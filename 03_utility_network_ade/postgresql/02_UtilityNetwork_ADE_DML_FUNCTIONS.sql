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
-- **************** 02_UtilityNetworks_ADE_DML_FUNCTIONS.sql *************
--
-- This script adds stored procedures for delete and insert operations
-- to the citydb_pkg schema. They are all prefixed with "utn9_".
--
-- ***********************************************************************
-- ***********************************************************************

----------------------------------------------------------------
-- Function DELETE_NODE
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_pkg.utn9_delete_node(integer,varchar);
CREATE OR REPLACE FUNCTION citydb_pkg.utn9_delete_node(
	o_id integer,
	schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer
AS $$
DECLARE
	deleted_id integer;
BEGIN
-- DELETE first all referencing Links
EXECUTE format('DELETE FROM %I.utn9_link WHERE start_node_id=%L OR end_node_id=%L', schema_name, o_id, o_id);
-- Delete node itself
EXECUTE format('DELETE FROM %I.utn9_node WHERE id = %L RETURNING id', schema_name, o_id) INTO deleted_id;
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.utn9_delete_node (id: %): %', o_id, SQLERRM;
END;
$$ LANGUAGE plpgsql;
-- ALTER FUNCTION citydb_pkg.utn9_delete_node(integer,varchar) OWNER TO postgres;

----------------------------------------------------------------
-- Function DELETE_LINK
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_pkg.utn9_delete_link(integer,varchar);
CREATE OR REPLACE FUNCTION citydb_pkg.utn9_delete_link(
	o_id integer,
	schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer
AS $$
DECLARE
	deleted_id integer;
BEGIN
EXECUTE format('DELETE FROM %I.utn9_link WHERE id=%L RETURNING id', schema_name, o_id) INTO deleted_id;
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.utn9_delete_link (id: %): %', o_id, SQLERRM;
END;
$$ LANGUAGE plpgsql;
-- ALTER FUNCTION citydb_pkg.utn9_delete_link(integer,varchar) OWNER TO postgres;

----------------------------------------------------------------
-- Function DELETE_FEATURE_GRAPH
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_pkg.utn9_delete_feature_graph(integer,varchar);
CREATE OR REPLACE FUNCTION citydb_pkg.utn9_delete_feature_graph(
	o_id integer,
	schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer
AS $$
DECLARE
  n_id integer;
  l_id integer;
  deleted_id integer;
BEGIN
-- Delete the depending links
FOR l_id IN EXECUTE format('SELECT id FROM %I.utn9_link WHERE feat_graph_id = %L', schema_name, o_id) LOOP
  IF l_id IS NOT NULL THEN
    EXECUTE 'SELECT citydb_pkg.utn9_delete_link($1, $2)' USING l_id, schema_name;
  END IF;
END LOOP;
-- Delete the depending nodes
FOR n_id IN EXECUTE format('SELECT id FROM %I.utn9_node WHERE feat_graph_id = %L', schema_name, o_id) LOOP
  IF n_id IS NOT NULL THEN
    EXECUTE 'SELECT citydb_pkg.utn9_delete_node($1, $2)' USING n_id, schema_name;
  END IF;
END LOOP;
-- Delete the feature_graph itself
EXECUTE format('DELETE FROM %I.utn9_feature_graph WHERE id=%L RETURNING id', schema_name, o_id) INTO deleted_id;
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.utn9_delete_feature_graph (id: %): %', o_id, SQLERRM;
END;
$$ LANGUAGE plpgsql;
-- ALTER FUNCTION citydb_pkg.utn9_delete_feature_graph(integer,varchar) OWNER TO postgres;

----------------------------------------------------------------
-- Function DELETE_NETWORK_FEATURE
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_pkg.utn9_delete_network_feature(integer,varchar);
CREATE OR REPLACE FUNCTION citydb_pkg.utn9_delete_network_feature(
	o_id integer,
	schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer
AS $$
DECLARE
	class_id integer;
	classname varchar;
  nf_id integer;
  fg_id integer;
  hs_id integer;
	deleted_id integer;
BEGIN
EXECUTE format('SELECT objectclass_id FROM %I.cityobject WHERE id=%L', schema_name, o_id) INTO class_id;
EXECUTE format('SELECT citydb_pkg.get_classname(%L, %L)', class_id, schema_name) INTO classname;
--RAISE NOTICE 'class id %, classname %', class_id, classname;
IF classname IS NOT NULL THEN
  CASE
		WHEN classname IN ('Bedding', 'RectangularShell', 'RoundShell', 'OtherShell') THEN
    -- delete the contained network features
      FOR nf_id IN EXECUTE format('SELECT id FROM %I.utn9_network_feature WHERE prot_element_id=%L', schema_name, o_id) LOOP
        IF nf_id IS NOT NULL THEN
          EXECUTE format('DELETE FROM %I.utn9_network_feature WHERE id=%L', schema_name, nf_id);
        END IF;
      END LOOP;
--	  WHEN classname IN ('Cable', 'Canal', 'SemiOpenCanal', 'RoundPipe', 'RectangularPipe', 'OtherShapePipe') THEN
--		WHEN classname IN ('ComplexFunctionalElement') THEN
--		WHEN classname IN ('SimpleFunctionalElement') THEN
--		WHEN classname IN ('TerminalElement') THEN
--		WHEN classname IN ('StorageDevice', 'TechDevice', 'MeasurementDevice', 'ControllerDevice', 'AnyDevice') THEN
	ELSE
		-- do nothing
	END CASE;

-- Delete the depending (sub)network_feature(s)
EXECUTE format('SELECT citydb_pkg.utn9_delete_network_feature(id, %L) FROM %I.utn9_network_feature WHERE id != %L AND ntw_feature_parent_id = %L', schema_name, schema_name, o_id, o_id);

-- Delete the depending hollow_spaces(s)
EXECUTE format('SELECT id FROM %I.utn9_hollow_space WHERE ntw_feature_id=%L', schema_name, o_id) INTO hs_id;
IF hs_id IS NOT NULL THEN
  EXECUTE 'SELECT citydb_pkg.utn9_delete_hollow_space($1, $2)' USING hs_id, schema_name;
END IF;

-- No need to delete reference to material (on delete cascade in m:n table)
-- No need to delete reference to network (on delete cascade in m:n table)

-- Delete the depending feature_graph (topology)
EXECUTE format('SELECT id FROM %I.utn9_feature_graph WHERE ntw_feature_id=%L', schema_name, o_id) INTO fg_id;
IF fg_id IS NOT NULL THEN
  EXECUTE 'SELECT citydb_pkg.utn9_delete_feature_graph($1, $2)' USING fg_id, schema_name;
END IF;

-- Delete the network_feature itself
EXECUTE format('DELETE FROM %I.utn9_network_feature WHERE id=%L RETURNING id', schema_name, o_id) INTO deleted_id;
-- conduct general cleaning of cityobject
EXECUTE 'SELECT citydb_pkg.intern_delete_cityobject($1, $2)' USING o_id, schema_name;
RETURN deleted_id;

END IF;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.utn9_delete_network_graph (id: %): %', o_id, SQLERRM;
END;
$$ LANGUAGE plpgsql;
-- ALTER FUNCTION citydb_pkg.utn9_delete_network_graph(integer,varchar) OWNER TO postgres;

----------------------------------------------------------------
-- Function DELETE_NETWORK_GRAPH
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_pkg.utn9_delete_network_graph(integer,varchar);
CREATE OR REPLACE FUNCTION citydb_pkg.utn9_delete_network_graph(
	o_id integer,
	schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer
AS $$
DECLARE
  l_id integer;
	fg_id integer;
	deleted_id integer;
BEGIN
-- Delete the depending InterFeatureLink(s)
FOR l_id IN EXECUTE format('SELECT id FROM %I.utn9_link WHERE ntw_graph_id=%L', schema_name, o_id) LOOP
	IF l_id IS NOT NULL THEN
		EXECUTE 'SELECT citydb_pkg.utn9_delete_link($1, $2)' USING l_id, schema_name;
	END IF;
END LOOP;
-- Delete the depending feature_graph(s)
FOR fg_id IN EXECUTE format('SELECT id FROM %I.utn9_feature_graph WHERE ntw_graph_id=%L', schema_name, o_id) LOOP
	IF fg_id IS NOT NULL THEN
		EXECUTE 'SELECT citydb_pkg.utn9_delete_feature_graph($1, $2)' USING fg_id, schema_name;
	END IF;
END LOOP;
-- Delete the network_graph itself
EXECUTE format('DELETE FROM %I.utn9_network_graph WHERE id=%L RETURNING id', schema_name, o_id) INTO deleted_id;
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.utn9_delete_network_graph (id: %): %', o_id, SQLERRM;
END;
$$ LANGUAGE plpgsql;
-- ALTER FUNCTION citydb_pkg.utn9_delete_network_graph(integer,varchar) OWNER TO postgres;

----------------------------------------------------------------
-- Function DELETE_NETWORK
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_pkg.utn9_delete_network(integer,varchar);
CREATE OR REPLACE FUNCTION citydb_pkg.utn9_delete_network(
  o_id integer,
  schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer
AS $$
DECLARE
--  nf_id integer;
  ng_id integer;
  co_id integer;
  deleted_id integer;
BEGIN
-- No need to delete reference to supply_area (on delete cascade in network_to_supply_area table)
-- No need to delete reference to super/sub-ordinate_network (on delete cascade)
-- No need to delete reference in table role_in_network (on delete cascade)

-- delete subnetworks (if there are any)
EXECUTE format('SELECT citydb_pkg.utn9_delete_network(id, %L) FROM %I.utn9_network WHERE id != %L AND network_parent_id = %L', schema_name, schema_name, o_id, o_id);

-- Delete the depending commodity (if not referenced by another network)
EXECUTE format('SELECT commodity_id FROM %I.utn9_network WHERE id=%L', schema_name, o_id) INTO co_id;
IF co_id IS NOT NULL THEN
	IF citydb_pkg.is_not_referenced('utn9_network','commodity_id', co_id, 'id', o_id, schema_name) IS TRUE THEN
    EXECUTE 'SELECT citydb_pkg.utn9_delete_commodity($1, $2)' USING schema_name, co_id;
  END IF;
END IF;

-- Delete the depending network_features (if they are not referenced by some other network)
EXECUTE format('SELECT citydb_pkg.utn9_delete_network_feature(nf.id, %L) FROM %I.utn9_network_feature AS nf, %I.utn9_network_to_network_feature AS n2nf WHERE
nf.id=n2nf.network_feature_id AND n2nf.network_id=%L AND citydb_pkg.is_not_referenced(''utn9_network_to_network_feature'', ''network_feature_id'', nf.id, ''network_id'', %L, %L)',
schema_name, schema_name, schema_name, o_id, o_id, schema_name);
--FOR nf_id IN EXECUTE format('SELECT network_feature_id FROM %I.utn9_network_to_network_feature WHERE network_id=%L ORDER BY network_feature_id', schema_name, o_id) LOOP
--	IF nf_id IS NOT NULL THEN
--	  IF citydb_pkg.is_not_referenced('utn9_network_to_network_feature','network_feature_id', nf_id, 'network_id', o_id, schema_name) IS TRUE THEN
--		  EXECUTE 'SELECT citydb_pkg.utn9_delete_network_feature($1, $2)' USING nf_id, schema_name;
--		END IF;	
--	END IF;
--END LOOP;

-- Delete the depending network_graph
EXECUTE format('SELECT id FROM %I.utn9_network_graph WHERE network_id=%L', schema_name, o_id) INTO ng_id;
IF ng_id IS NOT NULL THEN
  EXECUTE 'SELECT citydb_pkg.utn9_delete_network_graph($1, $2)' USING ng_id, schema_name;
END IF;
-- Delete the network itself
EXECUTE format('DELETE FROM %I.utn9_network WHERE id=%L RETURNING id', schema_name, o_id) INTO deleted_id;
-- conduct general cleaning of cityobject
EXECUTE 'SELECT citydb_pkg.intern_delete_cityobject($1, $2)' USING o_id, schema_name;
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.utn9_delete_network (id: %): %', o_id, SQLERRM;
END;
$$ LANGUAGE plpgsql;
-- ALTER FUNCTION citydb_pkg.utn9_delete_network(integer,varchar) OWNER TO postgres;

----------------------------------------------------------------
-- Function DELETE_SUPPLY_AREA
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_pkg.utn9_delete_supply_area(integer,varchar);
CREATE OR REPLACE FUNCTION citydb_pkg.utn9_delete_supply_area(
	o_id integer,
	delete_members integer DEFAULT 0,
	schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer
AS $$
DECLARE
	deleted_id integer;
BEGIN
-- Call the delete_cityobjectgroup function, as a supply_area is a cityobjectgroup
EXECUTE 'SELECT citydb_pkg.delete_cityobjectgroup($1, $2, $3)' INTO deleted_id USING o_id, delete_members, schema_name;
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.utn9_delete_supply_area (id: %): %', o_id, SQLERRM;
END;
$$ LANGUAGE plpgsql;
-- ALTER FUNCTION citydb_pkg.utn9_delete_supply_area(integer,varchar) OWNER TO postgres;

----------------------------------------------------------------
-- Function DELETE_MEDIUM_SUPPLY
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_pkg.utn9_delete_medium_supply(integer,varchar);
CREATE OR REPLACE FUNCTION citydb_pkg.utn9_delete_medium_supply(
	o_id integer,
	schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer
AS $$
DECLARE
  st_id integer;
	deleted_id integer;
BEGIN
-- Delete the depending storage
FOR st_id IN EXECUTE format('SELECT id FROM %I.utn9_storage WHERE medium_supply_id=%L ORDER BY id', schema_name, o_id) LOOP
	IF st_id IS NOT NULL THEN
    EXECUTE 'SELECT citydb_pkg.utn9_delete_storage($1, $2)' USING st_id, schema_name;
	END IF;
END LOOP;

-- Delete the medium_supply itself
EXECUTE format('DELETE FROM %I.utn9_medium_supply WHERE id=%L RETURNING id', schema_name, o_id) INTO deleted_id;
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.utn9_delete_medium_supply (id: %): %', o_id, SQLERRM;
END;
$$ LANGUAGE plpgsql;
-- ALTER FUNCTION citydb_pkg.utn9_delete_medium_supply(integer,varchar) OWNER TO postgres;

----------------------------------------------------------------
-- Function DELETE_STORAGE
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_pkg.utn9_delete_storage(integer,varchar);
CREATE OR REPLACE FUNCTION citydb_pkg.utn9_delete_storage(
	o_id integer,
	schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer
AS $$
DECLARE
	deleted_id integer;
BEGIN
-- Delete the storage itself
EXECUTE format('DELETE FROM %I.utn9_storage WHERE id=%L RETURNING id', schema_name, o_id) INTO deleted_id;
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.utn9_delete_storage (id: %): %', o_id, SQLERRM;
END;
$$ LANGUAGE plpgsql;
-- ALTER FUNCTION citydb_pkg.utn9_delete_storage(integer,varchar) OWNER TO postgres;

----------------------------------------------------------------
-- Function DELETE_UTN_BUILDING
----------------------------------------------------------------
-- *** PLEASE NOTE: utn-building is deleted automatically upon delete of table building
DROP FUNCTION IF EXISTS    citydb_pkg.utn9_delete_building(integer,varchar);
CREATE OR REPLACE FUNCTION citydb_pkg.utn9_delete_building(
	o_id integer,
	schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer
AS $$
DECLARE
	deleted_id integer;
BEGIN
-- Delete the utn_building itself
EXECUTE format('DELETE FROM %I.utn9_building WHERE id=%L RETURNING id', schema_name, o_id) INTO deleted_id;
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.utn9_delete_building (id: %): %', o_id, SQLERRM;
END;
$$ LANGUAGE plpgsql;
-- ALTER FUNCTION citydb_pkg.utn9_delete_building(integer,varchar) OWNER TO postgres;

----------------------------------------------------------------
-- Function DELETE_COMMODITY_CLASSIFIER
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_pkg.utn9_delete_commodity_classifier(integer,varchar);
CREATE OR REPLACE FUNCTION citydb_pkg.utn9_delete_commodity_classifier(
	o_id integer,
	schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer
AS $$
DECLARE
  cc_id integer;
	deleted_id integer;
BEGIN
-- Delete the depending commodity_classifier (if not referenced anymore)
FOR cc_id IN EXECUTE format('SELECT comm_class_id FROM %I.utn9_comm_class_to_comm_class WHERE comm_class_parent_id=%L ORDER BY comm_class_parent_id', schema_name, o_id) LOOP
	IF cc_id IS NOT NULL THEN
	  IF citydb_pkg.is_not_referenced('utn9_comm_class_to_comm_class','comm_class_id', cc_id, 'comm_class_parent_id', o_id, schema_name) IS TRUE THEN
		  EXECUTE 'SELECT citydb_pkg.utn9_delete_commodity_classifier($1, $2)' USING cc_id, schema_name;
		END IF;	
	END IF;
END LOOP;

-- Delete the commodity_classifier itself
EXECUTE format('DELETE FROM %I.utn9_commodity_classifier WHERE id=%L RETURNING id', schema_name, o_id) INTO deleted_id;
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.utn9_delete_commodity_classifier (id: %): %', o_id, SQLERRM;
END;
$$ LANGUAGE plpgsql;
-- ALTER FUNCTION citydb_pkg.utn9_delete_commodity_classifier(integer,varchar) OWNER TO postgres;

----------------------------------------------------------------
-- Function DELETE_MATERIAL
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_pkg.utn9_delete_material(integer,varchar);
CREATE OR REPLACE FUNCTION citydb_pkg.utn9_delete_material(
	o_id integer,
	schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer
AS $$
DECLARE
  cc_id integer;
	deleted_id integer;
BEGIN
-- Delete the depending material(s)
EXECUTE format('SELECT citydb_pkg.utn9_delete_material(id, %L) FROM %I.utn9_material WHERE id != %L AND material_parent_id = %L', schema_name, schema_name, o_id, o_id);

-- Delete the depending commodity_classifier(s)
FOR cc_id IN EXECUTE format('SELECT id FROM %I.utn9_commodity_classifier WHERE material_id=%L ORDER BY id', schema_name, o_id) LOOP
	IF cc_id IS NOT NULL THEN
	  EXECUTE 'SELECT citydb_pkg.utn9_delete_commodity_classifier($1, $2)' USING cc_id, schema_name;
	END IF;
END LOOP;

-- Delete the material itself
EXECUTE format('DELETE FROM %I.utn9_material WHERE id=%L RETURNING id', schema_name, o_id) INTO deleted_id;
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.utn9_delete_material (id: %): %', o_id, SQLERRM;
END;
$$ LANGUAGE plpgsql;
-- ALTER FUNCTION citydb_pkg.utn9_delete_material(integer,varchar) OWNER TO postgres;

----------------------------------------------------------------
-- Function DELETE_COMMODITY
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_pkg.utn9_delete_commodity(integer,varchar);
CREATE OR REPLACE FUNCTION citydb_pkg.utn9_delete_commodity(
	o_id integer,
	schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer
AS $$
DECLARE
	cc_id integer;
	deleted_id integer;
BEGIN
-- Delete the depending commodity_classifier
FOR cc_id IN EXECUTE format('SELECT id FROM %I.utn9_commodity_classifier WHERE commodity_id=%L ORDER BY id', schema_name, o_id) LOOP
	IF cc_id IS NOT NULL THEN
	  EXECUTE 'SELECT citydb_pkg.utn9_delete_commodity_classifier($1, $2)' USING cc_id, schema_name;
	END IF;
END LOOP;

-- Delete the commodity itself
EXECUTE format('DELETE FROM %I.utn9_commodity WHERE id=%L RETURNING id', schema_name, o_id) INTO deleted_id;
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.utn9_delete_commodity (id: %): %', o_id, SQLERRM;
END;
$$ LANGUAGE plpgsql;
-- ALTER FUNCTION citydb_pkg.utn9_delete_commodity(integer,varchar) OWNER TO postgres;

----------------------------------------------------------------
-- Function DELETE_HOLLOW_SPACE
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_pkg.utn9_delete_hollow_space(integer,varchar);
CREATE OR REPLACE FUNCTION citydb_pkg.utn9_delete_hollow_space(
	o_id integer,
	schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer
AS $$
DECLARE
	cc_id integer;
	deleted_id integer;
BEGIN
-- Delete the depending hollow space(s)
EXECUTE format('SELECT citydb_pkg.utn9_delete_hollow_space(id, %L) FROM %I.utn9_hollow_space WHERE id != %L AND hol_spc_parent_id = %L', schema_name, schema_name, o_id, o_id);

-- Delete the depending commodity_classifier
FOR cc_id IN EXECUTE format('SELECT id FROM %I.utn9_commodity_classifier WHERE hollow_space_id=%L ORDER BY id', schema_name, o_id) LOOP
	IF cc_id IS NOT NULL THEN
	  EXECUTE 'SELECT citydb_pkg.utn9_delete_commodity_classifier($1, $2)' USING cc_id, schema_name;
	END IF;
END LOOP;

-- Delete the hollow_space itself
EXECUTE format('DELETE FROM %I.utn9_hollow_space WHERE id=%L RETURNING id', schema_name, o_id) INTO deleted_id;
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.utn9_delete_hollow_space (id: %): %', o_id, SQLERRM;
END;
$$ LANGUAGE plpgsql;
-- ALTER FUNCTION citydb_pkg.utn9_delete_hollow_space(integer,varchar) OWNER TO postgres;

----------------------------------------------------------------
-- Function DELETE_ROLE_IN_NETWORK
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_pkg.utn9_delete_role_in_network(integer,varchar);
CREATE OR REPLACE FUNCTION citydb_pkg.utn9_delete_role_in_network(
	o_id integer,
	schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer
AS $$
DECLARE
	deleted_id integer;
BEGIN
-- Delete the role_in_network itself
EXECUTE format('DELETE FROM %I.utn9_role_in_network WHERE id=%L RETURNING id', schema_name, o_id) INTO deleted_id;
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.utn9_delete_role_in_network (id: %): %', o_id, SQLERRM;
END;
$$ LANGUAGE plpgsql;
-- ALTER FUNCTION citydb_pkg.utn9_delete_role_in_network(integer,varchar) OWNER TO postgres;

----------------------------------------------------------------
-- Function GET_ENVELOPE_NETWORK_FEATURE
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_pkg.utn9_get_envelope_network_feature(integer, integer, varchar);
CREATE OR REPLACE FUNCTION citydb_pkg.utn9_get_envelope_network_feature(
	co_id integer,
	set_envelope integer DEFAULT 0,
	schema_name varchar DEFAULT 'citydb'::varchar)
  RETURNS geometry AS
$BODY$
DECLARE
	envelope GEOMETRY;
BEGIN
-- get the geometries and aggregate them and extract the 3D envelope
EXECUTE format('WITH collect_geom AS (
SELECT geom FROM %I.utn9_network_feature WHERE id = %L AND geom IS NOT NULL
) SELECT citydb_pkg.box2envelope(ST_3DExtent(geom)) AS envelope3d FROM collect_geom',
schema_name, co_id)
INTO envelope;

IF set_envelope <> 0 THEN
	IF envelope IS NOT NULL THEN
		EXECUTE format('UPDATE %I.cityobject SET envelope = %L WHERE id = %L', schema_name, envelope, co_id);
	END IF;
END IF;

RETURN envelope;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.utn9_get_envelope_network_feature (id: %): %', co_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql;
--ALTER FUNCTION citydb_pkg.utn9_get_envelope_network_feature(integer, integer, varchar) OWNER TO postgres;

----------------------------------------------------------------
-- Function GET_ENVELOPE_NETWORK
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_pkg.utn9_get_envelope_network(integer, integer, varchar);
CREATE OR REPLACE FUNCTION citydb_pkg.utn9_get_envelope_network(
	co_id integer,
	set_envelope integer DEFAULT 0,
	schema_name varchar DEFAULT 'citydb'::varchar)
  RETURNS geometry AS
$BODY$
DECLARE
	envelope GEOMETRY;
BEGIN
-- get the geometries and aggregate them and extract the 3D envelope
EXECUTE format('WITH collect_geom AS (
SELECT nf.geom
FROM citydb.utn9_network_feature nf JOIN citydb.utn9_network_to_network_feature nnf ON nnf.network_feature_id = nf.id
WHERE nnf.network_id = %L AND nf.geom IS NOT NULL
) SELECT citydb_pkg.box2envelope(ST_3DExtent(geom)) AS envelope3d FROM collect_geom',
schema_name, co_id)
INTO envelope;

IF set_envelope <> 0 THEN
	IF envelope IS NOT NULL THEN
		EXECUTE format('UPDATE %I.cityobject SET envelope = %L WHERE id = %L', schema_name, envelope, co_id);
	END IF;
END IF;

RETURN envelope;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.utn9_get_envelope_network (id: %): %', co_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql;
--ALTER FUNCTION citydb_pkg.utn9_get_envelope_network(integer, integer, varchar) OWNER TO postgres;

----------------------------------------------------------------
-- Function GET_ENVELOPE_SUPPLY_AREA
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_pkg.utn9_get_envelope_supply_area(integer, integer, integer, varchar);
CREATE OR REPLACE FUNCTION citydb_pkg.utn9_get_envelope_supply_area(
  co_id integer,
  set_envelope integer DEFAULT 0,
  calc_member_envelopes integer DEFAULT 1,	
  schema_name varchar DEFAULT 'citydb'::varchar)
  RETURNS geometry AS
$BODY$
DECLARE
	envelope GEOMETRY;
BEGIN
-- get the geometries and aggregate them and extract the 3D envelope
EXECUTE 'citydb_pkg.get_envelope_cityobjectgroup($1, $2, $3, $4)' INTO envelope 
  USING co_id, set_envelope, calc_member_envelopes, schema_name;

RETURN envelope;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.utn9_get_envelope_supply_area (id: %): %', co_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql;
--ALTER FUNCTION citydb_pkg.utn9_get_envelope_supply_area(integer, integer, integer, varchar) OWNER TO postgres;

-- ***********************************************************************
-- ***********************************************************************

----------------------------------------------------------------
-- Function UTN9_INSERT_NETWORK_TO_SUPPLY_AREA
----------------------------------------------------------------
-- DROP FUNCTION IF EXISTS citydb_pkg.utn9_insert_network_to_supply_area (integer, integer) CASCADE;
CREATE OR REPLACE FUNCTION citydb_pkg.utn9_insert_network_to_supply_area (
  network_id     integer,
  supply_area_id integer,
--	
  schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS void
AS $$
DECLARE
  p_network_id     integer := network_id;
  p_supply_area_id integer := supply_area_id;
--
  p_schema_name varchar := schema_name;
BEGIN
EXECUTE format('
INSERT INTO %I.utn9_network_to_supply_area (
 network_id,
 supply_area_id
) VALUES (
%L, %L
)',
p_schema_name,
p_network_id, 
p_supply_area_id
) ;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.utn9_insert_network_to_supply_area (network_id: %, supply_area_id: %): %', network_id, supply_area_id, SQLERRM;
END;
$$ LANGUAGE 'plpgsql';

----------------------------------------------------------------
-- Function UTN9_INSERT_NETWORK_GRAPH
----------------------------------------------------------------
-- DROP FUNCTION IF EXISTS citydb_pkg.utn9_insert_network_graph (integer, integer, character varying, character varying, character varying, character varying, text, integer) CASCADE;
CREATE OR REPLACE FUNCTION citydb_pkg.utn9_insert_network_graph (
  objectclass_id  integer,
  id              integer DEFAULT NULL,
  gmlid           varchar DEFAULT NULL,
  gmlid_codespace varchar DEFAULT NULL,
  name            varchar DEFAULT NULL,
  name_codespace  varchar DEFAULT NULL,
  description     text DEFAULT NULL,
  network_id      integer DEFAULT NULL,
--	
  schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer
AS $$
DECLARE
  p_id              integer := id;
  p_objectclass_id  integer := objectclass_id;
  p_gmlid           varchar := gmlid;
  p_gmlid_codespace varchar := gmlid_codespace;
  p_name            varchar := name;
  p_name_codespace  varchar := name_codespace;
  p_description     text:= description;
  p_network_id      integer := network_id;
--	
  p_schema_name varchar := schema_name;
  seq_name varchar;
  inserted_id integer;
BEGIN
-- IF the ID is not given, then generate a new one.
IF p_id IS NULL THEN
  seq_name=schema_name||'.utn9_network_graph_id_seq';
  p_id=nextval(seq_name::regclass);
END IF;
-- IF the GmlID is not given, then generate a new one.
IF p_gmlid IS NULL THEN
  p_gmlid='UUID_'||uuid_generate_v4();
END IF;

EXECUTE format('
INSERT INTO %I.utn9_network_graph (
 id,
 objectclass_id,
 gmlid,
 gmlid_codespace,
 name,
 name_codespace,
 description,
 network_id
) VALUES (
%L, %L, %L, %L, %L, %L, %L, %L
) RETURNING id',
p_schema_name,
p_id, 
p_objectclass_id, 
p_gmlid, 
p_gmlid_codespace, 
p_name, 
p_name_codespace, 
p_description, 
p_network_id
) INTO inserted_id;
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.utn9_insert_network_graph (id: %): %', p_id, SQLERRM;
END;
$$ LANGUAGE 'plpgsql';

----------------------------------------------------------------
-- Function UTN9_INSERT_DISTRIB_ELEMENT
----------------------------------------------------------------
--DROP FUNCTION IF EXISTS citydb_pkg.utn9_insert_distrib_element (integer, integer, numeric, numeric, numeric, numeric, varchar, numeric, varchar, numeric, varchar, numeric, varchar, numeric, varchar, numeric, varchar, numeric, varchar, numeric, numeric, varchar, varchar) CASCADE;
CREATE OR REPLACE FUNCTION citydb_pkg.utn9_insert_distrib_element (
  id                 integer,
  objectclass_id     integer,
  function_of_line   varchar DEFAULT NULL,
  is_gravity         numeric DEFAULT NULL,
  is_transmission    numeric DEFAULT NULL,
  is_communication   numeric DEFAULT NULL,
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
  int_diameter       numeric DEFAULT NULL,
  int_diameter_unit  varchar DEFAULT NULL,
  cross_section      numeric DEFAULT NULL,
  cross_section_unit varchar DEFAULT NULL,
  slope_range_from   numeric DEFAULT NULL,
  slope_range_to     numeric DEFAULT NULL,
  slope_range_unit   varchar DEFAULT NULL,
  profile_name       varchar DEFAULT NULL,
--	
  schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer
AS $$
DECLARE
  p_id                 integer := id                ;
  p_objectclass_id     integer := objectclass_id    ;
  p_function_of_line   varchar := function_of_line  ;
  p_is_gravity         numeric := is_gravity        ;
  p_is_transmission    numeric := is_transmission   ;
  p_is_communication   numeric := is_communication  ;
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
  p_int_diameter       numeric := int_diameter      ;
  p_int_diameter_unit  varchar := int_diameter_unit ;
  p_cross_section      numeric := cross_section     ;
  p_cross_section_unit varchar := cross_section_unit;
  p_slope_range_from   numeric := slope_range_from  ;
  p_slope_range_to     numeric := slope_range_to    ;
  p_slope_range_unit   varchar := slope_range_unit  ;
  p_profile_name       varchar := profile_name      ;
--
  p_schema_name varchar := schema_name;
  inserted_id integer;
BEGIN
EXECUTE format('
INSERT INTO %I.utn9_distrib_element (
 id                ,
 objectclass_id    ,
 function_of_line  ,
 is_gravity        ,
 is_transmission   ,
 is_communication  ,
 ext_width         ,
 ext_width_unit    ,
 ext_height        ,
 ext_height_unit   ,
 ext_diameter      ,
 ext_diameter_unit ,
 int_width         ,
 int_width_unit    ,
 int_height        ,
 int_height_unit   ,
 int_diameter      ,
 int_diameter_unit ,
 cross_section     ,
 cross_section_unit,
 slope_range_from  ,
 slope_range_to    ,
 slope_range_unit  ,
 profile_name
) VALUES (
%L, %L, %L, %L, %L, %L, %L, %L, %L, %L,
%L, %L, %L, %L, %L, %L, %L, %L, %L, %L,
%L, %L, %L, %L
) RETURNING id',
p_schema_name,
p_id                , 
p_objectclass_id    , 
p_function_of_line  ,
p_is_gravity        , 
p_is_transmission   , 
p_is_communication  , 
p_ext_width         , 
p_ext_width_unit    , 
p_ext_height        , 
p_ext_height_unit   , 
p_ext_diameter      , 
p_ext_diameter_unit , 
p_int_width         , 
p_int_width_unit    , 
p_int_height        , 
p_int_height_unit   , 
p_int_diameter      , 
p_int_diameter_unit , 
p_cross_section     , 
p_cross_section_unit, 
p_slope_range_from  , 
p_slope_range_to    , 
p_slope_range_unit  , 
p_profile_name
) INTO inserted_id;
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.utn9_insert_distrib_element (id: %): %', p_id, SQLERRM;
END;
$$ LANGUAGE 'plpgsql';

----------------------------------------------------------------
-- Function UTN9_INSERT_NETWORK_TO_NETWORK_FEATURE
----------------------------------------------------------------
-- DROP FUNCTION IF EXISTS citydb_pkg.utn9_insert_network_to_network_feature (integer, integer) CASCADE;
CREATE OR REPLACE FUNCTION citydb_pkg.utn9_insert_network_to_network_feature (
  network_id   integer,
  network_feature_id   integer,
--
  schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS void
AS $$
DECLARE
  p_network_id integer := network_id;
  p_network_feature_id integer := network_feature_id;
--	
  p_schema_name varchar := schema_name;
BEGIN
EXECUTE format('
INSERT INTO %I.utn9_network_to_network_feature (
 network_id,
 network_feature_id
) VALUES (
%L, %L
)',
p_schema_name,
p_network_id,
p_network_feature_id
);
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.utn9_insert_network_to_network_feature (network_id: %, network_feature_id: %): %', network_id, network_feature_id, SQLERRM;
END;
$$ LANGUAGE 'plpgsql';

----------------------------------------------------------------
-- Function UTN9_INSERT_MEDIUM_SUPPLY
----------------------------------------------------------------
-- DROP FUNCTION IF EXISTS citydb_pkg.utn9_insert_medium_supply (integer, integer, varchar, numeric, numeric, varchar, numeric, numeric, varchar, integer) CASCADE;
CREATE OR REPLACE FUNCTION citydb_pkg.utn9_insert_medium_supply (
  objectclass_id            integer,
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
  schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer
AS $$
DECLARE
  p_id                        integer := id                       ;
  p_objectclass_id            integer := objectclass_id           ;
  p_type                      varchar := type                     ;
  p_cur_flow_rate      numeric := cur_flow_rate     ;
  p_cur_flow_rate_unit varchar := cur_flow_rate_unit;
  p_cur_status         varchar := cur_status        ;
  p_pot_flow_rate      numeric := pot_flow_rate     ;
  p_pot_flow_rate_unit varchar := pot_flow_rate_unit;
  p_pot_status         varchar := pot_status        ;
  p_cityobject_id             integer := cityobject_id            ;
--	
  p_schema_name varchar := schema_name;
  seq_name varchar;
  inserted_id integer;
BEGIN
-- IF the ID is not given, then generate a new one.
IF p_id IS NULL THEN
  seq_name=schema_name||'.utn9_medium_supply_id_seq';
  p_id=nextval(seq_name::regclass);
END IF;

EXECUTE format('
INSERT INTO %I.utn9_medium_supply (
 id,
 objectclass_id,
 type,
 cur_flow_rate,
 cur_flow_rate_unit,
 cur_status,
 pot_flow_rate,
 pot_flow_rate_unit,
 pot_status,
 cityobject_id
) VALUES (
%L, %L, %L, %L, %L, %L, %L, %L, %L, %L
) RETURNING id',
p_schema_name,
p_id, 
p_objectclass_id, 
p_type, 
p_cur_flow_rate, 
p_cur_flow_rate_unit, 
p_cur_status, 
p_pot_flow_rate, 
p_pot_flow_rate_unit, 
p_pot_status, 
p_cityobject_id
) INTO inserted_id;
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.utn9_insert_medium_supply (id: %): %', p_id, SQLERRM;
END;
$$ LANGUAGE 'plpgsql';

----------------------------------------------------------------
-- Function UTN9_INSERT_BUILDING
----------------------------------------------------------------
-- DROP FUNCTION IF EXISTS citydb_pkg.utn9_insert_building (integer, integer, integer) CASCADE;
CREATE OR REPLACE FUNCTION citydb_pkg.utn9_insert_building (
  id   integer,
  objectclass_id   integer,
  nbr_occupants integer DEFAULT NULL,
--	
  schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer
AS $$
DECLARE
  p_id integer := id;
  p_objectclass_id integer := objectclass_id;
  p_nbr_occupants  integer := nbr_occupants;
--
  p_schema_name varchar := schema_name;
  inserted_id integer;
BEGIN
EXECUTE format('
INSERT INTO %I.utn9_building (
 id,
 objectclass_id,
 nbr_occupants
) VALUES (
%L, %L, %L
) RETURNING id',
p_schema_name,
p_id, 
p_objectclass_id, 
p_nbr_occupants
) INTO inserted_id;
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.utn9_insert_building (id: %): %', p_id, SQLERRM;
END;
$$ LANGUAGE 'plpgsql';

----------------------------------------------------------------
-- Function UTN9_INSERT_ROLE_IN_NETWORK
----------------------------------------------------------------
-- DROP FUNCTION IF EXISTS citydb_pkg.utn9_insert_role_in_network (integer, integer, varchar, varchar, varchar, varchar, text, varchar, varchar, integer, integer) CASCADE;
CREATE OR REPLACE FUNCTION citydb_pkg.utn9_insert_role_in_network (
  objectclass_id  integer,
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
  schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer
AS $$
DECLARE
  p_id              integer := id;
  p_objectclass_id  integer := objectclass_id;
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
  seq_name varchar;
  inserted_id integer;
BEGIN
-- IF the ID is not given, then generate a new one.
IF p_id IS NULL THEN
  seq_name=schema_name||'.utn9_role_in_network_id_seq';
  p_id=nextval(seq_name::regclass);
END IF;
-- IF the GmlID is not given, then generate a new one.
IF p_gmlid IS NULL THEN
  p_gmlid='UUID_'||uuid_generate_v4();
END IF;

EXECUTE format('
INSERT INTO %I.utn9_role_in_network (
 id,
 objectclass_id,
 gmlid,
 gmlid_codespace,
 name,
 name_codespace,
 description,
 function,
 usage,
 cityobject_id,
 network_id
) VALUES (
%L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L
) RETURNING id',
p_schema_name,
p_id, 
p_objectclass_id, 
p_gmlid, 
p_gmlid_codespace, 
p_name, 
p_name_codespace, 
p_description, 
p_function, 
p_usage, 
p_cityobject_id, 
p_network_id
) INTO inserted_id;
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.utn9_insert_role_in_network (id: %): %', p_id, SQLERRM;
END;
$$ LANGUAGE 'plpgsql';

----------------------------------------------------------------
-- Function UTN9_INSERT_COMM_CLASS_TO_COMM_CLASS
----------------------------------------------------------------
-- DROP FUNCTION IF EXISTS citydb_pkg.utn9_insert_comm_class_to_comm_class (integer, integer) CASCADE;
CREATE OR REPLACE FUNCTION citydb_pkg.utn9_insert_comm_class_to_comm_class (
  comm_class_parent_id integer,
  comm_class_id integer,
--	
  schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS void
AS $$
DECLARE
  p_comm_class_parent_id integer := comm_class_parent_id;
  p_comm_class_id integer := comm_class_id;
--	
  p_schema_name varchar := schema_name;
BEGIN
EXECUTE format('
INSERT INTO %I.utn9_comm_class_to_comm_class (
 comm_class_parent_id,
 comm_class_id
) VALUES (
%L, %L
)',
p_schema_name,
p_comm_class_parent_id, 
p_comm_class_id
) ;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.utn9_insert_comm_class_to_comm_class (comm_class_parent_id: %, comm_class_id: %): %', comm_class_parent_id, comm_class_id, SQLERRM;
END;
$$ LANGUAGE 'plpgsql';

----------------------------------------------------------------
-- Function UTN9_INSERT_NETWORK_FEATURE
----------------------------------------------------------------
-- DROP FUNCTION IF EXISTS citydb_pkg.utn9_insert_network_feature (integer, integer, integer, integer, varchar, varchar, varchar, date, varchar, varchar, varchar, integer, integer, geometry) CASCADE;
CREATE OR REPLACE FUNCTION citydb_pkg.utn9_insert_network_feature (
  id                    integer,
  objectclass_id        integer,
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
  schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer
AS $$
DECLARE
  p_id                     integer  := id;
  p_objectclass_id         integer  := objectclass_id;
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
  inserted_id integer;
BEGIN
EXECUTE format('
INSERT INTO %I.utn9_network_feature (
 id,
 objectclass_id,
 ntw_feature_parent_id,
 ntw_feature_root_id,
 class,
 function,
 usage,
 year_of_construction,
 status,
 location_quality,
 elevation_quality,
 conn_cityobject_id,
 prot_element_id,
 geom
) VALUES (
%L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L
) RETURNING id',
p_schema_name,
p_id, 
p_objectclass_id, 
p_ntw_feature_parent_id, 
p_ntw_feature_root_id, 
p_class, 
p_function, 
p_usage, 
p_year_of_construction, 
p_status, 
p_location_quality, 
p_elevation_quality, 
p_conn_cityobject_id, 
p_prot_element_id, 
p_geom
) INTO inserted_id;
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.utn9_insert_network_feature (id: %): %', p_id, SQLERRM;
END;
$$ LANGUAGE 'plpgsql';

----------------------------------------------------------------
-- Function UTN9_INSERT_NETWORK_TO_NETWORK
----------------------------------------------------------------
-- DROP FUNCTION IF EXISTS citydb_pkg.utn9_insert_network_to_network (integer, integer) CASCADE;
CREATE OR REPLACE FUNCTION citydb_pkg.utn9_insert_network_to_network (
  superordinate_network_id integer,
  subordinate_network_id   integer,
--
  schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS void
AS $$
DECLARE
  p_superordinate_network_id integer := superordinate_network_id;
  p_subordinate_network_id integer   := subordinate_network_id;
--	
  p_schema_name varchar := schema_name;
BEGIN
EXECUTE format('
INSERT INTO %I.utn9_network_to_network (
 superordinate_network_id,
 subordinate_network_id
) VALUES (
%L, %L
)',
p_schema_name,p_superordinate_network_id, 
p_subordinate_network_id
) ;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.utn9_insert_network_to_network (superordinate_network_id: %, subordinate_network_id: %): %', superordinate_network_id, subordinate_network_id, SQLERRM;
END;
$$ LANGUAGE 'plpgsql';

----------------------------------------------------------------
-- Function UTN9_INSERT_MATERIAL
----------------------------------------------------------------
-- DROP FUNCTION IF EXISTS citydb_pkg.utn9_insert_material (integer, integer, integer, integer, varchar, varchar, varchar, varchar, text, varchar, integer) CASCADE;
CREATE OR REPLACE FUNCTION citydb_pkg.utn9_insert_material (
  objectclass_id     integer,
  id                 integer DEFAULT NULL,
  material_parent_id integer DEFAULT NULL,
  material_root_id   integer DEFAULT NULL,
  gmlid              varchar DEFAULT NULL,
  gmlid_codespace    varchar DEFAULT NULL,
  name               varchar DEFAULT NULL,
  name_codespace     varchar DEFAULT NULL,
  description        text    DEFAULT NULL,
  type               varchar DEFAULT NULL,
  material_id        integer DEFAULT NULL,
--	
  schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer
AS $$
DECLARE
  p_id                 integer := id;
  p_material_parent_id integer := material_parent_id;
  p_material_root_id   integer := material_root_id;
  p_objectclass_id     integer := objectclass_id;
  p_gmlid              varchar := gmlid;
  p_gmlid_codespace    varchar := gmlid_codespace;
  p_name               varchar := name;
  p_name_codespace     varchar := name_codespace;
  p_description        text    := description;
  p_type               varchar := type;
  p_material_id        integer := material_id;
--
  p_schema_name varchar := schema_name;
  seq_name varchar;
  inserted_id integer;
BEGIN
-- IF the ID is not given, then generate a new one.
IF p_id IS NULL THEN
  seq_name=schema_name||'.utn9_material_id_seq';
  p_id=nextval(seq_name::regclass);
END IF;
-- IF the GmlID is not given, then generate a new one.
IF p_gmlid IS NULL THEN
  p_gmlid='UUID_'||uuid_generate_v4();
END IF;

EXECUTE format('INSERT INTO %I.utn9_material (
 id,
 material_parent_id,
 material_root_id,
 objectclass_id,
 gmlid,
 gmlid_codespace,
 name,
 name_codespace,
 description,
 type,
 material_id
) VALUES (
%L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L
) RETURNING id',
p_schema_name,
p_id, 
p_material_parent_id, 
p_material_root_id, 
p_objectclass_id, 
p_gmlid, 
p_gmlid_codespace, 
p_name, 
p_name_codespace, 
p_description, 
p_type, 
p_material_id
) INTO inserted_id;
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.utn9_insert_material (id: %): %', p_id, SQLERRM;
END;
$$ LANGUAGE 'plpgsql';

----------------------------------------------------------------
-- Function UTN9_INSERT_FEATURE_GRAPH
----------------------------------------------------------------
-- DROP FUNCTION IF EXISTS citydb_pkg.utn9_insert_feature_graph (integer, integer, varchar, varchar, varchar, varchar, text, integer, integer) CASCADE;
CREATE OR REPLACE FUNCTION citydb_pkg.utn9_insert_feature_graph (
  objectclass_id   integer,
  id   integer DEFAULT NULL,
  gmlid varchar DEFAULT NULL,
  gmlid_codespace  varchar DEFAULT NULL,
  name varchar DEFAULT NULL,
  name_codespace   varchar DEFAULT NULL,
  description  text DEFAULT NULL,
  ntw_feature_id   integer DEFAULT NULL,
  ntw_graph_id integer DEFAULT NULL, 
  schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer
AS $$
DECLARE
  p_id integer := id;
  p_objectclass_id integer := objectclass_id;
  p_gmlid  varchar := gmlid;
  p_gmlid_codespace varchar := gmlid_codespace;
  p_name   varchar := name;
  p_name_codespace varchar := name_codespace;
  p_description text:= description;
  p_ntw_feature_id integer := ntw_feature_id;
  p_ntw_graph_id   integer := ntw_graph_id;
--	
  p_schema_name varchar := schema_name;
  seq_name varchar;
  inserted_id integer;
BEGIN
-- IF the ID is not given, then generate a new one.
IF p_id IS NULL THEN
  seq_name=schema_name||'.utn9_feature_graph_id_seq';
  p_id=nextval(seq_name::regclass);
END IF;
-- IF the GmlID is not given, then generate a new one.
IF p_gmlid IS NULL THEN
  p_gmlid='UUID_'||uuid_generate_v4();
END IF;

EXECUTE format('
INSERT INTO %I.utn9_feature_graph (
 id,
 objectclass_id,
 gmlid,
 gmlid_codespace,
 name,
 name_codespace,
 description,
 ntw_feature_id,
 ntw_graph_id
) VALUES (
%L, %L, %L, %L, %L, %L, %L, %L, %L
) RETURNING id',
p_schema_name,
p_id, 
p_objectclass_id, 
p_gmlid, 
p_gmlid_codespace, 
p_name, 
p_name_codespace, 
p_description, 
p_ntw_feature_id, 
p_ntw_graph_id
) INTO inserted_id;
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.utn9_insert_feature_graph (id: %): %', p_id, SQLERRM;
END;
$$ LANGUAGE 'plpgsql';

----------------------------------------------------------------
-- Function UTN9_INSERT_NETWORK_FEAT_TO_MATERIAL
----------------------------------------------------------------
-- DROP FUNCTION IF EXISTS citydb_pkg.utn9_insert_network_feat_to_material (integer, integer) CASCADE;
CREATE OR REPLACE FUNCTION citydb_pkg.utn9_insert_network_feat_to_material (
  network_feature_id  integer,
  material_id integer, 
  schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS void
AS $$
DECLARE
  p_network_feature_id  integer := network_feature_id;
  p_material_id integer := material_id;
--	
  p_schema_name varchar := schema_name;
BEGIN
EXECUTE format('
INSERT INTO %I.utn9_network_feat_to_material (
 network_feature_id,
 material_id
) VALUES (
%L, %L
)',
p_schema_name,
p_network_feature_id, 
p_material_id
) ;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.utn9_insert_network_feat_to_material (network_feature_id: %, material_id: %): %', network_feature_id, material_id, SQLERRM;
END;
$$ LANGUAGE 'plpgsql';

----------------------------------------------------------------
-- Function UTN9_INSERT_COMMODITY_CLASSIFIER
----------------------------------------------------------------
-- DROP FUNCTION IF EXISTS citydb_pkg.utn9_insert_commodity_classifier (integer, integer, varchar, varchar, varchar, varchar, text, varchar, numeric, numeric, varchar, varchar, numeric, varchar, varchar, varchar, varchar, varchar, varchar, varchar, varchar, integer, integer, integer) CASCADE;
CREATE OR REPLACE FUNCTION citydb_pkg.utn9_insert_commodity_classifier (
  objectclass_id   integer,
  id   integer DEFAULT NULL,
  gmlid varchar DEFAULT NULL,
  gmlid_codespace  varchar DEFAULT NULL,
  name varchar DEFAULT NULL,
  name_codespace   varchar DEFAULT NULL,
  description  text DEFAULT NULL,
  mol_formula  varchar DEFAULT NULL,
  mol_weight   numeric DEFAULT NULL,
  mol_weight_unit  numeric DEFAULT NULL,
  physical_form varchar DEFAULT NULL,
  signal_word  varchar DEFAULT NULL,
  is_chemical_complex  numeric DEFAULT NULL,
  haz_class varchar DEFAULT NULL,
  haz_class_category_code varchar DEFAULT NULL,
  haz_class_statement_code varchar DEFAULT NULL,
  haz_class_pictogram_code varchar DEFAULT NULL,
  haz_class_pictogram_uri varchar DEFAULT NULL,
  ec_number varchar DEFAULT NULL,
  cas_number   varchar DEFAULT NULL,
  iuclid_chem_datasheet varchar DEFAULT NULL,
  commodity_id integer DEFAULT NULL,
  material_id  integer DEFAULT NULL,
  hollow_space_id  integer DEFAULT NULL, 
  schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer
AS $$
DECLARE
  p_id   integer := id;
  p_objectclass_id   integer := objectclass_id;
  p_gmlid varchar := gmlid;
  p_gmlid_codespace  varchar := gmlid_codespace;
  p_name varchar := name;
  p_name_codespace   varchar := name_codespace;
  p_description  text:= description;
  p_mol_formula  varchar := mol_formula;
  p_mol_weight   numeric := mol_weight;
  p_mol_weight_unit  numeric := mol_weight_unit;
  p_physical_form varchar := physical_form;
  p_signal_word  varchar := signal_word;
  p_is_chemical_complex  numeric := is_chemical_complex;
  p_haz_class varchar := haz_class;
  p_haz_class_category_code  varchar := haz_class_category_code;
  p_haz_class_statement_code varchar := haz_class_statement_code;
  p_haz_class_pictogram_code varchar := haz_class_pictogram_code;
  p_haz_class_pictogram_uri  varchar := haz_class_pictogram_uri;
  p_ec_number varchar := ec_number;
  p_cas_number   varchar := cas_number;
  p_iuclid_chem_datasheet varchar := iuclid_chem_datasheet;
  p_commodity_id integer := commodity_id;
  p_material_id  integer := material_id;
  p_hollow_space_id  integer := hollow_space_id;
--	
  p_schema_name varchar := schema_name;
  seq_name varchar;
  inserted_id integer;
BEGIN
-- IF the ID is not given, then generate a new one.
IF p_id IS NULL THEN
  seq_name=schema_name||'.utn9_commodity_classifier_id_seq';
  p_id=nextval(seq_name::regclass);
END IF;
-- IF the GmlID is not given, then generate a new one.
IF p_gmlid IS NULL THEN
  p_gmlid='UUID_'||uuid_generate_v4();
END IF;

EXECUTE format('
INSERT INTO %I.utn9_commodity_classifier (
 id,
 objectclass_id,
 gmlid,
 gmlid_codespace,
 name,
 name_codespace,
 description,
 mol_formula,
 mol_weight,
 mol_weight_unit,
 physical_form,
 signal_word,
 is_chemical_complex,
 haz_class,
 haz_class_category_code,
 haz_class_statement_code,
 haz_class_pictogram_code,
 haz_class_pictogram_uri,
 ec_number,
 cas_number,
 iuclid_chem_datasheet,
 commodity_id,
 material_id,
 hollow_space_id
) VALUES (
%L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L
) RETURNING id',
p_schema_name,
p_id, 
p_objectclass_id, 
p_gmlid, 
p_gmlid_codespace, 
p_name, 
p_name_codespace, 
p_description, 
p_mol_formula, 
p_mol_weight, 
p_mol_weight_unit, 
p_physical_form, 
p_signal_word, 
p_is_chemical_complex, 
p_haz_class, 
p_haz_class_category_code, 
p_haz_class_statement_code, 
p_haz_class_pictogram_code, 
p_haz_class_pictogram_uri, 
p_ec_number, 
p_cas_number, 
p_iuclid_chem_datasheet, 
p_commodity_id, 
p_material_id, 
p_hollow_space_id
) INTO inserted_id;
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.utn9_insert_commodity_classifier (id: %): %', p_id, SQLERRM;
END;
$$ LANGUAGE 'plpgsql';

----------------------------------------------------------------
-- Function UTN9_INSERT_PROTECTIVE_ELEMENT
----------------------------------------------------------------
-- DROP FUNCTION IF EXISTS citydb_pkg.utn9_insert_protective_element (integer, integer, numeric, varchar, numeric, varchar, numeric, varchar, numeric, varchar, numeric, varchar, numeric, varchar, numeric, varchar) CASCADE;
CREATE OR REPLACE FUNCTION citydb_pkg.utn9_insert_protective_element (
  id                integer,
  objectclass_id    integer,
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
  int_diameter      numeric DEFAULT NULL,
  int_diameter_unit varchar DEFAULT NULL,
  width             numeric DEFAULT NULL,
  width_unit        varchar DEFAULT NULL,
--	
  schema_name       varchar DEFAULT 'citydb'::varchar
)
RETURNS integer
AS $$
DECLARE
  p_id                integer := id;
  p_objectclass_id    integer := objectclass_id;
  p_ext_width         numeric := ext_width;
  p_ext_width_unit    varchar := ext_width_unit;
  p_ext_height        numeric := ext_height;
  p_ext_height_unit   varchar := ext_height_unit;
  p_ext_diameter      numeric := ext_diameter;
  p_ext_diameter_unit varchar := ext_diameter_unit;
  p_int_width         numeric := int_width;
  p_int_width_unit    varchar := int_width_unit;
  p_int_height        numeric := int_height;
  p_int_height_unit   varchar := int_height_unit;
  p_int_diameter      numeric := int_diameter;
  p_int_diameter_unit varchar := int_diameter_unit;
  p_width             numeric := width;
  p_width_unit        varchar := width_unit;
--
  p_schema_name varchar := schema_name;
  inserted_id integer;
BEGIN
EXECUTE format('
INSERT INTO %I.utn9_protective_element (
 id,
 objectclass_id,
 ext_width,
 ext_width_unit,
 ext_height,
 ext_height_unit,
 ext_diameter,
 ext_diameter_unit,
 int_width,
 int_width_unit,
 int_height,
 int_height_unit,
 int_diameter,
 int_diameter_unit,
 width,
 width_unit
) VALUES (
%L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L
) RETURNING id',
p_schema_name,
p_id, 
p_objectclass_id, 
p_ext_width, 
p_ext_width_unit, 
p_ext_height, 
p_ext_height_unit, 
p_ext_diameter, 
p_ext_diameter_unit, 
p_int_width, 
p_int_width_unit, 
p_int_height, 
p_int_height_unit, 
p_int_diameter, 
p_int_diameter_unit, 
p_width, 
p_width_unit
) INTO inserted_id;
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.utn9_insert_protective_element (id: %): %', p_id, SQLERRM;
END;
$$ LANGUAGE 'plpgsql';

----------------------------------------------------------------
-- Function UTN9_INSERT_LINK
----------------------------------------------------------------
-- DROP FUNCTION IF EXISTS citydb_pkg.utn9_insert_link (integer, integer, varchar, varchar, varchar, varchar, text, character, varchar, varchar, integer, integer, integer, integer, geometry) CASCADE;
CREATE OR REPLACE FUNCTION citydb_pkg.utn9_insert_link (
  objectclass_id  integer,
  id              integer DEFAULT NULL,
  gmlid           varchar DEFAULT NULL,
  gmlid_codespace varchar DEFAULT NULL,
  name            varchar DEFAULT NULL,
  name_codespace  varchar DEFAULT NULL,
  description     text DEFAULT NULL,
  direction       character DEFAULT NULL,
  link_control    varchar DEFAULT NULL,
  type            varchar DEFAULT NULL,
  start_node_id   integer DEFAULT NULL,
  end_node_id     integer DEFAULT NULL,
  feat_graph_id   integer DEFAULT NULL,
  ntw_graph_id    integer DEFAULT NULL,
  line_geom       geometry DEFAULT NULL,
--  
  schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer
AS $$
DECLARE
  p_id integer := id;
  p_objectclass_id integer := objectclass_id;
  p_gmlid  varchar := gmlid;
  p_gmlid_codespace varchar := gmlid_codespace;
  p_name   varchar := name;
  p_name_codespace varchar := name_codespace;
  p_description text:= description;
  p_direction  character   := direction;
  p_link_control   varchar := link_control;
  p_type varchar := type;
  p_start_node_id  integer := start_node_id;
  p_end_node_id integer := end_node_id;
  p_feat_graph_id  integer := feat_graph_id;
  p_ntw_graph_id   integer := ntw_graph_id;
  p_line_geom  geometry:= line_geom;
--	
  p_schema_name varchar := schema_name;
  seq_name varchar;
  inserted_id integer;
BEGIN
-- IF the ID is not given, then generate a new one.
IF p_id IS NULL THEN
  seq_name=schema_name||'.utn9_link_id_seq';
  p_id=nextval(seq_name::regclass);
END IF;
-- IF the GmlID is not given, then generate a new one.
IF p_gmlid IS NULL THEN
  p_gmlid='UUID_'||uuid_generate_v4();
END IF;
EXECUTE format('
INSERT INTO %I.utn9_link (
 id,
 objectclass_id,
 gmlid,
 gmlid_codespace,
 name,
 name_codespace,
 description,
 direction,
 link_control,
 type,
 start_node_id,
 end_node_id,
 feat_graph_id,
 ntw_graph_id,
 line_geom
) VALUES (
%L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L
) RETURNING id',
p_schema_name,
p_id, 
p_objectclass_id, 
p_gmlid, 
p_gmlid_codespace, 
p_name, 
p_name_codespace, 
p_description, 
p_direction, 
p_link_control, 
p_type, 
p_start_node_id, 
p_end_node_id, 
p_feat_graph_id, 
p_ntw_graph_id, 
p_line_geom
) INTO inserted_id;
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.utn9_insert_link (id: %): %', p_id, SQLERRM;
END;
$$ LANGUAGE 'plpgsql';

----------------------------------------------------------------
-- Function UTN9_INSERT_STORAGE
----------------------------------------------------------------
-- DROP FUNCTION IF EXISTS citydb_pkg.utn9_insert_storage (integer, varchar, numeric, varchar, numeric, numeric, varchar, numeric, varchar, integer) CASCADE;
CREATE OR REPLACE FUNCTION citydb_pkg.utn9_insert_storage (
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
  schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer
AS $$
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
  seq_name varchar;
  inserted_id integer;
BEGIN
-- IF the ID is not given, then generate a new one.
IF p_id IS NULL THEN
  seq_name=schema_name||'.utn9_storage_id_seq';
  p_id=nextval(seq_name::regclass);
END IF;

EXECUTE format('
INSERT INTO %I.utn9_storage (
 id,
 type,
 max_capacity,
 max_capacity_unit,
 fill_level,
 inflow_rate,
 inflow_rate_unit,
 outflow_rate,
 outflow_rate_unit,
 medium_supply_id
) VALUES (
%L, %L, %L, %L, %L, %L, %L, %L, %L, %L
) RETURNING id',
p_schema_name,
p_id, 
p_type, 
p_max_capacity, 
p_max_capacity_unit, 
p_fill_level, 
p_inflow_rate, 
p_inflow_rate_unit, 
p_outflow_rate, 
p_outflow_rate_unit, 
p_medium_supply_id
) INTO inserted_id;
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.utn9_insert_storage (id: %): %', p_id, SQLERRM;
END;
$$ LANGUAGE 'plpgsql';

----------------------------------------------------------------
-- Function UTN9_INSERT_COMMODITY
----------------------------------------------------------------
-- DROP FUNCTION IF EXISTS citydb_pkg.utn9_insert_commodity (integer, integer, varchar, varchar, varchar, varchar, text, varchar, varchar, numeric, numeric, numeric, numeric, numeric, numeric, varchar, numeric, varchar, numeric, numeric, varchar, numeric, numeric, varchar, numeric, numeric, varchar, numeric, numeric, varchar, numeric, numeric, varchar, numeric, numeric, varchar, numeric, numeric, varchar, varchar) CASCADE;
CREATE OR REPLACE FUNCTION citydb_pkg.utn9_insert_commodity (
  objectclass_id   integer,
  id   integer DEFAULT NULL,
  gmlid varchar DEFAULT NULL,
  gmlid_codespace  varchar DEFAULT NULL,
  name varchar DEFAULT NULL,
  name_codespace   varchar DEFAULT NULL,
  description  text DEFAULT NULL,
  owner varchar DEFAULT NULL,
  type varchar DEFAULT NULL,
  is_corrosive numeric DEFAULT NULL,
  is_explosive numeric DEFAULT NULL,
  is_lighter_than_air  numeric DEFAULT NULL,
  flammability_ratio   numeric DEFAULT NULL,
  elec_conductivity_range_from numeric DEFAULT NULL,
  elec_conductivity_range_to numeric DEFAULT NULL,
  elec_conductivity_range_unit varchar DEFAULT NULL,
  concentration numeric DEFAULT NULL,
  concentration_unit   varchar DEFAULT NULL,
  ph_value_range_from  numeric DEFAULT NULL,
  ph_value_range_to numeric DEFAULT NULL,
  ph_value_range_unit  varchar DEFAULT NULL,
  temperature_range_from numeric DEFAULT NULL,
  temperature_range_to numeric DEFAULT NULL,
  temperature_range_unit varchar DEFAULT NULL,
  flow_rate_range_from numeric DEFAULT NULL,
  flow_rate_range_to   numeric DEFAULT NULL,
  flow_rate_range_unit varchar DEFAULT NULL,
  pressure_range_from  numeric DEFAULT NULL,
  pressure_range_to numeric DEFAULT NULL,
  pressure_range_unit  varchar DEFAULT NULL,
  voltage_range_from   numeric DEFAULT NULL,
  voltage_range_to numeric DEFAULT NULL,
  voltage_range_unit   varchar DEFAULT NULL,
  amperage_range_from  numeric DEFAULT NULL,
  amperage_range_to numeric DEFAULT NULL,
  amperage_range_unit  varchar DEFAULT NULL,
  bandwidth_range_from numeric DEFAULT NULL,
  bandwidth_range_to   numeric DEFAULT NULL,
  bandwidth_range_unit   varchar DEFAULT NULL,
  optical_mode varchar DEFAULT NULL, 
  schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer
AS $$
DECLARE
  p_id   integer := id  ;
  p_objectclass_id   integer := objectclass_id  ;
  p_gmlid varchar := gmlid   ;
  p_gmlid_codespace  varchar := gmlid_codespace ;
  p_name varchar := name;
  p_name_codespace   varchar := name_codespace  ;
  p_description  text:= description ;
  p_owner varchar := owner   ;
  p_type varchar := type;
  p_is_corrosive numeric := is_corrosive;
  p_is_explosive numeric := is_explosive;
  p_is_lighter_than_air  numeric := is_lighter_than_air ;
  p_flammability_ratio   numeric := flammability_ratio  ;
  p_elec_conductivity_range_from numeric := elec_conductivity_range_from;
  p_elec_conductivity_range_to   numeric := elec_conductivity_range_to  ;
  p_elec_conductivity_range_unit   varchar := elec_conductivity_range_unit  ;
  p_concentration numeric := concentration   ;
  p_concentration_unit   varchar := concentration_unit  ;
  p_ph_value_range_from  numeric := ph_value_range_from ;
  p_ph_value_range_to numeric := ph_value_range_to   ;
  p_ph_value_range_unit  varchar := ph_value_range_unit ;
  p_temperature_range_from   numeric := temperature_range_from  ;
  p_temperature_range_to numeric := temperature_range_to;
  p_temperature_range_unit   varchar := temperature_range_unit  ;
  p_flow_rate_range_from numeric := flow_rate_range_from;
  p_flow_rate_range_to   numeric := flow_rate_range_to  ;
  p_flow_rate_range_unit varchar := flow_rate_range_unit;
  p_pressure_range_from  numeric := pressure_range_from ;
  p_pressure_range_to numeric := pressure_range_to   ;
  p_pressure_range_unit  varchar := pressure_range_unit ;
  p_voltage_range_from   numeric := voltage_range_from  ;
  p_voltage_range_to numeric := voltage_range_to;
  p_voltage_range_unit   varchar := voltage_range_unit  ;
  p_amperage_range_from  numeric := amperage_range_from ;
  p_amperage_range_to numeric := amperage_range_to   ;
  p_amperage_range_unit  varchar := amperage_range_unit ;
  p_bandwidth_range_from numeric := bandwidth_range_from;
  p_bandwidth_range_to   numeric := bandwidth_range_to  ;
  p_bandwidth_range_unit   varchar := bandwidth_range_unit  ;
  p_optical_mode varchar := optical_mode;
--	
  p_schema_name varchar := schema_name;
  seq_name varchar;
  inserted_id integer;
BEGIN
-- IF the ID is not given, then generate a new one.
IF p_id IS NULL THEN
  seq_name=schema_name||'.utn9_commodity_id_seq';
  p_id=nextval(seq_name::regclass);
END IF;
-- IF the GmlID is not given, then generate a new one.
IF p_gmlid IS NULL THEN
  p_gmlid='UUID_'||uuid_generate_v4();
END IF;

EXECUTE format('
INSERT INTO %I.utn9_commodity (
 id,
 objectclass_id,
 gmlid,
 gmlid_codespace,
 name,
 name_codespace,
 description,
 owner,
 type,
 is_corrosive,
 is_explosive,
 is_lighter_than_air,
 flammability_ratio,
 elec_conductivity_range_from,
 elec_conductivity_range_to,
 elec_conductivity_range_unit,
 concentration,
 concentration_unit,
 ph_value_range_from,
 ph_value_range_to,
 ph_value_range_unit,
 temperature_range_from,
 temperature_range_to,
 temperature_range_unit,
 flow_rate_range_from,
 flow_rate_range_to,
 flow_rate_range_unit,
 pressure_range_from,
 pressure_range_to,
 pressure_range_unit,
 voltage_range_from,
 voltage_range_to,
 voltage_range_unit,
 amperage_range_from,
 amperage_range_to,
 amperage_range_unit,
 bandwidth_range_from,
 bandwidth_range_to,
 bandwidth_range_unit,
 optical_mode
) VALUES (
%L, %L, %L, %L, %L, %L, %L, %L, %L, %L,
%L, %L, %L, %L, %L, %L, %L, %L, %L, %L, 
%L, %L, %L, %L, %L, %L, %L, %L, %L, %L, 
%L, %L, %L, %L, %L, %L, %L, %L, %L, %L
) RETURNING id',
p_schema_name,
p_id, 
p_objectclass_id, 
p_gmlid, 
p_gmlid_codespace, 
p_name, 
p_name_codespace, 
p_description, 
p_owner, 
p_type, 
p_is_corrosive, 
p_is_explosive, 
p_is_lighter_than_air, 
p_flammability_ratio, 
p_elec_conductivity_range_from, 
p_elec_conductivity_range_to, 
p_elec_conductivity_range_unit, 
p_concentration, 
p_concentration_unit, 
p_ph_value_range_from, 
p_ph_value_range_to, 
p_ph_value_range_unit, 
p_temperature_range_from, 
p_temperature_range_to, 
p_temperature_range_unit, 
p_flow_rate_range_from, 
p_flow_rate_range_to, 
p_flow_rate_range_unit, 
p_pressure_range_from, 
p_pressure_range_to, 
p_pressure_range_unit, 
p_voltage_range_from, 
p_voltage_range_to, 
p_voltage_range_unit, 
p_amperage_range_from, 
p_amperage_range_to, 
p_amperage_range_unit, 
p_bandwidth_range_from, 
p_bandwidth_range_to, 
p_bandwidth_range_unit, 
p_optical_mode
) INTO inserted_id;
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.utn9_insert_commodity (id: %): %', p_id, SQLERRM;
END;
$$ LANGUAGE 'plpgsql';

----------------------------------------------------------------
-- Function UTN9_INSERT_NETWORK
----------------------------------------------------------------
-- DROP FUNCTION IF EXISTS citydb_pkg.utn9_insert_network (integer, integer, integer, integer, varchar, varchar, varchar, integer) CASCADE;
CREATE OR REPLACE FUNCTION citydb_pkg.utn9_insert_network (
  id                integer,
  objectclass_id    integer,
  network_parent_id integer DEFAULT NULL,
  network_root_id   integer DEFAULT NULL,
  class             varchar DEFAULT NULL,
  function          varchar DEFAULT NULL,
  usage             varchar DEFAULT NULL,
  commodity_id      integer DEFAULT NULL,
--	
  schema_name       varchar DEFAULT 'citydb'::varchar
)
RETURNS integer
AS $$
DECLARE
  p_id                integer := id;
  p_objectclass_id    integer := objectclass_id;
  p_network_parent_id integer := network_parent_id;
  p_network_root_id   integer := network_root_id;
  p_class             varchar := class;
  p_function          varchar := function;
  p_usage             varchar := usage;
  p_commodity_id      integer := commodity_id;
--	
  p_schema_name varchar := schema_name;
  inserted_id integer;
BEGIN
EXECUTE format('
INSERT INTO %I.utn9_network (
 id,
 objectclass_id,
 network_parent_id,
 network_root_id,
 class,
 function,
 usage,
 commodity_id
) VALUES (
%L, %L, %L, %L, %L, %L, %L, %L
) RETURNING id',
p_schema_name,
p_id, 
p_objectclass_id, 
p_network_parent_id, 
p_network_root_id, 
p_class, 
p_function, 
p_usage, 
p_commodity_id
) INTO inserted_id;
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.utn9_insert_network (id: %): %', p_id, SQLERRM;
END;
$$ LANGUAGE 'plpgsql';

----------------------------------------------------------------
-- Function UTN9_INSERT_NODE
----------------------------------------------------------------
-- DROP FUNCTION IF EXISTS citydb_pkg.utn9_insert_node (integer, integer, varchar, varchar, varchar, varchar, text, varchar, varchar, varchar, integer, geometry) CASCADE;
CREATE OR REPLACE FUNCTION citydb_pkg.utn9_insert_node (
  objectclass_id   integer,
  id   integer DEFAULT NULL,
  gmlid varchar DEFAULT NULL,
  gmlid_codespace  varchar DEFAULT NULL,
  name varchar DEFAULT NULL,
  name_codespace   varchar DEFAULT NULL,
  description  text DEFAULT NULL,
  type varchar DEFAULT NULL,
  connection_signature varchar DEFAULT NULL,
  link_control varchar DEFAULT NULL,
  feat_graph_id integer DEFAULT NULL,
  point_geom   geometry DEFAULT NULL,
--  
  schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer
AS $$
DECLARE
  p_id                   integer  := id;
  p_objectclass_id       integer  := objectclass_id;
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
  seq_name varchar;
  inserted_id integer;
BEGIN
-- IF the ID is not given, then generate a new one.
IF p_id IS NULL THEN
  seq_name=schema_name||'.utn9_node_id_seq';
  p_id=nextval(seq_name::regclass);
END IF;
-- IF the GmlID is not given, then generate a new one.
IF p_gmlid IS NULL THEN
  p_gmlid='UUID_'||uuid_generate_v4();
END IF;

EXECUTE format('
INSERT INTO %I.utn9_node (
 id,
 objectclass_id,
 gmlid,
 gmlid_codespace,
 name,
 name_codespace,
 description,
 type,
 connection_signature,
 link_control,
 feat_graph_id,
 point_geom
) VALUES (
%L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L
) RETURNING id',
p_schema_name,
p_id, 
p_objectclass_id, 
p_gmlid, 
p_gmlid_codespace, 
p_name, 
p_name_codespace, 
p_description, 
p_type, 
p_connection_signature, 
p_link_control, 
p_feat_graph_id, 
p_point_geom
) INTO inserted_id;
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.utn9_insert_node (id: %): %', p_id, SQLERRM;
END;
$$ LANGUAGE 'plpgsql';

----------------------------------------------------------------
-- Function UTN9_INSERT_HOLLOW_SPACE
----------------------------------------------------------------
-- DROP FUNCTION IF EXISTS citydb_pkg.utn9_insert_hollow_space (integer, integer, varchar, varchar, varchar, varchar, text, integer) CASCADE;
CREATE OR REPLACE FUNCTION citydb_pkg.utn9_insert_hollow_space (
  objectclass_id    integer,
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
  schema_name varchar DEFAULT 'citydb'::varchar
)
RETURNS integer
AS $$
DECLARE
  p_id                integer := id;
  p_objectclass_id    integer := objectclass_id;
  p_hol_spc_parent_id integer := hol_spc_parent_id;
  p_hol_spc_root_id   integer := hol_spc_root_id;
  p_gmlid             varchar := gmlid;
  p_gmlid_codespace   varchar := gmlid_codespace;
  p_name              varchar := name;
  p_name_codespace    varchar := name_codespace;
  p_description       text    := description;
  p_ntw_feature_id    integer := ntw_feature_id;
--
  p_schema_name varchar := schema_name;
  seq_name varchar;
  inserted_id integer;
BEGIN
-- IF the ID is not given, then generate a new one.
IF p_id IS NULL THEN
  seq_name=schema_name||'.utn9_hollow_space_id_seq';
  p_id=nextval(seq_name::regclass);
END IF;
-- IF the GmlID is not given, then generate a new one.
IF p_gmlid IS NULL THEN
  p_gmlid='UUID_'||uuid_generate_v4();
END IF;
EXECUTE format('
INSERT INTO %I.utn9_hollow_space (
 id,
 objectclass_id,
 hol_spc_parent_id, 
 hol_spc_root_id,
 gmlid,
 gmlid_codespace,
 name,
 name_codespace,
 description,
 ntw_feature_id
) VALUES (
%L, %L, %L, %L, %L, %L, %L, %L
) RETURNING id',
p_schema_name,
p_id, 
p_objectclass_id,
p_hol_spc_parent_id,
p_hol_spc_root_id,  
p_gmlid, 
p_gmlid_codespace, 
p_name, 
p_name_codespace, 
p_description, 
p_ntw_feature_id
) INTO inserted_id;
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.utn9_insert_hollow_space (id: %): %', p_id, SQLERRM;
END;
$$ LANGUAGE 'plpgsql';

----------------------------------------------------------------
-- Function UTN9_INSERT_SUPPLY_AREA_TO_CITYOBJECT
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_pkg.utn9_insert_supply_area_to_cityobject (integer, integer, varchar, varchar) CASCADE;
CREATE OR REPLACE FUNCTION citydb_pkg.utn9_insert_supply_area_to_cityobject (
  supply_area_id       integer,
  cityobject_id        integer,
  role                 varchar DEFAULT 'supplies'::varchar,
--  
  schema_name          varchar DEFAULT 'citydb'::varchar
)
RETURNS void
AS $$
DECLARE
  p_supply_area_id     integer := supply_area_id;
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
 p_supply_area_id,
 p_cityobject_id,
 p_role
);
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_pkg.utn9_insert_supply_area_to_cityobject (supply_area_id: %, cityobject_id %): %', supply_area_id, cityobject_id, SQLERRM;
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

Utility Network ADE DML functions installation complete!

********************************

';
END
$$;
SELECT 'Utility Network ADE DML functions installation complete!'::varchar AS installation_result;

-- ***********************************************************************
-- ***********************************************************************
--
-- END OF FILE
--
-- ***********************************************************************
-- ***********************************************************************
