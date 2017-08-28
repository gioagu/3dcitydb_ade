-- 3D City Database Utilities Package
--
--                     August 2017
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
-- ****************** 02_citydb_util_VIEWS.sql ***************************
--
-- This  script installs some views in the citydb_view schema.
--
-- ***********************************************************************
-- ***********************************************************************

CREATE SCHEMA IF NOT EXISTS citydb_view;

----------------------------------------------------------------
-- View BUILDING
----------------------------------------------------------------
DROP VIEW IF EXISTS citydb_view.building CASCADE;
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
-- View CITYOBJECTGROUP
----------------------------------------------------------------
DROP VIEW IF EXISTS citydb_view.cityobjectgroup CASCADE;
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
-- View GROUP_TO_CITYOBJECT
----------------------------------------------------------------
DROP VIEW IF EXISTS citydb_view.group_to_cityobject CASCADE;
CREATE OR REPLACE VIEW citydb_view.group_to_cityobject AS
SELECT 
  gtc.cityobjectgroup_id, 
  cog.objectclass_id AS cog_objectclass_id, 
  o2.classname AS cog_classname, 
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
  co.objectclass_id = o1.id;
--ALTER VIEW citydb_view.group_to_cityobject OWNER TO postgres;

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

----------------------------------------------------------------
-- View XXX
----------------------------------------------------------------
--DROP VIEW IF EXISTS    citydb_view.xxx CASCADE;
--CREATE OR REPLACE VIEW citydb_view.xxx AS

--ALTER VIEW citydb_view.xxx OWNER TO postgres;

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


















