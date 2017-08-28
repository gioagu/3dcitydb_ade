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
-- ********************* 04_Energy_ADE_triggers.sql **********************
--
-- This script creates some trigger functions that handle the deletion
-- of entries in some ADE tables. They are all prefixed with "nrg8_"
--
-- ***********************************************************************
-- ***********************************************************************

DROP FUNCTION IF EXISTS    citydb_pkg.nrg8_trigger_delete_nrg_building() CASCADE;
CREATE OR REPLACE FUNCTION citydb_pkg.nrg8_trigger_delete_nrg_building()
  RETURNS trigger AS
$BODY$
DECLARE
	b_id integer;
	tz_id integer;
	uz_id integer;
	schema_name varchar;
BEGIN
--RAISE NOTICE '**** TRIGGER nrg8_building_id "%" schema "%"', OLD.id, TG_TABLE_SCHEMA;
b_id := OLD.id;
schema_name := TG_TABLE_SCHEMA::varchar;

-- get the usage_zone ids
FOR uz_id IN EXECUTE format('SELECT id FROM %I.nrg8_usage_zone WHERE building_id = %L', schema_name, b_id) LOOP
-- delete the usage_zone
	EXECUTE 'SELECT citydb_pkg.nrg8_delete_usage_zone($1, $2)' USING uz_id, schema_name;
END LOOP;	

-- get the thermal_zone ids
FOR tz_id IN EXECUTE format('SELECT id FROM %I.nrg8_thermal_zone WHERE building_id = %L', schema_name, b_id) LOOP
-- delete the thermal_zone
	EXECUTE 'SELECT citydb_pkg.nrg8_delete_thermal_zone($1, $2)' USING tz_id, schema_name;
END LOOP;	
-- go on deleting itself right after the trigger by means of ON DELETE CASCADE
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.nrg8_trigger_delete_nrg_building(): %', SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

DROP TRIGGER IF EXISTS nrg8_trigger_delete_nrg_building ON nrg8_building;
CREATE TRIGGER nrg8_trigger_delete_nrg_building
	BEFORE DELETE ON citydb.nrg8_building
	FOR EACH ROW EXECUTE PROCEDURE citydb_pkg.nrg8_trigger_delete_nrg_building();

----------------------------------------------------------------
-- Function TRIGGER_DELETE_NRG_WEATHER_DATA
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_pkg.nrg8_trigger_delete_weather_data() CASCADE;
CREATE OR REPLACE FUNCTION citydb_pkg.nrg8_trigger_delete_weather_data()
  RETURNS trigger AS
$BODY$
DECLARE
	ts_id integer;
	schema_name varchar;
BEGIN
--RAISE NOTICE '**** TRIGGER weather_data.id "%" schema "%"', OLD.id, TG_TABLE_SCHEMA;
ts_id := OLD.time_series_id;
schema_name := TG_TABLE_SCHEMA::varchar;
-- Delete the dependent time_series 
EXECUTE 'SELECT citydb_pkg.nrg8_delete_time_series($1, $2)' USING ts_id, schema_name;
-- go on deleting itself right after the trigger by means of ON DELETE CASCADE
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.nrg8_trigger_delete_weather_data(): %', SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

DROP TRIGGER IF EXISTS nrg8_trigger_delete_weather_data ON citydb.nrg8_weather_data;
CREATE TRIGGER nrg8_trigger_delete_weather_data
	AFTER DELETE ON citydb.nrg8_weather_data
	FOR EACH ROW
	WHEN (OLD.time_series_id IS NOT NULL) 
	EXECUTE PROCEDURE citydb_pkg.nrg8_trigger_delete_weather_data();

----------------------------------------------------------------
-- Function TRIGGER_DELETE_ENERGY_DEMAND
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_pkg.nrg8_trigger_delete_energy_demand() CASCADE;
CREATE OR REPLACE FUNCTION citydb_pkg.nrg8_trigger_delete_energy_demand()
  RETURNS trigger AS
$BODY$
DECLARE
	ts_id integer;
	schema_name varchar;
BEGIN
schema_name := TG_TABLE_SCHEMA::varchar;
--RAISE NOTICE '**** TRIGGER energy_demand.id "%" schema "%"', OLD.id, TG_TABLE_SCHEMA;
ts_id := OLD.time_series_id;
-- Delete the dependent time_series 
EXECUTE 'SELECT citydb_pkg.nrg8_delete_time_series($1, $2)' USING ts_id, schema_name;
-- go on deleting itself right after the trigger by means of ON DELETE CASCADE
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.nrg8_trigger_delete_energy_demand()(): %', SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

DROP TRIGGER IF EXISTS nrg8_trigger_delete_energy_demand ON citydb.nrg8_energy_demand;
CREATE TRIGGER nrg8_trigger_delete_energy_demand
	AFTER DELETE ON citydb.nrg8_energy_demand
	FOR EACH ROW 
	WHEN (OLD.time_series_id IS NOT NULL)
	EXECUTE PROCEDURE citydb_pkg.nrg8_trigger_delete_energy_demand();

-- ***********************************************************************
-- ***********************************************************************

DO
$$
BEGIN
RAISE NOTICE '

********************************

Energy ADE triggers installation complete!

********************************

';
END
$$;
SELECT 'Energy ADE triggers installed correctly!'::varchar AS installation_result;	
	
	
-- ***********************************************************************
-- ***********************************************************************
--
-- END OF FILE
--
-- ***********************************************************************
-- ***********************************************************************

