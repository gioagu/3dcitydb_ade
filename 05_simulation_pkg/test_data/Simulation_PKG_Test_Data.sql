-- Simulation package v. 0.1 for the 3D City Database
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

SELECT sim_pkg.cleanup_schema();

INSERT INTO sim_pkg.tool
(id, name, server_name, server_address, os_type, os_version, dependencies, connection_parameters)
VALUES
( 1, 'tool_name_1', 'server_name_1', 'server_address_1', 'Microsoft Windows', '10', 'Python, ....', 'connection_parameters_string1'),
( 2, 'tool_name_2', 'server_name_2', 'server_address_2', 'Fedora Linux'     , '15', 'Python, ....', 'connection_parameters_string2'),
( 3, 'tool_name_3', 'server_name_3', 'server_address_3', 'Microsoft Windows',  '8', 'Python, ....', 'connection_parameters_string3'),
( 4, 'tool_name_4', 'server_name_4', 'server_address_4', 'Fedora Linux'     , '10', 'Python, ....', 'connection_parameters_string4'),
( 5, 'tool_name_5', 'server_name_5', 'server_address_5', 'Microsoft Windows',  '7', 'Python, ....', 'connection_parameters_string5'),
( 6, 'tool_name_6', 'server_name_6', 'server_address_6', 'Fedora Linux'     , '99', 'Python, ....', 'connection_parameters_string6'),
( 7, 'tool_name_7', 'server_name_7', 'server_address_7', 'Microsoft Windows', '10', 'Python, ....', 'connection_parameters_string7'),
( 8, 'tool_name_8', 'server_name_8', 'server_address_8', 'Fedora Linux'     , '10', 'Python, ....', 'connection_parameters_string8')
;
WITH s AS (
SELECT max(id) AS newid FROM sim_pkg.tool)
SELECT setval('sim_pkg.tool_id_seq', s.newid, true) FROM s;

INSERT INTO sim_pkg.generic_parameter
(name, strval, intval, realval, arrayval, unit, tool_id)
VALUES
('tool_param_1', NULL, NULL, 5.5, NULL, 'm^2', 1),
('tool_param_1', NULL, NULL, 6.5, NULL, 'm^2', 2),
('tool_param_1', NULL, NULL, 7.5, NULL, 'm^2', 3),
('tool_param_1', NULL, NULL, 8.5, NULL, 'm^2', 4),
('tool_param_1', NULL, NULL, 0.5, NULL, 'm^2', 5),
('tool_param_2', NULL, NULL, 5.99, NULL, 'm^3', 1),
('tool_param_2', NULL, NULL, 6.99, NULL, 'm^3', 2),
('tool_param_2', NULL, NULL, 7.99, NULL, 'm^3', 3),
('tool_param_2', NULL, NULL, 8.99, NULL, 'm^3', 4),
('tool_param_2', NULL, NULL, 0.99, NULL, 'm^3', 5),
('tool_param_3', NULL, 25, NULL, NULL, 'kg', 4),
('tool_param_3', NULL, 26, NULL, NULL, 'kg', 5),
('tool_param_3', NULL, 27, NULL, NULL, 'kg', 6),
('tool_param_3', NULL, 28, NULL, NULL, 'kg', 7),
('tool_param_3', NULL, 29, NULL, NULL, 'kg', 8)
;

INSERT INTO sim_pkg.simulation
(id, name, time_start, time_stop, time_interval, time_interval_unit)
VALUES
( 1, 'sim_1', '2000-01-01'::timestamp, '2010-12-31'::timestamp, 1, 'y'),
( 2, 'sim_2', '2000-01-01'::timestamp, '2010-12-31'::timestamp, 1, 'month'),
( 3, 'sim_3', '2000-01-01'::timestamp, '2000-01-31'::timestamp, 1, 'd'),
( 4, 'sim_4', '2000-01-01'::timestamp, '2000-12-31'::timestamp, 1, 'h')
;
WITH s AS (
SELECT max(id) AS newid FROM sim_pkg.simulation)
SELECT setval('sim_pkg.simulation_id_seq', s.newid, true) FROM s;

INSERT INTO sim_pkg.generic_parameter
(name, strval, intval, realval, arrayval, unit, simulation_id)
VALUES
('sim_param_1', NULL, NULL, 121.5, NULL, 'kg/m^2', 1),
('sim_param_1', NULL, NULL, 121.5, NULL, 'kg/m^2', 2),
('sim_param_1', NULL, NULL, 121.5, NULL, 'kg/m^2', 3),
('sim_param_1', NULL, NULL, 121.5, NULL, 'kg/m^2', 4),
('sim_param_2', NULL, NULL,  1.99, NULL, 'W',      1),
('sim_param_2', NULL, NULL,  1.99, NULL, 'W',      2),
('sim_param_2', NULL, NULL,  1.99, NULL, 'W',      3),
('sim_param_2', NULL, NULL,  1.99, NULL, 'W',      4),
('sim_param_3', NULL, 1.23,  NULL, NULL, 's',      1),
('sim_param_3', NULL, 1.23,  NULL, NULL, 's',      2),
('sim_param_3', NULL, 1.23,  NULL, NULL, 's',      3)
;

INSERT INTO sim_pkg.node
(id, name, cityobject_id, simulation_id)
VALUES
( 1, 'node_1_sim_1', NULL, 1),
( 2, 'node_2_sim_1', NULL, 1),
( 3, 'node_3_sim_1', NULL, 1),
( 4, 'node_4_sim_1', NULL, 1),
( 5, 'node_5_sim_1', NULL, 1),
( 6, 'node_6_sim_2', NULL, 2),
( 7, 'node_7_sim_2', NULL, 2),
( 8, 'node_8_sim_2', NULL, 2),
( 9, 'node_9_sim_2', NULL, 2)
;
WITH s AS (
SELECT max(id) AS newid FROM sim_pkg.node)
SELECT setval('sim_pkg.node_id_seq', s.newid, true) FROM s;

INSERT INTO sim_pkg.generic_parameter
(name, strval, intval, realval, arrayval, unit, node_id)
VALUES
('node_param_1', NULL, NULL, 121.5, NULL, 'kWh', 1),
('node_param_1', NULL, NULL, 121.5, NULL, 'kWh', 2),
('node_param_1', NULL, NULL, 121.5, NULL, 'kWh', 3),
('node_param_1', NULL, NULL, 121.5, NULL, 'kWh', 4),
('node_param_2', NULL, NULL,  1.99, NULL, 'm/s', 1),
('node_param_2', NULL, NULL,  1.99, NULL, 'm/s', 2),
('node_param_2', NULL, NULL,  1.99, NULL, 'm/s', 3),
('node_param_2', NULL, NULL,  1.99, NULL, 'm/s', 4),
('node_param_3', NULL, 1.23,  NULL, NULL, '° C', 1),
('node_param_3', NULL, 1.23,  NULL, NULL, '° C', 2),
('node_param_3', NULL, 1.23,  NULL, NULL, '° C', 3)
;

INSERT INTO sim_pkg.port
(id, type, name, variable_name, variable_type, cityobject_id, node_id)
VALUES
( 1, 'input' , 'Port_1_Node_1' , 'var_name_x', 'integer', NULL, 1),
( 2, 'input' , 'Port_2_Node_1' , 'var_name_y', 'double' , NULL, 1),
( 3, 'input' , 'Port_3_Node_1' , 'var_name_x', 'boolean', NULL, 1),
( 4, 'output', 'Port_4_Node_1' , 'var_name_y', 'string' , NULL, 1),
( 5, 'output', 'Port_5_Node_1' , 'var_name_x', 'integer', NULL, 1),
( 6, 'input' , 'Port_6_Node_2' , 'var_name_z', 'double' , NULL, 2),
( 7, 'output', 'Port_7_Node_2' , 'var_name_z', 'string' , NULL, 2),
( 8, 'input' , 'Port_8_Node_3' , 'var_name_x', 'integer', NULL, 3),
( 9, 'output', 'Port_9_Node_3' , 'var_name_y', 'integer', NULL, 3),
(10, 'output', 'Port_10_Node_3', 'var_name_x', 'string' , NULL, 3),
(11, 'input',  'Port_11_Node_8', 'var_name_x', 'string' , NULL, 8),
(12, 'output', 'Port_12_Node_8', 'var_name_x', 'string' , NULL, 8),
(13, 'input',  'Port_13_Node_9', 'var_name_x', 'string' , NULL, 9),
(14, 'output', 'Port_14_Node_9', 'var_name_x', 'string' , NULL, 9)
;
WITH s AS (
SELECT max(id) AS newid FROM sim_pkg.port)
SELECT setval('sim_pkg.port_id_seq', s.newid, true) FROM s;

INSERT INTO sim_pkg.port_connection
(name, output_port_id, input_port_id, simulation_id)
VALUES 
('Connection_1',  1,  7, 1),
('Connection_2',  2,  8, 1),
('Connection_3',  3, 10, 1)
;

DO
$$
BEGIN
RAISE NOTICE '

********************************

Simulation Package Test data installation complete!

********************************

';
END
$$;
SELECT 'Simulation Package Test data installation complete!'::varchar AS test_data_installation_result;

-- ***********************************************************************
-- ***********************************************************************
--
-- END OF FILE
--
-- ***********************************************************************
-- ***********************************************************************







