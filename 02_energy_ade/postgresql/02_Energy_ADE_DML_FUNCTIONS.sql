-- 3D City Database extension for the Energy ADE v. 0.8
--
--                     August 2017
--
-- 3D City Database: http://www.3dcitydb.org/
-- Energy ADE: https://github.com/cstb/citygml-energy
--
--                        Copyright 2017
-- Austrian Institute of Technology G.m.b.H., Austria
-- Center for Energy - Smart Cities and Regions Research Field
-- http://www.ait.ac.at/en/research-fields/smart-cities-and-regions/
--
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
--     http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.
--
-- ***********************************************************************
-- **************** 02_Energy_ADE_DME_FUNCTIONS.sql *******************
--
-- This script adds the stored procedures for delete and insert
-- operations to the citydb_pkg schema.
-- They are all prefixed with "nrg8_".
--
-- ***********************************************************************
-- ***********************************************************************

----------------------------------------------------------------
-- Function DELETE_TIME_SERIES
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_pkg.nrg8_delete_time_series(integer,varchar);
CREATE OR REPLACE FUNCTION citydb_pkg.nrg8_delete_time_series(
	ts_id integer,
	schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS $$
DECLARE
	deleted_id integer;
BEGIN
-- Note: deleting of entries in dependent table timeseries_file carried out automatically via ON DELETE CASCADE
-- Note: setting null in all referencing tables carried out automatically via ON DELETE SET NULL
EXECUTE format('DELETE FROM %I.nrg8_time_series WHERE id = %L RETURNING id', schema_name, ts_id) INTO deleted_id;
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.nrg8_delete_time_series (id: %): %', ts_id, SQLERRM;
END;
$$
LANGUAGE plpgsql;
-- ALTER FUNCTION citydb_pkg.nrg8_delete_time_series(integer,varchar) OWNER TO postgres;

----------------------------------------------------------------
-- Function DELETE_TIMESERIES_FILE
----------------------------------------------------------------
-- Not necessary because deleted upon ON DELETE CASCADE on table nrg8_time_series.

----------------------------------------------------------------
-- Function DELETE_DAILY_SCHEDULE
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_pkg.nrg8_delete_daily_schedule(integer,varchar);
CREATE OR REPLACE FUNCTION citydb_pkg.nrg8_delete_daily_schedule(
	ds_id integer,
	schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS $$
DECLARE
	ts_id integer;
	deleted_id integer;
BEGIN
-- Get the id of the dependent time_series
EXECUTE format('SELECT time_series_id FROM %I.nrg8_daily_schedule WHERE id = %L', schema_name, ds_id) INTO ts_id;
-- Delete the dependent time_series
EXECUTE 'SELECT citydb_pkg.nrg8_delete_time_series($1, $2)' USING ts_id, schema_name;
-- Delete the daily_schedule itself
EXECUTE format('DELETE FROM %I.nrg8_daily_schedule WHERE id = %L RETURNING id', schema_name, ds_id) INTO deleted_id;
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.nrg8_delete_daily_schedule (id: %): %', ds_id, SQLERRM;
END;
$$
LANGUAGE plpgsql;
-- ALTER FUNCTION citydb_pkg.nrg8_delete_daily_schedule(integer,varchar) OWNER TO postgres;

----------------------------------------------------------------
-- Function DELETE_PERIOD_OF_YEAR
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_pkg.nrg8_delete_period_of_year(integer,varchar);
CREATE OR REPLACE FUNCTION citydb_pkg.nrg8_delete_period_of_year(
	p_id integer,
	schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS $$
DECLARE
	ds_id integer;
	deleted_id integer;
BEGIN
-- Iterate through all dependent daily_schedule records for this period_of_year
FOR ds_id IN EXECUTE format('SELECT id FROM %I.nrg8_daily_schedule WHERE period_of_year_id = %L', schema_name, p_id) LOOP
-- delete dependent daily_schedule
	EXECUTE 'SELECT citydb_pkg.nrg8_delete_daily_schedule($1, $2)' USING ds_id, schema_name;
END LOOP;
-- delete period_of_year itself
EXECUTE format('DELETE FROM %I.nrg8_period_of_year WHERE id = %L RETURNING id', schema_name, p_id) INTO deleted_id;

RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.nrg8_delete_period_of_year (id: %): %', p_id, SQLERRM;
END;
$$
LANGUAGE plpgsql;
-- ALTER FUNCTION citydb_pkg.nrg8_delete_period_of_year(integer,varchar) OWNER TO postgres;

----------------------------------------------------------------
-- Function DELETE_SCHEDULE
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_pkg.nrg8_delete_schedule(integer,varchar);
CREATE OR REPLACE FUNCTION citydb_pkg.nrg8_delete_schedule(
	sched_id integer,
	schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS $$
DECLARE
	class_id integer;
	classname varchar;
	ts_id integer;
	p_id integer;
	deleted_id integer;
BEGIN
-- Identify which kind of timeseries it is.
EXECUTE format('SELECT objectclass_id FROM %I.nrg8_schedule WHERE id=%L', schema_name, sched_id) INTO class_id;
EXECUTE format('SELECT citydb_pkg.get_classname(%L,%L)', class_id, schema_name) INTO classname;
--RAISE NOTICE 'classname %',classname;
CASE
	WHEN classname='ConstantValueSchedule'  OR classname='DualValueSchedule' THEN
	-- do nothing, exit the case
	WHEN classname='DailyPatternSchedule' THEN
		-- Iterate through all dependent period_of_year records for this daily_pattern_schedule
		FOR p_id IN EXECUTE format('SELECT id FROM %I.nrg8_period_of_year WHERE sched_id=%L ORDER BY id', schema_name, sched_id) LOOP
			IF p_id IS NOT NULL THEN
				-- delete dependent period_of_year records
				EXECUTE 'SELECT citydb_pkg.nrg8_delete_period_of_year($1, $2)' USING p_id, schema_name;
			END IF;
		END LOOP;
	WHEN classname='TimeSeriesSchedule' THEN
		EXECUTE format('SELECT time_series_id FROM %I.nrg8_schedule WHERE id = %L', schema_name, sched_id) INTO ts_id;
		IF ts_id IS NOT NULL THEN
			EXECUTE 'SELECT citydb_pkg.nrg8_delete_time_series($1, $2)' USING ts_id, schema_name;
		END IF;
	ELSE
			-- do nothing, exit the case
END CASE;
-- delete schedule itself
EXECUTE format('DELETE FROM %I.nrg8_schedule WHERE id = %L RETURNING id', schema_name, sched_id) INTO deleted_id;
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.nrg8_delete_schedule (id: %): %', sched_id, SQLERRM;
END;
$$
LANGUAGE plpgsql;
-- ALTER FUNCTION citydb_pkg.nrg8_delete_schedule(integer,varchar) OWNER TO postgres;


----------------------------------------------------------------
-- Function DELETE_MATERIAL
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_pkg.nrg8_delete_material(integer,varchar);
CREATE OR REPLACE FUNCTION citydb_pkg.nrg8_delete_material(
	m_id integer,
	schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS $$
DECLARE
	deleted_id integer;
BEGIN
-- simply delete material itself
EXECUTE format('DELETE FROM %I.nrg8_material WHERE id = %L RETURNING id', schema_name, m_id) INTO deleted_id;
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.nrg8_delete_material (id: %): %', m_id, SQLERRM;
END;
$$
LANGUAGE plpgsql;
-- ALTER FUNCTION citydb_pkg.nrg8_delete_material(integer,varchar) OWNER TO postgres;

----------------------------------------------------------------
-- Function DELETE_LAYER_COMPONENT
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_pkg.nrg8_delete_layer_component(integer,varchar);
CREATE OR REPLACE FUNCTION citydb_pkg.nrg8_delete_layer_component(
	lc_id integer,
	schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS $$
DECLARE
	deleted_id integer;
BEGIN
-- Note: deleting of entries in dependent table material carried out automatically via ON DELETE CASCADE
-- delete layer component itself
EXECUTE format('DELETE FROM %I.nrg8_layer_component WHERE id = %L RETURNING id', schema_name, lc_id) INTO deleted_id;
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.nrg8_delete_layer_component (id: %): %', lc_id, SQLERRM;
END;
$$
LANGUAGE plpgsql;
-- ALTER FUNCTION citydb_pkg.nrg8_delete_layer_component(integer,varchar) OWNER TO postgres;

----------------------------------------------------------------
-- Function DELETE_LAYER
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_pkg.nrg8_delete_layer(integer,varchar);
CREATE OR REPLACE FUNCTION citydb_pkg.nrg8_delete_layer(
	l_id integer,
	schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS $$
DECLARE
	deleted_id integer;
BEGIN
-- Note: deleting of entries in dependent table layer_component carried out automatically via ON DELETE CASCADE
-- delete layer itself
EXECUTE format('DELETE FROM %I.nrg8_layer WHERE id = %L RETURNING id', schema_name, l_id) INTO deleted_id;
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.nrg8_delete_layer (id: %): %', l_id, SQLERRM;
END;
$$
LANGUAGE plpgsql;
-- ALTER FUNCTION citydb_pkg.nrg8_delete_layer(integer,varchar) OWNER TO postgres;

----------------------------------------------------------------
-- Function DELETE_CONSTRUCTION
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_pkg.nrg8_delete_construction(integer,varchar);
CREATE OR REPLACE FUNCTION citydb_pkg.nrg8_delete_construction(
	c_id integer,
	schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS $$
DECLARE
	deleted_id integer;
BEGIN
-- if it is a ReverseConstruction, it is deleted directly.
-- if it is a BaseConstruction, is is deleted and the associated ReverseConstruction is deleted ON CASCADE.
-- All references in table cityobject_to_constr are deleted ON CASCADE
EXECUTE format('DELETE FROM %I.nrg8_construction WHERE id = %L RETURNING id', schema_name, c_id) INTO deleted_id;
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.nrg8_delete_construction (id: %): %', c_id, SQLERRM;
END;
$$
LANGUAGE plpgsql;
-- ALTER FUNCTION citydb_pkg.nrg8_delete_construction(integer,varchar) OWNER TO postgres;

----------------------------------------------------------------
-- Function HAS_NO_REVERSE_CONSTRUCTION
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_pkg.nrg8_has_no_reverse_construction(integer, varchar);
CREATE OR REPLACE FUNCTION citydb_pkg.nrg8_has_no_reverse_construction(
    c_id integer,
    schema_name character varying DEFAULT 'citydb'::character varying)
  RETURNS boolean AS
$BODY$
DECLARE
  dummy INTEGER;
  has_no_reverse_construction BOOLEAN := FALSE;
BEGIN
-- check whether the construction has a reverse construction
EXECUTE format('SELECT 1 FROM %I.nrg8_construction WHERE base_constr_id = %L', schema_name, c_id) INTO dummy;
IF dummy IS NULL THEN
	has_no_reverse_construction := TRUE;
END IF;
RETURN has_no_reverse_construction;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.nrg8_has_no_reverse_construction(id: %): %', c_id, SQLERRM;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE COST 100;
--ALTER FUNCTION citydb_pkg.nrg8_has_no_reverse_construction(integer, character varying) OWNER TO postgres;

----------------------------------------------------------------
-- Function DELETE_OPTICAL_PROPERTY
----------------------------------------------------------------
-- Actually, this is carried out automatically via ON DELETE CASCADE on table
-- "construction"
DROP FUNCTION IF EXISTS citydb_pkg.nrg8_delete_optical_property(integer,varchar);
CREATE OR REPLACE FUNCTION citydb_pkg.nrg8_delete_optical_property(
 	op_id integer,
 	schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS $$
DECLARE
	deleted_id integer;
BEGIN
EXECUTE format('DELETE FROM %I.nrg8_optical_property WHERE id=%L RETURNING id',schema_name, op_id) INTO deleted_id;
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.nrg8_delete_optical_property (id: %): %', op_id, SQLERRM;
END;
$$
LANGUAGE plpgsql;
-- ALTER FUNCTION citydb_pkg.nrg8_delete_optical_property(integer,varchar) OWNER TO postgres;


----------------------------------------------------------------
-- Function DELETE_DIMENSIONAL_ATTRIB
----------------------------------------------------------------
-- Actually, this is carried out automatically via ON DELETE CASCADE on table
-- "cityobject"
DROP FUNCTION IF EXISTS citydb_pkg.nrg8_delete_dimensional_attrib(integer,varchar);
CREATE OR REPLACE FUNCTION citydb_pkg.nrg8_delete_dimensional_attrib(
 	d_id integer,
 	schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS $$
DECLARE
	deleted_id integer;
BEGIN
EXECUTE format('DELETE FROM %I.nrg8_dimensional_attrib WHERE id=%L RETURNING id',schema_name, d_id) INTO deleted_id;
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.nrg8_delete_dimensional_attrib (id: %): %', d_id, SQLERRM;
END;
$$
LANGUAGE plpgsql;
-- ALTER FUNCTION citydb_pkg.nrg8_delete_dimensional_attrib(integer,varchar) OWNER TO postgres;

----------------------------------------------------------------
-- Function DELETE_PERF_CERTIFICATION
----------------------------------------------------------------
-- Actually, this is carried out automatically via ON DELETE CASCADE
DROP FUNCTION IF EXISTS citydb_pkg.nrg8_delete_perf_certification(integer,varchar);
CREATE OR REPLACE FUNCTION citydb_pkg.nrg8_delete_perf_certification(
 	d_id integer,
 	schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS $$
DECLARE
	deleted_id integer;
BEGIN
EXECUTE format('DELETE FROM %I.nrg8_perf_certification WHERE id=%L RETURNING id',schema_name, d_id) INTO deleted_id;
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.nrg8_delete_perf_certification (id: %): %', d_id, SQLERRM;
END;
$$
LANGUAGE plpgsql;
-- ALTER FUNCTION citydb_pkg.nrg8_delete_perf_certification(integer,varchar) OWNER TO postgres;

----------------------------------------------------------------
-- Function DELETE_REFURBISHMENT_MEASURE
----------------------------------------------------------------
-- Actually, this is carried out automatically via ON DELETE CASCADE
DROP FUNCTION IF EXISTS citydb_pkg.nrg8_delete_refurbishment_measure(integer,varchar);
CREATE OR REPLACE FUNCTION citydb_pkg.nrg8_delete_refurbishment_measure(
 	d_id integer,
 	schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS $$
DECLARE
	deleted_id integer;
BEGIN
EXECUTE format('DELETE FROM %I.nrg8_refurbishment_measure WHERE id=%L RETURNING id',schema_name, d_id) INTO deleted_id;
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.nrg8_delete_refurbishment_measure (id: %): %', d_id, SQLERRM;
END;
$$
LANGUAGE plpgsql;
-- ALTER FUNCTION citydb_pkg.nrg8_delete_refurbishment_measure(integer,varchar) OWNER TO postgres;

----------------------------------------------------------------
-- Function DELETE_WEATHER_DATA
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_pkg.nrg8_delete_weather_data(integer,varchar);
CREATE OR REPLACE FUNCTION citydb_pkg.nrg8_delete_weather_data(
 	wd_id integer,
 	schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS $$
DECLARE
	deleted_id integer;
BEGIN
EXECUTE format('DELETE FROM %I.nrg8_weather_data WHERE id=%L RETURNING id',schema_name, wd_id) INTO deleted_id;
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.nrg8_delete_weather_data (id: %): %', wd_id, SQLERRM;
END;
$$
LANGUAGE plpgsql;
-- ALTER FUNCTION citydb_pkg.nrg8_delete_weather_data(integer,varchar) OWNER TO postgres;

----------------------------------------------------------------
-- Function DELETE_WEATHER_STATION
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_pkg.nrg8_delete_weather_station(integer,varchar);
CREATE OR REPLACE FUNCTION citydb_pkg.nrg8_delete_weather_station(
	ws_id integer,
	schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS $$
DECLARE
	wd_id integer;
	deleted_id integer;
BEGIN
-- delete all depending weather_data objects
FOR wd_id IN EXECUTE format('SELECT id FROM %I.nrg8_weather_data WHERE cityobject_id = %L', schema_name, ws_id) LOOP
	IF wd_id IS NOT NULL THEN
		-- delete dependent weather data
		EXECUTE 'SELECT citydb_pkg.nrg8_delete_weather_data($1, $2)' USING wd_id, schema_name;
	END IF;
END LOOP;

-- delete the weather_station itself from table weather_station
EXECUTE format('DELETE FROM %I.nrg8_weather_station WHERE id = %L RETURNING id', schema_name, ws_id) INTO deleted_id;
-- conduct general cleaning of cityobject and delete the CityObject itself from table CityObject
EXECUTE 'SELECT citydb_pkg.intern_delete_cityobject($1, $2)' USING ws_id, schema_name;
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.nrg8_delete_weather_station (id: %): %', ws_id, SQLERRM;
END;
$$
LANGUAGE plpgsql;
-- ALTER FUNCTION citydb_pkg.nrg8_delete_thermal_station(integer,varchar) OWNER TO postgres;

----------------------------------------------------------------
-- Function DELETE_NRG_BUILDING
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_pkg.nrg8_delete_building(integer,varchar);
-- Placeholder, look at trigger function!
--
CREATE OR REPLACE FUNCTION citydb_pkg.nrg8_delete_building(
 	b_id integer,
 	schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS $$
DECLARE
	deleted_id integer;
BEGIN
EXECUTE format('DELETE FROM %I.nrg8_building WHERE id=%L RETURNING id',schema_name,b_id) INTO deleted_id;
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.nrg8_delete_building (id: %): %', b_id, SQLERRM;
END;
$$
LANGUAGE plpgsql;
-- -- ALTER FUNCTION citydb_pkg.nrg8_delete_building(integer,varchar) OWNER TO postgres;

----------------------------------------------------------------
-- Function DELETE_THERMAL_OPENING
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_pkg.nrg8_delete_thermal_opening(integer,varchar);
CREATE OR REPLACE FUNCTION citydb_pkg.nrg8_delete_thermal_opening(
	to_id integer,
	schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS $$
DECLARE
	co_id integer;
	ms_id integer;
	deleted_id integer;
BEGIN

-- delete associated construction in cityobject_to_constr table.
-- should be taken care automatically by ON DELETE CASCADE
-- delete the link to the _opening (nrg8_therm_open_to_open) - THIS IS DONE AUTOMATICALLY BY ON DELETE CASCADE


--EXECUTE format('DELETE constr_id FROM %I.nrg8_cityobject_to_constr WHERE id = %L RETURNING constr_id', schema_name, to_id) INTO co_id;
-- delete the construction, if it exists
--IF co_id IS NOT NULL THEN
--	EXECUTE format('SELECT citydb_pkg.nrg8_intern_delete_construction(%L, %L)', co_id, schema_name);
--END IF;

-- get the multi_surf_id to the surface_geometry table
EXECUTE format('SELECT multi_surf_id FROM %I.nrg8_thermal_opening WHERE id = %L', schema_name, to_id) INTO ms_id;
-- delete the geometry, if it exists
IF ms_id IS NOT NULL THEN
	EXECUTE 'SELECT citydb_pkg.delete_surface_geometry($1, 0, $2)' USING ms_id, schema_name;
END IF;

-- delete the thermal opening itself
EXECUTE format('DELETE FROM %I.nrg8_thermal_opening WHERE id = %L RETURNING id', schema_name, to_id) INTO deleted_id;
-- conduct general cleaning of cityobject
EXECUTE 'SELECT citydb_pkg.intern_delete_cityobject($1, $2)' USING to_id, schema_name;
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.nrg8_delete_thermal_opening (id: %): %', to_id, SQLERRM;
END;
$$
LANGUAGE plpgsql;
-- ALTER FUNCTION citydb_pkg.nrg8_delete_thermal_opening(integer,varchar) OWNER TO postgres;

----------------------------------------------------------------
-- Function DELETE_THERMAL_BOUNDARY
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_pkg.nrg8_delete_thermal_boundary(integer,varchar);
CREATE OR REPLACE FUNCTION citydb_pkg.nrg8_delete_thermal_boundary(
	tb_id integer,
	schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS $$
DECLARE
	--co_id integer;
	to_id integer;
	ms_id integer;
	deleted_id integer;
BEGIN

-- delete associated construction in cityobject_to_constr table.
-- should be taken care automatically by ON DELETE CASCADE
-- delete the link to the _boundarySurface (nrg8_therm_bdry_to_them_surf) - THIS IS DONE AUTOMATICALLY BY ON DELETE CASCADE

--EXECUTE format('DELETE constr_id FROM %I.nrg8_cityobject_to_constr WHERE id = %L RETURNING constr_id', schema_name, tb_id) INTO co_id;
-- delete the construction, if it exists
--IF co_id IS NOT NULL THEN
--	EXECUTE format('SELECT citydb_pkg.nrg8_intern_delete_construction(%L, %L)', co_id, schema_name);
--END IF;

-- get the thermal opening ids referencing the thermal boundary
FOR to_id IN EXECUTE format('SELECT id FROM %I.nrg8_thermal_opening WHERE therm_boundary_id = %L', schema_name, tb_id) LOOP
	IF to_id IS NOT NULL THEN
		-- delete thermal opening
		EXECUTE 'SELECT citydb_pkg.nrg8_delete_thermal_opening($1, $2)' USING to_id, schema_name;
	END IF;
END LOOP;

-- get the reference id to the surface_geometry table
EXECUTE format('SELECT multi_surf_id FROM %I.nrg8_thermal_boundary WHERE id = %L', schema_name, tb_id) INTO ms_id;
IF ms_id IS NOT NULL THEN
	-- delete the geometry, if it exists
	EXECUTE 'SELECT citydb_pkg.delete_surface_geometry($1, 0, $2)' USING ms_id, schema_name;
END IF;

-- delete the thermal boundary itself
EXECUTE format('DELETE FROM %I.nrg8_thermal_boundary WHERE id = %L RETURNING id', schema_name, tb_id) INTO deleted_id;
-- conduct general cleanin of cityobject
EXECUTE 'SELECT citydb_pkg.intern_delete_cityobject($1, $2)' USING tb_id, schema_name;
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.nrg8_delete_thermal_boundary (id: %): %', tb_id, SQLERRM;
END;
$$
LANGUAGE plpgsql;
-- ALTER FUNCTION citydb_pkg.nrg8_delete_thermal_boundary(integer,varchar) OWNER TO postgres;

----------------------------------------------------------------
-- Function DELETE_THERMAL_ZONE
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_pkg.nrg8_delete_thermal_zone(integer,varchar);
CREATE OR REPLACE FUNCTION citydb_pkg.nrg8_delete_thermal_zone(
	tz_id integer,
	schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS $$
DECLARE
	tb_rs RECORD;
	uz_id integer;
	so_id integer;
	deleted_id integer;
BEGIN

-- delete of depending data in ancillary tables (DIMENSIONAL DATA) carried out on DELETE CASCADE
-- delete the link to room (nrg8_thermal_zone_to_room) - THIS IS DONE AUTOMATICALLY BY ON DELETE CASCADE

-- get the thermal boundary ids referencing the current thermal zone (attention: a thermal boundary can be shared by 2 thermal zone)
FOR tb_rs IN EXECUTE format('SELECT id, therm_zone1_id, therm_zone2_id FROM %I.nrg8_thermal_boundary WHERE therm_zone1_id = %L OR therm_zone2_id = %L', schema_name, tz_id, tz_id) LOOP
	-- check if current thermal boundary is delimited by 2 parents
	IF tb_rs.therm_zone1_id IS NOT NULL AND tb_rs.therm_zone2_id IS NOT NULL THEN -- it is a shared wall
		-- DO NOT DELETE thermal boundary, set either therm_zone1_id or therm_zone2_id to null
		IF tb_rs.therm_zone1_id = tz_id THEN
			-- set therm_zone1_id to NULL
			EXECUTE format('UPDATE %I.nrg8_thermal_boundary SET therm_zone1_id = NULL WHERE id = %L', schema_name, tb_rs.id);
		ELSE
			-- set therm_zone2_id to NULL
			EXECUTE format('UPDATE %I.nrg8_thermal_boundary SET therm_zone2_id = NULL WHERE id = %L', schema_name, tb_rs.id);
		END IF;
	ELSE -- it is not shared
		-- current thermal boundary is safe to be deleted
		EXECUTE 'SELECT citydb_pkg.nrg8_delete_thermal_boundary($1, $2)' USING tb_rs.id, schema_name;
	END IF;
END LOOP;

-- get the usage_zone ids referencing the current thermal zone
FOR uz_id IN EXECUTE format('SELECT id FROM %I.nrg8_usage_zone WHERE therm_zone_id = %L', schema_name, tz_id) LOOP
	IF uz_id IS NOT NULL THEN
		-- delete thedependent thermal zone
		EXECUTE 'SELECT citydb_pkg.nrg8_delete_usage_zone($1, $2)' USING uz_id, schema_name;
	END IF;
END LOOP;

-- get the reference id to the surface_geometry table
EXECUTE format('SELECT solid_id FROM %I.nrg8_thermal_zone WHERE id = %L', schema_name, tz_id) INTO so_id;
IF so_id IS NOT NULL THEN
	-- delete the geometry, if it exists
	EXECUTE 'SELECT citydb_pkg.delete_surface_geometry($1, 0, $2)' USING so_id, schema_name;
END IF;

-- delete the thermal zone itself
EXECUTE format('DELETE FROM %I.nrg8_thermal_zone WHERE id = %L RETURNING id', schema_name, tz_id) INTO deleted_id;
-- conduct general cleaning of cityobject
EXECUTE 'SELECT citydb_pkg.intern_delete_cityobject($1, $2)' USING tz_id, schema_name;
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.nrg8_delete_thermal_zone (id: %): %', tz_id, SQLERRM;
END;
$$
LANGUAGE plpgsql;
-- ALTER FUNCTION citydb_pkg.nrg8_delete_thermal_zone(integer,varchar) OWNER TO postgres;

----------------------------------------------------------------
-- Function DELETE_FACILITIES
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_pkg.nrg8_delete_facilities(integer,varchar);
CREATE OR REPLACE FUNCTION citydb_pkg.nrg8_delete_facilities(
	fa_id integer,
	schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS $$
DECLARE
	sc_id integer;
	deleted_id integer;
BEGIN
-- get the schedule id
EXECUTE format('SELECT oper_sched_id FROM %I.nrg8_facilities WHERE id = %L', schema_name, fa_id) INTO sc_id;
-- delete the schedule
IF sc_id IS NOT NULL THEN
	EXECUTE 'SELECT citydb_pkg.nrg8_delete_schedule($1, $2)' USING sc_id, schema_name;
END IF;

-- delete the facilities itself
EXECUTE format('DELETE FROM %I.nrg8_facilities WHERE id = %L RETURNING id', schema_name, fa_id) INTO deleted_id;
-- conduct general cleaning of cityobject
EXECUTE 'SELECT citydb_pkg.intern_delete_cityobject($1, $2)' USING fa_id, schema_name;
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.nrg8_delete_facilities (id: %): %', fa_id, SQLERRM;
END;
$$
LANGUAGE plpgsql;
-- ALTER FUNCTION citydb_pkg.nrg8_delete_thermal_zone(integer,varchar) OWNER TO postgres;

----------------------------------------------------------------
-- Function DELETE_HOUSEHOLD
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_pkg.nrg8_delete_household(integer,varchar);
CREATE OR REPLACE FUNCTION citydb_pkg.nrg8_delete_household(
	ho_id integer,
	schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS $$
DECLARE
	sc_id integer;
	deleted_id integer;
BEGIN
-- delete the household itself
EXECUTE format('DELETE FROM %I.nrg8_household WHERE id = %L RETURNING id', schema_name, ho_id) INTO deleted_id;
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.nrg8_delete_household (id: %): %', ho_id, SQLERRM;
END;
$$
LANGUAGE plpgsql;
-- ALTER FUNCTION citydb_pkg.nrg8_delete_thermal_zone(integer,varchar) OWNER TO postgres;

----------------------------------------------------------------
-- Function DELETE_OCCUPANTS
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_pkg.nrg8_delete_occupants(integer,varchar);
CREATE OR REPLACE FUNCTION citydb_pkg.nrg8_delete_occupants(
	oc_id integer,
	schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS $$
DECLARE
	sc_id integer;
	ho_id integer;
	deleted_id integer;
BEGIN
-- get the schedule id
EXECUTE format('SELECT sched_id FROM %I.nrg8_occupants WHERE id = %L', schema_name, oc_id) INTO sc_id;
IF sc_id IS NOT NULL THEN
	-- delete the schedule
	EXECUTE 'SELECT citydb_pkg.nrg8_delete_schedule($1, $2)' USING sc_id, schema_name;
END IF;

-- get the household ids referencing the occupants
FOR ho_id IN EXECUTE format('SELECT id FROM %I.nrg8_household WHERE occupants_id = %L', schema_name, oc_id) LOOP
	IF ho_id IS NOT NULL THEN
		-- delete household
		EXECUTE 'SELECT citydb_pkg.nrg8_delete_household($1, $2)' USING ho_id, schema_name;
	END IF;
END LOOP;

-- delete the household itself
EXECUTE format('DELETE FROM %I.nrg8_occupants WHERE id = %L RETURNING id', schema_name, oc_id) INTO deleted_id;
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.nrg8_delete_occupants (id: %): %', oc_id, SQLERRM;
END;
$$
LANGUAGE plpgsql;

-- ALTER FUNCTION citydb_pkg.nrg8_delete_thermal_zone(integer,varchar) OWNER TO postgres;

----------------------------------------------------------------
-- Function DELETE_BUILDING_UNIT
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_pkg.nrg8_delete_building_unit(integer,varchar);
CREATE OR REPLACE FUNCTION citydb_pkg.nrg8_delete_building_unit(
	bu_id integer,
	schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS $$
DECLARE
	oc_id integer;
	fa_id integer;
	deleted_id integer;
BEGIN

-- get the occupants ids referencing the building unit
FOR oc_id IN EXECUTE format('SELECT id FROM %I.nrg8_occupants WHERE building_unit_id = %L', schema_name, bu_id) LOOP
	IF oc_id IS NOT NULL THEN
		-- delete occupants
		EXECUTE 'SELECT citydb_pkg.nrg8_delete_occupants($1, $2)' USING oc_id, schema_name;
	END IF;
END LOOP;

-- get the facilities ids referencing the building unit
FOR fa_id IN EXECUTE format('SELECT id FROM %I.nrg8_facilities WHERE building_unit_id = %L', schema_name, bu_id) LOOP
	IF fa_id IS NOT NULL THEN
		-- delete thermal opening
		EXECUTE 'SELECT citydb_pkg.nrg8_delete_facilities($1, $2)' USING fa_id, schema_name;
	END IF;
END LOOP;

-- delete the link to address (nrg8_bdg_unit_to_address) - THIS IS DONE AUTOMATICALLY BY ON DELETE CASCADE

-- delete the building unit itself
EXECUTE format('DELETE FROM %I.nrg8_building_unit WHERE id = %L RETURNING id', schema_name, bu_id) INTO deleted_id;
-- conduct general cleaning of cityobject
EXECUTE 'SELECT citydb_pkg.intern_delete_cityobject($1, $2)' USING bu_id, schema_name;
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.nrg8_delete_building_unit (id: %): %', bu_id, SQLERRM;
END;
$$
LANGUAGE plpgsql;
-- ALTER FUNCTION citydb_pkg.nrg8_delete_building_unit(integer,varchar) OWNER TO postgres;

----------------------------------------------------------------
-- Function DELETE_USAGE_ZONE
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_pkg.nrg8_delete_usage_zone(integer,varchar);
CREATE OR REPLACE FUNCTION citydb_pkg.nrg8_delete_usage_zone(
	uz_id integer,
	schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS $$
DECLARE
	hs_id integer;
	cs_id integer;
	vs_id integer;
	bu_id integer;
	fa_id integer;
	oc_id integer;
	so_id integer;
	deleted_id integer;
BEGIN

-- get the heating schedule id
EXECUTE format('SELECT heat_sched_id FROM %I.nrg8_usage_zone WHERE id = %L', schema_name, uz_id) INTO hs_id;
-- delete the heating schedule
IF hs_id IS NOT NULL THEN
	EXECUTE 'SELECT citydb_pkg.nrg8_delete_schedule($1, $2)' USING hs_id, schema_name;
END IF;

-- get the cooling schedule id
EXECUTE format('SELECT cool_sched_id FROM %I.nrg8_usage_zone WHERE id = %L', schema_name, uz_id) INTO cs_id;
-- delete the cooling schedule
IF cs_id IS NOT NULL THEN
	EXECUTE 'SELECT citydb_pkg.nrg8_delete_schedule($1, $2)' USING cs_id, schema_name;
END IF;

-- get the ventilation schedule id
EXECUTE format('SELECT vent_sched_id FROM %I.nrg8_usage_zone WHERE id = %L', schema_name, uz_id) INTO vs_id;
-- delete the ventilation schedule
IF cs_id IS NOT NULL THEN
	EXECUTE 'SELECT citydb_pkg.nrg8_delete_schedule($1, $2)' USING vs_id, schema_name;
END IF;

-- get the building unit ids referencing the usage zone
FOR bu_id IN EXECUTE format('SELECT id FROM %I.nrg8_building_unit WHERE usage_zone_id = %L', schema_name, uz_id) LOOP
	IF bu_id IS NOT NULL THEN
		-- delete building unit
		EXECUTE 'SELECT citydb_pkg.nrg8_delete_building_unit($1, $2)' USING bu_id, schema_name;
	END IF;
END LOOP;

-- get the facilities ids referencing the usage zone
FOR fa_id IN EXECUTE format('SELECT id FROM %I.nrg8_facilities WHERE usage_zone_id = %L', schema_name, uz_id) LOOP
	IF fa_id IS NOT NULL THEN
		-- delete facilities
		EXECUTE 'SELECT citydb_pkg.nrg8_delete_facilities($1, $2)' USING fa_id, schema_name;
	END IF;
END LOOP;

-- get occupants ids referencing the usage zone
FOR oc_id IN EXECUTE format('SELECT id FROM %I.nrg8_occupants WHERE usage_zone_id = %L', schema_name, uz_id) LOOP
	IF oc_id IS NOT NULL THEN
		-- delete occupants
		EXECUTE 'SELECT citydb_pkg.nrg8_delete_occupants($1, $2)' USING oc_id, schema_name;
	END IF;
END LOOP;

-- get the reference id to the surface_geometry table
EXECUTE format('SELECT solid_id FROM %I.nrg8_usage_zone WHERE id = %L', schema_name, uz_id) INTO so_id;
IF so_id IS NOT NULL THEN
	-- delete the geometry, if it exists
	EXECUTE 'SELECT citydb_pkg.delete_surface_geometry($1, 0, $2)' USING so_id, schema_name;
END IF;

-- delete the usage zone itself
EXECUTE format('DELETE FROM %I.nrg8_usage_zone WHERE id = %L RETURNING id', schema_name, uz_id) INTO deleted_id;
-- conduct general cleaning of cityobject
EXECUTE 'SELECT citydb_pkg.intern_delete_cityobject($1, $2)' USING uz_id, schema_name;
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.nrg8_delete_usage_zone (id: %): %', uz_id, SQLERRM;
END;
$$
LANGUAGE plpgsql;
-- ALTER FUNCTION citydb_pkg.nrg8_delete_thermal_zone(integer,varchar) OWNER TO postgres;

----------------------------------------------------------------
-- Function DELETE_STORAGE_SYSTEM
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_pkg.nrg8_delete_storage_system(integer,varchar);
CREATE OR REPLACE FUNCTION citydb_pkg.nrg8_delete_storage_system(
	ss_id integer,
	schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS $$
DECLARE
	ed_id integer;
	deleted_id integer;
BEGIN
-- Note: deleting of entries in nrg8_thermal_storage_system and nrg8_power_storage_system tables are carried out automatically via ON DELETE CASCADE

-- get the energy_demand id referenced by the storage system
EXECUTE format('SELECT nrg8_demand_id FROM %I.nrg8_storage_system WHERE id = %L', schema_name, ss_id) INTO ed_id;
IF ed_id IS NOT NULL THEN
	-- delete energy demand
	EXECUTE 'SELECT citydb_pkg.nrg8_delete_energy_demand($1, $2)' USING ed_id, schema_name;
END IF;

-- delete the storage system
EXECUTE format('DELETE FROM %I.nrg8_storage_system WHERE id = %L RETURNING id', schema_name, ss_id) INTO deleted_id;
-- conduct general cleaning of cityobject
EXECUTE 'SELECT citydb_pkg.intern_delete_cityobject($1, $2)' USING ss_id, schema_name;
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.nrg8_delete_storage_system (id: %): %', ss_id, SQLERRM;
END;
$$
LANGUAGE plpgsql;
-- ALTER FUNCTION citydb_pkg.nrg8_delete_storage_system(integer,varchar) OWNER TO postgres;

----------------------------------------------------------------
-- Function DELETE_EMITTER
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_pkg.nrg8_delete_emitter(integer,varchar);
CREATE OR REPLACE FUNCTION citydb_pkg.nrg8_delete_emitter(
	em_id integer,
	schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS $$
DECLARE
	deleted_id integer;
BEGIN

-- delete the emitter
EXECUTE format('DELETE FROM %I.nrg8_emitter WHERE id = %L RETURNING id', schema_name, em_id) INTO deleted_id;
-- conduct general cleaning of cityobject
EXECUTE 'SELECT citydb_pkg.intern_delete_cityobject($1, $2)' USING em_id, schema_name;
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.nrg8_delete_emitter (id: %): %', em_id, SQLERRM;
END;
$$
LANGUAGE plpgsql;
-- ALTER FUNCTION citydb_pkg.nrg8_delete_emitter(integer,varchar) OWNER TO postgres;

----------------------------------------------------------------
-- Function DELETE_DISTRIB_SYSTEM
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_pkg.nrg8_delete_distrib_system(integer,varchar);
CREATE OR REPLACE FUNCTION citydb_pkg.nrg8_delete_distrib_system(
	ds_id integer,
	schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS $$
DECLARE
	em_id integer;
	ed_id integer;
	deleted_id integer;
BEGIN
-- Note: deleting of entries in nrg8_thermal_distrib_system and nrg8_power_distrib_system tables are carried out automatically via ON DELETE CASCADE
-- get the energy_demand id referencing the distribution system
EXECUTE format('SELECT nrg8_demand_id FROM %I.nrg8_distrib_system WHERE id = %L', schema_name, ds_id) INTO ed_id;
IF ed_id IS NOT NULL THEN
	-- delete emitter
	EXECUTE 'SELECT citydb_pkg.nrg8_delete_energy_demand($1, $2)' USING ed_id, schema_name;
END IF;
-- get the emitter ids referencing the distribution system
FOR em_id IN EXECUTE format('SELECT id FROM %I.nrg8_emitter WHERE distr_system_id = %L', schema_name, ds_id) LOOP
	IF em_id IS NOT NULL THEN
		-- delete emitter
		EXECUTE 'SELECT citydb_pkg.nrg8_delete_emitter($1, $2)' USING em_id, schema_name;
	END IF;
END LOOP;
-- delete the distribution system itself
EXECUTE format('DELETE FROM %I.nrg8_distrib_system WHERE id = %L RETURNING id', schema_name, ds_id) INTO deleted_id;
-- conduct general cleaning of cityobject
EXECUTE 'SELECT citydb_pkg.intern_delete_cityobject($1, $2)' USING ds_id, schema_name;
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.nrg8_delete_distrib_system (id: %): %', ds_id, SQLERRM;
END;
$$
LANGUAGE plpgsql;
-- ALTER FUNCTION citydb_pkg.nrg8_delete_distrib_system(integer,varchar) OWNER TO postgres;

----------------------------------------------------------------
-- Function DELETE_SYSTEM_OPERATION
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_pkg.nrg8_delete_system_operation(integer,varchar);
CREATE OR REPLACE FUNCTION citydb_pkg.nrg8_delete_system_operation(
	so_id integer,
	schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS $$
DECLARE
	sc_id integer;
	deleted_id integer;
BEGIN
-- get the schedule id
EXECUTE format('SELECT sched_id FROM %I.nrg8_system_operation WHERE id = %L', schema_name, so_id) INTO sc_id;
IF sc_id IS NOT NULL THEN
	-- delete the schedule
	EXECUTE 'SELECT citydb_pkg.nrg8_delete_schedule($1, $2)' USING sc_id, schema_name;
END IF;
-- delete the system operation itself
EXECUTE format('DELETE FROM %I.nrg8_system_operation WHERE id = %L RETURNING id', schema_name, so_id) INTO deleted_id;
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.nrg8_delete_system_operation (id: %): %', so_id, SQLERRM;
END;
$$
LANGUAGE plpgsql;
-- ALTER FUNCTION citydb_pkg.nrg8_delete_system_operation(integer,varchar) OWNER TO postgres;

----------------------------------------------------------------
-- Function DELETE_FINAL_ENERGY
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_pkg.nrg8_delete_final_energy(integer,varchar);
CREATE OR REPLACE FUNCTION citydb_pkg.nrg8_delete_final_energy(
	fe_id integer,
	schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS $$
DECLARE
	ts_id integer;
	deleted_id integer;
BEGIN
-- entries in m:n table con_syste_to_final_energy are deleted on cascade
-- get the id of the referenced time_series
EXECUTE format('SELECT time_series_id FROM %I.nrg8_final_energy WHERE id = %L', schema_name, fe_id) INTO ts_id;
IF ts_id IS NOT NULL THEN
	-- delete the referenced time_series
	EXECUTE 'SELECT citydb_pkg.nrg8_delete_time_series($1, $2)' USING ts_id, schema_name;
END IF;
-- delete the final_energy itself
EXECUTE format('DELETE FROM %I.nrg8_final_energy WHERE id = %L RETURNING id', schema_name, fe_id) INTO deleted_id;
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.nrg8_delete_energy_final_energy (id: %): %', ed_id, SQLERRM;
END;
$$
 LANGUAGE plpgsql;
-- ALTER FUNCTION citydb_pkg.nrg8_delete_final_energy(integer,varchar) OWNER TO postgres;

----------------------------------------------------------------
-- Function DELETE_CONV_SYSTEM
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_pkg.nrg8_delete_conv_system(integer,varchar);
CREATE OR REPLACE FUNCTION citydb_pkg.nrg8_delete_conv_system(
	cs_id integer,
	schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS $$
DECLARE
	class_id integer;
	classname varchar;
	so_id integer;
	fe_id integer;
	surf_id integer;
	deleted_id integer;
BEGIN
EXECUTE format('SELECT objectclass_id FROM %I.cityobject WHERE id=%L', schema_name, cs_id) INTO class_id;
EXECUTE format('SELECT citydb_pkg.get_classname(%L,%L)', class_id, schema_name) INTO classname;
--RAISE NOTICE 'class id %, classname %', class_id, classname;
-- Only in the case of SolarSystems I have to take care of the geometries
IF classname IS NOT NULL THEN
	CASE
		WHEN classname = 'SolarThermalSystem' OR
		     classname = 'PhotovoltaicSystem' OR
		     classname = 'PhotovoltaicThermalSystem' THEN
			 -- get the id of the surface geometry
			EXECUTE format('SELECT multi_surf_id FROM %I.nrg8_solar_system WHERE id = %L', schema_name, cs_id) INTO surf_id;
			-- delete the geometry, if it exists
			IF surf_id IS NOT NULL THEN
				EXECUTE 'SELECT citydb_pkg.delete_surface_geometry($1, 0, $2)' USING surf_id, schema_name;
			END IF;
	ELSE
		-- do nothing, proceed as usual
	END CASE;
	-- and now proceed as usual
	-- Note: setting null in all referencing tables (cityobject via fk inst_in_ctyobj_id) carried out automatically via ON DELETE SET NULL
	-- Note: deleting all referencing tables carried out automatically via ON DELETE CASCADE
	-- Note: tables affected are:
	--    nrg8_solar_system
	--    nrg8_boiler
	--    nrg8_heat_pump
	--    nrg8_combined_heat_power
	--    nrg8_heat_exchanger
	--    nrg8_mechanical_ventilation
	--    nrg8_chiller
	--    nrg8_air_compressor
	-- get the system operation ids referencing the energy conversion system
	FOR so_id IN EXECUTE format('SELECT id FROM %I.nrg8_system_operation WHERE nrg_conv_system_id = %L', schema_name, cs_id) LOOP
		IF so_id IS NOT NULL THEN
			-- delete system operation
			EXECUTE 'SELECT citydb_pkg.nrg8_delete_system_operation($1, $2)' USING so_id, schema_name;
		END IF;
	END LOOP;
	-- The entries in the m.n table nrg8_conv_sys_to_energy_demand are deleted automatically ON DELETE CASCADE
	-- The entries in the m.n table nrg8_conv_sys_to_final_nrg are deleted automatically ON DELETE CASCADE
	-- ************************************************
	-- delete final energy and entries in nrg8_conv_sys_to_final_nrg
	--FOR fe_id IN EXECUTE format('SELECT final_nrg_id FROM %I.nrg8_conv_sys_to_final_nrg WHERE conv_system_id = %L', schema_name, cs_id) LOOP
	-- delete final energy
	--	EXECUTE 'SELECT citydb_pkg.nrg8_delete_final_energy($1, $2)' USING fe_id, schema_name;
	--END LOOP;
	--EXECUTE format('DELETE FROM %I.nrg8_conv_sys_to_final_nrg WHERE conv_system_id = %L RETURNING id', schema_name, cs_id);
	-- ************************************************
	-- delete the conversion system itself
	EXECUTE format('DELETE FROM %I.nrg8_conv_system WHERE id = %L RETURNING id', schema_name, cs_id) INTO deleted_id;
	-- conduct general cleaning of cityobject
	EXECUTE 'SELECT citydb_pkg.intern_delete_cityobject($1, $2)' USING cs_id, schema_name;
	RETURN deleted_id;
END IF;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.nrg8_delete_conv_system (id: %): %', cs_id, SQLERRM;
END;
$$
LANGUAGE plpgsql;
-- ALTER FUNCTION citydb_pkg.nrg8_delete_conv_system(integer,varchar) OWNER TO postgres;

----------------------------------------------------------------
-- Function DELETE_ENERGY_DEMAND
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_pkg.nrg8_delete_energy_demand(integer,varchar);
--Actually superfluous, as it is deleted either with delete, or on DELETE CASCADE
-- This is a mere "placeholder" for coherency with other functions.
CREATE OR REPLACE FUNCTION citydb_pkg.nrg8_delete_energy_demand(
	ed_id integer,
	schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS $$
DECLARE
	deleted_id integer;
BEGIN
EXECUTE format('DELETE FROM %I.nrg8_energy_demand WHERE id=%L RETURNING id',schema_name,ed_id) INTO deleted_id;
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.nrg8_delete_energy_demand (id: %): %', ed_id, SQLERRM;
END;
$$
LANGUAGE plpgsql;
-- ALTER FUNCTION citydb_pkg.nrg8_delete_energy_demand(integer,varchar) OWNER TO postgres;

----------------------------------------------------------------
-- Function GET_ENVELOPE_THERMAL_ZONE
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_pkg.nrg8_get_envelope_thermal_zone(integer, integer, varchar);
CREATE OR REPLACE FUNCTION citydb_pkg.nrg8_get_envelope_thermal_zone(
    co_id integer,
    set_envelope integer DEFAULT 0,
    schema_name varchar DEFAULT 'citydb'::varchar)
  RETURNS geometry AS
$BODY$
DECLARE
	envelope GEOMETRY;
BEGIN
-- get the geometries and aggregate them and extract the 3D envelope
EXECUTE format(
'WITH collect_geom AS (
	 SELECT geometry AS geom FROM %I.surface_geometry WHERE cityobject_id = %L AND geometry IS NOT NULL

---- FOR TESTING PURPOSES ONLY ---- BEGIN - it takes into account the geometry column in the thermal_zone table

		UNION ALL
	 SELECT multi_surf_geom AS geom FROM %I.nrg8_thermal_zone WHERE id = %L AND multi_surf_geom IS NOT NULL

---- FOR TESTING PURPOSES ONLY ---- END - it takes into account the geometry column in the thermal_zone table

	 )
  SELECT citydb_pkg.box2envelope(ST_3DExtent(geom)) AS envelope3d FROM collect_geom',
  schema_name, co_id, schema_name, co_id)
INTO envelope;

IF set_envelope <> 0 THEN
	IF envelope IS NOT NULL THEN
		EXECUTE format('UPDATE %I.cityobject SET envelope = %L WHERE id = %L', schema_name, envelope, co_id);
	END IF;
END IF;
RETURN envelope;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.nrg8_get_envelope_thermal_zone (id: %): %', co_id, SQLERRM;
END;
$BODY$
  LANGUAGE plpgsql;
--ALTER FUNCTION citydb_pkg.nrg8_get_envelope_thermal_zone(integer, integer, varchar) OWNER TO postgres;

----------------------------------------------------------------
-- Function GET_ENVELOPE_THERMAL_BOUNDARY
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_pkg.nrg8_get_envelope_thermal_boundary(integer, integer, varchar);
CREATE OR REPLACE FUNCTION citydb_pkg.nrg8_get_envelope_thermal_boundary(
	co_id integer,
	set_envelope integer DEFAULT 0,
	schema_name varchar DEFAULT 'citydb'::varchar
)
  RETURNS geometry AS
$BODY$
DECLARE
	envelope GEOMETRY;
BEGIN
-- get the geometries and aggregate them and extract the 3D envelope
EXECUTE format(
'WITH collect_geom AS (
	 SELECT geometry AS geom FROM %I.surface_geometry WHERE cityobject_id = %L AND geometry IS NOT NULL

---- FOR TESTING PURPOSES ONLY ---- BEGIN - it takes into account the geometry column in the thermal_boundary table

		UNION ALL
	 SELECT multi_surf_geom AS geom FROM %I.nrg8_thermal_boundary WHERE id = %L AND multi_surf_geom IS NOT NULL

---- FOR TESTING PURPOSES ONLY ---- END - it takes into account the geometry column in the thermal_boundary table

	 )
  SELECT citydb_pkg.box2envelope(ST_3DExtent(geom)) AS envelope3d FROM collect_geom',
  schema_name, co_id, schema_name, co_id)
INTO envelope;

IF set_envelope <> 0 THEN
	IF envelope IS NOT NULL THEN
		EXECUTE format('UPDATE %I.cityobject SET envelope = %L WHERE id = %L', schema_name, envelope, co_id);
	END IF;
END IF;
RETURN envelope;
EXCEPTION
WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.nrg8_get_envelope_thermal_boundary (id: %): %', co_id, SQLERRM;
END;
$BODY$
  LANGUAGE plpgsql;
--ALTER FUNCTION citydb_pkg.nrg8_get_envelope_thermal_boundary(integer, integer, varchar) OWNER TO postgres;

----------------------------------------------------------------
-- Function nrg8_GET_ENVELOPE_THERMAL_OPENING
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_pkg.nrg8_get_envelope_thermal_opening(integer, integer, varchar);
CREATE OR REPLACE FUNCTION citydb_pkg.nrg8_get_envelope_thermal_opening(
	co_id integer,
	set_envelope integer DEFAULT 0,
	schema_name varchar DEFAULT 'citydb'::varchar
)
  RETURNS geometry AS
$BODY$
DECLARE
	envelope GEOMETRY;
BEGIN
-- get the geometries and aggregate them and extract the 3D envelope
EXECUTE format(
'WITH collect_geom AS (
	 SELECT geometry AS geom FROM %I.surface_geometry WHERE cityobject_id = %L AND geometry IS NOT NULL

---- FOR TESTING PURPOSES ONLY ---- BEGIN - it takes into account the geometry column in the thermal_opening table

		UNION ALL
	 SELECT multi_surf_geom AS geom FROM %I.nrg8_thermal_opening WHERE id = %L AND multi_surf_geom IS NOT NULL

---- FOR TESTING PURPOSES ONLY ---- END - it takes into account the geometry column in the thermal_opening table

	 )
  SELECT citydb_pkg.box2envelope(ST_3DExtent(geom)) AS envelope3d FROM collect_geom',
  schema_name, co_id, schema_name, co_id)
INTO envelope;

IF set_envelope <> 0 THEN
	IF envelope IS NOT NULL THEN
		EXECUTE format('UPDATE %I.cityobject SET envelope = %L WHERE id = %L', schema_name, envelope, co_id);
	END IF;
END IF;
RETURN envelope;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.nrg8_get_envelope_thermal_opening (id: %): %', co_id, SQLERRM;
END;
$BODY$
  LANGUAGE plpgsql;
--ALTER FUNCTION citydb_pkg.nrg8_get_envelope_thermal_opening(integer, integer, varchar) OWNER TO postgres;

----------------------------------------------------------------
-- Function nrg8_GET_ENVELOPE_USAGE_ZONE
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_pkg.nrg8_get_envelope_usage_zone(integer, integer, varchar);
CREATE OR REPLACE FUNCTION citydb_pkg.nrg8_get_envelope_usage_zone(
	co_id integer,
	set_envelope integer DEFAULT 0,
	schema_name varchar DEFAULT 'citydb'::varchar)
RETURNS geometry AS
$BODY$
DECLARE
	envelope GEOMETRY;
BEGIN
-- get the geometries and aggregate them and extract the 3D envelope
EXECUTE format(
'WITH collect_geom AS (
	 SELECT geometry AS geom FROM %I.surface_geometry WHERE cityobject_id = %L AND geometry IS NOT NULL

---- FOR TESTING PURPOSES ONLY ---- BEGIN - it takes into account the geometry column in the usage_zone table

		UNION ALL
	 SELECT multi_surf_geom AS geom FROM %I.nrg8_usage_zone WHERE id = %L AND multi_surf_geom IS NOT NULL

---- FOR TESTING PURPOSES ONLY ---- END - it takes into account the geometry column in the usage_zone table

	 )
  SELECT citydb_pkg.box2envelope(ST_3DExtent(geom)) AS envelope3d FROM collect_geom',
  schema_name, co_id, schema_name, co_id)
INTO envelope;

IF set_envelope <> 0 THEN
	IF envelope IS NOT NULL THEN
		EXECUTE format('UPDATE %I.cityobject SET envelope = %L WHERE id = %L', schema_name, envelope, co_id);
	END IF;
END IF;
RETURN envelope;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.nrg8_get_envelope_usage_zone (id: %): %', co_id, SQLERRM;
END;
$BODY$
  LANGUAGE plpgsql;
--ALTER FUNCTION citydb_pkg.nrg8_get_envelope_thermal_usage_zone(integer, integer, varchar) OWNER TO postgres;

----------------------------------------------------------------
-- Function GET_ENVELOPE_CONV_SYSTEM
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_pkg.nrg8_get_envelope_conv_system(integer, integer, varchar);
CREATE OR REPLACE FUNCTION citydb_pkg.nrg8_get_envelope_conv_system(
	co_id integer,
	set_envelope integer DEFAULT 0,
	schema_name varchar DEFAULT 'citydb'::varchar)
  RETURNS geometry AS
$BODY$
DECLARE
	class_id integer;
	classname varchar;
	envelope GEOMETRY;
BEGIN
EXECUTE format('SELECT objectclass_id FROM %I.cityobject WHERE id=%L', schema_name, co_id) INTO class_id;
EXECUTE format('SELECT citydb_pkg.get_classname(%L,%L)', class_id, schema_name) INTO classname;

IF classname IS NOT NULL THEN
	CASE
		WHEN classname = 'SolarThermalSystem' OR
			 classname = 'PhotovoltaicSystem' OR
			 classname = 'PhotovoltaicThermalSystem' THEN

			-- get the geometries and aggregate them and extract the 3D envelope
			EXECUTE format(
			'WITH collect_geom AS (
				 SELECT geometry AS geom FROM %I.surface_geometry WHERE cityobject_id = %L AND geometry IS NOT NULL

		---- FOR TESTING PURPOSES ONLY ---- BEGIN - it takes into account the geometry column in the  table

					UNION ALL
				 SELECT multi_surf_geom AS geom FROM %I.nrg8_solar_system WHERE id = %L AND multi_surf_geom IS NOT NULL

		---- FOR TESTING PURPOSES ONLY ---- END - it takes into account the geometry column in the usage_zone table

				 )
			  SELECT citydb_pkg.box2envelope(ST_3DExtent(geom)) AS envelope3d FROM collect_geom',
			  schema_name, co_id, schema_name, co_id)
			INTO envelope;

		--- FOR FUTURE USE  --- BEGIN, in case other Energy Conversion Systems get a geometry
		--WHEN class_name = 'xxxxxxxxxxxxxxx' THEN
		--- FOR FUTURE USE  --- END, in case other Energy Conversion Systems get a geometry

	ELSE
		RAISE NOTICE 'Cannot get envelope of object with ID % class_name %.', co_id, classname;
	END CASE;
END IF;

IF set_envelope <> 0 THEN
	IF envelope IS NOT NULL THEN
		EXECUTE format('UPDATE %I.cityobject SET envelope = %L WHERE id = %L', schema_name, envelope, co_id);
	END IF;
END IF;

RETURN envelope;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.nrg8_get_envelope_energy_conv_system (id: %): %', co_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql;
--ALTER FUNCTION citydb_pkg.nrg8_get_envelope_energy_conv_system(integer, integer, varchar) OWNER TO postgres;

-- ***********************************************************************
-- ***********************************************************************

----------------------------------------------------------------
-- Function nrg8_INTERN_DELETE_CITYOBJECT
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_pkg.nrg8_intern_delete_cityobject(integer, varchar);
CREATE OR REPLACE FUNCTION citydb_pkg.nrg8_intern_delete_cityobject(
	co_id integer,
	schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS void AS
$BODY$
DECLARE
	constr_id integer;
	cs_id integer;
	ss_id integer;
	ds_id integer;
	ws_id integer;
	deleted_id INTEGER;
BEGIN
--// START PRE DELETE ADE CITYOBJECT //--
-- delete construction(s) not being referenced anymore by any cityobject in table construction
-- entries in table cityobject_to_constr are deleted upon ON DELETE CASCADE
FOR constr_id IN EXECUTE format('SELECT c.id FROM %I.nrg8_cityobject_to_constr coc, %I.nrg8_construction c WHERE
coc.constr_id = c.id AND coc.cityobject_id=%L
AND citydb_pkg.is_not_referenced(%L,%L, c.id, %L , coc.cityobject_id, %L)
AND citydb_pkg.nrg8_has_no_reverse_construction(c.id,%L)',
schema_name, schema_name,
co_id,
'nrg8_cityobject_to_constr','constr_id','cityobject_id',schema_name,
schema_name) LOOP
	IF constr_id IS NOT NULL THEN
		EXECUTE 'SELECT citydb_pkg.nrg8_delete_construction($1, $2)' USING constr_id, schema_name;
	END IF;
END LOOP;
-- delete all energy conversion systems related to this cityobject
FOR cs_id IN EXECUTE format('SELECT id FROM %I.nrg8_conv_system WHERE cityobject_id = %L', schema_name, co_id) LOOP
	IF cs_id IS NOT NULL THEN
		-- delete dependent conversion system
		EXECUTE 'SELECT citydb_pkg.nrg8_delete_conv_system($1, $2)' USING cs_id, schema_name;
	END IF;
END LOOP;
-- delete all energy storage systems related to this cityobject
FOR ss_id IN EXECUTE format('SELECT id FROM %I.nrg8_storage_system WHERE cityobject_id = %L', schema_name, co_id) LOOP
	IF ss_id IS NOT NULL THEN
		-- delete dependent storage system
		EXECUTE 'SELECT citydb_pkg.nrg8_delete_storage_system($1, $2)' USING ss_id, schema_name;
	END IF;
END LOOP;
-- delete all energy distribution systems related to this cityobject
FOR ds_id IN EXECUTE format('SELECT id FROM %I.nrg8_distrib_system WHERE cityobject_id = %L', schema_name, co_id) LOOP
	IF ds_id IS NOT NULL THEN
		-- delete dependent distribution system
		EXECUTE 'SELECT citydb_pkg.nrg8_delete_distrib_system($1, $2)' USING ds_id, schema_name;
	END IF;
END LOOP;
-- delete all weather stations related to this cityobject
FOR ws_id IN EXECUTE format('SELECT id FROM %I.nrg8_weather_station WHERE cityobject_id = %L', schema_name, co_id) LOOP
	IF ws_id IS NOT NULL THEN
		-- delete dependent weather station
		EXECUTE 'SELECT citydb_pkg.nrg8_delete_weather_station($1, $2)' USING ws_id, schema_name;
	END IF;
END LOOP;
--
-- other stuff
--
--// END PRE DELETE ENERGY ADE CITYOBJECT //--
-- NO NEED TO DELETE CITYOBJECT, it is taken care in the vanilla intern_delete_cityobject() function.
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.nrg8_intern_delete_cityobject (id: %): %', co_id, SQLERRM;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE COST 100;
--ALTER FUNCTION citydb_pkg.intern_delete_cityobject_orig(integer, varchar) OWNER TO postgres;

----------------------------------------------------------------
-- Function nrg8_DELETE_CITYOBJECT
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_pkg.nrg8_delete_cityobject(integer, integer, integer, varchar);
CREATE OR REPLACE FUNCTION citydb_pkg.nrg8_delete_cityobject(
	co_id integer,
	delete_members integer DEFAULT 0,
	cleanup integer DEFAULT 0,
	schema_name varchar DEFAULT 'citydb'::text)
  RETURNS integer AS
$BODY$
DECLARE
	class_id INTEGER;
	classname varchar;
	deleted_id INTEGER;
BEGIN
EXECUTE format('SELECT objectclass_id FROM %I.cityobject WHERE id=%L', schema_name, co_id) INTO class_id;
EXECUTE format('SELECT citydb_pkg.get_classname(%L,%L)', class_id, schema_name) INTO classname;
--RAISE NOTICE 'class id %, classname %',class_id, classname;
-- classname can be NULL if object has already been deleted
IF classname IS NOT NULL THEN
    CASE
	WHEN classname = 'WeatherStation'          THEN deleted_id := citydb_pkg.nrg8_delete_weather_station(co_id, schema_name);
	WHEN classname = 'ThermalZone'             THEN deleted_id := citydb_pkg.nrg8_delete_thermal_zone(co_id, schema_name);
	WHEN classname = 'ThermalBoundary'         THEN deleted_id := citydb_pkg.nrg8_delete_thermal_boundary(co_id, schema_name);
	WHEN classname = 'ThermalOpening'          THEN deleted_id := citydb_pkg.nrg8_delete_thermal_opening(co_id, schema_name);
	WHEN classname = 'UsageZone'               THEN deleted_id := citydb_pkg.nrg8_delete_usage_zone(co_id, schema_name);
	WHEN classname = 'BuildingUnit'            THEN deleted_id := citydb_pkg.nrg8_delete_building_unit(co_id, schema_name);
	WHEN classname = 'DHWFacilities' OR
	     classname = 'ElectricalAppliances' OR
	     classname = 'LightingFacilities'      THEN deleted_id := citydb_pkg.nrg8_delete_facilities(co_id, schema_name);
	WHEN classname = 'Emitter'                 THEN deleted_id := citydb_pkg.nrg8_delete_emitter(co_id, schema_name);
	WHEN classname = 'ThermalStorageSystem' OR
	     classname = 'PowerStorageSystem'      THEN deleted_id := citydb_pkg.nrg8_delete_storage_system(co_id, schema_name);
	WHEN classname = 'ThermalDistributionSystem' OR
	     classname = 'PowerDistributionSystem' THEN deleted_id := citydb_pkg.nrg8_delete_distrib_system(co_id, schema_name);
	WHEN classname = 'EnergyConversionSystem' OR
	     classname = 'SolarThermalSystem' OR
	     classname = 'PhotovoltaicSystem' OR
	     classname = 'PhotovoltaicThermalSystem' OR
	     classname = 'Boiler' OR
	     classname = 'ElectricalResistance' OR
	     classname = 'HeatPump' OR
	     classname = 'CombinedHeatPower' OR
	     classname = 'HeatExchanger' OR
	     classname = 'MechanicalVentilation' OR
	     classname = 'Chiller' OR
	     classname = 'AirCompressor'           THEN deleted_id := citydb_pkg.nrg8_delete_conv_system(co_id, schema_name);
	ELSE
        RAISE NOTICE 'Cannot delete chosen object with ID % and classname %.', co_id, classname;
    END CASE;
END IF;
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.nrg8_delete_cityobject (id: %): %', co_id, SQLERRM;
END;
$BODY$
  LANGUAGE plpgsql;
--ALTER FUNCTION citydb_pkg.nrg8_delete_cityobject(integer, integer, integer, text) OWNER TO postgres;

----------------------------------------------------------------
-- Function nrg8_GET_ENEVELOPE_CITYOBJECT
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_pkg.nrg8_get_envelope_cityobject(integer, integer, integer, varchar);
CREATE OR REPLACE FUNCTION citydb_pkg.nrg8_get_envelope_cityobject(
	co_id integer,
	objclass_id integer DEFAULT 0,  -- not used anymore, but kept for compatibility
	set_envelope integer DEFAULT 0,
	schema_name varchar DEFAULT 'citydb'::varchar)
  RETURNS geometry AS
$BODY$
DECLARE
	class_id INTEGER;
	classname varchar;
	envelope GEOMETRY;
BEGIN
EXECUTE format('SELECT objectclass_id FROM %I.cityobject WHERE id=%L', schema_name, co_id) INTO class_id;
EXECUTE format('SELECT citydb_pkg.get_classname(%L,%L)', class_id, schema_name) INTO classname;
-- class_name can be NULL if object has already been deleted
IF classname IS NOT NULL THEN
	CASE
		WHEN classname = 'ThermalZone'             THEN envelope := citydb_pkg.nrg8_get_envelope_thermal_zone(co_id, set_envelope, schema_name);
		WHEN classname = 'ThermalBoundary'         THEN envelope := citydb_pkg.nrg8_get_envelope_thermal_boundary(co_id, set_envelope, schema_name);
		WHEN classname = 'ThermalOpening'          THEN envelope := citydb_pkg.nrg8_get_envelope_thermal_opening(co_id, set_envelope, schema_name);
		WHEN classname = 'UsageZone'               THEN envelope := citydb_pkg.nrg8_get_envelope_usage_zone(co_id, set_envelope, schema_name);
		WHEN classname = 'SolarThermalSystem' OR
			 classname = 'PhotovoltaicSystem' OR
			 classname = 'PhotovoltaicThermalSystem' THEN envelope := citydb_pkg.nrg8_get_envelope_conv_system(co_id, set_envelope, schema_name);
	ELSE
		RAISE NOTICE 'Cannot get envelope of object with ID % class_name %.', co_id, classname;
	END CASE;
END IF;
RETURN envelope;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.nrg8_get_envelope_cityobject (id: %): %', co_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE COST 100;
--ALTER FUNCTION citydb_pkg.nrg8_get_envelope_cityobject(integer, integer, integer, varchar) OWNER TO postgres;

-- ***********************************************************************
-- ***********************************************************************

----------------------------------------------------------------
-- Function NRG8_INSERT_AIR_COMPRESSOR
----------------------------------------------------------------
-- DROP FUNCTION IF EXISTS citydb_pkg.nrg8_insert_air_compressor (integer, integer, character varying, numeric, character varying) CASCADE;
CREATE OR REPLACE FUNCTION citydb_pkg.nrg8_insert_air_compressor (
  objectclass_id       integer,
  id                   integer,
  compressor_type      character varying DEFAULT NULL,
  pressure             numeric DEFAULT NULL,
  pressure_unit        character varying DEFAULT NULL,
  schema_name          varchar DEFAULT 'citydb'::varchar
)
RETURNS integer
AS
$$
DECLARE
  p_id                 integer;
  p_objectclass_id     integer;
  p_compressor_type    character varying;
  p_pressure           numeric;
  p_pressure_unit      character varying;
--
  p_schema_name        varchar;
  inserted_id integer;
BEGIN
-- Pass values to internal prefixed variables to avoid potential homonymy issues
  p_id                 :=id;
  p_objectclass_id     :=objectclass_id;
  p_compressor_type    :=compressor_type;
  p_pressure           :=pressure;
  p_pressure_unit      :=pressure_unit;
  p_schema_name        :=schema_name;

EXECUTE format('
    INSERT INTO %I.nrg8_air_compressor (
     id,
     objectclass_id,
     compressor_type,
     pressure,
     pressure_unit
    ) VALUES (
    %L, %L, %L, %L, %L
    ) RETURNING id',
    p_schema_name,
    p_id,
    p_objectclass_id,
    p_compressor_type,
    p_pressure,
    p_pressure_unit
) INTO inserted_id;
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.nrg8_insert_air_compressor (id: %): %', p_id, SQLERRM;
END;
$$
LANGUAGE 'plpgsql';

----------------------------------------------------------------
-- Function NRG8_INSERT_TIME_SERIES
----------------------------------------------------------------
-- DROP FUNCTION IF EXISTS citydb_pkg.nrg8_insert_time_series (integer, integer, character varying, character varying, character varying, character varying, text, character varying, character varying, text, character varying, timestamptz[], numeric[], character varying, integer, timestamp with time zone, timestamp with time zone, numeric, character varying) CASCADE;
CREATE OR REPLACE FUNCTION citydb_pkg.nrg8_insert_time_series (
  objectclass_id       integer,
  id                   integer DEFAULT NULL,
  gmlid                character varying DEFAULT NULL,
  gmlid_codespace      character varying DEFAULT NULL,
  name                 character varying DEFAULT NULL,
  name_codespace       character varying DEFAULT NULL,
  description          text DEFAULT NULL,
  acquisition_method   character varying DEFAULT NULL,
  interpolation_type   character varying DEFAULT NULL,
  quality_description  text DEFAULT NULL,
  source               character varying DEFAULT NULL,
  time_array           timestamptz[] DEFAULT NULL,
  values_array         numeric[] DEFAULT NULL,
  values_unit          character varying DEFAULT NULL,
  array_length         integer DEFAULT NULL,
  temporal_extent_begin timestamp with time zone DEFAULT NULL,
  temporal_extent_end  timestamp with time zone DEFAULT NULL,
  time_interval        numeric DEFAULT NULL,
  time_interval_unit   character varying DEFAULT NULL,
  schema_name          varchar DEFAULT 'citydb'::varchar
)
RETURNS integer
AS
$$
DECLARE
  p_id                 integer;
  p_objectclass_id     integer;
  p_gmlid              character varying;
  p_gmlid_codespace    character varying;
  p_name               character varying;
  p_name_codespace     character varying;
  p_description        text;
  p_acquisition_method character varying;
  p_interpolation_type character varying;
  p_quality_description text;
  p_source             character varying;
  p_time_array         timestamptz[];
  p_values_array       numeric[];
  p_values_unit        character varying;
  p_array_length       integer;
  p_temporal_extent_begin timestamp with time zone;
  p_temporal_extent_end timestamp with time zone;
  p_time_interval      numeric;
  p_time_interval_unit character varying;
--
  p_schema_name        varchar;
  seq_name varchar;
  inserted_id integer;
BEGIN
-- Pass values to internal prefixed variables to avoid potential homonymy issues
  p_id                 :=id;
  p_objectclass_id     :=objectclass_id;
  p_gmlid              :=gmlid;
  p_gmlid_codespace    :=gmlid_codespace;
  p_name               :=name;
  p_name_codespace     :=name_codespace;
  p_description        :=description;
  p_acquisition_method :=acquisition_method;
  p_interpolation_type :=interpolation_type;
  p_quality_description :=quality_description;
  p_source             :=source;
  p_time_array         :=time_array;
  p_values_array       :=values_array;
  p_values_unit        :=values_unit;
  p_array_length       :=array_length;
  p_temporal_extent_begin :=temporal_extent_begin;
  p_temporal_extent_end :=temporal_extent_end;
  p_time_interval      :=time_interval;
  p_time_interval_unit :=time_interval_unit;
  p_schema_name        :=schema_name;
-- IF the ID is not given, then generate a new one.
IF p_id IS NULL THEN
  seq_name=schema_name||'.nrg8_time_series_id_seq';
  p_id=nextval(seq_name::regclass);
END IF;
-- IF the GmlID is not given, then generate a new one.
IF p_gmlid IS NULL THEN
  p_gmlid='UUID_'||uuid_generate_v4();
END IF;

EXECUTE format('
    INSERT INTO %I.nrg8_time_series (
     id,
     objectclass_id,
     gmlid,
     gmlid_codespace,
     name,
     name_codespace,
     description,
     acquisition_method,
     interpolation_type,
     quality_description,
     source,
     time_array,
     values_array,
     values_unit,
     array_length,
     temporal_extent_begin,
     temporal_extent_end,
     time_interval,
     time_interval_unit
    ) VALUES (
    %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L
    ) RETURNING id',
		p_schema_name,
    p_id,
    p_objectclass_id,
    p_gmlid,
    p_gmlid_codespace,
    p_name,
    p_name_codespace,
    p_description,
    p_acquisition_method,
    p_interpolation_type,
    p_quality_description,
    p_source,
    p_time_array,
    p_values_array,
    p_values_unit,
    p_array_length,
    p_temporal_extent_begin,
    p_temporal_extent_end,
    p_time_interval,
    p_time_interval_unit
) INTO inserted_id;
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.nrg8_insert_time_series (id: %): %', p_id, SQLERRM;
END;
$$
LANGUAGE 'plpgsql';

----------------------------------------------------------------
-- Function NRG8_INSERT_TIME_SERIES_FILE
----------------------------------------------------------------
-- DROP FUNCTION IF EXISTS citydb_pkg.nrg8_insert_time_series_file (integer, integer, character varying, character varying, character varying, integer, character varying, character varying, character varying, integer, integer, numeric) CASCADE;
CREATE OR REPLACE FUNCTION citydb_pkg.nrg8_insert_time_series_file (
  objectclass_id       integer,
  id                   integer,
  file_path            character varying DEFAULT NULL,
  file_name            character varying DEFAULT NULL,
  file_extension       character varying DEFAULT NULL,
  nbr_header_lines     integer DEFAULT NULL,
  field_sep            character varying DEFAULT NULL,
  record_sep           character varying DEFAULT NULL,
  dec_symbol           character varying DEFAULT NULL,
  time_col_nbr         integer DEFAULT NULL,
  value_col_nbr        integer DEFAULT NULL,
  is_compressed        numeric DEFAULT NULL,
  schema_name          varchar DEFAULT 'citydb'::varchar
)
RETURNS integer
AS
$$
DECLARE
  p_id                 integer;
  p_objectclass_id     integer;
  p_file_path          character varying;
  p_file_name          character varying;
  p_file_extension     character varying;
  p_nbr_header_lines   integer;
  p_field_sep          character varying;
  p_record_sep         character varying;
  p_dec_symbol         character varying;
  p_time_col_nbr       integer;
  p_value_col_nbr      integer;
  p_is_compressed      numeric;
--
  p_schema_name        varchar;
  inserted_id integer;
BEGIN
-- Pass values to internal prefixed variables to avoid potential homonymy issues
  p_id                 :=id;
  p_objectclass_id     :=objectclass_id;
  p_file_path          :=file_path;
  p_file_name          :=file_name;
  p_file_extension     :=file_extension;
  p_nbr_header_lines   :=nbr_header_lines;
  p_field_sep          :=field_sep;
  p_record_sep         :=record_sep;
  p_dec_symbol         :=dec_symbol;
  p_time_col_nbr       :=time_col_nbr;
  p_value_col_nbr      :=value_col_nbr;
  p_is_compressed      :=is_compressed;
  p_schema_name        :=schema_name;

EXECUTE format('
    INSERT INTO %I.nrg8_time_series_file (
     id,
     objectclass_id,
     file_path,
     file_name,
     file_extension,
     nbr_header_lines,
     field_sep,
     record_sep,
     dec_symbol,
     time_col_nbr,
     value_col_nbr,
     is_compressed
    ) VALUES (
    %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L
    ) RETURNING id',
    p_schema_name,
    p_id,
    p_objectclass_id,
    p_file_path,
    p_file_name,
    p_file_extension,
    p_nbr_header_lines,
    p_field_sep,
    p_record_sep,
    p_dec_symbol,
    p_time_col_nbr,
    p_value_col_nbr,
    p_is_compressed
) INTO inserted_id;
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.nrg8_insert_time_series_file (id: %): %', p_id, SQLERRM;
END;
$$
LANGUAGE 'plpgsql';

----------------------------------------------------------------
-- Function NRG8_INSERT_SCHEDULE
----------------------------------------------------------------
-- DROP FUNCTION IF EXISTS citydb_pkg.nrg8_insert_schedule (integer, integer, character varying, character varying, character varying, character varying, text, numeric, character varying, numeric, character varying, numeric, numeric, integer) CASCADE;
CREATE OR REPLACE FUNCTION citydb_pkg.nrg8_insert_schedule (
  objectclass_id       integer,
  id                   integer DEFAULT NULL,
  gmlid                character varying DEFAULT NULL,
  gmlid_codespace      character varying DEFAULT NULL,
  name                 character varying DEFAULT NULL,
  name_codespace       character varying DEFAULT NULL,
  description          text DEFAULT NULL,
  value1               numeric DEFAULT NULL,
  value1_unit          character varying DEFAULT NULL,
  value2               numeric DEFAULT NULL,
  value2_unit          character varying DEFAULT NULL,
  hours_per_day        numeric DEFAULT NULL,
  days_per_year        numeric DEFAULT NULL,
  time_series_id       integer DEFAULT NULL,
  schema_name          varchar DEFAULT 'citydb'::varchar
)
RETURNS integer
AS
$$
DECLARE
  p_id                 integer;
  p_objectclass_id     integer;
  p_gmlid              character varying;
  p_gmlid_codespace    character varying;
  p_name               character varying;
  p_name_codespace     character varying;
  p_description        text;
  p_value1             numeric;
  p_value1_unit        character varying;
  p_value2             numeric;
  p_value2_unit        character varying;
  p_hours_per_day      numeric;
  p_days_per_year      numeric;
  p_time_series_id     integer;
--
  p_schema_name        varchar;
  seq_name varchar;
  inserted_id integer;
BEGIN
-- Pass values to internal prefixed variables to avoid potential homonymy issues
  p_id                 :=id;
  p_objectclass_id     :=objectclass_id;
  p_gmlid              :=gmlid;
  p_gmlid_codespace    :=gmlid_codespace;
  p_name               :=name;
  p_name_codespace     :=name_codespace;
  p_description        :=description;
  p_value1             :=value1;
  p_value1_unit        :=value1_unit;
  p_value2             :=value2;
  p_value2_unit        :=value2_unit;
  p_hours_per_day      :=hours_per_day;
  p_days_per_year      :=days_per_year;
  p_time_series_id     :=time_series_id;
  p_schema_name        :=schema_name;
-- IF the ID is not given, then generate a new one.
IF p_id IS NULL THEN
  seq_name=schema_name||'.nrg8_schedule_id_seq';
  p_id=nextval(seq_name::regclass);
END IF;
-- IF the GmlID is not given, then generate a new one.
IF p_gmlid IS NULL THEN
  p_gmlid='UUID_'||uuid_generate_v4();
END IF;

EXECUTE format('
    INSERT INTO %I.nrg8_schedule (
     id,
     objectclass_id,
     gmlid,
     gmlid_codespace,
     name,
     name_codespace,
     description,
     value1,
     value1_unit,
     value2,
     value2_unit,
     hours_per_day,
     days_per_year,
     time_series_id
    ) VALUES (
    %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L
    ) RETURNING id',
    p_schema_name,
    p_id,
    p_objectclass_id,
    p_gmlid,
    p_gmlid_codespace,
    p_name,
    p_name_codespace,
    p_description,
    p_value1,
    p_value1_unit,
    p_value2,
    p_value2_unit,
    p_hours_per_day,
    p_days_per_year,
    p_time_series_id
) INTO inserted_id;
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.nrg8_insert_schedule (id: %): %', p_id, SQLERRM;
END;
$$
LANGUAGE 'plpgsql';

----------------------------------------------------------------
-- Function NRG8_INSERT_DAILY_SCHEDULE
----------------------------------------------------------------
-- DROP FUNCTION IF EXISTS citydb_pkg.nrg8_insert_daily_schedule (integer, character varying, integer, integer) CASCADE;
CREATE OR REPLACE FUNCTION citydb_pkg.nrg8_insert_daily_schedule (
  id                   integer DEFAULT NULL,
  day_type             character varying DEFAULT NULL,
  period_of_year_id    integer DEFAULT NULL,
  time_series_id       integer DEFAULT NULL,
  schema_name          varchar DEFAULT 'citydb'::varchar
)
RETURNS integer
AS
$$
DECLARE
  p_id                 integer;
  p_day_type           character varying;
  p_period_of_year_id  integer;
  p_time_series_id     integer;
--
  p_schema_name        varchar;
  seq_name varchar;
  inserted_id integer;
BEGIN
-- Pass values to internal prefixed variables to avoid potential homonymy issues
  p_id                 :=id;
  p_day_type           :=day_type;
  p_period_of_year_id  :=period_of_year_id;
  p_time_series_id     :=time_series_id;
  p_schema_name        :=schema_name;
-- IF the ID is not given, then generate a new one.
IF p_id IS NULL THEN
  seq_name=schema_name||'.nrg8_daily_schedule_id_seq';
  p_id=nextval(seq_name::regclass);
END IF;

EXECUTE format('
    INSERT INTO %I.nrg8_daily_schedule (
     id,
     day_type,
     period_of_year_id,
     time_series_id
    ) VALUES (
    %L, %L, %L, %L
    ) RETURNING id',
    p_schema_name,
    p_id,
    p_day_type,
    p_period_of_year_id,
    p_time_series_id
) INTO inserted_id;
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.nrg8_insert_daily_schedule (id: %): %', p_id, SQLERRM;
END;
$$
LANGUAGE 'plpgsql';

----------------------------------------------------------------
-- Function NRG8_INSERT_PERIOD_OF_YEAR
----------------------------------------------------------------
-- DROP FUNCTION IF EXISTS citydb_pkg.nrg8_insert_period_of_year (integer, time without time zone, integer, integer, time without time zone, integer, integer, numeric, integer) CASCADE;
CREATE OR REPLACE FUNCTION citydb_pkg.nrg8_insert_period_of_year (
  id                   integer DEFAULT NULL,
  begin_time           time without time zone DEFAULT NULL,
  begin_day            integer DEFAULT NULL,
  begin_month          integer DEFAULT NULL,
  end_time             time without time zone DEFAULT NULL,
  end_day              integer DEFAULT NULL,
  end_month            integer DEFAULT NULL,
  sched_id             integer DEFAULT NULL,
  schema_name          varchar DEFAULT 'citydb'::varchar
)
RETURNS integer
AS
$$
DECLARE
  p_id                 integer;
  p_begin_time         time without time zone;
  p_begin_day          integer;
  p_begin_month        integer;
  p_end_time           time without time zone;
  p_end_day            integer;
  p_end_month          integer;
  p_sched_id           integer;
--
  p_schema_name        varchar;
  seq_name varchar;
  inserted_id integer;
BEGIN
-- Pass values to internal prefixed variables to avoid potential homonymy issues
  p_id                 :=id;
  p_begin_time         :=begin_time;
  p_begin_day          :=begin_day;
  p_begin_month        :=begin_month;
  p_end_time           :=end_time;
  p_end_day            :=end_day;
  p_end_month          :=end_month;
  p_sched_id           :=sched_id;
  p_schema_name        :=schema_name;
-- IF the ID is not given, then generate a new one.
IF p_id IS NULL THEN
  seq_name=schema_name||'.nrg8_period_of_year_id_seq';
  p_id=nextval(seq_name::regclass);
END IF;

EXECUTE format('
    INSERT INTO %I.nrg8_period_of_year (
     id,
     begin_time,
     begin_day,
     begin_month,
     end_time,
     end_day,
     end_month,
     sched_id
    ) VALUES (
    %L, %L, %L, %L, %L, %L, %L, %L
    ) RETURNING id',
    p_schema_name,
    p_id,
    p_begin_time,
    p_begin_day,
    p_begin_month,
    p_end_time,
    p_end_day,
    p_end_month,
    p_sched_id
) INTO inserted_id;
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.nrg8_insert_period_of_year (id: %): %', p_id, SQLERRM;
END;
$$
LANGUAGE 'plpgsql';

----------------------------------------------------------------
-- Function NRG8_INSERT_CONSTRUCTION
----------------------------------------------------------------
-- DROP FUNCTION IF EXISTS citydb_pkg.nrg8_insert_construction (integer, integer, character varying, character varying, character varying, character varying, text, numeric, character varying, numeric, date, numeric, character varying, numeric, character varying, integer) CASCADE;
CREATE OR REPLACE FUNCTION citydb_pkg.nrg8_insert_construction (
  objectclass_id       integer,
  id                   integer DEFAULT NULL,
  gmlid                character varying DEFAULT NULL,
  gmlid_codespace      character varying DEFAULT NULL,
  name                 character varying DEFAULT NULL,
  name_codespace       character varying DEFAULT NULL,
  description          text DEFAULT NULL,
  u_value              numeric DEFAULT NULL,
  u_value_unit         character varying DEFAULT NULL,
  glazing_ratio        numeric DEFAULT NULL,
  start_of_life        date DEFAULT NULL,
  life_expect_value    numeric DEFAULT NULL,
  life_expect_value_unit character varying DEFAULT NULL,
  main_maint_interval  numeric DEFAULT NULL,
  main_maint_interval_unit character varying DEFAULT NULL,
  base_constr_id       integer DEFAULT NULL,
  schema_name          varchar DEFAULT 'citydb'::varchar
)
RETURNS integer
AS
$$
DECLARE
  p_id                 integer;
  p_objectclass_id     integer;
  p_gmlid              character varying;
  p_gmlid_codespace    character varying;
  p_name               character varying;
  p_name_codespace     character varying;
  p_description        text;
  p_u_value            numeric;
  p_u_value_unit       character varying;
  p_glazing_ratio      numeric;
  p_start_of_life      date;
  p_life_expect_value  numeric;
  p_life_expect_value_unit character varying;
  p_main_maint_interval numeric;
  p_main_maint_interval_unit character varying;
  p_base_constr_id     integer;
--
  p_schema_name        varchar;
  seq_name varchar;
  inserted_id integer;
BEGIN
-- Pass values to internal prefixed variables to avoid potential homonymy issues
  p_id                 :=id;
  p_objectclass_id     :=objectclass_id;
  p_gmlid              :=gmlid;
  p_gmlid_codespace    :=gmlid_codespace;
  p_name               :=name;
  p_name_codespace     :=name_codespace;
  p_description        :=description;
  p_u_value            :=u_value;
  p_u_value_unit       :=u_value_unit;
  p_glazing_ratio      :=glazing_ratio;
  p_start_of_life      :=start_of_life;
  p_life_expect_value  :=life_expect_value;
  p_life_expect_value_unit :=life_expect_value_unit;
  p_main_maint_interval :=main_maint_interval;
  p_main_maint_interval_unit :=main_maint_interval_unit;
  p_base_constr_id     :=base_constr_id;
  p_schema_name        :=schema_name;
-- IF the ID is not given, then generate a new one.
IF p_id IS NULL THEN
  seq_name=schema_name||'.nrg8_construction_id_seq';
  p_id=nextval(seq_name::regclass);
END IF;
-- IF the GmlID is not given, then generate a new one.
IF p_gmlid IS NULL THEN
  p_gmlid='UUID_'||uuid_generate_v4();
END IF;

EXECUTE format('
    INSERT INTO %I.nrg8_construction (
     id,
     objectclass_id,
     gmlid,
     gmlid_codespace,
     name,
     name_codespace,
     description,
     u_value,
     u_value_unit,
     glazing_ratio,
     start_of_life,
     life_expect_value,
     life_expect_value_unit,
     main_maint_interval,
     main_maint_interval_unit,
     base_constr_id
    ) VALUES (
    %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L
    ) RETURNING id',
    p_schema_name,
    p_id,
    p_objectclass_id,
    p_gmlid,
    p_gmlid_codespace,
    p_name,
    p_name_codespace,
    p_description,
    p_u_value,
    p_u_value_unit,
    p_glazing_ratio,
    p_start_of_life,
    p_life_expect_value,
    p_life_expect_value_unit,
    p_main_maint_interval,
    p_main_maint_interval_unit,
    p_base_constr_id
) INTO inserted_id;
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.nrg8_insert_construction (id: %): %', p_id, SQLERRM;
END;
$$
LANGUAGE 'plpgsql';

----------------------------------------------------------------
-- Function NRG8_INSERT_CITYOBJECT_TO_CONSTR
----------------------------------------------------------------
-- DROP FUNCTION IF EXISTS citydb_pkg.nrg8_insert_cityobject_to_constr (integer, integer) CASCADE;
CREATE OR REPLACE FUNCTION citydb_pkg.nrg8_insert_cityobject_to_constr (
  cityobject_id        integer,
  constr_id            integer,
  schema_name          varchar DEFAULT 'citydb'::varchar
)
RETURNS void
AS
$$
DECLARE
  p_cityobject_id      integer;
  p_constr_id          integer;
--
  p_schema_name        varchar;
BEGIN
-- Pass values to internal prefixed variables to avoid potential homonymy issues
  p_cityobject_id      :=cityobject_id;
  p_constr_id          :=constr_id;
  p_schema_name        :=schema_name;

EXECUTE format('
    INSERT INTO %I.nrg8_cityobject_to_constr (
     cityobject_id,
     constr_id
    ) VALUES (
    %L, %L
    )',
	p_schema_name,
    p_cityobject_id,
    p_constr_id
);
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.nrg8_insert_cityobject_to_constr (cityobject_id: %, constr_id: %): %', cityobject_id, constr_id, SQLERRM;
END;
$$
LANGUAGE 'plpgsql';

----------------------------------------------------------------
-- Function NRG8_INSERT_OPTICAL_PROPERTY
----------------------------------------------------------------
-- DROP FUNCTION IF EXISTS citydb_pkg.nrg8_insert_optical_property (integer, integer, numeric, character varying, character varying, integer) CASCADE;
CREATE OR REPLACE FUNCTION citydb_pkg.nrg8_insert_optical_property (
  objectclass_id       integer,
  id                   integer DEFAULT NULL,
  fraction             numeric DEFAULT NULL,
  range                character varying DEFAULT NULL,
  surf_side            character varying DEFAULT NULL,
  constr_id            integer DEFAULT NULL,
  schema_name          varchar DEFAULT 'citydb'::varchar
)
RETURNS integer
AS
$$
DECLARE
  p_id                 integer;
  p_objectclass_id     integer;
  p_fraction           numeric;
  p_range              character varying;
  p_surf_side          character varying;
  p_constr_id          integer;
--
  p_schema_name        varchar;
  seq_name varchar;
  inserted_id integer;
BEGIN
-- Pass values to internal prefixed variables to avoid potential homonymy issues
  p_id                 :=id;
  p_objectclass_id     :=objectclass_id;
  p_fraction           :=fraction;
  p_range              :=range;
  p_surf_side          :=surf_side;
  p_constr_id          :=constr_id;
  p_schema_name        :=schema_name;
-- IF the ID is not given, then generate a new one.
IF p_id IS NULL THEN
  seq_name=schema_name||'.nrg8_optical_property_id_seq';
  p_id=nextval(seq_name::regclass);
END IF;

EXECUTE format('
    INSERT INTO %I.nrg8_optical_property (
     id,
     objectclass_id,
     fraction,
     range,
     surf_side,
     constr_id
    ) VALUES (
    %L, %L, %L, %L, %L, %L
    ) RETURNING id',
    p_schema_name,
    p_id,
    p_objectclass_id,
    p_fraction,
    p_range,
    p_surf_side,
    p_constr_id
) INTO inserted_id;
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.nrg8_insert_optical_property (id: %): %', p_id, SQLERRM;
END;
$$
LANGUAGE 'plpgsql';

----------------------------------------------------------------
-- Function NRG8_INSERT_DIMENSIONAL_ATTRIB
----------------------------------------------------------------
-- DROP FUNCTION IF EXISTS citydb_pkg.nrg8_insert_dimensional_attrib (integer, integer, character varying, numeric, character varying, integer) CASCADE;
CREATE OR REPLACE FUNCTION citydb_pkg.nrg8_insert_dimensional_attrib (
  objectclass_id       integer,
  id                   integer DEFAULT NULL,
  type                 character varying DEFAULT NULL,
  value                numeric DEFAULT NULL,
  value_unit           character varying DEFAULT NULL,
  cityobject_id        integer DEFAULT NULL,
  schema_name          varchar DEFAULT 'citydb'::varchar
)
RETURNS integer
AS
$$
DECLARE
  p_id                 integer;
  p_objectclass_id     integer;
  p_type               character varying;
  p_value              numeric;
  p_value_unit         character varying;
  p_cityobject_id      integer;
--
  p_schema_name        varchar;
  seq_name varchar;
  inserted_id integer;
BEGIN
-- Pass values to internal prefixed variables to avoid potential homonymy issues
  p_id                 :=id;
  p_objectclass_id     :=objectclass_id;
  p_type               :=type;
  p_value              :=value;
  p_value_unit         :=value_unit;
  p_cityobject_id      :=cityobject_id;
  p_schema_name        :=schema_name;
-- IF the ID is not given, then generate a new one.
IF p_id IS NULL THEN
  seq_name=schema_name||'.nrg8_dimensional_attrib_id_seq';
  p_id=nextval(seq_name::regclass);
END IF;

EXECUTE format('
    INSERT INTO %I.nrg8_dimensional_attrib (
     id,
     objectclass_id,
     type,
     value,
     value_unit,
     cityobject_id
    ) VALUES (
    %L, %L, %L, %L, %L, %L
    ) RETURNING id',
    p_schema_name,
    p_id,
    p_objectclass_id,
    p_type,
    p_value,
    p_value_unit,
    p_cityobject_id
) INTO inserted_id;
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.nrg8_insert_dimensional_attrib (id: %): %', p_id, SQLERRM;
END;
$$
LANGUAGE 'plpgsql';

----------------------------------------------------------------
-- Function NRG8_INSERT_LAYER
----------------------------------------------------------------
-- DROP FUNCTION IF EXISTS citydb_pkg.nrg8_insert_layer (integer, integer, character varying, character varying, character varying, character varying, text, integer, integer) CASCADE;
CREATE OR REPLACE FUNCTION citydb_pkg.nrg8_insert_layer (
  objectclass_id       integer,
  id                   integer DEFAULT NULL,
  gmlid                character varying DEFAULT NULL,
  gmlid_codespace      character varying DEFAULT NULL,
  name                 character varying DEFAULT NULL,
  name_codespace       character varying DEFAULT NULL,
  description          text DEFAULT NULL,
  pos_nbr             integer DEFAULT NULL,
  constr_id            integer DEFAULT NULL,
  schema_name          varchar DEFAULT 'citydb'::varchar
)
RETURNS integer
AS
$$
DECLARE
  p_id                 integer;
  p_objectclass_id     integer;
  p_gmlid              character varying;
  p_gmlid_codespace    character varying;
  p_name               character varying;
  p_name_codespace     character varying;
  p_description        text;
  p_pos_nbr           integer;
  p_constr_id          integer;
--
  p_schema_name        varchar;
  seq_name varchar;
  inserted_id integer;
BEGIN
-- Pass values to internal prefixed variables to avoid potential homonymy issues
  p_id                 :=id;
  p_objectclass_id     :=objectclass_id;
  p_gmlid              :=gmlid;
  p_gmlid_codespace    :=gmlid_codespace;
  p_name               :=name;
  p_name_codespace     :=name_codespace;
  p_description        :=description;
  p_pos_nbr           :=pos_nbr;
  p_constr_id          :=constr_id;
  p_schema_name        :=schema_name;
-- IF the ID is not given, then generate a new one.
IF p_id IS NULL THEN
  seq_name=schema_name||'.nrg8_layer_id_seq';
  p_id=nextval(seq_name::regclass);
END IF;
-- IF the GmlID is not given, then generate a new one.
IF p_gmlid IS NULL THEN
  p_gmlid='UUID_'||uuid_generate_v4();
END IF;

EXECUTE format('
    INSERT INTO %I.nrg8_layer (
     id,
     objectclass_id,
     gmlid,
     gmlid_codespace,
     name,
     name_codespace,
     description,
     pos_nbr,
     constr_id
    ) VALUES (
    %L, %L, %L, %L, %L, %L, %L, %L, %L
    ) RETURNING id',
    p_schema_name,
    p_id,
    p_objectclass_id,
    p_gmlid,
    p_gmlid_codespace,
    p_name,
    p_name_codespace,
    p_description,
    p_pos_nbr,
    p_constr_id
) INTO inserted_id;
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.nrg8_insert_layer (id: %): %', p_id, SQLERRM;
END;
$$
LANGUAGE 'plpgsql';

----------------------------------------------------------------
-- Function NRG8_INSERT_PERF_CERTIFICATION
----------------------------------------------------------------
-- DROP FUNCTION IF EXISTS citydb_pkg.nrg8_insert_perf_certification (integer, character varying, character varying, character varying, integer, integer) CASCADE;
CREATE OR REPLACE FUNCTION citydb_pkg.nrg8_insert_perf_certification (
  id                   integer DEFAULT NULL,
  name                 character varying DEFAULT NULL,
  rating               character varying DEFAULT NULL,
  certification_id     character varying DEFAULT NULL,
  building_id          integer DEFAULT NULL,
  building_unit_id     integer DEFAULT NULL,
  schema_name          varchar DEFAULT 'citydb'::varchar
)
RETURNS integer
AS
$$
DECLARE
  p_id                 integer;
  p_name               character varying;
  p_rating             character varying;
  p_certification_id   character varying;
  p_building_id        integer;
  p_building_unit_id   integer;
--
  p_schema_name        varchar;
  seq_name varchar;
  inserted_id integer;
BEGIN
-- Pass values to internal prefixed variables to avoid potential homonymy issues
  p_id                 :=id;
  p_name               :=name;
  p_rating             :=rating;
  p_certification_id   :=certification_id;
  p_building_id        :=building_id;
  p_building_unit_id   :=building_unit_id;
  p_schema_name        :=schema_name;
-- IF the ID is not given, then generate a new one.
IF p_id IS NULL THEN
  seq_name=schema_name||'.nrg8_perf_certification_id_seq';
  p_id=nextval(seq_name::regclass);
END IF;

EXECUTE format('
    INSERT INTO %I.nrg8_perf_certification (
     id,
     name,
     rating,
     certification_id,
     building_id,
     building_unit_id
    ) VALUES (
    %L, %L, %L, %L, %L, %L
    ) RETURNING id',
    p_schema_name,
    p_id,
    p_name,
    p_rating,
    p_certification_id,
    p_building_id,
    p_building_unit_id
) INTO inserted_id;
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.nrg8_insert_perf_certification (id: %): %', p_id, SQLERRM;
END;
$$
LANGUAGE 'plpgsql';

----------------------------------------------------------------
-- Function NRG8_INSERT_COMBINED_HEAT_POWER
----------------------------------------------------------------
-- DROP FUNCTION IF EXISTS citydb_pkg.nrg8_insert_combined_heat_power (integer, integer, character varying, numeric, numeric) CASCADE;
CREATE OR REPLACE FUNCTION citydb_pkg.nrg8_insert_combined_heat_power (
  objectclass_id       integer,
  id                   integer,
  techn_type           character varying DEFAULT NULL,
  therm_effcy          numeric DEFAULT NULL,
  electr_effcy         numeric DEFAULT NULL,
  schema_name          varchar DEFAULT 'citydb'::varchar
)
RETURNS integer
AS
$$
DECLARE
  p_id                 integer;
  p_objectclass_id     integer;
  p_techn_type         character varying;
  p_therm_effcy        numeric;
  p_electr_effcy       numeric;
--
  p_schema_name        varchar;
  inserted_id integer;
BEGIN
-- Pass values to internal prefixed variables to avoid potential homonymy issues
  p_id                 :=id;
  p_objectclass_id     :=objectclass_id;
  p_techn_type         :=techn_type;
  p_therm_effcy        :=therm_effcy;
  p_electr_effcy       :=electr_effcy;
  p_schema_name        :=schema_name;


EXECUTE format('
    INSERT INTO %I.nrg8_combined_heat_power (
     id,
     objectclass_id,
     techn_type,
     therm_effcy,
     electr_effcy
    ) VALUES (
    %L, %L, %L, %L, %L
    ) RETURNING id',
    p_schema_name,
    p_id,
    p_objectclass_id,
    p_techn_type,
    p_therm_effcy,
    p_electr_effcy
) INTO inserted_id;
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.nrg8_insert_combined_heat_power (id: %): %', p_id, SQLERRM;
END;
$$
LANGUAGE 'plpgsql';

----------------------------------------------------------------
-- Function NRG8_INSERT_HEAT_EXCHANGER
----------------------------------------------------------------
-- DROP FUNCTION IF EXISTS citydb_pkg.nrg8_insert_heat_exchanger (integer, integer, integer, integer, character varying) CASCADE;
CREATE OR REPLACE FUNCTION citydb_pkg.nrg8_insert_heat_exchanger (
  objectclass_id       integer,
  id                   integer,
  network_id           integer DEFAULT NULL,
  network_node_id      integer DEFAULT NULL,
  prim_heat_supplier   character varying DEFAULT NULL,
  schema_name          varchar DEFAULT 'citydb'::varchar
)
RETURNS integer
AS
$$
DECLARE
  p_id                 integer;
  p_objectclass_id     integer;
  p_network_id         integer;
  p_network_node_id    integer;
  p_prim_heat_supplier character varying;
--
  p_schema_name        varchar;
  inserted_id integer;
BEGIN
-- Pass values to internal prefixed variables to avoid potential homonymy issues
  p_id                 :=id;
  p_objectclass_id     :=objectclass_id;
  p_network_id         :=network_id;
  p_network_node_id    :=network_node_id;
  p_prim_heat_supplier :=prim_heat_supplier;
  p_schema_name        :=schema_name;


EXECUTE format('
    INSERT INTO %I.nrg8_heat_exchanger (
     id,
     objectclass_id,
     network_id,
     network_node_id,
     prim_heat_supplier
    ) VALUES (
    %L, %L, %L, %L, %L
    ) RETURNING id',
    p_schema_name,
    p_id,
    p_objectclass_id,
    p_network_id,
    p_network_node_id,
    p_prim_heat_supplier
) INTO inserted_id;
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.nrg8_insert_heat_exchanger (id: %): %', p_id, SQLERRM;
END;
$$
LANGUAGE 'plpgsql';

----------------------------------------------------------------
-- Function NRG8_INSERT_REFURBISHMENT_MEASURE
----------------------------------------------------------------
-- DROP FUNCTION IF EXISTS citydb_pkg.nrg8_insert_refurbishment_measure (integer, text, character varying, date, date, date, integer, integer) CASCADE;
CREATE OR REPLACE FUNCTION citydb_pkg.nrg8_insert_refurbishment_measure (
  id                   integer DEFAULT NULL,
  description          text DEFAULT NULL,
  level                character varying DEFAULT NULL,
  instant_date         date DEFAULT NULL,
  begin_date           date DEFAULT NULL,
  end_date             date DEFAULT NULL,
  building_id          integer DEFAULT NULL,
  therm_boundary_id    integer DEFAULT NULL,
  schema_name          varchar DEFAULT 'citydb'::varchar
)
RETURNS integer
AS
$$
DECLARE
  p_id                 integer;
  p_description        text;
  p_level              character varying;
  p_instant_date       date;
  p_begin_date         date;
  p_end_date           date;
  p_building_id        integer;
  p_therm_boundary_id  integer;
--
  p_schema_name        varchar;
  seq_name varchar;
  inserted_id integer;
BEGIN
-- Pass values to internal prefixed variables to avoid potential homonymy issues
  p_id                 :=id;
  p_description        :=description;
  p_level              :=level;
  p_instant_date       :=instant_date;
  p_begin_date         :=begin_date;
  p_end_date           :=end_date;
  p_building_id        :=building_id;
  p_therm_boundary_id  :=therm_boundary_id;
  p_schema_name        :=schema_name;
-- IF the ID is not given, then generate a new one.
IF p_id IS NULL THEN
  seq_name=schema_name||'.nrg8_refurbishment_measure_id_seq';
  p_id=nextval(seq_name::regclass);
END IF;

EXECUTE format('
    INSERT INTO %I.nrg8_refurbishment_measure (
     id,
     description,
     level,
     instant_date,
     begin_date,
     end_date,
     building_id,
     therm_boundary_id
    ) VALUES (
    %L, %L, %L, %L, %L, %L, %L, %L
    ) RETURNING id',
    p_schema_name,
    p_id,
    p_description,
    p_level,
    p_instant_date,
    p_begin_date,
    p_end_date,
    p_building_id,
    p_therm_boundary_id
) INTO inserted_id;
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.nrg8_insert_refurbishment_measure (id: %): %', p_id, SQLERRM;
END;
$$
LANGUAGE 'plpgsql';

----------------------------------------------------------------
-- Function NRG8_INSERT_WEATHER_DATA
----------------------------------------------------------------
-- DROP FUNCTION IF EXISTS citydb_pkg.nrg8_insert_weather_data (integer, character varying, character varying, character varying, character varying, text, character varying, integer, integer, geometry) CASCADE;
CREATE OR REPLACE FUNCTION citydb_pkg.nrg8_insert_weather_data (
  id                   integer DEFAULT NULL,
  gmlid                character varying DEFAULT NULL,
  gmlid_codespace      character varying DEFAULT NULL,
  name                 character varying DEFAULT NULL,
  name_codespace       character varying DEFAULT NULL,
  description          text DEFAULT NULL,
  type                 character varying DEFAULT NULL,
  time_series_id       integer DEFAULT NULL,
  cityobject_id        integer DEFAULT NULL,
  install_point        geometry DEFAULT NULL,
  schema_name          varchar DEFAULT 'citydb'::varchar
)
RETURNS integer
AS
$$
DECLARE
  p_id                 integer;
  p_gmlid              character varying;
  p_gmlid_codespace    character varying;
  p_name               character varying;
  p_name_codespace     character varying;
  p_description        text;
  p_type               character varying;
  p_time_series_id     integer;
  p_cityobject_id      integer;
  p_install_point      geometry;
--
  p_schema_name        varchar;
  seq_name varchar;
  inserted_id integer;
BEGIN
-- Pass values to internal prefixed variables to avoid potential homonymy issues
  p_id                 :=id;
  p_gmlid              :=gmlid;
  p_gmlid_codespace    :=gmlid_codespace;
  p_name               :=name;
  p_name_codespace     :=name_codespace;
  p_description        :=description;
  p_type               :=type;
  p_time_series_id     :=time_series_id;
  p_cityobject_id      :=cityobject_id;
  p_install_point      :=install_point;
  p_schema_name        :=schema_name;
-- IF the ID is not given, then generate a new one.
IF p_id IS NULL THEN
  seq_name=schema_name||'.nrg8_weather_data_id_seq';
  p_id=nextval(seq_name::regclass);
END IF;
-- IF the GmlID is not given, then generate a new one.
IF p_gmlid IS NULL THEN
  p_gmlid='UUID_'||uuid_generate_v4();
END IF;

EXECUTE format('
    INSERT INTO %I.nrg8_weather_data (
     id,
     gmlid,
     gmlid_codespace,
     name,
     name_codespace,
     description,
     type,
     time_series_id,
     cityobject_id,
     install_point
    ) VALUES (
    %L, %L, %L, %L, %L, %L, %L, %L, %L, %L
    ) RETURNING id',
    p_schema_name,
    p_id,
    p_gmlid,
    p_gmlid_codespace,
    p_name,
    p_name_codespace,
    p_description,
    p_type,
    p_time_series_id,
    p_cityobject_id,
    p_install_point
) INTO inserted_id;
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.nrg8_insert_weather_data (id: %): %', p_id, SQLERRM;
END;
$$
LANGUAGE 'plpgsql';

----------------------------------------------------------------
-- Function NRG8_INSERT_WEATHER_STATION
----------------------------------------------------------------
-- DROP FUNCTION IF EXISTS citydb_pkg.nrg8_insert_weather_station (integer, integer, integer, geometry) CASCADE;
CREATE OR REPLACE FUNCTION citydb_pkg.nrg8_insert_weather_station (
  objectclass_id       integer,
  id                   integer,
  cityobject_id        integer DEFAULT NULL,
  install_point        geometry DEFAULT NULL,
  schema_name          varchar DEFAULT 'citydb'::varchar
)
RETURNS integer
AS
$$
DECLARE
  p_id                 integer;
  p_objectclass_id     integer;
  p_cityobject_id      integer;
  p_install_point      geometry;
--
  p_schema_name        varchar;
  inserted_id integer;
BEGIN
-- Pass values to internal prefixed variables to avoid potential homonymy issues
  p_id                 :=id;
  p_objectclass_id     :=objectclass_id;
  p_cityobject_id      :=cityobject_id;
  p_install_point      :=install_point;
  p_schema_name        :=schema_name;

EXECUTE format('
    INSERT INTO %I.nrg8_weather_station (
     id,
     objectclass_id,
     cityobject_id,
     install_point
    ) VALUES (
    %L, %L, %L, %L
    ) RETURNING id',
    p_schema_name,
    p_id,
    p_objectclass_id,
    p_cityobject_id,
    p_install_point
) INTO inserted_id;
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.nrg8_insert_weather_station (id: %): %', p_id, SQLERRM;
END;
$$
LANGUAGE 'plpgsql';

----------------------------------------------------------------
-- Function NRG8_INSERT_BUILDING
----------------------------------------------------------------
-- DROP FUNCTION IF EXISTS citydb_pkg.nrg8_insert_building (integer, integer, character varying, character varying, character varying, numeric, geometry) CASCADE;
CREATE OR REPLACE FUNCTION citydb_pkg.nrg8_insert_building (
  objectclass_id       integer,
  id                   integer,
  type                 character varying DEFAULT NULL,
  type_codespace       character varying DEFAULT NULL,
  constr_weight        character varying DEFAULT NULL,
  is_landmarked        numeric DEFAULT NULL,
  ref_point            geometry DEFAULT NULL,
  schema_name          varchar DEFAULT 'citydb'::varchar
)
RETURNS integer
AS
$$
DECLARE
  p_id                 integer;
  p_objectclass_id     integer;
  p_type               character varying;
  p_type_codespace     character varying;
  p_constr_weight      character varying;
  p_is_landmarked      numeric;
  p_ref_point          geometry;
--
  p_schema_name        varchar;
  inserted_id integer;
BEGIN
-- Pass values to internal prefixed variables to avoid potential homonymy issues
  p_id                 :=id;
  p_objectclass_id     :=objectclass_id;
  p_type               :=type;
  p_type_codespace     :=type_codespace;
  p_constr_weight      :=constr_weight;
  p_is_landmarked      :=is_landmarked;
  p_ref_point          :=ref_point;
  p_schema_name        :=schema_name;


EXECUTE format('
    INSERT INTO %I.nrg8_building (
     id,
     objectclass_id,
     type,
     type_codespace,
     constr_weight,
     is_landmarked,
     ref_point
    ) VALUES (
    %L, %L, %L, %L, %L, %L, %L
    ) RETURNING id',
    p_schema_name,
    p_id,
    p_objectclass_id,
    p_type,
    p_type_codespace,
    p_constr_weight,
    p_is_landmarked,
    p_ref_point
) INTO inserted_id;
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.nrg8_insert_building (id: %): %', p_id, SQLERRM;
END;
$$
LANGUAGE 'plpgsql';

----------------------------------------------------------------
-- Function NRG8_INSERT_THERMAL_ZONE
----------------------------------------------------------------
-- DROP FUNCTION IF EXISTS citydb_pkg.nrg8_insert_thermal_zone (integer, integer, numeric, character varying, numeric, character varying, numeric, numeric, character varying, numeric, numeric, integer, integer, geometry) CASCADE;
CREATE OR REPLACE FUNCTION citydb_pkg.nrg8_insert_thermal_zone (
  objectclass_id       integer,
  id                   integer,
  add_therm_bridge_uvalue numeric DEFAULT NULL,
  add_therm_bridge_uvalue_unit character varying DEFAULT NULL,
  eff_therm_capacity   numeric DEFAULT NULL,
  eff_therm_capacity_unit character varying DEFAULT NULL,
  ind_heated_area_ratio numeric DEFAULT NULL,
  infiltr_rate         numeric DEFAULT NULL,
  infiltr_rate_unit    character varying DEFAULT NULL,
  is_cooled            numeric DEFAULT NULL,
  is_heated            numeric DEFAULT NULL,
  building_id          integer DEFAULT NULL,
  solid_id             integer DEFAULT NULL,
  multi_surf_geom      geometry DEFAULT NULL,
  schema_name          varchar DEFAULT 'citydb'::varchar
)
RETURNS integer
AS
$$
DECLARE
  p_id                 integer;
  p_objectclass_id     integer;
  p_add_therm_bridge_uvalue numeric;
  p_add_therm_bridge_uvalue_unit character varying;
  p_eff_therm_capacity numeric;
  p_eff_therm_capacity_unit character varying;
  p_ind_heated_area_ratio numeric;
  p_infiltr_rate       numeric;
  p_infiltr_rate_unit  character varying;
  p_is_cooled          numeric;
  p_is_heated          numeric;
  p_building_id        integer;
  p_solid_id           integer;
  p_multi_surf_geom    geometry;
--
  p_schema_name        varchar;
  inserted_id integer;
BEGIN
-- Pass values to internal prefixed variables to avoid potential homonymy issues
  p_id                 :=id;
  p_objectclass_id     :=objectclass_id;
  p_add_therm_bridge_uvalue :=add_therm_bridge_uvalue;
  p_add_therm_bridge_uvalue_unit :=add_therm_bridge_uvalue_unit;
  p_eff_therm_capacity :=eff_therm_capacity;
  p_eff_therm_capacity_unit :=eff_therm_capacity_unit;
  p_ind_heated_area_ratio :=ind_heated_area_ratio;
  p_infiltr_rate       :=infiltr_rate;
  p_infiltr_rate_unit  :=infiltr_rate_unit;
  p_is_cooled          :=is_cooled;
  p_is_heated          :=is_heated;
  p_building_id        :=building_id;
  p_solid_id           :=solid_id;
  p_multi_surf_geom    :=multi_surf_geom;
  p_schema_name        :=schema_name;


EXECUTE format('
    INSERT INTO %I.nrg8_thermal_zone (
     id,
     objectclass_id,
     add_therm_bridge_uvalue,
     add_therm_bridge_uvalue_unit,
     eff_therm_capacity,
     eff_therm_capacity_unit,
     ind_heated_area_ratio,
     infiltr_rate,
     infiltr_rate_unit,
     is_cooled,
     is_heated,
     building_id,
     solid_id,
     multi_surf_geom
    ) VALUES (
    %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L
    ) RETURNING id',
    p_schema_name,
    p_id,
    p_objectclass_id,
    p_add_therm_bridge_uvalue,
    p_add_therm_bridge_uvalue_unit,
    p_eff_therm_capacity,
    p_eff_therm_capacity_unit,
    p_ind_heated_area_ratio,
    p_infiltr_rate,
    p_infiltr_rate_unit,
    p_is_cooled,
    p_is_heated,
    p_building_id,
    p_solid_id,
    p_multi_surf_geom
) INTO inserted_id;
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.nrg8_insert_thermal_zone (id: %): %', p_id, SQLERRM;
END;
$$
LANGUAGE 'plpgsql';

----------------------------------------------------------------
-- Function NRG8_INSERT_OCCUPANTS
----------------------------------------------------------------
-- DROP FUNCTION IF EXISTS citydb_pkg.nrg8_insert_occupants (integer, integer, character varying, character varying, character varying, character varying, text, character varying, integer, numeric, character varying, numeric, numeric, numeric, integer, integer, integer) CASCADE;
CREATE OR REPLACE FUNCTION citydb_pkg.nrg8_insert_occupants (
  objectclass_id       integer,
  id                   integer DEFAULT NULL,
  gmlid                character varying DEFAULT NULL,
  gmlid_codespace      character varying DEFAULT NULL,
  name                 character varying DEFAULT NULL,
  name_codespace       character varying DEFAULT NULL,
  description          text DEFAULT NULL,
  type                 character varying DEFAULT NULL,
  nbr_of_occupants     integer DEFAULT NULL,
  heat_diss_tot_value  numeric DEFAULT NULL,
  heat_diss_tot_value_unit character varying DEFAULT NULL,
  heat_diss_conv       numeric DEFAULT NULL,
  heat_diss_lat        numeric DEFAULT NULL,
  heat_diss_rad        numeric DEFAULT NULL,
  usage_zone_id        integer DEFAULT NULL,
  sched_id             integer DEFAULT NULL,
  building_unit_id     integer DEFAULT NULL,
  schema_name          varchar DEFAULT 'citydb'::varchar
)
RETURNS integer
AS
$$
DECLARE
  p_id                 integer;
  p_objectclass_id     integer;
  p_gmlid              character varying;
  p_gmlid_codespace    character varying;
  p_name               character varying;
  p_name_codespace     character varying;
  p_description        text;
  p_type               character varying;
  p_nbr_of_occupants   integer;
  p_heat_diss_tot_value numeric;
  p_heat_diss_tot_value_unit character varying;
  p_heat_diss_conv     numeric;
  p_heat_diss_lat      numeric;
  p_heat_diss_rad      numeric;
  p_usage_zone_id      integer;
  p_sched_id           integer;
  p_building_unit_id   integer;
--
  p_schema_name        varchar;
  seq_name varchar;
  inserted_id integer;
BEGIN
-- Pass values to internal prefixed variables to avoid potential homonymy issues
  p_id                 :=id;
  p_objectclass_id     :=objectclass_id;
  p_gmlid              :=gmlid;
  p_gmlid_codespace    :=gmlid_codespace;
  p_name               :=name;
  p_name_codespace     :=name_codespace;
  p_description        :=description;
  p_type               :=type;
  p_nbr_of_occupants   :=nbr_of_occupants;
  p_heat_diss_tot_value :=heat_diss_tot_value;
  p_heat_diss_tot_value_unit :=heat_diss_tot_value_unit;
  p_heat_diss_conv     :=heat_diss_conv;
  p_heat_diss_lat      :=heat_diss_lat;
  p_heat_diss_rad      :=heat_diss_rad;
  p_usage_zone_id      :=usage_zone_id;
  p_sched_id           :=sched_id;
  p_building_unit_id   :=building_unit_id;
  p_schema_name        :=schema_name;
-- IF the ID is not given, then generate a new one.
IF p_id IS NULL THEN
  seq_name=schema_name||'.nrg8_occupants_id_seq';
  p_id=nextval(seq_name::regclass);
END IF;
-- IF the GmlID is not given, then generate a new one.
IF p_gmlid IS NULL THEN
  p_gmlid='UUID_'||uuid_generate_v4();
END IF;

EXECUTE format('
    INSERT INTO %I.nrg8_occupants (
     id,
     objectclass_id,
     gmlid,
     gmlid_codespace,
     name,
     name_codespace,
     description,
     type,
     nbr_of_occupants,
     heat_diss_tot_value,
     heat_diss_tot_value_unit,
     heat_diss_conv,
     heat_diss_lat,
     heat_diss_rad,
     usage_zone_id,
     sched_id,
     building_unit_id
    ) VALUES (
    %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L
    ) RETURNING id',
    p_schema_name,
    p_id,
    p_objectclass_id,
    p_gmlid,
    p_gmlid_codespace,
    p_name,
    p_name_codespace,
    p_description,
    p_type,
    p_nbr_of_occupants,
    p_heat_diss_tot_value,
    p_heat_diss_tot_value_unit,
    p_heat_diss_conv,
    p_heat_diss_lat,
    p_heat_diss_rad,
    p_usage_zone_id,
    p_sched_id,
    p_building_unit_id
) INTO inserted_id;
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.nrg8_insert_occupants (id: %): %', p_id, SQLERRM;
END;
$$
LANGUAGE 'plpgsql';

----------------------------------------------------------------
-- Function NRG8_INSERT_ENERGY_DEMAND
----------------------------------------------------------------
-- DROP FUNCTION IF EXISTS citydb_pkg.nrg8_insert_energy_demand (integer, integer, character varying, character varying, character varying, character varying, text, character varying, numeric, character varying, integer, integer) CASCADE;
CREATE OR REPLACE FUNCTION citydb_pkg.nrg8_insert_energy_demand (
  objectclass_id       integer,
  id                   integer DEFAULT NULL,
  gmlid                character varying DEFAULT NULL,
  gmlid_codespace      character varying DEFAULT NULL,
  name                 character varying DEFAULT NULL,
  name_codespace       character varying DEFAULT NULL,
  description          text DEFAULT NULL,
  end_use              character varying DEFAULT NULL,
  max_load             numeric DEFAULT NULL,
  max_load_unit        character varying DEFAULT NULL,
  time_series_id       integer DEFAULT NULL,
  cityobject_id        integer DEFAULT NULL,
  schema_name          varchar DEFAULT 'citydb'::varchar
)
RETURNS integer
AS
$$
DECLARE
  p_id                 integer;
  p_objectclass_id     integer;
  p_gmlid              character varying;
  p_gmlid_codespace    character varying;
  p_name               character varying;
  p_name_codespace     character varying;
  p_description        text;
  p_end_use            character varying;
  p_max_load           numeric;
  p_max_load_unit      character varying;
  p_time_series_id     integer;
  p_cityobject_id      integer;
--
  p_schema_name        varchar;
  seq_name varchar;
  inserted_id integer;
BEGIN
-- Pass values to internal prefixed variables to avoid potential homonymy issues
  p_id                 :=id;
  p_objectclass_id     :=objectclass_id;
  p_gmlid              :=gmlid;
  p_gmlid_codespace    :=gmlid_codespace;
  p_name               :=name;
  p_name_codespace     :=name_codespace;
  p_description        :=description;
  p_end_use            :=end_use;
  p_max_load           :=max_load;
  p_max_load_unit      :=max_load_unit;
  p_time_series_id     :=time_series_id;
  p_cityobject_id      :=cityobject_id;
  p_schema_name        :=schema_name;
-- IF the ID is not given, then generate a new one.
IF p_id IS NULL THEN
  seq_name=schema_name||'.nrg8_energy_demand_id_seq';
  p_id=nextval(seq_name::regclass);
END IF;
-- IF the GmlID is not given, then generate a new one.
IF p_gmlid IS NULL THEN
  p_gmlid='UUID_'||uuid_generate_v4();
END IF;

EXECUTE format('
    INSERT INTO %I.nrg8_energy_demand (
     id,
     objectclass_id,
     gmlid,
     gmlid_codespace,
     name,
     name_codespace,
     description,
     end_use,
     max_load,
     max_load_unit,
     time_series_id,
     cityobject_id
    ) VALUES (
    %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L
    ) RETURNING id',
    p_schema_name,
    p_id,
    p_objectclass_id,
    p_gmlid,
    p_gmlid_codespace,
    p_name,
    p_name_codespace,
    p_description,
    p_end_use,
    p_max_load,
    p_max_load_unit,
    p_time_series_id,
    p_cityobject_id
) INTO inserted_id;
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.nrg8_insert_energy_demand (id: %): %', p_id, SQLERRM;
END;
$$
LANGUAGE 'plpgsql';

----------------------------------------------------------------
-- Function NRG8_INSERT_FINAL_ENERGY
----------------------------------------------------------------
-- DROP FUNCTION IF EXISTS citydb_pkg.nrg8_insert_final_energy (integer, integer, character varying, character varying, character varying, character varying, text, character varying, numeric, character varying, numeric, character varying, numeric, character varying, integer) CASCADE;
CREATE OR REPLACE FUNCTION citydb_pkg.nrg8_insert_final_energy (
  objectclass_id       integer,
  id                   integer DEFAULT NULL,
  gmlid                character varying DEFAULT NULL,
  gmlid_codespace      character varying DEFAULT NULL,
  name                 character varying DEFAULT NULL,
  name_codespace       character varying DEFAULT NULL,
  description          text DEFAULT NULL,
  nrg_car_type         character varying DEFAULT NULL,
  nrg_car_prim_nrg_factor numeric DEFAULT NULL,
  nrg_car_prim_nrg_factor_unit character varying DEFAULT NULL,
  nrg_car_nrg_density  numeric DEFAULT NULL,
  nrg_car_nrg_density_unit character varying DEFAULT NULL,
  nrg_car_co2_emission numeric DEFAULT NULL,
  nrg_car_co2_emission_unit character varying DEFAULT NULL,
  time_series_id       integer DEFAULT NULL,
  schema_name          varchar DEFAULT 'citydb'::varchar
)
RETURNS integer
AS
$$
DECLARE
  p_id                 integer;
  p_objectclass_id     integer;
  p_gmlid              character varying;
  p_gmlid_codespace    character varying;
  p_name               character varying;
  p_name_codespace     character varying;
  p_description        text;
  p_nrg_car_type       character varying;
  p_nrg_car_prim_nrg_factor numeric;
  p_nrg_car_prim_nrg_factor_unit character varying;
  p_nrg_car_nrg_density numeric;
  p_nrg_car_nrg_density_unit character varying;
  p_nrg_car_co2_emission numeric;
  p_nrg_car_co2_emission_unit character varying;
  p_time_series_id     integer;
--
  p_schema_name        varchar;
  seq_name varchar;
  inserted_id integer;
BEGIN
-- Pass values to internal prefixed variables to avoid potential homonymy issues
  p_id                 :=id;
  p_objectclass_id     :=objectclass_id;
  p_gmlid              :=gmlid;
  p_gmlid_codespace    :=gmlid_codespace;
  p_name               :=name;
  p_name_codespace     :=name_codespace;
  p_description        :=description;
  p_nrg_car_type       :=nrg_car_type;
  p_nrg_car_prim_nrg_factor :=nrg_car_prim_nrg_factor;
  p_nrg_car_prim_nrg_factor_unit :=nrg_car_prim_nrg_factor_unit;
  p_nrg_car_nrg_density :=nrg_car_nrg_density;
  p_nrg_car_nrg_density_unit :=nrg_car_nrg_density_unit;
  p_nrg_car_co2_emission :=nrg_car_co2_emission;
  p_nrg_car_co2_emission_unit :=nrg_car_co2_emission_unit;
  p_time_series_id     :=time_series_id;
  p_schema_name        :=schema_name;
-- IF the ID is not given, then generate a new one.
IF p_id IS NULL THEN
  seq_name=schema_name||'.nrg8_final_energy_id_seq';
  p_id=nextval(seq_name::regclass);
END IF;
-- IF the GmlID is not given, then generate a new one.
IF p_gmlid IS NULL THEN
  p_gmlid='UUID_'||uuid_generate_v4();
END IF;

EXECUTE format('
    INSERT INTO %I.nrg8_final_energy (
     id,
     objectclass_id,
     gmlid,
     gmlid_codespace,
     name,
     name_codespace,
     description,
     nrg_car_type,
     nrg_car_prim_nrg_factor,
     nrg_car_prim_nrg_factor_unit,
     nrg_car_nrg_density,
     nrg_car_nrg_density_unit,
     nrg_car_co2_emission,
     nrg_car_co2_emission_unit,
     time_series_id
    ) VALUES (
    %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L
    ) RETURNING id',
    p_schema_name,
    p_id,
    p_objectclass_id,
    p_gmlid,
    p_gmlid_codespace,
    p_name,
    p_name_codespace,
    p_description,
    p_nrg_car_type,
    p_nrg_car_prim_nrg_factor,
    p_nrg_car_prim_nrg_factor_unit,
    p_nrg_car_nrg_density,
    p_nrg_car_nrg_density_unit,
    p_nrg_car_co2_emission,
    p_nrg_car_co2_emission_unit,
    p_time_series_id
) INTO inserted_id;
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.nrg8_insert_final_energy (id: %): %', p_id, SQLERRM;
END;
$$
LANGUAGE 'plpgsql';

----------------------------------------------------------------
-- Function NRG8_INSERT_FACILITIES
----------------------------------------------------------------
-- DROP FUNCTION IF EXISTS citydb_pkg.nrg8_insert_facilities (integer, integer, numeric, character varying, numeric, numeric, numeric, numeric, character varying, integer, integer, integer, numeric, character varying, integer, integer, integer) CASCADE;
CREATE OR REPLACE FUNCTION citydb_pkg.nrg8_insert_facilities (
  objectclass_id       integer,
  id                   integer,
  heat_diss_tot_value  numeric DEFAULT NULL,
  heat_diss_tot_value_unit character varying DEFAULT NULL,
  heat_diss_conv       numeric DEFAULT NULL,
  heat_diss_lat        numeric DEFAULT NULL,
  heat_diss_rad        numeric DEFAULT NULL,
  electr_pwr           numeric DEFAULT NULL,
  electr_pwr_unit      character varying DEFAULT NULL,
  nbr_of_baths         integer DEFAULT NULL,
  nbr_of_showers       integer DEFAULT NULL,
  nbr_of_washbasins    integer DEFAULT NULL,
  water_strg_vol       numeric DEFAULT NULL,
  water_strg_vol_unit  character varying DEFAULT NULL,
  oper_sched_id        integer DEFAULT NULL,
  usage_zone_id        integer DEFAULT NULL,
  building_unit_id     integer DEFAULT NULL,
  schema_name          varchar DEFAULT 'citydb'::varchar
)
RETURNS integer
AS
$$
DECLARE
  p_id                 integer;
  p_objectclass_id     integer;
  p_heat_diss_tot_value numeric;
  p_heat_diss_tot_value_unit character varying;
  p_heat_diss_conv     numeric;
  p_heat_diss_lat      numeric;
  p_heat_diss_rad      numeric;
  p_electr_pwr         numeric;
  p_electr_pwr_unit    character varying;
  p_nbr_of_baths       integer;
  p_nbr_of_showers     integer;
  p_nbr_of_washbasins  integer;
  p_water_strg_vol     numeric;
  p_water_strg_vol_unit character varying;
  p_oper_sched_id      integer;
  p_usage_zone_id      integer;
  p_building_unit_id   integer;
--
  p_schema_name        varchar;
  inserted_id integer;
BEGIN
-- Pass values to internal prefixed variables to avoid potential homonymy issues
  p_id                 :=id;
  p_objectclass_id     :=objectclass_id;
  p_heat_diss_tot_value :=heat_diss_tot_value;
  p_heat_diss_tot_value_unit :=heat_diss_tot_value_unit;
  p_heat_diss_conv     :=heat_diss_conv;
  p_heat_diss_lat      :=heat_diss_lat;
  p_heat_diss_rad      :=heat_diss_rad;
  p_electr_pwr         :=electr_pwr;
  p_electr_pwr_unit    :=electr_pwr_unit;
  p_nbr_of_baths       :=nbr_of_baths;
  p_nbr_of_showers     :=nbr_of_showers;
  p_nbr_of_washbasins  :=nbr_of_washbasins;
  p_water_strg_vol     :=water_strg_vol;
  p_water_strg_vol_unit :=water_strg_vol_unit;
  p_oper_sched_id      :=oper_sched_id;
  p_usage_zone_id      :=usage_zone_id;
  p_building_unit_id   :=building_unit_id;
  p_schema_name        :=schema_name;


EXECUTE format('
    INSERT INTO %I.nrg8_facilities (
     id,
     objectclass_id,
     heat_diss_tot_value,
     heat_diss_tot_value_unit,
     heat_diss_conv,
     heat_diss_lat,
     heat_diss_rad,
     electr_pwr,
     electr_pwr_unit,
     nbr_of_baths,
     nbr_of_showers,
     nbr_of_washbasins,
     water_strg_vol,
     water_strg_vol_unit,
     oper_sched_id,
     usage_zone_id,
     building_unit_id
    ) VALUES (
    %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L
    ) RETURNING id',
    p_schema_name,
    p_id,
    p_objectclass_id,
    p_heat_diss_tot_value,
    p_heat_diss_tot_value_unit,
    p_heat_diss_conv,
    p_heat_diss_lat,
    p_heat_diss_rad,
    p_electr_pwr,
    p_electr_pwr_unit,
    p_nbr_of_baths,
    p_nbr_of_showers,
    p_nbr_of_washbasins,
    p_water_strg_vol,
    p_water_strg_vol_unit,
    p_oper_sched_id,
    p_usage_zone_id,
    p_building_unit_id
) INTO inserted_id;
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.nrg8_insert_facilities (id: %): %', p_id, SQLERRM;
END;
$$
LANGUAGE 'plpgsql';

----------------------------------------------------------------
-- Function NRG8_INSERT_CONV_SYS_TO_NRG_DEMAND
----------------------------------------------------------------
-- DROP FUNCTION IF EXISTS citydb_pkg.nrg8_insert_conv_sys_to_nrg_demand (integer, integer) CASCADE;
CREATE OR REPLACE FUNCTION citydb_pkg.nrg8_insert_conv_sys_to_nrg_demand (
  conv_system_id       integer,
  nrg_demand_id        integer,
  schema_name          varchar DEFAULT 'citydb'::varchar
)
RETURNS void
AS
$$
DECLARE
  p_conv_system_id     integer;
  p_nrg_demand_id      integer;
--
  p_schema_name        varchar;
BEGIN
-- Pass values to internal prefixed variables to avoid potential homonymy issues
  p_conv_system_id     :=conv_system_id;
  p_nrg_demand_id      :=nrg_demand_id;
  p_schema_name        :=schema_name;

EXECUTE format('
    INSERT INTO %I.nrg8_conv_sys_to_nrg_demand (
     conv_system_id,
     nrg_demand_id
    ) VALUES (
    %L, %L
    )',	
    p_conv_system_id,
    p_nrg_demand_id
);
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.nrg8_insert_conv_sys_to_nrg_demand (id: %): %', p_id, SQLERRM;
END;
$$
LANGUAGE 'plpgsql';

----------------------------------------------------------------
-- Function NRG8_INSERT_DISTRIB_SYSTEM
----------------------------------------------------------------
-- DROP FUNCTION IF EXISTS citydb_pkg.nrg8_insert_distrib_system (integer, integer, character varying, date, numeric, character varying, numeric, character varying, integer, integer) CASCADE;
CREATE OR REPLACE FUNCTION citydb_pkg.nrg8_insert_distrib_system (
  objectclass_id       integer,
  id                   integer,
  distrib_perim        character varying DEFAULT NULL,
  start_of_life        date DEFAULT NULL,
  life_expect_value    numeric DEFAULT NULL,
  life_expect_value_unit character varying DEFAULT NULL,
  main_maint_interval  numeric DEFAULT NULL,
  main_maint_interval_unit character varying DEFAULT NULL,
  nrg_demand_id        integer DEFAULT NULL,
  cityobject_id        integer DEFAULT NULL,
  schema_name          varchar DEFAULT 'citydb'::varchar
)
RETURNS integer
AS
$$
DECLARE
  p_id                 integer;
  p_objectclass_id     integer;
  p_distrib_perim      character varying;
  p_start_of_life      date;
  p_life_expect_value  numeric;
  p_life_expect_value_unit character varying;
  p_main_maint_interval numeric;
  p_main_maint_interval_unit character varying;
  p_nrg_demand_id      integer;
  p_cityobject_id      integer;
--
  p_schema_name        varchar;
  inserted_id integer;
BEGIN
-- Pass values to internal prefixed variables to avoid potential homonymy issues
  p_id                 :=id;
  p_objectclass_id     :=objectclass_id;
  p_distrib_perim      :=distrib_perim;
  p_start_of_life      :=start_of_life;
  p_life_expect_value  :=life_expect_value;
  p_life_expect_value_unit :=life_expect_value_unit;
  p_main_maint_interval :=main_maint_interval;
  p_main_maint_interval_unit :=main_maint_interval_unit;
  p_nrg_demand_id      :=nrg_demand_id;
  p_cityobject_id      :=cityobject_id;
  p_schema_name        :=schema_name;


EXECUTE format('
    INSERT INTO %I.nrg8_distrib_system (
     id,
     objectclass_id,
     distrib_perim,
     start_of_life,
     life_expect_value,
     life_expect_value_unit,
     main_maint_interval,
     main_maint_interval_unit,
     nrg_demand_id,
     cityobject_id
    ) VALUES (
    %L, %L, %L, %L, %L, %L, %L, %L, %L, %L
    ) RETURNING id',
    p_schema_name,
    p_id,
    p_objectclass_id,
    p_distrib_perim,
    p_start_of_life,
    p_life_expect_value,
    p_life_expect_value_unit,
    p_main_maint_interval,
    p_main_maint_interval_unit,
    p_nrg_demand_id,
    p_cityobject_id
) INTO inserted_id;
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.nrg8_insert_distrib_system (id: %): %', p_id, SQLERRM;
END;
$$
LANGUAGE 'plpgsql';

----------------------------------------------------------------
-- Function NRG8_INSERT_SYSTEM_OPERATION
----------------------------------------------------------------
-- DROP FUNCTION IF EXISTS citydb_pkg.nrg8_insert_system_operation (integer, integer, character varying, character varying, character varying, character varying, text, character varying, numeric, integer, integer) CASCADE;
CREATE OR REPLACE FUNCTION citydb_pkg.nrg8_insert_system_operation (
  objectclass_id       integer,
  id                   integer DEFAULT NULL,
  gmlid                character varying DEFAULT NULL,
  gmlid_codespace      character varying DEFAULT NULL,
  name                 character varying DEFAULT NULL,
  name_codespace       character varying DEFAULT NULL,
  description          text DEFAULT NULL,
  end_use              character varying DEFAULT NULL,
  yearly_global_effcy  numeric DEFAULT NULL,
  sched_id             integer DEFAULT NULL,
  nrg_conv_system_id   integer DEFAULT NULL,
  schema_name          varchar DEFAULT 'citydb'::varchar
)
RETURNS integer
AS
$$
DECLARE
  p_id                 integer;
  p_objectclass_id     integer;
  p_gmlid              character varying;
  p_gmlid_codespace    character varying;
  p_name               character varying;
  p_name_codespace     character varying;
  p_description        text;
  p_end_use            character varying;
  p_yearly_global_effcy numeric;
  p_sched_id           integer;
  p_nrg_conv_system_id integer;
--
  p_schema_name        varchar;
  seq_name varchar;
  inserted_id integer;
BEGIN
-- Pass values to internal prefixed variables to avoid potential homonymy issues
  p_id                 :=id;
  p_objectclass_id     :=objectclass_id;
  p_gmlid              :=gmlid;
  p_gmlid_codespace    :=gmlid_codespace;
  p_name               :=name;
  p_name_codespace     :=name_codespace;
  p_description        :=description;
  p_end_use            :=end_use;
  p_yearly_global_effcy :=yearly_global_effcy;
  p_sched_id           :=sched_id;
  p_nrg_conv_system_id :=nrg_conv_system_id;
  p_schema_name        :=schema_name;
-- IF the ID is not given, then generate a new one.
IF p_id IS NULL THEN
  seq_name=schema_name||'.nrg8_system_operation_id_seq';
  p_id=nextval(seq_name::regclass);
END IF;
-- IF the GmlID is not given, then generate a new one.
IF p_gmlid IS NULL THEN
  p_gmlid='UUID_'||uuid_generate_v4();
END IF;

EXECUTE format('
    INSERT INTO %I.nrg8_system_operation (
     id,
     objectclass_id,
     gmlid,
     gmlid_codespace,
     name,
     name_codespace,
     description,
     end_use,
     yearly_global_effcy,
     sched_id,
     nrg_conv_system_id
    ) VALUES (
    %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L
    ) RETURNING id',
    p_schema_name,
    p_id,
    p_objectclass_id,
    p_gmlid,
    p_gmlid_codespace,
    p_name,
    p_name_codespace,
    p_description,
    p_end_use,
    p_yearly_global_effcy,
    p_sched_id,
    p_nrg_conv_system_id
) INTO inserted_id;
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.nrg8_insert_system_operation (id: %): %', p_id, SQLERRM;
END;
$$
LANGUAGE 'plpgsql';

----------------------------------------------------------------
-- Function NRG8_INSERT_BUILDING_UNIT
----------------------------------------------------------------
-- DROP FUNCTION IF EXISTS citydb_pkg.nrg8_insert_building_unit (integer, integer, integer, character varying, character varying, integer) CASCADE;
CREATE OR REPLACE FUNCTION citydb_pkg.nrg8_insert_building_unit (
  objectclass_id       integer,
  id                   integer,
  nbr_of_rooms         integer DEFAULT NULL,
  owner_name           character varying DEFAULT NULL,
  ownership_type       character varying DEFAULT NULL,
  usage_zone_id        integer DEFAULT NULL,
  schema_name          varchar DEFAULT 'citydb'::varchar
)
RETURNS integer
AS
$$
DECLARE
  p_id                 integer;
  p_objectclass_id     integer;
  p_nbr_of_rooms       integer;
  p_owner_name         character varying;
  p_ownership_type     character varying;
  p_usage_zone_id      integer;
--
  p_schema_name        varchar;
  inserted_id integer;
BEGIN
-- Pass values to internal prefixed variables to avoid potential homonymy issues
  p_id                 :=id;
  p_objectclass_id     :=objectclass_id;
  p_nbr_of_rooms       :=nbr_of_rooms;
  p_owner_name         :=owner_name;
  p_ownership_type     :=ownership_type;
  p_usage_zone_id      :=usage_zone_id;
  p_schema_name        :=schema_name;

EXECUTE format('
    INSERT INTO %I.nrg8_building_unit (
     id,
     objectclass_id,
     nbr_of_rooms,
     owner_name,
     ownership_type,
     usage_zone_id
    ) VALUES (
    %L, %L, %L, %L, %L, %L
    ) RETURNING id',
    p_schema_name,
    p_id,
    p_objectclass_id,
    p_nbr_of_rooms,
    p_owner_name,
    p_ownership_type,
    p_usage_zone_id
) INTO inserted_id;
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.nrg8_insert_building_unit (id: %): %', p_id, SQLERRM;
END;
$$
LANGUAGE 'plpgsql';

----------------------------------------------------------------
-- Function NRG8_INSERT_HOUSEHOLD
----------------------------------------------------------------
-- DROP FUNCTION IF EXISTS citydb_pkg.nrg8_insert_household (integer, integer, character varying, character varying, character varying, character varying, text, character varying, character varying, integer) CASCADE;
CREATE OR REPLACE FUNCTION citydb_pkg.nrg8_insert_household (
  objectclass_id       integer,
  id                   integer DEFAULT NULL,
  gmlid                character varying DEFAULT NULL,
  gmlid_codespace      character varying DEFAULT NULL,
  name                 character varying DEFAULT NULL,
  name_codespace       character varying DEFAULT NULL,
  description          text DEFAULT NULL,
  type                 character varying DEFAULT NULL,
  residence_type       character varying DEFAULT NULL,
  occupants_id         integer DEFAULT NULL,
  schema_name          varchar DEFAULT 'citydb'::varchar
)
RETURNS integer
AS
$$
DECLARE
  p_id                 integer;
  p_objectclass_id     integer;
  p_gmlid              character varying;
  p_gmlid_codespace    character varying;
  p_name               character varying;
  p_name_codespace     character varying;
  p_description        text;
  p_type               character varying;
  p_residence_type     character varying;
  p_occupants_id       integer;
--
  p_schema_name        varchar;
  seq_name varchar;
  inserted_id integer;
BEGIN
-- Pass values to internal prefixed variables to avoid potential homonymy issues
  p_id                 :=id;
  p_objectclass_id     :=objectclass_id;
  p_gmlid              :=gmlid;
  p_gmlid_codespace    :=gmlid_codespace;
  p_name               :=name;
  p_name_codespace     :=name_codespace;
  p_description        :=description;
  p_type               :=type;
  p_residence_type     :=residence_type;
  p_occupants_id       :=occupants_id;
  p_schema_name        :=schema_name;
-- IF the ID is not given, then generate a new one.
IF p_id IS NULL THEN
  seq_name=schema_name||'.nrg8_household_id_seq';
  p_id=nextval(seq_name::regclass);
END IF;
-- IF the GmlID is not given, then generate a new one.
IF p_gmlid IS NULL THEN
  p_gmlid='UUID_'||uuid_generate_v4();
END IF;

EXECUTE format('
    INSERT INTO %I.nrg8_household (
     id,
     objectclass_id,
     gmlid,
     gmlid_codespace,
     name,
     name_codespace,
     description,
     type,
     residence_type,
     occupants_id
    ) VALUES (
    %L, %L, %L, %L, %L, %L, %L, %L, %L, %L
    ) RETURNING id',
    p_schema_name,
    p_id,
    p_objectclass_id,
    p_gmlid,
    p_gmlid_codespace,
    p_name,
    p_name_codespace,
    p_description,
    p_type,
    p_residence_type,
    p_occupants_id
) INTO inserted_id;
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.nrg8_insert_household (id: %): %', p_id, SQLERRM;
END;
$$
LANGUAGE 'plpgsql';

----------------------------------------------------------------
-- Function NRG8_INSERT_EMITTER
----------------------------------------------------------------
-- DROP FUNCTION IF EXISTS citydb_pkg.nrg8_insert_emitter (integer, integer, character varying, integer, numeric, character varying, numeric, character varying, numeric, numeric, numeric, integer) CASCADE;
CREATE OR REPLACE FUNCTION citydb_pkg.nrg8_insert_emitter (
  objectclass_id            integer,
  id                        integer,
  type                      character varying DEFAULT NULL,
  unit_nbr                  integer DEFAULT NULL,
  inst_pwr                  numeric DEFAULT NULL,
  inst_pwr_unit             character varying DEFAULT NULL,
  therm_exch_tot_value      numeric DEFAULT NULL,
  therm_exch_tot_value_unit character varying DEFAULT NULL,
  therm_exch_conv           numeric DEFAULT NULL,
  therm_exch_rad            numeric DEFAULT NULL,
  therm_exch_lat            numeric DEFAULT NULL,
  distr_system_id           integer DEFAULT NULL,
  cityobject_id             integer DEFAULT NULL,
  schema_name               varchar DEFAULT 'citydb'::varchar
)
RETURNS integer
AS $$
DECLARE
  p_id                        integer;
  p_objectclass_id            integer;
  p_type                      character varying;
  p_unit_nbr                  integer;
  p_inst_pwr                  numeric;
  p_inst_pwr_unit             character varying;
  p_therm_exch_tot_value      numeric;
  p_therm_exch_tot_value_unit character varying;
  p_therm_exch_conv           numeric;
  p_therm_exch_rad            numeric;
  p_therm_exch_lat            numeric;
  p_cityobject_id             integer;
  p_distr_system_id           integer;
--
  p_schema_name        varchar;
  inserted_id integer;
BEGIN
-- Pass values to internal prefixed variables to avoid potential homonymy issues
  p_id                        :=id;
  p_objectclass_id            :=objectclass_id;
  p_type                      :=type;
  p_unit_nbr                  :=unit_nbr;
  p_inst_pwr                  :=inst_pwr;
  p_inst_pwr_unit             :=inst_pwr_unit;
  p_therm_exch_tot_value      :=therm_exch_tot_value;
  p_therm_exch_tot_value_unit :=therm_exch_tot_value_unit;
  p_therm_exch_conv           :=therm_exch_conv;
  p_therm_exch_rad            :=therm_exch_rad;
  p_therm_exch_lat            :=therm_exch_lat;
  p_distr_system_id           :=distr_system_id;
	p_cityobject_id             :=cityobject_id;
  p_schema_name               :=schema_name;


EXECUTE format('
    INSERT INTO %I.nrg8_emitter (
     id,
     objectclass_id,
     type,
     unit_nbr,
     inst_pwr,
     inst_pwr_unit,
     therm_exch_tot_value,
     therm_exch_tot_value_unit,
     therm_exch_conv,
     therm_exch_rad,
     therm_exch_lat,
     distr_system_id,
     cityobject_id
    ) VALUES (
    %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L
    ) RETURNING id',
    p_schema_name,
    p_id,
    p_objectclass_id,
    p_type,
    p_unit_nbr,
    p_inst_pwr,
    p_inst_pwr_unit,
    p_therm_exch_tot_value,
    p_therm_exch_tot_value_unit,
    p_therm_exch_conv,
    p_therm_exch_rad,
    p_therm_exch_lat,
    p_distr_system_id,
    p_cityobject_id
) INTO inserted_id;
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.nrg8_insert_emitter (id: %): %', p_id, SQLERRM;
END;
$$
LANGUAGE 'plpgsql';

----------------------------------------------------------------
-- Function NRG8_INSERT_POWER_DISTRIB_SYSTEM
----------------------------------------------------------------
-- DROP FUNCTION IF EXISTS citydb_pkg.nrg8_insert_power_distrib_system (integer, integer, numeric, character varying, numeric, character varying) CASCADE;
CREATE OR REPLACE FUNCTION citydb_pkg.nrg8_insert_power_distrib_system (
  objectclass_id       integer,
  id                   integer,
  current              numeric DEFAULT NULL,
  current_unit         character varying DEFAULT NULL,
  voltage              numeric DEFAULT NULL,
  voltage_unit         character varying DEFAULT NULL,
  schema_name          varchar DEFAULT 'citydb'::varchar
)
RETURNS integer
AS
$$
DECLARE
  p_id                 integer;
  p_objectclass_id     integer;
  p_current            numeric;
  p_current_unit       character varying;
  p_voltage            numeric;
  p_voltage_unit       character varying;
--
  p_schema_name        varchar;
  inserted_id integer;
BEGIN
-- Pass values to internal prefixed variables to avoid potential homonymy issues
  p_id                 :=id;
  p_objectclass_id     :=objectclass_id;
  p_current            :=current;
  p_current_unit       :=current_unit;
  p_voltage            :=voltage;
  p_voltage_unit       :=voltage_unit;
  p_schema_name        :=schema_name;


EXECUTE format('
    INSERT INTO %I.nrg8_power_distrib_system (
     id,
     objectclass_id,
     current,
     current_unit,
     voltage,
     voltage_unit
    ) VALUES (
    %L, %L, %L, %L, %L, %L
    ) RETURNING id',
    p_schema_name,
    p_id,
    p_objectclass_id,
    p_current,
    p_current_unit,
    p_voltage,
    p_voltage_unit
) INTO inserted_id;
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.nrg8_insert_power_distrib_system (id: %): %', p_id, SQLERRM;
END;
$$
LANGUAGE 'plpgsql';

----------------------------------------------------------------
-- Function NRG8_INSERT_THERMAL_STORAGE_SYSTEM
----------------------------------------------------------------
-- DROP FUNCTION IF EXISTS citydb_pkg.nrg8_insert_thermal_storage_system (integer, integer, character varying, numeric, character varying, numeric, character varying, numeric, character varying) CASCADE;
CREATE OR REPLACE FUNCTION citydb_pkg.nrg8_insert_thermal_storage_system (
  objectclass_id       integer,
  id                   integer,
  medium               character varying DEFAULT NULL,
  vol                  numeric DEFAULT NULL,
  vol_unit             character varying DEFAULT NULL,
  prep_temp            numeric DEFAULT NULL,
  prep_temp_unit       character varying DEFAULT NULL,
  therm_loss           numeric DEFAULT NULL,
  therm_loss_unit      character varying DEFAULT NULL,
  schema_name          varchar DEFAULT 'citydb'::varchar
)
RETURNS integer
AS
$$
DECLARE
  p_id                 integer;
  p_objectclass_id     integer;
  p_medium             character varying;
  p_vol                numeric;
  p_vol_unit           character varying;
  p_prep_temp          numeric;
  p_prep_temp_unit     character varying;
  p_therm_loss         numeric;
  p_therm_loss_unit    character varying;
--
  p_schema_name        varchar;
  inserted_id integer;
BEGIN
-- Pass values to internal prefixed variables to avoid potential homonymy issues
  p_id                 :=id;
  p_objectclass_id     :=objectclass_id;
  p_medium             :=medium;
  p_vol                :=vol;
  p_vol_unit           :=vol_unit;
  p_prep_temp          :=prep_temp;
  p_prep_temp_unit     :=prep_temp_unit;
  p_therm_loss         :=therm_loss;
  p_therm_loss_unit    :=therm_loss_unit;
  p_schema_name        :=schema_name;

EXECUTE format('
    INSERT INTO %I.nrg8_thermal_storage_system (
     id,
     objectclass_id,
     medium,
     vol,
     vol_unit,
     prep_temp,
     prep_temp_unit,
     therm_loss,
     therm_loss_unit
    ) VALUES (
    %L, %L, %L, %L, %L, %L, %L, %L, %L
    ) RETURNING id',
    p_schema_name,
    p_id,
    p_objectclass_id,
    p_medium,
    p_vol,
    p_vol_unit,
    p_prep_temp,
    p_prep_temp_unit,
    p_therm_loss,
    p_therm_loss_unit
) INTO inserted_id;
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.nrg8_insert_thermal_storage_system (id: %): %', p_id, SQLERRM;
END;
$$
LANGUAGE 'plpgsql';

----------------------------------------------------------------
-- Function NRG8_INSERT_POWER_STORAGE_SYSTEM
----------------------------------------------------------------
-- DROP FUNCTION IF EXISTS citydb_pkg.nrg8_insert_power_storage_system (integer, integer, character varying, numeric, character varying) CASCADE;
CREATE OR REPLACE FUNCTION citydb_pkg.nrg8_insert_power_storage_system (
  objectclass_id       integer,
  id                   integer,
  battery_techn        character varying DEFAULT NULL,
  pwr_capacity         numeric DEFAULT NULL,
  pwr_capacity_unit    character varying DEFAULT NULL,
  schema_name          varchar DEFAULT 'citydb'::varchar
)
RETURNS integer
AS
$$
DECLARE
  p_id                 integer;
  p_objectclass_id     integer;
  p_battery_techn      character varying;
  p_pwr_capacity       numeric;
  p_pwr_capacity_unit  character varying;
--
  p_schema_name        varchar;
  inserted_id integer;
BEGIN
-- Pass values to internal prefixed variables to avoid potential homonymy issues
  p_id                 :=id;
  p_objectclass_id     :=objectclass_id;
  p_battery_techn      :=battery_techn;
  p_pwr_capacity       :=pwr_capacity;
  p_pwr_capacity_unit  :=pwr_capacity_unit;
  p_schema_name        :=schema_name;


EXECUTE format('
    INSERT INTO %I.nrg8_power_storage_system (
     id,
     objectclass_id,
     battery_techn,
     pwr_capacity,
     pwr_capacity_unit
    ) VALUES (
    %L, %L, %L, %L, %L
    ) RETURNING id',
    p_schema_name,
    p_id,
    p_objectclass_id,
    p_battery_techn,
    p_pwr_capacity,
    p_pwr_capacity_unit
) INTO inserted_id;
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.nrg8_insert_power_storage_system (id: %): %', p_id, SQLERRM;
END;
$$
LANGUAGE 'plpgsql';

----------------------------------------------------------------
-- Function NRG8_INSERT_CONV_SYSTEM
----------------------------------------------------------------
-- DROP FUNCTION IF EXISTS citydb_pkg.nrg8_insert_conv_system (integer, integer, character varying, integer, integer, numeric, character varying, numeric, character varying, date, numeric, character varying, numeric, character varying, integer, integer) CASCADE;
CREATE OR REPLACE FUNCTION citydb_pkg.nrg8_insert_conv_system (
  objectclass_id       integer,
  id                   integer,
  model                character varying DEFAULT NULL,
  nbr                  integer DEFAULT NULL,
  year_of_manufacture  integer DEFAULT NULL,
  inst_nom_pwr         numeric DEFAULT NULL,
  inst_nom_pwr_unit    character varying DEFAULT NULL,
  nom_effcy            numeric DEFAULT NULL,
  effcy_indicator      character varying DEFAULT NULL,
  start_of_life        date DEFAULT NULL,
  life_expect_value    numeric DEFAULT NULL,
  life_expect_value_unit character varying DEFAULT NULL,
  main_maint_interval  numeric DEFAULT NULL,
  main_maint_interval_unit character varying DEFAULT NULL,
  inst_in_ctyobj_id    integer DEFAULT NULL,
  cityobject_id        integer DEFAULT NULL,
  schema_name          varchar DEFAULT 'citydb'::varchar
)
RETURNS integer
AS
$$
DECLARE
  p_id                 integer;
  p_objectclass_id     integer;
  p_model              character varying;
  p_nbr                integer;
  p_year_of_manufacture integer;
  p_inst_nom_pwr       numeric;
  p_inst_nom_pwr_unit  character varying;
  p_nom_effcy          numeric;
  p_effcy_indicator    character varying;
  p_start_of_life      date;
  p_life_expect_value  numeric;
  p_life_expect_value_unit character varying;
  p_main_maint_interval numeric;
  p_main_maint_interval_unit character varying;
  p_inst_in_ctyobj_id  integer;
  p_cityobject_id      integer;
--
  p_schema_name        varchar;
  inserted_id integer;
BEGIN
-- Pass values to internal prefixed variables to avoid potential homonymy issues
  p_id                 :=id;
  p_objectclass_id     :=objectclass_id;
  p_model              :=model;
  p_nbr                :=nbr;
  p_year_of_manufacture :=year_of_manufacture;
  p_inst_nom_pwr       :=inst_nom_pwr;
  p_inst_nom_pwr_unit  :=inst_nom_pwr_unit;
  p_nom_effcy          :=nom_effcy;
  p_effcy_indicator    :=effcy_indicator;
  p_start_of_life      :=start_of_life;
  p_life_expect_value  :=life_expect_value;
  p_life_expect_value_unit :=life_expect_value_unit;
  p_main_maint_interval :=main_maint_interval;
  p_main_maint_interval_unit :=main_maint_interval_unit;
  p_inst_in_ctyobj_id  :=inst_in_ctyobj_id;
  p_cityobject_id      :=cityobject_id;
  p_schema_name        :=schema_name;


EXECUTE format('
    INSERT INTO %I.nrg8_conv_system (
     id,
     objectclass_id,
     model,
     nbr,
     year_of_manufacture,
     inst_nom_pwr,
     inst_nom_pwr_unit,
     nom_effcy,
     effcy_indicator,
     start_of_life,
     life_expect_value,
     life_expect_value_unit,
     main_maint_interval,
     main_maint_interval_unit,
     inst_in_ctyobj_id,
     cityobject_id
    ) VALUES (
    %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L
    ) RETURNING id',
    p_schema_name,
    p_id,
    p_objectclass_id,
    p_model,
    p_nbr,
    p_year_of_manufacture,
    p_inst_nom_pwr,
    p_inst_nom_pwr_unit,
    p_nom_effcy,
    p_effcy_indicator,
    p_start_of_life,
    p_life_expect_value,
    p_life_expect_value_unit,
    p_main_maint_interval,
    p_main_maint_interval_unit,
    p_inst_in_ctyobj_id,
    p_cityobject_id
) INTO inserted_id;
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.nrg8_insert_conv_system (id: %): %', p_id, SQLERRM;
END;
$$
LANGUAGE 'plpgsql';

----------------------------------------------------------------
-- Function NRG8_INSERT_BOILER
----------------------------------------------------------------
-- DROP FUNCTION IF EXISTS citydb_pkg.nrg8_insert_boiler (integer, integer, numeric) CASCADE;
CREATE OR REPLACE FUNCTION citydb_pkg.nrg8_insert_boiler (
  objectclass_id       integer,
  id                   integer,
  condensation         numeric DEFAULT NULL,
  schema_name          varchar DEFAULT 'citydb'::varchar
)
RETURNS integer
AS
$$
DECLARE
  p_id                 integer;
  p_objectclass_id     integer;
  p_condensation       numeric;
--
  p_schema_name        varchar;
  inserted_id integer;
BEGIN
-- Pass values to internal prefixed variables to avoid potential homonymy issues
  p_id                 :=id;
  p_objectclass_id     :=objectclass_id;
  p_condensation       :=condensation;
  p_schema_name        :=schema_name;


EXECUTE format('
    INSERT INTO %I.nrg8_boiler (
     id,
     objectclass_id,
     condensation
    ) VALUES (
    %L, %L, %L
    ) RETURNING id',
    p_schema_name,
    p_id,
    p_objectclass_id,
    p_condensation
) INTO inserted_id;
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.nrg8_insert_boiler (id: %): %', p_id, SQLERRM;
END;
$$
LANGUAGE 'plpgsql';

----------------------------------------------------------------
-- Function NRG8_INSERT_USAGE_ZONE
----------------------------------------------------------------
-- DROP FUNCTION IF EXISTS citydb_pkg.nrg8_insert_usage_zone (integer, integer, character varying, character varying, integer, numeric, character varying, numeric, numeric, numeric, integer, integer, integer, integer, integer, integer, geometry) CASCADE;
CREATE OR REPLACE FUNCTION citydb_pkg.nrg8_insert_usage_zone (
  objectclass_id       integer,
  id                   integer,
  type                 character varying DEFAULT NULL,
  type_codespace       character varying DEFAULT NULL,
  used_floors          integer DEFAULT NULL,
  int_gains_tot_value  numeric DEFAULT NULL,
  int_gains_tot_value_unit character varying DEFAULT NULL,
  int_gains_conv       numeric DEFAULT NULL,
  int_gains_lat        numeric DEFAULT NULL,
  int_gains_rad        numeric DEFAULT NULL,
  heat_sched_id        integer DEFAULT NULL,
  cool_sched_id        integer DEFAULT NULL,
  vent_sched_id        integer DEFAULT NULL,
  therm_zone_id        integer DEFAULT NULL,
  building_id          integer DEFAULT NULL,
  solid_id             integer DEFAULT NULL,
  multi_surf_geom      geometry DEFAULT NULL,
  schema_name          varchar DEFAULT 'citydb'::varchar
)
RETURNS integer
AS
$$
DECLARE
  p_id                 integer;
  p_objectclass_id     integer;
  p_type               character varying;
  p_type_codespace     character varying;
  p_used_floors        integer;
  p_int_gains_tot_value numeric;
  p_int_gains_tot_value_unit character varying;
  p_int_gains_conv     numeric;
  p_int_gains_lat      numeric;
  p_int_gains_rad      numeric;
  p_heat_sched_id      integer;
  p_cool_sched_id      integer;
  p_vent_sched_id      integer;
  p_therm_zone_id      integer;
  p_building_id        integer;
  p_solid_id           integer;
  p_multi_surf_geom    geometry;
--
  p_schema_name        varchar;
  inserted_id integer;
BEGIN
-- Pass values to internal prefixed variables to avoid potential homonymy issues
  p_id                 :=id;
  p_objectclass_id     :=objectclass_id;
  p_type               :=type;
  p_type_codespace     :=type_codespace;
  p_used_floors        :=used_floors;
  p_int_gains_tot_value :=int_gains_tot_value;
  p_int_gains_tot_value_unit :=int_gains_tot_value_unit;
  p_int_gains_conv     :=int_gains_conv;
  p_int_gains_lat      :=int_gains_lat;
  p_int_gains_rad      :=int_gains_rad;
  p_heat_sched_id      :=heat_sched_id;
  p_cool_sched_id      :=cool_sched_id;
  p_vent_sched_id      :=vent_sched_id;
  p_therm_zone_id      :=therm_zone_id;
  p_building_id        :=building_id;
  p_solid_id           :=solid_id;
  p_multi_surf_geom    :=multi_surf_geom;
  p_schema_name        :=schema_name;

EXECUTE format('
    INSERT INTO %I.nrg8_usage_zone (
     id,
     objectclass_id,
     type,
     type_codespace,
     used_floors,
     int_gains_tot_value,
     int_gains_tot_value_unit,
     int_gains_conv,
     int_gains_lat,
     int_gains_rad,
     heat_sched_id,
     cool_sched_id,
     vent_sched_id,
     therm_zone_id,
     building_id,
     solid_id,
     multi_surf_geom
    ) VALUES (
    %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L
    ) RETURNING id',
    p_schema_name,
    p_id,
    p_objectclass_id,
    p_type,
    p_type_codespace,
    p_used_floors,
    p_int_gains_tot_value,
    p_int_gains_tot_value_unit,
    p_int_gains_conv,
    p_int_gains_lat,
    p_int_gains_rad,
    p_heat_sched_id,
    p_cool_sched_id,
    p_vent_sched_id,
    p_therm_zone_id,
    p_building_id,
    p_solid_id,
    p_multi_surf_geom
) INTO inserted_id;
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.nrg8_insert_usage_zone (id: %): %', p_id, SQLERRM;
END;
$$
LANGUAGE 'plpgsql';

----------------------------------------------------------------
-- Function NRG8_INSERT_THERMAL_OPENING
----------------------------------------------------------------
-- DROP FUNCTION IF EXISTS citydb_pkg.nrg8_insert_thermal_opening (integer, integer, numeric, character varying, numeric, character varying, numeric, numeric, character varying, character varying, numeric, numeric, character varying, integer, integer, geometry) CASCADE;
CREATE OR REPLACE FUNCTION citydb_pkg.nrg8_insert_thermal_opening (
  objectclass_id       integer,
  id                   integer,
  area                 numeric DEFAULT NULL,
  area_unit            character varying DEFAULT NULL,
  openable_ratio       numeric DEFAULT NULL,
  in_shad_name         character varying DEFAULT NULL,
  in_shad_max_cover_ratio numeric DEFAULT NULL,
  in_shad_transmission numeric DEFAULT NULL,
  in_shad_transmission_range character varying DEFAULT NULL,
  out_shad_name        character varying DEFAULT NULL,
  out_shad_max_cover_ratio numeric DEFAULT NULL,
  out_shad_transmittance numeric DEFAULT NULL,
  out_shad_transmittance_range character varying DEFAULT NULL,
  therm_boundary_id    integer DEFAULT NULL,
  multi_surf_id        integer DEFAULT NULL,
  multi_surf_geom      geometry DEFAULT NULL,
  schema_name          varchar DEFAULT 'citydb'::varchar
)
RETURNS integer
AS
$$
DECLARE
  p_id                 integer;
  p_objectclass_id     integer;
  p_area               numeric;
  p_area_unit          character varying;
  p_openable_ratio     numeric;
  p_in_shad_name       character varying;
  p_in_shad_max_cover_ratio numeric;
  p_in_shad_transmission numeric;
  p_in_shad_transmission_range character varying;
  p_out_shad_name      character varying;
  p_out_shad_max_cover_ratio numeric;
  p_out_shad_transmittance numeric;
  p_out_shad_transmittance_range character varying;
  p_therm_boundary_id  integer;
  p_multi_surf_id      integer;
  p_multi_surf_geom    geometry;
--
  p_schema_name        varchar;
  inserted_id integer;
BEGIN
-- Pass values to internal prefixed variables to avoid potential homonymy issues
  p_id                 :=id;
  p_objectclass_id     :=objectclass_id;
  p_area               :=area;
  p_area_unit          :=area_unit;
  p_openable_ratio     :=openable_ratio;
  p_in_shad_name       :=in_shad_name;
  p_in_shad_max_cover_ratio :=in_shad_max_cover_ratio;
  p_in_shad_transmission :=in_shad_transmission;
  p_in_shad_transmission_range :=in_shad_transmission_range;
  p_out_shad_name      :=out_shad_name;
  p_out_shad_max_cover_ratio :=out_shad_max_cover_ratio;
  p_out_shad_transmittance :=out_shad_transmittance;
  p_out_shad_transmittance_range :=out_shad_transmittance_range;
  p_therm_boundary_id  :=therm_boundary_id;
  p_multi_surf_id      :=multi_surf_id;
  p_multi_surf_geom    :=multi_surf_geom;
  p_schema_name        :=schema_name;

EXECUTE format('
    INSERT INTO %I.nrg8_thermal_opening (
     id,
     objectclass_id,
     area,
     area_unit,
     openable_ratio,
     in_shad_name,
     in_shad_max_cover_ratio,
     in_shad_transmission,
     in_shad_transmission_range,
     out_shad_name,
     out_shad_max_cover_ratio,
     out_shad_transmittance,
     out_shad_transmittance_range,
     therm_boundary_id,
     multi_surf_id,
     multi_surf_geom
    ) VALUES (
    %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L
    ) RETURNING id',
    p_schema_name,
    p_id,
    p_objectclass_id,
    p_area,
    p_area_unit,
    p_openable_ratio,
    p_in_shad_name,
    p_in_shad_max_cover_ratio,
    p_in_shad_transmission,
    p_in_shad_transmission_range,
    p_out_shad_name,
    p_out_shad_max_cover_ratio,
    p_out_shad_transmittance,
    p_out_shad_transmittance_range,
    p_therm_boundary_id,
    p_multi_surf_id,
    p_multi_surf_geom
) INTO inserted_id;
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.nrg8_insert_thermal_opening (id: %): %', p_id, SQLERRM;
END;
$$
LANGUAGE 'plpgsql';

----------------------------------------------------------------
-- Function NRG8_INSERT_THERMAL_BOUNDARY
----------------------------------------------------------------
-- DROP FUNCTION IF EXISTS citydb_pkg.nrg8_insert_thermal_boundary (integer, integer, character varying, numeric, character varying, numeric, character varying, numeric, character varying, integer, integer, integer, geometry) CASCADE;
CREATE OR REPLACE FUNCTION citydb_pkg.nrg8_insert_thermal_boundary (
  objectclass_id       integer,
  id                   integer,
  type                 character varying DEFAULT NULL,
  azimuth              numeric DEFAULT NULL,
  azimuth_unit         character varying DEFAULT NULL,
  inclination          numeric DEFAULT NULL,
  inclination_unit     character varying DEFAULT NULL,
  area                 numeric DEFAULT NULL,
  area_unit            character varying DEFAULT NULL,
  therm_zone1_id       integer DEFAULT NULL,
  therm_zone2_id       integer DEFAULT NULL,
  multi_surf_id        integer DEFAULT NULL,
  multi_surf_geom      geometry DEFAULT NULL,
  schema_name          varchar DEFAULT 'citydb'::varchar
)
RETURNS integer
AS
$$
DECLARE
  p_id                 integer;
  p_objectclass_id     integer;
  p_type               character varying;
  p_azimuth            numeric;
  p_azimuth_unit       character varying;
  p_inclination        numeric;
  p_inclination_unit   character varying;
  p_area               numeric;
  p_area_unit          character varying;
  p_therm_zone1_id     integer;
  p_therm_zone2_id     integer;
  p_multi_surf_id      integer;
  p_multi_surf_geom    geometry;
--
  p_schema_name        varchar;
  inserted_id integer;
BEGIN
-- Pass values to internal prefixed variables to avoid potential homonymy issues
  p_id                 :=id;
  p_objectclass_id     :=objectclass_id;
  p_type               :=type;
  p_azimuth            :=azimuth;
  p_azimuth_unit       :=azimuth_unit;
  p_inclination        :=inclination;
  p_inclination_unit   :=inclination_unit;
  p_area               :=area;
  p_area_unit          :=area_unit;
  p_therm_zone1_id     :=therm_zone1_id;
  p_therm_zone2_id     :=therm_zone2_id;
  p_multi_surf_id      :=multi_surf_id;
  p_multi_surf_geom    :=multi_surf_geom;
  p_schema_name        :=schema_name;

EXECUTE format('
    INSERT INTO %I.nrg8_thermal_boundary (
     id,
     objectclass_id,
     type,
     azimuth,
     azimuth_unit,
     inclination,
     inclination_unit,
     area,
     area_unit,
     therm_zone1_id,
     therm_zone2_id,
     multi_surf_id,
     multi_surf_geom
    ) VALUES (
    %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L
    ) RETURNING id',
    p_schema_name,
    p_id,
    p_objectclass_id,
    p_type,
    p_azimuth,
    p_azimuth_unit,
    p_inclination,
    p_inclination_unit,
    p_area,
    p_area_unit,
    p_therm_zone1_id,
    p_therm_zone2_id,
    p_multi_surf_id,
    p_multi_surf_geom
) INTO inserted_id;
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.nrg8_insert_thermal_boundary (id: %): %', p_id, SQLERRM;
END;
$$
LANGUAGE 'plpgsql';

----------------------------------------------------------------
-- Function NRG8_INSERT_CONV_SYS_TO_FINAL_NRG
----------------------------------------------------------------
-- DROP FUNCTION IF EXISTS citydb_pkg.nrg8_insert_conv_sys_to_final_nrg (integer, integer, character varying) CASCADE;
CREATE OR REPLACE FUNCTION citydb_pkg.nrg8_insert_conv_sys_to_final_nrg (
  conv_system_id       integer,
  final_nrg_id         integer,
  role                 character varying DEFAULT NULL,
  schema_name          varchar DEFAULT 'citydb'::varchar
)
RETURNS void
AS
$$
DECLARE
  p_conv_system_id     integer;
  p_final_nrg_id       integer;
  p_role               character varying;
--
  p_schema_name        varchar;
BEGIN
-- Pass values to internal prefixed variables to avoid potential homonymy issues
  p_conv_system_id     :=conv_system_id;
  p_final_nrg_id       :=final_nrg_id;
  p_role               :=role;
  p_schema_name        :=schema_name;

EXECUTE format('
    INSERT INTO %I.nrg8_conv_sys_to_final_nrg (
     conv_system_id,
     final_nrg_id,
     role
    ) VALUES (
    %L, %L, %L
    )',
    p_schema_name,
    p_conv_system_id,
    p_final_nrg_id,
    p_role
);
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.nrg8_insert_conv_sys_to_final_nrg (conv_system_id: %, final_nrg_id: %): %', conv_system_id, final_nrg_id, SQLERRM;
END;
$$
LANGUAGE 'plpgsql';

----------------------------------------------------------------
-- Function NRG8_INSERT_STORAGE_SYSTEM
----------------------------------------------------------------
-- DROP FUNCTION IF EXISTS citydb_pkg.nrg8_insert_storage_system (integer, integer, date, numeric, character varying, numeric, character varying, integer, integer) CASCADE;
CREATE OR REPLACE FUNCTION citydb_pkg.nrg8_insert_storage_system (
  objectclass_id       integer,
  id                   integer,
  start_of_life        date DEFAULT NULL,
  life_expect_value    numeric DEFAULT NULL,
  life_expect_value_unit character varying DEFAULT NULL,
  main_maint_interval  numeric DEFAULT NULL,
  main_maint_interval_unit character varying DEFAULT NULL,
  nrg_demand_id        integer DEFAULT NULL,
  cityobject_id        integer DEFAULT NULL,
  schema_name          varchar DEFAULT 'citydb'::varchar
)
RETURNS integer
AS
$$
DECLARE
  p_id                 integer;
  p_objectclass_id     integer;
  p_start_of_life      date;
  p_life_expect_value  numeric;
  p_life_expect_value_unit character varying;
  p_main_maint_interval numeric;
  p_main_maint_interval_unit character varying;
  p_nrg_demand_id      integer;
  p_cityobject_id      integer;
--
  p_schema_name        varchar;
  inserted_id integer;
BEGIN
-- Pass values to internal prefixed variables to avoid potential homonymy issues
  p_id                 :=id;
  p_objectclass_id     :=objectclass_id;
  p_start_of_life      :=start_of_life;
  p_life_expect_value  :=life_expect_value;
  p_life_expect_value_unit :=life_expect_value_unit;
  p_main_maint_interval :=main_maint_interval;
  p_main_maint_interval_unit :=main_maint_interval_unit;
  p_nrg_demand_id      :=nrg_demand_id;
  p_cityobject_id      :=cityobject_id;
  p_schema_name        :=schema_name;


EXECUTE format('
    INSERT INTO %I.nrg8_storage_system (
     id,
     objectclass_id,
     start_of_life,
     life_expect_value,
     life_expect_value_unit,
     main_maint_interval,
     main_maint_interval_unit,
     nrg_demand_id,
     cityobject_id
    ) VALUES (
    %L, %L, %L, %L, %L, %L, %L, %L, %L
    ) RETURNING id',
    p_schema_name,
    p_id,
    p_objectclass_id,
    p_start_of_life,
    p_life_expect_value,
    p_life_expect_value_unit,
    p_main_maint_interval,
    p_main_maint_interval_unit,
    p_nrg_demand_id,
    p_cityobject_id
) INTO inserted_id;
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.nrg8_insert_storage_system (id: %): %', p_id, SQLERRM;
END;
$$
LANGUAGE 'plpgsql';

----------------------------------------------------------------
-- Function NRG8_INSERT_BDG_UNIT_TO_ADDRESS
----------------------------------------------------------------
-- DROP FUNCTION IF EXISTS citydb_pkg.nrg8_insert_bdg_unit_to_address (integer, integer) CASCADE;
CREATE OR REPLACE FUNCTION citydb_pkg.nrg8_insert_bdg_unit_to_address (
  building_unit_id     integer,
  address_id           integer,
  schema_name          varchar DEFAULT 'citydb'::varchar
)
RETURNS void
AS
$$
DECLARE
  p_building_unit_id   integer;
  p_address_id         integer;
--
  p_schema_name        varchar;
BEGIN
-- Pass values to internal prefixed variables to avoid potential homonymy issues
  p_building_unit_id   :=building_unit_id;
  p_address_id         :=address_id;
  p_schema_name        :=schema_name;

EXECUTE format('
    INSERT INTO %I.nrg8_bdg_unit_to_address (
     building_unit_id,
     address_id
    ) VALUES (
    %L, %L
    )',
    p_schema_name,
    p_building_unit_id,
    p_address_id
);
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.nrg8_insert_bdg_unit_to_address (building_unit_id: %, address_id: %): %', building_unit_id, address_id, SQLERRM;
END;
$$
LANGUAGE 'plpgsql';

----------------------------------------------------------------
-- Function NRG8_INSERT_THERM_BDRY_TO_THEM_SURF
----------------------------------------------------------------
-- DROP FUNCTION IF EXISTS citydb_pkg.nrg8_insert_therm_bdry_to_them_surf (integer, integer) CASCADE;
CREATE OR REPLACE FUNCTION citydb_pkg.nrg8_insert_therm_bdry_to_them_surf (
  therm_boundary_id    integer,
  them_surf_id         integer,
  schema_name          varchar DEFAULT 'citydb'::varchar
)
RETURNS void
AS
$$
DECLARE
  p_therm_boundary_id  integer;
  p_them_surf_id       integer;
--
  p_schema_name        varchar;
BEGIN
-- Pass values to internal prefixed variables to avoid potential homonymy issues
  p_therm_boundary_id  :=therm_boundary_id;
  p_them_surf_id       :=them_surf_id;
  p_schema_name        :=schema_name;

EXECUTE format('
    INSERT INTO %I.nrg8_therm_bdry_to_them_surf (
     therm_boundary_id,
     them_surf_id
    ) VALUES (
    %L, %L
    )',
    p_schema_name,
    p_therm_boundary_id,
    p_them_surf_id
);
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.nrg8_insert_therm_bdry_to_them_surf (therm_boundary_id: %, them_surf_id: %): %', therm_boundary_id, them_surf_id, SQLERRM;
END;
$$
LANGUAGE 'plpgsql';

----------------------------------------------------------------
-- Function NRG8_INSERT_THERMAL_ZONE_TO_ROOM
----------------------------------------------------------------
-- DROP FUNCTION IF EXISTS citydb_pkg.nrg8_insert_thermal_zone_to_room (integer, integer) CASCADE;
CREATE OR REPLACE FUNCTION citydb_pkg.nrg8_insert_thermal_zone_to_room (
  therm_zone_id        integer,
  room_id              integer,
  schema_name          varchar DEFAULT 'citydb'::varchar
)
RETURNS void
AS
$$
DECLARE
  p_therm_zone_id      integer;
  p_room_id            integer;
--
  p_schema_name        varchar;
BEGIN
-- Pass values to internal prefixed variables to avoid potential homonymy issues
  p_therm_zone_id      :=therm_zone_id;
  p_room_id            :=room_id;
  p_schema_name        :=schema_name;

EXECUTE format('
    INSERT INTO %I.nrg8_thermal_zone_to_room (
     therm_zone_id,
     room_id
    ) VALUES (
    %L, %L
    )',
    p_schema_name,
    p_therm_zone_id,
    p_room_id
);
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.nrg8_insert_thermal_zone_to_room (therm_zone_id: %, room_id: %): %', therm_zone_id, room_id, SQLERRM;
END;
$$
LANGUAGE 'plpgsql';

----------------------------------------------------------------
-- Function NRG8_INSERT_THERMAL_DISTRIB_SYSTEM
----------------------------------------------------------------
-- DROP FUNCTION IF EXISTS citydb_pkg.nrg8_insert_thermal_distrib_system (integer, integer, numeric, character varying, numeric, character varying, numeric, character varying, numeric, character varying, numeric, character varying) CASCADE;
CREATE OR REPLACE FUNCTION citydb_pkg.nrg8_insert_thermal_distrib_system (
  objectclass_id       integer,
  id                   integer,
  has_circulation      numeric DEFAULT NULL,
  medium               character varying DEFAULT NULL,
  nom_flow             numeric DEFAULT NULL,
  nom_flow_unit        character varying DEFAULT NULL,
  supply_temp          numeric DEFAULT NULL,
  supply_temp_unit     character varying DEFAULT NULL,
  return_temp          numeric DEFAULT NULL,
  return_temp_unit     character varying DEFAULT NULL,
  therm_loss           numeric DEFAULT NULL,
  therm_loss_unit      character varying DEFAULT NULL,
  schema_name          varchar DEFAULT 'citydb'::varchar
)
RETURNS integer
AS
$$
DECLARE
  p_id                 integer;
  p_objectclass_id     integer;
  p_has_circulation    numeric;
  p_medium             character varying;
  p_nom_flow           numeric;
  p_nom_flow_unit      character varying;
  p_supply_temp        numeric;
  p_supply_temp_unit   character varying;
  p_return_temp        numeric;
  p_return_temp_unit   character varying;
  p_therm_loss         numeric;
  p_therm_loss_unit    character varying;
--
  p_schema_name        varchar;
  inserted_id integer;
BEGIN
-- Pass values to internal prefixed variables to avoid potential homonymy issues
  p_id                 :=id;
  p_objectclass_id     :=objectclass_id;
  p_has_circulation    :=has_circulation;
  p_medium             :=medium;
  p_nom_flow           :=nom_flow;
  p_nom_flow_unit      :=nom_flow_unit;
  p_supply_temp        :=supply_temp;
  p_supply_temp_unit   :=supply_temp_unit;
  p_return_temp        :=return_temp;
  p_return_temp_unit   :=return_temp_unit;
  p_therm_loss         :=therm_loss;
  p_therm_loss_unit    :=therm_loss_unit;
  p_schema_name        :=schema_name;


EXECUTE format('
    INSERT INTO %I.nrg8_thermal_distrib_system (
     id,
     objectclass_id,
     has_circulation,
     medium,
     nom_flow,
     nom_flow_unit,
     supply_temp,
     supply_temp_unit,
     return_temp,
     return_temp_unit,
     therm_loss,
     therm_loss_unit
    ) VALUES (
    %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L
    ) RETURNING id',
    p_schema_name,
    p_id,
    p_objectclass_id,
    p_has_circulation,
    p_medium,
    p_nom_flow,
    p_nom_flow_unit,
    p_supply_temp,
    p_supply_temp_unit,
    p_return_temp,
    p_return_temp_unit,
    p_therm_loss,
    p_therm_loss_unit
) INTO inserted_id;
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.nrg8_insert_thermal_distrib_system (id: %): %', p_id, SQLERRM;
END;
$$
LANGUAGE 'plpgsql';

----------------------------------------------------------------
-- Function NRG8_INSERT_LAYER_COMPONENT
----------------------------------------------------------------
-- DROP FUNCTION IF EXISTS citydb_pkg.nrg8_insert_layer_component (integer, integer, character varying, character varying, character varying, character varying, text, numeric, numeric, character varying, date, numeric, character varying, numeric, character varying, integer) CASCADE;
CREATE OR REPLACE FUNCTION citydb_pkg.nrg8_insert_layer_component (
  objectclass_id       integer,
  id                   integer DEFAULT NULL,
  gmlid                character varying DEFAULT NULL,
  gmlid_codespace      character varying DEFAULT NULL,
  name                 character varying DEFAULT NULL,
  name_codespace       character varying DEFAULT NULL,
  description          text DEFAULT NULL,
  area_fr              numeric DEFAULT NULL,
  thickness            numeric DEFAULT NULL,
  thickness_unit       character varying DEFAULT NULL,
  start_of_life        date DEFAULT NULL,
  life_expect_value    numeric DEFAULT NULL,
  life_expect_value_unit character varying DEFAULT NULL,
  main_maint_interval  numeric DEFAULT NULL,
  main_maint_interval_unit character varying DEFAULT NULL,
  layer_id             integer DEFAULT NULL,
  schema_name          varchar DEFAULT 'citydb'::varchar
)
RETURNS integer
AS
$$
DECLARE
  p_id                 integer;
  p_objectclass_id     integer;
  p_gmlid              character varying;
  p_gmlid_codespace    character varying;
  p_name               character varying;
  p_name_codespace     character varying;
  p_description        text;
  p_area_fr            numeric;
  p_thickness          numeric;
  p_thickness_unit     character varying;
  p_start_of_life      date;
  p_life_expect_value  numeric;
  p_life_expect_value_unit character varying;
  p_main_maint_interval numeric;
  p_main_maint_interval_unit character varying;
  p_layer_id           integer;
--
  p_schema_name        varchar;
  seq_name varchar;
  inserted_id integer;
BEGIN
-- Pass values to internal prefixed variables to avoid potential homonymy issues
  p_id                 :=id;
  p_objectclass_id     :=objectclass_id;
  p_gmlid              :=gmlid;
  p_gmlid_codespace    :=gmlid_codespace;
  p_name               :=name;
  p_name_codespace     :=name_codespace;
  p_description        :=description;
  p_area_fr            :=area_fr;
  p_thickness          :=thickness;
  p_thickness_unit     :=thickness_unit;
  p_start_of_life      :=start_of_life;
  p_life_expect_value  :=life_expect_value;
  p_life_expect_value_unit :=life_expect_value_unit;
  p_main_maint_interval :=main_maint_interval;
  p_main_maint_interval_unit :=main_maint_interval_unit;
  p_layer_id           :=layer_id;
  p_schema_name        :=schema_name;
-- IF the ID is not given, then generate a new one.
IF p_id IS NULL THEN
  seq_name=schema_name||'.nrg8_layer_component_id_seq';
  p_id=nextval(seq_name::regclass);
END IF;
-- IF the GmlID is not given, then generate a new one.
IF p_gmlid IS NULL THEN
  p_gmlid='UUID_'||uuid_generate_v4();
END IF;

EXECUTE format('
    INSERT INTO %I.nrg8_layer_component (
     id,
     objectclass_id,
     gmlid,
     gmlid_codespace,
     name,
     name_codespace,
     description,
     area_fr,
     thickness,
     thickness_unit,
     start_of_life,
     life_expect_value,
     life_expect_value_unit,
     main_maint_interval,
     main_maint_interval_unit,
     layer_id
    ) VALUES (
    %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L
    ) RETURNING id',
    p_schema_name,
    p_id,
    p_objectclass_id,
    p_gmlid,
    p_gmlid_codespace,
    p_name,
    p_name_codespace,
    p_description,
    p_area_fr,
    p_thickness,
    p_thickness_unit,
    p_start_of_life,
    p_life_expect_value,
    p_life_expect_value_unit,
    p_main_maint_interval,
    p_main_maint_interval_unit,
    p_layer_id
) INTO inserted_id;
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.nrg8_insert_layer_component (id: %): %', p_id, SQLERRM;
END;
$$
LANGUAGE 'plpgsql';

----------------------------------------------------------------
-- Function NRG8_INSERT_SOLAR_SYSTEM
----------------------------------------------------------------
-- DROP FUNCTION IF EXISTS citydb_pkg.nrg8_insert_solar_system (integer, integer, character varying, character varying, numeric, character varying, numeric, character varying, numeric, numeric, numeric, integer, integer, integer, geometry) CASCADE;
CREATE OR REPLACE FUNCTION citydb_pkg.nrg8_insert_solar_system (
  objectclass_id       integer,
  id                   integer,
  collector_type       character varying DEFAULT NULL,
  cell_type            character varying DEFAULT NULL,
  module_area          numeric DEFAULT NULL,
  module_area_unit     character varying DEFAULT NULL,
  aperture_area        numeric DEFAULT NULL,
  aperture_area_unit   character varying DEFAULT NULL,
  eta0                 numeric DEFAULT NULL,
  a1                   numeric DEFAULT NULL,
  a2                   numeric DEFAULT NULL,
  them_surf_id         integer DEFAULT NULL,
  building_inst_id     integer DEFAULT NULL,
  multi_surf_id        integer DEFAULT NULL,
  multi_surf_geom      geometry DEFAULT NULL,
  schema_name          varchar DEFAULT 'citydb'::varchar
)
RETURNS integer
AS
$$
DECLARE
  p_id                 integer;
  p_objectclass_id     integer;
  p_collector_type     character varying;
  p_cell_type          character varying;
  p_module_area        numeric;
  p_module_area_unit   character varying;
  p_aperture_area      numeric;
  p_aperture_area_unit character varying;
  p_eta0               numeric;
  p_a1                 numeric;
  p_a2                 numeric;
  p_them_surf_id       integer;
  p_building_inst_id   integer;
  p_multi_surf_id      integer;
  p_multi_surf_geom    geometry;
--
  p_schema_name        varchar;
  inserted_id integer;
BEGIN
-- Pass values to internal prefixed variables to avoid potential homonymy issues
  p_id                 :=id;
  p_objectclass_id     :=objectclass_id;
  p_collector_type     :=collector_type;
  p_cell_type          :=cell_type;
  p_module_area        :=module_area;
  p_module_area_unit   :=module_area_unit;
  p_aperture_area      :=aperture_area;
  p_aperture_area_unit :=aperture_area_unit;
  p_eta0               :=eta0;
  p_a1                 :=a1;
  p_a2                 :=a2;
  p_them_surf_id       :=them_surf_id;
  p_building_inst_id   :=building_inst_id;
  p_multi_surf_id      :=multi_surf_id;
  p_multi_surf_geom    :=multi_surf_geom;
  p_schema_name        :=schema_name;


EXECUTE format('
    INSERT INTO %I.nrg8_solar_system (
     id,
     objectclass_id,
     collector_type,
     cell_type,
     module_area,
     module_area_unit,
     aperture_area,
     aperture_area_unit,
     eta0,
     a1,
     a2,
     them_surf_id,
     building_inst_id,
     multi_surf_id,
     multi_surf_geom
    ) VALUES (
    %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L
    ) RETURNING id',
    p_schema_name,
    p_id,
    p_objectclass_id,
    p_collector_type,
    p_cell_type,
    p_module_area,
    p_module_area_unit,
    p_aperture_area,
    p_aperture_area_unit,
    p_eta0,
    p_a1,
    p_a2,
    p_them_surf_id,
    p_building_inst_id,
    p_multi_surf_id,
    p_multi_surf_geom
) INTO inserted_id;
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.nrg8_insert_solar_system (id: %): %', p_id, SQLERRM;
END;
$$
LANGUAGE 'plpgsql';

----------------------------------------------------------------
-- Function NRG8_INSERT_THERM_OPEN_TO_OPEN
----------------------------------------------------------------
-- DROP FUNCTION IF EXISTS citydb_pkg.nrg8_insert_therm_open_to_open (integer, integer) CASCADE;
CREATE OR REPLACE FUNCTION citydb_pkg.nrg8_insert_therm_open_to_open (
  therm_opening_id     integer,
  opening_id           integer,
  schema_name          varchar DEFAULT 'citydb'::varchar
)
RETURNS void
AS
$$
DECLARE
  p_therm_opening_id   integer;
  p_opening_id         integer;
--
  p_schema_name        varchar;
BEGIN
-- Pass values to internal prefixed variables to avoid potential homonymy issues
  p_therm_opening_id   :=therm_opening_id;
  p_opening_id         :=opening_id;
  p_schema_name        :=schema_name;

EXECUTE format('
    INSERT INTO %I.nrg8_therm_open_to_open (
     therm_opening_id,
     opening_id
    ) VALUES (
    %L, %L
    )',
    p_schema_name,
    p_therm_opening_id,
    p_opening_id
);
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.nrg8_insert_thermal_zone_to_room (therm_opening_id: %, room_id: %): %', therm_opening_id, opening_id, SQLERRM;
END;
$$
LANGUAGE 'plpgsql';

----------------------------------------------------------------
-- Function NRG8_INSERT_MATERIAL
----------------------------------------------------------------
-- DROP FUNCTION IF EXISTS citydb_pkg.nrg8_insert_material (integer, integer, character varying, character varying, character varying, character varying, text, numeric, numeric, character varying, numeric, character varying, numeric, character varying, numeric, character varying, numeric, character varying, numeric, numeric, character varying, numeric, character varying, integer) CASCADE;
CREATE OR REPLACE FUNCTION citydb_pkg.nrg8_insert_material (
  objectclass_id       integer,
  id                   integer DEFAULT NULL,
  gmlid                character varying DEFAULT NULL,
  gmlid_codespace      character varying DEFAULT NULL,
  name                 character varying DEFAULT NULL,
  name_codespace       character varying DEFAULT NULL,
  description          text DEFAULT NULL,
  is_ventilated        numeric DEFAULT NULL,
  r_value              numeric DEFAULT NULL,
  r_value_unit         character varying DEFAULT NULL,
  density              numeric DEFAULT NULL,
  density_unit         character varying DEFAULT NULL,
  specific_heat        numeric DEFAULT NULL,
  specific_heat_unit   character varying DEFAULT NULL,
  conductivity         numeric DEFAULT NULL,
  conductivity_unit    character varying DEFAULT NULL,
  permeance            numeric DEFAULT NULL,
  permeance_unit       character varying DEFAULT NULL,
  porosity             numeric DEFAULT NULL,
  embodied_carbon      numeric DEFAULT NULL,
  embodied_carbon_unit character varying DEFAULT NULL,
  embodied_nrg         numeric DEFAULT NULL,
  embodied_nrg_unit    character varying DEFAULT NULL,
  layer_component_id   integer DEFAULT NULL,
  schema_name          varchar DEFAULT 'citydb'::varchar
)
RETURNS integer
AS
$$
DECLARE
  p_id                 integer;
  p_objectclass_id     integer;
  p_gmlid              character varying;
  p_gmlid_codespace    character varying;
  p_name               character varying;
  p_name_codespace     character varying;
  p_description        text;
  p_is_ventilated      numeric;
  p_r_value            numeric;
  p_r_value_unit       character varying;
  p_density            numeric;
  p_density_unit       character varying;
  p_specific_heat      numeric;
  p_specific_heat_unit character varying;
  p_conductivity       numeric;
  p_conductivity_unit  character varying;
  p_permeance          numeric;
  p_permeance_unit     character varying;
  p_porosity           numeric;
  p_embodied_carbon    numeric;
  p_embodied_carbon_unit character varying;
  p_embodied_nrg       numeric;
  p_embodied_nrg_unit  character varying;
  p_layer_component_id integer;
--
  p_schema_name        varchar;
  seq_name varchar;
  inserted_id integer;
BEGIN
-- Pass values to internal prefixed variables to avoid potential homonymy issues
  p_id                 :=id;
  p_objectclass_id     :=objectclass_id;
  p_gmlid              :=gmlid;
  p_gmlid_codespace    :=gmlid_codespace;
  p_name               :=name;
  p_name_codespace     :=name_codespace;
  p_description        :=description;
  p_is_ventilated      :=is_ventilated;
  p_r_value            :=r_value;
  p_r_value_unit       :=r_value_unit;
  p_density            :=density;
  p_density_unit       :=density_unit;
  p_specific_heat      :=specific_heat;
  p_specific_heat_unit :=specific_heat_unit;
  p_conductivity       :=conductivity;
  p_conductivity_unit  :=conductivity_unit;
  p_permeance          :=permeance;
  p_permeance_unit     :=permeance_unit;
  p_porosity           :=porosity;
  p_embodied_carbon    :=embodied_carbon;
  p_embodied_carbon_unit :=embodied_carbon_unit;
  p_embodied_nrg       :=embodied_nrg;
  p_embodied_nrg_unit  :=embodied_nrg_unit;
  p_layer_component_id :=layer_component_id;
  p_schema_name        :=schema_name;
-- IF the ID is not given, then generate a new one.
IF p_id IS NULL THEN
  seq_name=schema_name||'.nrg8_material_id_seq';
  p_id=nextval(seq_name::regclass);
END IF;
-- IF the GmlID is not given, then generate a new one.
IF p_gmlid IS NULL THEN
  p_gmlid='UUID_'||uuid_generate_v4();
END IF;

EXECUTE format('
    INSERT INTO %I.nrg8_material (
     id,
     objectclass_id,
     gmlid,
     gmlid_codespace,
     name,
     name_codespace,
     description,
     is_ventilated,
     r_value,
     r_value_unit,
     density,
     density_unit,
     specific_heat,
     specific_heat_unit,
     conductivity,
     conductivity_unit,
     permeance,
     permeance_unit,
     porosity,
     embodied_carbon,
     embodied_carbon_unit,
     embodied_nrg,
     embodied_nrg_unit,
     layer_component_id
    ) VALUES (
    %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L
    ) RETURNING id',
    p_schema_name,
    p_id,
    p_objectclass_id,
    p_gmlid,
    p_gmlid_codespace,
    p_name,
    p_name_codespace,
    p_description,
    p_is_ventilated,
    p_r_value,
    p_r_value_unit,
    p_density,
    p_density_unit,
    p_specific_heat,
    p_specific_heat_unit,
    p_conductivity,
    p_conductivity_unit,
    p_permeance,
    p_permeance_unit,
    p_porosity,
    p_embodied_carbon,
    p_embodied_carbon_unit,
    p_embodied_nrg,
    p_embodied_nrg_unit,
    p_layer_component_id
) INTO inserted_id;
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.nrg8_insert_material (id: %): %', p_id, SQLERRM;
END;
$$
LANGUAGE 'plpgsql';

----------------------------------------------------------------
-- Function NRG8_INSERT_HEAT_PUMP
----------------------------------------------------------------
-- DROP FUNCTION IF EXISTS citydb_pkg.nrg8_insert_heat_pump (integer, integer, character varying, numeric, character varying, numeric, character varying) CASCADE;
CREATE OR REPLACE FUNCTION citydb_pkg.nrg8_insert_heat_pump (
  objectclass_id       integer,
  id                   integer,
  heat_source          character varying DEFAULT NULL,
  cop_source_temp      numeric DEFAULT NULL,
  cop_source_temp_unit character varying DEFAULT NULL,
  cop_oper_temp        numeric DEFAULT NULL,
  cop_oper_temp_unit   character varying DEFAULT NULL,
  schema_name          varchar DEFAULT 'citydb'::varchar
)
RETURNS integer
AS
$$
DECLARE
  p_id                 integer;
  p_objectclass_id     integer;
  p_heat_source        character varying;
  p_cop_source_temp    numeric;
  p_cop_source_temp_unit character varying;
  p_cop_oper_temp      numeric;
  p_cop_oper_temp_unit character varying;
--
  p_schema_name        varchar;
  inserted_id integer;
BEGIN
-- Pass values to internal prefixed variables to avoid potential homonymy issues
  p_id                 :=id;
  p_objectclass_id     :=objectclass_id;
  p_heat_source        :=heat_source;
  p_cop_source_temp    :=cop_source_temp;
  p_cop_source_temp_unit :=cop_source_temp_unit;
  p_cop_oper_temp      :=cop_oper_temp;
  p_cop_oper_temp_unit :=cop_oper_temp_unit;
  p_schema_name        :=schema_name;


EXECUTE format('
    INSERT INTO %I.nrg8_heat_pump (
     id,
     objectclass_id,
     heat_source,
     cop_source_temp,
     cop_source_temp_unit,
     cop_oper_temp,
     cop_oper_temp_unit
    ) VALUES (
    %L, %L, %L, %L, %L, %L, %L
    ) RETURNING id',
    p_schema_name,
    p_id,
    p_objectclass_id,
    p_heat_source,
    p_cop_source_temp,
    p_cop_source_temp_unit,
    p_cop_oper_temp,
    p_cop_oper_temp_unit
) INTO inserted_id;
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.nrg8_insert_heat_pump (id: %): %', p_id, SQLERRM;
END;
$$
LANGUAGE 'plpgsql';

----------------------------------------------------------------
-- Function NRG8_INSERT_MECH_VENTILATION
----------------------------------------------------------------
-- DROP FUNCTION IF EXISTS citydb_pkg.nrg8_insert_mech_ventilation (integer, integer, numeric, numeric) CASCADE;
CREATE OR REPLACE FUNCTION citydb_pkg.nrg8_insert_mech_ventilation (
  objectclass_id       integer,
  id                   integer,
  heat_recovery        numeric DEFAULT NULL,
  recuperation         numeric DEFAULT NULL,
  schema_name          varchar DEFAULT 'citydb'::varchar
)
RETURNS integer
AS
$$
DECLARE
  p_id                 integer;
  p_objectclass_id     integer;
  p_heat_recovery      numeric;
  p_recuperation       numeric;
--
  p_schema_name        varchar;
  inserted_id integer;
BEGIN
-- Pass values to internal prefixed variables to avoid potential homonymy issues
  p_id                 :=id;
  p_objectclass_id     :=objectclass_id;
  p_heat_recovery      :=heat_recovery;
  p_recuperation       :=recuperation;
  p_schema_name        :=schema_name;


EXECUTE format('
    INSERT INTO %I.nrg8_mech_ventilation (
     id,
     objectclass_id,
     heat_recovery,
     recuperation
    ) VALUES (
    %L, %L, %L, %L
    ) RETURNING id',
    p_schema_name,
    p_id,
    p_objectclass_id,
    p_heat_recovery,
    p_recuperation
) INTO inserted_id;
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.nrg8_insert_mech_ventilation (id: %): %', p_id, SQLERRM;
END;
$$
LANGUAGE 'plpgsql';

----------------------------------------------------------------
-- Function NRG8_INSERT_CHILLER
----------------------------------------------------------------
-- DROP FUNCTION IF EXISTS citydb_pkg.nrg8_insert_chiller (integer, integer, character varying, character varying, character varying) CASCADE;
CREATE OR REPLACE FUNCTION citydb_pkg.nrg8_insert_chiller (
  objectclass_id       integer,
  id                   integer,
  condensation_type    character varying DEFAULT NULL,
  compressor_type      character varying DEFAULT NULL,
  refrigerant          character varying DEFAULT NULL,
  schema_name          varchar DEFAULT 'citydb'::varchar
)
RETURNS integer
AS
$$
DECLARE
  p_id                 integer;
  p_objectclass_id     integer;
  p_condensation_type  character varying;
  p_compressor_type    character varying;
  p_refrigerant        character varying;
--
  p_schema_name        varchar;
  inserted_id integer;
BEGIN
-- Pass values to internal prefixed variables to avoid potential homonymy issues
  p_id                 :=id;
  p_objectclass_id     :=objectclass_id;
  p_condensation_type  :=condensation_type;
  p_compressor_type    :=compressor_type;
  p_refrigerant        :=refrigerant;
  p_schema_name        :=schema_name;

EXECUTE format('
    INSERT INTO %I.nrg8_chiller (
     id,
     objectclass_id,
     condensation_type,
     compressor_type,
     refrigerant
    ) VALUES (
    %L, %L, %L, %L, %L
    ) RETURNING id',
    p_schema_name,
    p_id,
    p_objectclass_id,
    p_condensation_type,
    p_compressor_type,
    p_refrigerant
) INTO inserted_id;
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.nrg8_insert_chiller (id: %): %', p_id, SQLERRM;
END;
$$
LANGUAGE 'plpgsql';

DO
$$
BEGIN
RAISE NOTICE '

********************************

Energy ADE DML functions installation complete!

********************************

';
END
$$;
SELECT 'Energy ADE DML functions installation complete!'::varchar AS installation_result;

-- ***********************************************************************
-- ***********************************************************************
--
-- END OF FILE
--
-- ***********************************************************************
-- ***********************************************************************
