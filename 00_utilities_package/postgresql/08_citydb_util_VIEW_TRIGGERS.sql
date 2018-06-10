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
-- ****************** 08_citydb_util_VIEW_TRIGGERS.sql *******************
--
-- This  script installs some triggers and trigger function in
-- the citydb_view schema.
--
-- ***********************************************************************
-- ***********************************************************************

----------------------------------------------------------------
-- Function TR_DEL_CITYMODEL
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.tr_del_citymodel() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.tr_del_citymodel()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
deleted_id=citydb_pkg.delete_citymodel(OLD.id, 0, p_schema_name);
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.tr_del_citymodel (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_CITYMODEL
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.tr_ins_citymodel() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.tr_ins_citymodel()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	inserted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
inserted_id=citydb_view.insert_citymodel(
id                    :=NEW.id                    ,
gmlid                 :=NEW.gmlid                 ,
gmlid_codespace       :=NEW.gmlid_codespace       ,
name                  :=NEW.name                  ,
name_codespace        :=NEW.name_codespace        ,
description           :=NEW.description           ,
envelope              :=NEW.envelope              ,
creation_date         :=NEW.creation_date         ,
termination_date      :=NEW.termination_date      ,
last_modification_date:=NEW.last_modification_date,
updating_person       :=NEW.updating_person       ,
reason_for_update     :=NEW.reason_for_update     ,
lineage               :=NEW.lineage               ,
--		
schema_name           :=p_schema_name
);
--RAISE NOTICE 'Inserted new record with id: %', inserted_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.tr_ins_citymodel (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_CITYMODEL
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.tr_upd_citymodel() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.tr_upd_citymodel()
  RETURNS trigger AS
$BODY$
DECLARE
  p_schema_name varchar DEFAULT 'citydb'::varchar;
  updated_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
EXECUTE format('UPDATE %I.citymodel AS t SET
 gmlid                 :=%L,
 gmlid_codespace       :=%L,
 name                  :=%L,
 name_codespace        :=%L,
 description           :=%L,
 envelope              :=%L,
 creation_date         :=%L,
 termination_date      :=%L,
 last_modification_date:=%L,
 updating_person       :=%L,
 reason_for_update     :=%L,
 lineage               :=%L
WHERE t.id=%L RETURNING id',
 p_schema_name,
 NEW.gmlid                 ,
 NEW.gmlid_codespace       ,
 NEW.name                  ,
 NEW.name_codespace        ,
 NEW.description           ,
 NEW.envelope              ,
 NEW.creation_date         ,
 NEW.termination_date      ,
 NEW.last_modification_date,
 NEW.updating_person       ,
 NEW.reason_for_update     ,
 NEW.lineage               , 
 OLD.id
) INTO updated_id;
-- RAISE NOTICE 'Updated record with id: %',updated_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.tr_upd_citymodel (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view CITYMODEL
----------------------------------------------------------------
DROP TRIGGER IF EXISTS tr_del_citymodel ON citydb_view.citymodel;
CREATE TRIGGER tr_del_citymodel
	INSTEAD OF DELETE ON citydb_view.citymodel
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.tr_del_citymodel ('citydb');

DROP TRIGGER IF EXISTS tr_ins_citymodel ON citydb_view.citymodel;
CREATE TRIGGER tr_ins_citymodel
	INSTEAD OF INSERT ON citydb_view.citymodel
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.tr_ins_citymodel ('citydb');

DROP TRIGGER IF EXISTS tr_upd_citymodel ON citydb_view.citymodel;
CREATE TRIGGER tr_upd_citymodel
	INSTEAD OF UPDATE ON citydb_view.citymodel
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.tr_upd_citymodel ('citydb');
-- *************************************************************
-- *************************************************************

----------------------------------------------------------------
-- Function TR_DEL_CITYOBJECTGROUP
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.tr_del_cityobjectgroup() CASCADE;
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
deleted_id=citydb_pkg.delete_cityobjectgroup(OLD.id, 0, p_schema_name);
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
deleted_id=citydb_pkg.delete_cityobject(OLD.id, 0, 0, p_schema_name);
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
deleted_id=citydb_pkg.delete_building(OLD.id, p_schema_name);
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

----------------------------------------------------------------
-- Function TR_DEL_CITYOBJECT_GENERICATTRIB_string
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.tr_del_cityobject_genericattrib_string() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.tr_del_cityobject_genericattrib_string()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
deleted_id=citydb_pkg.delete_genericattrib(OLD.id, 0, p_schema_name);
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.tr_del_cityobject_genericattrib_string (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_CITYOBJECT_GENERICATTRIB_string
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.tr_ins_cityobject_genericattrib_string() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.tr_ins_cityobject_genericattrib_string()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	inserted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
inserted_id=citydb_view.insert_cityobject_genericattrib_string(
  attrname            :=NEW.attrname           ,
  attrvalue           :=NEW.strval             ,
  cityobject_id       :=NEW.cityobject_id      ,
  id                  :=NEW.id                 ,
  parent_genattrib_id :=NEW.parent_genattrib_id,
  root_genattrib_id   :=NEW.root_genattrib_id  ,
--	
  schema_name         :=p_schema_name
);
--RAISE NOTICE 'Inserted record with id: %', inserted_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.tr_ins_cityobject_genericattrib_string (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_CITYOBJECT_GENERICATTRIB_string
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.tr_upd_cityobject_genericattrib_string() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.tr_upd_cityobject_genericattrib_string()
  RETURNS trigger AS
$BODY$
DECLARE
  p_schema_name varchar DEFAULT 'citydb'::varchar;
  updated_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
EXECUTE format('UPDATE %I.cityobject_genericattrib AS t SET
 attrname           =%L,
 strval             =%L,
 cityobject_id      =%L,
 parent_genattrib_id=%L,
 root_genattrib_id  =%L
WHERE t.id=%L RETURNING id',
 p_schema_name,
 NEW.attrname           ,
 NEW.strval             ,
 NEW.cityobject_id      ,
 NEW.parent_genattrib_id,
 NEW.root_genattrib_id  ,
 OLD.id
) INTO updated_id;
-- RAISE NOTICE 'Updated record with id: %',updated_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.tr_upd_cityobject_genericattrib_string (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view CITYOBJECT_GENERICATTRIB_string
----------------------------------------------------------------
DROP TRIGGER IF EXISTS tr_del_cityobject_genericattrib_string ON citydb_view.cityobject_genericattrib_string;
CREATE TRIGGER tr_del_cityobject_genericattrib_string
	INSTEAD OF DELETE ON citydb_view.cityobject_genericattrib_string
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.tr_del_cityobject_genericattrib_string ('citydb');

DROP TRIGGER IF EXISTS tr_ins_cityobject_genericattrib_string ON citydb_view.cityobject_genericattrib_string;
CREATE TRIGGER tr_ins_cityobject_genericattrib_string
	INSTEAD OF INSERT ON citydb_view.cityobject_genericattrib_string
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.tr_ins_cityobject_genericattrib_string ('citydb');

DROP TRIGGER IF EXISTS tr_upd_cityobject_genericattrib_string ON citydb_view.cityobject_genericattrib_string;
CREATE TRIGGER tr_upd_cityobject_genericattrib_string
	INSTEAD OF UPDATE ON citydb_view.cityobject_genericattrib_string
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.tr_upd_cityobject_genericattrib_string ('citydb');
--**************************************************************
--**************************************************************

----------------------------------------------------------------
-- Function TR_DEL_CITYOBJECT_GENERICATTRIB_integer
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.tr_del_cityobject_genericattrib_integer() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.tr_del_cityobject_genericattrib_integer()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
deleted_id=citydb_pkg.delete_genericattrib(OLD.id, 0, p_schema_name);
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.tr_del_cityobject_genericattrib_integer (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_CITYOBJECT_GENERICATTRIB_integer
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.tr_ins_cityobject_genericattrib_integer() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.tr_ins_cityobject_genericattrib_integer()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	inserted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
inserted_id=citydb_view.insert_cityobject_genericattrib_integer(
  attrname            :=NEW.attrname           ,
  attrvalue           :=NEW.intval             ,
  cityobject_id       :=NEW.cityobject_id      ,
  id                  :=NEW.id                 ,
  parent_genattrib_id :=NEW.parent_genattrib_id,
  root_genattrib_id   :=NEW.root_genattrib_id  ,
--	
  schema_name         :=p_schema_name
);
--RAISE NOTICE 'Inserted record with id: %', inserted_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.tr_ins_cityobject_genericattrib_integer (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_CITYOBJECT_GENERICATTRIB_integer
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.tr_upd_cityobject_genericattrib_integer() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.tr_upd_cityobject_genericattrib_integer()
  RETURNS trigger AS
$BODY$
DECLARE
  p_schema_name varchar DEFAULT 'citydb'::varchar;
  updated_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
EXECUTE format('UPDATE %I.cityobject_genericattrib AS t SET
 attrname           =%L,
 intval             =%L,
 cityobject_id      =%L,
 parent_genattrib_id=%L,
 root_genattrib_id  =%L
WHERE t.id=%L RETURNING id',
 p_schema_name,
 NEW.attrname           ,
 NEW.intval             ,
 NEW.cityobject_id      ,
 NEW.parent_genattrib_id,
 NEW.root_genattrib_id  ,
 OLD.id
) INTO updated_id;
-- RAISE NOTICE 'Updated record with id: %',updated_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.tr_upd_cityobject_genericattrib_integer (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view CITYOBJECT_GENERICATTRIB_integer
----------------------------------------------------------------
DROP TRIGGER IF EXISTS tr_del_cityobject_genericattrib_integer ON citydb_view.cityobject_genericattrib_integer;
CREATE TRIGGER tr_del_cityobject_genericattrib_integer
	INSTEAD OF DELETE ON citydb_view.cityobject_genericattrib_integer
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.tr_del_cityobject_genericattrib_integer ('citydb');

DROP TRIGGER IF EXISTS tr_ins_cityobject_genericattrib_integer ON citydb_view.cityobject_genericattrib_integer;
CREATE TRIGGER tr_ins_cityobject_genericattrib_integer
	INSTEAD OF INSERT ON citydb_view.cityobject_genericattrib_integer
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.tr_ins_cityobject_genericattrib_integer ('citydb');

DROP TRIGGER IF EXISTS tr_upd_cityobject_genericattrib_integer ON citydb_view.cityobject_genericattrib_integer;
CREATE TRIGGER tr_upd_cityobject_genericattrib_integer
	INSTEAD OF UPDATE ON citydb_view.cityobject_genericattrib_integer
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.tr_upd_cityobject_genericattrib_integer ('citydb');
--**************************************************************
--**************************************************************

----------------------------------------------------------------
-- Function TR_DEL_CITYOBJECT_GENERICATTRIB_real
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.tr_del_cityobject_genericattrib_real() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.tr_del_cityobject_genericattrib_real()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
deleted_id=citydb_pkg.delete_genericattrib(OLD.id, 0, p_schema_name);
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.tr_del_cityobject_genericattrib_real (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_CITYOBJECT_GENERICATTRIB_real
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.tr_ins_cityobject_genericattrib_real() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.tr_ins_cityobject_genericattrib_real()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	inserted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
inserted_id=citydb_view.insert_cityobject_genericattrib_real(
  attrname            :=NEW.attrname           ,
  attrvalue           :=NEW.realval             ,
  cityobject_id       :=NEW.cityobject_id      ,
  id                  :=NEW.id                 ,
  parent_genattrib_id :=NEW.parent_genattrib_id,
  root_genattrib_id   :=NEW.root_genattrib_id  ,
--	
  schema_name         :=p_schema_name
);
--RAISE NOTICE 'Inserted record with id: %', inserted_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.tr_ins_cityobject_genericattrib_real (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_CITYOBJECT_GENERICATTRIB_real
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.tr_upd_cityobject_genericattrib_real() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.tr_upd_cityobject_genericattrib_real()
  RETURNS trigger AS
$BODY$
DECLARE
  p_schema_name varchar DEFAULT 'citydb'::varchar;
  updated_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
EXECUTE format('UPDATE %I.cityobject_genericattrib AS t SET
 attrname           =%L,
 realval            =%L,
 cityobject_id      =%L,
 parent_genattrib_id=%L,
 root_genattrib_id  =%L
WHERE t.id=%L RETURNING id',
 p_schema_name,
 NEW.attrname           ,
 NEW.realval            ,
 NEW.cityobject_id      ,
 NEW.parent_genattrib_id,
 NEW.root_genattrib_id  ,
 OLD.id
) INTO updated_id;
-- RAISE NOTICE 'Updated record with id: %',updated_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.tr_upd_cityobject_genericattrib_real (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view CITYOBJECT_GENERICATTRIB_real
----------------------------------------------------------------
DROP TRIGGER IF EXISTS tr_del_cityobject_genericattrib_real ON citydb_view.cityobject_genericattrib_real;
CREATE TRIGGER tr_del_cityobject_genericattrib_real
	INSTEAD OF DELETE ON citydb_view.cityobject_genericattrib_real
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.tr_del_cityobject_genericattrib_real ('citydb');

DROP TRIGGER IF EXISTS tr_ins_cityobject_genericattrib_real ON citydb_view.cityobject_genericattrib_real;
CREATE TRIGGER tr_ins_cityobject_genericattrib_real
	INSTEAD OF INSERT ON citydb_view.cityobject_genericattrib_real
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.tr_ins_cityobject_genericattrib_real ('citydb');

DROP TRIGGER IF EXISTS tr_upd_cityobject_genericattrib_real ON citydb_view.cityobject_genericattrib_real;
CREATE TRIGGER tr_upd_cityobject_genericattrib_real
	INSTEAD OF UPDATE ON citydb_view.cityobject_genericattrib_real
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.tr_upd_cityobject_genericattrib_real ('citydb');
--**************************************************************
--**************************************************************

----------------------------------------------------------------
-- Function TR_DEL_CITYOBJECT_GENERICATTRIB_measure
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.tr_del_cityobject_genericattrib_measure() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.tr_del_cityobject_genericattrib_measure()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
deleted_id=citydb_pkg.delete_genericattrib(OLD.id, 0, p_schema_name);
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.tr_del_cityobject_genericattrib_measure (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_CITYOBJECT_GENERICATTRIB_measure
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.tr_ins_cityobject_genericattrib_measure() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.tr_ins_cityobject_genericattrib_measure()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	inserted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
inserted_id=citydb_view.insert_cityobject_genericattrib_measure(
  attrname            :=NEW.attrname           ,
  attrvalue           :=NEW.realval             ,
  attrvalue_unit      :=NEW.unit             ,  
  cityobject_id       :=NEW.cityobject_id      ,
  id                  :=NEW.id                 ,
  parent_genattrib_id :=NEW.parent_genattrib_id,
  root_genattrib_id   :=NEW.root_genattrib_id  ,
--	
  schema_name         :=p_schema_name
);
--RAISE NOTICE 'Inserted record with id: %', inserted_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.tr_ins_cityobject_genericattrib_measure (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_CITYOBJECT_GENERICATTRIB_measure
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.tr_upd_cityobject_genericattrib_measure() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.tr_upd_cityobject_genericattrib_measure()
  RETURNS trigger AS
$BODY$
DECLARE
  p_schema_name varchar DEFAULT 'citydb'::varchar;
  updated_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
EXECUTE format('UPDATE %I.cityobject_genericattrib AS t SET
 attrname           =%L,
 realval            =%L,
 unit               =%L,
 cityobject_id      =%L,
 parent_genattrib_id=%L,
 root_genattrib_id  =%L
WHERE t.id=%L RETURNING id',
 p_schema_name,
 NEW.attrname           ,
 NEW.realval            ,
 NEW.unit               ,
 NEW.cityobject_id      ,
 NEW.parent_genattrib_id,
 NEW.root_genattrib_id  ,
 OLD.id
) INTO updated_id;
-- RAISE NOTICE 'Updated record with id: %',updated_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.tr_upd_cityobject_genericattrib_measure (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view CITYOBJECT_GENERICATTRIB_measure
----------------------------------------------------------------
DROP TRIGGER IF EXISTS tr_del_cityobject_genericattrib_measure ON citydb_view.cityobject_genericattrib_measure;
CREATE TRIGGER tr_del_cityobject_genericattrib_measure
	INSTEAD OF DELETE ON citydb_view.cityobject_genericattrib_measure
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.tr_del_cityobject_genericattrib_measure ('citydb');

DROP TRIGGER IF EXISTS tr_ins_cityobject_genericattrib_measure ON citydb_view.cityobject_genericattrib_measure;
CREATE TRIGGER tr_ins_cityobject_genericattrib_measure
	INSTEAD OF INSERT ON citydb_view.cityobject_genericattrib_measure
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.tr_ins_cityobject_genericattrib_measure ('citydb');

DROP TRIGGER IF EXISTS tr_upd_cityobject_genericattrib_measure ON citydb_view.cityobject_genericattrib_measure;
CREATE TRIGGER tr_upd_cityobject_genericattrib_measure
	INSTEAD OF UPDATE ON citydb_view.cityobject_genericattrib_measure
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.tr_upd_cityobject_genericattrib_measure ('citydb');
--**************************************************************
--**************************************************************

----------------------------------------------------------------
-- Function TR_DEL_CITYOBJECT_GENERICATTRIB_uri
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.tr_del_cityobject_genericattrib_uri() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.tr_del_cityobject_genericattrib_uri()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
deleted_id=citydb_pkg.delete_genericattrib(OLD.id, 0, p_schema_name);
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.tr_del_cityobject_genericattrib_uri (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_CITYOBJECT_GENERICATTRIB_uri
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.tr_ins_cityobject_genericattrib_uri() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.tr_ins_cityobject_genericattrib_uri()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	inserted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
inserted_id=citydb_view.insert_cityobject_genericattrib_uri(
  attrname            :=NEW.attrname           ,
  attrvalue           :=NEW.urival             ,
  cityobject_id       :=NEW.cityobject_id      ,
  id                  :=NEW.id                 ,
  parent_genattrib_id :=NEW.parent_genattrib_id,
  root_genattrib_id   :=NEW.root_genattrib_id  ,
--	
  schema_name         :=p_schema_name
);
--RAISE NOTICE 'Inserted record with id: %', inserted_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.tr_ins_cityobject_genericattrib_uri (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_CITYOBJECT_GENERICATTRIB_uri
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.tr_upd_cityobject_genericattrib_uri() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.tr_upd_cityobject_genericattrib_uri()
  RETURNS trigger AS
$BODY$
DECLARE
  p_schema_name varchar DEFAULT 'citydb'::varchar;
  updated_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
EXECUTE format('UPDATE %I.cityobject_genericattrib AS t SET
 attrname           =%L,
 urival            =%L,
 cityobject_id      =%L,
 parent_genattrib_id=%L,
 root_genattrib_id  =%L
WHERE t.id=%L RETURNING id',
 p_schema_name,
 NEW.attrname           ,
 NEW.urival            ,
 NEW.cityobject_id      ,
 NEW.parent_genattrib_id,
 NEW.root_genattrib_id  ,
 OLD.id
) INTO updated_id;
-- RAISE NOTICE 'Updated record with id: %',updated_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.tr_upd_cityobject_genericattrib_uri (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view CITYOBJECT_GENERICATTRIB_uri
----------------------------------------------------------------
DROP TRIGGER IF EXISTS tr_del_cityobject_genericattrib_uri ON citydb_view.cityobject_genericattrib_uri;
CREATE TRIGGER tr_del_cityobject_genericattrib_uri
	INSTEAD OF DELETE ON citydb_view.cityobject_genericattrib_uri
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.tr_del_cityobject_genericattrib_uri ('citydb');

DROP TRIGGER IF EXISTS tr_ins_cityobject_genericattrib_uri ON citydb_view.cityobject_genericattrib_uri;
CREATE TRIGGER tr_ins_cityobject_genericattrib_uri
	INSTEAD OF INSERT ON citydb_view.cityobject_genericattrib_uri
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.tr_ins_cityobject_genericattrib_uri ('citydb');

DROP TRIGGER IF EXISTS tr_upd_cityobject_genericattrib_uri ON citydb_view.cityobject_genericattrib_uri;
CREATE TRIGGER tr_upd_cityobject_genericattrib_uri
	INSTEAD OF UPDATE ON citydb_view.cityobject_genericattrib_uri
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.tr_upd_cityobject_genericattrib_uri ('citydb');
--**************************************************************
--**************************************************************

----------------------------------------------------------------
-- Function TR_DEL_CITYOBJECT_GENERICATTRIB_date
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.tr_del_cityobject_genericattrib_date() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.tr_del_cityobject_genericattrib_date()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
deleted_id=citydb_pkg.delete_genericattrib(OLD.id, 0, p_schema_name);
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.tr_del_cityobject_genericattrib_date (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_CITYOBJECT_GENERICATTRIB_date
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.tr_ins_cityobject_genericattrib_date() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.tr_ins_cityobject_genericattrib_date()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	inserted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
inserted_id=citydb_view.insert_cityobject_genericattrib_date(
  attrname            :=NEW.attrname           ,
  attrvalue           :=NEW.dateval             ,
  cityobject_id       :=NEW.cityobject_id      ,
  id                  :=NEW.id                 ,
  parent_genattrib_id :=NEW.parent_genattrib_id,
  root_genattrib_id   :=NEW.root_genattrib_id  ,
--	
  schema_name         :=p_schema_name
);
--RAISE NOTICE 'Inserted record with id: %', inserted_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.tr_ins_cityobject_genericattrib_date (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_CITYOBJECT_GENERICATTRIB_date
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.tr_upd_cityobject_genericattrib_date() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.tr_upd_cityobject_genericattrib_date()
  RETURNS trigger AS
$BODY$
DECLARE
  p_schema_name varchar DEFAULT 'citydb'::varchar;
  updated_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
EXECUTE format('UPDATE %I.cityobject_genericattrib AS t SET
 attrname           =%L,
 dateval            =%L,
 cityobject_id      =%L,
 parent_genattrib_id=%L,
 root_genattrib_id  =%L
WHERE t.id=%L RETURNING id',
 p_schema_name,
 NEW.attrname           ,
 NEW.dateval            ,
 NEW.cityobject_id      ,
 NEW.parent_genattrib_id,
 NEW.root_genattrib_id  ,
 OLD.id
) INTO updated_id;
-- RAISE NOTICE 'Updated record with id: %',updated_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.tr_upd_cityobject_genericattrib_date (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view CITYOBJECT_GENERICATTRIB_date
----------------------------------------------------------------
DROP TRIGGER IF EXISTS tr_del_cityobject_genericattrib_date ON citydb_view.cityobject_genericattrib_date;
CREATE TRIGGER tr_del_cityobject_genericattrib_date
	INSTEAD OF DELETE ON citydb_view.cityobject_genericattrib_date
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.tr_del_cityobject_genericattrib_date ('citydb');

DROP TRIGGER IF EXISTS tr_ins_cityobject_genericattrib_date ON citydb_view.cityobject_genericattrib_date;
CREATE TRIGGER tr_ins_cityobject_genericattrib_date
	INSTEAD OF INSERT ON citydb_view.cityobject_genericattrib_date
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.tr_ins_cityobject_genericattrib_date ('citydb');

DROP TRIGGER IF EXISTS tr_upd_cityobject_genericattrib_date ON citydb_view.cityobject_genericattrib_date;
CREATE TRIGGER tr_upd_cityobject_genericattrib_date
	INSTEAD OF UPDATE ON citydb_view.cityobject_genericattrib_date
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.tr_upd_cityobject_genericattrib_date ('citydb');
--**************************************************************
--**************************************************************

----------------------------------------------------------------
-- Function TR_DEL_CITYOBJECT_GENERICATTRIB_blob
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.tr_del_cityobject_genericattrib_blob() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.tr_del_cityobject_genericattrib_blob()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
deleted_id=citydb_pkg.delete_genericattrib(OLD.id, 0, p_schema_name);
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.tr_del_cityobject_genericattrib_blob (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_CITYOBJECT_GENERICATTRIB_blob
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.tr_ins_cityobject_genericattrib_blob() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.tr_ins_cityobject_genericattrib_blob()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	inserted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
inserted_id=citydb_view.insert_cityobject_genericattrib_blob(
  attrname            :=NEW.attrname           ,
  attrvalue           :=NEW.blobval             ,
  cityobject_id       :=NEW.cityobject_id      ,
  id                  :=NEW.id                 ,
  parent_genattrib_id :=NEW.parent_genattrib_id,
  root_genattrib_id   :=NEW.root_genattrib_id  ,
--	
  schema_name         :=p_schema_name
);
--RAISE NOTICE 'Inserted record with id: %', inserted_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.tr_ins_cityobject_genericattrib_blob (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_CITYOBJECT_GENERICATTRIB_blob
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.tr_upd_cityobject_genericattrib_blob() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.tr_upd_cityobject_genericattrib_blob()
  RETURNS trigger AS
$BODY$
DECLARE
  p_schema_name varchar DEFAULT 'citydb'::varchar;
  updated_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
EXECUTE format('UPDATE %I.cityobject_genericattrib AS t SET
 attrname           =%L,
 blobval            =%L,
 cityobject_id      =%L,
 parent_genattrib_id=%L,
 root_genattrib_id  =%L
WHERE t.id=%L RETURNING id',
 p_schema_name,
 NEW.attrname           ,
 NEW.blobval            ,
 NEW.cityobject_id      ,
 NEW.parent_genattrib_id,
 NEW.root_genattrib_id  ,
 OLD.id
) INTO updated_id;
-- RAISE NOTICE 'Updated record with id: %',updated_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.tr_upd_cityobject_genericattrib_blob (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view CITYOBJECT_GENERICATTRIB_blob
----------------------------------------------------------------
DROP TRIGGER IF EXISTS tr_del_cityobject_genericattrib_blob ON citydb_view.cityobject_genericattrib_blob;
CREATE TRIGGER tr_del_cityobject_genericattrib_blob
	INSTEAD OF DELETE ON citydb_view.cityobject_genericattrib_blob
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.tr_del_cityobject_genericattrib_blob ('citydb');

DROP TRIGGER IF EXISTS tr_ins_cityobject_genericattrib_blob ON citydb_view.cityobject_genericattrib_blob;
CREATE TRIGGER tr_ins_cityobject_genericattrib_blob
	INSTEAD OF INSERT ON citydb_view.cityobject_genericattrib_blob
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.tr_ins_cityobject_genericattrib_blob ('citydb');

DROP TRIGGER IF EXISTS tr_upd_cityobject_genericattrib_blob ON citydb_view.cityobject_genericattrib_blob;
CREATE TRIGGER tr_upd_cityobject_genericattrib_blob
	INSTEAD OF UPDATE ON citydb_view.cityobject_genericattrib_blob
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.tr_upd_cityobject_genericattrib_blob ('citydb');
--**************************************************************
--**************************************************************

----------------------------------------------------------------
-- Function TR_DEL_CITYOBJECT_GENERICATTRIB_geometry
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.tr_del_cityobject_genericattrib_geometry() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.tr_del_cityobject_genericattrib_geometry()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
deleted_id=citydb_pkg.delete_genericattrib(OLD.id, 0, p_schema_name);
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.tr_del_cityobject_genericattrib_geometry (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_CITYOBJECT_GENERICATTRIB_geometry
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.tr_ins_cityobject_genericattrib_geometry() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.tr_ins_cityobject_genericattrib_geometry()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	inserted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
inserted_id=citydb_view.insert_cityobject_genericattrib_geometry(
  attrname            :=NEW.attrname           ,
  attrvalue           :=NEW.geomval             ,
  cityobject_id       :=NEW.cityobject_id      ,
  id                  :=NEW.id                 ,
  parent_genattrib_id :=NEW.parent_genattrib_id,
  root_genattrib_id   :=NEW.root_genattrib_id  ,
--	
  schema_name         :=p_schema_name
);
--RAISE NOTICE 'Inserted record with id: %', inserted_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.tr_ins_cityobject_genericattrib_geometry (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_CITYOBJECT_GENERICATTRIB_geometry
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.tr_upd_cityobject_genericattrib_geometry() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.tr_upd_cityobject_genericattrib_geometry()
  RETURNS trigger AS
$BODY$
DECLARE
  p_schema_name varchar DEFAULT 'citydb'::varchar;
  updated_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
EXECUTE format('UPDATE %I.cityobject_genericattrib AS t SET
 attrname           =%L,
 geomval            =%L,
 cityobject_id      =%L,
 parent_genattrib_id=%L,
 root_genattrib_id  =%L
WHERE t.id=%L RETURNING id',
 p_schema_name,
 NEW.attrname           ,
 NEW.geomval            ,
 NEW.cityobject_id      ,
 NEW.parent_genattrib_id,
 NEW.root_genattrib_id  ,
 OLD.id
) INTO updated_id;
-- RAISE NOTICE 'Updated record with id: %',updated_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.tr_upd_cityobject_genericattrib_geometry (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view CITYOBJECT_GENERICATTRIB_geometry
----------------------------------------------------------------
DROP TRIGGER IF EXISTS tr_del_cityobject_genericattrib_geometry ON citydb_view.cityobject_genericattrib_geometry;
CREATE TRIGGER tr_del_cityobject_genericattrib_geometry
	INSTEAD OF DELETE ON citydb_view.cityobject_genericattrib_geometry
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.tr_del_cityobject_genericattrib_geometry ('citydb');

DROP TRIGGER IF EXISTS tr_ins_cityobject_genericattrib_geometry ON citydb_view.cityobject_genericattrib_geometry;
CREATE TRIGGER tr_ins_cityobject_genericattrib_geometry
	INSTEAD OF INSERT ON citydb_view.cityobject_genericattrib_geometry
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.tr_ins_cityobject_genericattrib_geometry ('citydb');

DROP TRIGGER IF EXISTS tr_upd_cityobject_genericattrib_geometry ON citydb_view.cityobject_genericattrib_geometry;
CREATE TRIGGER tr_upd_cityobject_genericattrib_geometry
	INSTEAD OF UPDATE ON citydb_view.cityobject_genericattrib_geometry
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.tr_upd_cityobject_genericattrib_geometry ('citydb');
--**************************************************************
--**************************************************************

----------------------------------------------------------------
-- Function TR_DEL_CITYOBJECT_GENERICATTRIB_surfgeom
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.tr_del_cityobject_genericattrib_surfgeom() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.tr_del_cityobject_genericattrib_surfgeom()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
deleted_id=citydb_pkg.delete_genericattrib(OLD.id, 0, p_schema_name);
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.tr_del_cityobject_genericattrib_surfgeom (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_CITYOBJECT_GENERICATTRIB_surfgeom
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.tr_ins_cityobject_genericattrib_surfgeom() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.tr_ins_cityobject_genericattrib_surfgeom()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	inserted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
inserted_id=citydb_view.insert_cityobject_genericattrib_surfgeom(
  attrname            :=NEW.attrname           ,
  attrvalue           :=NEW.surface_geometry_id,
  cityobject_id       :=NEW.cityobject_id      ,
  id                  :=NEW.id                 ,
  parent_genattrib_id :=NEW.parent_genattrib_id,
  root_genattrib_id   :=NEW.root_genattrib_id  ,
--	
  schema_name         :=p_schema_name
);
--RAISE NOTICE 'Inserted record with id: %', inserted_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.tr_ins_cityobject_genericattrib_surfgeom (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_CITYOBJECT_GENERICATTRIB_surfgeom
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.tr_upd_cityobject_genericattrib_surfgeom() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.tr_upd_cityobject_genericattrib_surfgeom()
  RETURNS trigger AS
$BODY$
DECLARE
  p_schema_name varchar DEFAULT 'citydb'::varchar;
  updated_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
EXECUTE format('UPDATE %I.cityobject_genericattrib AS t SET
 attrname           =%L,
 surface_geometry_id=%L,
 cityobject_id      =%L,
 parent_genattrib_id=%L,
 root_genattrib_id  =%L
WHERE t.id=%L RETURNING id',
 p_schema_name,
 NEW.attrname           ,
 NEW.surface_geometry_id,
 NEW.cityobject_id      ,
 NEW.parent_genattrib_id,
 NEW.root_genattrib_id  ,
 OLD.id
) INTO updated_id;
-- RAISE NOTICE 'Updated record with id: %',updated_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.tr_upd_cityobject_genericattrib_surfgeom (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view CITYOBJECT_GENERICATTRIB_surfgeom
----------------------------------------------------------------
DROP TRIGGER IF EXISTS tr_del_cityobject_genericattrib_surfgeom ON citydb_view.cityobject_genericattrib_surfgeom;
CREATE TRIGGER tr_del_cityobject_genericattrib_surfgeom
	INSTEAD OF DELETE ON citydb_view.cityobject_genericattrib_surfgeom
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.tr_del_cityobject_genericattrib_surfgeom ('citydb');

DROP TRIGGER IF EXISTS tr_ins_cityobject_genericattrib_surfgeom ON citydb_view.cityobject_genericattrib_surfgeom;
CREATE TRIGGER tr_ins_cityobject_genericattrib_surfgeom
	INSTEAD OF INSERT ON citydb_view.cityobject_genericattrib_surfgeom
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.tr_ins_cityobject_genericattrib_surfgeom ('citydb');

DROP TRIGGER IF EXISTS tr_upd_cityobject_genericattrib_surfgeom ON citydb_view.cityobject_genericattrib_surfgeom;
CREATE TRIGGER tr_upd_cityobject_genericattrib_surfgeom
	INSTEAD OF UPDATE ON citydb_view.cityobject_genericattrib_surfgeom
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.tr_upd_cityobject_genericattrib_surfgeom ('citydb');
--**************************************************************
--**************************************************************

----------------------------------------------------------------
-- Function TR_DEL_CITYOBJECT_GENERICATTRIB_group
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.tr_del_cityobject_genericattrib_group() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.tr_del_cityobject_genericattrib_group()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
deleted_id=citydb_pkg.delete_genericattrib(OLD.id, 0, p_schema_name);
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.tr_del_cityobject_genericattrib_group (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_CITYOBJECT_GENERICATTRIB_group
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.tr_ins_cityobject_genericattrib_group() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.tr_ins_cityobject_genericattrib_group()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	inserted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
inserted_id=citydb_view.insert_cityobject_genericattrib_group(
  attrname              :=NEW.attrname           ,
  cityobject_id         :=NEW.cityobject_id      ,
  genattribset_codespace:=NEW.genattribset_codespace,
  id                    :=NEW.id                 ,
  parent_genattrib_id   :=NEW.parent_genattrib_id,
  root_genattrib_id     :=NEW.root_genattrib_id  ,
--	
  schema_name         :=p_schema_name
);
--RAISE NOTICE 'Inserted record with id: %', inserted_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.tr_ins_cityobject_genericattrib_group (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_CITYOBJECT_GENERICATTRIB_group
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.tr_upd_cityobject_genericattrib_group() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.tr_upd_cityobject_genericattrib_group()
  RETURNS trigger AS
$BODY$
DECLARE
  p_schema_name varchar DEFAULT 'citydb'::varchar;
  updated_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
EXECUTE format('UPDATE %I.cityobject_genericattrib AS t SET
 attrname               =%L,
 cityobject_id          =%L,
 genattribset_codespace =%L, 
 parent_genattrib_id    =%L,
 root_genattrib_id      =%L
WHERE t.id=%L RETURNING id',
 p_schema_name,
 NEW.attrname              ,
 NEW.cityobject_id         ,
 NEW.genattribset_codespace,
 NEW.parent_genattrib_id   ,
 NEW.root_genattrib_id     ,
 OLD.id
) INTO updated_id;
-- RAISE NOTICE 'Updated record with id: %',updated_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.tr_upd_cityobject_genericattrib_group (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view CITYOBJECT_GENERICATTRIB_group
----------------------------------------------------------------
DROP TRIGGER IF EXISTS tr_del_cityobject_genericattrib_group ON citydb_view.cityobject_genericattrib_group;
CREATE TRIGGER tr_del_cityobject_genericattrib_group
	INSTEAD OF DELETE ON citydb_view.cityobject_genericattrib_group
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.tr_del_cityobject_genericattrib_group ('citydb');

DROP TRIGGER IF EXISTS tr_ins_cityobject_genericattrib_group ON citydb_view.cityobject_genericattrib_group;
CREATE TRIGGER tr_ins_cityobject_genericattrib_group
	INSTEAD OF INSERT ON citydb_view.cityobject_genericattrib_group
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.tr_ins_cityobject_genericattrib_group ('citydb');

DROP TRIGGER IF EXISTS tr_upd_cityobject_genericattrib_group ON citydb_view.cityobject_genericattrib_group;
CREATE TRIGGER tr_upd_cityobject_genericattrib_group
	INSTEAD OF UPDATE ON citydb_view.cityobject_genericattrib_group
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.tr_upd_cityobject_genericattrib_group ('citydb');
--**************************************************************
--**************************************************************

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


















