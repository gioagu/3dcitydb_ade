-- 3D City Database Utilities Package
--
--                     June 2018
--
-- 3D City Database: http://www.3dcitydb.org
--
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
-- ****************** 06_citydb_util_VIEWS.sql ***************************
--
-- This  script installs some views in the citydb_view schema.
--
-- ***********************************************************************
-- ***********************************************************************

CREATE SCHEMA IF NOT EXISTS citydb_view;

----------------------------------------------------------------
-- View BRIDGE
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.bridge CASCADE;
CREATE OR REPLACE VIEW citydb_view.bridge AS
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
  b.bridge_parent_id, 
  b.bridge_root_id, 
  b.class, 
  b.class_codespace, 
  b.function, 
  b.function_codespace, 
  b.usage, 
  b.usage_codespace, 
  b.year_of_construction, 
  b.year_of_demolition, 
  b.is_movable, 
  b.lod1_terrain_intersection, 
  b.lod2_terrain_intersection, 
  b.lod3_terrain_intersection, 
  b.lod4_terrain_intersection, 
  b.lod2_multi_curve, 
  b.lod3_multi_curve, 
  b.lod4_multi_curve, 
  b.lod1_multi_surface_id, 
  b.lod2_multi_surface_id, 
  b.lod3_multi_surface_id, 
  b.lod4_multi_surface_id, 
  b.lod1_solid_id, 
  b.lod2_solid_id, 
  b.lod3_solid_id, 
  b.lod4_solid_id
FROM 
  citydb.cityobject co, 
  citydb.objectclass o, 
  citydb.bridge b
WHERE 
  o.id = co.objectclass_id AND
  b.id = co.id AND
  o.classname = 'Bridge';
--ALTER VIEW citydb_view.bridge OWNER TO postgres;

----------------------------------------------------------------
-- View BRIDGE_PART
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.bridge_part CASCADE;
CREATE OR REPLACE VIEW citydb_view.bridge_part AS
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
  b.bridge_parent_id, 
  b.bridge_root_id, 
  b.class, 
  b.class_codespace, 
  b.function, 
  b.function_codespace, 
  b.usage, 
  b.usage_codespace, 
  b.year_of_construction, 
  b.year_of_demolition, 
  b.is_movable, 
  b.lod1_terrain_intersection, 
  b.lod2_terrain_intersection, 
  b.lod3_terrain_intersection, 
  b.lod4_terrain_intersection, 
  b.lod2_multi_curve, 
  b.lod3_multi_curve, 
  b.lod4_multi_curve, 
  b.lod1_multi_surface_id, 
  b.lod2_multi_surface_id, 
  b.lod3_multi_surface_id, 
  b.lod4_multi_surface_id, 
  b.lod1_solid_id, 
  b.lod2_solid_id, 
  b.lod3_solid_id, 
  b.lod4_solid_id
FROM 
  citydb.cityobject co, 
  citydb.objectclass o, 
  citydb.bridge b
WHERE 
  o.id = co.objectclass_id AND
  b.id = co.id AND
  o.classname = 'BridgePart';
--ALTER VIEW citydb_view.bridge OWNER TO postgres;

----------------------------------------------------------------
-- View BRIDGE_OPENING
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.bridge_opening CASCADE;
CREATE OR REPLACE VIEW citydb_view.bridge_opening AS
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
  bo.address_id, 
  bo.lod3_multi_surface_id, 
  bo.lod4_multi_surface_id, 
  bo.lod3_implicit_rep_id, 
  bo.lod4_implicit_rep_id, 
  bo.lod3_implicit_ref_point, 
  bo.lod4_implicit_ref_point, 
  bo.lod3_implicit_transformation, 
  bo.lod4_implicit_transformation
FROM 
  citydb.cityobject co, 
  citydb.objectclass o, 
  citydb.bridge_opening bo
WHERE 
  o.id = co.objectclass_id AND
  bo.id = co.id;
--ALTER VIEW citydb_view.bridge_opening OWNER TO postgres;

----------------------------------------------------------------
-- View BRIDGE_OPENING_DOOR
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.bridge_opening_door CASCADE;
CREATE OR REPLACE VIEW citydb_view.bridge_opening_door AS
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
  bo.address_id, 
  bo.lod3_multi_surface_id, 
  bo.lod4_multi_surface_id, 
  bo.lod3_implicit_rep_id, 
  bo.lod4_implicit_rep_id, 
  bo.lod3_implicit_ref_point, 
  bo.lod4_implicit_ref_point, 
  bo.lod3_implicit_transformation, 
  bo.lod4_implicit_transformation
FROM 
  citydb.cityobject co, 
  citydb.objectclass o, 
  citydb.bridge_opening bo
WHERE 
  o.id = co.objectclass_id AND
  bo.id = co.id AND
  o.classname = 'BridgeDoor';
--ALTER VIEW citydb_view.bridge_opening_door OWNER TO postgres;

----------------------------------------------------------------
-- View BRIDGE_OPENING_WINDOW
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.bridge_opening_window CASCADE;
CREATE OR REPLACE VIEW citydb_view.bridge_opening_window AS
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
  bo.address_id, 
  bo.lod3_multi_surface_id, 
  bo.lod4_multi_surface_id, 
  bo.lod3_implicit_rep_id, 
  bo.lod4_implicit_rep_id, 
  bo.lod3_implicit_ref_point, 
  bo.lod4_implicit_ref_point, 
  bo.lod3_implicit_transformation, 
  bo.lod4_implicit_transformation
FROM 
  citydb.cityobject co, 
  citydb.objectclass o, 
  citydb.bridge_opening bo
WHERE 
  o.id = co.objectclass_id AND
  bo.id = co.id AND
  o.classname = 'BridgeWindow';
--ALTER VIEW citydb_view.bridge_opening_window OWNER TO postgres;

----------------------------------------------------------------
-- View BRIDGE_OPEN_TO_THEM_SURFACE_EXT
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.bridge_open_to_them_surface_ext CASCADE;
CREATE OR REPLACE VIEW citydb_view.bridge_open_to_them_surface_ext AS
SELECT 
  ts.id             AS themsurf_id, 
  ts.objectclass_id AS ts_objectclass_id, 
  o1.classname      AS ts_classname, 
  o.id              AS opening_id, 
  o.objectclass_id  AS o_objectclass_id, 
  o2.classname      AS o_classname, 
  o.address_id, 
  o.lod3_multi_surface_id, 
  o.lod4_multi_surface_id, 
  o.lod3_implicit_rep_id, 
  o.lod4_implicit_rep_id, 
  o.lod3_implicit_ref_point, 
  o.lod4_implicit_ref_point, 
  o.lod3_implicit_transformation, 
  o.lod4_implicit_transformation
FROM 
  citydb.bridge_open_to_them_srf o2ts, 
  citydb.bridge_opening o, 
  citydb.bridge_thematic_surface ts, 
  citydb.objectclass o1, 
  citydb.objectclass o2
WHERE 
  o2ts.bridge_thematic_surface_id = ts.id AND
  o2ts.bridge_opening_id = o.id AND
  o.objectclass_id = o2.id AND
  ts.objectclass_id = o1.id;
--ALTER VIEW opening_to_them_surface_ext OWNER TO postgres;

----------------------------------------------------------------
-- View BRIDGE_CONSTRUCTION_ELEMENT
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.bridge_constr_element CASCADE;
CREATE OR REPLACE VIEW citydb_view.bridge_constr_element AS
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
  bce.class, 
  bce.class_codespace, 
  bce.function, 
  bce.function_codespace, 
  bce.usage, 
  bce.usage_codespace, 
  bce.bridge_id, 
  bce.lod1_terrain_intersection, 
  bce.lod2_terrain_intersection, 
  bce.lod3_terrain_intersection, 
  bce.lod4_terrain_intersection, 
  bce.lod1_brep_id, 
  bce.lod2_brep_id, 
  bce.lod3_brep_id, 
  bce.lod4_brep_id, 
  bce.lod1_other_geom, 
  bce.lod2_other_geom, 
  bce.lod3_other_geom, 
  bce.lod4_other_geom, 
  bce.lod1_implicit_rep_id, 
  bce.lod2_implicit_rep_id, 
  bce.lod3_implicit_rep_id, 
  bce.lod4_implicit_rep_id, 
  bce.lod1_implicit_ref_point, 
  bce.lod2_implicit_ref_point, 
  bce.lod3_implicit_ref_point, 
  bce.lod4_implicit_ref_point, 
  bce.lod1_implicit_transformation, 
  bce.lod2_implicit_transformation, 
  bce.lod3_implicit_transformation, 
  bce.lod4_implicit_transformation
FROM 
  citydb.cityobject co, 
  citydb.objectclass o, 
  citydb.bridge_constr_element bce
WHERE 
  o.id = co.objectclass_id AND
  bce.id = co.id;
--ALTER VIEW citydb_view.bridge_constr_element OWNER TO postgres;

----------------------------------------------------------------
-- View BRIDGE_FURNITURE
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.bridge_furniture CASCADE;
CREATE OR REPLACE VIEW citydb_view.bridge_furniture AS
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
  bf.class, 
  bf.class_codespace, 
  bf.function, 
  bf.function_codespace, 
  bf.usage, 
  bf.usage_codespace, 
  bf.bridge_room_id, 
  bf.lod4_brep_id, 
  bf.lod4_other_geom, 
  bf.lod4_implicit_rep_id, 
  bf.lod4_implicit_ref_point, 
  bf.lod4_implicit_transformation
FROM 
  citydb.cityobject co, 
  citydb.objectclass o, 
  citydb.bridge_furniture bf
WHERE 
  o.id = co.objectclass_id AND
  bf.id = co.id;
--ALTER VIEW citydb_view.bridge_FURNITURE OWNER TO postgres;

----------------------------------------------------------------
-- View BRIDGE_INSTALLATION
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.bridge_installation CASCADE;
CREATE OR REPLACE VIEW citydb_view.bridge_installation AS
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
  bi.class, 
  bi.class_codespace, 
  bi.function, 
  bi.function_codespace, 
  bi.usage, 
  bi.usage_codespace, 
  bi.bridge_id, 
  bi.bridge_room_id, 
  bi.lod2_brep_id, 
  bi.lod3_brep_id, 
  bi.lod4_brep_id, 
  bi.lod2_other_geom, 
  bi.lod3_other_geom, 
  bi.lod4_other_geom, 
  bi.lod2_implicit_rep_id, 
  bi.lod3_implicit_rep_id, 
  bi.lod4_implicit_rep_id, 
  bi.lod2_implicit_ref_point, 
  bi.lod3_implicit_ref_point, 
  bi.lod4_implicit_ref_point, 
  bi.lod2_implicit_transformation, 
  bi.lod3_implicit_transformation, 
  bi.lod4_implicit_transformation
FROM 
  citydb.cityobject co, 
  citydb.objectclass o, 
  citydb.bridge_installation bi
WHERE 
  o.id = co.objectclass_id AND
  bi.id = co.id;
--ALTER VIEW citydb_view.bridge_installation OWNER TO postgres;

----------------------------------------------------------------
-- View BRIDGE_INSTALLATION_INTERIOR
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.bridge_installation_interior CASCADE;
CREATE OR REPLACE VIEW citydb_view.bridge_installation_interior AS
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
  bi.class, 
  bi.class_codespace, 
  bi.function, 
  bi.function_codespace, 
  bi.usage, 
  bi.usage_codespace, 
  bi.bridge_id, 
  bi.bridge_room_id, 
  bi.lod2_brep_id, 
  bi.lod3_brep_id, 
  bi.lod4_brep_id, 
  bi.lod2_other_geom, 
  bi.lod3_other_geom, 
  bi.lod4_other_geom, 
  bi.lod2_implicit_rep_id, 
  bi.lod3_implicit_rep_id, 
  bi.lod4_implicit_rep_id, 
  bi.lod2_implicit_ref_point, 
  bi.lod3_implicit_ref_point, 
  bi.lod4_implicit_ref_point, 
  bi.lod2_implicit_transformation, 
  bi.lod3_implicit_transformation, 
  bi.lod4_implicit_transformation
FROM 
  citydb.cityobject co, 
  citydb.objectclass o, 
  citydb.bridge_installation bi
WHERE 
  o.id = co.objectclass_id AND
  bi.id = co.id AND
  o.classname = 'IntBridgeInstallation';
--ALTER VIEW citydb_view.bridge_installation_interior OWNER TO postgres;

----------------------------------------------------------------
-- View BRIDGE_INSTALLATION_EXTERIOR
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.bridge_installation_exterior CASCADE;
CREATE OR REPLACE VIEW citydb_view.bridge_installation_exterior AS
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
  bi.class, 
  bi.class_codespace, 
  bi.function, 
  bi.function_codespace, 
  bi.usage, 
  bi.usage_codespace, 
  bi.bridge_id, 
  bi.bridge_room_id, 
  bi.lod2_brep_id, 
  bi.lod3_brep_id, 
  bi.lod4_brep_id, 
  bi.lod2_other_geom, 
  bi.lod3_other_geom, 
  bi.lod4_other_geom, 
  bi.lod2_implicit_rep_id, 
  bi.lod3_implicit_rep_id, 
  bi.lod4_implicit_rep_id, 
  bi.lod2_implicit_ref_point, 
  bi.lod3_implicit_ref_point, 
  bi.lod4_implicit_ref_point, 
  bi.lod2_implicit_transformation, 
  bi.lod3_implicit_transformation, 
  bi.lod4_implicit_transformation
FROM 
  citydb.cityobject co, 
  citydb.objectclass o, 
  citydb.bridge_installation bi
WHERE 
  o.id = co.objectclass_id AND
  bi.id = co.id AND
  o.classname = 'BridgeInstallation';
--ALTER VIEW citydb_view.bridge_installation_exterior OWNER TO postgres;

----------------------------------------------------------------
-- View BRIDGE_ROOM
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.bridge_room CASCADE;
CREATE OR REPLACE VIEW citydb_view.bridge_room AS
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
  br.class, 
  br.class_codespace, 
  br.function, 
  br.function_codespace, 
  br.usage, 
  br.usage_codespace, 
  br.bridge_id, 
  br.lod4_multi_surface_id, 
  br.lod4_solid_id
FROM 
  citydb.cityobject co, 
  citydb.objectclass o, 
  citydb.bridge_room br
WHERE 
  o.id = co.objectclass_id AND
  br.id = co.id;
--ALTER VIEW citydb_view.bridge_room OWNER TO postgres;

----------------------------------------------------------------
-- View BRIDGE_THEMATIC_SURFACE
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.bridge_thematic_surface CASCADE;
CREATE OR REPLACE VIEW citydb_view.bridge_thematic_surface AS
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
  ts.bridge_id, 
  ts.bridge_room_id, 
  ts.bridge_installation_id,
  ts.bridge_constr_element_id,   
  ts.lod2_multi_surface_id, 
  ts.lod3_multi_surface_id, 
  ts.lod4_multi_surface_id
FROM 
  citydb.cityobject co, 
  citydb.objectclass o, 
  citydb.bridge_thematic_surface ts
WHERE 
  o.id = co.objectclass_id AND
  ts.id = co.id;
--ALTER VIEW citydb_view.bridge_thematic_surface OWNER TO postgres;

----------------------------------------------------------------
-- View BRIDGE_THEMATIC_SURFACE_CEILING
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.bridge_thematic_surface_ceiling CASCADE;
CREATE OR REPLACE VIEW citydb_view.bridge_thematic_surface_ceiling AS
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
  ts.bridge_id, 
  ts.bridge_room_id, 
  ts.bridge_installation_id,
  ts.bridge_constr_element_id,   
  ts.lod2_multi_surface_id, 
  ts.lod3_multi_surface_id, 
  ts.lod4_multi_surface_id
FROM 
  citydb.cityobject co, 
  citydb.objectclass o, 
  citydb.bridge_thematic_surface ts
WHERE 
  o.id = co.objectclass_id AND
  ts.id = co.id AND
  o.classname = 'BridgeCeilingSurface';
--ALTER VIEW citydb_view.bridge_thematic_surface_ceiling OWNER TO postgres;

----------------------------------------------------------------
-- View BRIDGE_THEMATIC_SURFACE_OUTER_CEILING
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.bridge_thematic_surface_outer_ceiling CASCADE;
CREATE OR REPLACE VIEW citydb_view.bridge_thematic_surface_outer_ceiling AS
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
  ts.bridge_id, 
  ts.bridge_room_id, 
  ts.bridge_installation_id,
  ts.bridge_constr_element_id, 
  ts.lod2_multi_surface_id, 
  ts.lod3_multi_surface_id, 
  ts.lod4_multi_surface_id
FROM 
  citydb.cityobject co, 
  citydb.objectclass o, 
  citydb.bridge_thematic_surface ts
WHERE 
  o.id = co.objectclass_id AND
  ts.id = co.id AND
  o.classname = 'OuterBridgeCeilingSurface';
--ALTER VIEW citydb_view.bridge_thematic_surface_outer_ceiling OWNER TO postgres;

----------------------------------------------------------------
-- View BRIDGE_THEMATIC_SURFACE_CLOSURE
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.bridge_thematic_surface_closure CASCADE;
CREATE OR REPLACE VIEW citydb_view.bridge_thematic_surface_closure AS
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
  ts.bridge_id, 
  ts.bridge_room_id, 
  ts.bridge_installation_id,
  ts.bridge_constr_element_id,  
  ts.lod2_multi_surface_id, 
  ts.lod3_multi_surface_id, 
  ts.lod4_multi_surface_id
FROM 
  citydb.cityobject co, 
  citydb.objectclass o, 
  citydb.bridge_thematic_surface ts
WHERE 
  o.id = co.objectclass_id AND
  ts.id = co.id AND
  o.classname = 'BridgeClosureSurface';
--ALTER VIEW citydb_view.bridge_thematic_surface_closure OWNER TO postgres;

----------------------------------------------------------------
-- View BRIDGE_THEMATIC_SURFACE_FLOOR
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.bridge_thematic_surface_floor CASCADE;
CREATE OR REPLACE VIEW citydb_view.bridge_thematic_surface_floor AS
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
  ts.bridge_id, 
  ts.bridge_room_id, 
  ts.bridge_installation_id,
  ts.bridge_constr_element_id, 
  ts.lod2_multi_surface_id, 
  ts.lod3_multi_surface_id, 
  ts.lod4_multi_surface_id
FROM 
  citydb.cityobject co, 
  citydb.objectclass o, 
  citydb.bridge_thematic_surface ts
WHERE 
  o.id = co.objectclass_id AND
  ts.id = co.id AND
  o.classname = 'BridgeFloorSurface';
--ALTER VIEW citydb_view.bridge_thematic_surface_floor OWNER TO postgres;

----------------------------------------------------------------
-- View BRIDGE_THEMATIC_SURFACE_OUTER_FLOOR
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.bridge_thematic_surface_outer_floor CASCADE;
CREATE OR REPLACE VIEW citydb_view.bridge_thematic_surface_outer_floor AS
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
  ts.bridge_id, 
  ts.bridge_room_id, 
  ts.bridge_installation_id,
  ts.bridge_constr_element_id, 
  ts.lod2_multi_surface_id, 
  ts.lod3_multi_surface_id, 
  ts.lod4_multi_surface_id
FROM 
  citydb.cityobject co, 
  citydb.objectclass o, 
  citydb.bridge_thematic_surface ts
WHERE 
  o.id = co.objectclass_id AND
  ts.id = co.id AND
  o.classname = 'OuterBridgeFloorSurface';
--ALTER VIEW citydb_view.bridge_thematic_surface_outer_floor OWNER TO postgres;

----------------------------------------------------------------
-- View BRIDGE_THEMATIC_SURFACE_GROUND
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.bridge_thematic_surface_ground CASCADE;
CREATE OR REPLACE VIEW citydb_view.bridge_thematic_surface_ground AS
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
  ts.bridge_id, 
  ts.bridge_room_id, 
  ts.bridge_installation_id,
  ts.bridge_constr_element_id, 
  ts.lod2_multi_surface_id, 
  ts.lod3_multi_surface_id, 
  ts.lod4_multi_surface_id
FROM 
  citydb.cityobject co, 
  citydb.objectclass o, 
  citydb.bridge_thematic_surface ts
WHERE 
  o.id = co.objectclass_id AND
  ts.id = co.id AND
  o.classname = 'BridgeGroundSurface';
--ALTER VIEW citydb_view.bridge_thematic_surface_ground OWNER TO postgres;

----------------------------------------------------------------
-- View BRIDGE_THEMATIC_SURFACE_ROOF
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.bridge_thematic_surface_roof CASCADE;
CREATE OR REPLACE VIEW citydb_view.bridge_thematic_surface_roof AS
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
  ts.bridge_id, 
  ts.bridge_room_id, 
  ts.bridge_installation_id,
  ts.bridge_constr_element_id, 
  ts.lod2_multi_surface_id, 
  ts.lod3_multi_surface_id, 
  ts.lod4_multi_surface_id
FROM 
  citydb.cityobject co, 
  citydb.objectclass o, 
  citydb.bridge_thematic_surface ts
WHERE 
  o.id = co.objectclass_id AND
  ts.id = co.id AND
  o.classname = 'BridgeRoofSurface';
--ALTER VIEW citydb_view.bridge_thematic_surface_roof OWNER TO postgres;

----------------------------------------------------------------
-- View BRIDGE_THEMATIC_SURFACE_WALL
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.bridge_thematic_surface_wall CASCADE;
CREATE OR REPLACE VIEW citydb_view.bridge_thematic_surface_wall AS
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
  ts.bridge_id, 
  ts.bridge_room_id, 
  ts.bridge_installation_id,
  ts.bridge_constr_element_id,  
  ts.lod2_multi_surface_id, 
  ts.lod3_multi_surface_id, 
  ts.lod4_multi_surface_id
FROM 
  citydb.cityobject co, 
  citydb.objectclass o, 
  citydb.bridge_thematic_surface ts
WHERE 
  o.id = co.objectclass_id AND
  ts.id = co.id AND
  o.classname = 'BridgeWallSurface';
--ALTER VIEW citydb_view.bridge_thematic_surface_wall OWNER TO postgres;

----------------------------------------------------------------
-- View BRIDGE_THEMATIC_SURFACE_INTERIOR_WALL
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.bridge_thematic_surface_interior_wall CASCADE;
CREATE OR REPLACE VIEW citydb_view.bridge_thematic_surface_interior_wall AS
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
  ts.bridge_id, 
  ts.bridge_room_id, 
  ts.bridge_installation_id,
  ts.bridge_constr_element_id, 
  ts.lod2_multi_surface_id, 
  ts.lod3_multi_surface_id, 
  ts.lod4_multi_surface_id
FROM 
  citydb.cityobject co, 
  citydb.objectclass o, 
  citydb.bridge_thematic_surface ts
WHERE 
  o.id = co.objectclass_id AND
  ts.id = co.id AND
  o.classname = 'InteriorBridgeWallSurface';
--ALTER VIEW citydb_view.bridge_thematic_surface_interior_wall OWNER TO postgres;

----------------------------------------------------------------
-- View CITY_FURNITURE
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.city_furniture CASCADE;
CREATE OR REPLACE VIEW citydb_view.city_furniture AS
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
  cf.class, 
  cf.class_codespace, 
  cf.function, 
  cf.function_codespace, 
  cf.usage, 
  cf.usage_codespace, 
  cf.lod1_terrain_intersection, 
  cf.lod2_terrain_intersection, 
  cf.lod3_terrain_intersection, 
  cf.lod4_terrain_intersection, 
  cf.lod1_brep_id, 
  cf.lod2_brep_id, 
  cf.lod3_brep_id, 
  cf.lod4_brep_id, 
  cf.lod1_other_geom, 
  cf.lod2_other_geom, 
  cf.lod3_other_geom, 
  cf.lod4_other_geom, 
  cf.lod1_implicit_rep_id, 
  cf.lod2_implicit_rep_id, 
  cf.lod3_implicit_rep_id, 
  cf.lod4_implicit_rep_id, 
  cf.lod1_implicit_ref_point, 
  cf.lod2_implicit_ref_point, 
  cf.lod3_implicit_ref_point, 
  cf.lod4_implicit_ref_point, 
  cf.lod1_implicit_transformation, 
  cf.lod2_implicit_transformation, 
  cf.lod3_implicit_transformation, 
  cf.lod4_implicit_transformation
FROM 
  citydb.cityobject co, 
  citydb.objectclass o, 
  citydb.city_furniture cf
WHERE 
  o.id = co.objectclass_id AND
  cf.id = co.id;
--ALTER VIEW citydb_view.city_furniture OWNER TO postgres;

----------------------------------------------------------------
-- View RELIEF_FEATURE
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.relief_feature CASCADE;
CREATE OR REPLACE VIEW citydb_view.relief_feature AS
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
  rf.lod
FROM 
  citydb.cityobject co, 
  citydb.objectclass o, 
  citydb.relief_feature rf
WHERE 
  o.id = co.objectclass_id AND
  rf.id = co.id;
--ALTER VIEW citydb_view.relief_feature OWNER TO postgres;

----------------------------------------------------------------
-- View TIN_RELIEF
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.tin_relief CASCADE;
CREATE OR REPLACE VIEW citydb_view.tin_relief AS
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
  rc.lod, 
  rc.extent, 
  tr.max_length, 
  tr.max_length_unit, 
  tr.stop_lines, 
  tr.break_lines, 
  tr.control_points, 
  tr.surface_geometry_id
FROM 
  citydb.cityobject co, 
  citydb.objectclass o, 
  citydb.tin_relief tr, 
  citydb.relief_component rc
WHERE 
  o.id = co.objectclass_id AND
  tr.id = rc.id AND
  rc.id = co.id;
--ALTER VIEW citydb_view.tin_relief OWNER TO postgres;

----------------------------------------------------------------
-- View MASSPOINT_RELIEF
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.masspoint_relief CASCADE;
CREATE OR REPLACE VIEW citydb_view.masspoint_relief AS
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
  rc.lod, 
  rc.extent, 
  mr.relief_points
FROM 
  citydb.cityobject co, 
  citydb.objectclass o, 
  citydb.relief_component rc, 
  citydb.masspoint_relief mr
WHERE 
  o.id = co.objectclass_id AND
  rc.id = co.id AND
  mr.id = rc.id;
--ALTER VIEW citydb_view.masspoint_relief OWNER TO postgres;

----------------------------------------------------------------
-- View BREAKLINE_RELIEF
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.breakline_relief CASCADE;
CREATE OR REPLACE VIEW citydb_view.breakline_relief AS
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
  rc.lod, 
  rc.extent, 
  br.ridge_or_valley_lines, 
  br.break_lines
FROM 
  citydb.cityobject co, 
  citydb.objectclass o, 
  citydb.relief_component rc, 
  citydb.breakline_relief br
WHERE 
  o.id = co.objectclass_id AND
  rc.id = co.id AND
  br.id = rc.id;
--ALTER VIEW citydb_view.breakline_relief OWNER TO postgres;

----------------------------------------------------------------
-- View RASTER_RELIEF
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.raster_relief CASCADE;
CREATE OR REPLACE VIEW citydb_view.raster_relief AS
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
  rc.lod, 
  rc.extent, 
  rr.raster_uri, 
  rr.coverage_id
FROM 
  citydb.cityobject co, 
  citydb.objectclass o, 
  citydb.relief_component rc, 
  citydb.raster_relief rr
WHERE 
  o.id = co.objectclass_id AND
  rc.id = co.id AND
  rr.id = rc.id;
--ALTER VIEW citydb_view.raster_relief OWNER TO postgres;

----------------------------------------------------------------
-- View RELIEF_COMPONENT
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.relief_component CASCADE;
CREATE OR REPLACE VIEW citydb_view.relief_component AS
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
  rc.lod, 
  rc.extent
FROM 
  citydb.cityobject co, 
  citydb.objectclass o, 
  citydb.relief_component rc
WHERE 
  o.id = co.objectclass_id AND
  rc.id = co.id;
--ALTER VIEW citydb_view.relief_component OWNER TO postgres;

----------------------------------------------------------------
-- View RELIEF_FEAT_TO_REL_COMP_EXT
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.relief_feat_to_rel_comp_ext CASCADE;
CREATE OR REPLACE VIEW citydb_view.relief_feat_to_rel_comp_ext AS
SELECT 
  co1.id             AS rf_id, 
  co1.objectclass_id AS rf_objectclass_id, 
  o1.classname       AS rf_classname, 
  co2.id             AS rc_id, 
  co2.objectclass_id AS rc_objectclass_id, 
  o2.classname       AS rc_classname, 
  co2.gmlid, 
  co2.gmlid_codespace, 
  co2.name, 
  co2.name_codespace, 
  co2.description, 
  co2.envelope, 
  co2.creation_date, 
  co2.termination_date, 
  co2.relative_to_terrain, 
  co2.relative_to_water, 
  co2.last_modification_date, 
  co2.updating_person, 
  co2.reason_for_update, 
  co2.lineage, 
  rc.lod, 
  rc.extent
FROM 
  citydb.cityobject co2, 
  citydb.objectclass o2, 
  citydb.relief_component rc, 
  citydb.relief_feat_to_rel_comp rf2rc, 
  citydb.cityobject co1, 
  citydb.objectclass o1
WHERE 
  co2.id = rf2rc.relief_component_id AND
  o2.id = co2.objectclass_id AND
  rc.id = co2.id AND
  rf2rc.relief_feature_id = co1.id AND
  o1.id = co1.objectclass_id;
--ALTER VIEW citydb_view.relief_feat_to_rel_comp_ext OWNER TO postgres;

----------------------------------------------------------------
-- View TRAFFIC_AREA
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.traffic_area CASCADE;
CREATE OR REPLACE VIEW citydb_view.traffic_area AS
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
  ta.class, 
  ta.class_codespace, 
  ta.function, 
  ta.function_codespace, 
  ta.usage, 
  ta.usage_codespace, 
  ta.surface_material, 
  ta.surface_material_codespace, 
  ta.lod2_multi_surface_id, 
  ta.lod3_multi_surface_id, 
  ta.lod4_multi_surface_id, 
  ta.transportation_complex_id
FROM 
  citydb.cityobject co, 
  citydb.objectclass o, 
  citydb.traffic_area ta
WHERE 
  o.id = co.objectclass_id AND
  ta.id = co.id AND
  o.classname = 'TrafficArea';
--ALTER VIEW citydb_view.traffic_area OWNER TO postgres;

----------------------------------------------------------------
-- View TRAFFIC_AREA_AUXILIARY
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.traffic_area_auxiliary CASCADE;
CREATE OR REPLACE VIEW citydb_view.traffic_area_auxiliary AS
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
  ta.class, 
  ta.class_codespace, 
  ta.function, 
  ta.function_codespace, 
  ta.usage, 
  ta.usage_codespace, 
  ta.surface_material, 
  ta.surface_material_codespace, 
  ta.lod2_multi_surface_id, 
  ta.lod3_multi_surface_id, 
  ta.lod4_multi_surface_id, 
  ta.transportation_complex_id
FROM 
  citydb.cityobject co, 
  citydb.objectclass o, 
  citydb.traffic_area ta
WHERE 
  o.id = co.objectclass_id AND
  ta.id = co.id AND
  o.classname = 'AuxiliaryTrafficArea';
--ALTER VIEW citydb_view.traffic_area_auxiliary OWNER TO postgres;

----------------------------------------------------------------
-- View TRANSPORTATION_COMPLEX
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.transportation_complex CASCADE;
CREATE OR REPLACE VIEW citydb_view.transportation_complex AS
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
  tc.class, 
  tc.class_codespace, 
  tc.function, 
  tc.function_codespace, 
  tc.usage, 
  tc.usage_codespace, 
  tc.lod0_network, 
  tc.lod1_multi_surface_id, 
  tc.lod2_multi_surface_id, 
  tc.lod3_multi_surface_id, 
  tc.lod4_multi_surface_id
FROM 
  citydb.cityobject co, 
  citydb.objectclass o, 
  citydb.transportation_complex tc
WHERE 
  o.id = co.objectclass_id AND
  tc.id = co.id AND
  o.classname = 'TransportationComplex';
--ALTER VIEW citydb_view.transportation_complex OWNER TO postgres;

----------------------------------------------------------------
-- View TRANSPORTATION_COMPLEX_railway
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.transportation_complex_railway CASCADE;
CREATE OR REPLACE VIEW citydb_view.transportation_complex_railway AS
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
  tc.class, 
  tc.class_codespace, 
  tc.function, 
  tc.function_codespace, 
  tc.usage, 
  tc.usage_codespace, 
  tc.lod0_network, 
  tc.lod1_multi_surface_id, 
  tc.lod2_multi_surface_id, 
  tc.lod3_multi_surface_id, 
  tc.lod4_multi_surface_id
FROM 
  citydb.cityobject co, 
  citydb.objectclass o, 
  citydb.transportation_complex tc
WHERE 
  o.id = co.objectclass_id AND
  tc.id = co.id AND
  o.classname = 'Railway';
--ALTER VIEW citydb_view.transportation_complex_railway OWNER TO postgres;

----------------------------------------------------------------
-- View TRANSPORTATION_COMPLEX_road
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.transportation_complex_road CASCADE;
CREATE OR REPLACE VIEW citydb_view.transportation_complex_road AS
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
  tc.class, 
  tc.class_codespace, 
  tc.function, 
  tc.function_codespace, 
  tc.usage, 
  tc.usage_codespace, 
  tc.lod0_network, 
  tc.lod1_multi_surface_id, 
  tc.lod2_multi_surface_id, 
  tc.lod3_multi_surface_id, 
  tc.lod4_multi_surface_id
FROM 
  citydb.cityobject co, 
  citydb.objectclass o, 
  citydb.transportation_complex tc
WHERE 
  o.id = co.objectclass_id AND
  tc.id = co.id AND
  o.classname = 'Road';
--ALTER VIEW citydb_view.transportation_complex_road OWNER TO postgres;

----------------------------------------------------------------
-- View TRANSPORTATION_COMPLEX_square
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.transportation_complex_square CASCADE;
CREATE OR REPLACE VIEW citydb_view.transportation_complex_square AS
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
  tc.class, 
  tc.class_codespace, 
  tc.function, 
  tc.function_codespace, 
  tc.usage, 
  tc.usage_codespace, 
  tc.lod0_network, 
  tc.lod1_multi_surface_id, 
  tc.lod2_multi_surface_id, 
  tc.lod3_multi_surface_id, 
  tc.lod4_multi_surface_id
FROM 
  citydb.cityobject co, 
  citydb.objectclass o, 
  citydb.transportation_complex tc
WHERE 
  o.id = co.objectclass_id AND
  tc.id = co.id AND
  o.classname = 'Square';
--ALTER VIEW citydb_view.transportation_complex_square OWNER TO postgres;

----------------------------------------------------------------
-- View TRANSPORTATION_COMPLEX_track
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.transportation_complex_track CASCADE;
CREATE OR REPLACE VIEW citydb_view.transportation_complex_track AS
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
  tc.class, 
  tc.class_codespace, 
  tc.function, 
  tc.function_codespace, 
  tc.usage, 
  tc.usage_codespace, 
  tc.lod0_network, 
  tc.lod1_multi_surface_id, 
  tc.lod2_multi_surface_id, 
  tc.lod3_multi_surface_id, 
  tc.lod4_multi_surface_id
FROM 
  citydb.cityobject co, 
  citydb.objectclass o, 
  citydb.transportation_complex tc
WHERE 
  o.id = co.objectclass_id AND
  tc.id = co.id AND
  o.classname = 'Track';
--ALTER VIEW citydb_view.transportation_complex_track OWNER TO postgres;

----------------------------------------------------------------
-- View TUNNEL
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.tunnel CASCADE;
CREATE OR REPLACE VIEW citydb_view.tunnel AS
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
  t.tunnel_parent_id, 
  t.tunnel_root_id, 
  t.class, 
  t.class_codespace, 
  t.function, 
  t.function_codespace, 
  t.usage, 
  t.usage_codespace, 
  t.year_of_construction, 
  t.year_of_demolition, 
  t.lod1_terrain_intersection, 
  t.lod2_terrain_intersection, 
  t.lod3_terrain_intersection, 
  t.lod4_terrain_intersection, 
  t.lod2_multi_curve, 
  t.lod3_multi_curve, 
  t.lod4_multi_curve, 
  t.lod1_multi_surface_id, 
  t.lod2_multi_surface_id, 
  t.lod3_multi_surface_id, 
  t.lod4_multi_surface_id, 
  t.lod1_solid_id, 
  t.lod2_solid_id, 
  t.lod3_solid_id, 
  t.lod4_solid_id
FROM 
  citydb.cityobject co, 
  citydb.objectclass o, 
  citydb.tunnel t
WHERE 
  o.id = co.objectclass_id AND
  t.id = co.id AND
  o.classname = 'Tunnel';
--ALTER VIEW citydb_view.tunnel OWNER TO postgres;

----------------------------------------------------------------
-- View TUNNEL_PART
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.tunnel_part CASCADE;
CREATE OR REPLACE VIEW citydb_view.tunnel_part AS
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
  t.tunnel_parent_id, 
  t.tunnel_root_id, 
  t.class, 
  t.class_codespace, 
  t.function, 
  t.function_codespace, 
  t.usage, 
  t.usage_codespace, 
  t.year_of_construction, 
  t.year_of_demolition, 
  t.lod1_terrain_intersection, 
  t.lod2_terrain_intersection, 
  t.lod3_terrain_intersection, 
  t.lod4_terrain_intersection, 
  t.lod2_multi_curve, 
  t.lod3_multi_curve, 
  t.lod4_multi_curve, 
  t.lod1_multi_surface_id, 
  t.lod2_multi_surface_id, 
  t.lod3_multi_surface_id, 
  t.lod4_multi_surface_id, 
  t.lod1_solid_id, 
  t.lod2_solid_id, 
  t.lod3_solid_id, 
  t.lod4_solid_id
FROM 
  citydb.cityobject co, 
  citydb.objectclass o, 
  citydb.tunnel t
WHERE 
  o.id = co.objectclass_id AND
  t.id = co.id AND
  o.classname = 'TunnelPart';
--ALTER VIEW citydb_view.tunnel_part OWNER TO postgres;

----------------------------------------------------------------
-- View TUNNEL_INSTALLATION
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.tunnel_installation CASCADE;
CREATE OR REPLACE VIEW citydb_view.tunnel_installation AS
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
  t.tunnel_parent_id, 
  t.tunnel_root_id, 
  t.class, 
  t.class_codespace, 
  t.function, 
  t.function_codespace, 
  t.usage, 
  t.usage_codespace, 
  t.year_of_construction, 
  t.year_of_demolition, 
  t.lod1_terrain_intersection, 
  t.lod2_terrain_intersection, 
  t.lod3_terrain_intersection, 
  t.lod4_terrain_intersection, 
  t.lod2_multi_curve, 
  t.lod3_multi_curve, 
  t.lod4_multi_curve, 
  t.lod1_multi_surface_id, 
  t.lod2_multi_surface_id, 
  t.lod3_multi_surface_id, 
  t.lod4_multi_surface_id, 
  t.lod1_solid_id, 
  t.lod2_solid_id, 
  t.lod3_solid_id, 
  t.lod4_solid_id
FROM 
  citydb.cityobject co, 
  citydb.objectclass o, 
  citydb.tunnel t
WHERE 
  o.id = co.objectclass_id AND
  t.id = co.id;
--ALTER VIEW citydb_view.tunnel_installation OWNER TO postgres;

----------------------------------------------------------------
-- View TUNNEL_INSTALLATION_interior
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.tunnel_installation_interior CASCADE;
CREATE OR REPLACE VIEW citydb_view.tunnel_installation_interior AS
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
  t.tunnel_parent_id, 
  t.tunnel_root_id, 
  t.class, 
  t.class_codespace, 
  t.function, 
  t.function_codespace, 
  t.usage, 
  t.usage_codespace, 
  t.year_of_construction, 
  t.year_of_demolition, 
  t.lod1_terrain_intersection, 
  t.lod2_terrain_intersection, 
  t.lod3_terrain_intersection, 
  t.lod4_terrain_intersection, 
  t.lod2_multi_curve, 
  t.lod3_multi_curve, 
  t.lod4_multi_curve, 
  t.lod1_multi_surface_id, 
  t.lod2_multi_surface_id, 
  t.lod3_multi_surface_id, 
  t.lod4_multi_surface_id, 
  t.lod1_solid_id, 
  t.lod2_solid_id, 
  t.lod3_solid_id, 
  t.lod4_solid_id
FROM 
  citydb.cityobject co, 
  citydb.objectclass o, 
  citydb.tunnel t
WHERE 
  o.id = co.objectclass_id AND
  t.id = co.id AND
  o.classname = 'TunnelInstallation';
--ALTER VIEW citydb_view.tunnel_installation_interior OWNER TO postgres;

----------------------------------------------------------------
-- View TUNNEL_INSTALLATION_exterior
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.tunnel_installation_exterior CASCADE;
CREATE OR REPLACE VIEW citydb_view.tunnel_installation_exterior AS
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
  t.tunnel_parent_id, 
  t.tunnel_root_id, 
  t.class, 
  t.class_codespace, 
  t.function, 
  t.function_codespace, 
  t.usage, 
  t.usage_codespace, 
  t.year_of_construction, 
  t.year_of_demolition, 
  t.lod1_terrain_intersection, 
  t.lod2_terrain_intersection, 
  t.lod3_terrain_intersection, 
  t.lod4_terrain_intersection, 
  t.lod2_multi_curve, 
  t.lod3_multi_curve, 
  t.lod4_multi_curve, 
  t.lod1_multi_surface_id, 
  t.lod2_multi_surface_id, 
  t.lod3_multi_surface_id, 
  t.lod4_multi_surface_id, 
  t.lod1_solid_id, 
  t.lod2_solid_id, 
  t.lod3_solid_id, 
  t.lod4_solid_id
FROM 
  citydb.cityobject co, 
  citydb.objectclass o, 
  citydb.tunnel t
WHERE 
  o.id = co.objectclass_id AND
  t.id = co.id AND
  o.classname = 'IntTunnelInstallation';
--ALTER VIEW citydb_view.tunnel_installation_exterior OWNER TO postgres;

----------------------------------------------------------------
-- View TUNNEL_FURNITURE
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.tunnel_furniture CASCADE;
CREATE OR REPLACE VIEW citydb_view.tunnel_furniture AS
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
  tf.class, 
  tf.class_codespace, 
  tf.function, 
  tf.function_codespace, 
  tf.usage, 
  tf.usage_codespace, 
  tf.tunnel_hollow_space_id, 
  tf.lod4_brep_id, 
  tf.lod4_other_geom, 
  tf.lod4_implicit_rep_id, 
  tf.lod4_implicit_ref_point, 
  tf.lod4_implicit_transformation
FROM 
  citydb.cityobject co, 
  citydb.objectclass o, 
  citydb.tunnel_furniture tf
WHERE 
  o.id = co.objectclass_id AND
  tf.id = co.id;
--ALTER VIEW citydb_view.tunnel_furniture OWNER TO postgres;

----------------------------------------------------------------
-- View TUNNEL_HOLLOW_SPACE
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.tunnel_hollow_space CASCADE;
CREATE OR REPLACE VIEW citydb_view.tunnel_hollow_space AS
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
  ths.class, 
  ths.class_codespace, 
  ths.function, 
  ths.function_codespace, 
  ths.usage, 
  ths.usage_codespace, 
  ths.tunnel_id, 
  ths.lod4_multi_surface_id, 
  ths.lod4_solid_id
FROM 
  citydb.cityobject co, 
  citydb.objectclass o, 
  citydb.tunnel_hollow_space ths
WHERE 
  o.id = co.objectclass_id AND
  ths.id = co.id;
--ALTER VIEW citydb_view.tunnel_hollow_space OWNER TO postgres;

----------------------------------------------------------------
-- View TUNNEL_OPENING
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.opening_tunnel CASCADE;
CREATE OR REPLACE VIEW citydb_view.opening_tunnel AS
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
  top.lod3_multi_surface_id, 
  top.lod4_multi_surface_id, 
  top.lod3_implicit_rep_id, 
  top.lod4_implicit_rep_id, 
  top.lod3_implicit_ref_point, 
  top.lod4_implicit_ref_point, 
  top.lod3_implicit_transformation, 
  top.lod4_implicit_transformation
FROM 
  citydb.cityobject co, 
  citydb.objectclass o, 
  citydb.tunnel_opening top
WHERE 
  o.id = co.objectclass_id AND
  top.id = co.id;
--ALTER VIEW citydb_view.tunnel_tunnel OWNER TO postgres;

----------------------------------------------------------------
-- View TUNNEL_OPENING_DOOR
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.tunnel_opening_door CASCADE;
CREATE OR REPLACE VIEW citydb_view.tunnel_opening_door AS
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
  top.lod3_multi_surface_id, 
  top.lod4_multi_surface_id, 
  top.lod3_implicit_rep_id, 
  top.lod4_implicit_rep_id, 
  top.lod3_implicit_ref_point, 
  top.lod4_implicit_ref_point, 
  top.lod3_implicit_transformation, 
  top.lod4_implicit_transformation
FROM 
  citydb.cityobject co, 
  citydb.objectclass o, 
  citydb.tunnel_opening top
WHERE 
  o.id = co.objectclass_id AND
  top.id = co.id AND
  o.classname = 'TunnelDoor';
--ALTER VIEW citydb_view.tunnel_opening_door OWNER TO postgres;

----------------------------------------------------------------
-- View TUNNEL_OPENING_WINDOW
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.tunnel_opening_window CASCADE;
CREATE OR REPLACE VIEW citydb_view.tunnel_opening_window AS
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
  top.lod3_multi_surface_id, 
  top.lod4_multi_surface_id, 
  top.lod3_implicit_rep_id, 
  top.lod4_implicit_rep_id, 
  top.lod3_implicit_ref_point, 
  top.lod4_implicit_ref_point, 
  top.lod3_implicit_transformation, 
  top.lod4_implicit_transformation
FROM 
  citydb.cityobject co, 
  citydb.objectclass o, 
  citydb.tunnel_opening top
WHERE 
  o.id = co.objectclass_id AND
  top.id = co.id AND
  o.classname = 'TunnelWindow';
--ALTER VIEW citydb_view.tunnel_opening_window OWNER TO postgres;

----------------------------------------------------------------
-- View TUNNEL_OPEN_TO_THEM_SURFACE_EXT
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.tunnel_open_to_them_surface_ext CASCADE;
CREATE OR REPLACE VIEW citydb_view.tunnel_open_to_them_surface_ext AS
SELECT 
  ts.id             AS themsurf_id, 
  ts.objectclass_id AS ts_objectclass_id, 
  o1.classname      AS ts_classname, 
  o.id              AS opening_id, 
  o.objectclass_id  AS o_objectclass_id, 
  o2.classname      AS o_classname, 
  o.lod3_multi_surface_id, 
  o.lod4_multi_surface_id, 
  o.lod3_implicit_rep_id, 
  o.lod4_implicit_rep_id, 
  o.lod3_implicit_ref_point, 
  o.lod4_implicit_ref_point, 
  o.lod3_implicit_transformation, 
  o.lod4_implicit_transformation
FROM 
  citydb.tunnel_open_to_them_srf o2ts, 
  citydb.tunnel_opening o, 
  citydb.tunnel_thematic_surface ts, 
  citydb.objectclass o1, 
  citydb.objectclass o2
WHERE 
  o2ts.tunnel_thematic_surface_id = ts.id AND
  o2ts.tunnel_opening_id = o.id AND
  o.objectclass_id = o2.id AND
  ts.objectclass_id = o1.id;
--ALTER VIEW opening_to_them_surface_ext OWNER TO postgres;

----------------------------------------------------------------
-- View TUNNEL_THEMATIC_SURFACE
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.tunnel_thematic_surface CASCADE;
CREATE OR REPLACE VIEW citydb_view.tunnel_thematic_surface AS
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
  ts.tunnel_id, 
  ts.tunnel_hollow_space_id, 
  ts.tunnel_installation_id, 
  ts.lod2_multi_surface_id, 
  ts.lod3_multi_surface_id, 
  ts.lod4_multi_surface_id
FROM 
  citydb.cityobject co, 
  citydb.objectclass o, 
  citydb.tunnel_thematic_surface ts
WHERE 
  o.id = co.objectclass_id AND
  ts.id = co.id;
--ALTER VIEW citydb_view.tunnel_thematic_surface OWNER TO postgres;

----------------------------------------------------------------
-- View TUNNEL_THEMATIC_SURFACE_CEILING
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.tunnel_thematic_surface_ceiling CASCADE;
CREATE OR REPLACE VIEW citydb_view.tunnel_thematic_surface_ceiling AS
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
  ts.tunnel_id, 
  ts.tunnel_hollow_space_id, 
  ts.tunnel_installation_id, 
  ts.lod2_multi_surface_id, 
  ts.lod3_multi_surface_id, 
  ts.lod4_multi_surface_id
FROM 
  citydb.cityobject co, 
  citydb.objectclass o, 
  citydb.tunnel_thematic_surface ts
WHERE 
  o.id = co.objectclass_id AND
  ts.id = co.id AND
  o.classname = 'TunnelCeilingSurface';
--ALTER VIEW citydb_view.tunnel_thematic_surface_ceiling OWNER TO postgres;

----------------------------------------------------------------
-- View TUNNEL_THEMATIC_SURFACE_OUTER_CEILING
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.tunnel_thematic_surface_outer_ceiling CASCADE;
CREATE OR REPLACE VIEW citydb_view.tunnel_thematic_surface_outer_ceiling AS
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
  ts.tunnel_id, 
  ts.tunnel_hollow_space_id, 
  ts.tunnel_installation_id,  
  ts.lod2_multi_surface_id, 
  ts.lod3_multi_surface_id, 
  ts.lod4_multi_surface_id
FROM 
  citydb.cityobject co, 
  citydb.objectclass o, 
  citydb.tunnel_thematic_surface ts
WHERE 
  o.id = co.objectclass_id AND
  ts.id = co.id AND
  o.classname = 'OuterTunnelCeilingSurface';
--ALTER VIEW citydb_view.tunnel_thematic_surface_outer_ceiling OWNER TO postgres;

----------------------------------------------------------------
-- View TUNNEL_THEMATIC_SURFACE_CLOSURE
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.tunnel_thematic_surface_closure CASCADE;
CREATE OR REPLACE VIEW citydb_view.tunnel_thematic_surface_closure AS
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
  ts.tunnel_id, 
  ts.tunnel_hollow_space_id, 
  ts.tunnel_installation_id,  
  ts.lod2_multi_surface_id, 
  ts.lod3_multi_surface_id, 
  ts.lod4_multi_surface_id
FROM 
  citydb.cityobject co, 
  citydb.objectclass o, 
  citydb.tunnel_thematic_surface ts
WHERE 
  o.id = co.objectclass_id AND
  ts.id = co.id AND
  o.classname = 'TunnelClosureSurface';
--ALTER VIEW citydb_view.tunnel_thematic_surface_closure OWNER TO postgres;

----------------------------------------------------------------
-- View TUNNEL_THEMATIC_SURFACE_FLOOR
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.tunnel_thematic_surface_floor CASCADE;
CREATE OR REPLACE VIEW citydb_view.tunnel_thematic_surface_floor AS
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
  ts.tunnel_id, 
  ts.tunnel_hollow_space_id, 
  ts.tunnel_installation_id, 
  ts.lod2_multi_surface_id, 
  ts.lod3_multi_surface_id, 
  ts.lod4_multi_surface_id
FROM 
  citydb.cityobject co, 
  citydb.objectclass o, 
  citydb.tunnel_thematic_surface ts
WHERE 
  o.id = co.objectclass_id AND
  ts.id = co.id AND
  o.classname = 'TunnelFloorSurface';
--ALTER VIEW citydb_view.tunnel_thematic_surface_floor OWNER TO postgres;

----------------------------------------------------------------
-- View TUNNEL_THEMATIC_SURFACE_OUTER_FLOOR
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.tunnel_thematic_surface_outer_floor CASCADE;
CREATE OR REPLACE VIEW citydb_view.tunnel_thematic_surface_outer_floor AS
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
  ts.tunnel_id, 
  ts.tunnel_hollow_space_id, 
  ts.tunnel_installation_id, 
  ts.lod2_multi_surface_id, 
  ts.lod3_multi_surface_id, 
  ts.lod4_multi_surface_id
FROM 
  citydb.cityobject co, 
  citydb.objectclass o, 
  citydb.tunnel_thematic_surface ts
WHERE 
  o.id = co.objectclass_id AND
  ts.id = co.id AND
  o.classname = 'OuterTunnelFloorSurface';
--ALTER VIEW citydb_view.tunnel_thematic_surface_outer_floor OWNER TO postgres;

----------------------------------------------------------------
-- View TUNNEL_THEMATIC_SURFACE_GROUND
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.tunnel_thematic_surface_ground CASCADE;
CREATE OR REPLACE VIEW citydb_view.tunnel_thematic_surface_ground AS
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
  ts.tunnel_id, 
  ts.tunnel_hollow_space_id, 
  ts.tunnel_installation_id,  
  ts.lod2_multi_surface_id, 
  ts.lod3_multi_surface_id, 
  ts.lod4_multi_surface_id
FROM 
  citydb.cityobject co, 
  citydb.objectclass o, 
  citydb.tunnel_thematic_surface ts
WHERE 
  o.id = co.objectclass_id AND
  ts.id = co.id AND
  o.classname = 'TunnelGroundSurface';
--ALTER VIEW citydb_view.tunnel_thematic_surface_ground OWNER TO postgres;

----------------------------------------------------------------
-- View TUNNEL_THEMATIC_SURFACE_ROOF
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.tunnel_thematic_surface_roof CASCADE;
CREATE OR REPLACE VIEW citydb_view.tunnel_thematic_surface_roof AS
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
  ts.tunnel_id, 
  ts.tunnel_hollow_space_id, 
  ts.tunnel_installation_id,  
  ts.lod2_multi_surface_id, 
  ts.lod3_multi_surface_id, 
  ts.lod4_multi_surface_id
FROM 
  citydb.cityobject co, 
  citydb.objectclass o, 
  citydb.tunnel_thematic_surface ts
WHERE 
  o.id = co.objectclass_id AND
  ts.id = co.id AND
  o.classname = 'TunnelRoofSurface';
--ALTER VIEW citydb_view.tunnel_thematic_surface_roof OWNER TO postgres;

----------------------------------------------------------------
-- View TUNNEL_THEMATIC_SURFACE_WALL
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.tunnel_thematic_surface_wall CASCADE;
CREATE OR REPLACE VIEW citydb_view.tunnel_thematic_surface_wall AS
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
  ts.tunnel_id, 
  ts.tunnel_hollow_space_id, 
  ts.tunnel_installation_id,  
  ts.lod2_multi_surface_id, 
  ts.lod3_multi_surface_id, 
  ts.lod4_multi_surface_id
FROM 
  citydb.cityobject co, 
  citydb.objectclass o, 
  citydb.tunnel_thematic_surface ts
WHERE 
  o.id = co.objectclass_id AND
  ts.id = co.id AND
  o.classname = 'TunnelWallSurface';
--ALTER VIEW citydb_view.tunnel_thematic_surface_wall OWNER TO postgres;

----------------------------------------------------------------
-- View TUNNEL_THEMATIC_SURFACE_INTERIOR_WALL
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.tunnel_thematic_surface_interior_wall CASCADE;
CREATE OR REPLACE VIEW citydb_view.tunnel_thematic_surface_interior_wall AS
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
  ts.tunnel_id, 
  ts.tunnel_hollow_space_id, 
  ts.tunnel_installation_id, 
  ts.lod2_multi_surface_id, 
  ts.lod3_multi_surface_id, 
  ts.lod4_multi_surface_id
FROM 
  citydb.cityobject co, 
  citydb.objectclass o, 
  citydb.tunnel_thematic_surface ts
WHERE 
  o.id = co.objectclass_id AND
  ts.id = co.id AND
  o.classname = 'InteriorTunnelWallSurface';
--ALTER VIEW citydb_view.tunnel_thematic_surface_interior_wall OWNER TO postgres;

----------------------------------------------------------------
-- View CITYOBJECT_TO_CITYMODEL_EXT
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.cityobject_to_citymodel_ext CASCADE;
CREATE OR REPLACE VIEW citydb_view.cityobject_to_citymodel_ext AS
SELECT 
  co1.id AS co_id, 
  co1.objectclass_id AS co_objectclass_id, 
  o1.classname AS co_classname, 
  cm.id, 
  cm.gmlid, 
  cm.gmlid_codespace, 
  cm.name, 
  cm.name_codespace, 
  cm.description, 
  cm.envelope, 
  cm.creation_date, 
  cm.termination_date, 
  cm.last_modification_date, 
  cm.updating_person, 
  cm.reason_for_update, 
  cm.lineage
FROM 
  citydb.cityobject co1, 
  citydb.objectclass o1, 
  citydb.cityobject_member com, 
  citydb.citymodel cm
WHERE 
  co1.objectclass_id = o1.id AND
  com.cityobject_id = co1.id AND
  com.citymodel_id = cm.id;
--ALTER VIEW citydb_view.cityobject_to_citymodel_ext OWNER TO postgres;

----------------------------------------------------------------
-- View GENERALIZATION_EXT
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.generalization_ext CASCADE;
CREATE OR REPLACE VIEW citydb_view.generalization_ext AS 
SELECT 
  co1.id AS co_id, 
  co1.objectclass_id AS co_objectclass_id, 
  o1.classname AS co_classname, 
  co2.id AS gen_id, 
  co2.objectclass_id AS gen_objectclass_id, 
  o2.classname AS gen_classname, 
  co2.gmlid, 
  co2.gmlid_codespace, 
  co2.name, 
  co2.name_codespace, 
  co2.description, 
  co2.envelope, 
  co2.creation_date, 
  co2.termination_date, 
  co2.relative_to_terrain, 
  co2.relative_to_water, 
  co2.last_modification_date, 
  co2.updating_person, 
  co2.reason_for_update, 
  co2.lineage
FROM 
  citydb.generalization g, 
  citydb.cityobject co1, 
  citydb.cityobject co2, 
  citydb.objectclass o2, 
  citydb.objectclass o1
WHERE 
  g.generalizes_to_id = co2.id AND
  co1.id = g.cityobject_id AND
  co1.objectclass_id = o1.id AND
  co2.objectclass_id = o2.id;
--ALTER VIEW citydb_view.generalization_ext OWNER TO postgres;

----------------------------------------------------------------
-- View ADDRESS_EXT
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.address_ext CASCADE;
CREATE OR REPLACE VIEW citydb_view.address_ext AS 
SELECT 
  a.id,
  a.gmlid,
  a.gmlid_codespace,
  a.street,
  a.house_number,
  a.po_box,
  a.zip_code,
  a.city,
  a.state,
  a.country,
  a.multi_point,
  concat(a.street,' ',a.house_number,', ',a.po_box,', ',a.zip_code,', ',a.city,', ',a.state,', ',a.country)
FROM
  citydb.address a;
--ALTER VIEW citydb_view.address_ext OWNER TO postgres;

----------------------------------------------------------------
-- View ADDRESS_TO_BUILDING_EXT
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.address_to_building_ext CASCADE;
CREATE OR REPLACE VIEW citydb_view.address_to_building_ext AS 
SELECT 
  a2b.building_id,
  co.objectclass_id,
  o1.classname,
  a.id AS address_id,
  a.gmlid,
  a.gmlid_codespace,
  a.street,
  a.house_number,
  a.po_box,
  a.zip_code,
  a.city,
  a.state,
  a.country,
  a.multi_point,
  concat(a.street,' ',a.house_number,', ',a.po_box,', ',a.zip_code,', ',a.city,', ',a.state,', ',a.country)
FROM
  citydb.address_to_building a2b,
  citydb.address a,
  citydb.cityobject co,
  citydb.objectclass o1
WHERE  
  a2b.address_id = a.id AND
  a2b.building_id = co.id AND
  co.objectclass_id = o1.id;
--ALTER VIEW citydb_view.address_to_building_ext OWNER TO postgres;

----------------------------------------------------------------
-- View BRIDGE_TO_BUILDING_EXT
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.address_to_bridge_ext CASCADE;
CREATE OR REPLACE VIEW citydb_view.address_to_bridge_ext AS 
SELECT 
  a2b.bridge_id,
  co.objectclass_id,
  o1.classname,
  a.id AS address_id,
  a.gmlid,
  a.gmlid_codespace,
  a.street,
  a.house_number,
  a.po_box,
  a.zip_code,
  a.city,
  a.state,
  a.country,
  a.multi_point,
  concat(a.street,' ',a.house_number,', ',a.po_box,', ',a.zip_code,', ',a.city,', ',a.state,', ',a.country)
FROM
  citydb.address_to_bridge a2b,
  citydb.address a,
  citydb.cityobject co,
  citydb.objectclass o1
WHERE  
  a2b.address_id = a.id AND
  a2b.bridge_id = co.id AND
  co.objectclass_id = o1.id;
--ALTER VIEW citydb_view.address_to_bridge_ext OWNER TO postgres;

----------------------------------------------------------------
-- View CITYMODEL
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.citymodel CASCADE;
CREATE OR REPLACE VIEW citydb_view.citymodel AS 
SELECT 
  c.id, 
  c.gmlid, 
  c.gmlid_codespace, 
  c.name, 
  c.name_codespace, 
  c.description, 
  c.envelope, 
  c.creation_date, 
  c.termination_date, 
  c.last_modification_date, 
  c.updating_person, 
  c.reason_for_update, 
  c.lineage
FROM 
  citydb.citymodel c
ORDER BY c.id;
--ALTER VIEW citydb_view.citymodel OWNER TO postgres;

----------------------------------------------------------------
-- View CITYOBJECT_MEMBER_EXT
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.cityobject_member_ext CASCADE;
CREATE OR REPLACE VIEW citydb_view.cityobject_member_ext AS 
SELECT 
 com.citymodel_id,
 com.cityobject_id,
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
 co.lineage
FROM
 citydb.cityobject_member AS com,
 citydb.cityobject AS co,
 citydb.objectclass o
WHERE
 o.id = co.objectclass_id AND
 co.id = com.cityobject_id;
--ALTER VIEW citydb_view.cityobject_member_ext OWNER TO postgres;

----------------------------------------------------------------
-- View CITYOBJECT
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.cityobject CASCADE;
CREATE OR REPLACE VIEW citydb_view.cityobject AS
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
  co.lineage 
FROM 
  citydb.cityobject co, 
  citydb.objectclass o
WHERE 
  o.id = co.objectclass_id;
--ALTER VIEW citydb_view.cityobject OWNER TO postgres;

----------------------------------------------------------------
-- View CITYOBJECTGROUP
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.cityobjectgroup CASCADE;
CREATE OR REPLACE VIEW citydb_view.cityobjectgroup AS
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
  citydb.cityobject co, 
  citydb.cityobjectgroup cog, 
  citydb.objectclass o
WHERE 
  co.id = cog.id AND
  o.id = co.objectclass_id AND
  o.classname = 'CityObjectGroup';
--ALTER VIEW citydb_view.cityobjectgroup OWNER TO postgres;

----------------------------------------------------------------
-- View GROUP_TO_CITYOBJECT_EXT
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.group_to_cityobject_ext CASCADE;
CREATE OR REPLACE VIEW citydb_view.group_to_cityobject_ext AS 

SELECT 
  cog.cityobjectgroup_id,
  co2.objectclass_id AS cog_objectclass_id,
  o2.classname AS cog_classname,
  cog.cityobject_id,
  co1.objectclass_id AS co_objectclass_id,
  o1.classname AS co_classname,
  co1.gmlid,
  co1.gmlid_codespace,
  co1.name,
  co1.name_codespace,
  co1.description,
  co1.envelope,
  co1.creation_date,
  co1.termination_date,
  co1.relative_to_terrain,
  co1.relative_to_water,
  co1.last_modification_date,
  co1.updating_person,
  co1.reason_for_update,
  co1.lineage
FROM
  citydb.group_to_cityobject cog,
  citydb.cityobject co2,
  citydb.cityobject co1,
  citydb.objectclass o1,
  citydb.objectclass o2
WHERE
  co2.id = cog.cityobjectgroup_id AND 
  co1.id = cog.cityobject_id AND 
  o1.id = co1.objectclass_id AND 
  o2.id = co2.objectclass_id
ORDER BY
  cog.cityobjectgroup_id,
  cog.cityobject_id;
--ALTER VIEW citydb_view.group_to_cityobject_ext OWNER TO postgres;

----------------------------------------------------------------
-- View BUILDING
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.building CASCADE;
CREATE OR REPLACE VIEW citydb_view.building AS 
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
  b.lod4_solid_id
FROM 
  citydb.objectclass o,
  citydb.cityobject co
  LEFT JOIN citydb.building b ON co.id=b.id
WHERE 
  o.id = co.objectclass_id AND
  o.classname = 'Building';
--ALTER VIEW citydb_view.building OWNER TO postgres;

----------------------------------------------------------------
-- View BUILDING_PART
----------------------------------------------------------------
DROP VIEW IF EXISTS citydb_view.building_part CASCADE;
CREATE OR REPLACE VIEW citydb_view.building_part AS 
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
  b.lod4_solid_id
FROM 
  citydb.objectclass o,
  citydb.cityobject co 
  LEFT JOIN citydb.building b ON co.id=b.id
WHERE 
  o.id = co.objectclass_id AND
  o.classname = 'BuildingPart';
--ALTER VIEW citydb_view.building_part OWNER TO postgres;

----------------------------------------------------------------
-- View BUILDING_FURNITURE
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.building_furniture CASCADE;
CREATE OR REPLACE VIEW citydb_view.building_furniture AS
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
  bf.class, 
  bf.class_codespace, 
  bf.function, 
  bf.function_codespace, 
  bf.usage, 
  bf.usage_codespace, 
  bf.room_id, 
  bf.lod4_brep_id, 
  bf.lod4_other_geom, 
  bf.lod4_implicit_rep_id, 
  bf.lod4_implicit_ref_point, 
  bf.lod4_implicit_transformation
FROM 
  citydb.cityobject co, 
  citydb.objectclass o, 
  citydb.building_furniture bf
WHERE 
  o.id = co.objectclass_id AND
  bf.id = co.id;
--ALTER VIEW citydb_view.building_furniture OWNER TO postgres;

----------------------------------------------------------------
-- View BUILDING_INSTALLATION
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.building_installation CASCADE;
CREATE OR REPLACE VIEW citydb_view.building_installation AS
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
  bi.class, 
  bi.class_codespace, 
  bi.function, 
  bi.function_codespace, 
  bi.usage, 
  bi.usage_codespace, 
  bi.building_id, 
  bi.room_id, 
  bi.lod2_brep_id, 
  bi.lod3_brep_id, 
  bi.lod4_brep_id, 
  bi.lod2_other_geom, 
  bi.lod3_other_geom, 
  bi.lod4_other_geom, 
  bi.lod2_implicit_rep_id, 
  bi.lod3_implicit_rep_id, 
  bi.lod4_implicit_rep_id, 
  bi.lod2_implicit_ref_point, 
  bi.lod3_implicit_ref_point, 
  bi.lod4_implicit_ref_point, 
  bi.lod2_implicit_transformation, 
  bi.lod3_implicit_transformation, 
  bi.lod4_implicit_transformation
FROM 
  citydb.cityobject co, 
  citydb.objectclass o, 
  citydb.building_installation bi
WHERE 
  o.id = co.objectclass_id AND
  bi.id = co.id;
--ALTER VIEW citydb_view.building_installation OWNER TO postgres;

----------------------------------------------------------------
-- View BUILDING_INSTALLATION_EXTERIOR
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.building_installation_exterior CASCADE;
CREATE OR REPLACE VIEW citydb_view.building_installation_exterior AS
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
  bi.class, 
  bi.class_codespace, 
  bi.function, 
  bi.function_codespace, 
  bi.usage, 
  bi.usage_codespace, 
  bi.building_id, 
  bi.room_id, 
  bi.lod2_brep_id, 
  bi.lod3_brep_id, 
  bi.lod4_brep_id, 
  bi.lod2_other_geom, 
  bi.lod3_other_geom, 
  bi.lod4_other_geom, 
  bi.lod2_implicit_rep_id, 
  bi.lod3_implicit_rep_id, 
  bi.lod4_implicit_rep_id, 
  bi.lod2_implicit_ref_point, 
  bi.lod3_implicit_ref_point, 
  bi.lod4_implicit_ref_point, 
  bi.lod2_implicit_transformation, 
  bi.lod3_implicit_transformation, 
  bi.lod4_implicit_transformation
FROM 
  citydb.cityobject co, 
  citydb.objectclass o, 
  citydb.building_installation bi
WHERE 
  o.id = co.objectclass_id AND
  bi.id = co.id AND
	o.classname = 'BuildingInstallation';
--ALTER VIEW citydb_view.building_installation_exterior OWNER TO postgres;

----------------------------------------------------------------
-- View BUILDING_INSTALLATION_INTERIOR
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.building_installation_interior CASCADE;
CREATE OR REPLACE VIEW citydb_view.building_installation_interior AS
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
  bi.class, 
  bi.class_codespace, 
  bi.function, 
  bi.function_codespace, 
  bi.usage, 
  bi.usage_codespace, 
  bi.building_id, 
  bi.room_id, 
  bi.lod2_brep_id, 
  bi.lod3_brep_id, 
  bi.lod4_brep_id, 
  bi.lod2_other_geom, 
  bi.lod3_other_geom, 
  bi.lod4_other_geom, 
  bi.lod2_implicit_rep_id, 
  bi.lod3_implicit_rep_id, 
  bi.lod4_implicit_rep_id, 
  bi.lod2_implicit_ref_point, 
  bi.lod3_implicit_ref_point, 
  bi.lod4_implicit_ref_point, 
  bi.lod2_implicit_transformation, 
  bi.lod3_implicit_transformation, 
  bi.lod4_implicit_transformation
FROM 
  citydb.cityobject co, 
  citydb.objectclass o, 
  citydb.building_installation bi
WHERE 
  o.id = co.objectclass_id AND
  bi.id = co.id AND
	o.classname = 'IntBuildingInstallation';
--ALTER VIEW citydb_view.building_installation_interior OWNER TO postgres;

----------------------------------------------------------------
-- View GENERIC_CITYOBJECT
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.generic_cityobject CASCADE;
CREATE OR REPLACE VIEW citydb_view.generic_cityobject AS
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
  gco.class, 
  gco.class_codespace, 
  gco.function, 
  gco.function_codespace, 
  gco.usage, 
  gco.usage_codespace, 
  gco.lod0_terrain_intersection, 
  gco.lod1_terrain_intersection, 
  gco.lod2_terrain_intersection, 
  gco.lod3_terrain_intersection, 
  gco.lod4_terrain_intersection, 
  gco.lod0_brep_id, 
  gco.lod1_brep_id, 
  gco.lod2_brep_id, 
  gco.lod3_brep_id, 
  gco.lod4_brep_id, 
  gco.lod0_other_geom, 
  gco.lod1_other_geom, 
  gco.lod2_other_geom, 
  gco.lod3_other_geom, 
  gco.lod4_other_geom, 
  gco.lod0_implicit_rep_id, 
  gco.lod1_implicit_rep_id, 
  gco.lod2_implicit_rep_id, 
  gco.lod3_implicit_rep_id, 
  gco.lod4_implicit_rep_id, 
  gco.lod0_implicit_ref_point, 
  gco.lod1_implicit_ref_point, 
  gco.lod2_implicit_ref_point, 
  gco.lod3_implicit_ref_point, 
  gco.lod4_implicit_ref_point, 
  gco.lod0_implicit_transformation, 
  gco.lod1_implicit_transformation, 
  gco.lod2_implicit_transformation, 
  gco.lod3_implicit_transformation, 
  gco.lod4_implicit_transformation
FROM 
  citydb.cityobject co, 
  citydb.objectclass o, 
  citydb.generic_cityobject gco
WHERE 
  o.id = co.objectclass_id AND
  gco.id = co.id;
--ALTER VIEW citydb_view.generic_cityobject OWNER TO postgres;

----------------------------------------------------------------
-- View CITYOBJECT_GENERICATTRIB
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.cityobject_genericattrib CASCADE;
CREATE OR REPLACE VIEW citydb_view.cityobject_genericattrib AS
SELECT 
id                    , 
parent_genattrib_id   , 
root_genattrib_id     , 
datatype              , 
attrname              , 
strval                , 
intval                , 
realval               , 
urival                , 
dateval               , 
unit                  , 
genattribset_codespace, 
blobval               , 
geomval               , 
surface_geometry_id   , 
cityobject_id          
FROM
citydb.cityobject_genericattrib;
--ALTER VIEW citydb_view.cityobject_genericattrib OWNER TO postgres;


-- ********************************
-- Possible values for datatype
-- 1 STRING          (varchar)
-- 2 INTEGER         (integer)
-- 3 REAL            (double)
-- 4 URI             (varchar)
-- 5 DATE            (timestamptz)
-- 6 MEASURE         (double + varchar)
-- 7 Group of generic attributes
-- 8 BLOB            (bytea)
-- 9 Geometry type   (geometry)
-- 10 Geometry via surfaces in the table SURFACE_GEOMETRY (integer)
-- ********************************

----------------------------------------------------------------
-- View CITYOBJECT_GENERICATTRIB_STRING
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.cityobject_genericattrib_string CASCADE;
CREATE OR REPLACE VIEW citydb_view.cityobject_genericattrib_string AS
SELECT 
id                    , 
parent_genattrib_id   , 
root_genattrib_id     , 
datatype              , 
attrname              , 
strval                , 
--intval                , 
--realval               , 
--urival                , 
--dateval               , 
--unit                  , 
--genattribset_codespace, 
--blobval               , 
--geomval               , 
--surface_geometry_id   , 
cityobject_id          
FROM
citydb.cityobject_genericattrib
WHERE
datatype=1;
--ALTER VIEW citydb_view.cityobject_genericattrib_string OWNER TO postgres;

----------------------------------------------------------------
-- View CITYOBJECT_GENERICATTRIB_integer
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.cityobject_genericattrib_integer CASCADE;
CREATE OR REPLACE VIEW citydb_view.cityobject_genericattrib_integer AS
SELECT 
id                    , 
parent_genattrib_id   , 
root_genattrib_id     , 
datatype              , 
attrname              , 
--strval                , 
intval                , 
--realval               , 
--urival                , 
--dateval               , 
--unit                  , 
--genattribset_codespace, 
--blobval               , 
--geomval               , 
--surface_geometry_id   , 
cityobject_id          
FROM
citydb.cityobject_genericattrib
WHERE
datatype=2;
--ALTER VIEW citydb_view.cityobject_genericattrib_integer OWNER TO postgres;

----------------------------------------------------------------
-- View CITYOBJECT_GENERICATTRIB_real
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.cityobject_genericattrib_real CASCADE;
CREATE OR REPLACE VIEW citydb_view.cityobject_genericattrib_real AS
SELECT 
id                    , 
parent_genattrib_id   , 
root_genattrib_id     , 
datatype              , 
attrname              , 
--strval                , 
--intval                , 
realval               , 
--urival                , 
--dateval               , 
--unit                  , 
--genattribset_codespace, 
--blobval               , 
--geomval               , 
--surface_geometry_id   , 
cityobject_id          
FROM
citydb.cityobject_genericattrib
WHERE
datatype=3;
--ALTER VIEW citydb_view.cityobject_genericattrib_real OWNER TO postgres;

----------------------------------------------------------------
-- View CITYOBJECT_GENERICATTRIB_uri
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.cityobject_genericattrib_uri CASCADE;
CREATE OR REPLACE VIEW citydb_view.cityobject_genericattrib_uri AS
SELECT 
id                    , 
parent_genattrib_id   , 
root_genattrib_id     , 
datatype              , 
attrname              , 
--strval                , 
--intval                , 
--realval               , 
urival                , 
--dateval               , 
--unit                  , 
--genattribset_codespace, 
--blobval               , 
--geomval               , 
--surface_geometry_id   , 
cityobject_id          
FROM
citydb.cityobject_genericattrib
WHERE
datatype=4;
--ALTER VIEW citydb_view.cityobject_genericattrib_uri OWNER TO postgres;

----------------------------------------------------------------
-- View CITYOBJECT_GENERICATTRIB_date
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.cityobject_genericattrib_date CASCADE;
CREATE OR REPLACE VIEW citydb_view.cityobject_genericattrib_date AS
SELECT 
id                    , 
parent_genattrib_id   , 
root_genattrib_id     , 
datatype              , 
attrname              , 
--strval                , 
--intval                , 
--realval               , 
--urival                , 
dateval               , 
--unit                  , 
--genattribset_codespace, 
--blobval               , 
--geomval               , 
--surface_geometry_id   , 
cityobject_id          
FROM
citydb.cityobject_genericattrib
WHERE
datatype=5;
--ALTER VIEW citydb_view.cityobject_genericattrib_date OWNER TO postgres;

----------------------------------------------------------------
-- View CITYOBJECT_GENERICATTRIB_measure
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.cityobject_genericattrib_measure CASCADE;
CREATE OR REPLACE VIEW citydb_view.cityobject_genericattrib_measure AS
SELECT 
id                    , 
parent_genattrib_id   , 
root_genattrib_id     , 
datatype              , 
attrname              , 
--strval                , 
--intval                , 
realval               , 
--urival                , 
--dateval               , 
unit                  , 
--genattribset_codespace, 
--blobval               , 
--geomval               , 
--surface_geometry_id   , 
cityobject_id          
FROM
citydb.cityobject_genericattrib
WHERE
datatype=6;
--ALTER VIEW citydb_view.cityobject_genericattrib_measure OWNER TO postgres;

----------------------------------------------------------------
-- View CITYOBJECT_GENERICATTRIB_group
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.cityobject_genericattrib_group CASCADE;
CREATE OR REPLACE VIEW citydb_view.cityobject_genericattrib_group AS
SELECT 
id                    , 
parent_genattrib_id   , 
root_genattrib_id     , 
datatype              , 
attrname              , 
--strval                , 
--intval                , 
--realval               , 
--urival                , 
--dateval               , 
--unit                  , 
genattribset_codespace, 
--blobval               , 
--geomval               , 
--surface_geometry_id   , 
cityobject_id          
FROM
citydb.cityobject_genericattrib
WHERE
datatype=7;
--ALTER VIEW citydb_view.cityobject_genericattrib_group OWNER TO postgres;

----------------------------------------------------------------
-- View CITYOBJECT_GENERICATTRIB_blob
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.cityobject_genericattrib_blob CASCADE;
CREATE OR REPLACE VIEW citydb_view.cityobject_genericattrib_blob AS
SELECT 
id                    , 
parent_genattrib_id   , 
root_genattrib_id     , 
datatype              , 
attrname              , 
--strval                , 
--intval                , 
--realval               , 
--urival                , 
--dateval               , 
--unit                  , 
--genattribset_codespace, 
blobval               , 
--geomval               , 
--surface_geometry_id   , 
cityobject_id          
FROM
citydb.cityobject_genericattrib
WHERE
datatype=8;
--ALTER VIEW citydb_view.cityobject_genericattrib_blob OWNER TO postgres;

----------------------------------------------------------------
-- View CITYOBJECT_GENERICATTRIB_geometry
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.cityobject_genericattrib_geometry CASCADE;
CREATE OR REPLACE VIEW citydb_view.cityobject_genericattrib_geometry AS
SELECT 
id                    , 
parent_genattrib_id   , 
root_genattrib_id     , 
datatype              , 
attrname              , 
--strval                , 
--intval                , 
--realval               , 
--urival                , 
--dateval               , 
--unit                  , 
--genattribset_codespace, 
--blobval               , 
geomval               , 
--surface_geometry_id   , 
cityobject_id          
FROM
citydb.cityobject_genericattrib
WHERE
datatype=9;
--ALTER VIEW citydb_view.cityobject_genericattrib_geometry OWNER TO postgres;

----------------------------------------------------------------
-- View CITYOBJECT_GENERICATTRIB_surfgeom
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.cityobject_genericattrib_surfgeom CASCADE;
CREATE OR REPLACE VIEW citydb_view.cityobject_genericattrib_surfgeom AS
SELECT 
id                    , 
parent_genattrib_id   , 
root_genattrib_id     , 
datatype              , 
attrname              , 
--strval                , 
--intval                , 
--realval               , 
--urival                , 
--dateval               , 
--unit                  , 
--genattribset_codespace, 
--blobval               , 
--geomval               , 
surface_geometry_id   , 
cityobject_id          
FROM
citydb.cityobject_genericattrib
WHERE
datatype=10;
--ALTER VIEW citydb_view.cityobject_genericattrib_surfgeom OWNER TO postgres;

----------------------------------------------------------------
-- View LAND_USE
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.land_use CASCADE;
CREATE OR REPLACE VIEW citydb_view.land_use AS
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
  lu.class, 
  lu.class_codespace, 
  lu.function, 
  lu.function_codespace, 
  lu.usage, 
  lu.usage_codespace, 
  lu.lod0_multi_surface_id, 
  lu.lod1_multi_surface_id, 
  lu.lod2_multi_surface_id, 
  lu.lod3_multi_surface_id, 
  lu.lod4_multi_surface_id
FROM 
  citydb.cityobject co, 
  citydb.objectclass o, 
  citydb.land_use lu
WHERE 
  o.id = co.objectclass_id AND
  lu.id = co.id;
--ALTER VIEW citydb_view.land_use OWNER TO postgres;

----------------------------------------------------------------
-- View OPENING_TO_THEM_SURFACE_EXT
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.opening_to_them_surface_ext CASCADE;
CREATE OR REPLACE VIEW citydb_view.opening_to_them_surface_ext AS
SELECT 
  ts.id AS themsurf_id, 
  ts.objectclass_id AS ts_objectclass_id, 
  o1.classname AS ts_classname, 
  o.id AS opening_id, 
  o.objectclass_id AS o_objectclass_id, 
  o2.classname AS o_classname, 
  o.address_id, 
  o.lod3_multi_surface_id, 
  o.lod4_multi_surface_id, 
  o.lod3_implicit_rep_id, 
  o.lod4_implicit_rep_id, 
  o.lod3_implicit_ref_point, 
  o.lod4_implicit_ref_point, 
  o.lod3_implicit_transformation, 
  o.lod4_implicit_transformation
FROM 
  citydb.opening_to_them_surface o2ts, 
  citydb.opening o, 
  citydb.thematic_surface ts, 
  citydb.objectclass o1, 
  citydb.objectclass o2
WHERE 
  o2ts.thematic_surface_id = ts.id AND
  o2ts.opening_id = o.id AND
  o.objectclass_id = o2.id AND
  ts.objectclass_id = o1.id;
--ALTER VIEW opening_to_them_surface_ext OWNER TO postgres;

----------------------------------------------------------------
-- View OPENING
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.opening CASCADE;
CREATE OR REPLACE VIEW citydb_view.opening AS
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
  op.address_id, 
  op.lod3_multi_surface_id, 
  op.lod4_multi_surface_id, 
  op.lod3_implicit_rep_id, 
  op.lod4_implicit_rep_id, 
  op.lod3_implicit_ref_point, 
  op.lod4_implicit_ref_point, 
  op.lod3_implicit_transformation, 
  op.lod4_implicit_transformation
FROM 
  citydb.cityobject co, 
  citydb.objectclass o, 
  citydb.opening op
WHERE 
  o.id = co.objectclass_id AND
  op.id = co.id;
--ALTER VIEW citydb_view.opening OWNER TO postgres;

----------------------------------------------------------------
-- View OPENING_WINDOW
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.opening_window CASCADE;
CREATE OR REPLACE VIEW citydb_view.opening_window AS
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
  op.lod3_multi_surface_id, 
  op.lod4_multi_surface_id, 
  op.lod3_implicit_rep_id, 
  op.lod4_implicit_rep_id, 
  op.lod3_implicit_ref_point, 
  op.lod4_implicit_ref_point, 
  op.lod3_implicit_transformation, 
  op.lod4_implicit_transformation
FROM 
  citydb.cityobject co, 
  citydb.objectclass o, 
  citydb.opening op
WHERE 
  o.id = co.objectclass_id AND
  op.id = co.id AND
  o.classname = 'BuildingWindow';
--ALTER VIEW citydb_view.opening_window OWNER TO postgres;

----------------------------------------------------------------
-- View OPENING_DOOR
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.opening_door CASCADE;
CREATE OR REPLACE VIEW citydb_view.opening_door AS
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
  op.address_id, 
  op.lod3_multi_surface_id, 
  op.lod4_multi_surface_id, 
  op.lod3_implicit_rep_id, 
  op.lod4_implicit_rep_id, 
  op.lod3_implicit_ref_point, 
  op.lod4_implicit_ref_point, 
  op.lod3_implicit_transformation, 
  op.lod4_implicit_transformation
FROM 
  citydb.cityobject co, 
  citydb.objectclass o, 
  citydb.opening op
WHERE 
  o.id = co.objectclass_id AND
  op.id = co.id AND
  o.classname = 'BuildingDoor';
--ALTER VIEW citydb_view.opening_door OWNER TO postgres;

----------------------------------------------------------------
-- View ROOM
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.room CASCADE;
CREATE OR REPLACE VIEW citydb_view.room AS
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
  r.class, 
  r.class_codespace, 
  r.function, 
  r.function_codespace, 
  r.usage, 
  r.usage_codespace, 
  r.building_id, 
  r.lod4_multi_surface_id, 
  r.lod4_solid_id
FROM 
  citydb.cityobject co, 
  citydb.objectclass o, 
  citydb.room r
WHERE 
  o.id = co.objectclass_id AND
  r.id = co.id;
--ALTER VIEW citydb_view.room OWNER TO postgres;

----------------------------------------------------------------
-- View THEMATIC_SURFACE
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.thematic_surface CASCADE;
CREATE OR REPLACE VIEW citydb_view.thematic_surface AS
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
  ts.building_id, 
  ts.room_id, 
  ts.building_installation_id, 
  ts.lod2_multi_surface_id, 
  ts.lod3_multi_surface_id, 
  ts.lod4_multi_surface_id
FROM 
  citydb.cityobject co, 
  citydb.objectclass o, 
  citydb.thematic_surface ts
WHERE 
  o.id = co.objectclass_id AND
  ts.id = co.id;
--ALTER VIEW citydb_view.thematic_surface OWNER TO postgres;

----------------------------------------------------------------
-- View PLANT_COVER
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.plant_cover CASCADE;
CREATE OR REPLACE VIEW citydb_view.plant_cover AS
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
  pc.class_codespace, 
  pc.function, 
  pc.function_codespace, 
  pc.usage, 
  pc.usage_codespace, 
  pc.average_height, 
  pc.average_height_unit, 
  pc.lod1_multi_surface_id, 
  pc.lod2_multi_surface_id, 
  pc.lod3_multi_surface_id, 
  pc.lod4_multi_surface_id, 
  pc.lod1_multi_solid_id, 
  pc.lod2_multi_solid_id, 
  pc.lod3_multi_solid_id, 
  pc.lod4_multi_solid_id
FROM 
  citydb.cityobject co, 
  citydb.objectclass o, 
  citydb.plant_cover pc
WHERE 
  o.id = co.objectclass_id AND
  pc.id = co.id;
--ALTER VIEW citydb_view.plant_cover OWNER TO postgres;

----------------------------------------------------------------
-- View THEMATIC_SURFACE_CEILING
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.thematic_surface_ceiling CASCADE;
CREATE OR REPLACE VIEW citydb_view.thematic_surface_ceiling AS
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
  ts.building_id, 
  ts.room_id, 
  ts.building_installation_id, 
  ts.lod2_multi_surface_id, 
  ts.lod3_multi_surface_id, 
  ts.lod4_multi_surface_id
FROM 
  citydb.cityobject co, 
  citydb.objectclass o, 
  citydb.thematic_surface ts
WHERE 
  o.id = co.objectclass_id AND
  ts.id = co.id AND
  o.classname = 'BuildingCeilingSurface';
--ALTER VIEW citydb_view.thematic_surface_ceiling OWNER TO postgres;

----------------------------------------------------------------
-- View THEMATIC_SURFACE_INTERIOR_WALL
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.thematic_surface_interior_wall CASCADE;
CREATE OR REPLACE VIEW citydb_view.thematic_surface_interior_wall AS
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
  ts.building_id, 
  ts.room_id, 
  ts.building_installation_id, 
  ts.lod2_multi_surface_id, 
  ts.lod3_multi_surface_id, 
  ts.lod4_multi_surface_id
FROM 
  citydb.cityobject co, 
  citydb.objectclass o, 
  citydb.thematic_surface ts
WHERE 
  o.id = co.objectclass_id AND
  ts.id = co.id AND
  o.classname = 'InteriorBuildingWallSurface';
--ALTER VIEW citydb_view.thematic_surface_interior_wall OWNER TO postgres;

----------------------------------------------------------------
-- View THEMATIC_SURFACE_FLOOR_SURFACE
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.thematic_surface_floor CASCADE;
CREATE OR REPLACE VIEW citydb_view.thematic_surface_floor AS
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
  ts.building_id, 
  ts.room_id, 
  ts.building_installation_id, 
  ts.lod2_multi_surface_id, 
  ts.lod3_multi_surface_id, 
  ts.lod4_multi_surface_id
FROM 
  citydb.cityobject co, 
  citydb.objectclass o, 
  citydb.thematic_surface ts
WHERE 
  o.id = co.objectclass_id AND
  ts.id = co.id AND
  o.classname = 'BuildingFloorSurface';
--ALTER VIEW citydb_view.thematic_surface_floor OWNER TO postgres;

----------------------------------------------------------------
-- View THEMATIC_SURFACE_ROOF
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.thematic_surface_roof CASCADE;
CREATE OR REPLACE VIEW citydb_view.thematic_surface_roof AS
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
  ts.building_id, 
  ts.room_id, 
  ts.building_installation_id, 
  ts.lod2_multi_surface_id, 
  ts.lod3_multi_surface_id, 
  ts.lod4_multi_surface_id
FROM 
  citydb.cityobject co, 
  citydb.objectclass o, 
  citydb.thematic_surface ts
WHERE 
  o.id = co.objectclass_id AND
  ts.id = co.id AND
  o.classname = 'BuildingRoofSurface';
--ALTER VIEW citydb_view.thematic_surface_roof OWNER TO postgres;

----------------------------------------------------------------
-- View THEMATIC_SURFACE_WALL
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.thematic_surface_wall CASCADE;
CREATE OR REPLACE VIEW citydb_view.thematic_surface_wall AS
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
  ts.building_id, 
  ts.room_id, 
  ts.building_installation_id, 
  ts.lod2_multi_surface_id, 
  ts.lod3_multi_surface_id, 
  ts.lod4_multi_surface_id
FROM 
  citydb.cityobject co, 
  citydb.objectclass o, 
  citydb.thematic_surface ts
WHERE 
  o.id = co.objectclass_id AND
  ts.id = co.id AND
  o.classname = 'BuildingWallSurface';
--ALTER VIEW citydb_view.thematic_surface_wall OWNER TO postgres;

----------------------------------------------------------------
-- View THEMATIC_SURFACE_GROUND
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.thematic_surface_ground CASCADE;
CREATE OR REPLACE VIEW citydb_view.thematic_surface_ground AS
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
  ts.building_id, 
  ts.room_id, 
  ts.building_installation_id, 
  ts.lod2_multi_surface_id, 
  ts.lod3_multi_surface_id, 
  ts.lod4_multi_surface_id
FROM 
  citydb.cityobject co, 
  citydb.objectclass o, 
  citydb.thematic_surface ts
WHERE 
  o.id = co.objectclass_id AND
  ts.id = co.id AND
  o.classname = 'BuildingGroundSurface';
--ALTER VIEW citydb_view.thematic_surface_ground OWNER TO postgres;

----------------------------------------------------------------
-- View THEMATIC_SURFACE_CLOSURE
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.thematic_surface_closure CASCADE;
CREATE OR REPLACE VIEW citydb_view.thematic_surface_closure AS
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
  ts.building_id, 
  ts.room_id, 
  ts.building_installation_id, 
  ts.lod2_multi_surface_id, 
  ts.lod3_multi_surface_id, 
  ts.lod4_multi_surface_id
FROM 
  citydb.cityobject co, 
  citydb.objectclass o, 
  citydb.thematic_surface ts
WHERE 
  o.id = co.objectclass_id AND
  ts.id = co.id AND
  o.classname = 'BuildingClosureSurface';
--ALTER VIEW citydb_view.thematic_surface_closure OWNER TO postgres;

----------------------------------------------------------------
-- View THEMATIC_SURFACE_OUTER_CEILING
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.thematic_surface_outer_ceiling CASCADE;
CREATE OR REPLACE VIEW citydb_view.thematic_surface_outer_ceiling AS
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
  ts.building_id, 
  ts.room_id, 
  ts.building_installation_id, 
  ts.lod2_multi_surface_id, 
  ts.lod3_multi_surface_id, 
  ts.lod4_multi_surface_id
FROM 
  citydb.cityobject co, 
  citydb.objectclass o, 
  citydb.thematic_surface ts
WHERE 
  o.id = co.objectclass_id AND
  ts.id = co.id AND
  o.classname = 'OuterBuildingCeilingSurface';
--ALTER VIEW citydb_view.thematic_surface_outer_ceiling OWNER TO postgres;

----------------------------------------------------------------
-- View THEMATIC_SURFACE_OUTER_FLOOR
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.thematic_surface_outer_floor CASCADE;
CREATE OR REPLACE VIEW citydb_view.thematic_surface_outer_floor AS
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
  ts.building_id, 
  ts.room_id, 
  ts.building_installation_id, 
  ts.lod2_multi_surface_id, 
  ts.lod3_multi_surface_id, 
  ts.lod4_multi_surface_id
FROM 
  citydb.cityobject co, 
  citydb.objectclass o, 
  citydb.thematic_surface ts
WHERE 
  o.id = co.objectclass_id AND
  ts.id = co.id AND
  o.classname = 'OuterBuildingCeilingSurface';
--ALTER VIEW citydb_view.thematic_surface_outer_ceiling OWNER TO postgres;

----------------------------------------------------------------
-- View SOLITARY_VEGETAT_OBJECT
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.solitary_vegetat_object CASCADE;
CREATE OR REPLACE VIEW citydb_view.solitary_vegetat_object AS
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
  svo.class, 
  svo.class_codespace, 
  svo.function, 
  svo.function_codespace, 
  svo.usage, 
  svo.usage_codespace, 
  svo.species, 
  svo.species_codespace, 
  svo.height, 
  svo.height_unit, 
  svo.trunk_diameter, 
  svo.trunk_diameter_unit, 
  svo.crown_diameter, 
  svo.crown_diameter_unit, 
  svo.lod1_brep_id, 
  svo.lod2_brep_id, 
  svo.lod3_brep_id, 
  svo.lod4_brep_id, 
  svo.lod1_other_geom, 
  svo.lod2_other_geom, 
  svo.lod3_other_geom, 
  svo.lod4_other_geom, 
  svo.lod1_implicit_rep_id, 
  svo.lod2_implicit_rep_id, 
  svo.lod3_implicit_rep_id, 
  svo.lod4_implicit_rep_id, 
  svo.lod1_implicit_ref_point, 
  svo.lod2_implicit_ref_point, 
  svo.lod3_implicit_ref_point, 
  svo.lod4_implicit_ref_point, 
  svo.lod1_implicit_transformation, 
  svo.lod2_implicit_transformation, 
  svo.lod3_implicit_transformation
FROM 
  citydb.cityobject co, 
  citydb.objectclass o, 
  citydb.solitary_vegetat_object svo
WHERE 
  o.id = co.objectclass_id AND
  svo.id = co.id;
--ALTER VIEW citydb_view.solitary_vegetat_object OWNER TO postgres;

----------------------------------------------------------------
-- View WATERBODY
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.waterbody CASCADE;
CREATE OR REPLACE VIEW citydb_view.waterbody AS
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
  wb.class, 
  wb.class_codespace, 
  wb.function, 
  wb.function_codespace, 
  wb.usage, 
  wb.usage_codespace, 
  wb.lod0_multi_curve, 
  wb.lod1_multi_curve, 
  wb.lod0_multi_surface_id, 
  wb.lod1_multi_surface_id, 
  wb.lod1_solid_id, 
  wb.lod2_solid_id, 
  wb.lod3_solid_id, 
  wb.lod4_solid_id
FROM 
  citydb.cityobject co, 
  citydb.objectclass o, 
  citydb.waterbody wb
WHERE 
  o.id = co.objectclass_id AND
  wb.id = co.id;
--ALTER VIEW citydb_view.waterbody OWNER TO postgres;

----------------------------------------------------------------
-- View WATERBOUNDARY_SURFACE
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.waterboundary_surface CASCADE;
CREATE OR REPLACE VIEW citydb_view.waterboundary_surface AS
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
  wbs.lod2_surface_id, 
  wbs.lod3_surface_id, 
  wbs.lod4_surface_id
FROM 
  citydb.cityobject co, 
  citydb.objectclass o, 
  citydb.waterboundary_surface wbs
WHERE 
  o.id = co.objectclass_id AND
  wbs.id = co.id;
--ALTER VIEW citydb_view.waterboundary_surface OWNER TO postgres;

----------------------------------------------------------------
-- View WATERBOUNDARY_SURFACE_CLOSURE
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.waterboundary_surface_closure CASCADE;
CREATE OR REPLACE VIEW citydb_view.waterboundary_surface_closure AS
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
  wbs.lod2_surface_id, 
  wbs.lod3_surface_id, 
  wbs.lod4_surface_id
FROM 
  citydb.cityobject co, 
  citydb.objectclass o, 
  citydb.waterboundary_surface wbs
WHERE 
  o.id = co.objectclass_id AND
  wbs.id = co.id AND
  o.classname = 'WaterClosureSurface';
--ALTER VIEW citydb_view.waterboundary_surface_closure OWNER TO postgres;

----------------------------------------------------------------
-- View WATERBOUNDARY_SURFACE_GROUND
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.waterboundary_surface_ground CASCADE;
CREATE OR REPLACE VIEW citydb_view.waterboundary_surface_ground AS
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
  wbs.lod2_surface_id, 
  wbs.lod3_surface_id, 
  wbs.lod4_surface_id
FROM 
  citydb.cityobject co, 
  citydb.objectclass o, 
  citydb.waterboundary_surface wbs
WHERE 
  o.id = co.objectclass_id AND
  wbs.id = co.id AND
  o.classname = 'WaterGroundSurface';
--ALTER VIEW citydb_view.waterboundary_surface_ground OWNER TO postgres;

----------------------------------------------------------------
-- View WATERBOUNDARY_SURFACE_WATER
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.waterboundary_surface_water CASCADE;
CREATE OR REPLACE VIEW citydb_view.waterboundary_surface_water AS
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
  wbs.water_level, 
  wbs.water_level_codespace, 
  wbs.lod2_surface_id, 
  wbs.lod3_surface_id, 
  wbs.lod4_surface_id
FROM 
  citydb.cityobject co, 
  citydb.objectclass o, 
  citydb.waterboundary_surface wbs
WHERE 
  o.id = co.objectclass_id AND
  wbs.id = co.id AND
  o.classname = 'WaterSurface';
--ALTER VIEW citydb_view.waterboundary_surface_water OWNER TO postgres;

-- ***********************************************************************
-- ***********************************************************************

----------------------------------------------------------------
-- View BUILDING_LOD0_FOOTPRINT
----------------------------------------------------------------
DROP VIEW IF EXISTS    citydb_view.building_lod0_footprint CASCADE;
CREATE OR REPLACE VIEW citydb_view.building_lod0_footprint AS
SELECT 
  co.id, 
  co.objectclass_id, 
  o.classname, 
  g.geometry
FROM 
  citydb.surface_geometry g, 
  citydb.cityobject co, 
  citydb.building b, 
  citydb.objectclass o
WHERE 
  g.id = b.lod0_footprint_id AND
  b.id = co.id AND
  o.id = co.objectclass_id AND
  g.geometry IS NOT NULL  AND 
  o.classname = 'Building';
--ALTER VIEW citydb_view.building_lod0_footprint OWNER TO postgres;

-- ***********************************************************************
-- ***********************************************************************

DO
$$
BEGIN
RAISE NOTICE '

********************************

3DCityDB views installed correctly!

********************************

';
END
$$;
SELECT '3DCityDB views installed correctly!'::varchar AS installation_result;


-- ***********************************************************************
-- ***********************************************************************
--
-- END OF FILE
--
-- ***********************************************************************
-- ***********************************************************************