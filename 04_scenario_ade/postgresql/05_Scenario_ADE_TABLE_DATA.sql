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
-- ********************* 05_Scenario_ADE_TABLE_DATA.sql ******************
--
-- This script add entries to the ADE, SCHEMA, OBJECTCLASS and
-- SCHEMA_TO_OBJECTCLASS tables.
--
-- ***********************************************************************
-- ***********************************************************************

-- TO DO: Rewrite using dynamic IDs
-- FOR THE TIME BEING, we keep the ids of the new classes fixed. In near future, they will be
-- assigned automatically, starting after the last assigned id in the OBJECTCLASS table

-- Add entry into table ADE
DELETE FROM citydb.ade WHERE db_prefix='scn2'; 
INSERT INTO citydb.ade (name, description, version, db_prefix)
VALUES
('Scenario ADE', 'Scenario Application Domain Extension v. 0.2', '0.2', 'scn2');

-- Add entry into table SCHEMA
WITH a AS (SELECT id FROM citydb.ade WHERE db_prefix='scn2')
INSERT INTO citydb.schema
(ade_id, is_ade_root, citygml_version, xml_namespace_prefix, xml_namespace_uri, xml_schema_location)
SELECT
a.id, 1, '2.0','scenario', '_scenario_ade_placeholder_','_scenario_ade_placeholder_'
FROM a;

-- Add entry into table SCHEMA_REFERENCING
WITH ade AS (SELECT id FROM citydb.schema WHERE xml_namespace_uri='_scenario_ade_placeholder_' AND citygml_version='2.0'),
     c AS (SELECT id FROM citydb.schema WHERE xml_namespace_uri='http://schemas.opengis.net/citygml/2.0')
INSERT INTO citydb.schema_referencing (referenced_id, referencing_id) 
SELECT c.id,ade.id FROM ade,c;

WITH ade AS (SELECT id FROM citydb.schema WHERE xml_namespace_uri='_scenario_ade_placeholder_' AND citygml_version='1.0'),
     c AS (SELECT id FROM citydb.schema WHERE xml_namespace_uri='http://schemas.opengis.net/citygml/1.0')
INSERT INTO citydb.schema_referencing (referenced_id, referencing_id) 
SELECT c.id,ade.id FROM ade,c;

-- Add entries into table OBJECTCLASS
DELETE FROM citydb.objectclass WHERE id BETWEEN 140 AND 165;
INSERT INTO citydb.objectclass (id, superclass_id, baseclass_id, is_ade_class, classname, tablename) VALUES
-- Time Series
(140,   1, 1, 1, '_Type'                      , NULL                  ),
(141, 140, 1, 1, '_TimeSeries'                , 'scn2_timeseries'     ),
(142, 141, 1, 1, 'RegularTimeSeries'          , 'scn2_timeseries'     ),
(143, 141, 1, 1, 'IrregularTimeSeries'        , 'scn2_timeseries'     ),
(144, 141, 1, 1, 'RegularTimeSeriesFile'      , 'scn2_timeseries_file'),
(145, 141, 1, 1, 'IrregularTimeSeriesFile'    , 'scn2_timeseries_file'),
-- Scenario
(150,   2, 2, 1, 'Scenario'                   , 'scn2_scenario'       ),
-- Operation
(153,   2, 2, 1, '_Operation'                 , 'scn2_operation'      ),
(154, 153, 2, 1, 'ComplexOperation'           , 'scn2_operation'      ),
(155, 153, 2, 1, '_SimpleOperation'           , 'scn2_operation'      ),
(156, 155, 2, 1, 'AddFeature'                 , 'scn2_operation'      ),
(157, 155, 2, 1, 'RemoveFeature'              , 'scn2_operation'      ),
(158, 155, 2, 1, 'ChangeFeatureAttribute'     , 'scn2_operation'      ),
-- Resource                                                           
(160,   2, 2, 1, '_Resource'                  , 'scn2_resource'       ),
(161,   2, 2, 1, 'EnergyResource'             , 'scn2_resource'       ),
(162,   2, 2, 1, 'MaterialResource'           , 'scn2_resource'       ),
(163,   2, 2, 1, 'MoneyResource'              , 'scn2_resource'       ),
(164,   2, 2, 1, 'TimeResource'               , 'scn2_resource'       ),
(165,   2, 2, 1, 'OtherResource'              , 'scn2_resource'       )
;

-- Add entry into table SCHEMA_TO_OBJECTCLASS
WITH r AS (SELECT id FROM citydb.schema WHERE (xml_namespace_uri='_scenario_ade_placeholder_' AND citygml_version='2.0')
OR (xml_namespace_uri='http://www.sig3d.org/citygml/2.0/scenario/0.2' AND citygml_version='2.0')
),
     s AS (SELECT id FROM citydb.objectclass WHERE id BETWEEN 140 AND 199 ORDER BY id)
INSERT INTO citydb.schema_to_objectclass (schema_id,objectclass_id) SELECT r.id, s.id FROM s,r ORDER BY s.id;

-- Add entries into Lookup tables (Codelists and Enumerations)

-- Add entry into table LU_INTERPOLATION
TRUNCATE    citydb.scn2_lu_interpolation CASCADE;
INSERT INTO citydb.scn2_lu_interpolation
(id, name, name_codespace, description)
VALUES
('AverageInPrecedingInterval',    'Average in preceding interval',   NULL, NULL),
('AverageInSucceedingInterval',   'Average in succeeding interval',  NULL, NULL),
('ConstantInPrecedingInterval',   'Constant in preceding interval',  NULL, NULL),
('ConstantInSucceedingInterval',  'Constant in succeeding interval', NULL, NULL),
('Continuous',                    'Continuous',                      NULL, NULL),
('Discontinuous',                 'Discontinuous',                   NULL, NULL),
('InstantaneousTotal',            'Instantaneous total',             NULL, NULL),
('MaximumInPrecedingInterval',    'Maximum in preceding interval',   NULL, NULL),
('MaximumInSucceedingInterval',   'Maximum in succeeding interval',  NULL, NULL),
('MinimumInPrecedingInterval',    'Minimum in preceding interval',   NULL, NULL),
('MinimumInSucceedingInterval',   'Minimum in succeeding interval',  NULL, NULL),
('PrecedingTotal',                'Preceding total',                 NULL, NULL),
('SucceedingTotal',               'Succeeding total',                NULL, NULL)
;

-- Add entry into table LU_ACQUISITION_METHOD
TRUNCATE    citydb.scn2_lu_acquisition_method CASCADE;
INSERT INTO citydb.scn2_lu_acquisition_method
(id, name, name_codespace, description)
VALUES
('Measurement',          'Measurement',           NULL, NULL),
('Simulation',           'Simulation',            NULL, NULL),
('CalibratedSimulation', 'Calibrated simulation', NULL, NULL),
('Estimation',           'Estimation',            NULL, NULL),
('Unknown',              'Unknown',               NULL, NULL)
;

-- Add entry into table LU_CONSTRAINT_TYPE
TRUNCATE    citydb.scn2_lu_constraint_type CASCADE;
INSERT INTO citydb.scn2_lu_constraint_type
(id, name, name_codespace, description)
VALUES
('=' ,'=' , NULL, NULL),
('<' ,'<' , NULL, NULL),
('<=','<=', NULL, NULL),
('>' ,'>' , NULL, NULL),
('>=','>=', NULL, NULL),
('<>','<>', NULL, NULL),
('+','+'  , NULL, NULL),
('-','-'  , NULL, NULL)
;

-- Add entry into table LU_TEMPORAL_AGGRETATION
TRUNCATE    citydb.scn2_lu_temporal_aggregation CASCADE;
INSERT INTO citydb.scn2_lu_temporal_aggregation
(id, name, name_codespace, description)
VALUES
('hour' ,'Hour' , NULL, NULL),
('day'  ,'Day'  , NULL, NULL),
('week' ,'Week' , NULL, NULL),
('month','Month', NULL, NULL),
('year' ,'Year' , NULL, NULL),
('other','Other', NULL, NULL)
;

-- Add entry into table LU_AGGRETATION_TYPE
TRUNCATE    citydb.scn2_lu_aggregation_type CASCADE;
INSERT INTO citydb.scn2_lu_aggregation_type
(id, name, name_codespace, description)
VALUES
('average','Average', NULL, NULL),
('sum'    ,'Sum'    , NULL, NULL),
('max'    ,'Maximum', NULL, NULL),
('min'    ,'Minimum', NULL, NULL),
('other'  ,'Other'  , NULL, NULL)
;

-- ***********************************************************************
-- ***********************************************************************

DO
$$
BEGIN
RAISE NOTICE '

********************************

Scenario ADE table data installation complete!

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