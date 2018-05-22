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
-- ****************** 04_citydb_util_VIEW_TRIGGERS.sql *******************
--
-- This  script installs some triggers and trigger function in
-- the citydb_view schema.
--
-- ***********************************************************************
-- ***********************************************************************

----------------------------------------------------------------
-- Function TR_DEL_CITYOBJECTGROUP
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.tr_del_cityobjectgroup() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.tr_del_cityobjectgroup()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
deleted_id=citydb_pkg.delete_cityobjectgroup(OLD.id, 0, schema_name);
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.tr_del_cityobjectgroup (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_CITYOBJECTGROUP
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.tr_ins_cityobjectgroup() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.tr_ins_cityobjectgroup()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	inserted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
inserted_id=citydb_view.insert_cityobjectgroup(
    id                    :=NEW.id,
    gmlid                 :=NEW.gmlid,
    gmlid_codespace       :=NEW.gmlid_codespace,
    name                  :=NEW.name,
    name_codespace        :=NEW.name_codespace,
    description           :=NEW.description,
    envelope              :=NEW.envelope,
    creation_date         :=NEW.creation_date,
    termination_date      :=NEW.termination_date,
    relative_to_terrain   :=NEW.relative_to_terrain,
    relative_to_water     :=NEW.relative_to_water,
    last_modification_date:=NEW.last_modification_date,
    updating_person       :=NEW.updating_person,
    reason_for_update     :=NEW.reason_for_update,
    lineage               :=NEW.lineage,
    class                 :=NEW.class,
    class_codespace       :=NEW.class_codespace,
    function              :=NEW.function,
    function_codespace    :=NEW.function_codespace,
    usage                 :=NEW.usage,
    usage_codespace       :=NEW.usage_codespace,
    brep_id               :=NEW.brep_id,
    other_geom            :=NEW.other_geom,
    parent_cityobject_id  :=NEW.parent_cityobject_id,
    schema_name           :=p_schema_name
);
--RAISE NOTICE 'Inserted new record with id: %', inserted_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.tr_ins_cityobjectgroup (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_CITYOBJECTGROUP
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.tr_upd_cityobjectgroup() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.tr_upd_cityobjectgroup()
  RETURNS trigger AS
$BODY$
DECLARE
  p_schema_name varchar DEFAULT 'citydb'::varchar;
  updated_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
EXECUTE format('UPDATE %I.cityobject AS t SET
 gmlid                 =%L,
 gmlid_codespace       =%L,
 name                  =%L,
 name_codespace        =%L,
 description           =%L,
 envelope              =%L,
 creation_date         =%L,
 termination_date      =%L,
 relative_to_terrain   =%L,
 relative_to_water     =%L,
 last_modification_date=%L,
 updating_person       =%L,
 reason_for_update     =%L,
 lineage               =%L
WHERE t.id=%L RETURNING id',
 p_schema_name,
 NEW.gmlid,
 NEW.gmlid_codespace,
 NEW.name,
 NEW.name_codespace,
 NEW.description,
 NEW.envelope,
 NEW.creation_date,
 NEW.termination_date,
 NEW.relative_to_terrain,
 NEW.relative_to_water,
 NEW.last_modification_date,
 NEW.updating_person,
 NEW.reason_for_update,
 NEW.lineage,
 OLD.id
) INTO updated_id;
EXECUTE format('UPDATE %I.cityobjectgroup AS t SET
 class               =%L,
 class_codespace     =%L,
 function            =%L,
 function_codespace  =%L,
 usage               =%L,
 usage_codespace     =%L,
 brep_id             =%L,
 other_geom          =%L,
 parent_cityobject_id=%L
WHERE t.id=%L RETURNING id',
 p_schema_name,
 NEW.class               ,
 NEW.class_codespace     ,
 NEW.function            ,
 NEW.function_codespace  ,
 NEW.usage               ,
 NEW.usage_codespace     ,
 NEW.brep_id             ,
 NEW.other_geom          ,
 NEW.parent_cityobject_id,
 OLD.id
) INTO updated_id;
-- RAISE NOTICE 'Updated record with id: %',updated_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.tr_upd_cityobjectgroup (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view CITYOBJECTGROUP
----------------------------------------------------------------
DROP TRIGGER IF EXISTS tr_del_cityobjectgroup ON citydb_view.cityobjectgroup;
CREATE TRIGGER tr_del_cityobjectgroup
	INSTEAD OF DELETE ON citydb_view.cityobjectgroup
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.tr_del_cityobjectgroup ('citydb');

DROP TRIGGER IF EXISTS tr_ins_cityobjectgroup ON citydb_view.cityobjectgroup;
CREATE TRIGGER tr_ins_cityobjectgroup
	INSTEAD OF INSERT ON citydb_view.cityobjectgroup
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.tr_ins_cityobjectgroup ('citydb');

DROP TRIGGER IF EXISTS tr_upd_cityobjectgroup ON citydb_view.cityobjectgroup;
CREATE TRIGGER tr_upd_cityobjectgroup
	INSTEAD OF UPDATE ON citydb_view.cityobjectgroup
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.tr_upd_cityobjectgroup ('citydb');
-- *************************************************************
-- *************************************************************

----------------------------------------------------------------
-- Function TR_DEL_BUILDING
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.tr_del_building() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.tr_del_building()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
deleted_id=citydb_pkg.delete_cityobject(OLD.id, 0, 0, schema_name);
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.tr_del_building (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_BUILDING
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.tr_ins_building() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.tr_ins_building()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	inserted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
inserted_id=citydb_view.insert_building(
    id                    :=NEW.id,
    gmlid                 :=NEW.gmlid,
    gmlid_codespace       :=NEW.gmlid_codespace,
    name                  :=NEW.name,
    name_codespace        :=NEW.name_codespace,
    description           :=NEW.description,
    envelope              :=NEW.envelope,
    creation_date         :=NEW.creation_date,
    termination_date      :=NEW.termination_date,
    relative_to_terrain   :=NEW.relative_to_terrain,
    relative_to_water     :=NEW.relative_to_water,
    last_modification_date:=NEW.last_modification_date,
    updating_person       :=NEW.updating_person,
    reason_for_update     :=NEW.reason_for_update,
    lineage               :=NEW.lineage,
    building_parent_id         :=NEW.building_parent_id,
    building_root_id           :=NEW.building_root_id,
    class                      :=NEW.class,
    class_codespace            :=NEW.class_codespace,
    function                   :=NEW.function,
    function_codespace         :=NEW.function_codespace,
    usage                      :=NEW.usage,
    usage_codespace            :=NEW.usage_codespace,
    year_of_construction       :=NEW.year_of_construction,
    year_of_demolition         :=NEW.year_of_demolition,
    roof_type                  :=NEW.roof_type,
    roof_type_codespace        :=NEW.roof_type_codespace,
    measured_height            :=NEW.measured_height,
    measured_height_unit       :=NEW.measured_height_unit,
    storeys_above_ground       :=NEW.storeys_above_ground,
    storeys_below_ground       :=NEW.storeys_below_ground,
    storey_heights_above_ground:=NEW.storey_heights_above_ground,
    storey_heights_ag_unit     :=NEW.storey_heights_ag_unit,
    storey_heights_below_ground:=NEW.storey_heights_below_ground,
    storey_heights_bg_unit     :=NEW.storey_heights_bg_unit,
    lod1_terrain_intersection  :=NEW.lod1_terrain_intersection,
    lod2_terrain_intersection  :=NEW.lod2_terrain_intersection,
    lod3_terrain_intersection  :=NEW.lod3_terrain_intersection,
    lod4_terrain_intersection  :=NEW.lod4_terrain_intersection,
    lod2_multi_curve           :=NEW.lod2_multi_curve,
    lod3_multi_curve           :=NEW.lod3_multi_curve,
    lod4_multi_curve           :=NEW.lod4_multi_curve,
    lod0_footprint_id          :=NEW.lod0_footprint_id,
    lod0_roofprint_id          :=NEW.lod0_roofprint_id,
    lod1_multi_surface_id      :=NEW.lod1_multi_surface_id,
    lod2_multi_surface_id      :=NEW.lod2_multi_surface_id,
    lod3_multi_surface_id      :=NEW.lod3_multi_surface_id,
    lod4_multi_surface_id      :=NEW.lod4_multi_surface_id,
    lod1_solid_id              :=NEW.lod1_solid_id,
    lod2_solid_id              :=NEW.lod2_solid_id,
    lod3_solid_id              :=NEW.lod3_solid_id,
    lod4_solid_id              :=NEW.lod4_solid_id,
    schema_name                :=p_schema_name
);
--RAISE NOTICE 'Inserted record with id: %', inserted_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.tr_ins_building (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_BUILDING
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.tr_upd_building() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.tr_upd_building()
  RETURNS trigger AS
$BODY$
DECLARE
  p_schema_name varchar DEFAULT 'citydb'::varchar;
  updated_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
EXECUTE format('UPDATE %I.cityobject AS t SET
 gmlid                 =%L,
 gmlid_codespace       =%L,
 name                  =%L,
 name_codespace        =%L,
 description           =%L,
 envelope              =%L,
 creation_date         =%L,
 termination_date      =%L,
 relative_to_terrain   =%L,
 relative_to_water     =%L,
 last_modification_date=%L,
 updating_person       =%L,
 reason_for_update     =%L,
 lineage               =%L
WHERE t.id=%L RETURNING id',
 p_schema_name,
 NEW.gmlid,
 NEW.gmlid_codespace,
 NEW.name,
 NEW.name_codespace,
 NEW.description,
 NEW.envelope,
 NEW.creation_date,
 NEW.termination_date,
 NEW.relative_to_terrain,
 NEW.relative_to_water,
 NEW.last_modification_date,
 NEW.updating_person,
 NEW.reason_for_update,
 NEW.lineage,
 OLD.id
) INTO updated_id;
EXECUTE format('UPDATE %I.building AS t SET
 building_parent_id         =%L,
 building_root_id           =%L,
 class                      =%L,
 class_codespace            =%L,
 function                   =%L,
 function_codespace         =%L,
 usage                      =%L,
 usage_codespace            =%L,
 year_of_construction       =%L,
 year_of_demolition         =%L,
 roof_type                  =%L,
 roof_type_codespace        =%L,
 measured_height            =%L,
 measured_height_unit       =%L,
 storeys_above_ground       =%L,
 storeys_below_ground       =%L,
 storey_heights_above_ground=%L,
 storey_heights_ag_unit     =%L,
 storey_heights_below_ground=%L,
 storey_heights_bg_unit     =%L,
 lod1_terrain_intersection  =%L,
 lod2_terrain_intersection  =%L,
 lod3_terrain_intersection  =%L,
 lod4_terrain_intersection  =%L,
 lod2_multi_curve           =%L,
 lod3_multi_curve           =%L,
 lod4_multi_curve           =%L,
 lod0_footprint_id          =%L,
 lod0_roofprint_id          =%L,
 lod1_multi_surface_id      =%L,
 lod2_multi_surface_id      =%L,
 lod3_multi_surface_id      =%L,
 lod4_multi_surface_id      =%L,
 lod1_solid_id              =%L,
 lod2_solid_id              =%L,
 lod3_solid_id              =%L,
 lod4_solid_id              =%L
WHERE t.id=%L RETURNING id',
 p_schema_name,
 NEW.building_parent_id,
 NEW.building_root_id,
 NEW.class,
 NEW.class_codespace,
 NEW.function,
 NEW.function_codespace,
 NEW.usage,
 NEW.usage_codespace,
 NEW.year_of_construction,
 NEW.year_of_demolition,
 NEW.roof_type,
 NEW.roof_type_codespace,
 NEW.measured_height,
 NEW.measured_height_unit,
 NEW.storeys_above_ground,
 NEW.storeys_below_ground,
 NEW.storey_heights_above_ground,
 NEW.storey_heights_ag_unit,
 NEW.storey_heights_below_ground,
 NEW.storey_heights_bg_unit,
 NEW.lod1_terrain_intersection,
 NEW.lod2_terrain_intersection,
 NEW.lod3_terrain_intersection,
 NEW.lod4_terrain_intersection,
 NEW.lod2_multi_curve,
 NEW.lod3_multi_curve,
 NEW.lod4_multi_curve,
 NEW.lod0_footprint_id,
 NEW.lod0_roofprint_id,
 NEW.lod1_multi_surface_id,
 NEW.lod2_multi_surface_id,
 NEW.lod3_multi_surface_id,
 NEW.lod4_multi_surface_id,
 NEW.lod1_solid_id,
 NEW.lod2_solid_id,
 NEW.lod3_solid_id,
 NEW.lod4_solid_id,
 OLD.id
) INTO updated_id;
-- RAISE NOTICE 'Updated record with id: %',updated_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.tr_upd_building (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view BUILDING
----------------------------------------------------------------
DROP TRIGGER IF EXISTS tr_del_building ON citydb_view.building;
CREATE TRIGGER tr_del_building
	INSTEAD OF DELETE ON citydb_view.building
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.tr_del_building ('citydb');

DROP TRIGGER IF EXISTS tr_ins_building ON citydb_view.building;
CREATE TRIGGER tr_ins_building
	INSTEAD OF INSERT ON citydb_view.building
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.tr_ins_building ('citydb');

DROP TRIGGER IF EXISTS tr_upd_building ON citydb_view.building;
CREATE TRIGGER tr_upd_building
	INSTEAD OF UPDATE ON citydb_view.building
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.tr_upd_building ('citydb');
--**************************************************************
--**************************************************************

----------------------------------------------------------------
-- Function TR_DEL_BUILDING_PART
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.tr_del_building_part() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.tr_del_building_part()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
deleted_id=citydb_pkg.delete_building(OLD.id, schema_name);
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.tr_del_building_part (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_BUILDING_PART
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.tr_ins_building_part() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.tr_ins_building_part()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	inserted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
inserted_id=citydb_view.insert_building_part(
    id                    :=NEW.id,
    gmlid                 :=NEW.gmlid,
    gmlid_codespace       :=NEW.gmlid_codespace,
    name                  :=NEW.name,
    name_codespace        :=NEW.name_codespace,
    description           :=NEW.description,
    envelope              :=NEW.envelope,
    creation_date         :=NEW.creation_date,
    termination_date      :=NEW.termination_date,
    relative_to_terrain   :=NEW.relative_to_terrain,
    relative_to_water     :=NEW.relative_to_water,
    last_modification_date:=NEW.last_modification_date,
    updating_person       :=NEW.updating_person,
    reason_for_update     :=NEW.reason_for_update,
    lineage               :=NEW.lineage,
    building_parent_id         :=NEW.building_parent_id,
    building_root_id           :=NEW.building_root_id,
    class                      :=NEW.class,
    class_codespace            :=NEW.class_codespace,
    function                   :=NEW.function,
    function_codespace         :=NEW.function_codespace,
    usage                      :=NEW.usage,
    usage_codespace            :=NEW.usage_codespace,
    year_of_construction       :=NEW.year_of_construction,
    year_of_demolition         :=NEW.year_of_demolition,
    roof_type                  :=NEW.roof_type,
    roof_type_codespace        :=NEW.roof_type_codespace,
    measured_height            :=NEW.measured_height,
    measured_height_unit       :=NEW.measured_height_unit,
    storeys_above_ground       :=NEW.storeys_above_ground,
    storeys_below_ground       :=NEW.storeys_below_ground,
    storey_heights_above_ground:=NEW.storey_heights_above_ground,
    storey_heights_ag_unit     :=NEW.storey_heights_ag_unit,
    storey_heights_below_ground:=NEW.storey_heights_below_ground,
    storey_heights_bg_unit     :=NEW.storey_heights_bg_unit,
    lod1_terrain_intersection  :=NEW.lod1_terrain_intersection,
    lod2_terrain_intersection  :=NEW.lod2_terrain_intersection,
    lod3_terrain_intersection  :=NEW.lod3_terrain_intersection,
    lod4_terrain_intersection  :=NEW.lod4_terrain_intersection,
    lod2_multi_curve           :=NEW.lod2_multi_curve,
    lod3_multi_curve           :=NEW.lod3_multi_curve,
    lod4_multi_curve           :=NEW.lod4_multi_curve,
    lod0_footprint_id          :=NEW.lod0_footprint_id,
    lod0_roofprint_id          :=NEW.lod0_roofprint_id,
    lod1_multi_surface_id      :=NEW.lod1_multi_surface_id,
    lod2_multi_surface_id      :=NEW.lod2_multi_surface_id,
    lod3_multi_surface_id      :=NEW.lod3_multi_surface_id,
    lod4_multi_surface_id      :=NEW.lod4_multi_surface_id,
    lod1_solid_id              :=NEW.lod1_solid_id,
    lod2_solid_id              :=NEW.lod2_solid_id,
    lod3_solid_id              :=NEW.lod3_solid_id,
    lod4_solid_id              :=NEW.lod4_solid_id,
    schema_name                :=p_schema_name
);
--RAISE NOTICE 'Inserted record with id: %', inserted_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.tr_ins_building_part (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_BUILDING_PART
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.tr_upd_building_part() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.tr_upd_building_part()
  RETURNS trigger AS
$BODY$
DECLARE
  p_schema_name varchar DEFAULT 'citydb'::varchar;
  updated_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
EXECUTE format('UPDATE %I.cityobject AS t SET
 gmlid                 =%L,
 gmlid_codespace       =%L,
 name                  =%L,
 name_codespace        =%L,
 description           =%L,
 envelope              =%L,
 creation_date         =%L,
 termination_date      =%L,
 relative_to_terrain   =%L,
 relative_to_water     =%L,
 last_modification_date=%L,
 updating_person       =%L,
 reason_for_update     =%L,
 lineage               =%L
WHERE t.id=%L RETURNING id',
 p_schema_name,
 NEW.gmlid,
 NEW.gmlid_codespace,
 NEW.name,
 NEW.name_codespace,
 NEW.description,
 NEW.envelope,
 NEW.creation_date,
 NEW.termination_date,
 NEW.relative_to_terrain,
 NEW.relative_to_water,
 NEW.last_modification_date,
 NEW.updating_person,
 NEW.reason_for_update,
 NEW.lineage,
 OLD.id
) INTO updated_id;
EXECUTE format('UPDATE %I.building AS t SET
 building_parent_id         =%L,
 building_root_id           =%L,
 class                      =%L,
 class_codespace            =%L,
 function                   =%L,
 function_codespace         =%L,
 usage                      =%L,
 usage_codespace            =%L,
 year_of_construction       =%L,
 year_of_demolition         =%L,
 roof_type                  =%L,
 roof_type_codespace        =%L,
 measured_height            =%L,
 measured_height_unit       =%L,
 storeys_above_ground       =%L,
 storeys_below_ground       =%L,
 storey_heights_above_ground=%L,
 storey_heights_ag_unit     =%L,
 storey_heights_below_ground=%L,
 storey_heights_bg_unit     =%L,
 lod1_terrain_intersection  =%L,
 lod2_terrain_intersection  =%L,
 lod3_terrain_intersection  =%L,
 lod4_terrain_intersection  =%L,
 lod2_multi_curve           =%L,
 lod3_multi_curve           =%L,
 lod4_multi_curve           =%L,
 lod0_footprint_id          =%L,
 lod0_roofprint_id          =%L,
 lod1_multi_surface_id      =%L,
 lod2_multi_surface_id      =%L,
 lod3_multi_surface_id      =%L,
 lod4_multi_surface_id      =%L,
 lod1_solid_id              =%L,
 lod2_solid_id              =%L,
 lod3_solid_id              =%L,
 lod4_solid_id              =%L
WHERE t.id=%L RETURNING id',
 p_schema_name,
 NEW.building_parent_id,
 NEW.building_root_id,
 NEW.class,
 NEW.class_codespace,
 NEW.function,
 NEW.function_codespace,
 NEW.usage,
 NEW.usage_codespace,
 NEW.year_of_construction,
 NEW.year_of_demolition,
 NEW.roof_type,
 NEW.roof_type_codespace,
 NEW.measured_height,
 NEW.measured_height_unit,
 NEW.storeys_above_ground,
 NEW.storeys_below_ground,
 NEW.storey_heights_above_ground,
 NEW.storey_heights_ag_unit,
 NEW.storey_heights_below_ground,
 NEW.storey_heights_bg_unit,
 NEW.lod1_terrain_intersection,
 NEW.lod2_terrain_intersection,
 NEW.lod3_terrain_intersection,
 NEW.lod4_terrain_intersection,
 NEW.lod2_multi_curve,
 NEW.lod3_multi_curve,
 NEW.lod4_multi_curve,
 NEW.lod0_footprint_id,
 NEW.lod0_roofprint_id,
 NEW.lod1_multi_surface_id,
 NEW.lod2_multi_surface_id,
 NEW.lod3_multi_surface_id,
 NEW.lod4_multi_surface_id,
 NEW.lod1_solid_id,
 NEW.lod2_solid_id,
 NEW.lod3_solid_id,
 NEW.lod4_solid_id,
 OLD.id
) INTO updated_id;
-- RAISE NOTICE 'Updated record with id: %',updated_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.tr_upd_building (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view BUILDING_PART
----------------------------------------------------------------
DROP TRIGGER IF EXISTS tr_del_building_part ON citydb_view.building_part;
CREATE TRIGGER tr_del_building_part
	INSTEAD OF DELETE ON citydb_view.building_part
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.tr_del_building_part ('citydb');

DROP TRIGGER IF EXISTS tr_ins_building_part ON citydb_view.building_part;
CREATE TRIGGER tr_ins_building_part
	INSTEAD OF INSERT ON citydb_view.building_part
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.tr_ins_building_part ('citydb');

DROP TRIGGER IF EXISTS tr_upd_building_part ON citydb_view.building_part;
CREATE TRIGGER tr_upd_building_part
	INSTEAD OF UPDATE ON citydb_view.building_part
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.tr_upd_building_part ('citydb');
--**************************************************************
--**************************************************************




--**************************************************************
--**************************************************************

DO
$$
BEGIN
RAISE NOTICE '

********************************

3DCityDB view triggers installed correctly!

********************************

';
END
$$;
SELECT '3DCityDB view triggers installed correctly!'::varchar AS installation_result;


-- ***********************************************************************
-- ***********************************************************************
--
-- END OF FILE
--
-- ***********************************************************************
-- ***********************************************************************


















