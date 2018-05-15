-- Simulation package v. 0.1 for the 3D City Database
--
--                         May 2018
--
-- 3D City Database: http://www.3dcitydb.org/ 
-- 
--                        Copyright 2018
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
--
-- ***********************************************************************

DROP SCHEMA IF EXISTS sim_pkg CASCADE;
CREATE SCHEMA sim_pkg;

----------------------------------------------------------------
-- FUNCTION cleanup_schema
----------------------------------------------------------------
CREATE OR REPLACE FUNCTION sim_pkg.cleanup_schema()
RETURNS void AS $BODY$
DECLARE
BEGIN
-- truncate the tables
TRUNCATE TABLE sim_pkg.generic_parameter CASCADE;
TRUNCATE TABLE sim_pkg.port_connection CASCADE;
TRUNCATE TABLE sim_pkg.port CASCADE;
TRUNCATE TABLE sim_pkg.node CASCADE;
TRUNCATE TABLE sim_pkg.simulation_to_scenario CASCADE;
TRUNCATE TABLE sim_pkg.simulation CASCADE;
TRUNCATE TABLE sim_pkg.tool CASCADE;

-- restart sequences
ALTER SEQUENCE sim_pkg.generic_parameter_id_seq RESTART;
ALTER SEQUENCE sim_pkg.port_connection_id_seq RESTART;
ALTER SEQUENCE sim_pkg.port_id_seq RESTART;
ALTER SEQUENCE sim_pkg.node_id_seq RESTART;
ALTER SEQUENCE sim_pkg.simulation_id_seq RESTART;
ALTER SEQUENCE sim_pkg.tool_id_seq RESTART;

EXCEPTION
    WHEN OTHERS THEN RAISE NOTICE 'sim_pkg.cleanup_schema: %', SQLERRM;
END; 
$BODY$
LANGUAGE plpgsql;
	
-- ***********************************************************************
-- ***********************************************************************

DO
$$
BEGIN
RAISE NOTICE '

********************************

Simulation package functions installation complete!

********************************

';
END
$$;
SELECT 'Simulation package functions installation complete!'::varchar AS installation_result;

-- ***********************************************************************
-- ***********************************************************************
--
-- END OF FILE
--
-- ***********************************************************************
-- ***********************************************************************
