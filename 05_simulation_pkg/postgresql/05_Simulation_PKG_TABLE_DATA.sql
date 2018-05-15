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

-- Add entries into Lookup tables (Codelists and Enumerations)

-- Add entry into table LU_INTERPOLATION
TRUNCATE    sim_pkg.lu_variable_type CASCADE;
INSERT INTO sim_pkg.lu_variable_type
(id, name, name_codespace, description)
VALUES
('integer'        ,'Integer'         ,NULL, NULL),
('boolean'        ,'Boolean'         ,NULL, NULL),
('doublePrecision','Double precision',NULL, NULL),
('measure'        ,'Measure'         ,NULL, NULL),
('characterString','Character string',NULL, NULL),
('date'           ,'Date'            ,NULL, NULL),
('timestamp'      ,'Timestamp'       ,NULL, NULL)
;

-- ***********************************************************************
-- ***********************************************************************

DO
$$
BEGIN
RAISE NOTICE '

********************************

Simulation Package table data installation complete!

********************************

';
END
$$;
SELECT 'Scenario ADE table data installed correctly!'::varchar AS installation_result;


-- ***********************************************************************
-- ***********************************************************************
--
-- END OF FILE
--
-- ***********************************************************************
-- ***********************************************************************