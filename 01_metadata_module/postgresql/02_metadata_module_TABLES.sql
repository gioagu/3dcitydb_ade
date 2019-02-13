-- 3D City Database "Metadata Module" for ADEs v. 0.1
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
-- ******************* 02_metadata_module_TABLES.sql *********************
--
-- This  script installs the tables needed to set up the metadata module
-- in the 3DCityDB.
--
-- ***********************************************************************
-- ***********************************************************************

----------------------------------------------------------------
-- Table ADE
----------------------------------------------------------------
DROP TABLE IF EXISTS citydb.ade CASCADE;
CREATE TABLE citydb.ade (
id serial PRIMARY KEY,
name varchar(1000),
description varchar(4000),
version varchar(50),
db_prefix varchar(10) UNIQUE NOT NULL,
xml_schemamapping_file text,
drop_db_script text,
creation_date timestamp(0) with time zone DEFAULT now(),
creation_person varchar(256) DEFAULT user
);
--ALTER TABLE citydb.ade OWNER TO postgres;

----------------------------------------------------------------
-- Table SCHEMA
----------------------------------------------------------------
DROP TABLE IF EXISTS citydb.schema CASCADE;
CREATE TABLE citydb.schema (
id serial PRIMARY KEY,
ade_id integer,
is_ade_root numeric(1,0),
citygml_version varchar(50),
xml_namespace_uri character varying(4000),
xml_namespace_prefix character varying(50),
xml_schema_location character varying(4000),
xml_schemafile bytea,
xml_schemafile_type character varying(256)
);
--ALTER TABLE citydb.schema OWNER TO postgres;

CREATE INDEX schema_ade_id_fkx ON citydb.schema USING btree (ade_id);
CREATE INDEX schema_is_ade_root_inx ON citydb.schema USING btree (is_ade_root);

ALTER TABLE IF EXISTS citydb.schema ADD CONSTRAINT schema_ade_fk FOREIGN KEY (ade_id) REFERENCES citydb.ade (id) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;

----------------------------------------------------------------
-- Table SCHEMA_REFERENCING
----------------------------------------------------------------
DROP TABLE IF EXISTS citydb.schema_referencing;
CREATE TABLE citydb.schema_referencing (
referencing_id integer NOT NULL,
referenced_id integer NOT NULL,
CONSTRAINT schema_referencing_pky PRIMARY KEY (referenced_id,referencing_id)
);
--ALTER TABLE citydb.schema OWNER TO postgres;

CREATE INDEX schema_ref_local_id_inx ON citydb.schema_referencing USING btree (referenced_id) WITH (FILLFACTOR = 90);
CREATE INDEX schema_ref_ref_id_inx ON citydb.schema_referencing USING btree (referencing_id) WITH (FILLFACTOR = 90);

ALTER TABLE IF EXISTS citydb.schema_referencing ADD CONSTRAINT schema_ref_schema_fk1 FOREIGN KEY (referenced_id) REFERENCES citydb.schema (id) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE IF EXISTS citydb.schema_referencing ADD CONSTRAINT schema_ref_schema_fk2 FOREIGN KEY (referencing_id) REFERENCES citydb.schema (id) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;

----------------------------------------------------------------
-- Table SCHEMA_TO_OBJECTCLASS
----------------------------------------------------------------
DROP TABLE IF EXISTS citydb.schema_to_objectclass;
CREATE TABLE citydb.schema_to_objectclass (
schema_id integer NOT NULL,
objectclass_id integer NOT NULL,
CONSTRAINT schema_to_objectclass_pk PRIMARY KEY (schema_id,objectclass_id)
);
--ALTER TABLE citydb.schema OWNER TO postgres;

CREATE INDEX sch_to_objc_sch_id_inx ON citydb.schema_to_objectclass USING btree (schema_id) WITH (FILLFACTOR = 90);
CREATE INDEX sch_to_objc_objc_id_inx ON citydb.schema_to_objectclass USING btree (objectclass_id) WITH (FILLFACTOR = 90);

ALTER TABLE IF EXISTS citydb.schema_to_objectclass ADD CONSTRAINT sch_to_objclass_sch_fk FOREIGN KEY (schema_id) REFERENCES citydb.schema (id) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE IF EXISTS citydb.schema_to_objectclass ADD CONSTRAINT sch_to_objclass_objc_fk FOREIGN KEY (objectclass_id) REFERENCES citydb.objectclass (id) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;

----------------------------------------------------------------
-- ALTER Table OBJECTCLASS
----------------------------------------------------------------
ALTER TABLE citydb.objectclass
	DROP COLUMN IF EXISTS tablename,
	DROP COLUMN IF EXISTS is_ade_class,
	DROP COLUMN IF EXISTS baseclass_id;

ALTER TABLE citydb.objectclass
	ADD COLUMN tablename varchar(30),      -- This is to guarantee compatibility with Oracle.
	ADD COLUMN is_ade_class numeric(1,0),  -- This is to guarantee compatibility with Oracle.
	ADD COLUMN baseclass_id integer;

CREATE INDEX objectclass_is_ade_class_inx ON citydb.objectclass USING btree (is_ade_class) WITH (FILLFACTOR = 90);
CREATE INDEX objectclass_baseclass_id_fkx ON citydb.objectclass USING btree (baseclass_id) WITH (FILLFACTOR = 90);

ALTER TABLE citydb.objectclass ADD CONSTRAINT objectclass_baseclass_id_fk FOREIGN KEY (baseclass_id) REFERENCES citydb.objectclass (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;
--ALTER TABLE citydb.objectclass DROP CONSTRAINT IF EXISTS objectclass_superclass_id_fk;
--ALTER TABLE citydb.objectclass ADD CONSTRAINT objectclass_superclass_id_fk FOREIGN KEY (superclass_id) REFERENCES objectclass (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;

-- ***********************************************************************
-- ***********************************************************************

DO
$$
BEGIN
RAISE NOTICE '

********************************

Metadata module tables installation complete!

********************************

';
END
$$;
SELECT 'Metadata module tables installed correctly!'::varchar AS installation_result;

-- ***********************************************************************
-- ***********************************************************************
--
-- END OF FILE
--
-- ***********************************************************************
-- ***********************************************************************
