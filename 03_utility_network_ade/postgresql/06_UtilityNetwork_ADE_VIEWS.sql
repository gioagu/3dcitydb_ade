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
-- ******************* 06_UtilityNetworks_ADE_VIEWS.sql ******************
--
-- This script creates views in the citydb_view schema. All views are
-- prefixed with 'utn9_'.
--
-- ***********************************************************************
-- ***********************************************************************

CREATE SCHEMA IF NOT EXISTS citydb_view;

----------------------------------------------------------------
-- View NODE
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
-- View link_interiorfeature
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
  l.line_geom,
  l.ntw_graph_id,
  ng.network_id
FROM
  citydb.utn9_node n1,
  citydb.utn9_link l,
  citydb.utn9_node n2,
  citydb.objectclass o,
  citydb.utn9_network_graph ng
WHERE
  n1.id = l.start_node_id AND
  l.ntw_graph_id = ng.id AND
  n2.id = l.end_node_id AND
  o.id = l.objectclass_id AND
  o.classname='InteriorFeatureLink';
--ALTER VIEW citydb_view.utn9_link_interior_feature OWNER TO postgres;

----------------------------------------------------------------
-- View link_interiorfeature
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.utn9_link_inter_feature CASCADE;
CREATE OR REPLACE VIEW citydb_view.utn9_link_inter_feature AS
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
  l.line_geom,
  l.ntw_graph_id,
  ng.network_id
FROM
  citydb.utn9_node n1,
  citydb.utn9_link l,
  citydb.utn9_node n2,
  citydb.objectclass o,
  citydb.utn9_network_graph ng
WHERE
  n1.id = l.start_node_id AND
  l.ntw_graph_id = ng.id AND
  n2.id = l.end_node_id AND
  o.id = l.objectclass_id AND
  o.classname='InterFeatureLink';
--ALTER VIEW citydb_view.utn9_link_inter_feature OWNER TO postgres;

----------------------------------------------------------------
-- View NETWORK_GRAPH
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
-- View FEATURE_GRAPH
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
-- View NETWORK_GRAPH
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
-- View NETWORK
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

----------------------------------------------------------------
-- View NETWORK_FEATURE
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.utn9_network_feature CASCADE;
CREATE OR REPLACE VIEW citydb_view.utn9_network_feature AS
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
  nf.cityobject_id,
  nf.prot_element_id,
  nf.geom
FROM
  citydb.objectclass o,
  citydb.cityobject co,
  citydb.utn9_network_feature nf
WHERE
  o.id = co.objectclass_id AND
  nf.id = co.id;
--ALTER VIEW citydb_view.utn9_network_feature OWNER TO postgres;

----------------------------------------------------------------
-- View NETWORK_FEATURE_COMPLEX_FUNCT_ELEMENT
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.utn9_network_feature_complex_funct_element CASCADE;
CREATE OR REPLACE VIEW citydb_view.utn9_network_feature_complex_funct_element AS
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
  nf.cityobject_id,
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
--ALTER VIEW citydb_view.utn9_network_feature_complex_funct_element OWNER TO postgres;

----------------------------------------------------------------
-- View NETWORK_FEATURE_SIMPLE_FUNCT_ELEMENT
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.utn9_network_feature_simple_funct_element CASCADE;
CREATE OR REPLACE VIEW citydb_view.utn9_network_feature_simple_funct_element AS
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
  nf.cityobject_id,
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
--ALTER VIEW citydb_view.utn9_network_feature_simple_funct_element OWNER TO postgres;

----------------------------------------------------------------
-- View NETWORK_FEATURE_TERMINAL_ELEMENT
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.utn9_network_feature_terminal_element CASCADE;
CREATE OR REPLACE VIEW citydb_view.utn9_network_feature_terminal_element AS
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
  nf.cityobject_id,
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
--ALTER VIEW citydb_view.utn9_network_feature_terminal_element OWNER TO postgres;

----------------------------------------------------------------
-- View NETWORK_FEATURE_STORAGE_DEVICE
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.utn9_network_feature_storage_device CASCADE;
CREATE OR REPLACE VIEW citydb_view.utn9_network_feature_storage_device AS
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
  nf.cityobject_id,
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
--ALTER VIEW citydb_view.utn9_network_feature_storage_device OWNER TO postgres;

----------------------------------------------------------------
-- View NETWORK_FEATURE_TECH_DEVICE
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.utn9_network_feature_tech_device CASCADE;
CREATE OR REPLACE VIEW citydb_view.utn9_network_feature_tech_device AS
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
  nf.cityobject_id,
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
--ALTER VIEW citydb_view.utn9_network_feature_tech_device OWNER TO postgres;

----------------------------------------------------------------
-- View NETWORK_FEATURE_MEAS_DEVICE
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.utn9_network_feature_meas_device CASCADE;
CREATE OR REPLACE VIEW citydb_view.utn9_network_feature_meas_device AS
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
  nf.cityobject_id,
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
--ALTER VIEW citydb_view.utn9_network_feature_meas_device OWNER TO postgres;

----------------------------------------------------------------
-- View NETWORK_FEATURE_CONTROLLER_DEVICE
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.utn9_network_feature_controller_device CASCADE;
CREATE OR REPLACE VIEW citydb_view.utn9_network_feature_controller_device AS
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
  nf.cityobject_id,
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
--ALTER VIEW citydb_view.utn9_network_feature_controller_device OWNER TO postgres;

----------------------------------------------------------------
-- View NETWORK_FEATURE_ANY_DEVICE
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.utn9_network_feature_any_device CASCADE;
CREATE OR REPLACE VIEW citydb_view.utn9_network_feature_any_device AS
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
  nf.cityobject_id,
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
--ALTER VIEW citydb_view.utn9_network_feature_any_device OWNER TO postgres;

----------------------------------------------------------------
-- View NETWORK_FEATURE_ROUND_PIPE
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.utn9_network_feature_round_pipe CASCADE;
CREATE OR REPLACE VIEW citydb_view.utn9_network_feature_round_pipe AS
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
  nf.cityobject_id,
  nf.prot_element_id,
  nf.geom,
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
--ALTER VIEW citydb_view.utn9_network_feature_round_pipe OWNER TO postgres;

----------------------------------------------------------------
-- View NETWORK_FEATURE_RECTANGULAR_PIPE
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.utn9_network_feature_rect_pipe CASCADE;
CREATE OR REPLACE VIEW citydb_view.utn9_network_feature_rect_pipe AS
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
  nf.cityobject_id,
  nf.prot_element_id,
  nf.geom,
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
--ALTER VIEW citydb_view.utn9_network_feature_rect_pipe OWNER TO postgres;

----------------------------------------------------------------
-- View NETWORK_FEATURE_OTHER_SHAPE_PIPE
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.utn9_network_feature_other_shape_pipe CASCADE;
CREATE OR REPLACE VIEW citydb_view.utn9_network_feature_other_shape_pipe AS
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
  nf.cityobject_id,
  nf.prot_element_id,
  nf.geom,
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

--ALTER VIEW citydb_view.utn9_network_feature_other_shape_pipe OWNER TO postgres;

----------------------------------------------------------------
-- View NETWORK_FEATURE_CABLE
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.utn9_network_feature_cable CASCADE;
CREATE OR REPLACE VIEW citydb_view.utn9_network_feature_cable AS
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
  nf.cityobject_id,
  nf.prot_element_id,
  nf.geom,
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
--ALTER VIEW citydb_view.utn9_network_feature_cable OWNER TO postgres;

----------------------------------------------------------------
-- View NETWORK_FEATURE_CANAL
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.utn9_network_canal CASCADE;
CREATE OR REPLACE VIEW citydb_view.utn9_network_canal AS
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
  nf.cityobject_id,
  nf.prot_element_id,
  nf.geom,
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
--ALTER VIEW citydb_view.utn9_network_feature_canal OWNER TO postgres;

----------------------------------------------------------------
-- View NETWORK_FEATURE_CANAL_SEMI_OPEN
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.utn9_network_canal_semi_open CASCADE;
CREATE OR REPLACE VIEW citydb_view.utn9_network_canal_semi_open AS
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
  nf.cityobject_id,
  nf.prot_element_id,
  nf.geom,
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
--ALTER VIEW citydb_view.utn9_network_feature_canal_semi_open OWNER TO postgres;

----------------------------------------------------------------
-- View NETWORK_FEATURE_CANAL_CLOSED
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.utn9_network_canal_closed CASCADE;
CREATE OR REPLACE VIEW citydb_view.utn9_network_canal_closed AS
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
  nf.cityobject_id,
  nf.prot_element_id,
  nf.geom,
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
--ALTER VIEW citydb_view.utn9_network_feature_canal_semi_open OWNER TO postgres;

----------------------------------------------------------------
-- View NETWORK_FEATURE_DISTRIB_ELEMENT
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.utn9_network_feature_distrib_element CASCADE;
CREATE OR REPLACE VIEW citydb_view.utn9_network_feature_distrib_element AS
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
  nf.cityobject_id,
  nf.prot_element_id,
  nf.geom,
  de.is_gravity,
  de.is_transmission,
  de.is_communication,
  de.ext_width,
  de.ext_width_unit,
  de.ext_height,
  de.ext_height_unit,
  de.ext_diameter,
  de.ext_diameter_unit,
  de.int_width,
  de.int_width_unit,
  de.int_height,
  de.int_height_unit,
  de.int_diameter,
  de.int_diameter_unit,
  de.cross_section,
  de.cross_section_unit,
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
  de.id = nf.id;
--ALTER VIEW citydb_view.utn9_network_feature_distrib_element OWNER TO postgres;

----------------------------------------------------------------
-- View NETWORK_FEATURE_PROTECTIVE_ELEMENT
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.utn9_network_feature_protective_element CASCADE;
CREATE OR REPLACE VIEW citydb_view.utn9_network_feature_protective_element AS
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
  nf.cityobject_id,
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
  pe.int_height_unit,
  pe.int_diameter,
  pe.int_diameter_unit,
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
  pe.id = nf.id;
--ALTER VIEW citydb_view.utn9_network_feature_protective_element OWNER TO postgres;

----------------------------------------------------------------
-- View NETWORK_FEATURE_PROTECTIVE_ELEMENT_RECT_SHELL
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.utn9_network_feature_protective_element_rect_shell CASCADE;
CREATE OR REPLACE VIEW citydb_view.utn9_network_feature_protective_element_rect_shell AS
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
  nf.cityobject_id,
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
--ALTER VIEW citydb_view.utn9_network_feature_protective_element_rect_shell OWNER TO postgres;

----------------------------------------------------------------
-- View NETWORK_FEATURE_PROTECTIVE_ELEMENT_ROUND_SHELL
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.utn9_network_feature_protective_element_round_shell CASCADE;
CREATE OR REPLACE VIEW citydb_view.utn9_network_feature_protective_element_round_shell AS
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
  nf.cityobject_id,
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
--ALTER VIEW citydb_view.utn9_network_feature_protective_element_round_shell OWNER TO postgres;

----------------------------------------------------------------
-- View NETWORK_FEATURE_PROTECTIVE_ELEMENT_OTHER_SHELL
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.utn9_network_feature_protective_element_other_shell CASCADE;
CREATE OR REPLACE VIEW citydb_view.utn9_network_feature_protective_element_other_shell AS
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
  nf.cityobject_id,
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
--ALTER VIEW citydb_view.utn9_network_feature_protective_element_other_shell OWNER TO postgres;

----------------------------------------------------------------
-- View NETWORK_FEATURE_PROTECTIVE_ELEMENT_BEDDING
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.utn9_network_feature_protective_element_bedding CASCADE;
CREATE OR REPLACE VIEW citydb_view.utn9_network_feature_protective_element_bedding AS
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
  nf.cityobject_id,
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
--ALTER VIEW citydb_view.utn9_network_feature_protective_element_bedding OWNER TO postgres;

----------------------------------------------------------------
-- View SUPPLY_AREA
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

----------------------------------------------------------------
-- View UTN_MATERIAL
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
-- View UTN_BUILDING
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
-- View UTN_BUILDING
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
-- View COMMODITY
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
-- View COMMODITY_CLASSIFIER
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
-- View MEDIUM_SUPPLY
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.utn9_medium_supply CASCADE;
CREATE OR REPLACE VIEW citydb_view.utn9_medium_supply AS
SELECT 
  ms.id, 
  ms.objectclass_id, 
  o.classname, 
  ms.type, 
  ms.cur_supply_flow_rate, 
  ms.cur_supply_flow_rate_unit, 
  ms.cur_supply_status, 
  ms.pot_supply_flow_rate, 
  ms.pot_supply_flow_rate_unit, 
  ms.pot_supply_status, 
  ms.cityobject_id
FROM 
  citydb.objectclass o, 
  citydb.utn9_medium_supply ms
WHERE 
  o.id = ms.objectclass_id;
--ALTER VIEW citydb_view.utn9_medium_supply OWNER TO postgres;

----------------------------------------------------------------
-- View ROLE_IN_NETWORK
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
-- View HOLLOW_SPACE
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
  o.id = hs.objectclass_id;
--ALTER VIEW citydb_view.utn9_hollow_space OWNER TO postgres;

-- ***********************************************************************
-- ***********************************************************************

DO
$$
BEGIN
RAISE NOTICE '

********************************

UtilityNetworks ADE views installation complete!

********************************

';
END
$$;
SELECT 'UtilityNetworks ADE views installed correctly!'::varchar AS installation_result;


-- ***********************************************************************
-- ***********************************************************************
--
-- END OF FILE
--
-- ***********************************************************************
-- ***********************************************************************