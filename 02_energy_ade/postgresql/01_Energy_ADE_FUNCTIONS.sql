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
-- ******************** 01_Energy_ADE_FUNCTIONS.sql **********************
--
-- This script adds stored procedures to the citydb_pkg schema.
-- They are all prefixed with "nrg8_".
--
-- ATTENTION:
-- Please check to have installed the metadata module before.
--
-- ***********************************************************************
-- ***********************************************************************

----------------------------------------------------------------
-- Function nrg8_SET_ADE_COLUMN_SRID
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_pkg.nrg8_set_ade_columns_srid(varchar);
CREATE OR REPLACE FUNCTION citydb_pkg.nrg8_set_ade_columns_srid(
	schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS void AS $$
DECLARE
BEGIN
-- EXECUTE THE STORED PROCEDURE TO SET THE SRID OF THE NEW GEOMETRY COLUMNS
PERFORM citydb_pkg.change_ade_column_srid('nrg8_building', 'ref_point', 'POINTZ', schema_name);
PERFORM citydb_pkg.change_ade_column_srid('nrg8_weather_station', 'position', 'POINTZ', schema_name);
PERFORM citydb_pkg.change_ade_column_srid('nrg8_weather_data', 'position', 'POINTZ', schema_name);
-- NOTICE BEGIN
-- The following will become not necessary once the testing phase is over as they will be taken over by
-- table surface_geometry.
PERFORM citydb_pkg.change_ade_column_srid('nrg8_thermal_zone', 'multi_surf_geom', 'MULTIPOLYGONZ', schema_name);
PERFORM citydb_pkg.change_ade_column_srid('nrg8_thermal_boundary', 'multi_surf_geom', 'MULTIPOLYGONZ', schema_name);
PERFORM citydb_pkg.change_ade_column_srid('nrg8_thermal_opening', 'multi_surf_geom', 'MULTIPOLYGONZ', schema_name);
PERFORM citydb_pkg.change_ade_column_srid('nrg8_usage_zone', 'multi_surf_geom', 'MULTIPOLYGONZ', schema_name);
PERFORM citydb_pkg.change_ade_column_srid('nrg8_solar_system', 'multi_surf_geom', 'MULTIPOLYGONZ', schema_name);
-- NOTICE END
RAISE NOTICE 'Geometry columns of Energy ADE set to current database SRID';
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.nrg8_set_ade_columns_srid (schema: %): %', schema_name, SQLERRM;
END;
$$
LANGUAGE plpgsql;
-- ALTER FUNCTION citydb_pkgnrg8_set_ade_columns_srid(varchar) OWNER TO postgres;

----------------------------------------------------------------
-- Function nrg8_CLEANUP_SCHEMA
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_pkg.nrg8_cleanup_schema(varchar);
CREATE OR REPLACE FUNCTION citydb_pkg.nrg8_cleanup_schema(
	schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS void AS $BODY$
DECLARE
BEGIN
-- Time series and schedules
EXECUTE format('TRUNCATE TABLE %I.nrg8_time_series_file CASCADE', schema_name);
EXECUTE format('TRUNCATE TABLE %I.nrg8_time_series CASCADE', schema_name);
EXECUTE format('TRUNCATE TABLE %I.nrg8_daily_schedule CASCADE', schema_name);
EXECUTE format('TRUNCATE TABLE %I.nrg8_period_of_year CASCADE', schema_name);
EXECUTE format('TRUNCATE TABLE %I.nrg8_schedule CASCADE', schema_name);
-- Ancillary tables
EXECUTE format('TRUNCATE TABLE %I.nrg8_dimensional_attrib CASCADE', schema_name);
EXECUTE format('TRUNCATE TABLE %I.nrg8_perf_certification CASCADE', schema_name);
EXECUTE format('TRUNCATE TABLE %I.nrg8_refurbishment_measure CASCADE', schema_name);
EXECUTE format('TRUNCATE TABLE %I.nrg8_weather_data CASCADE', schema_name);
-- Constructions
EXECUTE format('TRUNCATE TABLE %I.nrg8_material CASCADE', schema_name);
EXECUTE format('TRUNCATE TABLE %I.nrg8_layer_component CASCADE', schema_name);
EXECUTE format('TRUNCATE TABLE %I.nrg8_layer CASCADE', schema_name);
EXECUTE format('TRUNCATE TABLE %I.nrg8_optical_property CASCADE', schema_name);
EXECUTE format('TRUNCATE TABLE %I.nrg8_construction CASCADE', schema_name);
-- Energy Systems
EXECUTE format('TRUNCATE TABLE %I.nrg8_energy_demand CASCADE', schema_name);
EXECUTE format('TRUNCATE TABLE %I.nrg8_final_energy CASCADE', schema_name);
EXECUTE format('TRUNCATE TABLE %I.nrg8_system_operation CASCADE', schema_name);
EXECUTE format('TRUNCATE TABLE %I.nrg8_emitter CASCADE', schema_name);
EXECUTE format('TRUNCATE TABLE %I.nrg8_distrib_system CASCADE', schema_name);
EXECUTE format('TRUNCATE TABLE %I.nrg8_storage_system CASCADE', schema_name);
--EXECUTE format('TRUNCATE TABLE %I.nrg8_solar_system CASCADE', schema_name);
EXECUTE format('TRUNCATE TABLE %I.nrg8_conv_system CASCADE', schema_name);
-- Occupancy module
EXECUTE format('TRUNCATE TABLE %I.nrg8_household CASCADE', schema_name);
EXECUTE format('TRUNCATE TABLE %I.nrg8_occupants CASCADE', schema_name);
EXECUTE format('TRUNCATE TABLE %I.nrg8_facilities CASCADE', schema_name);
EXECUTE format('TRUNCATE TABLE %I.nrg8_building_unit CASCADE', schema_name);
EXECUTE format('TRUNCATE TABLE %I.nrg8_usage_zone CASCADE', schema_name);
-- Building physics module
EXECUTE format('TRUNCATE TABLE %I.nrg8_thermal_opening CASCADE', schema_name);
EXECUTE format('TRUNCATE TABLE %I.nrg8_thermal_boundary CASCADE', schema_name);
EXECUTE format('TRUNCATE TABLE %I.nrg8_thermal_zone CASCADE', schema_name);
EXECUTE format('TRUNCATE TABLE %I.nrg8_building CASCADE', schema_name);
EXECUTE format('TRUNCATE TABLE %I.nrg8_weather_station CASCADE', schema_name);
-- Finished, now call the standard clear_schema functions.

-- restart sequences
EXECUTE format('ALTER SEQUENCE %I.nrg8_time_series_id_seq RESTART', schema_name);
EXECUTE format('ALTER SEQUENCE %I.nrg8_construction_id_seq RESTART', schema_name);
EXECUTE format('ALTER SEQUENCE %I.nrg8_daily_schedule_id_seq RESTART', schema_name);
EXECUTE format('ALTER SEQUENCE %I.nrg8_dimensional_attrib_id_seq RESTART', schema_name);
EXECUTE format('ALTER SEQUENCE %I.nrg8_energy_demand_id_seq RESTART', schema_name);
EXECUTE format('ALTER SEQUENCE %I.nrg8_final_energy_id_seq RESTART', schema_name);
EXECUTE format('ALTER SEQUENCE %I.nrg8_household_id_seq RESTART', schema_name);
EXECUTE format('ALTER SEQUENCE %I.nrg8_layer_component_id_seq RESTART', schema_name);
EXECUTE format('ALTER SEQUENCE %I.nrg8_layer_id_seq RESTART', schema_name);
EXECUTE format('ALTER SEQUENCE %I.nrg8_material_id_seq RESTART', schema_name);
EXECUTE format('ALTER SEQUENCE %I.nrg8_occupants_id_seq RESTART', schema_name);
EXECUTE format('ALTER SEQUENCE %I.nrg8_optical_property_id_seq RESTART', schema_name);
EXECUTE format('ALTER SEQUENCE %I.nrg8_perf_certification_id_seq RESTART', schema_name);
EXECUTE format('ALTER SEQUENCE %I.nrg8_period_of_year_id_seq RESTART', schema_name);
EXECUTE format('ALTER SEQUENCE %I.nrg8_refurbishment_measure_id_seq RESTART', schema_name);
EXECUTE format('ALTER SEQUENCE %I.nrg8_schedule_id_seq RESTART', schema_name);
EXECUTE format('ALTER SEQUENCE %I.nrg8_system_operation_id_seq RESTART', schema_name);
EXECUTE format('ALTER SEQUENCE %I.nrg8_weather_data_id_seq RESTART', schema_name);

EXCEPTION
    WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.nrg8_cleanup_schema: %', SQLERRM;
END; 
$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION citydb_pkg.nrg8_cleanup_schema(varchar) OWNER TO postgres;

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
	em_id integer;
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
-- delete all emitter related to this cityobject
FOR em_id IN EXECUTE format('SELECT id FROM %I.nrg8_emitter WHERE cityobject_id = %L', schema_name, em_id) LOOP
	IF em_id IS NOT NULL THEN
		-- delete dependent distribution system
		EXECUTE 'SELECT citydb_pkg.nrg8_delete_emitter($1, $2)' USING em_id, schema_name;
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
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.nrg8_delete_building_unit (id: %): %', em_id, SQLERRM;
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
	FOR so_id IN EXECUTE format('SELECT id FROM %I.nrg8_system_operation WHERE nrg8_conv_system_id = %L', schema_name, cs_id) LOOP
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
-- Function nrg8_GET_ENVELOPE_THERMAL_BOUNDARY
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

DO
$$
BEGIN
RAISE NOTICE '

********************************

Energy ADE functions installation complete!

********************************

';
END
$$;
SELECT 'Energy ADE functions installation complete!'::varchar AS installation_result;

-- ***********************************************************************
-- ***********************************************************************
--
-- END OF FILE
--
-- ***********************************************************************
-- ***********************************************************************
