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
-- ******************* 08_Scenario_ADE_VIEW_TRIGGERS.sql *****************
--
-- This script adds triggers and trigger functions to schema citydb_view
-- in order to make some views updatable. They are all prefixed with
-- "scn2_".
--
-- ***********************************************************************
-- ***********************************************************************

----------------------------------------------------------------
-- Function TR_DEL_RESOURCE_ENERGY
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.scn2_tr_del_resource_energy() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.scn2_tr_del_resource_energy()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
deleted_id=citydb_pkg.scn2_delete_resource(OLD.id, p_schema_name);
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.scn2_tr_del_resource_energy (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_RESOURCE_ENERGY
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.scn2_tr_ins_resource_energy() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.scn2_tr_ins_resource_energy()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	inserted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
inserted_id=citydb_view.scn2_insert_energy_resource(
id                :=NEW.id               ,
gmlid             :=NEW.gmlid            ,
gmlid_codespace   :=NEW.gmlid_codespace  ,
name              :=NEW.name             ,
name_codespace    :=NEW.name_codespace   ,
description       :=NEW.description      ,
type              :=NEW.type             ,
quantity          :=NEW.quantity         ,
quantity_unit     :=NEW.quantity_unit    ,
total_cost        :=NEW.total_cost       ,
total_cost_unit   :=NEW.total_cost_unit  ,
unitary_cost      :=NEW.unitary_cost     ,
unitary_cost_unit :=NEW.unitary_cost_unit,	
is_renewable      :=NEW.is_renewable     ,
scenario_id       :=NEW.scenario_id      ,
operation_id      :=NEW.operation_id     ,
--
schema_name          :=p_schema_name
);
--RAISE NOTICE 'Inserted record with id: %', inserted_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.scn2_tr_ins_resource_energy (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_RESOURCE_ENERGY
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.scn2_tr_upd_resource_energy() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.scn2_tr_upd_resource_energy()
  RETURNS trigger AS
$BODY$
DECLARE
  p_schema_name varchar DEFAULT 'citydb'::varchar;
  updated_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
EXECUTE format('UPDATE %I.scn2_resource AS t SET
-- no id no cityobjectclass
gmlid             =%L,
gmlid_codespace   =%L,
name              =%L,
name_codespace    =%L,
description       =%L,
type              =%L,
quantity          =%L,
quantity_unit     =%L,
total_cost        =%L,
total_cost_unit   =%L,
unitary_cost      =%L,
unitary_cost_unit =%L,	
is_renewable      =%L,
scenario_id       =%L,
operation_id      =%L
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.gmlid            ,
NEW.gmlid_codespace  ,
NEW.name             ,
NEW.name_codespace   ,
NEW.description      ,
NEW.type             ,
NEW.quantity         ,
NEW.quantity_unit    ,
NEW.total_cost       ,
NEW.total_cost_unit  ,
NEW.unitary_cost     ,
NEW.unitary_cost_unit,
NEW.is_renewable     ,
NEW.scenario_id      ,
NEW.operation_id     ,
OLD.id
) INTO updated_id;
-- RAISE NOTICE 'Updated record with id: %', updated_id;
RETURN NEW;
EXCEPTION
  WHEN OTHERS THEN RAISE NOTICE 'citydb_view.scn2_tr_upd_resource_energy (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view SCN_RESOURCE_ENERGY
----------------------------------------------------------------
DROP TRIGGER IF EXISTS scn2_tr_del_resource_energy ON citydb_view.scn2_resource_energy;
CREATE TRIGGER scn2_tr_del_resource_energy
	INSTEAD OF DELETE ON citydb_view.scn2_resource_energy
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.scn2_tr_del_resource_energy ('citydb');

DROP TRIGGER IF EXISTS scn2_tr_ins_resource_energy ON citydb_view.scn2_resource_energy;
CREATE TRIGGER scn2_tr_ins_resource_energy
	INSTEAD OF INSERT ON citydb_view.scn2_resource_energy
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.scn2_tr_ins_resource_energy ('citydb');

DROP TRIGGER IF EXISTS scn2_tr_upd_resource_energy ON citydb_view.scn2_resource_energy;
CREATE TRIGGER scn2_tr_upd_resource_energy
	INSTEAD OF UPDATE ON citydb_view.scn2_resource_energy
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.scn2_tr_upd_resource_energy ('citydb');
--**************************************************************
--**************************************************************

----------------------------------------------------------------
-- Function TR_DEL_RESOURCE_MATERIAL
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.scn2_tr_del_resource_material() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.scn2_tr_del_resource_material()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
deleted_id=citydb_pkg.scn2_delete_resource(OLD.id, p_schema_name);
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.scn2_tr_del_resource_material (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_RESOURCE_MATERIAL
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.scn2_tr_ins_resource_material() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.scn2_tr_ins_resource_material()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	inserted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
inserted_id=citydb_view.scn2_insert_material_resource(
id                :=NEW.id               ,
gmlid             :=NEW.gmlid            ,
gmlid_codespace   :=NEW.gmlid_codespace  ,
name              :=NEW.name             ,
name_codespace    :=NEW.name_codespace   ,
description       :=NEW.description      ,
type              :=NEW.type             ,
quantity          :=NEW.quantity         ,
quantity_unit     :=NEW.quantity_unit    ,
total_cost        :=NEW.total_cost       ,
total_cost_unit   :=NEW.total_cost_unit  ,
unitary_cost      :=NEW.unitary_cost     ,
unitary_cost_unit :=NEW.unitary_cost_unit,	
is_renewable      :=NEW.is_renewable     ,
scenario_id       :=NEW.scenario_id      ,
operation_id      :=NEW.operation_id     ,
--
schema_name          :=p_schema_name
);
--RAISE NOTICE 'Inserted record with id: %', inserted_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.scn2_tr_ins_resource_material (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_RESOURCE_MATERIAL
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.scn2_tr_upd_resource_material() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.scn2_tr_upd_resource_material()
  RETURNS trigger AS
$BODY$
DECLARE
  p_schema_name varchar DEFAULT 'citydb'::varchar;
  updated_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
EXECUTE format('UPDATE %I.scn2_resource AS t SET
-- no id no cityobjectclass
gmlid             =%L,
gmlid_codespace   =%L,
name              =%L,
name_codespace    =%L,
description       =%L,
type              =%L,
quantity          =%L,
quantity_unit     =%L,
total_cost        =%L,
total_cost_unit   =%L,
unitary_cost      =%L,
unitary_cost_unit =%L,	
is_renewable      =%L,
scenario_id       =%L,
operation_id      =%L
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.gmlid            ,
NEW.gmlid_codespace  ,
NEW.name             ,
NEW.name_codespace   ,
NEW.description      ,
NEW.type             ,
NEW.quantity         ,
NEW.quantity_unit    ,
NEW.total_cost       ,
NEW.total_cost_unit  ,
NEW.unitary_cost     ,
NEW.unitary_cost_unit,
NEW.is_renewable     ,
NEW.scenario_id      ,
NEW.operation_id     ,
OLD.id
) INTO updated_id;
-- RAISE NOTICE 'Updated record with id: %', updated_id;
RETURN NEW;
EXCEPTION
  WHEN OTHERS THEN RAISE NOTICE 'citydb_view.scn2_tr_upd_resource_material (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view SCN_RESOURCE_MATERIAL
----------------------------------------------------------------
DROP TRIGGER IF EXISTS scn2_tr_del_resource_material ON citydb_view.scn2_resource_material;
CREATE TRIGGER scn2_tr_del_resource_material
	INSTEAD OF DELETE ON citydb_view.scn2_resource_material
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.scn2_tr_del_resource_material ('citydb');

DROP TRIGGER IF EXISTS scn2_tr_ins_resource_material ON citydb_view.scn2_resource_material;
CREATE TRIGGER scn2_tr_ins_resource_material
	INSTEAD OF INSERT ON citydb_view.scn2_resource_material
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.scn2_tr_ins_resource_material ('citydb');

DROP TRIGGER IF EXISTS scn2_tr_upd_resource_material ON citydb_view.scn2_resource_material;
CREATE TRIGGER scn2_tr_upd_resource_material
	INSTEAD OF UPDATE ON citydb_view.scn2_resource_material
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.scn2_tr_upd_resource_material ('citydb');
--**************************************************************
--**************************************************************

----------------------------------------------------------------
-- Function TR_DEL_RESOURCE_MONEY
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.scn2_tr_del_resource_money() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.scn2_tr_del_resource_money()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
deleted_id=citydb_pkg.scn2_delete_resource(OLD.id, p_schema_name);
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.scn2_tr_del_resource_money (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_RESOURCE_MONEY
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.scn2_tr_ins_resource_money() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.scn2_tr_ins_resource_money()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	inserted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
inserted_id=citydb_view.scn2_insert_money_resource(
id                :=NEW.id               ,
gmlid             :=NEW.gmlid            ,
gmlid_codespace   :=NEW.gmlid_codespace  ,
name              :=NEW.name             ,
name_codespace    :=NEW.name_codespace   ,
description       :=NEW.description      ,
type              :=NEW.type             ,
quantity          :=NEW.quantity         ,
quantity_unit     :=NEW.quantity_unit    ,
total_cost        :=NEW.total_cost       ,
total_cost_unit   :=NEW.total_cost_unit  ,
unitary_cost      :=NEW.unitary_cost     ,
unitary_cost_unit :=NEW.unitary_cost_unit,	
is_renewable      :=NEW.is_renewable     ,
scenario_id       :=NEW.scenario_id      ,
operation_id      :=NEW.operation_id     ,
--
schema_name          :=p_schema_name
);
--RAISE NOTICE 'Inserted record with id: %', inserted_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.scn2_tr_ins_resource_money (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_RESOURCE_MONEY
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.scn2_tr_upd_resource_money() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.scn2_tr_upd_resource_money()
  RETURNS trigger AS
$BODY$
DECLARE
  p_schema_name varchar DEFAULT 'citydb'::varchar;
  updated_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
EXECUTE format('UPDATE %I.scn2_resource AS t SET
-- no id no cityobjectclass
gmlid             =%L,
gmlid_codespace   =%L,
name              =%L,
name_codespace    =%L,
description       =%L,
type              =%L,
quantity          =%L,
quantity_unit     =%L,
total_cost        =%L,
total_cost_unit   =%L,
unitary_cost      =%L,
unitary_cost_unit =%L,	
is_renewable      =%L,
scenario_id       =%L,
operation_id      =%L
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.gmlid            ,
NEW.gmlid_codespace  ,
NEW.name             ,
NEW.name_codespace   ,
NEW.description      ,
NEW.type             ,
NEW.quantity         ,
NEW.quantity_unit    ,
NEW.total_cost       ,
NEW.total_cost_unit  ,
NEW.unitary_cost     ,
NEW.unitary_cost_unit,
NEW.is_renewable     ,
NEW.scenario_id      ,
NEW.operation_id     ,
OLD.id
) INTO updated_id;
-- RAISE NOTICE 'Updated record with id: %', updated_id;
RETURN NEW;
EXCEPTION
  WHEN OTHERS THEN RAISE NOTICE 'citydb_view.scn2_tr_upd_resource_money (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view SCN_RESOURCE_MONEY
----------------------------------------------------------------
DROP TRIGGER IF EXISTS scn2_tr_del_resource_money ON citydb_view.scn2_resource_money;
CREATE TRIGGER scn2_tr_del_resource_money
	INSTEAD OF DELETE ON citydb_view.scn2_resource_money
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.scn2_tr_del_resource_money ('citydb');

DROP TRIGGER IF EXISTS scn2_tr_ins_resource_money ON citydb_view.scn2_resource_money;
CREATE TRIGGER scn2_tr_ins_resource_money
	INSTEAD OF INSERT ON citydb_view.scn2_resource_money
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.scn2_tr_ins_resource_money ('citydb');

DROP TRIGGER IF EXISTS scn2_tr_upd_resource_money ON citydb_view.scn2_resource_money;
CREATE TRIGGER scn2_tr_upd_resource_money
	INSTEAD OF UPDATE ON citydb_view.scn2_resource_money
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.scn2_tr_upd_resource_money ('citydb');
--**************************************************************
--**************************************************************

----------------------------------------------------------------
-- Function TR_DEL_RESOURCE_OTHER
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.scn2_tr_del_resource_other() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.scn2_tr_del_resource_other()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
deleted_id=citydb_pkg.scn2_delete_resource(OLD.id, p_schema_name);
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.scn2_tr_del_resource_other (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_RESOURCE_OTHER
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.scn2_tr_ins_resource_other() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.scn2_tr_ins_resource_other()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	inserted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
inserted_id=citydb_view.scn2_insert_other_resource(
id                :=NEW.id               ,
gmlid             :=NEW.gmlid            ,
gmlid_codespace   :=NEW.gmlid_codespace  ,
name              :=NEW.name             ,
name_codespace    :=NEW.name_codespace   ,
description       :=NEW.description      ,
type              :=NEW.type             ,
quantity          :=NEW.quantity         ,
quantity_unit     :=NEW.quantity_unit    ,
total_cost        :=NEW.total_cost       ,
total_cost_unit   :=NEW.total_cost_unit  ,
unitary_cost      :=NEW.unitary_cost     ,
unitary_cost_unit :=NEW.unitary_cost_unit,	
is_renewable      :=NEW.is_renewable     ,
scenario_id       :=NEW.scenario_id      ,
operation_id      :=NEW.operation_id     ,
--
schema_name          :=p_schema_name
);
--RAISE NOTICE 'Inserted record with id: %', inserted_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.scn2_tr_ins_resource_other (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_RESOURCE_OTHER
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.scn2_tr_upd_resource_other() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.scn2_tr_upd_resource_other()
  RETURNS trigger AS
$BODY$
DECLARE
  p_schema_name varchar DEFAULT 'citydb'::varchar;
  updated_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
EXECUTE format('UPDATE %I.scn2_resource AS t SET
-- no id no cityobjectclass
gmlid             =%L,
gmlid_codespace   =%L,
name              =%L,
name_codespace    =%L,
description       =%L,
type              =%L,
quantity          =%L,
quantity_unit     =%L,
total_cost        =%L,
total_cost_unit   =%L,
unitary_cost      =%L,
unitary_cost_unit =%L,	
is_renewable      =%L,
scenario_id       =%L,
operation_id      =%L
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.gmlid            ,
NEW.gmlid_codespace  ,
NEW.name             ,
NEW.name_codespace   ,
NEW.description      ,
NEW.type             ,
NEW.quantity         ,
NEW.quantity_unit    ,
NEW.total_cost       ,
NEW.total_cost_unit  ,
NEW.unitary_cost     ,
NEW.unitary_cost_unit,
NEW.is_renewable     ,
NEW.scenario_id      ,
NEW.operation_id     ,
OLD.id
) INTO updated_id;
-- RAISE NOTICE 'Updated record with id: %', updated_id;
RETURN NEW;
EXCEPTION
  WHEN OTHERS THEN RAISE NOTICE 'citydb_view.scn2_tr_upd_resource_other (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view SCN_RESOURCE_OTHER
----------------------------------------------------------------
DROP TRIGGER IF EXISTS scn2_tr_del_resource_other ON citydb_view.scn2_resource_other;
CREATE TRIGGER scn2_tr_del_resource_other
	INSTEAD OF DELETE ON citydb_view.scn2_resource_other
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.scn2_tr_del_resource_other ('citydb');

DROP TRIGGER IF EXISTS scn2_tr_ins_resource_other ON citydb_view.scn2_resource_other;
CREATE TRIGGER scn2_tr_ins_resource_other
	INSTEAD OF INSERT ON citydb_view.scn2_resource_other
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.scn2_tr_ins_resource_other ('citydb');

DROP TRIGGER IF EXISTS scn2_tr_upd_resource_other ON citydb_view.scn2_resource_other;
CREATE TRIGGER scn2_tr_upd_resource_other
	INSTEAD OF UPDATE ON citydb_view.scn2_resource_other
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.scn2_tr_upd_resource_other ('citydb');
--**************************************************************
--**************************************************************

----------------------------------------------------------------
-- Function TR_DEL_RESOURCE_TIME
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.scn2_tr_del_resource_time() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.scn2_tr_del_resource_time()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
deleted_id=citydb_pkg.scn2_delete_resource(OLD.id, p_schema_name);
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.scn2_tr_del_resource_time (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_RESOURCE_TIME
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.scn2_tr_ins_resource_time() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.scn2_tr_ins_resource_time()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	inserted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
inserted_id=citydb_view.scn2_insert_time_resource(
id                :=NEW.id               ,
gmlid             :=NEW.gmlid            ,
gmlid_codespace   :=NEW.gmlid_codespace  ,
name              :=NEW.name             ,
name_codespace    :=NEW.name_codespace   ,
description       :=NEW.description      ,
type              :=NEW.type             ,
quantity          :=NEW.quantity         ,
quantity_unit     :=NEW.quantity_unit    ,
total_cost        :=NEW.total_cost       ,
total_cost_unit   :=NEW.total_cost_unit  ,
unitary_cost      :=NEW.unitary_cost     ,
unitary_cost_unit :=NEW.unitary_cost_unit,	
is_renewable      :=NEW.is_renewable     ,
scenario_id       :=NEW.scenario_id      ,
operation_id      :=NEW.operation_id     ,
--
schema_name          :=p_schema_name
);
--RAISE NOTICE 'Inserted record with id: %', inserted_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.scn2_tr_ins_resource_time (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_RESOURCE_TIME
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.scn2_tr_upd_resource_time() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.scn2_tr_upd_resource_time()
  RETURNS trigger AS
$BODY$
DECLARE
  p_schema_name varchar DEFAULT 'citydb'::varchar;
  updated_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
EXECUTE format('UPDATE %I.scn2_resource AS t SET
gmlid             =%L,
gmlid_codespace   =%L,
name              =%L,
name_codespace    =%L,
description       =%L,
type              =%L,
quantity          =%L,
quantity_unit     =%L,
total_cost        =%L,
total_cost_unit   =%L,
unitary_cost      =%L,
unitary_cost_unit =%L,	
is_renewable      =%L,
scenario_id       =%L,
operation_id      =%L
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.gmlid            ,
NEW.gmlid_codespace  ,
NEW.name             ,
NEW.name_codespace   ,
NEW.description      ,
NEW.type             ,
NEW.quantity         ,
NEW.quantity_unit    ,
NEW.total_cost       ,
NEW.total_cost_unit  ,
NEW.unitary_cost     ,
NEW.unitary_cost_unit,
NEW.is_renewable     ,
NEW.scenario_id      ,
NEW.operation_id     ,
OLD.id
) INTO updated_id;
-- RAISE NOTICE 'Updated record with id: %', updated_id;
RETURN NEW;
EXCEPTION
  WHEN OTHERS THEN RAISE NOTICE 'citydb_view.scn2_tr_upd_resource_time (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view SCN_RESOURCE_TIME
----------------------------------------------------------------
DROP TRIGGER IF EXISTS scn2_tr_del_resource_time ON citydb_view.scn2_resource_time;
CREATE TRIGGER scn2_tr_del_resource_time
	INSTEAD OF DELETE ON citydb_view.scn2_resource_time
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.scn2_tr_del_resource_time ('citydb');

DROP TRIGGER IF EXISTS scn2_tr_ins_resource_time ON citydb_view.scn2_resource_time;
CREATE TRIGGER scn2_tr_ins_resource_time
	INSTEAD OF INSERT ON citydb_view.scn2_resource_time
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.scn2_tr_ins_resource_time ('citydb');

DROP TRIGGER IF EXISTS scn2_tr_upd_resource_time ON citydb_view.scn2_resource_time;
CREATE TRIGGER scn2_tr_upd_resource_time
	INSTEAD OF UPDATE ON citydb_view.scn2_resource_time
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.scn2_tr_upd_resource_time ('citydb');
--**************************************************************
--**************************************************************

----------------------------------------------------------------
-- Function TR_DEL_SCENARIO
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.scn2_tr_del_scenario() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.scn2_tr_del_scenario()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
deleted_id=citydb_pkg.scn2_delete_scenario(OLD.id, p_schema_name);
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.scn2_tr_del_scenario (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_SCENARIO
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.scn2_tr_ins_scenario() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.scn2_tr_ins_scenario()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	inserted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
inserted_id=citydb_view.scn2_insert_scenario(
id                 :=NEW.id                ,
scenario_parent_id :=NEW.scenario_parent_id,
gmlid              :=NEW.gmlid             ,
gmlid_codespace    :=NEW.gmlid_codespace   ,
name               :=NEW.name              ,
name_codespace     :=NEW.name_codespace    ,
description        :=NEW.description       ,
class              :=NEW.class             ,
instant            :=NEW.instant           ,
period_begin       :=NEW.period_begin      ,
period_end         :=NEW.period_end        ,
citymodel_id       :=NEW.citymodel_id      ,
cityobject_id      :=NEW.cityobject_id     ,
envelope           :=NEW.envelope          ,		
creator_name       :=NEW.creator_name      ,
creation_date      :=NEW.creation_date     ,
--
schema_name        :=p_schema_name
);
--RAISE NOTICE 'Inserted record with id: %', inserted_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.scn2_tr_ins_scenario (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_SCENARIO
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.scn2_tr_upd_scenario() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.scn2_tr_upd_scenario()
  RETURNS trigger AS
$BODY$
DECLARE
  p_schema_name varchar DEFAULT 'citydb'::varchar;
  updated_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
EXECUTE format('UPDATE %I.scn2_scenario AS t SET
scenario_parent_id=%L,
gmlid             =%L,
gmlid_codespace   =%L,
name              =%L,
name_codespace    =%L,
description       =%L,
class             =%L,
instant           =%L,
period_begin      =%L,
period_end        =%L,
citymodel_id      =%L,
cityobject_id     =%L,
envelope          =%L,
creator_name      =%L,
creation_date     =%L
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.scenario_parent_id,
NEW.gmlid             ,
NEW.gmlid_codespace   ,
NEW.name              ,
NEW.name_codespace    ,
NEW.description       ,
NEW.class             ,
NEW.instant           ,
NEW.period_begin      ,
NEW.period_end        ,
NEW.citymodel_id      ,
NEW.cityobject_id     ,
NEW.envelope          ,
NEW.creator_name      ,
NEW.creation_date     ,
OLD.id
) INTO updated_id;
-- RAISE NOTICE 'Updated record with id: %', updated_id;
RETURN NEW;
EXCEPTION
  WHEN OTHERS THEN RAISE NOTICE 'citydb_view.scn2_tr_upd_scenario (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view SCN_SCENARIO
----------------------------------------------------------------
DROP TRIGGER IF EXISTS scn2_tr_del_scenario ON citydb_view.scn2_scenario;
CREATE TRIGGER scn2_tr_del_scenario
	INSTEAD OF DELETE ON citydb_view.scn2_scenario
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.scn2_tr_del_scenario ('citydb');

DROP TRIGGER IF EXISTS scn2_tr_ins_scenario ON citydb_view.scn2_scenario;
CREATE TRIGGER scn2_tr_ins_scenario
	INSTEAD OF INSERT ON citydb_view.scn2_scenario
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.scn2_tr_ins_scenario ('citydb');

DROP TRIGGER IF EXISTS scn2_tr_upd_scenario ON citydb_view.scn2_scenario;
CREATE TRIGGER scn2_tr_upd_scenario
	INSTEAD OF UPDATE ON citydb_view.scn2_scenario
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.scn2_tr_upd_scenario ('citydb');
--**************************************************************
--**************************************************************

----------------------------------------------------------------
-- Function TR_DEL_SCENARIO_PARAMETER
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.scn2_tr_del_scenario_parameter() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.scn2_tr_del_scenario_parameter()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
deleted_id=citydb_pkg.scn2_delete_scenario_parameter(OLD.id, p_schema_name);
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.scn2_tr_del_scenario_parameter (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_SCENARIO_PARAMETER
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.scn2_tr_ins_scenario_parameter() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.scn2_tr_ins_scenario_parameter()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	inserted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
inserted_id=citydb_view.scn2_insert_scenario_parameter(
id              :=NEW.id              ,
type            :=NEW.type            ,
name            :=NEW.name            ,
name_codespace  :=NEW.name_codespace  ,
description     :=NEW.description     ,
class           :=NEW.class           ,
constraint_type :=NEW.constraint_type ,
sim_name        :=NEW.sim_name        ,
sim_description :=NEW.sim_description ,
sim_reference   :=NEW.sim_reference   ,
aggregation_type:=NEW.aggregation_type,
temp_aggregation:=NEW.temp_aggregation,	
strval          :=NEW.strval          ,
booleanval      :=NEW.booleanval      ,
intval          :=NEW.intval          ,
realval         :=NEW.realval         ,
unit            :=NEW.unit            ,
dateval         :=NEW.dateval         ,
urival          :=NEW.urival          ,
geomval         :=NEW.geomval         ,
time_series_id  :=NEW.time_series_id  ,
cityobject_id   :=NEW.cityobject_id   ,
scenario_id     :=NEW.scenario_id     ,
schema_name          :=p_schema_name
);
--RAISE NOTICE 'Inserted record with id: %', inserted_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.scn2_tr_ins_scenario_parameter (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_SCENARIO_PARAMETER
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.scn2_tr_upd_scenario_parameter() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.scn2_tr_upd_scenario_parameter()
  RETURNS trigger AS
$BODY$
DECLARE
  p_schema_name varchar DEFAULT 'citydb'::varchar;
  updated_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
EXECUTE format('UPDATE %I.scn2_scenario_parameter AS t SET
type            =%L,
name            =%L,
name_codespace  =%L,
description     =%L,
class           =%L,
constraint_type =%L,
sim_name        =%L,
sim_description =%L,
sim_reference   =%L,
aggregation_type=%L,
temp_aggregation=%L,
strval          =%L,
booleanval      =%L,
intval          =%L,
realval         =%L,
unit            =%L,
dateval         =%L,
urival          =%L,
geomval         =%L,
time_series_id  =%L,
cityobject_id   =%L,
scenario_id     =%L
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.type            ,
NEW.name            ,
NEW.name_codespace  ,
NEW.description     ,
NEW.class           ,
NEW.constraint_type ,
NEW.sim_name        ,
NEW.sim_description ,
NEW.sim_reference   ,
NEW.aggregation_type,
NEW.temp_aggregation,
NEW.strval          ,
NEW.booleanval      ,
NEW.intval          ,
NEW.realval         ,
NEW.unit            ,
NEW.dateval         ,
NEW.urival          ,
NEW.geomval         ,
NEW.time_series_id  ,
NEW.cityobject_id   ,
NEW.scenario_id     ,
OLD.id
) INTO updated_id;
-- RAISE NOTICE 'Updated record with id: %', updated_id;
RETURN NEW;
EXCEPTION
  WHEN OTHERS THEN RAISE NOTICE 'citydb_view.scn2_tr_upd_scenario_parameter (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view SCN_SCENARIO_PARAMETER
----------------------------------------------------------------
DROP TRIGGER IF EXISTS scn2_tr_del_scenario_parameter ON citydb_view.scn2_scenario_parameter;
CREATE TRIGGER scn2_tr_del_scenario_parameter
	INSTEAD OF DELETE ON citydb_view.scn2_scenario_parameter
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.scn2_tr_del_scenario_parameter ('citydb');

DROP TRIGGER IF EXISTS scn2_tr_ins_scenario_parameter ON citydb_view.scn2_scenario_parameter;
CREATE TRIGGER scn2_tr_ins_scenario_parameter
	INSTEAD OF INSERT ON citydb_view.scn2_scenario_parameter
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.scn2_tr_ins_scenario_parameter ('citydb');

DROP TRIGGER IF EXISTS scn2_tr_upd_scenario_parameter ON citydb_view.scn2_scenario_parameter;
CREATE TRIGGER scn2_tr_upd_scenario_parameter
	INSTEAD OF UPDATE ON citydb_view.scn2_scenario_parameter
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.scn2_tr_upd_scenario_parameter ('citydb');
--**************************************************************
--**************************************************************

----------------------------------------------------------------
-- Function TR_DEL_SCENARIO_PARAMETER_TS
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.scn2_tr_del_scenario_parameter_ts() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.scn2_tr_del_scenario_parameter_ts()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
deleted_id=citydb_pkg.scn2_delete_scenario_parameter(OLD.id, p_schema_name);
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.scn2_tr_del_scenario_parameter_ts (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_SCENARIO_PARAMETER_TS
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.scn2_tr_ins_scenario_parameter_ts() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.scn2_tr_ins_scenario_parameter_ts()
  RETURNS trigger AS
$BODY$
DECLARE
	ts_id integer;
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	inserted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;

IF NEW.ts_classname IS NOT NULL THEN 
 ts_id=citydb_view.scn2_insert_time_series(
  classname            :=NEW.ts_classname            ,
  id                   :=NEW.ts_id                   ,
  gmlid                :=NEW.ts_gmlid                ,
  gmlid_codespace      :=NEW.ts_gmlid_codespace      ,
  name                 :=NEW.ts_name                 ,
  name_codespace       :=NEW.ts_name_codespace       ,
  description          :=NEW.ts_description          ,
  acquisition_method   :=NEW.ts_acquisition_method   ,
  interpolation_type   :=NEW.ts_interpolation_type   ,
  quality_description  :=NEW.ts_quality_description  ,
  source               :=NEW.ts_source               ,
  time_array           :=NEW.ts_time_array           ,
  values_array         :=NEW.ts_values_array         ,
  values_unit          :=NEW.ts_values_unit          ,
  array_length         :=NEW.ts_array_length         ,
  temporal_extent_begin:=NEW.ts_temporal_extent_begin,
  temporal_extent_end  :=NEW.ts_temporal_extent_end  ,
  time_interval        :=NEW.ts_time_interval        ,
  time_interval_unit   :=NEW.ts_time_interval_unit   ,
  --
  file_path            :=NEW.ts_file_path            ,
  file_name            :=NEW.ts_file_name            ,
  file_extension       :=NEW.ts_file_extension       ,
  nbr_header_lines     :=NEW.ts_nbr_header_lines     ,
  field_sep            :=NEW.ts_field_sep            ,
  record_sep           :=NEW.ts_record_sep           ,
  dec_symbol           :=NEW.ts_dec_symbol           ,
  time_col_nbr         :=NEW.ts_time_col_nbr         ,
  value_col_nbr        :=NEW.ts_value_col_nbr        ,
  is_compressed        :=NEW.ts_is_compressed        ,
  --
  schema_name          :=p_schema_name
);
ELSE
 ts_id=NULL;
END IF;

inserted_id=citydb_view.scn2_insert_scenario_parameter(
id              :=NEW.id              ,
type            :=NEW.type            ,
name            :=NEW.name            ,
name_codespace  :=NEW.name_codespace  ,
description     :=NEW.description     ,
class           :=NEW.class           ,
constraint_type :=NEW.constraint_type ,
sim_name        :=NEW.sim_name        ,
sim_description :=NEW.sim_description ,
sim_reference   :=NEW.sim_reference   ,
aggregation_type:=NEW.aggregation_type,
temp_aggregation:=NEW.temp_aggregation,	
strval          :=NEW.strval          ,
booleanval      :=NEW.booleanval      ,
intval          :=NEW.intval          ,
realval         :=NEW.realval         ,
unit            :=NEW.unit            ,
dateval         :=NEW.dateval         ,
urival          :=NEW.urival          ,
geomval         :=NEW.geomval         ,
time_series_id  :=ts_id,
cityobject_id   :=NEW.cityobject_id   ,
scenario_id     :=NEW.scenario_id     ,
schema_name          :=p_schema_name
);
--RAISE NOTICE 'Inserted record with id: %', inserted_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.scn2_tr_ins_scenario_parameter_ts (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_SCENARIO_PARAMETER_TS
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.scn2_tr_upd_scenario_parameter_ts() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.scn2_tr_upd_scenario_parameter_ts()
  RETURNS trigger AS
$BODY$
DECLARE
  p_schema_name varchar DEFAULT 'citydb'::varchar;
  updated_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;

EXECUTE format('UPDATE %I.scn2_time_series AS t SET
gmlid                =%L,
gmlid_codespace      =%L,
name                 =%L,
name_codespace       =%L,
description          =%L,
acquisition_method   =%L,
interpolation_type   =%L,
quality_description  =%L,
source               =%L,
time_array           =%L,
values_array         =%L,
values_unit          =%L,
array_length         =%L,
temporal_extent_begin=%L,
temporal_extent_end  =%L,
time_interval        =%L, 
time_interval_unit   =%L 
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.ts_gmlid,
NEW.ts_gmlid_codespace,
NEW.ts_name,
NEW.ts_name_codespace,
NEW.ts_description,	
NEW.ts_acquisition_method,
NEW.ts_interpolation_type,
NEW.ts_quality_description,
NEW.ts_source,
NEW.ts_time_array,
NEW.ts_values_array,
NEW.ts_values_unit,
NEW.ts_array_length,
NEW.ts_temporal_extent_begin,
NEW.ts_temporal_extent_end, 
NEW.ts_time_interval, 
NEW.ts_time_interval_unit, 
OLD.ts_id
) INTO updated_id;

IF OLD.ts_classname IN ('RegularTimeSeriesFile', 'IrregularTimeSeriesFile') THEN
	EXECUTE format('UPDATE %I.scn2_time_series_file AS t SET
	file_path            =%L,
	file_name            =%L,
	file_extension       =%L,
	nbr_header_lines     =%L,
	field_sep            =%L,
	record_sep           =%L,
	dec_symbol           =%L,
	time_col_nbr         =%L,
	value_col_nbr        =%L,
	is_compressed        =%L
	WHERE t.id=%L RETURNING id',
	p_schema_name,
	NEW.ts_file_path,
	NEW.ts_file_name,
	NEW.ts_file_extension,
	NEW.ts_nbr_header_lines,
	NEW.ts_field_sep,
	NEW.ts_record_sep,
	NEW.ts_dec_symbol,
	NEW.ts_time_col_nbr,
	NEW.ts_value_col_nbr,
	NEW.ts_is_compressed,
	OLD.ts_id
	) INTO updated_id;
END IF;

EXECUTE format('UPDATE %I.scn2_scenario_parameter AS t SET
type            =%L,
name            =%L,
name_codespace  =%L,
description     =%L,
class           =%L,
constraint_type =%L,
sim_name        =%L,
sim_description =%L,
sim_reference   =%L,
aggregation_type=%L,
temp_aggregation=%L,
strval          =%L,
booleanval      =%L,
intval          =%L,
realval         =%L,
unit            =%L,
dateval         =%L,
urival          =%L,
geomval         =%L,
time_series_id  =%L,
cityobject_id   =%L,
scenario_id     =%L
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.type            ,
NEW.name            ,
NEW.name_codespace  ,
NEW.description     ,
NEW.class           ,
NEW.constraint_type ,
NEW.sim_name        ,
NEW.sim_description ,
NEW.sim_reference   ,
NEW.aggregation_type,
NEW.temp_aggregation,
NEW.strval          ,
NEW.booleanval      ,
NEW.intval          ,
NEW.realval         ,
NEW.unit            ,
NEW.dateval         ,
NEW.urival          ,
NEW.geomval         ,
NEW.time_series_id  ,
NEW.cityobject_id   ,
NEW.scenario_id     ,
OLD.id
) INTO updated_id;
-- RAISE NOTICE 'Updated record with id: %', updated_id;
RETURN NEW;
EXCEPTION
  WHEN OTHERS THEN RAISE NOTICE 'citydb_view.scn2_tr_upd_scenario_parameter_ts (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view SCN_SCENARIO_PARAMETER_TS
----------------------------------------------------------------
DROP TRIGGER IF EXISTS scn2_tr_del_scenario_parameter_ts ON citydb_view.scn2_scenario_parameter_ts;
CREATE TRIGGER scn2_tr_del_scenario_parameter_ts
	INSTEAD OF DELETE ON citydb_view.scn2_scenario_parameter_ts
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.scn2_tr_del_scenario_parameter_ts ('citydb');

DROP TRIGGER IF EXISTS scn2_tr_ins_scenario_parameter_ts ON citydb_view.scn2_scenario_parameter_ts;
CREATE TRIGGER scn2_tr_ins_scenario_parameter_ts
	INSTEAD OF INSERT ON citydb_view.scn2_scenario_parameter_ts
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.scn2_tr_ins_scenario_parameter_ts ('citydb');

DROP TRIGGER IF EXISTS scn2_tr_upd_scenario_parameter_ts ON citydb_view.scn2_scenario_parameter_ts;
CREATE TRIGGER scn2_tr_upd_scenario_parameter_ts
	INSTEAD OF UPDATE ON citydb_view.scn2_scenario_parameter_ts
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.scn2_tr_upd_scenario_parameter_ts ('citydb');
--**************************************************************
--**************************************************************

----------------------------------------------------------------
-- Function TR_DEL_TIME_SERIES_REGULAR
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.scn2_tr_del_time_series_regular() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.scn2_tr_del_time_series_regular()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
deleted_id=citydb_pkg.scn2_delete_time_series(OLD.id, p_schema_name);
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.scn2_tr_del_time_series_regular (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_TIME_SERIES_REGULAR
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.scn2_tr_ins_time_series_regular() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.scn2_tr_ins_time_series_regular()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	inserted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
inserted_id=citydb_view.scn2_insert_regular_time_series(
id                   :=NEW.id,
gmlid                :=NEW.gmlid,
gmlid_codespace      :=NEW.gmlid_codespace,
name                 :=NEW.name,
name_codespace       :=NEW.name_codespace,
description          :=NEW.description,	
acquisition_method   :=NEW.acquisition_method,
interpolation_type   :=NEW.interpolation_type,
quality_description  :=NEW.quality_description,
source               :=NEW.source,
values_array         :=NEW.values_array,
values_unit          :=NEW.values_unit,
array_length         :=NEW.array_length,
temporal_extent_begin:=NEW.temporal_extent_begin,
temporal_extent_end  :=NEW.temporal_extent_end,
time_interval        :=NEW.time_interval,
time_interval_unit   :=NEW.time_interval_unit,
schema_name          :=p_schema_name
);
--RAISE NOTICE 'Inserted record with id: %', inserted_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.scn2_tr_ins_time_series_regular (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_TIME_SERIES_REGULAR
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.scn2_tr_upd_time_series_regular() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.scn2_tr_upd_time_series_regular()
  RETURNS trigger AS
$BODY$
DECLARE
  p_schema_name varchar DEFAULT 'citydb'::varchar;
  updated_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
EXECUTE format('UPDATE %I.scn2_time_series AS t SET
gmlid                =%L,
gmlid_codespace      =%L,
name                 =%L,
name_codespace       =%L,
description          =%L,
acquisition_method   =%L,
interpolation_type   =%L,
quality_description  =%L,
source               =%L,
values_array         =%L,
values_unit          =%L,
array_length         =%L,
temporal_extent_begin=%L,
temporal_extent_end  =%L,
time_interval        =%L, 
time_interval_unit   =%L 
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.gmlid,
NEW.gmlid_codespace,
NEW.name,
NEW.name_codespace,
NEW.description,	
NEW.acquisition_method,
NEW.interpolation_type,
NEW.quality_description,
NEW.source,
NEW.values_array,
NEW.values_unit,
NEW.array_length,
NEW.temporal_extent_begin,
NEW.temporal_extent_end, 
NEW.time_interval, 
NEW.time_interval_unit, 
OLD.id
) INTO updated_id;
-- RAISE NOTICE 'Updated record with id: %', updated_id;
RETURN NEW;
EXCEPTION
  WHEN OTHERS THEN RAISE NOTICE 'citydb_view.scn2_tr_upd_time_series_regular (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view TIME_SERIES_REGULAR
----------------------------------------------------------------
DROP TRIGGER IF EXISTS scn2_tr_del_time_series_regular ON citydb_view.scn2_time_series_regular;
CREATE TRIGGER scn2_tr_del_time_series_regular
	INSTEAD OF DELETE ON citydb_view.scn2_time_series_regular
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.scn2_tr_del_time_series_regular ('citydb');

DROP TRIGGER IF EXISTS scn2_tr_ins_time_series_regular ON citydb_view.scn2_time_series_regular;
CREATE TRIGGER scn2_tr_ins_time_series_regular
	INSTEAD OF INSERT ON citydb_view.scn2_time_series_regular
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.scn2_tr_ins_time_series_regular ('citydb');

DROP TRIGGER IF EXISTS scn2_tr_upd_time_series_regular ON citydb_view.scn2_time_series_regular;
CREATE TRIGGER scn2_tr_upd_time_series_regular
	INSTEAD OF UPDATE ON citydb_view.scn2_time_series_regular
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.scn2_tr_upd_time_series_regular ('citydb');
--**************************************************************
--**************************************************************

----------------------------------------------------------------
-- Function TR_DEL_TIME_SERIES_IRREGULAR
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.scn2_tr_del_time_series_irregular() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.scn2_tr_del_time_series_irregular()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
deleted_id=citydb_pkg.scn2_delete_time_series(OLD.id, p_schema_name);
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.scn2_tr_del_time_series_irregular (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_TIME_SERIES_IRREGULAR
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.scn2_tr_ins_time_series_irregular() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.scn2_tr_ins_time_series_irregular()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	inserted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
inserted_id=citydb_view.scn2_insert_irregular_time_series(
id                   :=NEW.id,
gmlid                :=NEW.gmlid,
gmlid_codespace      :=NEW.gmlid_codespace,
name                 :=NEW.name,
name_codespace       :=NEW.name_codespace,
description          :=NEW.description,
acquisition_method   :=NEW.acquisition_method,
interpolation_type   :=NEW.interpolation_type,
quality_description  :=NEW.quality_description,
source               :=NEW.source,
time_array           :=NEW.time_array,
values_array         :=NEW.values_array,
values_unit          :=NEW.values_unit,
array_length         :=NEW.array_length,
schema_name          :=p_schema_name
);
--RAISE NOTICE 'Inserted record with id: %', inserted_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.scn2_tr_ins_time_series_irregular (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_TIME_SERIES_IRREGULAR
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.scn2_tr_upd_time_series_irregular() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.scn2_tr_upd_time_series_irregular()
  RETURNS trigger AS
$BODY$
DECLARE
  p_schema_name varchar DEFAULT 'citydb'::varchar;
  updated_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
EXECUTE format('UPDATE %I.scn2_time_series AS t SET
gmlid              =%L,
gmlid_codespace    =%L,
name               =%L,
name_codespace     =%L,
description        =%L,
acquisition_method =%L,
interpolation_type =%L,
quality_description=%L,
source             =%L,
time_array         =%L,
values_array       =%L,
values_unit        =%L,
array_length       =%L
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.gmlid,
NEW.gmlid_codespace,
NEW.name,
NEW.name_codespace,
NEW.description,	
NEW.acquisition_method,
NEW.interpolation_type,
NEW.quality_description,
NEW.source,
NEW.time_array,
NEW.values_array,
NEW.values_unit, 
NEW.array_length, 
OLD.id
) INTO updated_id;
-- RAISE NOTICE 'Updated record with id: %',updated_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.scn2_tr_upd_time_series_irregular (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view TIME_SERIES_IRREGULAR
----------------------------------------------------------------
DROP TRIGGER IF EXISTS scn2_tr_del_time_series_irregular ON citydb_view.scn2_time_series_irregular;
CREATE TRIGGER scn2_tr_del_time_series_irregular
	INSTEAD OF DELETE ON citydb_view.scn2_time_series_irregular
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.scn2_tr_del_time_series_irregular ('citydb');

DROP TRIGGER IF EXISTS scn2_tr_ins_time_series_irregular ON citydb_view.scn2_time_series_irregular;
CREATE TRIGGER scn2_tr_ins_time_series_irregular
	INSTEAD OF INSERT ON citydb_view.scn2_time_series_irregular
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.scn2_tr_ins_time_series_irregular ('citydb');

DROP TRIGGER IF EXISTS scn2_tr_upd_time_series_irregular ON citydb_view.scn2_time_series_irregular;
CREATE TRIGGER scn2_tr_upd_time_series_irregular
	INSTEAD OF UPDATE ON citydb_view.scn2_time_series_irregular
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.scn2_tr_upd_time_series_irregular ('citydb');
-- ***********************************************************************
-- ***********************************************************************

----------------------------------------------------------------
-- Function TR_DEL_TIME_SERIES_REGULAR_FILE
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.scn2_tr_del_time_series_regular_file() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.scn2_tr_del_time_series_regular_file()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
deleted_id=citydb_pkg.scn2_delete_time_series(OLD.id, p_schema_name);
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.scn2_tr_del_time_series_regular_file (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_TIME_SERIES_REGULAR_FILE
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.scn2_tr_ins_time_series_regular_file() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.scn2_tr_ins_time_series_regular_file()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	inserted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
inserted_id=citydb_view.scn2_insert_regular_time_series_file(
id                   :=NEW.id,
gmlid                :=NEW.gmlid,
gmlid_codespace      :=NEW.gmlid_codespace,
name                 :=NEW.name,
name_codespace       :=NEW.name_codespace,
description          :=NEW.description,	
acquisition_method   :=NEW.acquisition_method,
interpolation_type   :=NEW.interpolation_type,
quality_description  :=NEW.quality_description,
source               :=NEW.source,
values_unit          :=NEW.values_unit,
temporal_extent_begin:=NEW.temporal_extent_begin,
temporal_extent_end  :=NEW.temporal_extent_end,
time_interval        :=NEW.time_interval,
time_interval_unit   :=NEW.time_interval_unit,
file_path            :=NEW.file_path,
file_name            :=NEW.file_name,
file_extension       :=NEW.file_extension,
nbr_header_lines     :=NEW.nbr_header_lines,
field_sep            :=NEW.field_sep,
record_sep           :=NEW.record_sep,
dec_symbol           :=NEW.dec_symbol,
value_col_nbr        :=NEW.value_col_nbr,
is_compressed        :=NEW.is_compressed,
schema_name          :=p_schema_name
);
--RAISE NOTICE 'Inserted record with id: %', inserted_id;
  RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.scn2_tr_ins_time_series_regular_file (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_TIME_SERIES_REGULAR_FILE
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.scn2_tr_upd_time_series_regular_file() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.scn2_tr_upd_time_series_regular_file()
  RETURNS trigger AS
$BODY$
DECLARE
  p_schema_name varchar DEFAULT 'citydb'::varchar;
  updated_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
  p_schema_name=TG_ARGV[0];
END IF;
EXECUTE format('UPDATE %I.scn2_time_series AS t SET
gmlid                =%L,
gmlid_codespace      =%L,
name                 =%L,
name_codespace       =%L,
description          =%L,
acquisition_method   =%L,
interpolation_type   =%L,
quality_description  =%L,
source               =%L,
values_unit          =%L,
temporal_extent_begin=%L,
temporal_extent_end  =%L,
time_interval        =%L, 
time_interval_unit   =%L 
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.gmlid,
NEW.gmlid_codespace,
NEW.name,
NEW.name_codespace,
NEW.description,	
NEW.acquisition_method,
NEW.interpolation_type,
NEW.quality_description,
NEW.source,
NEW.values_unit,
NEW.temporal_extent_begin,
NEW.temporal_extent_end, 
NEW.time_interval, 
NEW.time_interval_unit, 
OLD.id
) INTO updated_id;
EXECUTE format('UPDATE %I.scn2_time_series_file AS t SET
file_path       =%L,
file_name       =%L,
file_extension  =%L,
nbr_header_lines=%L,
field_sep       =%L,
record_sep      =%L,
dec_symbol      =%L,
value_col_nbr   =%L,
is_compressed   =%L 
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.file_path,
NEW.file_name,
NEW.file_extension,
NEW.nbr_header_lines,
NEW.field_sep,
NEW.record_sep, 
NEW.dec_symbol, 
NEW.value_col_nbr, 
NEW.is_compressed, 
OLD.id
) INTO updated_id;
-- RAISE NOTICE 'Updated record with id: %',updated_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.scn2_tr_upd_time_series_regular_file (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view TIME_SERIES_REGULAR_FILE
----------------------------------------------------------------
DROP TRIGGER IF EXISTS scn2_tr_del_time_series_regular_file ON citydb_view.scn2_time_series_regular_file;
CREATE TRIGGER scn2_tr_del_time_series_regular_file
	INSTEAD OF DELETE ON citydb_view.scn2_time_series_regular_file
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.scn2_tr_del_time_series_regular_file ('citydb');

DROP TRIGGER IF EXISTS scn2_tr_ins_time_series_regular_file ON citydb_view.scn2_time_series_regular_file;
CREATE TRIGGER scn2_tr_ins_time_series_regular_file
	INSTEAD OF INSERT ON citydb_view.scn2_time_series_regular_file
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.scn2_tr_ins_time_series_regular_file ('citydb');

DROP TRIGGER IF EXISTS scn2_tr_upd_time_series_regular_file ON citydb_view.scn2_time_series_regular_file;
CREATE TRIGGER scn2_tr_upd_time_series_regular_file
	INSTEAD OF UPDATE ON citydb_view.scn2_time_series_regular_file
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.scn2_tr_upd_time_series_regular_file ('citydb');
-- ***********************************************************************
-- ***********************************************************************

----------------------------------------------------------------
-- Function TR_DEL_TIME_SERIES_IRREGULAR_FILE
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.scn2_tr_del_time_series_irregular_file() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.scn2_tr_del_time_series_irregular_file()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
deleted_id=citydb_pkg.scn2_delete_time_series(OLD.id, p_schema_name);
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.scn2_tr_del_time_series_irregular_file (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_TIME_SERIES_IRREGULAR_FILE
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.scn2_tr_ins_time_series_irregular_file() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.scn2_tr_ins_time_series_irregular_file()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	inserted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
inserted_id=citydb_view.scn2_insert_irregular_time_series_file(
id                   :=NEW.id,
gmlid                :=NEW.gmlid,
gmlid_codespace      :=NEW.gmlid_codespace,
name                 :=NEW.name,
name_codespace       :=NEW.name_codespace,
description          :=NEW.description,		
acquisition_method   :=NEW.acquisition_method,
interpolation_type   :=NEW.interpolation_type,
quality_description  :=NEW.quality_description,
source               :=NEW.source,
values_unit          :=NEW.values_unit,
file_path            :=NEW.file_path,
file_name            :=NEW.file_name,
file_extension       :=NEW.file_extension,
nbr_header_lines     :=NEW.nbr_header_lines,
field_sep            :=NEW.field_sep,
record_sep           :=NEW.record_sep,
dec_symbol           :=NEW.dec_symbol,
time_col_nbr         :=NEW.time_col_nbr,
value_col_nbr        :=NEW.value_col_nbr,
is_compressed        :=NEW.is_compressed,
schema_name          :=p_schema_name
);
--RAISE NOTICE 'Inserted record with id: %', inserted_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.scn2_tr_ins_time_series_irregular_file (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_TIME_SERIES_IRREGULAR_FILE
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.scn2_tr_upd_time_series_irregular_file() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.scn2_tr_upd_time_series_irregular_file()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
  updated_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
EXECUTE format('UPDATE %I.scn2_time_series AS t SET
gmlid                =%L,
gmlid_codespace      =%L,
name                 =%L,
name_codespace       =%L,
description          =%L,
acquisition_method   =%L,
interpolation_type   =%L,
quality_description  =%L,
source               =%L,
values_unit          =%L
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.gmlid,
NEW.gmlid_codespace,
NEW.name,
NEW.name_codespace,
NEW.description,			
NEW.acquisition_method,
NEW.interpolation_type,
NEW.quality_description,
NEW.source,
NEW.values_unit,
OLD.id
) INTO updated_id;
EXECUTE format('UPDATE %I.scn2_time_series_file AS t SET
file_path            =%L,
file_name            =%L,
file_extension       =%L,
nbr_header_lines     =%L,
field_sep            =%L,
record_sep           =%L,
dec_symbol           =%L,
time_col_nbr         =%L,
value_col_nbr        =%L,
is_compressed        =%L
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.file_path,
NEW.file_name,
NEW.file_extension,
NEW.nbr_header_lines,
NEW.field_sep,
NEW.record_sep,
NEW.dec_symbol,
NEW.time_col_nbr,
NEW.value_col_nbr,
NEW.is_compressed,
OLD.id
) INTO updated_id;
-- RAISE NOTICE 'Updated record with id: %',updated_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.scn2_tr_upd_time_series_irregular_file (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view TIME_SERIES_IRREGULAR_FILE
----------------------------------------------------------------
DROP TRIGGER IF EXISTS scn2_tr_del_time_series_irregular_file ON citydb_view.scn2_time_series_irregular_file;
CREATE TRIGGER scn2_tr_del_time_series_irregular_file
	INSTEAD OF DELETE ON citydb_view.scn2_time_series_irregular_file
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.scn2_tr_del_time_series_irregular_file ('citydb');

DROP TRIGGER IF EXISTS scn2_tr_ins_time_series_irregular_file ON citydb_view.scn2_time_series_irregular_file;
CREATE TRIGGER scn2_tr_ins_time_series_irregular_file
	INSTEAD OF INSERT ON citydb_view.scn2_time_series_irregular_file
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.scn2_tr_ins_time_series_irregular_file ('citydb');

DROP TRIGGER IF EXISTS scn2_tr_upd_time_series_irregular_file ON citydb_view.scn2_time_series_irregular_file;
CREATE TRIGGER scn2_tr_upd_time_series_irregular_file
	INSTEAD OF UPDATE ON citydb_view.scn2_time_series_irregular_file
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.scn2_tr_upd_time_series_irregular_file ('citydb');
-- ***********************************************************************
-- ***********************************************************************

----------------------------------------------------------------
-- Function TR_DEL_TIME_SERIES
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.scn2_tr_del_time_series() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.scn2_tr_del_time_series()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
deleted_id=citydb_pkg.scn2_delete_time_series(OLD.id, p_schema_name);
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.scn2_tr_del_time_series (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_TIME_SERIES
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.scn2_tr_ins_time_series() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.scn2_tr_ins_time_series()
  RETURNS trigger AS
$BODY$
DECLARE
	inserted_id integer;
	p_schema_name varchar DEFAULT 'citydb'::varchar;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
inserted_id=citydb_view.scn2_insert_time_series(
classname            :=NEW.classname            ,
id                   :=NEW.id                   ,
gmlid                :=NEW.gmlid                ,
gmlid_codespace      :=NEW.gmlid_codespace      ,
name                 :=NEW.name                 ,
name_codespace       :=NEW.name_codespace       ,
description          :=NEW.description          ,
acquisition_method   :=NEW.acquisition_method   ,
interpolation_type   :=NEW.interpolation_type   ,
quality_description  :=NEW.quality_description  ,
source               :=NEW.source               ,
time_array           :=NEW.time_array           ,
values_array         :=NEW.values_array         ,
values_unit          :=NEW.values_unit          ,
array_length         :=NEW.array_length         ,
temporal_extent_begin:=NEW.temporal_extent_begin,
temporal_extent_end  :=NEW.temporal_extent_end  ,
time_interval        :=NEW.time_interval        ,
time_interval_unit   :=NEW.time_interval_unit   ,
--
file_path            :=NEW.file_path            ,
file_name            :=NEW.file_name            ,
file_extension       :=NEW.file_extension       ,
nbr_header_lines     :=NEW.nbr_header_lines     ,
field_sep            :=NEW.field_sep            ,
record_sep           :=NEW.record_sep           ,
dec_symbol           :=NEW.dec_symbol           ,
time_col_nbr         :=NEW.time_col_nbr         ,
value_col_nbr        :=NEW.value_col_nbr        ,
is_compressed        :=NEW.is_compressed        ,
--
schema_name          :=p_schema_name
);
--RAISE NOTICE 'Inserted record with id: %', inserted_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.scn2_tr_ins_time_series (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_TIME_SERIES
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.scn2_tr_upd_time_series() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.scn2_tr_upd_time_series()
  RETURNS trigger AS
$BODY$
DECLARE
  updated_id integer;
  p_schema_name varchar DEFAULT 'citydb'::varchar;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
EXECUTE format('UPDATE %I.scn2_time_series AS t SET
gmlid                =%L,
gmlid_codespace      =%L,
name                 =%L,
name_codespace       =%L,
description          =%L,
acquisition_method   =%L,
interpolation_type   =%L,
quality_description  =%L,
source               =%L,
time_array           =%L,
values_array         =%L,
values_unit          =%L,
array_length         =%L,
temporal_extent_begin=%L,
temporal_extent_end  =%L,
time_interval        =%L, 
time_interval_unit   =%L 
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.gmlid,
NEW.gmlid_codespace,
NEW.name,
NEW.name_codespace,
NEW.description,	
NEW.acquisition_method,
NEW.interpolation_type,
NEW.quality_description,
NEW.source,
NEW.time_array,
NEW.values_array,
NEW.values_unit,
NEW.array_length,
NEW.temporal_extent_begin,
NEW.temporal_extent_end, 
NEW.time_interval, 
NEW.time_interval_unit, 
OLD.id
) INTO updated_id;

IF OLD.classname IN ('RegularTimeSeriesFile', 'IrregularTimeSeriesFile') THEN
	EXECUTE format('UPDATE %I.scn2_time_series_file AS t SET
	file_path            =%L,
	file_name            =%L,
	file_extension       =%L,
	nbr_header_lines     =%L,
	field_sep            =%L,
	record_sep           =%L,
	dec_symbol           =%L,
	time_col_nbr         =%L,
	value_col_nbr        =%L,
	is_compressed        =%L
	WHERE t.id=%L RETURNING id',
	p_schema_name,
	NEW.file_path,
	NEW.file_name,
	NEW.file_extension,
	NEW.nbr_header_lines,
	NEW.field_sep,
	NEW.record_sep,
	NEW.dec_symbol,
	NEW.time_col_nbr,
	NEW.value_col_nbr,
	NEW.is_compressed,
	OLD.id
	) INTO updated_id;
END IF;
-- RAISE NOTICE 'Updated record with id: %',updated_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.scn2_tr_upd_time_series (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view TIME_SERIES
----------------------------------------------------------------
DROP TRIGGER IF EXISTS scn2_tr_del_time_series ON citydb_view.scn2_time_series;
CREATE TRIGGER scn2_tr_del_time_series
	INSTEAD OF DELETE ON citydb_view.scn2_time_series
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.scn2_tr_del_time_series ('citydb');

DROP TRIGGER IF EXISTS scn2_tr_ins_time_series ON citydb_view.scn2_time_series;
CREATE TRIGGER scn2_tr_ins_time_series
	INSTEAD OF INSERT ON citydb_view.scn2_time_series
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.scn2_tr_ins_time_series ('citydb');

DROP TRIGGER IF EXISTS scn2_tr_upd_time_series ON citydb_view.scn2_time_series;
CREATE TRIGGER scn2_tr_upd_time_series
	INSTEAD OF UPDATE ON citydb_view.scn2_time_series
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.scn2_tr_upd_time_series ('citydb');
--**************************************************************
--**************************************************************

-- ***********************************************************************
-- ***********************************************************************

DO
$$
BEGIN
RAISE NOTICE '

********************************

Scenario ADE view triggers installation complete!

********************************

';
END
$$;
SELECT 'Scenario ADE view triggers installed correctly!'::varchar AS installation_result;


-- ***********************************************************************
-- ***********************************************************************
--
-- END OF FILE
--
-- ***********************************************************************
-- ***********************************************************************