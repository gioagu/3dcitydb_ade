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
-- ****************** 06_citydb_util_DML_FUNCTIONS.sql *******************
--
-- This  script installs the extension "uuid-ossp" and additional
-- stored procedures into the citydb_pkg schema.
--
-- ***********************************************************************
-- ***********************************************************************

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" SCHEMA public;

ALTER TABLE citydb.cityobject_genericattrib ALTER COLUMN datatype SET NOT NULL;

DROP INDEX   IF EXISTS     cityobject_genericattrib_attrname_inx;
CREATE INDEX IF NOT EXISTS cityobject_genericattrib_attrname_inx ON citydb.cityobject_genericattrib (attrname);

----------------------------------------------------------------
-- Function INSERT_CITYMODEL
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_pkg.insert_citymodel(integer, character varying, character varying, character varying, character varying, character varying, geometry, timestamp with time zone, timestamp with time zone, timestamp with time zone, character varying, character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION citydb_pkg.insert_citymodel (
id                     integer       DEFAULT NULL,
gmlid                  varchar(256)  DEFAULT NULL,
gmlid_codespace        varchar(1000) DEFAULT NULL,
name                   varchar(1000) DEFAULT NULL,
name_codespace         varchar(4000) DEFAULT NULL,
description            varchar(4000) DEFAULT NULL,
envelope               geometry      DEFAULT NULL,
creation_date          timestamptz   DEFAULT NULL,
termination_date       timestamptz   DEFAULT NULL,
last_modification_date timestamptz   DEFAULT NULL,
updating_person        varchar(256)  DEFAULT NULL,
reason_for_update      varchar(4000) DEFAULT NULL,
lineage                varchar(256)  DEFAULT NULL,
--
schema_name            varchar DEFAULT 'citydb'::varchar
)
RETURNS integer
AS $$
DECLARE
p_id                     integer      := id                    ;
p_gmlid                  varchar(256) := gmlid                 ;
p_gmlid_codespace        varchar(1000):= gmlid_codespace       ;
p_name                   varchar(1000):= name                  ;
p_name_codespace         varchar(4000):= name_codespace        ;
p_description            varchar(4000):= description           ;
p_envelope               geometry     := envelope              ;
p_creation_date          timestamptz  := creation_date         ;
p_termination_date       timestamptz  := termination_date      ;
p_last_modification_date timestamptz  := last_modification_date;
p_updating_person        varchar(256) := updating_person       ;
p_reason_for_update      varchar(4000):= reason_for_update     ;
p_lineage                varchar(256) := lineage               ;
--
p_schema_name varchar := schema_name;
seq_name varchar;
inserted_id integer;
BEGIN
-- IF the ID is not given, then generate a new one.
IF p_id IS NULL THEN
	seq_name=schema_name||'.citymodel_seq';
	p_id=nextval(seq_name::regclass);
END IF;
-- IF the GmlID is not given, then generate a new one.
IF p_gmlid IS NULL THEN
	p_gmlid='UUID_'||uuid_generate_v4();
END IF;
-- IF the creation_date is not given, then generate a new one.
IF p_creation_date IS NULL THEN
	p_creation_date=now()::timestamp(0) with time zone;
END IF;

EXECUTE format('INSERT INTO %I.citymodel (
 id                    ,
 gmlid                 ,
 gmlid_codespace       ,
 name                  ,
 name_codespace        ,
 description           ,
 envelope              ,
 creation_date         ,
 termination_date      ,
 last_modification_date,
 updating_person       ,
 reason_for_update     ,
 lineage
) VALUES (
%L, %L, %L, %L, %L, %L, %L, %L, %L, %L,
%L, %L, %L
) RETURNING id',
 p_schema_name,		-- ADD schema_name,
 p_id                    ,
 p_gmlid                 ,
 p_gmlid_codespace       ,
 p_name                  ,
 p_name_codespace        ,
 p_description           ,
 p_envelope              ,
 p_creation_date         ,
 p_termination_date      ,
 p_last_modification_date,
 p_updating_person       ,
 p_reason_for_update     ,
 p_lineage
) INTO inserted_id;
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.insert_citymodel (id: %): %', p_id, SQLERRM;
END;
$$
LANGUAGE 'plpgsql';

----------------------------------------------------------------
-- Function INSERT_CITYOBJECT_MEMBER
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_pkg.insert_cityobject_member (integer, integer, varchar) CASCADE;
CREATE OR REPLACE FUNCTION citydb_pkg.insert_cityobject_member (
  citymodel_id         integer,
  cityobject_id        integer,
--
  schema_name          varchar DEFAULT 'citydb'::varchar
)
RETURNS void
AS $$
DECLARE
  p_citymodel_id  integer := citymodel_id;
  p_cityobject_id integer := cityobject_id;
  p_role          varchar := role;
--
  p_schema_name        varchar := schema_name;
BEGIN
EXECUTE format('INSERT INTO %I.cityobject_member (
 citymodel_id,
 cityobject_id
) VALUES (
%L, %L
)',
 p_schema_name,
 p_citymodel_id,
 p_cityobject_id
);
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.insert_cityobject_member (citymodel_id: %, cityobject_id %): %', p_citymodel_id, p_cityobject_id, SQLERRM;
END;
$$
LANGUAGE 'plpgsql';

----------------------------------------------------------------
-- Function INSERT_CITYOBJECT
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_pkg.insert_cityobject(integer, integer, character varying, character varying, character varying, character varying, character varying, geometry, timestamp with time zone, timestamp with time zone, character varying, character varying, timestamp with time zone, character varying, character varying, character varying, character varying) CASCADE;
CREATE OR REPLACE FUNCTION citydb_pkg.insert_cityobject (
  objectclass_id         integer,
  id                     integer DEFAULT NULL,
  gmlid                  varchar(256) DEFAULT NULL,
  gmlid_codespace        varchar(1000) DEFAULT NULL,
  name                   varchar(1000) DEFAULT NULL,
  name_codespace         varchar(4000) DEFAULT NULL,
  description            varchar(4000) DEFAULT NULL,
  envelope               geometry DEFAULT NULL,
  creation_date          timestamp(0) with time zone DEFAULT NULL,
  termination_date       timestamp(0) with time zone DEFAULT NULL,
  relative_to_terrain    varchar(256) DEFAULT NULL,
  relative_to_water      varchar(256) DEFAULT NULL,
  last_modification_date timestamp with time zone DEFAULT NULL,
  updating_person        varchar(256) DEFAULT NULL,
  reason_for_update      varchar(4000) DEFAULT NULL,
  lineage                varchar(256) DEFAULT NULL,
--
  schema_name            varchar DEFAULT 'citydb'::varchar
)
RETURNS integer
AS
$$
DECLARE
  p_id                     integer                     := id                    ;
  p_objectclass_id         integer	                   := objectclass_id        ;
  p_gmlid                  varchar(256)                := gmlid                 ;
  p_gmlid_codespace        varchar(1000)               := gmlid_codespace       ;
  p_name                   varchar(1000)               := name                  ;
  p_name_codespace         varchar(4000)               := name_codespace        ;
  p_description            varchar(4000)               := description           ;
  p_envelope               geometry                    := envelope              ;
  p_creation_date          timestamp(0) with time zone := creation_date         ;
  p_termination_date       timestamp(0) with time zone := termination_date      ;
  p_relative_to_terrain    varchar(256)                := relative_to_terrain   ;
  p_relative_to_water      varchar(256)                := relative_to_water     ;
  p_last_modification_date timestamp with time zone    := last_modification_date;
  p_updating_person        varchar(256)                := updating_person       ;
  p_reason_for_update      varchar(4000)               := reason_for_update     ;
  p_lineage                varchar(256)                := lineage               ;
--
  p_schema_name varchar := schema_name;
  seq_name varchar;
  inserted_id integer;
BEGIN
-- IF the ID is not given, then generate a new one.
IF p_id IS NULL THEN
	seq_name=schema_name||'.cityobject_seq';
	p_id=nextval(seq_name::regclass);
END IF;
-- IF the GmlID is not given, then generate a new one.
IF p_gmlid IS NULL THEN
	p_gmlid='UUID_'||uuid_generate_v4();
END IF;
-- IF the creation_date is not given, then generate a new one.
IF p_creation_date IS NULL THEN
	p_creation_date=now()::timestamp(0) with time zone;
END IF;

EXECUTE format('INSERT INTO %I.cityobject (
 id,
 objectclass_id,
 gmlid,
 gmlid_codespace,
 name,
 name_codespace,
 description,
 envelope,
 creation_date,
 termination_date,
 relative_to_terrain,
 relative_to_water,
 last_modification_date,
 updating_person,
 reason_for_update,
 lineage
) VALUES (
%L, %L, %L, %L, %L, %L, %L, %L, %L, %L,
%L, %L, %L, %L, %L, %L
) RETURNING id',
 p_schema_name,		-- ADD schema_name,
 p_id,						-- ADD p_id
 p_objectclass_id,
 p_gmlid,
 p_gmlid_codespace,
 p_name,
 p_name_codespace,
 p_description,
 p_envelope,
 p_creation_date,
 p_termination_date,
 p_relative_to_terrain,
 p_relative_to_water,
 p_last_modification_date,
 p_updating_person,
 p_reason_for_update,
 p_lineage
) INTO inserted_id;
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.insert_cityobject (id: %): %', p_id, SQLERRM;
END;
$$
LANGUAGE 'plpgsql';

----------------------------------------------------------------
-- Function INSERT_CITYOBJECTGROUP
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_pkg.insert_cityobjectgroup(integer, character varying, character varying, character varying, character varying, character varying, character varying, integer, geometry, integer, character varying) CASCADE;
CREATE OR REPLACE FUNCTION citydb_pkg.insert_cityobjectgroup (
  id                   integer,
  class                varchar(256) DEFAULT NULL,
  class_codespace      varchar(4000) DEFAULT NULL,
  function             varchar(1000) DEFAULT NULL,
  function_codespace   varchar(4000) DEFAULT NULL,
  usage                varchar(1000) DEFAULT NULL,
  usage_codespace      varchar(4000) DEFAULT NULL,
  brep_id              integer DEFAULT NULL,
  other_geom           geometry DEFAULT NULL,
  parent_cityobject_id integer DEFAULT NULL,
  schema_name          varchar DEFAULT 'citydb'::varchar
)
RETURNS integer
AS
$$
DECLARE
  p_id                   integer         := id                  ;
  p_class                varchar(256)    := class               ;
  p_class_codespace      varchar(4000)   := class_codespace     ;
  p_function             varchar(1000)   := function            ;
  p_function_codespace   varchar(4000)   := function_codespace  ;
  p_usage                varchar(1000)   := usage               ;
  p_usage_codespace      varchar(4000)   := usage_codespace     ;
  p_brep_id              integer         := brep_id             ;
  p_other_geom           geometry        := other_geom          ;
  p_parent_cityobject_id integer         := parent_cityobject_id;
--
  p_schema_name varchar := schema_name;
  inserted_id integer;
BEGIN

EXECUTE format('INSERT INTO %I.cityobjectgroup (
 id,
 class,
 class_codespace,
 function,
 function_codespace,
 usage,
 usage_codespace,
 brep_id,
 other_geom,
 parent_cityobject_id
) VALUES (
%L, %L, %L, %L, %L, %L, %L, %L, %L, %L
) RETURNING id',
 p_schema_name,
 p_id,
 p_class,
 p_class_codespace,
 p_function,
 p_function_codespace,
 p_usage,
 p_usage_codespace,
 p_brep_id,
 p_other_geom,
 p_parent_cityobject_id
) INTO inserted_id;
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.insert_cityobjectgroup (id: %): %', p_id, SQLERRM;
END;
$$
LANGUAGE 'plpgsql';

----------------------------------------------------------------
-- Function INSERT_GROUP_TO_CITYOBJECT
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_pkg.insert_group_to_cityobject (integer, integer, varchar, varchar) CASCADE;
CREATE OR REPLACE FUNCTION citydb_pkg.insert_group_to_cityobject (
  cityobjectgroup_id   integer,
  cityobject_id        integer,
  role                 varchar DEFAULT NULL,
--
  schema_name          varchar DEFAULT 'citydb'::varchar
)
RETURNS void
AS $$
DECLARE
  p_cityobjectgroup_id integer := cityobjectgroup_id;
  p_cityobject_id      integer := cityobject_id;
  p_role               varchar := role;
--
  p_schema_name        varchar := schema_name;
BEGIN
EXECUTE format('INSERT INTO %I.group_to_cityobject (
 cityobjectgroup_id,
 cityobject_id,
 role
) VALUES (
%L, %L, %L
)',
 p_schema_name,
 p_cityobjectgroup_id,
 p_cityobject_id,
 p_role
);
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.insert_group_to_cityobject (cityobjectgroup_id: %, cityobject_id %): %', p_cityobjectgroup_id, p_cityobject_id, SQLERRM;
END;
$$
LANGUAGE 'plpgsql';

---------------------------------------------------------------
-- Function INSERT_BUILDING
---------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_pkg.insert_building(integer, integer, integer, character varying, character varying, character varying, character varying, character varying, character varying, date, date, character varying, character varying, double precision, character varying, numeric, numeric, character varying, character varying, character varying, character varying, geometry, geometry, geometry, geometry, geometry, geometry, geometry, integer, integer, integer, integer, integer, integer, integer, integer, integer, integer, character varying);
CREATE OR REPLACE FUNCTION citydb_pkg.insert_building (
  id integer,
  building_parent_id          integer DEFAULT NULL,
  building_root_id            integer DEFAULT NULL,
  class                       varchar(256) DEFAULT NULL,
  class_codespace             varchar(4000) DEFAULT NULL,
  function                    varchar(1000) DEFAULT NULL,
  function_codespace          varchar(4000) DEFAULT NULL,
  usage                       varchar(1000) DEFAULT NULL,
  usage_codespace             varchar(4000) DEFAULT NULL,
  year_of_construction        date DEFAULT NULL,
  year_of_demolition          date DEFAULT NULL,
  roof_type                   varchar(256) DEFAULT NULL,
  roof_type_codespace         varchar(4000) DEFAULT NULL,
  measured_height             double precision DEFAULT NULL,
  measured_height_unit        varchar(4000) DEFAULT NULL,
  storeys_above_ground        numeric(8) DEFAULT NULL,
  storeys_below_ground        numeric(8) DEFAULT NULL,
  storey_heights_above_ground varchar(4000) DEFAULT NULL,
  storey_heights_ag_unit      varchar(4000) DEFAULT NULL,
  storey_heights_below_ground varchar(4000) DEFAULT NULL,
  storey_heights_bg_unit      varchar(4000) DEFAULT NULL,
  lod1_terrain_intersection   geometry DEFAULT NULL,
  lod2_terrain_intersection   geometry DEFAULT NULL,
  lod3_terrain_intersection   geometry DEFAULT NULL,
  lod4_terrain_intersection   geometry DEFAULT NULL,
  lod2_multi_curve            geometry DEFAULT NULL,
  lod3_multi_curve            geometry DEFAULT NULL,
  lod4_multi_curve            geometry DEFAULT NULL,
  lod0_footprint_id           integer DEFAULT NULL,
  lod0_roofprint_id           integer DEFAULT NULL,
  lod1_multi_surface_id       integer DEFAULT NULL,
  lod2_multi_surface_id       integer DEFAULT NULL,
  lod3_multi_surface_id       integer DEFAULT NULL,
  lod4_multi_surface_id       integer DEFAULT NULL,
  lod1_solid_id               integer DEFAULT NULL,
  lod2_solid_id               integer DEFAULT NULL,
  lod3_solid_id               integer DEFAULT NULL,
  lod4_solid_id               integer DEFAULT NULL,
  schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer
AS
$$
DECLARE
  p_id                          integer          := id                         ;
  p_building_parent_id          integer          := building_parent_id         ;
  p_building_root_id            integer          := building_root_id           ;
  p_class                       varchar(256)     := class                      ;
  p_class_codespace             varchar(4000)    := class_codespace            ;
  p_function                    varchar(1000)    := function                   ;
  p_function_codespace          varchar(4000)    := function_codespace         ;
  p_usage                       varchar(1000)    := usage                      ;
  p_usage_codespace             varchar(4000)    := usage_codespace            ;
  p_year_of_construction        date             := year_of_construction       ;
  p_year_of_demolition          date             := year_of_demolition         ;
  p_roof_type                   varchar(256)     := roof_type                  ;
  p_roof_type_codespace         varchar(4000)    := roof_type_codespace        ;
  p_measured_height             double precision := measured_height            ;
  p_measured_height_unit        varchar(4000)    := measured_height_unit       ;
  p_storeys_above_ground        numeric(8)       := storeys_above_ground       ;
  p_storeys_below_ground        numeric(8)       := storeys_below_ground       ;
  p_storey_heights_above_ground varchar(4000)    := storey_heights_above_ground;
  p_storey_heights_ag_unit      varchar(4000)    := storey_heights_ag_unit     ;
  p_storey_heights_below_ground varchar(4000)    := storey_heights_below_ground;
  p_storey_heights_bg_unit      varchar(4000)    := storey_heights_bg_unit     ;
  p_lod1_terrain_intersection   geometry         := lod1_terrain_intersection  ;
  p_lod2_terrain_intersection   geometry         := lod2_terrain_intersection  ;
  p_lod3_terrain_intersection   geometry         := lod3_terrain_intersection  ;
  p_lod4_terrain_intersection   geometry         := lod4_terrain_intersection  ;
  p_lod2_multi_curve            geometry         := lod2_multi_curve           ;
  p_lod3_multi_curve            geometry         := lod3_multi_curve           ;
  p_lod4_multi_curve            geometry         := lod4_multi_curve           ;
  p_lod0_footprint_id           integer          := lod0_footprint_id          ;
  p_lod0_roofprint_id           integer          := lod0_roofprint_id          ;
  p_lod1_multi_surface_id       integer          := lod1_multi_surface_id      ;
  p_lod2_multi_surface_id       integer          := lod2_multi_surface_id      ;
  p_lod3_multi_surface_id       integer          := lod3_multi_surface_id      ;
  p_lod4_multi_surface_id       integer          := lod4_multi_surface_id      ;
  p_lod1_solid_id               integer          := lod1_solid_id              ;
  p_lod2_solid_id               integer          := lod2_solid_id              ;
  p_lod3_solid_id               integer          := lod3_solid_id              ;
  p_lod4_solid_id               integer          := lod4_solid_id              ;
--
  p_schema_name varchar := schema_name;
  inserted_id integer;
BEGIN

EXECUTE format('INSERT INTO %I.building (
 id,
 building_parent_id,
 building_root_id,
 class,
 class_codespace,
 function,
 function_codespace,
 usage,
 usage_codespace,
 year_of_construction,
 year_of_demolition,
 roof_type,
 roof_type_codespace,
 measured_height,
 measured_height_unit,
 storeys_above_ground,
 storeys_below_ground,
 storey_heights_above_ground,
 storey_heights_ag_unit,
 storey_heights_below_ground,
 storey_heights_bg_unit,
 lod1_terrain_intersection,
 lod2_terrain_intersection,
 lod3_terrain_intersection,
 lod4_terrain_intersection,
 lod2_multi_curve,
 lod3_multi_curve,
 lod4_multi_curve,
 lod0_footprint_id,
 lod0_roofprint_id,
 lod1_multi_surface_id,
 lod2_multi_surface_id,
 lod3_multi_surface_id,
 lod4_multi_surface_id,
 lod1_solid_id,
 lod2_solid_id,
 lod3_solid_id,
 lod4_solid_id
) VALUES (
%L, %L, %L, %L, %L, %L, %L, %L, %L, %L,
%L, %L, %L, %L, %L, %L, %L, %L, %L, %L,
%L, %L, %L, %L, %L, %L, %L, %L, %L, %L,
%L, %L, %L, %L, %L, %L, %L, %L
) RETURNING id',
 p_schema_name,
 p_id,
 p_building_parent_id,
 p_building_root_id,
 p_class,
 p_class_codespace,
 p_function,
 p_function_codespace,
 p_usage,
 p_usage_codespace,
 p_year_of_construction,
 p_year_of_demolition,
 p_roof_type,
 p_roof_type_codespace,
 p_measured_height,
 p_measured_height_unit,
 p_storeys_above_ground,
 p_storeys_below_ground,
 p_storey_heights_above_ground,
 p_storey_heights_ag_unit,
 p_storey_heights_below_ground,
 p_storey_heights_bg_unit,
 p_lod1_terrain_intersection,
 p_lod2_terrain_intersection,
 p_lod3_terrain_intersection,
 p_lod4_terrain_intersection,
 p_lod2_multi_curve,
 p_lod3_multi_curve,
 p_lod4_multi_curve,
 p_lod0_footprint_id,
 p_lod0_roofprint_id,
 p_lod1_multi_surface_id,
 p_lod2_multi_surface_id,
 p_lod3_multi_surface_id,
 p_lod4_multi_surface_id,
 p_lod1_solid_id,
 p_lod2_solid_id,
 p_lod3_solid_id,
 p_lod4_solid_id
) INTO inserted_id;
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.insert_building (id: %): %', p_id, SQLERRM;
END;
$$
LANGUAGE 'plpgsql';

----------------------------------------------------------------
-- Function INSERT_ADDRESS
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_pkg.insert_address (integer, varchar, varchar, varchar, varchar, varchar, varchar, varchar, varchar, varchar, geometry, text, varchar) CASCADE;
CREATE OR REPLACE FUNCTION citydb_pkg.insert_address (
  id              integer  DEFAULT NULL,
  gmlid           varchar  DEFAULT NULL,
  gmlid_codespace varchar  DEFAULT NULL,
  street          varchar  DEFAULT NULL,
  house_number    varchar  DEFAULT NULL,
  po_box          varchar  DEFAULT NULL,
  zip_code        varchar  DEFAULT NULL,
  city            varchar  DEFAULT NULL,
  state           varchar  DEFAULT NULL,
  country         varchar  DEFAULT NULL,
  multi_point     geometry DEFAULT NULL,
  xal_source      text     DEFAULT NULL,
--
  schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer
AS
$$
DECLARE
  p_id              integer  := id;
  p_gmlid           varchar  := gmlid;
  p_gmlid_codespace varchar  := gmlid_codespace;
  p_street          varchar  := street;
  p_house_number    varchar  := house_number;
  p_po_box          varchar  := po_box;
  p_zip_code        varchar  := zip_code;
  p_city            varchar  := city;
  p_state           varchar  := state;
  p_country         varchar  := country;
  p_multi_point     geometry := multi_point;
  p_xal_source      text     := xal_source;
--
  p_schema_name     varchar  := schema_name;
  seq_name                       varchar;
  inserted_id                    integer;
BEGIN
-- IF the ID is not given, then generate a new one.
IF p_id IS NULL THEN
  seq_name=schema_name||'.address_seq';
  p_id=nextval(seq_name::regclass);
END IF;
-- IF the GmlID is not given, then generate a new one.
IF p_gmlid IS NULL THEN
  p_gmlid='UUID_'||uuid_generate_v4();
END IF;

EXECUTE format('
INSERT INTO %I.address (
 id,
 gmlid,
 gmlid_codespace,
 street,
 house_number,
 po_box,
 zip_code,
 city,
 state,
 country,
 multi_point,
 xal_source
) VALUES (
%L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L
) RETURNING id',
p_schema_name,
p_id,
p_gmlid,
p_gmlid_codespace,
p_street,
p_house_number,
p_po_box,
p_zip_code,
p_city,
p_state,
p_country,
p_multi_point,
p_xal_source
) INTO inserted_id;
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.insert_address (id: %): %', p_id, SQLERRM;
END;
$$
LANGUAGE 'plpgsql';

----------------------------------------------------------------
-- Function INSERT_ADDRESS_TO_BRIDGE
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_pkg.insert_address_to_bridge (integer, integer, varchar) CASCADE;
CREATE OR REPLACE FUNCTION citydb_pkg.insert_address_to_bridge (
  bridge_id  integer,
  address_id integer,
--
  schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS void
AS
$$
DECLARE
  p_bridge_id   integer := bridge_id;
  p_address_id  integer := address_id;
--
  p_schema_name varchar := schema_name;
BEGIN
EXECUTE format('
INSERT INTO %I.address_to_bridge (
 bridge_id,
 address_id
) VALUES (
%L, %L
)',
p_schema_name,
p_bridge_id,
p_address_id
);
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.insert_address_to_bridge (address_id: %, bridge_id %): %', p_address_id, p_building_id, SQLERRM;
END;
$$
LANGUAGE 'plpgsql';

----------------------------------------------------------------
-- Function INSERT_ADDRESS_TO_BUILDING
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_pkg.insert_address_to_building (integer, integer, varchar) CASCADE;
CREATE OR REPLACE FUNCTION citydb_pkg.insert_address_to_building (
  building_id integer,
  address_id  integer,
--
  schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS void
AS
$$
DECLARE
  p_building_id integer := building_id;
  p_address_id  integer := address_id;
--
  p_schema_name varchar := schema_name;
BEGIN

EXECUTE format('
INSERT INTO %I.address_to_building (
 building_id,
 address_id
) VALUES (
%L, %L
)',
p_schema_name,
p_building_id,
p_address_id
);
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.insert_address_to_building (address_id: %, building_id %): %', p_address_id, p_building_id, SQLERRM;
END;
$$
LANGUAGE 'plpgsql';

----------------------------------------------------------------
-- Function INSERT_APPEAR_TO_SURFACE_DATA
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_pkg.insert_appear_to_surface_data (integer, integer, varchar) CASCADE;
CREATE OR REPLACE FUNCTION citydb_pkg.insert_appear_to_surface_data (
  surface_data_id                integer,
  appearance_id                  integer,
--
  schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS void
AS
$$
DECLARE
  p_surface_data_id integer := surface_data_id;
  p_appearance_id   integer := appearance_id;
--
  p_schema_name varchar := schema_name;
BEGIN

EXECUTE format('
INSERT INTO %I.appear_to_surface_data (
 surface_data_id,
 appearance_id
) VALUES (
%L, %L
)',
p_schema_name,
p_surface_data_id,
p_appearance_id
);
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.insert_appear_to_surface_data (appearance_id: %, surface_data_id %): %', p_appearance_id, p_surface_data_id, SQLERRM;
END;
$$
LANGUAGE 'plpgsql';

----------------------------------------------------------------
-- Function INSERT_APPEARANCE
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_pkg.insert_appearance (integer, varchar, varchar, varchar, varchar, varchar, varchar, integer, integer, varchar) CASCADE;
CREATE OR REPLACE FUNCTION citydb_pkg.insert_appearance (
  id              integer DEFAULT NULL,
  gmlid           varchar DEFAULT NULL,
  gmlid_codespace varchar DEFAULT NULL,
  name            varchar DEFAULT NULL,
  name_codespace  varchar DEFAULT NULL,
  description     varchar DEFAULT NULL,
  theme           varchar DEFAULT NULL,
  citymodel_id    integer DEFAULT NULL,
  cityobject_id   integer DEFAULT NULL,
--
  schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer
AS
$$
DECLARE
  p_id              integer := id;
  p_gmlid           varchar := gmlid;
  p_gmlid_codespace varchar := gmlid_codespace;
  p_name            varchar := name;
  p_name_codespace  varchar := name_codespace;
  p_description     varchar := description;
  p_theme           varchar := theme;
  p_citymodel_id    integer := citymodel_id;
  p_cityobject_id   integer := cityobject_id;
--
  p_schema_name varchar := schema_name;
  seq_name                       varchar;
  inserted_id                    integer;
BEGIN
-- IF the ID is not given, then generate a new one.
IF p_id IS NULL THEN
  seq_name=schema_name||'.appearance_seq';
  p_id=nextval(seq_name::regclass);
END IF;

-- IF the GmlID is not given, then generate a new one.
IF p_gmlid IS NULL THEN
  p_gmlid='UUID_'||uuid_generate_v4();
END IF;

EXECUTE format('
INSERT INTO %I.appearance (
 id,
 gmlid,
 gmlid_codespace,
 name,
 name_codespace,
 description,
 theme,
 citymodel_id,
 cityobject_id
) VALUES (
%L, %L, %L, %L, %L, %L, %L, %L, %L
) RETURNING id',
p_schema_name,
p_id,
p_gmlid,
p_gmlid_codespace,
p_name,
p_name_codespace,
p_description,
p_theme,
p_citymodel_id,
p_cityobject_id
) INTO inserted_id;
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.insert_appearance (id: %): %', p_id, SQLERRM;
END;
$$
LANGUAGE 'plpgsql';

----------------------------------------------------------------
-- Function INSERT_BREAKLINE_RELIEF
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_pkg.insert_breakline_relief (integer, geometry, geometry, varchar) CASCADE;
CREATE OR REPLACE FUNCTION citydb_pkg.insert_breakline_relief (
  id                    integer,
  ridge_or_valley_lines geometry DEFAULT NULL,
  break_lines           geometry DEFAULT NULL,
--
  schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer
AS
$$
DECLARE
  p_id                    integer  := id;
  p_ridge_or_valley_lines geometry := ridge_or_valley_lines;
  p_break_lines           geometry := break_lines;
--
  p_schema_name varchar := schema_name;
  inserted_id                    integer;
BEGIN

EXECUTE format('
INSERT INTO %I.breakline_relief (
 id,
 ridge_or_valley_lines,
 break_lines
) VALUES (
%L, %L, %L
) RETURNING id',
p_schema_name,
p_id,
p_ridge_or_valley_lines,
p_break_lines
) INTO inserted_id;
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.insert_breakline_relief (id: %): %', p_id, SQLERRM;
END;
$$
LANGUAGE 'plpgsql';

----------------------------------------------------------------
-- Function INSERT_BRIDGE
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_pkg.insert_bridge (integer, integer, integer, varchar, varchar, varchar, varchar, varchar, varchar, date, date, numeric, geometry, geometry, geometry, geometry, geometry, geometry, geometry, integer, integer, integer, integer, integer, integer, integer, integer, varchar) CASCADE;
CREATE OR REPLACE FUNCTION citydb_pkg.insert_bridge (
  id                        integer,
  bridge_parent_id          integer DEFAULT NULL,
  bridge_root_id            integer DEFAULT NULL,
  class                     varchar DEFAULT NULL,
  class_codespace           varchar DEFAULT NULL,
  function                  varchar DEFAULT NULL,
  function_codespace        varchar DEFAULT NULL,
  usage                     varchar DEFAULT NULL,
  usage_codespace           varchar DEFAULT NULL,
  year_of_construction      date DEFAULT NULL,
  year_of_demolition        date DEFAULT NULL,
  is_movable                numeric DEFAULT NULL,
  lod1_terrain_intersection geometry DEFAULT NULL,
  lod2_terrain_intersection geometry DEFAULT NULL,
  lod3_terrain_intersection geometry DEFAULT NULL,
  lod4_terrain_intersection geometry DEFAULT NULL,
  lod2_multi_curve          geometry DEFAULT NULL,
  lod3_multi_curve          geometry DEFAULT NULL,
  lod4_multi_curve          geometry DEFAULT NULL,
  lod1_multi_surface_id     integer DEFAULT NULL,
  lod2_multi_surface_id     integer DEFAULT NULL,
  lod3_multi_surface_id     integer DEFAULT NULL,
  lod4_multi_surface_id     integer DEFAULT NULL,
  lod1_solid_id             integer DEFAULT NULL,
  lod2_solid_id             integer DEFAULT NULL,
  lod3_solid_id             integer DEFAULT NULL,
  lod4_solid_id             integer DEFAULT NULL,
--
  schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer
AS
$$
DECLARE
  p_id                        integer := id;
  p_bridge_parent_id          integer := bridge_parent_id;
  p_bridge_root_id            integer := bridge_root_id;
  p_class                     varchar := class;
  p_class_codespace           varchar := class_codespace;
  p_function                  varchar := function;
  p_function_codespace        varchar := function_codespace;
  p_usage                     varchar := usage;
  p_usage_codespace           varchar := usage_codespace;
  p_year_of_construction      date    := year_of_construction;
  p_year_of_demolition        date    := year_of_demolition;
  p_is_movable                numeric := is_movable;
  p_lod1_terrain_intersection geometry:= lod1_terrain_intersection;
  p_lod2_terrain_intersection geometry:= lod2_terrain_intersection;
  p_lod3_terrain_intersection geometry:= lod3_terrain_intersection;
  p_lod4_terrain_intersection geometry:= lod4_terrain_intersection;
  p_lod2_multi_curve          geometry:= lod2_multi_curve;
  p_lod3_multi_curve          geometry:= lod3_multi_curve;
  p_lod4_multi_curve          geometry:= lod4_multi_curve;
  p_lod1_multi_surface_id     integer := lod1_multi_surface_id;
  p_lod2_multi_surface_id     integer := lod2_multi_surface_id;
  p_lod3_multi_surface_id     integer := lod3_multi_surface_id;
  p_lod4_multi_surface_id     integer := lod4_multi_surface_id;
  p_lod1_solid_id             integer := lod1_solid_id;
  p_lod2_solid_id             integer := lod2_solid_id;
  p_lod3_solid_id             integer := lod3_solid_id;
  p_lod4_solid_id             integer := lod4_solid_id;
--
  p_schema_name varchar := schema_name;
  inserted_id                    integer;
BEGIN

EXECUTE format('
INSERT INTO %I.bridge (
 id,
 bridge_parent_id,
 bridge_root_id,
 class,
 class_codespace,
 function,
 function_codespace,
 usage,
 usage_codespace,
 year_of_construction,
 year_of_demolition,
 is_movable,
 lod1_terrain_intersection,
 lod2_terrain_intersection,
 lod3_terrain_intersection,
 lod4_terrain_intersection,
 lod2_multi_curve,
 lod3_multi_curve,
 lod4_multi_curve,
 lod1_multi_surface_id,
 lod2_multi_surface_id,
 lod3_multi_surface_id,
 lod4_multi_surface_id,
 lod1_solid_id,
 lod2_solid_id,
 lod3_solid_id,
 lod4_solid_id
) VALUES (
%L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L
) RETURNING id',
p_schema_name,
p_id,
p_bridge_parent_id,
p_bridge_root_id,
p_class,
p_class_codespace,
p_function,
p_function_codespace,
p_usage,
p_usage_codespace,
p_year_of_construction,
p_year_of_demolition,
p_is_movable,
p_lod1_terrain_intersection,
p_lod2_terrain_intersection,
p_lod3_terrain_intersection,
p_lod4_terrain_intersection,
p_lod2_multi_curve,
p_lod3_multi_curve,
p_lod4_multi_curve,
p_lod1_multi_surface_id,
p_lod2_multi_surface_id,
p_lod3_multi_surface_id,
p_lod4_multi_surface_id,
p_lod1_solid_id,
p_lod2_solid_id,
p_lod3_solid_id,
p_lod4_solid_id
) INTO inserted_id;
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.insert_bridge (id: %): %', p_id, SQLERRM;
END;
$$
LANGUAGE 'plpgsql';

----------------------------------------------------------------
-- Function INSERT_BRIDGE_CONSTR_ELEMENT
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_pkg.insert_bridge_constr_element (integer, varchar, varchar, varchar, varchar, varchar, varchar, integer, geometry, geometry, geometry, geometry, integer, integer, integer, integer, geometry, geometry, geometry, geometry, integer, integer, integer, integer, geometry, geometry, geometry, geometry, varchar, varchar, varchar, varchar, varchar) CASCADE;
CREATE OR REPLACE FUNCTION citydb_pkg.insert_bridge_constr_element (
  id                             integer,
  class                          varchar  DEFAULT NULL,
  class_codespace                varchar  DEFAULT NULL,
  function                       varchar  DEFAULT NULL,
  function_codespace             varchar  DEFAULT NULL,
  usage                          varchar  DEFAULT NULL,
  usage_codespace                varchar  DEFAULT NULL,
  bridge_id                      integer  DEFAULT NULL,
  lod1_terrain_intersection      geometry DEFAULT NULL,
  lod2_terrain_intersection      geometry DEFAULT NULL,
  lod3_terrain_intersection      geometry DEFAULT NULL,
  lod4_terrain_intersection      geometry DEFAULT NULL,
  lod1_brep_id                   integer  DEFAULT NULL,
  lod2_brep_id                   integer  DEFAULT NULL,
  lod3_brep_id                   integer  DEFAULT NULL,
  lod4_brep_id                   integer  DEFAULT NULL,
  lod1_other_geom                geometry DEFAULT NULL,
  lod2_other_geom                geometry DEFAULT NULL,
  lod3_other_geom                geometry DEFAULT NULL,
  lod4_other_geom                geometry DEFAULT NULL,
  lod1_implicit_rep_id           integer  DEFAULT NULL,
  lod2_implicit_rep_id           integer  DEFAULT NULL,
  lod3_implicit_rep_id           integer  DEFAULT NULL,
  lod4_implicit_rep_id           integer  DEFAULT NULL,
  lod1_implicit_ref_point        geometry DEFAULT NULL,
  lod2_implicit_ref_point        geometry DEFAULT NULL,
  lod3_implicit_ref_point        geometry DEFAULT NULL,
  lod4_implicit_ref_point        geometry DEFAULT NULL,
  lod1_implicit_transformation   varchar  DEFAULT NULL,
  lod2_implicit_transformation   varchar  DEFAULT NULL,
  lod3_implicit_transformation   varchar  DEFAULT NULL,
  lod4_implicit_transformation   varchar  DEFAULT NULL,
--
  schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer
AS
$$
DECLARE
  p_id                           integer  := id;
  p_class                        varchar  := class;
  p_class_codespace              varchar  := class_codespace;
  p_function                     varchar  := function;
  p_function_codespace           varchar  := function_codespace;
  p_usage                        varchar  := usage;
  p_usage_codespace              varchar  := usage_codespace;
  p_bridge_id                    integer  := bridge_id;
  p_lod1_terrain_intersection    geometry := lod1_terrain_intersection;
  p_lod2_terrain_intersection    geometry := lod2_terrain_intersection;
  p_lod3_terrain_intersection    geometry := lod3_terrain_intersection;
  p_lod4_terrain_intersection    geometry := lod4_terrain_intersection;
  p_lod1_brep_id                 integer  := lod1_brep_id;
  p_lod2_brep_id                 integer  := lod2_brep_id;
  p_lod3_brep_id                 integer  := lod3_brep_id;
  p_lod4_brep_id                 integer  := lod4_brep_id;
  p_lod1_other_geom              geometry := lod1_other_geom;
  p_lod2_other_geom              geometry := lod2_other_geom;
  p_lod3_other_geom              geometry := lod3_other_geom;
  p_lod4_other_geom              geometry := lod4_other_geom;
  p_lod1_implicit_rep_id         integer  := lod1_implicit_rep_id;
  p_lod2_implicit_rep_id         integer  := lod2_implicit_rep_id;
  p_lod3_implicit_rep_id         integer  := lod3_implicit_rep_id;
  p_lod4_implicit_rep_id         integer  := lod4_implicit_rep_id;
  p_lod1_implicit_ref_point      geometry := lod1_implicit_ref_point;
  p_lod2_implicit_ref_point      geometry := lod2_implicit_ref_point;
  p_lod3_implicit_ref_point      geometry := lod3_implicit_ref_point;
  p_lod4_implicit_ref_point      geometry := lod4_implicit_ref_point;
  p_lod1_implicit_transformation varchar  := lod1_implicit_transformation;
  p_lod2_implicit_transformation varchar  := lod2_implicit_transformation;
  p_lod3_implicit_transformation varchar  := lod3_implicit_transformation;
  p_lod4_implicit_transformation varchar  := lod4_implicit_transformation;
--
  p_schema_name varchar := schema_name;
  inserted_id                    integer;
BEGIN

EXECUTE format('
INSERT INTO %I.bridge_constr_element (
 id,
 class,
 class_codespace,
 function,
 function_codespace,
 usage,
 usage_codespace,
 bridge_id,
 lod1_terrain_intersection,
 lod2_terrain_intersection,
 lod3_terrain_intersection,
 lod4_terrain_intersection,
 lod1_brep_id,
 lod2_brep_id,
 lod3_brep_id,
 lod4_brep_id,
 lod1_other_geom,
 lod2_other_geom,
 lod3_other_geom,
 lod4_other_geom,
 lod1_implicit_rep_id,
 lod2_implicit_rep_id,
 lod3_implicit_rep_id,
 lod4_implicit_rep_id,
 lod1_implicit_ref_point,
 lod2_implicit_ref_point,
 lod3_implicit_ref_point,
 lod4_implicit_ref_point,
 lod1_implicit_transformation,
 lod2_implicit_transformation,
 lod3_implicit_transformation,
 lod4_implicit_transformation
) VALUES (
%L, %L, %L, %L, %L, %L, %L, %L, %L, %L,
%L, %L, %L, %L, %L, %L, %L, %L, %L, %L,
%L, %L, %L, %L, %L, %L, %L, %L, %L, %L,
%L, %L
) RETURNING id',
p_schema_name,
p_id,
p_class,
p_class_codespace,
p_function,
p_function_codespace,
p_usage,
p_usage_codespace,
p_bridge_id,
p_lod1_terrain_intersection,
p_lod2_terrain_intersection,
p_lod3_terrain_intersection,
p_lod4_terrain_intersection,
p_lod1_brep_id,
p_lod2_brep_id,
p_lod3_brep_id,
p_lod4_brep_id,
p_lod1_other_geom,
p_lod2_other_geom,
p_lod3_other_geom,
p_lod4_other_geom,
p_lod1_implicit_rep_id,
p_lod2_implicit_rep_id,
p_lod3_implicit_rep_id,
p_lod4_implicit_rep_id,
p_lod1_implicit_ref_point,
p_lod2_implicit_ref_point,
p_lod3_implicit_ref_point,
p_lod4_implicit_ref_point,
p_lod1_implicit_transformation,
p_lod2_implicit_transformation,
p_lod3_implicit_transformation,
p_lod4_implicit_transformation
) INTO inserted_id;
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.insert_bridge_constr_element (id: %): %', p_id, SQLERRM;
END;
$$
LANGUAGE 'plpgsql';

----------------------------------------------------------------
-- Function INSERT_BRIDGE_FURNITURE
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_pkg.insert_bridge_furniture (integer, varchar, varchar, varchar, varchar, varchar, varchar, integer, integer, geometry, integer, geometry, varchar, varchar) CASCADE;
CREATE OR REPLACE FUNCTION citydb_pkg.insert_bridge_furniture (
  id                             integer,
  class                          varchar DEFAULT NULL,
  class_codespace                varchar DEFAULT NULL,
  function                       varchar DEFAULT NULL,
  function_codespace             varchar DEFAULT NULL,
  usage                          varchar DEFAULT NULL,
  usage_codespace                varchar DEFAULT NULL,
  bridge_room_id                 integer DEFAULT NULL,
  lod4_brep_id                   integer DEFAULT NULL,
  lod4_other_geom                geometry DEFAULT NULL,
  lod4_implicit_rep_id           integer DEFAULT NULL,
  lod4_implicit_ref_point        geometry DEFAULT NULL,
  lod4_implicit_transformation   varchar DEFAULT NULL,
--
  schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer
AS
$$
DECLARE
  p_id                           integer  := id;
  p_class                        varchar  := class;
  p_class_codespace              varchar  := class_codespace;
  p_function                     varchar  := function;
  p_function_codespace           varchar  := function_codespace;
  p_usage                        varchar  := usage;
  p_usage_codespace              varchar  := usage_codespace;
  p_bridge_room_id               integer  := bridge_room_id;
  p_lod4_brep_id                 integer  := lod4_brep_id;
  p_lod4_other_geom              geometry := lod4_other_geom;
  p_lod4_implicit_rep_id         integer  := lod4_implicit_rep_id;
  p_lod4_implicit_ref_point      geometry := lod4_implicit_ref_point;
  p_lod4_implicit_transformation varchar  := lod4_implicit_transformation;
--
  p_schema_name varchar := schema_name;
  inserted_id                    integer;
BEGIN

EXECUTE format('
INSERT INTO %I.bridge_furniture (
 id,
 class,
 class_codespace,
 function,
 function_codespace,
 usage,
 usage_codespace,
 bridge_room_id,
 lod4_brep_id,
 lod4_other_geom,
 lod4_implicit_rep_id,
 lod4_implicit_ref_point,
 lod4_implicit_transformation
) VALUES (
%L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L
) RETURNING id',
p_schema_name,
p_id,
p_class,
p_class_codespace,
p_function,
p_function_codespace,
p_usage,
p_usage_codespace,
p_bridge_room_id,
p_lod4_brep_id,
p_lod4_other_geom,
p_lod4_implicit_rep_id,
p_lod4_implicit_ref_point,
p_lod4_implicit_transformation
) INTO inserted_id;
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.insert_bridge_furniture (id: %): %', p_id, SQLERRM;
END;
$$
LANGUAGE 'plpgsql';

----------------------------------------------------------------
-- Function INSERT_BRIDGE_INSTALLATION
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_pkg.insert_bridge_installation (integer, integer, varchar, varchar, varchar, varchar, varchar, varchar, integer, integer, integer, integer, integer, geometry, geometry, geometry, integer, integer, integer, geometry, geometry, geometry, varchar, varchar, varchar, varchar) CASCADE;
CREATE OR REPLACE FUNCTION citydb_pkg.insert_bridge_installation (
  objectclass_id                 integer,
  id                             integer,
  class                          varchar DEFAULT NULL,
  class_codespace                varchar DEFAULT NULL,
  function                       varchar DEFAULT NULL,
  function_codespace             varchar DEFAULT NULL,
  usage                          varchar DEFAULT NULL,
  usage_codespace                varchar DEFAULT NULL,
  bridge_id                      integer DEFAULT NULL,
  bridge_room_id                 integer DEFAULT NULL,
  lod2_brep_id                   integer DEFAULT NULL,
  lod3_brep_id                   integer DEFAULT NULL,
  lod4_brep_id                   integer DEFAULT NULL,
  lod2_other_geom                geometry DEFAULT NULL,
  lod3_other_geom                geometry DEFAULT NULL,
  lod4_other_geom                geometry DEFAULT NULL,
  lod2_implicit_rep_id           integer DEFAULT NULL,
  lod3_implicit_rep_id           integer DEFAULT NULL,
  lod4_implicit_rep_id           integer DEFAULT NULL,
  lod2_implicit_ref_point        geometry DEFAULT NULL,
  lod3_implicit_ref_point        geometry DEFAULT NULL,
  lod4_implicit_ref_point        geometry DEFAULT NULL,
  lod2_implicit_transformation   varchar DEFAULT NULL,
  lod3_implicit_transformation   varchar DEFAULT NULL,
  lod4_implicit_transformation   varchar DEFAULT NULL,
--
  schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer
AS
$$
DECLARE
  p_id                           integer  := id;
  p_objectclass_id               integer  := objectclass_id;
  p_class                        varchar  := class;
  p_class_codespace              varchar  := class_codespace;
  p_function                     varchar  := function;
  p_function_codespace           varchar  := function_codespace;
  p_usage                        varchar  := usage;
  p_usage_codespace              varchar  := usage_codespace;
  p_bridge_id                    integer  := bridge_id;
  p_bridge_room_id               integer  := bridge_room_id;
  p_lod2_brep_id                 integer  := lod2_brep_id;
  p_lod3_brep_id                 integer  := lod3_brep_id;
  p_lod4_brep_id                 integer  := lod4_brep_id;
  p_lod2_other_geom              geometry := lod2_other_geom;
  p_lod3_other_geom              geometry := lod3_other_geom;
  p_lod4_other_geom              geometry := lod4_other_geom;
  p_lod2_implicit_rep_id         integer  := lod2_implicit_rep_id;
  p_lod3_implicit_rep_id         integer  := lod3_implicit_rep_id;
  p_lod4_implicit_rep_id         integer  := lod4_implicit_rep_id;
  p_lod2_implicit_ref_point      geometry := lod2_implicit_ref_point;
  p_lod3_implicit_ref_point      geometry := lod3_implicit_ref_point;
  p_lod4_implicit_ref_point      geometry := lod4_implicit_ref_point;
  p_lod2_implicit_transformation varchar  := lod2_implicit_transformation;
  p_lod3_implicit_transformation varchar  := lod3_implicit_transformation;
  p_lod4_implicit_transformation varchar  := lod4_implicit_transformation;
--
  p_schema_name varchar := schema_name;
  inserted_id                    integer;
BEGIN

EXECUTE format('
INSERT INTO %I.bridge_installation (
 id,
 objectclass_id,
 class,
 class_codespace,
 function,
 function_codespace,
 usage,
 usage_codespace,
 bridge_id,
 bridge_room_id,
 lod2_brep_id,
 lod3_brep_id,
 lod4_brep_id,
 lod2_other_geom,
 lod3_other_geom,
 lod4_other_geom,
 lod2_implicit_rep_id,
 lod3_implicit_rep_id,
 lod4_implicit_rep_id,
 lod2_implicit_ref_point,
 lod3_implicit_ref_point,
 lod4_implicit_ref_point,
 lod2_implicit_transformation,
 lod3_implicit_transformation,
 lod4_implicit_transformation
) VALUES (
%L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L
) RETURNING id',
p_schema_name,
p_id,
p_objectclass_id,
p_class,
p_class_codespace,
p_function,
p_function_codespace,
p_usage,
p_usage_codespace,
p_bridge_id,
p_bridge_room_id,
p_lod2_brep_id,
p_lod3_brep_id,
p_lod4_brep_id,
p_lod2_other_geom,
p_lod3_other_geom,
p_lod4_other_geom,
p_lod2_implicit_rep_id,
p_lod3_implicit_rep_id,
p_lod4_implicit_rep_id,
p_lod2_implicit_ref_point,
p_lod3_implicit_ref_point,
p_lod4_implicit_ref_point,
p_lod2_implicit_transformation,
p_lod3_implicit_transformation,
p_lod4_implicit_transformation
) INTO inserted_id;
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.insert_bridge_installation (id: %): %', p_id, SQLERRM;
END;
$$
LANGUAGE 'plpgsql';

----------------------------------------------------------------
-- Function INSERT_BRIDGE_OPEN_TO_THEM_SRF
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_pkg.insert_bridge_open_to_them_srf (integer, integer, varchar) CASCADE;
CREATE OR REPLACE FUNCTION citydb_pkg.insert_bridge_open_to_them_srf (
  bridge_opening_id              integer,
  bridge_thematic_surface_id     integer,
--
  schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS void
AS
$$
DECLARE
  p_bridge_opening_id            integer := bridge_opening_id;
  p_bridge_thematic_surface_id   integer := bridge_thematic_surface_id;
--
  p_schema_name varchar := schema_name;
BEGIN

EXECUTE format('
INSERT INTO %I.bridge_open_to_them_srf (
 bridge_opening_id,
 bridge_thematic_surface_id
) VALUES (
%L, %L
)',
p_schema_name,
p_bridge_opening_id,
p_bridge_thematic_surface_id
);
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.insert_bridge_open_to_them_srf (bridge_opening_id: %, bridge_thematic_surface_id: %): %', p_bridge_opening_id, p_bridge_thematic_surface_id, SQLERRM;
END;
$$
LANGUAGE 'plpgsql';

----------------------------------------------------------------
-- Function INSERT_BRIDGE_OPENING
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_pkg.insert_bridge_opening (integer, integer, integer, integer, integer, integer, integer, geometry, geometry, varchar, varchar, varchar) CASCADE;
CREATE OR REPLACE FUNCTION citydb_pkg.insert_bridge_opening (
  objectclass_id                 integer,
  id                             integer,
  address_id                     integer DEFAULT NULL,
  lod3_multi_surface_id          integer DEFAULT NULL,
  lod4_multi_surface_id          integer DEFAULT NULL,
  lod3_implicit_rep_id           integer DEFAULT NULL,
  lod4_implicit_rep_id           integer DEFAULT NULL,
  lod3_implicit_ref_point        geometry DEFAULT NULL,
  lod4_implicit_ref_point        geometry DEFAULT NULL,
  lod3_implicit_transformation   varchar DEFAULT NULL,
  lod4_implicit_transformation   varchar DEFAULT NULL,
--
  schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer
AS
$$
DECLARE
  p_id                           integer  := id;
  p_objectclass_id               integer  := objectclass_id;
  p_address_id                   integer  := address_id;
  p_lod3_multi_surface_id        integer  := lod3_multi_surface_id;
  p_lod4_multi_surface_id        integer  := lod4_multi_surface_id;
  p_lod3_implicit_rep_id         integer  := lod3_implicit_rep_id;
  p_lod4_implicit_rep_id         integer  := lod4_implicit_rep_id;
  p_lod3_implicit_ref_point      geometry := lod3_implicit_ref_point;
  p_lod4_implicit_ref_point      geometry := lod4_implicit_ref_point;
  p_lod3_implicit_transformation varchar  := lod3_implicit_transformation;
  p_lod4_implicit_transformation varchar  := lod4_implicit_transformation;
--
  p_schema_name varchar := schema_name;
  inserted_id                    integer;
BEGIN

EXECUTE format('
INSERT INTO %I.bridge_opening (
 id,
 objectclass_id,
 address_id,
 lod3_multi_surface_id,
 lod4_multi_surface_id,
 lod3_implicit_rep_id,
 lod4_implicit_rep_id,
 lod3_implicit_ref_point,
 lod4_implicit_ref_point,
 lod3_implicit_transformation,
 lod4_implicit_transformation
) VALUES (
%L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L
) RETURNING id',
p_schema_name,
p_id,
p_objectclass_id,
p_address_id,
p_lod3_multi_surface_id,
p_lod4_multi_surface_id,
p_lod3_implicit_rep_id,
p_lod4_implicit_rep_id,
p_lod3_implicit_ref_point,
p_lod4_implicit_ref_point,
p_lod3_implicit_transformation,
p_lod4_implicit_transformation
) INTO inserted_id;
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.insert_bridge_opening (id: %): %', p_id, SQLERRM;
END;
$$
LANGUAGE 'plpgsql';

----------------------------------------------------------------
-- Function INSERT_BRIDGE_ROOM
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_pkg.insert_bridge_room (integer, varchar, varchar, varchar, varchar, varchar, varchar, integer, integer, integer, varchar) CASCADE;
CREATE OR REPLACE FUNCTION citydb_pkg.insert_bridge_room (
  id                             integer,
  class                          varchar DEFAULT NULL,
  class_codespace                varchar DEFAULT NULL,
  function                       varchar DEFAULT NULL,
  function_codespace             varchar DEFAULT NULL,
  usage                          varchar DEFAULT NULL,
  usage_codespace                varchar DEFAULT NULL,
  bridge_id                      integer DEFAULT NULL,
  lod4_multi_surface_id          integer DEFAULT NULL,
  lod4_solid_id                  integer DEFAULT NULL,
--
  schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer
AS
$$
DECLARE
  p_id                           integer := id;
  p_class                        varchar := class;
  p_class_codespace              varchar := class_codespace;
  p_function                     varchar := function;
  p_function_codespace           varchar := function_codespace;
  p_usage                        varchar := usage;
  p_usage_codespace              varchar := usage_codespace;
  p_bridge_id                    integer := bridge_id;
  p_lod4_multi_surface_id        integer := lod4_multi_surface_id;
  p_lod4_solid_id                integer := lod4_solid_id;
--
  p_schema_name varchar := schema_name;
  inserted_id                    integer;
BEGIN

EXECUTE format('
INSERT INTO %I.bridge_room (
 id,
 class,
 class_codespace,
 function,
 function_codespace,
 usage,
 usage_codespace,
 bridge_id,
 lod4_multi_surface_id,
 lod4_solid_id
) VALUES (
%L, %L, %L, %L, %L, %L, %L, %L, %L, %L
) RETURNING id',
p_schema_name,
p_id,
p_class,
p_class_codespace,
p_function,
p_function_codespace,
p_usage,
p_usage_codespace,
p_bridge_id,
p_lod4_multi_surface_id,
p_lod4_solid_id
) INTO inserted_id;
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.insert_bridge_room (id: %): %', p_id, SQLERRM;
END;
$$
LANGUAGE 'plpgsql';

----------------------------------------------------------------
-- Function INSERT_BRIDGE_THEMATIC_SURFACE
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_pkg.insert_bridge_thematic_surface (integer, integer, integer, integer, integer, integer, integer, integer, integer, varchar) CASCADE;
CREATE OR REPLACE FUNCTION citydb_pkg.insert_bridge_thematic_surface (
  objectclass_id                 integer,
  id                             integer,
  bridge_id                      integer DEFAULT NULL,
  bridge_room_id                 integer DEFAULT NULL,
  bridge_installation_id         integer DEFAULT NULL,
  bridge_constr_element_id       integer DEFAULT NULL,
  lod2_multi_surface_id          integer DEFAULT NULL,
  lod3_multi_surface_id          integer DEFAULT NULL,
  lod4_multi_surface_id          integer DEFAULT NULL,
--
  schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer
AS
$$
DECLARE
  p_id                           integer := id;
  p_objectclass_id               integer := objectclass_id;
  p_bridge_id                    integer := bridge_id;
  p_bridge_room_id               integer := bridge_room_id;
  p_bridge_installation_id       integer := bridge_installation_id;
  p_bridge_constr_element_id     integer := bridge_constr_element_id;
  p_lod2_multi_surface_id        integer := lod2_multi_surface_id;
  p_lod3_multi_surface_id        integer := lod3_multi_surface_id;
  p_lod4_multi_surface_id        integer := lod4_multi_surface_id;
--
  p_schema_name varchar := schema_name;
  inserted_id                    integer;
BEGIN

EXECUTE format('
INSERT INTO %I.bridge_thematic_surface (
 id,
 objectclass_id,
 bridge_id,
 bridge_room_id,
 bridge_installation_id,
 bridge_constr_element_id,
 lod2_multi_surface_id,
 lod3_multi_surface_id,
 lod4_multi_surface_id
) VALUES (
%L, %L, %L, %L, %L, %L, %L, %L, %L
) RETURNING id',
p_schema_name,
p_id,
p_objectclass_id,
p_bridge_id,
p_bridge_room_id,
p_bridge_installation_id,
p_bridge_constr_element_id,
p_lod2_multi_surface_id,
p_lod3_multi_surface_id,
p_lod4_multi_surface_id
) INTO inserted_id;
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.insert_bridge_thematic_surface (id: %): %', p_id, SQLERRM;
END;
$$
LANGUAGE 'plpgsql';

----------------------------------------------------------------
-- Function INSERT_BUILDING_FURNITURE
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_pkg.insert_building_furniture (integer, varchar, varchar, varchar, varchar, varchar, varchar, integer, integer, geometry, integer, geometry, varchar, varchar) CASCADE;
CREATE OR REPLACE FUNCTION citydb_pkg.insert_building_furniture (
  id                             integer,
  class                          varchar DEFAULT NULL,
  class_codespace                varchar DEFAULT NULL,
  function                       varchar DEFAULT NULL,
  function_codespace             varchar DEFAULT NULL,
  usage                          varchar DEFAULT NULL,
  usage_codespace                varchar DEFAULT NULL,
  room_id                        integer DEFAULT NULL,
  lod4_brep_id                   integer DEFAULT NULL,
  lod4_other_geom                geometry DEFAULT NULL,
  lod4_implicit_rep_id           integer DEFAULT NULL,
  lod4_implicit_ref_point        geometry DEFAULT NULL,
  lod4_implicit_transformation   varchar DEFAULT NULL,
--
  schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer
AS
$$
DECLARE
  p_id                           integer  := id;
  p_class                        varchar  := class;
  p_class_codespace              varchar  := class_codespace;
  p_function                     varchar  := function;
  p_function_codespace           varchar  := function_codespace;
  p_usage                        varchar  := usage;
  p_usage_codespace              varchar  := usage_codespace;
  p_room_id                      integer  := room_id;
  p_lod4_brep_id                 integer  := lod4_brep_id;
  p_lod4_other_geom              geometry := lod4_other_geom;
  p_lod4_implicit_rep_id         integer  := lod4_implicit_rep_id;
  p_lod4_implicit_ref_point      geometry := lod4_implicit_ref_point;
  p_lod4_implicit_transformation varchar  := lod4_implicit_transformation;
--
  p_schema_name varchar := schema_name;
  inserted_id                    integer;
BEGIN

EXECUTE format('
INSERT INTO %I.building_furniture (
 id,
 class,
 class_codespace,
 function,
 function_codespace,
 usage,
 usage_codespace,
 room_id,
 lod4_brep_id,
 lod4_other_geom,
 lod4_implicit_rep_id,
 lod4_implicit_ref_point,
 lod4_implicit_transformation
) VALUES (
%L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L
) RETURNING id',
p_schema_name,
p_id,
p_class,
p_class_codespace,
p_function,
p_function_codespace,
p_usage,
p_usage_codespace,
p_room_id,
p_lod4_brep_id,
p_lod4_other_geom,
p_lod4_implicit_rep_id,
p_lod4_implicit_ref_point,
p_lod4_implicit_transformation
) INTO inserted_id;
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.insert_building_furniture (id: %): %', p_id, SQLERRM;
END;
$$
LANGUAGE 'plpgsql';

----------------------------------------------------------------
-- Function INSERT_BUILDING_INSTALLATION
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_pkg.insert_building_installation (integer, integer, varchar, varchar, varchar, varchar, varchar, varchar, integer, integer, integer, integer, integer, geometry, geometry, geometry, integer, integer, integer, geometry, geometry, geometry, varchar, varchar, varchar, varchar) CASCADE;
CREATE OR REPLACE FUNCTION citydb_pkg.insert_building_installation (
  objectclass_id                 integer,
  id                             integer,
  class                          varchar DEFAULT NULL,
  class_codespace                varchar DEFAULT NULL,
  function                       varchar DEFAULT NULL,
  function_codespace             varchar DEFAULT NULL,
  usage                          varchar DEFAULT NULL,
  usage_codespace                varchar DEFAULT NULL,
  building_id                    integer DEFAULT NULL,
  room_id                        integer DEFAULT NULL,
  lod2_brep_id                   integer DEFAULT NULL,
  lod3_brep_id                   integer DEFAULT NULL,
  lod4_brep_id                   integer DEFAULT NULL,
  lod2_other_geom                geometry DEFAULT NULL,
  lod3_other_geom                geometry DEFAULT NULL,
  lod4_other_geom                geometry DEFAULT NULL,
  lod2_implicit_rep_id           integer DEFAULT NULL,
  lod3_implicit_rep_id           integer DEFAULT NULL,
  lod4_implicit_rep_id           integer DEFAULT NULL,
  lod2_implicit_ref_point        geometry DEFAULT NULL,
  lod3_implicit_ref_point        geometry DEFAULT NULL,
  lod4_implicit_ref_point        geometry DEFAULT NULL,
  lod2_implicit_transformation   varchar DEFAULT NULL,
  lod3_implicit_transformation   varchar DEFAULT NULL,
  lod4_implicit_transformation   varchar DEFAULT NULL,
--
  schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer
AS
$$
DECLARE
  p_id                           integer  := id;
  p_objectclass_id               integer  := objectclass_id;
  p_class                        varchar  := class;
  p_class_codespace              varchar  := class_codespace;
  p_function                     varchar  := function;
  p_function_codespace           varchar  := function_codespace;
  p_usage                        varchar  := usage;
  p_usage_codespace              varchar  := usage_codespace;
  p_building_id                  integer  := building_id;
  p_room_id                      integer  := room_id;
  p_lod2_brep_id                 integer  := lod2_brep_id;
  p_lod3_brep_id                 integer  := lod3_brep_id;
  p_lod4_brep_id                 integer  := lod4_brep_id;
  p_lod2_other_geom              geometry := lod2_other_geom;
  p_lod3_other_geom              geometry := lod3_other_geom;
  p_lod4_other_geom              geometry := lod4_other_geom;
  p_lod2_implicit_rep_id         integer  := lod2_implicit_rep_id;
  p_lod3_implicit_rep_id         integer  := lod3_implicit_rep_id;
  p_lod4_implicit_rep_id         integer  := lod4_implicit_rep_id;
  p_lod2_implicit_ref_point      geometry := lod2_implicit_ref_point;
  p_lod3_implicit_ref_point      geometry := lod3_implicit_ref_point;
  p_lod4_implicit_ref_point      geometry := lod4_implicit_ref_point;
  p_lod2_implicit_transformation varchar  := lod2_implicit_transformation;
  p_lod3_implicit_transformation varchar  := lod3_implicit_transformation;
  p_lod4_implicit_transformation varchar  := lod4_implicit_transformation;
--
  p_schema_name varchar := schema_name;
  inserted_id                    integer;
BEGIN

EXECUTE format('
INSERT INTO %I.building_installation (
 id,
 objectclass_id,
 class,
 class_codespace,
 function,
 function_codespace,
 usage,
 usage_codespace,
 building_id,
 room_id,
 lod2_brep_id,
 lod3_brep_id,
 lod4_brep_id,
 lod2_other_geom,
 lod3_other_geom,
 lod4_other_geom,
 lod2_implicit_rep_id,
 lod3_implicit_rep_id,
 lod4_implicit_rep_id,
 lod2_implicit_ref_point,
 lod3_implicit_ref_point,
 lod4_implicit_ref_point,
 lod2_implicit_transformation,
 lod3_implicit_transformation,
 lod4_implicit_transformation
) VALUES (
%L, %L, %L, %L, %L, %L, %L, %L, %L, %L,
%L, %L, %L, %L, %L, %L, %L, %L, %L, %L,
%L, %L, %L, %L, %L
) RETURNING id',
p_schema_name,
p_id,
p_objectclass_id,
p_class,
p_class_codespace,
p_function,
p_function_codespace,
p_usage,
p_usage_codespace,
p_building_id,
p_room_id,
p_lod2_brep_id,
p_lod3_brep_id,
p_lod4_brep_id,
p_lod2_other_geom,
p_lod3_other_geom,
p_lod4_other_geom,
p_lod2_implicit_rep_id,
p_lod3_implicit_rep_id,
p_lod4_implicit_rep_id,
p_lod2_implicit_ref_point,
p_lod3_implicit_ref_point,
p_lod4_implicit_ref_point,
p_lod2_implicit_transformation,
p_lod3_implicit_transformation,
p_lod4_implicit_transformation
) INTO inserted_id;
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.insert_building_installation (id: %): %', p_id, SQLERRM;
END;
$$
LANGUAGE 'plpgsql';

----------------------------------------------------------------
-- Function INSERT_CITY_FURNITURE
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_pkg.insert_city_furniture (integer, varchar, varchar, varchar, varchar, varchar, varchar, geometry, geometry, geometry, geometry, integer, integer, integer, integer, geometry, geometry, geometry, geometry, integer, integer, integer, integer, geometry, geometry, geometry, geometry, varchar, varchar, varchar, varchar, varchar) CASCADE;
CREATE OR REPLACE FUNCTION citydb_pkg.insert_city_furniture (
  id                             integer,
  class                          varchar DEFAULT NULL,
  class_codespace                varchar DEFAULT NULL,
  function                       varchar DEFAULT NULL,
  function_codespace             varchar DEFAULT NULL,
  usage                          varchar DEFAULT NULL,
  usage_codespace                varchar DEFAULT NULL,
  lod1_terrain_intersection      geometry DEFAULT NULL,
  lod2_terrain_intersection      geometry DEFAULT NULL,
  lod3_terrain_intersection      geometry DEFAULT NULL,
  lod4_terrain_intersection      geometry DEFAULT NULL,
  lod1_brep_id                   integer DEFAULT NULL,
  lod2_brep_id                   integer DEFAULT NULL,
  lod3_brep_id                   integer DEFAULT NULL,
  lod4_brep_id                   integer DEFAULT NULL,
  lod1_other_geom                geometry DEFAULT NULL,
  lod2_other_geom                geometry DEFAULT NULL,
  lod3_other_geom                geometry DEFAULT NULL,
  lod4_other_geom                geometry DEFAULT NULL,
  lod1_implicit_rep_id           integer DEFAULT NULL,
  lod2_implicit_rep_id           integer DEFAULT NULL,
  lod3_implicit_rep_id           integer DEFAULT NULL,
  lod4_implicit_rep_id           integer DEFAULT NULL,
  lod1_implicit_ref_point        geometry DEFAULT NULL,
  lod2_implicit_ref_point        geometry DEFAULT NULL,
  lod3_implicit_ref_point        geometry DEFAULT NULL,
  lod4_implicit_ref_point        geometry DEFAULT NULL,
  lod1_implicit_transformation   varchar DEFAULT NULL,
  lod2_implicit_transformation   varchar DEFAULT NULL,
  lod3_implicit_transformation   varchar DEFAULT NULL,
  lod4_implicit_transformation   varchar DEFAULT NULL,
--
  schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer
AS
$$
DECLARE
  p_id                           integer  := id;
  p_class                        varchar  := class;
  p_class_codespace              varchar  := class_codespace;
  p_function                     varchar  := function;
  p_function_codespace           varchar  := function_codespace;
  p_usage                        varchar  := usage;
  p_usage_codespace              varchar  := usage_codespace;
  p_lod1_terrain_intersection    geometry := lod1_terrain_intersection;
  p_lod2_terrain_intersection    geometry := lod2_terrain_intersection;
  p_lod3_terrain_intersection    geometry := lod3_terrain_intersection;
  p_lod4_terrain_intersection    geometry := lod4_terrain_intersection;
  p_lod1_brep_id                 integer  := lod1_brep_id;
  p_lod2_brep_id                 integer  := lod2_brep_id;
  p_lod3_brep_id                 integer  := lod3_brep_id;
  p_lod4_brep_id                 integer  := lod4_brep_id;
  p_lod1_other_geom              geometry := lod1_other_geom;
  p_lod2_other_geom              geometry := lod2_other_geom;
  p_lod3_other_geom              geometry := lod3_other_geom;
  p_lod4_other_geom              geometry := lod4_other_geom;
  p_lod1_implicit_rep_id         integer  := lod1_implicit_rep_id;
  p_lod2_implicit_rep_id         integer  := lod2_implicit_rep_id;
  p_lod3_implicit_rep_id         integer  := lod3_implicit_rep_id;
  p_lod4_implicit_rep_id         integer  := lod4_implicit_rep_id;
  p_lod1_implicit_ref_point      geometry := lod1_implicit_ref_point;
  p_lod2_implicit_ref_point      geometry := lod2_implicit_ref_point;
  p_lod3_implicit_ref_point      geometry := lod3_implicit_ref_point;
  p_lod4_implicit_ref_point      geometry := lod4_implicit_ref_point;
  p_lod1_implicit_transformation varchar  := lod1_implicit_transformation;
  p_lod2_implicit_transformation varchar  := lod2_implicit_transformation;
  p_lod3_implicit_transformation varchar  := lod3_implicit_transformation;
  p_lod4_implicit_transformation varchar  := lod4_implicit_transformation;
--
  p_schema_name varchar := schema_name;
  inserted_id                    integer;
BEGIN

EXECUTE format('
INSERT INTO %I.city_furniture (
 id,
 class,
 class_codespace,
 function,
 function_codespace,
 usage,
 usage_codespace,
 lod1_terrain_intersection,
 lod2_terrain_intersection,
 lod3_terrain_intersection,
 lod4_terrain_intersection,
 lod1_brep_id,
 lod2_brep_id,
 lod3_brep_id,
 lod4_brep_id,
 lod1_other_geom,
 lod2_other_geom,
 lod3_other_geom,
 lod4_other_geom,
 lod1_implicit_rep_id,
 lod2_implicit_rep_id,
 lod3_implicit_rep_id,
 lod4_implicit_rep_id,
 lod1_implicit_ref_point,
 lod2_implicit_ref_point,
 lod3_implicit_ref_point,
 lod4_implicit_ref_point,
 lod1_implicit_transformation,
 lod2_implicit_transformation,
 lod3_implicit_transformation,
 lod4_implicit_transformation
) VALUES (
%L, %L, %L, %L, %L, %L, %L, %L, %L, %L,
%L, %L, %L, %L, %L, %L, %L, %L, %L, %L,
%L, %L, %L, %L, %L, %L, %L, %L, %L, %L,
%L
) RETURNING id',
p_schema_name,
p_id,
p_class,
p_class_codespace,
p_function,
p_function_codespace,
p_usage,
p_usage_codespace,
p_lod1_terrain_intersection,
p_lod2_terrain_intersection,
p_lod3_terrain_intersection,
p_lod4_terrain_intersection,
p_lod1_brep_id,
p_lod2_brep_id,
p_lod3_brep_id,
p_lod4_brep_id,
p_lod1_other_geom,
p_lod2_other_geom,
p_lod3_other_geom,
p_lod4_other_geom,
p_lod1_implicit_rep_id,
p_lod2_implicit_rep_id,
p_lod3_implicit_rep_id,
p_lod4_implicit_rep_id,
p_lod1_implicit_ref_point,
p_lod2_implicit_ref_point,
p_lod3_implicit_ref_point,
p_lod4_implicit_ref_point,
p_lod1_implicit_transformation,
p_lod2_implicit_transformation,
p_lod3_implicit_transformation,
p_lod4_implicit_transformation
) INTO inserted_id;
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.insert_city_furniture (id: %): %', p_id, SQLERRM;
END;
$$
LANGUAGE 'plpgsql';

----------------------------------------------------------------
-- Function INSERT_CITYOBJECT_GENERICATTRIB
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_pkg.insert_cityobject_genericattrib (varchar, integer, integer, integer, integer, integer, varchar, integer, double precision, varchar, timestamptz, varchar, varchar, bytea, geometry, integer) CASCADE; 
CREATE OR REPLACE FUNCTION citydb_pkg.insert_cityobject_genericattrib (
  attrname                       varchar,  
  datatype                       integer,
  cityobject_id                  integer,
  id                             integer          DEFAULT NULL,
  parent_genattrib_id            integer          DEFAULT NULL,
  root_genattrib_id              integer          DEFAULT NULL,
  strval                         varchar          DEFAULT NULL,
  intval                         integer          DEFAULT NULL,
  realval                        double precision DEFAULT NULL,
  urival                         varchar          DEFAULT NULL,
  dateval                        timestamptz      DEFAULT NULL,
  unit                           varchar          DEFAULT NULL,
  genattribset_codespace         varchar          DEFAULT NULL,
  blobval                        bytea            DEFAULT NULL,
  geomval                        geometry         DEFAULT NULL,
  surface_geometry_id            integer          DEFAULT NULL,
--
  schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer
AS
$$
DECLARE
  p_id                     integer           := id;
  p_parent_genattrib_id    integer           := parent_genattrib_id;
  p_root_genattrib_id      integer           := root_genattrib_id;
  p_attrname               varchar           := attrname;
  p_datatype               integer           := datatype;
  p_strval                 varchar           := strval;
  p_intval                 integer           := intval;
  p_realval                double precision  := realval;
  p_urival                 varchar           := urival;
  p_dateval                timestamptz       := dateval;
  p_unit                   varchar           := unit;
  p_genattribset_codespace varchar           := genattribset_codespace;
  p_blobval                bytea             := blobval;
  p_geomval                geometry          := geomval;
  p_surface_geometry_id    integer           := surface_geometry_id;
  p_cityobject_id          integer           := cityobject_id;
--
  p_schema_name varchar := schema_name;
  seq_name varchar;  
  inserted_id integer;
BEGIN
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
IF NOT (p_datatype BETWEEN 1 AND 10) THEN
	RAISE EXCEPTION 'datatype "%" not valid', p_datatype USING HINT = 'Valid values are between 1 and 10';
ELSE
	-- IF the ID is not given, then generate a new one.
	IF p_id IS NULL THEN
		seq_name=schema_name||'.cityobject_genericatt_seq';
		p_id=nextval(seq_name::regclass);
	END IF;

	EXECUTE format('
	INSERT INTO %I.cityobject_genericattrib (
	 id,
	 parent_genattrib_id,
	 root_genattrib_id,
	 attrname,
	 datatype,
	 strval,
	 intval,
	 realval,
	 urival,
	 dateval,
	 unit,
	 genattribset_codespace,
	 blobval,
	 geomval,
	 surface_geometry_id,
	 cityobject_id
	) VALUES (
	%L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L
	) RETURNING id',
	p_schema_name,
	p_id,
	p_parent_genattrib_id,
	p_root_genattrib_id,
	p_attrname,
	p_datatype,
	p_strval,
	p_intval,
	p_realval,
	p_urival,
	p_dateval,
	p_unit,
	p_genattribset_codespace,
	p_blobval,
	p_geomval,
	p_surface_geometry_id,
	p_cityobject_id
	) INTO inserted_id;
	RETURN inserted_id;

END IF;

EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.insert_cityobject_genericattrib (id: %): %', p_id, SQLERRM;
END;
$$
LANGUAGE 'plpgsql';

----------------------------------------------------------------
-- Function INSERT_EXTERNAL_REFERENCE
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_pkg.insert_external_reference (integer, integer, varchar, varchar, varchar, varchar) CASCADE;
CREATE OR REPLACE FUNCTION citydb_pkg.insert_external_reference (
  cityobject_id integer,
  id            integer DEFAULT NULL,
  infosys       varchar DEFAULT NULL,
  name          varchar DEFAULT NULL,
  uri           varchar DEFAULT NULL,
--
  schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer
AS
$$
DECLARE
  p_id            integer := id;
  p_infosys       varchar := infosys;
  p_name          varchar := name;
  p_uri           varchar := uri;
  p_cityobject_id integer := cityobject_id;
--
  p_schema_name varchar := schema_name;
  seq_name varchar;  
  inserted_id integer;
BEGIN
-- IF the ID is not given, then generate a new one.
IF p_id IS NULL THEN
	seq_name=schema_name||'.external_ref_seq';
	p_id=nextval(seq_name::regclass);
END IF;

EXECUTE format('
INSERT INTO %I.external_reference (
 id,
 infosys,
 name,
 uri,
 cityobject_id
) VALUES (
%L, %L, %L, %L, %L
) RETURNING id',
p_schema_name,
p_id,
p_infosys,
p_name,
p_uri,
p_cityobject_id
) INTO inserted_id;
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.insert_external_reference (id: %): %', p_id, SQLERRM;
END;
$$
LANGUAGE 'plpgsql';

----------------------------------------------------------------
-- Function INSERT_GENERALIZATION
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_pkg.insert_generalization (integer, integer, varchar) CASCADE;
CREATE OR REPLACE FUNCTION citydb_pkg.insert_generalization (
  cityobject_id     integer,
  generalizes_to_id integer,
--
  schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer
AS
$$
DECLARE
  p_cityobject_id     integer := cityobject_id;
  p_generalizes_to_id integer := generalizes_to_id;
--
  p_schema_name varchar := schema_name;
  inserted_id integer;
BEGIN

EXECUTE format('
INSERT INTO %I.generalization (
 cityobject_id,
 generalizes_to_id
) VALUES (
%L, %L
) RETURNING id',
p_schema_name,
p_cityobject_id,
p_generalizes_to_id
) INTO inserted_id;
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.insert_generalization (cityobject_id: %, generalizes_to_id: %): %', p_cityobject_id, p_generalizes_to_id, SQLERRM;
END;
$$
LANGUAGE 'plpgsql';

----------------------------------------------------------------
-- Function INSERT_GENERIC_CITYOBJECT
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_pkg.insert_generic_cityobject (integer, varchar, varchar, varchar, varchar, varchar, varchar, geometry, geometry, geometry, geometry, geometry, integer, integer, integer, integer, integer, geometry, geometry, geometry, geometry, geometry, integer, integer, integer, integer, integer, geometry, geometry, geometry, geometry, geometry, varchar, varchar, varchar, varchar, varchar, varchar) CASCADE;
CREATE OR REPLACE FUNCTION citydb_pkg.insert_generic_cityobject (
  id                             integer,
  class                          varchar DEFAULT NULL,
  class_codespace                varchar DEFAULT NULL,
  function                       varchar DEFAULT NULL,
  function_codespace             varchar DEFAULT NULL,
  usage                          varchar DEFAULT NULL,
  usage_codespace                varchar DEFAULT NULL,
  lod0_terrain_intersection      geometry DEFAULT NULL,
  lod1_terrain_intersection      geometry DEFAULT NULL,
  lod2_terrain_intersection      geometry DEFAULT NULL,
  lod3_terrain_intersection      geometry DEFAULT NULL,
  lod4_terrain_intersection      geometry DEFAULT NULL,
  lod0_brep_id                   integer DEFAULT NULL,
  lod1_brep_id                   integer DEFAULT NULL,
  lod2_brep_id                   integer DEFAULT NULL,
  lod3_brep_id                   integer DEFAULT NULL,
  lod4_brep_id                   integer DEFAULT NULL,
  lod0_other_geom                geometry DEFAULT NULL,
  lod1_other_geom                geometry DEFAULT NULL,
  lod2_other_geom                geometry DEFAULT NULL,
  lod3_other_geom                geometry DEFAULT NULL,
  lod4_other_geom                geometry DEFAULT NULL,
  lod0_implicit_rep_id           integer DEFAULT NULL,
  lod1_implicit_rep_id           integer DEFAULT NULL,
  lod2_implicit_rep_id           integer DEFAULT NULL,
  lod3_implicit_rep_id           integer DEFAULT NULL,
  lod4_implicit_rep_id           integer DEFAULT NULL,
  lod0_implicit_ref_point        geometry DEFAULT NULL,
  lod1_implicit_ref_point        geometry DEFAULT NULL,
  lod2_implicit_ref_point        geometry DEFAULT NULL,
  lod3_implicit_ref_point        geometry DEFAULT NULL,
  lod4_implicit_ref_point        geometry DEFAULT NULL,
  lod0_implicit_transformation   varchar DEFAULT NULL,
  lod1_implicit_transformation   varchar DEFAULT NULL,
  lod2_implicit_transformation   varchar DEFAULT NULL,
  lod3_implicit_transformation   varchar DEFAULT NULL,
  lod4_implicit_transformation   varchar DEFAULT NULL,
--
  schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer
AS
$$
DECLARE
  p_id                           integer  := id;
  p_class                        varchar  := class;
  p_class_codespace              varchar  := class_codespace;
  p_function                     varchar  := function;
  p_function_codespace           varchar  := function_codespace;
  p_usage                        varchar  := usage;
  p_usage_codespace              varchar  := usage_codespace;
  p_lod0_terrain_intersection    geometry := lod0_terrain_intersection;
  p_lod1_terrain_intersection    geometry := lod1_terrain_intersection;
  p_lod2_terrain_intersection    geometry := lod2_terrain_intersection;
  p_lod3_terrain_intersection    geometry := lod3_terrain_intersection;
  p_lod4_terrain_intersection    geometry := lod4_terrain_intersection;
  p_lod0_brep_id                 integer  := lod0_brep_id;
  p_lod1_brep_id                 integer  := lod1_brep_id;
  p_lod2_brep_id                 integer  := lod2_brep_id;
  p_lod3_brep_id                 integer  := lod3_brep_id;
  p_lod4_brep_id                 integer  := lod4_brep_id;
  p_lod0_other_geom              geometry := lod0_other_geom;
  p_lod1_other_geom              geometry := lod1_other_geom;
  p_lod2_other_geom              geometry := lod2_other_geom;
  p_lod3_other_geom              geometry := lod3_other_geom;
  p_lod4_other_geom              geometry := lod4_other_geom;
  p_lod0_implicit_rep_id         integer  := lod0_implicit_rep_id;
  p_lod1_implicit_rep_id         integer  := lod1_implicit_rep_id;
  p_lod2_implicit_rep_id         integer  := lod2_implicit_rep_id;
  p_lod3_implicit_rep_id         integer  := lod3_implicit_rep_id;
  p_lod4_implicit_rep_id         integer  := lod4_implicit_rep_id;
  p_lod0_implicit_ref_point      geometry := lod0_implicit_ref_point;
  p_lod1_implicit_ref_point      geometry := lod1_implicit_ref_point;
  p_lod2_implicit_ref_point      geometry := lod2_implicit_ref_point;
  p_lod3_implicit_ref_point      geometry := lod3_implicit_ref_point;
  p_lod4_implicit_ref_point      geometry := lod4_implicit_ref_point;
  p_lod0_implicit_transformation varchar  := lod0_implicit_transformation;
  p_lod1_implicit_transformation varchar  := lod1_implicit_transformation;
  p_lod2_implicit_transformation varchar  := lod2_implicit_transformation;
  p_lod3_implicit_transformation varchar  := lod3_implicit_transformation;
  p_lod4_implicit_transformation varchar  := lod4_implicit_transformation;
--
  p_schema_name varchar := schema_name;
  inserted_id integer;
BEGIN

EXECUTE format('
INSERT INTO %I.generic_cityobject (
 id,
 class,
 class_codespace,
 function,
 function_codespace,
 usage,
 usage_codespace,
 lod0_terrain_intersection,
 lod1_terrain_intersection,
 lod2_terrain_intersection,
 lod3_terrain_intersection,
 lod4_terrain_intersection,
 lod0_brep_id,
 lod1_brep_id,
 lod2_brep_id,
 lod3_brep_id,
 lod4_brep_id,
 lod0_other_geom,
 lod1_other_geom,
 lod2_other_geom,
 lod3_other_geom,
 lod4_other_geom,
 lod0_implicit_rep_id,
 lod1_implicit_rep_id,
 lod2_implicit_rep_id,
 lod3_implicit_rep_id,
 lod4_implicit_rep_id,
 lod0_implicit_ref_point,
 lod1_implicit_ref_point,
 lod2_implicit_ref_point,
 lod3_implicit_ref_point,
 lod4_implicit_ref_point,
 lod0_implicit_transformation,
 lod1_implicit_transformation,
 lod2_implicit_transformation,
 lod3_implicit_transformation,
 lod4_implicit_transformation
) VALUES (
%L, %L, %L, %L, %L, %L, %L, %L, %L, %L,
%L, %L, %L, %L, %L, %L, %L, %L, %L, %L,
%L, %L, %L, %L, %L, %L, %L, %L, %L, %L,
%L, %L, %L, %L, %L, %L, %L
) RETURNING id',
p_schema_name,
p_id,
p_class,
p_class_codespace,
p_function,
p_function_codespace,
p_usage,
p_usage_codespace,
p_lod0_terrain_intersection,
p_lod1_terrain_intersection,
p_lod2_terrain_intersection,
p_lod3_terrain_intersection,
p_lod4_terrain_intersection,
p_lod0_brep_id,
p_lod1_brep_id,
p_lod2_brep_id,
p_lod3_brep_id,
p_lod4_brep_id,
p_lod0_other_geom,
p_lod1_other_geom,
p_lod2_other_geom,
p_lod3_other_geom,
p_lod4_other_geom,
p_lod0_implicit_rep_id,
p_lod1_implicit_rep_id,
p_lod2_implicit_rep_id,
p_lod3_implicit_rep_id,
p_lod4_implicit_rep_id,
p_lod0_implicit_ref_point,
p_lod1_implicit_ref_point,
p_lod2_implicit_ref_point,
p_lod3_implicit_ref_point,
p_lod4_implicit_ref_point,
p_lod0_implicit_transformation,
p_lod1_implicit_transformation,
p_lod2_implicit_transformation,
p_lod3_implicit_transformation,
p_lod4_implicit_transformation
) INTO inserted_id;
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.insert_generic_cityobject (id: %): %', p_id, SQLERRM;
END;
$$
LANGUAGE 'plpgsql';

----------------------------------------------------------------
-- Function INSERT_GRID_COVERAGE
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_pkg.insert_grid_coverage (integer, raster, varchar) CASCADE;
CREATE OR REPLACE FUNCTION citydb_pkg.insert_grid_coverage (
  id             integer DEFAULT NULL,
  rasterproperty raster DEFAULT NULL,
--
  schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer
AS
$$
DECLARE
  p_id             integer := id;
  p_rasterproperty raster  := rasterproperty;
--
  p_schema_name varchar := schema_name;
  seq_name varchar;
  inserted_id integer;
BEGIN
-- IF the ID is not given, then generate a new one.
IF p_id IS NULL THEN
  seq_name=schema_name||'.grid_coverage_seq';
  p_id=nextval(seq_name::regclass);
END IF;

EXECUTE format('
INSERT INTO %I.grid_coverage (
 id,
 rasterproperty
) VALUES (
%L, %L
) RETURNING id',
p_schema_name,
p_id,
p_rasterproperty
) INTO inserted_id;
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.insert_grid_coverage (id: %): %', p_id, SQLERRM;
END;
$$
LANGUAGE 'plpgsql';

----------------------------------------------------------------
-- Function INSERT_IMPLICIT_GEOMETRY
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_pkg.insert_implicit_geometry (integer, varchar, varchar, bytea, integer, geometry, varchar) CASCADE;
CREATE OR REPLACE FUNCTION citydb_pkg.insert_implicit_geometry (
  id                   integer  DEFAULT NULL,
  mime_type            varchar  DEFAULT NULL,
  reference_to_library varchar  DEFAULT NULL,
  library_object       bytea    DEFAULT NULL,
  relative_brep_id     integer  DEFAULT NULL,
  relative_other_geom  geometry DEFAULT NULL,
--
  schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer
AS
$$
DECLARE
  p_id                   integer  := id;
  p_mime_type            varchar  := mime_type;
  p_reference_to_library varchar  := reference_to_library;
  p_library_object       bytea    := library_object;
  p_relative_brep_id     integer  := relative_brep_id;
  p_relative_other_geom  geometry := relative_other_geom;
--
  p_schema_name varchar := schema_name;
  seq_name varchar;
  inserted_id integer;
BEGIN
-- IF the ID is not given, then generate a new one.
IF p_id IS NULL THEN
  seq_name=schema_name||'.implicit_geometry_seq';
  p_id=nextval(seq_name::regclass);
END IF;

EXECUTE format('
INSERT INTO %I.implicit_geometry (
 id,
 mime_type,
 reference_to_library,
 library_object,
 relative_brep_id,
 relative_other_geom
) VALUES (
%L, %L, %L, %L, %L, %L
) RETURNING id',
p_schema_name,
p_id,
p_mime_type,
p_reference_to_library,
p_library_object,
p_relative_brep_id,
p_relative_other_geom
) INTO inserted_id;
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.insert_implicit_geometry (id: %): %', p_id, SQLERRM;
END;
$$
LANGUAGE 'plpgsql';

----------------------------------------------------------------
-- Function INSERT_LAND_USE
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_pkg.insert_land_use (integer, varchar, varchar, varchar, varchar, varchar, varchar, integer, integer, integer, integer, integer, varchar) CASCADE;
CREATE OR REPLACE FUNCTION citydb_pkg.insert_land_use (
  id                    integer,
  class                 varchar DEFAULT NULL,
  class_codespace       varchar DEFAULT NULL,
  function              varchar DEFAULT NULL,
  function_codespace    varchar DEFAULT NULL,
  usage                 varchar DEFAULT NULL,
  usage_codespace       varchar DEFAULT NULL,
  lod0_multi_surface_id integer DEFAULT NULL,
  lod1_multi_surface_id integer DEFAULT NULL,
  lod2_multi_surface_id integer DEFAULT NULL,
  lod3_multi_surface_id integer DEFAULT NULL,
  lod4_multi_surface_id integer DEFAULT NULL,
--
  schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer
AS
$$
DECLARE
  p_id                    integer := id;
  p_class                 varchar := class;
  p_class_codespace       varchar := class_codespace;
  p_function              varchar := function;
  p_function_codespace    varchar := function_codespace;
  p_usage                 varchar := usage;
  p_usage_codespace       varchar := usage_codespace;
  p_lod0_multi_surface_id integer := lod0_multi_surface_id;
  p_lod1_multi_surface_id integer := lod1_multi_surface_id;
  p_lod2_multi_surface_id integer := lod2_multi_surface_id;
  p_lod3_multi_surface_id integer := lod3_multi_surface_id;
  p_lod4_multi_surface_id integer := lod4_multi_surface_id;
--
  p_schema_name varchar := schema_name;
  inserted_id integer;
BEGIN

EXECUTE format('
INSERT INTO %I.land_use (
 id,
 class,
 class_codespace,
 function,
 function_codespace,
 usage,
 usage_codespace,
 lod0_multi_surface_id,
 lod1_multi_surface_id,
 lod2_multi_surface_id,
 lod3_multi_surface_id,
 lod4_multi_surface_id
) VALUES (
%L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L
) RETURNING id',
p_schema_name,
p_id,
p_class,
p_class_codespace,
p_function,
p_function_codespace,
p_usage,
p_usage_codespace,
p_lod0_multi_surface_id,
p_lod1_multi_surface_id,
p_lod2_multi_surface_id,
p_lod3_multi_surface_id,
p_lod4_multi_surface_id
) INTO inserted_id;
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.insert_land_use (id: %): %', p_id, SQLERRM;
END;
$$
LANGUAGE 'plpgsql';

----------------------------------------------------------------
-- Function INSERT_MASSPOINT_RELIEF
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_pkg.insert_masspoint_relief (integer, geometry, varchar) CASCADE;
CREATE OR REPLACE FUNCTION citydb_pkg.insert_masspoint_relief (
  id                             integer,
  relief_points                  geometry DEFAULT NULL,
--
  schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer
AS
$$
DECLARE
  p_id            integer  := id;
  p_relief_points geometry := relief_points;
--
  p_schema_name varchar := schema_name;
  inserted_id integer;
BEGIN

EXECUTE format('
INSERT INTO %I.masspoint_relief (
 id,
 relief_points
) VALUES (
%L, %L
) RETURNING id',
p_schema_name,
p_id,
p_relief_points
) INTO inserted_id;
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.insert_masspoint_relief (id: %): %', p_id, SQLERRM;
END;
$$
LANGUAGE 'plpgsql';

----------------------------------------------------------------
-- Function INSERT_OPENING
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_pkg.insert_opening (integer, integer, integer, integer, integer, integer, integer, geometry, geometry, varchar, varchar, varchar) CASCADE;
CREATE OR REPLACE FUNCTION citydb_pkg.insert_opening (
  objectclass_id                 integer,
  id                             integer,
  address_id                     integer DEFAULT NULL,
  lod3_multi_surface_id          integer DEFAULT NULL,
  lod4_multi_surface_id          integer DEFAULT NULL,
  lod3_implicit_rep_id           integer DEFAULT NULL,
  lod4_implicit_rep_id           integer DEFAULT NULL,
  lod3_implicit_ref_point        geometry DEFAULT NULL,
  lod4_implicit_ref_point        geometry DEFAULT NULL,
  lod3_implicit_transformation   varchar DEFAULT NULL,
  lod4_implicit_transformation   varchar DEFAULT NULL,
--
  schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer
AS
$$
DECLARE
  p_id                           integer  := id;
  p_objectclass_id               integer  := objectclass_id;
  p_address_id                   integer  := address_id;
  p_lod3_multi_surface_id        integer  := lod3_multi_surface_id;
  p_lod4_multi_surface_id        integer  := lod4_multi_surface_id;
  p_lod3_implicit_rep_id         integer  := lod3_implicit_rep_id;
  p_lod4_implicit_rep_id         integer  := lod4_implicit_rep_id;
  p_lod3_implicit_ref_point      geometry := lod3_implicit_ref_point;
  p_lod4_implicit_ref_point      geometry := lod4_implicit_ref_point;
  p_lod3_implicit_transformation varchar  := lod3_implicit_transformation;
  p_lod4_implicit_transformation varchar  := lod4_implicit_transformation;
--
  p_schema_name varchar := schema_name;
  inserted_id integer;
BEGIN

EXECUTE format('
INSERT INTO %I.opening (
 id,
 objectclass_id,
 address_id,
 lod3_multi_surface_id,
 lod4_multi_surface_id,
 lod3_implicit_rep_id,
 lod4_implicit_rep_id,
 lod3_implicit_ref_point,
 lod4_implicit_ref_point,
 lod3_implicit_transformation,
 lod4_implicit_transformation
) VALUES (
%L, %L, %L, %L, %L, %L, %L, %L, %L, %L,
%L
) RETURNING id',
p_schema_name,
p_id,
p_objectclass_id,
p_address_id,
p_lod3_multi_surface_id,
p_lod4_multi_surface_id,
p_lod3_implicit_rep_id,
p_lod4_implicit_rep_id,
p_lod3_implicit_ref_point,
p_lod4_implicit_ref_point,
p_lod3_implicit_transformation,
p_lod4_implicit_transformation
) INTO inserted_id;
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.insert_opening (id: %): %', p_id, SQLERRM;
END;
$$
LANGUAGE 'plpgsql';

----------------------------------------------------------------
-- Function INSERT_OPENING_TO_THEM_SURFACE
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_pkg.insert_opening_to_them_surface (integer, integer, varchar) CASCADE;
CREATE OR REPLACE FUNCTION citydb_pkg.insert_opening_to_them_surface (
  opening_id          integer,
  thematic_surface_id integer,
--
  schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS void
AS
$$
DECLARE
  p_opening_id          integer := opening_id;
  p_thematic_surface_id integer := thematic_surface_id;
--
  p_schema_name varchar := schema_name;
BEGIN

EXECUTE format('
INSERT INTO %I.opening_to_them_surface (
 opening_id,
 thematic_surface_id
) VALUES (
%L, %L
)',
p_schema_name,
p_opening_id,
p_thematic_surface_id
);
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.insert_opening_to_them_surface (opening_id: %, thematic_surface_id %): %', p_opening_id, thematic_surface_id, SQLERRM;
END;
$$
LANGUAGE 'plpgsql';

----------------------------------------------------------------
-- Function INSERT_PLANT_COVER
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_pkg.insert_plant_cover (integer, varchar, varchar, varchar, varchar, varchar, varchar, double precision, varchar, integer, integer, integer, integer, integer, integer, integer, integer, varchar) CASCADE;
CREATE OR REPLACE FUNCTION citydb_pkg.insert_plant_cover (
  id                    integer,
  class                 varchar DEFAULT NULL,
  class_codespace       varchar DEFAULT NULL,
  function              varchar DEFAULT NULL,
  function_codespace    varchar DEFAULT NULL,
  usage                 varchar DEFAULT NULL,
  usage_codespace       varchar DEFAULT NULL,
  average_height        double precision DEFAULT NULL,
  average_height_unit   varchar DEFAULT NULL,
  lod1_multi_surface_id integer DEFAULT NULL,
  lod2_multi_surface_id integer DEFAULT NULL,
  lod3_multi_surface_id integer DEFAULT NULL,
  lod4_multi_surface_id integer DEFAULT NULL,
  lod1_multi_solid_id   integer DEFAULT NULL,
  lod2_multi_solid_id   integer DEFAULT NULL,
  lod3_multi_solid_id   integer DEFAULT NULL,
  lod4_multi_solid_id   integer DEFAULT NULL,
--
  schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer
AS
$$
DECLARE
  p_id                    integer          := id;
  p_class                 varchar          := class;
  p_class_codespace       varchar          := class_codespace;
  p_function              varchar          := function;
  p_function_codespace    varchar          := function_codespace;
  p_usage                 varchar          := usage;
  p_usage_codespace       varchar          := usage_codespace;
  p_average_height        double precision := average_height;
  p_average_height_unit   varchar          := average_height_unit;
  p_lod1_multi_surface_id integer          := lod1_multi_surface_id;
  p_lod2_multi_surface_id integer          := lod2_multi_surface_id;
  p_lod3_multi_surface_id integer          := lod3_multi_surface_id;
  p_lod4_multi_surface_id integer          := lod4_multi_surface_id;
  p_lod1_multi_solid_id   integer          := lod1_multi_solid_id;
  p_lod2_multi_solid_id   integer          := lod2_multi_solid_id;
  p_lod3_multi_solid_id   integer          := lod3_multi_solid_id;
  p_lod4_multi_solid_id   integer          := lod4_multi_solid_id;
--
  p_schema_name varchar := schema_name;
  inserted_id integer;
BEGIN

EXECUTE format('
INSERT INTO %I.plant_cover (
 id,
 class,
 class_codespace,
 function,
 function_codespace,
 usage,
 usage_codespace,
 average_height,
 average_height_unit,
 lod1_multi_surface_id,
 lod2_multi_surface_id,
 lod3_multi_surface_id,
 lod4_multi_surface_id,
 lod1_multi_solid_id,
 lod2_multi_solid_id,
 lod3_multi_solid_id,
 lod4_multi_solid_id
) VALUES (
%L, %L, %L, %L, %L, %L, %L, %L, %L, %L,
%L, %L, %L, %L, %L, %L, %L
) RETURNING id',
p_schema_name,
p_id,
p_class,
p_class_codespace,
p_function,
p_function_codespace,
p_usage,
p_usage_codespace,
p_average_height,
p_average_height_unit,
p_lod1_multi_surface_id,
p_lod2_multi_surface_id,
p_lod3_multi_surface_id,
p_lod4_multi_surface_id,
p_lod1_multi_solid_id,
p_lod2_multi_solid_id,
p_lod3_multi_solid_id,
p_lod4_multi_solid_id
) INTO inserted_id;
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.insert_plant_cover (id: %): %', p_id, SQLERRM;
END;
$$
LANGUAGE 'plpgsql';

----------------------------------------------------------------
-- Function INSERT_RASTER_RELIEF
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_pkg.insert_raster_relief (integer, varchar, integer, varchar) CASCADE;
CREATE OR REPLACE FUNCTION citydb_pkg.insert_raster_relief (
  id                             integer,
  raster_uri                     varchar DEFAULT NULL,
  coverage_id                    integer DEFAULT NULL,
--
  schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer
AS
$$
DECLARE
  p_id           integer := id;
  p_raster_uri   varchar := raster_uri;
  p_coverage_id  integer := coverage_id;
--
  p_schema_name varchar := schema_name;
  inserted_id integer;
BEGIN

EXECUTE format('
INSERT INTO %I.raster_relief (
 id,
 raster_uri,
 coverage_id
) VALUES (
%L, %L, %L
) RETURNING id',
p_schema_name,
p_id,
p_raster_uri,
p_coverage_id
) INTO inserted_id;
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.insert_raster_relief (id: %): %', p_id, SQLERRM;
END;
$$
LANGUAGE 'plpgsql';

----------------------------------------------------------------
-- Function INSERT_RELIEF_COMPONENT
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_pkg.insert_relief_component (integer, integer, numeric, geometry, varchar) CASCADE;
CREATE OR REPLACE FUNCTION citydb_pkg.insert_relief_component (
  id                             integer,
  objectclass_id                 integer,
  lod                            numeric DEFAULT NULL,
  extent                         geometry DEFAULT NULL,
--
  schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer
AS
$$
DECLARE
  p_id             integer  := id;
  p_objectclass_id integer  := objectclass_id;
  p_lod            numeric  := lod;
  p_extent         geometry := extent;
--
  p_schema_name varchar := schema_name;
  inserted_id integer;
BEGIN

EXECUTE format('
INSERT INTO %I.relief_component (
 id,
 objectclass_id,
 lod,
 extent
) VALUES (
%L, %L, %L, %L
) RETURNING id',
p_schema_name,
p_id,
p_objectclass_id,
p_lod,
p_extent
) INTO inserted_id;
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.insert_relief_component (id: %): %', p_id, SQLERRM;
END;
$$
LANGUAGE 'plpgsql';

----------------------------------------------------------------
-- Function INSERT_RELIEF_FEAT_TO_REL_COMP
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_pkg.insert_relief_feat_to_rel_comp (integer, integer, varchar) CASCADE;
CREATE OR REPLACE FUNCTION citydb_pkg.insert_relief_feat_to_rel_comp (
  relief_component_id integer,
  relief_feature_id   integer,
--
  schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS void
AS
$$
DECLARE
  p_relief_component_id integer := relief_component_id;
  p_relief_feature_id   integer := relief_feature_id;
--
  p_schema_name varchar := schema_name;
BEGIN

EXECUTE format('
INSERT INTO %I.relief_feat_to_rel_comp (
 relief_component_id,
 relief_feature_id
) VALUES (
%L, %L
)',
p_schema_name,
p_relief_component_id,
p_relief_feature_id
);
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.insert_relief_feat_to_rel_comp (relief_feature_id: %, relief_component_id %): %', p_relief_feature_id, p_relief_component_id, SQLERRM;
END;
$$
LANGUAGE 'plpgsql';

----------------------------------------------------------------
-- Function INSERT_RELIEF_FEATURE
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_pkg.insert_relief_feature (integer, numeric, varchar) CASCADE;
CREATE OR REPLACE FUNCTION citydb_pkg.insert_relief_feature (
  id  integer,
  lod numeric DEFAULT NULL,
--
  schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer
AS
$$
DECLARE
  p_id  integer := id;
  p_lod numeric := lod;
--
  p_schema_name varchar := schema_name;
  inserted_id integer;
BEGIN

EXECUTE format('
INSERT INTO %I.relief_feature (
 id,
 lod
) VALUES (
%L, %L
) RETURNING id',
p_schema_name,
p_id,
p_lod
) INTO inserted_id;
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.insert_relief_feature (id: %): %', p_id, SQLERRM;
END;
$$
LANGUAGE 'plpgsql';

----------------------------------------------------------------
-- Function INSERT_ROOM
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_pkg.insert_room (integer, varchar, varchar, varchar, varchar, varchar, varchar, integer, integer, integer, varchar) CASCADE;
CREATE OR REPLACE FUNCTION citydb_pkg.insert_room (
  id                    integer,
  class                 varchar DEFAULT NULL,
  class_codespace       varchar DEFAULT NULL,
  function              varchar DEFAULT NULL,
  function_codespace    varchar DEFAULT NULL,
  usage                 varchar DEFAULT NULL,
  usage_codespace       varchar DEFAULT NULL,
  building_id           integer DEFAULT NULL,
  lod4_multi_surface_id integer DEFAULT NULL,
  lod4_solid_id         integer DEFAULT NULL,
--
  schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer
AS
$$
DECLARE
  p_id                    integer := id;
  p_class                 varchar := class;
  p_class_codespace       varchar := class_codespace;
  p_function              varchar := function;
  p_function_codespace    varchar := function_codespace;
  p_usage                 varchar := usage;
  p_usage_codespace       varchar := usage_codespace;
  p_building_id           integer := building_id;
  p_lod4_multi_surface_id integer := lod4_multi_surface_id;
  p_lod4_solid_id         integer := lod4_solid_id;
--
  p_schema_name varchar := schema_name;
  inserted_id integer;
BEGIN

EXECUTE format('
INSERT INTO %I.room (
 id,
 class,
 class_codespace,
 function,
 function_codespace,
 usage,
 usage_codespace,
 building_id,
 lod4_multi_surface_id,
 lod4_solid_id
) VALUES (
%L, %L, %L, %L, %L, %L, %L, %L, %L, %L
) RETURNING id',
p_schema_name,
p_id,
p_class,
p_class_codespace,
p_function,
p_function_codespace,
p_usage,
p_usage_codespace,
p_building_id,
p_lod4_multi_surface_id,
p_lod4_solid_id
) INTO inserted_id;
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.insert_room (id: %): %', p_id, SQLERRM;
END;
$$
LANGUAGE 'plpgsql';

----------------------------------------------------------------
-- Function INSERT_SOLITARY_VEGETAT_OBJECT
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_pkg.insert_solitary_vegetat_object (integer, varchar, varchar, varchar, varchar, varchar, varchar, varchar, varchar, double precision, varchar, double precision, varchar, double precision, varchar, integer, integer, integer, integer, geometry, geometry, geometry, geometry, integer, integer, integer, integer, geometry, geometry, geometry, geometry, varchar, varchar, varchar, varchar, varchar) CASCADE;
CREATE OR REPLACE FUNCTION citydb_pkg.insert_solitary_vegetat_object (
  id                             integer,
  class                          varchar DEFAULT NULL,
  class_codespace                varchar DEFAULT NULL,
  function                       varchar DEFAULT NULL,
  function_codespace             varchar DEFAULT NULL,
  usage                          varchar DEFAULT NULL,
  usage_codespace                varchar DEFAULT NULL,
  species                        varchar DEFAULT NULL,
  species_codespace              varchar DEFAULT NULL,
  height                         double precision DEFAULT NULL,
  height_unit                    varchar DEFAULT NULL,
  trunk_diameter                 double precision DEFAULT NULL,
  trunk_diameter_unit            varchar DEFAULT NULL,
  crown_diameter                 double precision DEFAULT NULL,
  crown_diameter_unit            varchar DEFAULT NULL,
  lod1_brep_id                   integer DEFAULT NULL,
  lod2_brep_id                   integer DEFAULT NULL,
  lod3_brep_id                   integer DEFAULT NULL,
  lod4_brep_id                   integer DEFAULT NULL,
  lod1_other_geom                geometry DEFAULT NULL,
  lod2_other_geom                geometry DEFAULT NULL,
  lod3_other_geom                geometry DEFAULT NULL,
  lod4_other_geom                geometry DEFAULT NULL,
  lod1_implicit_rep_id           integer DEFAULT NULL,
  lod2_implicit_rep_id           integer DEFAULT NULL,
  lod3_implicit_rep_id           integer DEFAULT NULL,
  lod4_implicit_rep_id           integer DEFAULT NULL,
  lod1_implicit_ref_point        geometry DEFAULT NULL,
  lod2_implicit_ref_point        geometry DEFAULT NULL,
  lod3_implicit_ref_point        geometry DEFAULT NULL,
  lod4_implicit_ref_point        geometry DEFAULT NULL,
  lod1_implicit_transformation   varchar DEFAULT NULL,
  lod2_implicit_transformation   varchar DEFAULT NULL,
  lod3_implicit_transformation   varchar DEFAULT NULL,
  lod4_implicit_transformation   varchar DEFAULT NULL,
--
  schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer
AS
$$
DECLARE
  p_id                           integer          := id;
  p_class                        varchar          := class;
  p_class_codespace              varchar          := class_codespace;
  p_function                     varchar          := function;
  p_function_codespace           varchar          := function_codespace;
  p_usage                        varchar          := usage;
  p_usage_codespace              varchar          := usage_codespace;
  p_species                      varchar          := species;
  p_species_codespace            varchar          := species_codespace;
  p_height                       double precision := height;
  p_height_unit                  varchar          := height_unit;
  p_trunk_diameter               double precision := trunk_diameter;
  p_trunk_diameter_unit          varchar          := trunk_diameter_unit;
  p_crown_diameter               double precision := crown_diameter;
  p_crown_diameter_unit          varchar          := crown_diameter_unit;
  p_lod1_brep_id                 integer          := lod1_brep_id;
  p_lod2_brep_id                 integer          := lod2_brep_id;
  p_lod3_brep_id                 integer          := lod3_brep_id;
  p_lod4_brep_id                 integer          := lod4_brep_id;
  p_lod1_other_geom              geometry         := lod1_other_geom;
  p_lod2_other_geom              geometry         := lod2_other_geom;
  p_lod3_other_geom              geometry         := lod3_other_geom;
  p_lod4_other_geom              geometry         := lod4_other_geom;
  p_lod1_implicit_rep_id         integer          := lod1_implicit_rep_id;
  p_lod2_implicit_rep_id         integer          := lod2_implicit_rep_id;
  p_lod3_implicit_rep_id         integer          := lod3_implicit_rep_id;
  p_lod4_implicit_rep_id         integer          := lod4_implicit_rep_id;
  p_lod1_implicit_ref_point      geometry         := lod1_implicit_ref_point;
  p_lod2_implicit_ref_point      geometry         := lod2_implicit_ref_point;
  p_lod3_implicit_ref_point      geometry         := lod3_implicit_ref_point;
  p_lod4_implicit_ref_point      geometry         := lod4_implicit_ref_point;
  p_lod1_implicit_transformation varchar          := lod1_implicit_transformation;
  p_lod2_implicit_transformation varchar          := lod2_implicit_transformation;
  p_lod3_implicit_transformation varchar          := lod3_implicit_transformation;
  p_lod4_implicit_transformation varchar          := lod4_implicit_transformation;
--
  p_schema_name varchar := schema_name;
  inserted_id integer;
BEGIN

EXECUTE format('
INSERT INTO %I.solitary_vegetat_object (
 id,
 class,
 class_codespace,
 function,
 function_codespace,
 usage,
 usage_codespace,
 species,
 species_codespace,
 height,
 height_unit,
 trunk_diameter,
 trunk_diameter_unit,
 crown_diameter,
 crown_diameter_unit,
 lod1_brep_id,
 lod2_brep_id,
 lod3_brep_id,
 lod4_brep_id,
 lod1_other_geom,
 lod2_other_geom,
 lod3_other_geom,
 lod4_other_geom,
 lod1_implicit_rep_id,
 lod2_implicit_rep_id,
 lod3_implicit_rep_id,
 lod4_implicit_rep_id,
 lod1_implicit_ref_point,
 lod2_implicit_ref_point,
 lod3_implicit_ref_point,
 lod4_implicit_ref_point,
 lod1_implicit_transformation,
 lod2_implicit_transformation,
 lod3_implicit_transformation,
 lod4_implicit_transformation
) VALUES (
%L, %L, %L, %L, %L, %L, %L, %L, %L, %L,
%L, %L, %L, %L, %L, %L, %L, %L, %L, %L,
%L, %L, %L, %L, %L, %L, %L, %L, %L, %L,
%L, %L, %L, %L, %L
) RETURNING id',
p_schema_name,
p_id,
p_class,
p_class_codespace,
p_function,
p_function_codespace,
p_usage,
p_usage_codespace,
p_species,
p_species_codespace,
p_height,
p_height_unit,
p_trunk_diameter,
p_trunk_diameter_unit,
p_crown_diameter,
p_crown_diameter_unit,
p_lod1_brep_id,
p_lod2_brep_id,
p_lod3_brep_id,
p_lod4_brep_id,
p_lod1_other_geom,
p_lod2_other_geom,
p_lod3_other_geom,
p_lod4_other_geom,
p_lod1_implicit_rep_id,
p_lod2_implicit_rep_id,
p_lod3_implicit_rep_id,
p_lod4_implicit_rep_id,
p_lod1_implicit_ref_point,
p_lod2_implicit_ref_point,
p_lod3_implicit_ref_point,
p_lod4_implicit_ref_point,
p_lod1_implicit_transformation,
p_lod2_implicit_transformation,
p_lod3_implicit_transformation,
p_lod4_implicit_transformation
) INTO inserted_id;
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.insert_solitary_vegetat_object (id: %): %', p_id, SQLERRM;
END;
$$
LANGUAGE 'plpgsql';

----------------------------------------------------------------
-- Function INSERT_SURFACE_DATA
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_pkg.insert_surface_data (integer, varchar, varchar, varchar, varchar, varchar, numeric, integer, double precision, double precision, double precision, varchar, varchar, varchar, numeric, integer, varchar, varchar, varchar, numeric, varchar, geometry, varchar) CASCADE;
CREATE OR REPLACE FUNCTION citydb_pkg.insert_surface_data (
  objectclass_id        integer,
  id                    integer DEFAULT NULL,
  gmlid                 varchar DEFAULT NULL,
  gmlid_codespace       varchar DEFAULT NULL,
  name                  varchar DEFAULT NULL,
  name_codespace        varchar DEFAULT NULL,
  description           varchar DEFAULT NULL,
  is_front              numeric DEFAULT NULL,
  x3d_shininess         double precision DEFAULT NULL,
  x3d_transparency      double precision DEFAULT NULL,
  x3d_ambient_intensity double precision DEFAULT NULL,
  x3d_specular_color    varchar DEFAULT NULL,
  x3d_diffuse_color     varchar DEFAULT NULL,
  x3d_emissive_color    varchar DEFAULT NULL,
  x3d_is_smooth         numeric DEFAULT NULL,
  tex_image_id          integer DEFAULT NULL,
  tex_texture_type      varchar DEFAULT NULL,
  tex_wrap_mode         varchar DEFAULT NULL,
  tex_border_color      varchar DEFAULT NULL,
  gt_prefer_worldfile   numeric DEFAULT NULL,
  gt_orientation        varchar DEFAULT NULL,
  gt_reference_point    geometry DEFAULT NULL,
--
  schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer
AS
$$
DECLARE
  p_id                    integer          := id;
  p_gmlid                 varchar          := gmlid;
  p_gmlid_codespace       varchar          := gmlid_codespace;
  p_name                  varchar          := name;
  p_name_codespace        varchar          := name_codespace;
  p_description           varchar          := description;
  p_is_front              numeric          := is_front;
  p_objectclass_id        integer          := objectclass_id;
  p_x3d_shininess         double precision := x3d_shininess;
  p_x3d_transparency      double precision := x3d_transparency;
  p_x3d_ambient_intensity double precision := x3d_ambient_intensity;
  p_x3d_specular_color    varchar          := x3d_specular_color;
  p_x3d_diffuse_color     varchar          := x3d_diffuse_color;
  p_x3d_emissive_color    varchar          := x3d_emissive_color;
  p_x3d_is_smooth         numeric          := x3d_is_smooth;
  p_tex_image_id          integer          := tex_image_id;
  p_tex_texture_type      varchar          := tex_texture_type;
  p_tex_wrap_mode         varchar          := tex_wrap_mode;
  p_tex_border_color      varchar          := tex_border_color;
  p_gt_prefer_worldfile   numeric          := gt_prefer_worldfile;
  p_gt_orientation        varchar          := gt_orientation;
  p_gt_reference_point    geometry         := gt_reference_point;
--
  p_schema_name varchar := schema_name;
  seq_name                       varchar;
  inserted_id integer;
BEGIN
-- IF the ID is not given, then generate a new one.
IF p_id IS NULL THEN
  seq_name=schema_name||'.surface_data_seq';
  p_id=nextval(seq_name::regclass);
END IF;

-- IF the GmlID is not given, then generate a new one.
IF p_gmlid IS NULL THEN
  p_gmlid='UUID_'||uuid_generate_v4();
END IF;

EXECUTE format('
INSERT INTO %I.surface_data (
 id,
 gmlid,
 gmlid_codespace,
 name,
 name_codespace,
 description,
 is_front,
 objectclass_id,
 x3d_shininess,
 x3d_transparency,
 x3d_ambient_intensity,
 x3d_specular_color,
 x3d_diffuse_color,
 x3d_emissive_color,
 x3d_is_smooth,
 tex_image_id,
 tex_texture_type,
 tex_wrap_mode,
 tex_border_color,
 gt_prefer_worldfile,
 gt_orientation,
 gt_reference_point
) VALUES (
%L, %L, %L, %L, %L, %L, %L, %L, %L, %L,
%L, %L, %L, %L, %L, %L, %L, %L, %L, %L,
%L, %L
) RETURNING id',
p_schema_name,
p_id,
p_gmlid,
p_gmlid_codespace,
p_name,
p_name_codespace,
p_description,
p_is_front,
p_objectclass_id,
p_x3d_shininess,
p_x3d_transparency,
p_x3d_ambient_intensity,
p_x3d_specular_color,
p_x3d_diffuse_color,
p_x3d_emissive_color,
p_x3d_is_smooth,
p_tex_image_id,
p_tex_texture_type,
p_tex_wrap_mode,
p_tex_border_color,
p_gt_prefer_worldfile,
p_gt_orientation,
p_gt_reference_point
) INTO inserted_id;
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.insert_surface_data (id: %): %', p_id, SQLERRM;
END;
$$
LANGUAGE 'plpgsql';

----------------------------------------------------------------
-- Function INSERT_SURFACE_GEOMETRY
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_pkg.insert_surface_geometry (integer, varchar, varchar, integer, integer, numeric, numeric, numeric, numeric, numeric, geometry, geometry, geometry, integer, varchar) CASCADE;
CREATE OR REPLACE FUNCTION citydb_pkg.insert_surface_geometry (
  id                integer DEFAULT NULL,
  gmlid             varchar DEFAULT NULL,
  gmlid_codespace   varchar DEFAULT NULL,
  parent_id         integer DEFAULT NULL,
  root_id           integer DEFAULT NULL,
  is_solid          numeric DEFAULT NULL,
  is_composite      numeric DEFAULT NULL,
  is_triangulated   numeric DEFAULT NULL,
  is_xlink          numeric DEFAULT NULL,
  is_reverse        numeric DEFAULT NULL,
  solid_geometry    geometry DEFAULT NULL,
  geometry          geometry DEFAULT NULL,
  implicit_geometry geometry DEFAULT NULL,
  cityobject_id     integer DEFAULT NULL,
--
  schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer
AS
$$
DECLARE
  p_id                           integer  := id;
  p_gmlid                        varchar  := gmlid;
  p_gmlid_codespace              varchar  := gmlid_codespace;
  p_parent_id                    integer  := parent_id;
  p_root_id                      integer  := root_id;
  p_is_solid                     numeric  := is_solid;
  p_is_composite                 numeric  := is_composite;
  p_is_triangulated              numeric  := is_triangulated;
  p_is_xlink                     numeric  := is_xlink;
  p_is_reverse                   numeric  := is_reverse;
  p_solid_geometry               geometry := solid_geometry;
  p_geometry                     geometry := geometry;
  p_implicit_geometry            geometry := implicit_geometry;
  p_cityobject_id                integer  := cityobject_id;
--
  p_schema_name varchar := schema_name;
  seq_name                       varchar;
  inserted_id integer;
BEGIN
-- IF the ID is not given, then generate a new one.
IF p_id IS NULL THEN
  seq_name=schema_name||'.surface_geometry_seq';
  p_id=nextval(seq_name::regclass);
END IF;
-- IF the GmlID is not given, then generate a new one.
IF p_gmlid IS NULL THEN
  p_gmlid='UUID_'||uuid_generate_v4();
END IF;

EXECUTE format('
INSERT INTO %I.surface_geometry (
 id,
 gmlid,
 gmlid_codespace,
 parent_id,
 root_id,
 is_solid,
 is_composite,
 is_triangulated,
 is_xlink,
 is_reverse,
 solid_geometry,
 geometry,
 implicit_geometry,
 cityobject_id
) VALUES (
%L, %L, %L, %L, %L, %L, %L, %L, %L, %L,
%L, %L, %L, %L
) RETURNING id',
p_schema_name,
p_id,
p_gmlid,
p_gmlid_codespace,
p_parent_id,
p_root_id,
p_is_solid,
p_is_composite,
p_is_triangulated,
p_is_xlink,
p_is_reverse,
p_solid_geometry,
p_geometry,
p_implicit_geometry,
p_cityobject_id
) INTO inserted_id;
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.insert_surface_geometry (id: %): %', p_id, SQLERRM;
END;
$$
LANGUAGE 'plpgsql';

----------------------------------------------------------------
-- Function INSERT_TEX_IMAGE
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_pkg.insert_tex_image (integer, varchar, bytea, varchar, varchar, varchar) CASCADE;
CREATE OR REPLACE FUNCTION citydb_pkg.insert_tex_image (
  id                             integer DEFAULT NULL,
  tex_image_uri                  varchar DEFAULT NULL,
  tex_image_data                 bytea   DEFAULT NULL,
  tex_mime_type                  varchar DEFAULT NULL,
  tex_mime_type_codespace        varchar DEFAULT NULL,
--
  schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer
AS
$$
DECLARE
  p_id                      integer := id;
  p_tex_image_uri           varchar := tex_image_uri;
  p_tex_image_data          bytea   := tex_image_data;
  p_tex_mime_type           varchar := tex_mime_type;
  p_tex_mime_type_codespace varchar := tex_mime_type_codespace;
--
  p_schema_name varchar := schema_name;
  seq_name                       varchar;
  inserted_id integer;
BEGIN
-- IF the ID is not given, then generate a new one.
IF p_id IS NULL THEN
  seq_name=schema_name||'.tex_image_seq';
  p_id=nextval(seq_name::regclass);
END IF;

EXECUTE format('
INSERT INTO %I.tex_image (
 id,
 tex_image_uri,
 tex_image_data,
 tex_mime_type,
 tex_mime_type_codespace
) VALUES (
%L, %L, %L, %L, %L
) RETURNING id',
p_schema_name,
p_id,
p_tex_image_uri,
p_tex_image_data,
p_tex_mime_type,
p_tex_mime_type_codespace
) INTO inserted_id;
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.insert_tex_image (id: %): %', p_id, SQLERRM;
END;
$$
LANGUAGE 'plpgsql';

----------------------------------------------------------------
-- Function INSERT_THEMATIC_SURFACE
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_pkg.insert_thematic_surface (integer, integer, integer, integer, integer, integer, integer, integer, varchar) CASCADE;
CREATE OR REPLACE FUNCTION citydb_pkg.insert_thematic_surface (
  id                       integer,
  objectclass_id           integer,
  building_id              integer DEFAULT NULL,
  room_id                  integer DEFAULT NULL,
  building_installation_id integer DEFAULT NULL,
  lod2_multi_surface_id    integer DEFAULT NULL,
  lod3_multi_surface_id    integer DEFAULT NULL,
  lod4_multi_surface_id    integer DEFAULT NULL,
--
  schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer
AS
$$
DECLARE
  p_id                       integer := id;
  p_objectclass_id           integer := objectclass_id;
  p_building_id              integer := building_id;
  p_room_id                  integer := room_id;
  p_building_installation_id integer := building_installation_id;
  p_lod2_multi_surface_id    integer := lod2_multi_surface_id;
  p_lod3_multi_surface_id    integer := lod3_multi_surface_id;
  p_lod4_multi_surface_id    integer := lod4_multi_surface_id;
--
  p_schema_name varchar := schema_name;
  inserted_id integer;
BEGIN

EXECUTE format('
INSERT INTO %I.thematic_surface (
 id,
 objectclass_id,
 building_id,
 room_id,
 building_installation_id,
 lod2_multi_surface_id,
 lod3_multi_surface_id,
 lod4_multi_surface_id
) VALUES (
%L, %L, %L, %L, %L, %L, %L, %L
) RETURNING id',
p_schema_name,
p_id,
p_objectclass_id,
p_building_id,
p_room_id,
p_building_installation_id,
p_lod2_multi_surface_id,
p_lod3_multi_surface_id,
p_lod4_multi_surface_id
) INTO inserted_id;
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.insert_thematic_surface (id: %): %', p_id, SQLERRM;
END;
$$
LANGUAGE 'plpgsql';

----------------------------------------------------------------
-- Function INSERT_TIN_RELIEF
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_pkg.insert_tin_relief (integer, double precision, varchar, geometry, geometry, geometry, integer, varchar) CASCADE;
CREATE OR REPLACE FUNCTION citydb_pkg.insert_tin_relief (
  id                  integer,
  max_length          double precision DEFAULT NULL,
  max_length_unit     varchar  DEFAULT NULL,
  stop_lines          geometry DEFAULT NULL,
  break_lines         geometry DEFAULT NULL,
  control_points      geometry DEFAULT NULL,
  surface_geometry_id integer  DEFAULT NULL,
--
  schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer
AS
$$
DECLARE
  p_id                  integer          := id;
  p_max_length          double precision := max_length;
  p_max_length_unit     varchar          := max_length_unit;
  p_stop_lines          geometry         := stop_lines;
  p_break_lines         geometry         := break_lines;
  p_control_points      geometry         := control_points;
  p_surface_geometry_id integer          := surface_geometry_id;
--
  p_schema_name varchar := schema_name;
  inserted_id integer;
BEGIN

EXECUTE format('
INSERT INTO %I.tin_relief (
 id,
 max_length,
 max_length_unit,
 stop_lines,
 break_lines,
 control_points,
 surface_geometry_id
) VALUES (
%L, %L, %L, %L, %L, %L, %L
) RETURNING id',
p_schema_name,
p_id,
p_max_length,
p_max_length_unit,
p_stop_lines,
p_break_lines,
p_control_points,
p_surface_geometry_id
) INTO inserted_id;
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.insert_tin_relief (id: %): %', p_id, SQLERRM;
END;
$$
LANGUAGE 'plpgsql';

----------------------------------------------------------------
-- Function INSERT_TRAFFIC_AREA
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_pkg.insert_traffic_area (integer, integer, varchar, varchar, varchar, varchar, varchar, varchar, varchar, varchar, integer, integer, integer, integer, varchar) CASCADE;
CREATE OR REPLACE FUNCTION citydb_pkg.insert_traffic_area (
  id                             integer,
  objectclass_id                 integer,
  class                          varchar DEFAULT NULL,
  class_codespace                varchar DEFAULT NULL,
  function                       varchar DEFAULT NULL,
  function_codespace             varchar DEFAULT NULL,
  usage                          varchar DEFAULT NULL,
  usage_codespace                varchar DEFAULT NULL,
  surface_material               varchar DEFAULT NULL,
  surface_material_codespace     varchar DEFAULT NULL,
  lod2_multi_surface_id          integer DEFAULT NULL,
  lod3_multi_surface_id          integer DEFAULT NULL,
  lod4_multi_surface_id          integer DEFAULT NULL,
  transportation_complex_id      integer DEFAULT NULL,
--
  schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer
AS
$$
DECLARE
  p_id                           integer := id;
  p_objectclass_id               integer := objectclass_id;
  p_class                        varchar := class;
  p_class_codespace              varchar := class_codespace;
  p_function                     varchar := function;
  p_function_codespace           varchar := function_codespace;
  p_usage                        varchar := usage;
  p_usage_codespace              varchar := usage_codespace;
  p_surface_material             varchar := surface_material;
  p_surface_material_codespace   varchar := surface_material_codespace;
  p_lod2_multi_surface_id        integer := lod2_multi_surface_id;
  p_lod3_multi_surface_id        integer := lod3_multi_surface_id;
  p_lod4_multi_surface_id        integer := lod4_multi_surface_id;
  p_transportation_complex_id    integer := transportation_complex_id;
--
  p_schema_name varchar := schema_name;
  inserted_id integer;
BEGIN

EXECUTE format('
INSERT INTO %I.traffic_area (
 id,
 objectclass_id,
 class,
 class_codespace,
 function,
 function_codespace,
 usage,
 usage_codespace,
 surface_material,
 surface_material_codespace,
 lod2_multi_surface_id,
 lod3_multi_surface_id,
 lod4_multi_surface_id,
 transportation_complex_id
) VALUES (
%L, %L, %L, %L, %L, %L, %L, %L, %L, %L,
%L, %L, %L, %L
) RETURNING id',
p_schema_name,
p_id,
p_objectclass_id,
p_class,
p_class_codespace,
p_function,
p_function_codespace,
p_usage,
p_usage_codespace,
p_surface_material,
p_surface_material_codespace,
p_lod2_multi_surface_id,
p_lod3_multi_surface_id,
p_lod4_multi_surface_id,
p_transportation_complex_id
) INTO inserted_id;
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.insert_traffic_area (id: %): %', p_id, SQLERRM;
END;
$$
LANGUAGE 'plpgsql';

----------------------------------------------------------------
-- Function INSERT_TRANSPORTATION_COMPLEX
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_pkg.insert_transportation_complex (integer, integer, varchar, varchar, varchar, varchar, varchar, varchar, geometry, integer, integer, integer, integer, varchar) CASCADE;
CREATE OR REPLACE FUNCTION citydb_pkg.insert_transportation_complex (
  id                             integer,
  objectclass_id                 integer,
  class                          varchar DEFAULT NULL,
  class_codespace                varchar DEFAULT NULL,
  function                       varchar DEFAULT NULL,
  function_codespace             varchar DEFAULT NULL,
  usage                          varchar DEFAULT NULL,
  usage_codespace                varchar DEFAULT NULL,
  lod0_network                   geometry DEFAULT NULL,
  lod1_multi_surface_id          integer DEFAULT NULL,
  lod2_multi_surface_id          integer DEFAULT NULL,
  lod3_multi_surface_id          integer DEFAULT NULL,
  lod4_multi_surface_id          integer DEFAULT NULL,
--
  schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer
AS
$$
DECLARE
  p_id                           integer  := id;
  p_objectclass_id               integer  := objectclass_id;
  p_class                        varchar  := class;
  p_class_codespace              varchar  := class_codespace;
  p_function                     varchar  := function;
  p_function_codespace           varchar  := function_codespace;
  p_usage                        varchar  := usage;
  p_usage_codespace              varchar  := usage_codespace;
  p_lod0_network                 geometry := lod0_network;
  p_lod1_multi_surface_id        integer  := lod1_multi_surface_id;
  p_lod2_multi_surface_id        integer  := lod2_multi_surface_id;
  p_lod3_multi_surface_id        integer  := lod3_multi_surface_id;
  p_lod4_multi_surface_id        integer  := lod4_multi_surface_id;
--
  p_schema_name varchar := schema_name;
  inserted_id integer;
BEGIN

EXECUTE format('
INSERT INTO %I.transportation_complex (
 id,
 objectclass_id,
 class,
 class_codespace,
 function,
 function_codespace,
 usage,
 usage_codespace,
 lod0_network,
 lod1_multi_surface_id,
 lod2_multi_surface_id,
 lod3_multi_surface_id,
 lod4_multi_surface_id
) VALUES (
%L, %L, %L, %L, %L, %L, %L, %L, %L, %L,
%L, %L, %L
) RETURNING id',
p_schema_name,
p_id,
p_objectclass_id,
p_class,
p_class_codespace,
p_function,
p_function_codespace,
p_usage,
p_usage_codespace,
p_lod0_network,
p_lod1_multi_surface_id,
p_lod2_multi_surface_id,
p_lod3_multi_surface_id,
p_lod4_multi_surface_id
) INTO inserted_id;
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.insert_transportation_complex (id: %): %', p_id, SQLERRM;
END;
$$
LANGUAGE 'plpgsql';

----------------------------------------------------------------
-- Function INSERT_TUNNEL
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_pkg.insert_tunnel (integer, integer, integer, varchar, varchar, varchar, varchar, varchar, varchar, date, date, geometry, geometry, geometry, geometry, geometry, geometry, geometry, integer, integer, integer, integer, integer, integer, integer, integer, varchar) CASCADE;
CREATE OR REPLACE FUNCTION citydb_pkg.insert_tunnel (
  id                             integer,
  tunnel_parent_id               integer DEFAULT NULL,
  tunnel_root_id                 integer DEFAULT NULL,
  class                          varchar DEFAULT NULL,
  class_codespace                varchar DEFAULT NULL,
  function                       varchar DEFAULT NULL,
  function_codespace             varchar DEFAULT NULL,
  usage                          varchar DEFAULT NULL,
  usage_codespace                varchar DEFAULT NULL,
  year_of_construction           date DEFAULT NULL,
  year_of_demolition             date DEFAULT NULL,
  lod1_terrain_intersection      geometry DEFAULT NULL,
  lod2_terrain_intersection      geometry DEFAULT NULL,
  lod3_terrain_intersection      geometry DEFAULT NULL,
  lod4_terrain_intersection      geometry DEFAULT NULL,
  lod2_multi_curve               geometry DEFAULT NULL,
  lod3_multi_curve               geometry DEFAULT NULL,
  lod4_multi_curve               geometry DEFAULT NULL,
  lod1_multi_surface_id          integer DEFAULT NULL,
  lod2_multi_surface_id          integer DEFAULT NULL,
  lod3_multi_surface_id          integer DEFAULT NULL,
  lod4_multi_surface_id          integer DEFAULT NULL,
  lod1_solid_id                  integer DEFAULT NULL,
  lod2_solid_id                  integer DEFAULT NULL,
  lod3_solid_id                  integer DEFAULT NULL,
  lod4_solid_id                  integer DEFAULT NULL,
--
  schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer
AS
$$
DECLARE
  p_id                           integer  := id;
  p_tunnel_parent_id             integer  := tunnel_parent_id;
  p_tunnel_root_id               integer  := tunnel_root_id;
  p_class                        varchar  := class;
  p_class_codespace              varchar  := class_codespace;
  p_function                     varchar  := function;
  p_function_codespace           varchar  := function_codespace;
  p_usage                        varchar  := usage;
  p_usage_codespace              varchar  := usage_codespace;
  p_year_of_construction         date     := year_of_construction;
  p_year_of_demolition           date     := year_of_demolition;
  p_lod1_terrain_intersection    geometry := lod1_terrain_intersection;
  p_lod2_terrain_intersection    geometry := lod2_terrain_intersection;
  p_lod3_terrain_intersection    geometry := lod3_terrain_intersection;
  p_lod4_terrain_intersection    geometry := lod4_terrain_intersection;
  p_lod2_multi_curve             geometry := lod2_multi_curve;
  p_lod3_multi_curve             geometry := lod3_multi_curve;
  p_lod4_multi_curve             geometry := lod4_multi_curve;
  p_lod1_multi_surface_id        integer  := lod1_multi_surface_id;
  p_lod2_multi_surface_id        integer  := lod2_multi_surface_id;
  p_lod3_multi_surface_id        integer  := lod3_multi_surface_id;
  p_lod4_multi_surface_id        integer  := lod4_multi_surface_id;
  p_lod1_solid_id                integer  := lod1_solid_id;
  p_lod2_solid_id                integer  := lod2_solid_id;
  p_lod3_solid_id                integer  := lod3_solid_id;
  p_lod4_solid_id                integer  := lod4_solid_id;
--
  p_schema_name varchar := schema_name;
  inserted_id integer;
BEGIN

EXECUTE format('
INSERT INTO %I.tunnel (
 id,
 tunnel_parent_id,
 tunnel_root_id,
 class,
 class_codespace,
 function,
 function_codespace,
 usage,
 usage_codespace,
 year_of_construction,
 year_of_demolition,
 lod1_terrain_intersection,
 lod2_terrain_intersection,
 lod3_terrain_intersection,
 lod4_terrain_intersection,
 lod2_multi_curve,
 lod3_multi_curve,
 lod4_multi_curve,
 lod1_multi_surface_id,
 lod2_multi_surface_id,
 lod3_multi_surface_id,
 lod4_multi_surface_id,
 lod1_solid_id,
 lod2_solid_id,
 lod3_solid_id,
 lod4_solid_id
) VALUES (
%L, %L, %L, %L, %L, %L, %L, %L, %L, %L,
%L, %L, %L, %L, %L, %L, %L, %L, %L, %L,
%L, %L, %L, %L, %L, %L
) RETURNING id',
p_schema_name,
p_id,
p_tunnel_parent_id,
p_tunnel_root_id,
p_class,
p_class_codespace,
p_function,
p_function_codespace,
p_usage,
p_usage_codespace,
p_year_of_construction,
p_year_of_demolition,
p_lod1_terrain_intersection,
p_lod2_terrain_intersection,
p_lod3_terrain_intersection,
p_lod4_terrain_intersection,
p_lod2_multi_curve,
p_lod3_multi_curve,
p_lod4_multi_curve,
p_lod1_multi_surface_id,
p_lod2_multi_surface_id,
p_lod3_multi_surface_id,
p_lod4_multi_surface_id,
p_lod1_solid_id,
p_lod2_solid_id,
p_lod3_solid_id,
p_lod4_solid_id
) INTO inserted_id;
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.insert_tunnel (id: %): %', p_id, SQLERRM;
END;
$$
LANGUAGE 'plpgsql';

----------------------------------------------------------------
-- Function INSERT_TUNNEL_FURNITURE
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_pkg.insert_tunnel_furniture (integer, varchar, varchar, varchar, varchar, varchar, varchar, integer, integer, geometry, integer, geometry, varchar, varchar) CASCADE;
CREATE OR REPLACE FUNCTION citydb_pkg.insert_tunnel_furniture (
  id                             integer,
  class                          varchar DEFAULT NULL,
  class_codespace                varchar DEFAULT NULL,
  function                       varchar DEFAULT NULL,
  function_codespace             varchar DEFAULT NULL,
  usage                          varchar DEFAULT NULL,
  usage_codespace                varchar DEFAULT NULL,
  tunnel_hollow_space_id         integer DEFAULT NULL,
  lod4_brep_id                   integer DEFAULT NULL,
  lod4_other_geom                geometry DEFAULT NULL,
  lod4_implicit_rep_id           integer DEFAULT NULL,
  lod4_implicit_ref_point        geometry DEFAULT NULL,
  lod4_implicit_transformation   varchar DEFAULT NULL,
--
  schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer
AS
$$
DECLARE
  p_id                           integer  := id;
  p_class                        varchar  := class;
  p_class_codespace              varchar  := class_codespace;
  p_function                     varchar  := function;
  p_function_codespace           varchar  := function_codespace;
  p_usage                        varchar  := usage;
  p_usage_codespace              varchar  := usage_codespace;
  p_tunnel_hollow_space_id       integer  := tunnel_hollow_space_id;
  p_lod4_brep_id                 integer  := lod4_brep_id;
  p_lod4_other_geom              geometry := lod4_other_geom;
  p_lod4_implicit_rep_id         integer  := lod4_implicit_rep_id;
  p_lod4_implicit_ref_point      geometry := lod4_implicit_ref_point;
  p_lod4_implicit_transformation varchar  := lod4_implicit_transformation;
--
  p_schema_name varchar := schema_name;
  inserted_id integer;
BEGIN

EXECUTE format('
INSERT INTO %I.tunnel_furniture (
 id,
 class,
 class_codespace,
 function,
 function_codespace,
 usage,
 usage_codespace,
 tunnel_hollow_space_id,
 lod4_brep_id,
 lod4_other_geom,
 lod4_implicit_rep_id,
 lod4_implicit_ref_point,
 lod4_implicit_transformation
) VALUES (
%L, %L, %L, %L, %L, %L, %L, %L, %L, %L,
%L, %L, %L
) RETURNING id',
p_schema_name,
p_id,
p_class,
p_class_codespace,
p_function,
p_function_codespace,
p_usage,
p_usage_codespace,
p_tunnel_hollow_space_id,
p_lod4_brep_id,
p_lod4_other_geom,
p_lod4_implicit_rep_id,
p_lod4_implicit_ref_point,
p_lod4_implicit_transformation
) INTO inserted_id;
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.insert_tunnel_furniture (id: %): %', p_id, SQLERRM;
END;
$$
LANGUAGE 'plpgsql';

----------------------------------------------------------------
-- Function INSERT_TUNNEL_HOLLOW_SPACE
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_pkg.insert_tunnel_hollow_space (integer, varchar, varchar, varchar, varchar, varchar, varchar, integer, integer, integer, varchar) CASCADE;
CREATE OR REPLACE FUNCTION citydb_pkg.insert_tunnel_hollow_space (
  id                    integer,
  class                 varchar DEFAULT NULL,
  class_codespace       varchar DEFAULT NULL,
  function              varchar DEFAULT NULL,
  function_codespace    varchar DEFAULT NULL,
  usage                 varchar DEFAULT NULL,
  usage_codespace       varchar DEFAULT NULL,
  tunnel_id             integer DEFAULT NULL,
  lod4_multi_surface_id integer DEFAULT NULL,
  lod4_solid_id         integer DEFAULT NULL,
--
  schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer
AS
$$
DECLARE
  p_id                    integer := id;
  p_class                 varchar := class;
  p_class_codespace       varchar := class_codespace;
  p_function              varchar := function;
  p_function_codespace    varchar := function_codespace;
  p_usage                 varchar := usage;
  p_usage_codespace       varchar := usage_codespace;
  p_tunnel_id             integer := tunnel_id;
  p_lod4_multi_surface_id integer := lod4_multi_surface_id;
  p_lod4_solid_id         integer := lod4_solid_id;
--
  p_schema_name varchar := schema_name;
  inserted_id integer;
BEGIN

EXECUTE format('
INSERT INTO %I.tunnel_hollow_space (
 id,
 class,
 class_codespace,
 function,
 function_codespace,
 usage,
 usage_codespace,
 tunnel_id,
 lod4_multi_surface_id,
 lod4_solid_id
) VALUES (
%L, %L, %L, %L, %L, %L, %L, %L, %L, %L
) RETURNING id',
p_schema_name,
p_id,
p_class,
p_class_codespace,
p_function,
p_function_codespace,
p_usage,
p_usage_codespace,
p_tunnel_id,
p_lod4_multi_surface_id,
p_lod4_solid_id
) INTO inserted_id;
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.insert_tunnel_hollow_space (id: %): %', p_id, SQLERRM;
END;
$$
LANGUAGE 'plpgsql';

----------------------------------------------------------------
-- Function INSERT_TUNNEL_INSTALLATION
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_pkg.insert_tunnel_installation (integer, integer, varchar, varchar, varchar, varchar, varchar, varchar, integer, integer, integer, integer, integer, geometry, geometry, geometry, integer, integer, integer, geometry, geometry, geometry, varchar, varchar, varchar, varchar) CASCADE;
CREATE OR REPLACE FUNCTION citydb_pkg.insert_tunnel_installation (
  objectclass_id                 integer,
  id                             integer,
  class                          varchar DEFAULT NULL,
  class_codespace                varchar DEFAULT NULL,
  function                       varchar DEFAULT NULL,
  function_codespace             varchar DEFAULT NULL,
  usage                          varchar DEFAULT NULL,
  usage_codespace                varchar DEFAULT NULL,
  tunnel_id                      integer DEFAULT NULL,
  tunnel_hollow_space_id         integer DEFAULT NULL,
  lod2_brep_id                   integer DEFAULT NULL,
  lod3_brep_id                   integer DEFAULT NULL,
  lod4_brep_id                   integer DEFAULT NULL,
  lod2_other_geom                geometry DEFAULT NULL,
  lod3_other_geom                geometry DEFAULT NULL,
  lod4_other_geom                geometry DEFAULT NULL,
  lod2_implicit_rep_id           integer DEFAULT NULL,
  lod3_implicit_rep_id           integer DEFAULT NULL,
  lod4_implicit_rep_id           integer DEFAULT NULL,
  lod2_implicit_ref_point        geometry DEFAULT NULL,
  lod3_implicit_ref_point        geometry DEFAULT NULL,
  lod4_implicit_ref_point        geometry DEFAULT NULL,
  lod2_implicit_transformation   varchar DEFAULT NULL,
  lod3_implicit_transformation   varchar DEFAULT NULL,
  lod4_implicit_transformation   varchar DEFAULT NULL,
--
  schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer
AS
$$
DECLARE
  p_id                           integer  := id;
  p_objectclass_id               integer  := objectclass_id;
  p_class                        varchar  := class;
  p_class_codespace              varchar  := class_codespace;
  p_function                     varchar  := function;
  p_function_codespace           varchar  := function_codespace;
  p_usage                        varchar  := usage;
  p_usage_codespace              varchar  := usage_codespace;
  p_tunnel_id                    integer  := tunnel_id;
  p_tunnel_hollow_space_id       integer  := tunnel_hollow_space_id;
  p_lod2_brep_id                 integer  := lod2_brep_id;
  p_lod3_brep_id                 integer  := lod3_brep_id;
  p_lod4_brep_id                 integer  := lod4_brep_id;
  p_lod2_other_geom              geometry := lod2_other_geom;
  p_lod3_other_geom              geometry := lod3_other_geom;
  p_lod4_other_geom              geometry := lod4_other_geom;
  p_lod2_implicit_rep_id         integer  := lod2_implicit_rep_id;
  p_lod3_implicit_rep_id         integer  := lod3_implicit_rep_id;
  p_lod4_implicit_rep_id         integer  := lod4_implicit_rep_id;
  p_lod2_implicit_ref_point      geometry := lod2_implicit_ref_point;
  p_lod3_implicit_ref_point      geometry := lod3_implicit_ref_point;
  p_lod4_implicit_ref_point      geometry := lod4_implicit_ref_point;
  p_lod2_implicit_transformation varchar  := lod2_implicit_transformation;
  p_lod3_implicit_transformation varchar  := lod3_implicit_transformation;
  p_lod4_implicit_transformation varchar  := lod4_implicit_transformation;
--
  p_schema_name varchar := schema_name;
  inserted_id integer;
BEGIN

EXECUTE format('
INSERT INTO %I.tunnel_installation (
 id,
 objectclass_id,
 class,
 class_codespace,
 function,
 function_codespace,
 usage,
 usage_codespace,
 tunnel_id,
 tunnel_hollow_space_id,
 lod2_brep_id,
 lod3_brep_id,
 lod4_brep_id,
 lod2_other_geom,
 lod3_other_geom,
 lod4_other_geom,
 lod2_implicit_rep_id,
 lod3_implicit_rep_id,
 lod4_implicit_rep_id,
 lod2_implicit_ref_point,
 lod3_implicit_ref_point,
 lod4_implicit_ref_point,
 lod2_implicit_transformation,
 lod3_implicit_transformation,
 lod4_implicit_transformation
) VALUES (
%L, %L, %L, %L, %L, %L, %L, %L, %L, %L,
%L, %L, %L, %L, %L, %L, %L, %L, %L, %L,
%L, %L, %L, %L, %L
) RETURNING id',
p_schema_name,
p_id,
p_objectclass_id,
p_class,
p_class_codespace,
p_function,
p_function_codespace,
p_usage,
p_usage_codespace,
p_tunnel_id,
p_tunnel_hollow_space_id,
p_lod2_brep_id,
p_lod3_brep_id,
p_lod4_brep_id,
p_lod2_other_geom,
p_lod3_other_geom,
p_lod4_other_geom,
p_lod2_implicit_rep_id,
p_lod3_implicit_rep_id,
p_lod4_implicit_rep_id,
p_lod2_implicit_ref_point,
p_lod3_implicit_ref_point,
p_lod4_implicit_ref_point,
p_lod2_implicit_transformation,
p_lod3_implicit_transformation,
p_lod4_implicit_transformation
) INTO inserted_id;
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.insert_tunnel_installation (id: %): %', p_id, SQLERRM;
END;
$$
LANGUAGE 'plpgsql';

----------------------------------------------------------------
-- Function INSERT_TUNNEL_OPEN_TO_THEM_SRF
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_pkg.insert_tunnel_open_to_them_srf (integer, integer, varchar) CASCADE;
CREATE OR REPLACE FUNCTION citydb_pkg.insert_tunnel_open_to_them_srf (
  tunnel_opening_id              integer,
  tunnel_thematic_surface_id     integer,
--
  schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS void
AS
$$
DECLARE
  p_tunnel_opening_id            integer := tunnel_opening_id;
  p_tunnel_thematic_surface_id   integer := tunnel_thematic_surface_id;
--
  p_schema_name varchar := schema_name;
BEGIN

EXECUTE format('
INSERT INTO %I.tunnel_open_to_them_srf (
 tunnel_opening_id,
 tunnel_thematic_surface_id
) VALUES (
%L, %L
)',
p_schema_name,
p_tunnel_opening_id,
p_tunnel_thematic_surface_id
);
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.insert_tunnel_open_to_them_srf (tunnel_opening_id: %, tunnel_thematic_surface_id: % ): %', p_tunnel_opening_id, p_tunnel_thematic_surface_id, SQLERRM;
END;
$$
LANGUAGE 'plpgsql';

----------------------------------------------------------------
-- Function INSERT_TUNNEL_OPENING
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_pkg.insert_tunnel_opening (integer, integer, integer, integer, integer, integer, geometry, geometry, varchar, varchar, varchar) CASCADE;
CREATE OR REPLACE FUNCTION citydb_pkg.insert_tunnel_opening (
  objectclass_id                 integer,
  id                             integer,
  lod3_multi_surface_id          integer DEFAULT NULL,
  lod4_multi_surface_id          integer DEFAULT NULL,
  lod3_implicit_rep_id           integer DEFAULT NULL,
  lod4_implicit_rep_id           integer DEFAULT NULL,
  lod3_implicit_ref_point        geometry DEFAULT NULL,
  lod4_implicit_ref_point        geometry DEFAULT NULL,
  lod3_implicit_transformation   varchar DEFAULT NULL,
  lod4_implicit_transformation   varchar DEFAULT NULL,
--
  schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer
AS
$$
DECLARE
  p_id                           integer  := id;
  p_objectclass_id               integer  := objectclass_id;
  p_lod3_multi_surface_id        integer  := lod3_multi_surface_id;
  p_lod4_multi_surface_id        integer  := lod4_multi_surface_id;
  p_lod3_implicit_rep_id         integer  := lod3_implicit_rep_id;
  p_lod4_implicit_rep_id         integer  := lod4_implicit_rep_id;
  p_lod3_implicit_ref_point      geometry := lod3_implicit_ref_point;
  p_lod4_implicit_ref_point      geometry := lod4_implicit_ref_point;
  p_lod3_implicit_transformation varchar  := lod3_implicit_transformation;
  p_lod4_implicit_transformation varchar  := lod4_implicit_transformation;
--
  p_schema_name varchar := schema_name;
  inserted_id integer;
BEGIN

EXECUTE format('
INSERT INTO %I.tunnel_opening (
 id,
 objectclass_id,
 lod3_multi_surface_id,
 lod4_multi_surface_id,
 lod3_implicit_rep_id,
 lod4_implicit_rep_id,
 lod3_implicit_ref_point,
 lod4_implicit_ref_point,
 lod3_implicit_transformation,
 lod4_implicit_transformation
) VALUES (
%L, %L, %L, %L, %L, %L, %L, %L, %L, %L
) RETURNING id',
p_schema_name,
p_id,
p_objectclass_id,
p_lod3_multi_surface_id,
p_lod4_multi_surface_id,
p_lod3_implicit_rep_id,
p_lod4_implicit_rep_id,
p_lod3_implicit_ref_point,
p_lod4_implicit_ref_point,
p_lod3_implicit_transformation,
p_lod4_implicit_transformation
) INTO inserted_id;
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.insert_tunnel_opening (id: %): %', p_id, SQLERRM;
END;
$$
LANGUAGE 'plpgsql';

----------------------------------------------------------------
-- Function INSERT_TUNNEL_THEMATIC_SURFACE
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_pkg.insert_tunnel_thematic_surface (integer, integer, integer, integer, integer, integer, integer, integer, varchar) CASCADE;
CREATE OR REPLACE FUNCTION citydb_pkg.insert_tunnel_thematic_surface (
  id                     integer,
  objectclass_id         integer,
  tunnel_id              integer DEFAULT NULL,
  tunnel_hollow_space_id integer DEFAULT NULL,
  tunnel_installation_id integer DEFAULT NULL,
  lod2_multi_surface_id  integer DEFAULT NULL,
  lod3_multi_surface_id  integer DEFAULT NULL,
  lod4_multi_surface_id  integer DEFAULT NULL,
--
  schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer
AS
$$
DECLARE
  p_id                     integer := id;
  p_objectclass_id         integer := objectclass_id;
  p_tunnel_id              integer := tunnel_id;
  p_tunnel_hollow_space_id integer := tunnel_hollow_space_id;
  p_tunnel_installation_id integer := tunnel_installation_id;
  p_lod2_multi_surface_id  integer := lod2_multi_surface_id;
  p_lod3_multi_surface_id  integer := lod3_multi_surface_id;
  p_lod4_multi_surface_id  integer := lod4_multi_surface_id;
--
  p_schema_name varchar := schema_name;
  inserted_id integer;
BEGIN

EXECUTE format('
INSERT INTO %I.tunnel_thematic_surface (
 id,
 objectclass_id,
 tunnel_id,
 tunnel_hollow_space_id,
 tunnel_installation_id,
 lod2_multi_surface_id,
 lod3_multi_surface_id,
 lod4_multi_surface_id
) VALUES (
%L, %L, %L, %L, %L, %L, %L, %L
) RETURNING id',
p_schema_name,
p_id,
p_objectclass_id,
p_tunnel_id,
p_tunnel_hollow_space_id,
p_tunnel_installation_id,
p_lod2_multi_surface_id,
p_lod3_multi_surface_id,
p_lod4_multi_surface_id
) INTO inserted_id;
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.insert_tunnel_thematic_surface (id: %): %', p_id, SQLERRM;
END;
$$
LANGUAGE 'plpgsql';

----------------------------------------------------------------
-- Function INSERT_WATERBOD_TO_WATERBND_SRF
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_pkg.insert_waterbod_to_waterbnd_srf (integer, integer, varchar) CASCADE;
CREATE OR REPLACE FUNCTION citydb_pkg.insert_waterbod_to_waterbnd_srf (
  waterboundary_surface_id       integer,
  waterbody_id                   integer,
--
  schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS void
AS
$$
DECLARE
  p_waterboundary_surface_id integer := waterboundary_surface_id;
  p_waterbody_id             integer := waterbody_id;
--
  p_schema_name varchar := schema_name;
BEGIN

EXECUTE format('
INSERT INTO %I.waterbod_to_waterbnd_srf (
 waterboundary_surface_id,
 waterbody_id
) VALUES (
%L, %L
)',
p_schema_name,
p_waterboundary_surface_id,
p_waterbody_id
);
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.insert_waterbod_to_waterbnd_srf (waterboundary_surface_id: %, waterbody_id: %): %', p_waterboundary_surface_id, waterbody_id, SQLERRM;
END;
$$
LANGUAGE 'plpgsql';

----------------------------------------------------------------
-- Function INSERT_WATERBODY
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_pkg.insert_waterbody (integer, varchar, varchar, varchar, varchar, varchar, varchar, geometry, geometry, integer, integer, integer, integer, integer, integer, varchar) CASCADE;
CREATE OR REPLACE FUNCTION citydb_pkg.insert_waterbody (
  id                    integer,
  class                 varchar DEFAULT NULL,
  class_codespace       varchar DEFAULT NULL,
  function              varchar DEFAULT NULL,
  function_codespace    varchar DEFAULT NULL,
  usage                 varchar DEFAULT NULL,
  usage_codespace       varchar DEFAULT NULL,
  lod0_multi_curve      geometry DEFAULT NULL,
  lod1_multi_curve      geometry DEFAULT NULL,
  lod0_multi_surface_id integer DEFAULT NULL,
  lod1_multi_surface_id integer DEFAULT NULL,
  lod1_solid_id         integer DEFAULT NULL,
  lod2_solid_id         integer DEFAULT NULL,
  lod3_solid_id         integer DEFAULT NULL,
  lod4_solid_id         integer DEFAULT NULL,
--
  schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer
AS
$$
DECLARE
  p_id                    integer  := id;
  p_class                 varchar  := class;
  p_class_codespace       varchar  := class_codespace;
  p_function              varchar  := function;
  p_function_codespace    varchar  := function_codespace;
  p_usage                 varchar  := usage;
  p_usage_codespace       varchar  := usage_codespace;
  p_lod0_multi_curve      geometry := lod0_multi_curve;
  p_lod1_multi_curve      geometry := lod1_multi_curve;
  p_lod0_multi_surface_id integer  := lod0_multi_surface_id;
  p_lod1_multi_surface_id integer  := lod1_multi_surface_id;
  p_lod1_solid_id         integer  := lod1_solid_id;
  p_lod2_solid_id         integer  := lod2_solid_id;
  p_lod3_solid_id         integer  := lod3_solid_id;
  p_lod4_solid_id         integer  := lod4_solid_id;
--
  p_schema_name varchar := schema_name;
  inserted_id integer;
BEGIN

EXECUTE format('
INSERT INTO %I.waterbody (
 id,
 class,
 class_codespace,
 function,
 function_codespace,
 usage,
 usage_codespace,
 lod0_multi_curve,
 lod1_multi_curve,
 lod0_multi_surface_id,
 lod1_multi_surface_id,
 lod1_solid_id,
 lod2_solid_id,
 lod3_solid_id,
 lod4_solid_id
) VALUES (
%L, %L, %L, %L, %L, %L, %L, %L, %L, %L,
%L, %L, %L, %L, %L
) RETURNING id',
p_schema_name,
p_id,
p_class,
p_class_codespace,
p_function,
p_function_codespace,
p_usage,
p_usage_codespace,
p_lod0_multi_curve,
p_lod1_multi_curve,
p_lod0_multi_surface_id,
p_lod1_multi_surface_id,
p_lod1_solid_id,
p_lod2_solid_id,
p_lod3_solid_id,
p_lod4_solid_id
) INTO inserted_id;
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.insert_waterbody (id: %): %', p_id, SQLERRM;
END;
$$
LANGUAGE 'plpgsql';

----------------------------------------------------------------
-- Function INSERT_WATERBOUNDARY_SURFACE
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_pkg.insert_waterboundary_surface (integer, integer, varchar, varchar, integer, integer, integer, varchar) CASCADE;
CREATE OR REPLACE FUNCTION citydb_pkg.insert_waterboundary_surface (
  objectclass_id                 integer,
  id                             integer,
  water_level                    varchar DEFAULT NULL,
  water_level_codespace          varchar DEFAULT NULL,
  lod2_surface_id                integer DEFAULT NULL,
  lod3_surface_id                integer DEFAULT NULL,
  lod4_surface_id                integer DEFAULT NULL,
--
  schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer
AS
$$
DECLARE
  p_id                    integer := id;
  p_objectclass_id        integer := objectclass_id;
  p_water_level           varchar := water_level;
  p_water_level_codespace varchar := water_level_codespace;
  p_lod2_surface_id       integer := lod2_surface_id;
  p_lod3_surface_id       integer := lod3_surface_id;
  p_lod4_surface_id       integer := lod4_surface_id;
--
  p_schema_name varchar := schema_name;
  inserted_id integer;
BEGIN

EXECUTE format('
INSERT INTO %I.waterboundary_surface (
 id,
 objectclass_id,
 water_level,
 water_level_codespace,
 lod2_surface_id,
 lod3_surface_id,
 lod4_surface_id
) VALUES (
%L, %L, %L, %L, %L, %L, %L
) RETURNING id',
p_schema_name,
p_id,
p_objectclass_id,
p_water_level,
p_water_level_codespace,
p_lod2_surface_id,
p_lod3_surface_id,
p_lod4_surface_id
) INTO inserted_id;
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.insert_waterboundary_surface (id: %): %', p_id, SQLERRM;
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

Additional DML functions for 3DCityDB installed correctly!

********************************

';
END
$$;
SELECT 'Additional DML functions for 3DCityDB installed correctly!'::varchar AS installation_result;

-- ***********************************************************************
-- ***********************************************************************
--
-- END OF FILE
--
-- ***********************************************************************
-- ***********************************************************************
