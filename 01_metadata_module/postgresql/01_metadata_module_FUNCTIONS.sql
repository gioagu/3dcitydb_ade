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
-- ***************** 01_metadata_module_FUNCTIONS.sql ********************
--
-- This  script installs the functions needed to set up the metadata 
-- module in the 3DCityDB.
-- A backup copy of some "vanilla" functions (with suffix "_orig") is 
-- performed before installing their new ADE-enabled version.
--
-- ***********************************************************************
-- ***********************************************************************

----------------------------------------------------------------
-- Function citydb_pkg.GET_OBJECTCLASS_INFO
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_pkg.get_objectclass_info(integer, varchar);
CREATE OR REPLACE FUNCTION citydb_pkg.get_objectclass_info(
	class_id integer,
	schema_name varchar DEFAULT 'citydb'::varchar)
RETURNS TABLE (
	db_prefix varchar,
	classname varchar,
	is_ade_class numeric(1,0)
)
AS $$
DECLARE
BEGIN
IF class_id IS NOT NULL THEN
	-- get more info about the objectclass
	EXECUTE format('SELECT a.db_prefix, o.classname, o.is_ade_class  
                  FROM %I.schema_to_objectclass so, %I.objectclass o, %I.schema s
                  LEFT OUTER JOIN %I.ade a ON (a.id=s.ade_id) 
                  WHERE s.id = so.schema_id AND so.objectclass_id = o.id AND o.id=%L
                  LIMIT 1',
		schema_name, schema_name, schema_name, schema_name, class_id) INTO db_prefix, classname, is_ade_class;
	--RAISE NOTICE '% % %', db_prefix, classname, is_ade_class;
	RETURN NEXT;
ELSE
	RAISE NOTICE 'citydb_pkg.get_classname: Class_id is NULL';
	-- RETURN NEXT -- outputs an empty row i.e. (,,)
END IF;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.get_objectclass_info (class_id: %, schema_name "%"): %', class_id, schema_name, SQLERRM;
END;
$$
LANGUAGE plpgsql;
-- ALTER FUNCTION citydb_pkg.get_objectclass_info(integer, varchar) OWNER TO postgres;

----------------------------------------------------------------
-- Function citydb_pkg.GET_CLASSNAME
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_pkg.get_classname(integer, varchar);
CREATE OR REPLACE FUNCTION citydb_pkg.get_classname(
	class_id integer,
	schema_name varchar DEFAULT 'citydb'::varchar)
RETURNS varchar
AS $BODY$
DECLARE
	classname varchar;
BEGIN
IF class_id IS NOT NULL THEN
	-- get the classname of the class
	EXECUTE format('SELECT classname FROM %I.objectclass WHERE id=%L',schema_name,class_id) INTO classname;
	--RAISE NOTICE 'classname %', classname
	RETURN classname;
ELSE
	RAISE NOTICE 'citydb_pkg.get_classname: Class_id is NULL';
	RETURN NULL;
END IF;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.get_classname (class_id: %, schema_name "%"): %', class_id, schema_name, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql;
-- ALTER FUNCTION citydb_pkg.get_classname(integer, varchar) OWNER TO postgres;

-- CREATES backup versions of the delete_cityobject and get_envelope_cityobject functions
-- This is nothing else than a copy and paste of the functions from the vanilla 3DCityDB 3.3.1.
----------------------------------------------------------------
-- Function citydb_pkg.DELETE_CITYOBJECT_orig 
----------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_pkg.delete_cityobject_orig(
	co_id integer,
	delete_members integer DEFAULT 0,
	cleanup integer DEFAULT 0,
	schema_name text DEFAULT 'citydb'::text)
  RETURNS integer AS
$BODY$
DECLARE
	deleted_id INTEGER;
	class_id INTEGER;
BEGIN
EXECUTE format('SELECT objectclass_id FROM %I.cityobject WHERE id = %L', schema_name, co_id) INTO class_id;
-- class_id can be NULL if object has already been deleted
IF class_id IS NOT NULL THEN
    CASE
      WHEN class_id = 4 THEN deleted_id := citydb_pkg.delete_land_use(co_id, schema_name);
      WHEN class_id = 5 THEN deleted_id := citydb_pkg.delete_generic_cityobject(co_id, schema_name);
      WHEN class_id = 7 THEN deleted_id := citydb_pkg.delete_solitary_veg_obj(co_id, schema_name);
      WHEN class_id = 8 THEN deleted_id := citydb_pkg.delete_plant_cover(co_id, schema_name);
      WHEN class_id = 9 THEN deleted_id := citydb_pkg.delete_waterbody(co_id, schema_name);
      WHEN class_id = 11 OR 
           class_id = 12 OR 
           class_id = 13 THEN deleted_id := citydb_pkg.delete_waterbnd_surface(co_id, schema_name);
      WHEN class_id = 14 THEN deleted_id := citydb_pkg.delete_relief_feature(co_id, schema_name);
      WHEN class_id = 16 OR 
           class_id = 17 OR 
           class_id = 18 OR 
           class_id = 19 THEN deleted_id := citydb_pkg.delete_relief_component(co_id, schema_name);
      WHEN class_id = 21 THEN deleted_id := citydb_pkg.delete_city_furniture(co_id, schema_name);
      WHEN class_id = 23 THEN deleted_id := citydb_pkg.delete_cityobjectgroup(co_id, delete_members, schema_name);
      WHEN class_id = 25 OR 
           class_id = 26 THEN deleted_id := citydb_pkg.delete_building(co_id, schema_name);
      WHEN class_id = 27 OR 
           class_id = 28 THEN deleted_id := citydb_pkg.delete_building_installation(co_id, schema_name);
      WHEN class_id = 30 OR 
           class_id = 31 OR 
           class_id = 32 OR 
           class_id = 33 OR 
           class_id = 34 OR 
           class_id = 35 OR 
           class_id = 36 OR 
           class_id = 60 OR 
           class_id = 61 THEN deleted_id := citydb_pkg.delete_thematic_surface(co_id, schema_name);
      WHEN class_id = 38 OR 
           class_id = 39 THEN deleted_id := citydb_pkg.delete_opening(co_id, schema_name);
      WHEN class_id = 40 THEN deleted_id := citydb_pkg.delete_building_furniture(co_id, schema_name);
      WHEN class_id = 41 THEN deleted_id := citydb_pkg.delete_room(co_id, schema_name);
      WHEN class_id = 43 OR 
           class_id = 44 OR 
           class_id = 45 OR 
           class_id = 46 THEN deleted_id := citydb_pkg.delete_transport_complex(co_id, schema_name);
      WHEN class_id = 47 OR 
           class_id = 48 THEN deleted_id := citydb_pkg.delete_traffic_area(co_id, schema_name);
      WHEN class_id = 63 OR 
           class_id = 64 THEN deleted_id := citydb_pkg.delete_bridge(co_id, schema_name);
      WHEN class_id = 65 OR 
           class_id = 66 THEN deleted_id := citydb_pkg.delete_bridge_installation(co_id, schema_name);
      WHEN class_id = 68 OR 
           class_id = 69 OR 
           class_id = 70 OR 
           class_id = 71 OR 
           class_id = 72 OR 
           class_id = 73 OR 
           class_id = 74 OR 
           class_id = 75 OR 
           class_id = 76 THEN deleted_id := citydb_pkg.delete_bridge_them_srf(co_id, schema_name);
      WHEN class_id = 78 OR 
           class_id = 79 THEN deleted_id := citydb_pkg.delete_bridge_opening(co_id, schema_name);		 
      WHEN class_id = 80 THEN deleted_id := citydb_pkg.delete_bridge_furniture(co_id, schema_name);
      WHEN class_id = 81 THEN deleted_id := citydb_pkg.delete_bridge_room(co_id, schema_name);
      WHEN class_id = 82 THEN deleted_id := citydb_pkg.delete_bridge_constr_element(co_id, schema_name);
      WHEN class_id = 84 OR 
           class_id = 85 THEN deleted_id := citydb_pkg.delete_tunnel(co_id, schema_name);
      WHEN class_id = 86 OR 
           class_id = 87 THEN deleted_id := citydb_pkg.delete_tunnel_installation(co_id, schema_name);
      WHEN class_id = 88 OR 
           class_id = 89 OR 
           class_id = 90 OR 
           class_id = 91 OR 
           class_id = 92 OR 
           class_id = 93 OR 
           class_id = 94 OR 
           class_id = 95 OR 
           class_id = 96 THEN deleted_id := citydb_pkg.delete_tunnel_them_srf(co_id, schema_name);
      WHEN class_id = 99 OR 
           class_id = 100 THEN deleted_id := citydb_pkg.delete_tunnel_opening(co_id, schema_name);
      WHEN class_id = 101 THEN deleted_id := citydb_pkg.delete_tunnel_furniture(co_id, schema_name);
      WHEN class_id = 102 THEN deleted_id := citydb_pkg.delete_tunnel_hollow_space(co_id, schema_name);
    ELSE
        RAISE NOTICE 'Can not delete chosen object with ID % and objectclass_id %.', co_id, class_id;
    END CASE;
END IF;

IF cleanup <> 0 THEN
    EXECUTE 'SELECT citydb_pkg.cleanup_implicit_geometries(1, $1)' USING schema_name;
    EXECUTE 'SELECT citydb_pkg.cleanup_appearances(1, $1)' USING schema_name;
    EXECUTE 'SELECT citydb_pkg.cleanup_citymodels($1)' USING schema_name;
END IF;

RETURN deleted_id;

EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.delete_cityobject (id: %): %', co_id, SQLERRM;
END; 
$BODY$
LANGUAGE plpgsql VOLATILE COST 100;

----------------------------------------------------------------
-- Function citydb_pkg.GET_ENVELOPE_CITYOBJECT_orig 
----------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_pkg.get_envelope_cityobject_orig(
	co_id integer,
	objclass_id integer DEFAULT 0,
	set_envelope integer DEFAULT 0,
	schema_name character varying DEFAULT 'citydb'::character varying)
  RETURNS geometry AS
$BODY$
DECLARE
	class_id INTEGER = 0;
	envelope GEOMETRY;
	db_srid INTEGER;
BEGIN
-- fetching class_id if it is NULL
IF objclass_id IS NULL OR objclass_id = 0 THEN
    EXECUTE format('SELECT objectclass_id FROM %I.cityobject WHERE id = %L', schema_name, co_id) INTO class_id;
ELSE
    class_id := objclass_id;
END IF;
CASE
	WHEN class_id = 4 THEN envelope := citydb_pkg.get_envelope_land_use(co_id, set_envelope, schema_name);
	WHEN class_id = 5 THEN envelope := citydb_pkg.get_envelope_generic_cityobj(co_id, set_envelope, schema_name);
	WHEN class_id = 7 THEN envelope := citydb_pkg.get_envelope_solitary_veg_obj(co_id, set_envelope, schema_name);
	WHEN class_id = 8 THEN envelope := citydb_pkg.get_envelope_plant_cover(co_id, set_envelope, schema_name);
	WHEN class_id = 9 THEN envelope := citydb_pkg.get_envelope_waterbody(co_id, set_envelope, schema_name);
	WHEN class_id = 11 OR
		 class_id = 12 OR
		 class_id = 13 THEN envelope := citydb_pkg.get_envelope_waterbnd_surface(co_id, set_envelope, schema_name);
	WHEN class_id = 14 THEN envelope := citydb_pkg.get_envelope_relief_feature(co_id, set_envelope, schema_name);
	WHEN class_id = 16 OR
		 class_id = 17 OR
		 class_id = 18 OR
		 class_id = 19 THEN envelope := citydb_pkg.get_envelope_relief_component(co_id, class_id, set_envelope, schema_name);
	WHEN class_id = 21 THEN envelope := citydb_pkg.get_envelope_city_furniture(co_id, set_envelope, schema_name);
	WHEN class_id = 23 THEN envelope := citydb_pkg.get_envelope_cityobjectgroup(co_id, set_envelope, 1, schema_name);
	WHEN class_id = 25 OR
		 class_id = 26 THEN envelope := citydb_pkg.get_envelope_building(co_id, set_envelope, schema_name);
	WHEN class_id = 27 OR
		 class_id = 28 THEN envelope := citydb_pkg.get_envelope_building_inst(co_id, set_envelope, schema_name);
	WHEN class_id = 30 OR
		 class_id = 31 OR
		 class_id = 32 OR
		 class_id = 33 OR
		 class_id = 34 OR
		 class_id = 35 OR
		 class_id = 36 OR
		 class_id = 60 OR
		 class_id = 61 THEN envelope := citydb_pkg.get_envelope_thematic_surface(co_id, set_envelope, schema_name);
	WHEN class_id = 38 OR
		 class_id = 39 THEN envelope := citydb_pkg.get_envelope_opening(co_id, set_envelope, schema_name);
	WHEN class_id = 40 THEN envelope := citydb_pkg.get_envelope_building_furn(co_id, set_envelope, schema_name);
	WHEN class_id = 41 THEN envelope := citydb_pkg.get_envelope_room(co_id, set_envelope, schema_name);
	WHEN class_id = 43 OR
		 class_id = 44 OR
		 class_id = 45 OR
		 class_id = 46 THEN envelope := citydb_pkg.get_envelope_trans_complex(co_id, set_envelope, schema_name);
	WHEN class_id = 47 OR
		 class_id = 48 THEN envelope := citydb_pkg.get_envelope_traffic_area(co_id, set_envelope, schema_name);
	WHEN class_id = 63 OR
		 class_id = 64 THEN envelope := citydb_pkg.get_envelope_bridge(co_id, set_envelope, schema_name);
	WHEN class_id = 65 OR
		 class_id = 66 THEN envelope := citydb_pkg.get_envelope_bridge_inst(co_id, set_envelope, schema_name);
	WHEN class_id = 68 OR
		 class_id = 69 OR
		 class_id = 70 OR
		 class_id = 71 OR
		 class_id = 72 OR
		 class_id = 73 OR
		 class_id = 74 OR
		 class_id = 75 OR
		 class_id = 76 THEN envelope := citydb_pkg.get_envelope_bridge_them_srf(co_id, set_envelope, schema_name);
	WHEN class_id = 78 OR
		 class_id = 79 THEN envelope := citydb_pkg.get_envelope_bridge_opening(co_id, set_envelope, schema_name);
	WHEN class_id = 80 THEN envelope := citydb_pkg.get_envelope_bridge_furniture(co_id, set_envelope, schema_name);
	WHEN class_id = 81 THEN envelope := citydb_pkg.get_envelope_bridge_room(co_id, set_envelope, schema_name);
	WHEN class_id = 82 THEN envelope := citydb_pkg.get_envelope_bridge_const_elem(co_id, set_envelope, schema_name);
	WHEN class_id = 84 OR
		 class_id = 85 THEN envelope := citydb_pkg.get_envelope_tunnel(co_id, set_envelope, schema_name);
	WHEN class_id = 86 OR
		 class_id = 87 THEN envelope := citydb_pkg.get_envelope_tunnel_inst(co_id, set_envelope, schema_name);
	WHEN class_id = 89 OR
		 class_id = 90 OR
		 class_id = 91 OR
		 class_id = 92 OR
		 class_id = 93 OR
		 class_id = 94 OR
		 class_id = 95 OR
		 class_id = 96 OR
		 class_id = 97 THEN envelope := citydb_pkg.get_envelope_tunnel_them_srf(co_id, set_envelope, schema_name);
	WHEN class_id = 99 OR
		 class_id = 100 THEN envelope := citydb_pkg.get_envelope_tunnel_opening(co_id, set_envelope, schema_name);
	WHEN class_id = 101 THEN envelope := citydb_pkg.get_envelope_tunnel_furniture(co_id, set_envelope, schema_name);
	WHEN class_id = 102 THEN envelope := citydb_pkg.get_envelope_tunnel_hspace(co_id, set_envelope, schema_name);
ELSE
	RAISE NOTICE 'Cannot get envelope of object with ID % and objectclass_id %.', co_id, class_id;
END CASE;

RETURN envelope;

EXCEPTION
  WHEN OTHERS THEN RAISE NOTICE 'An error occurred when executing function "citydb_pkg.get_envelope_cityobject": %', SQLERRM;
END;
$BODY$
LANGUAGE plpgsql;


-- And now "over"write the old vanilla versions with the new one which includes a hook mechanismus for the ADEs.
----------------------------------------------------------------
-- Function citydb_pkg.DELETE_CITYOBJECT 
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_pkg.delete_cityobject(integer, integer, integer, text); --this is only if there is a leftover of the function with text instead of varchar type. The backup one is now coherently "varchar".
DROP FUNCTION IF EXISTS citydb_pkg.delete_cityobject(integer, integer, integer, varchar);
CREATE OR REPLACE FUNCTION citydb_pkg.delete_cityobject(
	co_id integer,
	delete_members integer DEFAULT 0,
	cleanup integer DEFAULT 0,
	schema_name varchar DEFAULT 'citydb'::varchar)
  RETURNS integer AS
$BODY$
DECLARE
	class_id INTEGER;
	class_info RECORD;
	deleted_id INTEGER;
BEGIN

EXECUTE format('SELECT objectclass_id FROM %I.cityobject WHERE id = %L', schema_name, co_id) INTO class_id;
-- class_id can be NULL if object has already been deleted

IF class_id IS NOT NULL THEN
	-- get the full info of the objectclass, including db_prefix etc.

	EXECUTE format('SELECT t.* FROM citydb_pkg.get_objectclass_info(%L, %L) AS t', class_id, schema_name) INTO class_info;
	-- This funtion returns class_info.db_prefix varchar, class_info.classname varchar, class_info.is_ade_class numeric(1,0)
	-- RAISE NOTICE 'Class_info %', class_info;

	IF class_info.is_ade_class::integer = 1 THEN
	-- we are dealing with an ADE cityobject, so call the respective ADE delete_cityobject() function, which is identified by its db_prefix

		EXECUTE format('SELECT citydb_pkg.%I_delete_cityobject(%L, %L, %L, %L)', 
		 class_info.db_prefix, co_id, delete_members, cleanup, schema_name) INTO deleted_id;			

	ELSIF class_info.is_ade_class::integer = 0 THEN
	-- we are dealing with a vanilla CityObject class, so use the "vanilla" approach.

		CASE
		  WHEN class_id = 4 THEN deleted_id := citydb_pkg.delete_land_use(co_id, schema_name);
		  WHEN class_id = 5 THEN deleted_id := citydb_pkg.delete_generic_cityobject(co_id, schema_name);
		  WHEN class_id = 7 THEN deleted_id := citydb_pkg.delete_solitary_veg_obj(co_id, schema_name);
		  WHEN class_id = 8 THEN deleted_id := citydb_pkg.delete_plant_cover(co_id, schema_name);
		  WHEN class_id = 9 THEN deleted_id := citydb_pkg.delete_waterbody(co_id, schema_name);
		  WHEN class_id = 11 OR 
			   class_id = 12 OR 
			   class_id = 13 THEN deleted_id := citydb_pkg.delete_waterbnd_surface(co_id, schema_name);
		  WHEN class_id = 14 THEN deleted_id := citydb_pkg.delete_relief_feature(co_id, schema_name);
		  WHEN class_id = 16 OR 
			   class_id = 17 OR 
			   class_id = 18 OR 
			   class_id = 19 THEN deleted_id := citydb_pkg.delete_relief_component(co_id, schema_name);
		  WHEN class_id = 21 THEN deleted_id := citydb_pkg.delete_city_furniture(co_id, schema_name);
		  WHEN class_id = 23 THEN deleted_id := citydb_pkg.delete_cityobjectgroup(co_id, delete_members, schema_name);
		  WHEN class_id = 25 OR 
			   class_id = 26 THEN deleted_id := citydb_pkg.delete_building(co_id, schema_name);
		  WHEN class_id = 27 OR 
			   class_id = 28 THEN deleted_id := citydb_pkg.delete_building_installation(co_id, schema_name);
		  WHEN class_id = 30 OR 
			   class_id = 31 OR 
			   class_id = 32 OR 
			   class_id = 33 OR 
			   class_id = 34 OR 
			   class_id = 35 OR 
			   class_id = 36 OR 
			   class_id = 60 OR 
			   class_id = 61 THEN deleted_id := citydb_pkg.delete_thematic_surface(co_id, schema_name);
		  WHEN class_id = 38 OR 
			   class_id = 39 THEN deleted_id := citydb_pkg.delete_opening(co_id, schema_name);
		  WHEN class_id = 40 THEN deleted_id := citydb_pkg.delete_building_furniture(co_id, schema_name);
		  WHEN class_id = 41 THEN deleted_id := citydb_pkg.delete_room(co_id, schema_name);
		  WHEN class_id = 43 OR 
			   class_id = 44 OR 
			   class_id = 45 OR 
			   class_id = 46 THEN deleted_id := citydb_pkg.delete_transport_complex(co_id, schema_name);
		  WHEN class_id = 47 OR 
			   class_id = 48 THEN deleted_id := citydb_pkg.delete_traffic_area(co_id, schema_name);
		  WHEN class_id = 63 OR 
			   class_id = 64 THEN deleted_id := citydb_pkg.delete_bridge(co_id, schema_name);
		  WHEN class_id = 65 OR 
			   class_id = 66 THEN deleted_id := citydb_pkg.delete_bridge_installation(co_id, schema_name);
		  WHEN class_id = 68 OR 
			   class_id = 69 OR 
			   class_id = 70 OR 
			   class_id = 71 OR 
			   class_id = 72 OR 
			   class_id = 73 OR 
			   class_id = 74 OR 
			   class_id = 75 OR 
			   class_id = 76 THEN deleted_id := citydb_pkg.delete_bridge_them_srf(co_id, schema_name);
		  WHEN class_id = 78 OR 
			   class_id = 79 THEN deleted_id := citydb_pkg.delete_bridge_opening(co_id, schema_name);		 
		  WHEN class_id = 80 THEN deleted_id := citydb_pkg.delete_bridge_furniture(co_id, schema_name);
		  WHEN class_id = 81 THEN deleted_id := citydb_pkg.delete_bridge_room(co_id, schema_name);
		  WHEN class_id = 82 THEN deleted_id := citydb_pkg.delete_bridge_constr_element(co_id, schema_name);
		  WHEN class_id = 84 OR 
			   class_id = 85 THEN deleted_id := citydb_pkg.delete_tunnel(co_id, schema_name);
		  WHEN class_id = 86 OR 
			   class_id = 87 THEN deleted_id := citydb_pkg.delete_tunnel_installation(co_id, schema_name);
		  WHEN class_id = 88 OR 
			   class_id = 89 OR 
			   class_id = 90 OR 
			   class_id = 91 OR 
			   class_id = 92 OR 
			   class_id = 93 OR 
			   class_id = 94 OR 
			   class_id = 95 OR 
			   class_id = 96 THEN deleted_id := citydb_pkg.delete_tunnel_them_srf(co_id, schema_name);
		  WHEN class_id = 99 OR 
			   class_id = 100 THEN deleted_id := citydb_pkg.delete_tunnel_opening(co_id, schema_name);
		  WHEN class_id = 101 THEN deleted_id := citydb_pkg.delete_tunnel_furniture(co_id, schema_name);
		  WHEN class_id = 102 THEN deleted_id := citydb_pkg.delete_tunnel_hollow_space(co_id, schema_name);
		ELSE
			RAISE NOTICE 'Cannot delete chosen cityobject with ID % and objectclass_id %.', co_id, class_id;
		END CASE;
	END IF;

	IF cleanup <> 0 THEN
	    EXECUTE 'SELECT citydb_pkg.cleanup_implicit_geometries(1, $1)' USING schema_name;
	    EXECUTE 'SELECT citydb_pkg.cleanup_appearances(1, $1)' USING schema_name;
	    EXECUTE 'SELECT citydb_pkg.cleanup_citymodels($1)' USING schema_name;
	END IF;

	RAISE NOTICE 'Deleted CityObject (class_name %, class_id %) with id: %', class_info.classname, class_id, co_id;

	RETURN deleted_id;

ELSE
	-- do nothing, the object may have been deleted already
	-- RAISE NOTICE 'CityObject not found';
	RETURN NULL;
END IF;

EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.delete_cityobject (id: %): %', co_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;


----------------------------------------------------------------
-- Function citydb_pkg.GET_ENVELOPE_CITYOBJECT
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_pkg.get_envelope_cityobject(integer, integer, integer, varchar);
CREATE OR REPLACE FUNCTION citydb_pkg.get_envelope_cityobject(
	co_id integer,
	objclass_id integer DEFAULT 0,
	set_envelope integer DEFAULT 0,
	schema_name varchar DEFAULT 'citydb'::varchar)
  RETURNS geometry AS
$BODY$
DECLARE
	class_id INTEGER = 0;
	class_info RECORD;
	envelope GEOMETRY;
	db_srid INTEGER;
BEGIN
-- get class_id if it is NULL or zero
IF objclass_id IS NULL OR objclass_id = 0 THEN
    EXECUTE format('SELECT objectclass_id FROM %I.cityobject WHERE id = %L', schema_name, co_id) INTO class_id;
ELSE
    class_id:=objclass_id;
END IF;
-- now I am sure that class id <> 0 AND IS NOT NULL

EXECUTE format('SELECT t.* FROM citydb_pkg.get_objectclass_info(%L, %L) AS t', class_id, schema_name) INTO class_info;
-- This funtion returns class_info.db_prefix varchar, class_info.classname varchar, class_info.is_ade_class numeric(1,0)
--RAISE NOTICE 'Class_info %'), class_info;

IF class_info.is_ade_class::integer=1 THEN
-- we are dealing with an ADE cityobject, so call the respective ADE get_envelope_cityobject() function, which is identified by its db_prefix

	EXECUTE format('SELECT citydb_pkg.%I_get_envelope_cityobject(%L, %L, %L, %L)', class_info.db_prefix, co_id, objclass_id, set_envelope, schema_name) INTO envelope;			

ELSE -- i.e. is_ade_class::integer=0 
	-- we are dealing with a vanilla CityObject class, so use the "vanilla" approach.
	CASE
		WHEN class_id = 4 THEN envelope := citydb_pkg.get_envelope_land_use(co_id, set_envelope, schema_name);
		WHEN class_id = 5 THEN envelope := citydb_pkg.get_envelope_generic_cityobj(co_id, set_envelope, schema_name);
		WHEN class_id = 7 THEN envelope := citydb_pkg.get_envelope_solitary_veg_obj(co_id, set_envelope, schema_name);
		WHEN class_id = 8 THEN envelope := citydb_pkg.get_envelope_plant_cover(co_id, set_envelope, schema_name);
		WHEN class_id = 9 THEN envelope := citydb_pkg.get_envelope_waterbody(co_id, set_envelope, schema_name);
		WHEN class_id = 11 OR
			 class_id = 12 OR
			 class_id = 13 THEN envelope := citydb_pkg.get_envelope_waterbnd_surface(co_id, set_envelope, schema_name);
		WHEN class_id = 14 THEN envelope := citydb_pkg.get_envelope_relief_feature(co_id, set_envelope, schema_name);
		WHEN class_id = 16 OR
			 class_id = 17 OR
			 class_id = 18 OR
			 class_id = 19 THEN envelope := citydb_pkg.get_envelope_relief_component(co_id, class_id, set_envelope, schema_name);
		WHEN class_id = 21 THEN envelope := citydb_pkg.get_envelope_city_furniture(co_id, set_envelope, schema_name);
		WHEN class_id = 23 THEN envelope := citydb_pkg.get_envelope_cityobjectgroup(co_id, set_envelope, 1, schema_name);
		WHEN class_id = 25 OR
			 class_id = 26 THEN envelope := citydb_pkg.get_envelope_building(co_id, set_envelope, schema_name);
		WHEN class_id = 27 OR
			 class_id = 28 THEN envelope := citydb_pkg.get_envelope_building_inst(co_id, set_envelope, schema_name);
		WHEN class_id = 30 OR
			 class_id = 31 OR
			 class_id = 32 OR
			 class_id = 33 OR
			 class_id = 34 OR
			 class_id = 35 OR
			 class_id = 36 OR
			 class_id = 60 OR
			 class_id = 61 THEN envelope := citydb_pkg.get_envelope_thematic_surface(co_id, set_envelope, schema_name);
		WHEN class_id = 38 OR
			 class_id = 39 THEN envelope := citydb_pkg.get_envelope_opening(co_id, set_envelope, schema_name);
		WHEN class_id = 40 THEN envelope := citydb_pkg.get_envelope_building_furn(co_id, set_envelope, schema_name);
		WHEN class_id = 41 THEN envelope := citydb_pkg.get_envelope_room(co_id, set_envelope, schema_name);
		WHEN class_id = 43 OR
			 class_id = 44 OR
			 class_id = 45 OR
			 class_id = 46 THEN envelope := citydb_pkg.get_envelope_trans_complex(co_id, set_envelope, schema_name);
		WHEN class_id = 47 OR
			 class_id = 48 THEN envelope := citydb_pkg.get_envelope_traffic_area(co_id, set_envelope, schema_name);
		WHEN class_id = 63 OR
			 class_id = 64 THEN envelope := citydb_pkg.get_envelope_bridge(co_id, set_envelope, schema_name);
		WHEN class_id = 65 OR
			 class_id = 66 THEN envelope := citydb_pkg.get_envelope_bridge_inst(co_id, set_envelope, schema_name);
		WHEN class_id = 68 OR
			 class_id = 69 OR
			 class_id = 70 OR
			 class_id = 71 OR
			 class_id = 72 OR
			 class_id = 73 OR
			 class_id = 74 OR
			 class_id = 75 OR
			 class_id = 76 THEN envelope := citydb_pkg.get_envelope_bridge_them_srf(co_id, set_envelope, schema_name);
		WHEN class_id = 78 OR
			 class_id = 79 THEN envelope := citydb_pkg.get_envelope_bridge_opening(co_id, set_envelope, schema_name);
		WHEN class_id = 80 THEN envelope := citydb_pkg.get_envelope_bridge_furniture(co_id, set_envelope, schema_name);
		WHEN class_id = 81 THEN envelope := citydb_pkg.get_envelope_bridge_room(co_id, set_envelope, schema_name);
		WHEN class_id = 82 THEN envelope := citydb_pkg.get_envelope_bridge_const_elem(co_id, set_envelope, schema_name);
		WHEN class_id = 84 OR
			 class_id = 85 THEN envelope := citydb_pkg.get_envelope_tunnel(co_id, set_envelope, schema_name);
		WHEN class_id = 86 OR
			 class_id = 87 THEN envelope := citydb_pkg.get_envelope_tunnel_inst(co_id, set_envelope, schema_name);
		WHEN class_id = 89 OR
			 class_id = 90 OR
			 class_id = 91 OR
			 class_id = 92 OR
			 class_id = 93 OR
			 class_id = 94 OR
			 class_id = 95 OR
			 class_id = 96 OR
			 class_id = 97 THEN envelope := citydb_pkg.get_envelope_tunnel_them_srf(co_id, set_envelope, schema_name);
		WHEN class_id = 99 OR
			 class_id = 100 THEN envelope := citydb_pkg.get_envelope_tunnel_opening(co_id, set_envelope, schema_name);
		WHEN class_id = 101 THEN envelope := citydb_pkg.get_envelope_tunnel_furniture(co_id, set_envelope, schema_name);
		WHEN class_id = 102 THEN envelope := citydb_pkg.get_envelope_tunnel_hspace(co_id, set_envelope, schema_name);
	ELSE
		RAISE NOTICE 'Cannot get envelope of object with ID % and objectclass_id %.', co_id, class_id;
		RETURN NULL;
	END CASE;
END IF;

RAISE NOTICE 'Computed envelope of CityObject (%, class_id %) with id: %', class_info.classname, class_id, co_id;
RETURN envelope;

EXCEPTION
  WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.get_envelope_cityobject (id: %): %', co_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function DROP_ADE_OBJECTCLASSES
----------------------------------------------------------------
DROP FUNCTION IF EXISTS  citydb_pkg.drop_ade_objectclasses(varchar, varchar);
CREATE OR REPLACE FUNCTION citydb_pkg.drop_ade_objectclasses(
	db_prefix varchar,
	schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS varchar AS $$
DECLARE
	class_id integer;
BEGIN
IF db_prefix IS NOT NULL THEN
	--first, all FK in table objectclass are deleted (columns baseclass_id and superclass_id)
	FOR class_id IN EXECUTE format('SELECT DISTINCT o.id FROM %I.ade a, %I.schema_to_objectclass so, %I.objectclass o, %I.schema s WHERE so.schema_id = s.id AND o.id = so.objectclass_id AND s.ade_id = a.id AND a.db_prefix=%L ORDER BY o.id', schema_name, schema_name, schema_name, schema_name, db_prefix) LOOP
		IF class_id IS NOT NULL THEN 
			--RAISE NOTICE 'class id: %',class_id;
			EXECUTE format('UPDATE %I.objectclass SET baseclass_id=NULL, superclass_id=NULL WHERE id=%L', schema_name, class_id);
		END IF;
	END LOOP;
	--then, delete the objectclass
	FOR class_id IN EXECUTE format('SELECT DISTINCT o.id FROM %I.ade a, %I.schema_to_objectclass so, %I.objectclass o, %I.schema s WHERE so.schema_id = s.id AND o.id = so.objectclass_id AND s.ade_id = a.id AND a.db_prefix=%L ORDER BY o.id', schema_name, schema_name, schema_name, schema_name, db_prefix) LOOP
		IF class_id IS NOT NULL THEN 
			--RAISE NOTICE 'class id: %',class_id;
			EXECUTE format('DELETE FROM %I.objectclass WHERE id=%L', schema_name, class_id);
		END IF;
	END LOOP;
	RAISE NOTICE 'Records in table %.objectclass depending associated with db_prefix "%" deleted', schema_name, db_prefix;	
	RETURN db_prefix;
ELSE
	RAISE NOTICE 'citydb_pkg.drop_ade_objectclasses: db_prefix is NULL, nothing to do';
	RETURN NULL;
END IF;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.drop_ade_objectclasses (db_prefix: %) in "%", %', db_prefix, schema_name, SQLERRM;
END;
$$
LANGUAGE plpgsql;
-- ALTER FUNCTION citydb_pkg.drop_ade_objectclasses(varchar,varchar) OWNER TO postgres;

----------------------------------------------------------------
-- Function DROP_ADE_TABLES
----------------------------------------------------------------
DROP FUNCTION IF EXISTS  citydb_pkg.drop_ade_tables(varchar, varchar);
CREATE OR REPLACE FUNCTION citydb_pkg.drop_ade_tables(
	db_prefix varchar,
	schema_name varchar DEFAULT 'citydb'::varchar)
RETURNS varchar AS $$
DECLARE
	db_prefix_length varchar;
	test integer;
	rec RECORD;
BEGIN
IF db_prefix IS NOT NULL THEN
	db_prefix_length=char_length(db_prefix);
	-- Check whether there are any prefixed tables to drop at all!
	EXECUTE format('SELECT 1 FROM information_schema.tables WHERE table_type=''BASE TABLE'' AND table_schema=%L AND substring(table_name, 1, %L::integer)=%L LIMIT 1',schema_name, db_prefix_length, db_prefix) INTO test;
	IF test IS NOT NULL AND test=1 THEN
		--RAISE INFO 'Removing all tables with db_prefix "%" in schema "%"',  db_prefix, schema_name;		
		FOR rec IN EXECUTE format('SELECT table_schema, table_name FROM information_schema.tables WHERE table_type=''BASE TABLE'' AND table_schema=%L AND substring(table_name, 1, %L::integer)=%L',schema_name,  
			 db_prefix_length, db_prefix) LOOP
			--RAISE INFO 'Dropping table %.%',rec.table_schema, rec.table_name;
			EXECUTE format('DROP TABLE IF EXISTS %I.%I CASCADE',rec.table_schema, rec.table_name);
		END LOOP;
		RETURN db_prefix;
	ELSE
		RAISE INFO '-- No tables found'; 
		RETURN NULL;
	END IF;
ELSE
	RAISE NOTICE 'citydb_pkg.drop_ade_tables: db_prefix is NULL, nothing to do';
	RETURN NULL;
END IF;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.drop_ade_tables (db_prefix: %) in "%", %', db_prefix, schema_name, SQLERRM;
END;
$$
LANGUAGE plpgsql;
-- ALTER FUNCTION citydb_pkg.drop_ade_tables(varchar,varchar) OWNER TO postgres;

----------------------------------------------------------------
-- Function DROP_ADE_FUNCTIONS
----------------------------------------------------------------
DROP FUNCTION IF EXISTS  citydb_pkg.drop_ade_functions(varchar);
CREATE OR REPLACE FUNCTION citydb_pkg.drop_ade_functions(
	db_prefix varchar)
RETURNS varchar AS $$
DECLARE
	db_prefix_length varchar;
	test integer;
	rec RECORD;
BEGIN
IF db_prefix IS NOT NULL THEN
	db_prefix_length=char_length(db_prefix);
	-- Check whether there are any prefixed functions to drop at all!
	EXECUTE format('SELECT 1 FROM information_schema.routines WHERE routine_type=''FUNCTION'' AND routine_schema=''citydb_pkg'' AND substring(routine_name, 1, %L::integer)=%L LIMIT 1', db_prefix_length, db_prefix) INTO test;
	IF test IS NOT NULL AND test=1 THEN
		--RAISE INFO 'Removing all functions with db_prefix "%" in schema citydb_pkg',  db_prefix;	
		FOR rec IN EXECUTE format('SELECT proname || ''('' || oidvectortypes(proargtypes) || '')'' AS function_name
		FROM pg_proc INNER JOIN pg_namespace ns ON (pg_proc.pronamespace = ns.oid)
		WHERE ns.nspname = ''citydb_pkg'' AND substring(proname, 1, %L)=%L ORDER BY proname', db_prefix_length, db_prefix) LOOP
			--RAISE NOTICE 'Dropping FUNCTION citydb_pkg.%',rec.function_name;
			EXECUTE 'DROP FUNCTION IF EXISTS citydb_pkg.' || rec.function_name || ' CASCADE'; 
		END LOOP;
		RETURN db_prefix;
	ELSE
		RAISE INFO '-- No functions found';
		RETURN NULL;		
	END IF;
ELSE
	RAISE NOTICE 'citydb_pkg.adrop_ade_functions: db_prefix is NULL, nothing to do';
	RETURN NULL;
END IF;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.drop_ade_functions (db_prefix: %) in "%", %', db_prefix, schema_name, SQLERRM;
END;
$$
LANGUAGE plpgsql;
-- ALTER FUNCTION citydb_pkg.drop_ade_functions(varchar,varchar) OWNER TO postgres;

----------------------------------------------------------------
-- Function DROP_ADE
----------------------------------------------------------------
-- This is a very basic implementation which needs to be improved.
-- So far, it simply picks the db_prefix of the selected ADE and deletes
-- all entries with the same db_prefix in the schema table and all tables
-- and functions with the same db_prefix.
-- Entries in tables schema_referencing and schema_to_objectclass are deleted
-- automatically on cascade.
-- a more appropriate check on dependencies needs to be implemented.
DROP FUNCTION IF EXISTS  citydb_pkg.drop_ade(integer, varchar);
CREATE OR REPLACE FUNCTION citydb_pkg.drop_ade(
	ade_id integer,
	schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS $$
DECLARE
	db_prefix varchar;
	deleted_id integer;
BEGIN
-- get more info about the ADE schema
EXECUTE format('SELECT db_prefix FROM %I.ade WHERE id=%L', schema_name, ade_id) INTO db_prefix;
IF db_prefix IS NOT NULL THEN
	RAISE NOTICE 'Picked up db_prefix: %',db_prefix;
	-- drops all objectclasses in table objectclass
	EXECUTE 'SELECT citydb_pkg.drop_ade_objectclasses($1,$2)' USING db_prefix, schema_name;	
	-- drops all tables
	EXECUTE 'SELECT citydb_pkg.drop_ade_tables($1,$2)' USING db_prefix, schema_name;
	-- drops all functions
	EXECUTE 'SELECT citydb_pkg.drop_ade_functions($1)' USING db_prefix;
	-- deletes entry in ade table
	EXECUTE format('DELETE FROM %I.ade WHERE id=%L RETURNING id', schema_name, ade_id) INTO deleted_id;
	-- delete entries in schema table (carried out automatically ON DELETE CASCADE)
	-- delete entries in schema_referencing and schema_to_objectclass (carried out automatically ON DELETE CASCADE)
	RETURN deleted_id;
ELSE
	RAISE NOTICE 'citydb_pkg.drop_ade: no db_prefix found for ADE (id: %)', ade_id;
	RETURN NULL;
END IF;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.drop_ade (id: %) in "%", %', ade_id, schema_name, SQLERRM;
END;
$$
LANGUAGE plpgsql;
-- ALTER FUNCTION citydb_pkg.drop_ade(varchar,varchar) OWNER TO postgres;

----------------------------------------------------------------
-- Function CHANGE_ADE_COLUMN_SRID
----------------------------------------------------------------
--DROP FUNCTION IF EXISTS citydb_pkg.change_ade_column_srid(varchar,varchar,varchar,varchar);
CREATE OR REPLACE FUNCTION citydb_pkg.change_ade_column_srid(
  table_name varchar,
  geom_column varchar,
  geom_type varchar,
  schema_name varchar DEFAULT 'citydb'::varchar
)
  RETURNS void AS $$
DECLARE
  db_srid integer;
BEGIN
-- get the Srid already defined in the table database_srs
EXECUTE format('SELECT srid FROM %I.database_srs LIMIT 1',schema_name) INTO db_srid; 
-- RAISE INFO 'Found SRID % for schema %', db_srid, schema_name;
-- RAISE INFO 'Setting SRID for %.%', table_name, geom_column;
EXECUTE format('ALTER TABLE %I.%I ALTER COLUMN %I TYPE geometry(%I,%L) USING ST_SetSrid(%I,%L)',
			 schema_name, 
			 table_name, 
			 geom_column, 
			 geom_type, 
			 db_srid, 
			 geom_column,
			 db_srid); 
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.change_ade_column_srid(%, %, %, %): %', table_name, geom_column, geom_type,  schema_name, SQLERRM;
END;
$$ LANGUAGE plpgsql;
-- ALTER FUNCTION citydb_pkg.change_ade_column_srid(varchar,varchar,varchar,varchar) OWNER TO postgres;


-- CREATES backup versions of the objectclass_id_to_table_name function
-- This is nothing else than a copy and paste of the functions from the vanilla 3DCityDB 3.3.1.
----------------------------------------------------------------
-- Function citydb_pkg.OBJECTCLASS_ID_TO_TABLE_NAME_orig 
----------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_pkg.objectclass_id_to_table_name_orig(
	class_id integer
)
  RETURNS text AS
$BODY$
DECLARE
	table_name TEXT := '';
BEGIN
  CASE 
    WHEN class_id = 4 THEN table_name := 'land_use';
    WHEN class_id = 5 THEN table_name := 'generic_cityobject';
    WHEN class_id = 7 THEN table_name := 'solitary_vegetat_object';
    WHEN class_id = 8 THEN table_name := 'plant_cover';
    WHEN class_id = 9 THEN table_name := 'waterbody';
    WHEN class_id = 11 OR 
         class_id = 12 OR 
         class_id = 13 THEN table_name := 'waterboundary_surface';
    WHEN class_id = 14 THEN table_name := 'relief_feature';
    WHEN class_id = 16 OR 
         class_id = 17 OR 
         class_id = 18 OR 
         class_id = 19 THEN table_name := 'relief_component';
    WHEN class_id = 21 THEN table_name := 'city_furniture';
    WHEN class_id = 23 THEN table_name := 'cityobjectgroup';
    WHEN class_id = 25 OR 
         class_id = 26 THEN table_name := 'building';
    WHEN class_id = 27 OR 
         class_id = 28 THEN table_name := 'building_installation';
    WHEN class_id = 30 OR 
         class_id = 31 OR 
         class_id = 32 OR 
         class_id = 33 OR 
         class_id = 34 OR 
         class_id = 35 OR
         class_id = 36 OR
         class_id = 60 OR
         class_id = 61 THEN table_name := 'thematic_surface';
    WHEN class_id = 38 OR 
         class_id = 39 THEN table_name := 'opening';
    WHEN class_id = 40 THEN table_name := 'building_furniture';
    WHEN class_id = 41 THEN table_name := 'room';
    WHEN class_id = 43 OR 
         class_id = 44 OR 
         class_id = 45 OR 
         class_id = 46 THEN table_name := 'transportation_complex';
    WHEN class_id = 47 OR 
         class_id = 48 THEN table_name := 'traffic_area';
    WHEN class_id = 57 THEN table_name := 'citymodel';
    WHEN class_id = 63 OR
         class_id = 64 THEN table_name := 'bridge';
    WHEN class_id = 65 OR
         class_id = 66 THEN table_name := 'bridge_installation';
    WHEN class_id = 68 OR 
         class_id = 69 OR 
         class_id = 70 OR 
         class_id = 71 OR 
         class_id = 72 OR
         class_id = 73 OR
         class_id = 74 OR
         class_id = 75 OR
         class_id = 76 THEN table_name := 'bridge_thematic_surface';
    WHEN class_id = 78 OR 
         class_id = 79 THEN table_name := 'bridge_opening';		 
    WHEN class_id = 80 THEN table_name := 'bridge_furniture';
    WHEN class_id = 81 THEN table_name := 'bridge_room';
    WHEN class_id = 82 THEN table_name := 'bridge_constr_element';
    WHEN class_id = 84 OR
         class_id = 85 THEN table_name := 'tunnel';
    WHEN class_id = 86 OR
         class_id = 87 THEN table_name := 'tunnel_installation';
    WHEN class_id = 88 OR 
         class_id = 89 OR 
         class_id = 90 OR 
         class_id = 91 OR 
         class_id = 92 OR
         class_id = 93 OR
         class_id = 94 OR
         class_id = 95 OR
         class_id = 96 THEN table_name := 'tunnel_thematic_surface';
    WHEN class_id = 99 OR 
         class_id = 100 THEN table_name := 'tunnel_opening';		 
    WHEN class_id = 101 THEN table_name := 'tunnel_furniture';
    WHEN class_id = 102 THEN table_name := 'tunnel_hollow_space';
  ELSE
    RAISE NOTICE 'Table name unknown.';
  END CASE;
  
  RETURN table_name;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
-- ALTER FUNCTION citydb_pkg.objectclass_id_to_table_name(integer) OWNER TO postgres;

----------------------------------------------------------------
-- Function citydb_pkg.OBJECTCLASS_ID_TO_TABLE_NAME
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_pkg.objectclass_id_to_table_name(integer); -- drops leftover, just in case.
DROP FUNCTION IF EXISTS citydb_pkg.objectclass_id_to_table_name(integer, varchar);
CREATE OR REPLACE FUNCTION citydb_pkg.objectclass_id_to_table_name(
	class_id integer,
	schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS varchar AS
$BODY$
DECLARE
	table_name varchar;
BEGIN
IF class_id IS NOT NULL THEN
	EXECUTE format('SELECT tablename FROM %I.objectclass WHERE id=%L', schema_name, db_prefix) INTO table_name;
	IF table_name IS NOT NULL THEN
		RETURN table_name;
	ELSE
		RAISE NOTICE 'Table name unknown';
		RETURN NULL;
	END IF;
ELSE
	RAISE NOTICE 'objectclass_id_to_table_name: Class_id is NULL';
	RETURN NULL;
END IF;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.objectclass_id_to_table_name(%) in schema %, %', class_id, table_name, SQLERRM;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function CLEANUP_SCHEMA_orig
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_pkg.cleanup_schema(text);
DROP FUNCTION IF EXISTS citydb_pkg.cleanup_schema_orig(varchar);
CREATE OR REPLACE FUNCTION citydb_pkg.cleanup_schema_orig(
	schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS void AS
$BODY$
BEGIN
-- clear tables
EXECUTE format('TRUNCATE TABLE %I.cityobject CASCADE', schema_name);
EXECUTE format('TRUNCATE TABLE %I.tex_image CASCADE', schema_name);
EXECUTE format('TRUNCATE TABLE %I.grid_coverage CASCADE', schema_name);
EXECUTE format('TRUNCATE TABLE %I.address CASCADE', schema_name);
EXECUTE format('TRUNCATE TABLE %I.citymodel CASCADE', schema_name);
-- restart sequences
EXECUTE format('ALTER SEQUENCE %I.address_seq RESTART', schema_name);
EXECUTE format('ALTER SEQUENCE %I.appearance_seq RESTART', schema_name);
EXECUTE format('ALTER SEQUENCE %I.citymodel_seq RESTART', schema_name);
EXECUTE format('ALTER SEQUENCE %I.cityobject_genericatt_seq RESTART', schema_name);
EXECUTE format('ALTER SEQUENCE %I.cityobject_seq RESTART', schema_name);
EXECUTE format('ALTER SEQUENCE %I.external_ref_seq RESTART', schema_name);
EXECUTE format('ALTER SEQUENCE %I.grid_coverage_seq RESTART', schema_name);
EXECUTE format('ALTER SEQUENCE %I.implicit_geometry_seq RESTART', schema_name);
EXECUTE format('ALTER SEQUENCE %I.surface_data_seq RESTART', schema_name);
EXECUTE format('ALTER SEQUENCE %I.surface_geometry_seq RESTART', schema_name);
EXECUTE format('ALTER SEQUENCE %I.tex_image_seq RESTART', schema_name);

EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.cleanup_schema: %', SQLERRM;
END; 
$BODY$
  LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function CLEANUP_SCHEMA
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_pkg.cleanup_schema(varchar);
CREATE OR REPLACE FUNCTION citydb_pkg.cleanup_schema(
	schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS void AS
$BODY$
DECLARE
	test varchar = NULL;
	db_prefix varchar;	
BEGIN
-- First check whether there are ADE-related tables (by db_prefix)
-- If so, then first truncate the ADE-tables, and only then proceed
-- with the vanilla tables
EXECUTE format('SELECT db_prefix FROM %I.ade LIMIT 1',schema_name) INTO test;
IF test IS NOT NULL THEN
	-- there is at least an ADE
	FOR db_prefix IN EXECUTE format('SELECT db_prefix FROM %I.ade', schema_name) LOOP
		--RAISE NOTICE '---------- Found db_prefix: "%" in %',db_prefix, schema_name;
		EXECUTE format('SELECT citydb_pkg.%I_cleanup_schema(%L)',db_prefix, schema_name);
	END LOOP;
	RAISE NOTICE '--- Completed data cleanup of ADE with db_prefix: "%" in %',db_prefix, schema_name;
ELSE
-- do nothing
END IF;

-- Now proceed with the vanilla tables.
-- clear vanilla tables
EXECUTE format('TRUNCATE TABLE %I.cityobject CASCADE', schema_name);
EXECUTE format('TRUNCATE TABLE %I.tex_image CASCADE', schema_name);
EXECUTE format('TRUNCATE TABLE %I.grid_coverage CASCADE', schema_name);
EXECUTE format('TRUNCATE TABLE %I.address CASCADE', schema_name);
EXECUTE format('TRUNCATE TABLE %I.citymodel CASCADE', schema_name);
--restart vanilla sequences
EXECUTE format('ALTER SEQUENCE %I.address_seq RESTART', schema_name);
EXECUTE format('ALTER SEQUENCE %I.appearance_seq RESTART', schema_name);
EXECUTE format('ALTER SEQUENCE %I.citymodel_seq RESTART', schema_name);
EXECUTE format('ALTER SEQUENCE %I.cityobject_genericatt_seq RESTART', schema_name);
EXECUTE format('ALTER SEQUENCE %I.cityobject_seq RESTART', schema_name);
EXECUTE format('ALTER SEQUENCE %I.external_ref_seq RESTART', schema_name);
EXECUTE format('ALTER SEQUENCE %I.grid_coverage_seq RESTART', schema_name);
EXECUTE format('ALTER SEQUENCE %I.implicit_geometry_seq RESTART', schema_name);
EXECUTE format('ALTER SEQUENCE %I.surface_data_seq RESTART', schema_name);
EXECUTE format('ALTER SEQUENCE %I.surface_geometry_seq RESTART', schema_name);
EXECUTE format('ALTER SEQUENCE %I.tex_image_seq RESTART', schema_name);

EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.cleanup_schema: %', SQLERRM;
END; 
$BODY$
  LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function INTERN_DELETE_CITYOBJECT_orig
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_pkg.intern_delete_cityobject(integer, text);
DROP FUNCTION IF EXISTS citydb_pkg.intern_delete_cityobject_orig(integer, varchar);
CREATE OR REPLACE FUNCTION citydb_pkg.intern_delete_cityobject_orig(
	co_id integer,
	schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
	deleted_id INTEGER;
BEGIN
--// PRE DELETE CITY OBJECT //--
-- delete reference to city model
EXECUTE format('DELETE FROM %I.cityobject_member WHERE cityobject_id = %L', schema_name, co_id);
-- delete reference to city object group
EXECUTE format('DELETE FROM %I.group_to_cityobject WHERE cityobject_id = %L', schema_name, co_id);
-- delete reference to generalization
EXECUTE format('DELETE FROM %I.generalization WHERE generalizes_to_id = %L', schema_name, co_id);
EXECUTE format('DELETE FROM %I.generalization WHERE cityobject_id = %L', schema_name, co_id);
-- delete external references of city object
EXECUTE format('DELETE FROM %I.external_reference WHERE cityobject_id = %L', schema_name, co_id);
-- delete generic attributes of city object
EXECUTE format('DELETE FROM %I.cityobject_genericattrib WHERE cityobject_id = %L', schema_name, co_id);
EXECUTE format('UPDATE %I.cityobjectgroup SET parent_cityobject_id=null WHERE parent_cityobject_id = %L', schema_name, co_id);
-- delete local appearances of city object 
EXECUTE format('SELECT citydb_pkg.delete_appearance(id, 0, %L) FROM %I.appearance WHERE cityobject_id = %L', schema_name, schema_name, co_id);
--// DELETE CITY OBJECT //--
EXECUTE format('DELETE FROM %I.cityobject WHERE id = %L RETURNING id', schema_name, co_id) INTO deleted_id;
RETURN deleted_id;
EXCEPTION
WHEN OTHERS THEN RAISE NOTICE 'intern_delete_cityobject (id: %): %', co_id, SQLERRM;
END; 
$BODY$
  LANGUAGE plpgsql VOLATILE COST 100;
--ALTER FUNCTION citydb_pkg.intern_delete_cityobject_orig(integer, varchar) OWNER TO postgres;

----------------------------------------------------------------
-- Function INTERN_DELETE_CITYOBJECT
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_pkg.intern_delete_cityobject(integer, text);
DROP FUNCTION IF EXISTS citydb_pkg.intern_delete_cityobject(integer, varchar);
CREATE OR REPLACE FUNCTION citydb_pkg.intern_delete_cityobject(
	co_id integer,
	schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
	test varchar = NULL;
	db_prefix varchar;
	deleted_id INTEGER;
BEGIN
--// START ADE PRE DELETE CITYOBJECT //--
-- First check whether there are ADEs (by db_prefix)
-- If so, then first run the ADE-related intern_delete_cityobject(),
-- and then continue with the vanilla intern_delete_cityobject().
EXECUTE format('SELECT db_prefix FROM %I.ade LIMIT 1',schema_name) INTO test;
IF test IS NOT NULL THEN
	-- there is at least an ADE
	FOR db_prefix IN EXECUTE format('SELECT db_prefix FROM %I.ade', schema_name) LOOP
		--RAISE NOTICE '---------- Found db_prefix: "%" in %',db_prefix, schema_name;
		EXECUTE format('SELECT citydb_pkg.%I_intern_delete_cityobject(%L,%L)',db_prefix, co_id, schema_name);
	END LOOP;
ELSE
-- do nothing
END IF;
--// END ADE PRE DELETE ADE CITYOBJECT //--

--// VANILLA PRE DELETE CITY OBJECT //--
-- delete reference to city model
EXECUTE format('DELETE FROM %I.cityobject_member WHERE cityobject_id = %L', schema_name, co_id);
-- delete reference to city object group
EXECUTE format('DELETE FROM %I.group_to_cityobject WHERE cityobject_id = %L', schema_name, co_id);
-- delete reference to generalization
EXECUTE format('DELETE FROM %I.generalization WHERE generalizes_to_id = %L', schema_name, co_id);
EXECUTE format('DELETE FROM %I.generalization WHERE cityobject_id = %L', schema_name, co_id);
-- delete external references of city object
EXECUTE format('DELETE FROM %I.external_reference WHERE cityobject_id = %L', schema_name, co_id);
-- delete generic attributes of city object
EXECUTE format('DELETE FROM %I.cityobject_genericattrib WHERE cityobject_id = %L', schema_name, co_id);
EXECUTE format('UPDATE %I.cityobjectgroup SET parent_cityobject_id=null WHERE parent_cityobject_id = %L', schema_name, co_id);
-- delete local appearances of city object 
EXECUTE format('SELECT citydb_pkg.delete_appearance(id, 0, %L) FROM %I.appearance WHERE cityobject_id = %L', schema_name, schema_name, co_id);
--// DELETE CITY OBJECT //--
EXECUTE format('DELETE FROM %I.cityobject WHERE id = %L RETURNING id', schema_name, co_id) INTO deleted_id;
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.nrg8a_intern_delete_cityobject (id: %): %', co_id, SQLERRM;
END; 
$BODY$
  LANGUAGE plpgsql VOLATILE COST 100;
--ALTER FUNCTION citydb_pkg.intern_delete_cityobject_orig(integer, varchar) OWNER TO postgres;

----------------------------------------------------------------
-- Function citydb_pkg.OBJECTCLASS_CLASSNAME_TO_ID
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_pkg.objectclass_classname_to_id(varchar, varchar, varchar);
CREATE OR REPLACE FUNCTION citydb_pkg.objectclass_classname_to_id(
	class_name varchar,
	db_prefix varchar,
	schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
	class_id varchar;
BEGIN
IF class_name IS NOT NULL THEN
	IF db_prefix IS NULL THEN
		-- we are looking for a vanilla objectclass
		EXECUTE format('SELECT o.id FROM %I.objectclass o WHERE o.classname=%L', schema_name, class_name) INTO class_id;
	ELSE
		-- we are looking for an ADE objectclass
		EXECUTE format('SELECT o.id FROM %I.ade a, %I.schema s, %I.schema_to_objectclass so, %I.objectclass o WHERE a.id = s.ade_id AND s.id = so.schema_id AND so.objectclass_id = o.id AND a.db_prefix=%L AND o.classname=%L LIMIT 1',
		schema_name, schema_name, schema_name, schema_name, db_prefix, class_name) INTO class_id;
	END IF;
	IF class_id IS NOT NULL THEN
		RETURN class_id;
	ELSE
		RAISE EXCEPTION 'citydb_pkg.objectclass_classname_to_id: class_id is NULL for db_prefix "%" and classname "%"', db_prefix, class_name;
	END IF;
ELSE
	RAISE EXCEPTION 'citydb_pkg.objectclass_classname_to_id: class_name is NULL for db_prefix "%" and classname "%"',db_prefix, class_name;
END IF;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.objectclass_classname_to_id (db_prefix "%", classname "%"): %)', db_prefix, class_name, SQLERRM;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION citydb_pkg.objectclass_classname_to_id(varchar, varchar, varchar) OWNER TO postgres;

-- ***********************************************************************
-- ***********************************************************************

DO
$$
BEGIN
RAISE NOTICE '

********************************

Metadata module functions installation complete!

********************************

';
END
$$;
SELECT 'Metadata module functions installed correctly!'::varchar AS installation_result;


-- ***********************************************************************
-- ***********************************************************************
--
-- END OF FILE
--
-- ***********************************************************************
-- ***********************************************************************


















