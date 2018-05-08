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
-- ************** 07_UtilityNetworks_ADE_VIEW_FUNCTIONS.sql **************
--
-- This script adds stored procedured to schema citydb_view. They are all
-- prefixed with "utn9_".
--
-- ***********************************************************************
-- ***********************************************************************

----------------------------------------------------------------
-- DROP existing prefixed insert functions
----------------------------------------------------------------
DO $$
DECLARE
db_schema varchar DEFAULT 'citydb_view'::varchar;
db_prefix varchar DEFAULT 'utn9'::varchar;
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
db_prefix varchar DEFAULT 'utn9'::varchar;
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
-- Function UTN9_DELETE_BUILDING
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.utn9_delete_building(
  IN id integer,
  IN schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
	deleted_id integer;
BEGIN
deleted_id=citydb_pkg.delete_building(id, schema_name);
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_delete_building (id: %): %', id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function UTN9_DELETE_BUILDING_PART
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.utn9_delete_building(
  IN id integer,
  IN schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
	deleted_id integer;
BEGIN
deleted_id=citydb_pkg.delete_building(id, schema_name);
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_delete_building_part (id: %): %', id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function UTN9_DELETE_COMMODITY
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.utn9_delete_commodity(
  IN id integer,
  IN schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
	deleted_id integer;
BEGIN
deleted_id=citydb_pkg.utn9_delete_commodity(id, schema_name);
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_delete_commodity (id: %): %', id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function UTN9_DELETE_COMMODITY_ELECTRICAL_MEDIUM
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.utn9_delete_commodity_electrical_medium(
  IN id integer,
  IN schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
	deleted_id integer;
BEGIN
deleted_id=citydb_pkg.utn9_delete_commodity(id, schema_name);
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_delete_commodity_electrical_medium (id: %): %', id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function UTN9_DELETE_COMMODITY_GASEOUS_MEDIUM
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.utn9_delete_commodity_gaseous_medium(
  IN id integer,
  IN schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
	deleted_id integer;
BEGIN
deleted_id=citydb_pkg.utn9_delete_commodity(id, schema_name);
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_delete_commodity_gaseous_medium (id: %): %', id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function UTN9_DELETE_COMMODITY_LIQUID_MEDIUM
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.utn9_delete_commodity_liquid_medium(
  IN id integer,
  IN schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
	deleted_id integer;
BEGIN
deleted_id=citydb_pkg.utn9_delete_commodity(id, schema_name);
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_delete_commodity_liquid_medium (id: %): %', id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function UTN9_DELETE_COMMODITY_OPTICAL_MEDIUM
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.utn9_delete_commodity_optical_medium(
  IN id integer,
  IN schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
	deleted_id integer;
BEGIN
deleted_id=citydb_pkg.utn9_delete_commodity(id, schema_name);
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_delete_commodity_optical_medium (id: %): %', id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function UTN9_DELETE_COMMODITY_SOLID_MEDIUM
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.utn9_delete_commodity_solid_medium(
  IN id integer,
  IN schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
	deleted_id integer;
BEGIN
deleted_id=citydb_pkg.utn9_delete_commodity(id, schema_name);
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_delete_commodity_solid_medium (id: %): %', id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function UTN9_DELETE_COMMODITY_CLASSIFIER
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.utn9_delete_commodity_classifier(
  IN id integer,
  IN schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
	deleted_id integer;
BEGIN
deleted_id=citydb_pkg.utn9_delete_commodity_classifier(id, schema_name);
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_delete_commodity_classifier (id: %): %', id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function UTN9_DELETE_COMMODITY_CLASSIFIER_CHEMICAL
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.utn9_delete_commodity_classifier_chemical(
  IN id integer,
  IN schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
	deleted_id integer;
BEGIN
deleted_id=citydb_pkg.utn9_delete_commodity_classifier(id, schema_name);
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_delete_commodity_classifier_chemical (id: %): %', id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function UTN9_DELETE_COMMODITY_CLASSIFIER_GENERIC
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.utn9_delete_commodity_classifier_generic(
  IN id integer,
  IN schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
	deleted_id integer;
BEGIN
deleted_id=citydb_pkg.utn9_delete_commodity_classifier(id, schema_name);
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_delete_commodity_classifier_generic (id: %): %', id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function UTN9_DELETE_COMMODITY_CLASSIFIER_GHS
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.utn9_delete_commodity_classifier_ghs(
  IN id integer,
  IN schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
	deleted_id integer;
BEGIN
deleted_id=citydb_pkg.utn9_delete_commodity_classifier(id, schema_name);
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_delete_commodity_classifier_ghs (id: %): %', id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function UTN9_DELETE_FEATURE_GRAPH
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.utn9_delete_feature_graph(
  IN id integer,
  IN schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
	deleted_id integer;
BEGIN
deleted_id=citydb_pkg.utn9_delete_feature_graph(id, schema_name);
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_delete_feature_graph (id: %): %', id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function UTN9_DELETE_HOLLOW_SPACE
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.utn9_delete_hollow_space(
  IN id integer,
  IN schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
	deleted_id integer;
BEGIN
deleted_id=citydb_pkg.utn9_delete_hollow_space(id, schema_name);
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_delete_hollow_space (id: %): %', id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function UTN9_DELETE_HOLLOW_SPACE_PART
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.utn9_delete_hollow_space_part(
  IN id integer,
  IN schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
	deleted_id integer;
BEGIN
deleted_id=citydb_pkg.utn9_delete_hollow_space(id, schema_name);
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_delete_hollow_space_part (id: %): %', id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function UTN9_DELETE_LINK_INTER_FEATURE
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.utn9_delete_link_inter_feature(
  IN id integer,
  IN schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
	deleted_id integer;
BEGIN
deleted_id=citydb_pkg.utn9_delete_link(id, schema_name);
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_delete_link_inter_feature (id: %): %', id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function UTN9_DELETE_LINK_INTERIOR_FEATURE
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.utn9_delete_link_interior_feature(
  IN id integer,
  IN schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
	deleted_id integer;
BEGIN
deleted_id=citydb_pkg.utn9_delete_link(id, schema_name);
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_delete_link_interior_feature (id: %): %', id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function UTN9_DELETE_LINK_NETWORK
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.utn9_delete_link_network(
  IN id integer,
  IN schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
	deleted_id integer;
BEGIN
deleted_id=citydb_pkg.utn9_delete_link(id, schema_name);
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_delete_link_network (id: %): %', id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function UTN9_DELETE_MATERIAL
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.utn9_delete_material(
  IN id integer,
  IN schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
	deleted_id integer;
BEGIN
deleted_id=citydb_pkg.utn9_delete_material(id, schema_name);
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_delete_material (id: %): %', id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function UTN9_DELETE_MATERIAL_FILLING
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.utn9_delete_material_filling(
  IN id integer,
  IN schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
	deleted_id integer;
BEGIN
deleted_id=citydb_pkg.utn9_delete_material(id, schema_name);
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_delete_material_filling (id: %): %', id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function UTN9_DELETE_MATERIAL_EXTERIOR
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.utn9_delete_material_exterior(
  IN id integer,
  IN schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
	deleted_id integer;
BEGIN
deleted_id=citydb_pkg.utn9_delete_material(id, schema_name);
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_delete_material_exterior (id: %): %', id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function UTN9_DELETE_MATERIAL_INTERIOR
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.utn9_delete_material_exterior(
  IN id integer,
  IN schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
	deleted_id integer;
BEGIN
deleted_id=citydb_pkg.utn9_delete_material(id, schema_name);
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_delete_material_interior (id: %): %', id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function UTN9_DELETE_MEDIUM_SUPPLY
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.utn9_delete_medium_supply(
  IN id integer,
  IN schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
	deleted_id integer;
BEGIN
deleted_id=citydb_pkg.utn9_delete_medium_supply(id, schema_name);
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_delete_medium_supply (id: %): %', id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function UTN9_DELETE_MEDIUM_SUPPLY_ELECTRICAL
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.utn9_delete_medium_supply_electrical(
  IN id integer,
  IN schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
	deleted_id integer;
BEGIN
deleted_id=citydb_pkg.utn9_delete_medium_supply(id, schema_name);
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_delete_medium_supply_electrical (id: %): %', id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function UTN9_DELETE_MEDIUM_SUPPLY_GASEOUS
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.utn9_delete_medium_supply_gaseous(
  IN id integer,
  IN schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
	deleted_id integer;
BEGIN
deleted_id=citydb_pkg.utn9_delete_medium_supply(id, schema_name);
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_delete_medium_supply_gaseous (id: %): %', id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function UTN9_DELETE_MEDIUM_SUPPLY_LIQUID
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.utn9_delete_medium_supply_liquid(
  IN id integer,
  IN schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
	deleted_id integer;
BEGIN
deleted_id=citydb_pkg.utn9_delete_medium_supply(id, schema_name);
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_delete_medium_supply_liquid (id: %): %', id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function UTN9_DELETE_MEDIUM_SUPPLY_OPTICAL
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.utn9_delete_medium_supply_optical(
  IN id integer,
  IN schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
	deleted_id integer;
BEGIN
deleted_id=citydb_pkg.utn9_delete_medium_supply(id, schema_name);
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_delete_medium_supply_optical (id: %): %', id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function UTN9_DELETE_MEDIUM_SUPPLY_SOLID
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.utn9_delete_medium_supply_solid(
  IN id integer,
  IN schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
	deleted_id integer;
BEGIN
deleted_id=citydb_pkg.utn9_delete_medium_solid(id, schema_name);
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_delete_medium_supply_solid (id: %): %', id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function UTN9_DELETE_NETWORK
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.utn9_delete_network(
  IN id integer,
  IN schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
	deleted_id integer;
BEGIN
deleted_id=citydb_pkg.utn9_delete_network(id, schema_name);
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_delete_network (id: %): %', id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function UTN9_DELETE_NETWORK_GRAPH
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.utn9_delete_network_graph(
  IN id integer,
  IN schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
	deleted_id integer;
BEGIN
deleted_id=citydb_pkg.utn9_delete_network_graph(id, schema_name);
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_delete_network_graph (id: %): %', id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function UTN9_DELETE_NODE
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.utn9_delete_node(
  IN id integer,
  IN schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
	deleted_id integer;
BEGIN
deleted_id=citydb_pkg.utn9_delete_node(id, schema_name);
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_delete_node (id: %): %', id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function UTN9_DELETE_NTW_FEAT_COMPLEX_FUNCT_ELEM
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.utn9_delete_ntw_feat_complex_funct_elem(
  IN id integer,
  IN schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
	deleted_id integer;
BEGIN
deleted_id=citydb_pkg.utn9_delete_network_feature(id, schema_name);
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_delete_ntw_feat_complex_funct_elem (id: %): %', id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function UTN9_DELETE_NTW_FEAT_SIMPLE_FUNCT_ELEM
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.utn9_delete_ntw_feat_simple_funct_elem(
  IN id integer,
  IN schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
	deleted_id integer;
BEGIN
deleted_id=citydb_pkg.utn9_delete_network_feature(id, schema_name);
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_delete_ntw_feat_simple_funct_elem (id: %): %', id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function UTN9_DELETE_NTW_FEAT_TERM_ELEM
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.utn9_delete_ntw_feat_term_elem(
  IN id integer,
  IN schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
	deleted_id integer;
BEGIN
deleted_id=citydb_pkg.utn9_delete_network_feature(id, schema_name);
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_delete_ntw_feat_term_elem (id: %): %', id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function UTN9_DELETE_NTW_FEAT_DEVICE_CONTROLLER
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.utn9_delete_ntw_feat_device_controller(
  IN id integer,
  IN schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
	deleted_id integer;
BEGIN
deleted_id=citydb_pkg.utn9_delete_network_feature(id, schema_name);
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_delete_ntw_feat_device_controller (id: %): %', id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function UTN9_DELETE_NTW_FEAT_DEVICE_GENERIC
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.utn9_delete_ntw_feat_device_generic(
  IN id integer,
  IN schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
	deleted_id integer;
BEGIN
deleted_id=citydb_pkg.utn9_delete_network_feature(id, schema_name);
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_delete_ntw_feat_device_generic (id: %): %', id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function UTN9_DELETE_NTW_FEAT_DEVICE_MEAS
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.utn9_delete_ntw_feat_device_meas(
  IN id integer,
  IN schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
	deleted_id integer;
BEGIN
deleted_id=citydb_pkg.utn9_delete_network_feature(id, schema_name);
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_delete_ntw_feat_device_meas (id: %): %', id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function UTN9_DELETE_NTW_FEAT_DEVICE_STORAGE
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.utn9_delete_ntw_feat_device_storage(
  IN id integer,
  IN schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
	deleted_id integer;
BEGIN
deleted_id=citydb_pkg.utn9_delete_network_feature(id, schema_name);
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_delete_ntw_feat_device_storage (id: %): %', id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function UTN9_DELETE_NTW_FEAT_DEVICE_TECH
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.utn9_delete_ntw_feat_device_tech(
  IN id integer,
  IN schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
	deleted_id integer;
BEGIN
deleted_id=citydb_pkg.utn9_delete_network_feature(id, schema_name);
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_delete_ntw_feat_device_tech (id: %): %', id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function UTN9_DELETE_NTW_FEAT_DISTRIB_ELEM_CABLE
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.utn9_delete_ntw_feat_distrib_elem_cable(
  IN id integer,
  IN schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
	deleted_id integer;
BEGIN
deleted_id=citydb_pkg.utn9_delete_network_feature(id, schema_name);
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_delete_ntw_feat_distrib_elem_cable (id: %): %', id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function UTN9_DELETE_NTW_FEAT_DISTRIB_ELEM_CANAL
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.utn9_delete_ntw_feat_distrib_elem_canal(
  IN id integer,
  IN schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
	deleted_id integer;
BEGIN
deleted_id=citydb_pkg.utn9_delete_network_feature(id, schema_name);
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_delete_ntw_feat_distrib_elem_canal (id: %): %', id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function UTN9_DELETE_NTW_FEAT_DISTRIB_ELEM_CANAL_CLOSED
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.utn9_delete_ntw_feat_distrib_elem_canal_closed(
  IN id integer,
  IN schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
	deleted_id integer;
BEGIN
deleted_id=citydb_pkg.utn9_delete_network_feature(id, schema_name);
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_delete_ntw_feat_distrib_elem_canal_closed (id: %): %', id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function UTN9_DELETE_NTW_FEAT_DISTRIB_ELEM_CANAL_SEMI_OPEN
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.utn9_delete_ntw_feat_distrib_elem_canal_semi_open(
  IN id integer,
  IN schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
	deleted_id integer;
BEGIN
deleted_id=citydb_pkg.utn9_delete_network_feature(id, schema_name);
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_delete_ntw_feat_distrib_elem_canal_semi_open (id: %): %', id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function UTN9_DELETE_NTW_FEAT_DISTRIB_ELEM_PIPE_OTHER_SHAPE
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.utn9_delete_ntw_feat_distrib_elem_pipe_other_shape(
  IN id integer,
  IN schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
	deleted_id integer;
BEGIN
deleted_id=citydb_pkg.utn9_delete_network_feature(id, schema_name);
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_delete_ntw_feat_distrib_elem_pipe_other_shape (id: %): %', id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function UTN9_DELETE_NTW_FEAT_DISTRIB_ELEM_PIPE_RECT
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.utn9_delete_ntw_feat_distrib_elem_pipe_rect(
  IN id integer,
  IN schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
	deleted_id integer;
BEGIN
deleted_id=citydb_pkg.utn9_delete_network_feature(id, schema_name);
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_delete_ntw_feat_distrib_elem_pipe_rect (id: %): %', id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function UTN9_DELETE_NTW_FEAT_DISTRIB_ELEM_PIPE_ROUND
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.utn9_delete_ntw_feat_distrib_elem_pipe_round(
  IN id integer,
  IN schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
	deleted_id integer;
BEGIN
deleted_id=citydb_pkg.utn9_delete_network_feature(id, schema_name);
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_delete_ntw_feat_distrib_elem_pipe_round (id: %): %', id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

-- ---------------------------------------------------------------
-- -- Function UTN9_DELETE_NTW_FEAT_PROT_ELEM
-- ---------------------------------------------------------------
-- CREATE OR REPLACE FUNCTION citydb_view.utn9_delete_ntw_feat_prot_elem(
  -- IN id integer,
  -- IN schema_name varchar DEFAULT 'citydb'::varchar
-- )
-- RETURNS integer AS
-- $BODY$
-- DECLARE
	-- deleted_id integer;
-- BEGIN
-- deleted_id=citydb_pkg.utn9_delete_network_feature(id, schema_name);
-- RETURN deleted_id;
-- EXCEPTION
	-- WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_delete_ntw_feat_prot_elem (id: %): %', id, SQLERRM;
-- END;
-- $BODY$
-- LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function UTN9_DELETE_NTW_FEAT_PROT_ELEM_BEDDING
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.utn9_delete_ntw_feat_prot_elem_bedding(
  IN id integer,
  IN schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
	deleted_id integer;
BEGIN
deleted_id=citydb_pkg.utn9_delete_network_feature(id, schema_name);
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_delete_ntw_feat_prot_elem_bedding (id: %): %', id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function UTN9_DELETE_NTW_FEAT_PROT_ELEM_SHELL_OTHER
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.utn9_delete_ntw_feat_prot_elem_shell_other(
  IN id integer,
  IN schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
	deleted_id integer;
BEGIN
deleted_id=citydb_pkg.utn9_delete_network_feature(id, schema_name);
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_delete_ntw_feat_prot_elem_shell_other (id: %): %', id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function UTN9_DELETE_NTW_FEAT_PROT_ELEM_SHELL_RECT
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.utn9_delete_ntw_feat_prot_elem_shell_rect(
  IN id integer,
  IN schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
	deleted_id integer;
BEGIN
deleted_id=citydb_pkg.utn9_delete_network_feature(id, schema_name);
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_delete_ntw_feat_prot_elem_shell_rect (id: %): %', id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function UTN9_DELETE_NTW_FEAT_PROT_ELEM_SHELL_ROUND
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.utn9_delete_ntw_feat_prot_elem_shell_round(
  IN id integer,
  IN schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
	deleted_id integer;
BEGIN
deleted_id=citydb_pkg.utn9_delete_network_feature(id, schema_name);
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_delete_ntw_feat_prot_elem_shell_round (id: %): %', id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function UTN9_DELETE_ROLE_IN_NETWORK
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.utn9_delete_role_in_network(
  IN id integer,
  IN schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
	deleted_id integer;
BEGIN
deleted_id=citydb_pkg.utn9_delete_role_in_network(id, schema_name);
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_delete_role_in_network (id: %): %', id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function UTN9_DELETE_STORAGE
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.utn9_delete_storage(
  IN id integer,
  IN schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
	deleted_id integer;
BEGIN
deleted_id=citydb_pkg.utn9_delete_storage(id, schema_name);
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_delete_storage (id: %): %', id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function UTN9_DELETE_SUPPLY_AREA
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.utn9_delete_supply_area(
  IN id integer,
  IN schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
	deleted_id integer;
BEGIN
deleted_id=citydb_pkg.utn9_delete_supply_area(id, 0, schema_name);
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_delete_supply_area (id: %): %', id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

-- ***********************************************************************
-- ***********************************************************************

---------------------------------------------------------------
-- Function UTN9_INSERT_BUILDING
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.utn9_insert_building(
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
--
  nbr_occupants               integer DEFAULT NULL,
--
  schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
  p_id                     integer                     := id                    ;
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
  p_nbr_occupants               integer          := nbr_occupants              ;
--
  p_schema_name varchar := schema_name;
  class_name varchar DEFAULT 'Building'::varchar;
  db_prefix varchar DEFAULT NULL;
  objectclass_id integer;
  inserted_id integer;
BEGIN
objectclass_id=citydb_pkg.objectclass_classname_to_id(class_name, db_prefix, p_schema_name);

inserted_id=citydb_pkg.insert_cityobject(
    id                    :=p_id,
    objectclass_id        :=objectclass_id,
    gmlid                 :=p_gmlid,
    gmlid_codespace       :=p_gmlid_codespace,
    name                  :=p_name,
    name_codespace        :=p_name_codespace,
    description           :=p_description,
    envelope              :=p_envelope,
    creation_date         :=p_creation_date,
    termination_date      :=p_termination_date,
    relative_to_terrain   :=p_relative_to_terrain,
    relative_to_water     :=p_relative_to_water,
    last_modification_date:=p_last_modification_date,
    updating_person       :=p_updating_person,
    reason_for_update     :=p_reason_for_update,
    lineage               :=p_lineage,
    schema_name           :=p_schema_name
);
PERFORM citydb_pkg.insert_building(
    id                         :=inserted_id,
    building_parent_id         :=p_building_parent_id,
    building_root_id           :=p_building_root_id,
    class                      :=p_class,
    class_codespace            :=p_class_codespace,
    function                   :=p_function,
    function_codespace         :=p_function_codespace,
    usage                      :=p_usage,
    usage_codespace            :=p_usage_codespace,
    year_of_construction       :=p_year_of_construction,
    year_of_demolition         :=p_year_of_demolition,
    roof_type                  :=p_roof_type,
    roof_type_codespace        :=p_roof_type_codespace,
    measured_height            :=p_measured_height,
    measured_height_unit       :=p_measured_height_unit,
    storeys_above_ground       :=p_storeys_above_ground,
    storeys_below_ground       :=p_storeys_below_ground,
    storey_heights_above_ground:=p_storey_heights_above_ground,
    storey_heights_ag_unit     :=p_storey_heights_ag_unit,
    storey_heights_below_ground:=p_storey_heights_below_ground,
    storey_heights_bg_unit     :=p_storey_heights_bg_unit,
    lod1_terrain_intersection  :=p_lod1_terrain_intersection,
    lod2_terrain_intersection  :=p_lod2_terrain_intersection,
    lod3_terrain_intersection  :=p_lod3_terrain_intersection,
    lod4_terrain_intersection  :=p_lod4_terrain_intersection,
    lod2_multi_curve           :=p_lod2_multi_curve,
    lod3_multi_curve           :=p_lod3_multi_curve,
    lod4_multi_curve           :=p_lod4_multi_curve,
    lod0_footprint_id          :=p_lod0_footprint_id,
    lod0_roofprint_id          :=p_lod0_roofprint_id,
    lod1_multi_surface_id      :=p_lod1_multi_surface_id,
    lod2_multi_surface_id      :=p_lod2_multi_surface_id,
    lod3_multi_surface_id      :=p_lod3_multi_surface_id,
    lod4_multi_surface_id      :=p_lod4_multi_surface_id,
    lod1_solid_id              :=p_lod1_solid_id,
    lod2_solid_id              :=p_lod2_solid_id,
    lod3_solid_id              :=p_lod3_solid_id,
    lod4_solid_id              :=p_lod4_solid_id,
    schema_name                :=p_schema_name
);
PERFORM citydb_pkg.utn9_insert_building(
    id                         :=inserted_id,
    objectclass_id             :=objectclass_id,
    nbr_occupants              :=p_nbr_occupants
);
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_insert_building(): %', SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function UTN9_INSERT_BUILDING_PART
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.utn9_insert_building_part(
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
--
  nbr_occupants               integer DEFAULT NULL,
--
  schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
  p_id                     integer                     := id                    ;
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
  p_nbr_occupants               integer          := nbr_occupants              ;
--
  p_schema_name varchar := schema_name;
  class_name varchar DEFAULT 'BuildingPart'::varchar;
  db_prefix varchar DEFAULT NULL;
  objectclass_id integer;
  inserted_id integer;
BEGIN
objectclass_id=citydb_pkg.objectclass_classname_to_id(class_name, db_prefix, p_schema_name);

inserted_id=citydb_pkg.insert_cityobject(
    id                    :=p_id,
    objectclass_id        :=objectclass_id,
    gmlid                 :=p_gmlid,
    gmlid_codespace       :=p_gmlid_codespace,
    name                  :=p_name,
    name_codespace        :=p_name_codespace,
    description           :=p_description,
    envelope              :=p_envelope,
    creation_date         :=p_creation_date,
    termination_date      :=p_termination_date,
    relative_to_terrain   :=p_relative_to_terrain,
    relative_to_water     :=p_relative_to_water,
    last_modification_date:=p_last_modification_date,
    updating_person       :=p_updating_person,
    reason_for_update     :=p_reason_for_update,
    lineage               :=p_lineage,
    schema_name           :=p_schema_name
);
PERFORM citydb_pkg.insert_building(
    id                         :=inserted_id,
    building_parent_id         :=p_building_parent_id,
    building_root_id           :=p_building_root_id,
    class                      :=p_class,
    class_codespace            :=p_class_codespace,
    function                   :=p_function,
    function_codespace         :=p_function_codespace,
    usage                      :=p_usage,
    usage_codespace            :=p_usage_codespace,
    year_of_construction       :=p_year_of_construction,
    year_of_demolition         :=p_year_of_demolition,
    roof_type                  :=p_roof_type,
    roof_type_codespace        :=p_roof_type_codespace,
    measured_height            :=p_measured_height,
    measured_height_unit       :=p_measured_height_unit,
    storeys_above_ground       :=p_storeys_above_ground,
    storeys_below_ground       :=p_storeys_below_ground,
    storey_heights_above_ground:=p_storey_heights_above_ground,
    storey_heights_ag_unit     :=p_storey_heights_ag_unit,
    storey_heights_below_ground:=p_storey_heights_below_ground,
    storey_heights_bg_unit     :=p_storey_heights_bg_unit,
    lod1_terrain_intersection  :=p_lod1_terrain_intersection,
    lod2_terrain_intersection  :=p_lod2_terrain_intersection,
    lod3_terrain_intersection  :=p_lod3_terrain_intersection,
    lod4_terrain_intersection  :=p_lod4_terrain_intersection,
    lod2_multi_curve           :=p_lod2_multi_curve,
    lod3_multi_curve           :=p_lod3_multi_curve,
    lod4_multi_curve           :=p_lod4_multi_curve,
    lod0_footprint_id          :=p_lod0_footprint_id,
    lod0_roofprint_id          :=p_lod0_roofprint_id,
    lod1_multi_surface_id      :=p_lod1_multi_surface_id,
    lod2_multi_surface_id      :=p_lod2_multi_surface_id,
    lod3_multi_surface_id      :=p_lod3_multi_surface_id,
    lod4_multi_surface_id      :=p_lod4_multi_surface_id,
    lod1_solid_id              :=p_lod1_solid_id,
    lod2_solid_id              :=p_lod2_solid_id,
    lod3_solid_id              :=p_lod3_solid_id,
    lod4_solid_id              :=p_lod4_solid_id,
    schema_name                :=p_schema_name
);
PERFORM citydb_pkg.utn9_insert_building(
    id                         :=inserted_id,
    objectclass_id             :=objectclass_id,
    nbr_occupants              :=p_nbr_occupants
);
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_insert_building_part(): %', SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function UTN9_INSERT_COMMODITY_ELECTRICAL_MEDIUM
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.utn9_insert_commodity_electrical_medium(
  id                           integer DEFAULT NULL,
  gmlid                        varchar DEFAULT NULL,
  gmlid_codespace              varchar DEFAULT NULL,
  name                         varchar DEFAULT NULL,
  name_codespace               varchar DEFAULT NULL,
  description                  text    DEFAULT NULL,
  owner                        varchar DEFAULT NULL,
  type                         varchar DEFAULT NULL,
--  is_corrosive                 numeric DEFAULT NULL,
--  is_explosive                 numeric DEFAULT NULL,
--  is_lighter_than_air          numeric DEFAULT NULL,
--  flammability_ratio           numeric DEFAULT NULL,
--  elec_conductivity_range_from numeric DEFAULT NULL,
--  elec_conductivity_range_to   numeric DEFAULT NULL,
--  elec_conductivity_range_unit varchar DEFAULT NULL,
--  concentration                numeric DEFAULT NULL,
--  concentration_unit           varchar DEFAULT NULL,
--  ph_value_range_from          numeric DEFAULT NULL,
--  ph_value_range_to            numeric DEFAULT NULL,
--  ph_value_range_unit          varchar DEFAULT NULL,
--  temperature_range_from       numeric DEFAULT NULL,
--  temperature_range_to         numeric DEFAULT NULL,
--  temperature_range_unit       varchar DEFAULT NULL,
--  flow_rate_range_from         numeric DEFAULT NULL,
--  flow_rate_range_to           numeric DEFAULT NULL,
--  flow_rate_range_unit         varchar DEFAULT NULL,
--  pressure_range_from          numeric DEFAULT NULL,
--  pressure_range_to            numeric DEFAULT NULL,
--  pressure_range_unit          varchar DEFAULT NULL,
  voltage_range_from           numeric DEFAULT NULL,
  voltage_range_to             numeric DEFAULT NULL,
  voltage_range_unit           varchar DEFAULT NULL,
  amperage_range_from          numeric DEFAULT NULL,
  amperage_range_to            numeric DEFAULT NULL,
  amperage_range_unit          varchar DEFAULT NULL,
  bandwidth_range_from         numeric DEFAULT NULL,
  bandwidth_range_to           numeric DEFAULT NULL,
  bandwidth_range_unit         varchar DEFAULT NULL,
--  optical_mode                 varchar DEFAULT NULL, 
--
  schema_name              varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
  p_id                           integer := id;
  p_gmlid                        varchar := gmlid;
  p_gmlid_codespace              varchar := gmlid_codespace;
  p_name                         varchar := name;
  p_name_codespace               varchar := name_codespace;
  p_description                  text    := description;
  p_owner                        varchar := owner;
  p_type                         varchar := type;
  -- p_is_corrosive                 numeric := is_corrosive;
  -- p_is_explosive                 numeric := is_explosive;
  -- p_is_lighter_than_air          numeric := is_lighter_than_air;
  -- p_flammability_ratio           numeric := flammability_ratio;
  -- p_elec_conductivity_range_from numeric := elec_conductivity_range_from;
  -- p_elec_conductivity_range_to   numeric := elec_conductivity_range_to;
  -- p_elec_conductivity_range_unit varchar := elec_conductivity_range_unit;
  -- p_concentration                numeric := concentration;
  -- p_concentration_unit           varchar := concentration_unit;
  -- p_ph_value_range_from          numeric := ph_value_range_from;
  -- p_ph_value_range_to            numeric := ph_value_range_to;
  -- p_ph_value_range_unit          varchar := ph_value_range_unit;
  -- p_temperature_range_from       numeric := temperature_range_from;
  -- p_temperature_range_to         numeric := temperature_range_to;
  -- p_temperature_range_unit       varchar := temperature_range_unit;
  -- p_flow_rate_range_from         numeric := flow_rate_range_from;
  -- p_flow_rate_range_to           numeric := flow_rate_range_to;
  -- p_flow_rate_range_unit         varchar := flow_rate_range_unit;
  -- p_pressure_range_from          numeric := pressure_range_from;
  -- p_pressure_range_to            numeric := pressure_range_to;
  -- p_pressure_range_unit          varchar := pressure_range_unit;
  p_voltage_range_from           numeric := voltage_range_from;
  p_voltage_range_to             numeric := voltage_range_to;
  p_voltage_range_unit           varchar := voltage_range_unit;
  p_amperage_range_from          numeric := amperage_range_from;
  p_amperage_range_to            numeric := amperage_range_to;
  p_amperage_range_unit          varchar := amperage_range_unit;
  p_bandwidth_range_from         numeric := bandwidth_range_from;
  p_bandwidth_range_to           numeric := bandwidth_range_to;
  p_bandwidth_range_unit         varchar := bandwidth_range_unit;
--  p_optical_mode                 varchar := optical_mode;
--
  p_schema_name varchar := schema_name;
  class_name varchar DEFAULT 'ElectricalMedium'::varchar;
  db_prefix varchar DEFAULT 'utn9';
  objectclass_id integer;
  inserted_id integer;
BEGIN
objectclass_id=citydb_pkg.objectclass_classname_to_id(class_name, db_prefix, p_schema_name);

inserted_id=citydb_pkg.utn9_insert_commodity(
    id                           :=p_id,
    objectclass_id               :=objectclass_id,  -- objectclass ID
    gmlid                        :=p_gmlid,
    gmlid_codespace              :=p_gmlid_codespace,
    name                         :=p_name,
    name_codespace               :=p_name_codespace,
    description                  :=p_description,
    owner                        :=owner,
    type                         :=type,
    -- is_corrosive                 :=is_corrosive,
    -- is_explosive                 :=is_explosive,
    -- is_lighter_than_air          :=is_lighter_than_air,
    -- flammability_ratio           :=flammability_ratio,
    -- elec_conductivity_range_from :=elec_conductivity_range_from,
    -- elec_conductivity_range_to   :=elec_conductivity_range_to,
    -- elec_conductivity_range_unit :=elec_conductivity_range_unit,
    -- concentration                :=concentration,
    -- concentration_unit           :=concentration_unit,
    -- ph_value_range_from          :=ph_value_range_from,
    -- ph_value_range_to            :=ph_value_range_to,
    -- ph_value_range_unit          :=ph_value_range_unit,
    -- temperature_range_from       :=temperature_range_from,
    -- temperature_range_to         :=temperature_range_to,
    -- temperature_range_unit       :=temperature_range_unit,
    -- flow_rate_range_from         :=flow_rate_range_from,
    -- flow_rate_range_to           :=flow_rate_range_to,
    -- flow_rate_range_unit         :=flow_rate_range_unit,
    -- pressure_range_from          :=pressure_range_from,
    -- pressure_range_to            :=pressure_range_to,
    -- pressure_range_unit          :=pressure_range_unit,
    voltage_range_from           :=voltage_range_from,
    voltage_range_to             :=voltage_range_to,
    voltage_range_unit           :=voltage_range_unit,
    amperage_range_from          :=amperage_range_from,
    amperage_range_to            :=amperage_range_to,
    amperage_range_unit          :=amperage_range_unit,
    bandwidth_range_from         :=bandwidth_range_from,
    bandwidth_range_to           :=bandwidth_range_to,
    bandwidth_range_unit         :=bandwidth_range_unit,
--    optical_mode                 :=optical_mode,
--
    schema_name             :=p_schema_name  -- schema name
);
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_insert_commodity_electrical_medium(): %', SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function UTN9_INSERT_COMMODITY_GASEOUS_MEDIUM
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.utn9_insert_commodity_gaseous_medium(
  id                           integer DEFAULT NULL,
  gmlid                        varchar DEFAULT NULL,
  gmlid_codespace              varchar DEFAULT NULL,
  name                         varchar DEFAULT NULL,
  name_codespace               varchar DEFAULT NULL,
  description                  text    DEFAULT NULL,
  owner                        varchar DEFAULT NULL,
  type                         varchar DEFAULT NULL,
--  is_corrosive                 numeric DEFAULT NULL,
  is_explosive                 numeric DEFAULT NULL,
  is_lighter_than_air          numeric DEFAULT NULL,
--  flammability_ratio           numeric DEFAULT NULL,
  elec_conductivity_range_from numeric DEFAULT NULL,
  elec_conductivity_range_to   numeric DEFAULT NULL,
  elec_conductivity_range_unit varchar DEFAULT NULL,
  concentration                numeric DEFAULT NULL,
  concentration_unit           varchar DEFAULT NULL,
--  ph_value_range_from          numeric DEFAULT NULL,
--  ph_value_range_to            numeric DEFAULT NULL,
--  ph_value_range_unit          varchar DEFAULT NULL,
--  temperature_range_from       numeric DEFAULT NULL,
--  temperature_range_to         numeric DEFAULT NULL,
--  temperature_range_unit       varchar DEFAULT NULL,
--  flow_rate_range_from         numeric DEFAULT NULL,
--  flow_rate_range_to           numeric DEFAULT NULL,
--  flow_rate_range_unit         varchar DEFAULT NULL,
  pressure_range_from          numeric DEFAULT NULL,
  pressure_range_to            numeric DEFAULT NULL,
  pressure_range_unit          varchar DEFAULT NULL,
--  voltage_range_from           numeric DEFAULT NULL,
--  voltage_range_to             numeric DEFAULT NULL,
--  voltage_range_unit           varchar DEFAULT NULL,
--  amperage_range_from          numeric DEFAULT NULL,
--  amperage_range_to            numeric DEFAULT NULL,
--  amperage_range_unit          varchar DEFAULT NULL,
--  bandwidth_range_from         numeric DEFAULT NULL,
--  bandwidth_range_to           numeric DEFAULT NULL,
--  bandwidth_range_unit         varchar DEFAULT NULL,
--  optical_mode                 varchar DEFAULT NULL, 
--
  schema_name              varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
  p_id                           integer           := id;
  p_gmlid                        character varying := gmlid;
  p_gmlid_codespace              character varying := gmlid_codespace;
  p_name                         character varying := name;
  p_name_codespace               character varying := name_codespace;
  p_description                  text              := description;
  p_owner                        varchar := owner;
  p_type                         varchar := type;
--p_is_corrosive                 numeric := is_corrosive;
  p_is_explosive                 numeric := is_explosive;
  p_is_lighter_than_air          numeric := is_lighter_than_air;
--p_flammability_ratio           numeric := flammability_ratio;
  p_elec_conductivity_range_from numeric := elec_conductivity_range_from;
  p_elec_conductivity_range_to   numeric := elec_conductivity_range_to;
  p_elec_conductivity_range_unit varchar := elec_conductivity_range_unit;
  p_concentration                numeric := concentration;
  p_concentration_unit           varchar := concentration_unit;
--p_ph_value_range_from          numeric := ph_value_range_from;
--p_ph_value_range_to            numeric := ph_value_range_to;
--p_ph_value_range_unit          varchar := ph_value_range_unit;
--p_temperature_range_from       numeric := temperature_range_from;
--p_temperature_range_to         numeric := temperature_range_to;
--p_temperature_range_unit       varchar := temperature_range_unit;
--p_flow_rate_range_from         numeric := flow_rate_range_from;
--p_flow_rate_range_to           numeric := flow_rate_range_to;
--p_flow_rate_range_unit         varchar := flow_rate_range_unit;
  p_pressure_range_from          numeric := pressure_range_from;
  p_pressure_range_to            numeric := pressure_range_to;
  p_pressure_range_unit          varchar := pressure_range_unit;
--p_voltage_range_from           numeric := voltage_range_from;
--p_voltage_range_to             numeric := voltage_range_to;
--p_voltage_range_unit           varchar := voltage_range_unit;
--p_amperage_range_from          numeric := amperage_range_from;
--p_amperage_range_to            numeric := amperage_range_to;
--p_amperage_range_unit          varchar := amperage_range_unit;
--p_bandwidth_range_from         numeric := bandwidth_range_from;
--p_bandwidth_range_to           numeric := bandwidth_range_to;
--p_bandwidth_range_unit         varchar := bandwidth_range_unit;
--p_optical_mode                 varchar := optical_mode;
--
  p_schema_name varchar := schema_name;
  class_name varchar DEFAULT 'GaseousMedium'::varchar;
  db_prefix varchar DEFAULT 'utn9';
  objectclass_id integer;
  inserted_id integer;
BEGIN
objectclass_id=citydb_pkg.objectclass_classname_to_id(class_name, db_prefix, p_schema_name);

inserted_id=citydb_pkg.utn9_insert_commodity(
    id                           :=p_id,
    objectclass_id               :=objectclass_id,  -- objectclass ID
    gmlid                        :=p_gmlid,
    gmlid_codespace              :=p_gmlid_codespace,
    name                         :=p_name,
    name_codespace               :=p_name_codespace,
    description                  :=p_description,
    owner                        :=owner,
    type                         :=type,
--  is_corrosive                 :=is_corrosive,
    is_explosive                 :=is_explosive,
    is_lighter_than_air          :=is_lighter_than_air,
--  flammability_ratio           :=flammability_ratio,
    elec_conductivity_range_from :=elec_conductivity_range_from,
    elec_conductivity_range_to   :=elec_conductivity_range_to,
    elec_conductivity_range_unit :=elec_conductivity_range_unit,
    concentration                :=concentration,
    concentration_unit           :=concentration_unit,
--  ph_value_range_from          :=ph_value_range_from,
--  ph_value_range_to            :=ph_value_range_to,
--  ph_value_range_unit          :=ph_value_range_unit,
--  temperature_range_from       :=temperature_range_from,
--  temperature_range_to         :=temperature_range_to,
--  temperature_range_unit       :=temperature_range_unit,
--  flow_rate_range_from         :=flow_rate_range_from,
--  flow_rate_range_to           :=flow_rate_range_to,
--  flow_rate_range_unit         :=flow_rate_range_unit,
    pressure_range_from          :=pressure_range_from,
    pressure_range_to            :=pressure_range_to,
    pressure_range_unit          :=pressure_range_unit,
--  voltage_range_from           :=voltage_range_from,
--  voltage_range_to             :=voltage_range_to,
--  voltage_range_unit           :=voltage_range_unit,
--  amperage_range_from          :=amperage_range_from,
--  amperage_range_to            :=amperage_range_to,
--  amperage_range_unit          :=amperage_range_unit,
--  bandwidth_range_from         :=bandwidth_range_from,
--  bandwidth_range_to           :=bandwidth_range_to,
--  bandwidth_range_unit         :=bandwidth_range_unit,
--  optical_mode                 :=optical_mode,
--
    schema_name             :=p_schema_name  -- schema name
);
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_insert_commodity_gaseous_medium(): %', SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function UTN9_INSERT_COMMODITY_LIQUID_MEDIUM
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.utn9_insert_commodity_liquid_medium(
  id                           integer DEFAULT NULL,
  gmlid                        varchar DEFAULT NULL,
  gmlid_codespace              varchar DEFAULT NULL,
  name                         varchar DEFAULT NULL,
  name_codespace               varchar DEFAULT NULL,
  description                  text    DEFAULT NULL,
  owner                        varchar DEFAULT NULL,
  type                         varchar DEFAULT NULL,
  is_corrosive                 numeric DEFAULT NULL,
  is_explosive                 numeric DEFAULT NULL,
  is_lighter_than_air          numeric DEFAULT NULL,
  flammability_ratio           numeric DEFAULT NULL,
  elec_conductivity_range_from numeric DEFAULT NULL,
  elec_conductivity_range_to   numeric DEFAULT NULL,
  elec_conductivity_range_unit varchar DEFAULT NULL,
--  concentration                numeric DEFAULT NULL,
--  concentration_unit           varchar DEFAULT NULL,
  ph_value_range_from          numeric DEFAULT NULL,
  ph_value_range_to            numeric DEFAULT NULL,
  ph_value_range_unit          varchar DEFAULT NULL,
  temperature_range_from       numeric DEFAULT NULL,
  temperature_range_to         numeric DEFAULT NULL,
  temperature_range_unit       varchar DEFAULT NULL,
  flow_rate_range_from         numeric DEFAULT NULL,
  flow_rate_range_to           numeric DEFAULT NULL,
  flow_rate_range_unit         varchar DEFAULT NULL,
  pressure_range_from          numeric DEFAULT NULL,
  pressure_range_to            numeric DEFAULT NULL,
  pressure_range_unit          varchar DEFAULT NULL,
--  voltage_range_from           numeric DEFAULT NULL,
--  voltage_range_to             numeric DEFAULT NULL,
--  voltage_range_unit           varchar DEFAULT NULL,
--  amperage_range_from          numeric DEFAULT NULL,
--  amperage_range_to            numeric DEFAULT NULL,
--  amperage_range_unit          varchar DEFAULT NULL,
--  bandwidth_range_from         numeric DEFAULT NULL,
--  bandwidth_range_to           numeric DEFAULT NULL,
--  bandwidth_range_unit         varchar DEFAULT NULL,
--  optical_mode                 varchar DEFAULT NULL, 
--
  schema_name              varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
  p_id                           integer           := id;
  p_gmlid                        character varying := gmlid;
  p_gmlid_codespace              character varying := gmlid_codespace;
  p_name                         character varying := name;
  p_name_codespace               character varying := name_codespace;
  p_description                  text              := description;
  p_owner                        varchar := owner;
  p_type                         varchar := type;
  p_is_corrosive                 numeric := is_corrosive;
  p_is_explosive                 numeric := is_explosive;
  p_is_lighter_than_air          numeric := is_lighter_than_air;
  p_flammability_ratio           numeric := flammability_ratio;
  p_elec_conductivity_range_from numeric := elec_conductivity_range_from;
  p_elec_conductivity_range_to   numeric := elec_conductivity_range_to;
  p_elec_conductivity_range_unit varchar := elec_conductivity_range_unit;
--p_concentration                numeric := concentration;
--p_concentration_unit           varchar := concentration_unit;
  p_ph_value_range_from          numeric := ph_value_range_from;
  p_ph_value_range_to            numeric := ph_value_range_to;
  p_ph_value_range_unit          varchar := ph_value_range_unit;
  p_temperature_range_from       numeric := temperature_range_from;
  p_temperature_range_to         numeric := temperature_range_to;
  p_temperature_range_unit       varchar := temperature_range_unit;
  p_flow_rate_range_from         numeric := flow_rate_range_from;
  p_flow_rate_range_to           numeric := flow_rate_range_to;
  p_flow_rate_range_unit         varchar := flow_rate_range_unit;
  p_pressure_range_from          numeric := pressure_range_from;
  p_pressure_range_to            numeric := pressure_range_to;
  p_pressure_range_unit          varchar := pressure_range_unit;
--p_voltage_range_from           numeric := voltage_range_from;
--p_voltage_range_to             numeric := voltage_range_to;
--p_voltage_range_unit           varchar := voltage_range_unit;
--p_amperage_range_from          numeric := amperage_range_from;
--p_amperage_range_to            numeric := amperage_range_to;
--p_amperage_range_unit          varchar := amperage_range_unit;
--p_bandwidth_range_from         numeric := bandwidth_range_from;
--p_bandwidth_range_to           numeric := bandwidth_range_to;
--p_bandwidth_range_unit         varchar := bandwidth_range_unit;
--p_optical_mode                 varchar := optical_mode;
--
  p_schema_name varchar := schema_name;
  class_name varchar DEFAULT 'LiquidMedium'::varchar;
  db_prefix varchar DEFAULT 'utn9';
  objectclass_id integer;
  inserted_id integer;
BEGIN
objectclass_id=citydb_pkg.objectclass_classname_to_id(class_name, db_prefix, p_schema_name);

inserted_id=citydb_pkg.utn9_insert_commodity(
    id                           :=p_id,
    objectclass_id               :=objectclass_id,  -- objectclass ID
    gmlid                        :=p_gmlid,
    gmlid_codespace              :=p_gmlid_codespace,
    name                         :=p_name,
    name_codespace               :=p_name_codespace,
    description                  :=p_description,
    owner                        :=owner,
    type                         :=type,
    is_corrosive                 :=is_corrosive,
    is_explosive                 :=is_explosive,
    is_lighter_than_air          :=is_lighter_than_air,
    flammability_ratio           :=flammability_ratio,
    elec_conductivity_range_from :=elec_conductivity_range_from,
    elec_conductivity_range_to   :=elec_conductivity_range_to,
    elec_conductivity_range_unit :=elec_conductivity_range_unit,
--  concentration                :=concentration,
--  concentration_unit           :=concentration_unit,
    ph_value_range_from          :=ph_value_range_from,
    ph_value_range_to            :=ph_value_range_to,
    ph_value_range_unit          :=ph_value_range_unit,
    temperature_range_from       :=temperature_range_from,
    temperature_range_to         :=temperature_range_to,
    temperature_range_unit       :=temperature_range_unit,
    flow_rate_range_from         :=flow_rate_range_from,
    flow_rate_range_to           :=flow_rate_range_to,
    flow_rate_range_unit         :=flow_rate_range_unit,
    pressure_range_from          :=pressure_range_from,
    pressure_range_to            :=pressure_range_to,
    pressure_range_unit          :=pressure_range_unit,
--  voltage_range_from           :=voltage_range_from,
--  voltage_range_to             :=voltage_range_to,
--  voltage_range_unit           :=voltage_range_unit,
--  amperage_range_from          :=amperage_range_from,
--  amperage_range_to            :=amperage_range_to,
--  amperage_range_unit          :=amperage_range_unit,
--  bandwidth_range_from         :=bandwidth_range_from,
--  bandwidth_range_to           :=bandwidth_range_to,
--  bandwidth_range_unit         :=bandwidth_range_unit,
--  optical_mode                 :=optical_mode,
--
    schema_name             :=p_schema_name  -- schema name
);
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_insert_commodity_liquid_medium(): %', SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function UTN9_INSERT_COMMODITY_OPTICAL_MEDIUM
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.utn9_insert_commodity_optical_medium(
  id                           integer DEFAULT NULL,
  gmlid                        varchar DEFAULT NULL,
  gmlid_codespace              varchar DEFAULT NULL,
  name                         varchar DEFAULT NULL,
  name_codespace               varchar DEFAULT NULL,
  description                  text    DEFAULT NULL,
  owner                        varchar DEFAULT NULL,
  type                         varchar DEFAULT NULL,
--  is_corrosive                 numeric DEFAULT NULL,
--  is_explosive                 numeric DEFAULT NULL,
--  is_lighter_than_air          numeric DEFAULT NULL,
--  flammability_ratio           numeric DEFAULT NULL,
--  elec_conductivity_range_from numeric DEFAULT NULL,
--  elec_conductivity_range_to   numeric DEFAULT NULL,
--  elec_conductivity_range_unit varchar DEFAULT NULL,
--  concentration                numeric DEFAULT NULL,
--  concentration_unit           varchar DEFAULT NULL,
--  ph_value_range_from          numeric DEFAULT NULL,
--  ph_value_range_to            numeric DEFAULT NULL,
--  ph_value_range_unit          varchar DEFAULT NULL,
--  temperature_range_from       numeric DEFAULT NULL,
--  temperature_range_to         numeric DEFAULT NULL,
--  temperature_range_unit       varchar DEFAULT NULL,
--  flow_rate_range_from         numeric DEFAULT NULL,
--  flow_rate_range_to           numeric DEFAULT NULL,
--  flow_rate_range_unit         varchar DEFAULT NULL,
--  pressure_range_from          numeric DEFAULT NULL,
--  pressure_range_to            numeric DEFAULT NULL,
--  pressure_range_unit          varchar DEFAULT NULL,
--  voltage_range_from           numeric DEFAULT NULL,
--  voltage_range_to             numeric DEFAULT NULL,
--  voltage_range_unit           varchar DEFAULT NULL,
--  amperage_range_from          numeric DEFAULT NULL,
--  amperage_range_to            numeric DEFAULT NULL,
--  amperage_range_unit          varchar DEFAULT NULL,
  bandwidth_range_from         numeric DEFAULT NULL,
  bandwidth_range_to           numeric DEFAULT NULL,
  bandwidth_range_unit         varchar DEFAULT NULL,
  optical_mode                 varchar DEFAULT NULL, 
--
  schema_name              varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
  p_id                           integer           := id;
  p_gmlid                        character varying := gmlid;
  p_gmlid_codespace              character varying := gmlid_codespace;
  p_name                         character varying := name;
  p_name_codespace               character varying := name_codespace;
  p_description                  text              := description;
  p_owner                        varchar := owner;
  p_type                         varchar := type;
--p_is_corrosive                 numeric := is_corrosive;
--p_is_explosive                 numeric := is_explosive;
--p_is_lighter_than_air          numeric := is_lighter_than_air;
--p_flammability_ratio           numeric := flammability_ratio;
--p_elec_conductivity_range_from numeric := elec_conductivity_range_from;
--p_elec_conductivity_range_to   numeric := elec_conductivity_range_to;
--p_elec_conductivity_range_unit varchar := elec_conductivity_range_unit;
--p_concentration                numeric := concentration;
--p_concentration_unit           varchar := concentration_unit;
--p_ph_value_range_from          numeric := ph_value_range_from;
--p_ph_value_range_to            numeric := ph_value_range_to;
--p_ph_value_range_unit          varchar := ph_value_range_unit;
--p_temperature_range_from       numeric := temperature_range_from;
--p_temperature_range_to         numeric := temperature_range_to;
--p_temperature_range_unit       varchar := temperature_range_unit;
--p_flow_rate_range_from         numeric := flow_rate_range_from;
--p_flow_rate_range_to           numeric := flow_rate_range_to;
--p_flow_rate_range_unit         varchar := flow_rate_range_unit;
--p_pressure_range_from          numeric := pressure_range_from;
--p_pressure_range_to            numeric := pressure_range_to;
--p_pressure_range_unit          varchar := pressure_range_unit;
--p_voltage_range_from           numeric := voltage_range_from;
--p_voltage_range_to             numeric := voltage_range_to;
--p_voltage_range_unit           varchar := voltage_range_unit;
--p_amperage_range_from          numeric := amperage_range_from;
--p_amperage_range_to            numeric := amperage_range_to;
--p_amperage_range_unit          varchar := amperage_range_unit;
  p_bandwidth_range_from         numeric := bandwidth_range_from;
  p_bandwidth_range_to           numeric := bandwidth_range_to;
  p_bandwidth_range_unit         varchar := bandwidth_range_unit;
  p_optical_mode                 varchar := optical_mode;
--
  p_schema_name varchar := schema_name;
  class_name varchar DEFAULT 'OpticalMedium'::varchar;
  db_prefix varchar DEFAULT 'utn9';
  objectclass_id integer;
  inserted_id integer;
BEGIN
objectclass_id=citydb_pkg.objectclass_classname_to_id(class_name, db_prefix, p_schema_name);

inserted_id=citydb_pkg.utn9_insert_commodity(
    id                           :=p_id,
    objectclass_id               :=objectclass_id,  -- objectclass ID
    gmlid                        :=p_gmlid,
    gmlid_codespace              :=p_gmlid_codespace,
    name                         :=p_name,
    name_codespace               :=p_name_codespace,
    description                  :=p_description,
    owner                        :=owner,
    type                         :=type,
--  is_corrosive                 :=is_corrosive,
--  is_explosive                 :=is_explosive,
--  is_lighter_than_air          :=is_lighter_than_air,
--  flammability_ratio           :=flammability_ratio,
--  elec_conductivity_range_from :=elec_conductivity_range_from,
--  elec_conductivity_range_to   :=elec_conductivity_range_to,
--  elec_conductivity_range_unit :=elec_conductivity_range_unit,
--  concentration                :=concentration,
--  concentration_unit           :=concentration_unit,
--  ph_value_range_from          :=ph_value_range_from,
--  ph_value_range_to            :=ph_value_range_to,
--  ph_value_range_unit          :=ph_value_range_unit,
--  temperature_range_from       :=temperature_range_from,
--  temperature_range_to         :=temperature_range_to,
--  temperature_range_unit       :=temperature_range_unit,
--  flow_rate_range_from         :=flow_rate_range_from,
--  flow_rate_range_to           :=flow_rate_range_to,
--  flow_rate_range_unit         :=flow_rate_range_unit,
--  pressure_range_from          :=pressure_range_from,
--  pressure_range_to            :=pressure_range_to,
--  pressure_range_unit          :=pressure_range_unit,
--  voltage_range_from           :=voltage_range_from,
--  voltage_range_to             :=voltage_range_to,
--  voltage_range_unit           :=voltage_range_unit,
--  amperage_range_from          :=amperage_range_from,
--  amperage_range_to            :=amperage_range_to,
--  amperage_range_unit          :=amperage_range_unit,
    bandwidth_range_from         :=bandwidth_range_from,
    bandwidth_range_to           :=bandwidth_range_to,
    bandwidth_range_unit         :=bandwidth_range_unit,
    optical_mode                 :=optical_mode,
--
    schema_name             :=p_schema_name  -- schema name
);
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_insert_commodity_optical_medium(): %', SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function UTN9_INSERT_COMMODITY_SOLID_MEDIUM
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.utn9_insert_commodity_solid_medium(
  id                           integer DEFAULT NULL,
  gmlid                        varchar DEFAULT NULL,
  gmlid_codespace              varchar DEFAULT NULL,
  name                         varchar DEFAULT NULL,
  name_codespace               varchar DEFAULT NULL,
  description                  text    DEFAULT NULL,
  owner                        varchar DEFAULT NULL,
  type                         varchar DEFAULT NULL,
--  is_corrosive                 numeric DEFAULT NULL,
  is_explosive                 numeric DEFAULT NULL,
--  is_lighter_than_air          numeric DEFAULT NULL,
  flammability_ratio           numeric DEFAULT NULL,
  elec_conductivity_range_from numeric DEFAULT NULL,
  elec_conductivity_range_to   numeric DEFAULT NULL,
  elec_conductivity_range_unit varchar DEFAULT NULL,
  concentration                numeric DEFAULT NULL,
  concentration_unit           varchar DEFAULT NULL,
--  ph_value_range_from          numeric DEFAULT NULL,
--  ph_value_range_to            numeric DEFAULT NULL,
--  ph_value_range_unit          varchar DEFAULT NULL,
--  temperature_range_from       numeric DEFAULT NULL,
--  temperature_range_to         numeric DEFAULT NULL,
--  temperature_range_unit       varchar DEFAULT NULL,
--  flow_rate_range_from         numeric DEFAULT NULL,
--  flow_rate_range_to           numeric DEFAULT NULL,
--  flow_rate_range_unit         varchar DEFAULT NULL,
  pressure_range_from          numeric DEFAULT NULL,
  pressure_range_to            numeric DEFAULT NULL,
  pressure_range_unit          varchar DEFAULT NULL,
--  voltage_range_from           numeric DEFAULT NULL,
--  voltage_range_to             numeric DEFAULT NULL,
--  voltage_range_unit           varchar DEFAULT NULL,
--  amperage_range_from          numeric DEFAULT NULL,
--  amperage_range_to            numeric DEFAULT NULL,
--  amperage_range_unit          varchar DEFAULT NULL,
--  bandwidth_range_from         numeric DEFAULT NULL,
--  bandwidth_range_to           numeric DEFAULT NULL,
--  bandwidth_range_unit         varchar DEFAULT NULL,
--  optical_mode                 varchar DEFAULT NULL, 
--
  schema_name              varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
  p_id                           integer           := id;
  p_gmlid                        character varying := gmlid;
  p_gmlid_codespace              character varying := gmlid_codespace;
  p_name                         character varying := name;
  p_name_codespace               character varying := name_codespace;
  p_description                  text              := description;
  p_owner                        varchar := owner;
  p_type                         varchar := type;
--p_is_corrosive                 numeric := is_corrosive;
  p_is_explosive                 numeric := is_explosive;
--p_is_lighter_than_air          numeric := is_lighter_than_air;
  p_flammability_ratio           numeric := flammability_ratio;
  p_elec_conductivity_range_from numeric := elec_conductivity_range_from;
  p_elec_conductivity_range_to   numeric := elec_conductivity_range_to;
  p_elec_conductivity_range_unit varchar := elec_conductivity_range_unit;
  p_concentration                numeric := concentration;
  p_concentration_unit           varchar := concentration_unit;
--p_ph_value_range_from          numeric := ph_value_range_from;
--p_ph_value_range_to            numeric := ph_value_range_to;
--p_ph_value_range_unit          varchar := ph_value_range_unit;
--p_temperature_range_from       numeric := temperature_range_from;
--p_temperature_range_to         numeric := temperature_range_to;
--p_temperature_range_unit       varchar := temperature_range_unit;
--p_flow_rate_range_from         numeric := flow_rate_range_from;
--p_flow_rate_range_to           numeric := flow_rate_range_to;
--p_flow_rate_range_unit         varchar := flow_rate_range_unit;
  p_pressure_range_from          numeric := pressure_range_from;
  p_pressure_range_to            numeric := pressure_range_to;
  p_pressure_range_unit          varchar := pressure_range_unit;
--p_voltage_range_from           numeric := voltage_range_from;
--p_voltage_range_to             numeric := voltage_range_to;
--p_voltage_range_unit           varchar := voltage_range_unit;
--p_amperage_range_from          numeric := amperage_range_from;
--p_amperage_range_to            numeric := amperage_range_to;
--p_amperage_range_unit          varchar := amperage_range_unit;
--p_bandwidth_range_from         numeric := bandwidth_range_from;
--p_bandwidth_range_to           numeric := bandwidth_range_to;
--p_bandwidth_range_unit         varchar := bandwidth_range_unit;
--p_optical_mode                 varchar := optical_mode;
--
  p_schema_name varchar := schema_name;
  class_name varchar DEFAULT 'SolidMedium'::varchar;
  db_prefix varchar DEFAULT 'utn9';
  objectclass_id integer;
  inserted_id integer;
BEGIN
objectclass_id=citydb_pkg.objectclass_classname_to_id(class_name, db_prefix, p_schema_name);

inserted_id=citydb_pkg.utn9_insert_commodity(
    id                           :=p_id,
    objectclass_id               :=objectclass_id,  -- objectclass ID
    gmlid                        :=p_gmlid,
    gmlid_codespace              :=p_gmlid_codespace,
    name                         :=p_name,
    name_codespace               :=p_name_codespace,
    description                  :=p_description,
    owner                        :=owner,
    type                         :=type,
--  is_corrosive                 :=is_corrosive,
    is_explosive                 :=is_explosive,
--  is_lighter_than_air          :=is_lighter_than_air,
    flammability_ratio           :=flammability_ratio,
    elec_conductivity_range_from :=elec_conductivity_range_from,
    elec_conductivity_range_to   :=elec_conductivity_range_to,
    elec_conductivity_range_unit :=elec_conductivity_range_unit,
    concentration                :=concentration,
    concentration_unit           :=concentration_unit,
--  ph_value_range_from          :=ph_value_range_from,
--  ph_value_range_to            :=ph_value_range_to,
--  ph_value_range_unit          :=ph_value_range_unit,
--  temperature_range_from       :=temperature_range_from,
--  temperature_range_to         :=temperature_range_to,
--  temperature_range_unit       :=temperature_range_unit,
--  flow_rate_range_from         :=flow_rate_range_from,
--  flow_rate_range_to           :=flow_rate_range_to,
--  flow_rate_range_unit         :=flow_rate_range_unit,
    pressure_range_from          :=pressure_range_from,
    pressure_range_to            :=pressure_range_to,
    pressure_range_unit          :=pressure_range_unit,
--  voltage_range_from           :=voltage_range_from,
--  voltage_range_to             :=voltage_range_to,
--  voltage_range_unit           :=voltage_range_unit,
--  amperage_range_from          :=amperage_range_from,
--  amperage_range_to            :=amperage_range_to,
--  amperage_range_unit          :=amperage_range_unit,
--  bandwidth_range_from         :=bandwidth_range_from,
--  bandwidth_range_to           :=bandwidth_range_to,
--  bandwidth_range_unit         :=bandwidth_range_unit,
--  optical_mode                 :=optical_mode,
--
    schema_name             :=p_schema_name  -- schema name
);
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_insert_commodity_solid_medium(): %', SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function UTN9_INSERT_COMMODITY_CLASSIFIER_CHEMICAL
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.utn9_insert_commodity_classifier_chemical(
  id                           integer DEFAULT NULL,
  gmlid                        varchar DEFAULT NULL,
  gmlid_codespace              varchar DEFAULT NULL,
  name                         varchar DEFAULT NULL,
  name_codespace               varchar DEFAULT NULL,
  description                  text    DEFAULT NULL,
  mol_formula                  varchar DEFAULT NULL,
  mol_weight                   numeric DEFAULT NULL,
  mol_weight_unit              numeric DEFAULT NULL,
  physical_form                varchar DEFAULT NULL,
  signal_word                  varchar DEFAULT NULL,
  is_chemical_complex          numeric DEFAULT NULL,
  haz_class                    varchar DEFAULT NULL,
  haz_class_category_code      varchar DEFAULT NULL,
  haz_class_statement_code     varchar DEFAULT NULL,
  haz_class_pictogram_code     varchar DEFAULT NULL,
  haz_class_pictogram_uri      varchar DEFAULT NULL,
  ec_number                    varchar DEFAULT NULL,
  cas_number                   varchar DEFAULT NULL,
  iuclid_chem_datasheet        varchar DEFAULT NULL,
  commodity_id                 integer DEFAULT NULL,
  material_id                  integer DEFAULT NULL,
  hollow_space_id              integer DEFAULT NULL, 
--
  schema_name              varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
  p_id                           integer := id;
  p_gmlid                        varchar := gmlid;
  p_gmlid_codespace              varchar := gmlid_codespace;
  p_name                         varchar := name;
  p_name_codespace               varchar := name_codespace;
  p_description                  text    := description;
  p_mol_formula                  varchar :=mol_formula             ;
  p_mol_weight                   numeric :=mol_weight              ;
  p_mol_weight_unit              numeric :=mol_weight_unit         ;
  p_physical_form                varchar :=physical_form           ;
  p_signal_word                  varchar :=signal_word             ;
  p_is_chemical_complex          numeric :=is_chemical_complex     ;
  p_haz_class                    varchar :=haz_class               ;
  p_haz_class_category_code      varchar :=haz_class_category_code ;
  p_haz_class_statement_code     varchar :=haz_class_statement_code;
  p_haz_class_pictogram_code     varchar :=haz_class_pictogram_code;
  p_haz_class_pictogram_uri      varchar :=haz_class_pictogram_uri ;
  p_ec_number                    varchar :=ec_number               ;
  p_cas_number                   varchar :=cas_number              ;
  p_iuclid_chem_datasheet        varchar :=iuclid_chem_datasheet   ;
  p_commodity_id                 integer :=commodity_id            ;
  p_material_id                  integer :=material_id             ;
  p_hollow_space_id              integer :=hollow_space_id         ; 	
--
  p_schema_name varchar := schema_name;
  class_name varchar DEFAULT 'ChemicalClassifier'::varchar;
  db_prefix varchar DEFAULT 'utn9';
  objectclass_id integer;
  inserted_id integer;
BEGIN
objectclass_id=citydb_pkg.objectclass_classname_to_id(class_name, db_prefix, p_schema_name);

inserted_id=citydb_pkg.utn9_insert_commodity_classifier(
    id                           :=p_id,
    objectclass_id               :=objectclass_id,  -- objectclass ID
    gmlid                        :=p_gmlid,
    gmlid_codespace              :=p_gmlid_codespace,
    name                         :=p_name,
    name_codespace               :=p_name_codespace,
    description                  :=p_description,
    mol_formula                  :=p_mol_formula             ,
    mol_weight                   :=p_mol_weight              ,
    mol_weight_unit              :=p_mol_weight_unit         ,
    physical_form                :=p_physical_form           ,
    signal_word                  :=p_signal_word             ,
    is_chemical_complex          :=p_is_chemical_complex     ,
    haz_class                    :=p_haz_class               ,
    haz_class_category_code      :=p_haz_class_category_code ,
    haz_class_statement_code     :=p_haz_class_statement_code,
    haz_class_pictogram_code     :=p_haz_class_pictogram_code,
    haz_class_pictogram_uri      :=p_haz_class_pictogram_uri ,
    ec_number                    :=p_ec_number               ,
    cas_number                   :=p_cas_number              ,
    iuclid_chem_datasheet        :=p_iuclid_chem_datasheet   ,
    commodity_id                 :=p_commodity_id            ,
    material_id                  :=p_material_id             ,
    hollow_space_id              :=p_hollow_space_id         ,		
--
    schema_name             :=p_schema_name  -- schema name
);
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_insert_commodity_classifier_chemical(): %', SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function UTN9_INSERT_COMMODITY_CLASSIFIER_GHS
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.utn9_insert_commodity_classifier_ghs(
  id                           integer DEFAULT NULL,
  gmlid                        varchar DEFAULT NULL,
  gmlid_codespace              varchar DEFAULT NULL,
  name                         varchar DEFAULT NULL,
  name_codespace               varchar DEFAULT NULL,
  description                  text    DEFAULT NULL,
  mol_formula                  varchar DEFAULT NULL,
  mol_weight                   numeric DEFAULT NULL,
  mol_weight_unit              numeric DEFAULT NULL,
  physical_form                varchar DEFAULT NULL,
  signal_word                  varchar DEFAULT NULL,
  is_chemical_complex          numeric DEFAULT NULL,
  haz_class                    varchar DEFAULT NULL,
  haz_class_category_code      varchar DEFAULT NULL,
  haz_class_statement_code     varchar DEFAULT NULL,
  haz_class_pictogram_code     varchar DEFAULT NULL,
  haz_class_pictogram_uri      varchar DEFAULT NULL,
  ec_number                    varchar DEFAULT NULL,
  cas_number                   varchar DEFAULT NULL,
--  iuclid_chem_datasheet        varchar DEFAULT NULL,
  commodity_id                 integer DEFAULT NULL,
  material_id                  integer DEFAULT NULL,
  hollow_space_id              integer DEFAULT NULL, 
--
  schema_name              varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
  p_id                           integer := id;
  p_gmlid                        varchar := gmlid;
  p_gmlid_codespace              varchar := gmlid_codespace;
  p_name                         varchar := name;
  p_name_codespace               varchar := name_codespace;
  p_description                  text    := description;
  p_mol_formula                  varchar :=mol_formula             ;
  p_mol_weight                   numeric :=mol_weight              ;
  p_mol_weight_unit              numeric :=mol_weight_unit         ;
  p_physical_form                varchar :=physical_form           ;
  p_signal_word                  varchar :=signal_word             ;
  p_is_chemical_complex          numeric :=is_chemical_complex     ;
  p_haz_class                    varchar :=haz_class               ;
  p_haz_class_category_code      varchar :=haz_class_category_code ;
  p_haz_class_statement_code     varchar :=haz_class_statement_code;
  p_haz_class_pictogram_code     varchar :=haz_class_pictogram_code;
  p_haz_class_pictogram_uri      varchar :=haz_class_pictogram_uri ;
  p_ec_number                    varchar :=ec_number               ;
  p_cas_number                   varchar :=cas_number              ;
--p_iuclid_chem_datasheet        varchar :=iuclid_chem_datasheet   ;
  p_commodity_id                 integer :=commodity_id            ;
  p_material_id                  integer :=material_id             ;
  p_hollow_space_id              integer :=hollow_space_id         ; 	
--
  p_schema_name varchar := schema_name;
  class_name varchar DEFAULT 'GHSClassifier'::varchar;
  db_prefix varchar DEFAULT 'utn9';
  objectclass_id integer;
  inserted_id integer;
BEGIN
objectclass_id=citydb_pkg.objectclass_classname_to_id(class_name, db_prefix, p_schema_name);

inserted_id=citydb_pkg.utn9_insert_commodity_classifier(
    id                           :=p_id,
    objectclass_id               :=objectclass_id,  -- objectclass ID
    gmlid                        :=p_gmlid,
    gmlid_codespace              :=p_gmlid_codespace,
    name                         :=p_name,
    name_codespace               :=p_name_codespace,
    description                  :=p_description,
    mol_formula                  :=p_mol_formula             ,
    mol_weight                   :=p_mol_weight              ,
    mol_weight_unit              :=p_mol_weight_unit         ,
    physical_form                :=p_physical_form           ,
    signal_word                  :=p_signal_word             ,
    is_chemical_complex          :=p_is_chemical_complex     ,
    haz_class                    :=p_haz_class               ,
    haz_class_category_code      :=p_haz_class_category_code ,
    haz_class_statement_code     :=p_haz_class_statement_code,
    haz_class_pictogram_code     :=p_haz_class_pictogram_code,
    haz_class_pictogram_uri      :=p_haz_class_pictogram_uri ,
    ec_number                    :=p_ec_number               ,
    cas_number                   :=p_cas_number              ,
--  iuclid_chem_datasheet        :=p_iuclid_chem_datasheet   ,
    commodity_id                 :=p_commodity_id            ,
    material_id                  :=p_material_id             ,
    hollow_space_id              :=p_hollow_space_id         ,		
--
    schema_name             :=p_schema_name  -- schema name
);
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_insert_commodity_classifier_ghs(): %', SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function UTN9_INSERT_COMMODITY_CLASSIFIER_GENERIC
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.utn9_insert_commodity_classifier_generic(
  id                           integer DEFAULT NULL,
  gmlid                        varchar DEFAULT NULL,
  gmlid_codespace              varchar DEFAULT NULL,
  name                         varchar DEFAULT NULL,
  name_codespace               varchar DEFAULT NULL,
  description                  text    DEFAULT NULL,
  mol_formula                  varchar DEFAULT NULL,
  mol_weight                   numeric DEFAULT NULL,
  mol_weight_unit              numeric DEFAULT NULL,
  physical_form                varchar DEFAULT NULL,
  signal_word                  varchar DEFAULT NULL,
  is_chemical_complex          numeric DEFAULT NULL,
  haz_class                    varchar DEFAULT NULL,
  haz_class_category_code      varchar DEFAULT NULL,
  haz_class_statement_code     varchar DEFAULT NULL,
  haz_class_pictogram_code     varchar DEFAULT NULL,
  haz_class_pictogram_uri      varchar DEFAULT NULL,
--ec_number                    varchar DEFAULT NULL,
--cas_number                   varchar DEFAULT NULL,
--iuclid_chem_datasheet        varchar DEFAULT NULL,
  commodity_id                 integer DEFAULT NULL,
  material_id                  integer DEFAULT NULL,
  hollow_space_id              integer DEFAULT NULL, 
--
  schema_name              varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
  p_id                           integer := id;
  p_gmlid                        varchar := gmlid;
  p_gmlid_codespace              varchar := gmlid_codespace;
  p_name                         varchar := name;
  p_name_codespace               varchar := name_codespace;
  p_description                  text    := description;
  p_mol_formula                  varchar :=mol_formula             ;
  p_mol_weight                   numeric :=mol_weight              ;
  p_mol_weight_unit              numeric :=mol_weight_unit         ;
  p_physical_form                varchar :=physical_form           ;
  p_signal_word                  varchar :=signal_word             ;
  p_is_chemical_complex          numeric :=is_chemical_complex     ;
  p_haz_class                    varchar :=haz_class               ;
  p_haz_class_category_code      varchar :=haz_class_category_code ;
  p_haz_class_statement_code     varchar :=haz_class_statement_code;
  p_haz_class_pictogram_code     varchar :=haz_class_pictogram_code;
  p_haz_class_pictogram_uri      varchar :=haz_class_pictogram_uri ;
--p_ec_number                    varchar :=ec_number               ;
--p_cas_number                   varchar :=cas_number              ;
--p_iuclid_chem_datasheet        varchar :=iuclid_chem_datasheet   ;
  p_commodity_id                 integer :=commodity_id            ;
  p_material_id                  integer :=material_id             ;
  p_hollow_space_id              integer :=hollow_space_id         ; 	
--
  p_schema_name varchar := schema_name;
  class_name varchar DEFAULT 'GenericClassifier'::varchar;
  db_prefix varchar DEFAULT 'utn9';
  objectclass_id integer;
  inserted_id integer;
BEGIN
objectclass_id=citydb_pkg.objectclass_classname_to_id(class_name, db_prefix, p_schema_name);

inserted_id=citydb_pkg.utn9_insert_commodity_classifier(
    id                           :=p_id,
    objectclass_id               :=objectclass_id,  -- objectclass ID
    gmlid                        :=p_gmlid,
    gmlid_codespace              :=p_gmlid_codespace,
    name                         :=p_name,
    name_codespace               :=p_name_codespace,
    description                  :=p_description,
    mol_formula                  :=p_mol_formula             ,
    mol_weight                   :=p_mol_weight              ,
    mol_weight_unit              :=p_mol_weight_unit         ,
    physical_form                :=p_physical_form           ,
    signal_word                  :=p_signal_word             ,
    is_chemical_complex          :=p_is_chemical_complex     ,
    haz_class                    :=p_haz_class               ,
    haz_class_category_code      :=p_haz_class_category_code ,
    haz_class_statement_code     :=p_haz_class_statement_code,
    haz_class_pictogram_code     :=p_haz_class_pictogram_code,
    haz_class_pictogram_uri      :=p_haz_class_pictogram_uri ,
--  ec_number                    :=p_ec_number               ,
--  cas_number                   :=p_cas_number              ,
--  iuclid_chem_datasheet        :=p_iuclid_chem_datasheet   ,
    commodity_id                 :=p_commodity_id            ,
    material_id                  :=p_material_id             ,
    hollow_space_id              :=p_hollow_space_id         ,		
--
    schema_name             :=p_schema_name  -- schema name
);
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_insert_commodity_classifier_generic(): %', SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function UTN9_INSERT_NETWORK_GRAPH
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.utn9_insert_network_graph(
  id                           integer DEFAULT NULL,
  gmlid                        varchar DEFAULT NULL,
  gmlid_codespace              varchar DEFAULT NULL,
  name                         varchar DEFAULT NULL,
  name_codespace               varchar DEFAULT NULL,
  description                  text    DEFAULT NULL,
  network_id                   integer DEFAULT NULL,
--
  schema_name              varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
  p_id                           integer           := id;
  p_gmlid                        character varying := gmlid;
  p_gmlid_codespace              character varying := gmlid_codespace;
  p_name                         character varying := name;
  p_name_codespace               character varying := name_codespace;
  p_description                  text              := description;
  p_network_id                   integer           := network_id;
--
  p_schema_name varchar := schema_name;
  class_name varchar DEFAULT 'NetworkGraph'::varchar;
  db_prefix varchar DEFAULT 'utn9';
  objectclass_id integer;
  inserted_id integer;
BEGIN
objectclass_id=citydb_pkg.objectclass_classname_to_id(class_name, db_prefix, p_schema_name);

inserted_id=citydb_pkg.utn9_insert_network_graph(
    id                           :=p_id,
    objectclass_id               :=objectclass_id,  -- objectclass ID
    gmlid                        :=p_gmlid,
    gmlid_codespace              :=p_gmlid_codespace,
    name                         :=p_name,
    name_codespace               :=p_name_codespace,
    description                  :=p_description,
    network_id                   :=p_network_id,
--
    schema_name             :=p_schema_name  -- schema name
);
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_insert_network_graph(): %', SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function UTN9_INSERT_FEATURE_GRAPH
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.utn9_insert_feature_graph(
  id                           integer DEFAULT NULL,
  gmlid                        varchar DEFAULT NULL,
  gmlid_codespace              varchar DEFAULT NULL,
  name                         varchar DEFAULT NULL,
  name_codespace               varchar DEFAULT NULL,
  description                  text    DEFAULT NULL,
  ntw_feature_id               integer DEFAULT NULL,
  ntw_graph_id                 integer DEFAULT NULL,	
--
  schema_name              varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
  p_id                           integer           := id;
  p_gmlid                        character varying := gmlid;
  p_gmlid_codespace              character varying := gmlid_codespace;
  p_name                         character varying := name;
  p_name_codespace               character varying := name_codespace;
  p_description                  text              := description;
  p_ntw_feature_id               integer           := ntw_feature_id;
  p_ntw_graph_id                 integer           := ntw_graph_id;
--
  p_schema_name varchar := schema_name;
  class_name varchar DEFAULT 'FeatureGraph'::varchar;
  db_prefix varchar DEFAULT 'utn9';
  objectclass_id integer;
  inserted_id integer;
BEGIN
objectclass_id=citydb_pkg.objectclass_classname_to_id(class_name, db_prefix, p_schema_name);

inserted_id=citydb_pkg.utn9_insert_feature_graph(
    id                           :=p_id,
    objectclass_id               :=objectclass_id,  -- objectclass ID
    gmlid                        :=p_gmlid,
    gmlid_codespace              :=p_gmlid_codespace,
    name                         :=p_name,
    name_codespace               :=p_name_codespace,
    description                  :=p_description,
    ntw_feature_id               :=p_ntw_feature_id,
    ntw_graph_id                 :=p_ntw_graph_id,
--
    schema_name             :=p_schema_name  -- schema name
);
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_insert_feature_graph(): %', SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function UTN9_INSERT_HOLLOW_SPACE
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.utn9_insert_hollow_space(
  id                integer DEFAULT NULL,
  hol_spc_parent_id integer DEFAULT NULL,
  hol_spc_root_id   integer DEFAULT NULL,
  gmlid             varchar DEFAULT NULL,
  gmlid_codespace   varchar DEFAULT NULL,
  name              varchar DEFAULT NULL,
  name_codespace    varchar DEFAULT NULL,
  description       text DEFAULT NULL,
  ntw_feature_id    integer DEFAULT NULL,
--
  schema_name              varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
  p_id                           integer := id;
  p_hol_spc_parent_id            integer := hol_spc_parent_id;
  p_hol_spc_root_id              integer := hol_spc_root_id;	
  p_gmlid                        varchar := gmlid;
  p_gmlid_codespace              varchar := gmlid_codespace;
  p_name                         varchar := name;
  p_name_codespace               varchar := name_codespace;
  p_description                  text    := description;
  p_ntw_feature_id               integer := ntw_feature_id;	
--
  p_schema_name varchar := schema_name;
  class_name varchar DEFAULT 'HollowSpace'::varchar;
  db_prefix varchar DEFAULT 'utn9';
  objectclass_id integer;
  inserted_id integer;
BEGIN
objectclass_id=citydb_pkg.objectclass_classname_to_id(class_name, db_prefix, p_schema_name);

inserted_id=citydb_pkg.utn9_insert_feature_graph(
    id                           :=p_id,
    objectclass_id               :=objectclass_id,  -- objectclass ID
    hol_spc_parent_id            :=p_hol_spc_parent_id,
    hol_spc_root_id              :=p_hol_spc_root_id,
    gmlid                        :=p_gmlid,
    gmlid_codespace              :=p_gmlid_codespace,
    name                         :=p_name,
    name_codespace               :=p_name_codespace,
    description                  :=p_description,
    ntw_feature_id               :=p_ntw_feature_id,
--
    schema_name             :=p_schema_name  -- schema name
);
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_insert_hollow_space(): %', SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function UTN9_INSERT_HOLLOW_SPACE_PART
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.utn9_insert_hollow_space_part(
  id                integer DEFAULT NULL,
  hol_spc_parent_id integer DEFAULT NULL,
  hol_spc_root_id   integer DEFAULT NULL,
  gmlid             varchar DEFAULT NULL,
  gmlid_codespace   varchar DEFAULT NULL,
  name              varchar DEFAULT NULL,
  name_codespace    varchar DEFAULT NULL,
  description       text DEFAULT NULL,
  ntw_feature_id    integer DEFAULT NULL,
--
  schema_name              varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
  p_id                           integer := id;
  p_hol_spc_parent_id            integer := hol_spc_parent_id;
  p_hol_spc_root_id              integer := hol_spc_root_id;	
  p_gmlid                        varchar := gmlid;
  p_gmlid_codespace              varchar := gmlid_codespace;
  p_name                         varchar := name;
  p_name_codespace               varchar := name_codespace;
  p_description                  text    := description;
  p_ntw_feature_id               integer := ntw_feature_id;	
--
  p_schema_name varchar := schema_name;
  class_name varchar DEFAULT 'HollowSpacePart'::varchar;
  db_prefix varchar DEFAULT 'utn9';
  objectclass_id integer;
  inserted_id integer;
BEGIN
objectclass_id=citydb_pkg.objectclass_classname_to_id(class_name, db_prefix, p_schema_name);

inserted_id=citydb_pkg.utn9_insert_feature_graph(
    id                           :=p_id,
    objectclass_id               :=objectclass_id,  -- objectclass ID
    hol_spc_parent_id            :=p_hol_spc_parent_id,
    hol_spc_root_id              :=p_hol_spc_root_id,
    gmlid                        :=p_gmlid,
    gmlid_codespace              :=p_gmlid_codespace,
    name                         :=p_name,
    name_codespace               :=p_name_codespace,
    description                  :=p_description,
    ntw_feature_id               :=p_ntw_feature_id,
--
    schema_name             :=p_schema_name  -- schema name
);
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_insert_hollow_space_part(): %', SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function UTN9_INSERT_LINK_INTERFEATURE
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.utn9_insert_link_interfeature(
  id                           integer DEFAULT NULL,
  gmlid                        varchar DEFAULT NULL,
  gmlid_codespace              varchar DEFAULT NULL,
  name                         varchar DEFAULT NULL,
  name_codespace               varchar DEFAULT NULL,
  description                  text    DEFAULT NULL,
  direction                    character DEFAULT NULL,
  link_control                 varchar DEFAULT NULL,
  type                         varchar DEFAULT NULL,
  start_node_id                integer DEFAULT NULL,
  end_node_id                  integer DEFAULT NULL,
--  feat_graph_id                integer DEFAULT NULL,
  ntw_graph_id                 integer DEFAULT NULL,
  line_geom                    geometry DEFAULT NULL,	
--
  schema_name              varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
  p_id                           integer           := id;
  p_gmlid                        character varying := gmlid;
  p_gmlid_codespace              character varying := gmlid_codespace;
  p_name                         character varying := name;
  p_name_codespace               character varying := name_codespace;
  p_description                  text              := description;
  p_direction                    character         := direction;
  p_link_control                 varchar           := link_control;
  p_type                         varchar           := type;
  p_start_node_id                integer           := start_node_id;
  p_end_node_id                  integer           := end_node_id;
--  p_feat_graph_id                integer           := feat_graph_id;
  p_ntw_graph_id                 integer           := ntw_graph_id;
  p_line_geom                    geometry          := line_geom;
--
  p_schema_name varchar := schema_name;
  class_name varchar DEFAULT 'InterFeatureLink'::varchar;
  db_prefix varchar DEFAULT 'utn9';
  objectclass_id integer;
  inserted_id integer;
BEGIN
objectclass_id=citydb_pkg.objectclass_classname_to_id(class_name, db_prefix, p_schema_name);

inserted_id=citydb_pkg.utn9_insert_link(
    id                           :=p_id,
    objectclass_id               :=objectclass_id,  -- objectclass ID
    gmlid                        :=p_gmlid,
    gmlid_codespace              :=p_gmlid_codespace,
    name                         :=p_name,
    name_codespace               :=p_name_codespace,
    description                  :=p_description,
    direction                    :=p_direction,
    link_control                 :=p_link_control,
    type                         :=p_type,
    start_node_id                :=p_start_node_id,
    end_node_id                  :=p_end_node_id,
--    feat_graph_id                :=p_feat_graph_id,
    ntw_graph_id                 :=p_ntw_graph_id,
    line_geom                    :=p_line_geom,
--
    schema_name             :=p_schema_name  -- schema name
);
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_insert_link_interfeature(): %', SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function UTN9_INSERT_LINK_INTERIOR_FEATURE
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.utn9_insert_link_interior_feature(
  id                           integer DEFAULT NULL,
  gmlid                        varchar DEFAULT NULL,
  gmlid_codespace              varchar DEFAULT NULL,
  name                         varchar DEFAULT NULL,
  name_codespace               varchar DEFAULT NULL,
  description                  text    DEFAULT NULL,
  direction                    character DEFAULT NULL,
  link_control                 varchar DEFAULT NULL,
--  type       varchar DEFAULT NULL,
  start_node_id                integer DEFAULT NULL,
  end_node_id                  integer DEFAULT NULL,
  feat_graph_id                integer DEFAULT NULL,
--  ntw_graph_id                 integer DEFAULT NULL,
  line_geom                    geometry DEFAULT NULL,	
--
  schema_name              varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
  p_id                           integer           := id;
  p_gmlid                        character varying := gmlid;
  p_gmlid_codespace              character varying := gmlid_codespace;
  p_name                         character varying := name;
  p_name_codespace               character varying := name_codespace;
  p_description                  text              := description;
  p_direction                    character         := direction;
  p_link_control                 varchar           := link_control;
--  p_type       varchar           := type;
  p_start_node_id                integer           := start_node_id;
  p_end_node_id                  integer           := end_node_id;
  p_feat_graph_id                integer           := feat_graph_id;
--  p_ntw_graph_id                 integer           := ntw_graph_id;
  p_line_geom                    geometry          := line_geom;
--
  p_schema_name varchar := schema_name;
  class_name varchar DEFAULT 'InteriorFeatureLink'::varchar;
  db_prefix varchar DEFAULT 'utn9';
  objectclass_id integer;
  inserted_id integer;
BEGIN
objectclass_id=citydb_pkg.objectclass_classname_to_id(class_name, db_prefix, p_schema_name);

inserted_id=citydb_pkg.utn9_insert_link(
    id                           :=p_id,
    objectclass_id               :=objectclass_id,  -- objectclass ID
    gmlid                        :=p_gmlid,
    gmlid_codespace              :=p_gmlid_codespace,
    name                         :=p_name,
    name_codespace               :=p_name_codespace,
    description                  :=p_description,
    direction                    :=p_direction,
    link_control                 :=p_link_control,
--    type       :=p_type,
    start_node_id                :=p_start_node_id,
    end_node_id                  :=p_end_node_id,
    feat_graph_id                :=p_feat_graph_id,
--    ntw_graph_id                 :=p_ntw_graph_id,
    line_geom                    :=p_line_geom,
--
    schema_name             :=p_schema_name  -- schema name
);
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_insert_link_interior_feature(): %', SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function UTN9_INSERT_LINK_NETWORK
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.utn9_insert_link_network(
  id                           integer DEFAULT NULL,
  gmlid                        varchar DEFAULT NULL,
  gmlid_codespace              varchar DEFAULT NULL,
  name                         varchar DEFAULT NULL,
  name_codespace               varchar DEFAULT NULL,
  description                  text    DEFAULT NULL,
  direction                    character DEFAULT NULL,
  link_control                 varchar DEFAULT NULL,
--  type       varchar DEFAULT NULL,
  start_node_id                integer DEFAULT NULL,
  end_node_id                  integer DEFAULT NULL,
  feat_graph_id                integer DEFAULT NULL,
--  ntw_graph_id                 integer DEFAULT NULL,
  line_geom                    geometry DEFAULT NULL,	
--
  schema_name              varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
  p_id                           integer           := id;
  p_gmlid                        character varying := gmlid;
  p_gmlid_codespace              character varying := gmlid_codespace;
  p_name                         character varying := name;
  p_name_codespace               character varying := name_codespace;
  p_description                  text              := description;
  p_direction                    character         := direction;
  p_link_control                 varchar           := link_control;
--  p_type       varchar           := type;
  p_start_node_id                integer           := start_node_id;
  p_end_node_id                  integer           := end_node_id;
  p_feat_graph_id                integer           := feat_graph_id;
--  p_ntw_graph_id                 integer           := ntw_graph_id;
  p_line_geom                    geometry          := line_geom;
--
  p_schema_name varchar := schema_name;
  class_name varchar DEFAULT 'NetworkLink'::varchar;
  db_prefix varchar DEFAULT 'utn9';
  objectclass_id integer;
  inserted_id integer;
BEGIN
objectclass_id=citydb_pkg.objectclass_classname_to_id(class_name, db_prefix, p_schema_name);

inserted_id=citydb_pkg.utn9_insert_link(
    id                           :=p_id,
    objectclass_id               :=objectclass_id,  -- objectclass ID
    gmlid                        :=p_gmlid,
    gmlid_codespace              :=p_gmlid_codespace,
    name                         :=p_name,
    name_codespace               :=p_name_codespace,
    description                  :=p_description,
    direction                    :=p_direction,
    link_control                 :=p_link_control,
--    type       :=p_type,
    start_node_id                :=p_start_node_id,
    end_node_id                  :=p_end_node_id,
    feat_graph_id                :=p_feat_graph_id,
--    ntw_graph_id                 :=p_ntw_graph_id,
    line_geom                    :=p_line_geom,
--
    schema_name             :=p_schema_name  -- schema name
);
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_insert_link_network(): %', SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function UTN9_INSERT_MATERIAL_INTERIOR
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.utn9_insert_material_interior(
  id                           integer DEFAULT NULL,
  material_parent_id           integer DEFAULT NULL,
  material_root_id             integer DEFAULT NULL,	
  gmlid                        varchar DEFAULT NULL,
  gmlid_codespace              varchar DEFAULT NULL,
  name                         varchar DEFAULT NULL,
  name_codespace               varchar DEFAULT NULL,
  description                  text    DEFAULT NULL,
  type                         varchar DEFAULT NULL,
--material_id                  integer DEFAULT NULL,
--
  schema_name              varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
  p_id                           integer := id;
  p_material_parent_id           integer := material_parent_id;
  p_material_root_id             integer := material_root_id;  
  p_gmlid                        varchar := gmlid;
  p_gmlid_codespace              varchar := gmlid_codespace;
  p_name                         varchar := name;
  p_name_codespace               varchar := name_codespace;
  p_description                  text    := description;
  p_type                         varchar := type;              
--p_material_id                  integer := material_id;
--
  p_schema_name varchar := schema_name;
  class_name varchar DEFAULT 'InteriorMaterial'::varchar;
  db_prefix varchar DEFAULT 'utn9';
  objectclass_id integer;
  inserted_id integer;
BEGIN
objectclass_id=citydb_pkg.objectclass_classname_to_id(class_name, db_prefix, p_schema_name);

inserted_id=citydb_pkg.utn9_insert_material(
  id                           :=p_id,
  objectclass_id               :=objectclass_id,  -- objectclass ID
  material_parent_id           :=p_material_parent_id,
  material_root_id             :=p_material_root_id,
  gmlid                        :=p_gmlid,
  gmlid_codespace              :=p_gmlid_codespace,
  name                         :=p_name,
  name_codespace               :=p_name_codespace,
  description                  :=p_description,
  type                         :=p_type,              
--material_id                  :=p_material_id,	
--
  schema_name             :=p_schema_name  -- schema name
);
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_insert_material_interior(): %', SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function UTN9_INSERT_MATERIAL_EXTERIOR
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.utn9_insert_material_exterior(
  id                           integer DEFAULT NULL,
  material_parent_id           integer DEFAULT NULL,
  material_root_id             integer DEFAULT NULL,	
  gmlid                        varchar DEFAULT NULL,
  gmlid_codespace              varchar DEFAULT NULL,
  name                         varchar DEFAULT NULL,
  name_codespace               varchar DEFAULT NULL,
  description                  text    DEFAULT NULL,
  type                         varchar DEFAULT NULL,
--material_id                  integer DEFAULT NULL,
--
  schema_name              varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
  p_id                           integer := id;
  p_material_parent_id           integer := material_parent_id;
  p_material_root_id             integer := material_root_id;  
  p_gmlid                        varchar := gmlid;
  p_gmlid_codespace              varchar := gmlid_codespace;
  p_name                         varchar := name;
  p_name_codespace               varchar := name_codespace;
  p_description                  text    := description;
  p_type                         varchar := type;              
--p_material_id                  integer := material_id;
--
  p_schema_name varchar := schema_name;
  class_name varchar DEFAULT 'ExteriorMaterial'::varchar;
  db_prefix varchar DEFAULT 'utn9';
  objectclass_id integer;
  inserted_id integer;
BEGIN
objectclass_id=citydb_pkg.objectclass_classname_to_id(class_name, db_prefix, p_schema_name);

inserted_id=citydb_pkg.utn9_insert_material(
  id                           :=p_id,
  objectclass_id               :=objectclass_id,  -- objectclass ID
  material_parent_id           :=p_material_parent_id,
  material_root_id             :=p_material_root_id,
  gmlid                        :=p_gmlid,
  gmlid_codespace              :=p_gmlid_codespace,
  name                         :=p_name,
  name_codespace               :=p_name_codespace,
  description                  :=p_description,
  type                         :=p_type,              
--material_id                  :=p_material_id,	
--
  schema_name             :=p_schema_name  -- schema name
);
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_insert_material_exterior(): %', SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function UTN9_INSERT_MATERIAL_FILLING
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.utn9_insert_material_filling(
  id                           integer DEFAULT NULL,
  material_parent_id           integer DEFAULT NULL,
  material_root_id             integer DEFAULT NULL,	
  gmlid                        varchar DEFAULT NULL,
  gmlid_codespace              varchar DEFAULT NULL,
  name                         varchar DEFAULT NULL,
  name_codespace               varchar DEFAULT NULL,
  description                  text    DEFAULT NULL,
  type                         varchar DEFAULT NULL,
  material_id                  integer DEFAULT NULL,
--
  schema_name              varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
  p_id                           integer := id;
  p_material_parent_id           integer := material_parent_id;
  p_material_root_id             integer := material_root_id;  
  p_gmlid                        varchar := gmlid;
  p_gmlid_codespace              varchar := gmlid_codespace;
  p_name                         varchar := name;
  p_name_codespace               varchar := name_codespace;
  p_description                  text    := description;
  p_type                         varchar := type;              
  p_material_id                  integer := material_id;
--
  p_schema_name varchar := schema_name;
  class_name varchar DEFAULT 'FillingMaterial'::varchar;
  db_prefix varchar DEFAULT 'utn9';
  objectclass_id integer;
  inserted_id integer;
BEGIN
objectclass_id=citydb_pkg.objectclass_classname_to_id(class_name, db_prefix, p_schema_name);

inserted_id=citydb_pkg.utn9_insert_material(
  id                           :=p_id,
  objectclass_id               :=objectclass_id,  -- objectclass ID
  material_parent_id           :=p_material_parent_id,
  material_root_id             :=p_material_root_id,
  gmlid                        :=p_gmlid,
  gmlid_codespace              :=p_gmlid_codespace,
  name                         :=p_name,
  name_codespace               :=p_name_codespace,
  description                  :=p_description,
  type                         :=p_type,              
  material_id                  :=p_material_id,	
--
  schema_name             :=p_schema_name  -- schema name
);
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_insert_material_filling(): %', SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function UTN9_INSERT_MEDIUM_SUPPLY_ELECTRICAL
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.utn9_insert_medium_supply_electrical(
  id                        integer DEFAULT NULL,
  type                      varchar DEFAULT NULL,
  cur_flow_rate      numeric DEFAULT NULL,
  cur_flow_rate_unit varchar DEFAULT NULL,
  cur_status         varchar DEFAULT NULL,
  pot_flow_rate      numeric DEFAULT NULL,
  pot_flow_rate_unit varchar DEFAULT NULL,
  pot_status         varchar DEFAULT NULL,
  cityobject_id             integer DEFAULT NULL,	
--
  schema_name              varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
  p_id                           integer := id;
  p_type                         varchar :=type                     ;
  p_cur_flow_rate         numeric :=cur_flow_rate     ;
  p_cur_flow_rate_unit    varchar :=cur_flow_rate_unit;
  p_cur_status            varchar :=cur_status        ;
  p_pot_flow_rate         numeric :=pot_flow_rate     ;
  p_pot_flow_rate_unit    varchar :=pot_flow_rate_unit;
  p_pot_status            varchar :=pot_status        ;
  p_cityobject_id                integer :=cityobject_id            ;	
--
  p_schema_name varchar := schema_name;
  class_name varchar DEFAULT 'ElectricalMediumSupply'::varchar;
  db_prefix varchar DEFAULT 'utn9';
  objectclass_id integer;
  inserted_id integer;
BEGIN
objectclass_id=citydb_pkg.objectclass_classname_to_id(class_name, db_prefix, p_schema_name);

inserted_id=citydb_pkg.utn9_insert_medium_supply(
    id                           :=p_id,
    objectclass_id               :=objectclass_id,  -- objectclass ID
    type                         :=p_type                     ,
    cur_flow_rate         :=p_cur_flow_rate     ,
    cur_flow_rate_unit    :=p_cur_flow_rate_unit,
    cur_status            :=p_cur_status        ,
    pot_flow_rate         :=p_pot_flow_rate     ,
    pot_flow_rate_unit    :=p_pot_flow_rate_unit,
    pot_status            :=p_pot_status        ,
    cityobject_id                :=p_cityobject_id            ,		
--
    schema_name             :=p_schema_name  -- schema name
);
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_insert_medium_supply_electrical(): %', SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function UTN9_INSERT_MEDIUM_SUPPLY_GASEOUS
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.utn9_insert_medium_supply_gaseous(
  id                        integer DEFAULT NULL,
  type                      varchar DEFAULT NULL,
  cur_flow_rate      numeric DEFAULT NULL,
  cur_flow_rate_unit varchar DEFAULT NULL,
  cur_status         varchar DEFAULT NULL,
  pot_flow_rate      numeric DEFAULT NULL,
  pot_flow_rate_unit varchar DEFAULT NULL,
  pot_status         varchar DEFAULT NULL,
  cityobject_id             integer DEFAULT NULL,	
--
  schema_name              varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
  p_id                           integer := id;
  p_type                         varchar :=type                     ;
  p_cur_flow_rate         numeric :=cur_flow_rate     ;
  p_cur_flow_rate_unit    varchar :=cur_flow_rate_unit;
  p_cur_status            varchar :=cur_status        ;
  p_pot_flow_rate         numeric :=pot_flow_rate     ;
  p_pot_flow_rate_unit    varchar :=pot_flow_rate_unit;
  p_pot_status            varchar :=pot_status        ;
  p_cityobject_id                integer :=cityobject_id            ;	
--
  p_schema_name varchar := schema_name;
  class_name varchar DEFAULT 'GaseousMediumSupply'::varchar;
  db_prefix varchar DEFAULT 'utn9';
  objectclass_id integer;
  inserted_id integer;
BEGIN
objectclass_id=citydb_pkg.objectclass_classname_to_id(class_name, db_prefix, p_schema_name);

inserted_id=citydb_pkg.utn9_insert_medium_supply(
    id                           :=p_id,
    objectclass_id               :=objectclass_id,  -- objectclass ID
    type                         :=p_type                     ,
    cur_flow_rate         :=p_cur_flow_rate     ,
    cur_flow_rate_unit    :=p_cur_flow_rate_unit,
    cur_status            :=p_cur_status        ,
    pot_flow_rate         :=p_pot_flow_rate     ,
    pot_flow_rate_unit    :=p_pot_flow_rate_unit,
    pot_status            :=p_pot_status        ,
    cityobject_id                :=p_cityobject_id            ,		
--
    schema_name             :=p_schema_name  -- schema name
);
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_insert_medium_supply_gaseous(): %', SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function UTN9_INSERT_MEDIUM_SUPPLY_LIQUID
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.utn9_insert_medium_supply_liquid(
  id                        integer DEFAULT NULL,
  type                      varchar DEFAULT NULL,
  cur_flow_rate      numeric DEFAULT NULL,
  cur_flow_rate_unit varchar DEFAULT NULL,
  cur_status         varchar DEFAULT NULL,
  pot_flow_rate      numeric DEFAULT NULL,
  pot_flow_rate_unit varchar DEFAULT NULL,
  pot_status         varchar DEFAULT NULL,
  cityobject_id             integer DEFAULT NULL,	
--
  schema_name              varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
  p_id                           integer := id;
  p_type                         varchar :=type                     ;
  p_cur_flow_rate         numeric :=cur_flow_rate     ;
  p_cur_flow_rate_unit    varchar :=cur_flow_rate_unit;
  p_cur_status            varchar :=cur_status        ;
  p_pot_flow_rate         numeric :=pot_flow_rate     ;
  p_pot_flow_rate_unit    varchar :=pot_flow_rate_unit;
  p_pot_status            varchar :=pot_status        ;
  p_cityobject_id                integer :=cityobject_id            ;	
--
  p_schema_name varchar := schema_name;
  class_name varchar DEFAULT 'LiquidMediumSupply'::varchar;
  db_prefix varchar DEFAULT 'utn9';
  objectclass_id integer;
  inserted_id integer;
BEGIN
objectclass_id=citydb_pkg.objectclass_classname_to_id(class_name, db_prefix, p_schema_name);

inserted_id=citydb_pkg.utn9_insert_medium_supply(
    id                           :=p_id,
    objectclass_id               :=objectclass_id,  -- objectclass ID
    type                         :=p_type                     ,
    cur_flow_rate         :=p_cur_flow_rate     ,
    cur_flow_rate_unit    :=p_cur_flow_rate_unit,
    cur_status            :=p_cur_status        ,
    pot_flow_rate         :=p_pot_flow_rate     ,
    pot_flow_rate_unit    :=p_pot_flow_rate_unit,
    pot_status            :=p_pot_status        ,
    cityobject_id                :=p_cityobject_id            ,		
--
    schema_name             :=p_schema_name  -- schema name
);
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_insert_medium_supply_liquid(): %', SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function UTN9_INSERT_MEDIUM_SUPPLY_OPTICAL
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.utn9_insert_medium_supply_optical(
  id                        integer DEFAULT NULL,
  type                      varchar DEFAULT NULL,
  cur_flow_rate      numeric DEFAULT NULL,
  cur_flow_rate_unit varchar DEFAULT NULL,
  cur_status         varchar DEFAULT NULL,
  pot_flow_rate      numeric DEFAULT NULL,
  pot_flow_rate_unit varchar DEFAULT NULL,
  pot_status         varchar DEFAULT NULL,
  cityobject_id             integer DEFAULT NULL,	
--
  schema_name              varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
  p_id                           integer := id;
  p_type                         varchar :=type                     ;
  p_cur_flow_rate         numeric :=cur_flow_rate     ;
  p_cur_flow_rate_unit    varchar :=cur_flow_rate_unit;
  p_cur_status            varchar :=cur_status        ;
  p_pot_flow_rate         numeric :=pot_flow_rate     ;
  p_pot_flow_rate_unit    varchar :=pot_flow_rate_unit;
  p_pot_status            varchar :=pot_status        ;
  p_cityobject_id                integer :=cityobject_id            ;	
--
  p_schema_name varchar := schema_name;
  class_name varchar DEFAULT 'OpticalMediumSupply'::varchar;
  db_prefix varchar DEFAULT 'utn9';
  objectclass_id integer;
  inserted_id integer;
BEGIN
objectclass_id=citydb_pkg.objectclass_classname_to_id(class_name, db_prefix, p_schema_name);

inserted_id=citydb_pkg.utn9_insert_medium_supply(
    id                           :=p_id,
    objectclass_id               :=objectclass_id,  -- objectclass ID
    type                         :=p_type                     ,
    cur_flow_rate         :=p_cur_flow_rate     ,
    cur_flow_rate_unit    :=p_cur_flow_rate_unit,
    cur_status            :=p_cur_status        ,
    pot_flow_rate         :=p_pot_flow_rate     ,
    pot_flow_rate_unit    :=p_pot_flow_rate_unit,
    pot_status            :=p_pot_status        ,
    cityobject_id                :=p_cityobject_id            ,		
--
    schema_name             :=p_schema_name  -- schema name
);
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_insert_medium_supply_optical(): %', SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function UTN9_INSERT_MEDIUM_SUPPLY_SOLID
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.utn9_insert_medium_supply_solid(
  id                        integer DEFAULT NULL,
  type                      varchar DEFAULT NULL,
  cur_flow_rate      numeric DEFAULT NULL,
  cur_flow_rate_unit varchar DEFAULT NULL,
  cur_status         varchar DEFAULT NULL,
  pot_flow_rate      numeric DEFAULT NULL,
  pot_flow_rate_unit varchar DEFAULT NULL,
  pot_status         varchar DEFAULT NULL,
  cityobject_id             integer DEFAULT NULL,	
--
  schema_name              varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
  p_id                           integer := id;
  p_type                         varchar :=type                     ;
  p_cur_flow_rate         numeric :=cur_flow_rate     ;
  p_cur_flow_rate_unit    varchar :=cur_flow_rate_unit;
  p_cur_status            varchar :=cur_status        ;
  p_pot_flow_rate         numeric :=pot_flow_rate     ;
  p_pot_flow_rate_unit    varchar :=pot_flow_rate_unit;
  p_pot_status            varchar :=pot_status        ;
  p_cityobject_id                integer :=cityobject_id            ;	
--
  p_schema_name varchar := schema_name;
  class_name varchar DEFAULT 'SolidMediumSupply'::varchar;
  db_prefix varchar DEFAULT 'utn9';
  objectclass_id integer;
  inserted_id integer;
BEGIN
objectclass_id=citydb_pkg.objectclass_classname_to_id(class_name, db_prefix, p_schema_name);

inserted_id=citydb_pkg.utn9_insert_medium_supply(
    id                           :=p_id,
    objectclass_id               :=objectclass_id,  -- objectclass ID
    type                         :=p_type                     ,
    cur_flow_rate         :=p_cur_flow_rate     ,
    cur_flow_rate_unit    :=p_cur_flow_rate_unit,
    cur_status            :=p_cur_status        ,
    pot_flow_rate         :=p_pot_flow_rate     ,
    pot_flow_rate_unit    :=p_pot_flow_rate_unit,
    pot_status            :=p_pot_status        ,
    cityobject_id                :=p_cityobject_id            ,		
--
    schema_name             :=p_schema_name  -- schema name
);
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_insert_medium_supply_solid(): %', SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function UTN9_INSERT_NETWORK
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.utn9_insert_network(
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
  network_parent_id integer DEFAULT NULL,
  network_root_id   integer DEFAULT NULL,
  class             varchar DEFAULT NULL,
  function          varchar DEFAULT NULL,
  usage             varchar DEFAULT NULL,
  commodity_id      integer DEFAULT NULL,
--
  schema_name              varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
  p_id                     integer                     := id                    ;
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
  p_network_parent_id      integer := network_parent_id;
  p_network_root_id        integer := network_root_id;
  p_class                  varchar := class;
  p_function               varchar := function;
  p_usage                  varchar := usage;
  p_commodity_id           integer := commodity_id;
--
  p_schema_name varchar := schema_name;
  class_name varchar DEFAULT 'Network'::varchar;
  db_prefix varchar DEFAULT 'utn9';
  objectclass_id integer;
  inserted_id integer;
BEGIN
objectclass_id=citydb_pkg.objectclass_classname_to_id(class_name, db_prefix, p_schema_name);

inserted_id=citydb_pkg.insert_cityobject(
    id                    :=p_id,
    objectclass_id        :=objectclass_id,
    gmlid                 :=p_gmlid,
    gmlid_codespace       :=p_gmlid_codespace,
    name                  :=p_name,
    name_codespace        :=p_name_codespace,
    description           :=p_description,
    envelope              :=p_envelope,
    creation_date         :=p_creation_date,
    termination_date      :=p_termination_date,
    relative_to_terrain   :=p_relative_to_terrain,
    relative_to_water     :=p_relative_to_water,
    last_modification_date:=p_last_modification_date,
    updating_person       :=p_updating_person,
    reason_for_update     :=p_reason_for_update,
    lineage               :=p_lineage,
    schema_name           :=p_schema_name
);

PERFORM citydb_pkg.utn9_insert_network(
    id                           :=inserted_id,
    objectclass_id               :=objectclass_id,  -- objectclass ID
    network_parent_id            :=p_network_parent_id,
    network_root_id  		     :=p_network_root_id  ,
    class            		     :=p_class            ,
    function         		     :=p_function         ,
    usage            		     :=p_usage            ,
    commodity_id     		     :=p_commodity_id     ,
--
    schema_name             :=p_schema_name  -- schema name
);
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_insert_network(): %', SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function UTN9_INSERT_NODE
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.utn9_insert_node(
  id                   integer  DEFAULT NULL,
  gmlid                varchar  DEFAULT NULL,
  gmlid_codespace      varchar  DEFAULT NULL,
  name                 varchar  DEFAULT NULL,
  name_codespace       varchar  DEFAULT NULL,
  description          text     DEFAULT NULL,
  type                 varchar  DEFAULT NULL,
  connection_signature varchar  DEFAULT NULL,
  link_control         varchar  DEFAULT NULL,
  feat_graph_id        integer  DEFAULT NULL,
  point_geom           geometry DEFAULT NULL,
--	
  schema_name              varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
  p_id                   integer  := id;
  p_gmlid                varchar  := gmlid;
  p_gmlid_codespace      varchar  := gmlid_codespace;
  p_name                 varchar  := name;
  p_name_codespace       varchar  := name_codespace;
  p_description          text     := description;
  p_type                 varchar  := type;
  p_connection_signature varchar  := connection_signature;
  p_link_control         varchar  := link_control;
  p_feat_graph_id        integer  := feat_graph_id;
  p_point_geom           geometry := point_geom;
--
  p_schema_name varchar := schema_name;
  class_name varchar DEFAULT 'Node'::varchar;
  db_prefix varchar DEFAULT 'utn9';
  objectclass_id integer;
  inserted_id integer;
BEGIN
objectclass_id=citydb_pkg.objectclass_classname_to_id(class_name, db_prefix, p_schema_name);

inserted_id=citydb_pkg.utn9_insert_node(
  id                   :=p_id,
  objectclass_id       :=objectclass_id,  -- objectclass ID
  gmlid                :=gmlid               ,
  gmlid_codespace      :=gmlid_codespace     ,
  name                 :=name                ,
  name_codespace       :=name_codespace      ,
  description          :=description         ,
  type                 :=type                ,
  connection_signature :=connection_signature,
  link_control         :=link_control        ,
  feat_graph_id        :=feat_graph_id       ,
  point_geom           :=point_geom          ,  
--
  schema_name             :=p_schema_name  -- schema name
);
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_insert_node(): %', SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function UTN9_INSERT_NTW_FEAT_COMPLEX_FUNCT_ELEM
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.utn9_insert_ntw_feat_complex_funct_elem(
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
  ntw_feature_parent_id integer DEFAULT NULL,
  ntw_feature_root_id   integer DEFAULT NULL,
  class                 varchar DEFAULT NULL,
  function              varchar DEFAULT NULL,
  usage                 varchar DEFAULT NULL,
  year_of_construction  date    DEFAULT NULL,
  status                varchar DEFAULT NULL,
  location_quality      varchar DEFAULT NULL,
  elevation_quality     varchar DEFAULT NULL,
  conn_cityobject_id    integer DEFAULT NULL,
  prot_element_id       integer DEFAULT NULL,
  geom                  geometry DEFAULT NULL,	
--
  schema_name              varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
  p_id                     integer                     := id                    ;
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
  p_ntw_feature_parent_id  integer  := ntw_feature_parent_id;
  p_ntw_feature_root_id    integer  := ntw_feature_root_id;
  p_class                  varchar  := class;
  p_function               varchar  := function;
  p_usage                  varchar  := usage;
  p_year_of_construction   date     := year_of_construction;
  p_status                 varchar  := status;
  p_location_quality       varchar  := location_quality;
  p_elevation_quality      varchar  := elevation_quality;
  p_conn_cityobject_id     integer  := conn_cityobject_id;
  p_prot_element_id        integer  := prot_element_id;
  p_geom                   geometry := geom;	
--
  p_schema_name varchar := schema_name;
  class_name varchar DEFAULT 'ComplexFunctionalElement'::varchar;
  db_prefix varchar DEFAULT 'utn9';
  objectclass_id integer;
  inserted_id integer;
BEGIN
objectclass_id=citydb_pkg.objectclass_classname_to_id(class_name, db_prefix, p_schema_name);

inserted_id=citydb_pkg.insert_cityobject(
    id                    :=p_id,
    objectclass_id        :=objectclass_id,
    gmlid                 :=p_gmlid,
    gmlid_codespace       :=p_gmlid_codespace,
    name                  :=p_name,
    name_codespace        :=p_name_codespace,
    description           :=p_description,
    envelope              :=p_envelope,
    creation_date         :=p_creation_date,
    termination_date      :=p_termination_date,
    relative_to_terrain   :=p_relative_to_terrain,
    relative_to_water     :=p_relative_to_water,
    last_modification_date:=p_last_modification_date,
    updating_person       :=p_updating_person,
    reason_for_update     :=p_reason_for_update,
    lineage               :=p_lineage,
    schema_name           :=p_schema_name
);

PERFORM citydb_pkg.utn9_insert_network_feature(
    id                    :=inserted_id,
    objectclass_id        :=objectclass_id,  -- objectclass ID
    ntw_feature_parent_id :=p_ntw_feature_parent_id,
    ntw_feature_root_id  	:=p_ntw_feature_root_id  ,
    class                	:=p_class                ,
    function             	:=p_function             ,
    usage                	:=p_usage                ,
    year_of_construction 	:=p_year_of_construction ,
    status               	:=p_status               ,
    location_quality     	:=p_location_quality     ,
    elevation_quality    	:=p_elevation_quality    ,
    conn_cityobject_id      :=p_conn_cityobject_id   ,
    prot_element_id      	:=p_prot_element_id      ,
    geom                 	:=p_geom                 ,
--
    schema_name             :=p_schema_name  -- schema name
);

RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_insert_ntw_feat_complex_funct_elem(): %', SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function UTN9_INSERT_NTW_FEAT_SIMPLE_FUNCT_ELEM
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.utn9_insert_ntw_feat_simple_funct_elem(
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
  ntw_feature_parent_id integer DEFAULT NULL,
  ntw_feature_root_id   integer DEFAULT NULL,
  class                 varchar DEFAULT NULL,
  function              varchar DEFAULT NULL,
  usage                 varchar DEFAULT NULL,
  year_of_construction  date    DEFAULT NULL,
  status                varchar DEFAULT NULL,
  location_quality      varchar DEFAULT NULL,
  elevation_quality     varchar DEFAULT NULL,
  conn_cityobject_id    integer DEFAULT NULL,
  prot_element_id       integer DEFAULT NULL,
  geom                  geometry DEFAULT NULL,	
--
  schema_name              varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
  p_id                     integer                     := id                    ;
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
  p_ntw_feature_parent_id  integer  := ntw_feature_parent_id;
  p_ntw_feature_root_id    integer  := ntw_feature_root_id;
  p_class                  varchar  := class;
  p_function               varchar  := function;
  p_usage                  varchar  := usage;
  p_year_of_construction   date     := year_of_construction;
  p_status                 varchar  := status;
  p_location_quality       varchar  := location_quality;
  p_elevation_quality      varchar  := elevation_quality;
  p_conn_cityobject_id     integer  := conn_cityobject_id;
  p_prot_element_id        integer  := prot_element_id;
  p_geom                   geometry := geom;	
--
  p_schema_name varchar := schema_name;
  class_name varchar DEFAULT 'SimpleFunctionalElement'::varchar;
  db_prefix varchar DEFAULT 'utn9';
  objectclass_id integer;
  inserted_id integer;
BEGIN
objectclass_id=citydb_pkg.objectclass_classname_to_id(class_name, db_prefix, p_schema_name);

inserted_id=citydb_pkg.insert_cityobject(
    id                    :=p_id,
    objectclass_id        :=objectclass_id,
    gmlid                 :=p_gmlid,
    gmlid_codespace       :=p_gmlid_codespace,
    name                  :=p_name,
    name_codespace        :=p_name_codespace,
    description           :=p_description,
    envelope              :=p_envelope,
    creation_date         :=p_creation_date,
    termination_date      :=p_termination_date,
    relative_to_terrain   :=p_relative_to_terrain,
    relative_to_water     :=p_relative_to_water,
    last_modification_date:=p_last_modification_date,
    updating_person       :=p_updating_person,
    reason_for_update     :=p_reason_for_update,
    lineage               :=p_lineage,
    schema_name           :=p_schema_name
);

PERFORM citydb_pkg.utn9_insert_network_feature(
    id                    :=inserted_id,
    objectclass_id        :=objectclass_id,  -- objectclass ID
    ntw_feature_parent_id :=p_ntw_feature_parent_id,
    ntw_feature_root_id  	:=p_ntw_feature_root_id  ,
    class                	:=p_class                ,
    function             	:=p_function             ,
    usage                	:=p_usage                ,
    year_of_construction 	:=p_year_of_construction ,
    status               	:=p_status               ,
    location_quality     	:=p_location_quality     ,
    elevation_quality    	:=p_elevation_quality    ,
    conn_cityobject_id      :=p_conn_cityobject_id   ,
    prot_element_id      	:=p_prot_element_id      ,
    geom                 	:=p_geom                 ,
--
    schema_name             :=p_schema_name  -- schema name
);

RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_insert_ntw_feat_simple_funct_elem(): %', SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function UTN9_INSERT_NTW_FEAT_TERM_ELEM
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.utn9_insert_ntw_feat_term_elem(
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
  ntw_feature_parent_id integer DEFAULT NULL,
  ntw_feature_root_id   integer DEFAULT NULL,
  class                 varchar DEFAULT NULL,
  function              varchar DEFAULT NULL,
  usage                 varchar DEFAULT NULL,
  year_of_construction  date    DEFAULT NULL,
  status                varchar DEFAULT NULL,
  location_quality      varchar DEFAULT NULL,
  elevation_quality     varchar DEFAULT NULL,
  conn_cityobject_id    integer DEFAULT NULL,
  prot_element_id       integer DEFAULT NULL,
  geom                  geometry DEFAULT NULL,	
--
  schema_name              varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
  p_id                     integer                     := id                    ;
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
  p_ntw_feature_parent_id  integer  := ntw_feature_parent_id;
  p_ntw_feature_root_id    integer  := ntw_feature_root_id;
  p_class                  varchar  := class;
  p_function               varchar  := function;
  p_usage                  varchar  := usage;
  p_year_of_construction   date     := year_of_construction;
  p_status                 varchar  := status;
  p_location_quality       varchar  := location_quality;
  p_elevation_quality      varchar  := elevation_quality;
  p_conn_cityobject_id     integer  := conn_cityobject_id;
  p_prot_element_id        integer  := prot_element_id;
  p_geom                   geometry := geom;	
--
  p_schema_name varchar := schema_name;
  class_name varchar DEFAULT 'TerminalElement'::varchar;
  db_prefix varchar DEFAULT 'utn9';
  objectclass_id integer;
  inserted_id integer;
BEGIN
objectclass_id=citydb_pkg.objectclass_classname_to_id(class_name, db_prefix, p_schema_name);

inserted_id=citydb_pkg.insert_cityobject(
    id                    :=p_id,
    objectclass_id        :=objectclass_id,
    gmlid                 :=p_gmlid,
    gmlid_codespace       :=p_gmlid_codespace,
    name                  :=p_name,
    name_codespace        :=p_name_codespace,
    description           :=p_description,
    envelope              :=p_envelope,
    creation_date         :=p_creation_date,
    termination_date      :=p_termination_date,
    relative_to_terrain   :=p_relative_to_terrain,
    relative_to_water     :=p_relative_to_water,
    last_modification_date:=p_last_modification_date,
    updating_person       :=p_updating_person,
    reason_for_update     :=p_reason_for_update,
    lineage               :=p_lineage,
    schema_name           :=p_schema_name
);

PERFORM citydb_pkg.utn9_insert_network_feature(
    id                    :=inserted_id,
    objectclass_id        :=objectclass_id,  -- objectclass ID
    ntw_feature_parent_id :=p_ntw_feature_parent_id,
    ntw_feature_root_id  	:=p_ntw_feature_root_id  ,
    class                	:=p_class                ,
    function             	:=p_function             ,
    usage                	:=p_usage                ,
    year_of_construction 	:=p_year_of_construction ,
    status               	:=p_status               ,
    location_quality     	:=p_location_quality     ,
    elevation_quality    	:=p_elevation_quality    ,
    conn_cityobject_id      :=p_conn_cityobject_id   ,
    prot_element_id      	:=p_prot_element_id      ,
    geom                 	:=p_geom                 ,
--
    schema_name             :=p_schema_name  -- schema name
);

RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_insert_ntw_feat_term_elem(): %', SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function UTN9_INSERT_NTW_FEAT_DEVICE_GENERIC
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.utn9_insert_ntw_feat_device_generic(
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
  ntw_feature_parent_id integer DEFAULT NULL,
  ntw_feature_root_id   integer DEFAULT NULL,
  class                 varchar DEFAULT NULL,
  function              varchar DEFAULT NULL,
  usage                 varchar DEFAULT NULL,
  year_of_construction  date    DEFAULT NULL,
  status                varchar DEFAULT NULL,
  location_quality      varchar DEFAULT NULL,
  elevation_quality     varchar DEFAULT NULL,
  conn_cityobject_id    integer DEFAULT NULL,
  prot_element_id       integer DEFAULT NULL,
  geom                  geometry DEFAULT NULL,	
--
  schema_name              varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
  p_id                     integer                     := id                    ;
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
  p_ntw_feature_parent_id  integer  := ntw_feature_parent_id;
  p_ntw_feature_root_id    integer  := ntw_feature_root_id;
  p_class                  varchar  := class;
  p_function               varchar  := function;
  p_usage                  varchar  := usage;
  p_year_of_construction   date     := year_of_construction;
  p_status                 varchar  := status;
  p_location_quality       varchar  := location_quality;
  p_elevation_quality      varchar  := elevation_quality;
  p_conn_cityobject_id     integer  := conn_cityobject_id;
  p_prot_element_id        integer  := prot_element_id;
  p_geom                   geometry := geom;	
--
  p_schema_name varchar := schema_name;
  class_name varchar DEFAULT 'AnyDevice'::varchar;
  db_prefix varchar DEFAULT 'utn9';
  objectclass_id integer;
  inserted_id integer;
BEGIN
objectclass_id=citydb_pkg.objectclass_classname_to_id(class_name, db_prefix, p_schema_name);

inserted_id=citydb_pkg.insert_cityobject(
    id                    :=p_id,
    objectclass_id        :=objectclass_id,
    gmlid                 :=p_gmlid,
    gmlid_codespace       :=p_gmlid_codespace,
    name                  :=p_name,
    name_codespace        :=p_name_codespace,
    description           :=p_description,
    envelope              :=p_envelope,
    creation_date         :=p_creation_date,
    termination_date      :=p_termination_date,
    relative_to_terrain   :=p_relative_to_terrain,
    relative_to_water     :=p_relative_to_water,
    last_modification_date:=p_last_modification_date,
    updating_person       :=p_updating_person,
    reason_for_update     :=p_reason_for_update,
    lineage               :=p_lineage,
    schema_name           :=p_schema_name
);

PERFORM citydb_pkg.utn9_insert_network_feature(
    id                    :=inserted_id,
    objectclass_id        :=objectclass_id,  -- objectclass ID
    ntw_feature_parent_id :=p_ntw_feature_parent_id,
    ntw_feature_root_id  	:=p_ntw_feature_root_id  ,
    class                	:=p_class                ,
    function             	:=p_function             ,
    usage                	:=p_usage                ,
    year_of_construction 	:=p_year_of_construction ,
    status               	:=p_status               ,
    location_quality     	:=p_location_quality     ,
    elevation_quality    	:=p_elevation_quality    ,
    conn_cityobject_id      :=p_conn_cityobject_id   ,
    prot_element_id      	:=p_prot_element_id      ,
    geom                 	:=p_geom                 ,
--
    schema_name             :=p_schema_name  -- schema name
);

RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_insert_ntw_feat_device_generic(): %', SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function UTN9_INSERT_NTW_FEAT_DEVICE_CONTROLLER
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.utn9_insert_ntw_feat_device_controller(
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
  ntw_feature_parent_id integer DEFAULT NULL,
  ntw_feature_root_id   integer DEFAULT NULL,
  class                 varchar DEFAULT NULL,
  function              varchar DEFAULT NULL,
  usage                 varchar DEFAULT NULL,
  year_of_construction  date    DEFAULT NULL,
  status                varchar DEFAULT NULL,
  location_quality      varchar DEFAULT NULL,
  elevation_quality     varchar DEFAULT NULL,
  conn_cityobject_id    integer DEFAULT NULL,
  prot_element_id       integer DEFAULT NULL,
  geom                  geometry DEFAULT NULL,	
--
  schema_name              varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
  p_id                     integer                     := id                    ;
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
  p_ntw_feature_parent_id  integer  := ntw_feature_parent_id;
  p_ntw_feature_root_id    integer  := ntw_feature_root_id;
  p_class                  varchar  := class;
  p_function               varchar  := function;
  p_usage                  varchar  := usage;
  p_year_of_construction   date     := year_of_construction;
  p_status                 varchar  := status;
  p_location_quality       varchar  := location_quality;
  p_elevation_quality      varchar  := elevation_quality;
  p_conn_cityobject_id     integer  := conn_cityobject_id;
  p_prot_element_id        integer  := prot_element_id;
  p_geom                   geometry := geom;	
--
  p_schema_name varchar := schema_name;
  class_name varchar DEFAULT 'ControllerDevice'::varchar;
  db_prefix varchar DEFAULT 'utn9';
  objectclass_id integer;
  inserted_id integer;
BEGIN
objectclass_id=citydb_pkg.objectclass_classname_to_id(class_name, db_prefix, p_schema_name);

inserted_id=citydb_pkg.insert_cityobject(
    id                    :=p_id,
    objectclass_id        :=objectclass_id,
    gmlid                 :=p_gmlid,
    gmlid_codespace       :=p_gmlid_codespace,
    name                  :=p_name,
    name_codespace        :=p_name_codespace,
    description           :=p_description,
    envelope              :=p_envelope,
    creation_date         :=p_creation_date,
    termination_date      :=p_termination_date,
    relative_to_terrain   :=p_relative_to_terrain,
    relative_to_water     :=p_relative_to_water,
    last_modification_date:=p_last_modification_date,
    updating_person       :=p_updating_person,
    reason_for_update     :=p_reason_for_update,
    lineage               :=p_lineage,
    schema_name           :=p_schema_name
);

PERFORM citydb_pkg.utn9_insert_network_feature(
    id                    :=inserted_id,
    objectclass_id        :=objectclass_id,  -- objectclass ID
    ntw_feature_parent_id :=p_ntw_feature_parent_id,
    ntw_feature_root_id  	:=p_ntw_feature_root_id  ,
    class                	:=p_class                ,
    function             	:=p_function             ,
    usage                	:=p_usage                ,
    year_of_construction 	:=p_year_of_construction ,
    status               	:=p_status               ,
    location_quality     	:=p_location_quality     ,
    elevation_quality    	:=p_elevation_quality    ,
    conn_cityobject_id      :=p_conn_cityobject_id   ,
    prot_element_id      	:=p_prot_element_id      ,
    geom                 	:=p_geom                 ,
--
    schema_name             :=p_schema_name  -- schema name
);

RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_insert_ntw_feat_device_controller(): %', SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function UTN9_INSERT_NTW_FEAT_DEVICE_MEAS
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.utn9_insert_ntw_feat_device_meas(
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
  ntw_feature_parent_id integer DEFAULT NULL,
  ntw_feature_root_id   integer DEFAULT NULL,
  class                 varchar DEFAULT NULL,
  function              varchar DEFAULT NULL,
  usage                 varchar DEFAULT NULL,
  year_of_construction  date    DEFAULT NULL,
  status                varchar DEFAULT NULL,
  location_quality      varchar DEFAULT NULL,
  elevation_quality     varchar DEFAULT NULL,
  conn_cityobject_id    integer DEFAULT NULL,
  prot_element_id       integer DEFAULT NULL,
  geom                  geometry DEFAULT NULL,	
--
  schema_name              varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
  p_id                     integer                     := id                    ;
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
  p_ntw_feature_parent_id  integer  := ntw_feature_parent_id;
  p_ntw_feature_root_id    integer  := ntw_feature_root_id;
  p_class                  varchar  := class;
  p_function               varchar  := function;
  p_usage                  varchar  := usage;
  p_year_of_construction   date     := year_of_construction;
  p_status                 varchar  := status;
  p_location_quality       varchar  := location_quality;
  p_elevation_quality      varchar  := elevation_quality;
  p_conn_cityobject_id     integer  := conn_cityobject_id;
  p_prot_element_id        integer  := prot_element_id;
  p_geom                   geometry := geom;	
--
  p_schema_name varchar := schema_name;
  class_name varchar DEFAULT 'MeasurementDevice'::varchar;
  db_prefix varchar DEFAULT 'utn9';
  objectclass_id integer;
  inserted_id integer;
BEGIN
objectclass_id=citydb_pkg.objectclass_classname_to_id(class_name, db_prefix, p_schema_name);

inserted_id=citydb_pkg.insert_cityobject(
    id                    :=p_id,
    objectclass_id        :=objectclass_id,
    gmlid                 :=p_gmlid,
    gmlid_codespace       :=p_gmlid_codespace,
    name                  :=p_name,
    name_codespace        :=p_name_codespace,
    description           :=p_description,
    envelope              :=p_envelope,
    creation_date         :=p_creation_date,
    termination_date      :=p_termination_date,
    relative_to_terrain   :=p_relative_to_terrain,
    relative_to_water     :=p_relative_to_water,
    last_modification_date:=p_last_modification_date,
    updating_person       :=p_updating_person,
    reason_for_update     :=p_reason_for_update,
    lineage               :=p_lineage,
    schema_name           :=p_schema_name
);

PERFORM citydb_pkg.utn9_insert_network_feature(
    id                    :=inserted_id,
    objectclass_id        :=objectclass_id,  -- objectclass ID
    ntw_feature_parent_id :=p_ntw_feature_parent_id,
    ntw_feature_root_id  	:=p_ntw_feature_root_id  ,
    class                	:=p_class                ,
    function             	:=p_function             ,
    usage                	:=p_usage                ,
    year_of_construction 	:=p_year_of_construction ,
    status               	:=p_status               ,
    location_quality     	:=p_location_quality     ,
    elevation_quality    	:=p_elevation_quality    ,
    conn_cityobject_id      :=p_conn_cityobject_id   ,
    prot_element_id      	:=p_prot_element_id      ,
    geom                 	:=p_geom                 ,
--
    schema_name             :=p_schema_name  -- schema name
);

RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_insert_ntw_feat_device_meas(): %', SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function UTN9_INSERT_NTW_FEAT_DEVICE_STORAGE
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.utn9_insert_ntw_feat_device_storage(
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
  ntw_feature_parent_id integer DEFAULT NULL,
  ntw_feature_root_id   integer DEFAULT NULL,
  class                 varchar DEFAULT NULL,
  function              varchar DEFAULT NULL,
  usage                 varchar DEFAULT NULL,
  year_of_construction  date    DEFAULT NULL,
  status                varchar DEFAULT NULL,
  location_quality      varchar DEFAULT NULL,
  elevation_quality     varchar DEFAULT NULL,
  conn_cityobject_id    integer DEFAULT NULL,
  prot_element_id       integer DEFAULT NULL,
  geom                  geometry DEFAULT NULL,	
--
  schema_name              varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
  p_id                     integer                     := id                    ;
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
  p_ntw_feature_parent_id  integer  := ntw_feature_parent_id;
  p_ntw_feature_root_id    integer  := ntw_feature_root_id;
  p_class                  varchar  := class;
  p_function               varchar  := function;
  p_usage                  varchar  := usage;
  p_year_of_construction   date     := year_of_construction;
  p_status                 varchar  := status;
  p_location_quality       varchar  := location_quality;
  p_elevation_quality      varchar  := elevation_quality;
  p_conn_cityobject_id     integer  := conn_cityobject_id;
  p_prot_element_id        integer  := prot_element_id;
  p_geom                   geometry := geom;	
--
  p_schema_name varchar := schema_name;
  class_name varchar DEFAULT 'StorageDevice'::varchar;
  db_prefix varchar DEFAULT 'utn9';
  objectclass_id integer;
  inserted_id integer;
BEGIN
objectclass_id=citydb_pkg.objectclass_classname_to_id(class_name, db_prefix, p_schema_name);

inserted_id=citydb_pkg.insert_cityobject(
    id                    :=p_id,
    objectclass_id        :=objectclass_id,
    gmlid                 :=p_gmlid,
    gmlid_codespace       :=p_gmlid_codespace,
    name                  :=p_name,
    name_codespace        :=p_name_codespace,
    description           :=p_description,
    envelope              :=p_envelope,
    creation_date         :=p_creation_date,
    termination_date      :=p_termination_date,
    relative_to_terrain   :=p_relative_to_terrain,
    relative_to_water     :=p_relative_to_water,
    last_modification_date:=p_last_modification_date,
    updating_person       :=p_updating_person,
    reason_for_update     :=p_reason_for_update,
    lineage               :=p_lineage,
    schema_name           :=p_schema_name
);

PERFORM citydb_pkg.utn9_insert_network_feature(
    id                    :=inserted_id,
    objectclass_id        :=objectclass_id,  -- objectclass ID
    ntw_feature_parent_id :=p_ntw_feature_parent_id,
    ntw_feature_root_id  	:=p_ntw_feature_root_id  ,
    class                	:=p_class                ,
    function             	:=p_function             ,
    usage                	:=p_usage                ,
    year_of_construction 	:=p_year_of_construction ,
    status               	:=p_status               ,
    location_quality     	:=p_location_quality     ,
    elevation_quality    	:=p_elevation_quality    ,
    conn_cityobject_id      :=p_conn_cityobject_id   ,
    prot_element_id      	:=p_prot_element_id      ,
    geom                 	:=p_geom                 ,
--
    schema_name             :=p_schema_name  -- schema name
);

RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_insert_ntw_feat_device_storage(): %', SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function UTN9_INSERT_NTW_FEAT_DEVICE_TECH
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.utn9_insert_ntw_feat_device_tech(
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
  ntw_feature_parent_id integer DEFAULT NULL,
  ntw_feature_root_id   integer DEFAULT NULL,
  class                 varchar DEFAULT NULL,
  function              varchar DEFAULT NULL,
  usage                 varchar DEFAULT NULL,
  year_of_construction  date    DEFAULT NULL,
  status                varchar DEFAULT NULL,
  location_quality      varchar DEFAULT NULL,
  elevation_quality     varchar DEFAULT NULL,
  conn_cityobject_id    integer DEFAULT NULL,
  prot_element_id       integer DEFAULT NULL,
  geom                  geometry DEFAULT NULL,	
--
  schema_name              varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
  p_id                     integer                     := id                    ;
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
  p_ntw_feature_parent_id  integer  := ntw_feature_parent_id;
  p_ntw_feature_root_id    integer  := ntw_feature_root_id;
  p_class                  varchar  := class;
  p_function               varchar  := function;
  p_usage                  varchar  := usage;
  p_year_of_construction   date     := year_of_construction;
  p_status                 varchar  := status;
  p_location_quality       varchar  := location_quality;
  p_elevation_quality      varchar  := elevation_quality;
  p_conn_cityobject_id     integer  := conn_cityobject_id;
  p_prot_element_id        integer  := prot_element_id;
  p_geom                   geometry := geom;	
--
  p_schema_name varchar := schema_name;
  class_name varchar DEFAULT 'TechDevice'::varchar;
  db_prefix varchar DEFAULT 'utn9';
  objectclass_id integer;
  inserted_id integer;
BEGIN
objectclass_id=citydb_pkg.objectclass_classname_to_id(class_name, db_prefix, p_schema_name);

inserted_id=citydb_pkg.insert_cityobject(
    id                    :=p_id,
    objectclass_id        :=objectclass_id,
    gmlid                 :=p_gmlid,
    gmlid_codespace       :=p_gmlid_codespace,
    name                  :=p_name,
    name_codespace        :=p_name_codespace,
    description           :=p_description,
    envelope              :=p_envelope,
    creation_date         :=p_creation_date,
    termination_date      :=p_termination_date,
    relative_to_terrain   :=p_relative_to_terrain,
    relative_to_water     :=p_relative_to_water,
    last_modification_date:=p_last_modification_date,
    updating_person       :=p_updating_person,
    reason_for_update     :=p_reason_for_update,
    lineage               :=p_lineage,
    schema_name           :=p_schema_name
);

PERFORM citydb_pkg.utn9_insert_network_feature(
    id                    :=inserted_id,
    objectclass_id        :=objectclass_id,  -- objectclass ID
    ntw_feature_parent_id :=p_ntw_feature_parent_id,
    ntw_feature_root_id  	:=p_ntw_feature_root_id  ,
    class                	:=p_class                ,
    function             	:=p_function             ,
    usage                	:=p_usage                ,
    year_of_construction 	:=p_year_of_construction ,
    status               	:=p_status               ,
    location_quality     	:=p_location_quality     ,
    elevation_quality    	:=p_elevation_quality    ,
    conn_cityobject_id      :=p_conn_cityobject_id   ,
    prot_element_id      	:=p_prot_element_id      ,
    geom                 	:=p_geom                 ,
--
    schema_name             :=p_schema_name  -- schema name
);

RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_insert_ntw_feat_device_tech(): %', SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function UTN9_INSERT_NTW_FEAT_DISTRIB_ELEM_CABLE
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.utn9_insert_ntw_feat_distrib_elem_cable(
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
  ntw_feature_parent_id integer DEFAULT NULL,
  ntw_feature_root_id   integer DEFAULT NULL,
  class                 varchar DEFAULT NULL,
  function              varchar DEFAULT NULL,
  usage                 varchar DEFAULT NULL,
  year_of_construction  date    DEFAULT NULL,
  status                varchar DEFAULT NULL,
  location_quality      varchar DEFAULT NULL,
  elevation_quality     varchar DEFAULT NULL,
  conn_cityobject_id    integer DEFAULT NULL,
  prot_element_id       integer DEFAULT NULL,
  geom                  geometry DEFAULT NULL,	
--
  function_of_line   varchar DEFAULT NULL,
--is_gravity         numeric DEFAULT NULL,
  is_transmission    numeric DEFAULT NULL,
  is_communication   numeric DEFAULT NULL,
--ext_width          numeric DEFAULT NULL,
--ext_width_unit     varchar DEFAULT NULL,
--ext_height         numeric DEFAULT NULL,
--ext_height_unit    varchar DEFAULT NULL,
--ext_diameter       numeric DEFAULT NULL,
--ext_diameter_unit  varchar DEFAULT NULL,
--int_width          numeric DEFAULT NULL,
--int_width_unit     varchar DEFAULT NULL,
--int_height         numeric DEFAULT NULL,
--int_height_unit    varchar DEFAULT NULL,
--int_diameter       numeric DEFAULT NULL,
--int_diameter_unit  varchar DEFAULT NULL,
  cross_section      numeric DEFAULT NULL,
  cross_section_unit varchar DEFAULT NULL,
--slope_range_from   numeric DEFAULT NULL,
--slope_range_to     numeric DEFAULT NULL,
--slope_range_unit   varchar DEFAULT NULL,
--profile_name       varchar DEFAULT NULL,
--
  schema_name              varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
  p_id                     integer                     := id                    ;
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
  p_ntw_feature_parent_id  integer  := ntw_feature_parent_id;
  p_ntw_feature_root_id    integer  := ntw_feature_root_id;
  p_class                  varchar  := class;
  p_function               varchar  := function;
  p_usage                  varchar  := usage;
  p_year_of_construction   date     := year_of_construction;
  p_status                 varchar  := status;
  p_location_quality       varchar  := location_quality;
  p_elevation_quality      varchar  := elevation_quality;
  p_conn_cityobject_id     integer  := conn_cityobject_id;
  p_prot_element_id        integer  := prot_element_id;
  p_geom                   geometry := geom;	
--
  p_function_of_line   varchar := function_of_line  ;
--p_is_gravity         numeric := is_gravity        ;
  p_is_transmission    numeric := is_transmission   ;
  p_is_communication   numeric := is_communication  ;
--p_ext_width          numeric := ext_width         ;
--p_ext_width_unit     varchar := ext_width_unit    ;
--p_ext_height         numeric := ext_height        ;
--p_ext_height_unit    varchar := ext_height_unit   ;
--p_ext_diameter       numeric := ext_diameter      ;
--p_ext_diameter_unit  varchar := ext_diameter_unit ;
--p_int_width          numeric := int_width         ;
--p_int_width_unit     varchar := int_width_unit    ;
--p_int_height         numeric := int_height        ;
--p_int_height_unit    varchar := int_height_unit   ;
--p_int_diameter       numeric := int_diameter      ;
--p_int_diameter_unit  varchar := int_diameter_unit ;
  p_cross_section      numeric := cross_section     ;
  p_cross_section_unit varchar := cross_section_unit;
--p_slope_range_from   numeric := slope_range_from  ;
--p_slope_range_to     numeric := slope_range_to    ;
--p_slope_range_unit   varchar := slope_range_unit  ;
--p_profile_name       varchar := profile_name      ;
--
  p_schema_name varchar := schema_name;
  class_name varchar DEFAULT 'Cable'::varchar;
  db_prefix varchar DEFAULT 'utn9';
  objectclass_id integer;
  inserted_id integer;
BEGIN
objectclass_id=citydb_pkg.objectclass_classname_to_id(class_name, db_prefix, p_schema_name);

inserted_id=citydb_pkg.insert_cityobject(
    id                    :=p_id,
    objectclass_id        :=objectclass_id,
    gmlid                 :=p_gmlid,
    gmlid_codespace       :=p_gmlid_codespace,
    name                  :=p_name,
    name_codespace        :=p_name_codespace,
    description           :=p_description,
    envelope              :=p_envelope,
    creation_date         :=p_creation_date,
    termination_date      :=p_termination_date,
    relative_to_terrain   :=p_relative_to_terrain,
    relative_to_water     :=p_relative_to_water,
    last_modification_date:=p_last_modification_date,
    updating_person       :=p_updating_person,
    reason_for_update     :=p_reason_for_update,
    lineage               :=p_lineage,
    schema_name           :=p_schema_name
);

PERFORM citydb_pkg.utn9_insert_network_feature(
    id                    :=inserted_id,
    objectclass_id        :=objectclass_id,  -- objectclass ID
    ntw_feature_parent_id :=p_ntw_feature_parent_id,
    ntw_feature_root_id  	:=p_ntw_feature_root_id  ,
    class                	:=p_class                ,
    function             	:=p_function             ,
    usage                	:=p_usage                ,
    year_of_construction 	:=p_year_of_construction ,
    status               	:=p_status               ,
    location_quality     	:=p_location_quality     ,
    elevation_quality    	:=p_elevation_quality    ,
    conn_cityobject_id      :=p_conn_cityobject_id   ,
    prot_element_id      	:=p_prot_element_id      ,
    geom                 	:=p_geom                 ,
--
    schema_name             :=p_schema_name  -- schema name
);

PERFORM citydb_pkg.utn9_insert_distrib_element(
    id                    :=inserted_id,
    objectclass_id        :=objectclass_id,  -- objectclass ID
    function_of_line      :=p_function_of_line  ,
--  is_gravity            :=p_is_gravity        ,
  	is_transmission       :=p_is_transmission   ,
  	is_communication      :=p_is_communication  ,
--	ext_width             :=p_ext_width         ,
--	ext_width_unit        :=p_ext_width_unit    ,
--	ext_height            :=p_ext_height        ,
--	ext_height_unit       :=p_ext_height_unit   ,
--	ext_diameter          :=p_ext_diameter      ,
--	ext_diameter_unit     :=p_ext_diameter_unit ,
--	int_width             :=p_int_width         ,
--	int_width_unit        :=p_int_width_unit    ,
--	int_height            :=p_int_height        ,
--	int_height_unit       :=p_int_height_unit   ,
--	int_diameter          :=p_int_diameter      ,
--	int_diameter_unit     :=p_int_diameter_unit ,
  	cross_section         :=p_cross_section     ,
  	cross_section_unit    :=p_cross_section_unit,
--	slope_range_from      :=p_slope_range_from  ,
--	slope_range_to        :=p_slope_range_to    ,
--	slope_range_unit      :=p_slope_range_unit  ,
--	profile_name          :=p_profile_name      ,	
--
    schema_name             :=p_schema_name  -- schema name
);

RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_insert_ntw_feat_distrib_elem_cable(): %', SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function UTN9_INSERT_NTW_FEAT_DISTRIB_ELEM_CANAL
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.utn9_insert_ntw_feat_distrib_elem_canal(
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
  ntw_feature_parent_id integer DEFAULT NULL,
  ntw_feature_root_id   integer DEFAULT NULL,
  class                 varchar DEFAULT NULL,
  function              varchar DEFAULT NULL,
  usage                 varchar DEFAULT NULL,
  year_of_construction  date    DEFAULT NULL,
  status                varchar DEFAULT NULL,
  location_quality      varchar DEFAULT NULL,
  elevation_quality     varchar DEFAULT NULL,
  conn_cityobject_id    integer DEFAULT NULL,
  prot_element_id       integer DEFAULT NULL,
  geom                  geometry DEFAULT NULL,	
--
  function_of_line   varchar DEFAULT NULL,
  is_gravity         numeric DEFAULT NULL,
--is_transmission    numeric DEFAULT NULL,
--is_communication   numeric DEFAULT NULL,
  ext_width          numeric DEFAULT NULL,
  ext_width_unit     varchar DEFAULT NULL,
  ext_height         numeric DEFAULT NULL,
  ext_height_unit    varchar DEFAULT NULL,
  ext_diameter       numeric DEFAULT NULL,
  ext_diameter_unit  varchar DEFAULT NULL,
--int_width          numeric DEFAULT NULL,
--int_width_unit     varchar DEFAULT NULL,
--int_height         numeric DEFAULT NULL,
--int_height_unit    varchar DEFAULT NULL,
--int_diameter       numeric DEFAULT NULL,
--int_diameter_unit  varchar DEFAULT NULL,
--cross_section      numeric DEFAULT NULL,
--cross_section_unit varchar DEFAULT NULL,
  slope_range_from   numeric DEFAULT NULL,
  slope_range_to     numeric DEFAULT NULL,
  slope_range_unit   varchar DEFAULT NULL,
  profile_name       varchar DEFAULT NULL,
--
  schema_name              varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
  p_id                     integer                     := id                    ;
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
  p_ntw_feature_parent_id  integer  := ntw_feature_parent_id;
  p_ntw_feature_root_id    integer  := ntw_feature_root_id;
  p_class                  varchar  := class;
  p_function               varchar  := function;
  p_usage                  varchar  := usage;
  p_year_of_construction   date     := year_of_construction;
  p_status                 varchar  := status;
  p_location_quality       varchar  := location_quality;
  p_elevation_quality      varchar  := elevation_quality;
  p_conn_cityobject_id     integer  := conn_cityobject_id;
  p_prot_element_id        integer  := prot_element_id;
  p_geom                   geometry := geom;	
--
  p_function_of_line   varchar := function_of_line  ;
  p_is_gravity         numeric := is_gravity        ;
--p_is_transmission    numeric := is_transmission   ;
--p_is_communication   numeric := is_communication  ;
  p_ext_width          numeric := ext_width         ;
  p_ext_width_unit     varchar := ext_width_unit    ;
  p_ext_height         numeric := ext_height        ;
  p_ext_height_unit    varchar := ext_height_unit   ;
  p_ext_diameter       numeric := ext_diameter      ;
  p_ext_diameter_unit  varchar := ext_diameter_unit ;
--p_int_width          numeric := int_width         ;
--p_int_width_unit     varchar := int_width_unit    ;
--p_int_height         numeric := int_height        ;
--p_int_height_unit    varchar := int_height_unit   ;
--p_int_diameter       numeric := int_diameter      ;
--p_int_diameter_unit  varchar := int_diameter_unit ;
--p_cross_section      numeric := cross_section     ;
--p_cross_section_unit varchar := cross_section_unit;
  p_slope_range_from   numeric := slope_range_from  ;
  p_slope_range_to     numeric := slope_range_to    ;
  p_slope_range_unit   varchar := slope_range_unit  ;
  p_profile_name       varchar := profile_name      ;
--
  p_schema_name varchar := schema_name;
  class_name varchar DEFAULT 'Canal'::varchar;
  db_prefix varchar DEFAULT 'utn9';
  objectclass_id integer;
  inserted_id integer;
BEGIN
objectclass_id=citydb_pkg.objectclass_classname_to_id(class_name, db_prefix, p_schema_name);

inserted_id=citydb_pkg.insert_cityobject(
    id                    :=p_id,
    objectclass_id        :=objectclass_id,
    gmlid                 :=p_gmlid,
    gmlid_codespace       :=p_gmlid_codespace,
    name                  :=p_name,
    name_codespace        :=p_name_codespace,
    description           :=p_description,
    envelope              :=p_envelope,
    creation_date         :=p_creation_date,
    termination_date      :=p_termination_date,
    relative_to_terrain   :=p_relative_to_terrain,
    relative_to_water     :=p_relative_to_water,
    last_modification_date:=p_last_modification_date,
    updating_person       :=p_updating_person,
    reason_for_update     :=p_reason_for_update,
    lineage               :=p_lineage,
    schema_name           :=p_schema_name
);

PERFORM citydb_pkg.utn9_insert_network_feature(
    id                    :=inserted_id,
    objectclass_id        :=objectclass_id,  -- objectclass ID
    ntw_feature_parent_id :=p_ntw_feature_parent_id,
    ntw_feature_root_id  	:=p_ntw_feature_root_id  ,
    class                	:=p_class                ,
    function             	:=p_function             ,
    usage                	:=p_usage                ,
    year_of_construction 	:=p_year_of_construction ,
    status               	:=p_status               ,
    location_quality     	:=p_location_quality     ,
    elevation_quality    	:=p_elevation_quality    ,
    conn_cityobject_id      :=p_conn_cityobject_id   ,
    prot_element_id      	:=p_prot_element_id      ,
    geom                 	:=p_geom                 ,
--
    schema_name             :=p_schema_name  -- schema name
);

PERFORM citydb_pkg.utn9_insert_distrib_element(
    id                    :=inserted_id,
    objectclass_id        :=objectclass_id,  -- objectclass ID
    function_of_line      :=p_function_of_line  ,
    is_gravity            :=p_is_gravity        ,
--	is_transmission       :=p_is_transmission   ,
--	is_communication      :=p_is_communication  ,
  	ext_width             :=p_ext_width         ,
  	ext_width_unit        :=p_ext_width_unit    ,
  	ext_height            :=p_ext_height        ,
  	ext_height_unit       :=p_ext_height_unit   ,
  	ext_diameter          :=p_ext_diameter      ,
  	ext_diameter_unit     :=p_ext_diameter_unit ,
--	int_width             :=p_int_width         ,
--	int_width_unit        :=p_int_width_unit    ,
--	int_height            :=p_int_height        ,
--	int_height_unit       :=p_int_height_unit   ,
--	int_diameter          :=p_int_diameter      ,
--	int_diameter_unit     :=p_int_diameter_unit ,
--	cross_section         :=p_cross_section     ,
--	cross_section_unit    :=p_cross_section_unit,
  	slope_range_from      :=p_slope_range_from  ,
  	slope_range_to        :=p_slope_range_to    ,
  	slope_range_unit      :=p_slope_range_unit  ,
  	profile_name          :=p_profile_name      ,	
--
    schema_name             :=p_schema_name  -- schema name
);

RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_insert_ntw_feat_distrib_elem_canal(): %', SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function UTN9_INSERT_NTW_FEAT_DISTRIB_ELEM_CANAL_SEMI_OPEN
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.utn9_insert_ntw_feat_distrib_elem_canal_semi_open(
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
  ntw_feature_parent_id integer DEFAULT NULL,
  ntw_feature_root_id   integer DEFAULT NULL,
  class                 varchar DEFAULT NULL,
  function              varchar DEFAULT NULL,
  usage                 varchar DEFAULT NULL,
  year_of_construction  date    DEFAULT NULL,
  status                varchar DEFAULT NULL,
  location_quality      varchar DEFAULT NULL,
  elevation_quality     varchar DEFAULT NULL,
  conn_cityobject_id    integer DEFAULT NULL,
  prot_element_id       integer DEFAULT NULL,
  geom                  geometry DEFAULT NULL,	
--
  function_of_line   varchar DEFAULT NULL,
  is_gravity         numeric DEFAULT NULL,
--  is_transmission    numeric DEFAULT NULL,
--  is_communication   numeric DEFAULT NULL,
  ext_width          numeric DEFAULT NULL,
  ext_width_unit     varchar DEFAULT NULL,
  ext_height         numeric DEFAULT NULL,
  ext_height_unit    varchar DEFAULT NULL,
  ext_diameter       numeric DEFAULT NULL,
  ext_diameter_unit  varchar DEFAULT NULL,
--  int_width          numeric DEFAULT NULL,
--  int_width_unit     varchar DEFAULT NULL,
--  int_height         numeric DEFAULT NULL,
--  int_height_unit    varchar DEFAULT NULL,
--  int_diameter       numeric DEFAULT NULL,
--  int_diameter_unit  varchar DEFAULT NULL,
--  cross_section      numeric DEFAULT NULL,
--  cross_section_unit varchar DEFAULT NULL,
  slope_range_from   numeric DEFAULT NULL,
  slope_range_to     numeric DEFAULT NULL,
  slope_range_unit   varchar DEFAULT NULL,
  profile_name       varchar DEFAULT NULL,
--
  schema_name              varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
  p_id                     integer                     := id                    ;
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
  p_ntw_feature_parent_id  integer  := ntw_feature_parent_id;
  p_ntw_feature_root_id    integer  := ntw_feature_root_id;
  p_class                  varchar  := class;
  p_function               varchar  := function;
  p_usage                  varchar  := usage;
  p_year_of_construction   date     := year_of_construction;
  p_status                 varchar  := status;
  p_location_quality       varchar  := location_quality;
  p_elevation_quality      varchar  := elevation_quality;
  p_conn_cityobject_id     integer  := conn_cityobject_id;
  p_prot_element_id        integer  := prot_element_id;
  p_geom                   geometry := geom;	
--
  p_function_of_line   varchar := function_of_line  ;
  p_is_gravity         numeric := is_gravity        ;
--p_is_transmission    numeric := is_transmission   ;
--p_is_communication   numeric := is_communication  ;
  p_ext_width          numeric := ext_width         ;
  p_ext_width_unit     varchar := ext_width_unit    ;
  p_ext_height         numeric := ext_height        ;
  p_ext_height_unit    varchar := ext_height_unit   ;
  p_ext_diameter       numeric := ext_diameter      ;
  p_ext_diameter_unit  varchar := ext_diameter_unit ;
--p_int_width          numeric := int_width         ;
--p_int_width_unit     varchar := int_width_unit    ;
--p_int_height         numeric := int_height        ;
--p_int_height_unit    varchar := int_height_unit   ;
--p_int_diameter       numeric := int_diameter      ;
--p_int_diameter_unit  varchar := int_diameter_unit ;
--p_cross_section      numeric := cross_section     ;
--p_cross_section_unit varchar := cross_section_unit;
  p_slope_range_from   numeric := slope_range_from  ;
  p_slope_range_to     numeric := slope_range_to    ;
  p_slope_range_unit   varchar := slope_range_unit  ;
  p_profile_name       varchar := profile_name      ;
--
  p_schema_name varchar := schema_name;
  class_name varchar DEFAULT 'SemiOpenCanal'::varchar;
  db_prefix varchar DEFAULT 'utn9';
  objectclass_id integer;
  inserted_id integer;
BEGIN
objectclass_id=citydb_pkg.objectclass_classname_to_id(class_name, db_prefix, p_schema_name);

inserted_id=citydb_pkg.insert_cityobject(
    id                    :=p_id,
    objectclass_id        :=objectclass_id,
    gmlid                 :=p_gmlid,
    gmlid_codespace       :=p_gmlid_codespace,
    name                  :=p_name,
    name_codespace        :=p_name_codespace,
    description           :=p_description,
    envelope              :=p_envelope,
    creation_date         :=p_creation_date,
    termination_date      :=p_termination_date,
    relative_to_terrain   :=p_relative_to_terrain,
    relative_to_water     :=p_relative_to_water,
    last_modification_date:=p_last_modification_date,
    updating_person       :=p_updating_person,
    reason_for_update     :=p_reason_for_update,
    lineage               :=p_lineage,
    schema_name           :=p_schema_name
);

PERFORM citydb_pkg.utn9_insert_network_feature(
    id                    :=inserted_id,
    objectclass_id        :=objectclass_id,  -- objectclass ID
    ntw_feature_parent_id :=p_ntw_feature_parent_id,
    ntw_feature_root_id  	:=p_ntw_feature_root_id  ,
    class                	:=p_class                ,
    function             	:=p_function             ,
    usage                	:=p_usage                ,
    year_of_construction 	:=p_year_of_construction ,
    status               	:=p_status               ,
    location_quality     	:=p_location_quality     ,
    elevation_quality    	:=p_elevation_quality    ,
    conn_cityobject_id      :=p_conn_cityobject_id   ,
    prot_element_id      	:=p_prot_element_id      ,
    geom                 	:=p_geom                 ,
--
    schema_name             :=p_schema_name  -- schema name
);

PERFORM citydb_pkg.utn9_insert_distrib_element(
    id                    :=inserted_id,
    objectclass_id        :=objectclass_id,  -- objectclass ID
    function_of_line      :=p_function_of_line  ,
    is_gravity            :=p_is_gravity        ,
--	is_transmission       :=p_is_transmission   ,
--	is_communication      :=p_is_communication  ,
  	ext_width             :=p_ext_width         ,
  	ext_width_unit        :=p_ext_width_unit    ,
  	ext_height            :=p_ext_height        ,
  	ext_height_unit       :=p_ext_height_unit   ,
  	ext_diameter          :=p_ext_diameter      ,
  	ext_diameter_unit     :=p_ext_diameter_unit ,
--	int_width             :=p_int_width         ,
--	int_width_unit        :=p_int_width_unit    ,
--	int_height            :=p_int_height        ,
--	int_height_unit       :=p_int_height_unit   ,
--	int_diameter          :=p_int_diameter      ,
--	int_diameter_unit     :=p_int_diameter_unit ,
--	cross_section         :=p_cross_section     ,
--	cross_section_unit    :=p_cross_section_unit,
  	slope_range_from      :=p_slope_range_from  ,
  	slope_range_to        :=p_slope_range_to    ,
  	slope_range_unit      :=p_slope_range_unit  ,
  	profile_name          :=p_profile_name      ,	
--
    schema_name             :=p_schema_name  -- schema name
);

RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_insert_ntw_feat_distrib_elem_canal_semi_open(): %', SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function UTN9_INSERT_NTW_FEAT_DISTRIB_ELEM_CANAL_CLOSED
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.utn9_insert_ntw_feat_distrib_elem_canal_closed(
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
  ntw_feature_parent_id integer DEFAULT NULL,
  ntw_feature_root_id   integer DEFAULT NULL,
  class                 varchar DEFAULT NULL,
  function              varchar DEFAULT NULL,
  usage                 varchar DEFAULT NULL,
  year_of_construction  date    DEFAULT NULL,
  status                varchar DEFAULT NULL,
  location_quality      varchar DEFAULT NULL,
  elevation_quality     varchar DEFAULT NULL,
  conn_cityobject_id    integer DEFAULT NULL,
  prot_element_id       integer DEFAULT NULL,
  geom                  geometry DEFAULT NULL,	
--
  function_of_line   varchar DEFAULT NULL,
  is_gravity         numeric DEFAULT NULL,
--  is_transmission    numeric DEFAULT NULL,
--  is_communication   numeric DEFAULT NULL,
  ext_width          numeric DEFAULT NULL,
  ext_width_unit     varchar DEFAULT NULL,
  ext_height         numeric DEFAULT NULL,
  ext_height_unit    varchar DEFAULT NULL,
  ext_diameter       numeric DEFAULT NULL,
  ext_diameter_unit  varchar DEFAULT NULL,
--  int_width          numeric DEFAULT NULL,
--  int_width_unit     varchar DEFAULT NULL,
--  int_height         numeric DEFAULT NULL,
--  int_height_unit    varchar DEFAULT NULL,
--  int_diameter       numeric DEFAULT NULL,
--  int_diameter_unit  varchar DEFAULT NULL,
--  cross_section      numeric DEFAULT NULL,
--  cross_section_unit varchar DEFAULT NULL,
  slope_range_from   numeric DEFAULT NULL,
  slope_range_to     numeric DEFAULT NULL,
  slope_range_unit   varchar DEFAULT NULL,
  profile_name       varchar DEFAULT NULL,
--
  schema_name              varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
  p_id                     integer                     := id                    ;
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
  p_ntw_feature_parent_id  integer  := ntw_feature_parent_id;
  p_ntw_feature_root_id    integer  := ntw_feature_root_id;
  p_class                  varchar  := class;
  p_function               varchar  := function;
  p_usage                  varchar  := usage;
  p_year_of_construction   date     := year_of_construction;
  p_status                 varchar  := status;
  p_location_quality       varchar  := location_quality;
  p_elevation_quality      varchar  := elevation_quality;
  p_conn_cityobject_id     integer  := conn_cityobject_id;
  p_prot_element_id        integer  := prot_element_id;
  p_geom                   geometry := geom;	
--
  p_function_of_line   varchar := function_of_line  ;
  p_is_gravity         numeric := is_gravity        ;
--p_is_transmission    numeric := is_transmission   ;
--p_is_communication   numeric := is_communication  ;
  p_ext_width          numeric := ext_width         ;
  p_ext_width_unit     varchar := ext_width_unit    ;
  p_ext_height         numeric := ext_height        ;
  p_ext_height_unit    varchar := ext_height_unit   ;
  p_ext_diameter       numeric := ext_diameter      ;
  p_ext_diameter_unit  varchar := ext_diameter_unit ;
--p_int_width          numeric := int_width         ;
--p_int_width_unit     varchar := int_width_unit    ;
--p_int_height         numeric := int_height        ;
--p_int_height_unit    varchar := int_height_unit   ;
--p_int_diameter       numeric := int_diameter      ;
--p_int_diameter_unit  varchar := int_diameter_unit ;
--p_cross_section      numeric := cross_section     ;
--p_cross_section_unit varchar := cross_section_unit;
  p_slope_range_from   numeric := slope_range_from  ;
  p_slope_range_to     numeric := slope_range_to    ;
  p_slope_range_unit   varchar := slope_range_unit  ;
  p_profile_name       varchar := profile_name      ;
--
  p_schema_name varchar := schema_name;
  class_name varchar DEFAULT 'ClosedCanal'::varchar;
  db_prefix varchar DEFAULT 'utn9';
  objectclass_id integer;
  inserted_id integer;
BEGIN
objectclass_id=citydb_pkg.objectclass_classname_to_id(class_name, db_prefix, p_schema_name);

inserted_id=citydb_pkg.insert_cityobject(
    id                    :=p_id,
    objectclass_id        :=objectclass_id,
    gmlid                 :=p_gmlid,
    gmlid_codespace       :=p_gmlid_codespace,
    name                  :=p_name,
    name_codespace        :=p_name_codespace,
    description           :=p_description,
    envelope              :=p_envelope,
    creation_date         :=p_creation_date,
    termination_date      :=p_termination_date,
    relative_to_terrain   :=p_relative_to_terrain,
    relative_to_water     :=p_relative_to_water,
    last_modification_date:=p_last_modification_date,
    updating_person       :=p_updating_person,
    reason_for_update     :=p_reason_for_update,
    lineage               :=p_lineage,
    schema_name           :=p_schema_name
);

PERFORM citydb_pkg.utn9_insert_network_feature(
    id                    :=inserted_id,
    objectclass_id        :=objectclass_id,  -- objectclass ID
    ntw_feature_parent_id :=p_ntw_feature_parent_id,
    ntw_feature_root_id  	:=p_ntw_feature_root_id  ,
    class                	:=p_class                ,
    function             	:=p_function             ,
    usage                	:=p_usage                ,
    year_of_construction 	:=p_year_of_construction ,
    status               	:=p_status               ,
    location_quality     	:=p_location_quality     ,
    elevation_quality    	:=p_elevation_quality    ,
    conn_cityobject_id      :=p_conn_cityobject_id   ,
    prot_element_id      	:=p_prot_element_id      ,
    geom                 	:=p_geom                 ,
--
    schema_name             :=p_schema_name  -- schema name
);

PERFORM citydb_pkg.utn9_insert_distrib_element(
    id                    :=inserted_id,
    objectclass_id        :=objectclass_id,  -- objectclass ID
    function_of_line      :=p_function_of_line  ,
    is_gravity            :=p_is_gravity        ,
--	is_transmission       :=p_is_transmission   ,
--	is_communication      :=p_is_communication  ,
  	ext_width             :=p_ext_width         ,
  	ext_width_unit        :=p_ext_width_unit    ,
  	ext_height            :=p_ext_height        ,
  	ext_height_unit       :=p_ext_height_unit   ,
  	ext_diameter          :=p_ext_diameter      ,
  	ext_diameter_unit     :=p_ext_diameter_unit ,
--	int_width             :=p_int_width         ,
--	int_width_unit        :=p_int_width_unit    ,
--	int_height            :=p_int_height        ,
--	int_height_unit       :=p_int_height_unit   ,
--	int_diameter          :=p_int_diameter      ,
--	int_diameter_unit     :=p_int_diameter_unit ,
--	cross_section         :=p_cross_section     ,
--	cross_section_unit    :=p_cross_section_unit,
  	slope_range_from      :=p_slope_range_from  ,
  	slope_range_to        :=p_slope_range_to    ,
  	slope_range_unit      :=p_slope_range_unit  ,
  	profile_name          :=p_profile_name      ,	
--
    schema_name             :=p_schema_name  -- schema name
);

RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_insert_ntw_feat_distrib_elem_canal_closed(): %', SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function UTN9_INSERT_NTW_FEAT_DISTRIB_ELEM_PIPE_OTHER_SHAPE
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.utn9_insert_ntw_feat_distrib_elem_pipe_other_shape(
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
  ntw_feature_parent_id integer DEFAULT NULL,
  ntw_feature_root_id   integer DEFAULT NULL,
  class                 varchar DEFAULT NULL,
  function              varchar DEFAULT NULL,
  usage                 varchar DEFAULT NULL,
  year_of_construction  date    DEFAULT NULL,
  status                varchar DEFAULT NULL,
  location_quality      varchar DEFAULT NULL,
  elevation_quality     varchar DEFAULT NULL,
  conn_cityobject_id    integer DEFAULT NULL,
  prot_element_id       integer DEFAULT NULL,
  geom                  geometry DEFAULT NULL,	
--
  function_of_line   varchar DEFAULT NULL,
  is_gravity         numeric DEFAULT NULL,
--is_transmission    numeric DEFAULT NULL,
--is_communication   numeric DEFAULT NULL,
  ext_width          numeric DEFAULT NULL,
  ext_width_unit     varchar DEFAULT NULL,
  ext_height         numeric DEFAULT NULL,
  ext_height_unit    varchar DEFAULT NULL,
  ext_diameter       numeric DEFAULT NULL,
  ext_diameter_unit  varchar DEFAULT NULL,
--int_width          numeric DEFAULT NULL,
--int_width_unit     varchar DEFAULT NULL,
--int_height         numeric DEFAULT NULL,
--int_height_unit    varchar DEFAULT NULL,
--int_diameter       numeric DEFAULT NULL,
--int_diameter_unit  varchar DEFAULT NULL,
--cross_section      numeric DEFAULT NULL,
--cross_section_unit varchar DEFAULT NULL,
--slope_range_from   numeric DEFAULT NULL,
--slope_range_to     numeric DEFAULT NULL,
--slope_range_unit   varchar DEFAULT NULL,
--profile_name       varchar DEFAULT NULL,
--
  schema_name              varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
  p_id                     integer                     := id                    ;
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
  p_ntw_feature_parent_id  integer  := ntw_feature_parent_id;
  p_ntw_feature_root_id    integer  := ntw_feature_root_id;
  p_class                  varchar  := class;
  p_function               varchar  := function;
  p_usage                  varchar  := usage;
  p_year_of_construction   date     := year_of_construction;
  p_status                 varchar  := status;
  p_location_quality       varchar  := location_quality;
  p_elevation_quality      varchar  := elevation_quality;
  p_conn_cityobject_id     integer  := conn_cityobject_id;
  p_prot_element_id        integer  := prot_element_id;
  p_geom                   geometry := geom;	
--
  p_function_of_line   varchar := function_of_line  ;
  p_is_gravity         numeric := is_gravity        ;
--  p_is_transmission    numeric := is_transmission   ;
--  p_is_communication   numeric := is_communication  ;
    p_ext_width          numeric := ext_width         ;
    p_ext_width_unit     varchar := ext_width_unit    ;
    p_ext_height         numeric := ext_height        ;
    p_ext_height_unit    varchar := ext_height_unit   ;
    p_ext_diameter       numeric := ext_diameter      ;
    p_ext_diameter_unit  varchar := ext_diameter_unit ;
--  p_int_width          numeric := int_width         ;
--  p_int_width_unit     varchar := int_width_unit    ;
--  p_int_height         numeric := int_height        ;
--  p_int_height_unit    varchar := int_height_unit   ;
--  p_int_diameter       numeric := int_diameter      ;
--  p_int_diameter_unit  varchar := int_diameter_unit ;
--  p_cross_section      numeric := cross_section     ;
--  p_cross_section_unit varchar := cross_section_unit;
--  p_slope_range_from   numeric := slope_range_from  ;
--  p_slope_range_to     numeric := slope_range_to    ;
--  p_slope_range_unit   varchar := slope_range_unit  ;
--  p_profile_name       varchar := profile_name      ;
--
  p_schema_name varchar := schema_name;
  class_name varchar DEFAULT 'OtherShapePipe'::varchar;
  db_prefix varchar DEFAULT 'utn9';
  objectclass_id integer;
  inserted_id integer;
BEGIN
objectclass_id=citydb_pkg.objectclass_classname_to_id(class_name, db_prefix, p_schema_name);

inserted_id=citydb_pkg.insert_cityobject(
    id                    :=p_id,
    objectclass_id        :=objectclass_id,
    gmlid                 :=p_gmlid,
    gmlid_codespace       :=p_gmlid_codespace,
    name                  :=p_name,
    name_codespace        :=p_name_codespace,
    description           :=p_description,
    envelope              :=p_envelope,
    creation_date         :=p_creation_date,
    termination_date      :=p_termination_date,
    relative_to_terrain   :=p_relative_to_terrain,
    relative_to_water     :=p_relative_to_water,
    last_modification_date:=p_last_modification_date,
    updating_person       :=p_updating_person,
    reason_for_update     :=p_reason_for_update,
    lineage               :=p_lineage,
    schema_name           :=p_schema_name
);

PERFORM citydb_pkg.utn9_insert_network_feature(
    id                    :=inserted_id,
    objectclass_id        :=objectclass_id,  -- objectclass ID
    ntw_feature_parent_id :=p_ntw_feature_parent_id,
    ntw_feature_root_id  	:=p_ntw_feature_root_id  ,
    class                	:=p_class                ,
    function             	:=p_function             ,
    usage                	:=p_usage                ,
    year_of_construction 	:=p_year_of_construction ,
    status               	:=p_status               ,
    location_quality     	:=p_location_quality     ,
    elevation_quality    	:=p_elevation_quality    ,
    conn_cityobject_id      :=p_conn_cityobject_id   ,
    prot_element_id      	:=p_prot_element_id      ,
    geom                 	:=p_geom                 ,
--
    schema_name             :=p_schema_name  -- schema name
);

PERFORM citydb_pkg.utn9_insert_distrib_element(
    id                    :=inserted_id,
    objectclass_id        :=objectclass_id,  -- objectclass ID
    function_of_line      :=p_function_of_line  ,
    is_gravity            :=p_is_gravity        ,
--		is_transmission       :=p_is_transmission   ,
--		is_communication      :=p_is_communication  ,
  		ext_width             :=p_ext_width         ,
  		ext_width_unit        :=p_ext_width_unit    ,
  		ext_height            :=p_ext_height        ,
  		ext_height_unit       :=p_ext_height_unit   ,
  		ext_diameter          :=p_ext_diameter      ,
  		ext_diameter_unit     :=p_ext_diameter_unit ,
--		int_width             :=p_int_width         ,
--		int_width_unit        :=p_int_width_unit    ,
--		int_height            :=p_int_height        ,
--		int_height_unit       :=p_int_height_unit   ,
--		int_diameter          :=p_int_diameter      ,
--		int_diameter_unit     :=p_int_diameter_unit ,
--		cross_section         :=p_cross_section     ,
--		cross_section_unit    :=p_cross_section_unit,
--		slope_range_from      :=p_slope_range_from  ,
--		slope_range_to        :=p_slope_range_to    ,
--		slope_range_unit      :=p_slope_range_unit  ,
--		profile_name          :=p_profile_name      ,	
--
    schema_name             :=p_schema_name  -- schema name
);

RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_insert_ntw_feat_distrib_elem_pipe_other_shape(): %', SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function UTN9_INSERT_NTW_FEAT_DISTRIB_ELEM_PIPE_ROUND
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.utn9_insert_ntw_feat_distrib_elem_pipe_round(
  id                     integer        DEFAULT NULL,
  gmlid                  varchar(256)   DEFAULT NULL,
  gmlid_codespace        varchar(1000)  DEFAULT NULL,
  name                   varchar(1000)  DEFAULT NULL,
  name_codespace         varchar(4000)  DEFAULT NULL,
  description            varchar(4000)  DEFAULT NULL,
  envelope               geometry       DEFAULT NULL,
  creation_date          timestamptz(0) DEFAULT NULL,
  termination_date       timestamptz(0) DEFAULT NULL,
  relative_to_terrain    varchar(256)   DEFAULT NULL,
  relative_to_water      varchar(256)   DEFAULT NULL,
  last_modification_date timestamptz    DEFAULT NULL,
  updating_person        varchar(256)   DEFAULT NULL,
  reason_for_update      varchar(4000)  DEFAULT NULL,
  lineage                varchar(256)   DEFAULT NULL,
--	
  ntw_feature_parent_id integer  DEFAULT NULL,
  ntw_feature_root_id   integer  DEFAULT NULL,
  class                 varchar  DEFAULT NULL,
  function              varchar  DEFAULT NULL,
  usage                 varchar  DEFAULT NULL,
  year_of_construction  date     DEFAULT NULL,
  status                varchar  DEFAULT NULL,
  location_quality      varchar  DEFAULT NULL,
  elevation_quality     varchar  DEFAULT NULL,
  conn_cityobject_id    integer  DEFAULT NULL,
  prot_element_id       integer  DEFAULT NULL,
  geom                  geometry DEFAULT NULL,	
--
  function_of_line   varchar DEFAULT NULL,
  is_gravity         numeric DEFAULT NULL,
--is_transmission    numeric DEFAULT NULL,
--is_communication   numeric DEFAULT NULL,
  ext_width          numeric DEFAULT NULL,
  ext_width_unit     varchar DEFAULT NULL,
  ext_height         numeric DEFAULT NULL,
  ext_height_unit    varchar DEFAULT NULL,
  ext_diameter       numeric DEFAULT NULL,
  ext_diameter_unit  varchar DEFAULT NULL,
--int_width          numeric DEFAULT NULL,
--int_width_unit     varchar DEFAULT NULL,
--int_height         numeric DEFAULT NULL,
--int_height_unit    varchar DEFAULT NULL,
  int_diameter       numeric DEFAULT NULL,
  int_diameter_unit  varchar DEFAULT NULL,
--cross_section      numeric DEFAULT NULL,
--cross_section_unit varchar DEFAULT NULL,
--slope_range_from   numeric DEFAULT NULL,
--slope_range_to     numeric DEFAULT NULL,
--slope_range_unit   varchar DEFAULT NULL,
--profile_name       varchar DEFAULT NULL,
--
  schema_name              varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
  p_id                     integer        := id                    ;
  p_gmlid                  varchar(256)   := gmlid                 ;
  p_gmlid_codespace        varchar(1000)  := gmlid_codespace       ;
  p_name                   varchar(1000)  := name                  ;
  p_name_codespace         varchar(4000)  := name_codespace        ;
  p_description            varchar(4000)  := description           ;
  p_envelope               geometry       := envelope              ;
  p_creation_date          timestamptz(0) := creation_date         ;
  p_termination_date       timestamptz(0) := termination_date      ;
  p_relative_to_terrain    varchar(256)   := relative_to_terrain   ;
  p_relative_to_water      varchar(256)   := relative_to_water     ;
  p_last_modification_date timestamptz    := last_modification_date;
  p_updating_person        varchar(256)   := updating_person       ;
  p_reason_for_update      varchar(4000)  := reason_for_update     ;
  p_lineage                varchar(256)   := lineage               ;
--
  p_ntw_feature_parent_id  integer  := ntw_feature_parent_id;
  p_ntw_feature_root_id    integer  := ntw_feature_root_id;
  p_class                  varchar  := class;
  p_function               varchar  := function;
  p_usage                  varchar  := usage;
  p_year_of_construction   date     := year_of_construction;
  p_status                 varchar  := status;
  p_location_quality       varchar  := location_quality;
  p_elevation_quality      varchar  := elevation_quality;
  p_conn_cityobject_id     integer  := conn_cityobject_id;
  p_prot_element_id        integer  := prot_element_id;
  p_geom                   geometry := geom;	
--
    p_function_of_line   varchar := function_of_line  ;
    p_is_gravity         numeric := is_gravity        ;
--  p_is_transmission    numeric := is_transmission   ;
--  p_is_communication   numeric := is_communication  ;
    p_ext_width          numeric := ext_width         ;
    p_ext_width_unit     varchar := ext_width_unit    ;
    p_ext_height         numeric := ext_height        ;
    p_ext_height_unit    varchar := ext_height_unit   ;
    p_ext_diameter       numeric := ext_diameter      ;
    p_ext_diameter_unit  varchar := ext_diameter_unit ;
--  p_int_width          numeric := int_width         ;
--  p_int_width_unit     varchar := int_width_unit    ;
--  p_int_height         numeric := int_height        ;
--  p_int_height_unit    varchar := int_height_unit   ;
    p_int_diameter       numeric := int_diameter      ;
    p_int_diameter_unit  varchar := int_diameter_unit ;
--  p_cross_section      numeric := cross_section     ;
--  p_cross_section_unit varchar := cross_section_unit;
--  p_slope_range_from   numeric := slope_range_from  ;
--  p_slope_range_to     numeric := slope_range_to    ;
--  p_slope_range_unit   varchar := slope_range_unit  ;
--  p_profile_name       varchar := profile_name      ;
--
  p_schema_name varchar := schema_name;
  class_name varchar DEFAULT 'RoundPipe'::varchar;
  db_prefix varchar DEFAULT 'utn9';
  objectclass_id integer;
  inserted_id integer;
BEGIN
objectclass_id=citydb_pkg.objectclass_classname_to_id(class_name, db_prefix, p_schema_name);

inserted_id=citydb_pkg.insert_cityobject(
    id                    :=p_id,
    objectclass_id        :=objectclass_id,
    gmlid                 :=p_gmlid,
    gmlid_codespace       :=p_gmlid_codespace,
    name                  :=p_name,
    name_codespace        :=p_name_codespace,
    description           :=p_description,
    envelope              :=p_envelope,
    creation_date         :=p_creation_date,
    termination_date      :=p_termination_date,
    relative_to_terrain   :=p_relative_to_terrain,
    relative_to_water     :=p_relative_to_water,
    last_modification_date:=p_last_modification_date,
    updating_person       :=p_updating_person,
    reason_for_update     :=p_reason_for_update,
    lineage               :=p_lineage,
    schema_name           :=p_schema_name
);

PERFORM citydb_pkg.utn9_insert_network_feature(
    id                      :=inserted_id,
    objectclass_id          :=objectclass_id,  -- objectclass ID
    ntw_feature_parent_id   :=p_ntw_feature_parent_id,
    ntw_feature_root_id  	:=p_ntw_feature_root_id  ,
    class                	:=p_class                ,
    function             	:=p_function             ,
    usage                	:=p_usage                ,
    year_of_construction 	:=p_year_of_construction ,
    status               	:=p_status               ,
    location_quality     	:=p_location_quality     ,
    elevation_quality    	:=p_elevation_quality    ,
    conn_cityobject_id      :=p_conn_cityobject_id   ,
    prot_element_id      	:=p_prot_element_id      ,
    geom                 	:=p_geom                 ,
--
    schema_name             :=p_schema_name  -- schema name
);

PERFORM citydb_pkg.utn9_insert_distrib_element(
  id                    :=inserted_id,
  objectclass_id        :=objectclass_id,  -- objectclass ID
  function_of_line      :=p_function_of_line  ,
  is_gravity            :=p_is_gravity        ,
--is_transmission       :=p_is_transmission   ,
--is_communication      :=p_is_communication  ,
  ext_width             :=p_ext_width         ,
  ext_width_unit        :=p_ext_width_unit    ,
  ext_height            :=p_ext_height        ,
  ext_height_unit       :=p_ext_height_unit   ,
  ext_diameter          :=p_ext_diameter      ,
  ext_diameter_unit     :=p_ext_diameter_unit ,
--int_width             :=p_int_width         ,
--int_width_unit        :=p_int_width_unit    ,
--int_height            :=p_int_height        ,
--int_height_unit       :=p_int_height_unit   ,
  int_diameter          :=p_int_diameter      ,
  int_diameter_unit     :=p_int_diameter_unit ,
--cross_section         :=p_cross_section     ,
--cross_section_unit    :=p_cross_section_unit,
--slope_range_from      :=p_slope_range_from  ,
--slope_range_to        :=p_slope_range_to    ,
--slope_range_unit      :=p_slope_range_unit  ,
--profile_name          :=p_profile_name      ,	
--
    schema_name             :=p_schema_name  -- schema name
);

RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_insert_ntw_feat_distrib_elem_pipe_round(): %', SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function UTN9_INSERT_NTW_FEAT_DISTRIB_ELEM_PIPE_RECT
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.utn9_insert_ntw_feat_distrib_elem_pipe_rect(
  id                     integer        DEFAULT NULL,
  gmlid                  varchar(256)   DEFAULT NULL,
  gmlid_codespace        varchar(1000)  DEFAULT NULL,
  name                   varchar(1000)  DEFAULT NULL,
  name_codespace         varchar(4000)  DEFAULT NULL,
  description            varchar(4000)  DEFAULT NULL,
  envelope               geometry       DEFAULT NULL,
  creation_date          timestamptz(0) DEFAULT NULL,
  termination_date       timestamptz(0) DEFAULT NULL,
  relative_to_terrain    varchar(256)   DEFAULT NULL,
  relative_to_water      varchar(256)   DEFAULT NULL,
  last_modification_date timestamptz    DEFAULT NULL,
  updating_person        varchar(256)   DEFAULT NULL,
  reason_for_update      varchar(4000)  DEFAULT NULL,
  lineage                varchar(256)   DEFAULT NULL,
--	
  ntw_feature_parent_id integer DEFAULT NULL,
  ntw_feature_root_id   integer DEFAULT NULL,
  class                 varchar DEFAULT NULL,
  function              varchar DEFAULT NULL,
  usage                 varchar DEFAULT NULL,
  year_of_construction  date    DEFAULT NULL,
  status                varchar DEFAULT NULL,
  location_quality      varchar DEFAULT NULL,
  elevation_quality     varchar DEFAULT NULL,
  conn_cityobject_id    integer DEFAULT NULL,
  prot_element_id       integer DEFAULT NULL,
  geom                  geometry DEFAULT NULL,	
--
  function_of_line   varchar DEFAULT NULL,
  is_gravity         numeric DEFAULT NULL,
--is_transmission    numeric DEFAULT NULL,
--is_communication   numeric DEFAULT NULL,
  ext_width          numeric DEFAULT NULL,
  ext_width_unit     varchar DEFAULT NULL,
  ext_height         numeric DEFAULT NULL,
  ext_height_unit    varchar DEFAULT NULL,
  ext_diameter       numeric DEFAULT NULL,
  ext_diameter_unit  varchar DEFAULT NULL,
  int_width          numeric DEFAULT NULL,
  int_width_unit     varchar DEFAULT NULL,
  int_height         numeric DEFAULT NULL,
  int_height_unit    varchar DEFAULT NULL,
--int_diameter       numeric DEFAULT NULL,
--int_diameter_unit  varchar DEFAULT NULL,
--cross_section      numeric DEFAULT NULL,
--cross_section_unit varchar DEFAULT NULL,
--slope_range_from   numeric DEFAULT NULL,
--slope_range_to     numeric DEFAULT NULL,
--slope_range_unit   varchar DEFAULT NULL,
--profile_name       varchar DEFAULT NULL,
--
  schema_name              varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
  p_id                     integer                     := id                    ;
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
  p_ntw_feature_parent_id  integer  := ntw_feature_parent_id;
  p_ntw_feature_root_id    integer  := ntw_feature_root_id;
  p_class                  varchar  := class;
  p_function               varchar  := function;
  p_usage                  varchar  := usage;
  p_year_of_construction   date     := year_of_construction;
  p_status                 varchar  := status;
  p_location_quality       varchar  := location_quality;
  p_elevation_quality      varchar  := elevation_quality;
  p_conn_cityobject_id     integer  := conn_cityobject_id;
  p_prot_element_id        integer  := prot_element_id;
  p_geom                   geometry := geom;	
--
  p_function_of_line   varchar := function_of_line  ;
  p_is_gravity         numeric := is_gravity        ;
--p_is_transmission    numeric := is_transmission   ;
--p_is_communication   numeric := is_communication  ;
  p_ext_width          numeric := ext_width         ;
  p_ext_width_unit     varchar := ext_width_unit    ;
  p_ext_height         numeric := ext_height        ;
  p_ext_height_unit    varchar := ext_height_unit   ;
  p_ext_diameter       numeric := ext_diameter      ;
  p_ext_diameter_unit  varchar := ext_diameter_unit ;
  p_int_width          numeric := int_width         ;
  p_int_width_unit     varchar := int_width_unit    ;
  p_int_height         numeric := int_height        ;
  p_int_height_unit    varchar := int_height_unit   ;
--p_int_diameter       numeric := int_diameter      ;
--p_int_diameter_unit  varchar := int_diameter_unit ;
--p_cross_section      numeric := cross_section     ;
--p_cross_section_unit varchar := cross_section_unit;
--p_slope_range_from   numeric := slope_range_from  ;
--p_slope_range_to     numeric := slope_range_to    ;
--p_slope_range_unit   varchar := slope_range_unit  ;
--p_profile_name       varchar := profile_name      ;
--
  p_schema_name varchar := schema_name;
  class_name varchar DEFAULT 'RectangularPipe'::varchar;
  db_prefix varchar DEFAULT 'utn9';
  objectclass_id integer;
  inserted_id integer;
BEGIN
objectclass_id=citydb_pkg.objectclass_classname_to_id(class_name, db_prefix, p_schema_name);

inserted_id=citydb_pkg.insert_cityobject(
    id                    :=p_id,
    objectclass_id        :=objectclass_id,
    gmlid                 :=p_gmlid,
    gmlid_codespace       :=p_gmlid_codespace,
    name                  :=p_name,
    name_codespace        :=p_name_codespace,
    description           :=p_description,
    envelope              :=p_envelope,
    creation_date         :=p_creation_date,
    termination_date      :=p_termination_date,
    relative_to_terrain   :=p_relative_to_terrain,
    relative_to_water     :=p_relative_to_water,
    last_modification_date:=p_last_modification_date,
    updating_person       :=p_updating_person,
    reason_for_update     :=p_reason_for_update,
    lineage               :=p_lineage,
    schema_name           :=p_schema_name
);

PERFORM citydb_pkg.utn9_insert_network_feature(
    id                    :=inserted_id,
    objectclass_id        :=objectclass_id,  -- objectclass ID
    ntw_feature_parent_id :=p_ntw_feature_parent_id,
    ntw_feature_root_id  	:=p_ntw_feature_root_id  ,
    class                	:=p_class                ,
    function             	:=p_function             ,
    usage                	:=p_usage                ,
    year_of_construction 	:=p_year_of_construction ,
    status               	:=p_status               ,
    location_quality     	:=p_location_quality     ,
    elevation_quality    	:=p_elevation_quality    ,
    conn_cityobject_id      :=p_conn_cityobject_id   ,
    prot_element_id      	:=p_prot_element_id      ,
    geom                 	:=p_geom                 ,
--
    schema_name             :=p_schema_name  -- schema name
);

PERFORM citydb_pkg.utn9_insert_distrib_element(
    id                    :=inserted_id,
    objectclass_id        :=objectclass_id,  -- objectclass ID
    function_of_line      :=p_function_of_line  ,
    is_gravity            :=p_is_gravity        ,
--  is_transmission       :=p_is_transmission   ,
--  is_communication      :=p_is_communication  ,
    ext_width             :=p_ext_width         ,
    ext_width_unit        :=p_ext_width_unit    ,
    ext_height            :=p_ext_height        ,
    ext_height_unit       :=p_ext_height_unit   ,
    ext_diameter          :=p_ext_diameter      ,
    ext_diameter_unit     :=p_ext_diameter_unit ,
    int_width             :=p_int_width         ,
    int_width_unit        :=p_int_width_unit    ,
    int_height            :=p_int_height        ,
    int_height_unit       :=p_int_height_unit   ,
--  int_diameter          :=p_int_diameter      ,
--  int_diameter_unit     :=p_int_diameter_unit ,
--  cross_section         :=p_cross_section     ,
--  cross_section_unit    :=p_cross_section_unit,
--  slope_range_from      :=p_slope_range_from  ,
--  slope_range_to        :=p_slope_range_to    ,
--  slope_range_unit      :=p_slope_range_unit  ,
--  profile_name          :=p_profile_name      ,	
--
    schema_name             :=p_schema_name  -- schema name
);

RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_insert_ntw_feat_distrib_elem_pipe_rect(): %', SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function UTN9_INSERT_NTW_FEAT_PROT_ELEM_BEDDING
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.utn9_insert_ntw_feat_prot_elem_bedding(
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
  ntw_feature_parent_id integer DEFAULT NULL,
  ntw_feature_root_id   integer DEFAULT NULL,
  class                 varchar DEFAULT NULL,
  function              varchar DEFAULT NULL,
  usage                 varchar DEFAULT NULL,
  year_of_construction  date    DEFAULT NULL,
  status                varchar DEFAULT NULL,
  location_quality      varchar DEFAULT NULL,
  elevation_quality     varchar DEFAULT NULL,
  conn_cityobject_id    integer DEFAULT NULL,
  prot_element_id       integer DEFAULT NULL,
  geom                  geometry DEFAULT NULL,	
--
--ext_width         numeric DEFAULT NULL,
--ext_width_unit    varchar DEFAULT NULL,
--ext_height        numeric DEFAULT NULL,
--ext_height_unit   varchar DEFAULT NULL,
--ext_diameter      numeric DEFAULT NULL,
--ext_diameter_unit varchar DEFAULT NULL,
--int_width         numeric DEFAULT NULL,
--int_width_unit    varchar DEFAULT NULL,
--int_height        numeric DEFAULT NULL,
--int_height_unit   varchar DEFAULT NULL,
--int_diameter      numeric DEFAULT NULL,
--int_diameter_unit varchar DEFAULT NULL,
  width             numeric DEFAULT NULL,
  width_unit        varchar DEFAULT NULL,
--
  schema_name              varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
  p_id                     integer                     := id                    ;
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
  p_ntw_feature_parent_id  integer  := ntw_feature_parent_id;
  p_ntw_feature_root_id    integer  := ntw_feature_root_id;
  p_class                  varchar  := class;
  p_function               varchar  := function;
  p_usage                  varchar  := usage;
  p_year_of_construction   date     := year_of_construction;
  p_status                 varchar  := status;
  p_location_quality       varchar  := location_quality;
  p_elevation_quality      varchar  := elevation_quality;
  p_conn_cityobject_id     integer  := conn_cityobject_id;
  p_prot_element_id        integer  := prot_element_id;
  p_geom                   geometry := geom;	
--
--p_ext_width         numeric := ext_width        ;
--p_ext_width_unit    varchar := ext_width_unit   ;
--p_ext_height        numeric := ext_height       ;
--p_ext_height_unit   varchar := ext_height_unit  ;
--p_ext_diameter      numeric := ext_diameter     ;
--p_ext_diameter_unit varchar := ext_diameter_unit;
--p_int_width         numeric := int_width        ;
--p_int_width_unit    varchar := int_width_unit   ;
--p_int_height        numeric := int_height       ;
--p_int_height_unit   varchar := int_height_unit  ;
--p_int_diameter      numeric := int_diameter     ;
--p_int_diameter_unit varchar := int_diameter_unit;
  p_width             numeric := width            ;
  p_width_unit        varchar := width_unit       ;
--
  p_schema_name varchar := schema_name;
  class_name varchar DEFAULT 'Bedding'::varchar;
  db_prefix varchar DEFAULT 'utn9';
  objectclass_id integer;
  inserted_id integer;
BEGIN
objectclass_id=citydb_pkg.objectclass_classname_to_id(class_name, db_prefix, p_schema_name);

inserted_id=citydb_pkg.insert_cityobject(
    id                    :=p_id,
    objectclass_id        :=objectclass_id,
    gmlid                 :=p_gmlid,
    gmlid_codespace       :=p_gmlid_codespace,
    name                  :=p_name,
    name_codespace        :=p_name_codespace,
    description           :=p_description,
    envelope              :=p_envelope,
    creation_date         :=p_creation_date,
    termination_date      :=p_termination_date,
    relative_to_terrain   :=p_relative_to_terrain,
    relative_to_water     :=p_relative_to_water,
    last_modification_date:=p_last_modification_date,
    updating_person       :=p_updating_person,
    reason_for_update     :=p_reason_for_update,
    lineage               :=p_lineage,
    schema_name           :=p_schema_name
);

PERFORM citydb_pkg.utn9_insert_network_feature(
    id                    :=inserted_id,
    objectclass_id        :=objectclass_id,  -- objectclass ID
    ntw_feature_parent_id :=p_ntw_feature_parent_id,
    ntw_feature_root_id  	:=p_ntw_feature_root_id  ,
    class                	:=p_class                ,
    function             	:=p_function             ,
    usage                	:=p_usage                ,
    year_of_construction 	:=p_year_of_construction ,
    status               	:=p_status               ,
    location_quality     	:=p_location_quality     ,
    elevation_quality    	:=p_elevation_quality    ,
    conn_cityobject_id      :=p_conn_cityobject_id   ,
    prot_element_id      	:=p_prot_element_id      ,
    geom                 	:=p_geom                 ,
--
    schema_name             :=p_schema_name  -- schema name
);

PERFORM citydb_pkg.utn9_insert_protective_element(
    id                    :=inserted_id,
    objectclass_id        :=objectclass_id,  -- objectclass ID
--  ext_width             :=p_ext_width        ,
--  ext_width_unit        :=p_ext_width_unit   ,
--  ext_height            :=p_ext_height       ,
--  ext_height_unit       :=p_ext_height_unit  ,
--  ext_diameter          :=p_ext_diameter     ,
--  ext_diameter_unit     :=p_ext_diameter_unit,
--  int_width             :=p_int_width        ,
--  int_width_unit        :=p_int_width_unit   ,
--  int_height            :=p_int_height       ,
--  int_height_unit       :=p_int_height_unit  ,
--  int_diameter          :=p_int_diameter     ,
--  int_diameter_unit     :=p_int_diameter_unit,
    width                 :=p_width            ,
    width_unit            :=p_width_unit       ,
--
    schema_name             :=p_schema_name  -- schema name
);

RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_insert_ntw_feat_prot_elem_bedding(): %', SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function UTN9_INSERT_NTW_FEAT_PROT_ELEM_SHELL_OTHER
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.utn9_insert_ntw_feat_prot_elem_shell_other(
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
  ntw_feature_parent_id integer DEFAULT NULL,
  ntw_feature_root_id   integer DEFAULT NULL,
  class                 varchar DEFAULT NULL,
  function              varchar DEFAULT NULL,
  usage                 varchar DEFAULT NULL,
  year_of_construction  date    DEFAULT NULL,
  status                varchar DEFAULT NULL,
  location_quality      varchar DEFAULT NULL,
  elevation_quality     varchar DEFAULT NULL,
  conn_cityobject_id    integer DEFAULT NULL,
  prot_element_id       integer DEFAULT NULL,
  geom                  geometry DEFAULT NULL,	
--
  ext_width         numeric DEFAULT NULL,
  ext_width_unit    varchar DEFAULT NULL,
  ext_height        numeric DEFAULT NULL,
  ext_height_unit   varchar DEFAULT NULL,
  ext_diameter      numeric DEFAULT NULL,
  ext_diameter_unit varchar DEFAULT NULL,
--int_width         numeric DEFAULT NULL,
--int_width_unit    varchar DEFAULT NULL,
--int_height        numeric DEFAULT NULL,
--int_height_unit   varchar DEFAULT NULL,
--int_diameter      numeric DEFAULT NULL,
--int_diameter_unit varchar DEFAULT NULL,
--width             numeric DEFAULT NULL,
--width_unit        varchar DEFAULT NULL,
--
  schema_name              varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
  p_id                     integer                     := id                    ;
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
  p_ntw_feature_parent_id  integer  := ntw_feature_parent_id;
  p_ntw_feature_root_id    integer  := ntw_feature_root_id;
  p_class                  varchar  := class;
  p_function               varchar  := function;
  p_usage                  varchar  := usage;
  p_year_of_construction   date     := year_of_construction;
  p_status                 varchar  := status;
  p_location_quality       varchar  := location_quality;
  p_elevation_quality      varchar  := elevation_quality;
  p_conn_cityobject_id     integer  := conn_cityobject_id;
  p_prot_element_id        integer  := prot_element_id;
  p_geom                   geometry := geom;	
--
  p_ext_width         numeric := ext_width        ;
  p_ext_width_unit    varchar := ext_width_unit   ;
  p_ext_height        numeric := ext_height       ;
  p_ext_height_unit   varchar := ext_height_unit  ;
  p_ext_diameter      numeric := ext_diameter     ;
  p_ext_diameter_unit varchar := ext_diameter_unit;
--p_int_width         numeric := int_width        ;
--p_int_width_unit    varchar := int_width_unit   ;
--p_int_height        numeric := int_height       ;
--p_int_height_unit   varchar := int_height_unit  ;
--p_int_diameter      numeric := int_diameter     ;
--p_int_diameter_unit varchar := int_diameter_unit;
--p_width             numeric := width            ;
--p_width_unit        varchar := width_unit       ;
--
  p_schema_name varchar := schema_name;
  class_name varchar DEFAULT 'OtherShell'::varchar;
  db_prefix varchar DEFAULT 'utn9';
  objectclass_id integer;
  inserted_id integer;
BEGIN
objectclass_id=citydb_pkg.objectclass_classname_to_id(class_name, db_prefix, p_schema_name);

inserted_id=citydb_pkg.insert_cityobject(
    id                    :=p_id,
    objectclass_id        :=objectclass_id,
    gmlid                 :=p_gmlid,
    gmlid_codespace       :=p_gmlid_codespace,
    name                  :=p_name,
    name_codespace        :=p_name_codespace,
    description           :=p_description,
    envelope              :=p_envelope,
    creation_date         :=p_creation_date,
    termination_date      :=p_termination_date,
    relative_to_terrain   :=p_relative_to_terrain,
    relative_to_water     :=p_relative_to_water,
    last_modification_date:=p_last_modification_date,
    updating_person       :=p_updating_person,
    reason_for_update     :=p_reason_for_update,
    lineage               :=p_lineage,
    schema_name           :=p_schema_name
);

PERFORM citydb_pkg.utn9_insert_network_feature(
    id                    :=inserted_id,
    objectclass_id        :=objectclass_id,  -- objectclass ID
    ntw_feature_parent_id :=p_ntw_feature_parent_id,
    ntw_feature_root_id  	:=p_ntw_feature_root_id  ,
    class                	:=p_class                ,
    function             	:=p_function             ,
    usage                	:=p_usage                ,
    year_of_construction 	:=p_year_of_construction ,
    status               	:=p_status               ,
    location_quality     	:=p_location_quality     ,
    elevation_quality    	:=p_elevation_quality    ,
    conn_cityobject_id      :=p_conn_cityobject_id   ,
    prot_element_id      	:=p_prot_element_id      ,
    geom                 	:=p_geom                 ,
--
    schema_name             :=p_schema_name  -- schema name
);

PERFORM citydb_pkg.utn9_insert_protective_element(
    id                    :=inserted_id,
    objectclass_id        :=objectclass_id,  -- objectclass ID
    ext_width             :=p_ext_width        ,
    ext_width_unit        :=p_ext_width_unit   ,
    ext_height            :=p_ext_height       ,
    ext_height_unit       :=p_ext_height_unit  ,
    ext_diameter          :=p_ext_diameter     ,
    ext_diameter_unit     :=p_ext_diameter_unit,
--  int_width             :=p_int_width        ,
--  int_width_unit        :=p_int_width_unit   ,
--  int_height            :=p_int_height       ,
--  int_height_unit       :=p_int_height_unit  ,
--  int_diameter          :=p_int_diameter     ,
--  int_diameter_unit     :=p_int_diameter_unit,
--  width                 :=p_width            ,
--  width_unit            :=p_width_unit       ,
--
    schema_name             :=p_schema_name  -- schema name
);

RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_insert_ntw_feat_prot_elem_shell_other(): %', SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function UTN9_INSERT_NTW_FEAT_PROT_ELEM_SHELL_ROUND
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.utn9_insert_ntw_feat_prot_elem_shell_round(
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
  ntw_feature_parent_id integer DEFAULT NULL,
  ntw_feature_root_id   integer DEFAULT NULL,
  class                 varchar DEFAULT NULL,
  function              varchar DEFAULT NULL,
  usage                 varchar DEFAULT NULL,
  year_of_construction  date    DEFAULT NULL,
  status                varchar DEFAULT NULL,
  location_quality      varchar DEFAULT NULL,
  elevation_quality     varchar DEFAULT NULL,
  conn_cityobject_id    integer DEFAULT NULL,
  prot_element_id       integer DEFAULT NULL,
  geom                  geometry DEFAULT NULL,	
--
  ext_width         numeric DEFAULT NULL,
  ext_width_unit    varchar DEFAULT NULL,
  ext_height        numeric DEFAULT NULL,
  ext_height_unit   varchar DEFAULT NULL,
  ext_diameter      numeric DEFAULT NULL,
  ext_diameter_unit varchar DEFAULT NULL,
--int_width         numeric DEFAULT NULL,
--int_width_unit    varchar DEFAULT NULL,
--int_height        numeric DEFAULT NULL,
--int_height_unit   varchar DEFAULT NULL,
  int_diameter      numeric DEFAULT NULL,
  int_diameter_unit varchar DEFAULT NULL,
--width             numeric DEFAULT NULL,
--width_unit        varchar DEFAULT NULL,
--
  schema_name              varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
  p_id                     integer                     := id                    ;
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
  p_ntw_feature_parent_id  integer  := ntw_feature_parent_id;
  p_ntw_feature_root_id    integer  := ntw_feature_root_id;
  p_class                  varchar  := class;
  p_function               varchar  := function;
  p_usage                  varchar  := usage;
  p_year_of_construction   date     := year_of_construction;
  p_status                 varchar  := status;
  p_location_quality       varchar  := location_quality;
  p_elevation_quality      varchar  := elevation_quality;
  p_conn_cityobject_id     integer  := conn_cityobject_id;
  p_prot_element_id        integer  := prot_element_id;
  p_geom                   geometry := geom;	
--
  p_ext_width         numeric := ext_width        ;
  p_ext_width_unit    varchar := ext_width_unit   ;
  p_ext_height        numeric := ext_height       ;
  p_ext_height_unit   varchar := ext_height_unit  ;
  p_ext_diameter      numeric := ext_diameter     ;
  p_ext_diameter_unit varchar := ext_diameter_unit;
--p_int_width         numeric := int_width        ;
--p_int_width_unit    varchar := int_width_unit   ;
--p_int_height        numeric := int_height       ;
--p_int_height_unit   varchar := int_height_unit  ;
  p_int_diameter      numeric := int_diameter     ;
  p_int_diameter_unit varchar := int_diameter_unit;
--p_width             numeric := width            ;
--p_width_unit        varchar := width_unit       ;
--
  p_schema_name varchar := schema_name;
  class_name varchar DEFAULT 'RoundShell'::varchar;
  db_prefix varchar DEFAULT 'utn9';
  objectclass_id integer;
  inserted_id integer;
BEGIN
objectclass_id=citydb_pkg.objectclass_classname_to_id(class_name, db_prefix, p_schema_name);

inserted_id=citydb_pkg.insert_cityobject(
    id                    :=p_id,
    objectclass_id        :=objectclass_id,
    gmlid                 :=p_gmlid,
    gmlid_codespace       :=p_gmlid_codespace,
    name                  :=p_name,
    name_codespace        :=p_name_codespace,
    description           :=p_description,
    envelope              :=p_envelope,
    creation_date         :=p_creation_date,
    termination_date      :=p_termination_date,
    relative_to_terrain   :=p_relative_to_terrain,
    relative_to_water     :=p_relative_to_water,
    last_modification_date:=p_last_modification_date,
    updating_person       :=p_updating_person,
    reason_for_update     :=p_reason_for_update,
    lineage               :=p_lineage,
    schema_name           :=p_schema_name
);

PERFORM citydb_pkg.utn9_insert_network_feature(
    id                    :=inserted_id,
    objectclass_id        :=objectclass_id,  -- objectclass ID
    ntw_feature_parent_id :=p_ntw_feature_parent_id,
    ntw_feature_root_id  	:=p_ntw_feature_root_id  ,
    class                	:=p_class                ,
    function             	:=p_function             ,
    usage                	:=p_usage                ,
    year_of_construction 	:=p_year_of_construction ,
    status               	:=p_status               ,
    location_quality     	:=p_location_quality     ,
    elevation_quality    	:=p_elevation_quality    ,
    conn_cityobject_id      :=p_conn_cityobject_id   ,
    prot_element_id      	:=p_prot_element_id      ,
    geom                 	:=p_geom                 ,
--
    schema_name             :=p_schema_name  -- schema name
);

PERFORM citydb_pkg.utn9_insert_protective_element(
    id                    :=inserted_id,
    objectclass_id        :=objectclass_id,  -- objectclass ID
    ext_width             :=p_ext_width        ,
    ext_width_unit        :=p_ext_width_unit   ,
    ext_height            :=p_ext_height       ,
    ext_height_unit       :=p_ext_height_unit  ,
    ext_diameter          :=p_ext_diameter     ,
    ext_diameter_unit     :=p_ext_diameter_unit,
--  int_width             :=p_int_width        ,
--  int_width_unit        :=p_int_width_unit   ,
--  int_height            :=p_int_height       ,
--  int_height_unit       :=p_int_height_unit  ,
    int_diameter          :=p_int_diameter     ,
    int_diameter_unit     :=p_int_diameter_unit,
--  width                 :=p_width            ,
--  width_unit            :=p_width_unit       ,
--
    schema_name             :=p_schema_name  -- schema name
);

RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_insert_ntw_feat_prot_elem_shell_round(): %', SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function UTN9_INSERT_NTW_FEAT_PROT_ELEM_SHELL_RECT
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.utn9_insert_ntw_feat_prot_elem_shell_rect(
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
  ntw_feature_parent_id integer DEFAULT NULL,
  ntw_feature_root_id   integer DEFAULT NULL,
  class                 varchar DEFAULT NULL,
  function              varchar DEFAULT NULL,
  usage                 varchar DEFAULT NULL,
  year_of_construction  date    DEFAULT NULL,
  status                varchar DEFAULT NULL,
  location_quality      varchar DEFAULT NULL,
  elevation_quality     varchar DEFAULT NULL,
  conn_cityobject_id    integer DEFAULT NULL,
  prot_element_id       integer DEFAULT NULL,
  geom                  geometry DEFAULT NULL,	
--
  ext_width         numeric DEFAULT NULL,
  ext_width_unit    varchar DEFAULT NULL,
  ext_height        numeric DEFAULT NULL,
  ext_height_unit   varchar DEFAULT NULL,
  ext_diameter      numeric DEFAULT NULL,
  ext_diameter_unit varchar DEFAULT NULL,
  int_width         numeric DEFAULT NULL,
  int_width_unit    varchar DEFAULT NULL,
  int_height        numeric DEFAULT NULL,
  int_height_unit   varchar DEFAULT NULL,
--int_diameter      numeric DEFAULT NULL,
--int_diameter_unit varchar DEFAULT NULL,
--width             numeric DEFAULT NULL,
--width_unit        varchar DEFAULT NULL,
--
  schema_name              varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
  p_id                     integer                     := id                    ;
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
  p_ntw_feature_parent_id  integer  := ntw_feature_parent_id;
  p_ntw_feature_root_id    integer  := ntw_feature_root_id;
  p_class                  varchar  := class;
  p_function               varchar  := function;
  p_usage                  varchar  := usage;
  p_year_of_construction   date     := year_of_construction;
  p_status                 varchar  := status;
  p_location_quality       varchar  := location_quality;
  p_elevation_quality      varchar  := elevation_quality;
  p_conn_cityobject_id     integer  := conn_cityobject_id;
  p_prot_element_id        integer  := prot_element_id;
  p_geom                   geometry := geom;	
--
  p_ext_width         numeric := ext_width        ;
  p_ext_width_unit    varchar := ext_width_unit   ;
  p_ext_height        numeric := ext_height       ;
  p_ext_height_unit   varchar := ext_height_unit  ;
  p_ext_diameter      numeric := ext_diameter     ;
  p_ext_diameter_unit varchar := ext_diameter_unit;
  p_int_width         numeric := int_width        ;
  p_int_width_unit    varchar := int_width_unit   ;
  p_int_height        numeric := int_height       ;
  p_int_height_unit   varchar := int_height_unit  ;
--p_int_diameter      numeric := int_diameter     ;
--p_int_diameter_unit varchar := int_diameter_unit;
--p_width             numeric := width            ;
--p_width_unit        varchar := width_unit       ;
--
  p_schema_name varchar := schema_name;
  class_name varchar DEFAULT 'RectangularShell'::varchar;
  db_prefix varchar DEFAULT 'utn9';
  objectclass_id integer;
  inserted_id integer;
BEGIN
objectclass_id=citydb_pkg.objectclass_classname_to_id(class_name, db_prefix, p_schema_name);

inserted_id=citydb_pkg.insert_cityobject(
    id                    :=p_id,
    objectclass_id        :=objectclass_id,
    gmlid                 :=p_gmlid,
    gmlid_codespace       :=p_gmlid_codespace,
    name                  :=p_name,
    name_codespace        :=p_name_codespace,
    description           :=p_description,
    envelope              :=p_envelope,
    creation_date         :=p_creation_date,
    termination_date      :=p_termination_date,
    relative_to_terrain   :=p_relative_to_terrain,
    relative_to_water     :=p_relative_to_water,
    last_modification_date:=p_last_modification_date,
    updating_person       :=p_updating_person,
    reason_for_update     :=p_reason_for_update,
    lineage               :=p_lineage,
    schema_name           :=p_schema_name
);

PERFORM citydb_pkg.utn9_insert_network_feature(
    id                    :=inserted_id,
    objectclass_id        :=objectclass_id,  -- objectclass ID
    ntw_feature_parent_id :=p_ntw_feature_parent_id,
    ntw_feature_root_id  	:=p_ntw_feature_root_id  ,
    class                	:=p_class                ,
    function             	:=p_function             ,
    usage                	:=p_usage                ,
    year_of_construction 	:=p_year_of_construction ,
    status               	:=p_status               ,
    location_quality     	:=p_location_quality     ,
    elevation_quality    	:=p_elevation_quality    ,
    conn_cityobject_id      :=p_conn_cityobject_id   ,
    prot_element_id      	:=p_prot_element_id      ,
    geom                 	:=p_geom                 ,
--
    schema_name             :=p_schema_name  -- schema name
);

PERFORM citydb_pkg.utn9_insert_protective_element(
    id                    :=inserted_id,
    objectclass_id        :=objectclass_id,  -- objectclass ID
    ext_width             :=p_ext_width        ,
    ext_width_unit        :=p_ext_width_unit   ,
    ext_height            :=p_ext_height       ,
    ext_height_unit       :=p_ext_height_unit  ,
    ext_diameter          :=p_ext_diameter     ,
    ext_diameter_unit     :=p_ext_diameter_unit,
    int_width             :=p_int_width        ,
    int_width_unit        :=p_int_width_unit   ,
    int_height            :=p_int_height       ,
    int_height_unit       :=p_int_height_unit  ,
--  int_diameter          :=p_int_diameter     ,
--  int_diameter_unit     :=p_int_diameter_unit,
--  width                 :=p_width            ,
--  width_unit            :=p_width_unit       ,
--
    schema_name             :=p_schema_name  -- schema name
);

RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_insert_ntw_feat_prot_elem_shell_rect(): %', SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function UTN9_INSERT_ROLE_IN_NETWORK
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.utn9_insert_role_in_network(
  id              integer DEFAULT NULL,
  gmlid           varchar DEFAULT NULL,
  gmlid_codespace varchar DEFAULT NULL,
  name            varchar DEFAULT NULL,
  name_codespace  varchar DEFAULT NULL,
  description     text    DEFAULT NULL,
  function        varchar DEFAULT NULL,
  usage           varchar DEFAULT NULL,
  cityobject_id   integer DEFAULT NULL,
  network_id      integer DEFAULT NULL,
--
  schema_name              varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
  p_id              integer := id;
  p_gmlid           varchar := gmlid;
  p_gmlid_codespace varchar := gmlid_codespace;
  p_name            varchar := name;
  p_name_codespace  varchar := name_codespace;
  p_description     text    := description;
  p_function        varchar := function;
  p_usage           varchar := usage;
  p_cityobject_id   integer := cityobject_id;
  p_network_id      integer := network_id;
--
  p_schema_name varchar := schema_name;
  class_name varchar DEFAULT 'RoleInNetwork'::varchar;
  db_prefix varchar DEFAULT 'utn9';
  objectclass_id integer;
  inserted_id integer;
BEGIN
objectclass_id=citydb_pkg.objectclass_classname_to_id(class_name, db_prefix, p_schema_name);

inserted_id=citydb_pkg.utn9_insert_role_in_network(
    id              :=p_id             ,
    objectclass_id  :=objectclass_id   ,  -- objectclass ID
    gmlid           :=p_gmlid          ,
    gmlid_codespace :=p_gmlid_codespace,
    name            :=p_name           ,
    name_codespace  :=p_name_codespace ,
    description     :=p_description    ,
    function        :=p_function       ,
    usage           :=p_usage          ,
    cityobject_id   :=p_cityobject_id  ,
    network_id      :=p_network_id     ,
--
    schema_name             :=p_schema_name  -- schema name
);
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_insert_role_in_network(): %', SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function UTN9_INSERT_STORAGE
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.utn9_insert_storage(
  id                integer DEFAULT NULL,
  type              varchar DEFAULT NULL,
  max_capacity      numeric DEFAULT NULL,
  max_capacity_unit varchar DEFAULT NULL,
  fill_level        numeric DEFAULT NULL,
  inflow_rate       numeric DEFAULT NULL,
  inflow_rate_unit  varchar DEFAULT NULL,
  outflow_rate      numeric DEFAULT NULL,
  outflow_rate_unit varchar DEFAULT NULL,
  medium_supply_id  integer DEFAULT NULL,
--
  schema_name              varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
  p_id                integer := id;
  p_type              varchar := type;
  p_max_capacity      numeric := max_capacity;
  p_max_capacity_unit varchar := max_capacity_unit;
  p_fill_level        numeric := fill_level;
  p_inflow_rate       numeric := inflow_rate;
  p_inflow_rate_unit  varchar := inflow_rate_unit;
  p_outflow_rate      numeric := outflow_rate;
  p_outflow_rate_unit varchar := outflow_rate_unit;
  p_medium_supply_id  integer := medium_supply_id;
--
  p_schema_name varchar := schema_name;
--  class_name varchar DEFAULT 'Storage'::varchar;
--  db_prefix varchar DEFAULT 'utn9';
--  objectclass_id integer;
  inserted_id integer;
BEGIN
--objectclass_id=citydb_pkg.objectclass_classname_to_id(class_name, db_prefix, p_schema_name);

inserted_id=citydb_pkg.utn9_insert_storage(
  id                :=p_id                ,
  type              :=p_type              ,
  max_capacity      :=p_max_capacity      ,
  max_capacity_unit :=p_max_capacity_unit ,
  fill_level        :=p_fill_level        ,
  inflow_rate       :=p_inflow_rate       ,
  inflow_rate_unit  :=p_inflow_rate_unit  ,
  outflow_rate      :=p_outflow_rate      ,
  outflow_rate_unit :=p_outflow_rate_unit ,
  medium_supply_id  :=p_medium_supply_id  ,
--
    schema_name             :=p_schema_name  -- schema name
);
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_insert_storage(): %', SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function UTN9_INSERT_SUPPLY_AREA
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.utn9_insert_supply_area(
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
  class                varchar(256) DEFAULT NULL,
  class_codespace      varchar(4000) DEFAULT NULL,
  function             varchar(1000) DEFAULT NULL,
  function_codespace   varchar(4000) DEFAULT NULL,
  usage                varchar(1000) DEFAULT NULL,
  usage_codespace      varchar(4000) DEFAULT NULL,
  brep_id              integer DEFAULT NULL,
  other_geom           geometry DEFAULT NULL,
  parent_cityobject_id integer DEFAULT NULL,
--
  schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer AS
$BODY$
DECLARE
  p_id                     integer                     := id                    ;
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
  p_class                varchar(256)  := class               ;
  p_class_codespace      varchar(4000) := class_codespace     ;
  p_function             varchar(1000) := function            ;
  p_function_codespace   varchar(4000) := function_codespace  ;
  p_usage                varchar(1000) := usage               ;
  p_usage_codespace      varchar(4000) := usage_codespace     ;
  p_brep_id              integer       := brep_id             ;
  p_other_geom           geometry      := other_geom          ;
  p_parent_cityobject_id integer       := parent_cityobject_id;
--
  p_schema_name varchar := schema_name;
  class_name varchar DEFAULT 'SupplyArea'::varchar;
  db_prefix varchar DEFAULT 'utn9'::varchar;
  objectclass_id integer;
  inserted_id integer;
BEGIN
objectclass_id=citydb_pkg.objectclass_classname_to_id(class_name, db_prefix, p_schema_name);

inserted_id=citydb_pkg.insert_cityobject(
    id                    :=p_id,
    objectclass_id        :=objectclass_id,
    gmlid                 :=p_gmlid,
    gmlid_codespace       :=p_gmlid_codespace,
    name                  :=p_name,
    name_codespace        :=p_name_codespace,
    description           :=p_description,
    envelope              :=p_envelope,
    creation_date         :=p_creation_date,
    termination_date      :=p_termination_date,
    relative_to_terrain   :=p_relative_to_terrain,
    relative_to_water     :=p_relative_to_water,
    last_modification_date:=p_last_modification_date,
    updating_person       :=p_updating_person,
    reason_for_update     :=p_reason_for_update,
    lineage               :=p_lineage,
    schema_name           :=p_schema_name
);
PERFORM citydb_pkg.insert_cityobjectgroup(
    id                  :=inserted_id,
    class               :=p_class,
    class_codespace     :=p_class_codespace,
    function            :=p_function,
    function_codespace  :=p_function_codespace,
    usage               :=p_usage,
    usage_codespace     :=p_usage_codespace,
    brep_id             :=p_brep_id,
    other_geom          :=p_other_geom,
    parent_cityobject_id:=p_parent_cityobject_id,
    schema_name         :=p_schema_name
);
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_insert_supply_area (): %', SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

---------------------------------------------------------------
-- Function INSERT_COMMODITY (generic) com_classname att IS NOT NULL
---------------------------------------------------------------
CREATE OR REPLACE FUNCTION citydb_view.utn9_insert_commodity(
classname                    varchar,
--  
id                           integer DEFAULT NULL,
gmlid                        varchar DEFAULT NULL,
gmlid_codespace              varchar DEFAULT NULL,
name                         varchar DEFAULT NULL,
name_codespace               varchar DEFAULT NULL,
description                  text    DEFAULT NULL,
owner                        varchar DEFAULT NULL,
type                         varchar DEFAULT NULL,
is_corrosive                 numeric(1) DEFAULT NULL,
is_explosive                 numeric(1) DEFAULT NULL,
is_lighter_than_air          numeric(1) DEFAULT NULL,
flammability_ratio           numeric DEFAULT NULL,
elec_conductivity_range_from numeric DEFAULT NULL,
elec_conductivity_range_to   numeric DEFAULT NULL,	
elec_conductivity_range_unit varchar DEFAULT NULL,
concentration                numeric DEFAULT NULL,
concentration_unit           varchar DEFAULT NULL,	
ph_value_range_from          numeric DEFAULT NULL,
ph_value_range_to            numeric DEFAULT NULL,
ph_value_range_unit          varchar DEFAULT NULL,	
temperature_range_from       numeric DEFAULT NULL,
temperature_range_to         numeric DEFAULT NULL,
temperature_range_unit       varchar DEFAULT NULL,	
flow_rate_range_from         numeric DEFAULT NULL,
flow_rate_range_to           numeric DEFAULT NULL,
flow_rate_range_unit         varchar DEFAULT NULL,		
pressure_range_from          numeric DEFAULT NULL,
pressure_range_to            numeric DEFAULT NULL,
pressure_range_unit          varchar DEFAULT NULL,
voltage_range_from           numeric DEFAULT NULL,
voltage_range_to             numeric DEFAULT NULL,
voltage_range_unit           varchar DEFAULT NULL,
amperage_range_from          numeric DEFAULT NULL,
amperage_range_to            numeric DEFAULT NULL,
amperage_range_unit          varchar DEFAULT NULL,
bandwidth_range_from         numeric DEFAULT NULL,
bandwidth_range_to           numeric DEFAULT NULL,
bandwidth_range_unit         varchar DEFAULT NULL,
optical_mode	             varchar DEFAULT NULL,
--
schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer
AS $$
DECLARE
p_id                           integer    :=id                          ;
p_gmlid                        varchar    :=gmlid                       ;
p_gmlid_codespace              varchar    :=gmlid_codespace             ;
p_name                         varchar    :=name                        ;
p_name_codespace               varchar    :=name_codespace              ;
p_description                  text       :=description                 ;
p_owner                        varchar    :=owner                       ;
p_type                         varchar    :=type                        ;
p_is_corrosive                 numeric(1) :=is_corrosive                ;
p_is_explosive                 numeric(1) :=is_explosive                ;
p_is_lighter_than_air          numeric(1) :=is_lighter_than_air         ;
p_flammability_ratio           numeric    :=flammability_ratio          ;
p_elec_conductivity_range_from numeric    :=elec_conductivity_range_from;
p_elec_conductivity_range_to   numeric    :=elec_conductivity_range_to  ;	
p_elec_conductivity_range_unit varchar    :=elec_conductivity_range_unit;
p_concentration                numeric    :=concentration               ;
p_concentration_unit           varchar    :=concentration_unit          ;	
p_ph_value_range_from          numeric    :=ph_value_range_from         ;
p_ph_value_range_to            numeric    :=ph_value_range_to           ;
p_ph_value_range_unit          varchar    :=ph_value_range_unit         ;	
p_temperature_range_from       numeric    :=temperature_range_from      ;
p_temperature_range_to         numeric    :=temperature_range_to        ;
p_temperature_range_unit       varchar    :=temperature_range_unit      ;	
p_flow_rate_range_from         numeric    :=flow_rate_range_from        ;
p_flow_rate_range_to           numeric    :=flow_rate_range_to          ;
p_flow_rate_range_unit         varchar    :=flow_rate_range_unit        ;		
p_pressure_range_from          numeric    :=pressure_range_from         ;
p_pressure_range_to            numeric    :=pressure_range_to           ;
p_pressure_range_unit          varchar    :=pressure_range_unit         ;
p_voltage_range_from           numeric    :=voltage_range_from          ;
p_voltage_range_to             numeric    :=voltage_range_to            ;
p_voltage_range_unit           varchar    :=voltage_range_unit          ;
p_amperage_range_from          numeric    :=amperage_range_from         ;
p_amperage_range_to            numeric    :=amperage_range_to           ;
p_amperage_range_unit          varchar    :=amperage_range_unit         ;
p_bandwidth_range_from         numeric    :=bandwidth_range_from        ;
p_bandwidth_range_to           numeric    :=bandwidth_range_to          ;
p_bandwidth_range_unit         varchar    :=bandwidth_range_unit        ;
p_optical_mode	               varchar    :=optical_mode	            ; 
--
p_schema_name varchar := schema_name;
class_name varchar    := classname;
db_prefix varchar DEFAULT 'utn9';
inserted_id integer;
BEGIN

CASE class_name
	WHEN 'ElectricalMedium' THEN
		inserted_id=citydb_view.utn9_insert_commodity_electrical_medium (
          id                           := p_id,
          gmlid                        := p_gmlid,
          gmlid_codespace              := p_gmlid_codespace,
          name                         := p_name,
          name_codespace               := p_name_codespace,
          description                  := p_description,
          owner                        := owner,
          type                         := type,
--          is_corrosive                 := is_corrosive,
--          is_explosive                 := is_explosive,
--          is_lighter_than_air          := is_lighter_than_air,
--          flammability_ratio           := flammability_ratio,
--          elec_conductivity_range_from := elec_conductivity_range_from,
--          elec_conductivity_range_to   := elec_conductivity_range_to,
--          elec_conductivity_range_unit := elec_conductivity_range_unit,
--          concentration                := concentration,
--          concentration_unit           := concentration_unit,
--          ph_value_range_from          := ph_value_range_from,
--          ph_value_range_to            := ph_value_range_to,
--          ph_value_range_unit          := ph_value_range_unit,
--          temperature_range_from       := temperature_range_from,
--          temperature_range_to         := temperature_range_to,
--          temperature_range_unit       := temperature_range_unit,
--          flow_rate_range_from         := flow_rate_range_from,
--          flow_rate_range_to           := flow_rate_range_to,
--          flow_rate_range_unit         := flow_rate_range_unit,
--          pressure_range_from          := pressure_range_from,
--          pressure_range_to            := pressure_range_to,
--          pressure_range_unit          := pressure_range_unit,
          voltage_range_from           := voltage_range_from,
          voltage_range_to             := voltage_range_to,
          voltage_range_unit           := voltage_range_unit,
          amperage_range_from          := amperage_range_from,
          amperage_range_to            := amperage_range_to,
          amperage_range_unit          := amperage_range_unit,
          bandwidth_range_from         := bandwidth_range_from,
          bandwidth_range_to           := bandwidth_range_to,
          bandwidth_range_unit         := bandwidth_range_unit,
          optical_mode                 := optical_mode,
          --		
	      schema_name                  :=p_schema_name
		);
	WHEN 'GaseousMedium' THEN
		inserted_id=citydb_view.utn9_insert_commodity_gaseous_medium (
          id                           := p_id,
          gmlid                        := p_gmlid,
          gmlid_codespace              := p_gmlid_codespace,
          name                         := p_name,
          name_codespace               := p_name_codespace,
          description                  := p_description,
          owner                        := owner,
          type                         := type,
--          is_corrosive                 := is_corrosive,
          is_explosive                 := is_explosive,
          is_lighter_than_air          := is_lighter_than_air,
--          flammability_ratio           := flammability_ratio,
          elec_conductivity_range_from := elec_conductivity_range_from,
          elec_conductivity_range_to   := elec_conductivity_range_to,
          elec_conductivity_range_unit := elec_conductivity_range_unit,
          concentration                := concentration,
          concentration_unit           := concentration_unit,
--          ph_value_range_from          := ph_value_range_from,
--          ph_value_range_to            := ph_value_range_to,
--          ph_value_range_unit          := ph_value_range_unit,
--          temperature_range_from       := temperature_range_from,
--          temperature_range_to         := temperature_range_to,
--          temperature_range_unit       := temperature_range_unit,
--          flow_rate_range_from         := flow_rate_range_from,
--          flow_rate_range_to           := flow_rate_range_to,
--          flow_rate_range_unit         := flow_rate_range_unit,
          pressure_range_from          := pressure_range_from,
          pressure_range_to            := pressure_range_to,
          pressure_range_unit          := pressure_range_unit,
--          voltage_range_from           := voltage_range_from,
--          voltage_range_to             := voltage_range_to,
--          voltage_range_unit           := voltage_range_unit,
--          amperage_range_from          := amperage_range_from,
--          amperage_range_to            := amperage_range_to,
--          amperage_range_unit          := amperage_range_unit,
--          bandwidth_range_from         := bandwidth_range_from,
--          bandwidth_range_to           := bandwidth_range_to,
--          bandwidth_range_unit         := bandwidth_range_unit,
--          optical_mode                 := optical_mode,
          --		
	      schema_name                  :=p_schema_name
		);
	WHEN 'LiquidMedium' THEN
		inserted_id=citydb_view.utn9_insert_commodity_liquid_medium (
          id                           := p_id,
          gmlid                        := p_gmlid,
          gmlid_codespace              := p_gmlid_codespace,
          name                         := p_name,
          name_codespace               := p_name_codespace,
          description                  := p_description,
          owner                        := owner,
          type                         := type,
          is_corrosive                 := is_corrosive,
          is_explosive                 := is_explosive,
          is_lighter_than_air          := is_lighter_than_air,
          flammability_ratio           := flammability_ratio,
          elec_conductivity_range_from := elec_conductivity_range_from,
          elec_conductivity_range_to   := elec_conductivity_range_to,
          elec_conductivity_range_unit := elec_conductivity_range_unit,
--          concentration                := concentration,
--          concentration_unit           := concentration_unit,
          ph_value_range_from          := ph_value_range_from,
          ph_value_range_to            := ph_value_range_to,
          ph_value_range_unit          := ph_value_range_unit,
          temperature_range_from       := temperature_range_from,
          temperature_range_to         := temperature_range_to,
          temperature_range_unit       := temperature_range_unit,
          flow_rate_range_from         := flow_rate_range_from,
          flow_rate_range_to           := flow_rate_range_to,
          flow_rate_range_unit         := flow_rate_range_unit,
          pressure_range_from          := pressure_range_from,
          pressure_range_to            := pressure_range_to,
          pressure_range_unit          := pressure_range_unit,
--          voltage_range_from           := voltage_range_from,
--          voltage_range_to             := voltage_range_to,
--          voltage_range_unit           := voltage_range_unit,
--          amperage_range_from          := amperage_range_from,
--          amperage_range_to            := amperage_range_to,
--          amperage_range_unit          := amperage_range_unit,
--          bandwidth_range_from         := bandwidth_range_from,
--          bandwidth_range_to           := bandwidth_range_to,
--          bandwidth_range_unit         := bandwidth_range_unit,
--          optical_mode                 := optical_mode,
          --		
	      schema_name                  :=p_schema_name
		);
	WHEN 'OpticalMedium' THEN
		inserted_id=citydb_view.utn9_insert_commodity_optical_medium (
          id                           := p_id,
          gmlid                        := p_gmlid,
          gmlid_codespace              := p_gmlid_codespace,
          name                         := p_name,
          name_codespace               := p_name_codespace,
          description                  := p_description,
          owner                        := owner,
          type                         := type,
--        is_corrosive                 := is_corrosive,
--        is_explosive                 := is_explosive,
--        is_lighter_than_air          := is_lighter_than_air,
--        flammability_ratio           := flammability_ratio,
--        elec_conductivity_range_from := elec_conductivity_range_from,
--        elec_conductivity_range_to   := elec_conductivity_range_to,
--        elec_conductivity_range_unit := elec_conductivity_range_unit,
--        concentration                := concentration,
--        concentration_unit           := concentration_unit,
--        ph_value_range_from          := ph_value_range_from,
--        ph_value_range_to            := ph_value_range_to,
--        ph_value_range_unit          := ph_value_range_unit,
--        temperature_range_from       := temperature_range_from,
--        temperature_range_to         := temperature_range_to,
--        temperature_range_unit       := temperature_range_unit,
--        flow_rate_range_from         := flow_rate_range_from,
--        flow_rate_range_to           := flow_rate_range_to,
--        flow_rate_range_unit         := flow_rate_range_unit,
--        pressure_range_from          := pressure_range_from,
--        pressure_range_to            := pressure_range_to,
--        pressure_range_unit          := pressure_range_unit,
--        voltage_range_from           := voltage_range_from,
--        voltage_range_to             := voltage_range_to,
--        voltage_range_unit           := voltage_range_unit,
--        amperage_range_from          := amperage_range_from,
--        amperage_range_to            := amperage_range_to,
--        amperage_range_unit          := amperage_range_unit,
          bandwidth_range_from         := bandwidth_range_from,
          bandwidth_range_to           := bandwidth_range_to,
          bandwidth_range_unit         := bandwidth_range_unit,
          optical_mode                 := optical_mode,
          --		
	      schema_name                  :=p_schema_name
		);
	WHEN 'SolidMedium' THEN
		inserted_id=citydb_view.utn9_insert_commodity_solid_medium (
          id                           := p_id,
          gmlid                        := p_gmlid,
          gmlid_codespace              := p_gmlid_codespace,
          name                         := p_name,
          name_codespace               := p_name_codespace,
          description                  := p_description,
          owner                        := owner,
          type                         := type,
--          is_corrosive                 := is_corrosive,
          is_explosive                 := is_explosive,
--          is_lighter_than_air          := is_lighter_than_air,
          flammability_ratio           := flammability_ratio,
          elec_conductivity_range_from := elec_conductivity_range_from,
          elec_conductivity_range_to   := elec_conductivity_range_to,
          elec_conductivity_range_unit := elec_conductivity_range_unit,
          concentration                := concentration,
          concentration_unit           := concentration_unit,
--          ph_value_range_from          := ph_value_range_from,
--          ph_value_range_to            := ph_value_range_to,
--          ph_value_range_unit          := ph_value_range_unit,
--          temperature_range_from       := temperature_range_from,
--          temperature_range_to         := temperature_range_to,
--          temperature_range_unit       := temperature_range_unit,
--          flow_rate_range_from         := flow_rate_range_from,
--          flow_rate_range_to           := flow_rate_range_to,
--          flow_rate_range_unit         := flow_rate_range_unit,
          pressure_range_from          := pressure_range_from,
          pressure_range_to            := pressure_range_to,
          pressure_range_unit          := pressure_range_unit,
--          voltage_range_from           := voltage_range_from,
--          voltage_range_to             := voltage_range_to,
--          voltage_range_unit           := voltage_range_unit,
--          amperage_range_from          := amperage_range_from,
--          amperage_range_to            := amperage_range_to,
--          amperage_range_unit          := amperage_range_unit,
--          bandwidth_range_from         := bandwidth_range_from,
--          bandwidth_range_to           := bandwidth_range_to,
--          bandwidth_range_unit         := bandwidth_range_unit,
--          optical_mode                 := optical_mode,
          --		
	      schema_name                  :=p_schema_name
		);
	ELSE
	RAISE EXCEPTION 'classname "%" not valid', class_name USING HINT = 'Valid values are "ElectricalMedium", "GaseousMedium", "LiquidMedium", "OpticalMedium", "SolidMedium"';
END CASE;
RETURN inserted_id;
EXCEPTION
  WHEN OTHERS THEN RAISE NOTICE 'citydb_view.utn9_insert_commodity(): %', SQLERRM;
END;
$$ LANGUAGE plpgsql VOLATILE;

-- ***********************************************************************
-- ***********************************************************************

DO
$$
BEGIN
RAISE NOTICE '

********************************

Utility Network ADE view functions installation complete!

********************************

';
END
$$;
SELECT 'Utility Network ADE view functions installed correctly!'::varchar AS installation_result;


-- ***********************************************************************
-- ***********************************************************************
--
-- END OF FILE
--
-- ***********************************************************************
-- ***********************************************************************