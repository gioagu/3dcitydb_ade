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
-- ********************* 06_Scenario_ADE_VIEWS.sql ***********************
--
-- This script adds views to the citydb_view schema.
-- which is itself created (if needed) by the current script. 
-- All views are prefixed with "scn2_".
--
-- ***********************************************************************
-- ***********************************************************************

CREATE SCHEMA IF NOT EXISTS citydb_view;

----------------------------------------------------------------
-- View TIME_SERIES_REGULAR
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.scn2_time_series_regular CASCADE;
CREATE OR REPLACE VIEW citydb_view.scn2_time_series_regular AS
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
  citydb.scn2_time_series ts 
WHERE 
  o.id = ts.objectclass_id AND
  o.classname='RegularTimeSeries'
ORDER BY ts.id;
--ALTER VIEW citydb_view.scn2_time_series_regular OWNER TO postgres;

----------------------------------------------------------------
-- View TIME_SERIES_IRREGULAR
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.scn2_time_series_irregular CASCADE;
CREATE OR REPLACE VIEW citydb_view.scn2_time_series_irregular AS
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
  citydb.scn2_time_series ts 
WHERE 
  o.id = ts.objectclass_id AND
  o.classname='IrregularTimeSeries'
ORDER BY ts.id;
--ALTER VIEW citydb_view.scn2_time_series_irregular OWNER TO postgres;

----------------------------------------------------------------
-- View TIME_SERIES_REGULAR_FILE
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.scn2_time_series_regular_file CASCADE;
CREATE OR REPLACE VIEW citydb_view.scn2_time_series_regular_file AS
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
  citydb.scn2_time_series ts 
  LEFT JOIN citydb.scn2_time_series_file tsf ON ts.id = tsf.id
WHERE 
  o.id = ts.objectclass_id AND
  o.classname='RegularTimeSeriesFile'
ORDER BY ts.id;
--ALTER VIEW citydb_view.scn2_time_series_regular_file OWNER TO postgres;

----------------------------------------------------------------
-- View TIME_SERIES_IRREGULAR_FILE
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.scn2_time_series_irregular_file CASCADE;
CREATE OR REPLACE VIEW citydb_view.scn2_time_series_irregular_file AS
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
  citydb.scn2_time_series ts 
  LEFT JOIN citydb.scn2_time_series_file tsf ON ts.id = tsf.id
WHERE 
  o.id = ts.objectclass_id AND
  o.classname='IrregularTimeSeriesFile'
ORDER BY ts.id;	
--ALTER VIEW citydb_view.scn2_time_series_irregular_file OWNER TO postgres;

----------------------------------------------------------------
-- View TIME_SERIES (generic)
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.scn2_time_series CASCADE;
CREATE OR REPLACE VIEW citydb_view.scn2_time_series AS
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
  citydb.scn2_time_series ts LEFT OUTER JOIN citydb.scn2_time_series_file tsf ON tsf.id = ts.id 
WHERE 
  o.id = ts.objectclass_id
ORDER BY ts.id;
--ALTER VIEW citydb_view.scn2_time_series OWNER TO postgres;

----------------------------------------------------------------
-- View SCENARIO
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.scn2_scenario CASCADE;
CREATE OR REPLACE VIEW citydb_view.scn2_scenario AS
SELECT 
  s.id, 
  s.objectclass_id,
  o.classname,
  s.scenario_parent_id,  
  s.gmlid, 
  s.gmlid_codespace, 
  s.name, 
  s.name_codespace, 
  s.description, 
  s.class,
  s.instant, 
  s.period_begin, 
  s.period_end, 	
  s.citymodel_id, 
  s.cityobject_id, 
  o2.classname AS co_classname,
  s.envelope, 	
  s.creator_name, 
  s.creation_date
FROM 
  citydb.objectclass o, 
  citydb.scn2_scenario s LEFT OUTER JOIN citydb.objectclass o2 ON o2.id = s.cityobject_id
WHERE 
  o.id = s.objectclass_id
ORDER BY s.id;
--ALTER VIEW citydb_view.scn2_scenario OWNER TO postgres;

----------------------------------------------------------------
-- View OPERATION_COMPLEX
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.scn2_operation_complex CASCADE;
CREATE OR REPLACE VIEW citydb_view.scn2_operation_complex AS
SELECT 
  a.id, 
  a.objectclass_id, 
  o.classname, 
  a.operation_parent_id, 
  a.operation_root_id, 
  a.gmlid, 
  a.gmlid_codespace, 
  a.name, 
  a.name_codespace, 
  a.description, 
  a.class, 
  a.instant,
  a.period_begin,
  a.period_end  
FROM 
  citydb.scn2_operation a, 
  citydb.objectclass o
WHERE 
  o.id = a.objectclass_id AND
  o.classname='ComplexOperation'
ORDER BY a.id;
--ALTER VIEW citydb_view.scn2_operation_complex OWNER TO postgres;

----------------------------------------------------------------
-- View OPERATION_SIMPLE
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.scn2_operation_simple CASCADE;
CREATE OR REPLACE VIEW citydb_view.scn2_operation_simple AS
SELECT 
  a.id, 
  a.objectclass_id, 
  o.classname, 
  a.operation_parent_id, 
  a.operation_root_id, 
  a.gmlid, 
  a.gmlid_codespace, 
  a.name, 
  a.name_codespace, 
  a.description, 
  a.class,
  a.instant,
  a.period_begin,
  a.period_end,
  a.pos_nbr,
--  
  a.parent_feature_uri, 
  a.feature_uri, 
  a.attribute_uri, 
  a.citydb_object_id, 
  a.citydb_table_name, 
  a.citydb_column_name, 
  a.citydb_function,
  a.citydb_genericattrib_name,  
  a.strval, 
  a.booleanval, 
  a.intval, 
  a.realval, 
  a.unit, 
  a.dateval, 
  a.urival, 
  a.geomval, 
  a.time_series_id, 
  a.xml_source
FROM 
  citydb.objectclass o, 
  citydb.scn2_operation a
WHERE 
  o.id = a.objectclass_id AND
  o.classname IN ('AddFeature', 'RemoveFeature', 'ChangeFeatureAttribute')
ORDER BY a.id;	
--ALTER VIEW citydb_view.scn2_operation_simple OWNER TO postgres;

----------------------------------------------------------------
-- View OPERATION_SIMPLE_REMOVE
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.scn2_operation_simple_remove CASCADE;
CREATE OR REPLACE VIEW citydb_view.scn2_operation_simple_remove AS
SELECT 
  a.id, 
  a.objectclass_id, 
  o.classname, 
  a.operation_parent_id, 
  a.operation_root_id, 
  a.gmlid, 
  a.gmlid_codespace, 
  a.name, 
  a.name_codespace, 
  a.description, 
  a.class, 
  a.instant,
  a.period_begin,
  a.period_end,  
  a.pos_nbr,
--  
  a.feature_uri
FROM 
  citydb.objectclass o, 
  citydb.scn2_operation a 
WHERE 
  o.id = a.objectclass_id AND
  o.classname='RemoveFeature'
ORDER BY a.id;	
--ALTER VIEW citydb_view.scn2_operation_simple_remove OWNER TO postgres;

----------------------------------------------------------------
-- View OPERATION_SIMPLE_ADD
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.scn2_operation_simple_add CASCADE;
CREATE OR REPLACE VIEW citydb_view.scn2_operation_simple_add AS
SELECT 
  a.id, 
  a.objectclass_id, 
  o.classname, 
  a.operation_parent_id, 
  a.operation_root_id, 
  a.gmlid, 
  a.gmlid_codespace, 
  a.name, 
  a.name_codespace, 
  a.description, 
  a.class,
  a.instant,
  a.period_begin,
  a.period_end,   
  a.pos_nbr,
--  
  a.parent_feature_uri,	
  a.xml_source
FROM 
  citydb.objectclass o, 
  citydb.scn2_operation a
WHERE 
  o.id = a.objectclass_id AND
  o.classname= 'AddFeature'
ORDER BY a.id;	
--ALTER VIEW citydb_view.scn2_operation_simple_add OWNER TO postgres;

----------------------------------------------------------------
-- View OPERATION_SIMPLE_CHANGE
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.scn2_operation_simple_change CASCADE;
CREATE OR REPLACE VIEW citydb_view.scn2_operation_simple_change AS
SELECT 
  a.id, 
  a.objectclass_id, 
  o.classname, 
  a.operation_parent_id, 
  a.operation_root_id, 
  a.gmlid, 
  a.gmlid_codespace, 
  a.name, 
  a.name_codespace, 
  a.description, 
  a.class,
  a.instant,
  a.period_begin,
  a.period_end,   
  a.pos_nbr,
--  
  a.attribute_uri, 
  a.citydb_object_id, 
  a.citydb_table_name, 
  a.citydb_column_name, 
  a.citydb_function,
  a.citydb_genericattrib_name,    
  a.strval, 
  a.booleanval, 
  a.intval, 
  a.realval, 
  a.unit, 
  a.dateval, 
  a.urival, 
  a.geomval, 
  a.time_series_id
FROM 
  citydb.objectclass o, 
  citydb.scn2_operation a
WHERE 
  o.id = a.objectclass_id AND
  o.classname= 'ChangeFeatureAttribute'
ORDER BY a.id;	
--ALTER VIEW citydb_view.scn2_operation_simple_change OWNER TO postgres;

----------------------------------------------------------------
-- View SCENARIO_TO_OPERATION
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.scn2_scenario_to_operation CASCADE;
CREATE OR REPLACE VIEW citydb_view.scn2_scenario_to_operation AS
SELECT 
  sa.scenario_id, 
  o1.classname AS scn_classname, 
  sa.operation_id, 
  o2.classname AS act_classname, 
  sa.pos_nbr
FROM 
  citydb.scn2_operation a, 
  citydb.objectclass o2, 
  citydb.scn2_scenario s, 
  citydb.objectclass o1, 
  citydb.scn2_scenario_to_operation sa
WHERE 
  o2.id = a.objectclass_id AND
  o1.id = s.objectclass_id AND
  sa.scenario_id = s.id AND
  sa.operation_id = a.id
ORDER BY sa.scenario_id, sa.pos_nbr;
--ALTER VIEW citydb_view.scn2_scenario_to_operation OWNER TO postgres;

----------------------------------------------------------------
-- View RESOURCE
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.scn2_resource CASCADE;
CREATE OR REPLACE VIEW citydb_view.scn2_resource AS
SELECT 
  r.id, 
  r.objectclass_id, 
  o.classname, 
  r.gmlid, 
  r.gmlid_codespace, 
  r.name, 
  r.name_codespace, 
  r.description, 
  r.type, 
  r.quantity, 
  r.quantity_unit, 
  r.total_cost, 
  r.total_cost_unit,
  r.unitary_cost, 
  r.unitary_cost_unit,
  r.is_renewable, 
  r.scenario_id, 
  r.operation_id
FROM 
  citydb.objectclass o, 
  citydb.scn2_resource r
WHERE 
  o.id = r.objectclass_id
ORDER BY r.id;
--ALTER VIEW citydb_view.scn2_resource OWNER TO postgres;

----------------------------------------------------------------
-- View RESOURCE_MONEY
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.scn2_resource_money CASCADE;
CREATE OR REPLACE VIEW citydb_view.scn2_resource_money AS
SELECT 
  r.id, 
  r.objectclass_id, 
  o.classname, 
  r.gmlid, 
  r.gmlid_codespace, 
  r.name, 
  r.name_codespace, 
  r.description, 
  r.type, 
  r.quantity, 
  r.quantity_unit, 
  r.total_cost, 
  r.total_cost_unit,
  r.unitary_cost, 
  r.unitary_cost_unit,
  r.is_renewable, 
  r.scenario_id, 
  r.operation_id
FROM 
  citydb.objectclass o, 
  citydb.scn2_resource r
WHERE 
  o.id = r.objectclass_id AND
	o.classname='MoneyResource'
ORDER BY r.id;
--ALTER VIEW citydb_view.scn2_resource_money OWNER TO postgres;

----------------------------------------------------------------
-- View RESOURCE_TIME
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.scn2_resource_time CASCADE;
CREATE OR REPLACE VIEW citydb_view.scn2_resource_time AS
SELECT 
  r.id, 
  r.objectclass_id, 
  o.classname, 
  r.gmlid, 
  r.gmlid_codespace, 
  r.name, 
  r.name_codespace, 
  r.description, 
  r.type, 
  r.quantity, 
  r.quantity_unit, 
  r.total_cost, 
  r.total_cost_unit,
  r.unitary_cost, 
  r.unitary_cost_unit,
  r.is_renewable, 
  r.scenario_id, 
  r.operation_id
FROM 
  citydb.objectclass o, 
  citydb.scn2_resource r
WHERE 
  o.id = r.objectclass_id AND
	o.classname='TimeResource'
ORDER BY r.id;	
--ALTER VIEW citydb_view.scn2_resource_time OWNER TO postgres;

----------------------------------------------------------------
-- View RESOURCE_MATERIAL
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.scn2_resource_material CASCADE;
CREATE OR REPLACE VIEW citydb_view.scn2_resource_material AS
SELECT 
  r.id, 
  r.objectclass_id, 
  o.classname, 
  r.gmlid, 
  r.gmlid_codespace, 
  r.name, 
  r.name_codespace, 
  r.description, 
  r.type, 
  r.quantity, 
  r.quantity_unit, 
  r.total_cost, 
  r.total_cost_unit,
  r.unitary_cost, 
  r.unitary_cost_unit,
  r.is_renewable, 
  r.scenario_id, 
  r.operation_id
FROM 
  citydb.objectclass o, 
  citydb.scn2_resource r
WHERE 
  o.id = r.objectclass_id AND
	o.classname='MaterialResource'
ORDER BY r.id;	
--ALTER VIEW citydb_view.scn2_resource_material OWNER TO postgres;

----------------------------------------------------------------
-- View RESOURCE_ENERGY
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.scn2_resource_energy CASCADE;
CREATE OR REPLACE VIEW citydb_view.scn2_resource_energy AS
SELECT 
  r.id, 
  r.objectclass_id, 
  o.classname, 
  r.gmlid, 
  r.gmlid_codespace, 
  r.name, 
  r.name_codespace, 
  r.description, 
  r.type, 
  r.quantity, 
  r.quantity_unit, 
  r.total_cost, 
  r.total_cost_unit,
  r.unitary_cost, 
  r.unitary_cost_unit,
  r.is_renewable, 
  r.scenario_id, 
  r.operation_id
FROM 
  citydb.objectclass o, 
  citydb.scn2_resource r
WHERE 
  o.id = r.objectclass_id AND
	o.classname='EnergyResource'
ORDER BY r.id;	
--ALTER VIEW citydb_view.scn2_resource_energy OWNER TO postgres;

----------------------------------------------------------------
-- View RESOURCE_OTHER
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.scn2_resource_other CASCADE;
CREATE OR REPLACE VIEW citydb_view.scn2_resource_other AS
SELECT 
  r.id, 
  r.objectclass_id, 
  o.classname, 
  r.gmlid, 
  r.gmlid_codespace, 
  r.name, 
  r.name_codespace, 
  r.description, 
  r.type, 
  r.quantity, 
  r.quantity_unit, 
  r.total_cost, 
  r.total_cost_unit,
  r.unitary_cost, 
  r.unitary_cost_unit,
  r.is_renewable, 
  r.scenario_id, 
  r.operation_id
FROM 
  citydb.objectclass o, 
  citydb.scn2_resource r
WHERE 
  o.id = r.objectclass_id AND
	o.classname='OtherResource'
ORDER BY r.id;	
--ALTER VIEW citydb_view.scn2_resource_energy OWNER TO postgres;

----------------------------------------------------------------
-- View SCENARIO_PARAMETER
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.scn2_scenario_parameter CASCADE;
CREATE OR REPLACE VIEW citydb_view.scn2_scenario_parameter AS
SELECT
  sp.id, 
  sp.type, 
  sp.name, 
  sp.name_codespace, 
  sp.description, 
  sp.class,
	sp.constraint_type,
	sp.sim_name,
  sp.sim_description,
	sp.sim_reference,
  sp.aggregation_type,
  sp.temp_aggregation,
  sp.strval, 
  sp.booleanval, 
  sp.intval, 
  sp.realval, 
  sp.unit, 
  sp.dateval, 
  sp.urival, 
  sp.geomval, 
  sp.time_series_id, 
  sp.cityobject_id, 
  sp.scenario_id
FROM 
  citydb.scn2_scenario_parameter sp
ORDER BY sp.id;	
--ALTER VIEW citydb_view.scn2_scenario_parameter OWNER TO postgres;

----------------------------------------------------------------
-- View OPERATION_SIMPLE_CHANGE_TS
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.scn2_operation_simple_change_ts CASCADE;
CREATE OR REPLACE VIEW citydb_view.scn2_operation_simple_change_ts AS
SELECT 
  a.id, 
  a.objectclass_id, 
  o.classname, 
  a.operation_parent_id, 
  a.operation_root_id, 
  a.gmlid, 
  a.gmlid_codespace, 
  a.name, 
  a.name_codespace, 
  a.description, 
  a.class, 
  a.pos_nbr,
  a.attribute_uri, 
  a.citydb_object_id, 
  a.citydb_table_name, 
  a.citydb_column_name, 
  a.citydb_function, 
  a.strval, 
  a.booleanval, 
  a.intval, 
  a.realval, 
  a.unit, 
  a.dateval, 
  a.urival, 
  a.geomval, 
--  a.cityobject_id,
--
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
  citydb.objectclass o, 
  citydb.scn2_operation a LEFT OUTER JOIN (
  (citydb.scn2_time_series ts LEFT OUTER JOIN citydb.scn2_time_series_file tsf ON tsf.id = ts.id) LEFT OUTER JOIN citydb.objectclass o2 ON o2.id = ts.objectclass_id
   ) ON ts.id = a.time_series_id
WHERE 
  o.id = a.objectclass_id AND
  o.classname= 'ChangeFeatureAttribute'
ORDER BY a.id;		
--ALTER VIEW citydb_view.scn2_operation_simple_change_ts OWNER TO postgres;

----------------------------------------------------------------
-- View SCENARIO_PARAMETER_TS
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.scn2_scenario_parameter_ts CASCADE;
CREATE OR REPLACE VIEW citydb_view.scn2_scenario_parameter_ts AS
SELECT
  sp.id, 
  sp.type, 
  sp.name, 
  sp.name_codespace, 
  sp.description, 
  sp.class,
  sp.constraint_type,
  sp.sim_name,
  sp.sim_description,
  sp.sim_reference,
  sp.aggregation_type,
  sp.temp_aggregation,	
  sp.strval, 
  sp.booleanval, 
  sp.intval, 
  sp.realval, 
  sp.unit, 
  sp.dateval, 
  sp.urival, 
  sp.geomval, 
  sp.cityobject_id, 
  sp.scenario_id,
--
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
  citydb.scn2_scenario_parameter sp LEFT OUTER JOIN (
  (citydb.scn2_time_series ts LEFT OUTER JOIN citydb.scn2_time_series_file tsf ON tsf.id = ts.id) LEFT OUTER JOIN citydb.objectclass o ON o.id = ts.objectclass_id
   ) ON ts.id = sp.time_series_id
ORDER BY sp.id;
--ALTER VIEW citydb_view.scn2_scenario_parameter_ts OWNER TO postgres;

-- ***********************************************************************
-- ***********************************************************************

DO
$$
BEGIN
RAISE NOTICE '

********************************

Scenario ADE views installation complete!

********************************

';
END
$$;
SELECT 'Scenario ADE views installed correctly!'::varchar AS installation_result;


-- ***********************************************************************
-- ***********************************************************************
--
-- END OF FILE
--
-- ***********************************************************************
-- ***********************************************************************