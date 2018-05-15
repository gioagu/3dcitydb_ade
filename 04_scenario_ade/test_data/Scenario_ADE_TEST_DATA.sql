-- 3D City Database extension for the Scenario ADE v. 0.2
--
--                     May 2018
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
-- *********************** Scenario_ADE_TEST_DATA.sql **********************
--
--
-- ***********************************************************************
-- ***********************************************************************

--SELECT citydb_pkg.scn2_cleanup_schema('citydb');

INSERT INTO citydb.scn2_scenario
(id, objectclass_id, name, description, instant, period_begin, period_end)
VALUES
( 1, 150, 'Scenario_2017' ,'Scenario representing the baseline (status quo)', '2017-01-01', NULL, NULL),
( 2, 150, 'Scenario_2030' ,'Scenario representing the city in 2030'         , '2030-01-01', NULL, NULL),
( 3, 150, 'Scenario_2050' ,'Scenario representing the city in 2050'         , '2050-01-01', NULL, NULL),
( 4, 150, 'Scenario_ts'   ,'A placeholder scenario to be linked to timeseries results', NULL, NULL, NULL),
( 5, 150, 'Scenario_5'    ,'Description of Scenario  5'                     , NULL,         NULL, NULL),
( 6, 150, 'Scenario_6'    ,'Description of Scenario  6'                     , NULL,         NULL, NULL),
( 7, 150, 'Scenario_7'    ,'Description of Scenario  7'                     , NULL,         NULL, NULL),
( 8, 150, 'Scenario_8'    ,'Description of Scenario  8'                     , NULL,         NULL, NULL),
( 9, 150, 'Scenario_9'    ,'Description of Scenario  9'                     , NULL,         NULL, NULL),
(10, 150, 'Scenario_10'   ,'Description of Scenario  10'                    , NULL,         NULL, NULL)
;
WITH s AS (
SELECT max(id) AS newid FROM citydb.scn2_scenario)
SELECT setval('citydb.scn2_scenario_id_seq', s.newid, true) FROM s;

INSERT INTO citydb.scn2_resource
(objectclass_id, name, type, quantity, quantity_unit, total_cost, total_cost_unit, is_renewable, scenario_id, operation_id)
VALUES
(163, 'Resource_1 required by Scenario 1', NULL      ,  50, 'M€',  NULL, NULL, NULL, 1, NULL),
(164, 'Resource_2 required by Scenario 1', NULL      ,   1, 'Y',   100 , 'k€', NULL, 1, NULL),
(162, 'Resource_3 required by Scenario 1', 'Steel'   ,  20, 'T',     20, 'k$', NULL, 1, NULL),
(161, 'Resource_4 required by Scenario 1', NULL      ,  50, 'GWh', NULL, NULL, NULL, 1, NULL),
(165, 'Resource_5 required by Scenario 1', 'Seawater', 100, 'M€',  NULL, NULL, NULL, 1, NULL),
(163, 'Resource_1 required by Scenario 2', NULL      , 550, 'M€',  NULL, NULL, NULL, 2, NULL),
(164, 'Resource_2 required by Scenario 2', NULL      ,  51, 'Y',   100 , 'k€', NULL, 2, NULL),
(162, 'Resource_3 required by Scenario 2', 'Bricks'  ,  22, 'T',     20, 'k$', NULL, 2, NULL)
;

INSERT INTO citydb.scn2_time_series
(id, objectclass_id, name, acquisition_method, interpolation_type, values_array, 
values_unit, temporal_extent_begin, temporal_extent_end, time_interval, time_interval_unit)
VALUES
( 1,142, 'Reg Time Series 1 for Scenario Parameter' , 'Simulation', 'Continuous', '{101,102,103,104,105,106,107,108,109,110,111,112}', 'kWh/m^2/month','2017-01-01', '2017-12-31', 1, 'month'),
( 2,142, 'Reg Time Series 2 for Scenario Parameter' , 'Simulation', 'Continuous', '{71,72,73,74,75,76,77,78,79,80,81,82}'            , 'kWh/m^2/month','2030-01-01', '2030-12-31', 1, 'month'),
( 3,142, 'Reg Time Series 3 for Scenario Parameter' , 'Simulation', 'Continuous', '{11,12,13,14,15,16,17,18,19,20,21,22}'            , 'kWh/m^2/month','2050-01-01', '2050-12-31', 1, 'month'),
( 4,142, 'Reg Time Series 4 for Scenario Parameter' , 'Simulation', 'Continuous', '{1,2,3,4,5,6,7,8,9,10,11,12}', 'm^2','2000-01-01', '2000-12-31', 1, 'month'),
( 5,142, 'Reg Time Series 5 for Scenario Parameter' , 'Simulation', 'Continuous', '{1,2,3,4,5,6,7,8,9,10,11,12}', 'm^2','2000-01-01', '2000-12-31', 1, 'month'),
( 6,142, 'Reg Time Series 6 for Scenario Parameter' , 'Simulation', 'Continuous', '{11,12,13,14,15,16,17,18,19,110,111,112}', 'm^2','2000-01-01', '2000-12-31', 1, 'month'),
( 7,142, 'Reg Time Series 7 for Scenario Parameter' , 'Simulation', 'Continuous', '{10,20,30,40,50,60,70,80,90,100,110,120}', 'm^2','2000-01-01', '2000-12-31', 1, 'month'),
( 8,142, 'Reg Time Series 8 for Scenario Parameter' , 'Simulation', 'Continuous', '{1,2,3,4,5,6,7,8,9,10,11,12}', 'm^2','2000-01-01', '2000-12-31', 1, 'month');
WITH s AS (
SELECT max(id) AS newid FROM citydb.scn2_scenario)
SELECT setval('citydb.scn2_time_series_id_seq', s.newid, true) FROM s;

INSERT INTO citydb.scn2_scenario_parameter
(id, type, name, constraint_type, sim_name, aggregation_type, temp_aggregation, 
strval, booleanval, intval, realval, unit, dateval, urival, geomval, time_series_id, scenario_id)
VALUES
( 1, 'output' , 'Annual final energy consumption per capita',   NULL, NULL, NULL, NULL, NULL, NULL, NULL, 21232, 'kWh/a/person', NULL, NULL, NULL, NULL, 1),
( 2, 'output' , 'Annual CO2 emission per capita',               NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2.8  , 't/a/person'  , NULL, NULL, NULL, NULL, 1),
( 3, 'output' , 'Annual primary energy consumption per person', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2831 , 'W', NULL, NULL, NULL, NULL, 1),
( 4, 'input'  , 'Reduction of CO2 emissions (from 1995)',        '-', NULL, NULL, NULL, NULL, NULL, NULL, 30   , '%', NULL, NULL, NULL, NULL, 2),
( 5, 'input'  , 'Annual primary energy consumption per person', '<=', NULL, NULL, NULL, NULL, NULL, NULL, 2000 , 'W', NULL, NULL, NULL, NULL, 3),
( 6, 'input'  , 'Reduction of CO2 emissions (from 1995)',        '-', NULL, NULL, NULL, NULL, NULL, NULL, 50   , '%', NULL, NULL, NULL, NULL, 3),
( 7, 'input'  , 'Population (Inhabitants)',                     NULL, NULL, NULL, NULL, NULL, NULL, 1800000, NULL, NULL, NULL, NULL, NULL, NULL, 1),
( 8, 'output' , 'Population (Inhabitants)',                     NULL, 'Pop sim'   , NULL, NULL, NULL, NULL, 2100000, NULL, NULL, NULL, NULL, NULL, NULL, 2),
( 9, 'output' , 'Population (Inhabitants)',                     NULL, 'Pop sim'   , NULL, NULL, NULL, NULL, 2200000, NULL, NULL, NULL, NULL, NULL, NULL, 3),
(10, 'output' , 'Average monthly heating demand',               NULL, 'EnergyPlus', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1),
(11, 'output' , 'Average monthly heating demand',               NULL, 'CitySim+'  , NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2, 2),
(12, 'output' , 'Average monthly heating demand',               NULL, 'Simstadt'  , NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, 3),
(13, 'output' , 'Exemplary KPI with time series',               NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 4, 4),
(14, 'output' , 'Exemplary KPI with time series',               NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 5, 4),
(15, 'output' , 'Exemplary KPI with time series',               NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 6, 4),
(16, 'output' , 'Exemplary KPI with time series',               NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 7, 4),
(17, 'output' , 'Exemplary KPI with time series',               NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 8, 4)
;
WITH s AS (
SELECT max(id) AS newid FROM citydb.scn2_scenario_parameter)
SELECT setval('citydb.scn2_scenario_parameter_id_seq', s.newid, true) FROM s;

-- ********************************
--
-- TO DO: Add examples with Operation objects.
--
-- ********************************


DO
$$
BEGIN
RAISE NOTICE '

********************************

Test data installation complete!

********************************

';
END
$$;
SELECT 'Test data installation complete!'::varchar AS test_data_installation_result;

-- ***********************************************************************
-- ***********************************************************************
--
-- END OF FILE
--
-- ***********************************************************************
-- ***********************************************************************