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
-- *************** 08_UtilityNetworks_ADE_VIEW_TRIGGERS.sql **************
--
-- This script adds triggers and trigger functions to schema citydb_view
-- in order to make some views updatable. They are all prefixed with
-- "utn9_".
--
-- ***********************************************************************
-- ***********************************************************************


----------------------------------------------------------------
-- Function TR_DEL_UTN_BUILDING
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.utn9_tr_del_building() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_del_building()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
deleted_id=citydb_pkg.delete_building(OLD.id, 0, p_schema_name);
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_del_building (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_UTN_BUILDING
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.utn9_tr_ins_building() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_ins_building()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	inserted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
inserted_id=citydb_view.utn9_insert_building(
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
--
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
--
nbr_occupants              :=NEW.nbr_occupants,
--
schema_name                  :=p_schema_name
);
--RAISE NOTICE 'Inserted record with id: %', inserted_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_ins_building (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_UTN_BUILDING
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.utn9_tr_upd_building() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_upd_building()
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
EXECUTE format('UPDATE %I.utn9_building AS t SET
nbr_occupants     =%L
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.nbr_occupants,
OLD.id
) INTO updated_id;
-- RAISE NOTICE 'Updated record with id: %',updated_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_upd_building (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view UTN9_BUILDING
----------------------------------------------------------------
DROP TRIGGER IF EXISTS utn9_tr_del_building ON citydb_view.utn9_building;
CREATE TRIGGER utn9_tr_del_building
	INSTEAD OF DELETE ON citydb_view.utn9_building
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_del_building ('citydb');

DROP TRIGGER IF EXISTS utn9_tr_ins_building ON citydb_view.utn9_building;
CREATE TRIGGER utn9_tr_ins_building
	INSTEAD OF INSERT ON citydb_view.utn9_building
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_ins_building ('citydb');

DROP TRIGGER IF EXISTS utn9_tr_upd_building ON citydb_view.utn9_building;
CREATE TRIGGER utn9_tr_upd_building
	INSTEAD OF UPDATE ON citydb_view.utn9_building
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_upd_building ('citydb');
--**************************************************************
--**************************************************************

----------------------------------------------------------------
-- Function TR_DEL_UTN_BUILDING_PART
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.utn9_tr_del_building_part() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_del_building_part()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
deleted_id=citydb_pkg.delete_building(OLD.id, 0, p_schema_name);
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_del_building_part (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_UTN_BUILDING_PART
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.utn9_tr_ins_building_part() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_ins_building_part()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	inserted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
inserted_id=citydb_view.utn9_insert_building_part(
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
--
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
--
nbr_occupants              :=NEW.nbr_occupants,
--
schema_name                  :=p_schema_name
);
--RAISE NOTICE 'Inserted record with id: %', inserted_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_ins_building_part (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_UTN_BUILDING_PART
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.utn9_tr_upd_building_part() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_upd_building_part()
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
EXECUTE format('UPDATE %I.utn9_building AS t SET
nbr_occupants     =%L
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.nbr_occupants,
OLD.id
) INTO updated_id;
-- RAISE NOTICE 'Updated record with id: %',updated_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_upd_building_part (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view UTN9_BUILDING_PART
----------------------------------------------------------------
DROP TRIGGER IF EXISTS utn9_tr_del_building_part ON citydb_view.utn9_building_part;
CREATE TRIGGER utn9_tr_del_building_part
	INSTEAD OF DELETE ON citydb_view.utn9_building_part
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_del_building_part ('citydb');

DROP TRIGGER IF EXISTS utn9_tr_ins_building_part ON citydb_view.utn9_building_part;
CREATE TRIGGER utn9_tr_ins_building_part
	INSTEAD OF INSERT ON citydb_view.utn9_building_part
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_ins_building_part ('citydb');

DROP TRIGGER IF EXISTS utn9_tr_upd_building_part ON citydb_view.utn9_building_part;
CREATE TRIGGER utn9_tr_upd_building_part
	INSTEAD OF UPDATE ON citydb_view.utn9_building_part
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_upd_building_part ('citydb');
--**************************************************************
--**************************************************************

----------------------------------------------------------------
-- Function TR_DEL_COMMODITY_CLASSIFIER_CHEMICAL
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.utn9_tr_del_commodity_classifier_chemical() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_del_commodity_classifier_chemical()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
deleted_id=citydb_pkg.utn9_delete_commodity_classifier(OLD.id, p_schema_name);
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_del_commodity_classifier_chemical (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_COMMODITY_CLASSIFIER_CHEMICAL
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.utn9_tr_ins_commodity_classifier_chemical() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_ins_commodity_classifier_chemical()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	inserted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
inserted_id=citydb_view.utn9_insert_commodity_classifier_chemical(
id                      :=NEW.id                      ,
gmlid                   :=NEW.gmlid                   ,
gmlid_codespace         :=NEW.gmlid_codespace         ,
name                    :=NEW.name                    ,
name_codespace          :=NEW.name_codespace          ,
description             :=NEW.description             ,
mol_formula             :=NEW.mol_formula             ,
mol_weight              :=NEW.mol_weight              ,
mol_weight_unit         :=NEW.mol_weight_unit         ,
physical_form           :=NEW.physical_form           ,
signal_word             :=NEW.signal_word             ,
is_chemical_complex     :=NEW.is_chemical_complex     ,
haz_class               :=NEW.haz_class               ,
haz_class_category_code :=NEW.haz_class_category_code ,
haz_class_statement_code:=NEW.haz_class_statement_code,
haz_class_pictogram_code:=NEW.haz_class_pictogram_code,
haz_class_pictogram_uri :=NEW.haz_class_pictogram_uri ,
ec_number               :=NEW.ec_number               ,
cas_number              :=NEW.cas_number              ,
iuclid_chem_datasheet   :=NEW.iuclid_chem_datasheet   ,
commodity_id            :=NEW.commodity_id            ,
material_id             :=NEW.material_id             ,
hollow_space_id         :=NEW.hollow_space_id         ,
--
schema_name          :=p_schema_name
);
--RAISE NOTICE 'Inserted record with id: %', inserted_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_ins_commodity_classifier_chemical (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_COMMODITY_CLASSIFIER_CHEMICAL
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.utn9_tr_upd_commodity_classifier_chemical() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_upd_commodity_classifier_chemical()
  RETURNS trigger AS
$BODY$
DECLARE
  p_schema_name varchar DEFAULT 'citydb'::varchar;
  updated_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
EXECUTE format('UPDATE %I.utn9_commodity_classifier AS t SET
gmlid                   =%L,
gmlid_codespace         =%L,
name                    =%L,
name_codespace          =%L,
description             =%L,
mol_formula             =%L,
mol_weight              =%L,
mol_weight_unit         =%L,
physical_form           =%L,
signal_word             =%L,
is_chemical_complex     =%L,
haz_class               =%L,
haz_class_category_code =%L,
haz_class_statement_code=%L,
haz_class_pictogram_code=%L,
haz_class_pictogram_uri =%L,
ec_number               =%L,
cas_number              =%L,
iuclid_chem_datasheet   =%L,
commodity_id            =%L,
material_id             =%L,
hollow_space_id         =%L
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.gmlid                   ,
NEW.gmlid_codespace         ,
NEW.name                    ,
NEW.name_codespace          ,
NEW.description             ,
NEW.mol_formula             ,
NEW.mol_weight              ,
NEW.mol_weight_unit         ,
NEW.physical_form           ,
NEW.signal_word             ,
NEW.is_chemical_complex     ,
NEW.haz_class               ,
NEW.haz_class_category_code ,
NEW.haz_class_statement_code,
NEW.haz_class_pictogram_code,
NEW.haz_class_pictogram_uri ,
NEW.ec_number               ,
NEW.cas_number              ,
NEW.iuclid_chem_datasheet   ,
NEW.commodity_id            ,
NEW.material_id             ,
NEW.hollow_space_id         ,
OLD.id
) INTO updated_id;
-- RAISE NOTICE 'Updated record with id: %', updated_id;
RETURN NEW;
EXCEPTION
  WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_upd_commodity_classifier_chemical (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view UTN_COMMODITY_CLASSIFIER_CHEMICAL
----------------------------------------------------------------
DROP TRIGGER IF EXISTS utn9_tr_del_commodity_classifier_chemical ON citydb_view.utn9_commodity_classifier_chemical;
CREATE TRIGGER utn9_tr_del_commodity_classifier_chemical
	INSTEAD OF DELETE ON citydb_view.utn9_commodity_classifier_chemical
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_del_commodity_classifier_chemical ('citydb');

DROP TRIGGER IF EXISTS utn9_tr_ins_commodity_classifier_chemical ON citydb_view.utn9_commodity_classifier_chemical;
CREATE TRIGGER utn9_tr_ins_commodity_classifier_chemical
	INSTEAD OF INSERT ON citydb_view.utn9_commodity_classifier_chemical
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_ins_commodity_classifier_chemical ('citydb');

DROP TRIGGER IF EXISTS utn9_tr_upd_commodity_classifier_chemical ON citydb_view.utn9_commodity_classifier_chemical;
CREATE TRIGGER utn9_tr_upd_commodity_classifier_chemical
	INSTEAD OF UPDATE ON citydb_view.utn9_commodity_classifier_chemical
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_upd_commodity_classifier_chemical ('citydb');
--**************************************************************
--**************************************************************

----------------------------------------------------------------
-- Function TR_DEL_COMMODITY_CLASSIFIER_GHS
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_del_commodity_classifier_ghs() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_del_commodity_classifier_ghs()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
deleted_id=citydb_pkg.utn9_delete_commodity_classifier(OLD.id, p_schema_name);
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_del_commodity_classifier_ghs (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_COMMODITY_CLASSIFIER_GHS
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_ins_commodity_classifier_ghs() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_ins_commodity_classifier_ghs()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	inserted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
inserted_id=citydb_view.utn9_insert_commodity_classifier_ghs(
id                      :=NEW.id                      ,
gmlid                   :=NEW.gmlid                   ,
gmlid_codespace         :=NEW.gmlid_codespace         ,
name                    :=NEW.name                    ,
name_codespace          :=NEW.name_codespace          ,
description             :=NEW.description             ,
mol_formula             :=NEW.mol_formula             ,
mol_weight              :=NEW.mol_weight              ,
mol_weight_unit         :=NEW.mol_weight_unit         ,
physical_form           :=NEW.physical_form           ,
signal_word             :=NEW.signal_word             ,
is_chemical_complex     :=NEW.is_chemical_complex     ,
haz_class               :=NEW.haz_class               ,
haz_class_category_code :=NEW.haz_class_category_code ,
haz_class_statement_code:=NEW.haz_class_statement_code,
haz_class_pictogram_code:=NEW.haz_class_pictogram_code,
haz_class_pictogram_uri :=NEW.haz_class_pictogram_uri ,
ec_number               :=NEW.ec_number               ,
cas_number              :=NEW.cas_number              ,
--iuclid_chem_datasheet   :=NEW.iuclid_chem_datasheet   ,
commodity_id            :=NEW.commodity_id            ,
material_id             :=NEW.material_id             ,
hollow_space_id         :=NEW.hollow_space_id         ,
--
schema_name          :=p_schema_name
);
--RAISE NOTICE 'Inserted record with id: %', inserted_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_ins_commodity_classifier_ghs (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_COMMODITY_CLASSIFIER_GHS
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_upd_commodity_classifier_ghs() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_upd_commodity_classifier_ghs()
  RETURNS trigger AS
$BODY$
DECLARE
  p_schema_name varchar DEFAULT 'citydb'::varchar;
  updated_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
EXECUTE format('UPDATE %I.utn9_commodity_classifier AS t SET
gmlid                   =%L,
gmlid_codespace         =%L,
name                    =%L,
name_codespace          =%L,
description             =%L,
mol_formula             =%L,
mol_weight              =%L,
mol_weight_unit         =%L,
physical_form           =%L,
signal_word             =%L,
is_chemical_complex     =%L,
haz_class               =%L,
haz_class_category_code =%L,
haz_class_statement_code=%L,
haz_class_pictogram_code=%L,
haz_class_pictogram_uri =%L,
ec_number               =%L,
cas_number              =%L,

commodity_id            =%L,
material_id             =%L,
hollow_space_id         =%L
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.gmlid                   ,
NEW.gmlid_codespace         ,
NEW.name                    ,
NEW.name_codespace          ,
NEW.description             ,
NEW.mol_formula             ,
NEW.mol_weight              ,
NEW.mol_weight_unit         ,
NEW.physical_form           ,
NEW.signal_word             ,
NEW.is_chemical_complex     ,
NEW.haz_class               ,
NEW.haz_class_category_code ,
NEW.haz_class_statement_code,
NEW.haz_class_pictogram_code,
NEW.haz_class_pictogram_uri ,
NEW.ec_number               ,
NEW.cas_number              ,
--NEW.iuclid_chem_datasheet   ,
NEW.commodity_id            ,
NEW.material_id             ,
NEW.hollow_space_id         ,
OLD.id
) INTO updated_id;
-- RAISE NOTICE 'Updated record with id: %', updated_id;
RETURN NEW;
EXCEPTION
  WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_upd_commodity_classifier_ghs (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view UTN_COMMODITY_CLASSIFIER_GSH
----------------------------------------------------------------
DROP TRIGGER IF EXISTS utn9_tr_del_commodity_classifier_ghs ON citydb_view.utn9_commodity_classifier_ghs;
CREATE TRIGGER utn9_tr_del_commodity_classifier_ghs
	INSTEAD OF DELETE ON citydb_view.utn9_commodity_classifier_ghs
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_del_commodity_classifier_ghs ('citydb');

DROP TRIGGER IF EXISTS utn9_tr_ins_commodity_classifier_ghs ON citydb_view.utn9_commodity_classifier_ghs;
CREATE TRIGGER utn9_tr_ins_commodity_classifier_ghs
	INSTEAD OF INSERT ON citydb_view.utn9_commodity_classifier_ghs
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_ins_commodity_classifier_ghs ('citydb');

DROP TRIGGER IF EXISTS utn9_tr_upd_commodity_classifier_ghs ON citydb_view.utn9_commodity_classifier_ghs;
CREATE TRIGGER utn9_tr_upd_commodity_classifier_ghs
	INSTEAD OF UPDATE ON citydb_view.utn9_commodity_classifier_ghs
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_upd_commodity_classifier_ghs ('citydb');
--**************************************************************
--**************************************************************

----------------------------------------------------------------
-- Function TR_DEL_COMMODITY_CLASSIFIER_GENERIC
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_del_commodity_classifier_generic() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_del_commodity_classifier_generic()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
deleted_id=citydb_pkg.utn9_delete_commodity_classifier(OLD.id, p_schema_name);
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_del_commodity_classifier_generic (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

--------------------------------------------------------------
-- Function TR_INS_COMMODITY_CLASSIFIER_GENERIC
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_ins_commodity_classifier_generic() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_ins_commodity_classifier_generic()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	inserted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
inserted_id=citydb_view.utn9_insert_commodity_classifier_generic(
id                      :=NEW.id                      ,
gmlid                   :=NEW.gmlid                   ,
gmlid_codespace         :=NEW.gmlid_codespace         ,
name                    :=NEW.name                    ,
name_codespace          :=NEW.name_codespace          ,
description             :=NEW.description             ,
mol_formula             :=NEW.mol_formula             ,
mol_weight              :=NEW.mol_weight              ,
mol_weight_unit         :=NEW.mol_weight_unit         ,
physical_form           :=NEW.physical_form           ,
signal_word             :=NEW.signal_word             ,
is_chemical_complex     :=NEW.is_chemical_complex     ,
haz_class               :=NEW.haz_class               ,
haz_class_category_code :=NEW.haz_class_category_code ,
haz_class_statement_code:=NEW.haz_class_statement_code,
haz_class_pictogram_code:=NEW.haz_class_pictogram_code,
haz_class_pictogram_uri :=NEW.haz_class_pictogram_uri ,
--ec_number               :=NEW.ec_number               ,
--cas_number              :=NEW.cas_number              ,
--iuclid_chem_datasheet   :=NEW.iuclid_chem_datasheet   ,
commodity_id            :=NEW.commodity_id            ,
material_id             :=NEW.material_id             ,
hollow_space_id         :=NEW.hollow_space_id         ,
--
schema_name          :=p_schema_name
);
--RAISE NOTICE 'Inserted record with id: %', inserted_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_ins_commodity_classifier_generic (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_COMMODITY_CLASSIFIER_GENERIC
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_upd_commodity_classifier_generic() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_upd_commodity_classifier_generic()
  RETURNS trigger AS
$BODY$
DECLARE
  p_schema_name varchar DEFAULT 'citydb'::varchar;
  updated_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
EXECUTE format('UPDATE %I.utn9_commodity_classifier AS t SET
gmlid                   =%L,
gmlid_codespace         =%L,
name                    =%L,
name_codespace          =%L,
description             =%L,
mol_formula             =%L,
mol_weight              =%L,
mol_weight_unit         =%L,
physical_form           =%L,
signal_word             =%L,
is_chemical_complex     =%L,
haz_class               =%L,
haz_class_category_code =%L,
haz_class_statement_code=%L,
haz_class_pictogram_code=%L,
haz_class_pictogram_uri =%L,

commodity_id            =%L,
material_id             =%L,
hollow_space_id         =%L
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.gmlid                   ,
NEW.gmlid_codespace         ,
NEW.name                    ,
NEW.name_codespace          ,
NEW.description             ,
NEW.mol_formula             ,
NEW.mol_weight              ,
NEW.mol_weight_unit         ,
NEW.physical_form           ,
NEW.signal_word             ,
NEW.is_chemical_complex     ,
NEW.haz_class               ,
NEW.haz_class_category_code ,
NEW.haz_class_statement_code,
NEW.haz_class_pictogram_code,
NEW.haz_class_pictogram_uri ,
--NEW.ec_number               ,
--NEW.cas_number              ,
--NEW.iuclid_chem_datasheet   ,
NEW.commodity_id            ,
NEW.material_id             ,
NEW.hollow_space_id         ,
OLD.id
) INTO updated_id;
-- RAISE NOTICE 'Updated record with id: %', updated_id;
RETURN NEW;
EXCEPTION
  WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_upd_commodity_classifier_generic (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view UTN_COMMODITY_CLASSIFIER_GENERIC
----------------------------------------------------------------
DROP TRIGGER IF EXISTS utn9_tr_del_commodity_classifier_generic ON citydb_view.utn9_commodity_classifier_generic;
CREATE TRIGGER utn9_tr_del_commodity_classifier_generic
	INSTEAD OF DELETE ON citydb_view.utn9_commodity_classifier_generic
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_del_commodity_classifier_generic ('citydb');

DROP TRIGGER IF EXISTS utn9_tr_ins_commodity_classifier_generic ON citydb_view.utn9_commodity_classifier_generic;
CREATE TRIGGER utn9_tr_ins_commodity_classifier_generic
	INSTEAD OF INSERT ON citydb_view.utn9_commodity_classifier_generic
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_ins_commodity_classifier_generic ('citydb');

DROP TRIGGER IF EXISTS utn9_tr_upd_commodity_classifier_generic ON citydb_view.utn9_commodity_classifier_generic;
CREATE TRIGGER utn9_tr_upd_commodity_classifier_generic
	INSTEAD OF UPDATE ON citydb_view.utn9_commodity_classifier_generic
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_upd_commodity_classifier_generic ('citydb');
--**************************************************************
--**************************************************************

----------------------------------------------------------------
-- Function TR_DEL_COMMODITY_ELECTRICAL_MEDIUM
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_del_commodity_electrical_medium() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_del_commodity_electrical_medium()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
deleted_id=citydb_pkg.utn9_delete_commodity(OLD.id, p_schema_name);
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_del_commodity_electrical_medium (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_COMMODITY_ELECTRICAL_MEDIUM
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_ins_commodity_electrical_medium() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_ins_commodity_electrical_medium()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	inserted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
inserted_id=citydb_view.utn9_insert_commodity_electrical_medium(
id                           :=NEW.id                          ,
gmlid                        :=NEW.gmlid                       ,
gmlid_codespace              :=NEW.gmlid_codespace             ,
name                         :=NEW.name                        ,
name_codespace               :=NEW.name_codespace              ,
description                  :=NEW.description                 ,
owner                        :=NEW.owner                       ,
type                         :=NEW.type                        ,
--is_corrosive                 :=NEW.is_corrosive                ,
--is_explosive                 :=NEW.is_explosive                ,
--is_lighter_than_air          :=NEW.is_lighter_than_air         ,
--flammability_ratio           :=NEW.flammability_ratio          ,
--elec_conductivity_range_from :=NEW.elec_conductivity_range_from,
--elec_conductivity_range_to   :=NEW.elec_conductivity_range_to  ,
--elec_conductivity_range_unit :=NEW.elec_conductivity_range_unit,
--concentration                :=NEW.concentration               ,
--concentration_unit           :=NEW.concentration_unit          ,
--ph_value_range_from          :=NEW.ph_value_range_from         ,
--ph_value_range_to            :=NEW.ph_value_range_to           ,
--ph_value_range_unit          :=NEW.ph_value_range_unit         ,
--temperature_range_from       :=NEW.temperature_range_from      ,
--temperature_range_to         :=NEW.temperature_range_to        ,
--temperature_range_unit       :=NEW.temperature_range_unit      ,
--flow_rate_range_from         :=NEW.flow_rate_range_from        ,
--flow_rate_range_to           :=NEW.flow_rate_range_to          ,
--flow_rate_range_unit         :=NEW.flow_rate_range_unit        ,
--pressure_range_from          :=NEW.pressure_range_from         ,
--pressure_range_to            :=NEW.pressure_range_to           ,
--pressure_range_unit          :=NEW.pressure_range_unit         ,
voltage_range_from           :=NEW.voltage_range_from          ,
voltage_range_to             :=NEW.voltage_range_to            ,
voltage_range_unit           :=NEW.voltage_range_unit          ,
amperage_range_from          :=NEW.amperage_range_from         ,
amperage_range_to            :=NEW.amperage_range_to           ,
amperage_range_unit          :=NEW.amperage_range_unit         ,
bandwidth_range_from         :=NEW.bandwidth_range_from        ,
bandwidth_range_to           :=NEW.bandwidth_range_to          ,
bandwidth_range_unit         :=NEW.bandwidth_range_unit        ,
--optical_mode                 :=NEW.optical_mode                ,
--
schema_name          :=p_schema_name
);
--RAISE NOTICE 'Inserted record with id: %', inserted_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_ins_commodity_electrical_medium (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_COMMODITY_ELECTRICAL_MEDIUM
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_upd_commodity_electrical_medium() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_upd_commodity_electrical_medium()
  RETURNS trigger AS
$BODY$
DECLARE
  p_schema_name varchar DEFAULT 'citydb'::varchar;
  updated_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
EXECUTE format('UPDATE %I.utn9_commodity AS t SET
gmlid                        =%L,
gmlid_codespace              =%L,
name                         =%L,
name_codespace               =%L,
description                  =%L,
owner                        =%L,
type                         =%L,'||/*
is_corrosive                 =%L,
is_explosive                 =%L,
is_lighter_than_air          =%L,
flammability_ratio           =%L,
elec_conductivity_range_from =%L,
elec_conductivity_range_to   =%L,
elec_conductivity_range_unit =%L,
concentration                =%L,
concentration_unit           =%L,
ph_value_range_from          =%L,
ph_value_range_to            =%L,
ph_value_range_unit          =%L,
temperature_range_from       =%L,
temperature_range_to         =%L,
temperature_range_unit       =%L,
flow_rate_range_from         =%L,
flow_rate_range_to           =%L,
flow_rate_range_unit         =%L,
pressure_range_from          =%L,
pressure_range_to            =%L,
pressure_range_unit          =%L,*/'
voltage_range_from           =%L,
voltage_range_to             =%L,
voltage_range_unit           =%L,
amperage_range_from          =%L,
amperage_range_to            =%L,
amperage_range_unit          =%L,
bandwidth_range_from         =%L,
bandwidth_range_to           =%L,
bandwidth_range_unit         =%L'||/*,
optical_mode                 =%L*/'
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.gmlid                       ,
NEW.gmlid_codespace             ,
NEW.name                        ,
NEW.name_codespace              ,
NEW.description                 ,
NEW.owner                       ,
NEW.type                        ,
--NEW.is_corrosive                ,
--NEW.is_explosive                ,
--NEW.is_lighter_than_air         ,
--NEW.flammability_ratio          ,
--NEW.elec_conductivity_range_from,
--NEW.elec_conductivity_range_to  ,
--NEW.elec_conductivity_range_unit,
--NEW.concentration               ,
--NEW.concentration_unit          ,
--NEW.ph_value_range_from         ,
--NEW.ph_value_range_to           ,
--NEW.ph_value_range_unit         ,
--NEW.temperature_range_from      ,
--NEW.temperature_range_to        ,
--NEW.temperature_range_unit      ,
--NEW.flow_rate_range_from        ,
--NEW.flow_rate_range_to          ,
--NEW.flow_rate_range_unit        ,
--NEW.pressure_range_from         ,
--NEW.pressure_range_to           ,
--NEW.pressure_range_unit         ,
NEW.voltage_range_from          ,
NEW.voltage_range_to            ,
NEW.voltage_range_unit          ,
NEW.amperage_range_from         ,
NEW.amperage_range_to           ,
NEW.amperage_range_unit         ,
NEW.bandwidth_range_from        ,
NEW.bandwidth_range_to          ,
NEW.bandwidth_range_unit        ,
--NEW.optical_mode                ,
OLD.id
) INTO updated_id;
-- RAISE NOTICE 'Updated record with id: %', updated_id;
RETURN NEW;
EXCEPTION
  WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_upd_commodity_electrical_medium (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view UTN_COMMODITY_ELECTRICAL_MEDIUM
----------------------------------------------------------------
DROP TRIGGER IF EXISTS utn9_tr_del_commodity_electrical_medium ON citydb_view.utn9_commodity_electrical_medium;
CREATE TRIGGER utn9_tr_del_commodity_electrical_medium
	INSTEAD OF DELETE ON citydb_view.utn9_commodity_electrical_medium
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_del_commodity_electrical_medium ('citydb');

DROP TRIGGER IF EXISTS utn9_tr_ins_commodity_electrical_medium ON citydb_view.utn9_commodity_electrical_medium;
CREATE TRIGGER utn9_tr_ins_commodity_electrical_medium
	INSTEAD OF INSERT ON citydb_view.utn9_commodity_electrical_medium
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_ins_commodity_electrical_medium ('citydb');

DROP TRIGGER IF EXISTS utn9_tr_upd_commodity_electrical_medium ON citydb_view.utn9_commodity_electrical_medium;
CREATE TRIGGER utn9_tr_upd_commodity_electrical_medium
	INSTEAD OF UPDATE ON citydb_view.utn9_commodity_electrical_medium
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_upd_commodity_electrical_medium ('citydb');
--**************************************************************
--**************************************************************

----------------------------------------------------------------
-- Function TR_DEL_COMMODITY_GASEOUS_MEDIUM
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_del_commodity_gaseous_medium() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_del_commodity_gaseous_medium()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
deleted_id=citydb_pkg.utn9_delete_commodity(OLD.id, p_schema_name);
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_del_commodity_gaseous_medium (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_COMMODITY_GASEOUS_MEDIUM
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_ins_commodity_gaseous_medium() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_ins_commodity_gaseous_medium()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	inserted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
inserted_id=citydb_view.utn9_insert_commodity_gaseous_medium(
id                           :=NEW.id                          ,
gmlid                        :=NEW.gmlid                       ,
gmlid_codespace              :=NEW.gmlid_codespace             ,
name                         :=NEW.name                        ,
name_codespace               :=NEW.name_codespace              ,
description                  :=NEW.description                 ,
owner                        :=NEW.owner                       ,
type                         :=NEW.type                        ,
--is_corrosive                 :=NEW.is_corrosive                ,
is_explosive                 :=NEW.is_explosive                ,
is_lighter_than_air          :=NEW.is_lighter_than_air         ,
--flammability_ratio           :=NEW.flammability_ratio          ,
elec_conductivity_range_from :=NEW.elec_conductivity_range_from,
elec_conductivity_range_to   :=NEW.elec_conductivity_range_to  ,
elec_conductivity_range_unit :=NEW.elec_conductivity_range_unit,
concentration                :=NEW.concentration               ,
concentration_unit           :=NEW.concentration_unit          ,
--ph_value_range_from          :=NEW.ph_value_range_from         ,
--ph_value_range_to            :=NEW.ph_value_range_to           ,
--ph_value_range_unit          :=NEW.ph_value_range_unit         ,
--temperature_range_from       :=NEW.temperature_range_from      ,
--temperature_range_to         :=NEW.temperature_range_to        ,
--temperature_range_unit       :=NEW.temperature_range_unit      ,
--flow_rate_range_from         :=NEW.flow_rate_range_from        ,
--flow_rate_range_to           :=NEW.flow_rate_range_to          ,
--flow_rate_range_unit         :=NEW.flow_rate_range_unit        ,
pressure_range_from          :=NEW.pressure_range_from         ,
pressure_range_to            :=NEW.pressure_range_to           ,
pressure_range_unit          :=NEW.pressure_range_unit         ,
--voltage_range_from           :=NEW.voltage_range_from          ,
--voltage_range_to             :=NEW.voltage_range_to            ,
--voltage_range_unit           :=NEW.voltage_range_unit          ,
--amperage_range_from          :=NEW.amperage_range_from         ,
--amperage_range_to            :=NEW.amperage_range_to           ,
--amperage_range_unit          :=NEW.amperage_range_unit         ,
--bandwidth_range_from         :=NEW.bandwidth_range_from        ,
--bandwidth_range_to           :=NEW.bandwidth_range_to          ,
--bandwidth_range_unit         :=NEW.bandwidth_range_unit        ,
--optical_mode                 :=NEW.optical_mode                ,
--
schema_name          :=p_schema_name
);
--RAISE NOTICE 'Inserted record with id: %', inserted_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_ins_commodity_gaseous_medium (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_COMMODITY_GASEOUS_MEDIUM
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_upd_commodity_gaseous_medium() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_upd_commodity_gaseous_medium()
  RETURNS trigger AS
$BODY$
DECLARE
  p_schema_name varchar DEFAULT 'citydb'::varchar;
  updated_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
EXECUTE format('UPDATE %I.utn9_commodity AS t SET
gmlid                        =%L,
gmlid_codespace              =%L,
name                         =%L,
name_codespace               =%L,
description                  =%L,
owner                        =%L,
type                         =%L,'||/*
is_corrosive                 =%L,*/'
is_explosive                 =%L,
is_lighter_than_air          =%L,'||/*
flammability_ratio           =%L,*/'
elec_conductivity_range_from =%L,
elec_conductivity_range_to   =%L,
elec_conductivity_range_unit =%L,
concentration                =%L,
concentration_unit           =%L,'||/*
ph_value_range_from          =%L,
ph_value_range_to            =%L,
ph_value_range_unit          =%L,
temperature_range_from       =%L,
temperature_range_to         =%L,
temperature_range_unit       =%L,
flow_rate_range_from         =%L,
flow_rate_range_to           =%L,
flow_rate_range_unit         =%L,*/'
pressure_range_from          =%L,
pressure_range_to            =%L,
pressure_range_unit          =%L,
voltage_range_from           =%L,
voltage_range_to             =%L,
voltage_range_unit           =%L,
amperage_range_from          =%L,
amperage_range_to            =%L,
amperage_range_unit          =%L,
bandwidth_range_from         =%L,
bandwidth_range_to           =%L,
bandwidth_range_unit         =%L'||/*,
optical_mode                 =%L*/'
WHERE t.id=%L RETURNING id',
p_schema_name,
  NEW.gmlid                       ,
  NEW.gmlid_codespace             ,
  NEW.name                        ,
  NEW.name_codespace              ,
  NEW.description                 ,
  NEW.owner                       ,
  NEW.type                        ,
--NEW.is_corrosive                ,
  NEW.is_explosive                ,
  NEW.is_lighter_than_air         ,
--NEW.flammability_ratio          ,
  NEW.elec_conductivity_range_from,
  NEW.elec_conductivity_range_to  ,
  NEW.elec_conductivity_range_unit,
  NEW.concentration               ,
  NEW.concentration_unit          ,
--NEW.ph_value_range_from         ,
--NEW.ph_value_range_to           ,
--NEW.ph_value_range_unit         ,
--NEW.temperature_range_from      ,
--NEW.temperature_range_to        ,
--NEW.temperature_range_unit      ,
--NEW.flow_rate_range_from        ,
--NEW.flow_rate_range_to          ,
--NEW.flow_rate_range_unit        ,
  NEW.pressure_range_from         ,
  NEW.pressure_range_to           ,
  NEW.pressure_range_unit         ,
--NEW.voltage_range_from          ,
--NEW.voltage_range_to            ,
--NEW.voltage_range_unit          ,
--NEW.amperage_range_from         ,
--NEW.amperage_range_to           ,
--NEW.amperage_range_unit         ,
--NEW.bandwidth_range_from        ,
--NEW.bandwidth_range_to          ,
--NEW.bandwidth_range_unit        ,
--NEW.optical_mode                ,
OLD.id
) INTO updated_id;
-- RAISE NOTICE 'Updated record with id: %', updated_id;
RETURN NEW;
EXCEPTION
  WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_upd_commodity_gaseous_medium (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view UTN_COMMODITY_GASEOUS_MEDIUM
----------------------------------------------------------------
DROP TRIGGER IF EXISTS utn9_tr_del_commodity_gaseous_medium ON citydb_view.utn9_commodity_gaseous_medium;
CREATE TRIGGER utn9_tr_del_commodity_gaseous_medium
	INSTEAD OF DELETE ON citydb_view.utn9_commodity_gaseous_medium
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_del_commodity_gaseous_medium ('citydb');

DROP TRIGGER IF EXISTS utn9_tr_ins_commodity_gaseous_medium ON citydb_view.utn9_commodity_gaseous_medium;
CREATE TRIGGER utn9_tr_ins_commodity_gaseous_medium
	INSTEAD OF INSERT ON citydb_view.utn9_commodity_gaseous_medium
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_ins_commodity_gaseous_medium ('citydb');

DROP TRIGGER IF EXISTS utn9_tr_upd_commodity_gaseous_medium ON citydb_view.utn9_commodity_gaseous_medium;
CREATE TRIGGER utn9_tr_upd_commodity_gaseous_medium
	INSTEAD OF UPDATE ON citydb_view.utn9_commodity_gaseous_medium
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_upd_commodity_gaseous_medium ('citydb');
--**************************************************************
--**************************************************************

----------------------------------------------------------------
-- Function TR_DEL_COMMODITY_LIQUID_MEDIUM
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_del_commodity_liquid_medium() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_del_commodity_liquid_medium()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
deleted_id=citydb_pkg.utn9_delete_commodity(OLD.id, p_schema_name);
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_del_commodity_liquid_medium (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_COMMODITY_LIQUID_MEDIUM
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_ins_commodity_liquid_medium() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_ins_commodity_liquid_medium()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	inserted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
inserted_id=citydb_view.utn9_insert_commodity_liquid_medium(
  id                           :=NEW.id                          ,
  gmlid                        :=NEW.gmlid                       ,
  gmlid_codespace              :=NEW.gmlid_codespace             ,
  name                         :=NEW.name                        ,
  name_codespace               :=NEW.name_codespace              ,
  description                  :=NEW.description                 ,
  owner                        :=NEW.owner                       ,
  type                         :=NEW.type                        ,
  is_corrosive                 :=NEW.is_corrosive                ,
  is_explosive                 :=NEW.is_explosive                ,
  is_lighter_than_air          :=NEW.is_lighter_than_air         ,
  flammability_ratio           :=NEW.flammability_ratio          ,
  elec_conductivity_range_from :=NEW.elec_conductivity_range_from,
  elec_conductivity_range_to   :=NEW.elec_conductivity_range_to  ,
  elec_conductivity_range_unit :=NEW.elec_conductivity_range_unit,
--concentration                :=NEW.concentration               ,
--concentration_unit           :=NEW.concentration_unit          ,
  ph_value_range_from          :=NEW.ph_value_range_from         ,
  ph_value_range_to            :=NEW.ph_value_range_to           ,
  ph_value_range_unit          :=NEW.ph_value_range_unit         ,
  temperature_range_from       :=NEW.temperature_range_from      ,
  temperature_range_to         :=NEW.temperature_range_to        ,
  temperature_range_unit       :=NEW.temperature_range_unit      ,
  flow_rate_range_from         :=NEW.flow_rate_range_from        ,
  flow_rate_range_to           :=NEW.flow_rate_range_to          ,
  flow_rate_range_unit         :=NEW.flow_rate_range_unit        ,
  pressure_range_from          :=NEW.pressure_range_from         ,
  pressure_range_to            :=NEW.pressure_range_to           ,
  pressure_range_unit          :=NEW.pressure_range_unit         ,
--voltage_range_from           :=NEW.voltage_range_from          ,
--voltage_range_to             :=NEW.voltage_range_to            ,
--voltage_range_unit           :=NEW.voltage_range_unit          ,
--amperage_range_from          :=NEW.amperage_range_from         ,
--amperage_range_to            :=NEW.amperage_range_to           ,
--amperage_range_unit          :=NEW.amperage_range_unit         ,
--bandwidth_range_from         :=NEW.bandwidth_range_from        ,
--bandwidth_range_to           :=NEW.bandwidth_range_to          ,
--bandwidth_range_unit         :=NEW.bandwidth_range_unit        ,
--optical_mode                 :=NEW.optical_mode                ,
--
schema_name          :=p_schema_name
);
--RAISE NOTICE 'Inserted record with id: %', inserted_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_ins_commodity_liquid_medium (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_COMMODITY_LIQUID_MEDIUM
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_upd_commodity_liquid_medium() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_upd_commodity_liquid_medium()
  RETURNS trigger AS
$BODY$
DECLARE
  p_schema_name varchar DEFAULT 'citydb'::varchar;
  updated_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
EXECUTE format('UPDATE %I.utn9_commodity AS t SET
gmlid                        =%L,
gmlid_codespace              =%L,
name                         =%L,
name_codespace               =%L,
description                  =%L,
owner                        =%L,
type                         =%L, 
is_corrosive                 =%L,
is_explosive                 =%L,
is_lighter_than_air          =%L, 
flammability_ratio           =%L,
elec_conductivity_range_from =%L,
elec_conductivity_range_to   =%L,
elec_conductivity_range_unit =%L,'||/* 
concentration                =%L,
concentration_unit           =%L,*/' 
ph_value_range_from          =%L,
ph_value_range_to            =%L,
ph_value_range_unit          =%L,
temperature_range_from       =%L,
temperature_range_to         =%L,
temperature_range_unit       =%L,
flow_rate_range_from         =%L,
flow_rate_range_to           =%L,
flow_rate_range_unit         =%L,
pressure_range_from          =%L,
pressure_range_to            =%L,
pressure_range_unit          =%L'||/* , 
voltage_range_from           =%L,
voltage_range_to             =%L,
voltage_range_unit           =%L,
amperage_range_from          =%L,
amperage_range_to            =%L,
amperage_range_unit          =%L,
bandwidth_range_from         =%L,
bandwidth_range_to           =%L,
bandwidth_range_unit         =%L,
optical_mode                 =%L*/'
WHERE t.id=%L RETURNING id',
p_schema_name,
  NEW.gmlid                       ,
  NEW.gmlid_codespace             ,
  NEW.name                        ,
  NEW.name_codespace              ,
  NEW.description                 ,
  NEW.owner                       ,
  NEW.type                        ,
  NEW.is_corrosive                ,
  NEW.is_explosive                ,
  NEW.is_lighter_than_air         ,
  NEW.flammability_ratio          ,
  NEW.elec_conductivity_range_from,
  NEW.elec_conductivity_range_to  ,
  NEW.elec_conductivity_range_unit,
--NEW.concentration               ,
--NEW.concentration_unit          ,
  NEW.ph_value_range_from         ,
  NEW.ph_value_range_to           ,
  NEW.ph_value_range_unit         ,
  NEW.temperature_range_from      ,
  NEW.temperature_range_to        ,
  NEW.temperature_range_unit      ,
  NEW.flow_rate_range_from        ,
  NEW.flow_rate_range_to          ,
  NEW.flow_rate_range_unit        ,
  NEW.pressure_range_from         ,
  NEW.pressure_range_to           ,
  NEW.pressure_range_unit         ,
--NEW.voltage_range_from          ,
--NEW.voltage_range_to            ,
--NEW.voltage_range_unit          ,
--NEW.amperage_range_from         ,
--NEW.amperage_range_to           ,
--NEW.amperage_range_unit         ,
--NEW.bandwidth_range_from        ,
--NEW.bandwidth_range_to          ,
--NEW.bandwidth_range_unit        ,
--NEW.optical_mode                ,
OLD.id
) INTO updated_id;
-- RAISE NOTICE 'Updated record with id: %', updated_id;
RETURN NEW;
EXCEPTION
  WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_upd_commodity_liquid_medium (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view UTN_COMMODITY_LIQUID_MEDIUM
----------------------------------------------------------------
DROP TRIGGER IF EXISTS utn9_tr_del_commodity_liquid_medium ON citydb_view.utn9_commodity_liquid_medium;
CREATE TRIGGER utn9_tr_del_commodity_liquid_medium
	INSTEAD OF DELETE ON citydb_view.utn9_commodity_liquid_medium
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_del_commodity_liquid_medium ('citydb');

DROP TRIGGER IF EXISTS utn9_tr_ins_commodity_liquid_medium ON citydb_view.utn9_commodity_liquid_medium;
CREATE TRIGGER utn9_tr_ins_commodity_liquid_medium
	INSTEAD OF INSERT ON citydb_view.utn9_commodity_liquid_medium
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_ins_commodity_liquid_medium ('citydb');

DROP TRIGGER IF EXISTS utn9_tr_upd_commodity_liquid_medium ON citydb_view.utn9_commodity_liquid_medium;
CREATE TRIGGER utn9_tr_upd_commodity_liquid_medium
	INSTEAD OF UPDATE ON citydb_view.utn9_commodity_liquid_medium
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_upd_commodity_liquid_medium ('citydb');
--**************************************************************
--**************************************************************

----------------------------------------------------------------
-- Function TR_DEL_COMMODITY_OPTICAL_MEDIUM
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_del_commodity_optical_medium() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_del_commodity_optical_medium()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
deleted_id=citydb_pkg.utn9_delete_commodity(OLD.id, p_schema_name);
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_del_commodity_optical_medium (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_COMMODITY_OPTICAL_MEDIUM
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_ins_commodity_optical_medium() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_ins_commodity_optical_medium()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	inserted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
inserted_id=citydb_view.utn9_insert_commodity_optical_medium(
  id                           :=NEW.id                          ,
  gmlid                        :=NEW.gmlid                       ,
  gmlid_codespace              :=NEW.gmlid_codespace             ,
  name                         :=NEW.name                        ,
  name_codespace               :=NEW.name_codespace              ,
  description                  :=NEW.description                 ,
  owner                        :=NEW.owner                       ,
  type                         :=NEW.type                        ,
--is_corrosive                 :=NEW.is_corrosive                ,
--is_explosive                 :=NEW.is_explosive                ,
--is_lighter_than_air          :=NEW.is_lighter_than_air         ,
--flammability_ratio           :=NEW.flammability_ratio          ,
--elec_conductivity_range_from :=NEW.elec_conductivity_range_from,
--elec_conductivity_range_to   :=NEW.elec_conductivity_range_to  ,
--elec_conductivity_range_unit :=NEW.elec_conductivity_range_unit,
--concentration                :=NEW.concentration               ,
--concentration_unit           :=NEW.concentration_unit          ,
--ph_value_range_from          :=NEW.ph_value_range_from         ,
--ph_value_range_to            :=NEW.ph_value_range_to           ,
--ph_value_range_unit          :=NEW.ph_value_range_unit         ,
--temperature_range_from       :=NEW.temperature_range_from      ,
--temperature_range_to         :=NEW.temperature_range_to        ,
--temperature_range_unit       :=NEW.temperature_range_unit      ,
--flow_rate_range_from         :=NEW.flow_rate_range_from        ,
--flow_rate_range_to           :=NEW.flow_rate_range_to          ,
--flow_rate_range_unit         :=NEW.flow_rate_range_unit        ,
--pressure_range_from          :=NEW.pressure_range_from         ,
--pressure_range_to            :=NEW.pressure_range_to           ,
--pressure_range_unit          :=NEW.pressure_range_unit         ,
--voltage_range_from           :=NEW.voltage_range_from          ,
--voltage_range_to             :=NEW.voltage_range_to            ,
--voltage_range_unit           :=NEW.voltage_range_unit          ,
--amperage_range_from          :=NEW.amperage_range_from         ,
--amperage_range_to            :=NEW.amperage_range_to           ,
--amperage_range_unit          :=NEW.amperage_range_unit         ,
  bandwidth_range_from         :=NEW.bandwidth_range_from        ,
  bandwidth_range_to           :=NEW.bandwidth_range_to          ,
  bandwidth_range_unit         :=NEW.bandwidth_range_unit        ,
  optical_mode                 :=NEW.optical_mode                ,
--
schema_name          :=p_schema_name
);
--RAISE NOTICE 'Inserted record with id: %', inserted_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_ins_commodity_optical_medium (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_COMMODITY_OPTICAL_MEDIUM
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_upd_commodity_optical_medium() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_upd_commodity_optical_medium()
  RETURNS trigger AS
$BODY$
DECLARE
  p_schema_name varchar DEFAULT 'citydb'::varchar;
  updated_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
EXECUTE format('UPDATE %I.utn9_commodity AS t SET
gmlid                        =%L,
gmlid_codespace              =%L,
name                         =%L,
name_codespace               =%L,
description                  =%L,
owner                        =%L,
type                         =%L,'||/* 
is_corrosive                 =%L,
is_explosive                 =%L,
is_lighter_than_air          =%L,
flammability_ratio           =%L,
elec_conductivity_range_from =%L,
elec_conductivity_range_to   =%L,
elec_conductivity_range_unit =%L,
concentration                =%L,
concentration_unit           =%L,
ph_value_range_from          =%L,
ph_value_range_to            =%L,
ph_value_range_unit          =%L,
temperature_range_from       =%L,
temperature_range_to         =%L,
temperature_range_unit       =%L,
flow_rate_range_from         =%L,
flow_rate_range_to           =%L,
flow_rate_range_unit         =%L,
pressure_range_from          =%L,
pressure_range_to            =%L,
pressure_range_unit          =%L,
voltage_range_from           =%L,
voltage_range_to             =%L,
voltage_range_unit           =%L,
amperage_range_from          =%L,
amperage_range_to            =%L,
amperage_range_unit          =%L,*/'
bandwidth_range_from         =%L,
bandwidth_range_to           =%L,
bandwidth_range_unit         =%L,
optical_mode                 =%L
WHERE t.id=%L RETURNING id',
p_schema_name,
  NEW.gmlid                       ,
  NEW.gmlid_codespace             ,
  NEW.name                        ,
  NEW.name_codespace              ,
  NEW.description                 ,
  NEW.owner                       ,
  NEW.type                        ,
--NEW.is_corrosive                ,
--NEW.is_explosive                ,
--NEW.is_lighter_than_air         ,
--NEW.flammability_ratio          ,
--NEW.elec_conductivity_range_from,
--NEW.elec_conductivity_range_to  ,
--NEW.elec_conductivity_range_unit,
--NEW.concentration               ,
--NEW.concentration_unit          ,
--NEW.ph_value_range_from         ,
--NEW.ph_value_range_to           ,
--NEW.ph_value_range_unit         ,
--NEW.temperature_range_from      ,
--NEW.temperature_range_to        ,
--NEW.temperature_range_unit      ,
--NEW.flow_rate_range_from        ,
--NEW.flow_rate_range_to          ,
--NEW.flow_rate_range_unit        ,
--NEW.pressure_range_from         ,
--NEW.pressure_range_to           ,
--NEW.pressure_range_unit         ,
--NEW.voltage_range_from          ,
--NEW.voltage_range_to            ,
--NEW.voltage_range_unit          ,
--NEW.amperage_range_from         ,
--NEW.amperage_range_to           ,
--NEW.amperage_range_unit         ,
  NEW.bandwidth_range_from        ,
  NEW.bandwidth_range_to          ,
  NEW.bandwidth_range_unit        ,
  NEW.optical_mode                ,
OLD.id
) INTO updated_id;
-- RAISE NOTICE 'Updated record with id: %', updated_id;
RETURN NEW;
EXCEPTION
  WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_upd_commodity_optical_medium (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view UTN_COMMODITY_OPTICAL_MEDIUM
----------------------------------------------------------------
DROP TRIGGER IF EXISTS utn9_tr_del_commodity_optical_medium ON citydb_view.utn9_commodity_optical_medium;
CREATE TRIGGER utn9_tr_del_commodity_optical_medium
	INSTEAD OF DELETE ON citydb_view.utn9_commodity_optical_medium
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_del_commodity_optical_medium ('citydb');

DROP TRIGGER IF EXISTS utn9_tr_ins_commodity_optical_medium ON citydb_view.utn9_commodity_optical_medium;
CREATE TRIGGER utn9_tr_ins_commodity_optical_medium
	INSTEAD OF INSERT ON citydb_view.utn9_commodity_optical_medium
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_ins_commodity_optical_medium ('citydb');

DROP TRIGGER IF EXISTS utn9_tr_upd_commodity_optical_medium ON citydb_view.utn9_commodity_optical_medium;
CREATE TRIGGER utn9_tr_upd_commodity_optical_medium
	INSTEAD OF UPDATE ON citydb_view.utn9_commodity_optical_medium
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_upd_commodity_optical_medium ('citydb');
--**************************************************************
--**************************************************************

----------------------------------------------------------------
-- Function TR_DEL_COMMODITY_SOLID_MEDIUM
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_del_commodity_solid_medium() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_del_commodity_solid_medium()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
deleted_id=citydb_pkg.utn9_delete_commodity(OLD.id, p_schema_name);
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_del_commodity_solid_medium (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_COMMODITY_SOLID_MEDIUM
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_ins_commodity_solid_medium() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_ins_commodity_solid_medium()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	inserted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
inserted_id=citydb_view.utn9_insert_commodity_solid_medium(
  id                           :=NEW.id                          ,
  gmlid                        :=NEW.gmlid                       ,
  gmlid_codespace              :=NEW.gmlid_codespace             ,
  name                         :=NEW.name                        ,
  name_codespace               :=NEW.name_codespace              ,
  description                  :=NEW.description                 ,
  owner                        :=NEW.owner                       ,
  type                         :=NEW.type                        ,
--is_corrosive                 :=NEW.is_corrosive                ,
  is_explosive                 :=NEW.is_explosive                ,
--is_lighter_than_air          :=NEW.is_lighter_than_air         ,
  flammability_ratio           :=NEW.flammability_ratio          ,
  elec_conductivity_range_from :=NEW.elec_conductivity_range_from,
  elec_conductivity_range_to   :=NEW.elec_conductivity_range_to  ,
  elec_conductivity_range_unit :=NEW.elec_conductivity_range_unit,
  concentration                :=NEW.concentration               ,
  concentration_unit           :=NEW.concentration_unit          ,
--ph_value_range_from          :=NEW.ph_value_range_from         ,
--ph_value_range_to            :=NEW.ph_value_range_to           ,
--ph_value_range_unit          :=NEW.ph_value_range_unit         ,
--temperature_range_from       :=NEW.temperature_range_from      ,
--temperature_range_to         :=NEW.temperature_range_to        ,
--temperature_range_unit       :=NEW.temperature_range_unit      ,
--flow_rate_range_from         :=NEW.flow_rate_range_from        ,
--flow_rate_range_to           :=NEW.flow_rate_range_to          ,
--flow_rate_range_unit         :=NEW.flow_rate_range_unit        ,
  pressure_range_from          :=NEW.pressure_range_from         ,
  pressure_range_to            :=NEW.pressure_range_to           ,
  pressure_range_unit          :=NEW.pressure_range_unit         ,
--voltage_range_from           :=NEW.voltage_range_from          ,
--voltage_range_to             :=NEW.voltage_range_to            ,
--voltage_range_unit           :=NEW.voltage_range_unit          ,
--amperage_range_from          :=NEW.amperage_range_from         ,
--amperage_range_to            :=NEW.amperage_range_to           ,
--amperage_range_unit          :=NEW.amperage_range_unit         ,
--bandwidth_range_from         :=NEW.bandwidth_range_from        ,
--bandwidth_range_to           :=NEW.bandwidth_range_to          ,
--bandwidth_range_unit         :=NEW.bandwidth_range_unit        ,
--optical_mode                 :=NEW.optical_mode                ,
--
schema_name          :=p_schema_name
);
--RAISE NOTICE 'Inserted record with id: %', inserted_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_ins_commodity_solid_medium (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_COMMODITY_SOLID_MEDIUM
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_upd_commodity_solid_medium() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_upd_commodity_solid_medium()
  RETURNS trigger AS
$BODY$
DECLARE
  p_schema_name varchar DEFAULT 'citydb'::varchar;
  updated_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
EXECUTE format('UPDATE %I.utn9_commodity AS t SET
gmlid                        =%L,
gmlid_codespace              =%L,
name                         =%L,
name_codespace               =%L,
description                  =%L,
owner                        =%L,
type                         =%L,'||/* 
is_corrosive                 =%L,*/'
is_explosive                 =%L,'||/* 
is_lighter_than_air          =%L,*/'
flammability_ratio           =%L,
elec_conductivity_range_from =%L,
elec_conductivity_range_to   =%L,
elec_conductivity_range_unit =%L,
concentration                =%L,
concentration_unit           =%L,'||/* 
ph_value_range_from          =%L,
ph_value_range_to            =%L,
ph_value_range_unit          =%L,
temperature_range_from       =%L,
temperature_range_to         =%L,
temperature_range_unit       =%L,
flow_rate_range_from         =%L,
flow_rate_range_to           =%L,
flow_rate_range_unit         =%L,*/'
pressure_range_from          =%L,
pressure_range_to            =%L,
pressure_range_unit          =%L'||/* ,
voltage_range_from           =%L,
voltage_range_to             =%L,
voltage_range_unit           =%L,
amperage_range_from          =%L,
amperage_range_to            =%L,
amperage_range_unit          =%L,
bandwidth_range_from         =%L,
bandwidth_range_to           =%L,
bandwidth_range_unit         =%L,
optical_mode                 =%L*/'
WHERE t.id=%L RETURNING id',
p_schema_name,
  NEW.gmlid                       ,
  NEW.gmlid_codespace             ,
  NEW.name                        ,
  NEW.name_codespace              ,
  NEW.description                 ,
  NEW.owner                       ,
  NEW.type                        ,
--NEW.is_corrosive                ,
  NEW.is_explosive                ,
--NEW.is_lighter_than_air         ,
  NEW.flammability_ratio          ,
  NEW.elec_conductivity_range_from,
  NEW.elec_conductivity_range_to  ,
  NEW.elec_conductivity_range_unit,
  NEW.concentration               ,
  NEW.concentration_unit          ,
--NEW.ph_value_range_from         ,
--NEW.ph_value_range_to           ,
--NEW.ph_value_range_unit         ,
--NEW.temperature_range_from      ,
--NEW.temperature_range_to        ,
--NEW.temperature_range_unit      ,
--NEW.flow_rate_range_from        ,
--NEW.flow_rate_range_to          ,
--NEW.flow_rate_range_unit        ,
  NEW.pressure_range_from         ,
  NEW.pressure_range_to           ,
  NEW.pressure_range_unit         ,
--NEW.voltage_range_from          ,
--NEW.voltage_range_to            ,
--NEW.voltage_range_unit          ,
--NEW.amperage_range_from         ,
--NEW.amperage_range_to           ,
--NEW.amperage_range_unit         ,
--NEW.bandwidth_range_from        ,
--NEW.bandwidth_range_to          ,
--NEW.bandwidth_range_unit        ,
--NEW.optical_mode                ,
OLD.id
) INTO updated_id;
-- RAISE NOTICE 'Updated record with id: %', updated_id;
RETURN NEW;
EXCEPTION
  WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_upd_commodity_solid_medium (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view UTN_COMMODITY_SOLID_MEDIUM
----------------------------------------------------------------
DROP TRIGGER IF EXISTS utn9_tr_del_commodity_solid_medium ON citydb_view.utn9_commodity_solid_medium;
CREATE TRIGGER utn9_tr_del_commodity_solid_medium
	INSTEAD OF DELETE ON citydb_view.utn9_commodity_solid_medium
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_del_commodity_solid_medium ('citydb');

DROP TRIGGER IF EXISTS utn9_tr_ins_commodity_solid_medium ON citydb_view.utn9_commodity_solid_medium;
CREATE TRIGGER utn9_tr_ins_commodity_solid_medium
	INSTEAD OF INSERT ON citydb_view.utn9_commodity_solid_medium
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_ins_commodity_solid_medium ('citydb');

DROP TRIGGER IF EXISTS utn9_tr_upd_commodity_solid_medium ON citydb_view.utn9_commodity_solid_medium;
CREATE TRIGGER utn9_tr_upd_commodity_solid_medium
	INSTEAD OF UPDATE ON citydb_view.utn9_commodity_solid_medium
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_upd_commodity_solid_medium ('citydb');
--**************************************************************
--**************************************************************

----------------------------------------------------------------
-- Function TR_DEL_NETWORK_GRAPH
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_del_network_graph() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_del_network_graph()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
deleted_id=citydb_pkg.utn9_delete_network_graph(OLD.id, p_schema_name);
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_del_network_graph (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_NETWORK_GRAPH
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_ins_network_graph() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_ins_network_graph()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	inserted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
inserted_id=citydb_view.utn9_insert_network_graph(
id             :=NEW.id             ,
gmlid          :=NEW.gmlid          ,
gmlid_codespace:=NEW.gmlid_codespace,
name           :=NEW.name           ,
name_codespace :=NEW.name_codespace ,
description    :=NEW.description    ,
network_id     :=NEW.network_id     ,
--
schema_name          :=p_schema_name
);
--RAISE NOTICE 'Inserted record with id: %', inserted_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_ins_network_graph (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_NETWORK_GRAPH
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_upd_network_graph() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_upd_network_graph()
  RETURNS trigger AS
$BODY$
DECLARE
  p_schema_name varchar DEFAULT 'citydb'::varchar;
  updated_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
EXECUTE format('UPDATE %I.utn9_network_graph AS t SET
id             =%L,
gmlid          =%L,
gmlid_codespace=%L,
name           =%L,
name_codespace =%L,
description    =%L,
network_id     =%L
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.id             ,
NEW.gmlid          ,
NEW.gmlid_codespace,
NEW.name           ,
NEW.name_codespace ,
NEW.description    ,
NEW.network_id     ,
OLD.id
) INTO updated_id;
-- RAISE NOTICE 'Updated record with id: %', updated_id;
RETURN NEW;
EXCEPTION
  WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_upd_network_graph (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view UTN_NETWORK_GRAPH
----------------------------------------------------------------
DROP TRIGGER IF EXISTS utn9_tr_del_network_graph ON citydb_view.utn9_network_graph;
CREATE TRIGGER utn9_tr_del_network_graph
	INSTEAD OF DELETE ON citydb_view.utn9_network_graph
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_del_network_graph ('citydb');

DROP TRIGGER IF EXISTS utn9_tr_ins_network_graph ON citydb_view.utn9_network_graph;
CREATE TRIGGER utn9_tr_ins_network_graph
	INSTEAD OF INSERT ON citydb_view.utn9_network_graph
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_ins_network_graph ('citydb');

DROP TRIGGER IF EXISTS utn9_tr_upd_network_graph ON citydb_view.utn9_network_graph;
CREATE TRIGGER utn9_tr_upd_network_graph
	INSTEAD OF UPDATE ON citydb_view.utn9_network_graph
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_upd_network_graph ('citydb');
--**************************************************************
--**************************************************************

----------------------------------------------------------------
-- Function TR_DEL_FEATURE_GRAPH
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_del_feature_graph() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_del_feature_graph()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
deleted_id=citydb_pkg.utn9_delete_feature_graph(OLD.id, p_schema_name);
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_del_feature_graph (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_FEATURE_GRAPH
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_ins_feature_graph() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_ins_feature_graph()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	inserted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
inserted_id=citydb_view.utn9_insert_feature_graph(
id             :=NEW.id             ,
gmlid          :=NEW.gmlid          ,
gmlid_codespace:=NEW.gmlid_codespace,
name           :=NEW.name           ,
name_codespace :=NEW.name_codespace ,
description    :=NEW.description    ,
ntw_feature_id :=NEW.ntw_feature_id ,
ntw_graph_id   :=NEW.ntw_graph_id   ,
--
schema_name          :=p_schema_name
);
--RAISE NOTICE 'Inserted record with id: %', inserted_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_ins_feature_graph (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_FEATURE_GRAPH
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_upd_feature_graph() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_upd_feature_graph()
  RETURNS trigger AS
$BODY$
DECLARE
  p_schema_name varchar DEFAULT 'citydb'::varchar;
  updated_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
EXECUTE format('UPDATE %I.utn9_feature_graph AS t SET
id             =%L,
gmlid          =%L,
gmlid_codespace=%L,
name           =%L,
name_codespace =%L,
description    =%L,
ntw_feature_id =%L,
ntw_graph_id   =%L
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.id             ,
NEW.gmlid          ,
NEW.gmlid_codespace,
NEW.name           ,
NEW.name_codespace ,
NEW.description    ,
NEW.ntw_feature_id ,
NEW.ntw_graph_id   ,
OLD.id
) INTO updated_id;
-- RAISE NOTICE 'Updated record with id: %', updated_id;
RETURN NEW;
EXCEPTION
  WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_upd_feature_graph (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view UTN_FEATURE_GRAPH
----------------------------------------------------------------
DROP TRIGGER IF EXISTS utn9_tr_del_feature_graph ON citydb_view.utn9_feature_graph;
CREATE TRIGGER utn9_tr_del_feature_graph
	INSTEAD OF DELETE ON citydb_view.utn9_feature_graph
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_del_feature_graph ('citydb');

DROP TRIGGER IF EXISTS utn9_tr_ins_feature_graph ON citydb_view.utn9_feature_graph;
CREATE TRIGGER utn9_tr_ins_feature_graph
	INSTEAD OF INSERT ON citydb_view.utn9_feature_graph
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_ins_feature_graph ('citydb');

DROP TRIGGER IF EXISTS utn9_tr_upd_feature_graph ON citydb_view.utn9_feature_graph;
CREATE TRIGGER utn9_tr_upd_feature_graph
	INSTEAD OF UPDATE ON citydb_view.utn9_feature_graph
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_upd_feature_graph ('citydb');
--**************************************************************
--**************************************************************

----------------------------------------------------------------
-- Function TR_DEL_HOLLOW_SPACE
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_del_hollow_space() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_del_hollow_space()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
deleted_id=citydb_pkg.utn9_delete_hollow_space(OLD.id, p_schema_name);
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_del_hollow_space (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_HOLLOW_SPACE
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_ins_hollow_space() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_ins_hollow_space()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	inserted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
inserted_id=citydb_view.utn9_insert_hollow_space(
id                :=NEW.id               ,
hol_spc_parent_id :=NEW.hol_spc_parent_id,
hol_spc_root_id   :=NEW.hol_spc_root_id  ,
gmlid             :=NEW.gmlid            ,
gmlid_codespace   :=NEW.gmlid_codespace  ,
name              :=NEW.name             ,
name_codespace    :=NEW.name_codespace   ,
description       :=NEW.description      ,
ntw_feature_id    :=NEW.ntw_feature_id   ,
--
schema_name          :=p_schema_name
);
--RAISE NOTICE 'Inserted record with id: %', inserted_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_ins_hollow_space (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_HOLLOW_SPACE
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_upd_hollow_space() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_upd_hollow_space()
  RETURNS trigger AS
$BODY$
DECLARE
  p_schema_name varchar DEFAULT 'citydb'::varchar;
  updated_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
EXECUTE format('UPDATE %I.utn9_hollow_space AS t SET
id               =%L,
hol_spc_parent_id=%L,
hol_spc_root_id  =%L,
gmlid            =%L,
gmlid_codespace  =%L,
name             =%L,
name_codespace   =%L,
description      =%L,
ntw_feature_id   =%L
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.id               ,
NEW.hol_spc_parent_id,
NEW.hol_spc_root_id  ,
NEW.gmlid            ,
NEW.gmlid_codespace  ,
NEW.name             ,
NEW.name_codespace   ,
NEW.description      ,
NEW.ntw_feature_id   ,
OLD.id
) INTO updated_id;
-- RAISE NOTICE 'Updated record with id: %', updated_id;
RETURN NEW;
EXCEPTION
  WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_upd_hollow_space (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view UTN_HOLLOW_SPACE
----------------------------------------------------------------
DROP TRIGGER IF EXISTS utn9_tr_del_hollow_space ON citydb_view.utn9_hollow_space;
CREATE TRIGGER utn9_tr_del_hollow_space
	INSTEAD OF DELETE ON citydb_view.utn9_hollow_space
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_del_hollow_space ('citydb');

DROP TRIGGER IF EXISTS utn9_tr_ins_hollow_space ON citydb_view.utn9_hollow_space;
CREATE TRIGGER utn9_tr_ins_hollow_space
	INSTEAD OF INSERT ON citydb_view.utn9_hollow_space
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_ins_hollow_space ('citydb');

DROP TRIGGER IF EXISTS utn9_tr_upd_hollow_space ON citydb_view.utn9_hollow_space;
CREATE TRIGGER utn9_tr_upd_hollow_space
	INSTEAD OF UPDATE ON citydb_view.utn9_hollow_space
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_upd_hollow_space ('citydb');
--**************************************************************
--**************************************************************

----------------------------------------------------------------
-- Function TR_DEL_HOLLOW_SPACE_PART
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_del_hollow_space_part() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_del_hollow_space_part()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
deleted_id=citydb_pkg.utn9_delete_hollow_space(OLD.id, p_schema_name);
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_del_hollow_space_part (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_HOLLOW_SPACE_PART
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_ins_hollow_space_part() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_ins_hollow_space_part()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	inserted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
inserted_id=citydb_view.utn9_insert_hollow_space_part(
id                :=NEW.id               ,
hol_spc_parent_id :=NEW.hol_spc_parent_id,
hol_spc_root_id   :=NEW.hol_spc_root_id  ,
gmlid             :=NEW.gmlid            ,
gmlid_codespace   :=NEW.gmlid_codespace  ,
name              :=NEW.name             ,
name_codespace    :=NEW.name_codespace   ,
description       :=NEW.description      ,
ntw_feature_id    :=NEW.ntw_feature_id   ,
--
schema_name          :=p_schema_name
);
--RAISE NOTICE 'Inserted record with id: %', inserted_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_ins_hollow_space_part (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_HOLLOW_SPACE_PART
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_upd_hollow_space_part() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_upd_hollow_space_part()
  RETURNS trigger AS
$BODY$
DECLARE
  p_schema_name varchar DEFAULT 'citydb'::varchar;
  updated_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
EXECUTE format('UPDATE %I.utn9_hollow_space AS t SET
id               =%L,
hol_spc_parent_id=%L,
hol_spc_root_id  =%L,
gmlid            =%L,
gmlid_codespace  =%L,
name             =%L,
name_codespace   =%L,
description      =%L,
ntw_feature_id   =%L
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.id               ,
NEW.hol_spc_parent_id,
NEW.hol_spc_root_id  ,
NEW.gmlid            ,
NEW.gmlid_codespace  ,
NEW.name             ,
NEW.name_codespace   ,
NEW.description      ,
NEW.ntw_feature_id   ,
OLD.id
) INTO updated_id;
-- RAISE NOTICE 'Updated record with id: %', updated_id;
RETURN NEW;
EXCEPTION
  WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_upd_hollow_space_part (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view UTN_HOLLOW_SPACE_PART
----------------------------------------------------------------
DROP TRIGGER IF EXISTS utn9_tr_del_hollow_space_part ON citydb_view.utn9_hollow_space_part;
CREATE TRIGGER utn9_tr_del_hollow_space_part
	INSTEAD OF DELETE ON citydb_view.utn9_hollow_space_part
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_del_hollow_space_part ('citydb');

DROP TRIGGER IF EXISTS utn9_tr_ins_hollow_space_part ON citydb_view.utn9_hollow_space_part;
CREATE TRIGGER utn9_tr_ins_hollow_space_part
	INSTEAD OF INSERT ON citydb_view.utn9_hollow_space_part
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_ins_hollow_space_part ('citydb');

DROP TRIGGER IF EXISTS utn9_tr_upd_hollow_space_part ON citydb_view.utn9_hollow_space_part;
CREATE TRIGGER utn9_tr_upd_hollow_space_part
	INSTEAD OF UPDATE ON citydb_view.utn9_hollow_space_part
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_upd_hollow_space_part ('citydb');
--**************************************************************
--**************************************************************

----------------------------------------------------------------
-- Function TR_DEL_LINK_INTERFEATURE
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_del_link_interfeature() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_del_link_interfeature()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
deleted_id=citydb_pkg.utn9_delete_link(OLD.id, p_schema_name);
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_del_link_interfeature (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_LINK_INTERFEATURE
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_ins_link_interfeature() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_ins_link_interfeature()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	inserted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
inserted_id=citydb_view.utn9_insert_link_interfeature(
id                    :=NEW.id                    ,
gmlid                 :=NEW.gmlid                 ,
gmlid_codespace       :=NEW.gmlid_codespace       ,
name                  :=NEW.name                  ,
name_codespace        :=NEW.name_codespace        ,
description           :=NEW.description           ,
direction             :=NEW.direction             ,
link_control          :=NEW.link_control          ,
type                  :=NEW.type                  ,
start_node_id         :=NEW.start_node_id         ,
end_node_id           :=NEW.end_node_id           ,
--feat_graph_id         :=NEW.feat_graph_id         ,
ntw_graph_id          :=NEW.ntw_graph_id          ,
line_geom             :=NEW.line_geom             ,
--
schema_name          :=p_schema_name
);
--RAISE NOTICE 'Inserted record with id: %', inserted_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_ins_link_interfeature (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_LINK_INTERFEATURE
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_upd_link_interfeature() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_upd_link_interfeature()
  RETURNS trigger AS
$BODY$
DECLARE
  p_schema_name varchar DEFAULT 'citydb'::varchar;
  updated_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
EXECUTE format('UPDATE %I.utn9_link AS t SET
id             =%L,
gmlid          =%L,
gmlid_codespace=%L,
name           =%L,
name_codespace =%L,
description    =%L,
direction      =%L,
link_control   =%L,
type           =%L,
start_node_id  =%L,
end_node_id    =%L,

ntw_graph_id   =%L,
line_geom      =%L
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.id             ,
NEW.gmlid          ,
NEW.gmlid_codespace,
NEW.name           ,
NEW.name_codespace ,
NEW.description    ,
NEW.direction      ,
NEW.link_control   ,
NEW.type           ,
NEW.start_node_id  ,
NEW.end_node_id    ,
--NEW.feat_graph_id  ,
NEW.ntw_graph_id   ,
NEW.line_geom      ,
OLD.id
) INTO updated_id;
-- RAISE NOTICE 'Updated record with id: %', updated_id;
RETURN NEW;
EXCEPTION
  WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_upd_link_interfeature (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view UTN_LINK_INTERFEATURE
----------------------------------------------------------------
DROP TRIGGER IF EXISTS utn9_tr_del_link_interfeature ON citydb_view.utn9_link_interfeature;
CREATE TRIGGER utn9_tr_del_link_interfeature
	INSTEAD OF DELETE ON citydb_view.utn9_link_interfeature
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_del_link_interfeature ('citydb');

DROP TRIGGER IF EXISTS utn9_tr_ins_link_interfeature ON citydb_view.utn9_link_interfeature;
CREATE TRIGGER utn9_tr_ins_link_interfeature
	INSTEAD OF INSERT ON citydb_view.utn9_link_interfeature
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_ins_link_interfeature ('citydb');

DROP TRIGGER IF EXISTS utn9_tr_upd_link_interfeature ON citydb_view.utn9_link_interfeature;
CREATE TRIGGER utn9_tr_upd_link_interfeature
	INSTEAD OF UPDATE ON citydb_view.utn9_link_interfeature
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_upd_link_interfeature ('citydb');
--**************************************************************
--**************************************************************

----------------------------------------------------------------
-- Function TR_DEL_LINK_INTERIOR_FEATURE
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_del_link_interior_feature() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_del_link_interior_feature()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
deleted_id=citydb_pkg.utn9_delete_link(OLD.id, p_schema_name);
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_del_link_interior_feature (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_LINK_INTERIOR_FEATURE
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_ins_link_interior_feature() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_ins_link_interior_feature()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	inserted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
inserted_id=citydb_view.utn9_insert_link_interior_feature(
  id                    :=NEW.id                    ,
  gmlid                 :=NEW.gmlid                 ,
  gmlid_codespace       :=NEW.gmlid_codespace       ,
  name                  :=NEW.name                  ,
  name_codespace        :=NEW.name_codespace        ,
  description           :=NEW.description           ,
  direction             :=NEW.direction             ,
  link_control          :=NEW.link_control          ,
--type:=NEW.type,
  start_node_id         :=NEW.start_node_id         ,
  end_node_id           :=NEW.end_node_id           ,
  feat_graph_id         :=NEW.feat_graph_id         ,
--ntw_graph_id          :=NEW.ntw_graph_id          ,
  line_geom             :=NEW.line_geom             ,
--
schema_name          :=p_schema_name
);
--RAISE NOTICE 'Inserted record with id: %', inserted_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_ins_link_interior_feature (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_LINK_INTERIOR_FEATURE
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_upd_link_interior_feature() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_upd_link_interior_feature()
  RETURNS trigger AS
$BODY$
DECLARE
  p_schema_name varchar DEFAULT 'citydb'::varchar;
  updated_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
EXECUTE format('UPDATE %I.utn9_link AS t SET
id                    =%L,
gmlid                 =%L,
gmlid_codespace       =%L,
name                  =%L,
name_codespace        =%L,
description           =%L,
direction             =%L,
link_control          =%L,

start_node_id         =%L,
end_node_id           =%L,
feat_graph_id         =%L,

line_geom             =%L
WHERE t.id=%L RETURNING id',
p_schema_name,
  NEW.id                    ,
  NEW.gmlid                 ,
  NEW.gmlid_codespace       ,
  NEW.name                  ,
  NEW.name_codespace        ,
  NEW.description           ,
  NEW.direction             ,
  NEW.link_control          ,
--NEW.type,
  NEW.start_node_id         ,
  NEW.end_node_id           ,
  NEW.feat_graph_id         ,
--NEW.ntw_graph_id          ,
  NEW.line_geom             ,
OLD.id
) INTO updated_id;
-- RAISE NOTICE 'Updated record with id: %', updated_id;
RETURN NEW;
EXCEPTION
  WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_upd_link_interior_feature (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view UTN_LINK_INTERIOR_FEATURE
----------------------------------------------------------------
DROP TRIGGER IF EXISTS utn9_tr_del_link_interior_feature ON citydb_view.utn9_link_interior_feature;
CREATE TRIGGER utn9_tr_del_link_interior_feature
	INSTEAD OF DELETE ON citydb_view.utn9_link_interior_feature
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_del_link_interior_feature ('citydb');

DROP TRIGGER IF EXISTS utn9_tr_ins_link_interior_feature ON citydb_view.utn9_link_interior_feature;
CREATE TRIGGER utn9_tr_ins_link_interior_feature
	INSTEAD OF INSERT ON citydb_view.utn9_link_interior_feature
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_ins_link_interior_feature ('citydb');

DROP TRIGGER IF EXISTS utn9_tr_upd_link_interior_feature ON citydb_view.utn9_link_interior_feature;
CREATE TRIGGER utn9_tr_upd_link_interior_feature
	INSTEAD OF UPDATE ON citydb_view.utn9_link_interior_feature
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_upd_link_interior_feature ('citydb');
--**************************************************************
--**************************************************************

----------------------------------------------------------------
-- Function TR_DEL_LINK_NETWORK
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_del_link_network() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_del_link_network()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
deleted_id=citydb_pkg.utn9_delete_link(OLD.id, p_schema_name);
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_del_link_network (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_LINK_NETWORK
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_ins_link_network() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_ins_link_network()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	inserted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
inserted_id=citydb_view.utn9_insert_link_network(
  id                    :=NEW.id                    ,
  gmlid                 :=NEW.gmlid                 ,
  gmlid_codespace       :=NEW.gmlid_codespace       ,
  name                  :=NEW.name                  ,
  name_codespace        :=NEW.name_codespace        ,
  description           :=NEW.description           ,
  direction             :=NEW.direction             ,
  link_control          :=NEW.link_control          ,
--type:=NEW.type,
  start_node_id         :=NEW.start_node_id         ,
  end_node_id           :=NEW.end_node_id           ,
  feat_graph_id         :=NEW.feat_graph_id         ,
--ntw_graph_id          :=NEW.ntw_graph_id          ,
  line_geom             :=NEW.line_geom             ,
--
schema_name          :=p_schema_name
);
--RAISE NOTICE 'Inserted record with id: %', inserted_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_ins_link_network (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_LINK_NETWORK
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_upd_link_network() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_upd_link_network()
  RETURNS trigger AS
$BODY$
DECLARE
  p_schema_name varchar DEFAULT 'citydb'::varchar;
  updated_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
EXECUTE format('UPDATE %I.utn9_link AS t SET
id                    =%L,
gmlid                 =%L,
gmlid_codespace       =%L,
name                  =%L,
name_codespace        =%L,
description           =%L,
direction             =%L,
link_control          =%L,'||/* 
type=%L,*/'
start_node_id         =%L,
end_node_id           =%L,
feat_graph_id         =%L,'||/* 
ntw_graph_id          =%L,*/'
line_geom             =%L
WHERE t.id=%L RETURNING id',
p_schema_name,
  NEW.id                    ,
  NEW.gmlid                 ,
  NEW.gmlid_codespace       ,
  NEW.name                  ,
  NEW.name_codespace        ,
  NEW.description           ,
  NEW.direction             ,
  NEW.link_control          ,
--NEW.type,
  NEW.start_node_id         ,
  NEW.end_node_id           ,
  NEW.feat_graph_id         ,
--NEW.ntw_graph_id          ,
  NEW.line_geom             ,
OLD.id
) INTO updated_id;
-- RAISE NOTICE 'Updated record with id: %', updated_id;
RETURN NEW;
EXCEPTION
  WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_upd_link_network (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view UTN_LINK_NETWORK
----------------------------------------------------------------
DROP TRIGGER IF EXISTS utn9_tr_del_link_network ON citydb_view.utn9_link_network;
CREATE TRIGGER utn9_tr_del_link_network
	INSTEAD OF DELETE ON citydb_view.utn9_link_network
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_del_link_network ('citydb');

DROP TRIGGER IF EXISTS utn9_tr_ins_link_network ON citydb_view.utn9_link_network;
CREATE TRIGGER utn9_tr_ins_link_network
	INSTEAD OF INSERT ON citydb_view.utn9_link_network
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_ins_link_network ('citydb');

DROP TRIGGER IF EXISTS utn9_tr_upd_link_network ON citydb_view.utn9_link_network;
CREATE TRIGGER utn9_tr_upd_link_network
	INSTEAD OF UPDATE ON citydb_view.utn9_link_network
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_upd_link_network ('citydb');
--**************************************************************
--**************************************************************

----------------------------------------------------------------
-- Function TR_DEL_MATERIAL_FILLING
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_del_material_filling() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_del_material_filling()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
deleted_id=citydb_pkg.utn9_delete_material(OLD.id, p_schema_name);
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_del_material (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_MATERIAL_FILLING
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_ins_material_filling() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_ins_material_filling()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	inserted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
inserted_id=citydb_view.utn9_insert_material_filling(
  id                :=NEW.id                ,
--material_parent_id:=NEW.material_parent_id,
--material_root_id  :=NEW.material_root_id  ,
  gmlid             :=NEW.gmlid             ,
  gmlid_codespace   :=NEW.gmlid_codespace   ,
  name              :=NEW.name              ,
  name_codespace    :=NEW.name_codespace    ,
  description       :=NEW.description       ,
  type              :=NEW.type              ,
  material_id       :=NEW.material_id       ,
--
  schema_name          :=p_schema_name
);
--RAISE NOTICE 'Inserted record with id: %', inserted_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_ins_material (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_MATERIAL_FILLING
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_upd_material_filling() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_upd_material_filling()
  RETURNS trigger AS
$BODY$
DECLARE
  p_schema_name varchar DEFAULT 'citydb'::varchar;
  updated_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
EXECUTE format('UPDATE %I.utn9_material AS t SET
id                 =%L,'||/*
material_parent_id =%L,
material_root_id   =%L,*/'
gmlid              =%L,
gmlid_codespace    =%L,
name               =%L,
name_codespace     =%L,
description        =%L, 
type               =%L,
material_id        =%L
WHERE t.id=%L RETURNING id',
p_schema_name,
  NEW.id                ,
--NEW.material_parent_id,
--NEW.material_root_id  ,
  NEW.gmlid             ,
  NEW.gmlid_codespace   ,
  NEW.name              ,
  NEW.name_codespace    ,
  NEW.description       ,
  NEW.type              ,
  NEW.material_id       ,
OLD.id
) INTO updated_id;
-- RAISE NOTICE 'Updated record with id: %', updated_id;
RETURN NEW;
EXCEPTION
  WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_upd_material_filling (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view UTN_MATERIAL_FILLING
----------------------------------------------------------------
DROP TRIGGER IF EXISTS utn9_tr_del_material_filling ON citydb_view.utn9_material_filling;
CREATE TRIGGER utn9_tr_del_material_filling
	INSTEAD OF DELETE ON citydb_view.utn9_material_filling
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_del_material_filling ('citydb');

DROP TRIGGER IF EXISTS utn9_tr_ins_material_filling ON citydb_view.utn9_material_filling;
CREATE TRIGGER utn9_tr_ins_material_filling
	INSTEAD OF INSERT ON citydb_view.utn9_material_filling
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_ins_material_filling ('citydb');

DROP TRIGGER IF EXISTS utn9_tr_upd_material_filling ON citydb_view.utn9_material_filling;
CREATE TRIGGER utn9_tr_upd_material_filling
	INSTEAD OF UPDATE ON citydb_view.utn9_material_filling
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_upd_material_filling ('citydb');
--**************************************************************
--**************************************************************

----------------------------------------------------------------
-- Function TR_DEL_MATERIAL_INTERIOR
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_del_material_interior() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_del_material_interior()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
deleted_id=citydb_pkg.utn9_delete_material(OLD.id, p_schema_name);
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_del_material_interior (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_MATERIAL_INTERIOR
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_ins_material_interior() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_ins_material_interior()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	inserted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
inserted_id=citydb_view.utn9_insert_material_interior(
  id                :=NEW.id                ,
  material_parent_id:=NEW.material_parent_id,
  material_root_id  :=NEW.material_root_id  ,
  gmlid             :=NEW.gmlid             ,
  gmlid_codespace   :=NEW.gmlid_codespace   ,
  name              :=NEW.name              ,
  name_codespace    :=NEW.name_codespace    ,
  description       :=NEW.description       ,
  type              :=NEW.type              ,
--material_id       :=NEW.material_id       ,
--
  schema_name          :=p_schema_name
);
--RAISE NOTICE 'Inserted record with id: %', inserted_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_ins_material_interior (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_MATERIAL_INTERIOR
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_upd_material_interior() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_upd_material_interior()
  RETURNS trigger AS
$BODY$
DECLARE
  p_schema_name varchar DEFAULT 'citydb'::varchar;
  updated_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
EXECUTE format('UPDATE %I.utn9_material AS t SET
id                 =%L,
material_parent_id =%L,
material_root_id   =%L,
gmlid              =%L,
gmlid_codespace    =%L,
name               =%L,
name_codespace     =%L,
description        =%L, 
type               =%L'||/*,
material_id        =%L*/'
WHERE t.id=%L RETURNING id',
p_schema_name,
  NEW.id                ,
  NEW.material_parent_id,
  NEW.material_root_id  ,
  NEW.gmlid             ,
  NEW.gmlid_codespace   ,
  NEW.name              ,
  NEW.name_codespace    ,
  NEW.description       ,
  NEW.type              ,
--NEW.material_id       ,
OLD.id
) INTO updated_id;
-- RAISE NOTICE 'Updated record with id: %', updated_id;
RETURN NEW;
EXCEPTION
  WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_upd_material_interior (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view UTN_MATERIAL_INTERIOR
----------------------------------------------------------------
DROP TRIGGER IF EXISTS utn9_tr_del_material_interior ON citydb_view.utn9_material_interior;
CREATE TRIGGER utn9_tr_del_material_interior
	INSTEAD OF DELETE ON citydb_view.utn9_material_interior
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_del_material_interior ('citydb');

DROP TRIGGER IF EXISTS utn9_tr_ins_material_interior ON citydb_view.utn9_material_interior;
CREATE TRIGGER utn9_tr_ins_material_interior
	INSTEAD OF INSERT ON citydb_view.utn9_material_interior
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_ins_material_interior ('citydb');

DROP TRIGGER IF EXISTS utn9_tr_upd_material_interior ON citydb_view.utn9_material_interior;
CREATE TRIGGER utn9_tr_upd_material_interior
	INSTEAD OF UPDATE ON citydb_view.utn9_material_interior
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_upd_material_interior ('citydb');
--**************************************************************
--**************************************************************

----------------------------------------------------------------
-- Function TR_DEL_MATERIAL_EXTERIOR
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_del_material_exterior() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_del_material_exterior()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
deleted_id=citydb_pkg.utn9_delete_material(OLD.id, p_schema_name);
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_del_material_exterior (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_MATERIAL_EXTERIOR
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_ins_material_exterior() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_ins_material_exterior()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	inserted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
inserted_id=citydb_view.utn9_insert_material_exterior(
  id                :=NEW.id                ,
  material_parent_id:=NEW.material_parent_id,
  material_root_id  :=NEW.material_root_id  ,
  gmlid             :=NEW.gmlid             ,
  gmlid_codespace   :=NEW.gmlid_codespace   ,
  name              :=NEW.name              ,
  name_codespace    :=NEW.name_codespace    ,
  description       :=NEW.description       ,
  type              :=NEW.type              ,
--material_id       :=NEW.material_id       ,
--
  schema_name          :=p_schema_name
);
--RAISE NOTICE 'Inserted record with id: %', inserted_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_ins_material_exterior (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_MATERIAL_EXTERIOR
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_upd_material_exterior() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_upd_material_exterior()
  RETURNS trigger AS
$BODY$
DECLARE
  p_schema_name varchar DEFAULT 'citydb'::varchar;
  updated_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
EXECUTE format('UPDATE %I.utn9_material AS t SET
id                 =%L,
material_parent_id =%L,
material_root_id   =%L,
gmlid              =%L,
gmlid_codespace    =%L,
name               =%L,
name_codespace     =%L,
description        =%L, 
type               =%L'||/*,
material_id        =%L*/'
WHERE t.id=%L RETURNING id',
p_schema_name,
  NEW.id                ,
  NEW.material_parent_id,
  NEW.material_root_id  ,
  NEW.gmlid             ,
  NEW.gmlid_codespace   ,
  NEW.name              ,
  NEW.name_codespace    ,
  NEW.description       ,
  NEW.type              ,
--NEW.material_id       ,
OLD.id
) INTO updated_id;
-- RAISE NOTICE 'Updated record with id: %', updated_id;
RETURN NEW;
EXCEPTION
  WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_upd_material_exterior (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view UTN_MATERIAL_EXTERIOR
----------------------------------------------------------------
DROP TRIGGER IF EXISTS utn9_tr_del_material_exterior ON citydb_view.utn9_material_exterior;
CREATE TRIGGER utn9_tr_del_material_exterior
	INSTEAD OF DELETE ON citydb_view.utn9_material_exterior
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_del_material_exterior ('citydb');

DROP TRIGGER IF EXISTS utn9_tr_ins_material_exterior ON citydb_view.utn9_material_exterior;
CREATE TRIGGER utn9_tr_ins_material_exterior
	INSTEAD OF INSERT ON citydb_view.utn9_material_exterior
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_ins_material_exterior ('citydb');

DROP TRIGGER IF EXISTS utn9_tr_upd_material_exterior ON citydb_view.utn9_material_exterior;
CREATE TRIGGER utn9_tr_upd_material_exterior
	INSTEAD OF UPDATE ON citydb_view.utn9_material_exterior
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_upd_material_exterior ('citydb');
--**************************************************************
--**************************************************************

----------------------------------------------------------------
-- Function TR_DEL_MEDIUM_SUPPLY_ELECTRICAL
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_del_medium_supply_electrical() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_del_medium_supply_electrical()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
deleted_id=citydb_pkg.utn9_delete_medium_supply(OLD.id, p_schema_name);
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_del_medium_supply_electrical (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_MEDIUM_SUPPLY_ELECTRICAL
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_ins_medium_supply_electrical() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_ins_medium_supply_electrical()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	inserted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
inserted_id=citydb_view.utn9_insert_medium_supply_electrical(
id                       :=NEW.id                       ,
type                     :=NEW.type                     ,
cur_flow_rate     :=NEW.cur_flow_rate     ,
cur_flow_rate_unit:=NEW.cur_flow_rate_unit,
cur_status        :=NEW.cur_status        ,
pot_flow_rate     :=NEW.pot_flow_rate     ,
pot_flow_rate_unit:=NEW.pot_flow_rate_unit,
pot_status        :=NEW.pot_status        ,
cityobject_id            :=NEW.cityobject_id            ,
--
schema_name          :=p_schema_name
);
--RAISE NOTICE 'Inserted record with id: %', inserted_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_ins_medium_supply_electrical (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_MEDIUM_SUPPLY_ELECTRICAL
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_upd_medium_supply_electrical() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_upd_medium_supply_electrical()
  RETURNS trigger AS
$BODY$
DECLARE
  p_schema_name varchar DEFAULT 'citydb'::varchar;
  updated_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
EXECUTE format('UPDATE %I.utn9_medium_supply AS t SET
id                       =%L,
type                     =%L,
cur_flow_rate     =%L,
cur_flow_rate_unit=%L,
cur_status        =%L,
pot_flow_rate     =%L,
pot_flow_rate_unit=%L,
pot_status        =%L,
cityobject_id            =%L
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.id                       ,
NEW.type                     ,
NEW.cur_flow_rate     ,
NEW.cur_flow_rate_unit,
NEW.cur_status        ,
NEW.pot_flow_rate     ,
NEW.pot_flow_rate_unit,
NEW.pot_status        ,
NEW.cityobject_id            ,
OLD.id
) INTO updated_id;
-- RAISE NOTICE 'Updated record with id: %', updated_id;
RETURN NEW;
EXCEPTION
  WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_upd_medium_supply_electrical (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view UTN_MEDIUM_SUPPLY_ELECTRICAL
----------------------------------------------------------------
DROP TRIGGER IF EXISTS utn9_tr_del_medium_supply_electrical ON citydb_view.utn9_medium_supply_electrical;
CREATE TRIGGER utn9_tr_del_medium_supply_electrical
	INSTEAD OF DELETE ON citydb_view.utn9_medium_supply_electrical
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_del_medium_supply_electrical ('citydb');

DROP TRIGGER IF EXISTS utn9_tr_ins_medium_supply_electrical ON citydb_view.utn9_medium_supply_electrical;
CREATE TRIGGER utn9_tr_ins_medium_supply_electrical
	INSTEAD OF INSERT ON citydb_view.utn9_medium_supply_electrical
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_ins_medium_supply_electrical ('citydb');

DROP TRIGGER IF EXISTS utn9_tr_upd_medium_supply_electrical ON citydb_view.utn9_medium_supply_electrical;
CREATE TRIGGER utn9_tr_upd_medium_supply_electrical
	INSTEAD OF UPDATE ON citydb_view.utn9_medium_supply_electrical
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_upd_medium_supply_electrical ('citydb');
--**************************************************************
--**************************************************************

----------------------------------------------------------------
-- Function TR_DEL_MEDIUM_SUPPLY_GASEOUS
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_del_medium_supply_gaseous() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_del_medium_supply_gaseous()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
deleted_id=citydb_pkg.utn9_delete_medium_supply(OLD.id, p_schema_name);
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_del_medium_supply_gaseous (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_MEDIUM_SUPPLY_GASEOUS
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_ins_medium_supply_gaseous() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_ins_medium_supply_gaseous()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	inserted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
inserted_id=citydb_view.utn9_insert_medium_supply_gaseous(
id                       :=NEW.id                       ,
type                     :=NEW.type                     ,
cur_flow_rate     :=NEW.cur_flow_rate     ,
cur_flow_rate_unit:=NEW.cur_flow_rate_unit,
cur_status        :=NEW.cur_status        ,
pot_flow_rate     :=NEW.pot_flow_rate     ,
pot_flow_rate_unit:=NEW.pot_flow_rate_unit,
pot_status        :=NEW.pot_status        ,
cityobject_id            :=NEW.cityobject_id            ,
--
schema_name          :=p_schema_name
);
--RAISE NOTICE 'Inserted record with id: %', inserted_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_ins_medium_supply_gaseous (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_MEDIUM_SUPPLY_GASEOUS
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_upd_medium_supply_gaseous() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_upd_medium_supply_gaseous()
  RETURNS trigger AS
$BODY$
DECLARE
  p_schema_name varchar DEFAULT 'citydb'::varchar;
  updated_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
EXECUTE format('UPDATE %I.utn9_medium_supply AS t SET
id                       =%L,
type                     =%L,
cur_flow_rate     =%L,
cur_flow_rate_unit=%L,
cur_status        =%L,
pot_flow_rate     =%L,
pot_flow_rate_unit=%L,
pot_status        =%L,
cityobject_id            =%L
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.id                       ,
NEW.type                     ,
NEW.cur_flow_rate     ,
NEW.cur_flow_rate_unit,
NEW.cur_status        ,
NEW.pot_flow_rate     ,
NEW.pot_flow_rate_unit,
NEW.pot_status        ,
NEW.cityobject_id            ,
OLD.id
) INTO updated_id;
-- RAISE NOTICE 'Updated record with id: %', updated_id;
RETURN NEW;
EXCEPTION
  WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_upd_medium_supply_gaseous (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view UTN_MEDIUM_SUPPLY_GASEOUS
----------------------------------------------------------------
DROP TRIGGER IF EXISTS utn9_tr_del_medium_supply_gaseous ON citydb_view.utn9_medium_supply_gaseous;
CREATE TRIGGER utn9_tr_del_medium_supply_gaseous
	INSTEAD OF DELETE ON citydb_view.utn9_medium_supply_gaseous
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_del_medium_supply_gaseous ('citydb');

DROP TRIGGER IF EXISTS utn9_tr_ins_medium_supply_gaseous ON citydb_view.utn9_medium_supply_gaseous;
CREATE TRIGGER utn9_tr_ins_medium_supply_gaseous
	INSTEAD OF INSERT ON citydb_view.utn9_medium_supply_gaseous
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_ins_medium_supply_gaseous ('citydb');

DROP TRIGGER IF EXISTS utn9_tr_upd_medium_supply_gaseous ON citydb_view.utn9_medium_supply_gaseous;
CREATE TRIGGER utn9_tr_upd_medium_supply_gaseous
	INSTEAD OF UPDATE ON citydb_view.utn9_medium_supply_gaseous
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_upd_medium_supply_gaseous ('citydb');
--**************************************************************
--**************************************************************

----------------------------------------------------------------
-- Function TR_DEL_MEDIUM_SUPPLY_LIQUID
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_del_medium_supply_liquid() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_del_medium_supply_liquid()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
deleted_id=citydb_pkg.utn9_delete_medium_supply(OLD.id, p_schema_name);
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_del_medium_supply_liquid (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_MEDIUM_SUPPLY_LIQUID
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_ins_medium_supply_liquid() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_ins_medium_supply_liquid()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	inserted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
inserted_id=citydb_view.utn9_insert_medium_supply_liquid(
id                       :=NEW.id                       ,
type                     :=NEW.type                     ,
cur_flow_rate     :=NEW.cur_flow_rate     ,
cur_flow_rate_unit:=NEW.cur_flow_rate_unit,
cur_status        :=NEW.cur_status        ,
pot_flow_rate     :=NEW.pot_flow_rate     ,
pot_flow_rate_unit:=NEW.pot_flow_rate_unit,
pot_status        :=NEW.pot_status        ,
cityobject_id            :=NEW.cityobject_id            ,
--
schema_name          :=p_schema_name
);
--RAISE NOTICE 'Inserted record with id: %', inserted_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_ins_medium_supply_liquid (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_MEDIUM_SUPPLY_LIQUID
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_upd_medium_supply_liquid() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_upd_medium_supply_liquid()
  RETURNS trigger AS
$BODY$
DECLARE
  p_schema_name varchar DEFAULT 'citydb'::varchar;
  updated_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
EXECUTE format('UPDATE %I.utn9_medium_supply AS t SET
id                       =%L,
type                     =%L,
cur_flow_rate     =%L,
cur_flow_rate_unit=%L,
cur_status        =%L,
pot_flow_rate     =%L,
pot_flow_rate_unit=%L,
pot_status        =%L,
cityobject_id            =%L
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.id                       ,
NEW.type                     ,
NEW.cur_flow_rate     ,
NEW.cur_flow_rate_unit,
NEW.cur_status        ,
NEW.pot_flow_rate     ,
NEW.pot_flow_rate_unit,
NEW.pot_status        ,
NEW.cityobject_id            ,
OLD.id
) INTO updated_id;
-- RAISE NOTICE 'Updated record with id: %', updated_id;
RETURN NEW;
EXCEPTION
  WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_upd_medium_supply_liquid (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view UTN_MEDIUM_SUPPLY_LIQUID
----------------------------------------------------------------
DROP TRIGGER IF EXISTS utn9_tr_del_medium_supply_liquid ON citydb_view.utn9_medium_supply_liquid;
CREATE TRIGGER utn9_tr_del_medium_supply_liquid
	INSTEAD OF DELETE ON citydb_view.utn9_medium_supply_liquid
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_del_medium_supply_liquid ('citydb');

DROP TRIGGER IF EXISTS utn9_tr_ins_medium_supply_liquid ON citydb_view.utn9_medium_supply_liquid;
CREATE TRIGGER utn9_tr_ins_medium_supply_liquid
	INSTEAD OF INSERT ON citydb_view.utn9_medium_supply_liquid
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_ins_medium_supply_liquid ('citydb');

DROP TRIGGER IF EXISTS utn9_tr_upd_medium_supply_liquid ON citydb_view.utn9_medium_supply_liquid;
CREATE TRIGGER utn9_tr_upd_medium_supply_liquid
	INSTEAD OF UPDATE ON citydb_view.utn9_medium_supply_liquid
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_upd_medium_supply_liquid ('citydb');
--**************************************************************
--**************************************************************

----------------------------------------------------------------
-- Function TR_DEL_MEDIUM_SUPPLY_OPTICAL
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_del_medium_supply_optical() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_del_medium_supply_optical()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
deleted_id=citydb_pkg.utn9_delete_medium_supply(OLD.id, p_schema_name);
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_del_medium_supply_optical (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_MEDIUM_SUPPLY_OPTICAL
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_ins_medium_supply_optical() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_ins_medium_supply_optical()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	inserted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
inserted_id=citydb_view.utn9_insert_medium_supply_optical(
id                       :=NEW.id                       ,
type                     :=NEW.type                     ,
cur_flow_rate     :=NEW.cur_flow_rate     ,
cur_flow_rate_unit:=NEW.cur_flow_rate_unit,
cur_status        :=NEW.cur_status        ,
pot_flow_rate     :=NEW.pot_flow_rate     ,
pot_flow_rate_unit:=NEW.pot_flow_rate_unit,
pot_status        :=NEW.pot_status        ,
cityobject_id            :=NEW.cityobject_id            ,
--
schema_name          :=p_schema_name
);
--RAISE NOTICE 'Inserted record with id: %', inserted_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_ins_medium_supply_optical (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_MEDIUM_SUPPLY_OPTICAL
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_upd_medium_supply_optical() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_upd_medium_supply_optical()
  RETURNS trigger AS
$BODY$
DECLARE
  p_schema_name varchar DEFAULT 'citydb'::varchar;
  updated_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
EXECUTE format('UPDATE %I.utn9_medium_supply AS t SET
id                       =%L,
type                     =%L,
cur_flow_rate     =%L,
cur_flow_rate_unit=%L,
cur_status        =%L,
pot_flow_rate     =%L,
pot_flow_rate_unit=%L,
pot_status        =%L,
cityobject_id            =%L
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.id                       ,
NEW.type                     ,
NEW.cur_flow_rate     ,
NEW.cur_flow_rate_unit,
NEW.cur_status        ,
NEW.pot_flow_rate     ,
NEW.pot_flow_rate_unit,
NEW.pot_status        ,
NEW.cityobject_id            ,
OLD.id
) INTO updated_id;
-- RAISE NOTICE 'Updated record with id: %', updated_id;
RETURN NEW;
EXCEPTION
  WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_upd_medium_supply_optical (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view UTN_MEDIUM_SUPPLY_OPTICAL
----------------------------------------------------------------
DROP TRIGGER IF EXISTS utn9_tr_del_medium_supply_optical ON citydb_view.utn9_medium_supply_optical;
CREATE TRIGGER utn9_tr_del_medium_supply_optical
	INSTEAD OF DELETE ON citydb_view.utn9_medium_supply_optical
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_del_medium_supply_optical ('citydb');

DROP TRIGGER IF EXISTS utn9_tr_ins_medium_supply_optical ON citydb_view.utn9_medium_supply_optical;
CREATE TRIGGER utn9_tr_ins_medium_supply_optical
	INSTEAD OF INSERT ON citydb_view.utn9_medium_supply_optical
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_ins_medium_supply_optical ('citydb');

DROP TRIGGER IF EXISTS utn9_tr_upd_medium_supply_optical ON citydb_view.utn9_medium_supply_optical;
CREATE TRIGGER utn9_tr_upd_medium_supply_optical
	INSTEAD OF UPDATE ON citydb_view.utn9_medium_supply_optical
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_upd_medium_supply_optical ('citydb');
--**************************************************************
--**************************************************************

----------------------------------------------------------------
-- Function TR_DEL_MEDIUM_SUPPLY_SOLID
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_del_medium_supply_solid() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_del_medium_supply_solid()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
deleted_id=citydb_pkg.utn9_delete_medium_supply(OLD.id, p_schema_name);
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_del_medium_supply_solid (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_MEDIUM_SUPPLY_SOLID
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_ins_medium_supply_solid() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_ins_medium_supply_solid()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	inserted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
inserted_id=citydb_view.utn9_insert_medium_supply_solid(
id                       :=NEW.id                       ,
type                     :=NEW.type                     ,
cur_flow_rate     :=NEW.cur_flow_rate     ,
cur_flow_rate_unit:=NEW.cur_flow_rate_unit,
cur_status        :=NEW.cur_status        ,
pot_flow_rate     :=NEW.pot_flow_rate     ,
pot_flow_rate_unit:=NEW.pot_flow_rate_unit,
pot_status        :=NEW.pot_status        ,
cityobject_id            :=NEW.cityobject_id            ,
--
schema_name          :=p_schema_name
);
--RAISE NOTICE 'Inserted record with id: %', inserted_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_ins_medium_supply_solid (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_MEDIUM_SUPPLY_SOLID
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_upd_medium_supply_solid() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_upd_medium_supply_solid()
  RETURNS trigger AS
$BODY$
DECLARE
  p_schema_name varchar DEFAULT 'citydb'::varchar;
  updated_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
EXECUTE format('UPDATE %I.utn9_medium_supply AS t SET
id                       =%L,
type                     =%L,
cur_flow_rate     =%L,
cur_flow_rate_unit=%L,
cur_status        =%L,
pot_flow_rate     =%L,
pot_flow_rate_unit=%L,
pot_status        =%L,
cityobject_id            =%L
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.id                       ,
NEW.type                     ,
NEW.cur_flow_rate     ,
NEW.cur_flow_rate_unit,
NEW.cur_status        ,
NEW.pot_flow_rate     ,
NEW.pot_flow_rate_unit,
NEW.pot_status        ,
NEW.cityobject_id            ,
OLD.id
) INTO updated_id;
-- RAISE NOTICE 'Updated record with id: %', updated_id;
RETURN NEW;
EXCEPTION
  WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_upd_medium_supply_solid (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view UTN_MEDIUM_SUPPLY_SOLID
----------------------------------------------------------------
DROP TRIGGER IF EXISTS utn9_tr_del_medium_supply_solid ON citydb_view.utn9_medium_supply_solid;
CREATE TRIGGER utn9_tr_del_medium_supply_solid
	INSTEAD OF DELETE ON citydb_view.utn9_medium_supply_solid
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_del_medium_supply_solid ('citydb');

DROP TRIGGER IF EXISTS utn9_tr_ins_medium_supply_solid ON citydb_view.utn9_medium_supply_solid;
CREATE TRIGGER utn9_tr_ins_medium_supply_solid
	INSTEAD OF INSERT ON citydb_view.utn9_medium_supply_solid
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_ins_medium_supply_solid ('citydb');

DROP TRIGGER IF EXISTS utn9_tr_upd_medium_supply_solid ON citydb_view.utn9_medium_supply_solid;
CREATE TRIGGER utn9_tr_upd_medium_supply_solid
	INSTEAD OF UPDATE ON citydb_view.utn9_medium_supply_solid
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_upd_medium_supply_solid ('citydb');
--**************************************************************
--**************************************************************

----------------------------------------------------------------
-- Function TR_DEL_NETWORK
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_del_network() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_del_network()
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
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_del_network (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_NETWORK
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_ins_network() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_ins_network()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	inserted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
inserted_id=citydb_view.utn9_insert_network(
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
--
network_parent_id :=NEW.network_parent_id,
network_root_id   :=NEW.network_root_id  ,
class             :=NEW.class            ,
function          :=NEW.function         ,
usage             :=NEW.usage            ,
commodity_id      :=NEW.commodity_id     ,
--
schema_name                  :=p_schema_name
);
--RAISE NOTICE 'Inserted record with id: %', inserted_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_ins_network (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_NETWORK
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_upd_network() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_upd_network()
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

EXECUTE format('UPDATE %I.utn9_network AS t SET
network_parent_id =%L,
network_root_id   =%L,
class             =%L,
function          =%L,
usage             =%L,
commodity_id      =%L
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.network_parent_id,
NEW.network_root_id  ,
NEW.class            ,
NEW.function         ,
NEW.usage            ,
NEW.commodity_id     ,
OLD.id
) INTO updated_id;
-- RAISE NOTICE 'Updated record with id: %',updated_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_upd_network (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view NETWORK
----------------------------------------------------------------
DROP TRIGGER IF EXISTS utn9_tr_del_network ON citydb_view.utn9_network;
CREATE TRIGGER utn9_tr_del_network
	INSTEAD OF DELETE ON citydb_view.utn9_network
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_del_network ('citydb');

DROP TRIGGER IF EXISTS utn9_tr_ins_network ON citydb_view.utn9_network;
CREATE TRIGGER utn9_tr_ins_network
	INSTEAD OF INSERT ON citydb_view.utn9_network
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_ins_network ('citydb');

DROP TRIGGER IF EXISTS utn9_tr_upd_network ON citydb_view.utn9_network;
CREATE TRIGGER utn9_tr_upd_network
	INSTEAD OF UPDATE ON citydb_view.utn9_network
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_upd_network ('citydb');
--**************************************************************
--**************************************************************

----------------------------------------------------------------
-- Function TR_DEL_FEATURE_GRAPH
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_del_feature_graph() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_del_feature_graph()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
deleted_id=citydb_pkg.utn9_delete_feature_graph(OLD.id, p_schema_name);
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_del_feature_graph (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_FEATURE_GRAPH
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_ins_feature_graph() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_ins_feature_graph()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	inserted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
inserted_id=citydb_view.utn9_insert_feature_graph(
id              :=NEW.id             ,
gmlid           :=NEW.gmlid          ,
gmlid_codespace :=NEW.gmlid_codespace,
name            :=NEW.name           ,
name_codespace  :=NEW.name_codespace ,
description     :=NEW.description    ,
ntw_feature_id  :=NEW.ntw_feature_id ,
ntw_graph_id    :=NEW.ntw_graph_id   ,
--
schema_name          :=p_schema_name
);
--RAISE NOTICE 'Inserted record with id: %', inserted_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_ins_feature_graph (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_FEATURE_GRAPH
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_upd_feature_graph() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_upd_feature_graph()
  RETURNS trigger AS
$BODY$
DECLARE
  p_schema_name varchar DEFAULT 'citydb'::varchar;
  updated_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
EXECUTE format('UPDATE %I.utn9_feature_graph AS t SET
id             =%L,
gmlid          =%L,
gmlid_codespace=%L,
name           =%L,
name_codespace =%L,
description    =%L,
ntw_feature_id =%L,
ntw_graph_id   =%L
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.id             ,
NEW.gmlid          ,
NEW.gmlid_codespace,
NEW.name           ,
NEW.name_codespace ,
NEW.description    ,
NEW.ntw_feature_id ,
NEW.ntw_graph_id   ,
OLD.id
) INTO updated_id;
-- RAISE NOTICE 'Updated record with id: %', updated_id;
RETURN NEW;
EXCEPTION
  WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_upd_feature_graph (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view UTN_FEATURE_GRAPH
----------------------------------------------------------------
DROP TRIGGER IF EXISTS utn9_tr_del_feature_graph ON citydb_view.utn9_feature_graph;
CREATE TRIGGER utn9_tr_del_feature_graph
	INSTEAD OF DELETE ON citydb_view.utn9_feature_graph
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_del_feature_graph ('citydb');

DROP TRIGGER IF EXISTS utn9_tr_ins_feature_graph ON citydb_view.utn9_feature_graph;
CREATE TRIGGER utn9_tr_ins_feature_graph
	INSTEAD OF INSERT ON citydb_view.utn9_feature_graph
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_ins_feature_graph ('citydb');

DROP TRIGGER IF EXISTS utn9_tr_upd_feature_graph ON citydb_view.utn9_feature_graph;
CREATE TRIGGER utn9_tr_upd_feature_graph
	INSTEAD OF UPDATE ON citydb_view.utn9_feature_graph
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_upd_feature_graph ('citydb');
--**************************************************************
--**************************************************************

----------------------------------------------------------------
-- Function TR_DEL_NODE
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_del_node() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_del_node()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
deleted_id=citydb_pkg.utn9_delete_node(OLD.id, p_schema_name);
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_del_node (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_NODE
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_ins_node() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_ins_node()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	inserted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
inserted_id=citydb_view.utn9_insert_node(
id                  :=NEW.id                  ,
gmlid               :=NEW.gmlid               ,
gmlid_codespace     :=NEW.gmlid_codespace     ,
name                :=NEW.name                ,
name_codespace      :=NEW.name_codespace      ,
description         :=NEW.description         ,
type                :=NEW.type                ,
connection_signature:=NEW.connection_signature,
link_control        :=NEW.link_control        ,
feat_graph_id       :=NEW.feat_graph_id       ,
point_geom          :=NEW.point_geom          ,
--
schema_name          :=p_schema_name
);
--RAISE NOTICE 'Inserted record with id: %', inserted_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_ins_node (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_NODE
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_upd_node() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_upd_node()
  RETURNS trigger AS
$BODY$
DECLARE
  p_schema_name varchar DEFAULT 'citydb'::varchar;
  updated_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
EXECUTE format('UPDATE %I.utn9_node AS t SET
id                  =%L,
gmlid               =%L,
gmlid_codespace     =%L,
name                =%L,
name_codespace      =%L,
description         =%L,
type                =%L,
connection_signature=%L,
link_control        =%L,
feat_graph_id       =%L,
point_geom          =%L
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.id                  ,
NEW.gmlid               ,
NEW.gmlid_codespace     ,
NEW.name                ,
NEW.name_codespace      ,
NEW.description         ,
NEW.type                ,
NEW.connection_signature,
NEW.link_control        ,
NEW.feat_graph_id       ,
NEW.point_geom          ,
OLD.id
) INTO updated_id;
-- RAISE NOTICE 'Updated record with id: %', updated_id;
RETURN NEW;
EXCEPTION
  WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_upd_node (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view UTN_NODE
----------------------------------------------------------------
DROP TRIGGER IF EXISTS utn9_tr_del_node ON citydb_view.utn9_node;
CREATE TRIGGER utn9_tr_del_node
	INSTEAD OF DELETE ON citydb_view.utn9_node
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_del_node ('citydb');

DROP TRIGGER IF EXISTS utn9_tr_ins_node ON citydb_view.utn9_node;
CREATE TRIGGER utn9_tr_ins_node
	INSTEAD OF INSERT ON citydb_view.utn9_node
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_ins_node ('citydb');

DROP TRIGGER IF EXISTS utn9_tr_upd_node ON citydb_view.utn9_node;
CREATE TRIGGER utn9_tr_upd_node
	INSTEAD OF UPDATE ON citydb_view.utn9_node
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_upd_node ('citydb');
--**************************************************************
--**************************************************************

----------------------------------------------------------------
-- Function TR_DEL_NTW_FEAT_COMPLEX_FUNCT_ELEM
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_del_ntw_feat_complex_funct_elem() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_del_ntw_feat_complex_funct_elem()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
deleted_id=citydb_pkg.utn9_delete_network_feature(OLD.id, p_schema_name);
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_del_ntw_feat_complex_funct_elem (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_NTW_FEAT_COMPLEX_FUNCT_ELEM
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_ins_ntw_feat_complex_funct_elem() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_ins_ntw_feat_complex_funct_elem()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	inserted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;

inserted_id=citydb_view.utn9_insert_ntw_feat_complex_funct_elem(
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
--
ntw_feature_parent_id:=NEW.ntw_feature_parent_id,
ntw_feature_root_id  :=NEW.ntw_feature_root_id  ,
class                :=NEW.class                ,
function             :=NEW.function             ,
usage                :=NEW.usage                ,
year_of_construction :=NEW.year_of_construction ,
status               :=NEW.status               ,
location_quality     :=NEW.location_quality     ,
elevation_quality    :=NEW.elevation_quality    ,
conn_cityobject_id   :=NEW.conn_cityobject_id   ,
prot_element_id      :=NEW.prot_element_id      ,
geom                 :=NEW.geom                 ,
--
schema_name                  :=p_schema_name
);
--RAISE NOTICE 'Inserted record with id: %', inserted_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_ins_ntw_feat_complex_funct_elem (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_NTW_FEAT_COMPLEX_FUNCT_ELEM
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_upd_ntw_feat_complex_funct_elem() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_upd_ntw_feat_complex_funct_elem()
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

EXECUTE format('UPDATE %I.utn9_network_feature AS t SET
ntw_feature_parent_id =%L,
ntw_feature_root_id   =%L,
class                 =%L,
function              =%L,
usage                 =%L,
year_of_construction  =%L,
status                =%L,
location_quality      =%L,
elevation_quality     =%L,
conn_cityobject_id    =%L,
prot_element_id       =%L,
geom                  =%L
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.ntw_feature_parent_id,
NEW.ntw_feature_root_id  ,
NEW.class                ,
NEW.function             ,
NEW.usage                ,
NEW.year_of_construction ,
NEW.status               ,
NEW.location_quality     ,
NEW.elevation_quality    ,
NEW.conn_cityobject_id   ,
NEW.prot_element_id      ,
NEW.geom                 ,
OLD.id
) INTO updated_id;
-- RAISE NOTICE 'Updated record with id: %',updated_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_upd_ntw_feat_complex_funct_elem (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view NTW_FEAT_COMPLEX_FUNCT_ELEM
----------------------------------------------------------------
DROP TRIGGER IF EXISTS utn9_tr_del_ntw_feat_complex_funct_elem ON citydb_view.utn9_ntw_feat_complex_funct_elem;
CREATE TRIGGER utn9_tr_del_ntw_feat_complex_funct_elem
	INSTEAD OF DELETE ON citydb_view.utn9_ntw_feat_complex_funct_elem
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_del_ntw_feat_complex_funct_elem ('citydb');

DROP TRIGGER IF EXISTS utn9_tr_ins_ntw_feat_complex_funct_elem ON citydb_view.utn9_ntw_feat_complex_funct_elem;
CREATE TRIGGER utn9_tr_ins_ntw_feat_complex_funct_elem
	INSTEAD OF INSERT ON citydb_view.utn9_ntw_feat_complex_funct_elem
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_ins_ntw_feat_complex_funct_elem ('citydb');

DROP TRIGGER IF EXISTS utn9_tr_upd_ntw_feat_complex_funct_elem ON citydb_view.utn9_ntw_feat_complex_funct_elem;
CREATE TRIGGER utn9_tr_upd_ntw_feat_complex_funct_elem
	INSTEAD OF UPDATE ON citydb_view.utn9_ntw_feat_complex_funct_elem
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_upd_ntw_feat_complex_funct_elem ('citydb');
--**************************************************************
--**************************************************************

----------------------------------------------------------------
-- Function TR_DEL_NTW_FEAT_SIMPLE_FUNCT_ELEM
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_del_ntw_feat_simple_funct_elem() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_del_ntw_feat_simple_funct_elem()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
deleted_id=citydb_pkg.utn9_delete_network_feature(OLD.id, p_schema_name);
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_del_ntw_feat_simple_funct_elem (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_NTW_FEAT_SIMPLE_FUNCT_ELEM
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_ins_ntw_feat_simple_funct_elem() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_ins_ntw_feat_simple_funct_elem()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	inserted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;

inserted_id=citydb_view.utn9_insert_ntw_feat_simple_funct_elem(
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
--
ntw_feature_parent_id:=NEW.ntw_feature_parent_id,
ntw_feature_root_id  :=NEW.ntw_feature_root_id  ,
class                :=NEW.class                ,
function             :=NEW.function             ,
usage                :=NEW.usage                ,
year_of_construction :=NEW.year_of_construction ,
status               :=NEW.status               ,
location_quality     :=NEW.location_quality     ,
elevation_quality    :=NEW.elevation_quality    ,
conn_cityobject_id   :=NEW.conn_cityobject_id   ,
prot_element_id      :=NEW.prot_element_id      ,
geom                 :=NEW.geom                 ,
--
schema_name                  :=p_schema_name
);
--RAISE NOTICE 'Inserted record with id: %', inserted_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_ins_ntw_feat_simple_funct_elem (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_NTW_FEAT_SIMPLE_FUNCT_ELEM
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_upd_ntw_feat_simple_funct_elem() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_upd_ntw_feat_simple_funct_elem()
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

EXECUTE format('UPDATE %I.utn9_network_feature AS t SET
ntw_feature_parent_id =%L,
ntw_feature_root_id   =%L,
class                 =%L,
function              =%L,
usage                 =%L,
year_of_construction  =%L,
status                =%L,
location_quality      =%L,
elevation_quality     =%L,
conn_cityobject_id    =%L,
prot_element_id       =%L,
geom                  =%L
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.ntw_feature_parent_id,
NEW.ntw_feature_root_id  ,
NEW.class                ,
NEW.function             ,
NEW.usage                ,
NEW.year_of_construction ,
NEW.status               ,
NEW.location_quality     ,
NEW.elevation_quality    ,
NEW.conn_cityobject_id   ,
NEW.prot_element_id      ,
NEW.geom                 ,
OLD.id
) INTO updated_id;
-- RAISE NOTICE 'Updated record with id: %',updated_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_upd_ntw_feat_simple_funct_elem (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view NTW_FEAT_SIMPLE_FUNCT_ELEM
----------------------------------------------------------------
DROP TRIGGER IF EXISTS utn9_tr_del_ntw_feat_simple_funct_elem ON citydb_view.utn9_ntw_feat_simple_funct_elem;
CREATE TRIGGER utn9_tr_del_ntw_feat_simple_funct_elem
	INSTEAD OF DELETE ON citydb_view.utn9_ntw_feat_simple_funct_elem
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_del_ntw_feat_simple_funct_elem ('citydb');

DROP TRIGGER IF EXISTS utn9_tr_ins_ntw_feat_simple_funct_elem ON citydb_view.utn9_ntw_feat_simple_funct_elem;
CREATE TRIGGER utn9_tr_ins_ntw_feat_simple_funct_elem
	INSTEAD OF INSERT ON citydb_view.utn9_ntw_feat_simple_funct_elem
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_ins_ntw_feat_simple_funct_elem ('citydb');

DROP TRIGGER IF EXISTS utn9_tr_upd_ntw_feat_simple_funct_elem ON citydb_view.utn9_ntw_feat_simple_funct_elem;
CREATE TRIGGER utn9_tr_upd_ntw_feat_simple_funct_elem
	INSTEAD OF UPDATE ON citydb_view.utn9_ntw_feat_simple_funct_elem
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_upd_ntw_feat_simple_funct_elem ('citydb');
--**************************************************************
--**************************************************************

----------------------------------------------------------------
-- Function TR_DEL_NTW_FEAT_TERM_ELEM
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_del_ntw_feat_term_elem() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_del_ntw_feat_term_elem()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
deleted_id=citydb_pkg.utn9_delete_network_feature(OLD.id, p_schema_name);
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_del_ntw_feat_term_elem (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_NTW_FEAT_TERM_ELEM
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_ins_ntw_feat_term_elem() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_ins_ntw_feat_term_elem()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	inserted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;

inserted_id=citydb_view.utn9_insert_ntw_feat_term_elem(
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
--
ntw_feature_parent_id:=NEW.ntw_feature_parent_id,
ntw_feature_root_id  :=NEW.ntw_feature_root_id  ,
class                :=NEW.class                ,
function             :=NEW.function             ,
usage                :=NEW.usage                ,
year_of_construction :=NEW.year_of_construction ,
status               :=NEW.status               ,
location_quality     :=NEW.location_quality     ,
elevation_quality    :=NEW.elevation_quality    ,
conn_cityobject_id   :=NEW.conn_cityobject_id   ,
prot_element_id      :=NEW.prot_element_id      ,
geom                 :=NEW.geom                 ,
--
schema_name                  :=p_schema_name
);
--RAISE NOTICE 'Inserted record with id: %', inserted_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_ins_ntw_feat_term_elem (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_NTW_FEAT_TERM_ELEM
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_upd_ntw_feat_term_elem() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_upd_ntw_feat_term_elem()
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

EXECUTE format('UPDATE %I.utn9_network_feature AS t SET
ntw_feature_parent_id =%L,
ntw_feature_root_id   =%L,
class                 =%L,
function              =%L,
usage                 =%L,
year_of_construction  =%L,
status                =%L,
location_quality      =%L,
elevation_quality     =%L,
conn_cityobject_id    =%L,
prot_element_id       =%L,
geom                  =%L
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.ntw_feature_parent_id,
NEW.ntw_feature_root_id  ,
NEW.class                ,
NEW.function             ,
NEW.usage                ,
NEW.year_of_construction ,
NEW.status               ,
NEW.location_quality     ,
NEW.elevation_quality    ,
NEW.conn_cityobject_id   ,
NEW.prot_element_id      ,
NEW.geom                 ,
OLD.id
) INTO updated_id;
-- RAISE NOTICE 'Updated record with id: %',updated_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_upd_ntw_feat_term_elem (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view NTW_FEAT_TERM_ELEM
----------------------------------------------------------------
DROP TRIGGER IF EXISTS utn9_tr_del_ntw_feat_term_elem ON citydb_view.utn9_ntw_feat_term_elem;
CREATE TRIGGER utn9_tr_del_ntw_feat_term_elem
	INSTEAD OF DELETE ON citydb_view.utn9_ntw_feat_term_elem
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_del_ntw_feat_term_elem ('citydb');

DROP TRIGGER IF EXISTS utn9_tr_ins_ntw_feat_term_elem ON citydb_view.utn9_ntw_feat_term_elem;
CREATE TRIGGER utn9_tr_ins_ntw_feat_term_elem
	INSTEAD OF INSERT ON citydb_view.utn9_ntw_feat_term_elem
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_ins_ntw_feat_term_elem ('citydb');

DROP TRIGGER IF EXISTS utn9_tr_upd_ntw_feat_term_elem ON citydb_view.utn9_ntw_feat_term_elem;
CREATE TRIGGER utn9_tr_upd_ntw_feat_term_elem
	INSTEAD OF UPDATE ON citydb_view.utn9_ntw_feat_term_elem
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_upd_ntw_feat_term_elem ('citydb');
--**************************************************************
--**************************************************************

----------------------------------------------------------------
-- Function TR_DEL_NTW_FEAT_DEVICE_CONTROLLER
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_del_ntw_feat_device_controller() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_del_ntw_feat_device_controller()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
deleted_id=citydb_pkg.utn9_delete_network_feature(OLD.id, p_schema_name);
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_del_ntw_feat_device_controller (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_NTW_FEAT_DEVICE_CONTROLLER
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_ins_ntw_feat_device_controller() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_ins_ntw_feat_device_controller()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	inserted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;

inserted_id=citydb_view.utn9_insert_ntw_feat_device_controller(
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
--
ntw_feature_parent_id:=NEW.ntw_feature_parent_id,
ntw_feature_root_id  :=NEW.ntw_feature_root_id  ,
class                :=NEW.class                ,
function             :=NEW.function             ,
usage                :=NEW.usage                ,
year_of_construction :=NEW.year_of_construction ,
status               :=NEW.status               ,
location_quality     :=NEW.location_quality     ,
elevation_quality    :=NEW.elevation_quality    ,
conn_cityobject_id   :=NEW.conn_cityobject_id   ,
prot_element_id      :=NEW.prot_element_id      ,
geom                 :=NEW.geom                 ,
--
schema_name                  :=p_schema_name
);
--RAISE NOTICE 'Inserted record with id: %', inserted_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_ins_ntw_feat_device_controller (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_NTW_FEAT_DEVICE_CONTROLLER
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_upd_ntw_feat_device_controller() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_upd_ntw_feat_device_controller()
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

EXECUTE format('UPDATE %I.utn9_network_feature AS t SET
ntw_feature_parent_id =%L,
ntw_feature_root_id   =%L,
class                 =%L,
function              =%L,
usage                 =%L,
year_of_construction  =%L,
status                =%L,
location_quality      =%L,
elevation_quality     =%L,
conn_cityobject_id    =%L,
prot_element_id       =%L,
geom                  =%L
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.ntw_feature_parent_id,
NEW.ntw_feature_root_id  ,
NEW.class                ,
NEW.function             ,
NEW.usage                ,
NEW.year_of_construction ,
NEW.status               ,
NEW.location_quality     ,
NEW.elevation_quality    ,
NEW.conn_cityobject_id   ,
NEW.prot_element_id      ,
NEW.geom                 ,
OLD.id
) INTO updated_id;
-- RAISE NOTICE 'Updated record with id: %',updated_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_upd_ntw_feat_device_controller (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view NTW_FEAT_DEVICE_CONTROLLER
----------------------------------------------------------------
DROP TRIGGER IF EXISTS utn9_tr_del_ntw_feat_device_controller ON citydb_view.utn9_ntw_feat_device_controller;
CREATE TRIGGER utn9_tr_del_ntw_feat_device_controller
	INSTEAD OF DELETE ON citydb_view.utn9_ntw_feat_device_controller
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_del_ntw_feat_device_controller ('citydb');

DROP TRIGGER IF EXISTS utn9_tr_ins_ntw_feat_device_controller ON citydb_view.utn9_ntw_feat_device_controller;
CREATE TRIGGER utn9_tr_ins_ntw_feat_device_controller
	INSTEAD OF INSERT ON citydb_view.utn9_ntw_feat_device_controller
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_ins_ntw_feat_device_controller ('citydb');

DROP TRIGGER IF EXISTS utn9_tr_upd_ntw_feat_device_controller ON citydb_view.utn9_ntw_feat_device_controller;
CREATE TRIGGER utn9_tr_upd_ntw_feat_device_controller
	INSTEAD OF UPDATE ON citydb_view.utn9_ntw_feat_device_controller
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_upd_ntw_feat_device_controller ('citydb');
--**************************************************************
--**************************************************************

----------------------------------------------------------------
-- Function TR_DEL_NTW_FEAT_DEVICE_GENERIC
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_del_ntw_feat_device_generic() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_del_ntw_feat_device_generic()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
deleted_id=citydb_pkg.utn9_delete_network_feature(OLD.id, p_schema_name);
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_del_ntw_feat_device_generic (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_NTW_FEAT_DEVICE_GENERIC
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_ins_ntw_feat_device_generic() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_ins_ntw_feat_device_generic()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	inserted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;

inserted_id=citydb_view.utn9_insert_ntw_feat_device_generic(
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
--
ntw_feature_parent_id:=NEW.ntw_feature_parent_id,
ntw_feature_root_id  :=NEW.ntw_feature_root_id  ,
class                :=NEW.class                ,
function             :=NEW.function             ,
usage                :=NEW.usage                ,
year_of_construction :=NEW.year_of_construction ,
status               :=NEW.status               ,
location_quality     :=NEW.location_quality     ,
elevation_quality    :=NEW.elevation_quality    ,
conn_cityobject_id   :=NEW.conn_cityobject_id   ,
prot_element_id      :=NEW.prot_element_id      ,
geom                 :=NEW.geom                 ,
--
schema_name                  :=p_schema_name
);
--RAISE NOTICE 'Inserted record with id: %', inserted_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_ins_ntw_feat_device_generic (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_NTW_FEAT_DEVICE_GENERIC
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_upd_ntw_feat_device_generic() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_upd_ntw_feat_device_generic()
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

EXECUTE format('UPDATE %I.utn9_network_feature AS t SET
ntw_feature_parent_id =%L,
ntw_feature_root_id   =%L,
class                 =%L,
function              =%L,
usage                 =%L,
year_of_construction  =%L,
status                =%L,
location_quality      =%L,
elevation_quality     =%L,
conn_cityobject_id    =%L,
prot_element_id       =%L,
geom                  =%L
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.ntw_feature_parent_id,
NEW.ntw_feature_root_id  ,
NEW.class                ,
NEW.function             ,
NEW.usage                ,
NEW.year_of_construction ,
NEW.status               ,
NEW.location_quality     ,
NEW.elevation_quality    ,
NEW.conn_cityobject_id   ,
NEW.prot_element_id      ,
NEW.geom                 ,
OLD.id
) INTO updated_id;
-- RAISE NOTICE 'Updated record with id: %',updated_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_upd_ntw_feat_device_generic (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view NTW_FEAT_DEVICE_GENERIC
----------------------------------------------------------------
DROP TRIGGER IF EXISTS utn9_tr_del_ntw_feat_device_generic ON citydb_view.utn9_ntw_feat_device_generic;
CREATE TRIGGER utn9_tr_del_ntw_feat_device_generic
	INSTEAD OF DELETE ON citydb_view.utn9_ntw_feat_device_generic
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_del_ntw_feat_device_generic ('citydb');

DROP TRIGGER IF EXISTS utn9_tr_ins_ntw_feat_device_generic ON citydb_view.utn9_ntw_feat_device_generic;
CREATE TRIGGER utn9_tr_ins_ntw_feat_device_generic
	INSTEAD OF INSERT ON citydb_view.utn9_ntw_feat_device_generic
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_ins_ntw_feat_device_generic ('citydb');

DROP TRIGGER IF EXISTS utn9_tr_upd_ntw_feat_device_generic ON citydb_view.utn9_ntw_feat_device_generic;
CREATE TRIGGER utn9_tr_upd_ntw_feat_device_generic
	INSTEAD OF UPDATE ON citydb_view.utn9_ntw_feat_device_generic
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_upd_ntw_feat_device_generic ('citydb');
--**************************************************************
--**************************************************************

----------------------------------------------------------------
-- Function TR_DEL_NTW_FEAT_DEVICE_MEAS
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_del_ntw_feat_device_meas() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_del_ntw_feat_device_meas()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
deleted_id=citydb_pkg.utn9_delete_network_feature(OLD.id, p_schema_name);
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_del_ntw_feat_device_meas (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_NTW_FEAT_DEVICE_MEAS
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_ins_ntw_feat_device_meas() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_ins_ntw_feat_device_meas()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	inserted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;

inserted_id=citydb_view.utn9_insert_ntw_feat_device_meas(
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
--
ntw_feature_parent_id:=NEW.ntw_feature_parent_id,
ntw_feature_root_id  :=NEW.ntw_feature_root_id  ,
class                :=NEW.class                ,
function             :=NEW.function             ,
usage                :=NEW.usage                ,
year_of_construction :=NEW.year_of_construction ,
status               :=NEW.status               ,
location_quality     :=NEW.location_quality     ,
elevation_quality    :=NEW.elevation_quality    ,
conn_cityobject_id   :=NEW.conn_cityobject_id   ,
prot_element_id      :=NEW.prot_element_id      ,
geom                 :=NEW.geom                 ,
--
schema_name                  :=p_schema_name
);
--RAISE NOTICE 'Inserted record with id: %', inserted_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_ins_ntw_feat_device_meas (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_NTW_FEAT_DEVICE_MEAS
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_upd_ntw_feat_device_meas() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_upd_ntw_feat_device_meas()
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

EXECUTE format('UPDATE %I.utn9_network_feature AS t SET
ntw_feature_parent_id =%L,
ntw_feature_root_id   =%L,
class                 =%L,
function              =%L,
usage                 =%L,
year_of_construction  =%L,
status                =%L,
location_quality      =%L,
elevation_quality     =%L,
conn_cityobject_id    =%L,
prot_element_id       =%L,
geom                  =%L
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.ntw_feature_parent_id,
NEW.ntw_feature_root_id  ,
NEW.class                ,
NEW.function             ,
NEW.usage                ,
NEW.year_of_construction ,
NEW.status               ,
NEW.location_quality     ,
NEW.elevation_quality    ,
NEW.conn_cityobject_id   ,
NEW.prot_element_id      ,
NEW.geom                 ,
OLD.id
) INTO updated_id;
-- RAISE NOTICE 'Updated record with id: %',updated_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_upd_ntw_feat_device_meas (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view NTW_FEAT_DEVICE_MEAS
----------------------------------------------------------------
DROP TRIGGER IF EXISTS utn9_tr_del_ntw_feat_device_meas ON citydb_view.utn9_ntw_feat_device_meas;
CREATE TRIGGER utn9_tr_del_ntw_feat_device_meas
	INSTEAD OF DELETE ON citydb_view.utn9_ntw_feat_device_meas
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_del_ntw_feat_device_meas ('citydb');

DROP TRIGGER IF EXISTS utn9_tr_ins_ntw_feat_device_meas ON citydb_view.utn9_ntw_feat_device_meas;
CREATE TRIGGER utn9_tr_ins_ntw_feat_device_meas
	INSTEAD OF INSERT ON citydb_view.utn9_ntw_feat_device_meas
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_ins_ntw_feat_device_meas ('citydb');

DROP TRIGGER IF EXISTS utn9_tr_upd_ntw_feat_device_meas ON citydb_view.utn9_ntw_feat_device_meas;
CREATE TRIGGER utn9_tr_upd_ntw_feat_device_meas
	INSTEAD OF UPDATE ON citydb_view.utn9_ntw_feat_device_meas
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_upd_ntw_feat_device_meas ('citydb');
--**************************************************************
--**************************************************************

----------------------------------------------------------------
-- Function TR_DEL_NTW_FEAT_DEVICE_STORAGE
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_del_ntw_feat_device_storage() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_del_ntw_feat_device_storage()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
deleted_id=citydb_pkg.utn9_delete_network_feature(OLD.id, p_schema_name);
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_del_ntw_feat_device_storage (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_NTW_FEAT_DEVICE_STORAGE
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_ins_ntw_feat_device_storage() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_ins_ntw_feat_device_storage()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	inserted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;

inserted_id=citydb_view.utn9_insert_ntw_feat_device_storage(
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
--
ntw_feature_parent_id:=NEW.ntw_feature_parent_id,
ntw_feature_root_id  :=NEW.ntw_feature_root_id  ,
class                :=NEW.class                ,
function             :=NEW.function             ,
usage                :=NEW.usage                ,
year_of_construction :=NEW.year_of_construction ,
status               :=NEW.status               ,
location_quality     :=NEW.location_quality     ,
elevation_quality    :=NEW.elevation_quality    ,
conn_cityobject_id   :=NEW.conn_cityobject_id   ,
prot_element_id      :=NEW.prot_element_id      ,
geom                 :=NEW.geom                 ,
--
schema_name                  :=p_schema_name
);
--RAISE NOTICE 'Inserted record with id: %', inserted_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_ins_ntw_feat_device_storage (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_NTW_FEAT_DEVICE_STORAGE
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_upd_ntw_feat_device_storage() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_upd_ntw_feat_device_storage()
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

EXECUTE format('UPDATE %I.utn9_network_feature AS t SET
ntw_feature_parent_id =%L,
ntw_feature_root_id   =%L,
class                 =%L,
function              =%L,
usage                 =%L,
year_of_construction  =%L,
status                =%L,
location_quality      =%L,
elevation_quality     =%L,
conn_cityobject_id    =%L,
prot_element_id       =%L,
geom                  =%L
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.ntw_feature_parent_id,
NEW.ntw_feature_root_id  ,
NEW.class                ,
NEW.function             ,
NEW.usage                ,
NEW.year_of_construction ,
NEW.status               ,
NEW.location_quality     ,
NEW.elevation_quality    ,
NEW.conn_cityobject_id   ,
NEW.prot_element_id      ,
NEW.geom                 ,
OLD.id
) INTO updated_id;
-- RAISE NOTICE 'Updated record with id: %',updated_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_upd_ntw_feat_device_storage (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view NTW_FEAT_DEVICE_STORAGE
----------------------------------------------------------------
DROP TRIGGER IF EXISTS utn9_tr_del_ntw_feat_device_storage ON citydb_view.utn9_ntw_feat_device_storage;
CREATE TRIGGER utn9_tr_del_ntw_feat_device_storage
	INSTEAD OF DELETE ON citydb_view.utn9_ntw_feat_device_storage
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_del_ntw_feat_device_storage ('citydb');

DROP TRIGGER IF EXISTS utn9_tr_ins_ntw_feat_device_storage ON citydb_view.utn9_ntw_feat_device_storage;
CREATE TRIGGER utn9_tr_ins_ntw_feat_device_storage
	INSTEAD OF INSERT ON citydb_view.utn9_ntw_feat_device_storage
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_ins_ntw_feat_device_storage ('citydb');

DROP TRIGGER IF EXISTS utn9_tr_upd_ntw_feat_device_storage ON citydb_view.utn9_ntw_feat_device_storage;
CREATE TRIGGER utn9_tr_upd_ntw_feat_device_storage
	INSTEAD OF UPDATE ON citydb_view.utn9_ntw_feat_device_storage
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_upd_ntw_feat_device_storage ('citydb');
--**************************************************************
--**************************************************************

----------------------------------------------------------------
-- Function TR_DEL_NTW_FEAT_DEVICE_TECH
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_del_ntw_feat_device_tech() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_del_ntw_feat_device_tech()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
deleted_id=citydb_pkg.utn9_delete_network_feature(OLD.id, p_schema_name);
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_del_ntw_feat_device_tech (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_NTW_FEAT_DEVICE_TECH
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_ins_ntw_feat_device_tech() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_ins_ntw_feat_device_tech()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	inserted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;

inserted_id=citydb_view.utn9_insert_ntw_feat_device_tech(
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
--
ntw_feature_parent_id:=NEW.ntw_feature_parent_id,
ntw_feature_root_id  :=NEW.ntw_feature_root_id  ,
class                :=NEW.class                ,
function             :=NEW.function             ,
usage                :=NEW.usage                ,
year_of_construction :=NEW.year_of_construction ,
status               :=NEW.status               ,
location_quality     :=NEW.location_quality     ,
elevation_quality    :=NEW.elevation_quality    ,
conn_cityobject_id   :=NEW.conn_cityobject_id   ,
prot_element_id      :=NEW.prot_element_id      ,
geom                 :=NEW.geom                 ,
--
schema_name                  :=p_schema_name
);
--RAISE NOTICE 'Inserted record with id: %', inserted_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_ins_ntw_feat_device_tech (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_NTW_FEAT_DEVICE_TECH
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_upd_ntw_feat_device_tech() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_upd_ntw_feat_device_tech()
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

EXECUTE format('UPDATE %I.utn9_network_feature AS t SET
ntw_feature_parent_id =%L,
ntw_feature_root_id   =%L,
class                 =%L,
function              =%L,
usage                 =%L,
year_of_construction  =%L,
status                =%L,
location_quality      =%L,
elevation_quality     =%L,
conn_cityobject_id    =%L,
prot_element_id       =%L,
geom                  =%L
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.ntw_feature_parent_id,
NEW.ntw_feature_root_id  ,
NEW.class                ,
NEW.function             ,
NEW.usage                ,
NEW.year_of_construction ,
NEW.status               ,
NEW.location_quality     ,
NEW.elevation_quality    ,
NEW.conn_cityobject_id   ,
NEW.prot_element_id      ,
NEW.geom                 ,
OLD.id
) INTO updated_id;
-- RAISE NOTICE 'Updated record with id: %',updated_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_upd_ntw_feat_device_tech (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view NTW_FEAT_DEVICE_TECH
----------------------------------------------------------------
DROP TRIGGER IF EXISTS utn9_tr_del_ntw_feat_device_tech ON citydb_view.utn9_ntw_feat_device_tech;
CREATE TRIGGER utn9_tr_del_ntw_feat_device_tech
	INSTEAD OF DELETE ON citydb_view.utn9_ntw_feat_device_tech
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_del_ntw_feat_device_tech ('citydb');

DROP TRIGGER IF EXISTS utn9_tr_ins_ntw_feat_device_tech ON citydb_view.utn9_ntw_feat_device_tech;
CREATE TRIGGER utn9_tr_ins_ntw_feat_device_tech
	INSTEAD OF INSERT ON citydb_view.utn9_ntw_feat_device_tech
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_ins_ntw_feat_device_tech ('citydb');

DROP TRIGGER IF EXISTS utn9_tr_upd_ntw_feat_device_tech ON citydb_view.utn9_ntw_feat_device_tech;
CREATE TRIGGER utn9_tr_upd_ntw_feat_device_tech
	INSTEAD OF UPDATE ON citydb_view.utn9_ntw_feat_device_tech
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_upd_ntw_feat_device_tech ('citydb');
--**************************************************************
--**************************************************************

----------------------------------------------------------------
-- Function TR_DEL_NTW_FEAT_DISTRIB_ELEM_CABLE
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_del_ntw_feat_distrib_elem_cable() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_del_ntw_feat_distrib_elem_cable()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
deleted_id=citydb_pkg.utn9_delete_network_feature(OLD.id, p_schema_name);
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_del_ntw_feat_distrib_elem_cable (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_NTW_FEAT_DISTRIB_ELEM_CABLE
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_ins_ntw_feat_distrib_elem_cable() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_ins_ntw_feat_distrib_elem_cable()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	inserted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;

inserted_id=citydb_view.utn9_insert_ntw_feat_distrib_elem_cable(
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
--
ntw_feature_parent_id:=NEW.ntw_feature_parent_id,
ntw_feature_root_id  :=NEW.ntw_feature_root_id  ,
class                :=NEW.class                ,
function             :=NEW.function             ,
usage                :=NEW.usage                ,
year_of_construction :=NEW.year_of_construction ,
status               :=NEW.status               ,
location_quality     :=NEW.location_quality     ,
elevation_quality    :=NEW.elevation_quality    ,
conn_cityobject_id   :=NEW.conn_cityobject_id   ,
prot_element_id      :=NEW.prot_element_id      ,
geom                 :=NEW.geom                 ,
--
  function_of_line  :=NEW.function_of_line  ,
--is_gravity        :=NEW.is_gravity        ,
  is_transmission   :=NEW.is_transmission   ,
  is_communication  :=NEW.is_communication  ,
--ext_width         :=NEW.ext_width         ,
--ext_width_unit    :=NEW.ext_width_unit    ,
--ext_height        :=NEW.ext_height        ,
--ext_height_unit   :=NEW.ext_height_unit   ,
--ext_diameter      :=NEW.ext_diameter      ,
--ext_diameter_unit :=NEW.ext_diameter_unit ,
--int_width         :=NEW.int_width         ,
--int_width_unit    :=NEW.int_width_unit    ,
--int_height        :=NEW.int_height        ,
--int_height_unit   :=NEW.int_height_unit   ,
--int_diameter      :=NEW.int_diameter      ,
--int_diameter_unit :=NEW.int_diameter_unit ,
  cross_section     :=NEW.cross_section     ,
  cross_section_unit:=NEW.cross_section_unit,
--slope_range_from  :=NEW.slope_range_from  ,
--slope_range_to    :=NEW.slope_range_to    ,
--slope_range_unit  :=NEW.slope_range_unit  ,
--profile_name      :=NEW.profile_name      ,
--
schema_name                  :=p_schema_name
);
--RAISE NOTICE 'Inserted record with id: %', inserted_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_ins_ntw_feat_distrib_elem_cable (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_NTW_FEAT_DISTRIB_ELEM_CABLE
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_upd_ntw_feat_distrib_elem_cable() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_upd_ntw_feat_distrib_elem_cable()
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

EXECUTE format('UPDATE %I.utn9_network_feature AS t SET
ntw_feature_parent_id =%L,
ntw_feature_root_id   =%L,
class                 =%L,
function              =%L,
usage                 =%L,
year_of_construction  =%L,
status                =%L,
location_quality      =%L,
elevation_quality     =%L,
conn_cityobject_id    =%L,
prot_element_id       =%L,
geom                  =%L
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.ntw_feature_parent_id,
NEW.ntw_feature_root_id  ,
NEW.class                ,
NEW.function             ,
NEW.usage                ,
NEW.year_of_construction ,
NEW.status               ,
NEW.location_quality     ,
NEW.elevation_quality    ,
NEW.conn_cityobject_id   ,
NEW.prot_element_id      ,
NEW.geom                 ,
OLD.id
) INTO updated_id;

EXECUTE format('UPDATE %I.utn9_distrib_element AS t SET
function_of_line  =%L,'||/* 
is_gravity        =%L,*/'
is_transmission   =%L,
is_communication  =%L,
ext_width         =%L,'||/* 
ext_width_unit    =%L,
ext_height        =%L,
ext_height_unit   =%L,
ext_diameter      =%L,
ext_diameter_unit =%L,
int_width         =%L,
int_width_unit    =%L,
int_height        =%L,
int_height_unit   =%L,
int_diameter      =%L,
int_diameter_unit =%L,*/'
cross_section     =%L,
cross_section_unit=%L,
slope_range_from  =%L'||/*, 
slope_range_to    =%L,
slope_range_unit  =%L,
profile_name      =%L*/'
WHERE t.id=%L RETURNING id',
p_schema_name,
  NEW.function_of_line  ,
--NEW.is_gravity        ,
  NEW.is_transmission   ,
  NEW.is_communication  ,
--NEW.ext_width         ,
--NEW.ext_width_unit    ,
--NEW.ext_height        ,
--NEW.ext_height_unit   ,
--NEW.ext_diameter      ,
--NEW.ext_diameter_unit ,
--NEW.int_width         ,
--NEW.int_width_unit    ,
--NEW.int_height        ,
--NEW.int_height_unit   ,
--NEW.int_diameter      ,
--NEW.int_diameter_unit ,
  NEW.cross_section     ,
  NEW.cross_section_unit,
--NEW.slope_range_from  ,
--NEW.slope_range_to    ,
--NEW.slope_range_unit  ,
--NEW.profile_name      ,
OLD.id
) INTO updated_id;

-- RAISE NOTICE 'Updated record with id: %',updated_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_upd_ntw_feat_distrib_elem_cable (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view NTW_FEAT_DISTRIB_ELEM_CABLE
----------------------------------------------------------------
DROP TRIGGER IF EXISTS utn9_tr_del_ntw_feat_distrib_elem_cable ON citydb_view.utn9_ntw_feat_distrib_elem_cable;
CREATE TRIGGER utn9_tr_del_ntw_feat_distrib_elem_cable
	INSTEAD OF DELETE ON citydb_view.utn9_ntw_feat_distrib_elem_cable
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_del_ntw_feat_distrib_elem_cable ('citydb');

DROP TRIGGER IF EXISTS utn9_tr_ins_ntw_feat_distrib_elem_cable ON citydb_view.utn9_ntw_feat_distrib_elem_cable;
CREATE TRIGGER utn9_tr_ins_ntw_feat_distrib_elem_cable
	INSTEAD OF INSERT ON citydb_view.utn9_ntw_feat_distrib_elem_cable
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_ins_ntw_feat_distrib_elem_cable ('citydb');

DROP TRIGGER IF EXISTS utn9_tr_upd_ntw_feat_distrib_elem_cable ON citydb_view.utn9_ntw_feat_distrib_elem_cable;
CREATE TRIGGER utn9_tr_upd_ntw_feat_distrib_elem_cable
	INSTEAD OF UPDATE ON citydb_view.utn9_ntw_feat_distrib_elem_cable
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_upd_ntw_feat_distrib_elem_cable ('citydb');
--**************************************************************
--**************************************************************

----------------------------------------------------------------
-- Function TR_DEL_NTW_FEAT_DISTRIB_ELEM_CANAL
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_del_ntw_feat_distrib_elem_canal() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_del_ntw_feat_distrib_elem_canal()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
deleted_id=citydb_pkg.utn9_delete_network_feature(OLD.id, p_schema_name);
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_del_ntw_feat_distrib_elem_canal (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_NTW_FEAT_DISTRIB_ELEM_CANAL
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_ins_ntw_feat_distrib_elem_canal() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_ins_ntw_feat_distrib_elem_canal()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	inserted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;

inserted_id=citydb_view.utn9_insert_ntw_feat_distrib_elem_canal(
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
--
ntw_feature_parent_id:=NEW.ntw_feature_parent_id,
ntw_feature_root_id  :=NEW.ntw_feature_root_id  ,
class                :=NEW.class                ,
function             :=NEW.function             ,
usage                :=NEW.usage                ,
year_of_construction :=NEW.year_of_construction ,
status               :=NEW.status               ,
location_quality     :=NEW.location_quality     ,
elevation_quality    :=NEW.elevation_quality    ,
conn_cityobject_id   :=NEW.conn_cityobject_id   ,
prot_element_id      :=NEW.prot_element_id      ,
geom                 :=NEW.geom                 ,
--
  function_of_line  :=NEW.function_of_line  ,
  is_gravity        :=NEW.is_gravity        ,
--is_transmission   :=NEW.is_transmission   ,
--is_communication  :=NEW.is_communication  ,
  ext_width         :=NEW.ext_width         ,
  ext_width_unit    :=NEW.ext_width_unit    ,
  ext_height        :=NEW.ext_height        ,
  ext_height_unit   :=NEW.ext_height_unit   ,
  ext_diameter      :=NEW.ext_diameter      ,
  ext_diameter_unit :=NEW.ext_diameter_unit ,
--int_width         :=NEW.int_width         ,
--int_width_unit    :=NEW.int_width_unit    ,
--int_height        :=NEW.int_height        ,
--int_height_unit   :=NEW.int_height_unit   ,
--int_diameter      :=NEW.int_diameter      ,
--int_diameter_unit :=NEW.int_diameter_unit ,
--cross_section     :=NEW.cross_section     ,
--cross_section_unit:=NEW.cross_section_unit,
  slope_range_from  :=NEW.slope_range_from  ,
  slope_range_to    :=NEW.slope_range_to    ,
  slope_range_unit  :=NEW.slope_range_unit  ,
  profile_name      :=NEW.profile_name      ,
--
schema_name                  :=p_schema_name
);
--RAISE NOTICE 'Inserted record with id: %', inserted_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_ins_ntw_feat_distrib_elem_canal (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_NTW_FEAT_DISTRIB_ELEM_CANAL
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_upd_ntw_feat_distrib_elem_canal() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_upd_ntw_feat_distrib_elem_canal()
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

EXECUTE format('UPDATE %I.utn9_network_feature AS t SET
ntw_feature_parent_id =%L,
ntw_feature_root_id   =%L,
class                 =%L,
function              =%L,
usage                 =%L,
year_of_construction  =%L,
status                =%L,
location_quality      =%L,
elevation_quality     =%L,
conn_cityobject_id    =%L,
prot_element_id       =%L,
geom                  =%L
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.ntw_feature_parent_id,
NEW.ntw_feature_root_id  ,
NEW.class                ,
NEW.function             ,
NEW.usage                ,
NEW.year_of_construction ,
NEW.status               ,
NEW.location_quality     ,
NEW.elevation_quality    ,
NEW.conn_cityobject_id   ,
NEW.prot_element_id      ,
NEW.geom                 ,
OLD.id
) INTO updated_id;

EXECUTE format('UPDATE %I.utn9_distrib_element AS t SET
function_of_line  =%L,
is_gravity        =%L,'||/* 
is_transmission   =%L,
is_communication  =%L,*/'
ext_width         =%L,
ext_width_unit    =%L,
ext_height        =%L,
ext_height_unit   =%L,
ext_diameter      =%L,
ext_diameter_unit =%L,'||/*
int_width         =%L, 
int_width_unit    =%L,
int_height        =%L,
int_height_unit   =%L,
int_diameter      =%L,
int_diameter_unit =%L,
cross_section     =%L,
cross_section_unit=%L,*/'
slope_range_from  =%L,
slope_range_to    =%L,
slope_range_unit  =%L,
profile_name      =%L
WHERE t.id=%L RETURNING id',
p_schema_name,
  NEW.function_of_line  ,
  NEW.is_gravity        ,
--NEW.is_transmission   ,
--NEW.is_communication  ,
  NEW.ext_width         ,
  NEW.ext_width_unit    ,
  NEW.ext_height        ,
  NEW.ext_height_unit   ,
  NEW.ext_diameter      ,
  NEW.ext_diameter_unit ,
--NEW.int_width         ,
--NEW.int_width_unit    ,
--NEW.int_height        ,
--NEW.int_height_unit   ,
--NEW.int_diameter      ,
--NEW.int_diameter_unit ,
--NEW.cross_section     ,
--NEW.cross_section_unit,
  NEW.slope_range_from  ,
  NEW.slope_range_to    ,
  NEW.slope_range_unit  ,
  NEW.profile_name      ,
OLD.id
) INTO updated_id;

-- RAISE NOTICE 'Updated record with id: %',updated_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_upd_ntw_feat_distrib_elem_canal (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view NTW_FEAT_DISTRIB_ELEM_CANAL
----------------------------------------------------------------
DROP TRIGGER IF EXISTS utn9_tr_del_ntw_feat_distrib_elem_canal ON citydb_view.utn9_ntw_feat_distrib_elem_canal;
CREATE TRIGGER utn9_tr_del_ntw_feat_distrib_elem_canal
	INSTEAD OF DELETE ON citydb_view.utn9_ntw_feat_distrib_elem_canal
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_del_ntw_feat_distrib_elem_canal ('citydb');

DROP TRIGGER IF EXISTS utn9_tr_ins_ntw_feat_distrib_elem_canal ON citydb_view.utn9_ntw_feat_distrib_elem_canal;
CREATE TRIGGER utn9_tr_ins_ntw_feat_distrib_elem_canal
	INSTEAD OF INSERT ON citydb_view.utn9_ntw_feat_distrib_elem_canal
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_ins_ntw_feat_distrib_elem_canal ('citydb');

DROP TRIGGER IF EXISTS utn9_tr_upd_ntw_feat_distrib_elem_canal ON citydb_view.utn9_ntw_feat_distrib_elem_canal;
CREATE TRIGGER utn9_tr_upd_ntw_feat_distrib_elem_canal
	INSTEAD OF UPDATE ON citydb_view.utn9_ntw_feat_distrib_elem_canal
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_upd_ntw_feat_distrib_elem_canal ('citydb');
--**************************************************************
--**************************************************************

----------------------------------------------------------------
-- Function TR_DEL_NTW_FEAT_DISTRIB_ELEM_CANAL_CLOSED
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_del_ntw_feat_distrib_elem_canal_closed() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_del_ntw_feat_distrib_elem_canal_closed()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
deleted_id=citydb_pkg.utn9_delete_network_feature(OLD.id, p_schema_name);
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_del_ntw_feat_distrib_elem_canal_closed (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_NTW_FEAT_DISTRIB_ELEM_CANAL_CLOSED
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_ins_ntw_feat_distrib_elem_canal_closed() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_ins_ntw_feat_distrib_elem_canal_closed()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	inserted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;

inserted_id=citydb_view.utn9_insert_ntw_feat_distrib_elem_canal_closed(
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
--
ntw_feature_parent_id:=NEW.ntw_feature_parent_id,
ntw_feature_root_id  :=NEW.ntw_feature_root_id  ,
class                :=NEW.class                ,
function             :=NEW.function             ,
usage                :=NEW.usage                ,
year_of_construction :=NEW.year_of_construction ,
status               :=NEW.status               ,
location_quality     :=NEW.location_quality     ,
elevation_quality    :=NEW.elevation_quality    ,
conn_cityobject_id   :=NEW.conn_cityobject_id   ,
prot_element_id      :=NEW.prot_element_id      ,
geom                 :=NEW.geom                 ,
--
  function_of_line  :=NEW.function_of_line  ,
  is_gravity        :=NEW.is_gravity        ,
--is_transmission   :=NEW.is_transmission   ,
--is_communication  :=NEW.is_communication  ,
  ext_width         :=NEW.ext_width         ,
  ext_width_unit    :=NEW.ext_width_unit    ,
  ext_height        :=NEW.ext_height        ,
  ext_height_unit   :=NEW.ext_height_unit   ,
  ext_diameter      :=NEW.ext_diameter      ,
  ext_diameter_unit :=NEW.ext_diameter_unit ,
--int_width         :=NEW.int_width         ,
--int_width_unit    :=NEW.int_width_unit    ,
--int_height        :=NEW.int_height        ,
--int_height_unit   :=NEW.int_height_unit   ,
--int_diameter      :=NEW.int_diameter      ,
--int_diameter_unit :=NEW.int_diameter_unit ,
--cross_section     :=NEW.cross_section     ,
--cross_section_unit:=NEW.cross_section_unit,
  slope_range_from  :=NEW.slope_range_from  ,
  slope_range_to    :=NEW.slope_range_to    ,
  slope_range_unit  :=NEW.slope_range_unit  ,
  profile_name      :=NEW.profile_name      ,
--
schema_name                  :=p_schema_name
);
--RAISE NOTICE 'Inserted record with id: %', inserted_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_ins_ntw_feat_distrib_elem_canal_closed (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_NTW_FEAT_DISTRIB_ELEM_CANAL_CLOSED
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_upd_ntw_feat_distrib_elem_canal_closed() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_upd_ntw_feat_distrib_elem_canal_closed()
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

EXECUTE format('UPDATE %I.utn9_network_feature AS t SET
ntw_feature_parent_id =%L,
ntw_feature_root_id   =%L,
class                 =%L,
function              =%L,
usage                 =%L,
year_of_construction  =%L,
status                =%L,
location_quality      =%L,
elevation_quality     =%L,
conn_cityobject_id    =%L,
prot_element_id       =%L,
geom                  =%L
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.ntw_feature_parent_id,
NEW.ntw_feature_root_id  ,
NEW.class                ,
NEW.function             ,
NEW.usage                ,
NEW.year_of_construction ,
NEW.status               ,
NEW.location_quality     ,
NEW.elevation_quality    ,
NEW.conn_cityobject_id   ,
NEW.prot_element_id      ,
NEW.geom                 ,
OLD.id
) INTO updated_id;

EXECUTE format('UPDATE %I.utn9_distrib_element AS t SET
function_of_line  =%L,
is_gravity        =%L,'||/* 
is_transmission   =%L,
is_communication  =%L,*/'
ext_width         =%L,
ext_width_unit    =%L,
ext_height        =%L,
ext_height_unit   =%L,
ext_diameter      =%L,
ext_diameter_unit =%L,'||/*
int_width         =%L, 
int_width_unit    =%L,
int_height        =%L,
int_height_unit   =%L,
int_diameter      =%L,
int_diameter_unit =%L,
cross_section     =%L,
cross_section_unit=%L,*/'
slope_range_from  =%L,
slope_range_to    =%L,
slope_range_unit  =%L,
profile_name      =%L
WHERE t.id=%L RETURNING id',
p_schema_name,
  NEW.function_of_line  ,
  NEW.is_gravity        ,
--NEW.is_transmission   ,
--NEW.is_communication  ,
  NEW.ext_width         ,
  NEW.ext_width_unit    ,
  NEW.ext_height        ,
  NEW.ext_height_unit   ,
  NEW.ext_diameter      ,
  NEW.ext_diameter_unit ,
--NEW.int_width         ,
--NEW.int_width_unit    ,
--NEW.int_height        ,
--NEW.int_height_unit   ,
--NEW.int_diameter      ,
--NEW.int_diameter_unit ,
--NEW.cross_section     ,
--NEW.cross_section_unit,
  NEW.slope_range_from  ,
  NEW.slope_range_to    ,
  NEW.slope_range_unit  ,
  NEW.profile_name      ,
OLD.id
) INTO updated_id;

-- RAISE NOTICE 'Updated record with id: %',updated_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_upd_ntw_feat_distrib_elem_canal_closed (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view NTW_FEAT_DISTRIB_ELEM_CANAL_CLOSED
----------------------------------------------------------------
DROP TRIGGER IF EXISTS utn9_tr_del_ntw_feat_distrib_elem_canal_closed ON citydb_view.utn9_ntw_feat_distrib_elem_canal_closed;
CREATE TRIGGER utn9_tr_del_ntw_feat_distrib_elem_canal_closed
	INSTEAD OF DELETE ON citydb_view.utn9_ntw_feat_distrib_elem_canal_closed
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_del_ntw_feat_distrib_elem_canal_closed ('citydb');

DROP TRIGGER IF EXISTS utn9_tr_ins_ntw_feat_distrib_elem_canal_closed ON citydb_view.utn9_ntw_feat_distrib_elem_canal_closed;
CREATE TRIGGER utn9_tr_ins_ntw_feat_distrib_elem_canal_closed
	INSTEAD OF INSERT ON citydb_view.utn9_ntw_feat_distrib_elem_canal_closed
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_ins_ntw_feat_distrib_elem_canal_closed ('citydb');

DROP TRIGGER IF EXISTS utn9_tr_upd_ntw_feat_distrib_elem_canal_closed ON citydb_view.utn9_ntw_feat_distrib_elem_canal_closed;
CREATE TRIGGER utn9_tr_upd_ntw_feat_distrib_elem_canal_closed
	INSTEAD OF UPDATE ON citydb_view.utn9_ntw_feat_distrib_elem_canal_closed
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_upd_ntw_feat_distrib_elem_canal_closed ('citydb');
--**************************************************************
--**************************************************************

----------------------------------------------------------------
-- Function TR_DEL_NTW_FEAT_DISTRIB_ELEM_CANAL_SEMI_OPEN
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_del_ntw_feat_distrib_elem_canal_semi_open() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_del_ntw_feat_distrib_elem_canal_semi_open()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
deleted_id=citydb_pkg.utn9_delete_network_feature(OLD.id, p_schema_name);
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_del_ntw_feat_distrib_elem_canal_semi_open (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_NTW_FEAT_DISTRIB_ELEM_CANAL_SEMI_OPEN
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_ins_ntw_feat_distrib_elem_canal_semi_open() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_ins_ntw_feat_distrib_elem_canal_semi_open()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	inserted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;

inserted_id=citydb_view.utn9_insert_ntw_feat_distrib_elem_canal_semi_open(
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
--
ntw_feature_parent_id:=NEW.ntw_feature_parent_id,
ntw_feature_root_id  :=NEW.ntw_feature_root_id  ,
class                :=NEW.class                ,
function             :=NEW.function             ,
usage                :=NEW.usage                ,
year_of_construction :=NEW.year_of_construction ,
status               :=NEW.status               ,
location_quality     :=NEW.location_quality     ,
elevation_quality    :=NEW.elevation_quality    ,
conn_cityobject_id   :=NEW.conn_cityobject_id   ,
prot_element_id      :=NEW.prot_element_id      ,
geom                 :=NEW.geom                 ,
--
  function_of_line  :=NEW.function_of_line  ,
  is_gravity        :=NEW.is_gravity        ,
--is_transmission   :=NEW.is_transmission   ,
--is_communication  :=NEW.is_communication  ,
  ext_width         :=NEW.ext_width         ,
  ext_width_unit    :=NEW.ext_width_unit    ,
  ext_height        :=NEW.ext_height        ,
  ext_height_unit   :=NEW.ext_height_unit   ,
  ext_diameter      :=NEW.ext_diameter      ,
  ext_diameter_unit :=NEW.ext_diameter_unit ,
--int_width         :=NEW.int_width         ,
--int_width_unit    :=NEW.int_width_unit    ,
--int_height        :=NEW.int_height        ,
--int_height_unit   :=NEW.int_height_unit   ,
--int_diameter      :=NEW.int_diameter      ,
--int_diameter_unit :=NEW.int_diameter_unit ,
--cross_section     :=NEW.cross_section     ,
--cross_section_unit:=NEW.cross_section_unit,
  slope_range_from  :=NEW.slope_range_from  ,
  slope_range_to    :=NEW.slope_range_to    ,
  slope_range_unit  :=NEW.slope_range_unit  ,
  profile_name      :=NEW.profile_name      ,
--
schema_name                  :=p_schema_name
);
--RAISE NOTICE 'Inserted record with id: %', inserted_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_ins_ntw_feat_distrib_elem_canal_semi_open (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_NTW_FEAT_DISTRIB_ELEM_CANAL_SEMI_OPEN
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_upd_ntw_feat_distrib_elem_canal_semi_open() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_upd_ntw_feat_distrib_elem_canal_semi_open()
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

EXECUTE format('UPDATE %I.utn9_network_feature AS t SET
ntw_feature_parent_id =%L,
ntw_feature_root_id   =%L,
class                 =%L,
function              =%L,
usage                 =%L,
year_of_construction  =%L,
status                =%L,
location_quality      =%L,
elevation_quality     =%L,
conn_cityobject_id    =%L,
prot_element_id       =%L,
geom                  =%L
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.ntw_feature_parent_id,
NEW.ntw_feature_root_id  ,
NEW.class                ,
NEW.function             ,
NEW.usage                ,
NEW.year_of_construction ,
NEW.status               ,
NEW.location_quality     ,
NEW.elevation_quality    ,
NEW.conn_cityobject_id   ,
NEW.prot_element_id      ,
NEW.geom                 ,
OLD.id
) INTO updated_id;

EXECUTE format('UPDATE %I.utn9_distrib_element AS t SET
function_of_line  =%L,
is_gravity        =%L,'||/* 
is_transmission   =%L,
is_communication  =%L,*/'
ext_width         =%L,
ext_width_unit    =%L,
ext_height        =%L,
ext_height_unit   =%L,
ext_diameter      =%L,
ext_diameter_unit =%L,'||/*
int_width         =%L, 
int_width_unit    =%L,
int_height        =%L,
int_height_unit   =%L,
int_diameter      =%L,
int_diameter_unit =%L,
cross_section     =%L,
cross_section_unit=%L,*/'
slope_range_from  =%L,
slope_range_to    =%L,
slope_range_unit  =%L,
profile_name      =%L
WHERE t.id=%L RETURNING id',
p_schema_name,
  NEW.function_of_line  ,
  NEW.is_gravity        ,
--NEW.is_transmission   ,
--NEW.is_communication  ,
  NEW.ext_width         ,
  NEW.ext_width_unit    ,
  NEW.ext_height        ,
  NEW.ext_height_unit   ,
  NEW.ext_diameter      ,
  NEW.ext_diameter_unit ,
--NEW.int_width         ,
--NEW.int_width_unit    ,
--NEW.int_height        ,
--NEW.int_height_unit   ,
--NEW.int_diameter      ,
--NEW.int_diameter_unit ,
--NEW.cross_section     ,
--NEW.cross_section_unit,
  NEW.slope_range_from  ,
  NEW.slope_range_to    ,
  NEW.slope_range_unit  ,
  NEW.profile_name      ,
OLD.id
) INTO updated_id;

-- RAISE NOTICE 'Updated record with id: %',updated_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_upd_ntw_feat_distrib_elem_canal_semi_open (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view NTW_FEAT_DISTRIB_ELEM_CANAL_SEMI_OPEN
----------------------------------------------------------------
DROP TRIGGER IF EXISTS utn9_tr_del_ntw_feat_distrib_elem_canal_semi_open ON citydb_view.utn9_ntw_feat_distrib_elem_canal_semi_open;
CREATE TRIGGER utn9_tr_del_ntw_feat_distrib_elem_canal_semi_open
	INSTEAD OF DELETE ON citydb_view.utn9_ntw_feat_distrib_elem_canal_semi_open
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_del_ntw_feat_distrib_elem_canal_semi_open ('citydb');

DROP TRIGGER IF EXISTS utn9_tr_ins_ntw_feat_distrib_elem_canal_semi_open ON citydb_view.utn9_ntw_feat_distrib_elem_canal_semi_open;
CREATE TRIGGER utn9_tr_ins_ntw_feat_distrib_elem_canal_semi_open
	INSTEAD OF INSERT ON citydb_view.utn9_ntw_feat_distrib_elem_canal_semi_open
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_ins_ntw_feat_distrib_elem_canal_semi_open ('citydb');

DROP TRIGGER IF EXISTS utn9_tr_upd_ntw_feat_distrib_elem_canal_semi_open ON citydb_view.utn9_ntw_feat_distrib_elem_canal_semi_open;
CREATE TRIGGER utn9_tr_upd_ntw_feat_distrib_elem_canal_semi_open
	INSTEAD OF UPDATE ON citydb_view.utn9_ntw_feat_distrib_elem_canal_semi_open
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_upd_ntw_feat_distrib_elem_canal_semi_open ('citydb');
--**************************************************************
--**************************************************************

----------------------------------------------------------------
-- Function TR_DEL_NTW_FEAT_DISTRIB_ELEM_PIPE_OTHER_SHAPE
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_del_ntw_feat_distrib_elem_pipe_other_shape() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_del_ntw_feat_distrib_elem_pipe_other_shape()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
deleted_id=citydb_pkg.utn9_delete_network_feature(OLD.id, p_schema_name);
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_del_ntw_feat_distrib_elem_pipe_other_shape (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_NTW_FEAT_DISTRIB_ELEM_PIPE_OTHER_SHAPE
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_ins_ntw_feat_distrib_elem_pipe_other_shape() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_ins_ntw_feat_distrib_elem_pipe_other_shape()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	inserted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;

inserted_id=citydb_view.utn9_insert_ntw_feat_distrib_elem_pipe_other_shape(
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
--
ntw_feature_parent_id:=NEW.ntw_feature_parent_id,
ntw_feature_root_id  :=NEW.ntw_feature_root_id  ,
class                :=NEW.class                ,
function             :=NEW.function             ,
usage                :=NEW.usage                ,
year_of_construction :=NEW.year_of_construction ,
status               :=NEW.status               ,
location_quality     :=NEW.location_quality     ,
elevation_quality    :=NEW.elevation_quality    ,
conn_cityobject_id   :=NEW.conn_cityobject_id   ,
prot_element_id      :=NEW.prot_element_id      ,
geom                 :=NEW.geom                 ,
--
  function_of_line  :=NEW.function_of_line  ,
  is_gravity        :=NEW.is_gravity        ,
--is_transmission   :=NEW.is_transmission   ,
--is_communication  :=NEW.is_communication  ,
  ext_width         :=NEW.ext_width         ,
  ext_width_unit    :=NEW.ext_width_unit    ,
  ext_height        :=NEW.ext_height        ,
  ext_height_unit   :=NEW.ext_height_unit   ,
  ext_diameter      :=NEW.ext_diameter      ,
  ext_diameter_unit :=NEW.ext_diameter_unit ,
--int_width         :=NEW.int_width         ,
--int_width_unit    :=NEW.int_width_unit    ,
--int_height        :=NEW.int_height        ,
--int_height_unit   :=NEW.int_height_unit   ,
--int_diameter      :=NEW.int_diameter      ,
--int_diameter_unit :=NEW.int_diameter_unit ,
--cross_section     :=NEW.cross_section     ,
--cross_section_unit:=NEW.cross_section_unit,
--slope_range_from  :=NEW.slope_range_from  ,
--slope_range_to    :=NEW.slope_range_to    ,
--slope_range_unit  :=NEW.slope_range_unit  ,
--profile_name      :=NEW.profile_name      ,
--
schema_name                  :=p_schema_name
);
--RAISE NOTICE 'Inserted record with id: %', inserted_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_ins_ntw_feat_distrib_elem_pipe_other_shape (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_NTW_FEAT_DISTRIB_ELEM_PIPE_OTHER_SHAPE
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_upd_ntw_feat_distrib_elem_pipe_other_shape() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_upd_ntw_feat_distrib_elem_pipe_other_shape()
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

EXECUTE format('UPDATE %I.utn9_network_feature AS t SET
ntw_feature_parent_id =%L,
ntw_feature_root_id   =%L,
class                 =%L,
function              =%L,
usage                 =%L,
year_of_construction  =%L,
status                =%L,
location_quality      =%L,
elevation_quality     =%L,
conn_cityobject_id    =%L,
prot_element_id       =%L,
geom                  =%L
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.ntw_feature_parent_id,
NEW.ntw_feature_root_id  ,
NEW.class                ,
NEW.function             ,
NEW.usage                ,
NEW.year_of_construction ,
NEW.status               ,
NEW.location_quality     ,
NEW.elevation_quality    ,
NEW.conn_cityobject_id   ,
NEW.prot_element_id      ,
NEW.geom                 ,
OLD.id
) INTO updated_id;

EXECUTE format('UPDATE %I.utn9_distrib_element AS t SET
function_of_line  =%L,
is_gravity        =%L,'||/* 
is_transmission   =%L,
is_communication  =%L,*/'
ext_width         =%L,
ext_width_unit    =%L,
ext_height        =%L,
ext_height_unit   =%L,
ext_diameter      =%L,
ext_diameter_unit =%L'||/*, 
int_width         =%L,
int_width_unit    =%L,
int_height        =%L,
int_height_unit   =%L,
int_diameter      =%L,
int_diameter_unit =%L,
cross_section     =%L,
cross_section_unit=%L,
slope_range_from  =%L,
slope_range_to    =%L,
slope_range_unit  =%L,
profile_name      =%L*/'
WHERE t.id=%L RETURNING id',
p_schema_name,
  NEW.function_of_line  ,
  NEW.is_gravity        ,
--NEW.is_transmission   ,
--NEW.is_communication  ,
  NEW.ext_width         ,
  NEW.ext_width_unit    ,
  NEW.ext_height        ,
  NEW.ext_height_unit   ,
  NEW.ext_diameter      ,
  NEW.ext_diameter_unit ,
--NEW.int_width         ,
--NEW.int_width_unit    ,
--NEW.int_height        ,
--NEW.int_height_unit   ,
--NEW.int_diameter      ,
--NEW.int_diameter_unit ,
--NEW.cross_section     ,
--NEW.cross_section_unit,
--NEW.slope_range_from  ,
--NEW.slope_range_to    ,
--NEW.slope_range_unit  ,
--NEW.profile_name      ,
OLD.id
) INTO updated_id;

-- RAISE NOTICE 'Updated record with id: %',updated_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_upd_ntw_feat_distrib_elem_pipe_other_shape (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view NTW_FEAT_DISTRIB_ELEM_PIPE_OTHER_SHAPE
----------------------------------------------------------------
DROP TRIGGER IF EXISTS utn9_tr_del_ntw_feat_distrib_elem_pipe_other_shape ON citydb_view.utn9_ntw_feat_distrib_elem_pipe_other_shape;
CREATE TRIGGER utn9_tr_del_ntw_feat_distrib_elem_pipe_other_shape
	INSTEAD OF DELETE ON citydb_view.utn9_ntw_feat_distrib_elem_pipe_other_shape
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_del_ntw_feat_distrib_elem_pipe_other_shape ('citydb');

DROP TRIGGER IF EXISTS utn9_tr_ins_ntw_feat_distrib_elem_pipe_other_shape ON citydb_view.utn9_ntw_feat_distrib_elem_pipe_other_shape;
CREATE TRIGGER utn9_tr_ins_ntw_feat_distrib_elem_pipe_other_shape
	INSTEAD OF INSERT ON citydb_view.utn9_ntw_feat_distrib_elem_pipe_other_shape
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_ins_ntw_feat_distrib_elem_pipe_other_shape ('citydb');

DROP TRIGGER IF EXISTS utn9_tr_upd_ntw_feat_distrib_elem_pipe_other_shape ON citydb_view.utn9_ntw_feat_distrib_elem_pipe_other_shape;
CREATE TRIGGER utn9_tr_upd_ntw_feat_distrib_elem_pipe_other_shape
	INSTEAD OF UPDATE ON citydb_view.utn9_ntw_feat_distrib_elem_pipe_other_shape
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_upd_ntw_feat_distrib_elem_pipe_other_shape ('citydb');
--**************************************************************
--**************************************************************

----------------------------------------------------------------
-- Function TR_DEL_NTW_FEAT_DISTRIB_ELEM_PIPE_RECT
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_del_ntw_feat_distrib_elem_pipe_rect() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_del_ntw_feat_distrib_elem_pipe_rect()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
deleted_id=citydb_pkg.utn9_delete_network_feature(OLD.id, p_schema_name);
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_del_ntw_feat_distrib_elem_pipe_rect (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_NTW_FEAT_DISTRIB_ELEM_PIPE_RECT
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_ins_ntw_feat_distrib_elem_pipe_rect() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_ins_ntw_feat_distrib_elem_pipe_rect()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	inserted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;

inserted_id=citydb_view.utn9_insert_ntw_feat_distrib_elem_pipe_rect(
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
--
ntw_feature_parent_id:=NEW.ntw_feature_parent_id,
ntw_feature_root_id  :=NEW.ntw_feature_root_id  ,
class                :=NEW.class                ,
function             :=NEW.function             ,
usage                :=NEW.usage                ,
year_of_construction :=NEW.year_of_construction ,
status               :=NEW.status               ,
location_quality     :=NEW.location_quality     ,
elevation_quality    :=NEW.elevation_quality    ,
conn_cityobject_id   :=NEW.conn_cityobject_id   ,
prot_element_id      :=NEW.prot_element_id      ,
geom                 :=NEW.geom                 ,
--
  function_of_line  :=NEW.function_of_line  ,
  is_gravity        :=NEW.is_gravity        ,
--is_transmission   :=NEW.is_transmission   ,
--is_communication  :=NEW.is_communication  ,
  ext_width         :=NEW.ext_width         ,
  ext_width_unit    :=NEW.ext_width_unit    ,
  ext_height        :=NEW.ext_height        ,
  ext_height_unit   :=NEW.ext_height_unit   ,
  ext_diameter      :=NEW.ext_diameter      ,
  ext_diameter_unit :=NEW.ext_diameter_unit ,
  int_width         :=NEW.int_width         ,
  int_width_unit    :=NEW.int_width_unit    ,
  int_height        :=NEW.int_height        ,
  int_height_unit   :=NEW.int_height_unit   ,
--int_diameter      :=NEW.int_diameter      ,
--int_diameter_unit :=NEW.int_diameter_unit ,
--cross_section     :=NEW.cross_section     ,
--cross_section_unit:=NEW.cross_section_unit,
--slope_range_from  :=NEW.slope_range_from  ,
--slope_range_to    :=NEW.slope_range_to    ,
--slope_range_unit  :=NEW.slope_range_unit  ,
--profile_name      :=NEW.profile_name      ,
--
schema_name                  :=p_schema_name
);
--RAISE NOTICE 'Inserted record with id: %', inserted_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_ins_ntw_feat_distrib_elem_pipe_rect (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_NTW_FEAT_DISTRIB_ELEM_PIPE_RECT
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_upd_ntw_feat_distrib_elem_pipe_rect() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_upd_ntw_feat_distrib_elem_pipe_rect()
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

EXECUTE format('UPDATE %I.utn9_network_feature AS t SET
ntw_feature_parent_id =%L,
ntw_feature_root_id   =%L,
class                 =%L,
function              =%L,
usage                 =%L,
year_of_construction  =%L,
status                =%L,
location_quality      =%L,
elevation_quality     =%L,
conn_cityobject_id    =%L,
prot_element_id       =%L,
geom                  =%L
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.ntw_feature_parent_id,
NEW.ntw_feature_root_id  ,
NEW.class                ,
NEW.function             ,
NEW.usage                ,
NEW.year_of_construction ,
NEW.status               ,
NEW.location_quality     ,
NEW.elevation_quality    ,
NEW.conn_cityobject_id   ,
NEW.prot_element_id      ,
NEW.geom                 ,
OLD.id
) INTO updated_id;

EXECUTE format('UPDATE %I.utn9_distrib_element AS t SET
function_of_line  =%L,
is_gravity        =%L,'||/* 
is_transmission   =%L,
is_communication  =%L,*/'
ext_width         =%L,
ext_width_unit    =%L,
ext_height        =%L,
ext_height_unit   =%L,
ext_diameter      =%L,
ext_diameter_unit =%L,
int_width         =%L,
int_width_unit    =%L,
int_height        =%L,
int_height_unit   =%L'||/*, 
int_diameter      =%L,
int_diameter_unit =%L,
cross_section     =%L,
cross_section_unit=%L,
slope_range_from  =%L,
slope_range_to    =%L,
slope_range_unit  =%L,
profile_name      =%L*/'
WHERE t.id=%L RETURNING id',
p_schema_name,
  NEW.function_of_line  ,
  NEW.is_gravity        ,
--NEW.is_transmission   ,
--NEW.is_communication  ,
  NEW.ext_width         ,
  NEW.ext_width_unit    ,
  NEW.ext_height        ,
  NEW.ext_height_unit   ,
  NEW.ext_diameter      ,
  NEW.ext_diameter_unit ,
  NEW.int_width         ,
  NEW.int_width_unit    ,
  NEW.int_height        ,
  NEW.int_height_unit   ,
--NEW.int_diameter      ,
--NEW.int_diameter_unit ,
--NEW.cross_section     ,
--NEW.cross_section_unit,
--NEW.slope_range_from  ,
--NEW.slope_range_to    ,
--NEW.slope_range_unit  ,
--NEW.profile_name      ,
OLD.id
) INTO updated_id;

-- RAISE NOTICE 'Updated record with id: %',updated_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_upd_ntw_feat_distrib_elem_pipe_rect (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view NTW_FEAT_DISTRIB_ELEM_PIPE_RECT
----------------------------------------------------------------
DROP TRIGGER IF EXISTS utn9_tr_del_ntw_feat_distrib_elem_pipe_rect ON citydb_view.utn9_ntw_feat_distrib_elem_pipe_rect;
CREATE TRIGGER utn9_tr_del_ntw_feat_distrib_elem_pipe_rect
	INSTEAD OF DELETE ON citydb_view.utn9_ntw_feat_distrib_elem_pipe_rect
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_del_ntw_feat_distrib_elem_pipe_rect ('citydb');

DROP TRIGGER IF EXISTS utn9_tr_ins_ntw_feat_distrib_elem_pipe_rect ON citydb_view.utn9_ntw_feat_distrib_elem_pipe_rect;
CREATE TRIGGER utn9_tr_ins_ntw_feat_distrib_elem_pipe_rect
	INSTEAD OF INSERT ON citydb_view.utn9_ntw_feat_distrib_elem_pipe_rect
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_ins_ntw_feat_distrib_elem_pipe_rect ('citydb');

DROP TRIGGER IF EXISTS utn9_tr_upd_ntw_feat_distrib_elem_pipe_rect ON citydb_view.utn9_ntw_feat_distrib_elem_pipe_rect;
CREATE TRIGGER utn9_tr_upd_ntw_feat_distrib_elem_pipe_rect
	INSTEAD OF UPDATE ON citydb_view.utn9_ntw_feat_distrib_elem_pipe_rect
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_upd_ntw_feat_distrib_elem_pipe_rect ('citydb');
--**************************************************************
--**************************************************************

----------------------------------------------------------------
-- Function TR_DEL_NTW_FEAT_DISTRIB_ELEM_PIPE_ROUND
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_del_ntw_feat_distrib_elem_pipe_round() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_del_ntw_feat_distrib_elem_pipe_round()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
deleted_id=citydb_pkg.utn9_delete_network_feature(OLD.id, p_schema_name);
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_del_ntw_feat_distrib_elem_pipe_round (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_NTW_FEAT_DISTRIB_ELEM_PIPE_ROUND
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_ins_ntw_feat_distrib_elem_pipe_round() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_ins_ntw_feat_distrib_elem_pipe_round()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	inserted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;

inserted_id=citydb_view.utn9_insert_ntw_feat_distrib_elem_pipe_round(
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
--
ntw_feature_parent_id:=NEW.ntw_feature_parent_id,
ntw_feature_root_id  :=NEW.ntw_feature_root_id  ,
class                :=NEW.class                ,
function             :=NEW.function             ,
usage                :=NEW.usage                ,
year_of_construction :=NEW.year_of_construction ,
status               :=NEW.status               ,
location_quality     :=NEW.location_quality     ,
elevation_quality    :=NEW.elevation_quality    ,
conn_cityobject_id   :=NEW.conn_cityobject_id   ,
prot_element_id      :=NEW.prot_element_id      ,
geom                 :=NEW.geom                 ,
--
  function_of_line  :=NEW.function_of_line  ,
  is_gravity        :=NEW.is_gravity        ,
--is_transmission   :=NEW.is_transmission   ,
--is_communication  :=NEW.is_communication  ,
  ext_width         :=NEW.ext_width         ,
  ext_width_unit    :=NEW.ext_width_unit    ,
  ext_height        :=NEW.ext_height        ,
  ext_height_unit   :=NEW.ext_height_unit   ,
  ext_diameter      :=NEW.ext_diameter      ,
  ext_diameter_unit :=NEW.ext_diameter_unit ,
--int_width         :=NEW.int_width         ,
--int_width_unit    :=NEW.int_width_unit    ,
--int_height        :=NEW.int_height        ,
--int_height_unit   :=NEW.int_height_unit   ,
  int_diameter      :=NEW.int_diameter      ,
  int_diameter_unit :=NEW.int_diameter_unit ,
--cross_section     :=NEW.cross_section     ,
--cross_section_unit:=NEW.cross_section_unit,
--slope_range_from  :=NEW.slope_range_from  ,
--slope_range_to    :=NEW.slope_range_to    ,
--slope_range_unit  :=NEW.slope_range_unit  ,
--profile_name      :=NEW.profile_name      ,
--
schema_name                  :=p_schema_name
);
--RAISE NOTICE 'Inserted record with id: %', inserted_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_ins_ntw_feat_distrib_elem_pipe_round (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_NTW_FEAT_DISTRIB_ELEM_PIPE_ROUND
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_upd_ntw_feat_distrib_elem_pipe_round() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_upd_ntw_feat_distrib_elem_pipe_round()
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

EXECUTE format('UPDATE %I.utn9_network_feature AS t SET
ntw_feature_parent_id =%L,
ntw_feature_root_id   =%L,
class                 =%L,
function              =%L,
usage                 =%L,
year_of_construction  =%L,
status                =%L,
location_quality      =%L,
elevation_quality     =%L,
conn_cityobject_id    =%L,
prot_element_id       =%L,
geom                  =%L
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.ntw_feature_parent_id,
NEW.ntw_feature_root_id  ,
NEW.class                ,
NEW.function             ,
NEW.usage                ,
NEW.year_of_construction ,
NEW.status               ,
NEW.location_quality     ,
NEW.elevation_quality    ,
NEW.conn_cityobject_id   ,
NEW.prot_element_id      ,
NEW.geom                 ,
OLD.id
) INTO updated_id;

EXECUTE format('UPDATE %I.utn9_distrib_element AS t SET
function_of_line  =%L,
is_gravity        =%L,'||/* 
is_transmission   =%L,
is_communication  =%L,*/'
ext_width         =%L,
ext_width_unit    =%L,
ext_height        =%L,
ext_height_unit   =%L,
ext_diameter      =%L,
ext_diameter_unit =%L,'||/* 
int_width         =%L,
int_width_unit    =%L,
int_height        =%L,
int_height_unit   =%L,*/'
int_diameter      =%L,
int_diameter_unit =%L,'||/* 
cross_section     =%L,
cross_section_unit=%L,
slope_range_from  =%L,
slope_range_to    =%L,
slope_range_unit  =%L,
profile_name      =%L*/'
WHERE t.id=%L RETURNING id',
p_schema_name,
  NEW.function_of_line  ,
  NEW.is_gravity        ,
--NEW.is_transmission   ,
--NEW.is_communication  ,
  NEW.ext_width         ,
  NEW.ext_width_unit    ,
  NEW.ext_height        ,
  NEW.ext_height_unit   ,
  NEW.ext_diameter      ,
  NEW.ext_diameter_unit ,
--NEW.int_width         ,
--NEW.int_width_unit    ,
--NEW.int_height        ,
--NEW.int_height_unit   ,
  NEW.int_diameter      ,
  NEW.int_diameter_unit ,
--NEW.cross_section     ,
--NEW.cross_section_unit,
--NEW.slope_range_from  ,
--NEW.slope_range_to    ,
--NEW.slope_range_unit  ,
--NEW.profile_name      ,
OLD.id
) INTO updated_id;

-- RAISE NOTICE 'Updated record with id: %',updated_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_upd_ntw_feat_distrib_elem_pipe_round (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view NTW_FEAT_DISTRIB_ELEM_PIPE_ROUND
----------------------------------------------------------------
DROP TRIGGER IF EXISTS utn9_tr_del_ntw_feat_distrib_elem_pipe_round ON citydb_view.utn9_ntw_feat_distrib_elem_pipe_round;
CREATE TRIGGER utn9_tr_del_ntw_feat_distrib_elem_pipe_round
	INSTEAD OF DELETE ON citydb_view.utn9_ntw_feat_distrib_elem_pipe_round
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_del_ntw_feat_distrib_elem_pipe_round ('citydb');

DROP TRIGGER IF EXISTS utn9_tr_ins_ntw_feat_distrib_elem_pipe_round ON citydb_view.utn9_ntw_feat_distrib_elem_pipe_round;
CREATE TRIGGER utn9_tr_ins_ntw_feat_distrib_elem_pipe_round
	INSTEAD OF INSERT ON citydb_view.utn9_ntw_feat_distrib_elem_pipe_round
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_ins_ntw_feat_distrib_elem_pipe_round ('citydb');

DROP TRIGGER IF EXISTS utn9_tr_upd_ntw_feat_distrib_elem_pipe_round ON citydb_view.utn9_ntw_feat_distrib_elem_pipe_round;
CREATE TRIGGER utn9_tr_upd_ntw_feat_distrib_elem_pipe_round
	INSTEAD OF UPDATE ON citydb_view.utn9_ntw_feat_distrib_elem_pipe_round
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_upd_ntw_feat_distrib_elem_pipe_round ('citydb');
--**************************************************************
--**************************************************************

----------------------------------------------------------------
-- Function TR_DEL_NTW_FEAT_PROT_ELEM_BEDDING
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_del_ntw_feat_prot_elem_bedding() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_del_ntw_feat_prot_elem_bedding()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
deleted_id=citydb_pkg.utn9_delete_network_feature(OLD.id, p_schema_name);
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_del_ntw_feat_prot_elem_bedding (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_NTW_FEAT_PROT_ELEM_BEDDING
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_ins_ntw_feat_prot_elem_bedding() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_ins_ntw_feat_prot_elem_bedding()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	inserted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;

inserted_id=citydb_view.utn9_insert_ntw_feat_prot_elem_bedding(
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
--
ntw_feature_parent_id:=NEW.ntw_feature_parent_id,
ntw_feature_root_id  :=NEW.ntw_feature_root_id  ,
class                :=NEW.class                ,
function             :=NEW.function             ,
usage                :=NEW.usage                ,
year_of_construction :=NEW.year_of_construction ,
status               :=NEW.status               ,
location_quality     :=NEW.location_quality     ,
elevation_quality    :=NEW.elevation_quality    ,
conn_cityobject_id   :=NEW.conn_cityobject_id   ,
prot_element_id      :=NEW.prot_element_id      ,
geom                 :=NEW.geom                 ,
--
--ext_width        :=NEW.ext_width        ,
--ext_width_unit   :=NEW.ext_width_unit   ,
--ext_height       :=NEW.ext_height       ,
--ext_height_unit  :=NEW.ext_height_unit  ,
--ext_diameter     :=NEW.ext_diameter     ,
--ext_diameter_unit:=NEW.ext_diameter_unit,
--int_width        :=NEW.int_width        ,
--int_width_unit   :=NEW.int_width_unit   ,
--int_height       :=NEW.int_height       ,
--int_height_unit  :=NEW.int_height_unit  ,
--int_diameter     :=NEW.int_diameter     ,
--int_diameter_unit:=NEW.int_diameter_unit,
  width            :=NEW.width            ,
  width_unit       :=NEW.width_unit       ,
--
schema_name                  :=p_schema_name
);
--RAISE NOTICE 'Inserted record with id: %', inserted_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_ins_ntw_feat_prot_elem_bedding (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_NTW_FEAT_PROT_ELEM_BEDDING
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_upd_ntw_feat_prot_elem_bedding() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_upd_ntw_feat_prot_elem_bedding()
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

EXECUTE format('UPDATE %I.utn9_network_feature AS t SET
ntw_feature_parent_id =%L,
ntw_feature_root_id   =%L,
class                 =%L,
function              =%L,
usage                 =%L,
year_of_construction  =%L,
status                =%L,
location_quality      =%L,
elevation_quality     =%L,
conn_cityobject_id    =%L,
prot_element_id       =%L,
geom                  =%L
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.ntw_feature_parent_id,
NEW.ntw_feature_root_id  ,
NEW.class                ,
NEW.function             ,
NEW.usage                ,
NEW.year_of_construction ,
NEW.status               ,
NEW.location_quality     ,
NEW.elevation_quality    ,
NEW.conn_cityobject_id   ,
NEW.prot_element_id      ,
NEW.geom                 ,
OLD.id
) INTO updated_id;

EXECUTE format('UPDATE %I.utn9_protective_element AS t SET'||/* 
ext_width        =%L,
ext_width_unit   =%L, 
ext_height       =%L,
ext_height_unit  =%L,
ext_diameter     =%L,
ext_diameter_unit=%L,
int_width        =%L,
int_width_unit   =%L,
int_height       =%L,
int_height_unit  =%L, 
int_diameter     =%L,
int_diameter_unit=%L,*/'
width            =%L,
width_unit       =%L
WHERE t.id=%L RETURNING id',
p_schema_name,
--NEW.ext_width        ,
--NEW.ext_width_unit   ,
--NEW.ext_height       ,
--NEW.ext_height_unit  ,
--NEW.ext_diameter     ,
--NEW.ext_diameter_unit,
--NEW.int_width        ,
--NEW.int_width_unit   ,
--NEW.int_height       ,
--NEW.int_height_unit  ,
--NEW.int_diameter     ,
--NEW.int_diameter_unit,
  NEW.width            ,
  NEW.width_unit       ,
OLD.id
) INTO updated_id;

-- RAISE NOTICE 'Updated record with id: %',updated_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_upd_ntw_feat_prot_elem_bedding (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view NTW_FEAT_PROT_ELEM_BEDDING
----------------------------------------------------------------
DROP TRIGGER IF EXISTS utn9_tr_del_ntw_feat_prot_elem_bedding ON citydb_view.utn9_ntw_feat_prot_elem_bedding;
CREATE TRIGGER utn9_tr_del_ntw_feat_prot_elem_bedding
	INSTEAD OF DELETE ON citydb_view.utn9_ntw_feat_prot_elem_bedding
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_del_ntw_feat_prot_elem_bedding ('citydb');

DROP TRIGGER IF EXISTS utn9_tr_ins_ntw_feat_prot_elem_bedding ON citydb_view.utn9_ntw_feat_prot_elem_bedding;
CREATE TRIGGER utn9_tr_ins_ntw_feat_prot_elem_bedding
	INSTEAD OF INSERT ON citydb_view.utn9_ntw_feat_prot_elem_bedding
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_ins_ntw_feat_prot_elem_bedding ('citydb');

DROP TRIGGER IF EXISTS utn9_tr_upd_ntw_feat_prot_elem_bedding ON citydb_view.utn9_ntw_feat_prot_elem_bedding;
CREATE TRIGGER utn9_tr_upd_ntw_feat_prot_elem_bedding
	INSTEAD OF UPDATE ON citydb_view.utn9_ntw_feat_prot_elem_bedding
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_upd_ntw_feat_prot_elem_bedding ('citydb');
--**************************************************************
--**************************************************************

----------------------------------------------------------------
-- Function TR_DEL_NTW_FEAT_PROT_ELEM_SHELL_OTHER
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_del_ntw_feat_prot_elem_shell_other() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_del_ntw_feat_prot_elem_shell_other()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
deleted_id=citydb_pkg.utn9_delete_network_feature(OLD.id, p_schema_name);
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_del_ntw_feat_prot_elem_shell_other (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_NTW_FEAT_PROT_ELEM_SHELL_OTHER
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_ins_ntw_feat_prot_elem_shell_other() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_ins_ntw_feat_prot_elem_shell_other()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	inserted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;

inserted_id=citydb_view.utn9_insert_ntw_feat_prot_elem_shell_other(
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
--
ntw_feature_parent_id:=NEW.ntw_feature_parent_id,
ntw_feature_root_id  :=NEW.ntw_feature_root_id  ,
class                :=NEW.class                ,
function             :=NEW.function             ,
usage                :=NEW.usage                ,
year_of_construction :=NEW.year_of_construction ,
status               :=NEW.status               ,
location_quality     :=NEW.location_quality     ,
elevation_quality    :=NEW.elevation_quality    ,
conn_cityobject_id   :=NEW.conn_cityobject_id   ,
prot_element_id      :=NEW.prot_element_id      ,
geom                 :=NEW.geom                 ,
--
  ext_width        :=NEW.ext_width        ,
  ext_width_unit   :=NEW.ext_width_unit   ,
  ext_height       :=NEW.ext_height       ,
  ext_height_unit  :=NEW.ext_height_unit  ,
  ext_diameter     :=NEW.ext_diameter     ,
  ext_diameter_unit:=NEW.ext_diameter_unit,
--int_width        :=NEW.int_width        ,
--int_width_unit   :=NEW.int_width_unit   ,
--int_height       :=NEW.int_height       ,
--int_height_unit  :=NEW.int_height_unit  ,
--int_diameter     :=NEW.int_diameter     ,
--int_diameter_unit:=NEW.int_diameter_unit,
--width            :=NEW.width            ,
--width_unit       :=NEW.width_unit       ,
--
schema_name                  :=p_schema_name
);
--RAISE NOTICE 'Inserted record with id: %', inserted_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_ins_ntw_feat_prot_elem_shell_other (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_NTW_FEAT_PROT_ELEM_SHELL_OTHER
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_upd_ntw_feat_prot_elem_shell_other() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_upd_ntw_feat_prot_elem_shell_other()
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

EXECUTE format('UPDATE %I.utn9_network_feature AS t SET
ntw_feature_parent_id =%L,
ntw_feature_root_id   =%L,
class                 =%L,
function              =%L,
usage                 =%L,
year_of_construction  =%L,
status                =%L,
location_quality      =%L,
elevation_quality     =%L,
conn_cityobject_id    =%L,
prot_element_id       =%L,
geom                  =%L
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.ntw_feature_parent_id,
NEW.ntw_feature_root_id  ,
NEW.class                ,
NEW.function             ,
NEW.usage                ,
NEW.year_of_construction ,
NEW.status               ,
NEW.location_quality     ,
NEW.elevation_quality    ,
NEW.conn_cityobject_id   ,
NEW.prot_element_id      ,
NEW.geom                 ,
OLD.id
) INTO updated_id;

EXECUTE format('UPDATE %I.utn9_protective_element AS t SET
ext_width        =%L,
ext_width_unit   =%L, 
ext_height       =%L,
ext_height_unit  =%L,
ext_diameter     =%L,
ext_diameter_unit=%L'||/*, 
int_width        =%L,
int_width_unit   =%L,
int_height       =%L,
int_height_unit  =%L, 
int_diameter     =%L,
int_diameter_unit=%L,
width            =%L,
width_unit       =%L*/'
WHERE t.id=%L RETURNING id',
p_schema_name,
  NEW.ext_width        ,
  NEW.ext_width_unit   ,
  NEW.ext_height       ,
  NEW.ext_height_unit  ,
  NEW.ext_diameter     ,
  NEW.ext_diameter_unit,
--NEW.int_width        ,
--NEW.int_width_unit   ,
--NEW.int_height       ,
--NEW.int_height_unit  ,
--NEW.int_diameter     ,
--NEW.int_diameter_unit,
--NEW.width            ,
--NEW.width_unit       ,
OLD.id
) INTO updated_id;

-- RAISE NOTICE 'Updated record with id: %',updated_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_upd_ntw_feat_prot_elem_shell_other (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view NTW_FEAT_PROT_ELEM_SHELL_OTHER
----------------------------------------------------------------
DROP TRIGGER IF EXISTS utn9_tr_del_ntw_feat_prot_elem_shell_other ON citydb_view.utn9_ntw_feat_prot_elem_shell_other;
CREATE TRIGGER utn9_tr_del_ntw_feat_prot_elem_shell_other
	INSTEAD OF DELETE ON citydb_view.utn9_ntw_feat_prot_elem_shell_other
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_del_ntw_feat_prot_elem_shell_other ('citydb');

DROP TRIGGER IF EXISTS utn9_tr_ins_ntw_feat_prot_elem_shell_other ON citydb_view.utn9_ntw_feat_prot_elem_shell_other;
CREATE TRIGGER utn9_tr_ins_ntw_feat_prot_elem_shell_other
	INSTEAD OF INSERT ON citydb_view.utn9_ntw_feat_prot_elem_shell_other
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_ins_ntw_feat_prot_elem_shell_other ('citydb');

DROP TRIGGER IF EXISTS utn9_tr_upd_ntw_feat_prot_elem_shell_other ON citydb_view.utn9_ntw_feat_prot_elem_shell_other;
CREATE TRIGGER utn9_tr_upd_ntw_feat_prot_elem_shell_other
	INSTEAD OF UPDATE ON citydb_view.utn9_ntw_feat_prot_elem_shell_other
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_upd_ntw_feat_prot_elem_shell_other ('citydb');
--**************************************************************
--**************************************************************

----------------------------------------------------------------
-- Function TR_DEL_NTW_FEAT_PROT_ELEM_SHELL_RECT
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_del_ntw_feat_prot_elem_shell_rect() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_del_ntw_feat_prot_elem_shell_rect()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
deleted_id=citydb_pkg.utn9_delete_network_feature(OLD.id, p_schema_name);
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_del_ntw_feat_prot_elem_shell_rect (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_NTW_FEAT_PROT_ELEM_SHELL_RECT
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_ins_ntw_feat_prot_elem_shell_rect() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_ins_ntw_feat_prot_elem_shell_rect()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	inserted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;

inserted_id=citydb_view.utn9_insert_ntw_feat_prot_elem_shell_rect(
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
--
ntw_feature_parent_id:=NEW.ntw_feature_parent_id,
ntw_feature_root_id  :=NEW.ntw_feature_root_id  ,
class                :=NEW.class                ,
function             :=NEW.function             ,
usage                :=NEW.usage                ,
year_of_construction :=NEW.year_of_construction ,
status               :=NEW.status               ,
location_quality     :=NEW.location_quality     ,
elevation_quality    :=NEW.elevation_quality    ,
conn_cityobject_id   :=NEW.conn_cityobject_id   ,
prot_element_id      :=NEW.prot_element_id      ,
geom                 :=NEW.geom                 ,
--
  ext_width        :=NEW.ext_width        ,
  ext_width_unit   :=NEW.ext_width_unit   ,
  ext_height       :=NEW.ext_height       ,
  ext_height_unit  :=NEW.ext_height_unit  ,
  ext_diameter     :=NEW.ext_diameter     ,
  ext_diameter_unit:=NEW.ext_diameter_unit,
  int_width        :=NEW.int_width        ,
  int_width_unit   :=NEW.int_width_unit   ,
  int_height       :=NEW.int_height       ,
  int_height_unit  :=NEW.int_height_unit  ,
--int_diameter     :=NEW.int_diameter     ,
--int_diameter_unit:=NEW.int_diameter_unit,
--width            :=NEW.width            ,
--width_unit       :=NEW.width_unit       ,
--
schema_name                  :=p_schema_name
);
--RAISE NOTICE 'Inserted record with id: %', inserted_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_ins_ntw_feat_prot_elem_shell_rect (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_NTW_FEAT_PROT_ELEM_SHELL_RECT
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_upd_ntw_feat_prot_elem_shell_rect() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_upd_ntw_feat_prot_elem_shell_rect()
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

EXECUTE format('UPDATE %I.utn9_network_feature AS t SET
ntw_feature_parent_id =%L,
ntw_feature_root_id   =%L,
class                 =%L,
function              =%L,
usage                 =%L,
year_of_construction  =%L,
status                =%L,
location_quality      =%L,
elevation_quality     =%L,
conn_cityobject_id    =%L,
prot_element_id       =%L,
geom                  =%L
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.ntw_feature_parent_id,
NEW.ntw_feature_root_id  ,
NEW.class                ,
NEW.function             ,
NEW.usage                ,
NEW.year_of_construction ,
NEW.status               ,
NEW.location_quality     ,
NEW.elevation_quality    ,
NEW.conn_cityobject_id   ,
NEW.prot_element_id      ,
NEW.geom                 ,
OLD.id
) INTO updated_id;

EXECUTE format('UPDATE %I.utn9_protective_element AS t SET
ext_width        =%L,
ext_width_unit   =%L, 
ext_height       =%L,
ext_height_unit  =%L,
ext_diameter     =%L,
ext_diameter_unit=%L,
int_width        =%L,
int_width_unit   =%L,
int_height       =%L,
int_height_unit  =%L'||/*, 
int_diameter     =%L,
int_diameter_unit=%L,
width            =%L,
width_unit       =%L*/'
WHERE t.id=%L RETURNING id',
p_schema_name,
  NEW.ext_width        ,
  NEW.ext_width_unit   ,
  NEW.ext_height       ,
  NEW.ext_height_unit  ,
  NEW.ext_diameter     ,
  NEW.ext_diameter_unit,
  NEW.int_width        ,
  NEW.int_width_unit   ,
  NEW.int_height       ,
  NEW.int_height_unit  ,
--NEW.int_diameter     ,
--NEW.int_diameter_unit,
--NEW.width            ,
--NEW.width_unit       ,
OLD.id
) INTO updated_id;

-- RAISE NOTICE 'Updated record with id: %',updated_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_upd_ntw_feat_prot_elem_shell_rect (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view NTW_FEAT_PROT_ELEM_SHELL_RECT
----------------------------------------------------------------
DROP TRIGGER IF EXISTS utn9_tr_del_ntw_feat_prot_elem_shell_rect ON citydb_view.utn9_ntw_feat_prot_elem_shell_rect;
CREATE TRIGGER utn9_tr_del_ntw_feat_prot_elem_shell_rect
	INSTEAD OF DELETE ON citydb_view.utn9_ntw_feat_prot_elem_shell_rect
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_del_ntw_feat_prot_elem_shell_rect ('citydb');

DROP TRIGGER IF EXISTS utn9_tr_ins_ntw_feat_prot_elem_shell_rect ON citydb_view.utn9_ntw_feat_prot_elem_shell_rect;
CREATE TRIGGER utn9_tr_ins_ntw_feat_prot_elem_shell_rect
	INSTEAD OF INSERT ON citydb_view.utn9_ntw_feat_prot_elem_shell_rect
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_ins_ntw_feat_prot_elem_shell_rect ('citydb');

DROP TRIGGER IF EXISTS utn9_tr_upd_ntw_feat_prot_elem_shell_rect ON citydb_view.utn9_ntw_feat_prot_elem_shell_rect;
CREATE TRIGGER utn9_tr_upd_ntw_feat_prot_elem_shell_rect
	INSTEAD OF UPDATE ON citydb_view.utn9_ntw_feat_prot_elem_shell_rect
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_upd_ntw_feat_prot_elem_shell_rect ('citydb');
--**************************************************************
--**************************************************************

----------------------------------------------------------------
-- Function TR_DEL_NTW_FEAT_PROT_ELEM_SHELL_ROUND
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_del_ntw_feat_prot_elem_shell_round() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_del_ntw_feat_prot_elem_shell_round()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
deleted_id=citydb_pkg.utn9_delete_network_feature(OLD.id, p_schema_name);
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_del_ntw_feat_prot_elem_shell_round (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_NTW_FEAT_PROT_ELEM_SHELL_ROUND
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_ins_ntw_feat_prot_elem_shell_round() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_ins_ntw_feat_prot_elem_shell_round()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	inserted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;

inserted_id=citydb_view.utn9_insert_ntw_feat_prot_elem_shell_round(
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
--
ntw_feature_parent_id:=NEW.ntw_feature_parent_id,
ntw_feature_root_id  :=NEW.ntw_feature_root_id  ,
class                :=NEW.class                ,
function             :=NEW.function             ,
usage                :=NEW.usage                ,
year_of_construction :=NEW.year_of_construction ,
status               :=NEW.status               ,
location_quality     :=NEW.location_quality     ,
elevation_quality    :=NEW.elevation_quality    ,
conn_cityobject_id   :=NEW.conn_cityobject_id   ,
prot_element_id      :=NEW.prot_element_id      ,
geom                 :=NEW.geom                 ,
--
  ext_width        :=NEW.ext_width        ,
  ext_width_unit   :=NEW.ext_width_unit   ,
  ext_height       :=NEW.ext_height       ,
  ext_height_unit  :=NEW.ext_height_unit  ,
  ext_diameter     :=NEW.ext_diameter     ,
  ext_diameter_unit:=NEW.ext_diameter_unit,
--int_width        :=NEW.int_width        ,
--int_width_unit   :=NEW.int_width_unit   ,
--int_height       :=NEW.int_height       ,
--int_height_unit  :=NEW.int_height_unit  ,
  int_diameter     :=NEW.int_diameter     ,
  int_diameter_unit:=NEW.int_diameter_unit,
--width            :=NEW.width            ,
--width_unit       :=NEW.width_unit       ,
--
schema_name                  :=p_schema_name
);
--RAISE NOTICE 'Inserted record with id: %', inserted_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_ins_ntw_feat_prot_elem_shell_round (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_NTW_FEAT_PROT_ELEM_SHELL_ROUND
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_upd_ntw_feat_prot_elem_shell_round() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_upd_ntw_feat_prot_elem_shell_round()
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

EXECUTE format('UPDATE %I.utn9_network_feature AS t SET
ntw_feature_parent_id =%L,
ntw_feature_root_id   =%L,
class                 =%L,
function              =%L,
usage                 =%L,
year_of_construction  =%L,
status                =%L,
location_quality      =%L,
elevation_quality     =%L,
conn_cityobject_id    =%L,
prot_element_id       =%L,
geom                  =%L
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.ntw_feature_parent_id,
NEW.ntw_feature_root_id  ,
NEW.class                ,
NEW.function             ,
NEW.usage                ,
NEW.year_of_construction ,
NEW.status               ,
NEW.location_quality     ,
NEW.elevation_quality    ,
NEW.conn_cityobject_id   ,
NEW.prot_element_id      ,
NEW.geom                 ,
OLD.id
) INTO updated_id;

EXECUTE format('UPDATE %I.utn9_protective_element AS t SET
ext_width        =%L,
ext_width_unit   =%L, 
ext_height       =%L,
ext_height_unit  =%L,
ext_diameter     =%L,
ext_diameter_unit=%L,'||/* 
int_width        =%L,
int_width_unit   =%L,
int_height       =%L,
int_height_unit  =%L,*/' 
int_diameter     =%L,
int_diameter_unit=%L'||/*, 
width            =%L,
width_unit       =%L*/'
WHERE t.id=%L RETURNING id',
p_schema_name,
  NEW.ext_width        ,
  NEW.ext_width_unit   ,
  NEW.ext_height       ,
  NEW.ext_height_unit  ,
  NEW.ext_diameter     ,
  NEW.ext_diameter_unit,
--NEW.int_width        ,
--NEW.int_width_unit   ,
--NEW.int_height       ,
--NEW.int_height_unit  ,
  NEW.int_diameter     ,
  NEW.int_diameter_unit,
--NEW.width            ,
--NEW.width_unit       ,
OLD.id
) INTO updated_id;

-- RAISE NOTICE 'Updated record with id: %',updated_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_upd_ntw_feat_prot_elem_shell_round (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view NTW_FEAT_PROT_ELEM_SHELL_ROUND
----------------------------------------------------------------
DROP TRIGGER IF EXISTS utn9_tr_del_ntw_feat_prot_elem_shell_round ON citydb_view.utn9_ntw_feat_prot_elem_shell_round;
CREATE TRIGGER utn9_tr_del_ntw_feat_prot_elem_shell_round
	INSTEAD OF DELETE ON citydb_view.utn9_ntw_feat_prot_elem_shell_round
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_del_ntw_feat_prot_elem_shell_round ('citydb');

DROP TRIGGER IF EXISTS utn9_tr_ins_ntw_feat_prot_elem_shell_round ON citydb_view.utn9_ntw_feat_prot_elem_shell_round;
CREATE TRIGGER utn9_tr_ins_ntw_feat_prot_elem_shell_round
	INSTEAD OF INSERT ON citydb_view.utn9_ntw_feat_prot_elem_shell_round
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_ins_ntw_feat_prot_elem_shell_round ('citydb');

DROP TRIGGER IF EXISTS utn9_tr_upd_ntw_feat_prot_elem_shell_round ON citydb_view.utn9_ntw_feat_prot_elem_shell_round;
CREATE TRIGGER utn9_tr_upd_ntw_feat_prot_elem_shell_round
	INSTEAD OF UPDATE ON citydb_view.utn9_ntw_feat_prot_elem_shell_round
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_upd_ntw_feat_prot_elem_shell_round ('citydb');
--**************************************************************
--**************************************************************

----------------------------------------------------------------
-- Function TR_DEL_STORAGE
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_del_storage() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_del_storage()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
deleted_id=citydb_pkg.utn9_delete_storage(OLD.id, p_schema_name);
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_del_storage (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_STORAGE
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_ins_storage() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_ins_storage()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	inserted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
inserted_id=citydb_view.utn9_insert_storage(
id               :=NEW.id               ,
type             :=NEW.type             ,
max_capacity     :=NEW.max_capacity     ,
max_capacity_unit:=NEW.max_capacity_unit,
fill_level       :=NEW.fill_level       ,
inflow_rate      :=NEW.inflow_rate      ,
inflow_rate_unit :=NEW.inflow_rate_unit ,
outflow_rate     :=NEW.outflow_rate     ,
outflow_rate_unit:=NEW.outflow_rate_unit,
medium_supply_id :=NEW.medium_supply_id ,
--
schema_name          :=p_schema_name
);
--RAISE NOTICE 'Inserted record with id: %', inserted_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_ins_storage (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_STORAGE
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_upd_storage() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_upd_storage()
  RETURNS trigger AS
$BODY$
DECLARE
  p_schema_name varchar DEFAULT 'citydb'::varchar;
  updated_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
EXECUTE format('UPDATE %I.utn9_commodity AS t SET
id                =%L,
type              =%L,
max_capacity      =%L,
max_capacity_unit =%L,
fill_level        =%L,
inflow_rate       =%L,
inflow_rate_unit  =%L,
outflow_rate      =%L,
outflow_rate_unit =%L,
medium_supply_id  =%L
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.id               ,
NEW.type             ,
NEW.max_capacity     ,
NEW.max_capacity_unit,
NEW.fill_level       ,
NEW.inflow_rate      ,
NEW.inflow_rate_unit ,
NEW.outflow_rate     ,
NEW.outflow_rate_unit,
NEW.medium_supply_id ,
OLD.id
) INTO updated_id;
-- RAISE NOTICE 'Updated record with id: %', updated_id;
RETURN NEW;
EXCEPTION
  WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_upd_storage (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view UTN_STORAGE
----------------------------------------------------------------
DROP TRIGGER IF EXISTS utn9_tr_del_storage ON citydb_view.utn9_storage;
CREATE TRIGGER utn9_tr_del_storage
	INSTEAD OF DELETE ON citydb_view.utn9_storage
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_del_storage ('citydb');

DROP TRIGGER IF EXISTS utn9_tr_ins_storage ON citydb_view.utn9_storage;
CREATE TRIGGER utn9_tr_ins_storage
	INSTEAD OF INSERT ON citydb_view.utn9_storage
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_ins_storage ('citydb');

DROP TRIGGER IF EXISTS utn9_tr_upd_storage ON citydb_view.utn9_storage;
CREATE TRIGGER utn9_tr_upd_storage
	INSTEAD OF UPDATE ON citydb_view.utn9_storage
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_upd_storage ('citydb');
--**************************************************************
--**************************************************************

----------------------------------------------------------------
-- Function TR_DEL_SUPPLY_AREA
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_del_supply_area() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_del_supply_area()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
deleted_id=citydb_pkg.utn9_delete_supply_area(OLD.id, p_schema_name);
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_del_supply_area (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_SUPPLY_AREA
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_ins_supply_area() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_ins_supply_area()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	inserted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;

inserted_id=citydb_view.utn9_insert_supply_area(
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
--
class               :=NEW.class               ,
class_codespace     :=NEW.class_codespace     ,
function            :=NEW.function            ,
function_codespace  :=NEW.function_codespace  ,
usage               :=NEW.usage               ,
usage_codespace     :=NEW.usage_codespace     ,
brep_id             :=NEW.brep_id             ,
other_geom          :=NEW.other_geom          ,
parent_cityobject_id:=NEW.parent_cityobject_id,
--
schema_name                  :=p_schema_name
);
--RAISE NOTICE 'Inserted record with id: %', inserted_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_ins_supply_area (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_SUPPLY_AREA
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_upd_supply_area() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_upd_supply_area()
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
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_upd_supply_area (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view SUPPLY_AREA
----------------------------------------------------------------
DROP TRIGGER IF EXISTS utn9_tr_del_supply_area ON citydb_view.utn9_supply_area;
CREATE TRIGGER utn9_tr_del_supply_area
	INSTEAD OF DELETE ON citydb_view.utn9_supply_area
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_del_supply_area ('citydb');

DROP TRIGGER IF EXISTS utn9_tr_ins_supply_area ON citydb_view.utn9_supply_area;
CREATE TRIGGER utn9_tr_ins_supply_area
	INSTEAD OF INSERT ON citydb_view.utn9_supply_area
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_ins_supply_area ('citydb');

DROP TRIGGER IF EXISTS utn9_tr_upd_supply_area ON citydb_view.utn9_supply_area;
CREATE TRIGGER utn9_tr_upd_supply_area
	INSTEAD OF UPDATE ON citydb_view.utn9_supply_area
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_upd_supply_area ('citydb');
--**************************************************************
--**************************************************************

----------------------------------------------------------------
-- Function TR_DEL_ROLE_IN_NETWORK
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_del_role_in_network() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_del_role_in_network()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
deleted_id=citydb_pkg.utn9_delete_role_in_network(OLD.id, p_schema_name);
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_del_role_in_network (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_ROLE_IN_NETWORK
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_ins_role_in_network() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_ins_role_in_network()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	inserted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
inserted_id=citydb_view.utn9_insert_role_in_network(
id             :=NEW.id             ,
gmlid          :=NEW.gmlid          ,
gmlid_codespace:=NEW.gmlid_codespace,
name           :=NEW.name           ,
name_codespace :=NEW.name_codespace ,
description    :=NEW.description    ,
function       :=NEW.function       ,
usage          :=NEW.usage          ,
cityobject_id  :=NEW.cityobject_id  ,
network_id     :=NEW.network_id     ,
--
schema_name          :=p_schema_name
);
--RAISE NOTICE 'Inserted record with id: %', inserted_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_ins_role_in_network (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_ROLE_IN_NETWORK
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_upd_role_in_network() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_upd_role_in_network()
  RETURNS trigger AS
$BODY$
DECLARE
  p_schema_name varchar DEFAULT 'citydb'::varchar;
  updated_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
EXECUTE format('UPDATE %I.utn9_role_in_network AS t SET
id             =%L,
gmlid          =%L,
gmlid_codespace=%L,
name           =%L,
name_codespace =%L,
description    =%L,
function       =%L,
usage          =%L,
cityobject_id  =%L,
network_id     =%L
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.id             ,
NEW.gmlid          ,
NEW.gmlid_codespace,
NEW.name           ,
NEW.name_codespace ,
NEW.description    ,
NEW.function       ,
NEW.usage          ,
NEW.cityobject_id  ,
NEW.network_id     ,
OLD.id
) INTO updated_id;
-- RAISE NOTICE 'Updated record with id: %', updated_id;
RETURN NEW;
EXCEPTION
  WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_upd_role_in_network (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view UTN_ROLE_IN_NETWORK
----------------------------------------------------------------
DROP TRIGGER IF EXISTS utn9_tr_del_role_in_network ON citydb_view.utn9_role_in_network;
CREATE TRIGGER utn9_tr_del_role_in_network
	INSTEAD OF DELETE ON citydb_view.utn9_role_in_network
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_del_role_in_network ('citydb');

DROP TRIGGER IF EXISTS utn9_tr_ins_role_in_network ON citydb_view.utn9_role_in_network;
CREATE TRIGGER utn9_tr_ins_role_in_network
	INSTEAD OF INSERT ON citydb_view.utn9_role_in_network
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_ins_role_in_network ('citydb');

DROP TRIGGER IF EXISTS utn9_tr_upd_role_in_network ON citydb_view.utn9_role_in_network;
CREATE TRIGGER utn9_tr_upd_role_in_network
	INSTEAD OF UPDATE ON citydb_view.utn9_role_in_network
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_upd_role_in_network ('citydb');
--**************************************************************
--**************************************************************

----------------------------------------------------------------
-- Function TR_DEL_COMMODITY
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_del_commodity() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_del_commodity()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
deleted_id=citydb_pkg.utn9_delete_commodity(OLD.id, p_schema_name);
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_del_commodity (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_COMMODITY
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_ins_commodity() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_ins_commodity()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	inserted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;

inserted_id=citydb_view.utn9_insert_commodity(
classname                    :=NEW.classname                   ,
id                           :=NEW.id                          ,
gmlid                        :=NEW.gmlid                       ,
gmlid_codespace              :=NEW.gmlid_codespace             ,
name                         :=NEW.name                        ,
name_codespace               :=NEW.name_codespace              ,
description                  :=NEW.description                 ,
owner                        :=NEW.owner                       ,
type                         :=NEW.type                        ,
is_corrosive                 :=NEW.is_corrosive                ,
is_explosive                 :=NEW.is_explosive                ,
is_lighter_than_air          :=NEW.is_lighter_than_air         ,
flammability_ratio           :=NEW.flammability_ratio          ,
elec_conductivity_range_from :=NEW.elec_conductivity_range_from,
elec_conductivity_range_to   :=NEW.elec_conductivity_range_to  ,
elec_conductivity_range_unit :=NEW.elec_conductivity_range_unit,
concentration                :=NEW.concentration               ,
concentration_unit           :=NEW.concentration_unit          ,
ph_value_range_from          :=NEW.ph_value_range_from         ,
ph_value_range_to            :=NEW.ph_value_range_to           ,
ph_value_range_unit          :=NEW.ph_value_range_unit         ,
temperature_range_from       :=NEW.temperature_range_from      ,
temperature_range_to         :=NEW.temperature_range_to        ,
temperature_range_unit       :=NEW.temperature_range_unit      ,
flow_rate_range_from         :=NEW.flow_rate_range_from        ,
flow_rate_range_to           :=NEW.flow_rate_range_to          ,
flow_rate_range_unit         :=NEW.flow_rate_range_unit        ,
pressure_range_from          :=NEW.pressure_range_from         ,
pressure_range_to            :=NEW.pressure_range_to           ,
pressure_range_unit          :=NEW.pressure_range_unit         ,
voltage_range_from           :=NEW.voltage_range_from          ,
voltage_range_to             :=NEW.voltage_range_to            ,
voltage_range_unit           :=NEW.voltage_range_unit          ,
amperage_range_from          :=NEW.amperage_range_from         ,
amperage_range_to            :=NEW.amperage_range_to           ,
amperage_range_unit          :=NEW.amperage_range_unit         ,
bandwidth_range_from         :=NEW.bandwidth_range_from        ,
bandwidth_range_to           :=NEW.bandwidth_range_to          ,
bandwidth_range_unit         :=NEW.bandwidth_range_unit        ,
optical_mode                 :=NEW.optical_mode                ,
--
schema_name          :=p_schema_name
);
--RAISE NOTICE 'Inserted record with id: %', inserted_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_ins_commodity (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_COMMODITY
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_upd_commodity() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_upd_commodity()
  RETURNS trigger AS
$BODY$
DECLARE
  p_schema_name varchar DEFAULT 'citydb'::varchar;
  updated_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF; 
EXECUTE format('UPDATE %I.utn9_commodity AS t SET
gmlid                        =%L,
gmlid_codespace              =%L,
name                         =%L,
name_codespace               =%L,
description                  =%L,
owner                        =%L,
type                         =%L,
is_corrosive                 =%L,
is_explosive                 =%L,
is_lighter_than_air          =%L,
flammability_ratio           =%L,
elec_conductivity_range_from =%L,
elec_conductivity_range_to   =%L,
elec_conductivity_range_unit =%L,
concentration                =%L,
concentration_unit           =%L,
ph_value_range_from          =%L,
ph_value_range_to            =%L,
ph_value_range_unit          =%L,
temperature_range_from       =%L,
temperature_range_to         =%L,
temperature_range_unit       =%L,
flow_rate_range_from         =%L,
flow_rate_range_to           =%L,
flow_rate_range_unit         =%L,
pressure_range_from          =%L,
pressure_range_to            =%L,
pressure_range_unit          =%L,
voltage_range_from           =%L,
voltage_range_to             =%L,
voltage_range_unit           =%L,
amperage_range_from          =%L,
amperage_range_to            =%L,
amperage_range_unit          =%L,
bandwidth_range_from         =%L,
bandwidth_range_to           =%L,
bandwidth_range_unit         =%L,
optical_mode                 =%L
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.gmlid                       ,
NEW.gmlid_codespace             ,
NEW.name                        ,
NEW.name_codespace              ,
NEW.description                 ,
NEW.owner                       ,
NEW.type                        ,
NEW.is_corrosive                ,
NEW.is_explosive                ,
NEW.is_lighter_than_air         ,
NEW.flammability_ratio          ,
NEW.elec_conductivity_range_from,
NEW.elec_conductivity_range_to  ,
NEW.elec_conductivity_range_unit,
NEW.concentration               ,
NEW.concentration_unit          ,
NEW.ph_value_range_from         ,
NEW.ph_value_range_to           ,
NEW.ph_value_range_unit         ,
NEW.temperature_range_from      ,
NEW.temperature_range_to        ,
NEW.temperature_range_unit      ,
NEW.flow_rate_range_from        ,
NEW.flow_rate_range_to          ,
NEW.flow_rate_range_unit        ,
NEW.pressure_range_from         ,
NEW.pressure_range_to           ,
NEW.pressure_range_unit         ,
NEW.voltage_range_from          ,
NEW.voltage_range_to            ,
NEW.voltage_range_unit          ,
NEW.amperage_range_from         ,
NEW.amperage_range_to           ,
NEW.amperage_range_unit         ,
NEW.bandwidth_range_from        ,
NEW.bandwidth_range_to          ,
NEW.bandwidth_range_unit        ,
NEW.optical_mode                ,
OLD.id
) INTO updated_id;
-- RAISE NOTICE 'Updated record with id: %', updated_id;
RETURN NEW;
EXCEPTION
  WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_upd_commodity (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view UTN_COMMODITY
----------------------------------------------------------------
DROP TRIGGER IF EXISTS utn9_tr_del_commodity ON citydb_view.utn9_commodity;
CREATE TRIGGER utn9_tr_del_commodity
	INSTEAD OF DELETE ON citydb_view.utn9_commodity
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_del_commodity ('citydb');

DROP TRIGGER IF EXISTS utn9_tr_ins_commodity ON citydb_view.utn9_commodity;
CREATE TRIGGER utn9_tr_ins_commodity
	INSTEAD OF INSERT ON citydb_view.utn9_commodity
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_ins_commodity ('citydb');

DROP TRIGGER IF EXISTS utn9_tr_upd_commodity ON citydb_view.utn9_commodity;
CREATE TRIGGER utn9_tr_upd_commodity
	INSTEAD OF UPDATE ON citydb_view.utn9_commodity
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_upd_commodity ('citydb');
--**************************************************************
--**************************************************************

----------------------------------------------------------------
-- Function TR_DEL_NETWORK_COMMODITY
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_del_network_commodity() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_del_network_commodity()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
deleted_id=citydb_pkg.utn9_delete_network(OLD.id, p_schema_name);
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_del_network_commodity (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_NETWORK_COMMODITY
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_ins_network_commodity() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_ins_network_commodity()
  RETURNS trigger AS
$BODY$
DECLARE
    com_id integer;
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	inserted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;

IF NEW.com_classname IS NOT NULL THEN
 com_id=citydb_view.utn9_insert_commodity(
   classname                    :=NEW.com_classname                   ,
   id                           :=NEW.com_id                          ,
   gmlid                        :=NEW.com_gmlid                       ,
   gmlid_codespace              :=NEW.com_gmlid_codespace             ,
   name                         :=NEW.com_name                        ,
   name_codespace               :=NEW.com_name_codespace              ,
   description                  :=NEW.com_description                 ,
   owner                        :=NEW.com_owner                       ,
   type                         :=NEW.com_type                        ,
   is_corrosive                 :=NEW.com_is_corrosive                ,
   is_explosive                 :=NEW.com_is_explosive                ,
   is_lighter_than_air          :=NEW.com_is_lighter_than_air         ,
   flammability_ratio           :=NEW.com_flammability_ratio          ,
   elec_conductivity_range_from :=NEW.com_elec_conductivity_range_from,
   elec_conductivity_range_to   :=NEW.com_elec_conductivity_range_to  ,
   elec_conductivity_range_unit :=NEW.com_elec_conductivity_range_unit,
   concentration                :=NEW.com_concentration               ,
   concentration_unit           :=NEW.com_concentration_unit          ,
   ph_value_range_from          :=NEW.com_ph_value_range_from         ,
   ph_value_range_to            :=NEW.com_ph_value_range_to           ,
   ph_value_range_unit          :=NEW.com_ph_value_range_unit         ,
   temperature_range_from       :=NEW.com_temperature_range_from      ,
   temperature_range_to         :=NEW.com_temperature_range_to        ,
   temperature_range_unit       :=NEW.com_temperature_range_unit      ,
   flow_rate_range_from         :=NEW.com_flow_rate_range_from        ,
   flow_rate_range_to           :=NEW.com_flow_rate_range_to          ,
   flow_rate_range_unit         :=NEW.com_flow_rate_range_unit        ,
   pressure_range_from          :=NEW.com_pressure_range_from         ,
   pressure_range_to            :=NEW.com_pressure_range_to           ,
   pressure_range_unit          :=NEW.com_pressure_range_unit         ,
   voltage_range_from           :=NEW.com_voltage_range_from          ,
   voltage_range_to             :=NEW.com_voltage_range_to            ,
   voltage_range_unit           :=NEW.com_voltage_range_unit          ,
   amperage_range_from          :=NEW.com_amperage_range_from         ,
   amperage_range_to            :=NEW.com_amperage_range_to           ,
   amperage_range_unit          :=NEW.com_amperage_range_unit         ,
   bandwidth_range_from         :=NEW.com_bandwidth_range_from        ,
   bandwidth_range_to           :=NEW.com_bandwidth_range_to          ,
   bandwidth_range_unit         :=NEW.com_bandwidth_range_unit        ,
   optical_mode                 :=NEW.com_optical_mode                ,
--
   schema_name          :=p_schema_name
);
ELSE
 com_id=NULL;
END IF;

inserted_id=citydb_view.utn9_insert_network(
  id                     :=NEW.id                    ,
  gmlid                  :=NEW.gmlid                 ,
  gmlid_codespace        :=NEW.gmlid_codespace       ,
  name                   :=NEW.name                  ,
  name_codespace         :=NEW.name_codespace        ,
  description            :=NEW.description           ,
  envelope               :=NEW.envelope              ,
  creation_date          :=NEW.creation_date         ,
  termination_date       :=NEW.termination_date      ,
  relative_to_terrain    :=NEW.relative_to_terrain   ,
  relative_to_water      :=NEW.relative_to_water     ,
  last_modification_date :=NEW.last_modification_date,
  updating_person        :=NEW.updating_person       ,
  reason_for_update      :=NEW.reason_for_update     ,
  lineage                :=NEW.lineage               ,
  network_parent_id      :=NEW.network_parent_id     ,
  network_root_id        :=NEW.network_root_id       ,
  class                  :=NEW.class                 ,
  function               :=NEW.function              ,
  usage                  :=NEW.usage                 ,
  commodity_id           :=com_id                    ,
--
  schema_name          :=p_schema_name
);

--RAISE NOTICE 'Inserted record with id: %', inserted_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_ins_network_commodity (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_NETWORK_COMMODITY
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.utn9_tr_upd_network_commodity() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.utn9_tr_upd_network_commodity()
  RETURNS trigger AS
$BODY$
DECLARE
  p_schema_name varchar DEFAULT 'citydb'::varchar;
  updated_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;

EXECUTE format('UPDATE %I.utn9_commodity AS t SET
gmlid                        =%L,
gmlid_codespace              =%L,
name                         =%L,
name_codespace               =%L,
description                  =%L,
owner                        =%L,
type                         =%L,
is_corrosive                 =%L,
is_explosive                 =%L,
is_lighter_than_air          =%L,
flammability_ratio           =%L,
elec_conductivity_range_from =%L,
elec_conductivity_range_to   =%L,
elec_conductivity_range_unit =%L,
concentration                =%L,
concentration_unit           =%L,
ph_value_range_from          =%L,
ph_value_range_to            =%L,
ph_value_range_unit          =%L,
temperature_range_from       =%L,
temperature_range_to         =%L,
temperature_range_unit       =%L,
flow_rate_range_from         =%L,
flow_rate_range_to           =%L,
flow_rate_range_unit         =%L,
pressure_range_from          =%L,
pressure_range_to            =%L,
pressure_range_unit          =%L,
voltage_range_from           =%L,
voltage_range_to             =%L,
voltage_range_unit           =%L,
amperage_range_from          =%L,
amperage_range_to            =%L,
amperage_range_unit          =%L,
bandwidth_range_from         =%L,
bandwidth_range_to           =%L,
bandwidth_range_unit         =%L,
optical_mode                 =%L
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.gmlid                       ,
NEW.gmlid_codespace             ,
NEW.name                        ,
NEW.name_codespace              ,
NEW.description                 ,
NEW.owner                       ,
NEW.type                        ,
NEW.is_corrosive                ,
NEW.is_explosive                ,
NEW.is_lighter_than_air         ,
NEW.flammability_ratio          ,
NEW.elec_conductivity_range_from,
NEW.elec_conductivity_range_to  ,
NEW.elec_conductivity_range_unit,
NEW.concentration               ,
NEW.concentration_unit          ,
NEW.ph_value_range_from         ,
NEW.ph_value_range_to           ,
NEW.ph_value_range_unit         ,
NEW.temperature_range_from      ,
NEW.temperature_range_to        ,
NEW.temperature_range_unit      ,
NEW.flow_rate_range_from        ,
NEW.flow_rate_range_to          ,
NEW.flow_rate_range_unit        ,
NEW.pressure_range_from         ,
NEW.pressure_range_to           ,
NEW.pressure_range_unit         ,
NEW.voltage_range_from          ,
NEW.voltage_range_to            ,
NEW.voltage_range_unit          ,
NEW.amperage_range_from         ,
NEW.amperage_range_to           ,
NEW.amperage_range_unit         ,
NEW.bandwidth_range_from        ,
NEW.bandwidth_range_to          ,
NEW.bandwidth_range_unit        ,
NEW.optical_mode                ,
OLD.com_id
) INTO updated_id;

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

EXECUTE format('UPDATE %I.utn9_network AS t SET
network_parent_id =%L,
network_root_id   =%L,
class             =%L,
function          =%L,
usage             =%L,
commodity_id      =%L
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.network_parent_id,
NEW.network_root_id  ,
NEW.class            ,
NEW.function         ,
NEW.usage            ,
NEW.commodity_id     ,
OLD.id
) INTO updated_id;

-- RAISE NOTICE 'Updated record with id: %', updated_id;
RETURN NEW;
EXCEPTION
  WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_tr_upd_network_commodity (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view UTN_NETWORK_COMMODITY
----------------------------------------------------------------
DROP TRIGGER IF EXISTS utn9_tr_del_network_commodity ON citydb_view.utn9_network_commodity;
CREATE TRIGGER utn9_tr_del_network_commodity
	INSTEAD OF DELETE ON citydb_view.utn9_network_commodity
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_del_network_commodity ('citydb');

DROP TRIGGER IF EXISTS utn9_tr_ins_network_commodity ON citydb_view.utn9_network_commodity;
CREATE TRIGGER utn9_tr_ins_network_commodity
	INSTEAD OF INSERT ON citydb_view.utn9_network_commodity
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_ins_network_commodity ('citydb');

DROP TRIGGER IF EXISTS utn9_tr_upd_network_commodity ON citydb_view.utn9_network_commodity;
CREATE TRIGGER utn9_tr_upd_network_commodity
	INSTEAD OF UPDATE ON citydb_view.utn9_network_commodity
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.utn9_tr_upd_network_commodity ('citydb');
--**************************************************************
--**************************************************************




-- ***********************************************************************
-- ***********************************************************************

DO
$$
BEGIN
RAISE NOTICE '

********************************

Utility Network ADE view triggers installation complete!

********************************

';
END
$$;
SELECT 'Utility Network ADE view triggers installed correctly!'::varchar AS installation_result;


-- ***********************************************************************
-- ***********************************************************************
--
-- END OF FILE
--
-- ***********************************************************************
-- ***********************************************************************