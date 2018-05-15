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
-- ****************** 07_Scenario_ADE_VIEW_FUNCTIONS.sql *****************
--
-- This script adds stored procedured to schema citydb_view. They are all
-- prefixed with "scn2_".
--
-- ***********************************************************************
-- ***********************************************************************

----------------------------------------------------------------
-- DROP existing prefixed insert functions
----------------------------------------------------------------
DO $$
DECLARE
db_schema varchar DEFAULT 'citydb_view'::varchar;
db_prefix varchar DEFAULT 'scn2'::varchar;
func_prefix varchar DEFAULT 'insert'::varchar;
db_prefix_length integer;
test integer DEFAULT NULL;
rec RECORD;
BEGIN
db_prefix_length=char_length(db_prefix) + 1 + char_length(func_prefix::varchar);
-- Check whether there are any prefixed functions to drop at all!
EXECUTE format('SELECT 1 FROM information_schema.routines WHERE routine_type=''FUNCTION'' AND routine_schema=%L AND substring(routine_name, 1, %L::integer)=%L||''_''||%L LIMIT 1', db_schema, db_prefix_length, db_prefix, func_prefix) INTO test;
IF test IS NOT NULL AND test=1 THEN
	RAISE INFO 'Removing all % functions with db_prefix "%" in schema %',  func_prefix, db_prefix, db_schema;
	FOR rec IN EXECUTE format('SELECT proname || ''('' || oidvectortypes(proargtypes) || '')'' AS function_name
	FROM pg_proc INNER JOIN pg_namespace ns ON (pg_proc.pronamespace = ns.oid)
	WHERE ns.nspname = %L AND substring(proname, 1, %L::integer)=%L||''_''||%L ORDER BY proname', db_schema, db_prefix_length, db_prefix, func_prefix) LOOP
		--RAISE NOTICE 'Dropping FUNCTION citydb_view.%',rec.function_name;
		EXECUTE 'DROP FUNCTION IF EXISTS ' || db_schema ||'.' || rec.function_name || ' CASCADE';
	END LOOP;
ELSE
	-- RAISE INFO '-- No functions to delete';
END IF;
END $$;

----------------------------------------------------------------
-- DROP existing prefixed delete functions
----------------------------------------------------------------
DO $$
DECLARE
db_schema varchar DEFAULT 'citydb_view'::varchar;
db_prefix varchar DEFAULT 'scn2'::varchar;
func_prefix varchar DEFAULT 'delete'::varchar;
db_prefix_length integer;
test integer DEFAULT NULL;
rec RECORD;
BEGIN
db_prefix_length=char_length(db_prefix) + 1 + char_length(func_prefix::varchar);
-- Check whether there are any prefixed functions to drop at all!
EXECUTE format('SELECT 1 FROM information_schema.routines WHERE routine_type=''FUNCTION'' AND routine_schema=%L AND substring(routine_name, 1, %L::integer)=%L||''_''||%L LIMIT 1', db_schema, db_prefix_length, db_prefix, func_prefix) INTO test;
IF test IS NOT NULL AND test=1 THEN
	RAISE INFO 'Removing all % functions with db_prefix "%" in schema %',  func_prefix, db_prefix, db_schema;
	FOR rec IN EXECUTE format('SELECT proname || ''('' || oidvectortypes(proargtypes) || '')'' AS function_name
	FROM pg_proc INNER JOIN pg_namespace ns ON (pg_proc.pronamespace = ns.oid)
	WHERE ns.nspname = %L AND substring(proname, 1, %L::integer)=%L||''_''||%L ORDER BY proname', db_schema, db_prefix_length, db_prefix, func_prefix) LOOP
		--RAISE NOTICE 'Dropping FUNCTION citydb_view.%',rec.function_name;
		EXECUTE 'DROP FUNCTION IF EXISTS ' || db_schema ||'.' || rec.function_name || ' CASCADE';
	END LOOP;
ELSE
	-- RAISE INFO '-- No functions to delete';
END IF;
END $$;

-- ***********************************************************************
-- ***********************************************************************

---------------------------------------------------------------
-- Function SCN_DELETE_SCENARIO
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.scn2_delete_scenario(
  IN id integer,
  IN schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
	deleted_id integer;
BEGIN
deleted_id=citydb_pkg.scn2_delete_scenario(id, schema_name);
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.scn2_delete_scenario (id: %): %', id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function SCN_DELETE_SCENARIO_PARAMETER
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.scn2_delete_scenario_parameter(
  IN id integer,
  IN schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
	deleted_id integer;
BEGIN
deleted_id=citydb_pkg.scn2_delete_scenario_parameter(id, schema_name);
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.scn2_delete_parameter (id: %): %', id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function SCN_DELETE_RESOURCE
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.scn2_delete_resource(
  IN id integer,
  IN schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
	deleted_id integer;
BEGIN
deleted_id=citydb_pkg.scn2_delete_resource(id, schema_name);
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.scn2_delete_resource (id: %): %', id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function SCN_DELETE_ENERGY_RESOURCE
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.scn2_delete_energy_resource(
  IN id integer,
  IN schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
	deleted_id integer;
BEGIN
deleted_id=citydb_pkg.scn2_delete_resource(id, schema_name);
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.scn2_delete_energy_resource (id: %): %', id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function SCN_DELETE_MATERIAL_RESOURCE
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.scn2_delete_material_resource(
  IN id integer,
  IN schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
	deleted_id integer;
BEGIN
deleted_id=citydb_pkg.scn2_delete_resource(id, schema_name);
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.scn2_delete_material_resource (id: %): %', id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function SCN_DELETE_MONEY_RESOURCE
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.scn2_delete_money_resource(
  IN id integer,
  IN schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
	deleted_id integer;
BEGIN
deleted_id=citydb_pkg.scn2_delete_resource(id, schema_name);
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.scn2_delete_money_resource (id: %): %', id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function SCN_DELETE_OTHER_RESOURCE
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.scn2_delete_other_resource(
  IN id integer,
  IN schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
	deleted_id integer;
BEGIN
deleted_id=citydb_pkg.scn2_delete_resource(id, schema_name);
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.scn2_delete_other_resource (id: %): %', id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function SCN_DELETE_TIME_RESOURCE
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.scn2_delete_time_resource(
  IN id integer,
  IN schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
	deleted_id integer;
BEGIN
deleted_id=citydb_pkg.scn2_delete_resource(id, schema_name);
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.scn2_delete_time_resource (id: %): %', id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function SCN_DELETE_SIMPLE_OPERATION
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.scn2_delete_simple_operation(
  IN id integer,
  IN schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
	deleted_id integer;
BEGIN
deleted_id=citydb_pkg.scn2_delete_operation(id, schema_name);
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.scn2_delete_simple_operation (id: %): %', id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function SCN_DELETE_COMPLEX_OPERATION
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.scn2_delete_complex_operation(
  IN id integer,
  IN schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
	deleted_id integer;
BEGIN
deleted_id=citydb_pkg.scn2_delete_operation(id, schema_name);
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.scn2_delete_complex_operation (id: %): %', id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function SCN_DELETE_REGULAR_TIME_SERIES
----------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.scn2_delete_regular_time_series(
  IN id integer,
  IN schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
	deleted_id integer;
BEGIN
deleted_id=citydb_pkg.scn2_delete_time_series(id, schema_name);
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.scn2_delete_regular_time_series (id: %): %', id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function SCN_DELETE_IRREGULAR_TIME_SERIES
----------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.scn2_delete_irregular_time_series(
  IN id integer,
  IN schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
	deleted_id integer;
BEGIN
deleted_id=citydb_pkg.scn2_delete_time_series(id, schema_name);
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.scn2_delete_irregular_time_series (id: %): %', id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function SCN_DELETE_TIME_REGULAR_SERIES_FILE
----------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.scn2_delete_regular_time_series_file(
  IN id integer,
  IN schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
	deleted_id integer;
BEGIN
deleted_id=citydb_pkg.scn2_delete_time_series(id, schema_name);
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.scn2_delete_regular_time_series_file (id: %): %', id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function SCN_DELETE_IRREGULAR_TIME_SERIES_FILE
----------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.scn2_delete_irregular_time_series_file(
  IN id integer,
  IN schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
	deleted_id integer;
BEGIN
deleted_id=citydb_pkg.scn2_delete_time_series(id, schema_name);
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.scn2_delete_irregular_time_series_file (id: %): %', id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

-- ***********************************************************************
-- ***********************************************************************

----------------------------------------------------------------
-- Function SCN_INSERT_ENERGY_RESOURCE
----------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.scn2_insert_energy_resource(
  id                   integer DEFAULT NULL,
  gmlid                varchar DEFAULT NULL,
  gmlid_codespace      varchar DEFAULT NULL,
  name                 varchar DEFAULT NULL,
  name_codespace       varchar DEFAULT NULL,
  description          text    DEFAULT NULL,
  type                 varchar DEFAULT NULL,
  quantity             numeric DEFAULT NULL,
  quantity_unit        varchar DEFAULT NULL,
  total_cost           numeric DEFAULT NULL,
  total_cost_unit      varchar DEFAULT NULL,
  unitary_cost         numeric DEFAULT NULL,
  unitary_cost_unit    varchar DEFAULT NULL,	
  is_renewable         numeric DEFAULT NULL,
  scenario_id          integer DEFAULT NULL,
  operation_id         integer DEFAULT NULL,
--
  schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
p_id                integer :=id               ;
p_gmlid             varchar :=gmlid            ;
p_gmlid_codespace   varchar :=gmlid_codespace  ;
p_name              varchar :=name             ;
p_name_codespace    varchar :=name_codespace   ;
p_description       text    :=description      ;
p_type              varchar :=type             ;
p_quantity          numeric :=quantity         ;
p_quantity_unit     varchar :=quantity_unit    ;
p_total_cost        numeric :=total_cost       ;
p_total_cost_unit   varchar :=total_cost_unit  ;
p_unitary_cost      numeric :=unitary_cost     ;
p_unitary_cost_unit varchar :=unitary_cost_unit;
p_is_renewable      numeric :=is_renewable     ;
p_scenario_id       integer :=scenario_id      ;
p_operation_id      integer :=operation_id     ;
--
p_schema_name varchar := schema_name;
class_name varchar DEFAULT 'EnergyResource'::varchar;
db_prefix varchar DEFAULT 'scn2'::varchar;
objectclass_id integer;
inserted_id integer;
BEGIN
objectclass_id=citydb_pkg.objectclass_classname_to_id(class_name, db_prefix, p_schema_name);

inserted_id=citydb_pkg.scn2_insert_resource(
id                   :=p_id,
objectclass_id       :=objectclass_id,
gmlid                :=p_gmlid            ,
gmlid_codespace      :=p_gmlid_codespace  ,
name                 :=p_name             ,
name_codespace       :=p_name_codespace   ,
description          :=p_description      ,
type                 :=p_type             ,
quantity             :=p_quantity         ,
quantity_unit        :=p_quantity_unit    ,
total_cost           :=p_total_cost       ,
total_cost_unit      :=p_total_cost_unit  ,
unitary_cost         :=p_unitary_cost     ,
unitary_cost_unit    :=p_unitary_cost_unit,
is_renewable         :=p_is_renewable     ,
scenario_id          :=p_scenario_id      ,
operation_id         :=p_operation_id     ,
--
schema_name          :=p_schema_name
);
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.scn2_insert_energy_resource (): %', SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function SCN_INSERT_MATERIAL_RESOURCE
----------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.scn2_insert_material_resource(
  id                   integer DEFAULT NULL,
  gmlid                varchar DEFAULT NULL,
  gmlid_codespace      varchar DEFAULT NULL,
  name                 varchar DEFAULT NULL,
  name_codespace       varchar DEFAULT NULL,
  description          text    DEFAULT NULL,
  type                 varchar DEFAULT NULL,
  quantity             numeric DEFAULT NULL,
  quantity_unit        varchar DEFAULT NULL,
  total_cost           numeric DEFAULT NULL,
  total_cost_unit      varchar DEFAULT NULL,
  unitary_cost         numeric DEFAULT NULL,
  unitary_cost_unit    varchar DEFAULT NULL,	
  is_renewable         numeric DEFAULT NULL,
  scenario_id          integer DEFAULT NULL,
  operation_id         integer DEFAULT NULL,
--
  schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
p_id                integer :=id               ;
p_gmlid             varchar :=gmlid            ;
p_gmlid_codespace   varchar :=gmlid_codespace  ;
p_name              varchar :=name             ;
p_name_codespace    varchar :=name_codespace   ;
p_description       text    :=description      ;
p_type              varchar :=type             ;
p_quantity          numeric :=quantity         ;
p_quantity_unit     varchar :=quantity_unit    ;
p_total_cost        numeric :=total_cost       ;
p_total_cost_unit   varchar :=total_cost_unit  ;
p_unitary_cost      numeric :=unitary_cost     ;
p_unitary_cost_unit varchar :=unitary_cost_unit;
p_is_renewable      numeric :=is_renewable     ;
p_scenario_id       integer :=scenario_id      ;
p_operation_id      integer :=operation_id     ;
--
p_schema_name varchar := schema_name;
class_name varchar DEFAULT 'MaterialResource'::varchar;
db_prefix varchar DEFAULT 'scn2'::varchar;
objectclass_id integer;
inserted_id integer;
BEGIN
objectclass_id=citydb_pkg.objectclass_classname_to_id(class_name, db_prefix, p_schema_name);

inserted_id=citydb_pkg.scn2_insert_resource(
id                   :=p_id,
objectclass_id       :=objectclass_id,
gmlid                :=p_gmlid            ,
gmlid_codespace      :=p_gmlid_codespace  ,
name                 :=p_name             ,
name_codespace       :=p_name_codespace   ,
description          :=p_description      ,
type                 :=p_type             ,
quantity             :=p_quantity         ,
quantity_unit        :=p_quantity_unit    ,
total_cost           :=p_total_cost       ,
total_cost_unit      :=p_total_cost_unit  ,
unitary_cost         :=p_unitary_cost     ,
unitary_cost_unit    :=p_unitary_cost_unit,
is_renewable         :=p_is_renewable     ,
scenario_id          :=p_scenario_id      ,
operation_id         :=p_operation_id     ,
--
schema_name          :=p_schema_name
);
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.scn2_insert_material_resource (): %', SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function SCN_INSERT_MONEY_RESOURCE
----------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.scn2_insert_money_resource(
  id                   integer DEFAULT NULL,
  gmlid                varchar DEFAULT NULL,
  gmlid_codespace      varchar DEFAULT NULL,
  name                 varchar DEFAULT NULL,
  name_codespace       varchar DEFAULT NULL,
  description          text    DEFAULT NULL,
  type                 varchar DEFAULT NULL,
  quantity             numeric DEFAULT NULL,
  quantity_unit        varchar DEFAULT NULL,
  total_cost           numeric DEFAULT NULL,
  total_cost_unit      varchar DEFAULT NULL,
  unitary_cost         numeric DEFAULT NULL,
  unitary_cost_unit    varchar DEFAULT NULL,	
  is_renewable         numeric DEFAULT NULL,
  scenario_id          integer DEFAULT NULL,
  operation_id         integer DEFAULT NULL,
--
  schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
p_id                integer :=id               ;
p_gmlid             varchar :=gmlid            ;
p_gmlid_codespace   varchar :=gmlid_codespace  ;
p_name              varchar :=name             ;
p_name_codespace    varchar :=name_codespace   ;
p_description       text    :=description      ;
p_type              varchar :=type             ;
p_quantity          numeric :=quantity         ;
p_quantity_unit     varchar :=quantity_unit    ;
p_total_cost        numeric :=total_cost       ;
p_total_cost_unit   varchar :=total_cost_unit  ;
p_unitary_cost      numeric :=unitary_cost     ;
p_unitary_cost_unit varchar :=unitary_cost_unit;
p_is_renewable      numeric :=is_renewable     ;
p_scenario_id       integer :=scenario_id      ;
p_operation_id      integer :=operation_id     ;
--
p_schema_name varchar := schema_name;
class_name varchar DEFAULT 'MoneyResource'::varchar;
db_prefix varchar DEFAULT 'scn2'::varchar;
objectclass_id integer;
inserted_id integer;
BEGIN
objectclass_id=citydb_pkg.objectclass_classname_to_id(class_name, db_prefix, p_schema_name);

inserted_id=citydb_pkg.scn2_insert_resource(
id                   :=p_id,
objectclass_id       :=objectclass_id,
gmlid                :=p_gmlid            ,
gmlid_codespace      :=p_gmlid_codespace  ,
name                 :=p_name             ,
name_codespace       :=p_name_codespace   ,
description          :=p_description      ,
type                 :=p_type             ,
quantity             :=p_quantity         ,
quantity_unit        :=p_quantity_unit    ,
total_cost           :=p_total_cost       ,
total_cost_unit      :=p_total_cost_unit  ,
unitary_cost         :=p_unitary_cost     ,
unitary_cost_unit    :=p_unitary_cost_unit,
is_renewable         :=p_is_renewable     ,
scenario_id          :=p_scenario_id      ,
operation_id         :=p_operation_id     ,
--
schema_name          :=p_schema_name
);
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.scn2_insert_money_resource (): %', SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function SCN_INSERT_OTHER_RESOURCE
----------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.scn2_insert_other_resource(
  id                   integer DEFAULT NULL,
  gmlid                varchar DEFAULT NULL,
  gmlid_codespace      varchar DEFAULT NULL,
  name                 varchar DEFAULT NULL,
  name_codespace       varchar DEFAULT NULL,
  description          text    DEFAULT NULL,
  type                 varchar DEFAULT NULL,
  quantity             numeric DEFAULT NULL,
  quantity_unit        varchar DEFAULT NULL,
  total_cost           numeric DEFAULT NULL,
  total_cost_unit      varchar DEFAULT NULL,
  unitary_cost         numeric DEFAULT NULL,
  unitary_cost_unit    varchar DEFAULT NULL,	
  is_renewable         numeric DEFAULT NULL,
  scenario_id          integer DEFAULT NULL,
  operation_id         integer DEFAULT NULL,
--
  schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
p_id                integer :=id               ;
p_gmlid             varchar :=gmlid            ;
p_gmlid_codespace   varchar :=gmlid_codespace  ;
p_name              varchar :=name             ;
p_name_codespace    varchar :=name_codespace   ;
p_description       text    :=description      ;
p_type              varchar :=type             ;
p_quantity          numeric :=quantity         ;
p_quantity_unit     varchar :=quantity_unit    ;
p_total_cost        numeric :=total_cost       ;
p_total_cost_unit   varchar :=total_cost_unit  ;
p_unitary_cost      numeric :=unitary_cost     ;
p_unitary_cost_unit varchar :=unitary_cost_unit;
p_is_renewable      numeric :=is_renewable     ;
p_scenario_id       integer :=scenario_id      ;
p_operation_id      integer :=operation_id     ;
--
p_schema_name varchar := schema_name;
class_name varchar DEFAULT 'OtherResource'::varchar;
db_prefix varchar DEFAULT 'scn2'::varchar;
objectclass_id integer;
inserted_id integer;
BEGIN
objectclass_id=citydb_pkg.objectclass_classname_to_id(class_name, db_prefix, p_schema_name);

inserted_id=citydb_pkg.scn2_insert_resource(
id                   :=p_id,
objectclass_id       :=objectclass_id,
gmlid                :=p_gmlid            ,
gmlid_codespace      :=p_gmlid_codespace  ,
name                 :=p_name             ,
name_codespace       :=p_name_codespace   ,
description          :=p_description      ,
type                 :=p_type             ,
quantity             :=p_quantity         ,
quantity_unit        :=p_quantity_unit    ,
total_cost           :=p_total_cost       ,
total_cost_unit      :=p_total_cost_unit  ,
unitary_cost         :=p_unitary_cost     ,
unitary_cost_unit    :=p_unitary_cost_unit,
is_renewable         :=p_is_renewable     ,
scenario_id          :=p_scenario_id      ,
operation_id         :=p_operation_id     ,
--
schema_name          :=p_schema_name
);
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.scn2_insert_other_resource (): %', SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function SCN_INSERT_TIME_RESOURCE
----------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.scn2_insert_time_resource(
  id                   integer DEFAULT NULL,
  gmlid                varchar DEFAULT NULL,
  gmlid_codespace      varchar DEFAULT NULL,
  name                 varchar DEFAULT NULL,
  name_codespace       varchar DEFAULT NULL,
  description          text    DEFAULT NULL,
  type                 varchar DEFAULT NULL,
  quantity             numeric DEFAULT NULL,
  quantity_unit        varchar DEFAULT NULL,
  total_cost           numeric DEFAULT NULL,
  total_cost_unit      varchar DEFAULT NULL,
  unitary_cost         numeric DEFAULT NULL,
  unitary_cost_unit    varchar DEFAULT NULL,	
  is_renewable         numeric DEFAULT NULL,
  scenario_id          integer DEFAULT NULL,
  operation_id         integer DEFAULT NULL,
--
  schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
p_id                integer := id               ;
p_gmlid             varchar := gmlid            ;
p_gmlid_codespace   varchar := gmlid_codespace  ;
p_name              varchar := name             ;
p_name_codespace    varchar := name_codespace   ;
p_description       text    := description      ;
p_type              varchar := type             ;
p_quantity          numeric := quantity         ;
p_quantity_unit     varchar := quantity_unit    ;
p_total_cost        numeric := total_cost       ;
p_total_cost_unit   varchar := total_cost_unit  ;
p_unitary_cost      numeric := unitary_cost     ;
p_unitary_cost_unit varchar := unitary_cost_unit;
p_is_renewable      numeric := is_renewable     ;
p_scenario_id       integer := scenario_id      ;
p_operation_id      integer := operation_id     ;
--
p_schema_name varchar := schema_name;
class_name varchar DEFAULT 'TimeResource'::varchar;
db_prefix varchar DEFAULT 'scn2'::varchar;
objectclass_id integer;
inserted_id integer;
BEGIN
objectclass_id=citydb_pkg.objectclass_classname_to_id(class_name, db_prefix, p_schema_name);

inserted_id=citydb_pkg.scn2_insert_resource(
id                   :=p_id,
objectclass_id       :=objectclass_id,
gmlid                :=p_gmlid            ,
gmlid_codespace      :=p_gmlid_codespace  ,
name                 :=p_name             ,
name_codespace       :=p_name_codespace   ,
description          :=p_description      ,
type                 :=p_type             ,
quantity             :=p_quantity         ,
quantity_unit        :=p_quantity_unit    ,
total_cost           :=p_total_cost       ,
total_cost_unit      :=p_total_cost_unit  ,
unitary_cost         :=p_unitary_cost     ,
unitary_cost_unit    :=p_unitary_cost_unit,
is_renewable         :=p_is_renewable     ,
scenario_id          :=p_scenario_id      ,
operation_id         :=p_operation_id     ,
--
schema_name          :=p_schema_name
);
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.scn2_insert_time_resource (): %', SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;


----------------------------------------------------------------
-- Function SCN_INSERT_COMPLEX_OPERATION 
----------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.scn2_insert_complex_operation(
feature_uri               varchar,
id                        integer        DEFAULT NULL,
operation_parent_id       integer        DEFAULT NULL,         
operation_root_id         integer        DEFAULT NULL,         
gmlid                     varchar        DEFAULT NULL,
gmlid_codespace           varchar        DEFAULT NULL,
name                      varchar        DEFAULT NULL,
name_codespace            varchar        DEFAULT NULL,
description               text           DEFAULT NULL,
class                     varchar        DEFAULT NULL,
instant                   timestamptz(0) DEFAULT NULL,
period_begin              date           DEFAULT NULL,
period_end                date           DEFAULT NULL, 
--
schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
p_id                  integer        := id                 ;
p_operation_parent_id integer        := operation_parent_id;
p_operation_root_id   integer        := operation_root_id  ;
p_gmlid               varchar        := gmlid              ;
p_gmlid_codespace     varchar        := gmlid_codespace    ;
p_name                varchar        := name               ;
p_name_codespace      varchar        := name_codespace     ;
p_description         text           := description        ;
p_class               varchar        := class              ;
p_instant             timestamptz(0) := instant            ;
p_period_begin        date           := period_begin       ;
p_period_end          date           := period_end         ; 
--
p_schema_name varchar := schema_name;
class_name varchar DEFAULT 'ComplexOperation'::varchar;
db_prefix varchar DEFAULT 'scn2'::varchar;
objectclass_id integer;
inserted_id integer;
BEGIN
objectclass_id=citydb_pkg.objectclass_classname_to_id(class_name, db_prefix, p_schema_name);

inserted_id=citydb_pkg.scn2_insert_operation(
id                   :=p_id,
objectclass_id       :=objectclass_id,
operation_parent_id  :=p_operation_parent_id,
operation_root_id    :=p_operation_root_id  ,
gmlid                :=p_gmlid              ,
gmlid_codespace      :=p_gmlid_codespace    ,
name                 :=p_name               ,
name_codespace       :=p_name_codespace     ,
description          :=p_description        ,
class                :=p_class              ,
instant              :=p_instant            ,
period_begin         :=p_period_begin       ,
period_end           :=p_period_end         ,
--
schema_name          :=p_schema_name
);
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.scn2_insert_complex_operation (): %', SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;













----------------------------------------------------------------
-- Function SCN_INSERT_SCENARIO
----------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.scn2_insert_scenario(
id                 integer            DEFAULT NULL,
scenario_parent_id integer            DEFAULT NULL,
gmlid              varchar            DEFAULT NULL,
gmlid_codespace    varchar            DEFAULT NULL,
name               varchar            DEFAULT NULL,
name_codespace     varchar            DEFAULT NULL,
description        text               DEFAULT NULL,
class              varchar            DEFAULT NULL,
instant            timestamptz(0)     DEFAULT NULL,
period_begin       date               DEFAULT NULL,
period_end         date               DEFAULT NULL,
citymodel_id       integer            DEFAULT NULL,
cityobject_id      integer            DEFAULT NULL,
envelope           geometry(PolygonZ) DEFAULT NULL,		
creator_name       varchar            DEFAULT NULL,
creation_date      timestamptz(0)     DEFAULT NULL,
--
schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
p_id                 integer            := id             ;
p_scenario_parent_id integer            := scenario_parent_id;
p_gmlid              varchar            := gmlid          ;
p_gmlid_codespace    varchar            := gmlid_codespace;
p_name               varchar            := name           ;
p_name_codespace     varchar            := name_codespace ;
p_description        text               := description    ;
p_class              varchar            := class          ;
p_instant            timestamptz(0)     := instant        ;
p_period_begin       date               := period_begin   ;
p_period_end         date               := period_end     ;
p_citymodel_id       integer            := citymodel_id   ;
p_cityobject_id      integer            := cityobject_id  ;
p_envelope           geometry(PolygonZ) := envelope       ;
p_creator_name       varchar            := creator_name   ;
p_creation_date      timestamptz(0)     := creation_date  ;
--
p_schema_name varchar := schema_name;
class_name varchar DEFAULT 'Scenario'::varchar;
db_prefix varchar DEFAULT 'scn2'::varchar;
objectclass_id integer;
inserted_id integer;
BEGIN
objectclass_id=citydb_pkg.objectclass_classname_to_id(class_name, db_prefix, p_schema_name);

inserted_id=citydb_pkg.scn2_insert_scenario(
id                   :=p_id,
objectclass_id       :=objectclass_id,
scenario_parent_id   :=p_scenario_parent_id,
gmlid                :=p_gmlid             ,
gmlid_codespace      :=p_gmlid_codespace   ,
name                 :=p_name              ,
name_codespace       :=p_name_codespace    ,
description          :=p_description       ,
class                :=p_class             ,
instant              :=p_instant           ,
period_begin         :=p_period_begin      ,
period_end           :=p_period_end        ,
citymodel_id         :=p_citymodel_id      ,
cityobject_id        :=p_cityobject_id     ,
envelope             :=p_envelope          ,
creator_name         :=p_creator_name      ,
creation_date        :=p_creation_date     ,
--
schema_name          :=p_schema_name
);
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.scn2_insert_scenario (): %', SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function SCN_INSERT_SCENARIO_PARAMETER
----------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.scn2_insert_scenario_parameter(
  id               integer             DEFAULT NULL,
  type             varchar             DEFAULT NULL,
  name             varchar             DEFAULT NULL,
  name_codespace   varchar             DEFAULT NULL,
  description      text                DEFAULT NULL,
  class            varchar             DEFAULT NULL,
  constraint_type  varchar             DEFAULT NULL,
  sim_name         varchar             DEFAULT NULL,
  sim_description  varchar             DEFAULT NULL,
  sim_reference    varchar             DEFAULT NULL,
  aggregation_type varchar             DEFAULT NULL,
  temp_aggregation varchar             DEFAULT NULL,	
  strval           varchar             DEFAULT NULL,
  booleanval       numeric(1,0)        DEFAULT NULL,
  intval           integer             DEFAULT NULL,
  realval          numeric             DEFAULT NULL,
  unit             varchar             DEFAULT NULL,
  dateval          date                DEFAULT NULL,
  urival           varchar             DEFAULT NULL,
  geomval          geometry(GeometryZ) DEFAULT NULL,
  time_series_id   integer             DEFAULT NULL,
  cityobject_id    integer             DEFAULT NULL,
  scenario_id      integer             DEFAULT NULL,
--
schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
p_id               integer             :=id              ;
p_type             varchar             :=type            ;
p_name             varchar             :=name            ;
p_name_codespace   varchar             :=name_codespace  ;
p_description      text                :=description     ;
p_class            varchar             :=class           ;
p_constraint_type  varchar             :=constraint_type ;
p_sim_name         varchar             :=sim_name        ;
p_sim_description  varchar             :=sim_description ;
p_sim_reference    varchar             :=sim_reference   ;
p_aggregation_type varchar             :=aggregation_type;
p_temp_aggregation varchar             :=temp_aggregation;
p_strval           varchar             :=strval          ;
p_booleanval       numeric(1,0)        :=booleanval      ;
p_intval           integer             :=intval          ;
p_realval          numeric             :=realval         ;
p_unit             varchar             :=unit            ;
p_dateval          date                :=dateval         ;
p_urival           varchar             :=urival          ;
p_geomval          geometry(GeometryZ) :=geomval         ;
p_time_series_id   integer             :=time_series_id  ;
p_cityobject_id    integer             :=cityobject_id   ;
p_scenario_id      integer             :=scenario_id     ;
--
p_schema_name varchar := schema_name;
--class_name varchar DEFAULT 'ScenarioParameter'::varchar;
--db_prefix varchar DEFAULT 'scn2'::varchar;
--objectclass_id integer;
inserted_id integer;
BEGIN
--objectclass_id=citydb_pkg.objectclass_classname_to_id(class_name, db_prefix, p_schema_name);
--objectclass_id       :=objectclass_id,

inserted_id=citydb_pkg.scn2_insert_scenario_parameter(
id              :=p_id              ,
type            :=p_type            ,
name            :=p_name            ,
name_codespace  :=p_name_codespace  ,
description     :=p_description     ,
class           :=p_class           ,
constraint_type :=p_constraint_type ,
sim_name        :=p_sim_name        ,
sim_description :=p_sim_description ,
sim_reference   :=p_sim_reference   ,
aggregation_type:=p_aggregation_type,
temp_aggregation:=p_temp_aggregation,
strval          :=p_strval          ,
booleanval      :=p_booleanval      ,
intval          :=p_intval          ,
realval         :=p_realval         ,
unit            :=p_unit            ,
dateval         :=p_dateval         ,
urival          :=p_urival          ,
geomval         :=p_geomval         ,
time_series_id  :=p_time_series_id  ,
cityobject_id   :=p_cityobject_id   ,
scenario_id     :=p_scenario_id     ,
--
schema_name          :=p_schema_name
);
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.scn2_insert_scenario_parameter (): %', SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function INSERT_REGULAR_TIME_SERIES
----------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.scn2_insert_regular_time_series(
  id integer DEFAULT NULL,
  gmlid varchar DEFAULT NULL,
  gmlid_codespace varchar DEFAULT NULL,
  name varchar DEFAULT NULL,
  name_codespace varchar DEFAULT NULL,
  description text DEFAULT NULL,
  acquisition_method varchar DEFAULT NULL,
  interpolation_type varchar DEFAULT NULL,
  quality_description text DEFAULT NULL,
  source varchar DEFAULT NULL,
  values_array numeric[] DEFAULT NULL,
  values_unit varchar DEFAULT NULL,
  array_length integer DEFAULT NULL,
  temporal_extent_begin timestamp with time zone DEFAULT NULL,
  temporal_extent_end timestamp with time zone DEFAULT NULL,
  time_interval numeric DEFAULT NULL,
  time_interval_unit varchar DEFAULT NULL,
  --
  schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
  p_id                    integer                  := id                   ;
  p_gmlid                 varchar                  := gmlid                ;
  p_gmlid_codespace       varchar                  := gmlid_codespace      ;
  p_name                  varchar                  := name                 ;
  p_name_codespace        varchar                  := name_codespace       ;
  p_description           text                     := description          ;
  p_acquisition_method    varchar                  := acquisition_method   ;
  p_interpolation_type    varchar                  := interpolation_type   ;
  p_quality_description   text                     := quality_description  ;
  p_source                varchar                  := source               ;
  p_values_array          numeric[]                := values_array         ;
  p_values_unit           varchar                  := values_unit          ;
  p_array_length          integer                  := array_length         ;
  p_temporal_extent_begin timestamp with time zone := temporal_extent_begin;
  p_temporal_extent_end   timestamp with time zone := temporal_extent_end  ;
  p_time_interval         numeric                  := time_interval        ;
  p_time_interval_unit    varchar                  := time_interval_unit   ;
--
  p_schema_name varchar := schema_name;
  class_name varchar DEFAULT 'RegularTimeSeries'::varchar;
  db_prefix varchar DEFAULT 'scn2'::varchar;
  objectclass_id integer;
  inserted_id integer;
BEGIN
objectclass_id=citydb_pkg.objectclass_classname_to_id(class_name, db_prefix, p_schema_name);

inserted_id=citydb_pkg.scn2_insert_time_series(
    id                   :=p_id,
    objectclass_id       :=objectclass_id,
    gmlid                :=p_gmlid,
    gmlid_codespace      :=p_gmlid_codespace,
    name                 :=p_name,
    name_codespace       :=p_name_codespace,
    description          :=p_description,
    acquisition_method   :=p_acquisition_method,
    interpolation_type   :=p_interpolation_type,
    quality_description  :=p_quality_description,
    source               :=p_source,
    values_array         :=p_values_array,
    values_unit          :=p_values_unit,
    array_length         :=p_array_length,
    temporal_extent_begin:=p_temporal_extent_begin,
    temporal_extent_end  :=p_temporal_extent_end,
    time_interval        :=p_time_interval,
    time_interval_unit   :=p_time_interval_unit,
    schema_name          :=p_schema_name
);
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.scn2_insert_regular_time_series(): %', SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function INSERT_IRREGULAR_TIME_SERIES
----------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.scn2_insert_irregular_time_series(
id integer DEFAULT NULL,
gmlid varchar DEFAULT NULL,
gmlid_codespace varchar DEFAULT NULL,
name varchar DEFAULT NULL,
name_codespace varchar DEFAULT NULL,
description text DEFAULT NULL,
acquisition_method varchar DEFAULT NULL,
interpolation_type varchar DEFAULT NULL,
quality_description text DEFAULT NULL,
source varchar DEFAULT NULL,
time_array timestamptz[] DEFAULT NULL,
values_array numeric[] DEFAULT NULL,
values_unit varchar DEFAULT NULL,
array_length integer DEFAULT NULL,

schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
  p_id                    integer                  := id                   ;
  p_gmlid                 varchar                  := gmlid                ;
  p_gmlid_codespace       varchar                  := gmlid_codespace      ;
  p_name                  varchar                  := name                 ;
  p_name_codespace        varchar                  := name_codespace       ;
  p_description           text                     := description          ;
  p_acquisition_method    varchar                  := acquisition_method   ;
  p_interpolation_type    varchar                  := interpolation_type   ;
  p_quality_description   text                     := quality_description  ;
  p_source                varchar                  := source               ;
  p_time_array            timestamptz[]            := time_array           ;
  p_values_array          numeric[]                := values_array         ;
  p_values_unit           varchar                  := values_unit          ;
  p_array_length          integer                  := array_length         ;
--
  p_schema_name varchar := schema_name;
  class_name varchar DEFAULT 'IrregularTimeSeries'::varchar;
  db_prefix varchar DEFAULT 'scn2'::varchar;
  objectclass_id integer;
  inserted_id integer;
BEGIN
objectclass_id=citydb_pkg.objectclass_classname_to_id(class_name, db_prefix, p_schema_name);

inserted_id=citydb_pkg.scn2_insert_time_series(
    id                   :=p_id,
    objectclass_id       :=objectclass_id,
    gmlid                :=p_gmlid,
    gmlid_codespace      :=p_gmlid_codespace,
    name                 :=p_name,
    name_codespace       :=p_name_codespace,
    description          :=p_description,
    acquisition_method   :=p_acquisition_method,
    interpolation_type   :=p_interpolation_type,
    quality_description  :=p_quality_description,
    source               :=p_source,
    time_array           :=p_time_array,
    values_array         :=p_values_array,
    values_unit          :=p_values_unit,
    array_length         :=p_array_length,
    schema_name          :=p_schema_name
);
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.scn2_insert_irregular_time_series(): %', SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function INSERT_TIME_REGULAR_SERIES_FILE
----------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.scn2_insert_regular_time_series_file(
id integer DEFAULT NULL,
gmlid varchar DEFAULT NULL,
gmlid_codespace varchar DEFAULT NULL,
name varchar DEFAULT NULL,
name_codespace varchar DEFAULT NULL,
description text DEFAULT NULL,
acquisition_method varchar DEFAULT NULL,
interpolation_type varchar DEFAULT NULL,
quality_description text DEFAULT NULL,
source varchar DEFAULT NULL,
values_unit varchar DEFAULT NULL,
temporal_extent_begin timestamp with time zone DEFAULT NULL,
temporal_extent_end timestamp with time zone DEFAULT NULL,
time_interval numeric DEFAULT NULL,
time_interval_unit varchar DEFAULT NULL,
--
file_path varchar DEFAULT NULL,
file_name varchar DEFAULT NULL,
file_extension varchar DEFAULT NULL,
nbr_header_lines integer DEFAULT NULL,
field_sep varchar DEFAULT NULL,
record_sep varchar DEFAULT NULL,
dec_symbol varchar DEFAULT NULL,
value_col_nbr integer DEFAULT NULL,
is_compressed numeric(1) DEFAULT NULL,
--
schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
  p_id                    integer     := id                   ;
  p_gmlid                 varchar     := gmlid                ;
  p_gmlid_codespace       varchar     := gmlid_codespace      ;
  p_name                  varchar     := name                 ;
  p_name_codespace        varchar     := name_codespace       ;
  p_description           text        := description          ;
  p_acquisition_method    varchar     := acquisition_method   ;
  p_interpolation_type    varchar     := interpolation_type   ;
  p_quality_description   text        := quality_description  ;
  p_source                varchar     := source               ;
  p_values_unit           varchar     := values_unit          ;
  p_temporal_extent_begin timestamptz := temporal_extent_begin;
  p_temporal_extent_end   timestamptz := temporal_extent_end  ;
  p_time_interval         numeric     := time_interval        ;
  p_time_interval_unit    varchar     := time_interval_unit   ;
--
  p_file_path             varchar     := file_path            ;
  p_file_name             varchar     := file_name            ;
  p_file_extension        varchar     := file_extension       ;
  p_nbr_header_lines      integer     := nbr_header_lines     ;
  p_field_sep             varchar     := field_sep            ;
  p_record_sep            varchar     := record_sep           ;
  p_dec_symbol            varchar     := dec_symbol           ;
  p_value_col_nbr         integer     := value_col_nbr        ;
  p_is_compressed         numeric(1)  := is_compressed        ;
--
  p_schema_name varchar := schema_name;
  class_name varchar DEFAULT 'RegularTimeSeriesFile'::varchar;
  db_prefix varchar DEFAULT 'scn2'::varchar;
  objectclass_id integer;
  inserted_id integer;
BEGIN
objectclass_id=citydb_pkg.objectclass_classname_to_id(class_name, db_prefix, p_schema_name);

inserted_id=citydb_pkg.scn2_insert_time_series(
    id                   :=p_id,
    objectclass_id       :=objectclass_id,
    gmlid                :=p_gmlid,
    gmlid_codespace      :=p_gmlid_codespace,
    name                 :=p_name,
    name_codespace       :=p_name_codespace,
    description          :=p_description,
    acquisition_method   :=p_acquisition_method,
    interpolation_type   :=p_interpolation_type,
    quality_description  :=p_quality_description,
    source               :=p_source,
    values_unit          :=p_values_unit,
    temporal_extent_begin:=p_temporal_extent_begin,
    temporal_extent_end  :=p_temporal_extent_end,
    time_interval        :=p_time_interval,
    time_interval_unit   :=p_time_interval_unit,
    schema_name          :=p_schema_name
);
PERFORM citydb_pkg.scn2_insert_time_series_file(
    id              :=inserted_id,
    objectclass_id  :=objectclass_id,
    file_path       :=p_file_path,
    file_name       :=p_file_name,
    file_extension  :=p_file_extension,
    nbr_header_lines:=p_nbr_header_lines,
    field_sep       :=p_field_sep,
    record_sep      :=p_record_sep,
    dec_symbol      :=p_dec_symbol,
    value_col_nbr   :=p_value_col_nbr,
    is_compressed   :=p_is_compressed,
    schema_name     :=p_schema_name
);
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.scn2_insert_regular_time_series_file(): %', SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function INSERT_IRREGULAR_TIME_SERIES_FILE
----------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.scn2_insert_irregular_time_series_file(
id integer DEFAULT NULL,
gmlid varchar DEFAULT NULL,
gmlid_codespace varchar DEFAULT NULL,
name varchar DEFAULT NULL,
name_codespace varchar DEFAULT NULL,
description text DEFAULT NULL,
acquisition_method varchar DEFAULT NULL,
interpolation_type varchar DEFAULT NULL,
quality_description text DEFAULT NULL,
source varchar DEFAULT NULL,
values_unit varchar DEFAULT NULL,
--
file_path varchar DEFAULT NULL,
file_name varchar DEFAULT NULL,
file_extension varchar DEFAULT NULL,
nbr_header_lines integer DEFAULT NULL,
field_sep varchar DEFAULT NULL,
record_sep varchar DEFAULT NULL,
dec_symbol varchar DEFAULT NULL,
time_col_nbr integer DEFAULT NULL,
value_col_nbr integer DEFAULT NULL,
is_compressed numeric(1) DEFAULT NULL,
--
schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
  p_id                    integer                  := id                   ;
  p_gmlid                 varchar                  := gmlid                ;
  p_gmlid_codespace       varchar                  := gmlid_codespace      ;
  p_name                  varchar                  := name                 ;
  p_name_codespace        varchar                  := name_codespace       ;
  p_description           text                     := description          ;
  p_acquisition_method    varchar                  := acquisition_method   ;
  p_interpolation_type    varchar                  := interpolation_type   ;
  p_quality_description   text                     := quality_description  ;
  p_source                varchar                  := source               ;
  p_values_unit           varchar                  := values_unit          ;
--
  p_file_path             varchar                  := file_path            ;
  p_file_name             varchar                  := file_name            ;
  p_file_extension        varchar                  := file_extension       ;
  p_nbr_header_lines      integer                  := nbr_header_lines     ;
  p_field_sep             varchar                  := field_sep            ;
  p_record_sep            varchar                  := record_sep           ;
  p_dec_symbol            varchar                  := dec_symbol           ;
  p_time_col_nbr          integer                  := time_col_nbr         ;
  p_value_col_nbr         integer                  := value_col_nbr        ;
  p_is_compressed         numeric(1)               := is_compressed        ;
--
  p_schema_name varchar := schema_name;
  class_name varchar DEFAULT 'IrregularTimeSeriesFile'::varchar;
  db_prefix varchar DEFAULT 'scn2'::varchar;
  objectclass_id integer;
  inserted_id integer;
BEGIN
objectclass_id=citydb_pkg.objectclass_classname_to_id(class_name, db_prefix, p_schema_name);

inserted_id=citydb_pkg.scn2_insert_time_series(
    id                   :=p_id,
    objectclass_id       :=objectclass_id,
    gmlid                :=p_gmlid,
    gmlid_codespace      :=p_gmlid_codespace,
    name                 :=p_name,
    name_codespace       :=p_name_codespace,
    description          :=p_description,
    acquisition_method   :=p_acquisition_method,
    interpolation_type   :=p_interpolation_type,
    quality_description  :=p_quality_description,
    source               :=p_source,
    values_unit          :=p_values_unit,
    schema_name          :=p_schema_name
);
PERFORM citydb_pkg.scn2_insert_time_series_file(
    id              :=inserted_id,
    objectclass_id  :=objectclass_id,
    file_path       :=p_file_path,
    file_name       :=p_file_name,
    file_extension  :=p_file_extension,
    nbr_header_lines:=p_nbr_header_lines,
    field_sep       :=p_field_sep,
    record_sep      :=p_record_sep,
    dec_symbol      :=p_dec_symbol,
    time_col_nbr    :=p_time_col_nbr,
    value_col_nbr   :=p_value_col_nbr,
    is_compressed   :=p_is_compressed,
    schema_name     :=p_schema_name
);
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.scn2_insert_irregular_time_series_file(): %', SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function INSERT_TIME_SERIES (generic) class_name att IS NOT NULL
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.scn2_insert_time_series(
  classname             varchar,
  id                    integer DEFAULT NULL,
  gmlid                 varchar DEFAULT NULL,
  gmlid_codespace       varchar DEFAULT NULL,
  name                  varchar DEFAULT NULL,
  name_codespace        varchar DEFAULT NULL,
  description           text DEFAULT NULL,
  acquisition_method    varchar DEFAULT NULL,
  interpolation_type    varchar DEFAULT NULL,
  quality_description   text DEFAULT NULL,
  source                varchar DEFAULT NULL,
  time_array            timestamptz[] DEFAULT NULL,
  values_array          numeric[] DEFAULT NULL,
  values_unit           varchar DEFAULT NULL,
  array_length          integer DEFAULT NULL,
  temporal_extent_begin timestamp with time zone DEFAULT NULL,
  temporal_extent_end   timestamp with time zone DEFAULT NULL,
  time_interval         numeric DEFAULT NULL,
  time_interval_unit    varchar DEFAULT NULL,
  --
  file_path             varchar DEFAULT NULL,
  file_name             varchar DEFAULT NULL,
  file_extension        varchar DEFAULT NULL,
  nbr_header_lines      integer DEFAULT NULL,
  field_sep             varchar DEFAULT NULL,
  record_sep            varchar DEFAULT NULL,
  dec_symbol            varchar DEFAULT NULL,
  time_col_nbr          integer DEFAULT NULL,
  value_col_nbr         integer DEFAULT NULL,
  is_compressed         numeric(1) DEFAULT NULL,
  --
  schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer
AS $$
DECLARE
  p_id                    integer       := id                    ;
  p_gmlid                 varchar       := gmlid                 ;
  p_gmlid_codespace       varchar       := gmlid_codespace       ;
  p_name                  varchar       := name                  ;
  p_name_codespace        varchar       := name_codespace        ;
  p_description           text          := description           ;
  p_acquisition_method    varchar       := acquisition_method    ;
  p_interpolation_type    varchar       := interpolation_type    ;
  p_quality_description   text          := quality_description   ;
  p_source                varchar       := source                ;
  p_time_array            timestamptz[] := time_array            ;
  p_values_array          numeric[]     := values_array          ;
  p_values_unit           varchar       := values_unit           ;
  p_array_length          integer       := array_length          ;
  p_temporal_extent_begin timestamptz   := temporal_extent_begin ;
  p_temporal_extent_end   timestamptz   := temporal_extent_end   ;
  p_time_interval         numeric       := time_interval         ;
  p_time_interval_unit    varchar       := time_interval_unit    ;
--
  p_file_path             varchar       := file_path             ;
  p_file_name             varchar       := file_name             ;
  p_file_extension        varchar       := file_extension        ;
  p_nbr_header_lines      integer       := nbr_header_lines      ;
  p_field_sep             varchar       := field_sep             ;
  p_record_sep            varchar       := record_sep            ;
  p_dec_symbol            varchar       := dec_symbol            ;
  p_time_col_nbr          integer       := time_col_nbr          ;
  p_value_col_nbr         integer       := value_col_nbr         ;
  p_is_compressed         numeric(1)    := is_compressed         ;
--
	p_schema_name varchar := schema_name;
  class_name varchar := classname;
  db_prefix varchar DEFAULT 'scn2';
  inserted_id integer;
BEGIN
CASE class_name
	WHEN 'RegularTimeSeries' THEN
		inserted_id=citydb_view.scn2_insert_regular_time_series (
			id                   :=p_id                   ,
			gmlid                :=p_gmlid                ,
			gmlid_codespace      :=p_gmlid_codespace      ,
			name                 :=p_name                 ,
			name_codespace       :=p_name_codespace       ,
			description          :=p_description          ,
			acquisition_method   :=p_acquisition_method   ,
			interpolation_type   :=p_interpolation_type   ,
			quality_description  :=p_quality_description  ,
			source               :=p_source               ,
			values_array         :=p_values_array         ,
			values_unit          :=p_values_unit          ,
			array_length         :=p_array_length         ,
			temporal_extent_begin:=p_temporal_extent_begin,
			temporal_extent_end  :=p_temporal_extent_end  ,
			time_interval        :=p_time_interval        ,
			time_interval_unit   :=p_time_interval_unit   ,
	    schema_name          :=p_schema_name
		);
	WHEN 'IrregularTimeSeries' THEN
		inserted_id=citydb_view.scn2_insert_irregular_time_series (
			id                 :=p_id                 ,
			gmlid              :=p_gmlid              ,
			gmlid_codespace    :=p_gmlid_codespace    ,
			name               :=p_name               ,
			name_codespace     :=p_name_codespace     ,
			description        :=p_description        ,
			acquisition_method :=p_acquisition_method ,
			interpolation_type :=p_interpolation_type ,
			quality_description:=p_quality_description,
			source             :=p_source             ,
			time_array         :=p_time_array         ,
			values_array       :=p_values_array       ,
			values_unit        :=p_values_unit        ,
			array_length       :=p_array_length       ,
	    schema_name        :=p_schema_name
		);
	WHEN 'RegularTimeSeriesFile' THEN
		inserted_id=citydb_view.scn2_insert_regular_time_series_file (
			id                   :=p_id                   ,
			gmlid                :=p_gmlid                ,
			gmlid_codespace      :=p_gmlid_codespace      ,
			name                 :=p_name                 ,
			name_codespace       :=p_name_codespace       ,
			description          :=p_description          ,
			acquisition_method   :=p_acquisition_method   ,
			interpolation_type   :=p_interpolation_type   ,
			quality_description  :=p_quality_description  ,
			source               :=p_source               ,
			values_unit          :=p_values_unit          ,
			temporal_extent_begin:=p_temporal_extent_begin,
			temporal_extent_end  :=p_temporal_extent_end  ,
			time_interval        :=p_time_interval        ,
			time_interval_unit   :=p_time_interval_unit   ,
			file_path            :=p_file_path            ,
			file_name            :=p_file_name            ,
			file_extension       :=p_file_extension       ,
			nbr_header_lines     :=p_nbr_header_lines     ,
			field_sep            :=p_field_sep            ,
			record_sep           :=p_record_sep           ,
			dec_symbol           :=p_dec_symbol           ,
			value_col_nbr        :=p_value_col_nbr	      ,
			is_compressed        :=p_is_compressed        ,
	    schema_name          :=p_schema_name
		);
	WHEN 'IrregularTimeSeriesFile' THEN
		inserted_id=citydb_view.scn2_insert_irregular_time_series_file (
			id                   :=p_id                   ,
			gmlid                :=p_gmlid                ,
			gmlid_codespace      :=p_gmlid_codespace      ,
			name                 :=p_name                 ,
			name_codespace       :=p_name_codespace       ,
			description          :=p_description          ,
			acquisition_method   :=p_acquisition_method   ,
			interpolation_type   :=p_interpolation_type   ,
			quality_description  :=p_quality_description  ,
			source               :=p_source               ,
			values_unit          :=p_values_unit          ,
			file_path            :=p_file_path            ,
			file_name            :=p_file_name            ,
			file_extension       :=p_file_extension       ,
			nbr_header_lines     :=p_nbr_header_lines     ,
			field_sep            :=p_field_sep            ,
			record_sep           :=p_record_sep           ,
			dec_symbol           :=p_dec_symbol           ,
			time_col_nbr         :=p_time_col_nbr         ,
			value_col_nbr        :=p_value_col_nbr	      ,
			is_compressed        :=p_is_compressed        ,
	    schema_name          :=p_schema_name
		);
ELSE
	RAISE EXCEPTION 'classname "%" not valid', class_name USING HINT = 'Valid values are "RegularTimeSeries", "IrregularTimeSeries", "RegularTimeSeriesFile" and "IrregularTimeSeriesFile"';
END CASE;
RETURN inserted_id;
EXCEPTION
  WHEN OTHERS THEN RAISE NOTICE 'citydb_view.scn2_insert_time_series(): %', SQLERRM;
END;
$$ LANGUAGE plpgsql VOLATILE;

-- ***********************************************************************
-- ***********************************************************************

DO
$$
BEGIN
RAISE NOTICE '

********************************

Scenario ADE view functions installation complete!

********************************

';
END
$$;
SELECT 'Scenario ADE view functions installed correctly!'::varchar AS installation_result;


-- ***********************************************************************
-- ***********************************************************************
--
-- END OF FILE
--
-- ***********************************************************************
-- ***********************************************************************