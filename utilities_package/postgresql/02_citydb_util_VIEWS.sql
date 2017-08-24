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


















