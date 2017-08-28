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
-- ***************** 07_Energy_ADE_VIEW_FUNCTIONS.sql ********************
--
-- This script adds stored procedured to schema citydb_view.
--
-- ***********************************************************************
-- ***********************************************************************

----------------------------------------------------------------
-- DROP existing prefixed delete functions
----------------------------------------------------------------
DO $$
DECLARE
db_schema varchar DEFAULT 'citydb_view'::varchar;
db_prefix varchar DEFAULT 'nrg8'::varchar;
func_prefix varchar DEFAULT 'delete'::varchar;
db_prefix_length integer;
test integer DEFAULT NULL;
rec RECORD;
BEGIN
db_prefix_length=char_length(db_prefix) + 1 + char_length(func_prefix::varchar);
-- Check whether there are any prefixed functions to drop at all!
EXECUTE format('SELECT 1 FROM information_schema.routines WHERE routine_type=''FUNCTION'' AND routine_schema=%L AND substring(routine_name, 1, %L::integer)=%L||''_''||%L LIMIT 1', db_schema, db_prefix_length, db_prefix, func_prefix) INTO test;
IF test IS NOT NULL AND test=1 THEN
	RAISE INFO 'Removing all % functions with db_prefix "%" in schema %',  func_prefix, db_prefix, db_schema;
	FOR rec IN EXECUTE format('SELECT proname || ''('' || oidvectortypes(proargtypes) || '')'' AS function_name
	FROM pg_proc INNER JOIN pg_namespace ns ON (pg_proc.pronamespace = ns.oid)
	WHERE ns.nspname = %L AND substring(proname, 1, %L::integer)=%L||''_''||%L ORDER BY proname', db_schema, db_prefix_length, db_prefix, func_prefix) LOOP
		--RAISE NOTICE 'Dropping FUNCTION citydb_view.%',rec.function_name;
		EXECUTE 'DROP FUNCTION IF EXISTS ' || db_schema ||'.' || rec.function_name || ' CASCADE';
	END LOOP;
ELSE
	-- RAISE INFO '-- No functions to delete';
END IF;
END $$;

----------------------------------------------------------------
-- DROP existing prefixed insert functions
----------------------------------------------------------------
DO $$
DECLARE
db_schema varchar DEFAULT 'citydb_view'::varchar;
db_prefix varchar DEFAULT 'nrg8'::varchar;
func_prefix varchar DEFAULT 'insert'::varchar;
db_prefix_length integer;
test integer DEFAULT NULL;
rec RECORD;
BEGIN
db_prefix_length=char_length(db_prefix) + 1 + char_length(func_prefix::varchar);
-- Check whether there are any prefixed functions to drop at all!
EXECUTE format('SELECT 1 FROM information_schema.routines WHERE routine_type=''FUNCTION'' AND routine_schema=%L AND substring(routine_name, 1, %L::integer)=%L||''_''||%L LIMIT 1', db_schema, db_prefix_length, db_prefix, func_prefix) INTO test;
IF test IS NOT NULL AND test=1 THEN
	RAISE INFO 'Removing all % functions with db_prefix "%" in schema %',  func_prefix, db_prefix, db_schema;
	FOR rec IN EXECUTE format('SELECT proname || ''('' || oidvectortypes(proargtypes) || '')'' AS function_name
	FROM pg_proc INNER JOIN pg_namespace ns ON (pg_proc.pronamespace = ns.oid)
	WHERE ns.nspname = %L AND substring(proname, 1, %L::integer)=%L||''_''||%L ORDER BY proname', db_schema, db_prefix_length, db_prefix, func_prefix) LOOP
		--RAISE NOTICE 'Dropping FUNCTION citydb_view.%',rec.function_name;
		EXECUTE 'DROP FUNCTION IF EXISTS ' || db_schema ||'.' || rec.function_name || ' CASCADE';
	END LOOP;
ELSE
	-- RAISE INFO '-- No functions to delete';
END IF;
END $$;

---------------------------------------------------------------
-- Function nrg8_DELETE_BUILDING
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.nrg8_delete_building(
  IN id integer,
  IN schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
	deleted_id integer;
BEGIN
deleted_id=citydb_pkg.delete_building(id, schema_name);
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_delete_building (id: %): %', id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function nrg8_DELETE_BUILDING_PART
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.nrg8_delete_building_part(
  IN id integer,
  IN schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
	deleted_id integer;
BEGIN
deleted_id=citydb_pkg.delete_building(id, schema_name);
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_delete_building_part (id: %): %', id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;


---------------------------------------------------------------
-- Function DELETE_BUILDING_UNIT
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.nrg8_delete_building_unit(
  IN id integer,
  IN schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
	deleted_id integer;
BEGIN
deleted_id=citydb_pkg.delete_building_unit(id, schema_name);
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.delete_building_unit (id: %): %', id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function DELETE_BASE_CONSTRUCTION
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.nrg8_delete_base_construction(
  IN id integer,
  IN schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
	deleted_id integer;
BEGIN
deleted_id=citydb_pkg.nrg8_delete_construction(id, schema_name);
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_delete_base_construction (id: %): %', id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function DELETE_CONSTRUCTION_REVERSE
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.nrg8_delete_reverse_construction(
  IN id integer,
  IN schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
	deleted_id integer;
BEGIN
deleted_id=citydb_pkg.nrg8_delete_construction(id, schema_name);
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_delete_reverse_construction (id: %): %', id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function DELETE_CONV_SYSTEM
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.nrg8_delete_conv_system(
  IN id integer,
  IN schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
	deleted_id integer;
BEGIN
deleted_id=citydb_pkg.delete_conv_system(id, schema_name);
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_delete_conv_system (id: %): %', id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function DELETE_AIR_COMPRESSOR
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.nrg8_delete_air_compressor(
  IN id integer,
  IN schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
	deleted_id integer;
BEGIN
deleted_id=citydb_pkg.delete_conv_system(id, schema_name);
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_delete_air_compressor (id: %): %', id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function DELETE_BOILER
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.nrg8_delete_boiler(
  IN id integer,
  IN schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
	deleted_id integer;
BEGIN
deleted_id=citydb_pkg.delete_conv_system(id, schema_name);
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_delete_boiler (id: %): %', id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function DELETE_CHILLER
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.nrg8_delete_chiller(
  IN id integer,
  IN schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
	deleted_id integer;
BEGIN
deleted_id=citydb_pkg.delete_conv_system(id, schema_name);
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_delete_chiller (id: %): %', id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function DELETE_COMBINED_HEAT_POWER
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.nrg8_delete_combined_heat_power(
  IN id integer,
  IN schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
	deleted_id integer;
BEGIN
deleted_id=citydb_pkg.delete_conv_system(id, schema_name);
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_delete_combined_heat_power (id: %): %', id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function DELETE_ELECTRICAL_RESISTANCE
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.nrg8_delete_electrical_resistance(
  IN id integer,
  IN schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
	deleted_id integer;
BEGIN
deleted_id=citydb_pkg.delete_conv_system(id, schema_name);
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_delete_electrical_resistance (id: %): %', id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function DELETE_HEAT_EXCHANGER
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.nrg8_delete_heat_exchanger(
  IN id integer,
  IN schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
	deleted_id integer;
BEGIN
deleted_id=citydb_pkg.delete_conv_system(id, schema_name);
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_delete_heat_exchanger (id: %): %', id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function DELETE_HEAT_PUMP
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.nrg8_delete_heat_pump(
  IN id integer,
  IN schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
	deleted_id integer;
BEGIN
deleted_id=citydb_pkg.delete_conv_system(id, schema_name);
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_delete_heat_pump (id: %): %', id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function DELETE_MECH_VENTILATION
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.nrg8_delete_mech_ventilation(
  IN id integer,
  IN schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
	deleted_id integer;
BEGIN
deleted_id=citydb_pkg.delete_conv_system(id, schema_name);
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_delete_mech_ventilation (id: %): %', id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function DELETE_PV_THERMAL_SYSTEM
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.nrg8_delete_photovoltaic_thermal_system(
  IN id integer,
  IN schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
	deleted_id integer;
BEGIN
deleted_id=citydb_pkg.delete_conv_system(id, schema_name);
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_delete_photovoltaic_thermal_system (id: %): %', id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function DELETE_PV_SYSTEM
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.nrg8_delete_photovoltaic_system(
  IN id integer,
  IN schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
	deleted_id integer;
BEGIN
deleted_id=citydb_pkg.delete_conv_system(id, schema_name);
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_delete_photovoltaic_system (id: %): %', id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function DELETE_SOLAR_THERMAL_SYSTEM
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.nrg8_delete_solar_thermal_system(
  IN id integer,
  IN schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
	deleted_id integer;
BEGIN
deleted_id=citydb_pkg.delete_conv_system(id, schema_name);
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_delete_solar_thermal_system (id: %): %', id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function DELETE_DAILY_SCHEDULE
----------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.nrg8_delete_daily_schedule(
  IN id integer,
  IN schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
	deleted_id integer;
BEGIN
deleted_id=citydb_pkg.nrg8_delete_daily_schedule(id, schema_name);
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_delete_daily_schedule (id: %): %', id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function DELETE_FLOOR_AREA (non CityObject)
----------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.nrg8_delete_floor_area(
  IN id integer,
  IN schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
	deleted_id integer;
BEGIN
deleted_id=citydb_pkg.nrg8_delete_dimensional_attrib(id, schema_name);
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_delete_floor_area (id: %): %', id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function DELETE_HEIGHT
----------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.nrg8_delete_height_above_ground(
  IN id integer,
  IN schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
	deleted_id integer;
BEGIN
deleted_id=citydb_pkg.nrg8_delete_dimensional_attrib(id, schema_name);
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_delete_height_above_ground (id: %): %', id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function DELETE_VOLUME (non CityObject)
----------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.nrg8_delete_volume(
  IN id integer,
  IN schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
	deleted_id integer;
BEGIN
deleted_id=citydb_pkg.nrg8_delete_dimensional_attrib(id, schema_name);
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_delete_volume (id: %): %', id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function DELETE_EMITTER (CityObject)
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.nrg8_delete_emitter(
  IN id integer,
  IN schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
	deleted_id integer;
BEGIN
deleted_id=citydb_pkg.delete_emitter(id, schema_name);
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_delete_emitter (id: %): %', id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function DELETE_ENERGY_DEMAND (non CityObject)
----------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.nrg8_delete_energy_demand(
  IN id integer,
  IN schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
	deleted_id integer;
BEGIN
deleted_id=citydb_pkg.nrg8_delete_energy_demand(id, schema_name);
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_delete_energy_demand (id: %): %', id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function DELETE_DHWFACILITIES (CityObject)
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.nrg8_delete_dhw_facilities(
  IN id integer,
  IN schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
	deleted_id integer;
BEGIN
deleted_id=citydb_pkg.delete_facilities(id, schema_name);
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_delete_dhw_facilities (id: %): %', id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function DELETE_ELECTRICAL_APPLIANCES (CityObject)
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.nrg8_delete_electrical_appliances(
  IN id integer,
  IN schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
	deleted_id integer;
BEGIN
deleted_id=citydb_pkg.delete_facilities(id, schema_name);
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_delete_electrical_appliances (id: %): %', id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function DELETE_LIGHTING (CityObject)
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.nrg8_delete_lighting(
  IN id integer,
  IN schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
	deleted_id integer;
BEGIN
deleted_id=citydb_pkg.delete_facilities(id, schema_name);
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_delete_lighting (id: %): %', id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function DELETE_FINAL_ENERGY (non CityObject)
----------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.nrg8_delete_final_energy(
  IN id integer,
  IN schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
	deleted_id integer;
BEGIN
deleted_id=citydb_pkg.nrg8_delete_final_energy(id, schema_name);
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_delete_final_energy (id: %): %', id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function DELETE_HOUSEHOLD (non CityObject)
----------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.nrg8_delete_household(
  IN id integer,
  IN schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
	deleted_id integer;
BEGIN
deleted_id=citydb_pkg.nrg8_delete_household(id, schema_name);
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_delete_household (id: %): %', id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function DELETE_LAYER (non CityObject)
----------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.nrg8_delete_layer(
  IN id integer,
  IN schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
	deleted_id integer;
BEGIN
deleted_id=citydb_pkg.nrg8_delete_layer(id, schema_name);
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_delete_layer (id: %): %', id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function DELETE_LAYER_COMPONENT (non CityObject)
----------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.nrg8_delete_layer_component(
  IN id integer,
  IN schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
	deleted_id integer;
BEGIN
deleted_id=citydb_pkg.nrg8_delete_layer_component(id, schema_name);
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_delete_layer_component (id: %): %', id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function DELETE_GAS (non CityObject)
----------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.nrg8_delete_gas(
  IN id integer,
  IN schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
	deleted_id integer;
BEGIN
deleted_id=citydb_pkg.nrg8_delete_material(id, schema_name);
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_delete_gas (id: %): %', id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function DELETE_SOLID_MATERIAL (non CityObject)
----------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.nrg8_delete_solid_material(
  IN id integer,
  IN schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
	deleted_id integer;
BEGIN
deleted_id=citydb_pkg.nrg8_delete_material(id, schema_name);
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_delete_solid_material (id: %): %', id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function DELETE_OCCUPANTS (non CityObject)
----------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.nrg8_delete_occupants(
  IN id integer,
  IN schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
	deleted_id integer;
BEGIN
deleted_id=citydb_pkg.nrg8_delete_occupants(id, schema_name);
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_delete_occupants (id: %): %', id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function DELETE_EMISSIVITY (non CityObject)
----------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.nrg8_delete_emissivity(
  IN id integer,
  IN schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
	deleted_id integer;
BEGIN
deleted_id=citydb_pkg.nrg8_delete_optical_property(id, schema_name);
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_delete_emissivity (id: %): %', id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function DELETE_REFLECTANCE (non CityObject)
----------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.nrg8_delete_reflectance(
  IN id integer,
  IN schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
	deleted_id integer;
BEGIN
deleted_id=citydb_pkg.nrg8_delete_optical_property(id, schema_name);
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_delete_reflectance (id: %): %', id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function DELETE_TRANSMITTANCE (non CityObject)
----------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.nrg8_delete_transmittance(
  IN id integer,
  IN schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
	deleted_id integer;
BEGIN
deleted_id=citydb_pkg.nrg8_delete_optical_property(id, schema_name);
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_delete_transmittance (id: %): %', id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function DELETE_PERF_CERTIFICATION (non CityObject)
----------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.nrg8_delete_perf_certification(
  IN id integer,
  IN schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
	deleted_id integer;
BEGIN
deleted_id=citydb_pkg.nrg8_delete_perf_certification(id, schema_name);
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_delete_perf_certification (id: %): %', id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function DELETE_PERIOD_OF_YEAR (non CityObject)
----------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.nrg8_delete_period_of_year(
  IN id integer,
  IN schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
	deleted_id integer;
BEGIN
deleted_id=citydb_pkg.nrg8_delete_period_of_year(id, schema_name);
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_delete_period_of_year (id: %): %', id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function DELETE_DISTRIB_SYSTEM (CityObject)
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.nrg8_delete_distrib_system(
  IN id integer,
  IN schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
	deleted_id integer;
BEGIN
deleted_id=citydb_pkg.delete_distrib_system(id, schema_name);
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_delete_distrib_system (id: %): %', id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function DELETE_POWER_DISTRIB_SYSTEM (CityObject)
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.nrg8_delete_power_distrib_system(
  IN id integer,
  IN schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
	deleted_id integer;
BEGIN
deleted_id=citydb_pkg.delete_distrib_system(id, schema_name);
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_delete_power_distrib_system (id: %): %', id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function DELETE_THERMAL_DISTRIB_SYSTEM (CityObject)
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.nrg8_delete_thermal_distrib_system(
  IN id integer,
  IN schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
	deleted_id integer;
BEGIN
deleted_id=citydb_pkg.delete_distrib_system(id, schema_name);
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_delete_thermal_distrib_system (id: %): %', id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function DELETE_POWER_STORAGE_SYSTEM (CityObject)
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.nrg8_delete_power_storage_system(
  IN id integer,
  IN schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
	deleted_id integer;
BEGIN
deleted_id=citydb_pkg.delete_storage_system(id, schema_name);
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_delete_power_storage_system (id: %): %', id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function DELETE_THERMAL_STORAGE_SYSTEM (CityObject)
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.nrg8_delete_thermal_storage_system(
  IN id integer,
  IN schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
	deleted_id integer;
BEGIN
deleted_id=citydb_pkg.delete_storage_system(id, schema_name);
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_delete_thermal_storage_system (id: %): %', id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function DELETE_REFURBISHMENT_MEASURE (non CityObject)
----------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.nrg8_delete_refurbishment_measure(
  IN id integer,
  IN schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
	deleted_id integer;
BEGIN
deleted_id=citydb_pkg.nrg8_delete_refurbishment_measure(id, schema_name);
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_delete_refurbishment_measure (id: %): %', id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function DELETE_CONSTANT_VALUE_SCHEDULE (non CityObject)
----------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.nrg8_delete_constant_value_schedule(
  IN id integer,
  IN schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
	deleted_id integer;
BEGIN
deleted_id=citydb_pkg.nrg8_delete_schedule(id, schema_name);
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_delete_constant_value_schedule (id: %): %', id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function DELETE_DUAL_VALUE_SCHEDULE (non CityObject)
----------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.nrg8_delete_dual_value_schedule(
  IN id integer,
  IN schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
	deleted_id integer;
BEGIN
deleted_id=citydb_pkg.nrg8_delete_schedule(id, schema_name);
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_delete_dual_value_schedule (id: %): %', id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function DELETE_DAILY_PATTERN_SCHEDULE (non CityObject)
----------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.nrg8_delete_daily_pattern_schedule(
  IN id integer,
  IN schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
	deleted_id integer;
BEGIN
deleted_id=citydb_pkg.nrg8_delete_schedule(id, schema_name);
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_delete_daily_pattern_schedule (id: %): %', id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function DELETE_TIME_SERIES_SCHEDULE (non CityObject)
----------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.nrg8_delete_time_series_schedule(
  IN id integer,
  IN schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
	deleted_id integer;
BEGIN
deleted_id=citydb_pkg.nrg8_delete_schedule(id, schema_name);
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_delete_time_series_schedule (id: %): %', id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function DELETE_SYSTEM_OPERATION (non CityObject)
----------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.nrg8_delete_system_operation(
  IN id integer,
  IN schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
	deleted_id integer;
BEGIN
deleted_id=citydb_pkg.nrg8_delete_system_operation(id, schema_name);
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_delete_system_operation (id: %): %', id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function DELETE_THERMAL_BOUNDARY (CityObject)
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.nrg8_delete_thermal_boundary(
  IN id integer,
  IN schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
	deleted_id integer;
BEGIN
deleted_id=citydb_pkg.delete_thermal_boundary(id, schema_name);
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_delete_thermal_boundary (id: %): %', id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function DELETE_THERMAL_OPENING (CityObject)
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.nrg8_delete_thermal_opening(
  IN id integer,
  IN schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
	deleted_id integer;
BEGIN
deleted_id=citydb_pkg.delete_thermal_opening(id, schema_name);
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_delete_thermal_opening (id: %): %', id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function DELETE_THERMAL_ZONE (CityObject)
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.nrg8_delete_thermal_zone(
  IN id integer,
  IN schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
	deleted_id integer;
BEGIN
deleted_id=citydb_pkg.delete_thermal_zone(id, schema_name);
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_delete_thermal_zone (id: %): %', id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function DELETE_REGULAR_TIME_SERIES
----------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.nrg8_delete_regular_time_series(
  IN id integer,
  IN schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
	deleted_id integer;
BEGIN
deleted_id=citydb_pkg.nrg8_delete_time_series(id, schema_name);
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_delete_regular_time_series (id: %): %', id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function DELETE_IRREGULAR_TIME_SERIES
----------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.nrg8_delete_irregular_time_series(
  IN id integer,
  IN schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
	deleted_id integer;
BEGIN
deleted_id=citydb_pkg.nrg8_delete_time_series(id, schema_name);
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_delete_irregular_time_series (id: %): %', id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function DELETE_TIME_REGULAR_SERIES_FILE
----------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.nrg8_delete_regular_time_series_file(
  IN id integer,
  IN schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
	deleted_id integer;
BEGIN
deleted_id=citydb_pkg.nrg8_delete_time_series(id, schema_name);
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_delete_regular_time_series_file (id: %): %', id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function DELETE_IRREGULAR_TIME_SERIES_FILE
----------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.nrg8_delete_irregular_time_series_file(
  IN id integer,
  IN schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
	deleted_id integer;
BEGIN
deleted_id=citydb_pkg.nrg8_delete_time_series(id, schema_name);
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_delete_irregular_time_series_file (id: %): %', id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function DELETE_USAGE_ZONE (CityObject)
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.nrg8_delete_usage_zone(
  IN id integer,
  IN schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
	deleted_id integer;
BEGIN
deleted_id=citydb_pkg.delete_usage_zone(id, schema_name);
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_delete_usage_zone (id: %): %', id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function DELETE_WEATHER_DATA
----------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.nrg8_delete_weather_data(
  IN id integer,
  IN schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
	deleted_id integer;
BEGIN
deleted_id=citydb_pkg.nrg8_delete_weather_data(id, schema_name);
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_delete_weather_data (id: %): %', id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function DELETE_WEATHER_STATION (CityObject)
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.nrg8_delete_weather_station(
  IN id integer,
  IN schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
	deleted_id integer;
BEGIN
deleted_id=citydb_pkg.delete_weather_station(id, schema_name);
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_delete_weather_station (id: %): %', id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

-- ***********************************************************************
-- ***********************************************************************

---------------------------------------------------------------
-- Function nrg8_INSERT_BUILDING
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.nrg8_insert_building(
  id                     integer DEFAULT NULL,
  gmlid                  varchar(256) DEFAULT NULL,
  gmlid_codespace        varchar(1000) DEFAULT NULL,
  name                   varchar(1000) DEFAULT NULL,
  name_codespace         varchar(4000) DEFAULT NULL,
  description            varchar(4000) DEFAULT NULL,
  envelope               geometry DEFAULT NULL,
  creation_date          timestamp(0) with time zone DEFAULT NULL,
  termination_date       timestamp(0) with time zone DEFAULT NULL,
  relative_to_terrain    varchar(256) DEFAULT NULL,
  relative_to_water      varchar(256) DEFAULT NULL,
  last_modification_date timestamp with time zone DEFAULT NULL,
  updating_person        varchar(256) DEFAULT NULL,
  reason_for_update      varchar(4000) DEFAULT NULL,
  lineage                varchar(256) DEFAULT NULL,
--
  building_parent_id          integer DEFAULT NULL,
  building_root_id            integer DEFAULT NULL,
  class                       varchar(256) DEFAULT NULL,
  class_codespace             varchar(4000) DEFAULT NULL,
  function                    varchar(1000) DEFAULT NULL,
  function_codespace          varchar(4000) DEFAULT NULL,
  usage                       varchar(1000) DEFAULT NULL,
  usage_codespace             varchar(4000) DEFAULT NULL,
  year_of_construction        date DEFAULT NULL,
  year_of_demolition          date DEFAULT NULL,
  roof_type                   varchar(256) DEFAULT NULL,
  roof_type_codespace         varchar(4000) DEFAULT NULL,
  measured_height             double precision DEFAULT NULL,
  measured_height_unit        varchar(4000) DEFAULT NULL,
  storeys_above_ground        numeric(8) DEFAULT NULL,
  storeys_below_ground        numeric(8) DEFAULT NULL,
  storey_heights_above_ground varchar(4000) DEFAULT NULL,
  storey_heights_ag_unit      varchar(4000) DEFAULT NULL,
  storey_heights_below_ground varchar(4000) DEFAULT NULL,
  storey_heights_bg_unit      varchar(4000) DEFAULT NULL,
  lod1_terrain_intersection   geometry DEFAULT NULL,
  lod2_terrain_intersection   geometry DEFAULT NULL,
  lod3_terrain_intersection   geometry DEFAULT NULL,
  lod4_terrain_intersection   geometry DEFAULT NULL,
  lod2_multi_curve            geometry DEFAULT NULL,
  lod3_multi_curve            geometry DEFAULT NULL,
  lod4_multi_curve            geometry DEFAULT NULL,
  lod0_footprint_id           integer DEFAULT NULL,
  lod0_roofprint_id           integer DEFAULT NULL,
  lod1_multi_surface_id       integer DEFAULT NULL,
  lod2_multi_surface_id       integer DEFAULT NULL,
  lod3_multi_surface_id       integer DEFAULT NULL,
  lod4_multi_surface_id       integer DEFAULT NULL,
  lod1_solid_id               integer DEFAULT NULL,
  lod2_solid_id               integer DEFAULT NULL,
  lod3_solid_id               integer DEFAULT NULL,
  lod4_solid_id               integer DEFAULT NULL,
--
  type                 character varying DEFAULT NULL,
  type_codespace       character varying DEFAULT NULL,
  constr_weight        character varying DEFAULT NULL,
  is_landmarked        numeric DEFAULT NULL,
  ref_point            geometry DEFAULT NULL,
--
  schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
  p_id                     integer                     := id                    ;
  p_gmlid                  varchar(256)                := gmlid                 ;
  p_gmlid_codespace        varchar(1000)               := gmlid_codespace       ;
  p_name                   varchar(1000)               := name                  ;
  p_name_codespace         varchar(4000)               := name_codespace        ;
  p_description            varchar(4000)               := description           ;
  p_envelope               geometry                    := envelope              ;
  p_creation_date          timestamp(0) with time zone := creation_date         ;
  p_termination_date       timestamp(0) with time zone := termination_date      ;
  p_relative_to_terrain    varchar(256)                := relative_to_terrain   ;
  p_relative_to_water      varchar(256)                := relative_to_water     ;
  p_last_modification_date timestamp with time zone    := last_modification_date;
  p_updating_person        varchar(256)                := updating_person       ;
  p_reason_for_update      varchar(4000)               := reason_for_update     ;
  p_lineage                varchar(256)                := lineage               ;
--
  p_building_parent_id          integer          := building_parent_id         ;
  p_building_root_id            integer          := building_root_id           ;
  p_class                       varchar(256)     := class                      ;
  p_class_codespace             varchar(4000)    := class_codespace            ;
  p_function                    varchar(1000)    := function                   ;
  p_function_codespace          varchar(4000)    := function_codespace         ;
  p_usage                       varchar(1000)    := usage                      ;
  p_usage_codespace             varchar(4000)    := usage_codespace            ;
  p_year_of_construction        date             := year_of_construction       ;
  p_year_of_demolition          date             := year_of_demolition         ;
  p_roof_type                   varchar(256)     := roof_type                  ;
  p_roof_type_codespace         varchar(4000)    := roof_type_codespace        ;
  p_measured_height             double precision := measured_height            ;
  p_measured_height_unit        varchar(4000)    := measured_height_unit       ;
  p_storeys_above_ground        numeric(8)       := storeys_above_ground       ;
  p_storeys_below_ground        numeric(8)       := storeys_below_ground       ;
  p_storey_heights_above_ground varchar(4000)    := storey_heights_above_ground;
  p_storey_heights_ag_unit      varchar(4000)    := storey_heights_ag_unit     ;
  p_storey_heights_below_ground varchar(4000)    := storey_heights_below_ground;
  p_storey_heights_bg_unit      varchar(4000)    := storey_heights_bg_unit     ;
  p_lod1_terrain_intersection   geometry         := lod1_terrain_intersection  ;
  p_lod2_terrain_intersection   geometry         := lod2_terrain_intersection  ;
  p_lod3_terrain_intersection   geometry         := lod3_terrain_intersection  ;
  p_lod4_terrain_intersection   geometry         := lod4_terrain_intersection  ;
  p_lod2_multi_curve            geometry         := lod2_multi_curve           ;
  p_lod3_multi_curve            geometry         := lod3_multi_curve           ;
  p_lod4_multi_curve            geometry         := lod4_multi_curve           ;
  p_lod0_footprint_id           integer          := lod0_footprint_id          ;
  p_lod0_roofprint_id           integer          := lod0_roofprint_id          ;
  p_lod1_multi_surface_id       integer          := lod1_multi_surface_id      ;
  p_lod2_multi_surface_id       integer          := lod2_multi_surface_id      ;
  p_lod3_multi_surface_id       integer          := lod3_multi_surface_id      ;
  p_lod4_multi_surface_id       integer          := lod4_multi_surface_id      ;
  p_lod1_solid_id               integer          := lod1_solid_id              ;
  p_lod2_solid_id               integer          := lod2_solid_id              ;
  p_lod3_solid_id               integer          := lod3_solid_id              ;
  p_lod4_solid_id               integer          := lod4_solid_id              ;
--
  p_type           varchar  := type          ;
  p_type_codespace varchar  := type_codespace;
  p_constr_weight  varchar  := constr_weight ;
  p_is_landmarked  numeric  := is_landmarked ;
  p_ref_point      geometry := ref_point     ;
--
  p_schema_name varchar := schema_name;
  class_name varchar DEFAULT 'Building'::varchar;
  db_prefix varchar DEFAULT NULL;
  objectclass_id integer;
  inserted_id integer;
BEGIN
objectclass_id=citydb_pkg.objectclass_classname_to_id(class_name, db_prefix, p_schema_name);

inserted_id=citydb_pkg.insert_cityobject(
    id                    :=p_id,
    objectclass_id        :=objectclass_id,
    gmlid                 :=p_gmlid,
    gmlid_codespace       :=p_gmlid_codespace,
    name                  :=p_name,
    name_codespace        :=p_name_codespace,
    description           :=p_description,
    envelope              :=p_envelope,
    creation_date         :=p_creation_date,
    termination_date      :=p_termination_date,
    relative_to_terrain   :=p_relative_to_terrain,
    relative_to_water     :=p_relative_to_water,
    last_modification_date:=p_last_modification_date,
    updating_person       :=p_updating_person,
    reason_for_update     :=p_reason_for_update,
    lineage               :=p_lineage,
    schema_name           :=p_schema_name
);
PERFORM citydb_pkg.insert_building(
    id                         :=inserted_id,
    building_parent_id         :=p_building_parent_id,
    building_root_id           :=p_building_root_id,
    class                      :=p_class,
    class_codespace            :=p_class_codespace,
    function                   :=p_function,
    function_codespace         :=p_function_codespace,
    usage                      :=p_usage,
    usage_codespace            :=p_usage_codespace,
    year_of_construction       :=p_year_of_construction,
    year_of_demolition         :=p_year_of_demolition,
    roof_type                  :=p_roof_type,
    roof_type_codespace        :=p_roof_type_codespace,
    measured_height            :=p_measured_height,
    measured_height_unit       :=p_measured_height_unit,
    storeys_above_ground       :=p_storeys_above_ground,
    storeys_below_ground       :=p_storeys_below_ground,
    storey_heights_above_ground:=p_storey_heights_above_ground,
    storey_heights_ag_unit     :=p_storey_heights_ag_unit,
    storey_heights_below_ground:=p_storey_heights_below_ground,
    storey_heights_bg_unit     :=p_storey_heights_bg_unit,
    lod1_terrain_intersection  :=p_lod1_terrain_intersection,
    lod2_terrain_intersection  :=p_lod2_terrain_intersection,
    lod3_terrain_intersection  :=p_lod3_terrain_intersection,
    lod4_terrain_intersection  :=p_lod4_terrain_intersection,
    lod2_multi_curve           :=p_lod2_multi_curve,
    lod3_multi_curve           :=p_lod3_multi_curve,
    lod4_multi_curve           :=p_lod4_multi_curve,
    lod0_footprint_id          :=p_lod0_footprint_id,
    lod0_roofprint_id          :=p_lod0_roofprint_id,
    lod1_multi_surface_id      :=p_lod1_multi_surface_id,
    lod2_multi_surface_id      :=p_lod2_multi_surface_id,
    lod3_multi_surface_id      :=p_lod3_multi_surface_id,
    lod4_multi_surface_id      :=p_lod4_multi_surface_id,
    lod1_solid_id              :=p_lod1_solid_id,
    lod2_solid_id              :=p_lod2_solid_id,
    lod3_solid_id              :=p_lod3_solid_id,
    lod4_solid_id              :=p_lod4_solid_id,
    schema_name                :=p_schema_name
);
PERFORM citydb_pkg.nrg8_insert_building(
    id                         :=inserted_id,
    objectclass_id             :=objectclass_id,
    type                       :=p_type,
    type_codespace             :=p_type_codespace,
    constr_weight              :=p_constr_weight,
    is_landmarked              :=p_is_landmarked,
    ref_point                  :=p_ref_point,
    schema_name                :=p_schema_name
);
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_insert_building(): %', SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function nrg8_INSERT_BUILDING_PART
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.nrg8_insert_building_part(
  id                     integer DEFAULT NULL,
  gmlid                  varchar(256) DEFAULT NULL,
  gmlid_codespace        varchar(1000) DEFAULT NULL,
  name                   varchar(1000) DEFAULT NULL,
  name_codespace         varchar(4000) DEFAULT NULL,
  description            varchar(4000) DEFAULT NULL,
  envelope               geometry DEFAULT NULL,
  creation_date          timestamp(0) with time zone DEFAULT NULL,
  termination_date       timestamp(0) with time zone DEFAULT NULL,
  relative_to_terrain    varchar(256) DEFAULT NULL,
  relative_to_water      varchar(256) DEFAULT NULL,
  last_modification_date timestamp with time zone DEFAULT NULL,
  updating_person        varchar(256) DEFAULT NULL,
  reason_for_update      varchar(4000) DEFAULT NULL,
  lineage                varchar(256) DEFAULT NULL,
--
  building_parent_id integer DEFAULT NULL,
  building_root_id integer DEFAULT NULL,
  class varchar(256) DEFAULT NULL,
  class_codespace varchar(4000) DEFAULT NULL,
  function varchar(1000) DEFAULT NULL,
  function_codespace varchar(4000) DEFAULT NULL,
  usage varchar(1000) DEFAULT NULL,
  usage_codespace varchar(4000) DEFAULT NULL,
  year_of_construction date DEFAULT NULL,
  year_of_demolition date DEFAULT NULL,
  roof_type varchar(256) DEFAULT NULL,
  roof_type_codespace varchar(4000) DEFAULT NULL,
  measured_height double precision DEFAULT NULL,
  measured_height_unit varchar(4000) DEFAULT NULL,
  storeys_above_ground numeric(8) DEFAULT NULL,
  storeys_below_ground numeric(8) DEFAULT NULL,
  storey_heights_above_ground varchar(4000) DEFAULT NULL,
  storey_heights_ag_unit varchar(4000) DEFAULT NULL,
  storey_heights_below_ground varchar(4000) DEFAULT NULL,
  storey_heights_bg_unit varchar(4000) DEFAULT NULL,
  lod1_terrain_intersection public.geometry DEFAULT NULL,
  lod2_terrain_intersection public.geometry DEFAULT NULL,
  lod3_terrain_intersection public.geometry DEFAULT NULL,
  lod4_terrain_intersection public.geometry DEFAULT NULL,
  lod2_multi_curve public.geometry DEFAULT NULL,
  lod3_multi_curve public.geometry DEFAULT NULL,
  lod4_multi_curve public.geometry DEFAULT NULL,
  lod0_footprint_id integer DEFAULT NULL,
  lod0_roofprint_id integer DEFAULT NULL,
  lod1_multi_surface_id integer DEFAULT NULL,
  lod2_multi_surface_id integer DEFAULT NULL,
  lod3_multi_surface_id integer DEFAULT NULL,
  lod4_multi_surface_id integer DEFAULT NULL,
  lod1_solid_id integer DEFAULT NULL,
  lod2_solid_id integer DEFAULT NULL,
  lod3_solid_id integer DEFAULT NULL,
  lod4_solid_id integer DEFAULT NULL,
--
  type varchar DEFAULT NULL,
  type_codespace varchar DEFAULT NULL,
  constr_weight varchar DEFAULT NULL,
  is_landmarked numeric(1) DEFAULT NULL,
  ref_point public.geometry DEFAULT NULL,
--
  schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
  p_id                     integer                     := id                    ;
  p_gmlid                  varchar(256)                := gmlid                 ;
  p_gmlid_codespace        varchar(1000)               := gmlid_codespace       ;
  p_name                   varchar(1000)               := name                  ;
  p_name_codespace         varchar(4000)               := name_codespace        ;
  p_description            varchar(4000)               := description           ;
  p_envelope               geometry                    := envelope              ;
  p_creation_date          timestamp(0) with time zone := creation_date         ;
  p_termination_date       timestamp(0) with time zone := termination_date      ;
  p_relative_to_terrain    varchar(256)                := relative_to_terrain   ;
  p_relative_to_water      varchar(256)                := relative_to_water     ;
  p_last_modification_date timestamp with time zone    := last_modification_date;
  p_updating_person        varchar(256)                := updating_person       ;
  p_reason_for_update      varchar(4000)               := reason_for_update     ;
  p_lineage                varchar(256)                := lineage               ;
--
  p_building_parent_id          integer          := building_parent_id         ;
  p_building_root_id            integer          := building_root_id           ;
  p_class                       varchar(256)     := class                      ;
  p_class_codespace             varchar(4000)    := class_codespace            ;
  p_function                    varchar(1000)    := function                   ;
  p_function_codespace          varchar(4000)    := function_codespace         ;
  p_usage                       varchar(1000)    := usage                      ;
  p_usage_codespace             varchar(4000)    := usage_codespace            ;
  p_year_of_construction        date             := year_of_construction       ;
  p_year_of_demolition          date             := year_of_demolition         ;
  p_roof_type                   varchar(256)     := roof_type                  ;
  p_roof_type_codespace         varchar(4000)    := roof_type_codespace        ;
  p_measured_height             double precision := measured_height            ;
  p_measured_height_unit        varchar(4000)    := measured_height_unit       ;
  p_storeys_above_ground        numeric(8)       := storeys_above_ground       ;
  p_storeys_below_ground        numeric(8)       := storeys_below_ground       ;
  p_storey_heights_above_ground varchar(4000)    := storey_heights_above_ground;
  p_storey_heights_ag_unit      varchar(4000)    := storey_heights_ag_unit     ;
  p_storey_heights_below_ground varchar(4000)    := storey_heights_below_ground;
  p_storey_heights_bg_unit      varchar(4000)    := storey_heights_bg_unit     ;
  p_lod1_terrain_intersection   geometry         := lod1_terrain_intersection  ;
  p_lod2_terrain_intersection   geometry         := lod2_terrain_intersection  ;
  p_lod3_terrain_intersection   geometry         := lod3_terrain_intersection  ;
  p_lod4_terrain_intersection   geometry         := lod4_terrain_intersection  ;
  p_lod2_multi_curve            geometry         := lod2_multi_curve           ;
  p_lod3_multi_curve            geometry         := lod3_multi_curve           ;
  p_lod4_multi_curve            geometry         := lod4_multi_curve           ;
  p_lod0_footprint_id           integer          := lod0_footprint_id          ;
  p_lod0_roofprint_id           integer          := lod0_roofprint_id          ;
  p_lod1_multi_surface_id       integer          := lod1_multi_surface_id      ;
  p_lod2_multi_surface_id       integer          := lod2_multi_surface_id      ;
  p_lod3_multi_surface_id       integer          := lod3_multi_surface_id      ;
  p_lod4_multi_surface_id       integer          := lod4_multi_surface_id      ;
  p_lod1_solid_id               integer          := lod1_solid_id              ;
  p_lod2_solid_id               integer          := lod2_solid_id              ;
  p_lod3_solid_id               integer          := lod3_solid_id              ;
  p_lod4_solid_id               integer          := lod4_solid_id              ;
--
  p_type           varchar  := type          ;
  p_type_codespace varchar  := type_codespace;
  p_constr_weight  varchar  := constr_weight ;
  p_is_landmarked  numeric  := is_landmarked ;
  p_ref_point      geometry := ref_point     ;
--
  p_schema_name varchar := schema_name;
  class_name varchar DEFAULT 'BuildingPart'::varchar;
  db_prefix varchar DEFAULT NULL;
  objectclass_id integer;
  inserted_id integer;
BEGIN
objectclass_id=citydb_pkg.objectclass_classname_to_id(class_name, db_prefix, p_schema_name);

inserted_id=citydb_pkg.insert_cityobject(
    id                    :=p_id,
    objectclass_id        :=objectclass_id,
    gmlid                 :=p_gmlid,
    gmlid_codespace       :=p_gmlid_codespace,
    name                  :=p_name,
    name_codespace        :=p_name_codespace,
    description           :=p_description,
    envelope              :=p_envelope,
    creation_date         :=p_creation_date,
    termination_date      :=p_termination_date,
    relative_to_terrain   :=p_relative_to_terrain,
    relative_to_water     :=p_relative_to_water,
    last_modification_date:=p_last_modification_date,
    updating_person       :=p_updating_person,
    reason_for_update     :=p_reason_for_update,
    lineage               :=p_lineage,
    schema_name           :=p_schema_name
);
PERFORM citydb_pkg.insert_building(
    id                         :=inserted_id,
    objectclass_id             :=objectclass_id,
    building_parent_id         :=p_building_parent_id,
    building_root_id           :=p_building_root_id,
    class                      :=p_class,
    class_codespace            :=p_class_codespace,
    function                   :=p_function,
    function_codespace         :=p_function_codespace,
    usage                      :=p_usage,
    usage_codespace            :=p_usage_codespace,
    year_of_construction       :=p_year_of_construction,
    year_of_demolition         :=p_year_of_demolition,
    roof_type                  :=p_roof_type,
    roof_type_codespace        :=p_roof_type_codespace,
    measured_height            :=p_measured_height,
    measured_height_unit       :=p_measured_height_unit,
    storeys_above_ground       :=p_storeys_above_ground,
    storeys_below_ground       :=p_storeys_below_ground,
    storey_heights_above_ground:=p_storey_heights_above_ground,
    storey_heights_ag_unit     :=p_storey_heights_ag_unit,
    storey_heights_below_ground:=p_storey_heights_below_ground,
    storey_heights_bg_unit     :=p_storey_heights_bg_unit,
    lod1_terrain_intersection  :=p_lod1_terrain_intersection,
    lod2_terrain_intersection  :=p_lod2_terrain_intersection,
    lod3_terrain_intersection  :=p_lod3_terrain_intersection,
    lod4_terrain_intersection  :=p_lod4_terrain_intersection,
    lod2_multi_curve           :=p_lod2_multi_curve,
    lod3_multi_curve           :=p_lod3_multi_curve,
    lod4_multi_curve           :=p_lod4_multi_curve,
    lod0_footprint_id          :=p_lod0_footprint_id,
    lod0_roofprint_id          :=p_lod0_roofprint_id,
    lod1_multi_surface_id      :=p_lod1_multi_surface_id,
    lod2_multi_surface_id      :=p_lod2_multi_surface_id,
    lod3_multi_surface_id      :=p_lod3_multi_surface_id,
    lod4_multi_surface_id      :=p_lod4_multi_surface_id,
    lod1_solid_id              :=p_lod1_solid_id,
    lod2_solid_id              :=p_lod2_solid_id,
    lod3_solid_id              :=p_lod3_solid_id,
    lod4_solid_id              :=p_lod4_solid_id,
    schema_name                :=p_schema_name
);
PERFORM citydb_pkg.nrg8_insert_building(
    id                         :=inserted_id,
    objectclass_id             :=objectclass_id,
    type                       :=p_type,
    type_codespace             :=p_type_codespace,
    constr_weight              :=p_constr_weight,
    is_landmarked              :=p_is_landmarked,
    ref_point                  :=p_ref_point,
    schema_name                :=p_schema_name
);
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_insert_building_part(): %', SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function INSERT_BUILDING_UNIT
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.nrg8_insert_building_unit(
  id                     integer DEFAULT NULL,
  gmlid                  varchar(256) DEFAULT NULL,
  gmlid_codespace        varchar(1000) DEFAULT NULL,
  name                   varchar(1000) DEFAULT NULL,
  name_codespace         varchar(4000) DEFAULT NULL,
  description            varchar(4000) DEFAULT NULL,
  envelope               geometry DEFAULT NULL,
  creation_date          timestamp(0) with time zone DEFAULT NULL,
  termination_date       timestamp(0) with time zone DEFAULT NULL,
  relative_to_terrain    varchar(256) DEFAULT NULL,
  relative_to_water      varchar(256) DEFAULT NULL,
  last_modification_date timestamp with time zone DEFAULT NULL,
  updating_person        varchar(256) DEFAULT NULL,
  reason_for_update      varchar(4000) DEFAULT NULL,
  lineage                varchar(256) DEFAULT NULL,
--
  nbr_of_rooms  integer DEFAULT NULL,
  owner_name    character varying DEFAULT NULL,
  ownership_type  character varying DEFAULT NULL,
  usage_zone_id integer DEFAULT NULL,
--
  schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
  p_id                     integer                     := id                    ;
  p_gmlid                  varchar(256)                := gmlid                 ;
  p_gmlid_codespace        varchar(1000)               := gmlid_codespace       ;
  p_name                   varchar(1000)               := name                  ;
  p_name_codespace         varchar(4000)               := name_codespace        ;
  p_description            varchar(4000)               := description           ;
  p_envelope               geometry                    := envelope              ;
  p_creation_date          timestamp(0) with time zone := creation_date         ;
  p_termination_date       timestamp(0) with time zone := termination_date      ;
  p_relative_to_terrain    varchar(256)                := relative_to_terrain   ;
  p_relative_to_water      varchar(256)                := relative_to_water     ;
  p_last_modification_date timestamp with time zone    := last_modification_date;
  p_updating_person        varchar(256)                := updating_person       ;
  p_reason_for_update      varchar(4000)               := reason_for_update     ;
  p_lineage                varchar(256)                := lineage               ;
--
  p_nbr_of_rooms           integer           := nbr_of_rooms ;
  p_owner_name             character varying := owner_name   ;
  p_ownership_type         character varying := ownership_type ;
  p_usage_zone_id          integer           := usage_zone_id;
--
	p_schema_name varchar := schema_name;
  class_name varchar DEFAULT 'BuildingUnit'::varchar;
  db_prefix varchar DEFAULT 'nrg8';
  objectclass_id integer;
  inserted_id integer;
BEGIN
objectclass_id=citydb_pkg.objectclass_classname_to_id(class_name, db_prefix, p_schema_name);

inserted_id=citydb_pkg.insert_cityobject(
    id                    :=p_id,
    objectclass_id        :=objectclass_id,
    gmlid                 :=p_gmlid,
    gmlid_codespace       :=p_gmlid_codespace,
    name                  :=p_name,
    name_codespace        :=p_name_codespace,
    description           :=p_description,
    envelope              :=p_envelope,
    creation_date         :=p_creation_date,
    termination_date      :=p_termination_date,
    relative_to_terrain   :=p_relative_to_terrain,
    relative_to_water     :=p_relative_to_water,
    last_modification_date:=p_last_modification_date,
    updating_person       :=p_updating_person,
    reason_for_update     :=p_reason_for_update,
    lineage               :=p_lineage,
    schema_name           :=p_schema_name
);
PERFORM citydb_pkg.nrg8_insert_building_unit(
    id             :=inserted_id,
    objectclass_id :=objectclass_id,
    nbr_of_rooms   :=p_nbr_of_rooms,
    owner_name     :=p_owner_name,
    ownership_type :=p_ownership_type,
    usage_zone_id  :=p_usage_zone_id,
    schema_name    :=p_schema_name
);
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_insert_building_unit(): %', SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function INSERT_BASE_CONSTRUCTION
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.nrg8_insert_base_construction(
  id                       integer DEFAULT NULL,
  gmlid                    character varying DEFAULT NULL,
  gmlid_codespace          character varying DEFAULT NULL,
  name                     character varying DEFAULT NULL,
  name_codespace           character varying DEFAULT NULL,
  description              text DEFAULT NULL,
  u_value                  numeric DEFAULT NULL,
  u_value_unit             character varying DEFAULT NULL,
  glazing_ratio            numeric DEFAULT NULL,
  start_of_life            date DEFAULT NULL,
  life_expect_value        numeric DEFAULT NULL,
  life_expect_value_unit   character varying DEFAULT NULL,
  main_maint_interval      numeric DEFAULT NULL,
  main_maint_interval_unit character varying DEFAULT NULL,
--
  schema_name              varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
  p_id                       integer           := id;
  p_gmlid                    character varying := gmlid;
  p_gmlid_codespace          character varying := gmlid_codespace;
  p_name                     character varying := name;
  p_name_codespace           character varying := name_codespace;
  p_description              text              := description;
  p_u_value                  numeric           := u_value;
  p_u_value_unit             character varying := u_value_unit;
  p_glazing_ratio            numeric           := glazing_ratio;
  p_start_of_life            date              := start_of_life;
  p_life_expect_value        numeric           := life_expect_value;
  p_life_expect_value_unit   character varying := life_expect_value_unit;
  p_main_maint_interval      numeric           := main_maint_interval;
  p_main_maint_interval_unit character varying := main_maint_interval_unit;
--
  p_schema_name varchar := schema_name;
  class_name varchar DEFAULT 'Construction'::varchar;
  db_prefix varchar DEFAULT 'nrg8';
  objectclass_id integer;
  inserted_id integer;
BEGIN
objectclass_id=citydb_pkg.objectclass_classname_to_id(class_name, db_prefix, p_schema_name);

inserted_id=citydb_pkg.nrg8_insert_construction(
    id                      :=p_id,
    objectclass_id          :=objectclass_id,
    gmlid                   :=p_gmlid,
    gmlid_codespace         :=p_gmlid_codespace,
    name                    :=p_name,
    name_codespace          :=p_name_codespace,
    description             :=p_description,
    u_value                 :=p_u_value,
    u_value_unit            :=p_u_value_unit,
    glazing_ratio           :=p_glazing_ratio,
    start_of_life           :=p_start_of_life,
    life_expect_value       :=p_life_expect_value,
    life_expect_value_unit  :=p_life_expect_value_unit,
    main_maint_interval     :=p_main_maint_interval,
    main_maint_interval_unit:=p_main_maint_interval_unit,
    schema_name             :=p_schema_name
);
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_insert_base_construction(): %', SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function INSERT_CONSTRUCTION_REVERSE
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.nrg8_insert_reverse_construction(
  base_constr_id       integer,
  id                   integer DEFAULT NULL,
  gmlid                character varying DEFAULT NULL,
  gmlid_codespace      character varying DEFAULT NULL,
  name                 character varying DEFAULT NULL,
  name_codespace       character varying DEFAULT NULL,
  description          text DEFAULT NULL,
--
  schema_name          varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
  p_id                 integer            := id             ;
  p_gmlid              character varying  := gmlid          ;
  p_gmlid_codespace    character varying  := gmlid_codespace;
  p_name               character varying  := name           ;
  p_name_codespace     character varying  := name_codespace ;
  p_description        text               := description    ;
  p_base_constr_id     integer            := base_constr_id ;
--
  p_schema_name varchar := schema_name;
  class_name varchar DEFAULT 'ReverseConstruction'::varchar;
  db_prefix varchar DEFAULT 'nrg8';
  objectclass_id integer;
  inserted_id integer;
BEGIN
objectclass_id=citydb_pkg.objectclass_classname_to_id(class_name, db_prefix, p_schema_name);

inserted_id=citydb_pkg.nrg8_insert_construction(
    id             :=p_id,
    objectclass_id :=objectclass_id,
    gmlid          :=p_gmlid,
    gmlid_codespace:=p_gmlid_codespace,
    name           :=p_name,
    name_codespace :=p_name_codespace,
    description    :=p_description,
    base_constr_id :=p_base_constr_id,
    schema_name    :=p_schema_name
);
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_insert_reverse_construction(): %', SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function INSERT_CONV_SYSTEM
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.nrg8_insert_conv_system(
  id                     integer DEFAULT NULL,
  gmlid                  varchar(256) DEFAULT NULL,
  gmlid_codespace        varchar(1000) DEFAULT NULL,
  name                   varchar(1000) DEFAULT NULL,
  name_codespace         varchar(4000) DEFAULT NULL,
  description            varchar(4000) DEFAULT NULL,
  envelope               geometry DEFAULT NULL,
  creation_date          timestamp(0) with time zone DEFAULT NULL,
  termination_date       timestamp(0) with time zone DEFAULT NULL,
  relative_to_terrain    varchar(256) DEFAULT NULL,
  relative_to_water      varchar(256) DEFAULT NULL,
  last_modification_date timestamp with time zone DEFAULT NULL,
  updating_person        varchar(256) DEFAULT NULL,
  reason_for_update      varchar(4000) DEFAULT NULL,
  lineage                varchar(256) DEFAULT NULL,
--
  model                    character varying DEFAULT NULL,
  nbr                      integer DEFAULT NULL,
  year_of_manufacture      integer DEFAULT NULL,
  inst_nom_pwr             numeric DEFAULT NULL,
  inst_nom_pwr_unit        character varying DEFAULT NULL,
  nom_effcy                numeric DEFAULT NULL,
  effcy_indicator          character varying DEFAULT NULL,
  start_of_life            date DEFAULT NULL,
  life_expect_value        numeric DEFAULT NULL,
  life_expect_value_unit   character varying DEFAULT NULL,
  main_maint_interval      numeric DEFAULT NULL,
  main_maint_interval_unit character varying DEFAULT NULL,
  inst_in_ctyobj_id        integer DEFAULT NULL,
  cityobject_id            integer DEFAULT NULL,
--
  schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
  p_id                     integer                     := id                    ;
  p_gmlid                  varchar(256)                := gmlid                 ;
  p_gmlid_codespace        varchar(1000)               := gmlid_codespace       ;
  p_name                   varchar(1000)               := name                  ;
  p_name_codespace         varchar(4000)               := name_codespace        ;
  p_description            varchar(4000)               := description           ;
  p_envelope               geometry                    := envelope              ;
  p_creation_date          timestamp(0) with time zone := creation_date         ;
  p_termination_date       timestamp(0) with time zone := termination_date      ;
  p_relative_to_terrain    varchar(256)                := relative_to_terrain   ;
  p_relative_to_water      varchar(256)                := relative_to_water     ;
  p_last_modification_date timestamp with time zone    := last_modification_date;
  p_updating_person        varchar(256)                := updating_person       ;
  p_reason_for_update      varchar(4000)               := reason_for_update     ;
  p_lineage                varchar(256)                := lineage               ;
--
  p_model                    varchar := model                   ;
  p_nbr                      integer := nbr                     ;
  p_year_of_manufacture      integer := year_of_manufacture     ;
  p_inst_nom_pwr             numeric := inst_nom_pwr            ;
  p_inst_nom_pwr_unit        varchar := inst_nom_pwr_unit       ;
  p_nom_effcy                numeric := nom_effcy               ;
  p_effcy_indicator          varchar := effcy_indicator         ;
  p_start_of_life            date    := start_of_life           ;
  p_life_expect_value        numeric := life_expect_value       ;
  p_life_expect_value_unit   varchar := life_expect_value_unit  ;
  p_main_maint_interval      numeric := main_maint_interval     ;
  p_main_maint_interval_unit varchar := main_maint_interval_unit;
  p_inst_in_ctyobj_id        integer := inst_in_ctyobj_id       ;
  p_cityobject_id            integer := cityobject_id           ;
--
  p_schema_name varchar := schema_name;
	class_name varchar DEFAULT 'EnergyConversionSystem'::varchar;
	db_prefix varchar DEFAULT 'nrg8';
	objectclass_id integer;
	inserted_id integer;
BEGIN
objectclass_id=citydb_pkg.objectclass_classname_to_id(class_name, db_prefix, p_schema_name);

inserted_id=citydb_pkg.insert_cityobject(
    id                    :=p_id,
    objectclass_id        :=objectclass_id,
    gmlid                 :=p_gmlid,
    gmlid_codespace       :=p_gmlid_codespace,
    name                  :=p_name,
    name_codespace        :=p_name_codespace,
    description           :=p_description,
    envelope              :=p_envelope,
    creation_date         :=p_creation_date,
    termination_date      :=p_termination_date,
    relative_to_terrain   :=p_relative_to_terrain,
    relative_to_water     :=p_relative_to_water,
    last_modification_date:=p_last_modification_date,
    updating_person       :=p_updating_person,
    reason_for_update     :=p_reason_for_update,
    lineage               :=p_lineage,
    schema_name           :=p_schema_name
);
PERFORM citydb_pkg.nrg8_insert_conv_system(
    id                      :=inserted_id,
    objectclass_id          :=objectclass_id,
    model                   :=p_model,
    nbr                     :=p_nbr,
    year_of_manufacture     :=p_year_of_manufacture,
    inst_nom_pwr            :=p_inst_nom_pwr,
    inst_nom_pwr_unit       :=p_inst_nom_pwr_unit,
    nom_effcy               :=p_nom_effcy,
    effcy_indicator         :=p_effcy_indicator,
    start_of_life           :=p_start_of_life,
    life_expect_value       :=p_life_expect_value,
    life_expect_value_unit  :=p_life_expect_value_unit,
    main_maint_interval     :=p_main_maint_interval,
    main_maint_interval_unit:=p_main_maint_interval_unit,
    inst_in_ctyobj_id       :=p_inst_in_ctyobj_id,
    cityobject_id           :=p_cityobject_id,
    schema_name             :=p_schema_name
);
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_insert_conv_system(): %', SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function INSERT_AIR_COMPRESSOR
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.nrg8_insert_air_compressor(
  id                     integer DEFAULT NULL,
  gmlid                  varchar(256) DEFAULT NULL,
  gmlid_codespace        varchar(1000) DEFAULT NULL,
  name                   varchar(1000) DEFAULT NULL,
  name_codespace         varchar(4000) DEFAULT NULL,
  description            varchar(4000) DEFAULT NULL,
  envelope               geometry DEFAULT NULL,
  creation_date          timestamp(0) with time zone DEFAULT NULL,
  termination_date       timestamp(0) with time zone DEFAULT NULL,
  relative_to_terrain    varchar(256) DEFAULT NULL,
  relative_to_water      varchar(256) DEFAULT NULL,
  last_modification_date timestamp with time zone DEFAULT NULL,
  updating_person        varchar(256) DEFAULT NULL,
  reason_for_update      varchar(4000) DEFAULT NULL,
  lineage                varchar(256) DEFAULT NULL,
--
  model                    character varying DEFAULT NULL,
  nbr                      integer DEFAULT NULL,
  year_of_manufacture      integer DEFAULT NULL,
  inst_nom_pwr             numeric DEFAULT NULL,
  inst_nom_pwr_unit        character varying DEFAULT NULL,
  nom_effcy                numeric DEFAULT NULL,
  effcy_indicator          character varying DEFAULT NULL,
  start_of_life            date DEFAULT NULL,
  life_expect_value        numeric DEFAULT NULL,
  life_expect_value_unit   character varying DEFAULT NULL,
  main_maint_interval      numeric DEFAULT NULL,
  main_maint_interval_unit character varying DEFAULT NULL,
  inst_in_ctyobj_id        integer DEFAULT NULL,
  cityobject_id            integer DEFAULT NULL,
--
  compressor_type varchar DEFAULT NULL,
  pressure        numeric DEFAULT NULL,
  pressure_unit   varchar DEFAULT NULL,
--
  schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
  p_id                     integer                     := id                    ;
  p_gmlid                  varchar(256)                := gmlid                 ;
  p_gmlid_codespace        varchar(1000)               := gmlid_codespace       ;
  p_name                   varchar(1000)               := name                  ;
  p_name_codespace         varchar(4000)               := name_codespace        ;
  p_description            varchar(4000)               := description           ;
  p_envelope               geometry                    := envelope              ;
  p_creation_date          timestamp(0) with time zone := creation_date         ;
  p_termination_date       timestamp(0) with time zone := termination_date      ;
  p_relative_to_terrain    varchar(256)                := relative_to_terrain   ;
  p_relative_to_water      varchar(256)                := relative_to_water     ;
  p_last_modification_date timestamp with time zone    := last_modification_date;
  p_updating_person        varchar(256)                := updating_person       ;
  p_reason_for_update      varchar(4000)               := reason_for_update     ;
  p_lineage                varchar(256)                := lineage               ;
--
  p_model                    varchar := model                   ;
  p_nbr                      integer := nbr                     ;
  p_year_of_manufacture      integer := year_of_manufacture     ;
  p_inst_nom_pwr             numeric := inst_nom_pwr            ;
  p_inst_nom_pwr_unit        varchar := inst_nom_pwr_unit       ;
  p_nom_effcy                numeric := nom_effcy               ;
  p_effcy_indicator          varchar := effcy_indicator         ;
  p_start_of_life            date    := start_of_life           ;
  p_life_expect_value        numeric := life_expect_value       ;
  p_life_expect_value_unit   varchar := life_expect_value_unit  ;
  p_main_maint_interval      numeric := main_maint_interval     ;
  p_main_maint_interval_unit varchar := main_maint_interval_unit;
  p_inst_in_ctyobj_id        integer := inst_in_ctyobj_id       ;
  p_cityobject_id            integer := cityobject_id           ;
--
  p_compressor_type varchar := compressor_type;
  p_pressure        numeric := pressure       ;
  p_pressure_unit   varchar := pressure_unit  ;
--
  p_schema_name varchar := schema_name;
	class_name varchar DEFAULT 'AirCompressor'::varchar;
	db_prefix varchar DEFAULT 'nrg8';
	objectclass_id integer;
	inserted_id integer;
BEGIN
objectclass_id=citydb_pkg.objectclass_classname_to_id(class_name, db_prefix, p_schema_name);

inserted_id=citydb_pkg.insert_cityobject(
    id                    :=p_id,
    objectclass_id        :=objectclass_id,
    gmlid                 :=p_gmlid,
    gmlid_codespace       :=p_gmlid_codespace,
    name                  :=p_name,
    name_codespace        :=p_name_codespace,
    description           :=p_description,
    envelope              :=p_envelope,
    creation_date         :=p_creation_date,
    termination_date      :=p_termination_date,
    relative_to_terrain   :=p_relative_to_terrain,
    relative_to_water     :=p_relative_to_water,
    last_modification_date:=p_last_modification_date,
    updating_person       :=p_updating_person,
    reason_for_update     :=p_reason_for_update,
    lineage               :=p_lineage,
    schema_name           :=p_schema_name
);
PERFORM citydb_pkg.nrg8_insert_conv_system(
    id                      :=inserted_id,
    objectclass_id          :=objectclass_id,
    model                   :=p_model,
    nbr                     :=p_nbr,
    year_of_manufacture     :=p_year_of_manufacture,
    inst_nom_pwr            :=p_inst_nom_pwr,
    inst_nom_pwr_unit       :=p_inst_nom_pwr_unit,
    nom_effcy               :=p_nom_effcy,
    effcy_indicator         :=p_effcy_indicator,
    start_of_life           :=p_start_of_life,
    life_expect_value       :=p_life_expect_value,
    life_expect_value_unit  :=p_life_expect_value_unit,
    main_maint_interval     :=p_main_maint_interval,
    main_maint_interval_unit:=p_main_maint_interval_unit,
    inst_in_ctyobj_id       :=p_inst_in_ctyobj_id,
    cityobject_id           :=p_cityobject_id,
    schema_name             :=p_schema_name
);
PERFORM citydb_pkg.nrg8_insert_air_compressor(
    id             :=inserted_id,
    objectclass_id :=objectclass_id,
    compressor_type:=p_compressor_type,
    pressure       :=p_pressure,
    pressure_unit  :=p_pressure_unit,
    schema_name    :=p_schema_name
);
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_insert_air_compressor(): %', SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function INSERT_BOILER
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.nrg8_insert_boiler(
  id                     integer DEFAULT NULL,
  gmlid                  varchar(256) DEFAULT NULL,
  gmlid_codespace        varchar(1000) DEFAULT NULL,
  name                   varchar(1000) DEFAULT NULL,
  name_codespace         varchar(4000) DEFAULT NULL,
  description            varchar(4000) DEFAULT NULL,
  envelope               geometry DEFAULT NULL,
  creation_date          timestamp(0) with time zone DEFAULT NULL,
  termination_date       timestamp(0) with time zone DEFAULT NULL,
  relative_to_terrain    varchar(256) DEFAULT NULL,
  relative_to_water      varchar(256) DEFAULT NULL,
  last_modification_date timestamp with time zone DEFAULT NULL,
  updating_person        varchar(256) DEFAULT NULL,
  reason_for_update      varchar(4000) DEFAULT NULL,
  lineage                varchar(256) DEFAULT NULL,
--
  model                    character varying DEFAULT NULL,
  nbr                      integer DEFAULT NULL,
  year_of_manufacture      integer DEFAULT NULL,
  inst_nom_pwr             numeric DEFAULT NULL,
  inst_nom_pwr_unit        character varying DEFAULT NULL,
  nom_effcy                numeric DEFAULT NULL,
  effcy_indicator          character varying DEFAULT NULL,
  start_of_life            date DEFAULT NULL,
  life_expect_value        numeric DEFAULT NULL,
  life_expect_value_unit   character varying DEFAULT NULL,
  main_maint_interval      numeric DEFAULT NULL,
  main_maint_interval_unit character varying DEFAULT NULL,
  inst_in_ctyobj_id        integer DEFAULT NULL,
  cityobject_id            integer DEFAULT NULL,
--
  condensation numeric(1) DEFAULT NULL,
--
  schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
  p_id                     integer                     := id                    ;
  p_gmlid                  varchar(256)                := gmlid                 ;
  p_gmlid_codespace        varchar(1000)               := gmlid_codespace       ;
  p_name                   varchar(1000)               := name                  ;
  p_name_codespace         varchar(4000)               := name_codespace        ;
  p_description            varchar(4000)               := description           ;
  p_envelope               geometry                    := envelope              ;
  p_creation_date          timestamp(0) with time zone := creation_date         ;
  p_termination_date       timestamp(0) with time zone := termination_date      ;
  p_relative_to_terrain    varchar(256)                := relative_to_terrain   ;
  p_relative_to_water      varchar(256)                := relative_to_water     ;
  p_last_modification_date timestamp with time zone    := last_modification_date;
  p_updating_person        varchar(256)                := updating_person       ;
  p_reason_for_update      varchar(4000)               := reason_for_update     ;
  p_lineage                varchar(256)                := lineage               ;
--
  p_model                    varchar := model                   ;
  p_nbr                      integer := nbr                     ;
  p_year_of_manufacture      integer := year_of_manufacture     ;
  p_inst_nom_pwr             numeric := inst_nom_pwr            ;
  p_inst_nom_pwr_unit        varchar := inst_nom_pwr_unit       ;
  p_nom_effcy                numeric := nom_effcy               ;
  p_effcy_indicator          varchar := effcy_indicator         ;
  p_start_of_life            date    := start_of_life           ;
  p_life_expect_value        numeric := life_expect_value       ;
  p_life_expect_value_unit   varchar := life_expect_value_unit  ;
  p_main_maint_interval      numeric := main_maint_interval     ;
  p_main_maint_interval_unit varchar := main_maint_interval_unit;
  p_inst_in_ctyobj_id        integer := inst_in_ctyobj_id       ;
  p_cityobject_id            integer := cityobject_id           ;
--
  p_condensation numeric(1) := condensation;
--
  p_schema_name varchar := schema_name;
	class_name varchar DEFAULT 'Boiler'::varchar;
	db_prefix varchar DEFAULT 'nrg8';
	objectclass_id integer;
	inserted_id integer;
BEGIN
objectclass_id=citydb_pkg.objectclass_classname_to_id(class_name, db_prefix, p_schema_name);

inserted_id=citydb_pkg.insert_cityobject(
    id                    :=p_id,
    objectclass_id        :=objectclass_id,
    gmlid                 :=p_gmlid,
    gmlid_codespace       :=p_gmlid_codespace,
    name                  :=p_name,
    name_codespace        :=p_name_codespace,
    description           :=p_description,
    envelope              :=p_envelope,
    creation_date         :=p_creation_date,
    termination_date      :=p_termination_date,
    relative_to_terrain   :=p_relative_to_terrain,
    relative_to_water     :=p_relative_to_water,
    last_modification_date:=p_last_modification_date,
    updating_person       :=p_updating_person,
    reason_for_update     :=p_reason_for_update,
    lineage               :=p_lineage,
    schema_name           :=p_schema_name
);
PERFORM citydb_pkg.nrg8_insert_conv_system(
    id                      :=inserted_id,
    objectclass_id          :=objectclass_id,
    model                   :=p_model,
    nbr                     :=p_nbr,
    year_of_manufacture     :=p_year_of_manufacture,
    inst_nom_pwr            :=p_inst_nom_pwr,
    inst_nom_pwr_unit       :=p_inst_nom_pwr_unit,
    nom_effcy               :=p_nom_effcy,
    effcy_indicator         :=p_effcy_indicator,
    start_of_life           :=p_start_of_life,
    life_expect_value       :=p_life_expect_value,
    life_expect_value_unit  :=p_life_expect_value_unit,
    main_maint_interval     :=p_main_maint_interval,
    main_maint_interval_unit:=p_main_maint_interval_unit,
    inst_in_ctyobj_id       :=p_inst_in_ctyobj_id,
    cityobject_id           :=p_cityobject_id,
    schema_name             :=p_schema_name
);
PERFORM citydb_pkg.nrg8_insert_boiler(
    id             :=inserted_id,
    objectclass_id :=objectclass_id,
    condensation   :=p_condensation,
    schema_name    :=p_schema_name
);
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_insert_boiler(): %', SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function INSERT_CHILLER
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.nrg8_insert_chiller(
  id                     integer DEFAULT NULL,
  gmlid                  varchar(256) DEFAULT NULL,
  gmlid_codespace        varchar(1000) DEFAULT NULL,
  name                   varchar(1000) DEFAULT NULL,
  name_codespace         varchar(4000) DEFAULT NULL,
  description            varchar(4000) DEFAULT NULL,
  envelope               geometry DEFAULT NULL,
  creation_date          timestamp(0) with time zone DEFAULT NULL,
  termination_date       timestamp(0) with time zone DEFAULT NULL,
  relative_to_terrain    varchar(256) DEFAULT NULL,
  relative_to_water      varchar(256) DEFAULT NULL,
  last_modification_date timestamp with time zone DEFAULT NULL,
  updating_person        varchar(256) DEFAULT NULL,
  reason_for_update      varchar(4000) DEFAULT NULL,
  lineage                varchar(256) DEFAULT NULL,
--
  model                    character varying DEFAULT NULL,
  nbr                      integer DEFAULT NULL,
  year_of_manufacture      integer DEFAULT NULL,
  inst_nom_pwr             numeric DEFAULT NULL,
  inst_nom_pwr_unit        character varying DEFAULT NULL,
  nom_effcy                numeric DEFAULT NULL,
  effcy_indicator          character varying DEFAULT NULL,
  start_of_life            date DEFAULT NULL,
  life_expect_value        numeric DEFAULT NULL,
  life_expect_value_unit   character varying DEFAULT NULL,
  main_maint_interval      numeric DEFAULT NULL,
  main_maint_interval_unit character varying DEFAULT NULL,
  inst_in_ctyobj_id        integer DEFAULT NULL,
  cityobject_id            integer DEFAULT NULL,
--
  condensation_type varchar DEFAULT NULL,
  compressor_type   varchar DEFAULT NULL,
  refrigerant       varchar DEFAULT NULL,
--
  schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
  p_id                     integer                     := id                    ;
  p_gmlid                  varchar(256)                := gmlid                 ;
  p_gmlid_codespace        varchar(1000)               := gmlid_codespace       ;
  p_name                   varchar(1000)               := name                  ;
  p_name_codespace         varchar(4000)               := name_codespace        ;
  p_description            varchar(4000)               := description           ;
  p_envelope               geometry                    := envelope              ;
  p_creation_date          timestamp(0) with time zone := creation_date         ;
  p_termination_date       timestamp(0) with time zone := termination_date      ;
  p_relative_to_terrain    varchar(256)                := relative_to_terrain   ;
  p_relative_to_water      varchar(256)                := relative_to_water     ;
  p_last_modification_date timestamp with time zone    := last_modification_date;
  p_updating_person        varchar(256)                := updating_person       ;
  p_reason_for_update      varchar(4000)               := reason_for_update     ;
  p_lineage                varchar(256)                := lineage               ;
--
  p_model                    varchar := model                   ;
  p_nbr                      integer := nbr                     ;
  p_year_of_manufacture      integer := year_of_manufacture     ;
  p_inst_nom_pwr             numeric := inst_nom_pwr            ;
  p_inst_nom_pwr_unit        varchar := inst_nom_pwr_unit       ;
  p_nom_effcy                numeric := nom_effcy               ;
  p_effcy_indicator          varchar := effcy_indicator         ;
  p_start_of_life            date    := start_of_life           ;
  p_life_expect_value        numeric := life_expect_value       ;
  p_life_expect_value_unit   varchar := life_expect_value_unit  ;
  p_main_maint_interval      numeric := main_maint_interval     ;
  p_main_maint_interval_unit varchar := main_maint_interval_unit;
  p_inst_in_ctyobj_id        integer := inst_in_ctyobj_id       ;
  p_cityobject_id            integer := cityobject_id           ;
--
  p_condensation_type varchar := condensation_type;
  p_compressor_type   varchar := compressor_type  ;
  p_refrigerant       varchar := refrigerant      ;
--
  p_schema_name varchar := schema_name;
	class_name varchar DEFAULT 'Chiller'::varchar;
	db_prefix varchar DEFAULT 'nrg8';
	objectclass_id integer;
	inserted_id integer;
BEGIN
objectclass_id=citydb_pkg.objectclass_classname_to_id(class_name, db_prefix, p_schema_name);

inserted_id=citydb_pkg.insert_cityobject(
    id                    :=p_id,
    objectclass_id        :=objectclass_id,
    gmlid                 :=p_gmlid,
    gmlid_codespace       :=p_gmlid_codespace,
    name                  :=p_name,
    name_codespace        :=p_name_codespace,
    description           :=p_description,
    envelope              :=p_envelope,
    creation_date         :=p_creation_date,
    termination_date      :=p_termination_date,
    relative_to_terrain   :=p_relative_to_terrain,
    relative_to_water     :=p_relative_to_water,
    last_modification_date:=p_last_modification_date,
    updating_person       :=p_updating_person,
    reason_for_update     :=p_reason_for_update,
    lineage               :=p_lineage,
    schema_name           :=p_schema_name
);
PERFORM citydb_pkg.nrg8_insert_conv_system(
    id                      :=inserted_id,
    objectclass_id          :=objectclass_id,
    model                   :=p_model,
    nbr                     :=p_nbr,
    year_of_manufacture     :=p_year_of_manufacture,
    inst_nom_pwr            :=p_inst_nom_pwr,
    inst_nom_pwr_unit       :=p_inst_nom_pwr_unit,
    nom_effcy               :=p_nom_effcy,
    effcy_indicator         :=p_effcy_indicator,
    start_of_life           :=p_start_of_life,
    life_expect_value       :=p_life_expect_value,
    life_expect_value_unit  :=p_life_expect_value_unit,
    main_maint_interval     :=p_main_maint_interval,
    main_maint_interval_unit:=p_main_maint_interval_unit,
    inst_in_ctyobj_id       :=p_inst_in_ctyobj_id,
    cityobject_id           :=p_cityobject_id,
    schema_name             :=p_schema_name
);
PERFORM citydb_pkg.nrg8_insert_chiller(
    id               :=inserted_id,
    objectclass_id   :=objectclass_id,
    condensation_type:=p_condensation_type,
    compressor_type  :=p_compressor_type,
    refrigerant      :=p_refrigerant,
    schema_name      :=p_schema_name
);
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_insert_chiller(): %', SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function INSERT_COMBINED_HEAT_POWER
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.nrg8_insert_combined_heat_power(
  id                     integer DEFAULT NULL,
  gmlid                  varchar(256) DEFAULT NULL,
  gmlid_codespace        varchar(1000) DEFAULT NULL,
  name                   varchar(1000) DEFAULT NULL,
  name_codespace         varchar(4000) DEFAULT NULL,
  description            varchar(4000) DEFAULT NULL,
  envelope               geometry DEFAULT NULL,
  creation_date          timestamp(0) with time zone DEFAULT NULL,
  termination_date       timestamp(0) with time zone DEFAULT NULL,
  relative_to_terrain    varchar(256) DEFAULT NULL,
  relative_to_water      varchar(256) DEFAULT NULL,
  last_modification_date timestamp with time zone DEFAULT NULL,
  updating_person        varchar(256) DEFAULT NULL,
  reason_for_update      varchar(4000) DEFAULT NULL,
  lineage                varchar(256) DEFAULT NULL,
--
  model                    character varying DEFAULT NULL,
  nbr                      integer DEFAULT NULL,
  year_of_manufacture      integer DEFAULT NULL,
  inst_nom_pwr             numeric DEFAULT NULL,
  inst_nom_pwr_unit        character varying DEFAULT NULL,
  nom_effcy                numeric DEFAULT NULL,
  effcy_indicator          character varying DEFAULT NULL,
  start_of_life            date DEFAULT NULL,
  life_expect_value        numeric DEFAULT NULL,
  life_expect_value_unit   character varying DEFAULT NULL,
  main_maint_interval      numeric DEFAULT NULL,
  main_maint_interval_unit character varying DEFAULT NULL,
  inst_in_ctyobj_id        integer DEFAULT NULL,
  cityobject_id            integer DEFAULT NULL,
--
  techn_type   varchar DEFAULT NULL,
  therm_effcy  numeric DEFAULT NULL,
  electr_effcy numeric DEFAULT NULL,
--
  schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
  p_id                     integer                     := id                    ;
  p_gmlid                  varchar(256)                := gmlid                 ;
  p_gmlid_codespace        varchar(1000)               := gmlid_codespace       ;
  p_name                   varchar(1000)               := name                  ;
  p_name_codespace         varchar(4000)               := name_codespace        ;
  p_description            varchar(4000)               := description           ;
  p_envelope               geometry                    := envelope              ;
  p_creation_date          timestamp(0) with time zone := creation_date         ;
  p_termination_date       timestamp(0) with time zone := termination_date      ;
  p_relative_to_terrain    varchar(256)                := relative_to_terrain   ;
  p_relative_to_water      varchar(256)                := relative_to_water     ;
  p_last_modification_date timestamp with time zone    := last_modification_date;
  p_updating_person        varchar(256)                := updating_person       ;
  p_reason_for_update      varchar(4000)               := reason_for_update     ;
  p_lineage                varchar(256)                := lineage               ;
--
  p_model                    varchar := model                   ;
  p_nbr                      integer := nbr                     ;
  p_year_of_manufacture      integer := year_of_manufacture     ;
  p_inst_nom_pwr             numeric := inst_nom_pwr            ;
  p_inst_nom_pwr_unit        varchar := inst_nom_pwr_unit       ;
  p_nom_effcy                numeric := nom_effcy               ;
  p_effcy_indicator          varchar := effcy_indicator         ;
  p_start_of_life            date    := start_of_life           ;
  p_life_expect_value        numeric := life_expect_value       ;
  p_life_expect_value_unit   varchar := life_expect_value_unit  ;
  p_main_maint_interval      numeric := main_maint_interval     ;
  p_main_maint_interval_unit varchar := main_maint_interval_unit;
  p_inst_in_ctyobj_id        integer := inst_in_ctyobj_id       ;
  p_cityobject_id            integer := cityobject_id           ;
--
  p_techn_type   varchar := techn_type  ;
  p_therm_effcy  numeric := therm_effcy ;
  p_electr_effcy numeric := electr_effcy;
--
  p_schema_name varchar := schema_name;
	class_name varchar DEFAULT 'CombinedHeatPower'::varchar;
	db_prefix varchar DEFAULT 'nrg8';
	objectclass_id integer;
	inserted_id integer;
BEGIN
objectclass_id=citydb_pkg.objectclass_classname_to_id(class_name, db_prefix, p_schema_name);

inserted_id=citydb_pkg.insert_cityobject(
    id                    :=p_id,
    objectclass_id        :=objectclass_id,
    gmlid                 :=p_gmlid,
    gmlid_codespace       :=p_gmlid_codespace,
    name                  :=p_name,
    name_codespace        :=p_name_codespace,
    description           :=p_description,
    envelope              :=p_envelope,
    creation_date         :=p_creation_date,
    termination_date      :=p_termination_date,
    relative_to_terrain   :=p_relative_to_terrain,
    relative_to_water     :=p_relative_to_water,
    last_modification_date:=p_last_modification_date,
    updating_person       :=p_updating_person,
    reason_for_update     :=p_reason_for_update,
    lineage               :=p_lineage,
    schema_name           :=p_schema_name
);
PERFORM citydb_pkg.nrg8_insert_conv_system(
    id                      :=inserted_id,
    objectclass_id          :=objectclass_id,
    model                   :=p_model,
    nbr                     :=p_nbr,
    year_of_manufacture     :=p_year_of_manufacture,
    inst_nom_pwr            :=p_inst_nom_pwr,
    inst_nom_pwr_unit       :=p_inst_nom_pwr_unit,
    nom_effcy               :=p_nom_effcy,
    effcy_indicator         :=p_effcy_indicator,
    start_of_life           :=p_start_of_life,
    life_expect_value       :=p_life_expect_value,
    life_expect_value_unit  :=p_life_expect_value_unit,
    main_maint_interval     :=p_main_maint_interval,
    main_maint_interval_unit:=p_main_maint_interval_unit,
    inst_in_ctyobj_id       :=p_inst_in_ctyobj_id,
    cityobject_id           :=p_cityobject_id,
    schema_name             :=p_schema_name
);
PERFORM citydb_pkg.nrg8_insert_combined_heat_power(
    id             :=inserted_id,
    objectclass_id :=objectclass_id,
    techn_type     :=p_techn_type,
    therm_effcy    :=p_therm_effcy,
    electr_effcy   :=p_electr_effcy,
    schema_name    :=p_schema_name
);
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_insert_combined_heat_power(): %', SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function INSERT_ELECTRICAL_RESISTANCE
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.nrg8_insert_electrical_resistance(
  id                     integer DEFAULT NULL,
  gmlid                  varchar(256) DEFAULT NULL,
  gmlid_codespace        varchar(1000) DEFAULT NULL,
  name                   varchar(1000) DEFAULT NULL,
  name_codespace         varchar(4000) DEFAULT NULL,
  description            varchar(4000) DEFAULT NULL,
  envelope               geometry DEFAULT NULL,
  creation_date          timestamp(0) with time zone DEFAULT NULL,
  termination_date       timestamp(0) with time zone DEFAULT NULL,
  relative_to_terrain    varchar(256) DEFAULT NULL,
  relative_to_water      varchar(256) DEFAULT NULL,
  last_modification_date timestamp with time zone DEFAULT NULL,
  updating_person        varchar(256) DEFAULT NULL,
  reason_for_update      varchar(4000) DEFAULT NULL,
  lineage                varchar(256) DEFAULT NULL,
--
  model                    character varying DEFAULT NULL,
  nbr                      integer DEFAULT NULL,
  year_of_manufacture      integer DEFAULT NULL,
  inst_nom_pwr             numeric DEFAULT NULL,
  inst_nom_pwr_unit        character varying DEFAULT NULL,
  nom_effcy                numeric DEFAULT NULL,
  effcy_indicator          character varying DEFAULT NULL,
  start_of_life            date DEFAULT NULL,
  life_expect_value        numeric DEFAULT NULL,
  life_expect_value_unit   character varying DEFAULT NULL,
  main_maint_interval      numeric DEFAULT NULL,
  main_maint_interval_unit character varying DEFAULT NULL,
  inst_in_ctyobj_id        integer DEFAULT NULL,
  cityobject_id            integer DEFAULT NULL,
--
  schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
  p_id                     integer                     := id                    ;
  p_gmlid                  varchar(256)                := gmlid                 ;
  p_gmlid_codespace        varchar(1000)               := gmlid_codespace       ;
  p_name                   varchar(1000)               := name                  ;
  p_name_codespace         varchar(4000)               := name_codespace        ;
  p_description            varchar(4000)               := description           ;
  p_envelope               geometry                    := envelope              ;
  p_creation_date          timestamp(0) with time zone := creation_date         ;
  p_termination_date       timestamp(0) with time zone := termination_date      ;
  p_relative_to_terrain    varchar(256)                := relative_to_terrain   ;
  p_relative_to_water      varchar(256)                := relative_to_water     ;
  p_last_modification_date timestamp with time zone    := last_modification_date;
  p_updating_person        varchar(256)                := updating_person       ;
  p_reason_for_update      varchar(4000)               := reason_for_update     ;
  p_lineage                varchar(256)                := lineage               ;
--
  p_model                    varchar := model                   ;
  p_nbr                      integer := nbr                     ;
  p_year_of_manufacture      integer := year_of_manufacture     ;
  p_inst_nom_pwr             numeric := inst_nom_pwr            ;
  p_inst_nom_pwr_unit        varchar := inst_nom_pwr_unit       ;
  p_nom_effcy                numeric := nom_effcy               ;
  p_effcy_indicator          varchar := effcy_indicator         ;
  p_start_of_life            date    := start_of_life           ;
  p_life_expect_value        numeric := life_expect_value       ;
  p_life_expect_value_unit   varchar := life_expect_value_unit  ;
  p_main_maint_interval      numeric := main_maint_interval     ;
  p_main_maint_interval_unit varchar := main_maint_interval_unit;
  p_inst_in_ctyobj_id        integer := inst_in_ctyobj_id       ;
  p_cityobject_id            integer := cityobject_id           ;
--
  p_schema_name varchar := schema_name;
	class_name varchar DEFAULT 'ElectricalResistance'::varchar;
	db_prefix varchar DEFAULT 'nrg8';
	objectclass_id integer;
	inserted_id integer;
BEGIN
objectclass_id=citydb_pkg.objectclass_classname_to_id(class_name, db_prefix, p_schema_name);

inserted_id=citydb_pkg.insert_cityobject(
    id                    :=p_id,
    objectclass_id        :=objectclass_id,
    gmlid                 :=p_gmlid,
    gmlid_codespace       :=p_gmlid_codespace,
    name                  :=p_name,
    name_codespace        :=p_name_codespace,
    description           :=p_description,
    envelope              :=p_envelope,
    creation_date         :=p_creation_date,
    termination_date      :=p_termination_date,
    relative_to_terrain   :=p_relative_to_terrain,
    relative_to_water     :=p_relative_to_water,
    last_modification_date:=p_last_modification_date,
    updating_person       :=p_updating_person,
    reason_for_update     :=p_reason_for_update,
    lineage               :=p_lineage,
    schema_name           :=p_schema_name
);
PERFORM citydb_pkg.nrg8_insert_conv_system(
    id                      :=inserted_id,
    objectclass_id          :=objectclass_id,
    model                   :=p_model,
    nbr                     :=p_nbr,
    year_of_manufacture     :=p_year_of_manufacture,
    inst_nom_pwr            :=p_inst_nom_pwr,
    inst_nom_pwr_unit       :=p_inst_nom_pwr_unit,
    nom_effcy               :=p_nom_effcy,
    effcy_indicator         :=p_effcy_indicator,
    start_of_life           :=p_start_of_life,
    life_expect_value       :=p_life_expect_value,
    life_expect_value_unit  :=p_life_expect_value_unit,
    main_maint_interval     :=p_main_maint_interval,
    main_maint_interval_unit:=p_main_maint_interval_unit,
    inst_in_ctyobj_id       :=p_inst_in_ctyobj_id,
    cityobject_id           :=p_cityobject_id,
    schema_name             :=p_schema_name
);
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_insert_electrical_resistance(): %', SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function INSERT_HEAT_EXCHANGER
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.nrg8_insert_heat_exchanger(
  id                     integer DEFAULT NULL,
  gmlid                  varchar(256) DEFAULT NULL,
  gmlid_codespace        varchar(1000) DEFAULT NULL,
  name                   varchar(1000) DEFAULT NULL,
  name_codespace         varchar(4000) DEFAULT NULL,
  description            varchar(4000) DEFAULT NULL,
  envelope               geometry DEFAULT NULL,
  creation_date          timestamp(0) with time zone DEFAULT NULL,
  termination_date       timestamp(0) with time zone DEFAULT NULL,
  relative_to_terrain    varchar(256) DEFAULT NULL,
  relative_to_water      varchar(256) DEFAULT NULL,
  last_modification_date timestamp with time zone DEFAULT NULL,
  updating_person        varchar(256) DEFAULT NULL,
  reason_for_update      varchar(4000) DEFAULT NULL,
  lineage                varchar(256) DEFAULT NULL,
--
  model                    character varying DEFAULT NULL,
  nbr                      integer DEFAULT NULL,
  year_of_manufacture      integer DEFAULT NULL,
  inst_nom_pwr             numeric DEFAULT NULL,
  inst_nom_pwr_unit        character varying DEFAULT NULL,
  nom_effcy                numeric DEFAULT NULL,
  effcy_indicator          character varying DEFAULT NULL,
  start_of_life            date DEFAULT NULL,
  life_expect_value        numeric DEFAULT NULL,
  life_expect_value_unit   character varying DEFAULT NULL,
  main_maint_interval      numeric DEFAULT NULL,
  main_maint_interval_unit character varying DEFAULT NULL,
  inst_in_ctyobj_id        integer DEFAULT NULL,
  cityobject_id            integer DEFAULT NULL,
--
  network_id         integer DEFAULT NULL,
  network_node_id    integer DEFAULT NULL,
  prim_heat_supplier varchar DEFAULT NULL,
--
  schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
  p_id                     integer                     := id                    ;
  p_gmlid                  varchar(256)                := gmlid                 ;
  p_gmlid_codespace        varchar(1000)               := gmlid_codespace       ;
  p_name                   varchar(1000)               := name                  ;
  p_name_codespace         varchar(4000)               := name_codespace        ;
  p_description            varchar(4000)               := description           ;
  p_envelope               geometry                    := envelope              ;
  p_creation_date          timestamp(0) with time zone := creation_date         ;
  p_termination_date       timestamp(0) with time zone := termination_date      ;
  p_relative_to_terrain    varchar(256)                := relative_to_terrain   ;
  p_relative_to_water      varchar(256)                := relative_to_water     ;
  p_last_modification_date timestamp with time zone    := last_modification_date;
  p_updating_person        varchar(256)                := updating_person       ;
  p_reason_for_update      varchar(4000)               := reason_for_update     ;
  p_lineage                varchar(256)                := lineage               ;
--
  p_model                    varchar := model                   ;
  p_nbr                      integer := nbr                     ;
  p_year_of_manufacture      integer := year_of_manufacture     ;
  p_inst_nom_pwr             numeric := inst_nom_pwr            ;
  p_inst_nom_pwr_unit        varchar := inst_nom_pwr_unit       ;
  p_nom_effcy                numeric := nom_effcy               ;
  p_effcy_indicator          varchar := effcy_indicator         ;
  p_start_of_life            date    := start_of_life           ;
  p_life_expect_value        numeric := life_expect_value       ;
  p_life_expect_value_unit   varchar := life_expect_value_unit  ;
  p_main_maint_interval      numeric := main_maint_interval     ;
  p_main_maint_interval_unit varchar := main_maint_interval_unit;
  p_inst_in_ctyobj_id        integer := inst_in_ctyobj_id       ;
  p_cityobject_id            integer := cityobject_id           ;
--
  p_network_id         integer := network_id        ;
  p_network_node_id    integer := network_node_id   ;
  p_prim_heat_supplier varchar := prim_heat_supplier;
--
  p_schema_name varchar := schema_name;
	class_name varchar DEFAULT 'HeatExchanger'::varchar;
	db_prefix varchar DEFAULT 'nrg8';
	objectclass_id integer;
	inserted_id integer;
BEGIN
objectclass_id=citydb_pkg.objectclass_classname_to_id(class_name, db_prefix, p_schema_name);

inserted_id=citydb_pkg.insert_cityobject(
    id                    :=p_id,
    objectclass_id        :=objectclass_id,
    gmlid                 :=p_gmlid,
    gmlid_codespace       :=p_gmlid_codespace,
    name                  :=p_name,
    name_codespace        :=p_name_codespace,
    description           :=p_description,
    envelope              :=p_envelope,
    creation_date         :=p_creation_date,
    termination_date      :=p_termination_date,
    relative_to_terrain   :=p_relative_to_terrain,
    relative_to_water     :=p_relative_to_water,
    last_modification_date:=p_last_modification_date,
    updating_person       :=p_updating_person,
    reason_for_update     :=p_reason_for_update,
    lineage               :=p_lineage,
    schema_name           :=p_schema_name
);
PERFORM citydb_pkg.nrg8_insert_conv_system(
    id                      :=inserted_id,
    objectclass_id          :=objectclass_id,
    model                   :=p_model,
    nbr                     :=p_nbr,
    year_of_manufacture     :=p_year_of_manufacture,
    inst_nom_pwr            :=p_inst_nom_pwr,
    inst_nom_pwr_unit       :=p_inst_nom_pwr_unit,
    nom_effcy               :=p_nom_effcy,
    effcy_indicator         :=p_effcy_indicator,
    start_of_life           :=p_start_of_life,
    life_expect_value       :=p_life_expect_value,
    life_expect_value_unit  :=p_life_expect_value_unit,
    main_maint_interval     :=p_main_maint_interval,
    main_maint_interval_unit:=p_main_maint_interval_unit,
    inst_in_ctyobj_id       :=p_inst_in_ctyobj_id,
    cityobject_id           :=p_cityobject_id,
    schema_name             :=p_schema_name
);
PERFORM citydb_pkg.nrg8_insert_heat_exchanger(
    id                      :=inserted_id,
    objectclass_id          :=objectclass_id,
    network_id              :=p_network_id,
    network_node_id         :=p_network_node_id,
    prim_heat_supplier      :=p_prim_heat_supplier,
    schema_name             :=p_schema_name
);
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_insert_heat_exchanger(): %', SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function INSERT_HEAT_PUMP
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.nrg8_insert_heat_pump(
  id                     integer DEFAULT NULL,
  gmlid                  varchar(256) DEFAULT NULL,
  gmlid_codespace        varchar(1000) DEFAULT NULL,
  name                   varchar(1000) DEFAULT NULL,
  name_codespace         varchar(4000) DEFAULT NULL,
  description            varchar(4000) DEFAULT NULL,
  envelope               geometry DEFAULT NULL,
  creation_date          timestamp(0) with time zone DEFAULT NULL,
  termination_date       timestamp(0) with time zone DEFAULT NULL,
  relative_to_terrain    varchar(256) DEFAULT NULL,
  relative_to_water      varchar(256) DEFAULT NULL,
  last_modification_date timestamp with time zone DEFAULT NULL,
  updating_person        varchar(256) DEFAULT NULL,
  reason_for_update      varchar(4000) DEFAULT NULL,
  lineage                varchar(256) DEFAULT NULL,
--
  model                    character varying DEFAULT NULL,
  nbr                      integer DEFAULT NULL,
  year_of_manufacture      integer DEFAULT NULL,
  inst_nom_pwr             numeric DEFAULT NULL,
  inst_nom_pwr_unit        character varying DEFAULT NULL,
  nom_effcy                numeric DEFAULT NULL,
  effcy_indicator          character varying DEFAULT NULL,
  start_of_life            date DEFAULT NULL,
  life_expect_value        numeric DEFAULT NULL,
  life_expect_value_unit   character varying DEFAULT NULL,
  main_maint_interval      numeric DEFAULT NULL,
  main_maint_interval_unit character varying DEFAULT NULL,
  inst_in_ctyobj_id        integer DEFAULT NULL,
  cityobject_id            integer DEFAULT NULL,
--
  heat_source          varchar DEFAULT NULL,
  cop_source_temp      numeric DEFAULT NULL,
  cop_source_temp_unit varchar DEFAULT NULL,
  cop_oper_temp        numeric DEFAULT NULL,
  cop_oper_temp_unit   varchar DEFAULT NULL,
--
  schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
  p_id                     integer                     := id                    ;
  p_gmlid                  varchar(256)                := gmlid                 ;
  p_gmlid_codespace        varchar(1000)               := gmlid_codespace       ;
  p_name                   varchar(1000)               := name                  ;
  p_name_codespace         varchar(4000)               := name_codespace        ;
  p_description            varchar(4000)               := description           ;
  p_envelope               geometry                    := envelope              ;
  p_creation_date          timestamp(0) with time zone := creation_date         ;
  p_termination_date       timestamp(0) with time zone := termination_date      ;
  p_relative_to_terrain    varchar(256)                := relative_to_terrain   ;
  p_relative_to_water      varchar(256)                := relative_to_water     ;
  p_last_modification_date timestamp with time zone    := last_modification_date;
  p_updating_person        varchar(256)                := updating_person       ;
  p_reason_for_update      varchar(4000)               := reason_for_update     ;
  p_lineage                varchar(256)                := lineage               ;
--
  p_model                    varchar := model                   ;
  p_nbr                      integer := nbr                     ;
  p_year_of_manufacture      integer := year_of_manufacture     ;
  p_inst_nom_pwr             numeric := inst_nom_pwr            ;
  p_inst_nom_pwr_unit        varchar := inst_nom_pwr_unit       ;
  p_nom_effcy                numeric := nom_effcy               ;
  p_effcy_indicator          varchar := effcy_indicator         ;
  p_start_of_life            date    := start_of_life           ;
  p_life_expect_value        numeric := life_expect_value       ;
  p_life_expect_value_unit   varchar := life_expect_value_unit  ;
  p_main_maint_interval      numeric := main_maint_interval     ;
  p_main_maint_interval_unit varchar := main_maint_interval_unit;
  p_inst_in_ctyobj_id        integer := inst_in_ctyobj_id       ;
  p_cityobject_id            integer := cityobject_id           ;
--
  p_heat_source          varchar := heat_source         ;
  p_cop_source_temp      numeric := cop_source_temp     ;
  p_cop_source_temp_unit varchar := cop_source_temp_unit;
  p_cop_oper_temp        numeric := cop_oper_temp       ;
  p_cop_oper_temp_unit   varchar := cop_oper_temp_unit  ;
--
  p_schema_name varchar := schema_name;
	class_name varchar DEFAULT 'HeatPump'::varchar;
	db_prefix varchar DEFAULT 'nrg8';
	objectclass_id integer;
	inserted_id integer;
BEGIN
objectclass_id=citydb_pkg.objectclass_classname_to_id(class_name, db_prefix, p_schema_name);

inserted_id=citydb_pkg.insert_cityobject(
    id                    :=p_id,
    objectclass_id        :=objectclass_id,
    gmlid                 :=p_gmlid,
    gmlid_codespace       :=p_gmlid_codespace,
    name                  :=p_name,
    name_codespace        :=p_name_codespace,
    description           :=p_description,
    envelope              :=p_envelope,
    creation_date         :=p_creation_date,
    termination_date      :=p_termination_date,
    relative_to_terrain   :=p_relative_to_terrain,
    relative_to_water     :=p_relative_to_water,
    last_modification_date:=p_last_modification_date,
    updating_person       :=p_updating_person,
    reason_for_update     :=p_reason_for_update,
    lineage               :=p_lineage,
    schema_name           :=p_schema_name
);
PERFORM citydb_pkg.nrg8_insert_conv_system(
    id                      :=inserted_id,
    objectclass_id          :=objectclass_id,
    model                   :=p_model,
    nbr                     :=p_nbr,
    year_of_manufacture     :=p_year_of_manufacture,
    inst_nom_pwr            :=p_inst_nom_pwr,
    inst_nom_pwr_unit       :=p_inst_nom_pwr_unit,
    nom_effcy               :=p_nom_effcy,
    effcy_indicator         :=p_effcy_indicator,
    start_of_life           :=p_start_of_life,
    life_expect_value       :=p_life_expect_value,
    life_expect_value_unit  :=p_life_expect_value_unit,
    main_maint_interval     :=p_main_maint_interval,
    main_maint_interval_unit:=p_main_maint_interval_unit,
    inst_in_ctyobj_id       :=p_inst_in_ctyobj_id,
    cityobject_id           :=p_cityobject_id,
    schema_name             :=p_schema_name
);
PERFORM citydb_pkg.nrg8_insert_heat_pump(
    id                      :=inserted_id,
    objectclass_id          :=objectclass_id,
    heat_source             :=p_heat_source,
    cop_source_temp         :=p_cop_source_temp,
    cop_source_temp_unit    :=p_cop_source_temp_unit,
    cop_oper_temp           :=p_cop_oper_temp,
    cop_oper_temp_unit      :=p_cop_oper_temp_unit,
    schema_name             :=p_schema_name
);
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_insert_heat_pump(): %', SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function INSERT_MECH_VENTILATION
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.nrg8_insert_mech_ventilation(
  id                     integer DEFAULT NULL,
  gmlid                  varchar(256) DEFAULT NULL,
  gmlid_codespace        varchar(1000) DEFAULT NULL,
  name                   varchar(1000) DEFAULT NULL,
  name_codespace         varchar(4000) DEFAULT NULL,
  description            varchar(4000) DEFAULT NULL,
  envelope               geometry DEFAULT NULL,
  creation_date          timestamp(0) with time zone DEFAULT NULL,
  termination_date       timestamp(0) with time zone DEFAULT NULL,
  relative_to_terrain    varchar(256) DEFAULT NULL,
  relative_to_water      varchar(256) DEFAULT NULL,
  last_modification_date timestamp with time zone DEFAULT NULL,
  updating_person        varchar(256) DEFAULT NULL,
  reason_for_update      varchar(4000) DEFAULT NULL,
  lineage                varchar(256) DEFAULT NULL,
--
  model                    character varying DEFAULT NULL,
  nbr                      integer DEFAULT NULL,
  year_of_manufacture      integer DEFAULT NULL,
  inst_nom_pwr             numeric DEFAULT NULL,
  inst_nom_pwr_unit        character varying DEFAULT NULL,
  nom_effcy                numeric DEFAULT NULL,
  effcy_indicator          character varying DEFAULT NULL,
  start_of_life            date DEFAULT NULL,
  life_expect_value        numeric DEFAULT NULL,
  life_expect_value_unit   character varying DEFAULT NULL,
  main_maint_interval      numeric DEFAULT NULL,
  main_maint_interval_unit character varying DEFAULT NULL,
  inst_in_ctyobj_id        integer DEFAULT NULL,
  cityobject_id            integer DEFAULT NULL,
--
  heat_recovery numeric(1) DEFAULT NULL,
  recuperation  numeric    DEFAULT NULL,
--
  schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
  p_id                     integer                     := id                    ;
  p_gmlid                  varchar(256)                := gmlid                 ;
  p_gmlid_codespace        varchar(1000)               := gmlid_codespace       ;
  p_name                   varchar(1000)               := name                  ;
  p_name_codespace         varchar(4000)               := name_codespace        ;
  p_description            varchar(4000)               := description           ;
  p_envelope               geometry                    := envelope              ;
  p_creation_date          timestamp(0) with time zone := creation_date         ;
  p_termination_date       timestamp(0) with time zone := termination_date      ;
  p_relative_to_terrain    varchar(256)                := relative_to_terrain   ;
  p_relative_to_water      varchar(256)                := relative_to_water     ;
  p_last_modification_date timestamp with time zone    := last_modification_date;
  p_updating_person        varchar(256)                := updating_person       ;
  p_reason_for_update      varchar(4000)               := reason_for_update     ;
  p_lineage                varchar(256)                := lineage               ;
--
  p_model                    varchar := model                   ;
  p_nbr                      integer := nbr                     ;
  p_year_of_manufacture      integer := year_of_manufacture     ;
  p_inst_nom_pwr             numeric := inst_nom_pwr            ;
  p_inst_nom_pwr_unit        varchar := inst_nom_pwr_unit       ;
  p_nom_effcy                numeric := nom_effcy               ;
  p_effcy_indicator          varchar := effcy_indicator         ;
  p_start_of_life            date    := start_of_life           ;
  p_life_expect_value        numeric := life_expect_value       ;
  p_life_expect_value_unit   varchar := life_expect_value_unit  ;
  p_main_maint_interval      numeric := main_maint_interval     ;
  p_main_maint_interval_unit varchar := main_maint_interval_unit;
  p_inst_in_ctyobj_id        integer := inst_in_ctyobj_id       ;
  p_cityobject_id            integer := cityobject_id           ;
--
  p_heat_recovery numeric(1) := heat_recovery;
  p_recuperation  numeric    := recuperation ;
--
  p_schema_name varchar := schema_name;
	class_name varchar DEFAULT 'MechanicalVentilation'::varchar;
	db_prefix varchar DEFAULT 'nrg8';
	objectclass_id integer;
	inserted_id integer;
BEGIN
objectclass_id=citydb_pkg.objectclass_classname_to_id(class_name, db_prefix, p_schema_name);

inserted_id=citydb_pkg.insert_cityobject(
    id                    :=p_id,
    objectclass_id        :=objectclass_id,
    gmlid                 :=p_gmlid,
    gmlid_codespace       :=p_gmlid_codespace,
    name                  :=p_name,
    name_codespace        :=p_name_codespace,
    description           :=p_description,
    envelope              :=p_envelope,
    creation_date         :=p_creation_date,
    termination_date      :=p_termination_date,
    relative_to_terrain   :=p_relative_to_terrain,
    relative_to_water     :=p_relative_to_water,
    last_modification_date:=p_last_modification_date,
    updating_person       :=p_updating_person,
    reason_for_update     :=p_reason_for_update,
    lineage               :=p_lineage,
    schema_name           :=p_schema_name
);
PERFORM citydb_pkg.nrg8_insert_conv_system(
    id                      :=inserted_id,
    objectclass_id          :=objectclass_id,
    model                   :=p_model,
    nbr                     :=p_nbr,
    year_of_manufacture     :=p_year_of_manufacture,
    inst_nom_pwr            :=p_inst_nom_pwr,
    inst_nom_pwr_unit       :=p_inst_nom_pwr_unit,
    nom_effcy               :=p_nom_effcy,
    effcy_indicator         :=p_effcy_indicator,
    start_of_life           :=p_start_of_life,
    life_expect_value       :=p_life_expect_value,
    life_expect_value_unit  :=p_life_expect_value_unit,
    main_maint_interval     :=p_main_maint_interval,
    main_maint_interval_unit:=p_main_maint_interval_unit,
    inst_in_ctyobj_id       :=p_inst_in_ctyobj_id,
    cityobject_id           :=p_cityobject_id,
    schema_name             :=p_schema_name
);
PERFORM citydb_pkg.nrg8_insert_mech_ventilation(
    id                      :=inserted_id,
    objectclass_id          :=objectclass_id,
    heat_recovery           :=p_heat_recovery,
    recuperation            :=p_recuperation,
    schema_name             :=p_schema_name
);
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_insert_mech_ventilation(): %', SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function INSERT_PV_THERMAL_SYSTEM
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.nrg8_insert_photovoltaic_thermal_system(
  id                     integer DEFAULT NULL,
  gmlid                  varchar(256) DEFAULT NULL,
  gmlid_codespace        varchar(1000) DEFAULT NULL,
  name                   varchar(1000) DEFAULT NULL,
  name_codespace         varchar(4000) DEFAULT NULL,
  description            varchar(4000) DEFAULT NULL,
  envelope               geometry DEFAULT NULL,
  creation_date          timestamp(0) with time zone DEFAULT NULL,
  termination_date       timestamp(0) with time zone DEFAULT NULL,
  relative_to_terrain    varchar(256) DEFAULT NULL,
  relative_to_water      varchar(256) DEFAULT NULL,
  last_modification_date timestamp with time zone DEFAULT NULL,
  updating_person        varchar(256) DEFAULT NULL,
  reason_for_update      varchar(4000) DEFAULT NULL,
  lineage                varchar(256) DEFAULT NULL,
--
  model                    character varying DEFAULT NULL,
  nbr                      integer DEFAULT NULL,
  year_of_manufacture      integer DEFAULT NULL,
  inst_nom_pwr             numeric DEFAULT NULL,
  inst_nom_pwr_unit        character varying DEFAULT NULL,
  nom_effcy                numeric DEFAULT NULL,
  effcy_indicator          character varying DEFAULT NULL,
  start_of_life            date DEFAULT NULL,
  life_expect_value        numeric DEFAULT NULL,
  life_expect_value_unit   character varying DEFAULT NULL,
  main_maint_interval      numeric DEFAULT NULL,
  main_maint_interval_unit character varying DEFAULT NULL,
  inst_in_ctyobj_id        integer DEFAULT NULL,
  cityobject_id            integer DEFAULT NULL,
--
  collector_type     varchar DEFAULT NULL,
  cell_type          varchar DEFAULT NULL,
  module_area        numeric DEFAULT NULL,
  module_area_unit   varchar DEFAULT NULL,
  aperture_area      numeric DEFAULT NULL,
  aperture_area_unit varchar DEFAULT NULL,
  eta0               numeric DEFAULT NULL,
  a1                 numeric DEFAULT NULL,
  a2                 numeric DEFAULT NULL,
  them_surf_id       integer DEFAULT NULL,
  building_inst_id   integer DEFAULT NULL,
  multi_surf_id      integer DEFAULT NULL,
  multi_surf_geom    geometry DEFAULT NULL,
--
  schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
  p_id                     integer                     := id                    ;
  p_gmlid                  varchar(256)                := gmlid                 ;
  p_gmlid_codespace        varchar(1000)               := gmlid_codespace       ;
  p_name                   varchar(1000)               := name                  ;
  p_name_codespace         varchar(4000)               := name_codespace        ;
  p_description            varchar(4000)               := description           ;
  p_envelope               geometry                    := envelope              ;
  p_creation_date          timestamp(0) with time zone := creation_date         ;
  p_termination_date       timestamp(0) with time zone := termination_date      ;
  p_relative_to_terrain    varchar(256)                := relative_to_terrain   ;
  p_relative_to_water      varchar(256)                := relative_to_water     ;
  p_last_modification_date timestamp with time zone    := last_modification_date;
  p_updating_person        varchar(256)                := updating_person       ;
  p_reason_for_update      varchar(4000)               := reason_for_update     ;
  p_lineage                varchar(256)                := lineage               ;
--
  p_model                    varchar := model                   ;
  p_nbr                      integer := nbr                     ;
  p_year_of_manufacture      integer := year_of_manufacture     ;
  p_inst_nom_pwr             numeric := inst_nom_pwr            ;
  p_inst_nom_pwr_unit        varchar := inst_nom_pwr_unit       ;
  p_nom_effcy                numeric := nom_effcy               ;
  p_effcy_indicator          varchar := effcy_indicator         ;
  p_start_of_life            date    := start_of_life           ;
  p_life_expect_value        numeric := life_expect_value       ;
  p_life_expect_value_unit   varchar := life_expect_value_unit  ;
  p_main_maint_interval      numeric := main_maint_interval     ;
  p_main_maint_interval_unit varchar := main_maint_interval_unit;
  p_inst_in_ctyobj_id        integer := inst_in_ctyobj_id       ;
  p_cityobject_id            integer := cityobject_id           ;
--
  p_collector_type     varchar  := collector_type    ;
  p_cell_type          varchar  := cell_type         ;
  p_module_area        numeric  := module_area       ;
  p_module_area_unit   varchar  := module_area_unit  ;
  p_aperture_area      numeric  := aperture_area     ;
  p_aperture_area_unit varchar  := aperture_area_unit;
  p_eta0               numeric  := eta0              ;
  p_a1                 numeric  := a1                ;
  p_a2                 numeric  := a2                ;
  p_them_surf_id       integer  := them_surf_id      ;
  p_building_inst_id   integer  := building_inst_id  ;
  p_multi_surf_id      integer  := multi_surf_id     ;
  p_multi_surf_geom    geometry := multi_surf_geom   ;
--
  p_schema_name varchar := schema_name;
	class_name varchar DEFAULT 'PhotovoltaicThermalSystem'::varchar;
	db_prefix varchar DEFAULT 'nrg8';
	objectclass_id integer;
	inserted_id integer;
BEGIN
objectclass_id=citydb_pkg.objectclass_classname_to_id(class_name, db_prefix, p_schema_name);

inserted_id=citydb_pkg.insert_cityobject(
    id                    :=p_id,
    objectclass_id        :=objectclass_id,
    gmlid                 :=p_gmlid,
    gmlid_codespace       :=p_gmlid_codespace,
    name                  :=p_name,
    name_codespace        :=p_name_codespace,
    description           :=p_description,
    envelope              :=p_envelope,
    creation_date         :=p_creation_date,
    termination_date      :=p_termination_date,
    relative_to_terrain   :=p_relative_to_terrain,
    relative_to_water     :=p_relative_to_water,
    last_modification_date:=p_last_modification_date,
    updating_person       :=p_updating_person,
    reason_for_update     :=p_reason_for_update,
    lineage               :=p_lineage,
    schema_name           :=p_schema_name
);
PERFORM citydb_pkg.nrg8_insert_conv_system(
    id                      :=inserted_id,
    objectclass_id          :=objectclass_id,
    model                   :=p_model,
    nbr                     :=p_nbr,
    year_of_manufacture     :=p_year_of_manufacture,
    inst_nom_pwr            :=p_inst_nom_pwr,
    inst_nom_pwr_unit       :=p_inst_nom_pwr_unit,
    nom_effcy               :=p_nom_effcy,
    effcy_indicator         :=p_effcy_indicator,
    start_of_life           :=p_start_of_life,
    life_expect_value       :=p_life_expect_value,
    life_expect_value_unit  :=p_life_expect_value_unit,
    main_maint_interval     :=p_main_maint_interval,
    main_maint_interval_unit:=p_main_maint_interval_unit,
    inst_in_ctyobj_id       :=p_inst_in_ctyobj_id,
    cityobject_id           :=p_cityobject_id,
    schema_name             :=p_schema_name
);
PERFORM citydb_pkg.nrg8_insert_solar_system(
    id                      :=inserted_id,
    objectclass_id          :=objectclass_id,
    collector_type          :=p_collector_type,
    cell_type               :=p_cell_type,
    module_area             :=p_module_area,
    module_area_unit        :=p_module_area_unit,
    aperture_area           :=p_aperture_area,
    aperture_area_unit      :=p_aperture_area_unit,
    eta0                    :=p_eta0,
    a1                      :=p_a1,
    a2                      :=p_a2,
    them_surf_id            :=p_them_surf_id,
    building_inst_id        :=p_building_inst_id,
    multi_surf_id           :=p_multi_surf_id,
    multi_surf_geom         :=p_multi_surf_geom,
    schema_name             :=p_schema_name
);
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_insert_photovoltaic_thermal_system(): %', SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function INSERT_PV_SYSTEM
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.nrg8_insert_photovoltaic_system(
  id                     integer DEFAULT NULL,
  gmlid                  varchar(256) DEFAULT NULL,
  gmlid_codespace        varchar(1000) DEFAULT NULL,
  name                   varchar(1000) DEFAULT NULL,
  name_codespace         varchar(4000) DEFAULT NULL,
  description            varchar(4000) DEFAULT NULL,
  envelope               geometry DEFAULT NULL,
  creation_date          timestamp(0) with time zone DEFAULT NULL,
  termination_date       timestamp(0) with time zone DEFAULT NULL,
  relative_to_terrain    varchar(256) DEFAULT NULL,
  relative_to_water      varchar(256) DEFAULT NULL,
  last_modification_date timestamp with time zone DEFAULT NULL,
  updating_person        varchar(256) DEFAULT NULL,
  reason_for_update      varchar(4000) DEFAULT NULL,
  lineage                varchar(256) DEFAULT NULL,
--
  model                    character varying DEFAULT NULL,
  nbr                      integer DEFAULT NULL,
  year_of_manufacture      integer DEFAULT NULL,
  inst_nom_pwr             numeric DEFAULT NULL,
  inst_nom_pwr_unit        character varying DEFAULT NULL,
  nom_effcy                numeric DEFAULT NULL,
  effcy_indicator          character varying DEFAULT NULL,
  start_of_life            date DEFAULT NULL,
  life_expect_value        numeric DEFAULT NULL,
  life_expect_value_unit   character varying DEFAULT NULL,
  main_maint_interval      numeric DEFAULT NULL,
  main_maint_interval_unit character varying DEFAULT NULL,
  inst_in_ctyobj_id        integer DEFAULT NULL,
  cityobject_id            integer DEFAULT NULL,
--
  cell_type         varchar DEFAULT NULL,
  module_area       numeric DEFAULT NULL,
  module_area_unit  varchar DEFAULT NULL,
  them_surf_id      integer DEFAULT NULL,
  building_inst_id  integer DEFAULT NULL,
  multi_surf_id     integer DEFAULT NULL,
  multi_surf_geom   geometry DEFAULT NULL,
--
  schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
  p_id                     integer                     := id                    ;
  p_gmlid                  varchar(256)                := gmlid                 ;
  p_gmlid_codespace        varchar(1000)               := gmlid_codespace       ;
  p_name                   varchar(1000)               := name                  ;
  p_name_codespace         varchar(4000)               := name_codespace        ;
  p_description            varchar(4000)               := description           ;
  p_envelope               geometry                    := envelope              ;
  p_creation_date          timestamp(0) with time zone := creation_date         ;
  p_termination_date       timestamp(0) with time zone := termination_date      ;
  p_relative_to_terrain    varchar(256)                := relative_to_terrain   ;
  p_relative_to_water      varchar(256)                := relative_to_water     ;
  p_last_modification_date timestamp with time zone    := last_modification_date;
  p_updating_person        varchar(256)                := updating_person       ;
  p_reason_for_update      varchar(4000)               := reason_for_update     ;
  p_lineage                varchar(256)                := lineage               ;
--
  p_model                    varchar := model                   ;
  p_nbr                      integer := nbr                     ;
  p_year_of_manufacture      integer := year_of_manufacture     ;
  p_inst_nom_pwr             numeric := inst_nom_pwr            ;
  p_inst_nom_pwr_unit        varchar := inst_nom_pwr_unit       ;
  p_nom_effcy                numeric := nom_effcy               ;
  p_effcy_indicator          varchar := effcy_indicator         ;
  p_start_of_life            date    := start_of_life           ;
  p_life_expect_value        numeric := life_expect_value       ;
  p_life_expect_value_unit   varchar := life_expect_value_unit  ;
  p_main_maint_interval      numeric := main_maint_interval     ;
  p_main_maint_interval_unit varchar := main_maint_interval_unit;
  p_inst_in_ctyobj_id        integer := inst_in_ctyobj_id       ;
  p_cityobject_id            integer := cityobject_id           ;
--
  p_cell_type         varchar  := cell_type       ;
  p_module_area       numeric  := module_area     ;
  p_module_area_unit  varchar  := module_area_unit;
  p_them_surf_id      integer  := them_surf_id    ;
  p_building_inst_id  integer  := building_inst_id;
  p_multi_surf_id     integer  := multi_surf_id   ;
  p_multi_surf_geom   geometry := multi_surf_geom ;
--
  p_schema_name varchar := schema_name;
	class_name varchar DEFAULT 'PhotovoltaicSystem'::varchar;
	db_prefix varchar DEFAULT 'nrg8';
	objectclass_id integer;
	inserted_id integer;
BEGIN
objectclass_id=citydb_pkg.objectclass_classname_to_id(class_name, db_prefix, p_schema_name);

inserted_id=citydb_pkg.insert_cityobject(
    id                    :=p_id,
    objectclass_id        :=objectclass_id,
    gmlid                 :=p_gmlid,
    gmlid_codespace       :=p_gmlid_codespace,
    name                  :=p_name,
    name_codespace        :=p_name_codespace,
    description           :=p_description,
    envelope              :=p_envelope,
    creation_date         :=p_creation_date,
    termination_date      :=p_termination_date,
    relative_to_terrain   :=p_relative_to_terrain,
    relative_to_water     :=p_relative_to_water,
    last_modification_date:=p_last_modification_date,
    updating_person       :=p_updating_person,
    reason_for_update     :=p_reason_for_update,
    lineage               :=p_lineage,
    schema_name           :=p_schema_name
);
PERFORM citydb_pkg.nrg8_insert_conv_system(
    id                      :=inserted_id,
    objectclass_id          :=objectclass_id,
    model                   :=p_model,
    nbr                     :=p_nbr,
    year_of_manufacture     :=p_year_of_manufacture,
    inst_nom_pwr            :=p_inst_nom_pwr,
    inst_nom_pwr_unit       :=p_inst_nom_pwr_unit,
    nom_effcy               :=p_nom_effcy,
    effcy_indicator         :=p_effcy_indicator,
    start_of_life           :=p_start_of_life,
    life_expect_value       :=p_life_expect_value,
    life_expect_value_unit  :=p_life_expect_value_unit,
    main_maint_interval     :=p_main_maint_interval,
    main_maint_interval_unit:=p_main_maint_interval_unit,
    inst_in_ctyobj_id       :=p_inst_in_ctyobj_id,
    cityobject_id           :=p_cityobject_id,
    schema_name             :=p_schema_name
);
PERFORM citydb_pkg.nrg8_insert_solar_system(
    id                      :=inserted_id,
    objectclass_id          :=objectclass_id,
    cell_type               :=p_cell_type,
    module_area             :=p_module_area,
    module_area_unit        :=p_module_area_unit,
    them_surf_id            :=p_them_surf_id,
    building_inst_id        :=p_building_inst_id,
    multi_surf_id           :=p_multi_surf_id,
    multi_surf_geom         :=p_multi_surf_geom,
    schema_name             :=p_schema_name
);
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_insert_photovoltaic_system(): %', SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function INSERT_SOLAR_THERMAL_SYSTEM
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.nrg8_insert_solar_thermal_system(
  id                     integer DEFAULT NULL,
  gmlid                  varchar(256) DEFAULT NULL,
  gmlid_codespace        varchar(1000) DEFAULT NULL,
  name                   varchar(1000) DEFAULT NULL,
  name_codespace         varchar(4000) DEFAULT NULL,
  description            varchar(4000) DEFAULT NULL,
  envelope               geometry DEFAULT NULL,
  creation_date          timestamp(0) with time zone DEFAULT NULL,
  termination_date       timestamp(0) with time zone DEFAULT NULL,
  relative_to_terrain    varchar(256) DEFAULT NULL,
  relative_to_water      varchar(256) DEFAULT NULL,
  last_modification_date timestamp with time zone DEFAULT NULL,
  updating_person        varchar(256) DEFAULT NULL,
  reason_for_update      varchar(4000) DEFAULT NULL,
  lineage                varchar(256) DEFAULT NULL,
--
  model                    character varying DEFAULT NULL,
  nbr                      integer DEFAULT NULL,
  year_of_manufacture      integer DEFAULT NULL,
  inst_nom_pwr             numeric DEFAULT NULL,
  inst_nom_pwr_unit        character varying DEFAULT NULL,
  nom_effcy                numeric DEFAULT NULL,
  effcy_indicator          character varying DEFAULT NULL,
  start_of_life            date DEFAULT NULL,
  life_expect_value        numeric DEFAULT NULL,
  life_expect_value_unit   character varying DEFAULT NULL,
  main_maint_interval      numeric DEFAULT NULL,
  main_maint_interval_unit character varying DEFAULT NULL,
  inst_in_ctyobj_id        integer DEFAULT NULL,
  cityobject_id            integer DEFAULT NULL,
--
  collector_type varchar DEFAULT NULL,
  aperture_area numeric DEFAULT NULL,
  aperture_area_unit varchar DEFAULT NULL,
  eta0 numeric DEFAULT NULL,
  a1 numeric DEFAULT NULL,
  a2 numeric DEFAULT NULL,
  them_surf_id integer DEFAULT NULL,
  building_inst_id integer DEFAULT NULL,
  multi_surf_id integer DEFAULT NULL,
  multi_surf_geom public.geometry DEFAULT NULL,
--
  schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
  p_id                     integer                     := id                    ;
  p_gmlid                  varchar(256)                := gmlid                 ;
  p_gmlid_codespace        varchar(1000)               := gmlid_codespace       ;
  p_name                   varchar(1000)               := name                  ;
  p_name_codespace         varchar(4000)               := name_codespace        ;
  p_description            varchar(4000)               := description           ;
  p_envelope               geometry                    := envelope              ;
  p_creation_date          timestamp(0) with time zone := creation_date         ;
  p_termination_date       timestamp(0) with time zone := termination_date      ;
  p_relative_to_terrain    varchar(256)                := relative_to_terrain   ;
  p_relative_to_water      varchar(256)                := relative_to_water     ;
  p_last_modification_date timestamp with time zone    := last_modification_date;
  p_updating_person        varchar(256)                := updating_person       ;
  p_reason_for_update      varchar(4000)               := reason_for_update     ;
  p_lineage                varchar(256)                := lineage               ;
--
  p_model                    varchar := model                   ;
  p_nbr                      integer := nbr                     ;
  p_year_of_manufacture      integer := year_of_manufacture     ;
  p_inst_nom_pwr             numeric := inst_nom_pwr            ;
  p_inst_nom_pwr_unit        varchar := inst_nom_pwr_unit       ;
  p_nom_effcy                numeric := nom_effcy               ;
  p_effcy_indicator          varchar := effcy_indicator         ;
  p_start_of_life            date    := start_of_life           ;
  p_life_expect_value        numeric := life_expect_value       ;
  p_life_expect_value_unit   varchar := life_expect_value_unit  ;
  p_main_maint_interval      numeric := main_maint_interval     ;
  p_main_maint_interval_unit varchar := main_maint_interval_unit;
  p_inst_in_ctyobj_id        integer := inst_in_ctyobj_id       ;
  p_cityobject_id            integer := cityobject_id           ;
--
  p_collector_type     varchar  := collector_type    ;
  p_aperture_area      numeric  := aperture_area     ;
  p_aperture_area_unit varchar  := aperture_area_unit;
  p_eta0               numeric  := eta0              ;
  p_a1                 numeric  := a1                ;
  p_a2                 numeric  := a2                ;
  p_them_surf_id       integer  := them_surf_id      ;
  p_building_inst_id   integer  := building_inst_id  ;
  p_multi_surf_id      integer  := multi_surf_id     ;
  p_multi_surf_geom    geometry := multi_surf_geom   ;
--
  p_schema_name varchar := schema_name;
	class_name varchar DEFAULT 'SolarThermalSystem'::varchar;
	db_prefix varchar DEFAULT 'nrg8';
	objectclass_id integer;
	inserted_id integer;
BEGIN
objectclass_id=citydb_pkg.objectclass_classname_to_id(class_name, db_prefix, p_schema_name);

inserted_id=citydb_pkg.insert_cityobject(
    id                    :=p_id,
    objectclass_id        :=objectclass_id,
    gmlid                 :=p_gmlid,
    gmlid_codespace       :=p_gmlid_codespace,
    name                  :=p_name,
    name_codespace        :=p_name_codespace,
    description           :=p_description,
    envelope              :=p_envelope,
    creation_date         :=p_creation_date,
    termination_date      :=p_termination_date,
    relative_to_terrain   :=p_relative_to_terrain,
    relative_to_water     :=p_relative_to_water,
    last_modification_date:=p_last_modification_date,
    updating_person       :=p_updating_person,
    reason_for_update     :=p_reason_for_update,
    lineage               :=p_lineage,
    schema_name           :=p_schema_name
);
PERFORM citydb_pkg.nrg8_insert_conv_system(
    id                      :=inserted_id,
    objectclass_id          :=objectclass_id,
    model                   :=p_model,
    nbr                     :=p_nbr,
    year_of_manufacture     :=p_year_of_manufacture,
    inst_nom_pwr            :=p_inst_nom_pwr,
    inst_nom_pwr_unit       :=p_inst_nom_pwr_unit,
    nom_effcy               :=p_nom_effcy,
    effcy_indicator         :=p_effcy_indicator,
    start_of_life           :=p_start_of_life,
    life_expect_value       :=p_life_expect_value,
    life_expect_value_unit  :=p_life_expect_value_unit,
    main_maint_interval     :=p_main_maint_interval,
    main_maint_interval_unit:=p_main_maint_interval_unit,
    inst_in_ctyobj_id       :=p_inst_in_ctyobj_id,
    cityobject_id           :=p_cityobject_id,
    schema_name             :=p_schema_name
);
PERFORM citydb_pkg.nrg8_insert_solar_system(
    id                      :=inserted_id,
    objectclass_id          :=objectclass_id,
    collector_type          :=p_collector_type,
    aperture_area           :=p_aperture_area,
    aperture_area_unit      :=p_aperture_area_unit,
    eta0                    :=p_eta0,
    a1                      :=p_a1,
    a2                      :=p_a2,
    them_surf_id            :=p_them_surf_id,
    building_inst_id        :=p_building_inst_id,
    multi_surf_id           :=p_multi_surf_id,
    multi_surf_geom         :=p_multi_surf_geom,
    schema_name             :=p_schema_name
);
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_insert_solar_thermal_system(): %', SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function INSERT_DAILY_SCHEDULE
----------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.nrg8_insert_daily_schedule(
  id                integer DEFAULT NULL,
  day_type          varchar DEFAULT NULL,
  period_of_year_id integer DEFAULT NULL,
  time_series_id    integer DEFAULT NULL,
--
  schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
  p_id                integer := id               ;
  p_day_type          varchar := day_type         ;
  p_period_of_year_id integer := period_of_year_id;
  p_time_series_id    integer := time_series_id   ;
--
  p_schema_name varchar := schema_name;
	inserted_id integer;
BEGIN
inserted_id=citydb_pkg.nrg8_insert_daily_schedule(
    id                   :=p_id,
    day_type             :=p_day_type,
    period_of_year_id    :=p_period_of_year_id,
    time_series_id       :=p_time_series_id,
    schema_name          :=p_schema_name
);
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_insert_daily_schedule(): %', SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function INSERT_FLOOR_AREA (non CityObject)
----------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.nrg8_insert_floor_area(
  id                   integer DEFAULT NULL,
  type                 character varying DEFAULT NULL,
  value                numeric DEFAULT NULL,
  value_unit           character varying DEFAULT NULL,
  cityobject_id        integer DEFAULT NULL,
--
  schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
  p_id                 integer           := id           ;
  p_type               character varying := type         ;
  p_value              numeric           := value        ;
  p_value_unit         character varying := value_unit   ;
  p_cityobject_id      integer           := cityobject_id;
--
  p_schema_name varchar := schema_name;
	class_name varchar DEFAULT 'FloorArea'::varchar;
	db_prefix varchar DEFAULT 'nrg8'::varchar;
	objectclass_id integer;
	inserted_id integer;
BEGIN
objectclass_id=citydb_pkg.objectclass_classname_to_id(class_name, db_prefix, p_schema_name);

inserted_id=citydb_pkg.nrg8_insert_dimensional_attrib(
    id                   :=p_id,
    objectclass_id       :=objectclass_id,
    type                 :=p_type,
    value                :=p_value,
    value_unit           :=p_value_unit,
    cityobject_id        :=p_cityobject_id,
    schema_name          :=p_schema_name
);
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_insert_floor_area(): %', SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function INSERT_HEIGHT
----------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.nrg8_insert_height_above_ground(
  id                   integer DEFAULT NULL,
  type                 character varying DEFAULT NULL,
  value                numeric DEFAULT NULL,
  value_unit           character varying DEFAULT NULL,
  cityobject_id        integer DEFAULT NULL,
--
  schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
  p_id                 integer           := id           ;
  p_type               character varying := type         ;
  p_value              numeric           := value        ;
  p_value_unit         character varying := value_unit   ;
  p_cityobject_id      integer           := cityobject_id;
--
  p_schema_name varchar := schema_name;
	class_name varchar DEFAULT 'HeightAboveGround'::varchar;
	db_prefix varchar DEFAULT 'nrg8'::varchar;
	objectclass_id integer;
	inserted_id integer;
BEGIN
objectclass_id=citydb_pkg.objectclass_classname_to_id(class_name, db_prefix, p_schema_name);

inserted_id=citydb_pkg.nrg8_insert_dimensional_attrib(
    id                   :=p_id,
    objectclass_id       :=objectclass_id,
    type                 :=p_type,
    value                :=p_value,
    value_unit           :=p_value_unit,
    cityobject_id        :=p_cityobject_id,
    schema_name          :=p_schema_name
);
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_insert_height_above_ground(): %', SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function INSERT_VOLUME (non CityObject)
----------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.nrg8_insert_volume(
  id                   integer DEFAULT NULL,
  type                 character varying DEFAULT NULL,
  value                numeric DEFAULT NULL,
  value_unit           character varying DEFAULT NULL,
  cityobject_id        integer DEFAULT NULL,
--
  schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
  p_id                 integer           := id           ;
  p_type               character varying := type         ;
  p_value              numeric           := value        ;
  p_value_unit         character varying := value_unit   ;
  p_cityobject_id      integer           := cityobject_id;
--
  p_schema_name varchar := schema_name;
	class_name varchar DEFAULT 'VolumeType'::varchar;
	db_prefix varchar DEFAULT 'nrg8'::varchar;
	objectclass_id integer;
	inserted_id integer;
BEGIN
objectclass_id=citydb_pkg.objectclass_classname_to_id(class_name, db_prefix, p_schema_name);

inserted_id=citydb_pkg.nrg8_insert_dimensional_attrib(
    id                   :=p_id,
    objectclass_id       :=objectclass_id,
    type                 :=p_type,
    value                :=p_value,
    value_unit           :=p_value_unit,
    cityobject_id        :=p_cityobject_id,
    schema_name          :=p_schema_name
);
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_insert_volume(): %', SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function INSERT_EMITTER (CityObject)
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.nrg8_insert_emitter(
  id                     integer DEFAULT NULL,
  gmlid                  varchar(256) DEFAULT NULL,
  gmlid_codespace        varchar(1000) DEFAULT NULL,
  name                   varchar(1000) DEFAULT NULL,
  name_codespace         varchar(4000) DEFAULT NULL,
  description            varchar(4000) DEFAULT NULL,
  envelope               geometry DEFAULT NULL,
  creation_date          timestamp(0) with time zone DEFAULT NULL,
  termination_date       timestamp(0) with time zone DEFAULT NULL,
  relative_to_terrain    varchar(256) DEFAULT NULL,
  relative_to_water      varchar(256) DEFAULT NULL,
  last_modification_date timestamp with time zone DEFAULT NULL,
  updating_person        varchar(256) DEFAULT NULL,
  reason_for_update      varchar(4000) DEFAULT NULL,
  lineage                varchar(256) DEFAULT NULL,
--
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
--
  schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
  p_id                     integer                     := id                    ;
  p_gmlid                  varchar(256)                := gmlid                 ;
  p_gmlid_codespace        varchar(1000)               := gmlid_codespace       ;
  p_name                   varchar(1000)               := name                  ;
  p_name_codespace         varchar(4000)               := name_codespace        ;
  p_description            varchar(4000)               := description           ;
  p_envelope               geometry                    := envelope              ;
  p_creation_date          timestamp(0) with time zone := creation_date         ;
  p_termination_date       timestamp(0) with time zone := termination_date      ;
  p_relative_to_terrain    varchar(256)                := relative_to_terrain   ;
  p_relative_to_water      varchar(256)                := relative_to_water     ;
  p_last_modification_date timestamp with time zone    := last_modification_date;
  p_updating_person        varchar(256)                := updating_person       ;
  p_reason_for_update      varchar(4000)               := reason_for_update     ;
  p_lineage                varchar(256)                := lineage               ;
--
  p_type                      character varying := type;
  p_unit_nbr                  integer           := unit_nbr;
  p_inst_pwr                  numeric           := inst_pwr;
  p_inst_pwr_unit             character varying := inst_pwr_unit;
  p_therm_exch_tot_value      numeric           := therm_exch_tot_value;
  p_therm_exch_tot_value_unit character varying := therm_exch_tot_value_unit;
  p_therm_exch_conv           numeric           := therm_exch_conv;
  p_therm_exch_rad            numeric           := therm_exch_rad;
  p_therm_exch_lat            numeric           := therm_exch_lat;
  p_distr_system_id           integer           := distr_system_id;
  p_cityobject_id             integer           := cityobject_id;
--
  p_schema_name varchar := schema_name;
	class_name varchar DEFAULT 'Emitter'::varchar;
	db_prefix varchar DEFAULT 'nrg8';
	objectclass_id integer;
	inserted_id integer;
BEGIN
objectclass_id=citydb_pkg.objectclass_classname_to_id(class_name, db_prefix, p_schema_name);

inserted_id=citydb_pkg.insert_cityobject(
    id                    :=p_id,
    objectclass_id        :=objectclass_id,
    gmlid                 :=p_gmlid,
    gmlid_codespace       :=p_gmlid_codespace,
    name                  :=p_name,
    name_codespace        :=p_name_codespace,
    description           :=p_description,
    envelope              :=p_envelope,
    creation_date         :=p_creation_date,
    termination_date      :=p_termination_date,
    relative_to_terrain   :=p_relative_to_terrain,
    relative_to_water     :=p_relative_to_water,
    last_modification_date:=p_last_modification_date,
    updating_person       :=p_updating_person,
    reason_for_update     :=p_reason_for_update,
    lineage               :=p_lineage,
    schema_name           :=p_schema_name
);
PERFORM citydb_pkg.nrg8_insert_emitter(
    id                       :=inserted_id,
    objectclass_id           :=objectclass_id,
    type                     :=p_type,
    unit_nbr                 :=p_unit_nbr,
    inst_pwr                 :=p_inst_pwr,
    inst_pwr_unit            :=p_inst_pwr_unit,
    therm_exch_tot_value     :=p_therm_exch_tot_value,
    therm_exch_tot_value_unit:=p_therm_exch_tot_value_unit,
    therm_exch_conv          :=p_therm_exch_conv,
    therm_exch_rad           :=p_therm_exch_rad,
    therm_exch_lat           :=p_therm_exch_lat,
    distr_system_id          :=p_distr_system_id,
    cityobject_id            :=p_cityobject_id,
    schema_name              :=p_schema_name
);
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_insert_emitter(): %', SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function INSERT_ENERGY_DEMAND (non CityObject)
----------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.nrg8_insert_energy_demand(
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
--
  schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
  p_id                 integer           = id;
  p_gmlid              character varying = gmlid;
  p_gmlid_codespace    character varying = gmlid_codespace;
  p_name               character varying = name;
  p_name_codespace     character varying = name_codespace;
  p_description        text              = description;
  p_end_use            character varying = end_use;
  p_max_load           numeric           = max_load;
  p_max_load_unit      character varying = max_load_unit;
  p_time_series_id     integer           = time_series_id;
  p_cityobject_id      integer           = cityobject_id;
--
  p_schema_name varchar := schema_name;
	class_name varchar DEFAULT 'EnergyDemand'::varchar;
	db_prefix varchar DEFAULT 'nrg8'::varchar;
	objectclass_id integer;
	inserted_id integer;
BEGIN
objectclass_id=citydb_pkg.objectclass_classname_to_id(class_name, db_prefix, p_schema_name);

inserted_id=citydb_pkg.nrg8_insert_energy_demand(
    id                   :=p_id,
    objectclass_id       :=objectclass_id,
    gmlid                :=p_gmlid,
    gmlid_codespace      :=p_gmlid_codespace,
    name                 :=p_name,
    name_codespace       :=p_name_codespace,
    description          :=p_description,
    end_use              :=p_end_use,
    max_load             :=p_max_load,
    max_load_unit        :=p_max_load_unit,
    time_series_id       :=p_time_series_id,
    cityobject_id        :=p_cityobject_id,
    schema_name          :=p_schema_name
);
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_insert_energy_demand(): %', SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function INSERT_DHW_FACILITIES (CityObject)
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.nrg8_insert_dhw_facilities(
  id                     integer DEFAULT NULL,
  gmlid                  varchar(256) DEFAULT NULL,
  gmlid_codespace        varchar(1000) DEFAULT NULL,
  name                   varchar(1000) DEFAULT NULL,
  name_codespace         varchar(4000) DEFAULT NULL,
  description            varchar(4000) DEFAULT NULL,
  envelope               geometry DEFAULT NULL,
  creation_date          timestamp(0) with time zone DEFAULT NULL,
  termination_date       timestamp(0) with time zone DEFAULT NULL,
  relative_to_terrain    varchar(256) DEFAULT NULL,
  relative_to_water      varchar(256) DEFAULT NULL,
  last_modification_date timestamp with time zone DEFAULT NULL,
  updating_person        varchar(256) DEFAULT NULL,
  reason_for_update      varchar(4000) DEFAULT NULL,
  lineage                varchar(256) DEFAULT NULL,
--
  heat_diss_tot_value      numeric DEFAULT NULL,
  heat_diss_tot_value_unit character varying DEFAULT NULL,
  heat_diss_conv           numeric DEFAULT NULL,
  heat_diss_lat            numeric DEFAULT NULL,
  heat_diss_rad            numeric DEFAULT NULL,
  nbr_of_baths             integer DEFAULT NULL,
  nbr_of_showers           integer DEFAULT NULL,
  nbr_of_washbasins        integer DEFAULT NULL,
  water_strg_vol           numeric DEFAULT NULL,
  water_strg_vol_unit      character varying DEFAULT NULL,
  oper_sched_id            integer DEFAULT NULL,
  usage_zone_id            integer DEFAULT NULL,
  building_unit_id         integer DEFAULT NULL,
--
  schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
  p_id                     integer                     := id                    ;
  p_gmlid                  varchar(256)                := gmlid                 ;
  p_gmlid_codespace        varchar(1000)               := gmlid_codespace       ;
  p_name                   varchar(1000)               := name                  ;
  p_name_codespace         varchar(4000)               := name_codespace        ;
  p_description            varchar(4000)               := description           ;
  p_envelope               geometry                    := envelope              ;
  p_creation_date          timestamp(0) with time zone := creation_date         ;
  p_termination_date       timestamp(0) with time zone := termination_date      ;
  p_relative_to_terrain    varchar(256)                := relative_to_terrain   ;
  p_relative_to_water      varchar(256)                := relative_to_water     ;
  p_last_modification_date timestamp with time zone    := last_modification_date;
  p_updating_person        varchar(256)                := updating_person       ;
  p_reason_for_update      varchar(4000)               := reason_for_update     ;
  p_lineage                varchar(256)                := lineage               ;
--
  p_heat_diss_tot_value      numeric           := heat_diss_tot_value;
  p_heat_diss_tot_value_unit character varying := heat_diss_tot_value_unit;
  p_heat_diss_conv           numeric           := heat_diss_conv;
  p_heat_diss_lat            numeric           := heat_diss_lat;
  p_heat_diss_rad            numeric           := heat_diss_rad;
  p_nbr_of_baths             integer           := nbr_of_baths;
  p_nbr_of_showers           integer           := nbr_of_showers;
  p_nbr_of_washbasins        integer           := nbr_of_washbasins;
  p_water_strg_vol           numeric           := water_strg_vol;
  p_water_strg_vol_unit      character varying := water_strg_vol_unit;
  p_oper_sched_id            integer           := oper_sched_id;
  p_usage_zone_id            integer           := usage_zone_id;
  p_building_unit_id         integer           := building_unit_id;
--
  p_schema_name varchar := schema_name;
	class_name varchar DEFAULT 'DHWFacilities'::varchar;
	db_prefix varchar DEFAULT 'nrg8';
	objectclass_id integer;
	inserted_id integer;
BEGIN
objectclass_id=citydb_pkg.objectclass_classname_to_id(class_name, db_prefix, p_schema_name);

inserted_id=citydb_pkg.insert_cityobject(
    id                    :=p_id,
    objectclass_id        :=objectclass_id,
    gmlid                 :=p_gmlid,
    gmlid_codespace       :=p_gmlid_codespace,
    name                  :=p_name,
    name_codespace        :=p_name_codespace,
    description           :=p_description,
    envelope              :=p_envelope,
    creation_date         :=p_creation_date,
    termination_date      :=p_termination_date,
    relative_to_terrain   :=p_relative_to_terrain,
    relative_to_water     :=p_relative_to_water,
    last_modification_date:=p_last_modification_date,
    updating_person       :=p_updating_person,
    reason_for_update     :=p_reason_for_update,
    lineage               :=p_lineage,
    schema_name           :=p_schema_name
);
PERFORM citydb_pkg.nrg8_insert_facilities(
    id                      :=inserted_id,
    objectclass_id          :=objectclass_id,
    heat_diss_tot_value     :=p_heat_diss_tot_value,
    heat_diss_tot_value_unit:=p_heat_diss_tot_value_unit,
    heat_diss_conv          :=p_heat_diss_conv,
    heat_diss_lat           :=p_heat_diss_lat,
    heat_diss_rad           :=p_heat_diss_rad,
    nbr_of_baths            :=p_nbr_of_baths,
    nbr_of_showers          :=p_nbr_of_showers,
    nbr_of_washbasins       :=p_nbr_of_washbasins,
    water_strg_vol          :=p_water_strg_vol,
    water_strg_vol_unit     :=p_water_strg_vol_unit,
    oper_sched_id           :=p_oper_sched_id,
    usage_zone_id           :=p_usage_zone_id,
    building_unit_id        :=p_building_unit_id,
    schema_name             :=p_schema_name
);
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_insert_dhw_facilities(): %', SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function INSERT_ELECTRICAL_APPLIANCES (CityObject)
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.nrg8_insert_electrical_appliances(
  id                     integer DEFAULT NULL,
  gmlid                  varchar(256) DEFAULT NULL,
  gmlid_codespace        varchar(1000) DEFAULT NULL,
  name                   varchar(1000) DEFAULT NULL,
  name_codespace         varchar(4000) DEFAULT NULL,
  description            varchar(4000) DEFAULT NULL,
  envelope               geometry DEFAULT NULL,
  creation_date          timestamp(0) with time zone DEFAULT NULL,
  termination_date       timestamp(0) with time zone DEFAULT NULL,
  relative_to_terrain    varchar(256) DEFAULT NULL,
  relative_to_water      varchar(256) DEFAULT NULL,
  last_modification_date timestamp with time zone DEFAULT NULL,
  updating_person        varchar(256) DEFAULT NULL,
  reason_for_update      varchar(4000) DEFAULT NULL,
  lineage                varchar(256) DEFAULT NULL,
--
  heat_diss_tot_value      numeric DEFAULT NULL,
  heat_diss_tot_value_unit character varying DEFAULT NULL,
  heat_diss_conv           numeric DEFAULT NULL,
  heat_diss_lat            numeric DEFAULT NULL,
  heat_diss_rad            numeric DEFAULT NULL,
  electr_pwr               numeric DEFAULT NULL,
  electr_pwr_unit          character varying DEFAULT NULL,
  oper_sched_id            integer DEFAULT NULL,
  usage_zone_id            integer DEFAULT NULL,
  building_unit_id         integer DEFAULT NULL,
--
  schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
  p_id                     integer                     := id                    ;
  p_gmlid                  varchar(256)                := gmlid                 ;
  p_gmlid_codespace        varchar(1000)               := gmlid_codespace       ;
  p_name                   varchar(1000)               := name                  ;
  p_name_codespace         varchar(4000)               := name_codespace        ;
  p_description            varchar(4000)               := description           ;
  p_envelope               geometry                    := envelope              ;
  p_creation_date          timestamp(0) with time zone := creation_date         ;
  p_termination_date       timestamp(0) with time zone := termination_date      ;
  p_relative_to_terrain    varchar(256)                := relative_to_terrain   ;
  p_relative_to_water      varchar(256)                := relative_to_water     ;
  p_last_modification_date timestamp with time zone    := last_modification_date;
  p_updating_person        varchar(256)                := updating_person       ;
  p_reason_for_update      varchar(4000)               := reason_for_update     ;
  p_lineage                varchar(256)                := lineage               ;
--
  p_heat_diss_tot_value      numeric           := heat_diss_tot_value;
  p_heat_diss_tot_value_unit character varying := heat_diss_tot_value_unit;
  p_heat_diss_conv           numeric           := heat_diss_conv;
  p_heat_diss_lat            numeric           := heat_diss_lat;
  p_heat_diss_rad            numeric           := heat_diss_rad;
  p_electr_pwr               numeric           := electr_pwr;
  p_electr_pwr_unit          character varying := electr_pwr_unit;
  p_oper_sched_id            integer           := oper_sched_id;
  p_usage_zone_id            integer           := usage_zone_id;
  p_building_unit_id         integer           := building_unit_id;
--
  p_schema_name varchar := schema_name;
	class_name varchar DEFAULT 'ElectricalAppliances'::varchar;
	db_prefix varchar DEFAULT 'nrg8';
	objectclass_id integer;
	inserted_id integer;
BEGIN
objectclass_id=citydb_pkg.objectclass_classname_to_id(class_name, db_prefix, p_schema_name);

inserted_id=citydb_pkg.insert_cityobject(
    id                    :=p_id,
    objectclass_id        :=objectclass_id,
    gmlid                 :=p_gmlid,
    gmlid_codespace       :=p_gmlid_codespace,
    name                  :=p_name,
    name_codespace        :=p_name_codespace,
    description           :=p_description,
    envelope              :=p_envelope,
    creation_date         :=p_creation_date,
    termination_date      :=p_termination_date,
    relative_to_terrain   :=p_relative_to_terrain,
    relative_to_water     :=p_relative_to_water,
    last_modification_date:=p_last_modification_date,
    updating_person       :=p_updating_person,
    reason_for_update     :=p_reason_for_update,
    lineage               :=p_lineage,
    schema_name           :=p_schema_name
);
PERFORM citydb_pkg.nrg8_insert_facilities(
    id                      :=inserted_id,
    objectclass_id          :=objectclass_id,
    heat_diss_tot_value     :=p_heat_diss_tot_value,
    heat_diss_tot_value_unit:=p_heat_diss_tot_value_unit,
    heat_diss_conv          :=p_heat_diss_conv,
    heat_diss_lat           :=p_heat_diss_lat,
    heat_diss_rad           :=p_heat_diss_rad,
    electr_pwr              :=p_electr_pwr,
    electr_pwr_unit         :=p_electr_pwr_unit,
    oper_sched_id           :=p_oper_sched_id,
    usage_zone_id           :=p_usage_zone_id,
    building_unit_id        :=p_building_unit_id,
    schema_name             :=p_schema_name
);
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_insert_electrical_appliances(): %', SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function INSERT_LIGHTING (CityObject)
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.nrg8_insert_lighting(
  id                     integer DEFAULT NULL,
  gmlid                  varchar(256) DEFAULT NULL,
  gmlid_codespace        varchar(1000) DEFAULT NULL,
  name                   varchar(1000) DEFAULT NULL,
  name_codespace         varchar(4000) DEFAULT NULL,
  description            varchar(4000) DEFAULT NULL,
  envelope               geometry DEFAULT NULL,
  creation_date          timestamp(0) with time zone DEFAULT NULL,
  termination_date       timestamp(0) with time zone DEFAULT NULL,
  relative_to_terrain    varchar(256) DEFAULT NULL,
  relative_to_water      varchar(256) DEFAULT NULL,
  last_modification_date timestamp with time zone DEFAULT NULL,
  updating_person        varchar(256) DEFAULT NULL,
  reason_for_update      varchar(4000) DEFAULT NULL,
  lineage                varchar(256) DEFAULT NULL,
--
  heat_diss_tot_value      numeric DEFAULT NULL,
  heat_diss_tot_value_unit varchar DEFAULT NULL,
  heat_diss_conv           numeric DEFAULT NULL,
  heat_diss_lat            numeric DEFAULT NULL,
  heat_diss_rad            numeric DEFAULT NULL,
  electr_pwr               numeric DEFAULT NULL,
  electr_pwr_unit          varchar DEFAULT NULL,
  oper_sched_id            integer DEFAULT NULL,
  usage_zone_id            integer DEFAULT NULL,
  building_unit_id         integer DEFAULT NULL,
--
  schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
  p_id                     integer                     := id                    ;
  p_gmlid                  varchar(256)                := gmlid                 ;
  p_gmlid_codespace        varchar(1000)               := gmlid_codespace       ;
  p_name                   varchar(1000)               := name                  ;
  p_name_codespace         varchar(4000)               := name_codespace        ;
  p_description            varchar(4000)               := description           ;
  p_envelope               geometry                    := envelope              ;
  p_creation_date          timestamp(0) with time zone := creation_date         ;
  p_termination_date       timestamp(0) with time zone := termination_date      ;
  p_relative_to_terrain    varchar(256)                := relative_to_terrain   ;
  p_relative_to_water      varchar(256)                := relative_to_water     ;
  p_last_modification_date timestamp with time zone    := last_modification_date;
  p_updating_person        varchar(256)                := updating_person       ;
  p_reason_for_update      varchar(4000)               := reason_for_update     ;
  p_lineage                varchar(256)                := lineage               ;
--
  p_heat_diss_tot_value      numeric           := heat_diss_tot_value;
  p_heat_diss_tot_value_unit character varying := heat_diss_tot_value_unit;
  p_heat_diss_conv           numeric           := heat_diss_conv;
  p_heat_diss_lat            numeric           := heat_diss_lat;
  p_heat_diss_rad            numeric           := heat_diss_rad;
  p_electr_pwr               numeric           := electr_pwr;
  p_electr_pwr_unit          character varying := electr_pwr_unit;
  p_oper_sched_id            integer           := oper_sched_id;
  p_usage_zone_id            integer           := usage_zone_id;
  p_building_unit_id         integer           := building_unit_id;
--
  p_schema_name varchar := schema_name;
	class_name varchar DEFAULT 'LightingFacilities'::varchar;
	db_prefix varchar DEFAULT 'nrg8';
	objectclass_id integer;
	inserted_id integer;
BEGIN
objectclass_id=citydb_pkg.objectclass_classname_to_id(class_name, db_prefix, p_schema_name);

inserted_id=citydb_pkg.insert_cityobject(
    id                    :=p_id,
    objectclass_id        :=objectclass_id,
    gmlid                 :=p_gmlid,
    gmlid_codespace       :=p_gmlid_codespace,
    name                  :=p_name,
    name_codespace        :=p_name_codespace,
    description           :=p_description,
    envelope              :=p_envelope,
    creation_date         :=p_creation_date,
    termination_date      :=p_termination_date,
    relative_to_terrain   :=p_relative_to_terrain,
    relative_to_water     :=p_relative_to_water,
    last_modification_date:=p_last_modification_date,
    updating_person       :=p_updating_person,
    reason_for_update     :=p_reason_for_update,
    lineage               :=p_lineage,
    schema_name           :=p_schema_name
);
PERFORM citydb_pkg.nrg8_insert_facilities(
    id                      :=inserted_id,
    objectclass_id          :=objectclass_id,
    heat_diss_tot_value     :=p_heat_diss_tot_value,
    heat_diss_tot_value_unit:=p_heat_diss_tot_value_unit,
    heat_diss_conv          :=p_heat_diss_conv,
    heat_diss_lat           :=p_heat_diss_lat,
    heat_diss_rad           :=p_heat_diss_rad,
    electr_pwr              :=p_electr_pwr,
    electr_pwr_unit         :=p_electr_pwr_unit,
    oper_sched_id           :=p_oper_sched_id,
    usage_zone_id           :=p_usage_zone_id,
    building_unit_id        :=p_building_unit_id,
    schema_name             :=p_schema_name
);
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_insert_lighting(): %', SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function INSERT_FINAL_ENERGY (non CityObject)
----------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.nrg8_insert_final_energy(
  id                           integer DEFAULT NULL,
  gmlid                        character varying DEFAULT NULL,
  gmlid_codespace              character varying DEFAULT NULL,
  name                         character varying DEFAULT NULL,
  name_codespace               character varying DEFAULT NULL,
  description                  text DEFAULT NULL,
  nrg_car_type                 character varying DEFAULT NULL,
  nrg_car_prim_nrg_factor      numeric DEFAULT NULL,
  nrg_car_prim_nrg_factor_unit character varying DEFAULT NULL,
  nrg_car_nrg_density          numeric DEFAULT NULL,
  nrg_car_nrg_density_unit     character varying DEFAULT NULL,
  nrg_car_co2_emission         numeric DEFAULT NULL,
  nrg_car_co2_emission_unit    character varying DEFAULT NULL,
  time_series_id               integer DEFAULT NULL,
--
  schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
  p_id                           integer           := id;
  p_gmlid                        character varying := gmlid;
  p_gmlid_codespace              character varying := gmlid_codespace;
  p_name                         character varying := name;
  p_name_codespace               character varying := name_codespace;
  p_description                  text              := description;
  p_nrg_car_type                 character varying := nrg_car_type;
  p_nrg_car_prim_nrg_factor      numeric           := nrg_car_prim_nrg_factor;
  p_nrg_car_prim_nrg_factor_unit character varying := nrg_car_prim_nrg_factor_unit;
  p_nrg_car_nrg_density          numeric           := nrg_car_nrg_density;
  p_nrg_car_nrg_density_unit     character varying := nrg_car_nrg_density_unit;
  p_nrg_car_co2_emission         numeric           := nrg_car_co2_emission;
  p_nrg_car_co2_emission_unit    character varying := nrg_car_co2_emission_unit;
  p_time_series_id               integer           := time_series_id;
--
  p_schema_name varchar := schema_name;
	class_name varchar DEFAULT 'FinalEnergy'::varchar;
	db_prefix varchar DEFAULT 'nrg8'::varchar;
	objectclass_id integer;
	inserted_id integer;
BEGIN
objectclass_id=citydb_pkg.objectclass_classname_to_id(class_name, db_prefix, p_schema_name);

inserted_id=citydb_pkg.nrg8_insert_final_energy(
    id                          :=p_id,
    objectclass_id              :=objectclass_id,
    gmlid                       :=p_gmlid,
    gmlid_codespace             :=p_gmlid_codespace,
    name                        :=p_name,
    name_codespace              :=p_name_codespace,
    description                 :=p_description,
    nrg_car_type                :=p_nrg_car_type,
    nrg_car_prim_nrg_factor     :=p_nrg_car_prim_nrg_factor,
    nrg_car_prim_nrg_factor_unit:=p_nrg_car_prim_nrg_factor_unit,
    nrg_car_nrg_density         :=p_nrg_car_nrg_density,
    nrg_car_nrg_density_unit    :=p_nrg_car_nrg_density_unit,
    nrg_car_co2_emission        :=p_nrg_car_co2_emission,
    nrg_car_co2_emission_unit   :=p_nrg_car_co2_emission_unit,
    time_series_id              :=p_time_series_id,
    schema_name                 :=p_schema_name
);
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_insert_final_energy(): %', SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function INSERT_HOUSEHOLD (non CityObject)
----------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.nrg8_insert_household(
  id                   integer DEFAULT NULL,
  gmlid                character varying DEFAULT NULL,
  gmlid_codespace      character varying DEFAULT NULL,
  name                 character varying DEFAULT NULL,
  name_codespace       character varying DEFAULT NULL,
  description          text DEFAULT NULL,
  type                 character varying DEFAULT NULL,
  residence_type       character varying DEFAULT NULL,
  occupants_id         integer DEFAULT NULL,
--
  schema_name          varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
  p_id                 integer           := id;
  p_gmlid              character varying := gmlid;
  p_gmlid_codespace    character varying := gmlid_codespace;
  p_name               character varying := name;
  p_name_codespace     character varying := name_codespace;
  p_description        text              := description;
  p_type               character varying := type;
  p_residence_type     character varying := residence_type;
  p_occupants_id       integer           := occupants_id;
--
  p_schema_name varchar := schema_name;
	class_name varchar DEFAULT 'Household'::varchar;
	db_prefix varchar DEFAULT 'nrg8'::varchar;
	objectclass_id integer;
	inserted_id integer;
BEGIN
objectclass_id=citydb_pkg.objectclass_classname_to_id(class_name, db_prefix, p_schema_name);

inserted_id=citydb_pkg.nrg8_insert_household(
    id                   :=p_id,
    objectclass_id       :=objectclass_id,
    gmlid                :=p_gmlid,
    gmlid_codespace      :=p_gmlid_codespace,
    name                 :=p_name,
    name_codespace       :=p_name_codespace,
    description          :=p_description,
    type                 :=p_type,
    residence_type       :=p_residence_type,
    occupants_id         :=p_occupants_id,
    schema_name          :=p_schema_name
);
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_insert_household(): %', SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function INSERT_LAYER (non CityObject)
----------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.nrg8_insert_layer(
  id                   integer DEFAULT NULL,
  gmlid                character varying DEFAULT NULL,
  gmlid_codespace      character varying DEFAULT NULL,
  name                 character varying DEFAULT NULL,
  name_codespace       character varying DEFAULT NULL,
  description          text DEFAULT NULL,
  pos_nbr              integer DEFAULT NULL,
  constr_id            integer DEFAULT NULL,
--
  schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
  p_id                 integer           := id;
  p_gmlid              character varying := gmlid;
  p_gmlid_codespace    character varying := gmlid_codespace;
  p_name               character varying := name;
  p_name_codespace     character varying := name_codespace;
  p_description        text              := description;
  p_pos_nbr            integer           := pos_nbr;
  p_constr_id          integer           := constr_id;
--
  p_schema_name varchar := schema_name;
	class_name varchar DEFAULT 'Layer'::varchar;
	db_prefix varchar DEFAULT 'nrg8'::varchar;
	objectclass_id integer;
	inserted_id integer;
BEGIN
objectclass_id=citydb_pkg.objectclass_classname_to_id(class_name, db_prefix, p_schema_name);

inserted_id=citydb_pkg.nrg8_insert_layer(
    id                   :=p_id,
    objectclass_id       :=objectclass_id,
    gmlid                :=p_gmlid,
    gmlid_codespace      :=p_gmlid_codespace,
    name                 :=p_name,
    name_codespace       :=p_name_codespace,
    description          :=p_description,
    pos_nbr              :=p_pos_nbr,
    constr_id            :=p_constr_id,
    schema_name          :=p_schema_name
);
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_insert_layer(): %', SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function INSERT_LAYER_COMPONENT (non CityObject)
----------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.nrg8_insert_layer_component(
  id                       integer DEFAULT NULL,
  gmlid                    character varying DEFAULT NULL,
  gmlid_codespace          character varying DEFAULT NULL,
  name                     character varying DEFAULT NULL,
  name_codespace           character varying DEFAULT NULL,
  description              text DEFAULT NULL,
  area_fr                  numeric DEFAULT NULL,
  thickness                numeric DEFAULT NULL,
  thickness_unit           character varying DEFAULT NULL,
  start_of_life            date DEFAULT NULL,
  life_expect_value        numeric DEFAULT NULL,
  life_expect_value_unit   character varying DEFAULT NULL,
  main_maint_interval      numeric DEFAULT NULL,
  main_maint_interval_unit character varying DEFAULT NULL,
  layer_id                 integer DEFAULT NULL,
--
  schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
  p_id                       integer           := id;
  p_gmlid                    character varying := gmlid;
  p_gmlid_codespace          character varying := gmlid_codespace;
  p_name                     character varying := name;
  p_name_codespace           character varying := name_codespace;
  p_description              text              := description;
  p_area_fr                  numeric           := area_fr;
  p_thickness                numeric           := thickness;
  p_thickness_unit           character varying := thickness_unit;
  p_start_of_life            date              := start_of_life;
  p_life_expect_value        numeric           := life_expect_value;
  p_life_expect_value_unit   character varying := life_expect_value_unit;
  p_main_maint_interval      numeric           := main_maint_interval;
  p_main_maint_interval_unit character varying := main_maint_interval_unit;
  p_layer_id                 integer           := layer_id;
	--
  p_schema_name varchar := schema_name;
	class_name varchar DEFAULT 'LayerComponent'::varchar;
	db_prefix varchar DEFAULT 'nrg8'::varchar;
	objectclass_id integer;
	inserted_id integer;
BEGIN
objectclass_id=citydb_pkg.objectclass_classname_to_id(class_name, db_prefix, p_schema_name);

inserted_id=citydb_pkg.nrg8_insert_layer_component(
    id                      :=p_id,
    objectclass_id          :=objectclass_id,
    gmlid                   :=p_gmlid,
    gmlid_codespace         :=p_gmlid_codespace,
    name                    :=p_name,
    name_codespace          :=p_name_codespace,
    description             :=p_description,
    area_fr                 :=p_area_fr,
    thickness               :=p_thickness,
    thickness_unit          :=p_thickness_unit,
    start_of_life           :=p_start_of_life,
    life_expect_value       :=p_life_expect_value,
    life_expect_value_unit  :=p_life_expect_value_unit,
    main_maint_interval     :=p_main_maint_interval,
    main_maint_interval_unit:=p_main_maint_interval_unit,
    layer_id                :=p_layer_id,
    schema_name             :=p_schema_name
);
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_insert_layer_component(): %', SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function INSERT_GAS (non CityObject)
----------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.nrg8_insert_gas(
  id                   integer DEFAULT NULL,
  gmlid                character varying DEFAULT NULL,
  gmlid_codespace      character varying DEFAULT NULL,
  name                 character varying DEFAULT NULL,
  name_codespace       character varying DEFAULT NULL,
  description          text DEFAULT NULL,
  is_ventilated        numeric DEFAULT NULL,
  r_value              numeric DEFAULT NULL,
  r_value_unit         character varying DEFAULT NULL,
  embodied_carbon      numeric DEFAULT NULL,
  embodied_carbon_unit character varying DEFAULT NULL,
  embodied_nrg         numeric DEFAULT NULL,
  embodied_nrg_unit    character varying DEFAULT NULL,
  layer_component_id   integer DEFAULT NULL,
--
  schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
  p_id                   integer           := id;
  p_gmlid                character varying := gmlid;
  p_gmlid_codespace      character varying := gmlid_codespace;
  p_name                 character varying := name;
  p_name_codespace       character varying := name_codespace;
  p_description          text              := description;
  p_is_ventilated        numeric           := is_ventilated;
  p_r_value              numeric           := r_value;
  p_r_value_unit         character varying := r_value_unit;
  p_embodied_carbon      numeric           := embodied_carbon;
  p_embodied_carbon_unit character varying := embodied_carbon_unit;
  p_embodied_nrg         numeric           := embodied_nrg;
  p_embodied_nrg_unit    character varying := embodied_nrg_unit;
  p_layer_component_id   integer           := layer_component_id;
--
  p_schema_name varchar := schema_name;
	class_name varchar DEFAULT 'Gas'::varchar;
	db_prefix varchar DEFAULT 'nrg8'::varchar;
	objectclass_id integer;
	inserted_id integer;
BEGIN
objectclass_id=citydb_pkg.objectclass_classname_to_id(class_name, db_prefix, p_schema_name);

inserted_id=citydb_pkg.nrg8_insert_material(
    id                   :=p_id,
    objectclass_id       :=objectclass_id,
    gmlid                :=p_gmlid,
    gmlid_codespace      :=p_gmlid_codespace,
    name                 :=p_name,
    name_codespace       :=p_name_codespace,
    description          :=p_description,
    is_ventilated        :=p_is_ventilated,
    r_value              :=p_r_value,
    r_value_unit         :=p_r_value_unit,
    embodied_carbon      :=p_embodied_carbon,
    embodied_carbon_unit :=p_embodied_carbon_unit,
    embodied_nrg         :=p_embodied_nrg,
    embodied_nrg_unit    :=p_embodied_nrg_unit,
    layer_component_id   :=p_layer_component_id,
    schema_name          :=p_schema_name
);
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_insert_gas(): %', SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function INSERT_SOLID_MATERIAL (non CityObject)
----------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.nrg8_insert_solid_material(
  id                   integer DEFAULT NULL,
  gmlid                character varying DEFAULT NULL,
  gmlid_codespace      character varying DEFAULT NULL,
  name                 character varying DEFAULT NULL,
  name_codespace       character varying DEFAULT NULL,
  description          text DEFAULT NULL,
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
--
  schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
  p_id                   integer           := id;
  p_gmlid                character varying := gmlid;
  p_gmlid_codespace      character varying := gmlid_codespace;
  p_name                 character varying := name;
  p_name_codespace       character varying := name_codespace;
  p_description          text              := description;
  p_density              numeric           := density;
  p_density_unit         character varying := density_unit;
  p_specific_heat        numeric           := specific_heat;
  p_specific_heat_unit   character varying := specific_heat_unit;
  p_conductivity         numeric           := conductivity;
  p_conductivity_unit    character varying := conductivity_unit;
  p_permeance            numeric           := permeance;
  p_permeance_unit       character varying := permeance_unit;
  p_porosity             numeric           := porosity;
  p_embodied_carbon      numeric           := embodied_carbon;
  p_embodied_carbon_unit character varying := embodied_carbon_unit;
  p_embodied_nrg         numeric           := embodied_nrg;
  p_embodied_nrg_unit    character varying := embodied_nrg_unit;
  p_layer_component_id   integer           := layer_component_id;
--
  p_schema_name varchar := schema_name;
	class_name varchar DEFAULT 'SolidMaterial'::varchar;
	db_prefix varchar DEFAULT 'nrg8'::varchar;
	objectclass_id integer;
	inserted_id integer;
BEGIN
objectclass_id=citydb_pkg.objectclass_classname_to_id(class_name, db_prefix, p_schema_name);

inserted_id=citydb_pkg.nrg8_insert_material(
    id                   :=p_id,
    objectclass_id       :=objectclass_id,
    gmlid                :=p_gmlid,
    gmlid_codespace      :=p_gmlid_codespace,
    name                 :=p_name,
    name_codespace       :=p_name_codespace,
    description          :=p_description,
    density              :=p_density,
    density_unit         :=p_density_unit,
    specific_heat        :=p_specific_heat,
    specific_heat_unit   :=p_specific_heat_unit,
    conductivity         :=p_conductivity,
    conductivity_unit    :=p_conductivity_unit,
    permeance            :=p_permeance,
    permeance_unit       :=p_permeance_unit,
    porosity             :=p_porosity,
    embodied_carbon      :=p_embodied_carbon,
    embodied_carbon_unit :=p_embodied_carbon_unit,
    embodied_nrg         :=p_embodied_nrg,
    embodied_nrg_unit    :=p_embodied_nrg_unit,
    layer_component_id   :=p_layer_component_id,
    schema_name          :=p_schema_name
);
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_insert_solid_material(): %', SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function INSERT_OCCUPANTS (non CityObject)
----------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.nrg8_insert_occupants(
  id                       integer DEFAULT NULL,
  gmlid                    character varying DEFAULT NULL,
  gmlid_codespace          character varying DEFAULT NULL,
  name                     character varying DEFAULT NULL,
  name_codespace           character varying DEFAULT NULL,
  description              text DEFAULT NULL,
  type                     character varying DEFAULT NULL,
  nbr_of_occupants         integer DEFAULT NULL,
  heat_diss_tot_value      numeric DEFAULT NULL,
  heat_diss_tot_value_unit character varying DEFAULT NULL,
  heat_diss_conv           numeric DEFAULT NULL,
  heat_diss_lat            numeric DEFAULT NULL,
  heat_diss_rad            numeric DEFAULT NULL,
  usage_zone_id            integer DEFAULT NULL,
  sched_id                 integer DEFAULT NULL,
  building_unit_id         integer DEFAULT NULL,
--
  schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
  p_id                 integer                 := id;
  p_gmlid              character varying       := gmlid;
  p_gmlid_codespace    character varying       := gmlid_codespace;
  p_name               character varying       := name;
  p_name_codespace     character varying       := name_codespace;
  p_description        text                    := description;
  p_type               character varying       := type;
  p_nbr_of_occupants   integer                 := nbr_of_occupants;
  p_heat_diss_tot_value numeric                := heat_diss_tot_value;
  p_heat_diss_tot_value_unit character varying := heat_diss_tot_value_unit;
  p_heat_diss_conv     numeric                 := heat_diss_conv;
  p_heat_diss_lat      numeric                 := heat_diss_lat;
  p_heat_diss_rad      numeric                 := heat_diss_rad;
  p_usage_zone_id      integer                 := usage_zone_id;
  p_sched_id           integer                 := sched_id;
  p_building_unit_id   integer                 := building_unit_id;
--
  p_schema_name varchar := schema_name;
	class_name varchar DEFAULT 'Occupants'::varchar;
	db_prefix varchar DEFAULT 'nrg8'::varchar;
	objectclass_id integer;
	inserted_id integer;
BEGIN
objectclass_id=citydb_pkg.objectclass_classname_to_id(class_name, db_prefix, p_schema_name);

inserted_id=citydb_pkg.nrg8_insert_occupants(
    id                      :=p_id,
    objectclass_id          :=objectclass_id,
    gmlid                   :=p_gmlid,
    gmlid_codespace         :=p_gmlid_codespace,
    name                    :=p_name,
    name_codespace          :=p_name_codespace,
    description             :=p_description,
    type                    :=p_type,
    nbr_of_occupants        :=p_nbr_of_occupants,
    heat_diss_tot_value     :=p_heat_diss_tot_value,
    heat_diss_tot_value_unit:=p_heat_diss_tot_value_unit,
    heat_diss_conv          :=p_heat_diss_conv,
    heat_diss_lat           :=p_heat_diss_lat,
    heat_diss_rad           :=p_heat_diss_rad,
    sched_id                :=p_sched_id,
    usage_zone_id           :=p_usage_zone_id,
    building_unit_id        :=p_building_unit_id,
    schema_name             :=p_schema_name
);
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_insert_occupants(): %', SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function INSERT_EMISSIVITY (non CityObject)
----------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.nrg8_insert_emissivity(
  id                   integer DEFAULT NULL,
  fraction             numeric DEFAULT NULL,
--  range                character varying DEFAULT NULL,
  surf_side            character varying DEFAULT NULL,
  constr_id            integer DEFAULT NULL,
--
  schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
  p_id                 integer             := id;
  p_fraction           numeric             := fraction;
--  p_range              character varying   := range;
  p_surf_side          character varying   := surf_side;
  p_constr_id          integer             := constr_id;
--
  p_schema_name varchar := schema_name;
	class_name varchar DEFAULT 'Emissivity'::varchar;
	db_prefix varchar DEFAULT 'nrg8'::varchar;
	objectclass_id integer;
	inserted_id integer;
BEGIN
objectclass_id=citydb_pkg.objectclass_classname_to_id(class_name, db_prefix, p_schema_name);

inserted_id=citydb_pkg.nrg8_insert_optical_property(
    id             :=p_id,
    objectclass_id :=objectclass_id,
    fraction       :=p_fraction,
    -- range          :=p_range,
    surf_side      :=p_surf_side,
    constr_id      :=p_constr_id,
    schema_name    :=p_schema_name
);
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_insert_emissivity(): %', SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function INSERT_REFLECTANCE (non CityObject)
----------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.nrg8_insert_reflectance(
  id                   integer DEFAULT NULL,
  fraction             numeric DEFAULT NULL,
  range                character varying DEFAULT NULL,
  surf_side            character varying DEFAULT NULL,
  constr_id            integer DEFAULT NULL,
--
  schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
  p_id                 integer             := id;
  p_fraction           numeric             := fraction;
  p_range              character varying   := range;
  p_surf_side          character varying   := surf_side;
  p_constr_id          integer             := constr_id;
--
  p_schema_name varchar := schema_name;
	class_name varchar DEFAULT 'Reflectance'::varchar;
	db_prefix varchar DEFAULT 'nrg8'::varchar;
	objectclass_id integer;
	inserted_id integer;
BEGIN
objectclass_id=citydb_pkg.objectclass_classname_to_id(class_name, db_prefix, p_schema_name);

inserted_id=citydb_pkg.nrg8_insert_optical_property(
    id             :=p_id,
    objectclass_id :=objectclass_id,
    fraction       :=p_fraction,
    range          :=p_range,
    surf_side      :=p_surf_side,
    constr_id      :=p_constr_id,
    schema_name    :=p_schema_name
);
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_insert_reflectance(): %', SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function INSERT_TRANSMITTANCE (non CityObject)
----------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.nrg8_insert_transmittance(
  id                   integer DEFAULT NULL,
  fraction             numeric DEFAULT NULL,
  range                character varying DEFAULT NULL,
--  surf_side            character varying DEFAULT NULL,
  constr_id            integer DEFAULT NULL,
--
  schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
  p_id                 integer             := id;
  p_fraction           numeric             := fraction;
  p_range              character varying   := range;
  -- p_surf_side          character varying   := surf_side;
  p_constr_id          integer             := constr_id;
--
  p_schema_name varchar := schema_name;
	class_name varchar DEFAULT 'Transmittance'::varchar;
	db_prefix varchar DEFAULT 'nrg8'::varchar;
	objectclass_id integer;
	inserted_id integer;
BEGIN
objectclass_id=citydb_pkg.objectclass_classname_to_id(class_name, db_prefix, p_schema_name);

inserted_id=citydb_pkg.nrg8_insert_optical_property(
    id             :=p_id,
    objectclass_id :=objectclass_id,
    fraction       :=p_fraction,
    range          :=p_range,
    -- surf_side      :=p_surf_side,
    constr_id      :=p_constr_id,
    schema_name    :=p_schema_name
);
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_insert_transmittance(): %', SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function INSERT_PERF_CERTIFICATION (non CityObject)
----------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.nrg8_insert_perf_certification(
  id                   integer DEFAULT NULL,
  name                 character varying DEFAULT NULL,
  rating               character varying DEFAULT NULL,
  certification_id     character varying DEFAULT NULL,
  building_id          integer DEFAULT NULL,
  building_unit_id     integer DEFAULT NULL,
--
  schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
  p_id                 integer           := id;
  p_name               character varying := name;
  p_rating             character varying := rating;
  p_certification_id   character varying := certification_id;
  p_building_id        integer           := building_id;
  p_building_unit_id   integer           := building_unit_id;
--
  p_schema_name varchar := schema_name;
	inserted_id integer;
BEGIN
inserted_id=citydb_pkg.nrg8_insert_perf_certification(
    id               :=p_id,
    name             :=p_name,
    rating           :=p_rating,
    certification_id :=p_certification_id,
    building_id      :=p_building_id,
    building_unit_id :=p_building_unit_id,
    schema_name      :=p_schema_name
);
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_insert_perf_certification(): %', SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function INSERT_PERIOD_OF_YEAR (non CityObject)
----------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.nrg8_insert_period_of_year(
  id                   integer DEFAULT NULL,
  begin_time           time without time zone DEFAULT NULL,
  begin_day            integer DEFAULT NULL,
  begin_month          integer DEFAULT NULL,
  end_time             time without time zone DEFAULT NULL,
  end_day              integer DEFAULT NULL,
  end_month            integer DEFAULT NULL,
  sched_id             integer DEFAULT NULL,
--
  schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
  p_id          integer                := id;
  p_begin_time  time without time zone := begin_time;
  p_begin_day   integer                := begin_day;
  p_begin_month integer                := begin_month;
  p_end_time    time without time zone := end_time;
  p_end_day     integer                := end_day;
  p_end_month   integer                := end_month;
  p_sched_id    integer                := sched_id;
--
  p_schema_name varchar := schema_name;
	inserted_id integer;
BEGIN
inserted_id=citydb_pkg.nrg8_insert_period_of_year(
    id           :=p_id,
    begin_time   :=p_begin_time,
    begin_day    :=p_begin_day,
    begin_month  :=p_begin_month,
    end_time     :=p_end_time,
    end_day      :=p_end_day,
    end_month    :=p_end_month,
    sched_id     :=p_sched_id,
    schema_name  :=p_schema_name
);
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_insert_period_of_year(): %', SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function INSERT_DISTRIB_SYSTEM (CityObject)
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.nrg8_insert_distrib_system(
  id                     integer DEFAULT NULL,
  gmlid                  varchar(256) DEFAULT NULL,
  gmlid_codespace        varchar(1000) DEFAULT NULL,
  name                   varchar(1000) DEFAULT NULL,
  name_codespace         varchar(4000) DEFAULT NULL,
  description            varchar(4000) DEFAULT NULL,
  envelope               geometry DEFAULT NULL,
  creation_date          timestamp(0) with time zone DEFAULT NULL,
  termination_date       timestamp(0) with time zone DEFAULT NULL,
  relative_to_terrain    varchar(256) DEFAULT NULL,
  relative_to_water      varchar(256) DEFAULT NULL,
  last_modification_date timestamp with time zone DEFAULT NULL,
  updating_person        varchar(256) DEFAULT NULL,
  reason_for_update      varchar(4000) DEFAULT NULL,
  lineage                varchar(256) DEFAULT NULL,
--
  distrib_perim            character varying DEFAULT NULL,
  start_of_life            date DEFAULT NULL,
  life_expect_value        numeric DEFAULT NULL,
  life_expect_value_unit   character varying DEFAULT NULL,
  main_maint_interval      numeric DEFAULT NULL,
  main_maint_interval_unit character varying DEFAULT NULL,
  nrg_demand_id            integer DEFAULT NULL,
  cityobject_id            integer DEFAULT NULL,
--
  schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
  p_id                     integer                     := id                    ;
  p_gmlid                  varchar(256)                := gmlid                 ;
  p_gmlid_codespace        varchar(1000)               := gmlid_codespace       ;
  p_name                   varchar(1000)               := name                  ;
  p_name_codespace         varchar(4000)               := name_codespace        ;
  p_description            varchar(4000)               := description           ;
  p_envelope               geometry                    := envelope              ;
  p_creation_date          timestamp(0) with time zone := creation_date         ;
  p_termination_date       timestamp(0) with time zone := termination_date      ;
  p_relative_to_terrain    varchar(256)                := relative_to_terrain   ;
  p_relative_to_water      varchar(256)                := relative_to_water     ;
  p_last_modification_date timestamp with time zone    := last_modification_date;
  p_updating_person        varchar(256)                := updating_person       ;
  p_reason_for_update      varchar(4000)               := reason_for_update     ;
  p_lineage                varchar(256)                := lineage               ;
--
  p_distrib_perim            character varying := distrib_perim;
  p_start_of_life            date              := start_of_life;
  p_life_expect_value        numeric           := life_expect_value;
  p_life_expect_value_unit   character varying := life_expect_value_unit;
  p_main_maint_interval      numeric           := main_maint_interval;
  p_main_maint_interval_unit character varying := main_maint_interval_unit;
  p_nrg_demand_id            integer           := nrg_demand_id;
  p_cityobject_id            integer           := cityobject_id;
--
  p_schema_name varchar := schema_name;
	class_name varchar DEFAULT 'DistributionSystem'::varchar;
	db_prefix varchar DEFAULT 'nrg8';
	objectclass_id integer;
	inserted_id integer;
BEGIN
objectclass_id=citydb_pkg.objectclass_classname_to_id(class_name, db_prefix, p_schema_name);

inserted_id=citydb_pkg.insert_cityobject(
    id                    :=p_id,
    objectclass_id        :=objectclass_id,
    gmlid                 :=p_gmlid,
    gmlid_codespace       :=p_gmlid_codespace,
    name                  :=p_name,
    name_codespace        :=p_name_codespace,
    description           :=p_description,
    envelope              :=p_envelope,
    creation_date         :=p_creation_date,
    termination_date      :=p_termination_date,
    relative_to_terrain   :=p_relative_to_terrain,
    relative_to_water     :=p_relative_to_water,
    last_modification_date:=p_last_modification_date,
    updating_person       :=p_updating_person,
    reason_for_update     :=p_reason_for_update,
    lineage               :=p_lineage,
    schema_name           :=p_schema_name
);
PERFORM citydb_pkg.nrg8_insert_distrib_system(
    id                      :=inserted_id,
    objectclass_id          :=objectclass_id,
    distrib_perim           :=p_distrib_perim,
    start_of_life           :=p_start_of_life,
    life_expect_value       :=p_life_expect_value,
    life_expect_value_unit  :=p_life_expect_value_unit,
    main_maint_interval     :=p_main_maint_interval,
    main_maint_interval_unit:=p_main_maint_interval_unit,
    nrg_demand_id           :=p_nrg_demand_id,
    cityobject_id           :=p_cityobject_id,
    schema_name             :=p_schema_name
);
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_insert_distrib_system(): %', SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function INSERT_POWER_DISTRIB_SYSTEM (CityObject)
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.nrg8_insert_power_distrib_system(
  id                     integer DEFAULT NULL,
  gmlid                  varchar(256) DEFAULT NULL,
  gmlid_codespace        varchar(1000) DEFAULT NULL,
  name                   varchar(1000) DEFAULT NULL,
  name_codespace         varchar(4000) DEFAULT NULL,
  description            varchar(4000) DEFAULT NULL,
  envelope               geometry DEFAULT NULL,
  creation_date          timestamp(0) with time zone DEFAULT NULL,
  termination_date       timestamp(0) with time zone DEFAULT NULL,
  relative_to_terrain    varchar(256) DEFAULT NULL,
  relative_to_water      varchar(256) DEFAULT NULL,
  last_modification_date timestamp with time zone DEFAULT NULL,
  updating_person        varchar(256) DEFAULT NULL,
  reason_for_update      varchar(4000) DEFAULT NULL,
  lineage                varchar(256) DEFAULT NULL,
--
  distrib_perim            character varying DEFAULT NULL,
  start_of_life            date DEFAULT NULL,
  life_expect_value        numeric DEFAULT NULL,
  life_expect_value_unit   character varying DEFAULT NULL,
  main_maint_interval      numeric DEFAULT NULL,
  main_maint_interval_unit character varying DEFAULT NULL,
  nrg_demand_id            integer DEFAULT NULL,
  cityobject_id            integer DEFAULT NULL,
--
  current              numeric DEFAULT NULL,
  current_unit         character varying DEFAULT NULL,
  voltage              numeric DEFAULT NULL,
  voltage_unit         character varying DEFAULT NULL,
--
  schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
  p_id                     integer                     := id                    ;
  p_gmlid                  varchar(256)                := gmlid                 ;
  p_gmlid_codespace        varchar(1000)               := gmlid_codespace       ;
  p_name                   varchar(1000)               := name                  ;
  p_name_codespace         varchar(4000)               := name_codespace        ;
  p_description            varchar(4000)               := description           ;
  p_envelope               geometry                    := envelope              ;
  p_creation_date          timestamp(0) with time zone := creation_date         ;
  p_termination_date       timestamp(0) with time zone := termination_date      ;
  p_relative_to_terrain    varchar(256)                := relative_to_terrain   ;
  p_relative_to_water      varchar(256)                := relative_to_water     ;
  p_last_modification_date timestamp with time zone    := last_modification_date;
  p_updating_person        varchar(256)                := updating_person       ;
  p_reason_for_update      varchar(4000)               := reason_for_update     ;
  p_lineage                varchar(256)                := lineage               ;
--
  p_distrib_perim            character varying := distrib_perim;
  p_start_of_life            date              := start_of_life;
  p_life_expect_value        numeric           := life_expect_value;
  p_life_expect_value_unit   character varying := life_expect_value_unit;
  p_main_maint_interval      numeric           := main_maint_interval;
  p_main_maint_interval_unit character varying := main_maint_interval_unit;
  p_nrg_demand_id            integer           := nrg_demand_id;
  p_cityobject_id            integer           := cityobject_id;
--
  p_current            numeric           := current;
  p_current_unit       character varying := current_unit;
  p_voltage            numeric           := voltage;
  p_voltage_unit       character varying := voltage_unit;
--
  p_schema_name varchar := schema_name;
	class_name varchar DEFAULT 'PowerDistributionSystem'::varchar;
	db_prefix varchar DEFAULT 'nrg8';
	objectclass_id integer;
	inserted_id integer;
BEGIN
objectclass_id=citydb_pkg.objectclass_classname_to_id(class_name, db_prefix, p_schema_name);

inserted_id=citydb_pkg.insert_cityobject(
    id                    :=p_id,
    objectclass_id        :=objectclass_id,
    gmlid                 :=p_gmlid,
    gmlid_codespace       :=p_gmlid_codespace,
    name                  :=p_name,
    name_codespace        :=p_name_codespace,
    description           :=p_description,
    envelope              :=p_envelope,
    creation_date         :=p_creation_date,
    termination_date      :=p_termination_date,
    relative_to_terrain   :=p_relative_to_terrain,
    relative_to_water     :=p_relative_to_water,
    last_modification_date:=p_last_modification_date,
    updating_person       :=p_updating_person,
    reason_for_update     :=p_reason_for_update,
    lineage               :=p_lineage,
    schema_name           :=p_schema_name
);
PERFORM citydb_pkg.nrg8_insert_distrib_system(
    id                      :=inserted_id,
    objectclass_id          :=objectclass_id,
    distrib_perim           :=p_distrib_perim,
    start_of_life           :=p_start_of_life,
    life_expect_value       :=p_life_expect_value,
    life_expect_value_unit  :=p_life_expect_value_unit,
    main_maint_interval     :=p_main_maint_interval,
    main_maint_interval_unit:=p_main_maint_interval_unit,
    nrg_demand_id           :=p_nrg_demand_id,
    cityobject_id           :=p_cityobject_id,
    schema_name             :=p_schema_name
);
PERFORM citydb_pkg.nrg8_insert_power_distrib_system(
    id              :=inserted_id,
    objectclass_id  :=objectclass_id,
    current         :=p_current,
    current_unit    :=p_current_unit,
    voltage         :=p_voltage,
    voltage_unit    :=p_voltage_unit,
    schema_name     :=p_schema_name
);
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_insert_power_distrib_system(): %', SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function INSERT_THERMAL_DISTRIB_SYSTEM (CityObject)
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.nrg8_insert_thermal_distrib_system(
  id                     integer DEFAULT NULL,
  gmlid                  varchar(256) DEFAULT NULL,
  gmlid_codespace        varchar(1000) DEFAULT NULL,
  name                   varchar(1000) DEFAULT NULL,
  name_codespace         varchar(4000) DEFAULT NULL,
  description            varchar(4000) DEFAULT NULL,
  envelope               geometry DEFAULT NULL,
  creation_date          timestamp(0) with time zone DEFAULT NULL,
  termination_date       timestamp(0) with time zone DEFAULT NULL,
  relative_to_terrain    varchar(256) DEFAULT NULL,
  relative_to_water      varchar(256) DEFAULT NULL,
  last_modification_date timestamp with time zone DEFAULT NULL,
  updating_person        varchar(256) DEFAULT NULL,
  reason_for_update      varchar(4000) DEFAULT NULL,
  lineage                varchar(256) DEFAULT NULL,
--
  distrib_perim            character varying DEFAULT NULL,
  start_of_life            date DEFAULT NULL,
  life_expect_value        numeric DEFAULT NULL,
  life_expect_value_unit   character varying DEFAULT NULL,
  main_maint_interval      numeric DEFAULT NULL,
  main_maint_interval_unit character varying DEFAULT NULL,
  nrg_demand_id            integer DEFAULT NULL,
  cityobject_id            integer DEFAULT NULL,
--
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
--
  schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
  p_id                     integer                     := id                    ;
  p_gmlid                  varchar(256)                := gmlid                 ;
  p_gmlid_codespace        varchar(1000)               := gmlid_codespace       ;
  p_name                   varchar(1000)               := name                  ;
  p_name_codespace         varchar(4000)               := name_codespace        ;
  p_description            varchar(4000)               := description           ;
  p_envelope               geometry                    := envelope              ;
  p_creation_date          timestamp(0) with time zone := creation_date         ;
  p_termination_date       timestamp(0) with time zone := termination_date      ;
  p_relative_to_terrain    varchar(256)                := relative_to_terrain   ;
  p_relative_to_water      varchar(256)                := relative_to_water     ;
  p_last_modification_date timestamp with time zone    := last_modification_date;
  p_updating_person        varchar(256)                := updating_person       ;
  p_reason_for_update      varchar(4000)               := reason_for_update     ;
  p_lineage                varchar(256)                := lineage               ;
--
  p_distrib_perim            character varying := distrib_perim;
  p_start_of_life            date              := start_of_life;
  p_life_expect_value        numeric           := life_expect_value;
  p_life_expect_value_unit   character varying := life_expect_value_unit;
  p_main_maint_interval      numeric           := main_maint_interval;
  p_main_maint_interval_unit character varying := main_maint_interval_unit;
  p_nrg_demand_id            integer           := nrg_demand_id;
  p_cityobject_id            integer           := cityobject_id;
--
  p_has_circulation    numeric           := has_circulation;
  p_medium             character varying := medium;
  p_nom_flow           numeric           := nom_flow;
  p_nom_flow_unit      character varying := nom_flow_unit;
  p_supply_temp        numeric           := supply_temp;
  p_supply_temp_unit   character varying := supply_temp_unit;
  p_return_temp        numeric           := return_temp;
  p_return_temp_unit   character varying := return_temp_unit;
  p_therm_loss         numeric           := therm_loss;
  p_therm_loss_unit    character varying := therm_loss_unit;
--
  p_schema_name varchar := schema_name;
	class_name varchar DEFAULT 'ThermalDistributionSystem'::varchar;
	db_prefix varchar DEFAULT 'nrg8';
	objectclass_id integer;
	inserted_id integer;
BEGIN
objectclass_id=citydb_pkg.objectclass_classname_to_id(class_name, db_prefix, p_schema_name);

inserted_id=citydb_pkg.insert_cityobject(
    id                    :=p_id,
    objectclass_id        :=objectclass_id,
    gmlid                 :=p_gmlid,
    gmlid_codespace       :=p_gmlid_codespace,
    name                  :=p_name,
    name_codespace        :=p_name_codespace,
    description           :=p_description,
    envelope              :=p_envelope,
    creation_date         :=p_creation_date,
    termination_date      :=p_termination_date,
    relative_to_terrain   :=p_relative_to_terrain,
    relative_to_water     :=p_relative_to_water,
    last_modification_date:=p_last_modification_date,
    updating_person       :=p_updating_person,
    reason_for_update     :=p_reason_for_update,
    lineage               :=p_lineage,
    schema_name           :=p_schema_name
);
PERFORM citydb_pkg.nrg8_insert_distrib_system(
    id                      :=inserted_id,
    objectclass_id          :=objectclass_id,
    distrib_perim           :=p_distrib_perim,
    start_of_life           :=p_start_of_life,
    life_expect_value       :=p_life_expect_value,
    life_expect_value_unit  :=p_life_expect_value_unit,
    main_maint_interval     :=p_main_maint_interval,
    main_maint_interval_unit:=p_main_maint_interval_unit,
    nrg_demand_id           :=p_nrg_demand_id,
    cityobject_id           :=p_cityobject_id,
    schema_name             :=p_schema_name
);
PERFORM citydb_pkg.nrg8_insert_thermal_distrib_system(
    id              :=inserted_id,
    objectclass_id  :=objectclass_id,
    has_circulation :=p_has_circulation,
    medium          :=p_medium,
    nom_flow        :=p_nom_flow,
    nom_flow_unit   :=p_nom_flow_unit,
    supply_temp     :=p_supply_temp,
    supply_temp_unit:=p_supply_temp_unit,
    return_temp     :=p_return_temp,
    return_temp_unit:=p_return_temp_unit,
    therm_loss      :=p_therm_loss,
    therm_loss_unit :=p_therm_loss_unit,
    schema_name     :=p_schema_name
);
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_insert_thermal_distrib_system(): %', SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function INSERT_POWER_STORAGE_SYSTEM (CityObject)
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.nrg8_insert_power_storage_system(
  id                     integer DEFAULT NULL,
  gmlid                  varchar(256) DEFAULT NULL,
  gmlid_codespace        varchar(1000) DEFAULT NULL,
  name                   varchar(1000) DEFAULT NULL,
  name_codespace         varchar(4000) DEFAULT NULL,
  description            varchar(4000) DEFAULT NULL,
  envelope               geometry DEFAULT NULL,
  creation_date          timestamp(0) with time zone DEFAULT NULL,
  termination_date       timestamp(0) with time zone DEFAULT NULL,
  relative_to_terrain    varchar(256) DEFAULT NULL,
  relative_to_water      varchar(256) DEFAULT NULL,
  last_modification_date timestamp with time zone DEFAULT NULL,
  updating_person        varchar(256) DEFAULT NULL,
  reason_for_update      varchar(4000) DEFAULT NULL,
  lineage                varchar(256) DEFAULT NULL,
--
  start_of_life            date DEFAULT NULL,
  life_expect_value        numeric DEFAULT NULL,
  life_expect_value_unit   character varying DEFAULT NULL,
  main_maint_interval      numeric DEFAULT NULL,
  main_maint_interval_unit character varying DEFAULT NULL,
  nrg_demand_id            integer DEFAULT NULL,
  cityobject_id            integer DEFAULT NULL,
--
  battery_techn        character varying DEFAULT NULL,
  pwr_capacity         numeric DEFAULT NULL,
  pwr_capacity_unit    character varying DEFAULT NULL,
--
  schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
  p_id                     integer                     := id                    ;
  p_gmlid                  varchar(256)                := gmlid                 ;
  p_gmlid_codespace        varchar(1000)               := gmlid_codespace       ;
  p_name                   varchar(1000)               := name                  ;
  p_name_codespace         varchar(4000)               := name_codespace        ;
  p_description            varchar(4000)               := description           ;
  p_envelope               geometry                    := envelope              ;
  p_creation_date          timestamp(0) with time zone := creation_date         ;
  p_termination_date       timestamp(0) with time zone := termination_date      ;
  p_relative_to_terrain    varchar(256)                := relative_to_terrain   ;
  p_relative_to_water      varchar(256)                := relative_to_water     ;
  p_last_modification_date timestamp with time zone    := last_modification_date;
  p_updating_person        varchar(256)                := updating_person       ;
  p_reason_for_update      varchar(4000)               := reason_for_update     ;
  p_lineage                varchar(256)                := lineage               ;
--
  p_start_of_life            date              := start_of_life;
  p_life_expect_value        numeric           := life_expect_value;
  p_life_expect_value_unit   character varying := life_expect_value_unit;
  p_main_maint_interval      numeric           := main_maint_interval;
  p_main_maint_interval_unit character varying := main_maint_interval_unit;
  p_nrg_demand_id            integer           := nrg_demand_id;
  p_cityobject_id            integer           := cityobject_id;
--
  p_battery_techn      character varying := battery_techn;
  p_pwr_capacity       numeric           := pwr_capacity;
  p_pwr_capacity_unit  character varying := pwr_capacity_unit;
--
  p_schema_name varchar := schema_name;
	class_name varchar DEFAULT 'PowerStorageSystem'::varchar;
	db_prefix varchar DEFAULT 'nrg8';
	objectclass_id integer;
	inserted_id integer;
BEGIN
objectclass_id=citydb_pkg.objectclass_classname_to_id(class_name, db_prefix, p_schema_name);

inserted_id=citydb_pkg.insert_cityobject(
    id                    :=p_id,
    objectclass_id        :=objectclass_id,
    gmlid                 :=p_gmlid,
    gmlid_codespace       :=p_gmlid_codespace,
    name                  :=p_name,
    name_codespace        :=p_name_codespace,
    description           :=p_description,
    envelope              :=p_envelope,
    creation_date         :=p_creation_date,
    termination_date      :=p_termination_date,
    relative_to_terrain   :=p_relative_to_terrain,
    relative_to_water     :=p_relative_to_water,
    last_modification_date:=p_last_modification_date,
    updating_person       :=p_updating_person,
    reason_for_update     :=p_reason_for_update,
    lineage               :=p_lineage,
    schema_name           :=p_schema_name
);
PERFORM citydb_pkg.nrg8_insert_storage_system(
    id                      :=inserted_id,
    objectclass_id          :=objectclass_id,
    start_of_life           :=p_start_of_life,
    life_expect_value       :=p_life_expect_value,
    life_expect_value_unit  :=p_life_expect_value_unit,
    main_maint_interval     :=p_main_maint_interval,
    main_maint_interval_unit:=p_main_maint_interval_unit,
    nrg_demand_id           :=p_nrg_demand_id,
    cityobject_id           :=p_cityobject_id,
    schema_name             :=p_schema_name
);
PERFORM citydb_pkg.nrg8_insert_power_storage_system(
    id               :=inserted_id,
    objectclass_id   :=objectclass_id,
    battery_techn    :=p_battery_techn,
    pwr_capacity     :=p_pwr_capacity,
    pwr_capacity_unit:=p_pwr_capacity_unit,
    schema_name      :=p_schema_name
);
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_insert_power_storage_system(): %', SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function INSERT_THERMAL_STORAGE_SYSTEM (CityObject)
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.nrg8_insert_thermal_storage_system(
  id                     integer DEFAULT NULL,
  gmlid                  varchar(256) DEFAULT NULL,
  gmlid_codespace        varchar(1000) DEFAULT NULL,
  name                   varchar(1000) DEFAULT NULL,
  name_codespace         varchar(4000) DEFAULT NULL,
  description            varchar(4000) DEFAULT NULL,
  envelope               geometry DEFAULT NULL,
  creation_date          timestamp(0) with time zone DEFAULT NULL,
  termination_date       timestamp(0) with time zone DEFAULT NULL,
  relative_to_terrain    varchar(256) DEFAULT NULL,
  relative_to_water      varchar(256) DEFAULT NULL,
  last_modification_date timestamp with time zone DEFAULT NULL,
  updating_person        varchar(256) DEFAULT NULL,
  reason_for_update      varchar(4000) DEFAULT NULL,
  lineage                varchar(256) DEFAULT NULL,
--
  start_of_life            date DEFAULT NULL,
  life_expect_value        numeric DEFAULT NULL,
  life_expect_value_unit   character varying DEFAULT NULL,
  main_maint_interval      numeric DEFAULT NULL,
  main_maint_interval_unit character varying DEFAULT NULL,
  nrg_demand_id            integer DEFAULT NULL,
  cityobject_id            integer DEFAULT NULL,
--
  medium               character varying DEFAULT NULL,
  vol                  numeric DEFAULT NULL,
  vol_unit             character varying DEFAULT NULL,
  prep_temp            numeric DEFAULT NULL,
  prep_temp_unit       character varying DEFAULT NULL,
  therm_loss           numeric DEFAULT NULL,
  therm_loss_unit      character varying DEFAULT NULL,
--
  schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
  p_id                     integer                     := id                    ;
  p_gmlid                  varchar(256)                := gmlid                 ;
  p_gmlid_codespace        varchar(1000)               := gmlid_codespace       ;
  p_name                   varchar(1000)               := name                  ;
  p_name_codespace         varchar(4000)               := name_codespace        ;
  p_description            varchar(4000)               := description           ;
  p_envelope               geometry                    := envelope              ;
  p_creation_date          timestamp(0) with time zone := creation_date         ;
  p_termination_date       timestamp(0) with time zone := termination_date      ;
  p_relative_to_terrain    varchar(256)                := relative_to_terrain   ;
  p_relative_to_water      varchar(256)                := relative_to_water     ;
  p_last_modification_date timestamp with time zone    := last_modification_date;
  p_updating_person        varchar(256)                := updating_person       ;
  p_reason_for_update      varchar(4000)               := reason_for_update     ;
  p_lineage                varchar(256)                := lineage               ;
--
  p_start_of_life            date              := start_of_life;
  p_life_expect_value        numeric           := life_expect_value;
  p_life_expect_value_unit   character varying := life_expect_value_unit;
  p_main_maint_interval      numeric           := main_maint_interval;
  p_main_maint_interval_unit character varying := main_maint_interval_unit;
  p_nrg_demand_id            integer           := nrg_demand_id;
  p_cityobject_id            integer           := cityobject_id;
--
  p_medium             character varying := medium;
  p_vol                numeric           := vol;
  p_vol_unit           character varying := vol_unit;
  p_prep_temp          numeric           := prep_temp;
  p_prep_temp_unit     character varying := prep_temp_unit;
  p_therm_loss         numeric           := therm_loss;
  p_therm_loss_unit    character varying := therm_loss_unit;
--
  p_schema_name varchar := schema_name;
	class_name varchar DEFAULT 'ThermalStorageSystem'::varchar;
	db_prefix varchar DEFAULT 'nrg8';
	objectclass_id integer;
	inserted_id integer;
BEGIN
objectclass_id=citydb_pkg.objectclass_classname_to_id(class_name, db_prefix, p_schema_name);

inserted_id=citydb_pkg.insert_cityobject(
    id                    :=p_id,
    objectclass_id        :=objectclass_id,
    gmlid                 :=p_gmlid,
    gmlid_codespace       :=p_gmlid_codespace,
    name                  :=p_name,
    name_codespace        :=p_name_codespace,
    description           :=p_description,
    envelope              :=p_envelope,
    creation_date         :=p_creation_date,
    termination_date      :=p_termination_date,
    relative_to_terrain   :=p_relative_to_terrain,
    relative_to_water     :=p_relative_to_water,
    last_modification_date:=p_last_modification_date,
    updating_person       :=p_updating_person,
    reason_for_update     :=p_reason_for_update,
    lineage               :=p_lineage,
    schema_name           :=p_schema_name
);
PERFORM citydb_pkg.nrg8_insert_storage_system(
    id                      :=inserted_id,
    objectclass_id          :=objectclass_id,
    start_of_life           :=p_start_of_life,
    life_expect_value       :=p_life_expect_value,
    life_expect_value_unit  :=p_life_expect_value_unit,
    main_maint_interval     :=p_main_maint_interval,
    main_maint_interval_unit:=p_main_maint_interval_unit,
    nrg_demand_id           :=p_nrg_demand_id,
    cityobject_id           :=p_cityobject_id,
    schema_name             :=p_schema_name
);
PERFORM citydb_pkg.nrg8_insert_thermal_storage_system(
    id               :=inserted_id,
    objectclass_id   :=objectclass_id,
    medium           :=p_medium,
    vol              :=p_vol,
    vol_unit         :=p_vol_unit,
    prep_temp        :=p_prep_temp,
    prep_temp_unit   :=p_prep_temp_unit,
    therm_loss       :=p_therm_loss,
    therm_loss_unit  :=p_therm_loss_unit,
    schema_name      :=p_schema_name
);
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_insert_thermal_storage_system(): %', SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function INSERT_REFURBISHMENT_MEASURE (non CityObject)
----------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.nrg8_insert_refurbishment_measure(
  id                   integer DEFAULT NULL,
  description          text DEFAULT NULL,
  level                character varying DEFAULT NULL,
  instant_date         date DEFAULT NULL,
  begin_date           date DEFAULT NULL,
  end_date             date DEFAULT NULL,
  building_id          integer DEFAULT NULL,
  therm_boundary_id    integer DEFAULT NULL,
--
  schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
  p_id                 integer           := id;
  p_description        text              := description;
  p_level              character varying := level;
  p_instant_date       date              := instant_date;
  p_begin_date         date              := begin_date;
  p_end_date           date              := end_date;
  p_building_id        integer           := building_id;
  p_therm_boundary_id  integer           := therm_boundary_id;
--
  p_schema_name varchar := schema_name;
	inserted_id integer;
BEGIN
inserted_id=citydb_pkg.nrg8_insert_refurbishment_measure(
    id                   :=p_id,
    description          :=p_description,
    level                :=p_level,
    instant_date         :=p_instant_date,
    begin_date           :=p_begin_date,
    end_date             :=p_end_date,
    building_id          :=p_building_id,
    therm_boundary_id    :=p_therm_boundary_id,
    schema_name          :=p_schema_name
);
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_insert_refurbishment_measure(): %', SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function INSERT_CONSTANT_VALUE_SCHEDULE (non CityObject)
----------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.nrg8_insert_constant_value_schedule(
  id                   integer DEFAULT NULL,
  gmlid                character varying DEFAULT NULL,
  gmlid_codespace      character varying DEFAULT NULL,
  name                 character varying DEFAULT NULL,
  name_codespace       character varying DEFAULT NULL,
  description          text DEFAULT NULL,
  average_value        numeric DEFAULT NULL,
  average_value_unit   varchar DEFAULT NULL,
--
  schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
  p_id                 integer           := id                ;
  p_gmlid              character varying := gmlid             ;
  p_gmlid_codespace    character varying := gmlid_codespace   ;
  p_name               character varying := name              ;
  p_name_codespace     character varying := name_codespace    ;
  p_description        text              := description       ;
  p_average_value      numeric           := average_value     ;
  p_average_value_unit character varying := average_value_unit;
--
  p_schema_name varchar := schema_name;
	class_name varchar DEFAULT 'ConstantValueSchedule'::varchar;
	db_prefix varchar DEFAULT 'nrg8'::varchar;
	objectclass_id integer;
	inserted_id integer;
BEGIN
objectclass_id=citydb_pkg.objectclass_classname_to_id(class_name, db_prefix, p_schema_name);

inserted_id=citydb_pkg.nrg8_insert_schedule(
    id                   :=p_id,
    objectclass_id       :=objectclass_id,
    gmlid                :=p_gmlid,
    gmlid_codespace      :=p_gmlid_codespace,
    name                 :=p_name,
    name_codespace       :=p_name_codespace,
    description          :=p_description,
    value1               :=p_average_value,
    value1_unit          :=p_average_value_unit,
    schema_name          :=p_schema_name
);
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_insert_constant_value_schedule(): %', SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function INSERT_DUAL_VALUE_SCHEDULE (non CityObject)
----------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.nrg8_insert_dual_value_schedule(
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
--
  schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
  p_id                 integer            :=id             ;
  p_gmlid              character varying  :=gmlid          ;
  p_gmlid_codespace    character varying  :=gmlid_codespace;
  p_name               character varying  :=name           ;
  p_name_codespace     character varying  :=name_codespace ;
  p_description        text               :=description    ;
  p_value1             numeric            :=value1         ;
  p_value1_unit        character varying  :=value1_unit    ;
  p_value2             numeric            :=value2         ;
  p_value2_unit        character varying  :=value2_unit    ;
  p_hours_per_day      numeric            :=hours_per_day  ;
  p_days_per_year      numeric            :=days_per_year  ;
--
  p_schema_name varchar := schema_name;
	class_name varchar DEFAULT 'DualValueSchedule'::varchar;
	db_prefix varchar DEFAULT 'nrg8'::varchar;
	objectclass_id integer;
	inserted_id integer;
BEGIN
objectclass_id=citydb_pkg.objectclass_classname_to_id(class_name, db_prefix, p_schema_name);

inserted_id=citydb_pkg.nrg8_insert_schedule(
    id                   :=p_id,
    objectclass_id       :=objectclass_id,
    gmlid                :=p_gmlid,
    gmlid_codespace      :=p_gmlid_codespace,
    name                 :=p_name,
    name_codespace       :=p_name_codespace,
    description          :=p_description,
    value1               :=p_idle_value,
    value1_unit          :=p_idle_value_unit,
    value2               :=p_usage_value,
    value2_unit          :=p_usage_value_unit,
    schema_name          :=p_schema_name
);
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_insert_dual_value_schedule(): %', SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function INSERT_DAILY_PATTERN_SCHEDULE (non CityObject)
----------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.nrg8_insert_daily_pattern_schedule(
  id                   integer DEFAULT NULL,
  gmlid                character varying DEFAULT NULL,
  gmlid_codespace      character varying DEFAULT NULL,
  name                 character varying DEFAULT NULL,
  name_codespace       character varying DEFAULT NULL,
  description          text DEFAULT NULL,
--
  schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
  p_id                 integer            :=id             ;
  p_gmlid              character varying  :=gmlid          ;
  p_gmlid_codespace    character varying  :=gmlid_codespace;
  p_name               character varying  :=name           ;
  p_name_codespace     character varying  :=name_codespace ;
  p_description        text               :=description    ;
--
  p_schema_name varchar := schema_name;
	class_name varchar DEFAULT 'DailyPatternSchedule'::varchar;
	db_prefix varchar DEFAULT 'nrg8'::varchar;
	objectclass_id integer;
	inserted_id integer;
BEGIN
objectclass_id=citydb_pkg.objectclass_classname_to_id(class_name, db_prefix, p_schema_name);

inserted_id=citydb_pkg.nrg8_insert_schedule(
    id                   :=p_id,
    objectclass_id       :=objectclass_id,
    gmlid                :=p_gmlid,
    gmlid_codespace      :=p_gmlid_codespace,
    name                 :=p_name,
    name_codespace       :=p_name_codespace,
    description          :=p_description,
    schema_name          :=p_schema_name
);
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_insert_daily_pattern_schedule(): %', SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function INSERT_TIME_SERIES_SCHEDULE (non CityObject)
----------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.nrg8_insert_time_series_schedule(
  id                   integer DEFAULT NULL,
  gmlid                character varying DEFAULT NULL,
  gmlid_codespace      character varying DEFAULT NULL,
  name                 character varying DEFAULT NULL,
  name_codespace       character varying DEFAULT NULL,
  description          text DEFAULT NULL,
  time_series_id       integer DEFAULT NULL,
--
  schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
  p_id                 integer            :=id             ;
  p_gmlid              character varying  :=gmlid          ;
  p_gmlid_codespace    character varying  :=gmlid_codespace;
  p_name               character varying  :=name           ;
  p_name_codespace     character varying  :=name_codespace ;
  p_description        text               :=description    ;
  p_time_series_id     integer            :=time_series_id ;
--
  p_schema_name varchar := schema_name;
	class_name varchar DEFAULT 'TimeSeriesSchedule'::varchar;
	db_prefix varchar DEFAULT 'nrg8'::varchar;
	objectclass_id integer;
	inserted_id integer;
BEGIN
objectclass_id=citydb_pkg.objectclass_classname_to_id(class_name, db_prefix, p_schema_name);

inserted_id=citydb_pkg.nrg8_insert_schedule(
    id                   :=p_id,
    objectclass_id       :=objectclass_id,
    gmlid                :=p_gmlid,
    gmlid_codespace      :=p_gmlid_codespace,
    name                 :=p_name,
    name_codespace       :=p_name_codespace,
    description          :=p_description,
    time_series_id       :=p_time_series_id,
    schema_name          :=p_schema_name
);
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_insert_time_series_schedule(): %', SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function INSERT_SYSTEM_OPERATION (non CityObject)
----------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.nrg8_insert_system_operation(
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
--
  schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
  p_id                 integer           := id                 ;
  p_gmlid              character varying := gmlid              ;
  p_gmlid_codespace    character varying := gmlid_codespace    ;
  p_name               character varying := name               ;
  p_name_codespace     character varying := name_codespace     ;
  p_description        text              := description        ;
  p_end_use            character varying := end_use            ;
  p_yearly_global_effcy numeric          := yearly_global_effcy;
  p_sched_id           integer           := sched_id           ;
  p_nrg_conv_system_id integer           := nrg_conv_system_id ;
--
  p_schema_name varchar := schema_name;
	class_name varchar DEFAULT 'SystemOperation'::varchar;
	db_prefix varchar DEFAULT 'nrg8'::varchar;
	objectclass_id integer;
	inserted_id integer;
BEGIN
objectclass_id=citydb_pkg.objectclass_classname_to_id(class_name, db_prefix, p_schema_name);

inserted_id=citydb_pkg.nrg8_insert_system_operation(
    id                   :=p_id,
    objectclass_id       :=objectclass_id,
    gmlid                :=p_gmlid,
    gmlid_codespace      :=p_gmlid_codespace,
    name                 :=p_name,
    name_codespace       :=p_name_codespace,
    description          :=p_description,
    end_use              :=p_end_use,
    yearly_global_effcy  :=p_yearly_global_effcy,
    sched_id             :=p_sched_id,
    nrg_conv_system_id   :=p_nrg_conv_system_id,
    schema_name          :=p_schema_name
);
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_insert_system_operation(): %', SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function INSERT_THERMAL_BOUNDARY (CityObject)
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.nrg8_insert_thermal_boundary(
  id                     integer DEFAULT NULL,
  gmlid                  varchar(256) DEFAULT NULL,
  gmlid_codespace        varchar(1000) DEFAULT NULL,
  name                   varchar(1000) DEFAULT NULL,
  name_codespace         varchar(4000) DEFAULT NULL,
  description            varchar(4000) DEFAULT NULL,
  envelope               geometry DEFAULT NULL,
  creation_date          timestamp(0) with time zone DEFAULT NULL,
  termination_date       timestamp(0) with time zone DEFAULT NULL,
  relative_to_terrain    varchar(256) DEFAULT NULL,
  relative_to_water      varchar(256) DEFAULT NULL,
  last_modification_date timestamp with time zone DEFAULT NULL,
  updating_person        varchar(256) DEFAULT NULL,
  reason_for_update      varchar(4000) DEFAULT NULL,
  lineage                varchar(256) DEFAULT NULL,
--
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
--
  schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
  p_id                     integer                     := id                    ;
  p_gmlid                  varchar(256)                := gmlid                 ;
  p_gmlid_codespace        varchar(1000)               := gmlid_codespace       ;
  p_name                   varchar(1000)               := name                  ;
  p_name_codespace         varchar(4000)               := name_codespace        ;
  p_description            varchar(4000)               := description           ;
  p_envelope               geometry                    := envelope              ;
  p_creation_date          timestamp(0) with time zone := creation_date         ;
  p_termination_date       timestamp(0) with time zone := termination_date      ;
  p_relative_to_terrain    varchar(256)                := relative_to_terrain   ;
  p_relative_to_water      varchar(256)                := relative_to_water     ;
  p_last_modification_date timestamp with time zone    := last_modification_date;
  p_updating_person        varchar(256)                := updating_person       ;
  p_reason_for_update      varchar(4000)               := reason_for_update     ;
  p_lineage                varchar(256)                := lineage               ;
--
  p_type               character varying := type            ;
  p_azimuth            numeric           := azimuth         ;
  p_azimuth_unit       character varying := azimuth_unit    ;
  p_inclination        numeric           := inclination     ;
  p_inclination_unit   character varying := inclination_unit;
  p_area               numeric           := area            ;
  p_area_unit          character varying := area_unit       ;
  p_therm_zone1_id     integer           := therm_zone1_id  ;
  p_therm_zone2_id     integer           := therm_zone2_id  ;
  p_multi_surf_id      integer           := multi_surf_id   ;
  p_multi_surf_geom    geometry          := multi_surf_geom ;
--
  p_schema_name varchar := schema_name;
	class_name varchar DEFAULT 'ThermalBoundary'::varchar;
	db_prefix varchar DEFAULT 'nrg8';
	objectclass_id integer;
	inserted_id integer;
BEGIN
objectclass_id=citydb_pkg.objectclass_classname_to_id(class_name, db_prefix, p_schema_name);

inserted_id=citydb_pkg.insert_cityobject(
    id                    :=p_id,
    objectclass_id        :=objectclass_id,
    gmlid                 :=p_gmlid,
    gmlid_codespace       :=p_gmlid_codespace,
    name                  :=p_name,
    name_codespace        :=p_name_codespace,
    description           :=p_description,
    envelope              :=p_envelope,
    creation_date         :=p_creation_date,
    termination_date      :=p_termination_date,
    relative_to_terrain   :=p_relative_to_terrain,
    relative_to_water     :=p_relative_to_water,
    last_modification_date:=p_last_modification_date,
    updating_person       :=p_updating_person,
    reason_for_update     :=p_reason_for_update,
    lineage               :=p_lineage,
    schema_name           :=p_schema_name
);
PERFORM citydb_pkg.nrg8_insert_thermal_boundary(
    id              :=inserted_id,
    objectclass_id  :=objectclass_id,
    type            :=p_type,
    azimuth         :=p_azimuth,
    azimuth_unit    :=p_azimuth_unit,
    inclination     :=p_inclination,
    inclination_unit:=p_inclination_unit,
    area            :=p_area,
    area_unit       :=p_area_unit,
    therm_zone1_id  :=p_therm_zone1_id,
    therm_zone2_id  :=p_therm_zone2_id,
    multi_surf_id   :=p_multi_surf_id,
    multi_surf_geom :=p_multi_surf_geom,
    schema_name     :=p_schema_name
);
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_insert_thermal_boundary(): %', SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function INSERT_THERMAL_OPENING (CityObject)
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.nrg8_insert_thermal_opening(
  id                     integer DEFAULT NULL,
  gmlid                  varchar(256) DEFAULT NULL,
  gmlid_codespace        varchar(1000) DEFAULT NULL,
  name                   varchar(1000) DEFAULT NULL,
  name_codespace         varchar(4000) DEFAULT NULL,
  description            varchar(4000) DEFAULT NULL,
  envelope               geometry DEFAULT NULL,
  creation_date          timestamp(0) with time zone DEFAULT NULL,
  termination_date       timestamp(0) with time zone DEFAULT NULL,
  relative_to_terrain    varchar(256) DEFAULT NULL,
  relative_to_water      varchar(256) DEFAULT NULL,
  last_modification_date timestamp with time zone DEFAULT NULL,
  updating_person        varchar(256) DEFAULT NULL,
  reason_for_update      varchar(4000) DEFAULT NULL,
  lineage                varchar(256) DEFAULT NULL,
--
  area                         numeric DEFAULT NULL,
  area_unit                    character varying DEFAULT NULL,
  openable_ratio               numeric DEFAULT NULL,
  in_shad_name                 character varying DEFAULT NULL,
  in_shad_max_cover_ratio      numeric DEFAULT NULL,
  in_shad_transmission         numeric DEFAULT NULL,
  in_shad_transmission_range   character varying DEFAULT NULL,
  out_shad_name                character varying DEFAULT NULL,
  out_shad_max_cover_ratio     numeric DEFAULT NULL,
  out_shad_transmittance       numeric DEFAULT NULL,
  out_shad_transmittance_range character varying DEFAULT NULL,
  therm_boundary_id            integer DEFAULT NULL,
  multi_surf_id                integer DEFAULT NULL,
  multi_surf_geom              geometry DEFAULT NULL,
--
  schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
  p_id                     integer                     := id                    ;
  p_gmlid                  varchar(256)                := gmlid                 ;
  p_gmlid_codespace        varchar(1000)               := gmlid_codespace       ;
  p_name                   varchar(1000)               := name                  ;
  p_name_codespace         varchar(4000)               := name_codespace        ;
  p_description            varchar(4000)               := description           ;
  p_envelope               geometry                    := envelope              ;
  p_creation_date          timestamp(0) with time zone := creation_date         ;
  p_termination_date       timestamp(0) with time zone := termination_date      ;
  p_relative_to_terrain    varchar(256)                := relative_to_terrain   ;
  p_relative_to_water      varchar(256)                := relative_to_water     ;
  p_last_modification_date timestamp with time zone    := last_modification_date;
  p_updating_person        varchar(256)                := updating_person       ;
  p_reason_for_update      varchar(4000)               := reason_for_update     ;
  p_lineage                varchar(256)                := lineage               ;
--
  p_area                         numeric           := area                        ;
  p_area_unit                    character varying := area_unit                   ;
  p_openable_ratio               numeric           := openable_ratio              ;
  p_in_shad_name                 character varying := in_shad_name                ;
  p_in_shad_max_cover_ratio      numeric           := in_shad_max_cover_ratio     ;
  p_in_shad_transmission         numeric           := in_shad_transmission        ;
  p_in_shad_transmission_range   character varying := in_shad_transmission_range  ;
  p_out_shad_name                character varying := out_shad_name               ;
  p_out_shad_max_cover_ratio     numeric           := out_shad_max_cover_ratio    ;
  p_out_shad_transmittance       numeric           := out_shad_transmittance      ;
  p_out_shad_transmittance_range character varying := out_shad_transmittance_range;
  p_therm_boundary_id            integer           := therm_boundary_id           ;
  p_multi_surf_id                integer           := multi_surf_id               ;
  p_multi_surf_geom              geometry          := multi_surf_geom             ;
--
  p_schema_name varchar := schema_name;
	class_name varchar DEFAULT 'ThermalOpening'::varchar;
	db_prefix varchar DEFAULT 'nrg8';
	objectclass_id integer;
	inserted_id integer;
BEGIN
objectclass_id=citydb_pkg.objectclass_classname_to_id(class_name, db_prefix, p_schema_name);

inserted_id=citydb_pkg.insert_cityobject(
    id                    :=p_id,
    objectclass_id        :=objectclass_id,
    gmlid                 :=p_gmlid,
    gmlid_codespace       :=p_gmlid_codespace,
    name                  :=p_name,
    name_codespace        :=p_name_codespace,
    description           :=p_description,
    envelope              :=p_envelope,
    creation_date         :=p_creation_date,
    termination_date      :=p_termination_date,
    relative_to_terrain   :=p_relative_to_terrain,
    relative_to_water     :=p_relative_to_water,
    last_modification_date:=p_last_modification_date,
    updating_person       :=p_updating_person,
    reason_for_update     :=p_reason_for_update,
    lineage               :=p_lineage,
    schema_name           :=p_schema_name
);
PERFORM citydb_pkg.nrg8_insert_thermal_opening(
    id                          :=inserted_id,
    objectclass_id              :=objectclass_id,
    area                        :=p_area,
    area_unit                   :=p_area_unit,
    openable_ratio              :=p_openable_ratio,
    in_shad_name                :=p_in_shad_name,
    in_shad_max_cover_ratio     :=p_in_shad_max_cover_ratio,
    in_shad_transmission        :=p_in_shad_transmission,
    in_shad_transmission_range  :=p_in_shad_transmission_range,
    out_shad_name               :=p_out_shad_name,
    out_shad_max_cover_ratio    :=p_out_shad_max_cover_ratio,
    out_shad_transmittance      :=p_out_shad_transmittance,
    out_shad_transmittance_range:=p_out_shad_transmittance_range,
    therm_boundary_id           :=p_therm_boundary_id,
    multi_surf_id               :=p_multi_surf_id,
    multi_surf_geom             :=p_multi_surf_geom,
    schema_name                 :=p_schema_name
);
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_insert_thermal_opening(): %', SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function INSERT_THERMAL_ZONE (CityObject)
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.nrg8_insert_thermal_zone(
  id                     integer DEFAULT NULL,
  gmlid                  varchar(256) DEFAULT NULL,
  gmlid_codespace        varchar(1000) DEFAULT NULL,
  name                   varchar(1000) DEFAULT NULL,
  name_codespace         varchar(4000) DEFAULT NULL,
  description            varchar(4000) DEFAULT NULL,
  envelope               geometry DEFAULT NULL,
  creation_date          timestamp(0) with time zone DEFAULT NULL,
  termination_date       timestamp(0) with time zone DEFAULT NULL,
  relative_to_terrain    varchar(256) DEFAULT NULL,
  relative_to_water      varchar(256) DEFAULT NULL,
  last_modification_date timestamp with time zone DEFAULT NULL,
  updating_person        varchar(256) DEFAULT NULL,
  reason_for_update      varchar(4000) DEFAULT NULL,
  lineage                varchar(256) DEFAULT NULL,
--
  add_therm_bridge_uvalue      numeric DEFAULT NULL,
  add_therm_bridge_uvalue_unit character varying DEFAULT NULL,
  eff_therm_capacity           numeric DEFAULT NULL,
  eff_therm_capacity_unit      character varying DEFAULT NULL,
  ind_heated_area_ratio        numeric DEFAULT NULL,
  infiltr_rate                 numeric DEFAULT NULL,
  infiltr_rate_unit            character varying DEFAULT NULL,
  is_cooled                    numeric DEFAULT NULL,
  is_heated                    numeric DEFAULT NULL,
  building_id                  integer DEFAULT NULL,
  solid_id                     integer DEFAULT NULL,
  multi_surf_geom              geometry DEFAULT NULL,
--
  schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
  p_id                     integer                     := id                    ;
  p_gmlid                  varchar(256)                := gmlid                 ;
  p_gmlid_codespace        varchar(1000)               := gmlid_codespace       ;
  p_name                   varchar(1000)               := name                  ;
  p_name_codespace         varchar(4000)               := name_codespace        ;
  p_description            varchar(4000)               := description           ;
  p_envelope               geometry                    := envelope              ;
  p_creation_date          timestamp(0) with time zone := creation_date         ;
  p_termination_date       timestamp(0) with time zone := termination_date      ;
  p_relative_to_terrain    varchar(256)                := relative_to_terrain   ;
  p_relative_to_water      varchar(256)                := relative_to_water     ;
  p_last_modification_date timestamp with time zone    := last_modification_date;
  p_updating_person        varchar(256)                := updating_person       ;
  p_reason_for_update      varchar(4000)               := reason_for_update     ;
  p_lineage                varchar(256)                := lineage               ;
--
  p_add_therm_bridge_uvalue      numeric           := add_therm_bridge_uvalue     ;
  p_add_therm_bridge_uvalue_unit character varying := add_therm_bridge_uvalue_unit;
  p_eff_therm_capacity           numeric           := eff_therm_capacity          ;
  p_eff_therm_capacity_unit      character varying := eff_therm_capacity_unit     ;
  p_ind_heated_area_ratio        numeric           := ind_heated_area_ratio       ;
  p_infiltr_rate                 numeric           := infiltr_rate                ;
  p_infiltr_rate_unit            character varying := infiltr_rate_unit           ;
  p_is_cooled                    numeric           := is_cooled                   ;
  p_is_heated                    numeric           := is_heated                   ;
  p_building_id                  integer           := building_id                 ;
  p_solid_id                     integer           := solid_id                    ;
  p_multi_surf_geom              geometry          := multi_surf_geom             ;
--
  p_schema_name varchar := schema_name;
	class_name varchar DEFAULT 'ThermalZone'::varchar;
	db_prefix varchar DEFAULT 'nrg8';
	objectclass_id integer;
	inserted_id integer;
BEGIN
objectclass_id=citydb_pkg.objectclass_classname_to_id(class_name, db_prefix, p_schema_name);

inserted_id=citydb_pkg.insert_cityobject(
    id                    :=p_id,
    objectclass_id        :=objectclass_id,
    gmlid                 :=p_gmlid,
    gmlid_codespace       :=p_gmlid_codespace,
    name                  :=p_name,
    name_codespace        :=p_name_codespace,
    description           :=p_description,
    envelope              :=p_envelope,
    creation_date         :=p_creation_date,
    termination_date      :=p_termination_date,
    relative_to_terrain   :=p_relative_to_terrain,
    relative_to_water     :=p_relative_to_water,
    last_modification_date:=p_last_modification_date,
    updating_person       :=p_updating_person,
    reason_for_update     :=p_reason_for_update,
    lineage               :=p_lineage,
    schema_name           :=p_schema_name
);
PERFORM citydb_pkg.nrg8_insert_thermal_zone(
    id                          :=inserted_id,
    objectclass_id              :=objectclass_id,
    add_therm_bridge_uvalue     :=p_add_therm_bridge_uvalue,
    add_therm_bridge_uvalue_unit:=p_add_therm_bridge_uvalue_unit,
    eff_therm_capacity          :=p_eff_therm_capacity,
    eff_therm_capacity_unit     :=p_eff_therm_capacity_unit,
    ind_heated_area_ratio       :=p_ind_heated_area_ratio,
    infiltr_rate                :=p_infiltr_rate,
    infiltr_rate_unit           :=p_infiltr_rate_unit,
    is_cooled                   :=p_is_cooled,
    is_heated                   :=p_is_heated,
    building_id                 :=p_building_id,
    solid_id                    :=p_solid_id,
    multi_surf_geom             :=p_multi_surf_geom,
    schema_name                 :=p_schema_name
);
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_insert_thermal_zone(): %', SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function INSERT_REGULAR_TIME_SERIES
----------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.nrg8_insert_regular_time_series(
  id integer DEFAULT NULL,
  gmlid varchar DEFAULT NULL,
  gmlid_codespace varchar DEFAULT NULL,
  name varchar DEFAULT NULL,
  name_codespace varchar DEFAULT NULL,
  description text DEFAULT NULL,
  acquisition_method varchar DEFAULT NULL,
  interpolation_type varchar DEFAULT NULL,
  quality_description text DEFAULT NULL,
  source varchar DEFAULT NULL,
  values_array numeric[] DEFAULT NULL,
  values_unit varchar DEFAULT NULL,
  array_length integer DEFAULT NULL,
  temporal_extent_begin timestamp with time zone DEFAULT NULL,
  temporal_extent_end timestamp with time zone DEFAULT NULL,
  time_interval numeric DEFAULT NULL,
  time_interval_unit varchar DEFAULT NULL,
  --
  schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
  p_id                    integer                  := id                   ;
  p_gmlid                 varchar                  := gmlid                ;
  p_gmlid_codespace       varchar                  := gmlid_codespace      ;
  p_name                  varchar                  := name                 ;
  p_name_codespace        varchar                  := name_codespace       ;
  p_description           text                     := description          ;
  p_acquisition_method    varchar                  := acquisition_method   ;
  p_interpolation_type    varchar                  := interpolation_type   ;
  p_quality_description   text                     := quality_description  ;
  p_source                varchar                  := source               ;
  p_values_array          numeric[]                := values_array         ;
  p_values_unit           varchar                  := values_unit          ;
  p_array_length          integer                  := array_length         ;
  p_temporal_extent_begin timestamp with time zone := temporal_extent_begin;
  p_temporal_extent_end   timestamp with time zone := temporal_extent_end  ;
  p_time_interval         numeric                  := time_interval        ;
  p_time_interval_unit    varchar                  := time_interval_unit   ;
--
  p_schema_name varchar := schema_name;
  class_name varchar DEFAULT 'RegularTimeSeries'::varchar;
  db_prefix varchar DEFAULT 'nrg8'::varchar;
  objectclass_id integer;
  inserted_id integer;
BEGIN
objectclass_id=citydb_pkg.objectclass_classname_to_id(class_name, db_prefix, p_schema_name);

inserted_id=citydb_pkg.nrg8_insert_time_series(
    id                   :=p_id,
    objectclass_id       :=objectclass_id,
    gmlid                :=p_gmlid,
    gmlid_codespace      :=p_gmlid_codespace,
    name                 :=p_name,
    name_codespace       :=p_name_codespace,
    description          :=p_description,
    acquisition_method   :=p_acquisition_method,
    interpolation_type   :=p_interpolation_type,
    quality_description  :=p_quality_description,
    source               :=p_source,
    values_array         :=p_values_array,
    values_unit          :=p_values_unit,
    array_length         :=p_array_length,
    temporal_extent_begin:=p_temporal_extent_begin,
    temporal_extent_end  :=p_temporal_extent_end,
    time_interval        :=p_time_interval,
    time_interval_unit   :=p_time_interval_unit,
    schema_name          :=p_schema_name
);
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_insert_regular_time_series(): %', SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function INSERT_IRREGULAR_TIME_SERIES
----------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.nrg8_insert_irregular_time_series(
id integer DEFAULT NULL,
gmlid varchar DEFAULT NULL,
gmlid_codespace varchar DEFAULT NULL,
name varchar DEFAULT NULL,
name_codespace varchar DEFAULT NULL,
description text DEFAULT NULL,
acquisition_method varchar DEFAULT NULL,
interpolation_type varchar DEFAULT NULL,
quality_description text DEFAULT NULL,
source varchar DEFAULT NULL,
time_array numeric[] DEFAULT NULL,
values_array numeric[] DEFAULT NULL,
values_unit varchar DEFAULT NULL,
array_length integer DEFAULT NULL,

schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
  p_id                    integer                  := id                   ;
  p_gmlid                 varchar                  := gmlid                ;
  p_gmlid_codespace       varchar                  := gmlid_codespace      ;
  p_name                  varchar                  := name                 ;
  p_name_codespace        varchar                  := name_codespace       ;
  p_description           text                     := description          ;
  p_acquisition_method    varchar                  := acquisition_method   ;
  p_interpolation_type    varchar                  := interpolation_type   ;
  p_quality_description   text                     := quality_description  ;
  p_source                varchar                  := source               ;
  p_time_array            numeric[]                := time_array           ;
  p_values_array          numeric[]                := values_array         ;
  p_values_unit           varchar                  := values_unit          ;
  p_array_length          integer                  := array_length         ;
--
  p_schema_name varchar := schema_name;
  class_name varchar DEFAULT 'IrregularTimeSeries'::varchar;
  db_prefix varchar DEFAULT 'nrg8'::varchar;
  objectclass_id integer;
  inserted_id integer;
BEGIN
objectclass_id=citydb_pkg.objectclass_classname_to_id(class_name, db_prefix, p_schema_name);

inserted_id=citydb_pkg.nrg8_insert_time_series(
    id                   :=p_id,
    objectclass_id       :=objectclass_id,
    gmlid                :=p_gmlid,
    gmlid_codespace      :=p_gmlid_codespace,
    name                 :=p_name,
    name_codespace       :=p_name_codespace,
    description          :=p_description,
    acquisition_method   :=p_acquisition_method,
    interpolation_type   :=p_interpolation_type,
    quality_description  :=p_quality_description,
    source               :=p_source,
    time_array           :=p_time_array,
    values_array         :=p_values_array,
    values_unit          :=p_values_unit,
    array_length         :=p_array_length,
    schema_name          :=p_schema_name
);
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_insert_irregular_time_series(): %', SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function INSERT_TIME_REGULAR_SERIES_FILE
----------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.nrg8_insert_regular_time_series_file(
id integer DEFAULT NULL,
gmlid varchar DEFAULT NULL,
gmlid_codespace varchar DEFAULT NULL,
name varchar DEFAULT NULL,
name_codespace varchar DEFAULT NULL,
description text DEFAULT NULL,
acquisition_method varchar DEFAULT NULL,
interpolation_type varchar DEFAULT NULL,
quality_description text DEFAULT NULL,
source varchar DEFAULT NULL,
values_unit varchar DEFAULT NULL,
temporal_extent_begin timestamp with time zone DEFAULT NULL,
temporal_extent_end timestamp with time zone DEFAULT NULL,
time_interval numeric DEFAULT NULL,
time_interval_unit varchar DEFAULT NULL,
--
file_path varchar DEFAULT NULL,
file_name varchar DEFAULT NULL,
file_extension varchar DEFAULT NULL,
nbr_header_lines integer DEFAULT NULL,
field_sep varchar DEFAULT NULL,
record_sep varchar DEFAULT NULL,
dec_symbol varchar DEFAULT NULL,
value_col_nbr integer DEFAULT NULL,
is_compressed numeric(1) DEFAULT NULL,
--
schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
  p_id                    integer                  := id                   ;
  p_gmlid                 varchar                  := gmlid                ;
  p_gmlid_codespace       varchar                  := gmlid_codespace      ;
  p_name                  varchar                  := name                 ;
  p_name_codespace        varchar                  := name_codespace       ;
  p_description           text                     := description          ;
  p_acquisition_method    varchar                  := acquisition_method   ;
  p_interpolation_type    varchar                  := interpolation_type   ;
  p_quality_description   text                     := quality_description  ;
  p_source                varchar                  := source               ;
  p_values_unit           varchar                  := values_unit          ;
  p_temporal_extent_begin timestamp with time zone := temporal_extent_begin;
  p_temporal_extent_end   timestamp with time zone := temporal_extent_end  ;
  p_time_interval         numeric                  := time_interval        ;
  p_time_interval_unit    varchar                  := time_interval_unit   ;
--
  p_file_path             varchar                  := file_path            ;
  p_file_name             varchar                  := file_name            ;
  p_file_extension        varchar                  := file_extension       ;
  p_nbr_header_lines      integer                  := nbr_header_lines     ;
  p_field_sep             varchar                  := field_sep            ;
  p_record_sep            varchar                  := record_sep           ;
  p_dec_symbol            varchar                  := dec_symbol           ;
  p_value_col_nbr         integer                  := value_col_nbr        ;
  p_is_compressed         numeric(1)               := is_compressed        ;
--
  p_schema_name varchar := schema_name;
  class_name varchar DEFAULT 'RegularTimeSeriesFile'::varchar;
  db_prefix varchar DEFAULT 'nrg8'::varchar;
  objectclass_id integer;
  inserted_id integer;
BEGIN
objectclass_id=citydb_pkg.objectclass_classname_to_id(class_name, db_prefix, p_schema_name);

inserted_id=citydb_pkg.nrg8_insert_time_series(
    id                   :=p_id,
    objectclass_id       :=objectclass_id,
    gmlid                :=p_gmlid,
    gmlid_codespace      :=p_gmlid_codespace,
    name                 :=p_name,
    name_codespace       :=p_name_codespace,
    description          :=p_description,
    acquisition_method   :=p_acquisition_method,
    interpolation_type   :=p_interpolation_type,
    quality_description  :=p_quality_description,
    source               :=p_source,
    values_unit          :=p_values_unit,
    temporal_extent_begin:=p_temporal_extent_begin,
    temporal_extent_end  :=p_temporal_extent_end,
    time_interval        :=p_time_interval,
    time_interval_unit   :=p_time_interval_unit,
    schema_name          :=p_schema_name
);
PERFORM citydb_pkg.nrg8_insert_time_series_file(
    id              :=inserted_id,
    objectclass_id  :=objectclass_id,
    file_path       :=p_file_path,
    file_name       :=p_file_name,
    file_extension  :=p_file_extension,
    nbr_header_lines:=p_nbr_header_lines,
    field_sep       :=p_field_sep,
    record_sep      :=p_record_sep,
    dec_symbol      :=p_dec_symbol,
    value_col_nbr   :=p_value_col_nbr,
    is_compressed   :=p_is_compressed,
    schema_name     :=p_schema_name
);
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_insert_regular_time_series_file(): %', SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function INSERT_IRREGULAR_TIME_SERIES_FILE
----------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.nrg8_insert_irregular_time_series_file(
id integer DEFAULT NULL,
gmlid varchar DEFAULT NULL,
gmlid_codespace varchar DEFAULT NULL,
name varchar DEFAULT NULL,
name_codespace varchar DEFAULT NULL,
description text DEFAULT NULL,
acquisition_method varchar DEFAULT NULL,
interpolation_type varchar DEFAULT NULL,
quality_description text DEFAULT NULL,
source varchar DEFAULT NULL,
values_unit varchar DEFAULT NULL,
--
file_path varchar DEFAULT NULL,
file_name varchar DEFAULT NULL,
file_extension varchar DEFAULT NULL,
nbr_header_lines integer DEFAULT NULL,
field_sep varchar DEFAULT NULL,
record_sep varchar DEFAULT NULL,
dec_symbol varchar DEFAULT NULL,
time_col_nbr integer DEFAULT NULL,
value_col_nbr integer DEFAULT NULL,
is_compressed numeric(1) DEFAULT NULL,
--
schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
  p_id                    integer                  := id                   ;
  p_gmlid                 varchar                  := gmlid                ;
  p_gmlid_codespace       varchar                  := gmlid_codespace      ;
  p_name                  varchar                  := name                 ;
  p_name_codespace        varchar                  := name_codespace       ;
  p_description           text                     := description          ;
  p_acquisition_method    varchar                  := acquisition_method   ;
  p_interpolation_type    varchar                  := interpolation_type   ;
  p_quality_description   text                     := quality_description  ;
  p_source                varchar                  := source               ;
  p_values_unit           varchar                  := values_unit          ;
--
  p_file_path             varchar                  := file_path            ;
  p_file_name             varchar                  := file_name            ;
  p_file_extension        varchar                  := file_extension       ;
  p_nbr_header_lines      integer                  := nbr_header_lines     ;
  p_field_sep             varchar                  := field_sep            ;
  p_record_sep            varchar                  := record_sep           ;
  p_dec_symbol            varchar                  := dec_symbol           ;
  p_time_col_nbr          integer                  := time_col_nbr         ;
  p_value_col_nbr         integer                  := value_col_nbr        ;
  p_is_compressed         numeric(1)               := is_compressed        ;
--
  p_schema_name varchar := schema_name;
  class_name varchar DEFAULT 'IrregularTimeSeriesFile'::varchar;
  db_prefix varchar DEFAULT 'nrg8'::varchar;
  objectclass_id integer;
  inserted_id integer;
BEGIN
objectclass_id=citydb_pkg.objectclass_classname_to_id(class_name, db_prefix, p_schema_name);

inserted_id=citydb_pkg.nrg8_insert_time_series(
    id                   :=p_id,
    objectclass_id       :=objectclass_id,
    gmlid                :=p_gmlid,
    gmlid_codespace      :=p_gmlid_codespace,
    name                 :=p_name,
    name_codespace       :=p_name_codespace,
    description          :=p_description,
    acquisition_method   :=p_acquisition_method,
    interpolation_type   :=p_interpolation_type,
    quality_description  :=p_quality_description,
    source               :=p_source,
    values_unit          :=p_values_unit,
    schema_name          :=p_schema_name
);
PERFORM citydb_pkg.nrg8_insert_time_series_file(
    id              :=inserted_id,
    objectclass_id  :=objectclass_id,
    file_path       :=p_file_path,
    file_name       :=p_file_name,
    file_extension  :=p_file_extension,
    nbr_header_lines:=p_nbr_header_lines,
    field_sep       :=p_field_sep,
    record_sep      :=p_record_sep,
    dec_symbol      :=p_dec_symbol,
    time_col_nbr    :=p_time_col_nbr,
    value_col_nbr   :=p_value_col_nbr,
    is_compressed   :=p_is_compressed,
    schema_name     :=p_schema_name
);
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_insert_irregular_time_series_file(): %', SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function INSERT_USAGE_ZONE (CityObject)
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.nrg8_insert_usage_zone(
  id                     integer DEFAULT NULL,
  gmlid                  varchar(256) DEFAULT NULL,
  gmlid_codespace        varchar(1000) DEFAULT NULL,
  name                   varchar(1000) DEFAULT NULL,
  name_codespace         varchar(4000) DEFAULT NULL,
  description            varchar(4000) DEFAULT NULL,
  envelope               geometry DEFAULT NULL,
  creation_date          timestamp(0) with time zone DEFAULT NULL,
  termination_date       timestamp(0) with time zone DEFAULT NULL,
  relative_to_terrain    varchar(256) DEFAULT NULL,
  relative_to_water      varchar(256) DEFAULT NULL,
  last_modification_date timestamp with time zone DEFAULT NULL,
  updating_person        varchar(256) DEFAULT NULL,
  reason_for_update      varchar(4000) DEFAULT NULL,
  lineage                varchar(256) DEFAULT NULL,
--
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
--
  schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
  p_id                     integer                     := id                    ;
  p_gmlid                  varchar(256)                := gmlid                 ;
  p_gmlid_codespace        varchar(1000)               := gmlid_codespace       ;
  p_name                   varchar(1000)               := name                  ;
  p_name_codespace         varchar(4000)               := name_codespace        ;
  p_description            varchar(4000)               := description           ;
  p_envelope               geometry                    := envelope              ;
  p_creation_date          timestamp(0) with time zone := creation_date         ;
  p_termination_date       timestamp(0) with time zone := termination_date      ;
  p_relative_to_terrain    varchar(256)                := relative_to_terrain   ;
  p_relative_to_water      varchar(256)                := relative_to_water     ;
  p_last_modification_date timestamp with time zone    := last_modification_date;
  p_updating_person        varchar(256)                := updating_person       ;
  p_reason_for_update      varchar(4000)               := reason_for_update     ;
  p_lineage                varchar(256)                := lineage               ;
--
  p_type                     character varying := type                    ;
  p_type_codespace           character varying := type_codespace          ;
  p_used_floors              integer           := used_floors             ;
  p_int_gains_tot_value      numeric           := int_gains_tot_value     ;
  p_int_gains_tot_value_unit character varying := int_gains_tot_value_unit;
  p_int_gains_conv           numeric           := int_gains_conv          ;
  p_int_gains_lat            numeric           := int_gains_lat           ;
  p_int_gains_rad            numeric           := int_gains_rad           ;
  p_heat_sched_id            integer           := heat_sched_id           ;
  p_cool_sched_id            integer           := cool_sched_id           ;
  p_vent_sched_id            integer           := vent_sched_id           ;
  p_therm_zone_id            integer           := therm_zone_id           ;
  p_building_id              integer           := building_id             ;
  p_solid_id                 integer           := solid_id                ;
  p_multi_surf_geom          geometry          := multi_surf_geom         ;
--
  p_schema_name varchar := schema_name;
	class_name varchar DEFAULT 'UsageZone'::varchar;
	db_prefix varchar DEFAULT 'nrg8';
	objectclass_id integer;
	inserted_id integer;
BEGIN
objectclass_id=citydb_pkg.objectclass_classname_to_id(class_name, db_prefix, p_schema_name);

inserted_id=citydb_pkg.insert_cityobject(
    id                    :=p_id,
    objectclass_id        :=objectclass_id,
    gmlid                 :=p_gmlid,
    gmlid_codespace       :=p_gmlid_codespace,
    name                  :=p_name,
    name_codespace        :=p_name_codespace,
    description           :=p_description,
    envelope              :=p_envelope,
    creation_date         :=p_creation_date,
    termination_date      :=p_termination_date,
    relative_to_terrain   :=p_relative_to_terrain,
    relative_to_water     :=p_relative_to_water,
    last_modification_date:=p_last_modification_date,
    updating_person       :=p_updating_person,
    reason_for_update     :=p_reason_for_update,
    lineage               :=p_lineage,
    schema_name           :=p_schema_name
);
PERFORM citydb_pkg.nrg8_insert_usage_zone(
    id                      :=inserted_id,
    objectclass_id          :=objectclass_id,
    type                    :=p_type,
    type_codespace          :=p_type_codespace,
    used_floors             :=p_used_floors,
    int_gains_tot_value     :=p_int_gains_tot_value,
    int_gains_tot_value_unit:=p_int_gains_tot_value_unit,
    int_gains_conv          :=p_int_gains_conv,
    int_gains_lat           :=p_int_gains_lat,
    int_gains_rad           :=p_int_gains_rad,
    heat_sched_id           :=p_heat_sched_id,
    cool_sched_id           :=p_cool_sched_id,
    vent_sched_id           :=p_vent_sched_id,
    therm_zone_id           :=p_therm_zone_id,
    building_id             :=p_building_id,
    solid_id                :=p_solid_id,
    multi_surf_geom         :=p_multi_surf_geom,
    schema_name             :=p_schema_name
);
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_insert_usage_zone(): %', SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function INSERT_WEATHER_DATA
----------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.nrg8_insert_weather_data(
  id                       integer DEFAULT NULL,
  gmlid                    varchar DEFAULT NULL,
  gmlid_codespace          varchar DEFAULT NULL,
  name                     varchar DEFAULT NULL,
  name_codespace           varchar DEFAULT NULL,
  description              text DEFAULT NULL,
  type                     varchar DEFAULT NULL,
  time_series_id           integer DEFAULT NULL,
  cityobject_id            integer DEFAULT NULL,
  install_point            geometry DEFAULT NULL,
  schema_name              varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
  p_id                       integer  := id             ;
  p_gmlid                    varchar  := gmlid          ;
  p_gmlid_codespace          varchar  := gmlid_codespace;
  p_name                     varchar  := name           ;
  p_name_codespace           varchar  := name_codespace ;
  p_description              text     := description    ;
  p_type                     varchar  := type           ;
  p_time_series_id           integer  := time_series_id ;
  p_cityobject_id            integer  := cityobject_id  ;
  p_install_point            geometry := install_point  ;
--
  p_schema_name varchar := schema_name;
	inserted_id integer;
BEGIN
inserted_id=citydb_pkg.nrg8_insert_weather_data(
    id                   :=p_id,
    gmlid                :=p_gmlid,
    gmlid_codespace      :=p_gmlid_codespace,
    name                 :=p_name,
    name_codespace       :=p_name_codespace,
    description          :=p_description,
    type                 :=p_type,
    time_series_id       :=p_time_series_id,
    cityobject_id        :=p_cityobject_id,
    install_point        :=p_install_point,
    schema_name          :=p_schema_name
);
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_insert_weather_data(): %', SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function INSERT_WEATHER_STATION (CityObject)
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.nrg8_insert_weather_station(
  id                     integer DEFAULT NULL,
  gmlid                  varchar(256) DEFAULT NULL,
  gmlid_codespace        varchar(1000) DEFAULT NULL,
  name                   varchar(1000) DEFAULT NULL,
  name_codespace         varchar(4000) DEFAULT NULL,
  description            varchar(4000) DEFAULT NULL,
  envelope               geometry DEFAULT NULL,
  creation_date          timestamp(0) with time zone DEFAULT NULL,
  termination_date       timestamp(0) with time zone DEFAULT NULL,
  relative_to_terrain    varchar(256) DEFAULT NULL,
  relative_to_water      varchar(256) DEFAULT NULL,
  last_modification_date timestamp with time zone DEFAULT NULL,
  updating_person        varchar(256) DEFAULT NULL,
  reason_for_update      varchar(4000) DEFAULT NULL,
  lineage                varchar(256) DEFAULT NULL,
--
  cityobject_id          integer DEFAULT NULL,
  install_point          geometry DEFAULT NULL,
--
  schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
  p_id                     integer                     := id                    ;
  p_gmlid                  varchar(256)                := gmlid                 ;
  p_gmlid_codespace        varchar(1000)               := gmlid_codespace       ;
  p_name                   varchar(1000)               := name                  ;
  p_name_codespace         varchar(4000)               := name_codespace        ;
  p_description            varchar(4000)               := description           ;
  p_envelope               geometry                    := envelope              ;
  p_creation_date          timestamp(0) with time zone := creation_date         ;
  p_termination_date       timestamp(0) with time zone := termination_date      ;
  p_relative_to_terrain    varchar(256)                := relative_to_terrain   ;
  p_relative_to_water      varchar(256)                := relative_to_water     ;
  p_last_modification_date timestamp with time zone    := last_modification_date;
  p_updating_person        varchar(256)                := updating_person       ;
  p_reason_for_update      varchar(4000)               := reason_for_update     ;
  p_lineage                varchar(256)                := lineage               ;
--
  p_cityobject_id          integer  := cityobject_id;
  p_install_point          geometry := install_point;
--
  p_schema_name varchar := schema_name;
	class_name varchar DEFAULT 'WeatherStation'::varchar;
	db_prefix varchar DEFAULT 'nrg8';
	objectclass_id integer;
	inserted_id integer;
BEGIN
objectclass_id=citydb_pkg.objectclass_classname_to_id(class_name, db_prefix, p_schema_name);

inserted_id=citydb_pkg.insert_cityobject(
    id                    :=p_id,
    objectclass_id        :=objectclass_id,
    gmlid                 :=p_gmlid,
    gmlid_codespace       :=p_gmlid_codespace,
    name                  :=p_name,
    name_codespace        :=p_name_codespace,
    description           :=p_description,
    envelope              :=p_envelope,
    creation_date         :=p_creation_date,
    termination_date      :=p_termination_date,
    relative_to_terrain   :=p_relative_to_terrain,
    relative_to_water     :=p_relative_to_water,
    last_modification_date:=p_last_modification_date,
    updating_person       :=p_updating_person,
    reason_for_update     :=p_reason_for_update,
    lineage               :=p_lineage,
    schema_name           :=p_schema_name
);
PERFORM citydb_pkg.nrg8_insert_weather_station(
    id                    :=inserted_id,
    objectclass_id        :=objectclass_id,
    cityobject_id         :=p_cityobject_id,
    install_point         :=p_install_point,
    schema_name           :=p_schema_name
);
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_insert_weather_station(): %', SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function INSERT_TIME_SERIES (generic) class_name att IS NOT NULL
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.nrg8_insert_time_series(
  classname             varchar,
  id                    integer DEFAULT NULL,
  gmlid                 varchar DEFAULT NULL,
  gmlid_codespace       varchar DEFAULT NULL,
  name                  varchar DEFAULT NULL,
  name_codespace        varchar DEFAULT NULL,
  description           text DEFAULT NULL,
  acquisition_method    varchar DEFAULT NULL,
  interpolation_type    varchar DEFAULT NULL,
  quality_description   text DEFAULT NULL,
  source                varchar DEFAULT NULL,
  time_array            numeric[] DEFAULT NULL,
  values_array          numeric[] DEFAULT NULL,
  values_unit           varchar DEFAULT NULL,
  array_length          integer DEFAULT NULL,
  temporal_extent_begin timestamp with time zone DEFAULT NULL,
  temporal_extent_end   timestamp with time zone DEFAULT NULL,
  time_interval         numeric DEFAULT NULL,
  time_interval_unit    varchar DEFAULT NULL,
  --
  file_path             varchar DEFAULT NULL,
  file_name             varchar DEFAULT NULL,
  file_extension        varchar DEFAULT NULL,
  nbr_header_lines      integer DEFAULT NULL,
  field_sep             varchar DEFAULT NULL,
  record_sep            varchar DEFAULT NULL,
  dec_symbol            varchar DEFAULT NULL,
  time_col_nbr          integer DEFAULT NULL,
  value_col_nbr         integer DEFAULT NULL,
  is_compressed         numeric(1) DEFAULT NULL,
  --
  schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer
AS $$
DECLARE
  p_id                    integer    := id                    ;
  p_gmlid                 varchar    := gmlid                 ;
  p_gmlid_codespace       varchar    := gmlid_codespace       ;
  p_name                  varchar    := name                  ;
  p_name_codespace        varchar    := name_codespace        ;
  p_description           text       := description           ;
  p_acquisition_method    varchar    := acquisition_method    ;
  p_interpolation_type    varchar    := interpolation_type    ;
  p_quality_description   text       := quality_description   ;
  p_source                varchar    := source                ;
  p_time_array            numeric[]  := time_array            ;
  p_values_array          numeric[]  := values_array          ;
  p_values_unit           varchar    := values_unit           ;
  p_array_length          integer    := array_length          ;
  p_temporal_extent_begin timestamp with time zone := temporal_extent_begin ;
  p_temporal_extent_end   timestamp with time zone := temporal_extent_end   ;
  p_time_interval         numeric    := time_interval         ;
  p_time_interval_unit    varchar    := time_interval_unit    ;
--
  p_file_path             varchar    := file_path             ;
  p_file_name             varchar    := file_name             ;
  p_file_extension        varchar    := file_extension        ;
  p_nbr_header_lines      integer    := nbr_header_lines      ;
  p_field_sep             varchar    := field_sep             ;
  p_record_sep            varchar    := record_sep            ;
  p_dec_symbol            varchar    := dec_symbol            ;
  p_time_col_nbr          integer    := time_col_nbr          ;
  p_value_col_nbr         integer    := value_col_nbr         ;
  p_is_compressed         numeric(1) := is_compressed         ;
--
	p_schema_name varchar := schema_name;
  class_name varchar := classname;
  db_prefix varchar DEFAULT 'nrg8';
  inserted_id integer;
BEGIN
CASE class_name
	WHEN 'RegularTimeSeries' THEN
		inserted_id=citydb_view.nrg8_insert_regular_time_series (
			id                   :=p_id                   ,
			gmlid                :=p_gmlid                ,
			gmlid_codespace      :=p_gmlid_codespace      ,
			name                 :=p_name                 ,
			name_codespace       :=p_name_codespace       ,
			description          :=p_description          ,
			acquisition_method   :=p_acquisition_method   ,
			interpolation_type   :=p_interpolation_type   ,
			quality_description  :=p_quality_description  ,
			source               :=p_source               ,
			values_array         :=p_values_array         ,
			values_unit          :=p_values_unit          ,
			array_length         :=p_array_length         ,
			temporal_extent_begin:=p_temporal_extent_begin,
			temporal_extent_end  :=p_temporal_extent_end  ,
			time_interval        :=p_time_interval        ,
			time_interval_unit   :=p_time_interval_unit   ,
	    schema_name          :=p_schema_name
		);
	WHEN 'IrregularTimeSeries' THEN
		inserted_id=citydb_view.nrg8_insert_irregular_time_series (
			id                 :=p_id                 ,
			gmlid              :=p_gmlid              ,
			gmlid_codespace    :=p_gmlid_codespace    ,
			name               :=p_name               ,
			name_codespace     :=p_name_codespace     ,
			description        :=p_description        ,
			acquisition_method :=p_acquisition_method ,
			interpolation_type :=p_interpolation_type ,
			quality_description:=p_quality_description,
			source             :=p_source             ,
			time_array         :=p_time_array         ,
			values_array       :=p_values_array       ,
			values_unit        :=p_values_unit        ,
			array_length       :=p_array_length       ,
	    schema_name        :=p_schema_name
		);
	WHEN 'RegularTimeSeriesFile' THEN
		inserted_id=citydb_view.nrg8_insert_regular_time_series_file (
			id                   :=p_id                   ,
			gmlid                :=p_gmlid                ,
			gmlid_codespace      :=p_gmlid_codespace      ,
			name                 :=p_name                 ,
			name_codespace       :=p_name_codespace       ,
			description          :=p_description          ,
			acquisition_method   :=p_acquisition_method   ,
			interpolation_type   :=p_interpolation_type   ,
			quality_description  :=p_quality_description  ,
			source               :=p_source               ,
			values_unit          :=p_values_unit          ,
			temporal_extent_begin:=p_temporal_extent_begin,
			temporal_extent_end  :=p_temporal_extent_end  ,
			time_interval        :=p_time_interval        ,
			time_interval_unit   :=p_time_interval_unit   ,
			file_path            :=p_file_path            ,
			file_name            :=p_file_name            ,
			file_extension       :=p_file_extension       ,
			nbr_header_lines     :=p_nbr_header_lines     ,
			field_sep            :=p_field_sep            ,
			record_sep           :=p_record_sep           ,
			dec_symbol           :=p_dec_symbol           ,
			value_col_nbr        :=p_value_col_nbr	      ,
			is_compressed        :=p_is_compressed        ,
	    schema_name          :=p_schema_name
		);
	WHEN 'IrregularTimeSeriesFile' THEN
		inserted_id=citydb_view.nrg8_insert_irregular_time_series_file (
			id                   :=p_id                   ,
			gmlid                :=p_gmlid                ,
			gmlid_codespace      :=p_gmlid_codespace      ,
			name                 :=p_name                 ,
			name_codespace       :=p_name_codespace       ,
			description          :=p_description          ,
			acquisition_method   :=p_acquisition_method   ,
			interpolation_type   :=p_interpolation_type   ,
			quality_description  :=p_quality_description  ,
			source               :=p_source               ,
      values_unit          :=p_values_unit          ,
			file_path            :=p_file_path            ,
			file_name            :=p_file_name            ,
			file_extension       :=p_file_extension       ,
			nbr_header_lines     :=p_nbr_header_lines     ,
			field_sep            :=p_field_sep            ,
			record_sep           :=p_record_sep           ,
			dec_symbol           :=p_dec_symbol           ,
			time_col_nbr         :=p_time_col_nbr         ,
			value_col_nbr        :=p_value_col_nbr	      ,
			is_compressed        :=p_is_compressed        ,
	    schema_name          :=p_schema_name
		);
ELSE
	RAISE EXCEPTION 'classname "%" not valid', class_name USING HINT = 'Valid values are "RegularTimeSeries", "IrregularTimeSeries", "RegularTimeSeriesFile" and "IrregularTimeSeriesFile"';
END CASE;
EXCEPTION
  WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_insert_time_series(): %', SQLERRM;
END;
$$ LANGUAGE plpgsql VOLATILE;

DO
$$
BEGIN
RAISE NOTICE '

********************************

Energy ADE view functions installation complete!

********************************

';
END
$$;
SELECT 'Energy ADE view functions installed correctly!'::varchar AS installation_result;

-- ***********************************************************************
-- ***********************************************************************
--
-- END OF FILE
--
-- ***********************************************************************
-- ***********************************************************************

