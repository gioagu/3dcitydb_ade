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
-- **************** 01_UtilityNetworks_ADE_FUNCTIONS.sql *****************
--
-- This script adds the stored procedures to the citydb_pkg schema.
-- They are all prefixed with "utn9_".
--
-- ATTENTION:
-- Please check to have installed the metadata module before.
--
-- ***********************************************************************
-- ***********************************************************************

-- Deletes all entries in the database.
SELECT citydb_pkg.cleanup_schema('citydb');

-- Unistall the Utility Network ADE in case there is a previous installation
-- with the same db_prefix.
WITH a AS (
SELECT id FROM citydb.ade WHERE db_prefix='utn9'
)
SELECT citydb_pkg.drop_ade(a.id) FROM a;

----------------------------------------------------------------
-- Function UTN_SET_ADE_COLUMN_SRID
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_pkg.utn9_set_ade_columns_srid(varchar);
CREATE OR REPLACE FUNCTION citydb_pkg.utn9_set_ade_columns_srid(
	schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS void AS $$
DECLARE
BEGIN
-- execute the stored procedure to set the srid of the new geometry columns
PERFORM citydb_pkg.change_ade_column_srid('utn9_network_feature', 'geom', 'GEOMETRYZ', schema_name);
PERFORM citydb_pkg.change_ade_column_srid('utn9_node', 'point_geom', 'POINTZ', schema_name);
PERFORM citydb_pkg.change_ade_column_srid('utn9_link', 'line_geom', 'LINESTRINGZ', schema_name);

RAISE NOTICE 'Geometry columns of Utility Networks ADE set to current database SRID';
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.utn9_set_ade_columns_srid (schema: %): %', schema_name, SQLERRM;
END;
$$
LANGUAGE plpgsql;
-- ALTER FUNCTION citydb_pkg.utn9_set_ade_columns_srid(varchar) OWNER TO postgres;

----------------------------------------------------------------
-- Function UTN_CLEANUP_SCHEMA
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_pkg.utn9_cleanup_schema(varchar);
CREATE OR REPLACE FUNCTION citydb_pkg.utn9_cleanup_schema(
	schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS void AS $BODY$
DECLARE
BEGIN
-- truncate the tables
EXECUTE format('TRUNCATE TABLE %I.utn9_storage CASCADE', schema_name);
EXECUTE format('TRUNCATE TABLE %I.utn9_medium_supply CASCADE', schema_name);
EXECUTE format('TRUNCATE TABLE %I.utn9_role_in_network CASCADE', schema_name);
EXECUTE format('TRUNCATE TABLE %I.utn9_comm_class_to_comm_class CASCADE', schema_name);
EXECUTE format('TRUNCATE TABLE %I.utn9_commodity_classifier CASCADE', schema_name);
EXECUTE format('TRUNCATE TABLE %I.utn9_commodity CASCADE', schema_name);
EXECUTE format('TRUNCATE TABLE %I.utn9_network_feat_to_material CASCADE', schema_name);
EXECUTE format('TRUNCATE TABLE %I.utn9_material CASCADE', schema_name);
EXECUTE format('TRUNCATE TABLE %I.utn9_hollow_space CASCADE', schema_name);
EXECUTE format('TRUNCATE TABLE %I.utn9_building CASCADE', schema_name);
-- Network Components
EXECUTE format('TRUNCATE TABLE %I.utn9_protective_element CASCADE', schema_name);
EXECUTE format('TRUNCATE TABLE %I.utn9_distrib_element CASCADE', schema_name);
-- Core module: Topology
EXECUTE format('TRUNCATE TABLE %I.utn9_node CASCADE', schema_name);
EXECUTE format('TRUNCATE TABLE %I.utn9_link CASCADE', schema_name);
EXECUTE format('TRUNCATE TABLE %I.utn9_feature_graph CASCADE', schema_name);
EXECUTE format('TRUNCATE TABLE %I.utn9_network_graph CASCADE', schema_name);
-- Core module: Geography
EXECUTE format('TRUNCATE TABLE %I.utn9_network_to_network_feature CASCADE', schema_name);
EXECUTE format('TRUNCATE TABLE %I.utn9_network_to_supply_area CASCADE', schema_name);
EXECUTE format('TRUNCATE TABLE %I.utn9_network_to_network CASCADE', schema_name);
EXECUTE format('TRUNCATE TABLE %I.utn9_network_feature CASCADE', schema_name);
EXECUTE format('TRUNCATE TABLE %I.utn9_network CASCADE', schema_name);

-- Restart sequences
EXECUTE format('ALTER SEQUENCE %I.utn9_commodity_classifier_id_seq RESTART', schema_name);
EXECUTE format('ALTER SEQUENCE %I.utn9_commodity_id_seq RESTART', schema_name);
EXECUTE format('ALTER SEQUENCE %I.utn9_feature_graph_id_seq RESTART', schema_name);
EXECUTE format('ALTER SEQUENCE %I.utn9_hollow_space_id_seq RESTART', schema_name);
EXECUTE format('ALTER SEQUENCE %I.utn9_link_id_seq RESTART', schema_name);
EXECUTE format('ALTER SEQUENCE %I.utn9_material_id_seq RESTART', schema_name);
EXECUTE format('ALTER SEQUENCE %I.utn9_medium_supply_id_seq RESTART', schema_name);
EXECUTE format('ALTER SEQUENCE %I.utn9_network_graph_id_seq RESTART', schema_name);
EXECUTE format('ALTER SEQUENCE %I.utn9_node_id_seq RESTART', schema_name);
EXECUTE format('ALTER SEQUENCE %I.utn9_role_in_network_id_seq RESTART', schema_name);
EXECUTE format('ALTER SEQUENCE %I.utn9_storage_id_seq RESTART', schema_name);
-- Finished, now call the standard clear_schema function(s).
EXCEPTION
    WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.utn9_cleanup_schema: %', SQLERRM;
END; 
$BODY$
  LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function UTN_INTERN_DELETE_CITYOBJECT
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_pkg.utn9_intern_delete_cityobject(integer, varchar);
CREATE OR REPLACE FUNCTION citydb_pkg.utn9_intern_delete_cityobject(
	co_id integer,
	schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS void AS
$BODY$
DECLARE
	ms_id integer;
	deleted_id integer;
BEGIN
--// START PRE DELETE ADE CITYOBJECT //--
-- delete all medium_supplies related to this object
FOR ms_id IN EXECUTE format('SELECT id FROM %I.utn9_medium_supply WHERE cityobject_id = %L', schema_name, co_id) LOOP
	IF ms_id IS NOT NULL THEN
		-- delete dependent medium_supplies
		EXECUTE 'SELECT citydb_pkg.utn9_delete_medium_supply($1, $2)' USING ws_id, schema_name;
	END IF;
END LOOP;
--// END PRE DELETE ENERGY ADE CITYOBJECT //--
-- NO NEED TO DELETE CITYOBJECT, it is taken care in the vanilla intern_delete_cityobject() function.
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.utn9_intern_delete_cityobject (id: %): %', co_id, SQLERRM;
END; 
$BODY$ LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function UTN_DELETE_CITYOBJECT 
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_pkg.utn9_delete_cityobject(integer, integer, integer, varchar);
CREATE OR REPLACE FUNCTION citydb_pkg.utn9_delete_cityobject(
	co_id integer,
	delete_members integer DEFAULT 0,
	cleanup integer DEFAULT 0,
	schema_name varchar DEFAULT 'citydb'::text)
  RETURNS integer AS
$BODY$
DECLARE
	class_id INTEGER;
	classname varchar;
	deleted_id INTEGER;
BEGIN
EXECUTE format('SELECT objectclass_id FROM %I.cityobject WHERE id=%L', schema_name, co_id) INTO class_id;
EXECUTE format('SELECT citydb_pkg.get_classname(%L,%L)', class_id, schema_name) INTO classname;
--RAISE NOTICE 'class id %, classname %',class_id, classname;
-- classname can be NULL if object has already been deleted
IF classname IS NOT NULL THEN
  CASE
    WHEN classname = 'Network'        THEN deleted_id := citydb_pkg.utn9_delete_network(co_id, schema_name);
    WHEN classname = 'SupplyArea'     THEN deleted_id := citydb_pkg.utn9_delete_supply_area(co_id, delete_members, schema_name);
    WHEN classname IN ('Bedding', 'RectangularShell', 'RoundShell', 'OtherShell', 'Cable', 'Canal', 'SemiOpenCanal', 'ClosedCanal', 'RoundPipe', 'RectangularPipe', 'OtherShapePipe', 'ComplexFunctionalElement', 'SimpleFunctionalElement', 'TerminalElement', 'StorageDevice', 'TechDevice', 'MeasurementDevice', 'ControllerDevice', 'AnyDevice') 
			THEN deleted_id := citydb_pkg.utn9_delete_network_feature(co_id, schema_name);
    ELSE
     RAISE NOTICE 'Cannot delete chosen object with ID % and classname %', co_id, classname;
  END CASE;
END IF;
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.utn9_delete_cityobject (id: %): %', co_id, SQLERRM;
END; 
$BODY$ LANGUAGE plpgsql;

----------------------------------------------------------------
-- Function UTN9_GET_ENVELOPE_CITYOBJECT
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_pkg.utn9_get_envelope_cityobject(integer, integer, integer, varchar);
CREATE OR REPLACE FUNCTION citydb_pkg.utn9_get_envelope_cityobject(
	co_id integer,
	objclass_id integer DEFAULT 0,  -- not used anymore, but kept for compatibility
	set_envelope integer DEFAULT 0,
	schema_name varchar DEFAULT 'citydb'::varchar)
  RETURNS geometry AS
$BODY$
DECLARE
	class_id INTEGER;
	classname varchar;
	envelope GEOMETRY;
BEGIN
EXECUTE format('SELECT objectclass_id FROM %I.cityobject WHERE id=%L', schema_name, co_id) INTO class_id;
EXECUTE format('SELECT citydb_pkg.get_classname(%L,%L)', class_id, schema_name) INTO classname;
-- class_name can be NULL if object has already been deleted
IF classname IS NOT NULL THEN
	CASE
		WHEN classname = 'Network'    THEN envelope := citydb_pkg.utn9_get_envelope_network(co_id, set_envelope, schema_name);
		WHEN classname = 'SupplyArea' THEN envelope := citydb_pkg.utn9_get_envelope_supply_area(co_id, set_envelope, 1, schema_name);
		WHEN classname IN ('Bedding', 'RectangularShell', 'RoundShell', 'OtherShell', 'Cable', 'Canal', 'SemiOpenCanal', 'ClosedCanal', 'RoundPipe', 'RectangularPipe', 'OtherShapePipe', 'ComplexFunctionalElement', 'SimpleFunctionalElement', 'TerminalElement', 'StorageDevice', 'TechDevice', 'MeasurementDevice', 'ControllerDevice', 'AnyDevice')	
		  THEN envelope := citydb_pkg.utn9_get_envelope_network_feature(co_id, set_envelope, schema_name);
	ELSE
		RAISE NOTICE 'Cannot get envelope of object with ID % class_name %', co_id, classname;
	END CASE;
END IF;
RETURN envelope;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.utn9_get_envelope_cityobject (id: %): %', co_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION citydb_pkg.utn9_get_envelope_cityobject(integer, integer, integer, varchar) OWNER TO postgres;

	
-- ***********************************************************************
-- ***********************************************************************

DO
$$
BEGIN
RAISE NOTICE '

********************************

Utility Network ADE functions installation complete!

********************************

';
END
$$;
SELECT 'Utility Network ADE functions installation complete!'::varchar AS installation_result;

-- ***********************************************************************
-- ***********************************************************************
--
-- END OF FILE
--
-- ***********************************************************************
-- ***********************************************************************
