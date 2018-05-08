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
-- ***************** 03_UtilityNetworks_ADE_TABLES.sql *******************
--
-- This script creates all Utility Network ADE tables in the citydb 
-- schema. All new tables are prefixed with "utn9_".
-- At the end, the function citydb_pkg.set_ade_column_srid() is executed
-- to set the SRID of the newly added geometry columns.
--
-- ***********************************************************************
-- ***********************************************************************

----------------------------------------------------------------
-- Table LU_NETWORK_CLASS
----------------------------------------------------------------
DROP TABLE IF EXISTS citydb.utn9_lu_network_class CASCADE;
CREATE TABLE         citydb.utn9_lu_network_class (
	id                   varchar PRIMARY KEY,
	name                 varchar,
	name_codespace       varchar,
	description          text
);
-- ALTER TABLE citydb.utn9_lu_network_class OWNER TO postgres;

CREATE INDEX utn9_lu_ntw_class_name_inx ON citydb.utn9_lu_network_class USING btree (name, name_codespace);

----------------------------------------------------------------
-- Table LU_NETWORK_FUNCTION
----------------------------------------------------------------
DROP TABLE IF EXISTS citydb.utn9_lu_network_function CASCADE;
CREATE TABLE         citydb.utn9_lu_network_function (
	id                   varchar PRIMARY KEY,
	name                 varchar,
	name_codespace       varchar,
	description          text
);
-- ALTER TABLE citydb.utn9_lu_network_function OWNER TO postgres;

CREATE INDEX utn9_lu_ntw_function_name_inx ON citydb.utn9_lu_network_function USING btree (name, name_codespace);

----------------------------------------------------------------
-- Table LU_NETWORK_FEATURE_CLASS
----------------------------------------------------------------
DROP TABLE IF EXISTS citydb.utn9_lu_network_feature_class CASCADE;
CREATE TABLE         citydb.utn9_lu_network_feature_class (
	id                   varchar NOT NULL,
	objectclass_id       integer NOT NULL,	
	name                 varchar,
	name_codespace       varchar,
	description          text,
	PRIMARY KEY (id, objectclass_id)
);
-- ALTER TABLE citydb.utn9_lu_network_feature_class OWNER TO postgres;

CREATE INDEX utn9_lu_ntw_feat_class_objclass_id_fkx ON citydb.utn9_lu_network_feature_class USING btree (objectclass_id);
CREATE INDEX utn9_lu_ntw_feat_class_name_inx        ON citydb.utn9_lu_network_feature_class USING btree (name, name_codespace);

----------------------------------------------------------------
-- Table LU_NETWORK_FEATURE_FUNCTION
----------------------------------------------------------------
DROP TABLE IF EXISTS citydb.utn9_lu_network_feature_function CASCADE;
CREATE TABLE         citydb.utn9_lu_network_feature_function (
	id                   varchar PRIMARY KEY,
	name                 varchar,
	name_codespace       varchar,
	description          text
);
-- ALTER TABLE citydb.utn9_lu_network_feature_function OWNER TO postgres;

CREATE INDEX utn9_lu_ntw_feat_function_name_inx ON citydb.utn9_lu_network_function USING btree (name, name_codespace);

----------------------------------------------------------------
-- Table LU_SPATIAL_QUALITY
----------------------------------------------------------------
DROP TABLE IF EXISTS citydb.utn9_lu_spatial_quality CASCADE;
CREATE TABLE         citydb.utn9_lu_spatial_quality (
	id                   varchar PRIMARY KEY,
	name                 varchar,
	name_codespace       varchar,
	description          text
);
-- ALTER TABLE citydb.utn9_lu_network_feature_function OWNER TO postgres;

CREATE INDEX utn9_lu_spat_qual_name_inx ON citydb.utn9_lu_spatial_quality USING btree (name, name_codespace);

----------------------------------------------------------------
-- Table LU_MATERIAL
----------------------------------------------------------------
DROP TABLE IF EXISTS citydb.utn9_lu_material CASCADE;
CREATE TABLE         citydb.utn9_lu_material (
	id                   varchar PRIMARY KEY,
	name                 varchar,
	name_codespace       varchar,
	description          text
);
-- ALTER TABLE citydb.utn9_lu_material OWNER TO postgres;

CREATE INDEX utn9_lu_material_name_inx ON citydb.utn9_lu_material USING btree (name, name_codespace);

----------------------------------------------------------------
-- Table LU_STATUS
----------------------------------------------------------------
DROP TABLE IF EXISTS citydb.utn9_lu_status CASCADE;
CREATE TABLE         citydb.utn9_lu_status (
	id                   varchar PRIMARY KEY,
	name                 varchar,
	name_codespace       varchar,
	description          text
);
-- ALTER TABLE citydb.utn9_lu_status OWNER TO postgres;

CREATE INDEX utn9_lu_status_name_inx ON citydb.utn9_lu_status USING btree (name, name_codespace);


----------------------------------------------------------------
-- Table LU_MEDIUM_SUPPLY
----------------------------------------------------------------
DROP TABLE IF EXISTS citydb.utn9_lu_medium_supply CASCADE;
CREATE TABLE         citydb.utn9_lu_medium_supply (
	id                   varchar NOT NULL,
	objectclass_id       integer NOT NULL,
	name                 varchar,
	name_codespace       varchar,
	description          text,
	PRIMARY KEY (id, objectclass_id)
);
-- ALTER TABLE citydb.utn9_lu_medium_supply OWNER TO postgres;

CREATE INDEX utn9_lu_medium_supply_objclass_id_fkx ON citydb.utn9_lu_medium_supply USING btree (objectclass_id);
CREATE INDEX utn9_lu_medium_supply_inx             ON citydb.utn9_lu_medium_supply USING btree (name, name_codespace);

----------------------------------------------------------------
-- Table LU_FUNCTION_OF_LINE
----------------------------------------------------------------
DROP TABLE IF EXISTS citydb.utn9_lu_function_of_line CASCADE;
CREATE TABLE         citydb.utn9_lu_function_of_line (
	id                   varchar PRIMARY KEY,
	name                 varchar,
	name_codespace       varchar,
	description          text
);
-- ALTER TABLE citydb.utn9_lu_function_of_line OWNER TO postgres;

CREATE INDEX utn9_lu_function_of_line_name_inx ON citydb.utn9_lu_function_of_line USING btree (name, name_codespace);

----------------------------------------------------------------
-- Table LU_SIGNAL_WORD
----------------------------------------------------------------
DROP TABLE IF EXISTS citydb.utn9_lu_signal_word CASCADE;
CREATE TABLE         citydb.utn9_lu_signal_word (
	id                   varchar PRIMARY KEY,
	name                 varchar,
	name_codespace       varchar,
	description          text
);
-- ALTER TABLE citydb.utn9_lu_function_of_line OWNER TO postgres;

CREATE INDEX utn9_lu_signal_word_name_inx ON citydb.utn9_lu_signal_word USING btree (name, name_codespace);

----------------------------------------------------------------
-- Table NETWORK (_CityObject)
----------------------------------------------------------------
DROP TABLE IF EXISTS citydb.utn9_network CASCADE;
CREATE TABLE         citydb.utn9_network (
	id                   integer PRIMARY KEY,	-- This is a foreign key to cityobject.id
	objectclass_id       integer NOT NULL, 	    -- This is a foreign key to objectclass.id
	network_parent_id    integer,
	network_root_id      integer,
	class                varchar,
	function             varchar,	
	usage                varchar,
	commodity_id         integer
);
-- ALTER TABLE citydb.utn9_network OWNER TO postgres;

CREATE INDEX utn9_ntw_objclass_id_fkx ON citydb.utn9_network USING btree (objectclass_id);
CREATE INDEX utn9_ntw_ntw_parent_id_fkx ON citydb.utn9_network USING btree (network_parent_id);
CREATE INDEX utn9_ntw_ntw_root_id_fkx ON citydb.utn9_network USING btree (network_root_id);
CREATE INDEX utn9_ntw_comm_id_fkx ON citydb.utn9_network USING btree (commodity_id);

CREATE INDEX utn9_ntw_class_fkx ON citydb.utn9_network USING btree (class);

COMMENT ON TABLE citydb.utn9_network IS 'Geographical representation of the network';

COMMENT ON COLUMN citydb.utn9_network.objectclass_id IS 'Objectclass ID of the network';
COMMENT ON COLUMN citydb.utn9_network.class          IS 'Class of the network feature';
COMMENT ON COLUMN citydb.utn9_network.function       IS 'Function(s) of the network feature';
COMMENT ON COLUMN citydb.utn9_network.usage          IS 'Usage(s) of the network feature';

----------------------------------------------------------------
-- Table NETWORK_TO_NETWORK
----------------------------------------------------------------
DROP TABLE IF EXISTS citydb.utn9_network_to_network CASCADE;
CREATE TABLE         citydb.utn9_network_to_network(
	superordinate_network_id   integer NOT NULL,
	subordinate_network_id     integer NOT NULL,
	CONSTRAINT utn9_network_to_network_pk PRIMARY KEY (superordinate_network_id, subordinate_network_id)
);
-- ALTER TABLE citydb.utn9_network_to_network OWNER TO postgres;

CREATE INDEX utn9_ntw_to_ntw_superntw_id_fkx ON citydb.utn9_network_to_network USING btree (superordinate_network_id);
CREATE INDEX utn9_ntw_to_ntw_subntw_id_fkx   ON citydb.utn9_network_to_network USING btree (subordinate_network_id);

----------------------------------------------------------------
-- Table NETWORK_TO_SUPPLY_AREA
----------------------------------------------------------------
DROP TABLE IF EXISTS citydb.utn9_network_to_supply_area CASCADE;
CREATE TABLE         citydb.utn9_network_to_supply_area(
	network_id       integer NOT NULL,
	supply_area_id   integer NOT NULL,
	CONSTRAINT utn9_network_to_supply_area_pk PRIMARY KEY (network_id, supply_area_id)
);
-- ALTER TABLE citydb.utn9_network_to_supply_area OWNER TO postgres;

CREATE INDEX utn9_ntw_to_supply_area_ntw_id_fkx  ON citydb.utn9_network_to_supply_area USING btree (network_id);
CREATE INDEX utn9_ntw_to_supply_area_area_id_fkx ON citydb.utn9_network_to_supply_area USING btree (supply_area_id);

----------------------------------------------------------------
-- Table NETWORK_FEATURE (_CityObject)
----------------------------------------------------------------
DROP TABLE IF EXISTS citydb.utn9_network_feature CASCADE;
CREATE TABLE         citydb.utn9_network_feature (
	id                       integer PRIMARY KEY,	-- This is a foreign key to cityobject.id
	objectclass_id           integer NOT NULL, 	    -- This is a foreign key to objectclass.id
	ntw_feature_parent_id    integer,
	ntw_feature_root_id      integer,
	class                    varchar,
	function                 varchar,	
	usage                    varchar,
	year_of_construction     date,
	status                   varchar,
	location_quality         varchar,
	elevation_quality        varchar,
	conn_cityobject_id       integer,
	prot_element_id          integer,
	geom                     geometry(GeometryZ)
);
-- ALTER TABLE citydb.utn9_network_feature OWNER TO postgres;

CREATE INDEX utn9_ntw_feat_objclass_id_fkx ON citydb.utn9_network_feature USING btree (objectclass_id);
CREATE INDEX utn9_ntw_feat_ntw_feat_parent_id_fkx ON citydb.utn9_network_feature USING btree (ntw_feature_parent_id);
CREATE INDEX utn9_ntw_feat_ntw_feat_root_id_fkx ON citydb.utn9_network_feature USING btree (ntw_feature_root_id);
CREATE INDEX utn9_ntw_feat_conn_cto_id_fkx ON citydb.utn9_network_feature USING btree (conn_cityobject_id);
CREATE INDEX utn9_ntw_feat_prot_elem_id_fkx ON citydb.utn9_network_feature USING btree (prot_element_id);
CREATE INDEX utn9_ntw_feat_geom_spx ON citydb.utn9_network_feature USING gist (geom gist_geometry_ops_nd);

CREATE INDEX utn9_ntw_feat_status_fkx ON citydb.utn9_network_feature USING btree (status);
CREATE INDEX utn9_ntw_feat_loc_qual_fkx ON citydb.utn9_network_feature USING btree (location_quality);
CREATE INDEX utn9_ntw_feat_ele_qual_fkx ON citydb.utn9_network_feature USING btree (elevation_quality);

COMMENT ON TABLE citydb.utn9_network_feature IS 'Geographical representation of the network feature';

COMMENT ON COLUMN citydb.utn9_network_feature.objectclass_id       IS 'Objectclass ID of the network feature';
COMMENT ON COLUMN citydb.utn9_network_feature.function             IS 'Function of the network feature';
COMMENT ON COLUMN citydb.utn9_network_feature.class                IS 'Class of the network feature';
COMMENT ON COLUMN citydb.utn9_network_feature.usage                IS 'Usage of the network feature';
COMMENT ON COLUMN citydb.utn9_network_feature.year_of_construction IS 'Year of contruction';
COMMENT ON COLUMN citydb.utn9_network_feature.status               IS 'Current status';
COMMENT ON COLUMN citydb.utn9_network_feature.location_quality     IS 'Location quality';
COMMENT ON COLUMN citydb.utn9_network_feature.elevation_quality    IS 'Elevation quality';

----------------------------------------------------------------
-- Table DISTRIBUTION_ELEMENT (_CityObject)
----------------------------------------------------------------
DROP TABLE IF EXISTS citydb.utn9_distrib_element CASCADE;
CREATE TABLE         citydb.utn9_distrib_element (
	id                       integer PRIMARY KEY,	-- This is a foreign key to cityobject.id
	objectclass_id           integer NOT NULL, 	  -- This is a foreign key to objectclass.id
	function_of_line         varchar,
	is_gravity               numeric(1),
	is_transmission          numeric(1),
	is_communication         numeric(1),
	ext_width                numeric,
	ext_width_unit           varchar,
	ext_height               numeric,
	ext_height_unit          varchar,
	ext_diameter             numeric,
	ext_diameter_unit        varchar,
	int_width                numeric,
	int_width_unit           varchar,
	int_height               numeric,
	int_height_unit          varchar,
	int_diameter             numeric,
	int_diameter_unit        varchar,	
	cross_section            numeric,
	cross_section_unit       varchar,	
	slope_range_from         numeric,
	slope_range_to           numeric,	
	slope_range_unit         varchar,
	profile_name             varchar	
);
-- ALTER TABLE citydb.utn9_distrib_element OWNER TO postgres;

CREATE INDEX utn9_distrib_elem_objclass_id_fkx ON citydb.utn9_distrib_element USING btree (objectclass_id);




COMMENT ON TABLE citydb.utn9_distrib_element IS 'Network distribution element (cable, pipe, canal, etc.)';

COMMENT ON COLUMN citydb.utn9_distrib_element.objectclass_id       IS 'Objectclass ID of the distribution element';
COMMENT ON COLUMN citydb.utn9_distrib_element.is_gravity           IS 'Is subject to gravity?';
COMMENT ON COLUMN citydb.utn9_distrib_element.is_transmission      IS 'Is a transmission element?';
COMMENT ON COLUMN citydb.utn9_distrib_element.is_communication     IS 'Is a communication element?';
COMMENT ON COLUMN citydb.utn9_distrib_element.ext_width            IS 'Exterior width';
COMMENT ON COLUMN citydb.utn9_distrib_element.ext_width_unit       IS 'Unit of exterior width';
COMMENT ON COLUMN citydb.utn9_distrib_element.ext_height           IS 'Exterior height';
COMMENT ON COLUMN citydb.utn9_distrib_element.ext_height_unit      IS 'Unit of exterior height';
COMMENT ON COLUMN citydb.utn9_distrib_element.ext_diameter         IS 'Exterior diameter';
COMMENT ON COLUMN citydb.utn9_distrib_element.ext_diameter_unit    IS 'Unit of exterior diameter';
COMMENT ON COLUMN citydb.utn9_distrib_element.int_width            IS 'Interior width';
COMMENT ON COLUMN citydb.utn9_distrib_element.int_width_unit       IS 'Unit of interior width';
COMMENT ON COLUMN citydb.utn9_distrib_element.int_height           IS 'Interior height';
COMMENT ON COLUMN citydb.utn9_distrib_element.int_height_unit      IS 'Unit of interior height';
COMMENT ON COLUMN citydb.utn9_distrib_element.int_diameter         IS 'Interior diameter';
COMMENT ON COLUMN citydb.utn9_distrib_element.int_diameter_unit    IS 'Unit of interior diameter';
COMMENT ON COLUMN citydb.utn9_distrib_element.cross_section        IS 'Cross section';
COMMENT ON COLUMN citydb.utn9_distrib_element.cross_section_unit   IS 'Unit of cross section';
COMMENT ON COLUMN citydb.utn9_distrib_element.slope_range_from     IS 'Slope range: min value';
COMMENT ON COLUMN citydb.utn9_distrib_element.slope_range_to       IS 'Slope range: max value';
COMMENT ON COLUMN citydb.utn9_distrib_element.slope_range_unit     IS 'Unit of slope';
COMMENT ON COLUMN citydb.utn9_distrib_element.profile_name         IS 'Profile name';

----------------------------------------------------------------
-- Table PROTECTIVE_ELEMENT (_CityObject)
----------------------------------------------------------------
DROP TABLE IF EXISTS citydb.utn9_protective_element CASCADE;
CREATE TABLE         citydb.utn9_protective_element (
	id             integer PRIMARY KEY, -- This is a foreign key to cityobject.id
	objectclass_id integer NOT NULL, 	  -- This is a foreign key to objectclass.id
	ext_width         numeric,
	ext_width_unit    varchar,
	ext_height        numeric,
	ext_height_unit   varchar,
	ext_diameter      numeric,
	ext_diameter_unit varchar,
	int_width         numeric,
	int_width_unit    varchar,
	int_height        numeric,
	int_height_unit   varchar,
	int_diameter      numeric,
	int_diameter_unit varchar,
	width             numeric,
	width_unit        varchar
);
-- ALTER TABLE citydb.utn9_protective_element OWNER TO postgres;

CREATE INDEX utn9_prot_elem_objclass_id_fkx ON citydb.utn9_protective_element USING btree (objectclass_id);

COMMENT ON TABLE citydb.utn9_protective_element IS 'Network protective element (shell, bedding, etc.)';

COMMENT ON COLUMN citydb.utn9_protective_element.objectclass_id       IS 'Objectclass ID of the distribution element';
COMMENT ON COLUMN citydb.utn9_protective_element.ext_width            IS 'Exterior width';
COMMENT ON COLUMN citydb.utn9_protective_element.ext_width_unit       IS 'Unit of exterior width';
COMMENT ON COLUMN citydb.utn9_protective_element.ext_height           IS 'Exterior height';
COMMENT ON COLUMN citydb.utn9_protective_element.ext_height_unit      IS 'Unit of exterior height';
COMMENT ON COLUMN citydb.utn9_protective_element.ext_diameter         IS 'Exterior diameter';
COMMENT ON COLUMN citydb.utn9_protective_element.ext_diameter_unit    IS 'Unit of exterior diameter';
COMMENT ON COLUMN citydb.utn9_protective_element.int_width            IS 'Interior width';
COMMENT ON COLUMN citydb.utn9_protective_element.int_width_unit       IS 'Unit of interior width';
COMMENT ON COLUMN citydb.utn9_protective_element.int_height           IS 'Interior height';
COMMENT ON COLUMN citydb.utn9_protective_element.int_height_unit      IS 'Unit of interior height';
COMMENT ON COLUMN citydb.utn9_protective_element.int_diameter         IS 'Interior diameter';
COMMENT ON COLUMN citydb.utn9_protective_element.int_diameter_unit    IS 'Unit of interior diameter';
COMMENT ON COLUMN citydb.utn9_protective_element.width                IS 'Width';
COMMENT ON COLUMN citydb.utn9_protective_element.width_unit           IS 'Unit of width';

----------------------------------------------------------------
-- Table NETWORK_TO_NETWORK_FEATURE
----------------------------------------------------------------
DROP TABLE IF EXISTS citydb.utn9_network_to_network_feature CASCADE;
CREATE TABLE         citydb.utn9_network_to_network_feature(
	network_id             integer NOT NULL,
	network_feature_id     integer NOT NULL,
	CONSTRAINT utn9_network_to_network_feature_pk PRIMARY KEY (network_id, network_feature_id)
);
-- ALTER TABLE citydb.utn9_network_to_network_feature OWNER TO postgres;

CREATE INDEX utn9_ntw_to_ntw_feat_ntw_id_fkx      ON citydb.utn9_network_to_network_feature USING btree (network_id);
CREATE INDEX utn9_ntw_to_ntw_feat_ntw_feat_id_fkx ON citydb.utn9_network_to_network_feature USING btree (network_feature_id);

----------------------------------------------------------------
-- Table NETWORK_GRAPH (FEATURE prototype)
----------------------------------------------------------------
DROP TABLE IF EXISTS citydb.utn9_network_graph CASCADE;
CREATE TABLE         citydb.utn9_network_graph (
	id              serial PRIMARY KEY,
	objectclass_id  integer NOT NULL, -- This is a foreign key to citydb.objectclass.id
	gmlid           varchar,
	gmlid_codespace varchar,
	name            varchar,
	name_codespace  varchar,
	description     text,
	network_id      integer
);
-- ALTER TABLE citydb.utn9_network_graph OWNER TO postgres;

CREATE INDEX utn9_ntw_graph_gmlid_inx       ON citydb.utn9_network_graph USING btree (gmlid, gmlid_codespace);
CREATE INDEX utn9_ntw_graph_objclass_id_fkx ON citydb.utn9_network_graph USING btree (objectclass_id);
CREATE INDEX utn9_ntw_graph_ntw_id_fkx      ON citydb.utn9_network_graph USING btree (network_id);

COMMENT ON TABLE citydb.utn9_network_graph IS 'Topological representation of the network';

COMMENT ON COLUMN citydb.utn9_network_graph.id              IS 'ID';
COMMENT ON COLUMN citydb.utn9_network_graph.objectclass_id  IS 'Objectclass ID of the network graph';
COMMENT ON COLUMN citydb.utn9_network_graph.gmlid           IS 'Gml ID';
COMMENT ON COLUMN citydb.utn9_network_graph.gmlid_codespace IS 'Gml ID codespace';
COMMENT ON COLUMN citydb.utn9_network_graph.name            IS 'Name';
COMMENT ON COLUMN citydb.utn9_network_graph.name_codespace  IS 'Name codespace';
COMMENT ON COLUMN citydb.utn9_network_graph.description     IS 'Description';

----------------------------------------------------------------
-- Table FEATURE_GRAPH (FEATURE prototype)
----------------------------------------------------------------
DROP TABLE IF EXISTS citydb.utn9_feature_graph CASCADE;
CREATE TABLE         citydb.utn9_feature_graph (
	id              serial PRIMARY KEY,
	objectclass_id  integer NOT NULL, -- This is a foreign key to citydb.objectclass.id
	gmlid           varchar,
	gmlid_codespace varchar,
	name            varchar,
	name_codespace  varchar,
	description     text,
	ntw_feature_id  integer,
	ntw_graph_id    integer	
);
-- ALTER TABLE citydb.utn9_feature_graph OWNER TO postgres;

CREATE INDEX utn9_feat_graph_gmlid_inx       ON citydb.utn9_feature_graph USING btree (gmlid, gmlid_codespace);
CREATE INDEX utn9_feat_graph_objclass_id_fkx ON citydb.utn9_feature_graph USING btree (objectclass_id);
CREATE INDEX utn9_feat_graph_ntw_feat_id_fkx ON citydb.utn9_feature_graph USING btree (ntw_feature_id);
CREATE INDEX utn9_feat_graph_ntw_graph_id_fkx ON citydb.utn9_feature_graph USING btree (ntw_graph_id);

COMMENT ON TABLE  citydb.utn9_feature_graph IS 'Topological representation of the network feature';

COMMENT ON COLUMN citydb.utn9_feature_graph.id              IS 'ID';
COMMENT ON COLUMN citydb.utn9_feature_graph.objectclass_id  IS 'Objectclass ID of the network graph';
COMMENT ON COLUMN citydb.utn9_feature_graph.gmlid           IS 'Gml ID';
COMMENT ON COLUMN citydb.utn9_feature_graph.gmlid_codespace IS 'Gml ID codespace';
COMMENT ON COLUMN citydb.utn9_feature_graph.name            IS 'Name';
COMMENT ON COLUMN citydb.utn9_feature_graph.name_codespace  IS 'Name codespace';
COMMENT ON COLUMN citydb.utn9_feature_graph.description     IS 'Description';

----------------------------------------------------------------
-- Table NODE (FEATURE prototype)
----------------------------------------------------------------
DROP TABLE IF EXISTS citydb.utn9_node CASCADE;
CREATE TABLE         citydb.utn9_node (
	id                   serial PRIMARY KEY,
	objectclass_id       integer NOT NULL, -- This is a foreign key to citydb.objectclass.id
	gmlid                varchar,
	gmlid_codespace      varchar,
	name                 varchar,
	name_codespace       varchar,
	description          text,
	type                 varchar CHECK (type IN ('interior', 'exterior')),
	connection_signature varchar,
	link_control         varchar,
	feat_graph_id        integer,
	point_geom           geometry(POINTZ)		
);
-- ALTER TABLE citydb.utn9_node OWNER TO postgres;

CREATE INDEX utn9_node_gmlid_inx       ON citydb.utn9_node USING btree (gmlid, gmlid_codespace);
CREATE INDEX utn9_node_objclass_id_fkx ON citydb.utn9_node USING btree (objectclass_id);
CREATE INDEX utn9_node_feat_graph_id_fkx ON citydb.utn9_node USING btree (feat_graph_id);
CREATE INDEX utn9_node_geom_spx ON citydb.utn9_node USING gist (point_geom gist_geometry_ops_nd);

COMMENT ON TABLE citydb.utn9_node IS 'Topological node';

COMMENT ON COLUMN citydb.utn9_node.id                   IS 'ID';
COMMENT ON COLUMN citydb.utn9_node.objectclass_id       IS 'Objectclass ID of the node';
COMMENT ON COLUMN citydb.utn9_node.gmlid                IS 'Gml ID';
COMMENT ON COLUMN citydb.utn9_node.gmlid_codespace      IS 'Gml ID codespace';
COMMENT ON COLUMN citydb.utn9_node.name                 IS 'Name';
COMMENT ON COLUMN citydb.utn9_node.name_codespace       IS 'Name codespace';
COMMENT ON COLUMN citydb.utn9_node.description          IS 'Description';
COMMENT ON COLUMN citydb.utn9_node.type                 IS 'Type of node';
COMMENT ON COLUMN citydb.utn9_node.connection_signature IS 'Connection signature';
COMMENT ON COLUMN citydb.utn9_node.link_control         IS 'Link control';

----------------------------------------------------------------
-- Table LINK (FEATURE prototype)
----------------------------------------------------------------
DROP TABLE IF EXISTS citydb.utn9_link CASCADE;
CREATE TABLE         citydb.utn9_link (
	id                     serial PRIMARY KEY,
	objectclass_id         integer NOT NULL, -- This is a foreign key to citydb.objectclass.id
	gmlid                  varchar,
	gmlid_codespace        varchar,
	name                   varchar,
	name_codespace         varchar,
	description            text,
	direction              char CHECK (direction IN ('+', '-')),
	link_control           varchar,
	type varchar CHECK (type IN ('connects', 'contains')),
	start_node_id          integer NOT NULL,
	end_node_id            integer NOT NULL,
	feat_graph_id          integer,
	ntw_graph_id           integer,
	line_geom              geometry(LINESTRINGZ)	
);
-- ALTER TABLE citydb.utn9_node OWNER TO postgres;

CREATE INDEX utn9_link_gmlid_inx         ON citydb.utn9_link USING btree (gmlid, gmlid_codespace);
CREATE INDEX utn9_link_objclass_id_fkx   ON citydb.utn9_link USING btree (objectclass_id);
CREATE INDEX utn9_link_start_node_id_fkx ON citydb.utn9_link USING btree (start_node_id);
CREATE INDEX utn9_link_end_node_id_fkx   ON citydb.utn9_link USING btree (end_node_id);
CREATE INDEX utn9_link_feat_graph_id_fkx ON citydb.utn9_link USING btree (feat_graph_id);
CREATE INDEX utn9_link_ntw_graph_id_fkx  ON citydb.utn9_link USING btree (ntw_graph_id);
CREATE INDEX utn9_link_geom_spx ON citydb.utn9_link USING gist (line_geom gist_geometry_ops_nd);

COMMENT ON TABLE citydb.utn9_link IS 'Topological link';

COMMENT ON COLUMN citydb.utn9_link.id                     IS 'ID';
COMMENT ON COLUMN citydb.utn9_link.objectclass_id         IS 'Objectclass ID of the link';
COMMENT ON COLUMN citydb.utn9_link.gmlid                  IS 'Gml ID';
COMMENT ON COLUMN citydb.utn9_link.gmlid_codespace        IS 'Gml ID codespace';
COMMENT ON COLUMN citydb.utn9_link.name                   IS 'Name';
COMMENT ON COLUMN citydb.utn9_link.name_codespace         IS 'Name codespace';
COMMENT ON COLUMN citydb.utn9_link.description            IS 'Description';
COMMENT ON COLUMN citydb.utn9_link.direction              IS 'Link direction (+ or -)';
COMMENT ON COLUMN citydb.utn9_link.link_control           IS 'Link control';
COMMENT ON COLUMN citydb.utn9_link.type IS 'Interfeature link type';

----------------------------------------------------------------
-- Table UTN_BUILDING (_CityObject)
----------------------------------------------------------------
DROP TABLE IF EXISTS citydb.utn9_building CASCADE;
CREATE TABLE         citydb.utn9_building (
	id                   integer PRIMARY KEY,	-- This is a foreign key to cityobject.id
	objectclass_id       integer NOT NULL, 	  -- This is a foreign key to objectclass.id
	nbr_occupants        integer
);
-- ALTER TABLE citydb.utn9_network OWNER TO postgres;

CREATE INDEX utn9_bdg_objclass_id_fkx ON citydb.utn9_building USING btree (objectclass_id);

COMMENT ON TABLE citydb.utn9_building IS 'Extension of the BUILDING table for the UtilityNetworks ADE';

COMMENT ON COLUMN citydb.utn9_building.objectclass_id  IS 'Objectclass ID of the building';
COMMENT ON COLUMN citydb.utn9_building.nbr_occupants IS 'Number of occupants';

--------------------
-- Table MEDIUM_SUPPLY (electrical, gaseous, liquid, optical, solid)
--------------------
DROP TABLE IF EXISTS citydb.utn9_medium_supply CASCADE;
CREATE TABLE         citydb.utn9_medium_supply (
 id                 serial PRIMARY KEY,
 objectclass_id     integer NOT NULL,-- This is a foreign key to objectclass.id	
 type               varchar NOT NULL,-- (This is a foreign key to lu_medium_supply.id)
 cur_flow_rate      numeric,
 cur_flow_rate_unit varchar,
 cur_status         varchar,	     -- This is a foreign key to lu_status.id
 pot_flow_rate      numeric,
 pot_flow_rate_unit varchar,
 pot_status         varchar,         -- This is a foreign key to lu_status.id
 cityobject_id      integer	         -- This is a foreign key to cityobject.id
);
-- ALTER TABLE citydb.utn9_medium_supply OWNER TO postgres;

CREATE INDEX utn9_medium_supply_objclass_id_fkx ON citydb.utn9_medium_supply USING btree (objectclass_id);
CREATE INDEX utn9_medium_supply_type_fkx        ON citydb.utn9_medium_supply USING btree (type);
CREATE INDEX utn9_medium_supply_ctyobj_id_fkx   ON citydb.utn9_medium_supply USING btree (cityobject_id);

CREATE INDEX utn9_medium_supply_cur_status_fkx   ON citydb.utn9_medium_supply USING btree (cur_status);
CREATE INDEX utn9_medium_supply_pot_status_fkx   ON citydb.utn9_medium_supply USING btree (pot_status);

COMMENT ON TABLE citydb.utn9_medium_supply IS 'Medium supply';

COMMENT ON COLUMN citydb.utn9_medium_supply.objectclass_id      IS 'Objectclass ID of the medium supply';
COMMENT ON COLUMN citydb.utn9_medium_supply.type                IS 'Type of the medium supply';
COMMENT ON COLUMN citydb.utn9_medium_supply.cur_flow_rate       IS 'Current supply flow rate';
COMMENT ON COLUMN citydb.utn9_medium_supply.cur_flow_rate_unit  IS 'Unit of current supply flow rate';
COMMENT ON COLUMN citydb.utn9_medium_supply.cur_status          IS 'Current supply status';
COMMENT ON COLUMN citydb.utn9_medium_supply.pot_flow_rate       IS 'Potential supply flow rate';
COMMENT ON COLUMN citydb.utn9_medium_supply.pot_flow_rate_unit  IS 'Unit of potential supply flow rate';
COMMENT ON COLUMN citydb.utn9_medium_supply.pot_status          IS 'Potential supply status';

--------------------
-- Table STORAGE
--------------------
DROP TABLE IF EXISTS citydb.utn9_storage CASCADE;
CREATE TABLE         citydb.utn9_storage (
 id                serial PRIMARY KEY,
 type              varchar,	-- (This is a foreign key to lu_storage_device.id)
 max_capacity      numeric,	
 max_capacity_unit varchar,
 fill_level        numeric CHECK (fill_level BETWEEN 0 AND 1),
 inflow_rate       numeric,
 inflow_rate_unit  varchar,
 outflow_rate      numeric,
 outflow_rate_unit varchar,	
 medium_supply_id  integer	-- This is a foreign key to utn_medium_supply.id
);
-- ALTER TABLE citydb.utn9_storage OWNER TO postgres;

CREATE INDEX utn9_storage_medium_supply_id_fkx   ON citydb.utn9_storage USING btree (medium_supply_id);

COMMENT ON TABLE citydb.utn9_storage IS 'Storage';

COMMENT ON COLUMN citydb.utn9_storage.id                    IS 'ID';
COMMENT ON COLUMN citydb.utn9_storage.type                  IS 'Type of storage';
COMMENT ON COLUMN citydb.utn9_storage.max_capacity          IS 'Maximum capacity';
COMMENT ON COLUMN citydb.utn9_storage.max_capacity_unit     IS 'Unit of maximum capacity';
COMMENT ON COLUMN citydb.utn9_storage.fill_level            IS 'Fill level';
COMMENT ON COLUMN citydb.utn9_storage.inflow_rate           IS 'Inflow rate';
COMMENT ON COLUMN citydb.utn9_storage.inflow_rate_unit      IS 'Unit of inflow rate';
COMMENT ON COLUMN citydb.utn9_storage.outflow_rate          IS 'Outflow rate';
COMMENT ON COLUMN citydb.utn9_storage.outflow_rate_unit     IS 'Unit of outflow rate';

-- --------------------------------------------------------------
-- Table ROLE_IN_NETWORK (FEATURE prototype)
-- --------------------------------------------------------------
DROP TABLE IF EXISTS citydb.utn9_role_in_network CASCADE;
CREATE TABLE         citydb.utn9_role_in_network (
 id              serial PRIMARY KEY,
 objectclass_id  integer NOT NULL, -- This is a foreign key to citydb.objectclass.id
 gmlid           varchar,
 gmlid_codespace varchar,
 name            varchar,
 name_codespace  varchar,
 description     text,
 function        varchar,
 usage           varchar,
 cityobject_id   integer,	      -- This is a foreign key to cityobject.id
 network_id      integer           -- This is a foreign key to utn_network.id
);
-- ALTER TABLE citydb.utn9_role_in_network OWNER TO postgres;

CREATE INDEX utn9_role_in_network_gmlid_inx       ON citydb.utn9_role_in_network USING btree (gmlid, gmlid_codespace);
CREATE INDEX utn9_role_in_network_objclass_id_fkx ON citydb.utn9_role_in_network USING btree (objectclass_id);
CREATE INDEX utn9_role_in_network_ctyobj_id_fkx   ON citydb.utn9_role_in_network USING btree (cityobject_id);
CREATE INDEX utn9_role_in_network_ntw_id_fkx      ON citydb.utn9_role_in_network USING btree (network_id);

COMMENT ON TABLE citydb.utn9_role_in_network IS 'Role in network';

COMMENT ON COLUMN citydb.utn9_role_in_network.id              IS 'ID';
COMMENT ON COLUMN citydb.utn9_role_in_network.objectclass_id  IS 'Objectclass ID of the role in network';
COMMENT ON COLUMN citydb.utn9_role_in_network.gmlid           IS 'Gml ID';
COMMENT ON COLUMN citydb.utn9_role_in_network.gmlid_codespace IS 'Gml ID codespace';
COMMENT ON COLUMN citydb.utn9_role_in_network.name            IS 'Name';
COMMENT ON COLUMN citydb.utn9_role_in_network.name_codespace  IS 'Name codespace';
COMMENT ON COLUMN citydb.utn9_role_in_network.description     IS 'Description';
COMMENT ON COLUMN citydb.utn9_role_in_network.function        IS 'Function in network';
COMMENT ON COLUMN citydb.utn9_role_in_network.usage           IS 'Usage in network';

----------------------------------------------------------------
-- Table COMMODITY (FEATURE prototype)
----------------------------------------------------------------
DROP TABLE IF EXISTS citydb.utn9_commodity CASCADE;
CREATE TABLE         citydb.utn9_commodity (
	id                           serial PRIMARY KEY,
	objectclass_id               integer NOT NULL, -- This is a foreign key to citydb.objectclass.id
	gmlid                        varchar,
	gmlid_codespace              varchar,
	name                         varchar,
	name_codespace               varchar,
	description                  text,
	owner                        varchar,
	type                         varchar NOT NULL,
	is_corrosive                 numeric(1),
	is_explosive                 numeric(1),
	is_lighter_than_air          numeric(1),
	flammability_ratio           numeric CHECK (flammability_ratio BETWEEN 0 AND 1),
	elec_conductivity_range_from numeric,
	elec_conductivity_range_to   numeric,	
	elec_conductivity_range_unit varchar,
	concentration                numeric,
	concentration_unit           varchar,	
	ph_value_range_from          numeric,
	ph_value_range_to            numeric,
	ph_value_range_unit          varchar,	
	temperature_range_from       numeric,
	temperature_range_to         numeric,
	temperature_range_unit       varchar,	
	flow_rate_range_from         numeric,
	flow_rate_range_to           numeric,
	flow_rate_range_unit         varchar,		
	pressure_range_from          numeric,
	pressure_range_to            numeric,
	pressure_range_unit          varchar,
	voltage_range_from           numeric,
	voltage_range_to             numeric,
	voltage_range_unit           varchar,
	amperage_range_from          numeric,
	amperage_range_to            numeric,
	amperage_range_unit          varchar,
	bandwidth_range_from         numeric,
	bandwidth_range_to           numeric,
	bandwidth_range_unit         varchar,
	optical_mode	             varchar
--	core_cross_section          numeric,
--	core_cross_section_unit     varchar,
--	cladding_cross_section      numeric,
--	cladding_cross_section_unit varchar	
);
-- ALTER TABLE citydb.utn9_commodity OWNER TO postgres;

CREATE INDEX utn9_commodity_gmlid_inx       ON citydb.utn9_commodity USING btree (gmlid, gmlid_codespace);
CREATE INDEX utn9_commodity_objclass_id_fkx ON citydb.utn9_commodity USING btree (objectclass_id);

COMMENT ON TABLE citydb.utn9_commodity IS 'Commodity';

COMMENT ON COLUMN citydb.utn9_commodity.id                           IS 'ID';
COMMENT ON COLUMN citydb.utn9_commodity.objectclass_id               IS 'Objectclass ID of the commodity';
COMMENT ON COLUMN citydb.utn9_commodity.gmlid                        IS 'Gml ID';
COMMENT ON COLUMN citydb.utn9_commodity.gmlid_codespace              IS 'Gml ID codespace';
COMMENT ON COLUMN citydb.utn9_commodity.name                         IS 'Name';
COMMENT ON COLUMN citydb.utn9_commodity.name_codespace               IS 'Name codespace';
COMMENT ON COLUMN citydb.utn9_commodity.description                  IS 'Description';
COMMENT ON COLUMN citydb.utn9_commodity.owner                        IS 'Owner';
COMMENT ON COLUMN citydb.utn9_commodity.type                         IS 'Type of commodity';
COMMENT ON COLUMN citydb.utn9_commodity.is_corrosive                 IS 'Is corrosive?';
COMMENT ON COLUMN citydb.utn9_commodity.is_explosive                 IS 'Is explosive?';
COMMENT ON COLUMN citydb.utn9_commodity.is_lighter_than_air          IS 'Is lighter than air?';
COMMENT ON COLUMN citydb.utn9_commodity.flammability_ratio           IS 'Flammability ratio, value in [0,1]';
COMMENT ON COLUMN citydb.utn9_commodity.elec_conductivity_range_from IS 'Electrical conductivity rage: min value';
COMMENT ON COLUMN citydb.utn9_commodity.elec_conductivity_range_to   IS 'Electrical conductivity rage: max value';
COMMENT ON COLUMN citydb.utn9_commodity.elec_conductivity_range_unit IS 'Unit of electrical conductivity';
COMMENT ON COLUMN citydb.utn9_commodity.concentration                IS 'Concentration';
COMMENT ON COLUMN citydb.utn9_commodity.concentration_unit           IS 'Unit of concentration';
COMMENT ON COLUMN citydb.utn9_commodity.ph_value_range_from          IS 'Ph value range: min value';
COMMENT ON COLUMN citydb.utn9_commodity.ph_value_range_to            IS 'Ph value range: max value';
COMMENT ON COLUMN citydb.utn9_commodity.ph_value_range_unit          IS 'Unit of Ph value';
COMMENT ON COLUMN citydb.utn9_commodity.temperature_range_from       IS 'Temperature range: min value';
COMMENT ON COLUMN citydb.utn9_commodity.temperature_range_to         IS 'Temperature range: max value';
COMMENT ON COLUMN citydb.utn9_commodity.temperature_range_unit       IS 'Unit of temperature';
COMMENT ON COLUMN citydb.utn9_commodity.flow_rate_range_from         IS 'Flow_rate range: min value';
COMMENT ON COLUMN citydb.utn9_commodity.flow_rate_range_to           IS 'Flow_rate range: max value';
COMMENT ON COLUMN citydb.utn9_commodity.flow_rate_range_unit         IS 'Unit of flow_rate';
COMMENT ON COLUMN citydb.utn9_commodity.pressure_range_from          IS 'Pressure range: min value';
COMMENT ON COLUMN citydb.utn9_commodity.pressure_range_to            IS 'Pressure range: max value';
COMMENT ON COLUMN citydb.utn9_commodity.pressure_range_unit          IS 'Unit of pressure';
COMMENT ON COLUMN citydb.utn9_commodity.voltage_range_from           IS 'Voltage range: min value';
COMMENT ON COLUMN citydb.utn9_commodity.voltage_range_to             IS 'Voltage range: max value';
COMMENT ON COLUMN citydb.utn9_commodity.voltage_range_unit           IS 'Unit of voltage';
COMMENT ON COLUMN citydb.utn9_commodity.amperage_range_from          IS 'Amperage range: min value';
COMMENT ON COLUMN citydb.utn9_commodity.amperage_range_to            IS 'Amperage range: max value';
COMMENT ON COLUMN citydb.utn9_commodity.amperage_range_unit          IS 'Unit of ';
COMMENT ON COLUMN citydb.utn9_commodity.bandwidth_range_from         IS 'Bandwidth range: min value';
COMMENT ON COLUMN citydb.utn9_commodity.bandwidth_range_to           IS 'Bandwidth range: max value';
COMMENT ON COLUMN citydb.utn9_commodity.bandwidth_range_unit         IS 'Unit of bandwidth';
COMMENT ON COLUMN citydb.utn9_commodity.optical_mode                 IS 'Optical mode';

----------------------------------------------------------------
-- Table COMMODITY_CLASSIFIER (FEATURE prototype)
----------------------------------------------------------------
DROP TABLE IF EXISTS citydb.utn9_commodity_classifier CASCADE;
CREATE TABLE         citydb.utn9_commodity_classifier (
	id                          serial PRIMARY KEY,
--	comm_classifier_parent_id   integer,
--	comm_classifier_root_id     integer,
	objectclass_id              integer NOT NULL, -- This is a foreign key to citydb.objectclass.id
	gmlid                       varchar,
	gmlid_codespace             varchar,
	name                        varchar,
	name_codespace              varchar,
	description                 text,
	mol_formula                 varchar,
	mol_weight                  numeric,
	mol_weight_unit             numeric,
	physical_form               varchar,
	signal_word                 varchar,  -- This is a foreign key to utn9_lu_signal_word.id
	is_chemical_complex         numeric(1),
	haz_class                   varchar,
	haz_class_category_code     varchar,
	haz_class_statement_code    varchar,
	haz_class_pictogram_code    varchar,
	haz_class_pictogram_uri     varchar,
	ec_number                   varchar,
	cas_number                  varchar,
	iuclid_chem_datasheet       varchar,
	commodity_id                integer,
	material_id                 integer,
	hollow_space_id             integer
);
-- ALTER TABLE citydb.utn9_commodity_classifier OWNER TO postgres;

CREATE INDEX utn9_comm_class_gmlid_inx         ON citydb.utn9_commodity_classifier USING btree (gmlid, gmlid_codespace);
--CREATE INDEX utn9_comm_class_parent_id_fkx       ON citydb.utn9_commodity_classifier USING btree (comm_classifier_parent_id);
--CREATE INDEX utn9_comm_class_root_id_fkx       ON citydb.utn9_commodity_classifier USING btree (comm_classifier_root_id);
CREATE INDEX utn9_comm_class_objclass_id_fkx   ON citydb.utn9_commodity_classifier USING btree (objectclass_id);
CREATE INDEX utn9_comm_class_comm_id_fkx       ON citydb.utn9_commodity_classifier USING btree (commodity_id);
CREATE INDEX utn9_comm_class_mat_id_fkx        ON citydb.utn9_commodity_classifier USING btree (material_id);
CREATE INDEX utn9_comm_class_hollow_spc_id_fkx ON citydb.utn9_commodity_classifier USING btree (hollow_space_id);

CREATE INDEX utn9_comm_class_signal_word_fkx ON citydb.utn9_commodity_classifier USING btree (signal_word);

COMMENT ON TABLE citydb.utn9_commodity_classifier IS 'Commodity classifier';

COMMENT ON COLUMN citydb.utn9_commodity_classifier.id                        IS 'ID';
COMMENT ON COLUMN citydb.utn9_commodity_classifier.objectclass_id            IS 'Objectclass ID of the commodity classifier';
COMMENT ON COLUMN citydb.utn9_commodity_classifier.gmlid                     IS 'Gml ID';
COMMENT ON COLUMN citydb.utn9_commodity_classifier.gmlid_codespace           IS 'Gml ID codespace';
COMMENT ON COLUMN citydb.utn9_commodity_classifier.name                      IS 'Name';
COMMENT ON COLUMN citydb.utn9_commodity_classifier.name_codespace            IS 'Name codespace';
COMMENT ON COLUMN citydb.utn9_commodity_classifier.description               IS 'Description';
COMMENT ON COLUMN citydb.utn9_commodity_classifier.mol_formula               IS 'Molecular formula';
COMMENT ON COLUMN citydb.utn9_commodity_classifier.mol_weight                IS 'Molecular weigth';
COMMENT ON COLUMN citydb.utn9_commodity_classifier.mol_weight_unit           IS 'Unit of molecular weight';
COMMENT ON COLUMN citydb.utn9_commodity_classifier.physical_form             IS 'Phisical form';
COMMENT ON COLUMN citydb.utn9_commodity_classifier.signal_word               IS 'Signal word';
COMMENT ON COLUMN citydb.utn9_commodity_classifier.is_chemical_complex       IS 'Is a chemical complex?	';
COMMENT ON COLUMN citydb.utn9_commodity_classifier.haz_class                 IS 'Hazard class';
COMMENT ON COLUMN citydb.utn9_commodity_classifier.haz_class_category_code   IS 'Hazard class: category code';
COMMENT ON COLUMN citydb.utn9_commodity_classifier.haz_class_statement_code  IS 'Hazard class: statement code';
COMMENT ON COLUMN citydb.utn9_commodity_classifier.haz_class_pictogram_code  IS 'Hazard class: pictogram code';
COMMENT ON COLUMN citydb.utn9_commodity_classifier.haz_class_pictogram_uri   IS 'Hazard class: pictogram URI';
COMMENT ON COLUMN citydb.utn9_commodity_classifier.ec_number                 IS 'EC number';
COMMENT ON COLUMN citydb.utn9_commodity_classifier.cas_number                IS 'Cas number';
COMMENT ON COLUMN citydb.utn9_commodity_classifier.iuclid_chem_datasheet     IS 'IUCLID Chemical Datasheet';

----------------------------------------------------------------
-- Table COMM_CLASS_TO_COMM_CLASS
----------------------------------------------------------------
DROP TABLE IF EXISTS citydb.utn9_comm_class_to_comm_class CASCADE;
CREATE TABLE         citydb.utn9_comm_class_to_comm_class(
	comm_class_parent_id   integer NOT NULL,
	comm_class_id          integer NOT NULL,
	CONSTRAINT utn9_comm_class_to_comm_class_pk PRIMARY KEY (comm_class_parent_id, comm_class_id)
);
--ALTER TABLE citydb.utn9_comm_class_to_comm_class OWNER TO postgres;

CREATE INDEX utn9_comm_class_to_comm_class_parent_class_id_fkx ON citydb.utn9_comm_class_to_comm_class USING btree (comm_class_parent_id);
CREATE INDEX utn9_comm_class_to_comm_class_class_id_fkx        ON citydb.utn9_comm_class_to_comm_class USING btree (comm_class_id);

----------------------------------------------------------------
-- Table MATERIAL (FEATURE prototype)
----------------------------------------------------------------
DROP TABLE IF EXISTS citydb.utn9_material CASCADE;
CREATE TABLE         citydb.utn9_material (
	id                 serial PRIMARY KEY,
	objectclass_id     integer NOT NULL, -- This is a foreign key to citydb.objectclass.id
	material_parent_id integer,
	material_root_id   integer,
	gmlid              varchar,
	gmlid_codespace    varchar,
	name               varchar,
	name_codespace     varchar,
	description        text,
	type               varchar,
	material_id        integer	
);
-- ALTER TABLE citydb.utn9_material OWNER TO postgres;

CREATE INDEX utn9_mat_mat_parent_id_fkx ON citydb.utn9_material USING btree (material_parent_id);
CREATE INDEX utn9_mat_mat_root_id_fkx   ON citydb.utn9_material USING btree (material_root_id);
CREATE INDEX utn9_mat_gmlid_inx         ON citydb.utn9_material USING btree (gmlid, gmlid_codespace);
CREATE INDEX utn9_mat_objclass_id_fkx   ON citydb.utn9_material USING btree (objectclass_id);
CREATE INDEX utn9_mat_mat_id_fkx        ON citydb.utn9_material USING btree (material_id);

COMMENT ON TABLE citydb.utn9_material IS 'Material';

COMMENT ON COLUMN citydb.utn9_material.id                        IS 'ID';
COMMENT ON COLUMN citydb.utn9_material.objectclass_id            IS 'Objectclass ID of the material';
COMMENT ON COLUMN citydb.utn9_material.gmlid                     IS 'Gml ID';
COMMENT ON COLUMN citydb.utn9_material.gmlid_codespace           IS 'Gml ID codespace';
COMMENT ON COLUMN citydb.utn9_material.name                      IS 'Name';
COMMENT ON COLUMN citydb.utn9_material.name_codespace            IS 'Name codespace';
COMMENT ON COLUMN citydb.utn9_material.description               IS 'Description';
COMMENT ON COLUMN citydb.utn9_material.type                      IS 'Type of material';

----------------------------------------------------------------
-- Table NETWORK_FEAT_TO_MATERIAL
----------------------------------------------------------------
DROP TABLE IF EXISTS citydb.utn9_network_feat_to_material CASCADE;
CREATE TABLE         citydb.utn9_network_feat_to_material (
	network_feature_id integer NOT NULL,
	material_id integer NOT NULL,
	CONSTRAINT utn9_network_feat_to_material_pk PRIMARY KEY (network_feature_id, material_id)
);
--ALTER TABLE citydb.utn9_x_to_y OWNER TO postgres;

CREATE INDEX utn9_ntw_feat_to_mat_ntw_feat_id_fkx ON citydb.utn9_network_feat_to_material USING btree (network_feature_id);
CREATE INDEX utn9_ntw_feat_to_mat_mat_id_fkx ON citydb.utn9_network_feat_to_material USING btree (material_id);

----------------------------------------------------------------
-- Table HOLLOW_SPACE (FEATURE prototype)
----------------------------------------------------------------
DROP TABLE IF EXISTS citydb.utn9_hollow_space CASCADE;
CREATE TABLE         citydb.utn9_hollow_space (
	id                 serial PRIMARY KEY,
	objectclass_id     integer NOT NULL, -- This is a foreign key to citydb.objectclass.id
	hol_spc_parent_id  integer,
	hol_spc_root_id    integer,
	gmlid              varchar,
	gmlid_codespace    varchar,
	name               varchar,
	name_codespace     varchar,
	description        text,
-- OTHER ATTRIBUTES ?	
	ntw_feature_id     integer
);
-- ALTER TABLE citydb.utn9_hollow_space OWNER TO postgres;

CREATE INDEX utn9_hollow_spc_gmlid_inx         ON citydb.utn9_hollow_space USING btree (gmlid, gmlid_codespace);
CREATE INDEX utn9_hollow_spc_objclass_id_fkx   ON citydb.utn9_hollow_space USING btree (objectclass_id);
CREATE INDEX utn9_hollow_spc_ntw_feat_id_fkx   ON citydb.utn9_hollow_space USING btree (ntw_feature_id);

COMMENT ON TABLE citydb.utn9_hollow_space IS 'Hollow space';

COMMENT ON COLUMN citydb.utn9_hollow_space.id              IS 'ID';
COMMENT ON COLUMN citydb.utn9_hollow_space.objectclass_id  IS 'Objectclass ID of the hollow space';
COMMENT ON COLUMN citydb.utn9_hollow_space.gmlid           IS 'Gml ID';
COMMENT ON COLUMN citydb.utn9_hollow_space.gmlid_codespace IS 'Gml ID codespace';
COMMENT ON COLUMN citydb.utn9_hollow_space.name            IS 'Name';
COMMENT ON COLUMN citydb.utn9_hollow_space.name_codespace  IS 'Name codespace';
COMMENT ON COLUMN citydb.utn9_hollow_space.description     IS 'Description';


-- **********************************************************************
-- FOREIGN KEYS CONSTRAINTS
-- **********************************************************************

-- FOREIGN KEY constraint on Table NETWORK
ALTER TABLE IF EXISTS citydb.utn9_network ADD CONSTRAINT utn9_ntw_ctyobj_fk FOREIGN KEY (id) REFERENCES citydb.cityobject (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;
ALTER TABLE IF EXISTS citydb.utn9_network ADD CONSTRAINT utn9_ntw_objclass_fk FOREIGN KEY (objectclass_id) REFERENCES citydb.objectclass (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;
ALTER TABLE IF EXISTS citydb.utn9_network ADD CONSTRAINT utn9_ntw_utn_ntw_fk1 FOREIGN KEY (network_parent_id) REFERENCES citydb.utn9_network (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;
ALTER TABLE IF EXISTS citydb.utn9_network ADD CONSTRAINT utn9_ntw_utn_ntw_fk2 FOREIGN KEY (network_root_id) REFERENCES citydb.utn9_network (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;
ALTER TABLE IF EXISTS citydb.utn9_network ADD CONSTRAINT utn9_ntw_utn_comm_fk2 FOREIGN KEY (commodity_id) REFERENCES citydb.utn9_commodity (id) MATCH FULL ON UPDATE CASCADE ON DELETE SET NULL;

ALTER TABLE IF EXISTS citydb.utn9_network ADD CONSTRAINT utn9_ntw_lu_ntw_class_fk FOREIGN KEY (class) REFERENCES citydb.utn9_lu_network_class (id) MATCH FULL ON UPDATE CASCADE ON DELETE SET NULL;

-- FOREIGN KEY constraint on Table NETWORK_TO_NETWORK
ALTER TABLE IF EXISTS citydb.utn9_network_to_network ADD CONSTRAINT utn9_ntw_to_ntw_fk1 FOREIGN KEY (superordinate_network_id) REFERENCES citydb.utn9_network (id) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE IF EXISTS citydb.utn9_network_to_network ADD CONSTRAINT utn9_ntw_to_ntw_fk2 FOREIGN KEY (subordinate_network_id) REFERENCES citydb.utn9_network (id) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;

-- FOREIGN KEY constraint on Table NETWORK_TO_SUPPLY_AREA
ALTER TABLE IF EXISTS citydb.utn9_network_to_supply_area ADD CONSTRAINT utn9_ntw_to_sup_area_fk1 FOREIGN KEY (network_id) REFERENCES citydb.utn9_network (id) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE IF EXISTS citydb.utn9_network_to_supply_area ADD CONSTRAINT utn9_ntw_to_sup_area_fk2 FOREIGN KEY (supply_area_id) REFERENCES citydb.cityobjectgroup (id) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;

-- FOREIGN KEY constraint on Table NETWORK_FEATURE
ALTER TABLE IF EXISTS citydb.utn9_network_feature ADD CONSTRAINT utn9_ntw_feat_ctyobj_fk1 FOREIGN KEY (id) REFERENCES citydb.cityobject (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;
ALTER TABLE IF EXISTS citydb.utn9_network_feature ADD CONSTRAINT utn9_ntw_feat_objclass_fk FOREIGN KEY (objectclass_id) REFERENCES citydb.objectclass (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;
ALTER TABLE IF EXISTS citydb.utn9_network_feature ADD CONSTRAINT utn9_ntw_feat_utn_ntw_feat_fk1 FOREIGN KEY (ntw_feature_parent_id) REFERENCES citydb.utn9_network_feature (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;
ALTER TABLE IF EXISTS citydb.utn9_network_feature ADD CONSTRAINT utn9_ntw_feat_utn_ntw_feat_fk2 FOREIGN KEY (ntw_feature_root_id) REFERENCES citydb.utn9_network_feature (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;
ALTER TABLE IF EXISTS citydb.utn9_network_feature ADD CONSTRAINT utn9_ntw_feat_ctyobj_fk2 FOREIGN KEY (conn_cityobject_id) REFERENCES citydb.cityobject (id) MATCH FULL ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE IF EXISTS citydb.utn9_network_feature ADD CONSTRAINT utn9_ntw_feat_utn_prot_elem_fk FOREIGN KEY (prot_element_id) REFERENCES citydb.utn9_protective_element (id) MATCH FULL ON UPDATE CASCADE ON DELETE SET NULL;

ALTER TABLE IF EXISTS citydb.utn9_network_feature ADD CONSTRAINT utn9_ntw_feat_lu_spat_qual_fk1 FOREIGN KEY (location_quality) REFERENCES citydb.utn9_lu_spatial_quality (id) MATCH FULL ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE IF EXISTS citydb.utn9_network_feature ADD CONSTRAINT utn9_ntw_feat_lu_spat_qual_fk2 FOREIGN KEY (elevation_quality) REFERENCES citydb.utn9_lu_spatial_quality (id) MATCH FULL ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE IF EXISTS citydb.utn9_network_feature ADD CONSTRAINT utn9_ntw_feat_lu_status_fk FOREIGN KEY (status) REFERENCES citydb.utn9_lu_status (id) MATCH FULL ON UPDATE CASCADE ON DELETE SET NULL;


-- FOREIGN KEY constraint on Table DISTRIB_ELEMENT
ALTER TABLE IF EXISTS citydb.utn9_distrib_element ADD CONSTRAINT utn9_distrib_elem_utn_ntw_feat_fk FOREIGN KEY (id) REFERENCES citydb.utn9_network_feature (id) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE IF EXISTS citydb.utn9_distrib_element ADD CONSTRAINT utn9_distrib_elem_objclass_fk FOREIGN KEY (objectclass_id) REFERENCES citydb.objectclass (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;

-- FOREIGN KEY constraint on Table PROTECTIVE_ELEMENT
ALTER TABLE IF EXISTS citydb.utn9_protective_element ADD CONSTRAINT utn9_prot_elem_utn_ntw_feat_fk FOREIGN KEY (id) REFERENCES citydb.utn9_network_feature (id) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE IF EXISTS citydb.utn9_protective_element ADD CONSTRAINT utn9_prot_elem_objclass_fk FOREIGN KEY (objectclass_id) REFERENCES citydb.objectclass (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;

-- FOREIGN KEY constraint on Table NETWORK_TO_NETWORK_FEATURE
ALTER TABLE IF EXISTS citydb.utn9_network_to_network_feature ADD CONSTRAINT utn9_ntw_to_ntw_feat_fk1 FOREIGN KEY (network_id) REFERENCES citydb.utn9_network (id) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE IF EXISTS citydb.utn9_network_to_network_feature ADD CONSTRAINT utn9_ntw_to_ntw_feat_fk2 FOREIGN KEY (network_feature_id) REFERENCES citydb.utn9_network_feature (id) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;

-- FOREIGN KEY constraint on Table NETWORK_GRAPH
ALTER TABLE IF EXISTS citydb.utn9_network_graph ADD CONSTRAINT utn9_ntw_graph_objclass_fk FOREIGN KEY (objectclass_id) REFERENCES citydb.objectclass (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;
ALTER TABLE IF EXISTS citydb.utn9_network_graph ADD CONSTRAINT utn9_ntw_graph_utn_ntw_fk FOREIGN KEY (network_id) REFERENCES citydb.utn9_network (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;

-- FOREIGN KEY constraint on Table FEATURE_GRAPH
ALTER TABLE IF EXISTS citydb.utn9_feature_graph ADD CONSTRAINT utn9_feat_graph_objclass_fk FOREIGN KEY (objectclass_id) REFERENCES citydb.objectclass (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;
ALTER TABLE IF EXISTS citydb.utn9_feature_graph ADD CONSTRAINT utn9_feat_graph_utn_ntw_feat_fk FOREIGN KEY (ntw_feature_id) REFERENCES citydb.utn9_network_feature (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;
ALTER TABLE IF EXISTS citydb.utn9_feature_graph ADD CONSTRAINT utn9_feat_graph_utn_ntw_graph_fk FOREIGN KEY (ntw_graph_id) REFERENCES citydb.utn9_network_graph (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;

-- FOREIGN KEY constraint on Table NODE
ALTER TABLE IF EXISTS citydb.utn9_node ADD CONSTRAINT utn9_node_objclass_fk FOREIGN KEY (objectclass_id) REFERENCES citydb.objectclass (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;
ALTER TABLE IF EXISTS citydb.utn9_node ADD CONSTRAINT utn9_node_utn_feat_graph_fk FOREIGN KEY (feat_graph_id) REFERENCES citydb.utn9_feature_graph (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;

-- FOREIGN KEY constraint on Table LINK
ALTER TABLE IF EXISTS citydb.utn9_link ADD CONSTRAINT utn9_link_objclass_fk FOREIGN KEY (objectclass_id) REFERENCES citydb.objectclass (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;
ALTER TABLE IF EXISTS citydb.utn9_link ADD CONSTRAINT utn9_link_utn_node_fk1 FOREIGN KEY (start_node_id) REFERENCES citydb.utn9_node (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;
ALTER TABLE IF EXISTS citydb.utn9_link ADD CONSTRAINT utn9_link_utn_node_fk2 FOREIGN KEY (end_node_id) REFERENCES citydb.utn9_node (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;
ALTER TABLE IF EXISTS citydb.utn9_link ADD CONSTRAINT utn9_link_utn_feat_graph_fk FOREIGN KEY (feat_graph_id) REFERENCES citydb.utn9_feature_graph (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;
ALTER TABLE IF EXISTS citydb.utn9_link ADD CONSTRAINT utn9_link_utn_ntw_graph_fk FOREIGN KEY (ntw_graph_id) REFERENCES citydb.utn9_network_graph (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;

-- FOREIGN KEY constraint on Table UTN9_BUILDING
ALTER TABLE IF EXISTS citydb.utn9_building ADD CONSTRAINT utn9_bdg_bdg_fk FOREIGN KEY (id) REFERENCES citydb.building (id) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE IF EXISTS citydb.utn9_building ADD CONSTRAINT utn9_bdg_objclass_fk FOREIGN KEY (objectclass_id) REFERENCES citydb.objectclass (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;

-- FOREIGN KEY constraint on Table MEDIUM_SUPPLY
ALTER TABLE IF EXISTS citydb.utn9_medium_supply ADD CONSTRAINT utn9_med_sup_objclass_fk FOREIGN KEY (objectclass_id) REFERENCES citydb.objectclass (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;
ALTER TABLE IF EXISTS citydb.utn9_medium_supply ADD CONSTRAINT utn9_med_sup_ctyobj_fk FOREIGN KEY (cityobject_id) REFERENCES citydb.cityobject (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;

ALTER TABLE IF EXISTS citydb.utn9_medium_supply ADD CONSTRAINT utn9_med_sup_lu_status_fk1 FOREIGN KEY (cur_status) REFERENCES citydb.utn9_lu_status (id) MATCH FULL ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE IF EXISTS citydb.utn9_medium_supply ADD CONSTRAINT utn9_med_sup_lu_status_fk2 FOREIGN KEY (pot_status) REFERENCES citydb.utn9_lu_status (id) MATCH FULL ON UPDATE CASCADE ON DELETE SET NULL;

-- FOREIGN KEY constraint on Table STORAGE
ALTER TABLE IF EXISTS citydb.utn9_storage ADD CONSTRAINT utn9_stor_utn_med_sup_fk FOREIGN KEY (medium_supply_id) REFERENCES citydb.utn9_medium_supply (id) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;

-- FOREIGN KEY constraint on Table ROLE_IN_NETWORK
ALTER TABLE IF EXISTS citydb.utn9_role_in_network ADD CONSTRAINT utn9_role_in_ntw_objclass_fk FOREIGN KEY (objectclass_id) REFERENCES citydb.objectclass (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;
ALTER TABLE IF EXISTS citydb.utn9_role_in_network ADD CONSTRAINT utn9_role_in_ntw_ctyobj_fk FOREIGN KEY (cityobject_id) REFERENCES citydb.cityobject (id) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE IF EXISTS citydb.utn9_role_in_network ADD CONSTRAINT utn9_role_in_ntw_utn_ntw_fk FOREIGN KEY (network_id) REFERENCES citydb.utn9_network (id) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;

-- FOREIGN KEY constraint on Table COMMODITY
ALTER TABLE IF EXISTS citydb.utn9_commodity ADD CONSTRAINT utn9_comm_objclass_fk FOREIGN KEY (objectclass_id) REFERENCES citydb.objectclass (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;

-- FOREIGN KEY constraint on Table COMMODITY_CLASSIFIER
--ALTER TABLE IF EXISTS citydb.utn9_commodity_classifier ADD CONSTRAINT utn9_comm_classt_utn_comm_class_fk1 FOREIGN KEY (comm_classifier_parent_id) REFERENCES citydb.utn9_commodity_classifier (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;
--ALTER TABLE IF EXISTS citydb.utn9_commodity_classifier ADD CONSTRAINT utn9_comm_class_utn_comm_class_fk2 FOREIGN KEY (comm_classifier_root_id) REFERENCES citydb.utn9_commodity_classifier (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;
ALTER TABLE IF EXISTS citydb.utn9_commodity_classifier ADD CONSTRAINT utn9_comm_class_objclass_fk FOREIGN KEY (objectclass_id) REFERENCES citydb.objectclass (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;
ALTER TABLE IF EXISTS citydb.utn9_commodity_classifier ADD CONSTRAINT utn9_comm_class_utn_comm_fk FOREIGN KEY (commodity_id) REFERENCES citydb.utn9_commodity (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;
ALTER TABLE IF EXISTS citydb.utn9_commodity_classifier ADD CONSTRAINT utn9_comm_class_utn_mat_fk FOREIGN KEY (material_id) REFERENCES citydb.utn9_material (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;
ALTER TABLE IF EXISTS citydb.utn9_commodity_classifier ADD CONSTRAINT utn9_comm_class_utn_hol_spc_fk FOREIGN KEY (hollow_space_id) REFERENCES citydb.utn9_hollow_space (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;

ALTER TABLE IF EXISTS citydb.utn9_commodity_classifier ADD CONSTRAINT utn9_comm_class_lu_signal_word_fk FOREIGN KEY (signal_word) REFERENCES citydb.utn9_lu_signal_word (id) MATCH FULL ON UPDATE CASCADE ON DELETE SET NULL;

-- FOREIGN KEY constraint on Table COMM_CLASS_TO_COMM_CLASS
ALTER TABLE IF EXISTS citydb.utn9_comm_class_to_comm_class ADD CONSTRAINT utn9_comm_class_to_comm_class_fk1 FOREIGN KEY (comm_class_parent_id) REFERENCES citydb.utn9_commodity (id) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE IF EXISTS citydb.utn9_comm_class_to_comm_class ADD CONSTRAINT utn9_comm_class_to_comm_class_fk2 FOREIGN KEY (comm_class_id) REFERENCES citydb.utn9_commodity (id) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;

-- FOREIGN KEY constraint on Table MATERIAL
ALTER TABLE IF EXISTS citydb.utn9_material ADD CONSTRAINT utn9_mat_utn_mat_fk1 FOREIGN KEY (material_parent_id) REFERENCES citydb.utn9_material (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;
ALTER TABLE IF EXISTS citydb.utn9_material ADD CONSTRAINT utn9_mat_utn_mat_fk2 FOREIGN KEY (material_root_id) REFERENCES citydb.utn9_material (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;
ALTER TABLE IF EXISTS citydb.utn9_material ADD CONSTRAINT utn9_mat_objclass_fk FOREIGN KEY (objectclass_id) REFERENCES citydb.objectclass (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;
ALTER TABLE IF EXISTS citydb.utn9_material ADD CONSTRAINT utn9_mat_utn_mat_fk3 FOREIGN KEY (material_id) REFERENCES citydb.utn9_material (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;

-- FOREIGN KEY constraint on Table NETWORK_FEAT_TO_MATERIAL
ALTER TABLE IF EXISTS citydb.utn9_network_feat_to_material ADD CONSTRAINT utn9_ntw_feat_to_mat_fk1 FOREIGN KEY (network_feature_id) REFERENCES citydb.utn9_network_feature (id) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE IF EXISTS citydb.utn9_network_feat_to_material ADD CONSTRAINT utn9_ntw_feat_to_mat_fk2 FOREIGN KEY (material_id) REFERENCES citydb.utn9_material (id) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;

-- FOREIGN KEY constraint on Table HOLLOW_SPACE
ALTER TABLE IF EXISTS citydb.utn9_hollow_space ADD CONSTRAINT utn9_hol_spc_objclass_fk FOREIGN KEY (objectclass_id) REFERENCES citydb.objectclass (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;
ALTER TABLE IF EXISTS citydb.utn9_hollow_space ADD CONSTRAINT utn9_hol_spc_utn_ntw_feat_fk FOREIGN KEY (ntw_feature_id) REFERENCES citydb.utn9_network_feature (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;

-- FOREIGN KEY constraint on Table LU_NETWOKR_FEATURE_CLASS
ALTER TABLE IF EXISTS citydb.utn9_lu_network_feature_class ADD CONSTRAINT utn9_ntw_feat_class_objclass_fk FOREIGN KEY (objectclass_id) REFERENCES citydb.objectclass (id) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;

-- FOREIGN KEY constraint on Table LU_MEDIUM_SUPPLY
ALTER TABLE IF EXISTS citydb.utn9_lu_medium_supply ADD CONSTRAINT utn9_lu_med_sup_objclass_fk FOREIGN KEY (objectclass_id) REFERENCES citydb.objectclass (id) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;







-- ***********************************************************************
-- EXECUTE THE STORED PROCEDURE TO SET THE SRID OF THE NEW GEOMETRY COLUMNS TO THE CURRENT ONE ON THE DATABASE
-- ***********************************************************************

SELECT citydb_pkg.utn9_set_ade_columns_srid('citydb');

-- ***********************************************************************
-- ***********************************************************************

DO
$$
BEGIN
RAISE NOTICE '

********************************

Utility Network ADE tables installation complete!

********************************

';
END
$$;
SELECT 'Energy ADE tables installation complete!'::varchar AS installation_result;

-- ***********************************************************************
-- ***********************************************************************
--
-- END OF FILE
--
-- ***********************************************************************
-- ***********************************************************************

