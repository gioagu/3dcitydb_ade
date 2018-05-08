-- 3D City Database extension for the Utility Network ADE v. 0.9.2
--
--                     August 2017
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
-- ***************** 05_UtilityNetworks_ADE_TABLE_DATA.sql ***************
--
-- This script add entries to the ADE, SCHEMA, OBJECTCLASS and
-- SCHEMA_TO_OBJECTCLASS tables.
--
-- ***********************************************************************
-- ***********************************************************************

-- Add entry into table ADE
DELETE FROM citydb.ade WHERE db_prefix='utn9'; 
INSERT INTO citydb.ade (name, description, version, db_prefix)
VALUES
('UtilityNetworks ADE', 'UtilityNetworks Application Domain Extension v. 0.9', '0.9', 'utn9');

-- Add entry into table SCHEMA
WITH a AS (SELECT id FROM citydb.ade WHERE db_prefix='utn9')
INSERT INTO citydb.schema
(ade_id, is_ade_root, citygml_version, xml_namespace_prefix, xml_namespace_uri, xml_schema_location)
SELECT
a.id, 1, '2.0','utilitynetworks', '_utilitynetworks_ade_placeholder_','_utilitynetworks_ade_placeholder_'
FROM a;

-- Add entry into table SCHEMA_REFERENCING
WITH nrg AS (SELECT id FROM citydb.schema WHERE xml_namespace_uri='_utilitynetworks_ade_placeholder_' AND citygml_version='2.0'),
     c AS (SELECT id FROM citydb.schema WHERE xml_namespace_uri='http://schemas.opengis.net/citygml/2.0')
INSERT INTO citydb.schema_referencing (referenced_id, referencing_id) 
SELECT c.id,nrg.id FROM nrg,c;

-- Add entries into table OBJECTCLASS
DELETE FROM citydb.objectclass WHERE id BETWEEN 300 AND 399;
INSERT INTO citydb.objectclass (id, superclass_id, baseclass_id, is_ade_class, classname, tablename) VALUES
-- Core
(300,   3, 3, 1, 'Network'                       , 'ntw9_network'             ),
(301,   3, 3, 1, '_NetworkFeature'               , 'ntw9_network_feature'     ),
(302,   2, 2, 1, 'NetworkGraph'                  , 'ntw9_network_graph'       ),
(303,   2, 2, 1, 'FeatureGraph'                  , 'ntw9_feature_graph'       ),
(304,   2, 2, 1, 'Node'                          , 'ntw9_node'                ),
(305,   2, 2, 1, '_Link'                         , 'ntw9_link'                ),
(306, 305, 2, 1, 'InteriorFeatureLink'           , 'ntw9_link'                ),
(307, 305, 2, 1, 'InterFeatureLink'              , 'ntw9_link'                ),
(308, 305, 2, 1, 'NetworkLink'                   , 'ntw9_link'                ),
-- Functional characteristics                                                                        
(309,  23, 3, 1, 'SupplyArea'                    , 'ntw9_supply_area'         ),  -- like CityObjectGroup
(310,   2, 2, 1, 'RoleInNetwork'                 , 'ntw9_role_in_network'     ),
-- Commodity
(311,   2, 2, 1, '_Commodity'                    , 'ntw9_commodity'           ),
(312, 311, 2, 1, 'LiquidMedium'                  , 'ntw9_commodity'           ),
(313, 311, 2, 1, 'GaseousMedium'                 , 'ntw9_commodity'           ),
(314, 311, 2, 1, 'SolidMedium'                   , 'ntw9_commodity'           ),
(315, 311, 2, 1, 'ElectricalMedium'              , 'ntw9_commodity'           ),
(316, 311, 2, 1, 'OpticalMedium'                 , 'ntw9_commodity'           ),
-- Commodity classifier
(317,   2, 2, 1, '_CommodityClassifier'          , 'ntw9_commodity_classifier'),
(318, 317, 2, 1, 'ChemicalClassifier'            , 'ntw9_commodity_classifier'),
(319, 317, 2, 1, 'GHSClassifier'                 , 'ntw9_commodity_classifier'),
(320, 317, 2, 1, 'GenericClassifier'             , 'ntw9_commodity_classifier'),
-- HollowSpace
(321,   2, 2, 1, '_HollowSpace'                  , 'ntw9_hollow_space'        ),
(322, 321, 2, 1, 'HollowSpace'                   , 'ntw9_hollow_space'        ),
(323, 321, 2, 1, 'HollowSpacePart'               , 'ntw9_hollow_space'        ),
-- Material
(324,   2, 2, 1, '_FeatureMaterial'              , 'ntw9_material'            ),
(325, 324, 2, 1, 'InteriorMaterial'              , 'ntw9_material'            ),
(326, 324, 2, 1, 'ExteriorMaterial'              , 'ntw9_material'            ),
(327, 324, 2, 1, 'FillingMaterial'               , 'ntw9_material'            ),
-- Network Feature classes (to be adapted and improved)
-- Protective elements
(328, 301, 3, 1, '_ProtectiveElement'            , 'ntw9_protective_element'  ),
(329, 328, 3, 1, 'Bedding'                       , 'ntw9_protective_element'  ),
(330, 328, 3, 1, '_ProtectionShell'              , 'ntw9_protective_element'  ),
(331, 330, 3, 1, 'RectangularShell'              , 'ntw9_protective_element'  ),
(332, 330, 3, 1, 'RoundShell'                    , 'ntw9_protective_element'  ),
(333, 330, 3, 1, 'OtherShell'                    , 'ntw9_protective_element'  ),
-- Distribution elements
(334, 301, 3, 1, '_DistributionElement'          , 'ntw9_distrib_element'     ),
(335, 334, 3, 1, 'Cable'                         , 'ntw9_distrib_element'     ),
(336, 334, 3, 1, 'Canal'                         , 'ntw9_distrib_element'     ),
(337, 336, 3, 1, 'SemiOpenCanal'                 , 'ntw9_distrib_element'     ),
(338, 336, 3, 1, 'ClosedCanal'                   , 'ntw9_distrib_element'     ),
(339, 334, 3, 1, '_Pipe'                         , 'ntw9_distrib_element'     ),
(340, 339, 3, 1, 'RoundPipe'                     , 'ntw9_distrib_element'     ),
(341, 339, 3, 1, 'RectangularPipe'               , 'ntw9_distrib_element'     ),
(342, 339, 3, 1, 'OtherShapePipe'                , 'ntw9_distrib_element'     ),
-- Other elements
(343, 301, 3, 1, 'SimpleFunctionalElement'       , 'ntw9_network_feature'     ),
(344, 301, 3, 1, 'ComplexFunctionalElement'      , 'ntw9_network_feature'     ),
(345, 301, 3, 1, 'TerminalElement'               , 'ntw9_network_feature'     ),
-- Devices
(346, 301, 3, 1, '_Device'                       , 'ntw9_network_feature'     ),
(347, 346, 3, 1, 'StorageDevice'                 , 'ntw9_network_feature'     ),
(348, 346, 3, 1, 'TechDevice'                    , 'ntw9_network_feature'     ),
(349, 346, 3, 1, 'MeasurementDevice'             , 'ntw9_network_feature'     ),
(350, 346, 3, 1, 'ControllerDevice'              , 'ntw9_network_feature'     ),
(351, 346, 3, 1, 'AnyDevice'                     , 'ntw9_network_feature'     ),
-- MediumSupply
(352,   1, 1, 1, '_MediumSupply'                 , 'ntw9_medium_supply'       ),
(353, 352, 1, 1, 'LiquidMediumSupply'            , 'ntw9_medium_supply'       ),
(354, 352, 1, 1, 'GaseousMediumSupply'           , 'ntw9_medium_supply'       ),
(355, 352, 1, 1, 'SolidMediumSupply'             , 'ntw9_medium_supply'       ),
(356, 352, 1, 1, 'ElectricalMediumSupply'        , 'ntw9_medium_supply'       ),
(357, 352, 1, 1, 'OpticalMediumSupply'           , 'ntw9_medium_supply'       )
;

-- Add entry into table SCHEMA_TO_OBJECTCLASS
WITH r AS (SELECT id FROM citydb.schema WHERE (xml_namespace_uri='_utilitynetworks_ade_placeholder_' AND citygml_version='2.0')
OR (xml_namespace_uri='_utilitynetworks_ade_placeholder_' AND citygml_version='1.0')
),
     s AS (SELECT id FROM citydb.objectclass WHERE id BETWEEN 300 AND 399 ORDER BY id)
INSERT INTO citydb.schema_to_objectclass (schema_id,objectclass_id) SELECT r.id, s.id FROM s,r ORDER BY s.id;

-- Add entries into Lookup tables (Codelists and Enumerations)

-- STILL TO DO


-- ***********************************************************************
-- ***********************************************************************

DO
$$
BEGIN
RAISE NOTICE '

********************************

Utility Network ADE table data installation complete!

********************************

';
END
$$;
SELECT 'Utility Network ADE table data installed correctly!'::varchar AS installation_result;


-- ***********************************************************************
-- ***********************************************************************
--
-- END OF FILE
--
-- ***********************************************************************
-- ***********************************************************************