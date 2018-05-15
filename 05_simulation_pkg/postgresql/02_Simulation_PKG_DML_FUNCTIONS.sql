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
-- DELETE tool
----------------------------------------------------------------
CREATE OR REPLACE FUNCTION sim_pkg.delete_tool (
	o_id integer
)
RETURNS integer AS $$
DECLARE
		deleted_id integer;
BEGIN
-- All dependent GenericParameters are deleted automatically
-- This is carried out automatically ON DELETE CASCADE
--
EXECUTE format('DELETE FROM sim_pkg.tool WHERE id = %L RETURNING id', o_id) INTO deleted_id;
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'sim_pkg.delete_tool (id: %): %', o_id, SQLERRM;
END;
$$
LANGUAGE plpgsql;

----------------------------------------------------------------
-- DELETE node
----------------------------------------------------------------
CREATE OR REPLACE FUNCTION sim_pkg.delete_node (
	o_id integer
)
RETURNS integer AS $$
DECLARE
	deleted_id integer;
BEGIN
-- Delete the dependent nodes
EXECUTE format('SELECT sim_pkg.delete_node(id) FROM sim_pkg.node WHERE id != %L AND parent_id = %L',  o_id, o_id);

-- All dependent GenericParameters are deleted automatically
-- This is carried out automatically ON DELETE CASCADE
--
-- Delete the depending ports (whose deletion triggers the deletion of the port_connection)
-- This is carried out automatically ON DELETE CASCADE
--
-- Delete the node itself
EXECUTE format('DELETE FROM sim_pkg.node WHERE id = %L RETURNING id', o_id) INTO deleted_id;
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'sim_pkg.delete_node (id: %): %', o_id, SQLERRM;
END;
$$
LANGUAGE plpgsql;

----------------------------------------------------------------
-- DELETE port_connection
----------------------------------------------------------------
CREATE OR REPLACE FUNCTION sim_pkg.delete_port_connection (
	o_id integer
)
RETURNS integer AS $$
DECLARE
	deleted_id integer;
BEGIN
EXECUTE format('DELETE FROM sim_pkg.port_connection WHERE id = %L RETURNING id', o_id) INTO deleted_id;
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'sim_pkg.delete_port_connection (id: %): %', o_id, SQLERRM;
END;
$$
LANGUAGE plpgsql;

----------------------------------------------------------------
-- DELETE port
----------------------------------------------------------------
CREATE OR REPLACE FUNCTION sim_pkg.delete_port (
	o_id integer
)
RETURNS integer AS $$
DECLARE
	deleted_id integer;
BEGIN
-- The deletion of a port implies that the associated port_connection is deleted as well.
-- This is carried out automatically ON DELETE CASCADE
--
EXECUTE format('DELETE FROM sim_pkg.port WHERE id = %L RETURNING id', o_id) INTO deleted_id;
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'sim_pkg.delete_port (id: %): %', o_id, SQLERRM;
END;
$$
LANGUAGE plpgsql;

----------------------------------------------------------------
-- DELETE simulation
----------------------------------------------------------------
CREATE OR REPLACE FUNCTION sim_pkg.delete_simulation (
	o_id integer
)
RETURNS integer AS $$
DECLARE
	deleted_id integer;
BEGIN
-- All dependent GenericParameters are deleted automatically
-- This is carried out automatically, ON DELETE CASCADE
--
-- Delete all depending port_connections
-- This is carried out automatically, ON DELETE CASCADE
--
-- Delete all depending nodes
-- This is carried out automatically, ON DELETE CASCADE
--
EXECUTE format('DELETE FROM sim_pkg.simulation WHERE id = %L RETURNING id', o_id) INTO deleted_id;
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'sim_pkg.delete_simulation (id: %): %', o_id, SQLERRM;
END;
$$
LANGUAGE plpgsql;

----------------------------------------------------------------
-- DELETE generic_parameter
----------------------------------------------------------------
CREATE OR REPLACE FUNCTION sim_pkg.delete_generic_parameter (
	o_id integer
)
RETURNS integer AS $$
DECLARE
	deleted_id integer;
BEGIN
EXECUTE format('DELETE FROM sim_pkg.generic_parameter WHERE id = %L RETURNING id', o_id) INTO deleted_id;
RETURN deleted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'sim_pkg.delete_generic_parameter (id: %): %', o_id, SQLERRM;
END;
$$
LANGUAGE plpgsql;

-- *****************************************************************
-- *****************************************************************
-- *****************************************************************

----------------------------------------------------------------
-- INSERT tool
----------------------------------------------------------------
CREATE OR REPLACE FUNCTION sim_pkg.insert_tool (
id                    integer DEFAULT NULL,
gmlid                 varchar DEFAULT NULL,
gmlid_codespace       varchar DEFAULT NULL,
name                  varchar DEFAULT NULL,
name_codespace        varchar DEFAULT NULL,
description           text    DEFAULT NULL,
server_name           varchar DEFAULT NULL,
server_address        varchar DEFAULT NULL,
os_type               varchar DEFAULT NULL,
os_version            varchar DEFAULT NULL,
dependencies          varchar DEFAULT NULL,
connection_parameters varchar DEFAULT NULL,
creator_name          varchar DEFAULT user,
creation_date         date    DEFAULT (now())::date
)
RETURNS integer AS $$
DECLARE
p_id                    integer := id;
p_gmlid                 varchar := gmlid;
p_gmlid_codespace       varchar := gmlid_codespace;
p_name                  varchar := name;
p_name_codespace        varchar := name_codespace;
p_description           text    := description;
p_server_name           varchar := server_name;
p_server_address        varchar := server_address;
p_os_type               varchar := os_type;
p_os_version            varchar := os_version;
p_dependencies          varchar := dependencies;
p_connection_parameters varchar := connection_parameters;
p_creator_name          varchar := creator_name;
p_creation_date         date    := creation_date;
inserted_id integer;
seq_name varchar;
BEGIN
IF p_id IS NULL THEN
	seq_name='sim_pkg.tool_id_seq';
	p_id=nextval(seq_name::regclass);
END IF;
IF p_gmlid IS NULL THEN
	p_gmlid='UUID_'||uuid_generate_v4();
END IF;

EXECUTE format('INSERT INTO sim_pkg.tool (
id                   ,
gmlid                ,
gmlid_codespace      ,
name                 ,
name_codespace       ,
description          ,
server_name          ,
server_address       ,
os_type              ,
os_version           ,
dependencies         ,
connection_parameters,
creator_name         ,
creation_date        
) VALUES (
%L, %L, %L, %L, %L, %L, %L, %L, %L, %L,
%L, %L, %L, %L
) RETURNING id',
p_id                   ,
p_gmlid                ,
p_gmlid_codespace      ,
p_name                 ,
p_name_codespace       ,
p_description          ,
p_server_name          ,
p_server_address       ,
p_os_type              ,
p_os_version           ,
p_dependencies         ,
p_connection_parameters,
p_creator_name         ,
p_creation_date        
) INTO inserted_id;
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'sim_pkg.insert_tool (id: %): %', p_id, SQLERRM; 
END;
$$
LANGUAGE plpgsql;

----------------------------------------------------------------
-- INSERT simulation
----------------------------------------------------------------
CREATE OR REPLACE FUNCTION sim_pkg.insert_simulation (
id                 integer                   DEFAULT NULL,
gmlid              varchar                   DEFAULT NULL,
gmlid_codespace    varchar                   DEFAULT NULL,
name               varchar                   DEFAULT NULL,
name_codespace     varchar                   DEFAULT NULL,
description        text                      DEFAULT NULL,
time_start         timestamp with time zone  DEFAULT NULL,
time_stop          timestamp with time zone  DEFAULT NULL,
time_interval      numeric                   DEFAULT NULL,
time_interval_unit varchar                   DEFAULT NULL,
creator_name       varchar                   DEFAULT user,
creation_date      date                      DEFAULT now()::date
)
RETURNS integer AS $$
DECLARE
p_id                    integer                  := id             ;
p_gmlid                 varchar                  := gmlid          ;
p_gmlid_codespace       varchar                  := gmlid_codespace;
p_name                  varchar                  := name           ;
p_name_codespace        varchar                  := name_codespace ;
p_description           text                     := description    ;
p_time_start            timestamp with time zone := time_start          ;
p_time_stop             timestamp with time zone := time_stop           ;
p_time_interval         numeric                  := time_interval       ;
p_time_interval_unit    varchar                  := time_interval_unit  ;
p_creator_name          varchar                  := creator_name   ;
p_creation_date         date                     := creation_date  ;
inserted_id integer;
seq_name varchar;
BEGIN
IF p_id IS NULL THEN
	seq_name='sim_pkg.simulation_id_seq';
	p_id=nextval(seq_name::regclass);
END IF;
IF p_gmlid IS NULL THEN
	p_gmlid='UUID_'||uuid_generate_v4();
END IF;

EXECUTE format('INSERT INTO sim_pkg.simulation (
id                   ,
gmlid                ,
gmlid_codespace      ,
name                 ,
name_codespace       ,
description          ,
time_start           ,
time_stop            ,
time_interval        ,
time_interval_unit   ,
creator_name         ,
creation_date
) VALUES (
%L, %L, %L, %L, %L, %L, %L, %L, %L, %L,
%L, %L
) RETURNING id',
p_id                   ,
p_gmlid                ,
p_gmlid_codespace      ,
p_name                 ,
p_name_codespace       ,
p_description          ,
p_time_start           ,
p_time_stop            ,
p_time_interval        ,
p_time_interval_unit   ,
p_creator_name         ,
p_creation_date
) INTO inserted_id;
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'sim_pkg.insert_simulation (id: %): %', p_id, SQLERRM; 
END;
$$
LANGUAGE plpgsql;

----------------------------------------------------------------
-- Function INSERT_SIMULATION_TO_SCENARIO
----------------------------------------------------------------
CREATE OR REPLACE FUNCTION sim_pkg.insert_simulation_to_scenario (
  simulation_id        integer,
  scenario_id          integer
)
RETURNS void
AS $$
DECLARE
  p_simulation_id integer := simulation_id;
  p_scenario_id   integer := scenario_id  ;
--
  p_schema_name        varchar;
BEGIN
EXECUTE format('INSERT INTO sim_pkg.simulation_to_scenario (
simulation_id,
scenario_id
) VALUES (
%L, %L
)',
p_simulation_id,
p_scenario_id
);
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'sim_pkg.insert_simulation_to_scenario (simulation_id: %, scenario_id: %): %', simulation_id, scenario_id, SQLERRM;
END;
$$ LANGUAGE 'plpgsql';

---------------------------------------------------------------
-- INSERT node
----------------------------------------------------------------
CREATE OR REPLACE FUNCTION sim_pkg.insert_node (
simulation_id    integer,
id               integer DEFAULT NULL,
parent_id        integer DEFAULT NULL,
gmlid            varchar DEFAULT NULL,
gmlid_codespace  varchar DEFAULT NULL,
name             varchar DEFAULT NULL,
name_codespace   varchar DEFAULT NULL,
description      text    DEFAULT NULL,
--is_template      boolean DEFAULT FALSE,
cityobject_id    integer DEFAULT NULL,
tool_id          integer DEFAULT NULL
)
RETURNS integer AS $$
DECLARE
p_id                    integer := id             ;
p_parent_id             integer := parent_id      ;
p_gmlid                 varchar := gmlid          ;
p_gmlid_codespace       varchar := gmlid_codespace;
p_name                  varchar := name           ;
p_name_codespace        varchar := name_codespace ;
p_description           text    := description    ;
--
p_is_template           boolean DEFAULT FALSE;
--p_is_template           boolean := is_template    ;
p_cityobject_id         integer := cityobject_id  ;
p_tool_id               integer := tool_id        ;
p_simulation_id         integer := simulation_id  ;
inserted_id integer;
seq_name varchar;
BEGIN
IF p_id IS NULL THEN
	seq_name='sim_pkg.node_id_seq';
	p_id=nextval(seq_name::regclass);
END IF;
IF p_gmlid IS NULL THEN
	p_gmlid='UUID_'||uuid_generate_v4();
END IF;
--IF p_is_template IS NULL THEN
--	p_is_template=FALSE;
--END IF;

EXECUTE format('INSERT INTO sim_pkg.node (
id             ,
parent_id      ,
gmlid          ,
gmlid_codespace,
name           ,
name_codespace ,
description    ,
is_template    ,
cityobject_id  ,
tool_id        ,
simulation_id
) VALUES (
%L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L
) RETURNING id',
p_id             ,
p_parent_id      ,
p_gmlid          ,
p_gmlid_codespace,
p_name           ,
p_name_codespace ,
p_description    ,
p_is_template    ,
p_cityobject_id  ,
p_tool_id        ,
p_simulation_id
) INTO inserted_id;
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'sim_pkg.insert_node (id: %): %', p_id, SQLERRM; 
END;
$$
LANGUAGE plpgsql;

---------------------------------------------------------------
-- INSERT node_template
----------------------------------------------------------------
CREATE OR REPLACE FUNCTION sim_pkg.insert_node_template (
simulation_id    integer DEFAULT NULL,
id               integer DEFAULT NULL,
parent_id        integer DEFAULT NULL,
gmlid            varchar DEFAULT NULL,
gmlid_codespace  varchar DEFAULT NULL,
name             varchar DEFAULT NULL,
name_codespace   varchar DEFAULT NULL,
description      text    DEFAULT NULL,
--is_template      boolean DEFAULT TRUE,
cityobject_id    integer DEFAULT NULL,
tool_id          integer DEFAULT NULL
)
RETURNS integer AS $$
DECLARE
p_id              integer := id             ;
p_parent_id       integer := parent_id      ;
p_gmlid           varchar := gmlid          ;
p_gmlid_codespace varchar := gmlid_codespace;
p_name            varchar := name           ;
p_name_codespace  varchar := name_codespace ;
p_description     text    := description    ;
--
p_is_template     boolean DEFAULT TRUE;
--p_is_template     boolean := is_template    ;
p_cityobject_id   integer := cityobject_id  ;
p_tool_id         integer := tool_id        ;
p_simulation_id   integer := simulation_id  ;
--
inserted_id integer;
seq_name varchar;
BEGIN
IF p_id IS NULL THEN
	seq_name='sim_pkg.node_id_seq';
	p_id=nextval(seq_name::regclass);
END IF;
IF p_gmlid IS NULL THEN
	p_gmlid='UUID_'||uuid_generate_v4();
END IF;
--IF p_is_template IS NULL THEN
--	p_is_template=TRUE;
--END IF;

EXECUTE format('INSERT INTO sim_pkg.node (
id             ,
parent_id      ,
gmlid          ,
gmlid_codespace,
name           ,
name_codespace ,
description    ,
is_template    ,
cityobject_id  ,
tool_id        ,
simulation_id
) VALUES (
%L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L 
) RETURNING id',
p_id             ,
p_parent_id      ,
p_gmlid          ,
p_gmlid_codespace,
p_name           ,
p_name_codespace ,
p_description    ,
p_is_template    ,
p_cityobject_id  ,
p_tool_id        ,
p_simulation_id
) INTO inserted_id;
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'sim_pkg.insert_node_template (id: %): %', p_id, SQLERRM; 
END;
$$
LANGUAGE plpgsql;

----------------------------------------------------------------
-- INSERT port
----------------------------------------------------------------
CREATE OR REPLACE FUNCTION sim_pkg.insert_port (
type             varchar             ,
node_id          integer             ,
id               integer DEFAULT NULL,
gmlid            varchar DEFAULT NULL,
gmlid_codespace  varchar DEFAULT NULL,
name             varchar DEFAULT NULL,
name_codespace   varchar DEFAULT NULL,
variable_name    varchar DEFAULT NULL,
variable_type    varchar DEFAULT NULL,
cityobject_id    integer DEFAULT NULL,
description      text    DEFAULT NULL
)
RETURNS integer AS $$
DECLARE
p_id              integer := id             ;
p_type            varchar := type           ;
p_gmlid           varchar := gmlid          ;
p_gmlid_codespace varchar := gmlid_codespace;
p_name            varchar := name           ;
p_name_codespace  varchar := name_codespace ;
p_description     text    := description    ;
p_variable_name   varchar := variable_name  ;
p_variable_type   varchar := variable_type  ;
p_cityobject_id   integer := cityobject_id  ;
p_node_id         integer := node_id        ;
inserted_id       integer;
seq_name varchar;
BEGIN
IF p_id IS NULL THEN
	seq_name='sim_pkg.port_id_seq';
	p_id=nextval(seq_name::regclass);
END IF;
IF p_gmlid IS NULL THEN
	p_gmlid='UUID_'||uuid_generate_v4();
END IF;

EXECUTE format('INSERT INTO sim_pkg.port (
id             ,
type           ,
gmlid          ,
gmlid_codespace,
name           ,
name_codespace ,
description    ,
variable_name  ,
variable_type  ,
cityobject_id  ,
node_id      
) VALUES (
%L, %L, %L, %L, %L, %L, %L, %L, %L, %L, %L
) RETURNING id',
p_id             ,
p_type           ,
p_gmlid          ,
p_gmlid_codespace,
p_name           ,
p_name_codespace ,
p_description    ,
p_variable_name  ,
p_variable_type  ,
p_cityobject_id  ,
p_node_id      
) INTO inserted_id;
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'sim_pkg.insert_port (id: %): %', p_id, SQLERRM; 
END;
$$
LANGUAGE plpgsql;

----------------------------------------------------------------
-- INSERT port_connection
----------------------------------------------------------------
CREATE OR REPLACE FUNCTION sim_pkg.insert_port_connection (
output_port_id   integer             ,
input_port_id    integer             ,
simulation_id    integer             ,
id               integer DEFAULT NULL,
gmlid            varchar DEFAULT NULL,
gmlid_codespace  varchar DEFAULT NULL,
name             varchar DEFAULT NULL,
name_codespace   varchar DEFAULT NULL,
description      text    DEFAULT NULL
)
RETURNS integer AS $$
DECLARE
p_id              integer := id             ;
p_gmlid           varchar := gmlid          ;
p_gmlid_codespace varchar := gmlid_codespace;
p_name            varchar := name           ;
p_name_codespace  varchar := name_codespace ;
p_description     text    := description    ;
p_output_port_id  integer := output_port_id ;
p_input_port_id   integer := input_port_id  ;
p_simulation_id   integer := simulation_id  ;
--
input_port  RECORD;
output_port RECORD;
inserted_id integer;
seq_name    varchar;
BEGIN
-- Add check for topological correctness 
-- ie input to input, output to output, and both ports must belong to the same simulation topology
-- Get the type and simulation id of the output port and check it

EXECUTE format('SELECT p.type, n.simulation_id FROM sim_pkg.port p, sim_pkg.node n WHERE p.node_id = n.id AND p.id=%L', output_port_id) INTO output_port;
EXECUTE format('SELECT p.type, n.simulation_id FROM sim_pkg.port p, sim_pkg.node n WHERE p.node_id = n.id AND p.id=%L', input_port_id) INTO input_port;

IF output_port.simulation_id<>input_port.simulation_id THEN
  RAISE EXCEPTION 'ERROR: The two ports belong to nodes belonging to different simulation topologies (output_port: simulation_id %, input_port: simulation_id % )', output_port.simulation_id, input_port.simulation_id;
ELSE
-- fine, same simulation topology
	IF output_port.type<>'output' THEN
		RAISE EXCEPTION 'ERROR for port (id %): type is wrong. It should be "output" but is: %', output_port_id, output_port.type USING HINT = 'You may have switched input and output ports';
	END IF;
	IF input_port.type<>'input' THEN
		RAISE EXCEPTION 'ERROR for port (id %): type is wrong. It should be "input" but is: %', input_port_id, input_port.type USING HINT = 'You may have switched input and output ports';
	END IF;
END IF;

IF p_id IS NULL THEN
	seq_name='sim_pkg.port_connection_id_seq';
	p_id=nextval(seq_name::regclass);
END IF;
IF p_gmlid IS NULL THEN
	p_gmlid='UUID_'||uuid_generate_v4();
END IF;

EXECUTE format('INSERT INTO sim_pkg.port_connection (
id             ,
gmlid          ,
gmlid_codespace,
name           ,
name_codespace ,
description    ,
output_port_id ,
input_port_id  ,
simulation_id
) VALUES (
%L, %L, %L, %L, %L, %L, %L, %L, %L
) RETURNING id',
p_id             ,
p_gmlid          ,
p_gmlid_codespace,
p_name           ,
p_name_codespace ,
p_description    ,
p_output_port_id ,
p_input_port_id  ,
p_simulation_id
) INTO inserted_id;
RETURN inserted_id;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'sim_pkg.insert_port_connection (id: %): %', p_id, SQLERRM; 
END;
$$
LANGUAGE plpgsql;

----------------------------------------------------------------
-- INSERT generic_parameter
----------------------------------------------------------------
CREATE OR REPLACE FUNCTION sim_pkg.insert_generic_parameter (
name                      varchar,
is_init_parameter         boolean     DEFAULT FALSE,
--
id                        integer     DEFAULT NULL,
name_codespace            varchar     DEFAULT NULL,
description               text        DEFAULT NULL,
--
citydb_table_name         varchar     DEFAULT NULL,
citydb_object_id          integer     DEFAULT NULL,
citydb_column_name        varchar     DEFAULT NULL,
citydb_genericattrib_name varchar     DEFAULT NULL,
citydb_function           varchar     DEFAULT NULL,
--
strval                    varchar     DEFAULT NULL,
intval                    integer     DEFAULT NULL,
realval                   numeric     DEFAULT NULL,
arrayval                  numeric[]   DEFAULT NULL,
urival                    varchar     DEFAULT NULL,
dateval                   timestamptz DEFAULT NULL,
unit                      varchar     DEFAULT NULL,
--
tool_id                   integer     DEFAULT NULL,
node_id                   integer     DEFAULT NULL,
simulation_id             integer     DEFAULT NULL
)
RETURNS integer AS $$
DECLARE
p_id                        integer     := id                       ;
p_name                      varchar     := name                     ;
p_name_codespace            varchar     := name_codespace           ;
p_description               text        := description              ;
--
p_is_init_parameter         boolean     := is_init_parameter        ;
p_citydb_table_name         varchar     := citydb_table_name        ;
p_citydb_object_id          integer     := citydb_object_id         ;
p_citydb_column_name        varchar     := citydb_column_name       ;
p_citydb_genericattrib_name varchar     := citydb_genericattrib_name;
p_citydb_function           varchar     := citydb_function          ;
--
p_strval                    varchar     := strval                   ;
p_intval                    integer     := intval                   ;
p_realval                   numeric     := realval                  ;
p_arrayval                  numeric[]   := arrayval                 ;
p_urival                    varchar     := urival                   ;
p_dateval                   timestamptz := dateval                  ;
p_unit                      varchar     := unit                     ;
p_tool_id                   integer     := tool_id                  ;
p_node_id                   integer     := node_id                  ;
p_simulation_id             integer     := simulation_id            ;
--
inserted_id integer;
seq_name varchar;
BEGIN
IF (tool_id IS NULL) AND (node_id IS NULL) AND (simulation_id IS NULL) THEN
  RAISE EXCEPTION 'Parameters tool_id, node_id and simulation_id are all NULL' USING HINT = 'Please set one of the parent_id values (tool_id, node_id or simulation_id)';
ELSE

IF p_is_init_parameter IS NULL THEN
  p_is_init_parameter = FALSE;
END IF;

IF p_id IS NULL THEN
	seq_name='sim_pkg.generic_parameter_id_seq';
	p_id=nextval(seq_name::regclass);
END IF;

EXECUTE format('INSERT INTO sim_pkg.generic_parameter (
id                       ,
name                     ,
name_codespace           ,
description              ,
is_init_parameter        ,
citydb_table_name        ,
citydb_object_id         ,
citydb_column_name       ,
citydb_genericattrib_name,
citydb_function          ,
strval                   ,
intval                   ,
realval                  ,
arrayval                 ,
urival                   ,
dateval                  ,
unit                     ,
tool_id                  ,
node_id                  ,
simulation_id        
) VALUES (
%L, %L, %L, %L, %L, %L, %L, %L, %L, %L,
%L, %L, %L, %L, %L, %L, %L, %L, %L, %L
) RETURNING id',
p_id                       ,
p_name                     ,
p_name_codespace           ,
p_description              ,
--
p_is_init_parameter        ,
p_citydb_table_name        ,
p_citydb_object_id         ,
p_citydb_column_name       ,
p_citydb_genericattrib_name,
p_citydb_function          ,
--
p_strval                   ,
p_intval                   ,
p_realval                  ,
p_arrayval                 ,
p_urival                   ,
p_dateval                  ,
p_unit                     ,
p_tool_id                  ,
p_node_id                  ,
p_simulation_id
) INTO inserted_id;
RETURN inserted_id;
END IF;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'sim_pkg.insert_generic_parameter (id: %): %', p_id, SQLERRM; 
END;
$$
LANGUAGE plpgsql;

----------------------------------------------------------------
-- INSERT generic_parameter_init
----------------------------------------------------------------
CREATE OR REPLACE FUNCTION sim_pkg.insert_generic_parameter_init (
name                      varchar,
--
id                        integer     DEFAULT NULL,
name_codespace            varchar     DEFAULT NULL,
description               text        DEFAULT NULL,
--
citydb_table_name         varchar     DEFAULT NULL,
citydb_object_id          integer     DEFAULT NULL,
citydb_column_name        varchar     DEFAULT NULL,
citydb_genericattrib_name varchar     DEFAULT NULL,
citydb_function           varchar     DEFAULT NULL,
--
strval                    varchar     DEFAULT NULL,
intval                    integer     DEFAULT NULL,
realval                   numeric     DEFAULT NULL,
arrayval                  numeric[]   DEFAULT NULL,
urival                    varchar     DEFAULT NULL,
dateval                   timestamptz DEFAULT NULL,
unit                      varchar     DEFAULT NULL,
--
tool_id                   integer     DEFAULT NULL,
node_id                   integer     DEFAULT NULL,
simulation_id             integer     DEFAULT NULL
)
RETURNS integer AS $$
DECLARE
p_id                        integer     := id                       ;
p_name                      varchar     := name                     ;
p_name_codespace            varchar     := name_codespace           ;
p_description               text        := description              ;
--
p_is_init_parameter         boolean     := TRUE                     ;
p_citydb_table_name         varchar     := citydb_table_name        ;
p_citydb_object_id          integer     := citydb_object_id         ;
p_citydb_column_name        varchar     := citydb_column_name       ;
p_citydb_genericattrib_name varchar     := citydb_genericattrib_name;
p_citydb_function           varchar     := citydb_function          ;
--
p_strval                    varchar     := strval                   ;
p_intval                    integer     := intval                   ;
p_realval                   numeric     := realval                  ;
p_arrayval                  numeric[]   := arrayval                 ;
p_urival                    varchar     := urival                   ;
p_dateval                   timestamptz := dateval                  ;
p_unit                      varchar     := unit                     ;
p_tool_id                   integer     := tool_id                  ;
p_node_id                   integer     := node_id                  ;
p_simulation_id             integer     := simulation_id            ;
--
inserted_id integer;
seq_name varchar;
BEGIN
IF (tool_id IS NULL) AND (node_id IS NULL) AND (simulation_id IS NULL) THEN
  RAISE EXCEPTION 'Parameters tool_id, node_id and simulation_id are all NULL' USING HINT = 'Please set one of the parent_id values (tool_id, node_id or simulation_id)';
ELSE

IF p_id IS NULL THEN
	seq_name='sim_pkg.generic_parameter_id_seq';
	p_id=nextval(seq_name::regclass);
END IF;

inserted_id=sim_pkg.insert_generic_parameter(
name                      := p_name                     ,
is_init_parameter         := p_is_init_parameter        ,
id                        := p_id                       ,
name_codespace            := p_name_codespace           ,
description               := p_description              ,
citydb_table_name         := p_citydb_table_name        ,
citydb_object_id          := p_citydb_object_id         ,
citydb_column_name        := p_citydb_column_name       ,
citydb_genericattrib_name := p_citydb_genericattrib_name,
citydb_function           := p_citydb_function          ,
strval                    := p_strval                   ,
intval                    := p_intval                   ,
realval                   := p_realval                  ,
arrayval                  := p_arrayval                 ,
urival                    := p_urival                   ,
dateval                   := p_dateval                  ,
unit                      := p_unit                     ,
tool_id                   := p_tool_id                  ,
node_id                   := p_node_id                  ,
simulation_id             := p_simulation_id
);

RETURN inserted_id;
END IF;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'sim_pkg.insert_generic_parameter_init (id: %): %', p_id, SQLERRM; 
END;
$$
LANGUAGE plpgsql;

-- ***********************************************************************
-- ***********************************************************************












































-- ***********************************************************************
-- ***********************************************************************

DO
$$
BEGIN
RAISE NOTICE '

********************************

Simulation package DML functions installation complete!

********************************

';
END
$$;
SELECT 'Simulation package DML functions installation complete!'::varchar AS installation_result;

-- ***********************************************************************
-- ***********************************************************************
--
-- END OF FILE
--
-- ***********************************************************************
-- ***********************************************************************
