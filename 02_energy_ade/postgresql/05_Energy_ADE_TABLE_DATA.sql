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
-- ***************** 05_Energy_ADE_TABLE_DATA.sql ************************
--
-- This script add entries to the ADE, SCHEMA, OBJECTCLASS and
-- SCHEMA_TO_OBJECTCLASS tables.
--
-- ***********************************************************************
-- ***********************************************************************

-- TO DO: Rewrite using non-fixed IDs
-- FOR THE TIME BEING, we keep the ids of the new classes fixed. In near future, they will be
-- assigned automatically, starting after the last assigned id in the OBJECTCLASS table.
-- In any case, all other database objects (views, stored procedures, triggers, etc.)
-- are already able to deal with non-fixed IDs

-- Add entry into table ADE
DELETE FROM citydb.ade WHERE db_prefix='nrg8'; 
INSERT INTO citydb.ade (name, description, version, db_prefix)
VALUES
('Energy ADE', 'Energy Application Domain Extension v. 0.8', '0.8', 'nrg8');

-- Add entry into table SCHEMA
WITH a AS (SELECT id FROM citydb.ade WHERE db_prefix='nrg8')
INSERT INTO citydb.schema
(ade_id, is_ade_root, citygml_version, xml_namespace_prefix, xml_namespace_uri, xml_schema_location)
SELECT
a.id, 1, '2.0','energy', 'http://www.sig3d.org/citygml/2.0/energy/0.8.0','http://www.sig3d.org/citygml/2.0/energy/0.8.0/EnergyADE_0_8_0.xsd'
FROM a;

-- Add entry into table SCHEMA_REFERENCING
WITH nrg AS (SELECT id FROM citydb.schema WHERE xml_namespace_uri='http://www.sig3d.org/citygml/2.0/energy/0.8.0' AND citygml_version='2.0'),
     c AS (SELECT id FROM citydb.schema WHERE xml_namespace_uri='http://schemas.opengis.net/citygml/2.0')
INSERT INTO citydb.schema_referencing (referenced_id, referencing_id) 
SELECT c.id,nrg.id FROM nrg,c;

-- Add entries into table OBJECTCLASS
DELETE FROM citydb.objectclass WHERE id BETWEEN 200 AND 299;
INSERT INTO citydb.objectclass (id, classname, superclass_id, tablename, is_ade_class, baseclass_id) VALUES
(200,'_Type',1, NULL, 1, 1),
-- Time series
(201,'_TimeSeries',200, 'nrg8_timeseries', 1, 1),
(202,'RegularTimeSeries',201, 'nrg8_timeseries', 1, 1),
(203,'IrregularTimeSeries',201, 'nrg8_timeseries', 1, 1),
(204,'RegularTimeSeriesFile',201, 'nrg8_timeseries_file', 1, 1),
(205,'IrregularTimeSeriesFile',201, 'nrg8_timeseries_file', 1, 1),
-- Schedules
(206,'_Schedule',200, 'nrg8_schedule', 1, 1),
(207,'ConstantValueSchedule',206, 'nrg8_schedule', 1, 1),
(208,'DualValueSchedule',206, 'nrg8_schedule', 1, 1),
(209,'DailyPatternSchedule',206, 'nrg8_schedule', 1, 1),
(210,'TimeSeriesSchedule',206, 'nrg8_schedule', 1, 1),
(255,'PeriodOfYear',1, 'nrg8_period_of_year', 1, 1),
(256,'DailySchedule',1, 'nrg8_daily_schedule', 1, 1),
-- Construction & Materials Module
(211,'_Construction',2, 'nrg8_construction', 1,2),
(212,'Construction',211, 'nrg8_construction', 1,2),
(213,'ReverseConstruction',211, 'nrg8_construction', 1,2),
(214,'Layer',2, 'nrg8_layer', 1,2),
(215,'LayerComponent',2, 'nrg8_layer_component', 1,2),
(216,'_Material',2, 'nrg8_material', 1,2),
(217,'Gas',216, 'nrg8_material', 1,2),
(218,'SolidMaterial',216, 'nrg8_material', 1,2),
-- Building physics Module
(219,'WeatherStation',3, 'nrg8_weather_station', 1,3),
(220,'WeatherData',2, 'nrg8_weather_data', 1, 1),
(221,'ThermalZone',3, 'nrg8_thermal_zone', 1,3),
(222,'ThermalBoundary',3, 'nrg8_thermal_boundary', 1,3),
(223,'ThermalOpening',3, 'nrg8_thermal_opening', 1,3),
-- Occupancy Module
(224,'UsageZone',3, 'nrg8_usage_zone', 1,3),
(225,'BuildingUnit',3, 'nrg8_building_unit', 1,3),
(226,'_Facilities',3, 'nrg8_facilities', 1,3),
(227,'DHWFacilities',226, 'nrg8_facilities', 1,3),
(228,'ElectricalAppliances',226, 'nrg8_facilities', 1,3),
(229,'LightingFacilities',226, 'nrg8_facilities', 1,3),
(230,'Occupants',2, 'nrg8_occupants', 1,2),
(231,'Household',2, 'nrg8_households', 1,2),
-- Energy System Module
(232,'EnergyDemand',2, 'nrg8_energy_demand', 1,2),
(233,'FinalEnergy',2, 'nrg8_final_energy', 1,2),
(234,'SystemOperation',2, 'nrg8_system_operation', 1,2),
(235,'_StorageSystem',3, 'nrg8_storage_system', 1,3),
(236,'ThermalStorageSystem',235, 'nrg8_thermal_storage_system', 1,3),
(237,'PowerStorageSystem',235, 'nrg8_power_storage_system', 1,3),
(238,'DistributionSystem',3, 'nrg8_distrib_system', 1,3),
(239,'ThermalDistributionSystem',238, 'nrg8_thermal_distrib_system', 1,3),
(240,'PowerDistributionSystem',238, 'nrg8_power_distrib_system', 1,3),
(241,'Emitter',3, 'nrg8_emitter', 1,3),
(242,'EnergyConversionSystem',3, 'nrg8_conv_system', 1,3),
(243,'_SolarEnergySystem',242, 'nrg8_solar_system', 1,3),
(244,'SolarThermalSystem',243, 'nrg8_solar_system', 1,3),
(245,'PhotovoltaicSystem',243, 'nrg8_solar_system', 1,3),
(246,'PhotovoltaicThermalSystem',243, 'nrg8_solar_system', 1,3),
(247,'Boiler',242, 'nrg8_boiler', 1,3),
(248,'ElectricalResistance',242, 'nrg8_conv_system', 1,3),
(249,'HeatPump',242, 'nrg8_heat_pump', 1,3),
(250,'CombinedHeatPower',242, 'nrg8_combined_heat_power', 1,3),
(251,'HeatExchanger',242, 'nrg8_heat_exchanger', 1,3),
(252,'MechanicalVentilation',242, 'nrg8_mech_ventilation', 1,3),
(253,'Chiller',242, 'nrg8_chiller', 1,3),
(254,'AirCompressor',242, 'nrg8_air_compressor', 1,3),
-- DataTypes
(257,'FloorArea',1, 'nrg8_dimensional_attrib', 1, 1),
(258,'VolumeType',1, 'nrg8_dimensional_attrib', 1, 1),
(259,'HeightAboveGround',1, 'nrg8_dimensional_attrib', 1, 1),
(260,'RefurbishmentMeasure',1, 'nrg8_refurbishment_measure', 1, 1),
(261,'Reflectance',1, 'nrg8_optical_properties', 1, 1),
(262,'Emissivity',1, 'nrg8_optical_properties', 1, 1),
(263,'Transmittance',1, 'nrg8_optical_properties', 1, 1)
;

-- Add entry into table SCHEMA_TO_OBJECTCLASS
WITH r AS (SELECT id FROM citydb.schema WHERE (xml_namespace_uri='http://www.sig3d.org/citygml/2.0/energy/0.8.0' AND citygml_version='2.0')
OR (xml_namespace_uri='http://www.sig3d.org/citygml/1.0/energy/0.8.0' AND citygml_version='1.0')
),
     s AS (SELECT id FROM citydb.objectclass WHERE id BETWEEN 200 AND 299 ORDER BY id)
INSERT INTO citydb.schema_to_objectclass (schema_id,objectclass_id) SELECT r.id, s.id FROM s,r ORDER BY s.id;


-- Add entries into Lookup tables (Codelists and Enumerations)

-- Add entry into table LU_INTERPOLATION
TRUNCATE citydb.nrg8_lu_interpolation CASCADE;
INSERT INTO citydb.nrg8_lu_interpolation
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
TRUNCATE citydb.nrg8_lu_acquisition_method CASCADE;
INSERT INTO citydb.nrg8_lu_acquisition_method
(id, name, name_codespace, description)
VALUES
('Measurement',          'Measurement',           NULL, NULL),
('Simulation',           'Simulation',            NULL, NULL),
('CalibratedSimulation', 'Calibrated simulation', NULL, NULL),
('Estimation',           'Estimation',            NULL, NULL),
('Unknown',              'Unknown',               NULL, NULL)
;

-- Add entry into table LU_DAY
TRUNCATE citydb.nrg8_lu_day CASCADE;
INSERT INTO citydb.nrg8_lu_day
(id, name, name_codespace, description)
VALUES
('Monday',     'Monday',      NULL, NULL),
('Tuesday',    'Tuesday',     NULL, NULL),
('Wednesday',  'Wednesday',   NULL, NULL),
('Thursday',   'Thursday',    NULL, NULL),
('Friday',     'Friday',      NULL, NULL),
('Saturday',   'Saturday',    NULL, NULL),
('Sunday',     'Sunday',      NULL, NULL),
('DesignDay',  'Design day',  NULL, NULL),
('WeekDay',    'Weekday',     NULL, NULL),
('WeekEnd',    'Weekend',     NULL, NULL),
('TypicalDay', 'Typical day', NULL, NULL)
;

-- Add entry into table LU_SURFACE_SIDE
TRUNCATE citydb.nrg8_lu_surface_side CASCADE;
INSERT INTO citydb.nrg8_lu_surface_side
(id, name, name_codespace, description)
VALUES
('Inside',  'Inside',  NULL, NULL),
('Outside', 'Outside', NULL, NULL)
;

-- Add entry into table LU_WAVELENGTH_RANGE
TRUNCATE citydb.nrg8_lu_wavelength_range CASCADE;
INSERT INTO citydb.nrg8_lu_wavelength_range
(id, name, name_codespace, description)
VALUES
('Infrared', 'Infrared', NULL, NULL),
('Solar',    'Solar',    NULL, NULL),
('Total',    'Total',    NULL, NULL),
('Visible',  'Visible',  NULL, NULL)
;

-- Add entry into table LU_DIMENSIONAL_ATTRIB
TRUNCATE citydb.nrg8_lu_dimensional_attrib CASCADE;
INSERT INTO citydb.nrg8_lu_dimensional_attrib 
(objectclass_id, id, name, name_codespace, description)
VALUES
( 257, 'NetFloorArea'            , 'Net floor area',               NULL, NULL),
( 257, 'GrossFloorArea'          , 'Gross floor area',             NULL, NULL),
( 257, 'EnergyReferenceArea'     , 'Energy reference area',        NULL, NULL),
( 258, 'NetVolume'               , 'Net volume',                   NULL, NULL),
( 258, 'GrossVolume'             , 'Gross volume',                 NULL, NULL),
( 258, 'EnergyReferenceVolume'   , 'Energy reference volume',      NULL, NULL),
( 259, 'BottomOfConstruction'    , 'Bottom of construction',       NULL, NULL),
( 259, 'EntrancePoint'           , 'Entrance point',               NULL, NULL),
( 259, 'GeneralEave'             , 'General eave',                 NULL, NULL),
( 259, 'GeneralRoof'             , 'General roof',                 NULL, NULL),
( 259, 'GeneralRoofEdge'         , 'General roof edge',            NULL, NULL),
( 259, 'HighestEave'             , 'Highest eave',                 NULL, NULL),
( 259, 'HighestPoint'            , 'Highest point',                NULL, NULL),
( 259, 'HighestRoofEdge'         , 'Highest roof edge',            NULL, NULL),
( 259, 'LowestEave'              , 'Lowest eave',                  NULL, NULL),
( 259, 'LowestFloorAboveGround'  , 'Lowest floor above ground',    NULL, NULL),
( 259, 'LowestRoofEdge'          , 'Lowest roof edge',             NULL, NULL),
( 259, 'TopOfConstruction'       , 'Top of construction',          NULL, NULL),
( 259, 'TopThermalBoundary'      , 'Top thermal boundary',         NULL, NULL),
( 259, 'BottomThermalBoundary'   , 'Bottom thermal boundary',      NULL, NULL)
;

--Add entry into table LU_REFURBISHMENT_CLASS
TRUNCATE citydb.nrg8_lu_refurbishment_class CASCADE;
INSERT INTO citydb.nrg8_lu_refurbishment_class 
(id, name, name_codespace, description)
VALUES
('UsualRefurbishment',    'Usual refurbishment',    NULL, NULL),
('AdvancedRefurbishment', 'Advanced refurbishment', NULL, NULL)
;

-- Add entry into table LU_CONSTRUCTION_WEIGHT
TRUNCATE citydb.nrg8_lu_construction_weight CASCADE;
INSERT INTO citydb.nrg8_lu_construction_weight
(id, name, name_codespace, description)
VALUES
('VeryLight', 'Very light', NULL, NULL),
('Light',     'Light',      NULL, NULL),
('Medium',    'Medium',     NULL, NULL),
('Heavy',     'Heavy',      NULL, NULL)
;

-- Add entry into table LU_WEATHER_DATA
TRUNCATE citydb.nrg8_lu_weather_data CASCADE;
INSERT INTO citydb.nrg8_lu_weather_data
(id, name, name_codespace, description)
VALUES
('AirTemperature',               'Air temperature',                NULL, NULL),
('Humidity',                     'Humidity',                       NULL, NULL),
('WindSpeed',                    'Wind speed',                     NULL, NULL),
('Cloudiness',                   'Cloudiness',                     NULL, NULL),
('GlobalSolarIrradiance',        'Global solar irradiance',        NULL, NULL),
('DirectSolarIrradiance',        'Direct solar irradiance',        NULL, NULL),
('DiffuseSolarIrradiance',       'Diffuse solar irradiance',       NULL, NULL),
('TerrestrialEmission',          'Terrestrial emission',           NULL, NULL),
('DownwardTerrestrialRadiation', 'Downward terrestrial radiation', NULL, NULL),
('DaylightIlluminance',          'Daylight illuminance',           NULL, NULL)
;

-- Add entry into table LU_THERMAL_BOUNDARY
TRUNCATE citydb.nrg8_lu_thermal_boundary CASCADE;
INSERT INTO citydb.nrg8_lu_thermal_boundary
(id, name, name_codespace, description)
VALUES
('InteriorWall',      'Interior wall',      NULL, NULL),
('IntermediaryFloor', 'Intermediary floor', NULL, NULL),
('SharedWall',        'Shared wall',        NULL, NULL),
('OuterWall',         'Outer wall',         NULL, NULL),
('GroundSlab',        'Ground slab',        NULL, NULL),
('BasementCeiling',   'Basement ceiling',   NULL, NULL),
('AtticFloor',        'Attic floor',        NULL, NULL),
('Roof',              'Roof',               NULL, NULL)
;

-- Add entry into table LU_HOUSEHOLD
TRUNCATE citydb.nrg8_lu_household CASCADE;
INSERT INTO citydb.nrg8_lu_household
(id, name, name_codespace, description)
VALUES
('LoneAdult',       'Lone adult',          NULL, NULL),
('MultiFamily',     'Multi-family',        NULL, NULL),
('OneFamily',       'One family',          NULL, NULL),
('PensionerCouple', 'Pensioners'' couple', NULL, NULL),
('UnrelatedAdults', 'Unrelated adults',    NULL, NULL),
('Vacant',          'Vacant',              NULL, NULL),
('WorkerCouple',    'Workers'' Couple',    NULL, NULL)
;

-- Add entry into table LU_OCCUPANTS
TRUNCATE citydb.nrg8_lu_occupants CASCADE;
INSERT INTO citydb.nrg8_lu_occupants
(id, name, name_codespace, description)
VALUES
('OthersOrCombination', 'Others or Combination', NULL, NULL),
('Patients',            'Patients',              NULL, NULL),
('Residents',           'Residents',             NULL, NULL),
('Students',            'Students',              NULL, NULL),
('Visitors',            'Visitors',              NULL, NULL),
('Workers',             'Workers',               NULL, NULL)
;

-- Add entry into table LU_OWNERSHIP
TRUNCATE citydb.nrg8_lu_ownership CASCADE;
INSERT INTO citydb.nrg8_lu_ownership
(id, name, name_codespace, description)
VALUES
('Corporation',               'Corporation',               NULL, NULL),
('Government',                'Government',                NULL, NULL),
('NonOccupantPrivateOwner',   'Non-occupant private owner',   NULL, NULL),
('NonProfitOrganisation',     'Non-profit organisation',     NULL, NULL),
('OccupantPrivateOwner',      'Occupant private owner',      NULL, NULL),
('OtherOrCombination',        'Other or combination',        NULL, NULL),
('PropertyManagementCompany', 'Property-management company', NULL, NULL)
;

-- Add entry into table LU_RESIDENCE
TRUNCATE citydb.nrg8_lu_residence CASCADE;
INSERT INTO citydb.nrg8_lu_residence
(id, name, name_codespace, description)
VALUES
('MainResidence',      'Main residence',      NULL, NULL),
('SecondaryResidence', 'Secondary residence', NULL, NULL),
('Vacant',             'Vacant',              NULL, NULL)
;

-- Add entry into table LU_END_USE
TRUNCATE citydb.nrg8_lu_end_use CASCADE;
INSERT INTO citydb.nrg8_lu_end_use
(id, name, name_codespace, description)
VALUES
('Cooking',              'Cooking',               NULL, NULL),
('DomesticHotWater',     'Domestic hot water',    NULL, NULL),
('ElectricalAppliances', 'Electrical appliances', NULL, NULL),
('Lighting',             'Lighting',              NULL, NULL),
('OtherOrCombination',   'Other or combination',  NULL, NULL),
('SpaceCooling',         'Space cooling',         NULL, NULL),
('SpaceHeating',         'Space heating',         NULL, NULL),
('Ventilation',          'Ventilation',           NULL, NULL),
('Process',              'Process',               NULL, NULL)
;

-- Add entry into table LU_DISTRIBUTION
TRUNCATE citydb.nrg8_lu_distribution CASCADE;
INSERT INTO citydb.nrg8_lu_distribution
(id, name, name_codespace, description)
VALUES
('Building',         'Building',           NULL, NULL),
('Dwelling',         'Dwelling',           NULL, NULL),
('GroupOfBuildings', 'Group of buildings', NULL, NULL),
('Room',             'Room',               NULL, NULL),
('Staircase',        'Staircase',          NULL, NULL),
('Storey',           'Storey',             NULL, NULL)
;

-- Add entry into table LU_MEDIUM
TRUNCATE citydb.nrg8_lu_medium CASCADE;
INSERT INTO citydb.nrg8_lu_medium
(id, name, name_codespace, description)
VALUES
('Air',   'Air',   NULL, NULL),
('Steam', 'Steam', NULL, NULL),
('Water', 'Water', NULL, NULL)
;

-- Add entry into table LU_HEAT_SOURCE
TRUNCATE citydb.nrg8_lu_heat_source CASCADE;
INSERT INTO citydb.nrg8_lu_heat_source
(id, name, name_codespace, description)
VALUES
('AmbientAir',                'Ambient air',                 NULL, NULL),
('Aquifer',                   'Aquifer',                     NULL, NULL),
('ExhaustAir',                'Exhaust air',                 NULL, NULL),
('HorizontalGroundCollector', 'Horizontal ground collector', NULL, NULL),
('VerticalGroundCollector',   'Vertical ground collector',   NULL, NULL)
;

-- Add entry into table LU_CELL
TRUNCATE citydb.nrg8_lu_cell CASCADE;
INSERT INTO citydb.nrg8_lu_cell
(id, name, name_codespace, description)
VALUES
('Monocrystalline', 'Monocrystalline', NULL, NULL),
('Polycrystalline', 'Polycrystalline', NULL, NULL),
('Amorphous',       'Amorphous',       NULL, NULL)
;

-- Add entry into table LU_COLLECTOR
TRUNCATE citydb.nrg8_lu_collector CASCADE;
INSERT INTO citydb.nrg8_lu_collector
(id, name, name_codespace, description)
VALUES
('FlatPanelCollector',     'Flat panel collector',    NULL, NULL),
('EvacuatedTubeCollector', 'Evacuated tube collector', NULL, NULL)
;

-- Add entry into table LU_EMITTER
TRUNCATE citydb.nrg8_lu_emitter CASCADE;
INSERT INTO citydb.nrg8_lu_emitter
(id, name, name_codespace, description)
VALUES
('Radiator',          'Radiator',             NULL, NULL),
('Convector',         'Convector',            NULL, NULL),
('RadiantFloor',      'Radiant floor',        NULL, NULL),
('RadiantCeiling',    'Radiant ceiling',      NULL, NULL),
('RadiantWall',       'Radiant wall',         NULL, NULL),
('SplitUnit',         'Split unit',           NULL, NULL),
('2PipesFanCoilUnit', '2-pipes fancoil unit', NULL, NULL),
('4PipesFanCoilUnit', '4-pipes fancoil unit', NULL, NULL)
;

-- Add entry into table LU_COMPRESSOR
TRUNCATE citydb.nrg8_lu_compressor CASCADE;
INSERT INTO citydb.nrg8_lu_compressor
(id, name, name_codespace, description)
VALUES
('ReciprocatingCompressorHermetic',     'Reciprocating compressor hermetic',      NULL, NULL),
('ReciprocatingCompressorSemiHermetic', 'Reciprocating compressor semi-hermetic', NULL, NULL),
('ReciprocatingCompressorOpen',         'Reciprocating compressor open',          NULL, NULL),
('RotaryVaneCompressor',                'Rotary vane compressor',                 NULL, NULL),
('ScrollCompressor',                    'Scroll compressor',                      NULL, NULL),
('ScrewCompressor',                     'Screw compressor',                       NULL, NULL),
('CentrifugalCompressor',               'Centrifugal compressor',                 NULL, NULL)
;

-- Add entry into table LU_CONDENSATION
TRUNCATE citydb.nrg8_lu_condensation CASCADE;
INSERT INTO citydb.nrg8_lu_condensation
(id, name, name_codespace, description)
VALUES
('DryCooling',         'Dry cooling',         NULL, NULL),
('EvaporativeCooling', 'Evaporative cooling', NULL, NULL),
('HybridCooling',      'Hybrid cooling',      NULL, NULL),
('AdiabaticCooling',   'Adiabatic cooling',   NULL, NULL),
('FreeCooling',        'Free cooling',        NULL, NULL)
;

-- Add entry into table LU_ENERGY_SOURCE
TRUNCATE citydb.nrg8_lu_energy_source CASCADE;
INSERT INTO citydb.nrg8_lu_energy_source
(id, name, name_codespace, description)
VALUES
('ChilledAir',   'Chilled air',   NULL, NULL),
('ChilledWater', 'Chilled water', NULL, NULL),
('Coal',         'Coal',          NULL, NULL),
('Electricity',  'Electricity',   NULL, NULL),
('FuelOil',      'Fuel oil',      NULL, NULL),
('HotAir',       'Hot air',       NULL, NULL),
('HotWater',     'Hot water',     NULL, NULL),
('NaturalGas',   'Natural gas',   NULL, NULL),
('Propane',      'Propane',       NULL, NULL),
('Steam',        'Steam',         NULL, NULL),
('WoodChips',    'Wood chips',    NULL, NULL),
('WoodPellets',  'Wood pellets',  NULL, NULL)
;


-- -- Add entry into table LU_xxxx
-- TRUNCATE citydb.nrg8_lu_xxxx CASCADE;
-- INSERT INTO citydb.nrg8_lu_xxxx
-- (id, name, name_codespace, description)
-- VALUES
-- ('', NULL, NULL, NULL),
-- ('', NULL, NULL, NULL)
-- ;

-- ***********************************************************************
-- ***********************************************************************

DO
$$
BEGIN
RAISE NOTICE '

********************************

Energy ADE table data installation complete!

********************************

';
END
$$;
SELECT 'Energy ADE table data installed correctly!'::varchar AS installation_result;


-- ***********************************************************************
-- ***********************************************************************
--
-- END OF FILE
--
-- ***********************************************************************
-- ***********************************************************************