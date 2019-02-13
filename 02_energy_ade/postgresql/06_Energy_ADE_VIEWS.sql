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
-- ********************* 06_Energy_ADE_VIEWS.sql *************************
--
-- This script creates views in the citydb_view schema. All views are
-- prefixed with 'nrg8'.
--
-- ***********************************************************************
-- ***********************************************************************

CREATE SCHEMA IF NOT EXISTS citydb_view;

----------------------------------------------------------------
-- View TIME_SERIES
----------------------------------------------------------------
DROP VIEW IF EXISTS citydb_view.nrg8_time_series CASCADE;
CREATE OR REPLACE VIEW citydb_view.nrg8_time_series AS
SELECT
  ts.id,
  ts.objectclass_id,
  o.classname,
  ts.gmlid,
  ts.gmlid_codespace,
  ts.name,
  ts.name_codespace,
  ts.description,
  ts.acquisition_method,
  ts.interpolation_type,
  ts.quality_description,
  ts.source,
  ts.time_array,
  ts.values_array,
  ts.values_unit,
  ts.array_length,
  ts.temporal_extent_begin,
  ts.temporal_extent_end,
  ts.time_interval,
  ts.time_interval_unit,
  tsf.file_path,
  tsf.file_name,
  tsf.file_extension,
  tsf.nbr_header_lines,
  tsf.field_sep,
  tsf.record_sep,
  tsf.dec_symbol,
  tsf.time_col_nbr,
  tsf.value_col_nbr,
  tsf.is_compressed
FROM
  citydb.objectclass o,
  citydb.nrg8_time_series ts
  LEFT JOIN citydb.nrg8_time_series_file tsf ON tsf.id = ts.id
WHERE
  o.id = ts.objectclass_id;
--ALTER VIEW citydb_view.nrg8_time_series OWNER TO postgres;

----------------------------------------------------------------
-- View TIME_SERIES_REGULAR
----------------------------------------------------------------
DROP VIEW IF EXISTS citydb_view.nrg8_time_series_regular CASCADE;
CREATE OR REPLACE VIEW citydb_view.nrg8_time_series_regular AS
SELECT
  ts.id,
  ts.objectclass_id,
  o.classname,
  ts.gmlid,
  ts.gmlid_codespace,
  ts.name,
  ts.name_codespace,
  ts.description,
  ts.acquisition_method,
  ts.interpolation_type,
  ts.quality_description,
  ts.source,
  ts.values_array,
  ts.values_unit,
  ts.array_length,
  ts.temporal_extent_begin,
  ts.temporal_extent_end,
  ts.time_interval,
  ts.time_interval_unit
FROM
  citydb.objectclass o,
  citydb.nrg8_time_series ts
WHERE
  o.id = ts.objectclass_id AND
  o.classname='RegularTimeSeries';
--ALTER VIEW citydb_view.nrg8_time_series_regular OWNER TO postgres;

----------------------------------------------------------------
-- View TIME_SERIES_IRREGULAR
----------------------------------------------------------------
DROP VIEW IF EXISTS citydb_view.nrg8_time_series_irregular CASCADE;
CREATE OR REPLACE VIEW citydb_view.nrg8_time_series_irregular AS
SELECT
  ts.id,
  ts.objectclass_id,
  o.classname,
  ts.gmlid,
  ts.gmlid_codespace,
  ts.name,
  ts.name_codespace,
  ts.description,
  ts.acquisition_method,
  ts.interpolation_type,
  ts.quality_description,
  ts.source,
  ts.time_array,
  ts.values_array,
  ts.values_unit,
  ts.array_length
FROM
  citydb.objectclass o,
  citydb.nrg8_time_series ts
WHERE
  o.id = ts.objectclass_id AND
  o.classname='IrregularTimeSeries';
--ALTER VIEW citydb_view.nrg8_time_series_irregular OWNER TO postgres;

----------------------------------------------------------------
-- View TIME_SERIES_REGULAR_FILE
----------------------------------------------------------------
DROP VIEW IF EXISTS citydb_view.nrg8_time_series_regular_file CASCADE;
CREATE OR REPLACE VIEW citydb_view.nrg8_time_series_regular_file AS
SELECT
  ts.id,
  ts.objectclass_id,
  o.classname,
  ts.gmlid,
  ts.gmlid_codespace,
  ts.name,
  ts.name_codespace,
  ts.description,
  ts.acquisition_method,
  ts.interpolation_type,
  ts.quality_description,
  ts.source,
  ts.values_unit,
  ts.temporal_extent_begin,
  ts.temporal_extent_end,
  ts.time_interval,
  ts.time_interval_unit,
  tsf.file_path,
  tsf.file_name,
  tsf.file_extension,
  tsf.nbr_header_lines,
  tsf.field_sep,
  tsf.record_sep,
  tsf.dec_symbol,
  tsf.value_col_nbr,
  tsf.is_compressed
FROM
  citydb.objectclass o,
  citydb.nrg8_time_series ts
  LEFT JOIN citydb.nrg8_time_series_file tsf ON ts.id = tsf.id
WHERE
  o.id = ts.objectclass_id AND
  o.classname='RegularTimeSeriesFile';
--ALTER VIEW citydb_view.nrg8_time_series_regular_file OWNER TO postgres;

----------------------------------------------------------------
-- View TIME_SERIES_IRREGULAR_FILE
----------------------------------------------------------------
DROP VIEW IF EXISTS citydb_view.nrg8_time_series_irregular_file CASCADE;
CREATE OR REPLACE VIEW citydb_view.nrg8_time_series_irregular_file AS
SELECT
  ts.id,
  ts.objectclass_id,
  o.classname,
  ts.gmlid,
  ts.gmlid_codespace,
  ts.name,
  ts.name_codespace,
  ts.description,
  ts.acquisition_method,
  ts.interpolation_type,
  ts.quality_description,
  ts.source,
  ts.values_unit,
  tsf.file_path,
  tsf.file_name,
  tsf.file_extension,
  tsf.nbr_header_lines,
  tsf.field_sep,
  tsf.record_sep,
  tsf.dec_symbol,
  tsf.time_col_nbr,
  tsf.value_col_nbr,
  tsf.is_compressed
FROM
  citydb.objectclass o,
  citydb.nrg8_time_series ts
  LEFT JOIN citydb.nrg8_time_series_file tsf ON ts.id = tsf.id
WHERE
  o.id = ts.objectclass_id AND
  o.classname='IrregularTimeSeriesFile';;
--ALTER VIEW citydb_view.nrg8_time_series_irregular_file OWNER TO postgres;

----------------------------------------------------------------
-- View SCHEDULE
----------------------------------------------------------------
DROP VIEW IF EXISTS citydb_view.nrg8_schedule CASCADE;
CREATE OR REPLACE VIEW citydb_view.nrg8_schedule AS
SELECT
  s.id,
  s.objectclass_id,
  o.classname,
  s.gmlid,
  s.gmlid_codespace,
  s.name,
  s.name_codespace,
  s.description,
  s.value1,
  s.value1_unit,
  s.value2,
  s.value2_unit,
  s.hours_per_day,
  s.days_per_year,
  s.time_series_id
FROM
  citydb.objectclass o,
  citydb.nrg8_schedule s
WHERE
  o.id = s.objectclass_id;
--ALTER VIEW citydb_view.nrg8_schedule OWNER TO postgres;

----------------------------------------------------------------
-- View SCHEDULE_CONSTANT_VALUE
----------------------------------------------------------------
DROP VIEW IF EXISTS citydb_view.nrg8_schedule_constant_value CASCADE;
CREATE OR REPLACE VIEW citydb_view.nrg8_schedule_constant_value AS
SELECT
  s.id,
  s.objectclass_id,
  o.classname,
  s.gmlid,
  s.gmlid_codespace,
  s.description,
  s.name,
  s.name_codespace,
  s.value1 AS average_value,
  s.value1_unit AS average_value_unit
FROM
  citydb.objectclass o,
  citydb.nrg8_schedule s
WHERE
  o.id = s.objectclass_id AND
  o.classname = 'ConstantValueSchedule';
--ALTER VIEW citydb_view.nrg8_schedule_single_value OWNER TO postgres;

----------------------------------------------------------------
-- View SCHEDULE_DUAL_VALUE
----------------------------------------------------------------
DROP VIEW IF EXISTS citydb_view.nrg8_schedule_dual_value CASCADE;
CREATE OR REPLACE VIEW citydb_view.nrg8_schedule_dual_value AS
SELECT
  s.id,
  s.objectclass_id,
  o.classname,
  s.gmlid,
  s.gmlid_codespace,
  s.description,
  s.name,
  s.name_codespace,
  s.value1 AS idle_value,
  s.value1_unit AS idle_value_unit,
  s.value2 AS usage_value,
  s.value2_unit AS usage_value_unit,
  s.hours_per_day,
  s.days_per_year
FROM
  citydb.objectclass o,
  citydb.nrg8_schedule s
WHERE
  o.id = s.objectclass_id AND
  o.classname = 'DualValueSchedule';
--ALTER VIEW citydb_view.nrg8_schedule_dual_value OWNER TO postgres;

----------------------------------------------------------------
-- View SCHEDULE_DAILY_PATTERN
----------------------------------------------------------------
DROP VIEW IF EXISTS citydb_view.nrg8_schedule_daily_pattern CASCADE;
CREATE OR REPLACE VIEW citydb_view.nrg8_schedule_daily_pattern AS
SELECT
  s.id,
  s.objectclass_id,
  o.classname,
  s.gmlid,
  s.gmlid_codespace,
  s.name,
  s.name_codespace,
  s.description
FROM
  citydb.objectclass o,
  citydb.nrg8_schedule s
WHERE
  o.id = s.objectclass_id AND
  o.classname = 'DailyPatternSchedule';
--ALTER VIEW citydb_view.nrg8_schedule_daily_pattern OWNER TO postgres;

---------------------------------------------------------------
-- View SCHEDULE_TIME_SERIES
----------------------------------------------------------------
DROP VIEW IF EXISTS citydb_view.nrg8_schedule_time_series CASCADE;
CREATE OR REPLACE VIEW citydb_view.nrg8_schedule_time_series AS
SELECT
  s.id,
  s.objectclass_id,
  o.classname,
  s.gmlid,
  s.gmlid_codespace,
  s.description,
  s.name,
  s.name_codespace,
  s.time_series_id
FROM
  citydb.objectclass o,
  citydb.nrg8_schedule s
WHERE
  o.id = s.objectclass_id AND
  o.classname = 'TimeSeriesSchedule';
--ALTER VIEW citydb_view.nrg8_schedule_time_series OWNER TO postgres;

---------------------------------------------------------------
-- View PERIOD_OF_YEAR
----------------------------------------------------------------
DROP VIEW IF EXISTS citydb_view.nrg8_period_of_year CASCADE;
CREATE OR REPLACE VIEW citydb_view.nrg8_period_of_year AS
SELECT
  p.id,
  p.begin_time,
  p.begin_day,
  p.begin_month,
  p.end_time,
  p.end_day,
  p.end_month,
  p.sched_id
FROM
  citydb.nrg8_period_of_year p;
--ALTER VIEW citydb_view.nrg8_period_of_year OWNER TO postgres;

---------------------------------------------------------------
-- View DAILY_SCHEDULE
----------------------------------------------------------------
DROP VIEW IF EXISTS citydb_view.nrg8_daily_schedule CASCADE;
CREATE OR REPLACE VIEW citydb_view.nrg8_daily_schedule AS
SELECT
  ds.id,
  ds.day_type,
  ds.period_of_year_id,
  ds.time_series_id
FROM
  citydb.nrg8_daily_schedule ds;
--ALTER VIEW citydb_view.nrg8_daily_schedule OWNER TO postgres;

----------------------------------------------------------------
-- View OPTICAL_PROPERTY
----------------------------------------------------------------
DROP VIEW IF EXISTS citydb_view.nrg8_optical_property CASCADE;
CREATE OR REPLACE VIEW citydb_view.nrg8_optical_property AS
SELECT
  op.id,
  op.objectclass_id,
  o.classname,
  op.fraction,
  op.range,
  op.surf_side,
  op.constr_id
FROM
  citydb.objectclass o,
  citydb.nrg8_optical_property op
WHERE
  o.id = op.objectclass_id;
--ALTER VIEW citydb_view.nrg8_optical_property OWNER TO postgres;

----------------------------------------------------------------
-- View OPTICAL_PROPERTY_TRANSMITTANCE
----------------------------------------------------------------
DROP VIEW IF EXISTS citydb_view.nrg8_optical_property_transmittance CASCADE;
CREATE OR REPLACE VIEW citydb_view.nrg8_optical_property_transmittance AS
SELECT
  op.id,
  op.objectclass_id,
  o.classname,
  op.fraction,
  op.range,
  op.constr_id
FROM
  citydb.objectclass o,
  citydb.nrg8_optical_property op
WHERE
  o.id = op.objectclass_id AND
  o.classname = 'Transmittance';
--ALTER VIEW citydb_view.nrg8_optical_property_transmittance OWNER TO postgres;

----------------------------------------------------------------
-- View OPTICAL_PROPERTY_REFLECTANCE
----------------------------------------------------------------
DROP VIEW IF EXISTS citydb_view.nrg8_optical_property_reflectance CASCADE;
CREATE OR REPLACE VIEW citydb_view.nrg8_optical_property_reflectance AS
SELECT
  op.id,
  op.objectclass_id,
  o.classname,
  op.fraction,
  op.range,
  op.surf_side,
  op.constr_id
FROM
  citydb.objectclass o,
  citydb.nrg8_optical_property op
WHERE
  o.id = op.objectclass_id AND
  o.classname = 'Reflectance';
--ALTER VIEW citydb_view.nrg8_optical_property_reflectance OWNER TO postgres;

----------------------------------------------------------------
-- View OPTICAL_PROPERTY_EMISSIVITY
----------------------------------------------------------------
DROP VIEW IF EXISTS citydb_view.nrg8_optical_property_emissivity CASCADE;
CREATE OR REPLACE VIEW citydb_view.nrg8_optical_property_emissivity AS
SELECT
  op.id,
  op.objectclass_id,
  o.classname,
  op.fraction,
  op.surf_side,
  op.constr_id
FROM
  citydb.objectclass o,
  citydb.nrg8_optical_property op
WHERE
  o.id = op.objectclass_id AND
  o.classname = 'Emissivity';
--ALTER VIEW citydb_view.nrg8_optical_property_emissivity OWNER TO postgres;

----------------------------------------------------------------
-- View CONSTRUCTION
----------------------------------------------------------------
DROP VIEW IF EXISTS citydb_view.nrg8_construction CASCADE;
CREATE OR REPLACE VIEW citydb_view.nrg8_construction AS
SELECT
  c.id,
  c.objectclass_id,
  o.classname,
  c.gmlid,
  c.gmlid_codespace,
  c.name,
  c.name_codespace,
  c.description,
  c.u_value,
  c.u_value_unit,
  c.glazing_ratio,
  c.start_of_life,
  c.life_expect_value,
  c.life_expect_value_unit,
  c.main_maint_interval,
  c.main_maint_interval_unit,
  c.base_constr_id
FROM
  citydb.nrg8_construction c,
  citydb.objectclass o
WHERE
  o.id = c.objectclass_id;
--ALTER VIEW citydb_view.nrg8_construction OWNER TO postgres;

----------------------------------------------------------------
-- View CONSTRUCTION_BASE
----------------------------------------------------------------
DROP VIEW IF EXISTS citydb_view.nrg8_construction_base CASCADE;
CREATE OR REPLACE VIEW citydb_view.nrg8_construction_base AS
SELECT
  c.id,
  c.objectclass_id,
  o.classname,
  c.gmlid,
  c.gmlid_codespace,
  c.name,
  c.name_codespace,
  c.description,
  c.u_value,
  c.u_value_unit,
  c.glazing_ratio,
  c.start_of_life,
  c.life_expect_value,
  c.life_expect_value_unit,
  c.main_maint_interval,
  c.main_maint_interval_unit
FROM
  citydb.nrg8_construction c,
  citydb.objectclass o
WHERE
  o.id = c.objectclass_id AND
  o.classname = 'Construction';
--ALTER VIEW citydb_view.nrg8_construction_base OWNER TO postgres;

----------------------------------------------------------------
-- View CONSTRUCTION_REVERSE
----------------------------------------------------------------
DROP VIEW IF EXISTS citydb_view.nrg8_construction_reverse CASCADE;
CREATE OR REPLACE VIEW citydb_view.nrg8_construction_reverse AS
SELECT
  c.id,
  c.objectclass_id,
  o.classname,
  c.gmlid,
  c.gmlid_codespace,
  c.name,
  c.name_codespace,
  c.description,
  c.base_constr_id
FROM
  citydb.nrg8_construction c,
  citydb.objectclass o
WHERE
  o.id = c.objectclass_id AND
  o.classname = 'ReverseConstruction';
--ALTER VIEW citydb_view.nrg8_construction_reverse OWNER TO postgres;

----------------------------------------------------------------
-- View LAYER
----------------------------------------------------------------
DROP VIEW IF EXISTS citydb_view.nrg8_layer CASCADE;
CREATE OR REPLACE VIEW citydb_view.nrg8_layer AS
SELECT
  l.id,
  l.objectclass_id,
  o.classname,
  l.gmlid,
  l.gmlid_codespace,
  l.name,
  l.name_codespace,
  l.description,
  l.pos_nbr,
  l.constr_id
FROM
  citydb.objectclass o,
  citydb.nrg8_layer l
WHERE
  o.id = l.objectclass_id;
--ALTER VIEW citydb_view.nrg8_layer OWNER TO postgres;

----------------------------------------------------------------
-- View LAYER_COMPONENT
----------------------------------------------------------------
DROP VIEW IF EXISTS citydb_view.nrg8_layer_component CASCADE;
CREATE OR REPLACE VIEW citydb_view.nrg8_layer_component AS
SELECT
  lc.id,
  lc.objectclass_id,
  o.classname,
  lc.gmlid,
  lc.gmlid_codespace,
  lc.name,
  lc.name_codespace,
  lc.description,
  lc.area_fr,
  lc.thickness,
  lc.thickness_unit,
  lc.start_of_life,
  lc.life_expect_value,
  lc.life_expect_value_unit,
  lc.main_maint_interval,
  lc.main_maint_interval_unit,
  lc.layer_id
FROM
  citydb.objectclass o,
  citydb.nrg8_layer_component lc
WHERE
  o.id = lc.objectclass_id;
--ALTER VIEW citydb_view.nrg8_layer_component OWNER TO postgres;

----------------------------------------------------------------
-- View MATERIAL
----------------------------------------------------------------
DROP VIEW IF EXISTS citydb_view.nrg8_material CASCADE;
CREATE OR REPLACE VIEW citydb_view.nrg8_material AS
SELECT
  m.id,
  m.objectclass_id,
  o.classname,
  m.gmlid,
  m.gmlid_codespace,
  m.name,
  m.name_codespace,
  m.description,
  m.is_ventilated,
  m.r_value,
  m.r_value_unit,
  m.density,
  m.density_unit,
  m.specific_heat,
  m.specific_heat_unit,
  m.conductivity,
  m.conductivity_unit,
  m.permeance,
  m.permeance_unit,
  m.porosity,
  m.embodied_carbon,
  m.embodied_carbon_unit,
  m.embodied_nrg,
  m.embodied_nrg_unit,
  m.layer_component_id
FROM
  citydb.objectclass o,
  citydb.nrg8_material m
WHERE
  o.id = m.objectclass_id;
--ALTER VIEW citydb_view.nrg8_material OWNER TO postgres;

----------------------------------------------------------------
-- View MATERIAL_GAS
----------------------------------------------------------------
DROP VIEW IF EXISTS citydb_view.nrg8_material_gas CASCADE;
CREATE OR REPLACE VIEW citydb_view.nrg8_material_gas AS
SELECT
  m.id,
  m.objectclass_id,
  o.classname,
  m.gmlid,
  m.gmlid_codespace,
  m.name,
  m.name_codespace,
  m.description,
  m.is_ventilated,
  m.r_value,
  m.r_value_unit,
  m.embodied_carbon,
  m.embodied_carbon_unit,
  m.embodied_nrg,
  m.embodied_nrg_unit,
  m.layer_component_id
FROM
  citydb.objectclass o,
  citydb.nrg8_material m
WHERE
  o.id = m.objectclass_id AND
  o.classname = 'Gas';
--ALTER VIEW citydb_view.nrg8_material_gas OWNER TO postgres;

----------------------------------------------------------------
-- View MATERIAL_SOLID
----------------------------------------------------------------
DROP VIEW IF EXISTS citydb_view.nrg8_material_solid CASCADE;
CREATE OR REPLACE VIEW citydb_view.nrg8_material_solid AS
SELECT
  m.id,
  m.objectclass_id,
  o.classname,
  m.gmlid,
  m.gmlid_codespace,
  m.name,
  m.name_codespace,
  m.description,
  m.density,
  m.density_unit,
  m.specific_heat,
  m.specific_heat_unit,
  m.conductivity,
  m.conductivity_unit,
  m.permeance,
  m.permeance_unit,
  m.porosity,
  m.embodied_carbon,
  m.embodied_carbon_unit,
  m.embodied_nrg,
  m.embodied_nrg_unit,
  m.layer_component_id
FROM
  citydb.objectclass o,
  citydb.nrg8_material m
WHERE
  o.id = m.objectclass_id AND
  o.classname = 'SolidMaterial';
--ALTER VIEW citydb_view.nrg8_material_solid OWNER TO postgres;

----------------------------------------------------------------
-- View DIMENSIONAL_ATTRIB
----------------------------------------------------------------
DROP VIEW IF EXISTS citydb_view.nrg8_dimensional_attrib CASCADE;
CREATE OR REPLACE VIEW citydb_view.nrg8_dimensional_attrib AS
SELECT
  da.id,
  da.objectclass_id,
  o.classname,
  da.type,
  da.value,
  da.value_unit,
  da.cityobject_id
FROM
  citydb.objectclass o,
  citydb.nrg8_dimensional_attrib da
WHERE
  o.id = da.objectclass_id;
--ALTER VIEW citydb_view.nrg8_dimensional_attrib OWNER TO postgres;

----------------------------------------------------------------
-- View DIMENSIONAL_ATTRIB_FLOOR_AREA
----------------------------------------------------------------
DROP VIEW IF EXISTS citydb_view.nrg8_dimensional_attrib_floor_area CASCADE;
CREATE OR REPLACE VIEW citydb_view.nrg8_dimensional_attrib_floor_area AS
SELECT
  da.id,
  da.objectclass_id,
  o.classname,
  da.type,
  da.value,
  da.value_unit,
  da.cityobject_id
FROM
  citydb.objectclass o,
  citydb.nrg8_dimensional_attrib da
WHERE
  o.id = da.objectclass_id
  AND o.classname = 'FloorArea';
--ALTER VIEW citydb_view.nrg8_dimensional_attrib_floor_area OWNER TO postgres;

----------------------------------------------------------------
-- View DIMENSIONAL_ATTRIB_VOLUME
----------------------------------------------------------------
DROP VIEW IF EXISTS citydb_view.nrg8_dimensional_attrib_volume CASCADE;
CREATE OR REPLACE VIEW citydb_view.nrg8_dimensional_attrib_volume AS
SELECT
  da.id,
  da.objectclass_id,
  o.classname,
  da.type,
  da.value,
  da.value_unit,
  da.cityobject_id
FROM
  citydb.objectclass o,
  citydb.nrg8_dimensional_attrib da
WHERE
  o.id = da.objectclass_id
  AND o.classname = 'VolumeType';
--ALTER VIEW citydb_view.nrg8_dimensional_attrib_volume OWNER TO postgres;

----------------------------------------------------------------
-- View DIMENSIONAL_ATTRIB_HEIGHT
----------------------------------------------------------------
DROP VIEW IF EXISTS citydb_view.nrg8_dimensional_attrib_height CASCADE;
CREATE OR REPLACE VIEW citydb_view.nrg8_dimensional_attrib_height AS
SELECT
  da.id,
  da.objectclass_id,
  o.classname,
  da.type,
  da.value,
  da.value_unit,
  da.cityobject_id
FROM
  citydb.objectclass o,
  citydb.nrg8_dimensional_attrib da
WHERE
  o.id = da.objectclass_id
  AND o.classname = 'HeightAboveGround';
--ALTER VIEW citydb_view.nrg8_dimensional_attrib_height OWNER TO postgres;

----------------------------------------------------------------
-- View nrg8_BUILDING
----------------------------------------------------------------
DROP VIEW IF EXISTS citydb_view.nrg8_building CASCADE;
CREATE OR REPLACE VIEW citydb_view.nrg8_building AS
SELECT
  co.id,
  co.objectclass_id,
  o.classname,
  co.gmlid,
  co.gmlid_codespace,
  co.name,
  co.name_codespace,
  co.description,
  co.envelope,
  co.creation_date,
  co.termination_date,
  co.relative_to_terrain,
  co.relative_to_water,
  co.last_modification_date,
  co.updating_person,
  co.reason_for_update,
  co.lineage,
  b.building_parent_id,
  b.building_root_id,
  b.class,
  b.class_codespace,
  b.function,
  b.function_codespace,
  b.usage,
  b.usage_codespace,
  b.year_of_construction,
  b.year_of_demolition,
  b.roof_type,
  b.roof_type_codespace,
  b.measured_height,
  b.measured_height_unit,
  b.storeys_above_ground,
  b.storeys_below_ground,
  b.storey_heights_above_ground,
  b.storey_heights_ag_unit,
  b.storey_heights_below_ground,
  b.storey_heights_bg_unit,
  b.lod1_terrain_intersection,
  b.lod2_terrain_intersection,
  b.lod3_terrain_intersection,
  b.lod4_terrain_intersection,
  b.lod2_multi_curve,
  b.lod3_multi_curve,
  b.lod4_multi_curve,
  b.lod0_footprint_id,
  b.lod0_roofprint_id,
  b.lod1_multi_surface_id,
  b.lod2_multi_surface_id,
  b.lod3_multi_surface_id,
  b.lod4_multi_surface_id,
  b.lod1_solid_id,
  b.lod2_solid_id,
  b.lod3_solid_id,
  b.lod4_solid_id,
  nrg8_co.id AS nrg_id,
  nrg8_co.type,
  nrg8_co.type_codespace,
  nrg8_co.constr_weight,
  nrg8_co.is_landmarked,
  nrg8_co.ref_point
FROM
  citydb.objectclass o,
  citydb.cityobject co
  LEFT JOIN citydb.building b ON co.id=b.id
  LEFT JOIN citydb.nrg8_building nrg8_co ON b.id=nrg8_co.id
WHERE
  o.id = co.objectclass_id AND
  o.classname = 'Building';
--ALTER VIEW citydb_view.nrg8_building OWNER TO postgres;

----------------------------------------------------------------
-- View nrg8_BUILDING_PART
----------------------------------------------------------------
DROP VIEW IF EXISTS citydb_view.nrg8_building_part CASCADE;
CREATE OR REPLACE VIEW citydb_view.nrg8_building_part AS
SELECT
  co.id,
  co.objectclass_id,
  o.classname,
  co.gmlid,
  co.gmlid_codespace,
  co.name,
  co.name_codespace,
  co.description,
  co.envelope,
  co.creation_date,
  co.termination_date,
  co.relative_to_terrain,
  co.relative_to_water,
  co.last_modification_date,
  co.updating_person,
  co.reason_for_update,
  co.lineage,
  b.building_parent_id,
  b.building_root_id,
  b.class,
  b.class_codespace,
  b.function,
  b.function_codespace,
  b.usage,
  b.usage_codespace,
  b.year_of_construction,
  b.year_of_demolition,
  b.roof_type,
  b.roof_type_codespace,
  b.measured_height,
  b.measured_height_unit,
  b.storeys_above_ground,
  b.storeys_below_ground,
  b.storey_heights_above_ground,
  b.storey_heights_ag_unit,
  b.storey_heights_below_ground,
  b.storey_heights_bg_unit,
  b.lod1_terrain_intersection,
  b.lod2_terrain_intersection,
  b.lod3_terrain_intersection,
  b.lod4_terrain_intersection,
  b.lod2_multi_curve,
  b.lod3_multi_curve,
  b.lod4_multi_curve,
  b.lod0_footprint_id,
  b.lod0_roofprint_id,
  b.lod1_multi_surface_id,
  b.lod2_multi_surface_id,
  b.lod3_multi_surface_id,
  b.lod4_multi_surface_id,
  b.lod1_solid_id,
  b.lod2_solid_id,
  b.lod3_solid_id,
  b.lod4_solid_id,
  nrg8_co.id AS nrg8_id,
  nrg8_co.type,
  nrg8_co.type_codespace,
  nrg8_co.constr_weight,
  nrg8_co.is_landmarked,
  nrg8_co.ref_point
FROM
  citydb.objectclass o,
  citydb.cityobject co
  LEFT JOIN citydb.building b ON co.id=b.id
  LEFT JOIN citydb.nrg8_building nrg8_co ON b.id=nrg8_co.id
WHERE
  o.id = co.objectclass_id AND
  o.classname = 'BuildingPart';
--ALTER VIEW citydb_view.nrg8_building_part OWNER TO postgres;

----------------------------------------------------------------
-- View PERF_CERTIFICATION
----------------------------------------------------------------
DROP VIEW IF EXISTS citydb_view.nrg8_perf_certification CASCADE;
CREATE OR REPLACE VIEW citydb_view.nrg8_perf_certification AS
SELECT
  d.id,
  d.name,
  d.rating,
  d.certification_id,
  d.building_id,
  d.building_unit_id
FROM
  citydb.nrg8_perf_certification d;
--ALTER VIEW citydb_view.nrg8_perf_certification OWNER TO postgres;

----------------------------------------------------------------
-- View REFURBISHMENT_MEASURE
----------------------------------------------------------------
DROP VIEW IF EXISTS citydb_view.nrg8_refurbishment_measure CASCADE;
CREATE OR REPLACE VIEW citydb_view.nrg8_refurbishment_measure AS
SELECT
  r.id,
  r.description,
  r.level,
  r.instant_date,
  r.begin_date,
  r.end_date,
  r.building_id,
  r.therm_boundary_id
FROM
  citydb.nrg8_refurbishment_measure r;
--ALTER VIEW citydb_view.nrg8_refubirshment_measure OWNER TO postgres;

----------------------------------------------------------------
-- View WEATHER_DATA
----------------------------------------------------------------
DROP VIEW IF EXISTS citydb_view.nrg8_weather_data CASCADE;
CREATE OR REPLACE VIEW citydb_view.nrg8_weather_data AS
SELECT
  d.id,
  d.gmlid,
  d.gmlid_codespace,
  d.name,
  d.name_codespace,
  d.description,
  d.type,
  d.time_series_id,
  d.cityobject_id,
  d.install_point
FROM
  citydb.nrg8_weather_data d;
--ALTER VIEW citydb_view.nrg8_weather_data OWNER TO postgres;

----------------------------------------------------------------
-- View THERMAL_ZONE
----------------------------------------------------------------
DROP VIEW IF EXISTS citydb_view.nrg8_thermal_zone CASCADE;
CREATE OR REPLACE VIEW citydb_view.nrg8_thermal_zone AS
SELECT
  co.id,
  co.objectclass_id,
  o.classname,
  co.gmlid,
  co.gmlid_codespace,
  co.name,
  co.name_codespace,
  co.description,
  co.envelope,
  co.creation_date,
  co.termination_date,
  co.relative_to_terrain,
  co.relative_to_water,
  co.last_modification_date,
  co.updating_person,
  co.reason_for_update,
  co.lineage,
  nrg8_co.add_therm_bridge_uvalue,
  nrg8_co.add_therm_bridge_uvalue_unit,
  nrg8_co.eff_therm_capacity,
  nrg8_co.eff_therm_capacity_unit,
  nrg8_co.ind_heated_area_ratio,
  nrg8_co.infiltr_rate,
  nrg8_co.infiltr_rate_unit,
  nrg8_co.is_cooled,
  nrg8_co.is_heated,
  nrg8_co.building_id,
  nrg8_co.solid_id,
  nrg8_co.multi_surf_geom
FROM
  citydb.objectclass o,
  citydb.cityobject co
  LEFT JOIN citydb.nrg8_thermal_zone nrg8_co ON co.id = nrg8_co.id
WHERE
  o.id = co.objectclass_id AND
  o.classname= 'ThermalZone';
--ALTER VIEW citydb_view.nrg8_thermal_zone OWNER TO postgres;

----------------------------------------------------------------
-- View THERMAL_BOUNDARY
----------------------------------------------------------------
DROP VIEW IF EXISTS citydb_view.nrg8_thermal_boundary CASCADE;
CREATE OR REPLACE VIEW citydb_view.nrg8_thermal_boundary AS
SELECT
  co.id,
  co.objectclass_id,
  o.classname,
  co.gmlid,
  co.gmlid_codespace,
  co.name,
  co.name_codespace,
  co.description,
  co.envelope,
  co.creation_date,
  co.termination_date,
  co.relative_to_terrain,
  co.relative_to_water,
  co.last_modification_date,
  co.updating_person,
  co.reason_for_update,
  co.lineage,
  nrg8_co.type,
  nrg8_co.azimuth,
  nrg8_co.azimuth_unit,
  nrg8_co.inclination,
  nrg8_co.inclination_unit,
  nrg8_co.area,
  nrg8_co.area_unit,
  nrg8_co.therm_zone1_id,
  nrg8_co.therm_zone2_id,
  nrg8_co.multi_surf_id,
  nrg8_co.multi_surf_geom
FROM
  citydb.objectclass o,
  citydb.cityobject co
  LEFT JOIN citydb.nrg8_thermal_boundary nrg8_co ON co.id = nrg8_co.id
WHERE
  o.id = co.objectclass_id AND
  o.classname= 'ThermalBoundary';
--ALTER VIEW citydb_view.nrg8_thermal_boundary OWNER TO postgres;

----------------------------------------------------------------
-- View THERMAL_OPENING
----------------------------------------------------------------
DROP VIEW IF EXISTS citydb_view.nrg8_thermal_opening CASCADE;
CREATE OR REPLACE VIEW citydb_view.nrg8_thermal_opening AS
SELECT
  co.id,
  co.objectclass_id,
  o.classname,
  co.gmlid,
  co.gmlid_codespace,
  co.name,
  co.name_codespace,
  co.description,
  co.envelope,
  co.creation_date,
  co.termination_date,
  co.relative_to_terrain,
  co.relative_to_water,
  co.last_modification_date,
  co.updating_person,
  co.reason_for_update,
  co.lineage,
  nrg8_co.area,
  nrg8_co.area_unit,
  nrg8_co.openable_ratio,
  nrg8_co.in_shad_name,
  nrg8_co.in_shad_max_cover_ratio,
  nrg8_co.in_shad_transmission,
  nrg8_co.in_shad_transmission_range,
  nrg8_co.out_shad_name,
  nrg8_co.out_shad_max_cover_ratio,
  nrg8_co.out_shad_transmittance,
  nrg8_co.out_shad_transmittance_range,
  nrg8_co.therm_boundary_id,
  nrg8_co.multi_surf_id,
  nrg8_co.multi_surf_geom
FROM
  citydb.objectclass o,
  citydb.cityobject co
  LEFT JOIN citydb.nrg8_thermal_opening nrg8_co ON co.id = nrg8_co.id
WHERE
  o.id = co.objectclass_id AND
  o.classname= 'ThermalOpening';
 --ALTER VIEW citydb_view.nrg8_thermal_opening OWNER TO postgres;

----------------------------------------------------------------
-- View WEATHER_STATION
----------------------------------------------------------------
DROP VIEW IF EXISTS citydb_view.nrg8_weather_station CASCADE;
CREATE OR REPLACE VIEW citydb_view.nrg8_weather_station AS
SELECT
  co.id,
  co.objectclass_id,
  o.classname,
  co.gmlid,
  co.gmlid_codespace,
  co.name,
  co.name_codespace,
  co.description,
  co.envelope,
  co.creation_date,
  co.termination_date,
  co.relative_to_terrain,
  co.relative_to_water,
  co.last_modification_date,
  co.updating_person,
  co.reason_for_update,
  co.lineage,
  nrg8_co.cityobject_id,
  nrg8_co.install_point
FROM
  citydb.objectclass o,
  citydb.cityobject co
  LEFT JOIN citydb.nrg8_weather_station nrg8_co ON co.id = nrg8_co.id
WHERE
  o.id = co.objectclass_id AND
  o.classname= 'WeatherStation';
--ALTER VIEW citydb_view.nrg8_weather_station OWNER TO postgres;

----------------------------------------------------------------
-- View USAGE_ZONE
----------------------------------------------------------------
DROP VIEW IF EXISTS citydb_view.nrg8_usage_zone CASCADE;
CREATE OR REPLACE VIEW citydb_view.nrg8_usage_zone AS
SELECT
  co.id,
  co.objectclass_id,
  o.classname,
  co.gmlid,
  co.gmlid_codespace,
  co.name,
  co.name_codespace,
  co.description,
  co.envelope,
  co.creation_date,
  co.termination_date,
  co.relative_to_terrain,
  co.relative_to_water,
  co.last_modification_date,
  co.updating_person,
  co.reason_for_update,
  co.lineage,
  nrg8_co.type,
  nrg8_co.type_codespace,
  nrg8_co.used_floors,
  nrg8_co.int_gains_tot_value,
  nrg8_co.int_gains_tot_value_unit,
  nrg8_co.int_gains_conv,
  nrg8_co.int_gains_lat,
  nrg8_co.int_gains_rad,
  nrg8_co.heat_sched_id,
  nrg8_co.cool_sched_id,
  nrg8_co.vent_sched_id,
  nrg8_co.therm_zone_id,
  nrg8_co.building_id,
  nrg8_co.solid_id,
  nrg8_co.multi_surf_geom
FROM
  citydb.objectclass o,
  citydb.cityobject co
  LEFT JOIN citydb.nrg8_usage_zone nrg8_co ON co.id = nrg8_co.id
WHERE
  o.id = co.objectclass_id AND
  o.classname= 'UsageZone';
--ALTER VIEW citydb_view.nrg8_usage_zone OWNER TO postgres;

----------------------------------------------------------------
-- View BUILDING_UNIT
----------------------------------------------------------------
DROP VIEW IF EXISTS citydb_view.nrg8_building_unit CASCADE;
CREATE OR REPLACE VIEW citydb_view.nrg8_building_unit AS
SELECT
  co.id,
  co.objectclass_id,
  o.classname,
  co.gmlid,
  co.gmlid_codespace,
  co.name,
  co.name_codespace,
  co.description,
  co.envelope,
  co.creation_date,
  co.termination_date,
  co.relative_to_terrain,
  co.relative_to_water,
  co.last_modification_date,
  co.updating_person,
  co.reason_for_update,
  co.lineage,
  nrg8_co.nbr_of_rooms,
  nrg8_co.owner_name,
  nrg8_co.ownership_type,
  nrg8_co.usage_zone_id
FROM
  citydb.objectclass o,
  citydb.cityobject co
  LEFT JOIN citydb.nrg8_building_unit nrg8_co ON co.id = nrg8_co.id
WHERE
  o.id = co.objectclass_id AND
  o.classname= 'BuildingUnit';
--ALTER VIEW citydb_view.nrg8_building_unit OWNER TO postgres;

----------------------------------------------------------------
-- View FACILITIES
----------------------------------------------------------------
DROP VIEW IF EXISTS citydb_view.nrg8_facilities CASCADE;
CREATE OR REPLACE VIEW citydb_view.nrg8_facilities AS
SELECT
  co.id,
  co.objectclass_id,
  o.classname,
  co.gmlid,
  co.gmlid_codespace,
  co.name,
  co.name_codespace,
  co.description,
  co.envelope,
  co.creation_date,
  co.termination_date,
  co.relative_to_terrain,
  co.relative_to_water,
  co.last_modification_date,
  co.updating_person,
  co.reason_for_update,
  co.lineage,
  nrg8_co.heat_diss_tot_value,
  nrg8_co.heat_diss_tot_value_unit,
  nrg8_co.heat_diss_conv,
  nrg8_co.heat_diss_lat,
  nrg8_co.heat_diss_rad,
  nrg8_co.electr_pwr,
  nrg8_co.electr_pwr_unit,
  nrg8_co.nbr_of_baths,
  nrg8_co.nbr_of_showers,
  nrg8_co.nbr_of_washbasins,
  nrg8_co.water_strg_vol,
  nrg8_co.water_strg_vol_unit,
  nrg8_co.oper_sched_id,
  nrg8_co.usage_zone_id,
  nrg8_co.building_unit_id
FROM
  citydb.objectclass o,
  citydb.cityobject co,
  citydb.nrg8_facilities nrg8_co
WHERE
  o.id = co.objectclass_id AND
  co.id=nrg8_co.id;
--ALTER VIEW citydb_view.nrg8_facilities OWNER TO postgres;

----------------------------------------------------------------
-- View FACILITIES_DHW
----------------------------------------------------------------
DROP VIEW IF EXISTS citydb_view.nrg8_facilities_dhw CASCADE;
CREATE OR REPLACE VIEW citydb_view.nrg8_facilities_dhw AS
SELECT
  co.id,
  co.objectclass_id,
  o.classname,
  co.gmlid,
  co.gmlid_codespace,
  co.name,
  co.name_codespace,
  co.description,
  co.envelope,
  co.creation_date,
  co.termination_date,
  co.relative_to_terrain,
  co.relative_to_water,
  co.last_modification_date,
  co.updating_person,
  co.reason_for_update,
  co.lineage,
  nrg8_co.heat_diss_tot_value,
  nrg8_co.heat_diss_tot_value_unit,
  nrg8_co.heat_diss_conv,
  nrg8_co.heat_diss_lat,
  nrg8_co.heat_diss_rad,
  nrg8_co.nbr_of_baths,
  nrg8_co.nbr_of_showers,
  nrg8_co.nbr_of_washbasins,
  nrg8_co.water_strg_vol,
  nrg8_co.water_strg_vol_unit,
  nrg8_co.oper_sched_id,
  nrg8_co.usage_zone_id,
  nrg8_co.building_unit_id
FROM
  citydb.objectclass o,
  citydb.cityobject co,
  citydb.nrg8_facilities nrg8_co
WHERE
  co.id = nrg8_co.id
  AND o.id = co.objectclass_id
  AND o.classname = 'DHWFacilities';
--ALTER VIEW citydb_view.nrg8_facilities_dhw OWNER TO postgres;

----------------------------------------------------------------
-- View FACILITIES_ELECTRICAL_APPLIANCES
----------------------------------------------------------------
DROP VIEW IF EXISTS citydb_view.nrg8_facilities_electrical_appliances CASCADE;
CREATE OR REPLACE VIEW citydb_view.nrg8_facilities_electrical_appliances AS
SELECT
  co.id,
  co.objectclass_id,
  o.classname,
  co.gmlid,
  co.gmlid_codespace,
  co.name,
  co.name_codespace,
  co.description,
  co.envelope,
  co.creation_date,
  co.termination_date,
  co.relative_to_terrain,
  co.relative_to_water,
  co.last_modification_date,
  co.updating_person,
  co.reason_for_update,
  co.lineage,
  nrg8_co.heat_diss_tot_value,
  nrg8_co.heat_diss_tot_value_unit,
  nrg8_co.heat_diss_conv,
  nrg8_co.heat_diss_lat,
  nrg8_co.heat_diss_rad,
  nrg8_co.electr_pwr,
  nrg8_co.electr_pwr_unit,
  nrg8_co.oper_sched_id,
  nrg8_co.usage_zone_id,
  nrg8_co.building_unit_id
FROM
  citydb.objectclass o,
  citydb.cityobject co,
  citydb.nrg8_facilities nrg8_co
WHERE
  co.id = nrg8_co.id
  AND o.id = co.objectclass_id
  AND o.classname = 'ElectricalAppliances';
--ALTER VIEW citydb_view.nrg8_facilities_electrical_appliances OWNER TO postgres;

----------------------------------------------------------------
-- View FACILITIES_LIGHTING
----------------------------------------------------------------
DROP VIEW IF EXISTS citydb_view.nrg8_facilities_lighting CASCADE;
CREATE OR REPLACE VIEW citydb_view.nrg8_facilities_lighting AS
SELECT
  co.id,
  co.objectclass_id,
  o.classname,
  co.gmlid,
  co.gmlid_codespace,
  co.name,
  co.name_codespace,
  co.description,
  co.envelope,
  co.creation_date,
  co.termination_date,
  co.relative_to_terrain,
  co.relative_to_water,
  co.last_modification_date,
  co.updating_person,
  co.reason_for_update,
  co.lineage,
  nrg8_co.heat_diss_tot_value,
  nrg8_co.heat_diss_tot_value_unit,
  nrg8_co.heat_diss_conv,
  nrg8_co.heat_diss_lat,
  nrg8_co.heat_diss_rad,
  nrg8_co.electr_pwr,
  nrg8_co.electr_pwr_unit,
  nrg8_co.oper_sched_id,
  nrg8_co.usage_zone_id,
  nrg8_co.building_unit_id
FROM
  citydb.objectclass o,
  citydb.cityobject co,
  citydb.nrg8_facilities nrg8_co
WHERE
  co.id = nrg8_co.id
  AND o.id = co.objectclass_id
  AND o.classname = 'LightingFacilities';
--ALTER VIEW citydb_view.nrg8_facilities_lighting OWNER TO postgres;

----------------------------------------------------------------
-- View OCCUPANTS
----------------------------------------------------------------
DROP VIEW IF EXISTS citydb_view.nrg8_occupants CASCADE;
CREATE OR REPLACE VIEW citydb_view.nrg8_occupants AS
SELECT
  f.id,
  f.objectclass_id,
  o.classname,
  f.gmlid,
  f.gmlid_codespace,
  f.name,
  f.name_codespace,
  f.description,
  f.type,
  f.nbr_of_occupants,
  f.heat_diss_tot_value,
  f.heat_diss_tot_value_unit,
  f.heat_diss_conv,
  f.heat_diss_lat,
  f.heat_diss_rad,
  f.usage_zone_id,
  f.sched_id,
  f.building_unit_id
FROM
  citydb.objectclass o,
  citydb.nrg8_occupants f
WHERE
  o.id = f.objectclass_id;
--ALTER VIEW citydb_view.nrg8_occupants OWNER TO postgres;

----------------------------------------------------------------
-- View HOUSEHOLD
----------------------------------------------------------------
DROP VIEW IF EXISTS citydb_view.nrg8_household CASCADE;
CREATE OR REPLACE VIEW citydb_view.nrg8_household AS
SELECT
  f.id,
  f.objectclass_id,
  o.classname,
  f.gmlid,
  f.gmlid_codespace,
  f.name,
  f.name_codespace,
  f.description,
  f.type,
  f.residence_type,
  f.occupants_id
FROM
  citydb.objectclass o,
  citydb.nrg8_household f
WHERE
  o.id = f.objectclass_id;
--ALTER VIEW citydb_view.nrg8_household OWNER TO postgres;

----------------------------------------------------------------
-- View ENERGY_DEMAND
----------------------------------------------------------------
DROP VIEW IF EXISTS citydb_view.nrg8_energy_demand CASCADE;
CREATE OR REPLACE VIEW citydb_view.nrg8_energy_demand AS
SELECT
  f.id,
  f.objectclass_id,
  o.classname,
  f.gmlid,
  f.gmlid_codespace,
  f.name,
  f.name_codespace,
  f.description,
  f.end_use,
  f.max_load,
  f.max_load_unit,
  f.time_series_id,
  f.cityobject_id
FROM
  citydb.objectclass o,
  citydb.nrg8_energy_demand f
WHERE
  o.id = f.objectclass_id;
--ALTER VIEW citydb_view.nrg8_energy_demand OWNER TO postgres;

----------------------------------------------------------------
-- View FINAL_ENERGY
----------------------------------------------------------------
DROP VIEW IF EXISTS citydb_view.nrg8_final_energy CASCADE;
CREATE OR REPLACE VIEW citydb_view.nrg8_final_energy AS
SELECT
  f.id,
  f.objectclass_id,
  o.classname,
  f.gmlid,
  f.gmlid_codespace,
  f.name,
  f.name_codespace,
  f.description,
  f.nrg_car_type,
  f.nrg_car_prim_nrg_factor,
  f.nrg_car_prim_nrg_factor_unit,
  f.nrg_car_nrg_density,
  f.nrg_car_nrg_density_unit,
  f.nrg_car_co2_emission,
  f.nrg_car_co2_emission_unit,
  f.time_series_id
FROM
  citydb.objectclass o,
  citydb.nrg8_final_energy f
WHERE
  o.id = f.objectclass_id;
--ALTER VIEW citydb_view.nrg8_final_energy OWNER TO postgres;

----------------------------------------------------------------
-- View SYSTEM_OPERATION
----------------------------------------------------------------
DROP VIEW IF EXISTS citydb_view.nrg8_system_operation CASCADE;
CREATE OR REPLACE VIEW citydb_view.nrg8_system_operation AS
SELECT
  f.id,
  f.objectclass_id,
  o.classname,
  f.gmlid,
  f.gmlid_codespace,
  f.name,
  f.name_codespace,
  f.description,
  f.end_use,
  f.yearly_global_effcy,
  f.sched_id,
  f.nrg_conv_system_id
FROM
  citydb.objectclass o,
  citydb.nrg8_system_operation f
WHERE
  o.id = f.objectclass_id;
--ALTER VIEW citydb_view.nrg8_system_operation OWNER TO postgres;

----------------------------------------------------------------
-- View STORAGE_SYSTEM_THERMAL
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.nrg8_storage_system_thermal CASCADE;
CREATE OR REPLACE VIEW citydb_view.nrg8_storage_system_thermal AS
SELECT
  co.id,
  co.objectclass_id,
  o.classname,
  co.gmlid,
  co.gmlid_codespace,
  co.name,
  co.name_codespace,
  co.description,
  co.envelope,
  co.creation_date,
  co.termination_date,
  co.relative_to_terrain,
  co.relative_to_water,
  co.last_modification_date,
  co.updating_person,
  co.reason_for_update,
  co.lineage,
  nrg8_ss.start_of_life,
  nrg8_ss.life_expect_value,
  nrg8_ss.life_expect_value_unit,
  nrg8_ss.main_maint_interval,
  nrg8_ss.main_maint_interval_unit,
  nrg8_ss.nrg_demand_id,
  nrg8_ss.cityobject_id,
  nrg8_ts.medium,
  nrg8_ts.vol,
  nrg8_ts.vol_unit,
  nrg8_ts.prep_temp,
  nrg8_ts.prep_temp_unit,
  nrg8_ts.therm_loss,
  nrg8_ts.therm_loss_unit
FROM
  citydb.objectclass o,
  citydb.cityobject co,
  citydb.nrg8_storage_system nrg8_ss,
  citydb.nrg8_thermal_storage_system nrg8_ts
WHERE
  co.id = nrg8_ts.id
  AND o.id = co.objectclass_id
  AND nrg8_ts.id = nrg8_ss.id
  AND o.classname = 'ThermalStorageSystem';
--ALTER VIEW citydb_view.nrg8_thermal_storage_system OWNER TO postgres;

----------------------------------------------------------------
-- View STORAGE_SYSTEM_POWER
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.nrg8_storage_system_power CASCADE;
CREATE OR REPLACE VIEW citydb_view.nrg8_storage_system_power AS
SELECT
  co.id,
  co.objectclass_id,
  o.classname,
  co.gmlid,
  co.gmlid_codespace,
  co.name,
  co.name_codespace,
  co.description,
  co.envelope,
  co.creation_date,
  co.termination_date,
  co.relative_to_terrain,
  co.relative_to_water,
  co.last_modification_date,
  co.updating_person,
  co.reason_for_update,
  co.lineage,
  nrg8_ss.start_of_life,
  nrg8_ss.life_expect_value,
  nrg8_ss.life_expect_value_unit,
  nrg8_ss.main_maint_interval,
  nrg8_ss.main_maint_interval_unit,
  nrg8_ss.nrg_demand_id,
  nrg8_ss.cityobject_id,
  nrg8_ps.battery_techn,
  nrg8_ps.pwr_capacity,
  nrg8_ps.pwr_capacity_unit
FROM
  citydb.objectclass o,
  citydb.cityobject co,
  citydb.nrg8_storage_system nrg8_ss,
  citydb.nrg8_power_storage_system nrg8_ps
WHERE
  co.id = nrg8_ps.id
  AND o.id = co.objectclass_id
  AND nrg8_ps.id = nrg8_ss.id
  AND o.classname = 'PowerStorageSystem';
--ALTER VIEW citydb_view.nrg8_power_storage_system OWNER TO postgres;

----------------------------------------------------------------
-- View DISTRIB_SYSTEM_GENERIC
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.nrg8_distrib_system_generic CASCADE;
CREATE OR REPLACE VIEW citydb_view.nrg8_distrib_system_generic AS
SELECT
  co.id,
  co.objectclass_id,
  o.classname,
  co.gmlid,
  co.gmlid_codespace,
  co.name,
  co.name_codespace,
  co.description,
  co.envelope,
  co.creation_date,
  co.termination_date,
  co.relative_to_terrain,
  co.relative_to_water,
  co.last_modification_date,
  co.updating_person,
  co.reason_for_update,
  co.lineage,
  nrg8_ds.distrib_perim,
  nrg8_ds.start_of_life,
  nrg8_ds.life_expect_value,
  nrg8_ds.life_expect_value_unit,
  nrg8_ds.main_maint_interval,
  nrg8_ds.main_maint_interval_unit,
  nrg8_ds.nrg_demand_id,
  nrg8_ds.cityobject_id
FROM
  citydb.objectclass o,
  citydb.cityobject co,
  citydb.nrg8_distrib_system nrg8_ds
WHERE
  co.id = nrg8_ds.id
  AND o.id = co.objectclass_id
  AND o.classname = 'DistributionSystem';
--ALTER VIEW citydb_view.nrg8_distrib_system OWNER TO postgres;

----------------------------------------------------------------
-- View DISTRIB_SYSTEM_THERMAL
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.nrg8_distrib_system_thermal CASCADE;
CREATE OR REPLACE VIEW citydb_view.nrg8_distrib_system_thermal AS
SELECT
  co.id,
  co.objectclass_id,
  o.classname,
  co.gmlid,
  co.gmlid_codespace,
  co.name,
  co.name_codespace,
  co.description,
  co.envelope,
  co.creation_date,
  co.termination_date,
  co.relative_to_terrain,
  co.relative_to_water,
  co.last_modification_date,
  co.updating_person,
  co.reason_for_update,
  co.lineage,
  nrg8_ds.distrib_perim,
  nrg8_ds.start_of_life,
  nrg8_ds.life_expect_value,
  nrg8_ds.life_expect_value_unit,
  nrg8_ds.main_maint_interval,
  nrg8_ds.main_maint_interval_unit,
  nrg8_ds.nrg_demand_id,
  nrg8_ds.cityobject_id,
  nrg8_td.has_circulation,
  nrg8_td.medium,
  nrg8_td.nom_flow,
  nrg8_td.nom_flow_unit,
  nrg8_td.supply_temp,
  nrg8_td.supply_temp_unit,
  nrg8_td.return_temp,
  nrg8_td.return_temp_unit,
  nrg8_td.therm_loss,
  nrg8_td.therm_loss_unit
FROM
  citydb.objectclass o,
  citydb.cityobject co,
  citydb.nrg8_distrib_system nrg8_ds,
  citydb.nrg8_thermal_distrib_system nrg8_td
WHERE
  co.id = nrg8_ds.id
  AND o.id = co.objectclass_id
  AND nrg8_ds.id = nrg8_td.id
  AND o.classname = 'ThermalDistributionSystem';
--ALTER VIEW citydb_view.nrg8_thermal_distrib_system OWNER TO postgres;

----------------------------------------------------------------
-- View DISTRIB_SYSTEM_POWER
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.nrg8_distrib_system_power CASCADE;
CREATE OR REPLACE VIEW citydb_view.nrg8_distrib_system_power AS
SELECT
  co.id,
  co.objectclass_id,
  o.classname,
  co.gmlid,
  co.gmlid_codespace,
  co.name,
  co.name_codespace,
  co.description,
  co.envelope,
  co.creation_date,
  co.termination_date,
  co.relative_to_terrain,
  co.relative_to_water,
  co.last_modification_date,
  co.updating_person,
  co.reason_for_update,
  co.lineage,
  nrg8_ds.distrib_perim,
  nrg8_ds.start_of_life,
  nrg8_ds.life_expect_value,
  nrg8_ds.life_expect_value_unit,
  nrg8_ds.main_maint_interval,
  nrg8_ds.main_maint_interval_unit,
  nrg8_ds.nrg_demand_id,
  nrg8_ds.cityobject_id,
  nrg8_pd.current,
  nrg8_pd.current_unit,
  nrg8_pd.voltage,
  nrg8_pd.voltage_unit
FROM
  citydb.objectclass o,
  citydb.cityobject co,
  citydb.nrg8_distrib_system nrg8_ds,
  citydb.nrg8_power_distrib_system nrg8_pd
WHERE
  co.id = nrg8_ds.id
  AND o.id = co.objectclass_id
  AND nrg8_ds.id = nrg8_pd.id
  AND o.classname = 'PowerDistributionSystem';
--ALTER VIEW citydb_view.nrg8_power_distrib_system OWNER TO postgres;

----------------------------------------------------------------
-- View EMITTER
----------------------------------------------------------------
DROP VIEW IF EXISTS citydb_view.nrg8_emitter CASCADE;
CREATE OR REPLACE VIEW citydb_view.nrg8_emitter AS
SELECT
  co.id,
  co.objectclass_id,
  o.classname,
  co.gmlid,
  co.gmlid_codespace,
  co.name,
  co.name_codespace,
  co.description,
  co.envelope,
  co.creation_date,
  co.termination_date,
  co.relative_to_terrain,
  co.relative_to_water,
  co.last_modification_date,
  co.updating_person,
  co.reason_for_update,
  co.lineage,
  nrg8_co.type,
  nrg8_co.unit_nbr,
  nrg8_co.inst_pwr,
  nrg8_co.inst_pwr_unit,
  nrg8_co.therm_exch_tot_value,
  nrg8_co.therm_exch_tot_value_unit,
  nrg8_co.therm_exch_conv,
  nrg8_co.therm_exch_rad,
  nrg8_co.therm_exch_lat,
  nrg8_co.distr_system_id,
  nrg8_co.cityobject_id
FROM
  citydb.objectclass o,
  citydb.cityobject co,
  citydb.nrg8_emitter nrg8_co
WHERE
  nrg8_co.id = co.id AND
  o.id = co.objectclass_id;
--ALTER VIEW citydb_view.nrg8_emitter OWNER TO postgres;

----------------------------------------------------------------
-- View CONV_SYSTEM_GENERIC
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.nrg8_conv_system_generic CASCADE;
CREATE OR REPLACE VIEW citydb_view.nrg8_conv_system_generic AS
SELECT
  co.id,
  co.objectclass_id,
  o.classname,
  co.gmlid,
  co.gmlid_codespace,
  co.name,
  co.name_codespace,
  co.description,
  co.envelope,
  co.creation_date,
  co.termination_date,
  co.relative_to_terrain,
  co.relative_to_water,
  co.last_modification_date,
  co.updating_person,
  co.reason_for_update,
  co.lineage,
  cs.model,
  cs.nbr,
  cs.year_of_manufacture,
  cs.inst_nom_pwr,
  cs.inst_nom_pwr_unit,
  cs.nom_effcy,
  cs.effcy_indicator,
  cs.start_of_life,
  cs.life_expect_value,
  cs.life_expect_value_unit,
  cs.main_maint_interval,
  cs.main_maint_interval_unit,
  cs.inst_in_ctyobj_id,
  cs.cityobject_id
FROM
  citydb.objectclass o,
  citydb.cityobject co,
  citydb.nrg8_conv_system cs
WHERE
  o.id = co.objectclass_id AND
  cs.id = co.id AND
	o.classname = 'EnergyConversionSystem';
--ALTER VIEW citydb_view.nrg8_conv_system OWNER TO postgres;

----------------------------------------------------------------
-- View CONV_SYSTEM_SOLAR_PV_THERMAL
----------------------------------------------------------------
DROP VIEW IF EXISTS citydb_view.nrg8_conv_system_solar_pv_thermal CASCADE;
CREATE OR REPLACE VIEW citydb_view.nrg8_conv_system_solar_pv_thermal AS
SELECT
  co.id,
  co.objectclass_id,
  o.classname,
  co.gmlid,
  co.gmlid_codespace,
  co.name,
  co.name_codespace,
  co.description,
  co.envelope,
  co.creation_date,
  co.termination_date,
  co.relative_to_terrain,
  co.relative_to_water,
  co.last_modification_date,
  co.updating_person,
  co.reason_for_update,
  co.lineage,
  cs.model,
  cs.nbr,
  cs.year_of_manufacture,
  cs.inst_nom_pwr,
  cs.inst_nom_pwr_unit,
  cs.nom_effcy,
  cs.effcy_indicator,
  cs.start_of_life,
  cs.life_expect_value,
  cs.life_expect_value_unit,
  cs.main_maint_interval,
  cs.main_maint_interval_unit,
  cs.inst_in_ctyobj_id,
  cs.cityobject_id,
  ss.collector_type,
  ss.cell_type,
  ss.module_area,
  ss.module_area_unit,
  ss.aperture_area,
  ss.aperture_area_unit,
  ss.eta0,
  ss.a1,
  ss.a2,
  ss.them_surf_id,
  ss.building_inst_id,
  ss.multi_surf_id,
  ss.multi_surf_geom
FROM
  citydb.objectclass o,
  citydb.cityobject co,
  citydb.nrg8_conv_system cs,
  citydb.nrg8_solar_system ss
WHERE
  o.id = co.objectclass_id AND
  cs.id = co.id AND
  ss.id = cs.id AND
  o.classname = 'PhotovoltaicThermalSystem';
--ALTER VIEW citydb_view.nrg8_conv_system_solar_pv_thermal OWNER TO postgres;

----------------------------------------------------------------
-- View CONV_SYSTEM_SOLAR_PV
----------------------------------------------------------------
DROP VIEW IF EXISTS citydb_view.nrg8_conv_system_solar_pv CASCADE;
CREATE OR REPLACE VIEW citydb_view.nrg8_conv_system_solar_pv AS
SELECT
  co.id,
  co.objectclass_id,
  o.classname,
  co.gmlid,
  co.gmlid_codespace,
  co.name,
  co.name_codespace,
  co.description,
  co.envelope,
  co.creation_date,
  co.termination_date,
  co.relative_to_terrain,
  co.relative_to_water,
  co.last_modification_date,
  co.updating_person,
  co.reason_for_update,
  co.lineage,
  cs.model,
  cs.nbr,
  cs.year_of_manufacture,
  cs.inst_nom_pwr,
  cs.inst_nom_pwr_unit,
  cs.nom_effcy,
  cs.effcy_indicator,
  cs.start_of_life,
  cs.life_expect_value,
  cs.life_expect_value_unit,
  cs.main_maint_interval,
  cs.main_maint_interval_unit,
  cs.inst_in_ctyobj_id,
  cs.cityobject_id,
  ss.cell_type,
  ss.module_area,
  ss.module_area_unit,
  ss.them_surf_id,
  ss.building_inst_id,
  ss.multi_surf_id,
  ss.multi_surf_geom
FROM
  citydb.objectclass o,
  citydb.cityobject co,
  citydb.nrg8_conv_system cs,
  citydb.nrg8_solar_system ss
WHERE
  o.id = co.objectclass_id AND
  cs.id = co.id AND
  ss.id = cs.id AND
  o.classname = 'PhotovoltaicSystem';
--ALTER VIEW citydb_view.nrg8_conv_system_solar_pv OWNER TO postgres;

----------------------------------------------------------------
-- View CONV_SYSTEM_SOLAR_THERMAL
----------------------------------------------------------------
DROP VIEW IF EXISTS citydb_view.nrg8_conv_system_solar_thermal CASCADE;
CREATE OR REPLACE VIEW citydb_view.nrg8_conv_system_solar_thermal AS
SELECT
  co.id,
  co.objectclass_id,
  o.classname,
  co.gmlid,
  co.gmlid_codespace,
  co.name,
  co.name_codespace,
  co.description,
  co.envelope,
  co.creation_date,
  co.termination_date,
  co.relative_to_terrain,
  co.relative_to_water,
  co.last_modification_date,
  co.updating_person,
  co.reason_for_update,
  co.lineage,
  cs.model,
  cs.nbr,
  cs.year_of_manufacture,
  cs.inst_nom_pwr,
  cs.inst_nom_pwr_unit,
  cs.nom_effcy,
  cs.effcy_indicator,
  cs.start_of_life,
  cs.life_expect_value,
  cs.life_expect_value_unit,
  cs.main_maint_interval,
  cs.main_maint_interval_unit,
  cs.inst_in_ctyobj_id,
  cs.cityobject_id,
  ss.collector_type,
  ss.aperture_area,
  ss.aperture_area_unit,
  ss.eta0,
  ss.a1,
  ss.a2,
  ss.them_surf_id,
  ss.building_inst_id,
  ss.multi_surf_id,
  ss.multi_surf_geom
FROM
  citydb.objectclass o,
  citydb.cityobject co,
  citydb.nrg8_conv_system cs,
  citydb.nrg8_solar_system ss
WHERE
  o.id = co.objectclass_id AND
  cs.id = co.id AND
  ss.id = cs.id AND
  o.classname = 'SolarThermalSystem';
--ALTER VIEW citydb_view.nrg8_conv_system_solar_thermal OWNER TO postgres;

----------------------------------------------------------------
-- View CONV_SYSTEM_BOILER
----------------------------------------------------------------
DROP VIEW IF EXISTS citydb_view.nrg8_conv_system_boiler CASCADE;
CREATE OR REPLACE VIEW citydb_view.nrg8_conv_system_boiler AS
SELECT
  co.id,
  co.objectclass_id,
  o.classname,
  co.gmlid,
  co.gmlid_codespace,
  co.name,
  co.name_codespace,
  co.description,
  co.envelope,
  co.creation_date,
  co.termination_date,
  co.relative_to_terrain,
  co.relative_to_water,
  co.last_modification_date,
  co.updating_person,
  co.reason_for_update,
  co.lineage,
  cs.model,
  cs.nbr,
  cs.year_of_manufacture,
  cs.inst_nom_pwr,
  cs.inst_nom_pwr_unit,
  cs.nom_effcy,
  cs.effcy_indicator,
  cs.start_of_life,
  cs.life_expect_value,
  cs.life_expect_value_unit,
  cs.main_maint_interval,
  cs.main_maint_interval_unit,
  cs.inst_in_ctyobj_id,
  cs.cityobject_id,
  b.condensation
FROM
  citydb.objectclass o,
  citydb.cityobject co,
  citydb.nrg8_conv_system cs,
  citydb.nrg8_boiler b
WHERE
  o.id = co.objectclass_id AND
  cs.id = co.id AND
  b.id = cs.id AND
  o.classname = 'Boiler';
--ALTER VIEW citydb_view.nrg8_conv_system_boiler OWNER TO postgres;

----------------------------------------------------------------
-- View CONV_SYSTEM_ELECTRICAL_RESISTANCE
----------------------------------------------------------------
DROP VIEW IF EXISTS citydb_view.nrg8_conv_system_electrical_resistance CASCADE;
CREATE OR REPLACE VIEW citydb_view.nrg8_conv_system_electrical_resistance AS
SELECT
  co.id,
  co.objectclass_id,
  o.classname,
  co.gmlid,
  co.gmlid_codespace,
  co.name,
  co.name_codespace,
  co.description,
  co.envelope,
  co.creation_date,
  co.termination_date,
  co.relative_to_terrain,
  co.relative_to_water,
  co.last_modification_date,
  co.updating_person,
  co.reason_for_update,
  co.lineage,
  cs.model,
  cs.nbr,
  cs.year_of_manufacture,
  cs.inst_nom_pwr,
  cs.inst_nom_pwr_unit,
  cs.nom_effcy,
  cs.effcy_indicator,
  cs.start_of_life,
  cs.life_expect_value,
  cs.life_expect_value_unit,
  cs.main_maint_interval,
  cs.main_maint_interval_unit,
  cs.inst_in_ctyobj_id,
  cs.cityobject_id
FROM
  citydb.objectclass o,
  citydb.cityobject co,
  citydb.nrg8_conv_system cs
WHERE
  o.id = co.objectclass_id AND
  cs.id = co.id AND
  o.classname = 'ElectricalResistance';
--ALTER VIEW citydb_view.nrg8_conv_system_electrical_resistance OWNER TO postgres;

----------------------------------------------------------------
-- View CONV_SYSTEM_HEAT_PUMP
----------------------------------------------------------------
DROP VIEW IF EXISTS citydb_view.nrg8_conv_system_heat_pump CASCADE;
CREATE OR REPLACE VIEW citydb_view.nrg8_conv_system_heat_pump AS
SELECT
  co.id,
  co.objectclass_id,
  o.classname,
  co.gmlid,
  co.gmlid_codespace,
  co.name,
  co.name_codespace,
  co.description,
  co.envelope,
  co.creation_date,
  co.termination_date,
  co.relative_to_terrain,
  co.relative_to_water,
  co.last_modification_date,
  co.updating_person,
  co.reason_for_update,
  co.lineage,
  cs.model,
  cs.nbr,
  cs.year_of_manufacture,
  cs.inst_nom_pwr,
  cs.inst_nom_pwr_unit,
  cs.nom_effcy,
  cs.effcy_indicator,
  cs.start_of_life,
  cs.life_expect_value,
  cs.life_expect_value_unit,
  cs.main_maint_interval,
  cs.main_maint_interval_unit,
  cs.inst_in_ctyobj_id,
  cs.cityobject_id,
  hp.heat_source,
  hp.cop_source_temp,
  hp.cop_source_temp_unit,
  hp.cop_oper_temp,
  hp.cop_oper_temp_unit
FROM
  citydb.objectclass o,
  citydb.cityobject co,
  citydb.nrg8_conv_system cs,
  citydb.nrg8_heat_pump hp
WHERE
  o.id = co.objectclass_id AND
  cs.id = co.id AND
  hp.id = cs.id AND
  o.classname = 'HeatPump';
--ALTER VIEW citydb_view.nrg8_conv_system_heat_pump OWNER TO postgres;

----------------------------------------------------------------
-- View CONV_SYSTEM_COMBINED_HEAT_POWER
----------------------------------------------------------------
DROP VIEW IF EXISTS citydb_view.nrg8_conv_system_combined_heat_power CASCADE;
CREATE OR REPLACE VIEW citydb_view.nrg8_conv_system_combined_heat_power AS
SELECT
  co.id,
  co.objectclass_id,
  o.classname,
  co.gmlid,
  co.gmlid_codespace,
  co.name,
  co.name_codespace,
  co.description,
  co.envelope,
  co.creation_date,
  co.termination_date,
  co.relative_to_terrain,
  co.relative_to_water,
  co.last_modification_date,
  co.updating_person,
  co.reason_for_update,
  co.lineage,
  cs.model,
  cs.nbr,
  cs.year_of_manufacture,
  cs.inst_nom_pwr,
  cs.inst_nom_pwr_unit,
  cs.nom_effcy,
  cs.effcy_indicator,
  cs.start_of_life,
  cs.life_expect_value,
  cs.life_expect_value_unit,
  cs.main_maint_interval,
  cs.main_maint_interval_unit,
  cs.inst_in_ctyobj_id,
  cs.cityobject_id,
  chp.techn_type,
  chp.therm_effcy,
  chp.electr_effcy
FROM
  citydb.cityobject co,
  citydb.objectclass o,
  citydb.nrg8_conv_system cs,
  citydb.nrg8_combined_heat_power chp
WHERE
  o.id = co.objectclass_id AND
  cs.id = co.id AND
  chp.id = cs.id AND
  o.classname = 'CombinedHeatPower';
--ALTER VIEW citydb_view.nrg8_conv_system_combined_heat_power OWNER TO postgres;

----------------------------------------------------------------
-- View CONV_SYSTEM_HEAT_EXCHANGER
----------------------------------------------------------------
DROP VIEW IF EXISTS citydb_view.nrg8_conv_system_heat_exchanger CASCADE;
CREATE OR REPLACE VIEW citydb_view.nrg8_conv_system_heat_exchanger AS
SELECT
  co.id,
  co.objectclass_id,
  o.classname,
  co.gmlid,
  co.gmlid_codespace,
  co.name,
  co.name_codespace,
  co.description,
  co.envelope,
  co.creation_date,
  co.termination_date,
  co.relative_to_terrain,
  co.relative_to_water,
  co.last_modification_date,
  co.updating_person,
  co.reason_for_update,
  co.lineage,
  cs.model,
  cs.nbr,
  cs.year_of_manufacture,
  cs.inst_nom_pwr,
  cs.inst_nom_pwr_unit,
  cs.nom_effcy,
  cs.effcy_indicator,
  cs.start_of_life,
  cs.life_expect_value,
  cs.life_expect_value_unit,
  cs.main_maint_interval,
  cs.main_maint_interval_unit,
  cs.inst_in_ctyobj_id,
  cs.cityobject_id,
  he.network_id,
  he.network_node_id,
  he.prim_heat_supplier
FROM
  citydb.cityobject co,
  citydb.objectclass o,
  citydb.nrg8_conv_system cs,
  citydb.nrg8_heat_exchanger he
WHERE
  o.id = co.objectclass_id AND
  cs.id = co.id AND
  he.id = cs.id AND
  o.classname = 'HeatExchanger';
--ALTER VIEW citydb_view.nrg8_conv_system_heat_exchanger OWNER TO postgres;

----------------------------------------------------------------
-- View CONV_SYSTEM_MECH_VENTILATION
----------------------------------------------------------------
DROP VIEW IF EXISTS citydb_view.nrg8_conv_system_mech_ventilation CASCADE;
CREATE OR REPLACE VIEW citydb_view.nrg8_conv_system_mech_ventilation AS
SELECT
  co.id,
  co.objectclass_id,
  o.classname,
  co.gmlid,
  co.gmlid_codespace,
  co.name,
  co.name_codespace,
  co.description,
  co.envelope,
  co.creation_date,
  co.termination_date,
  co.relative_to_terrain,
  co.relative_to_water,
  co.last_modification_date,
  co.updating_person,
  co.reason_for_update,
  co.lineage,
  cs.model,
  cs.nbr,
  cs.year_of_manufacture,
  cs.inst_nom_pwr,
  cs.inst_nom_pwr_unit,
  cs.nom_effcy,
  cs.effcy_indicator,
  cs.start_of_life,
  cs.life_expect_value,
  cs.life_expect_value_unit,
  cs.main_maint_interval,
  cs.main_maint_interval_unit,
  cs.inst_in_ctyobj_id,
  cs.cityobject_id,
  mv.heat_recovery,
  mv.recuperation
FROM
  citydb.cityobject co,
  citydb.objectclass o,
  citydb.nrg8_conv_system cs,
  citydb.nrg8_mech_ventilation mv
WHERE
  o.id = co.objectclass_id AND
  cs.id = co.id AND
  mv.id = cs.id AND
  o.classname = 'MechanicalVentilation';
--ALTER VIEW citydb_view.nrg8_conv_system_mech_ventilation OWNER TO postgres;

----------------------------------------------------------------
-- View CONV_SYSTEM_CHILLER
----------------------------------------------------------------
DROP VIEW IF EXISTS citydb_view.nrg8_conv_system_chiller CASCADE;
CREATE OR REPLACE VIEW citydb_view.nrg8_conv_system_chiller AS
SELECT
  co.id,
  co.objectclass_id,
  o.classname,
  co.gmlid,
  co.gmlid_codespace,
  co.name,
  co.name_codespace,
  co.description,
  co.envelope,
  co.creation_date,
  co.termination_date,
  co.relative_to_terrain,
  co.relative_to_water,
  co.last_modification_date,
  co.updating_person,
  co.reason_for_update,
  co.lineage,
  cs.model,
  cs.nbr,
  cs.year_of_manufacture,
  cs.inst_nom_pwr,
  cs.inst_nom_pwr_unit,
  cs.nom_effcy,
  cs.effcy_indicator,
  cs.start_of_life,
  cs.life_expect_value,
  cs.life_expect_value_unit,
  cs.main_maint_interval,
  cs.main_maint_interval_unit,
  cs.inst_in_ctyobj_id,
  cs.cityobject_id,
  ch.condensation_type,
  ch.compressor_type,
  ch.refrigerant
FROM
  citydb.cityobject co,
  citydb.objectclass o,
  citydb.nrg8_conv_system cs,
  citydb.nrg8_chiller ch
WHERE
  o.id = co.objectclass_id AND
  cs.id = co.id AND
  ch.id = cs.id AND
  o.classname = 'Chiller';
--ALTER VIEW citydb_view.nrg8_conv_system_chiller OWNER TO postgres;

----------------------------------------------------------------
-- View CONV_SYSTEM_AIR_COMPRESSOR
----------------------------------------------------------------
DROP VIEW IF EXISTS citydb_view.nrg8_conv_system_air_compressor CASCADE;
CREATE OR REPLACE VIEW citydb_view.nrg8_conv_system_air_compressor AS
SELECT
  co.id,
  co.objectclass_id,
  o.classname,
  co.gmlid,
  co.gmlid_codespace,
  co.name,
  co.name_codespace,
  co.description,
  co.envelope,
  co.creation_date,
  co.termination_date,
  co.relative_to_terrain,
  co.relative_to_water,
  co.last_modification_date,
  co.updating_person,
  co.reason_for_update,
  co.lineage,
  cs.model,
  cs.nbr,
  cs.year_of_manufacture,
  cs.inst_nom_pwr,
  cs.inst_nom_pwr_unit,
  cs.nom_effcy,
  cs.effcy_indicator,
  cs.start_of_life,
  cs.life_expect_value,
  cs.life_expect_value_unit,
  cs.main_maint_interval,
  cs.main_maint_interval_unit,
  cs.inst_in_ctyobj_id,
  cs.cityobject_id,
  ac.compressor_type,
  ac.pressure,
  ac.pressure_unit
FROM
  citydb.cityobject co,
  citydb.objectclass o,
  citydb.nrg8_conv_system cs,
  citydb.nrg8_air_compressor ac
WHERE
  o.id = co.objectclass_id AND
  cs.id = co.id AND
  ac.id = cs.id AND
  o.classname = 'AirCompressor';
--ALTER VIEW citydb_view.nrg8_conv_system_air_compressor OWNER TO postgres;

----------------------------------------------------------------
-- View ENERGY_DEMAND_TS
----------------------------------------------------------------
CREATE OR REPLACE VIEW citydb_view.nrg8_energy_demand_ts AS
SELECT
  e.id,
  e.objectclass_id,
  o1.classname,
  e.gmlid,
  e.gmlid_codespace,
  e.name,
  e.name_codespace,
  e.description,
  e.end_use,
  e.max_load,
  e.max_load_unit,
  e.cityobject_id,
  ts.id AS ts_id,
  ts.objectclass_id AS ts_objectclass_id,
  o2.classname AS ts_classname,
  ts.gmlid AS ts_gmlid,
  ts.gmlid_codespace AS ts_gmlid_codespace,
  ts.name AS ts_name,
  ts.name_codespace AS ts_name_codespace,
  ts.description AS ts_description,
  ts.acquisition_method AS ts_acquisition_method,
  ts.interpolation_type AS ts_interpolation_type,
  ts.quality_description AS ts_quality_description,
  ts.source AS ts_source,
  ts.time_array AS ts_time_array,
  ts.values_array AS ts_values_array,
  ts.values_unit AS ts_values_unit,
  ts.array_length AS ts_array_length,
  ts.temporal_extent_begin AS ts_temporal_extent_begin,
  ts.temporal_extent_end AS ts_temporal_extent_end,
  ts.time_interval AS ts_time_interval,
  ts.time_interval_unit AS ts_time_interval_unit,
  tsf.file_path AS ts_file_path,
  tsf.file_name AS ts_file_name,
  tsf.file_extension AS ts_file_extension,
  tsf.nbr_header_lines AS ts_nbr_header_lines,
  tsf.field_sep AS ts_field_sep,
  tsf.record_sep AS ts_record_sep,
  tsf.dec_symbol AS ts_dec_symbol,
  tsf.time_col_nbr AS ts_time_col_nbr,
  tsf.value_col_nbr AS ts_value_col_nbr,
  tsf.is_compressed AS ts_is_compressed
FROM
  citydb.objectclass o1,
  citydb.nrg8_energy_demand e
	    LEFT OUTER JOIN (
      (citydb.nrg8_time_series ts
			    LEFT OUTER JOIN
          citydb.nrg8_time_series_file tsf
			    ON ts.id=tsf.id)
					   LEFT OUTER JOIN
			       citydb.objectclass o2
			       ON o2.id = ts.objectclass_id
      ) ON e.time_series_id=ts.id
WHERE
  o1.id = e.objectclass_id;
--ALTER VIEW citydb_view.nrg8_energy_demand_ts OWNER TO postgres;

----------------------------------------------------------------
-- View FINAL_ENERGY_TS
----------------------------------------------------------------
CREATE OR REPLACE VIEW citydb_view.nrg8_final_energy_ts AS
SELECT
  e.id,
  e.objectclass_id,
  o1.classname,
  e.gmlid,
  e.gmlid_codespace,
  e.name,
  e.name_codespace,
  e.description,
  e.nrg_car_type,
  e.nrg_car_prim_nrg_factor,
  e.nrg_car_prim_nrg_factor_unit,
  e.nrg_car_nrg_density,
  e.nrg_car_nrg_density_unit,
  e.nrg_car_co2_emission,
  e.nrg_car_co2_emission_unit,
  ts.id AS ts_id,
  ts.objectclass_id AS ts_objectclass_id,
  o2.classname AS ts_classname,
  ts.gmlid AS ts_gmlid,
  ts.gmlid_codespace AS ts_gmlid_codespace,
  ts.name AS ts_name,
  ts.name_codespace AS ts_name_codespace,
  ts.description AS ts_description,
  ts.acquisition_method AS ts_acquisition_method,
  ts.interpolation_type AS ts_interpolation_type,
  ts.quality_description AS ts_quality_description,
  ts.source AS ts_source,
  ts.time_array AS ts_time_array,
  ts.values_array AS ts_values_array,
  ts.values_unit AS ts_values_unit,
  ts.array_length AS ts_array_length,
  ts.temporal_extent_begin AS ts_temporal_extent_begin,
  ts.temporal_extent_end AS ts_temporal_extent_end,
  ts.time_interval AS ts_time_interval,
  ts.time_interval_unit AS ts_time_interval_unit,
  tsf.file_path AS ts_file_path,
  tsf.file_name AS ts_file_name,
  tsf.file_extension AS ts_file_extension,
  tsf.nbr_header_lines AS ts_nbr_header_lines,
  tsf.field_sep AS ts_field_sep,
  tsf.record_sep AS ts_record_sep,
  tsf.dec_symbol AS ts_dec_symbol,
  tsf.time_col_nbr AS ts_time_col_nbr,
  tsf.value_col_nbr AS ts_value_col_nbr,
  tsf.is_compressed AS ts_is_compressed
FROM
  citydb.objectclass o1,
  citydb.nrg8_final_energy e
	    LEFT OUTER JOIN (
      (citydb.nrg8_time_series ts
			    LEFT OUTER JOIN
          citydb.nrg8_time_series_file tsf
			    ON ts.id=tsf.id)
					   LEFT OUTER JOIN
			       citydb.objectclass o2
			       ON o2.id = ts.objectclass_id
      ) ON e.time_series_id=ts.id
WHERE
  o1.id = e.objectclass_id;
--ALTER VIEW citydb_view.nrg8_final_energy_ts OWNER TO postgres;

----------------------------------------------------------------
-- View WEATHER_DATA_TS
----------------------------------------------------------------
CREATE OR REPLACE VIEW citydb_view.nrg8_weather_data_ts AS
SELECT
  wd.id,
  wd.gmlid,
  wd.gmlid_codespace,
  wd.name,
  wd.name_codespace,
  wd.description,
  wd.type,
  wd.cityobject_id,
  wd.install_point,
  ts.id AS ts_id,
  ts.objectclass_id AS ts_objectclass_id,
  o.classname AS ts_classname,
  ts.gmlid AS ts_gmlid,
  ts.gmlid_codespace AS ts_gmlid_codespace,
  ts.name AS ts_name,
  ts.name_codespace AS ts_name_codespace,
  ts.description AS ts_description,
  ts.acquisition_method AS ts_acquisition_method,
  ts.interpolation_type AS ts_interpolation_type,
  ts.quality_description AS ts_quality_description,
  ts.source AS ts_source,
  ts.time_array AS ts_time_array,
  ts.values_array AS ts_values_array,
  ts.values_unit AS ts_values_unit,
  ts.array_length AS ts_array_length,
  ts.temporal_extent_begin AS ts_temporal_extent_begin,
  ts.temporal_extent_end AS ts_temporal_extent_end,
  ts.time_interval AS ts_time_interval,
  ts.time_interval_unit AS ts_time_interval_unit,
  tsf.file_path AS ts_file_path,
  tsf.file_name AS ts_file_name,
  tsf.file_extension AS ts_file_extension,
  tsf.nbr_header_lines AS ts_nbr_header_lines,
  tsf.field_sep AS ts_field_sep,
  tsf.record_sep AS ts_record_sep,
  tsf.dec_symbol AS ts_dec_symbol,
  tsf.time_col_nbr AS ts_time_col_nbr,
  tsf.value_col_nbr AS ts_value_col_nbr,
  tsf.is_compressed AS ts_is_compressed
FROM
  citydb.nrg8_weather_data wd
    	LEFT OUTER JOIN (
      ((citydb.nrg8_time_series ts
			     LEFT OUTER JOIN
           citydb.nrg8_time_series_file tsf
				   ON ts.id=tsf.id)
			LEFT OUTER JOIN
			citydb.objectclass o
			ON o.id = ts.objectclass_id)
	) ON wd.time_series_id=ts.id;
--ALTER VIEW citydb_view.nrg8_weather_data_ts OWNER TO postgres;

----------------------------------------------------------------
-- View DAILY_SCHEDULE_TS
----------------------------------------------------------------
CREATE OR REPLACE VIEW citydb_view.nrg8_daily_schedule_ts AS
SELECT
  d.id,
  d.day_type,
  d.period_of_year_id,
  ts.id AS ts_id,
  ts.objectclass_id AS ts_objectclass_id,
  o.classname AS ts_classname,
  ts.gmlid AS ts_gmlid,
  ts.gmlid_codespace AS ts_gmlid_codespace,
  ts.name AS ts_name,
  ts.name_codespace AS ts_name_codespace,
  ts.description AS ts_description,
  ts.acquisition_method AS ts_acquisition_method,
  ts.interpolation_type AS ts_interpolation_type,
  ts.quality_description AS ts_quality_description,
  ts.source AS ts_source,
  ts.time_array AS ts_time_array,
  ts.values_array AS ts_values_array,
  ts.values_unit AS ts_values_unit,
  ts.array_length AS ts_array_length,
  ts.temporal_extent_begin AS ts_temporal_extent_begin,
  ts.temporal_extent_end AS ts_temporal_extent_end,
  ts.time_interval AS ts_time_interval,
  ts.time_interval_unit AS ts_time_interval_unit,
  tsf.file_path AS ts_file_path,
  tsf.file_name AS ts_file_name,
  tsf.file_extension AS ts_file_extension,
  tsf.nbr_header_lines AS ts_nbr_header_lines,
  tsf.field_sep AS ts_field_sep,
  tsf.record_sep AS ts_record_sep,
  tsf.dec_symbol AS ts_dec_symbol,
  tsf.time_col_nbr AS ts_time_col_nbr,
  tsf.value_col_nbr AS ts_value_col_nbr,
  tsf.is_compressed AS ts_is_compressed
FROM
  citydb.nrg8_daily_schedule d
    	LEFT OUTER JOIN (
      ((citydb.nrg8_time_series ts
			     LEFT OUTER JOIN
           citydb.nrg8_time_series_file tsf
				   ON ts.id=tsf.id)
			LEFT OUTER JOIN
			citydb.objectclass o
			ON o.id = ts.objectclass_id)
	) ON d.time_series_id=ts.id;
--ALTER VIEW citydb_view.nrg8_daily_schedule_ts OWNER TO postgres;

----------------------------------------------------------------
-- View SCHEDULE_TIME_SERIES_TS
----------------------------------------------------------------
CREATE OR REPLACE VIEW citydb_view.nrg8_schedule_time_series_ts AS
SELECT
  s.id,
  s.objectclass_id,
  o1.classname,
  s.gmlid,
  s.gmlid_codespace,
  s.name,
  s.name_codespace,
  s.description,
  ts.id AS ts_id,
  ts.objectclass_id AS ts_objectclass_id,
  o2.classname AS ts_classname,
  ts.gmlid AS ts_gmlid,
  ts.gmlid_codespace AS ts_gmlid_codespace,
  ts.name AS ts_name,
  ts.name_codespace AS ts_name_codespace,
  ts.description AS ts_description,
  ts.acquisition_method AS ts_acquisition_method,
  ts.interpolation_type AS ts_interpolation_type,
  ts.quality_description AS ts_quality_description,
  ts.source AS ts_source,
  ts.time_array AS ts_time_array,
  ts.values_array AS ts_values_array,
  ts.values_unit AS ts_values_unit,
  ts.array_length AS ts_array_length,
  ts.temporal_extent_begin AS ts_temporal_extent_begin,
  ts.temporal_extent_end AS ts_temporal_extent_end,
  ts.time_interval AS ts_time_interval,
  ts.time_interval_unit AS ts_time_interval_unit,
  tsf.file_path AS ts_file_path,
  tsf.file_name AS ts_file_name,
  tsf.file_extension AS ts_file_extension,
  tsf.nbr_header_lines AS ts_nbr_header_lines,
  tsf.field_sep AS ts_field_sep,
  tsf.record_sep AS ts_record_sep,
  tsf.dec_symbol AS ts_dec_symbol,
  tsf.time_col_nbr AS ts_time_col_nbr,
  tsf.value_col_nbr AS ts_value_col_nbr,
  tsf.is_compressed AS ts_is_compressed
FROM
	citydb.objectclass o1,
  citydb.nrg8_schedule s
    	LEFT OUTER JOIN (
      ((citydb.nrg8_time_series ts
			     LEFT OUTER JOIN
           citydb.nrg8_time_series_file tsf
				   ON ts.id=tsf.id)
			LEFT OUTER JOIN
			citydb.objectclass o2
			ON o2.id = ts.objectclass_id)
	) ON s.time_series_id=ts.id
WHERE
  o1.id=s.objectclass_id AND
  o1.classname='TimeSeriesSchedule';
--ALTER VIEW citydb_view.nrg8_schedule_time_series_ts OWNER TO postgres;

-- ***********************************************************************
-- ***********************************************************************

DO
$$
BEGIN
RAISE NOTICE '

********************************

Energy ADE views data installation complete!

********************************

';
END
$$;
SELECT 'Energy ADE views installation complete!'::varchar AS installation_result;

-- ***********************************************************************
-- ***********************************************************************
--
-- END OF FILE
--
-- ***********************************************************************
-- ***********************************************************************