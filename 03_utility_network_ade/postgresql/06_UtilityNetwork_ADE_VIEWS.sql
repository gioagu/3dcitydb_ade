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
-- ******************* 06_UtilityNetworks_ADE_VIEWS.sql ******************
--
-- This script adds views to the citydb_view schema.
-- which is itself created (if needed) by the current script. 
-- All views are prefixed with "utn9_".
--
-- ***********************************************************************
-- ***********************************************************************

CREATE SCHEMA IF NOT EXISTS citydb_view;

----------------------------------------------------------------
-- View UTN9_NODE
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.utn9_node CASCADE;
CREATE OR REPLACE VIEW citydb_view.utn9_node AS
SELECT
  n.id,
  n.objectclass_id,
  o.classname,
  n.gmlid,
  n.gmlid_codespace,
  n.name,
  n.name_codespace,
  n.description,
  n.type,
  n.connection_signature,
  n.link_control,
  n.feat_graph_id,
  n.point_geom
FROM
  citydb.utn9_node n,
  citydb.objectclass o
WHERE
  o.id = n.objectclass_id;
--ALTER VIEW citydb_view.utn9_node OWNER TO postgres;

----------------------------------------------------------------
-- View UTN9_LINK_INTERIOR_FEATURE
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.utn9_link_interior_feature CASCADE;
CREATE OR REPLACE VIEW citydb_view.utn9_link_interior_feature AS
SELECT
  l.id,
  l.objectclass_id,
  o.classname,
  l.gmlid,
  l.gmlid_codespace,
  l.name,
  l.name_codespace,
  l.description,
  l.direction,
  l.link_control,
  l.start_node_id,
  n1.type AS start_node_type,
  l.end_node_id,
  n2.type AS end_node_type,
  l.feat_graph_id,
  l.line_geom
FROM
  citydb.utn9_link l,
  citydb.objectclass o,
  citydb.utn9_node n1,
  citydb.utn9_node n2
WHERE
  o.id = l.objectclass_id AND
  o.classname='InteriorFeatureLink' AND
  n1.id = l.start_node_id AND
  n2.id = l.end_node_id;
--ALTER VIEW citydb_view.utn9_link_interior_feature OWNER TO postgres;

----------------------------------------------------------------
-- View UTN9_LINK_INTERFEATURE
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.utn9_link_interfeature CASCADE;
CREATE OR REPLACE VIEW citydb_view.utn9_link_interfeature AS
SELECT
  l.id,
  l.objectclass_id,
  o.classname,
  l.gmlid,
  l.gmlid_codespace,
  l.name,
  l.name_codespace,
  l.description,
  l.direction,
  l.link_control,
  l.type,
  l.start_node_id,
  n1.type AS start_node_type,
  l.end_node_id,
  n2.type AS end_node_type,
  l.ntw_graph_id,
  l.line_geom
FROM
  citydb.utn9_link l,
  citydb.objectclass o,
  citydb.utn9_node n1,
  citydb.utn9_node n2
WHERE
  n1.id = l.start_node_id AND
  n2.id = l.end_node_id AND
  o.id = l.objectclass_id AND
  o.classname='InterFeatureLink';
--ALTER VIEW citydb_view.utn9_link_interfeature OWNER TO postgres;

----------------------------------------------------------------
-- View UTN9_LINK_NETWORK
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.utn9_link_network CASCADE;
CREATE OR REPLACE VIEW citydb_view.utn9_link_network AS
SELECT
  l.id,
  l.objectclass_id,
  o.classname,
  l.gmlid,
  l.gmlid_codespace,
  l.name,
  l.name_codespace,
  l.description,
  l.direction,
  l.link_control,
  l.start_node_id,
  n1.type AS start_node_type,
  l.end_node_id,
  n2.type AS end_node_type,
  l.ntw_graph_id,
  l.line_geom
FROM
  citydb.utn9_link l,
  citydb.objectclass o,
  citydb.utn9_node n1,
  citydb.utn9_node n2
WHERE
  n1.id = l.start_node_id AND
  n2.id = l.end_node_id AND
  o.id = l.objectclass_id AND
  o.classname='NetworkLink';
--ALTER VIEW citydb_view.utn9_link_network OWNER TO postgres;

----------------------------------------------------------------
-- View UTN9_NETWORK_GRAPH
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.utn9_network_graph CASCADE;
CREATE OR REPLACE VIEW citydb_view.utn9_network_graph AS
SELECT
  ng.id,
  ng.objectclass_id,
  o.classname,
  ng.gmlid,
  ng.gmlid_codespace,
  ng.name,
  ng.name_codespace,
  ng.description,
  ng.network_id
FROM
  citydb.utn9_network_graph ng,
  citydb.objectclass o
WHERE
  o.id = ng.objectclass_id;
--ALTER VIEW citydb_view.utn9_network_graph OWNER TO postgres;

----------------------------------------------------------------
-- View UTN9_FEATURE_GRAPH
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.utn9_feature_graph CASCADE;
CREATE OR REPLACE VIEW citydb_view.utn9_feature_graph AS
SELECT
  fg.id,
  fg.objectclass_id,
  o.classname,
  fg.gmlid,
  fg.gmlid_codespace,
  fg.name,
  fg.name_codespace,
  fg.description,
  fg.ntw_feature_id,
  fg.ntw_graph_id
FROM
  citydb.objectclass o,
  citydb.utn9_feature_graph fg
WHERE
  o.id = fg.objectclass_id;
--ALTER VIEW citydb_view.utn9_feature_graph OWNER TO postgres;

----------------------------------------------------------------
-- View UTN9_NETWORK_GRAPH
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.utn9_network_graph CASCADE;
CREATE OR REPLACE VIEW citydb_view.utn9_network_graph AS
SELECT
  ng.id,
  ng.objectclass_id,
  o.classname,
  ng.gmlid,
  ng.gmlid_codespace,
  ng.name,
  ng.name_codespace,
  ng.description,
  ng.network_id
FROM
  citydb.objectclass o,
  citydb.utn9_network_graph ng
WHERE
  o.id = ng.objectclass_id;
--ALTER VIEW citydb_view.utn9_network_graph OWNER TO postgres;

----------------------------------------------------------------
-- View UTN9_NETWORK
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.utn9_network CASCADE;
CREATE OR REPLACE VIEW citydb_view.utn9_network AS
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
  n.network_parent_id,
  n.network_root_id,
  n.class,
  n.function,
  n.usage,
  n.commodity_id
FROM
  citydb.objectclass o,
  citydb.utn9_network n,
  citydb.cityobject co
WHERE
  o.id = co.objectclass_id AND
  n.id = co.id;
--ALTER VIEW citydb_view.utn9_network OWNER TO postgres;

-- ----------------------------------------------------------------
-- -- View UTN9_NETWORK_FEATURE (ABSTRACT)
-- ----------------------------------------------------------------
-- DROP VIEW IF EXISTS    citydb_view.utn9_network_feature CASCADE;
-- CREATE OR REPLACE VIEW citydb_view.utn9_network_feature AS
-- SELECT
  -- co.id,
  -- co.objectclass_id,
  -- o.classname,
  -- co.gmlid,
  -- co.gmlid_codespace,
  -- co.name,
  -- co.name_codespace,
  -- co.description,
  -- co.envelope,
  -- co.creation_date,
  -- co.termination_date,
  -- co.relative_to_terrain,
  -- co.relative_to_water,
  -- co.last_modification_date,
  -- co.updating_person,
  -- co.reason_for_update,
  -- co.lineage,
  -- nf.ntw_feature_parent_id,
  -- nf.ntw_feature_root_id,
  -- nf.class,
  -- nf.function,
  -- nf.usage,
  -- nf.year_of_construction,
  -- nf.status,
  -- nf.location_quality,
  -- nf.elevation_quality,
  -- nf.cityobject_id,
  -- nf.prot_element_id,
  -- nf.geom
-- FROM
  -- citydb.objectclass o,
  -- citydb.cityobject co,
  -- citydb.utn9_network_feature nf
-- WHERE
  -- o.id = co.objectclass_id AND
  -- nf.id = co.id;
-- --ALTER VIEW citydb_view.utn9_network_feature OWNER TO postgres;

----------------------------------------------------------------
-- View UTN9_NTW_FEAT_COMPLEX_FUNCT_ELEM
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.utn9_ntw_feat_complex_funct_elem CASCADE;
CREATE OR REPLACE VIEW citydb_view.utn9_ntw_feat_complex_funct_elem AS
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
  nf.ntw_feature_parent_id,
  nf.ntw_feature_root_id,
  nf.class,
  nf.function,
  nf.usage,
  nf.year_of_construction,
  nf.status,
  nf.location_quality,
  nf.elevation_quality,
  nf.conn_cityobject_id,
  nf.prot_element_id,
  nf.geom
FROM
  citydb.objectclass o,
  citydb.cityobject co,
  citydb.utn9_network_feature nf
WHERE
  o.id = co.objectclass_id AND
  nf.id = co.id AND
	o.classname='ComplexFunctionalElement';
--ALTER VIEW citydb_view.utn9_ntw_feat_complex_funct_elem OWNER TO postgres;

----------------------------------------------------------------
-- View UTN9_NTW_FEAT_SIMPLE_FUNCT_ELEM
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.utn9_ntw_feat_simple_funct_elem CASCADE;
CREATE OR REPLACE VIEW citydb_view.utn9_ntw_feat_simple_funct_elem AS
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
  nf.ntw_feature_parent_id,
  nf.ntw_feature_root_id,
  nf.class,
  nf.function,
  nf.usage,
  nf.year_of_construction,
  nf.status,
  nf.location_quality,
  nf.elevation_quality,
  nf.conn_cityobject_id,
  nf.prot_element_id,
  nf.geom
FROM
  citydb.objectclass o,
  citydb.cityobject co,
  citydb.utn9_network_feature nf
WHERE
  o.id = co.objectclass_id AND
  nf.id = co.id AND
	o.classname='SimpleFunctionalElement';
--ALTER VIEW citydb_view.utn9_ntw_feat_simple_funct_elem OWNER TO postgres;

----------------------------------------------------------------
-- View UTN9_NTW_FEAT_TERM_ELEM
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.utn9_ntw_feat_term_elem CASCADE;
CREATE OR REPLACE VIEW citydb_view.utn9_ntw_feat_term_elem AS
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
  nf.ntw_feature_parent_id,
  nf.ntw_feature_root_id,
  nf.class,
  nf.function,
  nf.usage,
  nf.year_of_construction,
  nf.status,
  nf.location_quality,
  nf.elevation_quality,
  nf.conn_cityobject_id,
  nf.prot_element_id,
  nf.geom
FROM
  citydb.objectclass o,
  citydb.cityobject co,
  citydb.utn9_network_feature nf
WHERE
  o.id = co.objectclass_id AND
  nf.id = co.id AND
	o.classname='TerminalElement';
--ALTER VIEW citydb_view.utn9_ntw_feat_term_elem OWNER TO postgres;

----------------------------------------------------------------
-- View UTN9_NTW_FEAT_DEVICE_STORAGE
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.utn9_ntw_feat_device_storage CASCADE;
CREATE OR REPLACE VIEW citydb_view.utn9_ntw_feat_device_storage AS
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
  nf.ntw_feature_parent_id,
  nf.ntw_feature_root_id,
  nf.class,
  nf.function,
  nf.usage,
  nf.year_of_construction,
  nf.status,
  nf.location_quality,
  nf.elevation_quality,
  nf.conn_cityobject_id,
  nf.prot_element_id,
  nf.geom
FROM
  citydb.objectclass o,
  citydb.cityobject co,
  citydb.utn9_network_feature nf
WHERE
  o.id = co.objectclass_id AND
  nf.id = co.id AND
	o.classname='StorageDevice';
--ALTER VIEW citydb_view.utn9_ntw_feat_device_storage OWNER TO postgres;

----------------------------------------------------------------
-- View UTN9_NTW_FEAT_DEVICE_TECH
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.utn9_ntw_feat_device_tech CASCADE;
CREATE OR REPLACE VIEW citydb_view.utn9_ntw_feat_device_tech AS
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
  nf.ntw_feature_parent_id,
  nf.ntw_feature_root_id,
  nf.class,
  nf.function,
  nf.usage,
  nf.year_of_construction,
  nf.status,
  nf.location_quality,
  nf.elevation_quality,
  nf.conn_cityobject_id,
  nf.prot_element_id,
  nf.geom
FROM
  citydb.objectclass o,
  citydb.cityobject co,
  citydb.utn9_network_feature nf
WHERE
  o.id = co.objectclass_id AND
  nf.id = co.id AND
	o.classname='TechDevice';
--ALTER VIEW citydb_view.utn9_ntw_feat_device_tech OWNER TO postgres;

----------------------------------------------------------------
-- View UTN9_NTW_FEAT_DEVICE_MEAS
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.utn9_ntw_feat_device_meas CASCADE;
CREATE OR REPLACE VIEW citydb_view.utn9_ntw_feat_device_meas AS
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
  nf.ntw_feature_parent_id,
  nf.ntw_feature_root_id,
  nf.class,
  nf.function,
  nf.usage,
  nf.year_of_construction,
  nf.status,
  nf.location_quality,
  nf.elevation_quality,
  nf.conn_cityobject_id,
  nf.prot_element_id,
  nf.geom
FROM
  citydb.objectclass o,
  citydb.cityobject co,
  citydb.utn9_network_feature nf
WHERE
  o.id = co.objectclass_id AND
  nf.id = co.id AND
	o.classname='MeasurementDevice';
--ALTER VIEW citydb_view.utn9_ntw_feat_device_meas OWNER TO postgres;

----------------------------------------------------------------
-- View UTN9_NTW_FEAT_DEVICE_CONTROLLER
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.utn9_ntw_feat_device_controller CASCADE;
CREATE OR REPLACE VIEW citydb_view.utn9_ntw_feat_device_controller AS
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
  nf.ntw_feature_parent_id,
  nf.ntw_feature_root_id,
  nf.class,
  nf.function,
  nf.usage,
  nf.year_of_construction,
  nf.status,
  nf.location_quality,
  nf.elevation_quality,
  nf.conn_cityobject_id,
  nf.prot_element_id,
  nf.geom
FROM
  citydb.objectclass o,
  citydb.cityobject co,
  citydb.utn9_network_feature nf
WHERE
  o.id = co.objectclass_id AND
  nf.id = co.id AND
	o.classname='ControllerDevice';
--ALTER VIEW citydb_view.utn9_ntw_feat_device_controller OWNER TO postgres;

----------------------------------------------------------------
-- View UTN9_NTW_FEAT_DEVICE_GENERIC
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.utn9_ntw_feat_device_generic CASCADE;
CREATE OR REPLACE VIEW citydb_view.utn9_ntw_feat_device_generic AS
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
  nf.ntw_feature_parent_id,
  nf.ntw_feature_root_id,
  nf.class,
  nf.function,
  nf.usage,
  nf.year_of_construction,
  nf.status,
  nf.location_quality,
  nf.elevation_quality,
  nf.conn_cityobject_id,
  nf.prot_element_id,
  nf.geom
FROM
  citydb.objectclass o,
  citydb.cityobject co,
  citydb.utn9_network_feature nf
WHERE
  o.id = co.objectclass_id AND
  nf.id = co.id AND
	o.classname='AnyDevice';
--ALTER VIEW citydb_view.utn9_ntw_feat_device_any OWNER TO postgres;

----------------------------------------------------------------
-- View UTN9_NTW_FEAT_DISTRIB_ELEM_PIPE_ROUND
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.utn9_ntw_feat_distrib_elem_pipe_round CASCADE;
CREATE OR REPLACE VIEW citydb_view.utn9_ntw_feat_distrib_elem_pipe_round AS
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
  nf.ntw_feature_parent_id,
  nf.ntw_feature_root_id,
  nf.class,
  nf.function,
  nf.usage,
  nf.year_of_construction,
  nf.status,
  nf.location_quality,
  nf.elevation_quality,
  nf.conn_cityobject_id,
  nf.prot_element_id,
  nf.geom,
  de.function_of_line,
  de.is_gravity,
  de.ext_width,
  de.ext_width_unit,
  de.ext_height,
  de.ext_height_unit,
  de.ext_diameter,
  de.ext_diameter_unit,
  de.int_diameter,
  de.int_diameter_unit
FROM
  citydb.objectclass o,
  citydb.cityobject co,
  citydb.utn9_network_feature nf,
  citydb.utn9_distrib_element de
WHERE
  o.id = co.objectclass_id AND
  nf.id = co.id AND
  de.id = nf.id AND
  o.classname='RoundPipe';
--ALTER VIEW citydb_view.utn9_ntw_feat_distrib_elem_pipe_round OWNER TO postgres;

----------------------------------------------------------------
-- View UTN9_NTW_FEAT_DISTRIB_ELEM_PIPE_RECT
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.utn9_ntw_feat_distrib_elem_pipe_rect CASCADE;
CREATE OR REPLACE VIEW citydb_view.utn9_ntw_feat_distrib_elem_pipe_rect AS
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
  nf.ntw_feature_parent_id,
  nf.ntw_feature_root_id,
  nf.class,
  nf.function,
  nf.usage,
  nf.year_of_construction,
  nf.status,
  nf.location_quality,
  nf.elevation_quality,
  nf.conn_cityobject_id,
  nf.prot_element_id,
  nf.geom,
  de.function_of_line,
  de.is_gravity,
  de.ext_width,
  de.ext_width_unit,
  de.ext_height,
  de.ext_height_unit,
  de.ext_diameter,
  de.ext_diameter_unit,
  de.int_width,
  de.int_width_unit,
  de.int_height,
  de.int_height_unit
FROM
  citydb.objectclass o,
  citydb.cityobject co,
  citydb.utn9_network_feature nf,
  citydb.utn9_distrib_element de
WHERE
  o.id = co.objectclass_id AND
  nf.id = co.id AND
  de.id = nf.id AND
  o.classname='RectangularPipe';
--ALTER VIEW citydb_view.utn9_ntw_feat_distrib_elem_pipe_rect OWNER TO postgres;

----------------------------------------------------------------
-- View UTN9_NTW_FEAT_DISTRIB_ELEM_PIPE_OTHER_SHAPE
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.utn9_ntw_feat_distrib_elem_pipe_other_shape CASCADE;
CREATE OR REPLACE VIEW citydb_view.utn9_ntw_feat_distrib_elem_pipe_other_shape AS
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
  nf.ntw_feature_parent_id,
  nf.ntw_feature_root_id,
  nf.class,
  nf.function,
  nf.usage,
  nf.year_of_construction,
  nf.status,
  nf.location_quality,
  nf.elevation_quality,
  nf.conn_cityobject_id,
  nf.prot_element_id,
  nf.geom,
  de.function_of_line,
  de.is_gravity,
  de.ext_width,
  de.ext_width_unit,
  de.ext_height,
  de.ext_height_unit,
  de.ext_diameter,
  de.ext_diameter_unit
FROM
  citydb.objectclass o,
  citydb.cityobject co,
  citydb.utn9_network_feature nf,
  citydb.utn9_distrib_element de
WHERE
  o.id = co.objectclass_id AND
  nf.id = co.id AND
  de.id = nf.id AND
  o.classname='OtherShapePipe';

--ALTER VIEW citydb_view.utn9_ntw_feat_distrib_elem_pipe_other_shape OWNER TO postgres;

----------------------------------------------------------------
-- View UTN9_NTW_FEAT_DISTRIB_ELEM_CABLE
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.utn9_ntw_feat_distrib_elem_cable CASCADE;
CREATE OR REPLACE VIEW citydb_view.utn9_ntw_feat_distrib_elem_cable AS
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
  nf.ntw_feature_parent_id,
  nf.ntw_feature_root_id,
  nf.class,
  nf.function,
  nf.usage,
  nf.year_of_construction,
  nf.status,
  nf.location_quality,
  nf.elevation_quality,
  nf.conn_cityobject_id,
  nf.prot_element_id,
  nf.geom,
  de.function_of_line,
  de.is_transmission,
  de.is_communication,
  de.cross_section,
  de.cross_section_unit
FROM
  citydb.objectclass o,
  citydb.cityobject co,
  citydb.utn9_network_feature nf,
  citydb.utn9_distrib_element de
WHERE
  o.id = co.objectclass_id AND
  nf.id = co.id AND
  de.id = nf.id AND
  o.classname='Cable';
--ALTER VIEW citydb_view.utn9_ntw_feat_distrib_elem_cable OWNER TO postgres;

----------------------------------------------------------------
-- View UTN9_NTW_FEAT_DISTRIB_ELEM_CANAL
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.utn9_ntw_feat_distrib_elem_canal CASCADE;
CREATE OR REPLACE VIEW citydb_view.utn9_ntw_feat_distrib_elem_canal AS
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
  nf.ntw_feature_parent_id,
  nf.ntw_feature_root_id,
  nf.class,
  nf.function,
  nf.usage,
  nf.year_of_construction,
  nf.status,
  nf.location_quality,
  nf.elevation_quality,
  nf.conn_cityobject_id,
  nf.prot_element_id,
  nf.geom,
  de.function_of_line,
  de.is_gravity,
  de.ext_width,
  de.ext_width_unit,
  de.ext_height,
  de.ext_height_unit,
  de.ext_diameter,
  de.ext_diameter_unit,
  de.slope_range_from,
  de.slope_range_to,
  de.slope_range_unit,
  de.profile_name
FROM
  citydb.objectclass o,
  citydb.cityobject co,
  citydb.utn9_network_feature nf,
  citydb.utn9_distrib_element de
WHERE
  o.id = co.objectclass_id AND
  nf.id = co.id AND
  de.id = nf.id AND
  o.classname='Canal';
--ALTER VIEW citydb_view.utn9_ntw_feat_distrib_elem_canal OWNER TO postgres;

----------------------------------------------------------------
-- View UTN9_NTW_FEAT_DISTRIB_ELEM_CANAL_SEMI_OPEN
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.utn9_ntw_feat_distrib_elem_canal_semi_open CASCADE;
CREATE OR REPLACE VIEW citydb_view.utn9_ntw_feat_distrib_elem_canal_semi_open AS
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
  nf.ntw_feature_parent_id,
  nf.ntw_feature_root_id,
  nf.class,
  nf.function,
  nf.usage,
  nf.year_of_construction,
  nf.status,
  nf.location_quality,
  nf.elevation_quality,
  nf.conn_cityobject_id,
  nf.prot_element_id,
  nf.geom,
  de.function_of_line,
  de.is_gravity,
  de.ext_width,
  de.ext_width_unit,
  de.ext_height,
  de.ext_height_unit,
  de.ext_diameter,
  de.ext_diameter_unit,
  de.slope_range_from,
  de.slope_range_to,
  de.slope_range_unit,
  de.profile_name
FROM
  citydb.objectclass o,
  citydb.cityobject co,
  citydb.utn9_network_feature nf,
  citydb.utn9_distrib_element de
WHERE
  o.id = co.objectclass_id AND
  nf.id = co.id AND
  de.id = nf.id AND
  o.classname='SemiOpenCanal';
--ALTER VIEW citydb_view.utn9_ntw_feat_distrib_elem_canal_semi_open OWNER TO postgres;

----------------------------------------------------------------
-- View UTN9_NTW_FEAT_DISTRIB_ELEM_CANAL_CLOSED
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.utn9_ntw_feat_distrib_elem_canal_closed CASCADE;
CREATE OR REPLACE VIEW citydb_view.utn9_ntw_feat_distrib_elem_canal_closed AS
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
  nf.ntw_feature_parent_id,
  nf.ntw_feature_root_id,
  nf.class,
  nf.function,
  nf.usage,
  nf.year_of_construction,
  nf.status,
  nf.location_quality,
  nf.elevation_quality,
  nf.conn_cityobject_id,
  nf.prot_element_id,
  nf.geom,
  de.function_of_line,	
  de.is_gravity,
  de.ext_width,
  de.ext_width_unit,
  de.ext_height,
  de.ext_height_unit,
  de.ext_diameter,
  de.ext_diameter_unit,
  de.slope_range_from,
  de.slope_range_to,
  de.slope_range_unit,
  de.profile_name
FROM
  citydb.objectclass o,
  citydb.cityobject co,
  citydb.utn9_network_feature nf,
  citydb.utn9_distrib_element de
WHERE
  o.id = co.objectclass_id AND
  nf.id = co.id AND
  de.id = nf.id AND
  o.classname='ClosedCanal';
--ALTER VIEW citydb_view.utn9_ntw_feat_canal_semi_open OWNER TO postgres;

----------------------------------------------------------------
-- View UTN9_NTW_FEAT_PROT_ELEM_SHELL_RECT
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.utn9_ntw_feat_prot_elem_shell_rect CASCADE;
CREATE OR REPLACE VIEW citydb_view.utn9_ntw_feat_prot_elem_shell_rect AS
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
  nf.ntw_feature_parent_id,
  nf.ntw_feature_root_id,
  nf.class,
  nf.function,
  nf.usage,
  nf.year_of_construction,
  nf.status,
  nf.location_quality,
  nf.elevation_quality,
  nf.conn_cityobject_id,
  nf.prot_element_id,
  nf.geom,
  pe.ext_width,
  pe.ext_width_unit,
  pe.ext_height,
  pe.ext_height_unit,
  pe.ext_diameter,
  pe.ext_diameter_unit,
  pe.int_width,
  pe.int_width_unit,
  pe.int_height,
  pe.int_height_unit
FROM
  citydb.objectclass o,
  citydb.cityobject co,
  citydb.utn9_network_feature nf,
  citydb.utn9_protective_element pe
WHERE
  o.id = co.objectclass_id AND
  nf.id = co.id AND
  pe.id = nf.id AND
	o.classname='RectangularShell';
--ALTER VIEW citydb_view.utn9_ntw_feat_prot_elem_shell_rect OWNER TO postgres;

----------------------------------------------------------------
-- View UTN9_NTW_FEAT_PROT_ELEM_SHELL_ROUND
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.utn9_ntw_feat_prot_elem_shell_round CASCADE;
CREATE OR REPLACE VIEW citydb_view.utn9_ntw_feat_prot_elem_shell_round AS
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
  nf.ntw_feature_parent_id,
  nf.ntw_feature_root_id,
  nf.class,
  nf.function,
  nf.usage,
  nf.year_of_construction,
  nf.status,
  nf.location_quality,
  nf.elevation_quality,
  nf.conn_cityobject_id,
  nf.prot_element_id,
  nf.geom,
  pe.ext_width,
  pe.ext_width_unit,
  pe.ext_height,
  pe.ext_height_unit,
  pe.ext_diameter,
  pe.ext_diameter_unit,
  pe.int_diameter,
  pe.int_diameter_unit
FROM
  citydb.objectclass o,
  citydb.cityobject co,
  citydb.utn9_network_feature nf,
  citydb.utn9_protective_element pe
WHERE
  o.id = co.objectclass_id AND
  nf.id = co.id AND
  pe.id = nf.id AND
	o.classname='RoundShell';
--ALTER VIEW citydb_view.utn9_ntw_feat_prot_elem_shell_round OWNER TO postgres;

----------------------------------------------------------------
-- View UTN9_NTW_FEAT_PROT_ELEM_SHELL_OTHER
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.utn9_ntw_feat_prot_elem_shell_other CASCADE;
CREATE OR REPLACE VIEW citydb_view.utn9_ntw_feat_prot_elem_shell_other AS
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
  nf.ntw_feature_parent_id,
  nf.ntw_feature_root_id,
  nf.class,
  nf.function,
  nf.usage,
  nf.year_of_construction,
  nf.status,
  nf.location_quality,
  nf.elevation_quality,
  nf.conn_cityobject_id,
  nf.prot_element_id,
  nf.geom,
  pe.ext_width,
  pe.ext_width_unit,
  pe.ext_height,
  pe.ext_height_unit,
  pe.ext_diameter,
  pe.ext_diameter_unit,
  pe.int_diameter,
  pe.int_diameter_unit
FROM
  citydb.objectclass o,
  citydb.cityobject co,
  citydb.utn9_network_feature nf,
  citydb.utn9_protective_element pe
WHERE
  o.id = co.objectclass_id AND
  nf.id = co.id AND
  pe.id = nf.id AND
	o.classname='OtherShell';
--ALTER VIEW citydb_view.utn9_ntw_feat_prot_elem_shell_other OWNER TO postgres;

----------------------------------------------------------------
-- View UTN9_NTW_FEAT_PROT_ELEM_BEDDING
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.utn9_ntw_feat_prot_elem_bedding CASCADE;
CREATE OR REPLACE VIEW citydb_view.utn9_ntw_feat_prot_elem_bedding AS
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
  nf.ntw_feature_parent_id,
  nf.ntw_feature_root_id,
  nf.class,
  nf.function,
  nf.usage,
  nf.year_of_construction,
  nf.status,
  nf.location_quality,
  nf.elevation_quality,
  nf.conn_cityobject_id,
  nf.prot_element_id,
  nf.geom,
  pe.width,
  pe.width_unit
FROM
  citydb.objectclass o,
  citydb.cityobject co,
  citydb.utn9_network_feature nf,
  citydb.utn9_protective_element pe
WHERE
  o.id = co.objectclass_id AND
  nf.id = co.id AND
  pe.id = nf.id AND
	o.classname='Bedding';
--ALTER VIEW citydb_view.utn9_ntw_feat_prot_elem_bedding OWNER TO postgres;

----------------------------------------------------------------
-- View UTN9_SUPPLY_AREA
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.utn9_supply_area CASCADE;
CREATE OR REPLACE VIEW citydb_view.utn9_supply_area AS
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
  cog.class, 
  cog.class_codespace, 
  cog.function, 
  cog.function_codespace, 
  cog.usage, 
  cog.usage_codespace, 
  cog.brep_id, 
  cog.other_geom, 
  cog.parent_cityobject_id
FROM 
  citydb.objectclass o, 
  citydb.cityobject co, 
  citydb.cityobjectgroup cog
WHERE 
  o.id = co.objectclass_id AND
  cog.id = co.id AND
	o.classname='SupplyArea';
--ALTER VIEW citydb_view.utn9_supply_area OWNER TO postgres;
	
----------------------------------------------------------------
-- View UTN9_SUPPLY_AREA_TO_CITYOBJECT
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.utn9_supply_area_to_cityobject CASCADE;	
CREATE OR REPLACE VIEW citydb_view.utn9_supply_area_to_cityobject AS 
 SELECT 
    gtc.cityobjectgroup_id AS supply_area_id,
    cog.objectclass_id AS sa_objectclass_id,
    o2.classname AS sa_classname,
    gtc.cityobject_id,
    co.objectclass_id AS co_objectclass_id,
    o1.classname AS co_classname,
    gtc.role
   FROM 
    citydb.cityobject cog,
    citydb.objectclass o1,
    citydb.objectclass o2,
    citydb.group_to_cityobject gtc,
    citydb.cityobject co
  WHERE
	cog.id = gtc.cityobjectgroup_id AND
	cog.objectclass_id = o2.id AND
	co.id = gtc.cityobject_id AND
	co.objectclass_id = o1.id AND
	o2.classname='SupplyArea';
--ALTER VIEW citydb_view.utn9_supply_area_to_cityobject OWNER TO postgres;	
	
----------------------------------------------------------------
-- View UTN9_MATERIAL
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.utn9_material CASCADE;
CREATE OR REPLACE VIEW citydb_view.utn9_material AS
SELECT 
  m.id, 
  m.objectclass_id, 
  o.classname, 
  m.material_parent_id, 
  m.material_root_id, 
  m.gmlid, 
  m.gmlid_codespace, 
  m.name, 
  m.name_codespace, 
  m.description, 
  m.type, 
  m.material_id
FROM 
  citydb.objectclass o, 
  citydb.utn9_material m
WHERE 
  o.id = m.objectclass_id;
--ALTER VIEW citydb_view.utn9_material OWNER TO postgres;

----------------------------------------------------------------
-- View UTN9_MATERIAL_INTERIOR
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.utn9_material_interior CASCADE;
CREATE OR REPLACE VIEW citydb_view.utn9_material_interior AS
SELECT 
  m.id, 
  m.objectclass_id, 
  o.classname, 
  m.material_parent_id, 
  m.material_root_id, 
  m.gmlid, 
  m.gmlid_codespace, 
  m.name, 
  m.name_codespace, 
  m.description, 
  m.type--, 
--  m.material_id
FROM 
  citydb.objectclass o, 
  citydb.utn9_material m
WHERE 
  o.id = m.objectclass_id AND
  o.classname='InteriorMaterial';
--ALTER VIEW citydb_view.utn9_material_interior OWNER TO postgres;

----------------------------------------------------------------
-- View UTN9_MATERIAL_EXTERIOR
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.utn9_material_exterior CASCADE;
CREATE OR REPLACE VIEW citydb_view.utn9_material_exterior AS
SELECT 
  m.id, 
  m.objectclass_id, 
  o.classname, 
  m.material_parent_id, 
  m.material_root_id, 
  m.gmlid, 
  m.gmlid_codespace, 
  m.name, 
  m.name_codespace, 
  m.description, 
  m.type--, 
--  m.material_id
FROM 
  citydb.objectclass o, 
  citydb.utn9_material m
WHERE 
  o.id = m.objectclass_id AND
  o.classname='ExteriorMaterial';
--ALTER VIEW citydb_view.utn9_material_exterior OWNER TO postgres;

----------------------------------------------------------------
-- View UTN9_MATERIAL_FILLING
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.utn9_material_filling CASCADE;
CREATE OR REPLACE VIEW citydb_view.utn9_material_filling AS
SELECT 
  m.id, 
  m.objectclass_id, 
  o.classname, 
--  m.material_parent_id, 
--  m.material_root_id, 
  m.gmlid, 
  m.gmlid_codespace, 
  m.name, 
  m.name_codespace, 
  m.description, 
  m.type, 
  m.material_id
FROM 
  citydb.objectclass o, 
  citydb.utn9_material m
WHERE 
  o.id = m.objectclass_id AND
  o.classname='FillingMaterial';
--ALTER VIEW citydb_view.utn9_material_filling OWNER TO postgres;

----------------------------------------------------------------
-- View UTN9_BUILDING
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.utn9_building CASCADE;
CREATE OR REPLACE VIEW citydb_view.utn9_building AS
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
  utn_b.nbr_occupants
FROM 
  citydb.objectclass o, 
  citydb.utn9_building utn_b, 
  citydb.building b, 
  citydb.cityobject co
WHERE 
  o.id = co.objectclass_id AND
  utn_b.id = b.id AND
  b.id = co.id AND
  o.classname='Building';
--ALTER VIEW citydb_view.utn9_building OWNER TO postgres;

----------------------------------------------------------------
-- View UTN9_BUILDING_PART
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.utn9_building_part CASCADE;
CREATE OR REPLACE VIEW citydb_view.utn9_building_part AS
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
  utn_b.nbr_occupants
FROM 
  citydb.objectclass o, 
  citydb.utn9_building utn_b, 
  citydb.building b, 
  citydb.cityobject co
WHERE 
  o.id = co.objectclass_id AND
  utn_b.id = b.id AND
  b.id = co.id AND
	o.classname='BuildingPart';
--ALTER VIEW citydb_view.utn9_building_part OWNER TO postgres;

----------------------------------------------------------------
-- View UTN9_COMMODITY
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.utn9_commodity CASCADE;
CREATE OR REPLACE VIEW citydb_view.utn9_commodity AS
SELECT 
  c.id, 
  c.objectclass_id, 
  o.classname, 
  c.gmlid, 
  c.gmlid_codespace, 
  c.name, 
  c.name_codespace, 
  c.description, 
  c.owner, 
  c.type, 
  c.is_corrosive, 
  c.is_explosive, 
  c.is_lighter_than_air, 
  c.flammability_ratio, 
  c.elec_conductivity_range_from, 
  c.elec_conductivity_range_to, 
  c.elec_conductivity_range_unit, 
  c.concentration, 
  c.concentration_unit, 
  c.ph_value_range_from, 
  c.ph_value_range_to, 
  c.ph_value_range_unit, 
  c.temperature_range_from, 
  c.temperature_range_to, 
  c.temperature_range_unit, 
  c.flow_rate_range_from, 
  c.flow_rate_range_to, 
  c.flow_rate_range_unit, 
  c.pressure_range_from, 
  c.pressure_range_to, 
  c.pressure_range_unit, 
  c.voltage_range_from, 
  c.voltage_range_to, 
  c.voltage_range_unit, 
  c.amperage_range_from, 
  c.amperage_range_to, 
  c.amperage_range_unit, 
  c.bandwidth_range_from, 
  c.bandwidth_range_to, 
  c.bandwidth_range_unit, 
  c.optical_mode
FROM 
  citydb.objectclass o, 
  citydb.utn9_commodity c
WHERE 
  o.id = c.objectclass_id;
--ALTER VIEW citydb_view.utn9_commodity OWNER TO postgres;

----------------------------------------------------------------
-- View UTN9_COMMODITY_ELECTRICAL_MEDIUM
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.utn9_commodity_electrical_medium CASCADE;
CREATE OR REPLACE VIEW citydb_view.utn9_commodity_electrical_medium AS
SELECT 
  c.id, 
  c.objectclass_id, 
  o.classname, 
  c.gmlid, 
  c.gmlid_codespace, 
  c.name, 
  c.name_codespace, 
  c.description, 
  c.owner, 
  c.type, 
--  c.is_corrosive, 
--  c.is_explosive, 
--  c.is_lighter_than_air, 
--  c.flammability_ratio, 
--  c.elec_conductivity_range_from, 
--  c.elec_conductivity_range_to, 
--  c.elec_conductivity_range_unit, 
--  c.concentration, 
--  c.concentration_unit, 
--  c.ph_value_range_from, 
--  c.ph_value_range_to, 
--  c.ph_value_range_unit, 
--  c.temperature_range_from, 
--  c.temperature_range_to, 
--  c.temperature_range_unit, 
--  c.flow_rate_range_from, 
--  c.flow_rate_range_to, 
--  c.flow_rate_range_unit, 
--  c.pressure_range_from, 
--  c.pressure_range_to, 
--  c.pressure_range_unit, 
  c.voltage_range_from, 
  c.voltage_range_to, 
  c.voltage_range_unit, 
  c.amperage_range_from, 
  c.amperage_range_to, 
  c.amperage_range_unit, 
  c.bandwidth_range_from, 
  c.bandwidth_range_to, 
  c.bandwidth_range_unit --, 
--  c.optical_mode
FROM 
  citydb.objectclass o, 
  citydb.utn9_commodity c
WHERE 
  o.id = c.objectclass_id AND
  o.classname='ElectricalMedium';
--ALTER VIEW citydb_view.utn9_commodity_electrical_medium OWNER TO postgres;

----------------------------------------------------------------
-- View UTN9_COMMODITY_LIQUID_MEDIUM
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.utn9_commodity_liquid_medium CASCADE;
CREATE OR REPLACE VIEW citydb_view.utn9_commodity_liquid_medium AS
SELECT 
  c.id, 
  c.objectclass_id, 
  o.classname, 
  c.gmlid, 
  c.gmlid_codespace, 
  c.name, 
  c.name_codespace, 
  c.description, 
  c.owner, 
  c.type, 
  c.is_corrosive, 
  c.is_explosive, 
--  c.is_lighter_than_air, 
  c.flammability_ratio, 
  c.elec_conductivity_range_from, 
  c.elec_conductivity_range_to, 
  c.elec_conductivity_range_unit, 
--  c.concentration, 
--  c.concentration_unit, 
  c.ph_value_range_from, 
  c.ph_value_range_to, 
  c.ph_value_range_unit, 
  c.temperature_range_from, 
  c.temperature_range_to, 
  c.temperature_range_unit, 
  c.flow_rate_range_from, 
  c.flow_rate_range_to, 
  c.flow_rate_range_unit, 
  c.pressure_range_from, 
  c.pressure_range_to, 
  c.pressure_range_unit --, 
--  c.voltage_range_from, 
--  c.voltage_range_to, 
--  c.voltage_range_unit, 
--  c.amperage_range_from, 
--  c.amperage_range_to, 
--  c.amperage_range_unit, 
--  c.bandwidth_range_from, 
--  c.bandwidth_range_to, 
--  c.bandwidth_range_unit, 
--  c.optical_mode
FROM 
  citydb.objectclass o, 
  citydb.utn9_commodity c
WHERE 
  o.id = c.objectclass_id AND
  o.classname='LiquidMedium';
--ALTER VIEW citydb_view.utn9_commodity_liquid_medium OWNER TO postgres;

----------------------------------------------------------------
-- View UTN9_COMMODITY_GASEOUS_MEDIUM
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.utn9_commodity_gaseous_medium CASCADE;
CREATE OR REPLACE VIEW citydb_view.utn9_commodity_gaseous_medium AS
SELECT 
  c.id, 
  c.objectclass_id, 
  o.classname, 
  c.gmlid, 
  c.gmlid_codespace, 
  c.name, 
  c.name_codespace, 
  c.description, 
  c.owner, 
  c.type, 
--  c.is_corrosive, 
  c.is_explosive, 
  c.is_lighter_than_air, 
--  c.flammability_ratio, 
  c.elec_conductivity_range_from, 
  c.elec_conductivity_range_to, 
  c.elec_conductivity_range_unit, 
  c.concentration, 
  c.concentration_unit, 
--  c.ph_value_range_from, 
--  c.ph_value_range_to, 
--  c.ph_value_range_unit, 
--  c.temperature_range_from, 
--  c.temperature_range_to, 
--  c.temperature_range_unit, 
--  c.flow_rate_range_from, 
--  c.flow_rate_range_to, 
--  c.flow_rate_range_unit, 
  c.pressure_range_from, 
  c.pressure_range_to, 
  c.pressure_range_unit --, 
--  c.voltage_range_from, 
--  c.voltage_range_to, 
--  c.voltage_range_unit, 
--  c.amperage_range_from, 
--  c.amperage_range_to, 
--  c.amperage_range_unit, 
--  c.bandwidth_range_from, 
--  c.bandwidth_range_to, 
--  c.bandwidth_range_unit, 
--  c.optical_mode
FROM 
  citydb.objectclass o, 
  citydb.utn9_commodity c
WHERE 
  o.id = c.objectclass_id AND
  o.classname='GaseousMedium';
--ALTER VIEW citydb_view.utn9_commodity_gaseous_medium OWNER TO postgres;

----------------------------------------------------------------
-- View UTN9_COMMODITY_SOLID_MEDIUM
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.utn9_commodity_solid_medium CASCADE;
CREATE OR REPLACE VIEW citydb_view.utn9_commodity_solid_medium AS
SELECT 
  c.id, 
  c.objectclass_id, 
  o.classname, 
  c.gmlid, 
  c.gmlid_codespace, 
  c.name, 
  c.name_codespace, 
  c.description, 
  c.owner, 
  c.type, 
--  c.is_corrosive, 
  c.is_explosive, 
--  c.is_lighter_than_air, 
  c.flammability_ratio, 
  c.elec_conductivity_range_from, 
  c.elec_conductivity_range_to, 
  c.elec_conductivity_range_unit, 
  c.concentration, 
  c.concentration_unit --, 
--  c.ph_value_range_from, 
--  c.ph_value_range_to, 
--  c.ph_value_range_unit, 
--  c.temperature_range_from, 
--  c.temperature_range_to, 
--  c.temperature_range_unit, 
--  c.flow_rate_range_from, 
--  c.flow_rate_range_to, 
--  c.flow_rate_range_unit, 
--  c.pressure_range_from, 
--  c.pressure_range_to, 
--  c.pressure_range_unit, 
--  c.voltage_range_from, 
--  c.voltage_range_to, 
--  c.voltage_range_unit, 
--  c.amperage_range_from, 
--  c.amperage_range_to, 
--  c.amperage_range_unit, 
--  c.bandwidth_range_from, 
--  c.bandwidth_range_to, 
--  c.bandwidth_range_unit, 
--  c.optical_mode
FROM 
  citydb.objectclass o, 
  citydb.utn9_commodity c
WHERE 
  o.id = c.objectclass_id AND
  o.classname='SolidMedium';
--ALTER VIEW citydb_view.utn9_commodity_solid_medium OWNER TO postgres;

----------------------------------------------------------------
-- View UTN9_COMMODITY_OPTICAL_MEDIUM
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.utn9_commodity_optical_medium CASCADE;
CREATE OR REPLACE VIEW citydb_view.utn9_commodity_optical_medium AS
SELECT 
  c.id, 
  c.objectclass_id, 
  o.classname, 
  c.gmlid, 
  c.gmlid_codespace, 
  c.name, 
  c.name_codespace, 
  c.description, 
  c.owner, 
  c.type, 
--  c.is_corrosive, 
--  c.is_explosive, 
--  c.is_lighter_than_air, 
--  c.flammability_ratio, 
--  c.elec_conductivity_range_from, 
--  c.elec_conductivity_range_to, 
--  c.elec_conductivity_range_unit, 
--  c.concentration, 
--  c.concentration_unit, 
--  c.ph_value_range_from, 
--  c.ph_value_range_to, 
--  c.ph_value_range_unit, 
--  c.temperature_range_from, 
--  c.temperature_range_to, 
--  c.temperature_range_unit, 
--  c.flow_rate_range_from, 
--  c.flow_rate_range_to, 
--  c.flow_rate_range_unit, 
--  c.pressure_range_from, 
--  c.pressure_range_to, 
--  c.pressure_range_unit, 
--  c.voltage_range_from, 
--  c.voltage_range_to, 
--  c.voltage_range_unit, 
--  c.amperage_range_from, 
--  c.amperage_range_to, 
--  c.amperage_range_unit, 
  c.bandwidth_range_from, 
  c.bandwidth_range_to, 
  c.bandwidth_range_unit, 
  c.optical_mode
FROM 
  citydb.objectclass o, 
  citydb.utn9_commodity c
WHERE 
  o.id = c.objectclass_id AND
  o.classname='OpticalMedium';
--ALTER VIEW citydb_view.utn9_commodity_optical_medium OWNER TO postgres;

----------------------------------------------------------------
-- View UTN9_COMMODITY_CLASSIFIER
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.utn9_commodity_classifier CASCADE;
CREATE OR REPLACE VIEW citydb_view.utn9_commodity_classifier AS
SELECT 
  cc.id, 
  cc.objectclass_id, 
  o.classname, 
  cc.gmlid, 
  cc.gmlid_codespace, 
  cc.name, 
  cc.name_codespace, 
  cc.description, 
  cc.mol_formula, 
  cc.mol_weight, 
  cc.mol_weight_unit, 
  cc.physical_form, 
  cc.signal_word, 
  cc.is_chemical_complex, 
  cc.haz_class, 
  cc.haz_class_category_code, 
  cc.haz_class_statement_code, 
  cc.haz_class_pictogram_code, 
  cc.haz_class_pictogram_uri, 
  cc.ec_number, 
  cc.cas_number, 
  cc.iuclid_chem_datasheet, 
  cc.commodity_id, 
  cc.material_id, 
  cc.hollow_space_id
FROM 
  citydb.objectclass o, 
  citydb.utn9_commodity_classifier cc
WHERE 
  o.id = cc.objectclass_id;
--ALTER VIEW citydb_view.utn9_commodity_classifier OWNER TO postgres;

----------------------------------------------------------------
-- View UTN9_COMMODITY_CLASSIFIER_CHEMICAL
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.utn9_commodity_classifier_chemical CASCADE;
CREATE OR REPLACE VIEW citydb_view.utn9_commodity_classifier_chemical AS
SELECT 
  cc.id, 
  cc.objectclass_id, 
  o.classname, 
  cc.gmlid, 
  cc.gmlid_codespace, 
  cc.name, 
  cc.name_codespace, 
  cc.description, 
  cc.mol_formula, 
  cc.mol_weight, 
  cc.mol_weight_unit, 
  cc.physical_form, 
  cc.signal_word, 
  cc.is_chemical_complex, 
  cc.haz_class, 
  cc.haz_class_category_code, 
  cc.haz_class_statement_code, 
  cc.haz_class_pictogram_code, 
  cc.haz_class_pictogram_uri, 
  cc.ec_number, 
  cc.cas_number, 
  cc.iuclid_chem_datasheet, 
  cc.commodity_id, 
  cc.material_id, 
  cc.hollow_space_id
FROM 
  citydb.objectclass o, 
  citydb.utn9_commodity_classifier cc
WHERE 
  o.id = cc.objectclass_id AND
  o.classname='ChemicalClassifier';
--ALTER VIEW citydb_view.utn9_commodity_classifier_chemical OWNER TO postgres;

----------------------------------------------------------------
-- View UTN9_COMMODITY_CLASSIFIER_GHS
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.utn9_commodity_classifier_ghs CASCADE;
CREATE OR REPLACE VIEW citydb_view.utn9_commodity_classifier_ghs AS
SELECT 
  cc.id, 
  cc.objectclass_id, 
  o.classname, 
  cc.gmlid, 
  cc.gmlid_codespace, 
  cc.name, 
  cc.name_codespace, 
  cc.description, 
  cc.mol_formula, 
  cc.mol_weight, 
  cc.mol_weight_unit, 
  cc.physical_form, 
  cc.signal_word, 
  cc.is_chemical_complex, 
  cc.haz_class, 
  cc.haz_class_category_code, 
  cc.haz_class_statement_code, 
  cc.haz_class_pictogram_code, 
  cc.haz_class_pictogram_uri, 
  cc.ec_number, 
  cc.cas_number, 
--  cc.iuclid_chem_datasheet, 
  cc.commodity_id, 
  cc.material_id, 
  cc.hollow_space_id
FROM 
  citydb.objectclass o, 
  citydb.utn9_commodity_classifier cc
WHERE 
  o.id = cc.objectclass_id AND
  o.classname='GHSClassifier';
--ALTER VIEW citydb_view.utn9_commodity_classifier_ghs OWNER TO postgres;

----------------------------------------------------------------
-- View UTN9_COMMODITY_CLASSIFIER_GENERIC
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.utn9_commodity_classifier_generic CASCADE;
CREATE OR REPLACE VIEW citydb_view.utn9_commodity_classifier_generic AS
SELECT 
  cc.id, 
  cc.objectclass_id, 
  o.classname, 
  cc.gmlid, 
  cc.gmlid_codespace, 
  cc.name, 
  cc.name_codespace, 
  cc.description, 
  cc.mol_formula, 
  cc.mol_weight, 
  cc.mol_weight_unit, 
  cc.physical_form, 
  cc.signal_word, 
  cc.is_chemical_complex, 
  cc.haz_class, 
  cc.haz_class_category_code, 
  cc.haz_class_statement_code, 
  cc.haz_class_pictogram_code, 
  cc.haz_class_pictogram_uri, 
--  cc.ec_number, 
--  cc.cas_number, 
--  cc.iuclid_chem_datasheet, 
  cc.commodity_id, 
  cc.material_id, 
  cc.hollow_space_id
FROM 
  citydb.objectclass o, 
  citydb.utn9_commodity_classifier cc
WHERE 
  o.id = cc.objectclass_id AND
  o.classname='GenericClassifier';
--ALTER VIEW citydb_view.utn9_commodity_classifier_generic OWNER TO postgres;

----------------------------------------------------------------
-- View UTN9_MEDIUM_SUPPLY
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.utn9_medium_supply CASCADE;
CREATE OR REPLACE VIEW citydb_view.utn9_medium_supply AS
SELECT 
  ms.id, 
  ms.objectclass_id, 
  o.classname, 
  ms.type, 
  ms.cur_flow_rate, 
  ms.cur_flow_rate_unit, 
  ms.cur_status, 
  ms.pot_flow_rate, 
  ms.pot_flow_rate_unit, 
  ms.pot_status, 
  ms.cityobject_id
FROM 
  citydb.objectclass o, 
  citydb.utn9_medium_supply ms
WHERE 
  o.id = ms.objectclass_id;
--ALTER VIEW citydb_view.utn9_medium_supply OWNER TO postgres;

----------------------------------------------------------------
-- View UTN9_MEDIUM_SUPPLY_ELECTRICAL
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.utn9_medium_supply_electrical CASCADE;
CREATE OR REPLACE VIEW citydb_view.utn9_medium_supply_electrical AS
SELECT 
  ms.id, 
  ms.objectclass_id, 
  o.classname, 
  ms.type, 
  ms.cur_flow_rate, 
  ms.cur_flow_rate_unit, 
  ms.cur_status, 
  ms.pot_flow_rate, 
  ms.pot_flow_rate_unit, 
  ms.pot_status, 
  ms.cityobject_id
FROM 
  citydb.objectclass o, 
  citydb.utn9_medium_supply ms
WHERE 
  o.id = ms.objectclass_id AND
	o.classname='ElectricalMediumSupply';
--ALTER VIEW citydb_view.utn9_medium_supply_electrical OWNER TO postgres;

----------------------------------------------------------------
-- View UTN9_MEDIUM_SUPPLY_GASEOUS
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.utn9_medium_supply_gaseous CASCADE;
CREATE OR REPLACE VIEW citydb_view.utn9_medium_supply_gaseous AS
SELECT 
  ms.id, 
  ms.objectclass_id, 
  o.classname, 
  ms.type, 
  ms.cur_flow_rate, 
  ms.cur_flow_rate_unit, 
  ms.cur_status, 
  ms.pot_flow_rate, 
  ms.pot_flow_rate_unit, 
  ms.pot_status, 
  ms.cityobject_id
FROM 
  citydb.objectclass o, 
  citydb.utn9_medium_supply ms
WHERE 
  o.id = ms.objectclass_id AND
	o.classname='GaseousMediumSupply';
--ALTER VIEW citydb_view.utn9_medium_supply_gaseous OWNER TO postgres;

----------------------------------------------------------------
-- View UTN9_MEDIUM_SUPPLY_LIQUID
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.utn9_medium_supply_liquid CASCADE;
CREATE OR REPLACE VIEW citydb_view.utn9_medium_supply_liquid AS
SELECT 
  ms.id, 
  ms.objectclass_id, 
  o.classname, 
  ms.type, 
  ms.cur_flow_rate, 
  ms.cur_flow_rate_unit, 
  ms.cur_status, 
  ms.pot_flow_rate, 
  ms.pot_flow_rate_unit, 
  ms.pot_status, 
  ms.cityobject_id
FROM 
  citydb.objectclass o, 
  citydb.utn9_medium_supply ms
WHERE 
  o.id = ms.objectclass_id AND
	o.classname='LiquidMediumSupply';

----------------------------------------------------------------
-- View UTN9_MEDIUM_SUPPLY_OPTICAL
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.utn9_medium_supply_optical CASCADE;
CREATE OR REPLACE VIEW citydb_view.utn9_medium_supply_optical AS
SELECT 
  ms.id, 
  ms.objectclass_id, 
  o.classname, 
  ms.type, 
  ms.cur_flow_rate, 
  ms.cur_flow_rate_unit, 
  ms.cur_status, 
  ms.pot_flow_rate, 
  ms.pot_flow_rate_unit, 
  ms.pot_status, 
  ms.cityobject_id
FROM 
  citydb.objectclass o, 
  citydb.utn9_medium_supply ms
WHERE 
  o.id = ms.objectclass_id AND
	o.classname='OpticalMediumSupply';	
--ALTER VIEW citydb_view.utn9_medium_supply_optical OWNER TO postgres;

----------------------------------------------------------------
-- View UTN9_MEDIUM_SUPPLY_SOLID
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.utn9_medium_supply_solid CASCADE;
CREATE OR REPLACE VIEW citydb_view.utn9_medium_supply_solid AS
SELECT 
  ms.id, 
  ms.objectclass_id, 
  o.classname, 
  ms.type, 
  ms.cur_flow_rate, 
  ms.cur_flow_rate_unit, 
  ms.cur_status, 
  ms.pot_flow_rate, 
  ms.pot_flow_rate_unit, 
  ms.pot_status, 
  ms.cityobject_id
FROM 
  citydb.objectclass o, 
  citydb.utn9_medium_supply ms
WHERE 
  o.id = ms.objectclass_id AND
	o.classname='SolidMediumSupply';	
--ALTER VIEW citydb_view.utn9_medium_supply_solid OWNER TO postgres;

----------------------------------------------------------------
-- View UTN9_ROLE_IN_NETWORK
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.utn9_role_in_network CASCADE;
CREATE OR REPLACE VIEW citydb_view.utn9_role_in_network AS
SELECT 
  r.id, 
  r.objectclass_id, 
  o.classname, 
  r.gmlid, 
  r.gmlid_codespace, 
  r.name, 
  r.name_codespace, 
  r.description, 
  r.function, 
  r.usage, 
  r.cityobject_id, 
  r.network_id
FROM 
  citydb.objectclass o, 
  citydb.utn9_role_in_network r
WHERE 
  o.id = r.objectclass_id;
--ALTER VIEW citydb_view.utn9_role_in_network OWNER TO postgres;

----------------------------------------------------------------
-- View UTN9_HOLLOW_SPACE
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.utn9_hollow_space CASCADE;
CREATE OR REPLACE VIEW citydb_view.utn9_hollow_space AS
SELECT 
  hs.id, 
  hs.objectclass_id, 
  o.classname, 
  hs.hol_spc_parent_id, 
  hs.hol_spc_root_id, 
  hs.gmlid, 
  hs.gmlid_codespace, 
  hs.name, 
  hs.name_codespace, 
  hs.description, 
  hs.ntw_feature_id
FROM 
  citydb.objectclass o, 
  citydb.utn9_hollow_space hs
WHERE 
  o.id = hs.objectclass_id AND
	o.classname='HollowSpace';	
	;
--ALTER VIEW citydb_view.utn9_hollow_space OWNER TO postgres;

----------------------------------------------------------------
-- View UTN9_HOLLOW_SPACE_PART
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.utn9_hollow_space_part CASCADE;
CREATE OR REPLACE VIEW citydb_view.utn9_hollow_space_part AS
SELECT 
  hs.id, 
  hs.objectclass_id, 
  o.classname, 
  hs.hol_spc_parent_id, 
  hs.hol_spc_root_id, 
  hs.gmlid, 
  hs.gmlid_codespace, 
  hs.name, 
  hs.name_codespace, 
  hs.description, 
  hs.ntw_feature_id
FROM 
  citydb.objectclass o, 
  citydb.utn9_hollow_space hs
WHERE 
  o.id = hs.objectclass_id AND
	o.classname='HollowSpacePart';	
--ALTER VIEW citydb_view.utn9_hollow_space_part OWNER TO postgres;

----------------------------------------------------------------
-- View UTN9_STORAGE
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.utn9_storage CASCADE;
CREATE OR REPLACE VIEW citydb_view.utn9_storage AS
SELECT 
  s.id, 
  s.type, 
  s.max_capacity, 
  s.max_capacity_unit, 
  s.fill_level, 
  s.inflow_rate, 
  s.inflow_rate_unit, 
  s.outflow_rate, 
  s.outflow_rate_unit, 
  s.medium_supply_id
FROM 
  citydb.utn9_storage s;
--ALTER VIEW citydb_view.utn9_storage OWNER TO postgres;

----------------------------------------------------------------
-- View UTN9_NETWORK_COMMODITY
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.utn9_network_commodity CASCADE;
CREATE OR REPLACE VIEW citydb_view.utn9_network_commodity AS
SELECT 
  co.id,
  co.objectclass_id,
  o1.classname,
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
  n.network_parent_id,
  n.network_root_id,
  n.class,
  n.function,
  n.usage,
  com.id                           AS com_id,
  com.objectclass_id               AS com_objectclass_id,
  o2.classname                     AS com_classname,
  com.gmlid                        AS com_gmlid,
  com.gmlid_codespace              AS com_gmlid_codespace,
  com.name                         AS com_name,
  com.name_codespace               AS com_name_codespace,
  com.description                  AS com_description,
  com.owner                        AS com_owner,
  com.type                         AS com_type,
  com.is_corrosive                 AS com_is_corrosive,
  com.is_explosive                 AS com_is_explosive,
  com.is_lighter_than_air          AS com_is_lighter_than_air,
  com.flammability_ratio           AS com_flammability_ratio,
  com.elec_conductivity_range_from AS com_elec_conductivity_range_from,
  com.elec_conductivity_range_to   AS com_elec_conductivity_range_to,
  com.elec_conductivity_range_unit AS com_elec_conductivity_range_unit,
  com.concentration                AS com_concentration,
  com.concentration_unit           AS com_concentration_unit,
  com.ph_value_range_from          AS com_ph_value_range_from,
  com.ph_value_range_to            AS com_ph_value_range_to,
  com.ph_value_range_unit          AS com_ph_value_range_unit,
  com.temperature_range_from       AS com_temperature_range_from,
  com.temperature_range_to         AS com_temperature_range_to,
  com.temperature_range_unit       AS com_temperature_range_unit,
  com.flow_rate_range_from         AS com_flow_rate_range_from,
  com.flow_rate_range_to           AS com_flow_rate_range_to,
  com.flow_rate_range_unit         AS com_flow_rate_range_unit,
  com.pressure_range_from          AS com_pressure_range_from,
  com.pressure_range_to            AS com_pressure_range_to,
  com.pressure_range_unit          AS com_pressure_range_unit,
  com.voltage_range_from           AS com_voltage_range_from,
  com.voltage_range_to             AS com_voltage_range_to,
  com.voltage_range_unit           AS com_voltage_range_unit,
  com.amperage_range_from          AS com_amperage_range_from,
  com.amperage_range_to            AS com_amperage_range_to,
  com.amperage_range_unit          AS com_amperage_range_unit,
  com.bandwidth_range_from         AS com_bandwidth_range_from,
  com.bandwidth_range_to           AS com_bandwidth_range_to,
  com.bandwidth_range_unit         AS com_bandwidth_range_unit,
  com.optical_mode                 AS com_optical_mode
FROM
  (citydb.utn9_commodity com
  INNER JOIN citydb.objectclass o2 ON (com.objectclass_id = o2.id))
  RIGHT OUTER JOIN citydb.utn9_network n ON (n.commodity_id = com.id),
  citydb.cityobject co,
  citydb.objectclass o1
WHERE
  co.id = n.id AND 
  co.objectclass_id = o1.id;
--ALTER VIEW citydb_view.utn9_network_commodity OWNER TO postgres;
COMMENT ON VIEW citydb_view.utn9_network_commodity IS 'This view joins the network table with the commodity one';


-- ***********************************************************************
-- ***********************************************************************

DO
$$
BEGIN
RAISE NOTICE '

********************************

Utility Network ADE views installation complete!

********************************

';
END
$$;
SELECT 'Utility Network ADE views installed correctly!'::varchar AS installation_result;


-- ***********************************************************************
-- ***********************************************************************
--
-- END OF FILE
--
-- ***********************************************************************
-- ***********************************************************************