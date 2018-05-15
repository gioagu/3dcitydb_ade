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
-- View GENERIC_PARAMETER_SIM
----------------------------------------------------------------
DROP VIEW IF EXISTS sim_pkg.generic_parameter_sim CASCADE; 
CREATE OR REPLACE VIEW sim_pkg.generic_parameter_sim AS
SELECT 
  gp.id, 
  gp.name, 
  gp.name_codespace, 
  gp.description,
  gp.is_init_parameter        ,
  gp.citydb_table_name        ,
  gp.citydb_object_id         ,
  gp.citydb_column_name       ,
  gp.citydb_genericattrib_name,
  gp.citydb_function          ,
  gp.strval, 
  gp.intval, 
  gp.realval, 
  gp.arrayval, 
  gp.urival, 
  gp.dateval, 
  gp.unit, 
--  gp.tool_id, 
--  gp.node_id, 
  gp.simulation_id
FROM 
  sim_pkg.generic_parameter gp
WHERE 
  gp.simulation_id IS NOT NULL;
-- ALTER VIEW sim_pkg.generic_parameter_sim OWNER postgres

----------------------------------------------------------------
-- View GENERIC_PARAMETER_NODE
----------------------------------------------------------------
DROP VIEW IF EXISTS sim_pkg.generic_parameter_node CASCADE; 
CREATE OR REPLACE VIEW sim_pkg.generic_parameter_node AS
SELECT 
  gp.id, 
  gp.name, 
  gp.name_codespace, 
  gp.description,
  gp.is_init_parameter        ,
  gp.citydb_table_name        ,
  gp.citydb_object_id         ,
  gp.citydb_column_name       ,
  gp.citydb_genericattrib_name,
  gp.citydb_function          ,  
  gp.strval, 
  gp.intval, 
  gp.realval, 
  gp.arrayval, 
  gp.urival, 
  gp.dateval, 
  gp.unit, 
--  gp.tool_id, 
  gp.node_id 
--  gp.simulation_id
FROM 
  sim_pkg.generic_parameter gp
WHERE 
  gp.node_id IS NOT NULL;
-- ALTER VIEW sim_pkg.generic_parameter_node OWNER postgres

----------------------------------------------------------------
-- View GENERIC_PARAMETER_TOOL
----------------------------------------------------------------
DROP VIEW IF EXISTS sim_pkg.generic_parameter_tool CASCADE; 
CREATE OR REPLACE VIEW sim_pkg.generic_parameter_tool AS
SELECT 
  gp.id, 
  gp.name, 
  gp.name_codespace, 
  gp.description,
  gp.is_init_parameter        ,
  gp.citydb_table_name        ,
  gp.citydb_object_id         ,
  gp.citydb_column_name       ,
  gp.citydb_genericattrib_name,
  gp.citydb_function          ,  
  gp.strval, 
  gp.intval, 
  gp.realval, 
  gp.arrayval, 
  gp.urival, 
  gp.dateval, 
  gp.unit, 
  gp.tool_id 
--  gp.node_id, 
--  gp.simulation_id
FROM 
  sim_pkg.generic_parameter gp
WHERE 
  gp.tool_id IS NOT NULL;
-- ALTER VIEW sim_pkg.generic_parameter_tool OWNER postgres

----------------------------------------------------------------
-- View PORT_CONNECTION_EXT(ended)
----------------------------------------------------------------
DROP VIEW IF EXISTS sim_pkg.port_connection_ext CASCADE; 
CREATE OR REPLACE VIEW sim_pkg.port_connection_ext AS
SELECT 
  pc.id, 
  pc.simulation_id, 
  pc.gmlid, 
  pc.gmlid_codespace, 
  pc.name, 
  pc.name_codespace, 
  pc.description, 
  
  p1.id                 AS p1_id             ,
  p1.type               AS p1_type           ,
  p1.gmlid              AS p1_gmlid          ,
  p1.gmlid_codespace    AS p1_gmlid_codespace,
  p1.name               AS p1_name           ,
  p1.name_codespace     AS p1_name_codespace ,
  p1.description        AS p1_description    ,
  p1.variable_name      AS p1_variable_name  ,
  p1.variable_type      AS p1_variable_type  ,
  p1.cityobject_id      AS p1_cityobject_id  ,
--  co1p.id               AS co1p_id           ,  
  o1p.classname         AS p1_co_classname    , 
  n1.id                 AS n1_id             ,
  n1.gmlid              AS n1_gmlid          ,
  n1.gmlid_codespace    AS n1_gmlid_codespace,
  n1.name               AS n1_name           ,
  n1.name_codespace     AS n1_name_codespace ,
  n1.description        AS n1_description    ,
  n1.cityobject_id      AS n1_cityobject_id  ,
--  co1n.id               AS con1_id           ,
  o1n.classname         AS n1_co_classname    ,
  
  p2.id                 AS p2_id             ,
  p2.type               AS p2_type           ,
  p2.gmlid              AS p2_gmlid          ,
  p2.gmlid_codespace    AS p2_gmlid_codespace,
  p2.name               AS p2_name           ,
  p2.name_codespace     AS p2_name_codespace ,
  p2.description        AS p2_description    ,
  p2.variable_name      AS p2_variable_name  ,
  p2.variable_type      AS p2_variable_type  ,
  p2.cityobject_id      AS p2_cityobject_id  ,
--  co2p.id               AS cop2_id           ,
  o2p.classname         AS p2_co_classname    , 
  n2.id                 AS n2_id             ,
  n2.gmlid              AS n2_gmlid          ,
  n2.gmlid_codespace    AS n2_gmlid_codespace,
  n2.name               AS n2_name           ,
  n2.name_codespace     AS n2_name_codespace ,
  n2.description        AS n2_description    ,
  n2.cityobject_id      AS n2_cityobject_id  ,
 -- co2n.id               AS con2_id,
  o2n.classname         AS n2_co_classname                    
FROM 
  sim_pkg.port_connection pc, 
  sim_pkg.port p1 LEFT OUTER JOIN (citydb.cityobject co1p INNER JOIN citydb.objectclass o1p ON co1p.objectclass_id=o1p.id) ON p1.cityobject_id=co1p.id, 
  sim_pkg.port p2 LEFT OUTER JOIN (citydb.cityobject co2p INNER JOIN citydb.objectclass o2p ON co2p.objectclass_id=o2p.id) ON p2.cityobject_id=co2p.id, 
  sim_pkg.node n1 LEFT OUTER JOIN (citydb.cityobject co1n INNER JOIN citydb.objectclass o1n ON co1n.objectclass_id=o1n.id) ON n1.cityobject_id=co1n.id, 
  sim_pkg.node n2 LEFT OUTER JOIN (citydb.cityobject co2n INNER JOIN citydb.objectclass o2n ON co2n.objectclass_id=o2n.id) ON n2.cityobject_id=co2n.id
WHERE 
  p1.id = pc.output_port_id AND
  p2.id = pc.input_port_id AND
  n1.id = p1.node_id AND
  n2.id = p2.node_id;
-- ALTER VIEW sim_pkg.port_connection_ext OWNER postgres

----------------------------------------------------------------
-- View NODE_TEMPLATE
----------------------------------------------------------------
DROP VIEW IF EXISTS sim_pkg.node_template CASCADE; 
CREATE VIEW         sim_pkg.node_template AS
SELECT 
  nt.id,
  nt.parent_id,
  nt.gmlid,
  nt.gmlid_codespace,
  nt.name,
  nt.name_codespace,
  nt.description,
  nt.is_template,
  nt.cityobject_id,
  nt.tool_id,
  nt.simulation_id
FROM sim_pkg.node AS nt
WHERE 
  nt.is_template IS TRUE;
-- ALTER VIEW sim_pkg.node_template OWNER postgres

COMMENT ON VIEW sim_pkg.node_template IS 'This view shows only those nodes that are TEMPLATES';

----------------------------------------------------------------
-- View NODE
----------------------------------------------------------------
DROP VIEW IF EXISTS sim_pkg.node_no_template CASCADE; 
CREATE VIEW         sim_pkg.node_no_template AS
SELECT 
  nt.id,
  nt.parent_id,
  nt.gmlid,
  nt.gmlid_codespace,
  nt.name,
  nt.name_codespace,
  nt.description,
  nt.is_template,
  nt.cityobject_id,
  nt.tool_id,
  nt.simulation_id
FROM sim_pkg.node AS nt
WHERE 
  nt.is_template IS FALSE;
-- ALTER VIEW sim_pkg.node_no_template OWNER postgres

COMMENT ON VIEW sim_pkg.node_no_template IS 'This view shows only those nodes that are NO TEMPLATES';

-- ***********************************************************************
-- ***********************************************************************

DO
$$
BEGIN
RAISE NOTICE '

********************************

Simulation package views installation complete!

********************************

';
END
$$;
SELECT 'Simulation package views installation complete!'::varchar AS installation_result;

-- ***********************************************************************
-- ***********************************************************************
--
-- END OF FILE
--
-- ***********************************************************************
-- ***********************************************************************

