-- Simulation package v. 0.1 for the 3D City Database
--
--                         May 2018
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

----------------------------------------------------------------
-- Table LU_VARIABLE_TYPE 
----------------------------------------------------------------
DROP TABLE IF EXISTS sim_pkg.lu_variable_type CASCADE;
CREATE TABLE         sim_pkg.lu_variable_type (
	id                   varchar PRIMARY KEY,
	name                 varchar,
	name_codespace       varchar,
	description          text
);
-- ALTER TABLE sim_pkg.lu_variable_type OWNER TO postgres;

CREATE INDEX simpkg_lu_var_type_inx ON sim_pkg.lu_variable_type USING btree (name, name_codespace);

----------------------------------------------------------------
-- Table TOOL (_FEATURE prototype)
----------------------------------------------------------------
DROP TABLE IF EXISTS sim_pkg.tool CASCADE;
CREATE TABLE         sim_pkg.tool (
	id                    serial  PRIMARY KEY      ,
	gmlid                 varchar                  ,
	gmlid_codespace       varchar                  ,
	name                  varchar UNIQUE NOT NULL  ,
	name_codespace        varchar                  ,
	description           text                     ,
	server_name           varchar                  ,
	server_address        varchar                  ,
	os_type               varchar                  ,
	os_version            varchar                  ,
	dependencies          varchar                  ,
	connection_parameters varchar                  ,
  creator_name          varchar DEFAULT user     ,
	creation_date         date DEFAULT now()::date
);
-- ALTER TABLE sim_pkg.tool OWNER TO postgres;

CREATE INDEX tool_gmlid_inx ON sim_pkg.tool USING btree (gmlid, gmlid_codespace);

COMMENT ON TABLE sim_pkg.tool IS 'Information about the simulation tool';

COMMENT ON COLUMN sim_pkg.tool.id                    IS 'ID';     
COMMENT ON COLUMN sim_pkg.tool.gmlid                 IS 'Gml ID';          
COMMENT ON COLUMN sim_pkg.tool.gmlid_codespace       IS 'Gml codespace';          
COMMENT ON COLUMN sim_pkg.tool.name                  IS 'Name';      
COMMENT ON COLUMN sim_pkg.tool.name_codespace        IS 'Name codespace';         
COMMENT ON COLUMN sim_pkg.tool.description           IS 'Description';       
COMMENT ON COLUMN sim_pkg.tool.server_name           IS 'Server name';          
COMMENT ON COLUMN sim_pkg.tool.server_address        IS 'Server address';          
COMMENT ON COLUMN sim_pkg.tool.os_type               IS 'Operating system type';       
COMMENT ON COLUMN sim_pkg.tool.os_version            IS 'Operating system version';          
COMMENT ON COLUMN sim_pkg.tool.dependencies          IS 'Dependencies';          
COMMENT ON COLUMN sim_pkg.tool.connection_parameters IS 'Connection parameters';

----------------------------------------------------------------
-- Table SIMULATION (_FEATURE prototype)
----------------------------------------------------------------
DROP TABLE IF EXISTS sim_pkg.simulation CASCADE;
CREATE TABLE         sim_pkg.simulation (
  id                 serial  PRIMARY KEY ,
  gmlid              varchar             ,
  gmlid_codespace    varchar             ,
  name               varchar NOT NULL    ,
  name_codespace     varchar             ,
  description        text                ,
  time_start         timestamptz         ,
  time_stop          timestamptz         ,
  time_interval      numeric             ,
  time_interval_unit varchar             ,
  creator_name       varchar DEFAULT user,
  creation_date      date DEFAULT now()::date
);
-- ALTER TABLE sim_pkg.simulation OWNER TO postgres;

CREATE INDEX sim_gmlid_inx       ON sim_pkg.simulation USING btree (gmlid, gmlid_codespace);
CREATE INDEX sim_name_inx        ON sim_pkg.simulation USING btree (name);
--CREATE INDEX sim_scen_id_fkx     ON sim_pkg.simulation USING btree (scenario_id);

COMMENT ON TABLE sim_pkg.simulation IS 'Information about the simulation';

COMMENT ON COLUMN sim_pkg.simulation.id                 IS 'ID';     
COMMENT ON COLUMN sim_pkg.simulation.gmlid              IS 'Gml ID';        
COMMENT ON COLUMN sim_pkg.simulation.gmlid_codespace    IS 'Gml codespace'; 
COMMENT ON COLUMN sim_pkg.simulation.name               IS 'Name';      
COMMENT ON COLUMN sim_pkg.simulation.name_codespace     IS 'Name codespace';
COMMENT ON COLUMN sim_pkg.simulation.description        IS 'Description';   
COMMENT ON COLUMN sim_pkg.simulation.time_start         IS 'Start time of the simulation';
COMMENT ON COLUMN sim_pkg.simulation.time_stop          IS 'Stop time of the simulation';
COMMENT ON COLUMN sim_pkg.simulation.time_interval      IS 'Time interval of the simulation';
COMMENT ON COLUMN sim_pkg.simulation.time_interval_unit IS 'Unit of measure of the time interval of the simulation';
--COMMENT ON COLUMN sim_pkg.simulation.scenario_id        IS 'ID of the scenario';
COMMENT ON COLUMN sim_pkg.simulation.creator_name       IS 'Name of the simulation creator';
COMMENT ON COLUMN sim_pkg.simulation.creation_date      IS 'Date of the simulation creation';

----------------------------------------------------------------
-- Table SIMULATION_TO_SCENARIO
----------------------------------------------------------------
DROP TABLE IF EXISTS sim_pkg.simulation_to_scenario CASCADE;
CREATE TABLE         sim_pkg.simulation_to_scenario (
simulation_id integer NOT NULL,
scenario_id   integer NOT NULL,
CONSTRAINT sim_to_scen_pk PRIMARY KEY (simulation_id, scenario_id)
);

CREATE INDEX sim_to_scen_sim_id_fkx  ON sim_pkg.simulation_to_scenario USING btree (simulation_id);
CREATE INDEX sim_to_scen_scen_id_fkx ON sim_pkg.simulation_to_scenario USING btree (scenario_id);

----------------------------------------------------------------
-- Table NODE (_FEATURE prototype)
----------------------------------------------------------------
DROP TABLE IF EXISTS sim_pkg.node CASCADE;
CREATE TABLE         sim_pkg.node (
  id               serial    PRIMARY KEY         ,
  parent_id        integer                       ,
  gmlid            varchar                       ,
  gmlid_codespace  varchar                       ,
  name             varchar                       ,
  name_codespace   varchar                       ,
  description      text                          ,
  is_template      boolean NOT NULL DEFAULT FALSE,
  cityobject_id    integer                       ,
  tool_id          integer                       ,
  simulation_id    integer
);
-- ALTER TABLE sim_pkg.node OWNER TO postgres;

CREATE INDEX node_gmlid_inx       ON sim_pkg.node USING btree (gmlid, gmlid_codespace);
CREATE INDEX node_parent_id_fkx   ON sim_pkg.node USING btree (parent_id);
CREATE INDEX node_ctyobj_id_fkx   ON sim_pkg.node USING btree (cityobject_id);
CREATE INDEX node_sim_id_fkx      ON sim_pkg.node USING btree (simulation_id);
CREATE INDEX node_tool_id_fkx     ON sim_pkg.node USING btree (tool_id);

COMMENT ON TABLE sim_pkg.node IS 'Information about the node';

COMMENT ON COLUMN sim_pkg.node.id              IS 'ID';
COMMENT ON COLUMN sim_pkg.node.parent_id       IS 'ID of the parent node';   
COMMENT ON COLUMN sim_pkg.node.gmlid           IS 'Gml ID';        
COMMENT ON COLUMN sim_pkg.node.gmlid_codespace IS 'Gml codespace'; 
COMMENT ON COLUMN sim_pkg.node.name            IS 'Name';      
COMMENT ON COLUMN sim_pkg.node.name_codespace  IS 'Name codespace';
COMMENT ON COLUMN sim_pkg.node.description     IS 'Description';
COMMENT ON COLUMN sim_pkg.node.is_template     IS 'Is this node a template? (Default:FALSE)'; 
COMMENT ON COLUMN sim_pkg.node.cityobject_id   IS 'ID of the cityobject';
COMMENT ON COLUMN sim_pkg.node.tool_id         IS 'ID of the simulation tool';
COMMENT ON COLUMN sim_pkg.node.simulation_id   IS 'ID of the simulation';

----------------------------------------------------------------
-- Table PORT (_FEATURE prototype)
----------------------------------------------------------------
DROP TABLE IF EXISTS sim_pkg.port CASCADE;
CREATE TABLE sim_pkg.port (
	id               serial   PRIMARY KEY                        ,
	type             varchar  NOT NULL CHECK (type IN ('input', 'output')),
	gmlid            varchar                                     ,
	gmlid_codespace  varchar                                     ,
	name             varchar                                     ,
	name_codespace   varchar                                     ,
	description      text                                        ,
	variable_name    varchar                                     ,
	variable_type    varchar                                     ,
  cityobject_id    integer                                     ,
  node_id          integer NOT NULL
);
-- ALTER TABLE sim_pkg.port OWNER TO postgres;

CREATE INDEX port_gmlid_inx     ON sim_pkg.port USING btree (gmlid, gmlid_codespace);
CREATE INDEX port_ctyobj_id_fkx ON sim_pkg.port USING btree (cityobject_id);
CREATE INDEX port_node_id_fkx   ON sim_pkg.port USING btree (node_id);

COMMENT ON TABLE sim_pkg.port IS 'Information about the port';

COMMENT ON COLUMN sim_pkg.port.id              IS 'ID';     
COMMENT ON COLUMN sim_pkg.port.type            IS 'Type of port, values in (input, output)';  
COMMENT ON COLUMN sim_pkg.port.gmlid           IS 'Gml ID';        
COMMENT ON COLUMN sim_pkg.port.gmlid_codespace IS 'Gml codespace'; 
COMMENT ON COLUMN sim_pkg.port.name            IS 'Name';      
COMMENT ON COLUMN sim_pkg.port.name_codespace  IS 'Name codespace';
COMMENT ON COLUMN sim_pkg.port.description     IS 'Description';
COMMENT ON COLUMN sim_pkg.port.variable_name   IS 'Name of the variable';
COMMENT ON COLUMN sim_pkg.port.variable_type   IS 'Type of the variable';
COMMENT ON COLUMN sim_pkg.port.cityobject_id   IS 'ID of the cityobject';
COMMENT ON COLUMN sim_pkg.port.node_id         IS 'ID of the node';

----------------------------------------------------------------
-- Table PORT_CONNECTION (_FEATURE prototype)
----------------------------------------------------------------
DROP TABLE IF EXISTS sim_pkg.port_connection CASCADE;
CREATE TABLE sim_pkg.port_connection (
	id               serial PRIMARY KEY,
	gmlid            varchar           ,
	gmlid_codespace  varchar           ,
	name             varchar           ,
	name_codespace   varchar           ,
	description      text              ,
	output_port_id   integer NOT NULL  ,
  input_port_id    integer NOT NULL  ,
  simulation_id    integer NOT NULL  ,
	UNIQUE (output_port_id, input_port_id, simulation_id)
);
-- ALTER TABLE sim_pkg.port_connection OWNER TO postgres;

CREATE INDEX port_conn_gmlid_inx          ON sim_pkg.port_connection USING btree (gmlid, gmlid_codespace);
CREATE INDEX port_conn_output_port_id_fkx ON sim_pkg.port_connection USING btree (output_port_id);
CREATE INDEX port_conn_input_port_id_fkx  ON sim_pkg.port_connection USING btree (input_port_id);
CREATE INDEX port_conn_sim_id_fkx         ON sim_pkg.port_connection USING btree (simulation_id);

COMMENT ON TABLE sim_pkg.port_connection IS 'Information about the port connection. It link an input port with an output port';

COMMENT ON COLUMN sim_pkg.port_connection.id              IS 'ID';     
COMMENT ON COLUMN sim_pkg.port_connection.gmlid           IS 'Gml ID';        
COMMENT ON COLUMN sim_pkg.port_connection.gmlid_codespace IS 'Gml codespace'; 
COMMENT ON COLUMN sim_pkg.port_connection.name            IS 'Name';      
COMMENT ON COLUMN sim_pkg.port_connection.name_codespace  IS 'Name codespace';
COMMENT ON COLUMN sim_pkg.port_connection.description     IS 'Description';
COMMENT ON COLUMN sim_pkg.port_connection.output_port_id  IS 'ID of the output port of a node';
COMMENT ON COLUMN sim_pkg.port_connection.input_port_id   IS 'ID of the input port of a node';
COMMENT ON COLUMN sim_pkg.port_connection.simulation_id   IS 'ID of the simulation the port connection belong to';

---------------------------------------------------------------
-- Table GENERIC_PARAMETER (_DataType prototype)
----------------------------------------------------------------
DROP TABLE IF EXISTS sim_pkg.generic_parameter CASCADE;
CREATE TABLE sim_pkg.generic_parameter (
  id                        serial  PRIMARY KEY,
  name                      varchar NOT NULL   ,
  name_codespace            varchar            ,
  description               text               ,
-- OTHER ATTRIBUTES HERE BEGIN
  is_init_parameter          boolean NOT NULL DEFAULT FALSE,
--  
  citydb_table_name         varchar            ,
  citydb_object_id          integer            ,
  citydb_column_name        varchar            ,
  citydb_genericattrib_name varchar            ,
  citydb_function           varchar            ,
-- OTHER ATTRIBUTES HERE END                   
  strval          varchar                      ,
  intval          integer                      ,
  realval         numeric                      ,
  arrayval        numeric[]                    ,
  urival          varchar                      ,
  dateval         timestamptz,                 
  unit            varchar                      ,
--                                             
  tool_id         integer                      ,
  node_id         integer                      ,
  simulation_id   integer
);
-- ALTER TABLE sim_pkg.generic_parameter OWNER TO postgres;

CREATE INDEX gen_par_tool_is_init_par_inx ON sim_pkg.generic_parameter USING btree (is_init_parameter);
CREATE INDEX gen_par_tool_id_fkx     ON sim_pkg.generic_parameter USING btree (tool_id);
CREATE INDEX gen_par_node_id_fkx     ON sim_pkg.generic_parameter USING btree (node_id);
CREATE INDEX gen_par_sim_id_fkx      ON sim_pkg.generic_parameter USING btree (simulation_id);

COMMENT ON TABLE sim_pkg.generic_parameter IS 'Generic parameter of either a tool, a node or a simulation';

COMMENT ON COLUMN sim_pkg.generic_parameter.id              IS 'ID';     
COMMENT ON COLUMN sim_pkg.generic_parameter.name            IS 'Name';      
COMMENT ON COLUMN sim_pkg.generic_parameter.name_codespace  IS 'Name codespace';
COMMENT ON COLUMN sim_pkg.generic_parameter.description     IS 'Description';
--
COMMENT ON COLUMN sim_pkg.generic_parameter.is_init_parameter          IS 'Is this an initialisation parameter?';
--
COMMENT ON COLUMN sim_pkg.generic_parameter.citydb_table_name         IS 'Name of the target table in the 3DCityDB';
COMMENT ON COLUMN sim_pkg.generic_parameter.citydb_object_id          IS 'ID of the target object in the 3DCityDB';
COMMENT ON COLUMN sim_pkg.generic_parameter.citydb_column_name        IS 'Name of the target column in the 3DCityDB';
COMMENT ON COLUMN sim_pkg.generic_parameter.citydb_genericattrib_name IS 'Name of the generic attribute in the 3DCityDB'; 
COMMENT ON COLUMN sim_pkg.generic_parameter.citydb_function           IS 'Function to be performed in the 3DCityDB';
--
COMMENT ON COLUMN sim_pkg.generic_parameter.strval          IS 'String value';
COMMENT ON COLUMN sim_pkg.generic_parameter.intval          IS 'Integer value';
COMMENT ON COLUMN sim_pkg.generic_parameter.realval         IS 'Real (numeric) value';
COMMENT ON COLUMN sim_pkg.generic_parameter.arrayval        IS 'Array of numeric values';
COMMENT ON COLUMN sim_pkg.generic_parameter.urival          IS 'Any URI';
COMMENT ON COLUMN sim_pkg.generic_parameter.dateval         IS 'Data value';
COMMENT ON COLUMN sim_pkg.generic_parameter.unit            IS 'Unit of measure';
COMMENT ON COLUMN sim_pkg.generic_parameter.tool_id         IS 'ID of the tool';
COMMENT ON COLUMN sim_pkg.generic_parameter.node_id         IS 'ID of the node';
COMMENT ON COLUMN sim_pkg.generic_parameter.simulation_id   IS 'ID of the simulation';

----------------------------------------------------------------
-- ADD FOREIGN KEY CONTRAINTS
----------------------------------------------------------------

-- FOREIGN KEY constraint(s) on table "tool"

-- FOREIGN KEY constraint(s) on table "simulation"
--ALTER TABLE IF EXISTS sim_pkg.simulation ADD CONSTRAINT sim_scn_scen_fk FOREIGN KEY (scenario_id)     REFERENCES citydb.scn2_scenario (id) MATCH FULL ON UPDATE CASCADE ON DELETE SET NULL;

-- FOREIGN KEY constraint(s) on table "simulation_to_scenario"
ALTER TABLE IF EXISTS sim_pkg.simulation_to_scenario ADD CONSTRAINT sim_scn_sim_fk FOREIGN KEY (simulation_id)     REFERENCES sim_pkg.simulation (id) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE IF EXISTS sim_pkg.simulation_to_scenario ADD CONSTRAINT sim_scn_scen_fk FOREIGN KEY (scenario_id)     REFERENCES citydb.scn2_scenario (id) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;

-- FOREIGN KEY constraint(s) on table "node"
ALTER TABLE IF EXISTS sim_pkg.node ADD CONSTRAINT node_sim_fk  FOREIGN KEY (simulation_id) REFERENCES sim_pkg.simulation (id) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE IF EXISTS sim_pkg.node ADD CONSTRAINT node_tool_fk FOREIGN KEY (tool_id)       REFERENCES sim_pkg.tool (id) MATCH FULL ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE IF EXISTS sim_pkg.node ADD CONSTRAINT node_node_fk FOREIGN KEY (parent_id)     REFERENCES sim_pkg.node (id) MATCH FULL ON UPDATE CASCADE ON DELETE SET NULL;

-- FOREIGN KEY constraint(s) on table "port"
ALTER TABLE IF EXISTS sim_pkg.port ADD CONSTRAINT port_node_fk FOREIGN KEY (node_id)     REFERENCES sim_pkg.node (id) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;

-- FOREIGN KEY constraint(s) on table "port_connection"
ALTER TABLE IF EXISTS sim_pkg.port_connection ADD CONSTRAINT conn_port_fk1 FOREIGN KEY (output_port_id)     REFERENCES sim_pkg.port (id) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE IF EXISTS sim_pkg.port_connection ADD CONSTRAINT conn_port_fk2 FOREIGN KEY (input_port_id)     REFERENCES sim_pkg.port (id) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE IF EXISTS sim_pkg.port_connection ADD CONSTRAINT conn_sim_fk FOREIGN KEY (simulation_id)     REFERENCES sim_pkg.simulation (id) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;

-- FOREIGN KEY constraint(s) on table "generic_parameter"
ALTER TABLE IF EXISTS sim_pkg.generic_parameter ADD CONSTRAINT gen_par_tool_fk FOREIGN KEY (tool_id)     REFERENCES sim_pkg.tool (id) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE IF EXISTS sim_pkg.generic_parameter ADD CONSTRAINT gen_par_node_fk FOREIGN KEY (node_id)     REFERENCES sim_pkg.node (id) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE IF EXISTS sim_pkg.generic_parameter ADD CONSTRAINT gen_par_sim_fk FOREIGN KEY (simulation_id)     REFERENCES sim_pkg.simulation (id) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;

-- ***********************************************************************
-- ***********************************************************************

DO
$$
BEGIN
RAISE NOTICE '

********************************

Simulation package tables installation complete!

********************************

';
END
$$;
SELECT 'Simulation package tables installation complete!'::varchar AS installation_result;

-- ***********************************************************************
-- ***********************************************************************
--
-- END OF FILE
--
-- ***********************************************************************
-- ***********************************************************************

