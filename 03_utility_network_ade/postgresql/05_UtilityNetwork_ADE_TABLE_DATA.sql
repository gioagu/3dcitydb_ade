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
(300,   3, 3, 1, 'Network'                       , 'utn9_network'             ),
(301,   3, 3, 1, 'AbstractNetworkFeature'        , 'utn9_network_feature'     ),
(302,   2, 2, 1, 'NetworkGraph'                  , 'utn9_network_graph'       ),
(303,   2, 2, 1, 'FeatureGraph'                  , 'utn9_feature_graph'       ),
(304,   2, 2, 1, 'Node'                          , 'utn9_node'                ),
(305,   2, 2, 1, 'AbstractLink'                  , 'utn9_link'                ),
(306, 305, 2, 1, 'InteriorFeatureLink'           , 'utn9_link'                ),
(307, 305, 2, 1, 'InterFeatureLink'              , 'utn9_link'                ),
(308, 305, 2, 1, 'NetworkLink'                   , 'utn9_link'                ),
-- Functional characteristics                                                                        
(309,  23, 3, 1, 'SupplyArea'                    , 'cityobjectgroup'          ),  -- like CityObjectGroup
(310,   2, 2, 1, 'RoleInNetwork'                 , 'utn9_role_in_network'     ),
-- Commodity
(311,   2, 2, 1, 'AbstractCommodity'             , 'utn9_commodity'           ),
(312, 311, 2, 1, 'LiquidMedium'                  , 'utn9_commodity'           ),
(313, 311, 2, 1, 'GaseousMedium'                 , 'utn9_commodity'           ),
(314, 311, 2, 1, 'SolidMedium'                   , 'utn9_commodity'           ),
(315, 311, 2, 1, 'ElectricalMedium'              , 'utn9_commodity'           ),
(316, 311, 2, 1, 'OpticalMedium'                 , 'utn9_commodity'           ),
-- Commodity classifier
(317,   2, 2, 1, 'AbstractCommodityClassifier'   , 'utn9_commodity_classifier'),
(318, 317, 2, 1, 'ChemicalClassifier'            , 'utn9_commodity_classifier'),
(319, 317, 2, 1, 'GHSClassifier'                 , 'utn9_commodity_classifier'),
(320, 317, 2, 1, 'GenericClassifier'             , 'utn9_commodity_classifier'),
-- HollowSpace
(321,   2, 2, 1, '_HollowSpace'                  , 'utn9_hollow_space'        ),
(322, 321, 2, 1, 'HollowSpace'                   , 'utn9_hollow_space'        ),
(323, 321, 2, 1, 'HollowSpacePart'               , 'utn9_hollow_space'        ),
-- Material
(324,   2, 2, 1, 'AbstractFeatureMaterial'       , 'utn9_material'            ),
(325, 324, 2, 1, 'InteriorMaterial'              , 'utn9_material'            ),
(326, 324, 2, 1, 'ExteriorMaterial'              , 'utn9_material'            ),
(327, 324, 2, 1, 'FillingMaterial'               , 'utn9_material'            ),
-- Network Feature classes
-- Protective elements
(328, 301, 3, 1, 'AbstractProtectiveElement'     , 'utn9_protective_element'  ),
(329, 328, 3, 1, 'Bedding'                       , 'utn9_protective_element'  ),
(330, 328, 3, 1, 'AbstractProtectionShell'       , 'utn9_protective_element'  ),
(331, 330, 3, 1, 'RectangularShell'              , 'utn9_protective_element'  ),
(332, 330, 3, 1, 'RoundShell'                    , 'utn9_protective_element'  ),
(333, 330, 3, 1, 'OtherShell'                    , 'utn9_protective_element'  ),
-- Distribution elements
(334, 301, 3, 1, 'AbstractDistributionElement'   , 'utn9_distrib_element'     ),
(335, 334, 3, 1, 'Cable'                         , 'utn9_distrib_element'     ),
(336, 334, 3, 1, 'Canal'                         , 'utn9_distrib_element'     ),
(337, 336, 3, 1, 'SemiOpenCanal'                 , 'utn9_distrib_element'     ),
(338, 336, 3, 1, 'ClosedCanal'                   , 'utn9_distrib_element'     ),
(339, 334, 3, 1, 'AbstractPipe'                  , 'utn9_distrib_element'     ),
(340, 339, 3, 1, 'RoundPipe'                     , 'utn9_distrib_element'     ),
(341, 339, 3, 1, 'RectangularPipe'               , 'utn9_distrib_element'     ),
(342, 339, 3, 1, 'OtherShapePipe'                , 'utn9_distrib_element'     ),
-- Other elements
(343, 301, 3, 1, 'SimpleFunctionalElement'       , 'utn9_network_feature'     ),
(344, 301, 3, 1, 'ComplexFunctionalElement'      , 'utn9_network_feature'     ),
(345, 301, 3, 1, 'TerminalElement'               , 'utn9_network_feature'     ),
-- Devices
(346, 301, 3, 1, 'AbstractDevice'                , 'utn9_network_feature'     ),
(347, 346, 3, 1, 'StorageDevice'                 , 'utn9_network_feature'     ),
(348, 346, 3, 1, 'TechDevice'                    , 'utn9_network_feature'     ),
(349, 346, 3, 1, 'MeasurementDevice'             , 'utn9_network_feature'     ),
(350, 346, 3, 1, 'ControllerDevice'              , 'utn9_network_feature'     ),
(351, 346, 3, 1, 'AnyDevice'                     , 'utn9_network_feature'     ),
-- MediumSupply
(352,   1, 1, 1, 'AbstractMediumSupply'          , 'utn_medium_supply'       ),
(353, 352, 1, 1, 'LiquidMediumSupply'            , 'utn_medium_supply'       ),
(354, 352, 1, 1, 'GaseousMediumSupply'           , 'utn_medium_supply'       ),
(355, 352, 1, 1, 'SolidMediumSupply'             , 'utn_medium_supply'       ),
(356, 352, 1, 1, 'ElectricalMediumSupply'        , 'utn_medium_supply'       ),
(357, 352, 1, 1, 'OpticalMediumSupply'           , 'utn_medium_supply'       )
;

-- Add entry into table SCHEMA_TO_OBJECTCLASS
WITH r AS (SELECT id FROM citydb.schema WHERE (xml_namespace_uri='_utilitynetworks_ade_placeholder_' AND citygml_version='2.0')
OR (xml_namespace_uri='_utilitynetworks_ade_placeholder_' AND citygml_version='1.0')
),
     s AS (SELECT id FROM citydb.objectclass WHERE id BETWEEN 300 AND 399 ORDER BY id)
INSERT INTO citydb.schema_to_objectclass (schema_id,objectclass_id) SELECT r.id, s.id FROM s,r ORDER BY s.id;

-- Add entries into Lookup tables (Codelists and Enumerations)

INSERT INTO citydb.utn9_lu_network_class
(id, name, name_codespace, description)
VALUES
('HighVoltageNetwork'   ,'High-voltage Network'   , NULL, NULL),
('MediumVoltageNetwork' ,'Medium-voltage Network' , NULL, NULL),
('LowVoltageNetwork'    ,'Low-voltage Network'    , NULL, NULL),
('HighPressureNetwork'  ,'High-pressure Network'  , NULL, NULL),
('MediumPressureNetwork','Medium-pressure Network', NULL, NULL),
('LowPressureNetwork'   ,'Low-pressure Network'   , NULL, NULL)
;

INSERT INTO citydb.utn9_lu_network_function
(id, name, name_codespace, description)
VALUES
('supply'       ,'Supply'       , NULL, NULL),
('disposal'     ,'Disposal'     , NULL, NULL),
('communication','Communication', NULL, NULL)
;

INSERT INTO citydb.utn9_lu_network_feature_class
(objectclass_id, id, name, name_codespace, description)
VALUES
-- AbstractDistributionElement
(334, 'unknown'         ,'Unknown'                     , NULL, NULL),
(334, 'mainLine'        ,'Main line'                   , NULL, NULL),
(334, 'transportLine'   ,'Transport line'              , NULL, NULL),
(334, 'supplyLine'      ,'Supply line'                 , NULL, NULL),
(334, 'houseServiceLine','House-service line'          , NULL, NULL),
-- ComplexFunctionalElement
(344, 'unknown'       ,'Unknown'                       , NULL, NULL),
(344, 'station'       ,'Station'                       , NULL, NULL),
(344, 'structure'     ,'Structure'                     , NULL, NULL),
(344, 'factory'       ,'Factory'                       , NULL, NULL),
(344, 'waterWork'     ,'Waterwork'                     , NULL, NULL),
(344, 'treatmentPlant','Treatment plant'               , NULL, NULL),
(344, 'heatingPlant'  ,'Heating plant'                 , NULL, NULL),
(344, 'powerPlant'    ,'Power plant'                   , NULL, NULL),
(344, 'pumpingStation','Pumping station'               , NULL, NULL),
-- SimpleFunctionalElement
(343, 'unknown'         ,'Unknown'                     , NULL, NULL),
(343, 'manhole'         ,'Manhole'                     , NULL, NULL),
(343, 'invertedSyphon'  ,'Inverted syphon'             , NULL, NULL),
(343, 'transformer'     ,'Transformer'                 , NULL, NULL),
(343, 'voltageRegulator','Voltage regulator'           , NULL, NULL),
(343, 'teeFitting'      ,'Tee-fitting'                 , NULL, NULL),
(343, 'crossFitting'    ,'Cross-fitting'               , NULL, NULL),
(343, 'tap'             ,'Tap'                         , NULL, NULL),
-- TerminalElement
(345, 'unknown'    ,'Unknown'                          , NULL, NULL),
(345, 'lamp'       ,'Lamp'                             , NULL, NULL),
(345, 'cock'       ,'Cock'                             , NULL, NULL),
(345, 'streetLight','Streetlight'                      , NULL, NULL),
(345, 'hydrant'    ,'Hydrant'                          , NULL, NULL),
-- StorageDevice
(347, 'unknown'     ,'Unknown'                         , NULL, NULL),
(347, 'storageBasin','Storage basin'                   , NULL, NULL),
(347, 'battery'     ,'Battery'                         , NULL, NULL),
(347, 'tank'        ,'Tank'                            , NULL, NULL),
(347, 'cistern'     ,'Cistern'                         , NULL, NULL),
-- TechDevice
(348, 'unknown'   ,'Unknown'                           , NULL, NULL),
(348, 'pump'      ,'Pump'                              , NULL, NULL),
(348, 'slideValve','SlideValve'                        , NULL, NULL),
(348, 'generator' ,'Generator'                         , NULL, NULL),
(348, 'valve'     ,'Valve'                             , NULL, NULL),
(348, 'turbine'   ,'Turbine'                           , NULL, NULL),
-- MeasurementDevice
(349, 'unknown'          ,'Unknown'                    , NULL, NULL),
(349, 'anode'            ,'Anode'                      , NULL, NULL),
(349, 'corrosionDetector','Corrosion detector'         , NULL, NULL),
(349, 'pressureSensor'   ,'Pressure sensor'            , NULL, NULL),
(349, 'meter'            ,'Meter'                      , NULL, NULL),
-- ControllerDevice
(350, 'unknown'   ,'Unknown'                           , NULL, NULL),
(350, 'switch'    ,'Switch'                            , NULL, NULL),
(350, 'valve'     ,'Valve'                             , NULL, NULL),
(350, 'slideValve','Slide valve'                       , NULL, NULL),
-- AnyDevice
(351, 'unknown' ,'Unknown'                             , NULL, NULL),
(351, 'flange'  ,'Flange'                              , NULL, NULL),
(351, 'coupling','Coupling'                            , NULL, NULL),
(351, 'adapter' ,'Adapter'                             , NULL, NULL)
;

INSERT INTO citydb.utn9_lu_network_feature_function
(id, name, name_codespace, description)
VALUES
('feeding'     ,'Feeding'      ,NULL, NULL),
('draining'    ,'Draining'     ,NULL, NULL),
('distribution','Distribution' ,NULL, NULL),
('storage'     ,'Storage'      ,NULL, NULL),
('venting'     ,'Venting'      ,NULL, NULL),
('abstraction' ,'Abstraction'  ,NULL, NULL),
('measurement' ,'Measurement'  ,NULL, NULL),
('shortCircuit','Short circuit',NULL, NULL),
('branch'      ,'Branch'       ,NULL, NULL),
('observer'    ,'Observer'     ,NULL, NULL),
('protection'  ,'Protection'   ,NULL, NULL),
('control'     ,'Control'      ,NULL, NULL),
('shutOff'     ,'ShutOff'      ,NULL, NULL),
('unknown'     ,'Unknown'      ,NULL, NULL)
;

INSERT INTO citydb.utn9_lu_spatial_quality
(id, name, name_codespace, description)
VALUES
('unknown'     ,'Unknown'     , NULL, NULL),
('surveyed'    ,'Surveyed'    , NULL, NULL),
('calculated'  ,'Calculated'  , NULL, NULL),
('interpolated','Interpolated', NULL, NULL),
('estimated'   ,'Estimated'   , NULL, NULL),
('assumed'     ,'Assumed'     , NULL, NULL)
;

INSERT INTO citydb.utn9_lu_material
(id, name, name_codespace, description)
VALUES
('unknown'              ,'Unknown'                , NULL, NULL),
('steel'                ,'Steel'                  , NULL, NULL),
('stoneware'            ,'Stoneware'              , NULL, NULL),
('PE'                   ,'PE'                     , NULL, NULL),
('casting'              ,'Casting'                , NULL, NULL),
('iron'                 ,'Iron'                   , NULL, NULL),
('concrete'             ,'Concrete'               , NULL, NULL),
('brick'                ,'Brick'                  , NULL, NULL),
('glass'                ,'Glass'                  , NULL, NULL),
('copper'               ,'Copper'                 , NULL, NULL),
('rubber'               ,'Rubber'                 , NULL, NULL),
('polymericOpticalFibre','Polymeric optical fibre', NULL, NULL),
('quartzSilica'         ,'Quartz silica'          , NULL, NULL),
('air'                  ,'Air'                    , NULL, NULL),
('carbon'               ,'Carbon'                 , NULL, NULL),
('sand'                 ,'Sand'                   , NULL, NULL)
;

INSERT INTO citydb.utn9_lu_status
(id, name, name_codespace, description)
VALUES
('inUse'           ,'In use'                    , NULL, NULL),
('tempOutOfService','Temporarily out of service', NULL, NULL),
('outOfService'    ,'Out of service'            , NULL, NULL),
('destroyed'       ,'Destroyed'                 , NULL, NULL),
('unknown'         ,'Unknown'                   , NULL, NULL)
;

INSERT INTO citydb.utn9_lu_medium_supply
(objectclass_id, id, name, name_codespace, description)
VALUES
-- ElectricalMedium
(315,'unknown'                      ,'Unknown'                         , NULL, NULL),
(315,'directCurrent'                ,'Direct current'                  , NULL, NULL),
(315,'singlePhaseAlternatingCurrent','Single-phase alternating current', NULL, NULL),
(315,'threePhaseAlternatingCurrent' ,'Three-phase alternating current' , NULL, NULL),
(315,'undulatoryCurrent'            ,'Undulatory current'              , NULL, NULL),
(315,'telephone'                    ,'Telephone'                       , NULL, NULL),
-- GaseousMedium
(313,'unknown'     ,'Unknown'                                          , NULL, NULL),
(313,'naturalGas'  ,'Natural gas'                                      , NULL, NULL),
(313,'petroleumGas','Petroleum gas'                                    , NULL, NULL),
(313,'helium'      ,'Helium'                                           , NULL, NULL),
(313,'air'         ,'Air'                                              , NULL, NULL),
(313,'dioxygen'    ,'Dioxygen'                                         , NULL, NULL),
(313,'nitrogen'    ,'Nitrogen'                                         , NULL, NULL),
(313,'hydrogen'    ,'Hydrogen'                                         , NULL, NULL),
(313,'carbon'      ,'Carbon'                                           , NULL, NULL),
-- LiquidMedium
(312,'unknown'             ,'Unknown'                                  , NULL, NULL),
(312,'freshWater'          ,'Freshwater'                               , NULL, NULL),
(312,'stormWater'          ,'Stormwater'                               , NULL, NULL),
(312,'wasteWater'          ,'Wastewater'                               , NULL, NULL),
(312,'districtHeatingWater','District-heating water'                   , NULL, NULL),
(312,'petrol'              ,'Petrol'                                   , NULL, NULL),
(312,'oil'                 ,'Oil'                                      , NULL, NULL),
(312,'gasohol'             ,'Gasohol'                                  , NULL, NULL),
(312,'acid'                ,'Acid'                                     , NULL, NULL),
(312,'kerosine'            ,'Kerosine'                                 , NULL, NULL),
(312,'liquidPG'            ,'Liquid propane gas'                       , NULL, NULL),
-- OpticalMedium
(316,'unknown','Unknown'                                               , NULL, NULL),
(316,'light'  ,'Light'                                                 , NULL, NULL),
-- SolidMedium
(314,'unknown'   ,'Unknown'                                            , NULL, NULL),
(314,'carbonDust','Carbon dust'                                        , NULL, NULL),
(314,'stone'     ,'Stone'                                              , NULL, NULL),
(314,'ore'       ,'Ore'                                                , NULL, NULL),
(314,'sand'      ,'Sand'                                               , NULL, NULL)
;

INSERT INTO citydb.utn9_lu_function_of_line
(id, name, name_codespace, description)
VALUES
('unknown'       ,'unknown'        , NULL, NULL),
('coolingLine'   ,'Cooling line'   , NULL, NULL),
('constantLine'  ,'Constant line'  , NULL, NULL),
('flowLine'      ,'Flow line'      , NULL, NULL),
('returnLine'    ,'Return line'    , NULL, NULL),
('steamLine'     ,'Steam line'     , NULL, NULL),
('condensateLine','Condensate line', NULL, NULL)
;

INSERT INTO citydb.utn9_lu_signal_word
(id, name, name_codespace, description)
VALUES
('unknown'     ,'Unknown'      , NULL, NULL),
('nonHazardous','Non hazardous', NULL, NULL),
('attention'   ,'Attention'    , NULL, NULL),
('hazardous'   ,'Hazardous'    , NULL, NULL)
;

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