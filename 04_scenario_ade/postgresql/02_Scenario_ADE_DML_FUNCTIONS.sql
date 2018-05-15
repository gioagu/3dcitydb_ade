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
-- ********************* 02_Scenario_ADE_FUNCTIONS.sql *******************
--
-- This script adds the stored procedures to the citydb_pkg schema.
-- They are all prefixed with "scn2_".
--
-- ***********************************************************************
-- ***********************************************************************

----------------------------------------------------------------
-- Function SCN_DELETE_OPERATION
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_pkg.scn2_delete_operation(integer,varchar);
CREATE OR REPLACE FUNCTION citydb_pkg.scn2_delete_operation(
	o_id integer,
	schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS $$
DECLARE
  ts_id integer;
	deleted_id integer;
BEGIN
-- delete referencing sub-action(s)
EXECUTE format('SELECT citydb_pkg.scn2_delete_operation(id, %L) FROM %I.scn2_operation WHERE id != %L AND operation_parent_id = %L', schema_name, schema_name, o_id, o_id);
-- Delete dependent resource records (carried out automatically on DELETE CASCADE)
-- Get the id of the dependent time_series
EXECUTE format('SELECT time_series_id FROM %I.scn2_operation WHERE id = %L', schema_name, o_id) INTO ts_id;
IF ts_id IS NOT NULL THEN
-- Delete the dependent time_series
  EXECUTE 'SELECT citydb_pkg.scn2_delete_time_series($1, $2)' USING ts_id, schema_name;
END IF;
-- Delete the operation itself
EXECUTE format('DELETE FROM %I.scn2_operation WHERE id = %L RETURNING id', schema_name, o_id) INTO deleted_id;
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.scn2_delete_operation (id: %): %', o_id, SQLERRM;
END;
$$ LANGUAGE plpgsql;

----------------------------------------------------------------
-- Function SCN_DELETE_RESOURCE
----------------------------------------------------------------
-- Actually, this is carried out automatically upon CASCADE
DROP FUNCTION IF EXISTS    citydb_pkg.scn2_delete_resource(integer, varchar);
CREATE OR REPLACE FUNCTION citydb_pkg.scn2_delete_resource (
	o_id integer,
	schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS $$
DECLARE
	deleted_id integer;
BEGIN
EXECUTE format('DELETE FROM %I.scn2_resource WHERE id = %L RETURNING id', schema_name, o_id) INTO deleted_id;
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.scn2_delete_resource (id: %): %', o_id, SQLERRM;
END;
$$
LANGUAGE plpgsql;

----------------------------------------------------------------
-- Function SCN_DELETE_SCENARIO_PARAMETER
----------------------------------------------------------------
-- Actually, this is carried out automatically upon CASCADE
DROP FUNCTION IF EXISTS    citydb_pkg.scn2_delete_scenario_parameter(integer,varchar);
CREATE OR REPLACE FUNCTION citydb_pkg.scn2_delete_scenario_parameter(
	o_id integer,
	schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS $$
DECLARE
  ts_id integer;
	deleted_id integer;
BEGIN
-- Get the id of the dependent time_series
EXECUTE format('SELECT time_series_id FROM %I.scn2_scenario_parameter WHERE id = %L', schema_name, o_id) INTO ts_id;
IF ts_id IS NOT NULL THEN
-- Delete the dependent time_series
  EXECUTE 'SELECT citydb_pkg.scn2_delete_time_series($1, $2)' USING ts_id, schema_name;
END IF;
-- Delete the scenario_parameter itself
EXECUTE format('DELETE FROM %I.scn2_scenario_parameter WHERE id = %L RETURNING id', schema_name, o_id) INTO deleted_id;
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.scn2_delete_scenario_parameter (id: %): %', o_id, SQLERRM;
END;
$$
LANGUAGE plpgsql;

----------------------------------------------------------------
-- Function SCN_DELETE_SCENARIO
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_pkg.scn2_delete_scenario(integer,varchar);
CREATE OR REPLACE FUNCTION citydb_pkg.scn2_delete_scenario(
	o_id integer,
	schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS $$
DECLARE
  sp_id integer;
  op_id integer;
  deleted_id integer;
BEGIN
-- Delete the depending (sub)scenario(s)
EXECUTE format('SELECT citydb_pkg.scn2_delete_scenario(id, %L) FROM %I.scn2_scenario WHERE id != %L AND scenario_parent_id = %L', schema_name, schema_name, o_id, o_id);

-- Delete dependent resource records (carried out automatically on DELETE CASCADE)
-- Delete dependent scenario parameters
FOR sp_id IN EXECUTE format('SELECT id FROM %I.scn2_scenario_parameter WHERE scenario_id = %L', schema_name, o_id) LOOP
	IF sp_id IS NOT NULL THEN
		-- delete dependent scenario parameter 
		EXECUTE 'SELECT citydb_pkg.scn2_delete_scenario_parameter($1, $2)' USING sp_id, schema_name;
	END IF;
END LOOP;

-- Delete dependent operations that are not referenced by anyone else 
EXECUTE format('SELECT citydb_pkg.scn2_delete_operation(op.id, %L) FROM %I.scn2_operation AS op, %I.scn2_scenario_to_operation AS s2o WHERE
op.id=s2o.operation_id AND s2o.scenario_id=%L AND citydb_pkg.is_not_referenced(''scn2_scenario_to_operation'', ''operation_id'', op.id, ''scenario_id'', %L, %L)',
schema_name, schema_name, schema_name, 
o_id, o_id, schema_name);

-- Delete the scenario itself (and this automatically deletes also the entry in the scenario_to_operation table)
EXECUTE format('DELETE FROM %I.scn2_scenario WHERE id = %L RETURNING id', schema_name, o_id) INTO deleted_id;
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.scn2_delete_scenario (id: %): %', o_id, SQLERRM;
END;
$$
LANGUAGE plpgsql;

----------------------------------------------------------------
-- Function SCN_DELETE_TIME_SERIES
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_pkg.scn2_delete_time_series(integer,varchar);
CREATE OR REPLACE FUNCTION citydb_pkg.scn2_delete_time_series(
	ts_id integer,
	schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS $$
DECLARE
	deleted_id integer;
BEGIN
-- Note: deleting of entries in dependent table timeseries_file carried out automatically via ON DELETE CASCADE
-- Note: setting null in all referencing tables carried out automatically via ON DELETE SET NULL
EXECUTE format('DELETE FROM %I.scn2_time_series WHERE id = %L RETURNING id', schema_name, ts_id) INTO deleted_id;
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.scn2_delete_time_series (id: %): %', ts_id, SQLERRM;
END;
$$
LANGUAGE plpgsql;

----------------------------------------------------------------
-- Function SCN_DELETE_TIMESERIES_FILE
----------------------------------------------------------------
-- Not necessary because deleted upon ON DELETE CASCADE on table scn2_time_series.

----------------------------------------------------------------
-- Function SCN_INSERT_TIME_SERIES
----------------------------------------------------------------
-- DROP FUNCTION IF EXISTS citydb_pkg.scn2_insert_time_series (integer, integer, character varying, character varying, character varying, character varying, text, character varying, character varying, text, character varying, timestamptz[], numeric[], character varying, integer, timestamp with time zone, timestamp with time zone, numeric, character varying) CASCADE;
CREATE OR REPLACE FUNCTION citydb_pkg.scn2_insert_time_series (
  objectclass_id        integer,
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
  temporal_extent_begin timestamptz DEFAULT NULL,
  temporal_extent_end   timestamptz DEFAULT NULL,
  time_interval         numeric DEFAULT NULL,
  time_interval_unit    varchar DEFAULT NULL, 
  schema_name           varchar DEFAULT 'citydb'::varchar
)
RETURNS integer
AS
$$
DECLARE
  p_id                    integer       := id;
  p_objectclass_id        integer       := objectclass_id;
  p_gmlid                 varchar       := gmlid;
  p_gmlid_codespace       varchar       := gmlid_codespace;
  p_name                  varchar       := name;
  p_name_codespace        varchar       := name_codespace;
  p_description           text          := description;
  p_acquisition_method    varchar       := acquisition_method;
  p_interpolation_type    varchar       := interpolation_type;
  p_quality_description   text          := quality_description;
  p_source                varchar       := source;
  p_time_array            timestamptz[] := time_array;
  p_values_array          numeric[]     := values_array;
  p_values_unit           varchar       := values_unit;
  p_array_length          integer       := array_length;
  p_temporal_extent_begin timestamptz   := temporal_extent_begin;
  p_temporal_extent_end   timestamptz   := temporal_extent_end;
  p_time_interval         numeric       := time_interval;
  p_time_interval_unit    varchar       := time_interval_unit;
--
  p_schema_name varchar := schema_name;
  seq_name varchar;
  inserted_id integer;
BEGIN
-- IF the ID is not given, then generate a new one.
IF p_id IS NULL THEN
  seq_name=schema_name||'.scn2_time_series_id_seq';
  p_id=nextval(seq_name::regclass);
END IF;
-- IF the GmlID is not given, then generate a new one.
IF p_gmlid IS NULL THEN
  p_gmlid='UUID_'||uuid_generate_v4();
END IF;
EXECUTE format('
    INSERT INTO %I.scn2_time_series (
     id,
     objectclass_id,
     gmlid,
     gmlid_codespace,
     name,
     name_codespace,
     description,
     acquisition_method,
     interpolation_type,
     quality_description,
     source,
     time_array,
     values_array,
     values_unit,
     array_length,
     temporal_extent_begin,
     temporal_extent_end,
     time_interval,
     time_interval_unit
    ) VALUES (
    %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L
    ) RETURNING id',
    p_schema_name,
    p_id,
    p_objectclass_id,
    p_gmlid,
    p_gmlid_codespace,
    p_name,
    p_name_codespace,
    p_description,
    p_acquisition_method,
    p_interpolation_type,
    p_quality_description,
    p_source,
    p_time_array,
    p_values_array,
    p_values_unit,
    p_array_length,
    p_temporal_extent_begin,
    p_temporal_extent_end,
    p_time_interval,
    p_time_interval_unit
) INTO inserted_id;
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.scn2_insert_time_series (id: %): %', p_id, SQLERRM;
END;
$$
LANGUAGE 'plpgsql';

----------------------------------------------------------------
-- Function SCN_INSERT_TIME_SERIES_FILE
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_pkg.scn2_insert_time_series_file (integer, integer, varchar, varchar, varchar, integer, varchar, varchar, varchar, integer, integer, numeric) CASCADE;
CREATE OR REPLACE FUNCTION citydb_pkg.scn2_insert_time_series_file (
  objectclass_id       integer,
  id                   integer,
  file_path            varchar DEFAULT NULL,
  file_name            varchar DEFAULT NULL,
  file_extension       varchar DEFAULT NULL,
  nbr_header_lines     integer DEFAULT NULL,
  field_sep            varchar DEFAULT NULL,
  record_sep           varchar DEFAULT NULL,
  dec_symbol           varchar DEFAULT NULL,
  time_col_nbr         integer DEFAULT NULL,
  value_col_nbr        integer DEFAULT NULL,
  is_compressed        numeric DEFAULT NULL, 
  schema_name          varchar DEFAULT 'citydb'::varchar
)
RETURNS integer
AS
$$
DECLARE
  p_id                 integer := id;
  p_objectclass_id     integer := objectclass_id;
  p_file_path          varchar := file_path;
  p_file_name          varchar := file_name;
  p_file_extension     varchar := file_extension;
  p_nbr_header_lines   integer := nbr_header_lines;
  p_field_sep          varchar := field_sep;
  p_record_sep         varchar := record_sep;
  p_dec_symbol         varchar := dec_symbol;
  p_time_col_nbr       integer := time_col_nbr;
  p_value_col_nbr      integer := value_col_nbr;
  p_is_compressed      numeric := is_compressed;
--  
  p_schema_name varchar := schema_name;
  inserted_id integer;
BEGIN
EXECUTE format('INSERT INTO %I.scn2_time_series_file (
 id,
 objectclass_id,
 file_path,
 file_name,
 file_extension,
 nbr_header_lines,
 field_sep,
 record_sep,
 dec_symbol,
 time_col_nbr,
 value_col_nbr,
 is_compressed
) VALUES (
%L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L
) RETURNING id',
 p_schema_name,
 p_id,
 p_objectclass_id,
 p_file_path,
 p_file_name,
 p_file_extension,
 p_nbr_header_lines,
 p_field_sep,
 p_record_sep,
 p_dec_symbol,
 p_time_col_nbr,
 p_value_col_nbr,
 p_is_compressed
) INTO inserted_id;
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.scn2_insert_time_series_file (id: %): %', p_id, SQLERRM;
END;
$$
LANGUAGE 'plpgsql';

----------------------------------------------------------------
-- Function SCN_INSERT_SCENARIO_PARAMETER
----------------------------------------------------------------
-- DROP FUNCTION IF EXISTS citydb_pkg.scn2_insert_scenario_parameter (integer, integer, varchar, varchar, text, varchar, varchar, integer, numeric, varchar, timestamptz, varchar, bytea, geometry, integer, integer) CASCADE;
CREATE OR REPLACE FUNCTION citydb_pkg.scn2_insert_scenario_parameter (
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
  schema_name          varchar DEFAULT 'citydb'::varchar
)
RETURNS integer
AS
$$
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
  seq_name varchar;
  inserted_id integer;
BEGIN
-- IF the ID is not given, then generate a new one.
IF p_id IS NULL THEN
  seq_name=schema_name||'.scn2_scenario_parameter_id_seq';
  p_id=nextval(seq_name::regclass);
END IF;
EXECUTE format('INSERT INTO %I.scn2_scenario_parameter (
 id              ,
 type            ,
 name            ,
 name_codespace  ,
 description     ,
 class           ,
 constraint_type ,
 sim_name        ,
 sim_description ,
 sim_reference   ,
 aggregation_type,
 temp_aggregation,
 strval          ,
 booleanval      ,
 intval          ,
 realval         ,
 unit            ,
 dateval         ,
 urival          ,
 geomval         ,
 time_series_id  ,
 cityobject_id   ,
 scenario_id   
) VALUES (
%L, %L, %L, %L, %L, %L, %L, %L, %L, %L,
%L, %L, %L, %L, %L, %L, %L, %L, %L, %L,
%L, %L, %L
) RETURNING id',
 p_schema_name  	,
 p_id              ,
 p_type            ,
 p_name            ,
 p_name_codespace  ,
 p_description     ,
 p_class           ,
 p_constraint_type ,
 p_sim_name        ,
 p_sim_description ,
 p_sim_reference   ,
 p_aggregation_type,
 p_temp_aggregation,
 p_strval          ,
 p_booleanval      ,
 p_intval          ,
 p_realval         ,
 p_unit            ,
 p_dateval         ,
 p_urival          ,
 p_geomval         ,
 p_time_series_id  ,
 p_cityobject_id   ,
 p_scenario_id
) INTO inserted_id;
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.scn2_insert_scenario_parameter (id: %): %', p_id, SQLERRM;
END;
$$
LANGUAGE 'plpgsql';

----------------------------------------------------------------
-- Function SCN_INSERT_OPERATION
----------------------------------------------------------------
-- DROP FUNCTION IF EXISTS citydb_pkg.scn2_insert_operation (integer, integer, integer, integer, varchar, varchar, varchar, varchar, text, integer, varchar, varchar, varchar, integer, varchar, varchar, integer, numeric, numeric[], varchar, timestamptz, varchar, bytea, geometry, integer) CASCADE;
CREATE OR REPLACE FUNCTION citydb_pkg.scn2_insert_operation (
objectclass_id            integer,
id                        integer             DEFAULT NULL,
operation_parent_id       integer             DEFAULT NULL,
operation_root_id         integer             DEFAULT NULL,
gmlid                     varchar             DEFAULT NULL,
gmlid_codespace           varchar             DEFAULT NULL,
name                      varchar             DEFAULT NULL,
name_codespace            varchar             DEFAULT NULL,
description               text                DEFAULT NULL,
pos_nbr                   integer             DEFAULT NULL,
class                     varchar             DEFAULT NULL,
parent_feature_uri        varchar             DEFAULT NULL,
feature_uri               varchar             DEFAULT NULL,
attribute_uri             varchar             DEFAULT NULL,
citydb_object_id          integer             DEFAULT NULL,
citydb_table_name         varchar             DEFAULT NULL,
citydb_column_name        varchar             DEFAULT NULL,
citydb_function           varchar             DEFAULT NULL,
citydb_genericattrib_name varchar             DEFAULT NULL,
strval                    varchar             DEFAULT NULL,
booleanval                numeric(1,0)        DEFAULT NULL,
intval                    integer             DEFAULT NULL,
realval                   numeric             DEFAULT NULL,
unit                      varchar             DEFAULT NULL,
dateval                   timestamptz         DEFAULT NULL,
urival                    varchar             DEFAULT NULL,
geomval                   geometry(GeometryZ) DEFAULT NULL,
time_series_id            integer             DEFAULT NULL,
--	
schema_name           varchar DEFAULT 'citydb'::varchar
)
RETURNS integer
AS $$
DECLARE
  p_id                        integer            := id                   ;
  p_objectclass_id            integer            := objectclass_id       ;
  p_operation_parent_id       integer            := operation_parent_id  ;
  p_operation_root_id         integer            := operation_root_id    ;
  p_gmlid                     varchar            := gmlid                ;
  p_gmlid_codespace           varchar            := gmlid_codespace      ;
  p_name                      varchar            := name                 ;
  p_name_codespace            varchar            := name_codespace       ;
  p_description               text               := description          ;
  p_pos_nbr                   integer            := pos_nbr              ;
  p_class                     varchar            := class                ;
  p_parent_feature_uri        varchar            := parent_feature_uri   ;
  p_feature_uri               varchar            := feature_uri          ;
  p_attribute_uri             varchar            := attribute_uri        ;
  p_citydb_object_id          integer            := citydb_object_id     ;
  p_citydb_table_name         varchar            := citydb_table_name    ;
  p_citydb_column_name        varchar            := citydb_column_name   ;
  p_citydb_function           varchar            := citydb_function      ;
  p_citydb_genericattrib_name varchar            := citydb_genericattrib_name;  
  p_strval                    varchar            := strval               ;
  p_booleanval                numeric(1,0)       := booleanval           ;
  p_intval                    integer            := intval               ;
  p_realval                   numeric            := realval              ;
  p_unit                      varchar            := unit                 ;
  p_dateval                   timestamptz        := dateval              ;
  p_urival                    varchar            := urival               ;
  p_geomval                   geometry(GeometryZ):= geomval              ;
  p_time_series_id            integer            := time_series_id       ;
--  
  p_schema_name varchar := schema_name;
  seq_name varchar;
  inserted_id integer;
BEGIN
-- IF the ID is not given, then generate a new one.
IF p_id IS NULL THEN
  seq_name=schema_name||'.scn2_operation_id_seq';
  p_id=nextval(seq_name::regclass);
END IF;
-- IF the GmlID is not given, then generate a new one.
IF p_gmlid IS NULL THEN
  p_gmlid='UUID_'||uuid_generate_v4();
END IF;
EXECUTE format('INSERT INTO %I.scn2_operation (
 id                       ,
 objectclass_id           ,
 operation_parent_id      ,
 operation_root_id        ,
 gmlid                    ,
 gmlid_codespace          ,
 name                     ,
 name_codespace           ,
 description              ,
 pos_nbr                  ,
 class                    ,
 parent_feature_uri       ,
 feature_uri              ,
 attribute_uri            ,
 citydb_table_name        ,
 citydb_object_id         ,
 citydb_column_name       ,
 citydb_function          ,
 citydb_genericattrib_name,
 strval                   ,
 booleanval               ,
 intval                   ,
 realval                  ,
 unit                     ,
 dateval                  ,
 urival                   ,
 geomval                  ,
 time_series_id       
) VALUES (
%L, %L, %L, %L, %L, %L, %L, %L, %L, %L, 
%L, %L, %L, %L, %L, %L, %L, %L, %L, %L, 
%L, %L, %L, %L, %L, %L, %L, %L
) RETURNING id',
 p_schema_name,
 p_id                       ,
 p_objectclass_id           ,
 p_operation_parent_id      ,
 p_operation_root_id        ,
 p_gmlid                    ,
 p_gmlid_codespace          ,
 p_name                     ,
 p_name_codespace           ,
 p_description              ,
 p_pos_nbr                  ,
 p_class                    ,
 p_parent_feature_uri       ,
 p_feature_uri              ,
 p_attribute_uri            ,
 p_citydb_table_name        ,
 p_citydb_object_id         ,
 p_citydb_column_name       ,
 p_citydb_function          ,
 p_citydb_genericattrib_name,
 p_strval                   ,
 p_booleanval               ,
 p_intval                   ,
 p_realval                  ,
 p_unit                     ,
 p_dateval                  ,
 p_urival                   ,
 p_geomval                  ,
 p_time_series_id		
) INTO inserted_id;
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.scn2_insert_operation (id: %): %', p_id, SQLERRM;
END;
$$
LANGUAGE 'plpgsql';

----------------------------------------------------------------
-- Function SCN_INSERT_SCENARIO_TO_OPERATION
----------------------------------------------------------------
-- DROP FUNCTION IF EXISTS citydb_pkg.scn2_insert_scenario_to_operation (integer, integer, integer) CASCADE;
CREATE OR REPLACE FUNCTION citydb_pkg.scn2_insert_scenario_to_operation (
  scenario_id integer,
  operation_id   integer,
  pos_nbr     integer DEFAULT NULL,
--
  schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS void
AS
$$
DECLARE
  p_scenario_id  integer := scenario_id;
  p_operation_id integer := operation_id;
  p_pos_nbr      integer := pos_nbr;
--  
  p_schema_name varchar := schema_name;
BEGIN
EXECUTE format('INSERT INTO %I.scn2_scenario_to_operation (
 scenario_id,
 operation_id,
 pos_nbr
) VALUES (
%L, %L, %L
)',
 p_schema_name,	
 p_scenario_id, 
 p_operation_id, 
 p_pos_nbr
);
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.scn2_insert_scenario_to_operation (scenario_id: %, operation_id: %): %', scenario_id, operation_id, SQLERRM;
END;
$$
LANGUAGE 'plpgsql';

----------------------------------------------------------------
-- Function SCN_INSERT_SCENARIO
----------------------------------------------------------------
-- DROP FUNCTION IF EXISTS citydb_pkg.scn2_insert_scenario (integer, integer, varchar, varchar, varchar, varchar, text, varchar, integer, integer, varchar, date) CASCADE;
CREATE OR REPLACE FUNCTION citydb_pkg.scn2_insert_scenario (
  objectclass_id       integer,
  id                   integer            DEFAULT NULL,
  scenario_parent_id   integer            DEFAULT NULL,
  gmlid                varchar            DEFAULT NULL,
  gmlid_codespace      varchar            DEFAULT NULL,
  name                 varchar            DEFAULT NULL,
  name_codespace       varchar            DEFAULT NULL,
  description          text               DEFAULT NULL,
  class                varchar            DEFAULT NULL,
  instant              timestamptz(0)     DEFAULT NULL,
  period_begin         date               DEFAULT NULL,
  period_end           date               DEFAULT NULL,
  citymodel_id         integer            DEFAULT NULL,
  cityobject_id        integer            DEFAULT NULL,
  envelope             geometry(PolygonZ) DEFAULT NULL,		
  creator_name         varchar            DEFAULT NULL,
  creation_date        timestamptz(0)     DEFAULT NULL,
--	
  schema_name          varchar            DEFAULT 'citydb'::varchar
)
RETURNS integer
AS
$$
DECLARE
  p_id                 integer            := id                ;
  p_scenario_parent_id integer            := scenario_parent_id;  
  p_objectclass_id     integer            := objectclass_id    ;
  p_gmlid              varchar            := gmlid             ;
  p_gmlid_codespace    varchar            := gmlid_codespace   ;
  p_name               varchar            := name              ;
  p_name_codespace     varchar            := name_codespace    ;
  p_description        text               := description       ;
  p_class              varchar            := class             ;
  p_instant            timestamptz(0)     := instant           ;
  p_period_begin       date               := period_begin      ;
  p_period_end         date               := period_end        ; 	
  p_citymodel_id       integer            := citymodel_id      ;
  p_cityobject_id      integer            := cityobject_id     ;
  p_envelope           geometry(PolygonZ) := envelope          ; 
  p_creator_name       varchar            := creator_name      ;
  p_creation_date      timestamptz(0)     := creation_date     ;
--
  p_schema_name varchar := schema_name;
  seq_name varchar;
  inserted_id integer;
BEGIN
-- IF the ID is not given, then generate a new one.
IF p_id IS NULL THEN
  seq_name=schema_name||'.scn2_scenario_id_seq';
  p_id=nextval(seq_name::regclass);
END IF;
-- IF the GmlID is not given, then generate a new one.
IF p_gmlid IS NULL THEN
  p_gmlid='UUID_'||uuid_generate_v4();
END IF;
EXECUTE format('INSERT INTO %I.scn2_scenario (
 id                ,
 objectclass_id    ,
 scenario_parent_id,
 gmlid             ,
 gmlid_codespace   ,
 name              ,
 name_codespace    ,
 description       ,
 class             ,
 instant           ,
 period_begin      ,
 period_end        ,
 citymodel_id      ,
 cityobject_id     ,
 envelope          ,
 creator_name      ,
 creation_date
) VALUES (
%L, %L, %L, %L, %L, %L, %L, %L, %L, %L,
%L, %L, %L, %L, %L, %L, %L
) RETURNING id',
 p_schema_name,	
 p_id                ,
 p_objectclass_id    ,
 p_scenario_parent_id,
 p_gmlid             ,
 p_gmlid_codespace   ,
 p_name              ,
 p_name_codespace    ,
 p_description       ,
 p_class             ,
 p_instant           ,
 p_period_begin      ,
 p_period_end        ,
 p_citymodel_id      ,
 p_cityobject_id     ,
 p_envelope          ,
 p_creator_name      ,
 p_creation_date
) INTO inserted_id;
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.scn2_insert_scenario (id: %): %', p_id, SQLERRM;
END;
$$
LANGUAGE 'plpgsql';

----------------------------------------------------------------
-- Function SCN_INSERT_RESOURCE
----------------------------------------------------------------
-- DROP FUNCTION IF EXISTS citydb_pkg.scn2_insert_resource (integer, integer, varchar, varchar, varchar, varchar, text, varchar, numeric, varchar, numeric, varchar, numeric, integer, integer) CASCADE;
CREATE OR REPLACE FUNCTION citydb_pkg.scn2_insert_resource (
  objectclass_id       integer,
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
  schema_name          varchar DEFAULT 'citydb'::varchar
)
RETURNS integer
AS $$
DECLARE
  p_id                integer      := id;
  p_objectclass_id    integer      := objectclass_id;
  p_gmlid             varchar      := gmlid;
  p_gmlid_codespace   varchar      := gmlid_codespace;
  p_name              varchar      := name;
  p_name_codespace    varchar      := name_codespace;
  p_description       text         := description;
  p_type              varchar      := type;
  p_quantity          numeric      := quantity;
  p_quantity_unit     varchar      := quantity_unit;
  p_total_cost        numeric      := total_cost;
  p_total_cost_unit   varchar      := total_cost_unit;	
  p_unitary_cost      numeric      := unitary_cost;
  p_unitary_cost_unit varchar      := unitary_cost_unit;
  p_is_renewable      numeric(1,0) := is_renewable;
  p_scenario_id       integer      := scenario_id;
  p_operation_id      integer      := action_id;
--  
  p_schema_name varchar := schema_name;
  seq_name varchar;
  inserted_id integer;
BEGIN
-- IF the ID is not given, then generate a new one.
IF p_id IS NULL THEN
  seq_name=schema_name||'.scn2_resource_id_seq';
  p_id=nextval(seq_name::regclass);
END IF;
-- IF the GmlID is not given, then generate a new one.
IF p_gmlid IS NULL THEN
  p_gmlid='UUID_'||uuid_generate_v4();
END IF;

EXECUTE format('INSERT INTO %I.scn2_resource (
 id             ,
 objectclass_id ,
 gmlid          ,
 gmlid_codespace,
 name           ,
 name_codespace ,
 description    ,
 type           ,
 quantity       ,
 quantity_unit  ,
 total_cost     ,
 total_cost     ,
 unitary_cost   ,
 unitary_cost   ,
 is_renewable   ,
 scenario_id    ,
 operation_id
) VALUES (
%L, %L, %L, %L, %L, %L, %L, %L, %L, %L,
%L, %L, %L, %L, %L, %L, %L
) RETURNING id',
 p_schema_name,
 p_id             ,
 p_objectclass_id ,
 p_gmlid          ,
 p_gmlid_codespace,
 p_name           ,
 p_name_codespace ,
 p_description    ,
 p_type           ,
 p_quantity       ,
 p_quantity_unit  ,
 p_total_cost     ,
 p_total_cost     ,
 p_unitary_cost   ,
 p_unitary_cost   ,
 p_is_renewable   ,
 p_scenario_id    ,
 p_operation_id		
) INTO inserted_id;
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.scn2_insert_resource (id: %): %', p_id, SQLERRM;
END;
$$
LANGUAGE 'plpgsql';

-- ***********************************************************************
-- ***********************************************************************

DO
$$
BEGIN
RAISE NOTICE '

********************************

Scenario ADE DML functions installation complete!

********************************

';
END
$$;
SELECT 'Scenario ADE DML functions installation complete!'::varchar AS installation_result;

-- ***********************************************************************
-- ***********************************************************************
--
-- END OF FILE
--
-- ***********************************************************************
-- ***********************************************************************
