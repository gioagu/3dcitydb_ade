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
-- ****************** 01_citydb_util_DML_FUNCTIONS.sql *******************
--
-- This  script installs the extension "uuid-ossp" and additional
-- stored procedures into the citydb_pkg schema.
--
-- ***********************************************************************
-- ***********************************************************************

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" SCHEMA public;

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
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.insert_group_to_cityobject (cityobjectgroup_id: %, cityobject_id %): %', cityobjectgroup_id, cityobject_id, SQLERRM;
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
