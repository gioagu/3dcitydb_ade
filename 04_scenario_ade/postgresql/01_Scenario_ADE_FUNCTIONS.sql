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
-- **************** 01_Scenario_ADE_FUNCTIONS.sql *******************
--
-- This script adds the stored procedures to the citydb_pkg schema.
-- They are all prefixed with "scn2_".
--
-- ATTENTION:
-- Please check to have installed the metadata module before.
--
-- ***********************************************************************
-- ***********************************************************************

-- Unistall the scenario ADE in case there is a previous installation
-- with the same db_prefix.
SELECT citydb_pkg.cleanup_schema();

WITH a AS (
SELECT id FROM citydb.ade WHERE db_prefix='scn2'
)
SELECT citydb_pkg.drop_ade(a.id) FROM a;

----------------------------------------------------------------
-- Function citydb_pkg.DELETE_CITYMODEL_orig 
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_pkg.delete_citymodel(integer, integer, text);
DROP FUNCTION IF EXISTS    citydb_pkg.delete_citymodel_orig(integer, integer, text);
CREATE OR REPLACE FUNCTION citydb_pkg.delete_citymodel_orig(
  cm_id integer,
  delete_members integer DEFAULT 0,
  schema_name text DEFAULT 'citydb'::text)
RETURNS integer
LANGUAGE 'plpgsql'
AS $BODY$
DECLARE
  deleted_id INTEGER;
  member_id INTEGER;
BEGIN
  --// PRE DELETE CITY MODEL //--
  -- delete members
  IF delete_members <> 0 THEN
    FOR member_id IN EXECUTE format('SELECT cityobject_id FROM %I.cityobject_member WHERE citymodel_id = %L', 
                                        schema_name, cm_id) LOOP
      BEGIN
        EXECUTE 'SELECT citydb_pkg.delete_cityobject($1, $2, 0, $3)' USING member_id, delete_members, schema_name;

        EXCEPTION
          WHEN OTHERS THEN
            RAISE NOTICE 'delete_citymodel: deletion of cityobject_member with ID % threw %', member_id, SQLERRM;
      END;
    END LOOP;

    -- cleanup
    EXECUTE 'SELECT citydb_pkg.cleanup_implicit_geometries(1, $1)' USING schema_name;
    EXECUTE 'SELECT citydb_pkg.cleanup_appearances(1, $1)' USING schema_name;
  END IF;
  
  -- delete reference to city objects
  EXECUTE format('DELETE FROM %I.cityobject_member WHERE citymodel_id = %L', schema_name, cm_id);

  -- delete appearances assigned to the city model
  EXECUTE format('SELECT citydb_pkg.delete_appearance(id, 0, %L) FROM %I.appearance WHERE citymodel_id = %L', 
                    schema_name, schema_name, cm_id);

  --// DELETE CITY MODEL //--
  EXECUTE format('DELETE FROM %I.citymodel WHERE id = %L RETURNING id', schema_name, cm_id) INTO deleted_id;

  RETURN deleted_id;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE NOTICE 'delete_citymodel (id: %): %', cm_id, SQLERRM;
END; 
$BODY$;
-- ALTER FUNCTION citydb_pkg.delete_citymodel(integer, integer, text) OWNER TO postgres;

----------------------------------------------------------------
-- Function citydb_pkg.DELETE_CITYMODEL
----------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_pkg.delete_citymodel(
  cm_id integer,
  delete_members integer DEFAULT 0,
  schema_name varchar DEFAULT 'citydb'::varchar)
RETURNS integer
LANGUAGE 'plpgsql'
AS $BODY$
DECLARE
  deleted_id INTEGER;
  member_id INTEGER;
  flag integer;
BEGIN
-- delete cityobjects that are members of this citymodel (at least those not referenced by other city models)
IF delete_members <> 0 THEN

  FOR member_id IN EXECUTE format('SELECT co.id FROM %I.cityobject AS co, %I.cityobject_member AS com WHERE co.id=com.cityobject_id AND
    com.citymodel_id=%L AND citydb_pkg.is_not_referenced(''cityobject_member'', ''cityobject_id'', co.id, ''citymodel_id'', %L, %L)',
    schema_name, schema_name, cm_id, cm_id, schema_name) LOOP
    IF member_id IS NOT NULL THEN
		EXECUTE 'SELECT citydb_pkg.delete_cityobject($1, $2, 0, $3)' USING member_id, delete_members, schema_name;
	END IF;
  END LOOP;
  -- cleanup
  EXECUTE 'SELECT citydb_pkg.cleanup_implicit_geometries(1, $1)' USING schema_name;
  EXECUTE 'SELECT citydb_pkg.cleanup_appearances(1, $1)' USING schema_name;
END IF;
  
-- delete reference to city objects in table CITYOBJECT_MEMBER
EXECUTE format('DELETE FROM %I.cityobject_member WHERE citymodel_id = %L', schema_name, cm_id);

-- delete appearances assigned to the city model
EXECUTE format('SELECT citydb_pkg.delete_appearance(id, 0, %L) FROM %I.appearance WHERE citymodel_id = %L', schema_name, schema_name, cm_id);

--// DELETE CITY MODEL //--
EXECUTE format('DELETE FROM %I.citymodel WHERE id = %L RETURNING id', schema_name, cm_id) INTO deleted_id;
RETURN deleted_id;

EXCEPTION
  WHEN OTHERS THEN RAISE NOTICE 'citydb.delete_citymodel (id: %): %', cm_id, SQLERRM;
END; 
$BODY$;
-- ALTER FUNCTION citydb_pkg.delete_citymodel(integer, integer, text) OWNER TO postgres;

----------------------------------------------------------------
-- Function SCN_SET_ADE_COLUMN_SRID
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_pkg.scn2_set_ade_columns_srid(varchar);
CREATE OR REPLACE FUNCTION citydb_pkg.scn2_set_ade_columns_srid(
	schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS void AS $$
DECLARE
BEGIN
-- execute the stored procedure to set the srid of the new geometry columns
PERFORM citydb_pkg.change_ade_column_srid('scn2_scenario', 'envelope', 'POLYGONZ', schema_name);
PERFORM citydb_pkg.change_ade_column_srid('scn2_operation', 'geomval', 'GEOMETRYZ', schema_name);
PERFORM citydb_pkg.change_ade_column_srid('scn2_scenario_parameter', 'geomval', 'GEOMETRYZ', schema_name);
RAISE NOTICE 'Geometry columns of Scenario ADE set to current database SRID';
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.scn2_set_ade_columns_srid (schema: %): %', schema_name, SQLERRM;
END;
$$
LANGUAGE plpgsql;
-- ALTER FUNCTION citydb_pkg.scn2_set_ade_columns_srid(varchar) OWNER TO postgres;

----------------------------------------------------------------
-- Function SCN_CLEANUP_SCHEMA
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_pkg.scn2_cleanup_schema(varchar);
CREATE OR REPLACE FUNCTION citydb_pkg.scn2_cleanup_schema(
	schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS void AS $BODY$
DECLARE
BEGIN
-- truncate the tables
EXECUTE format('TRUNCATE TABLE %I.scn2_time_series_file CASCADE', schema_name);
EXECUTE format('TRUNCATE TABLE %I.scn2_time_series CASCADE', schema_name);
EXECUTE format('TRUNCATE TABLE %I.scn2_resource CASCADE', schema_name);
EXECUTE format('TRUNCATE TABLE %I.scn2_scenario_parameter CASCADE', schema_name);
EXECUTE format('TRUNCATE TABLE %I.scn2_operation CASCADE', schema_name);
EXECUTE format('TRUNCATE TABLE %I.scn2_scenario CASCADE', schema_name);

-- restart sequences
EXECUTE format('ALTER SEQUENCE %I.scn2_time_series_id_seq RESTART', schema_name);
EXECUTE format('ALTER SEQUENCE %I.scn2_scenario_id_seq RESTART', schema_name);
EXECUTE format('ALTER SEQUENCE %I.scn2_operation_id_seq RESTART', schema_name);
EXECUTE format('ALTER SEQUENCE %I.scn2_scenario_parameter_id_seq RESTART', schema_name);
EXECUTE format('ALTER SEQUENCE %I.scn2_resource_id_seq RESTART', schema_name);

-- Finished, now call the standard clear_schema function(s).
EXCEPTION
    WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.scn2_cleanup_schema: %', SQLERRM;
END; 
$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION citydb_pkg.scn2_cleanup_schema(varchar) OWNER TO postgres;

----------------------------------------------------------------
-- Function SCN_INTERN_DELETE_CITYOBJECT
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_pkg.scn2_intern_delete_cityobject(integer, varchar);
CREATE OR REPLACE FUNCTION citydb_pkg.scn2_intern_delete_cityobject(
	co_id integer,
	schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS void AS
$BODY$
DECLARE
  sp_id integer;
  op_id integer;
  sc_id integer;	
	deleted_id INTEGER;
BEGIN
--// START PRE DELETE ADE CITYOBJECT //--
-- Delete scenario parameter 
FOR sp_id IN EXECUTE format('SELECT id FROM %I.scn2_scenario_parameter WHERE cityobject_id = %L', schema_name, sp_id) LOOP
	IF sp_id IS NOT NULL THEN
		-- delete dependent scenario parameter 
		EXECUTE 'SELECT citydb_pkg.scn2_delete_scenario_parameter($1, $2)' USING sp_id, schema_name;
	END IF;
END LOOP;
-- Delete dependent scenario
FOR sc_id IN EXECUTE format('SELECT id FROM %I.scn2_scenario WHERE cityobject_id = %L', schema_name, sc_id) LOOP
	IF sc_id IS NOT NULL THEN
		-- delete dependent scenario 
		EXECUTE 'SELECT citydb_pkg.scn2_delete_scenario($1, $2)' USING sc_id, schema_name;
	END IF;
END LOOP;
--// END PRE DELETE ENERGY ADE CITYOBJECT //--
-- NO NEED TO DELETE CITYOBJECT, it is taken care in the vanilla intern_delete_cityobject() function.
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.scn2_intern_delete_cityobject (id: %): %', co_id, SQLERRM;
END; 
$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION citydb_pkg.scn2_intern_delete_cityobject_orig(integer, varchar) OWNER TO postgres;

----------------------------------------------------------------
-- Function SCN_DELETE_CITYOBJECT 
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_pkg.scn2_delete_cityobject(integer, integer, integer, varchar);
CREATE OR REPLACE FUNCTION citydb_pkg.scn2_delete_cityobject(
	co_id integer,
	delete_members integer DEFAULT 0,
	cleanup integer DEFAULT 0,
	schema_name varchar DEFAULT 'citydb'::text)
RETURNS integer AS
$BODY$
DECLARE
	class_id INTEGER;
	classname varchar;
	deleted_id integer;
BEGIN
-- EXECUTE format('SELECT objectclass_id FROM %I.cityobject WHERE id=%L', schema_name, co_id) INTO class_id;
-- EXECUTE format('SELECT citydb_pkg.get_classname(%L,%L)', class_id, schema_name) INTO classname;
-- DUMMY FUNCTION, there are (as of now) no cityobjects in the Scenario ADE
deleted_id:=NULL;
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.scn2_delete_cityobject (id: %): %', co_id, SQLERRM;
END; 
$BODY$
  LANGUAGE plpgsql;
--ALTER FUNCTION citydb_pkg.scn2_delete_cityobject(integer, integer, integer, text) OWNER TO postgres;

-- ***********************************************************************
-- ***********************************************************************

DO
$$
BEGIN
RAISE NOTICE '

********************************

Scenario ADE functions installation complete!

********************************

';
END
$$;
SELECT 'Scenario ADE functions installation complete!'::varchar AS installation_result;

-- ***********************************************************************
-- ***********************************************************************
--
-- END OF FILE
--
-- ***********************************************************************
-- ***********************************************************************
