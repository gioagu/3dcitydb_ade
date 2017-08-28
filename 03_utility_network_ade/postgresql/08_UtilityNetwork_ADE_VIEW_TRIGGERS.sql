-- 3D City Database extension for the UtilityNetworks ADE v. 0.9
--
--                     BETA 1, August 2017
--
-- 3D City Database: http://www.3dcitydb.org/ 
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
-- *************** 08_UtilityNetworks_ADE_VIEW_TRIGGERS.sql **************
--
-- This script adds triggers and trigger functions to schema citydb_view
-- in order to make some views updateable.
--
-- ***********************************************************************
-- ***********************************************************************

-- SCRIPT IS EMPTY FOR NOW

-- ***********************************************************************
-- ***********************************************************************

DO
$$
BEGIN
RAISE NOTICE '

********************************

UtilityNetworks ADE view triggers installation complete!

********************************

';
END
$$;
SELECT 'UtilityNetworks ADE view triggers installed correctly!'::varchar AS installation_result;


-- ***********************************************************************
-- ***********************************************************************
--
-- END OF FILE
--
-- ***********************************************************************
-- ***********************************************************************