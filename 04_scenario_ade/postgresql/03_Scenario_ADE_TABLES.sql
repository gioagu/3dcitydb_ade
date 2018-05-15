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
-- ********************* 03_Scenario_ADE_TABLES.sql **********************
--
-- This script adds the stored procedures to the citydb_pkg schema.
-- They are all prefixed with "scn2_".
--
-- ***********************************************************************
-- ***********************************************************************

----------------------------------------------------------------
-- Table SCENARIO (FEATURE prototype)
----------------------------------------------------------------
DROP TABLE IF EXISTS citydb.scn2_scenario CASCADE;
CREATE TABLE citydb.scn2_scenario (
  id                 serial PRIMARY KEY,
  objectclass_id     integer NOT NULL, -- This is a foreign key to citydb.objectclass.id
  scenario_parent_id integer,
  gmlid              varchar,
  gmlid_codespace    varchar,
  name               varchar,
  name_codespace     varchar,
  description        text,
  class              varchar,
  instant            timestamptz(0),
  period_begin       date,
  period_end         date,
  citymodel_id       integer,
  cityobject_id      integer,
  envelope           geometry(PolygonZ),	
  creator_name       varchar DEFAULT user,
  creation_date      timestamptz(0) DEFAULT now()::timestamptz(0)
);
-- ALTER TABLE citydb.scn2_scenario OWNER TO postgres;

CREATE INDEX scn2_scen_gmlid_inx          ON citydb.scn2_scenario USING btree (gmlid, gmlid_codespace);
CREATE INDEX scn2_scen_objclass_id_fkx    ON citydb.scn2_scenario USING btree (objectclass_id);
CREATE INDEX scn2_scen_scen_parent_id_fkx ON citydb.scn2_scenario USING btree (scenario_parent_id);
CREATE INDEX scn2_scen_citymodel_id_fkx   ON citydb.scn2_scenario USING btree (citymodel_id);
CREATE INDEX scn2_scen_ctyobj_id_fkx      ON citydb.scn2_scenario USING btree (cityobject_id);
CREATE INDEX scn2_scen_envelope_spx       ON citydb.scn2_scenario USING gist  (envelope gist_geometry_ops_nd);

COMMENT ON TABLE citydb.scn2_scenario IS 'Information about the scenario';

COMMENT ON COLUMN citydb.scn2_scenario.id                  IS 'ID';
COMMENT ON COLUMN citydb.scn2_scenario.objectclass_id      IS 'Objectclass ID of the scenario';
COMMENT ON COLUMN citydb.scn2_scenario.scenario_parent_id  IS 'ID of the parent scenario';
COMMENT ON COLUMN citydb.scn2_scenario.gmlid               IS 'Gml ID';
COMMENT ON COLUMN citydb.scn2_scenario.gmlid_codespace     IS 'Gml ID codespace';
COMMENT ON COLUMN citydb.scn2_scenario.name                IS 'Name';
COMMENT ON COLUMN citydb.scn2_scenario.name_codespace      IS 'Name codespace';
COMMENT ON COLUMN citydb.scn2_scenario.description         IS 'Description';
COMMENT ON COLUMN citydb.scn2_scenario.class               IS 'Class';
COMMENT ON COLUMN citydb.scn2_scenario.instant             IS 'Temporal reference: instant date';
COMMENT ON COLUMN citydb.scn2_scenario.period_begin        IS 'Temporal reference: period begin date';
COMMENT ON COLUMN citydb.scn2_scenario.period_end          IS 'Temporal reference: period end date';
COMMENT ON COLUMN citydb.scn2_scenario.citymodel_id        IS 'Target citymodel of this scenario';
COMMENT ON COLUMN citydb.scn2_scenario.cityobject_id       IS 'Target cityobject of this scenario';
COMMENT ON COLUMN citydb.scn2_scenario.envelope            IS 'Spatial bounding box of this scenario';
COMMENT ON COLUMN citydb.scn2_scenario.creator_name        IS 'Name of the scenario creator';
COMMENT ON COLUMN citydb.scn2_scenario.creation_date       IS 'Timestamp of the scenario creation';

----------------------------------------------------------------
-- Table OPERATION (FEATURE prototype)
----------------------------------------------------------------
DROP TABLE IF EXISTS citydb.scn2_operation CASCADE;
CREATE TABLE         citydb.scn2_operation (
  id                        serial PRIMARY KEY,
  objectclass_id            integer NOT NULL, -- This is a foreign key to citydb.objectclass.id
  operation_parent_id       integer,          -- This is a foreign key to citydb.scn2_operation.id
  operation_root_id         integer,          -- This is a foreign key to citydb.scn2_operation.id
  gmlid                     varchar,
  gmlid_codespace           varchar,
  name                      varchar,
  name_codespace            varchar,
  description               text,
  pos_nbr                   integer,
  class                     varchar,
  instant                   timestamptz(0),
  period_begin              date,
  period_end                date,  
  parent_feature_uri        varchar,
  feature_uri               varchar,
  attribute_uri             varchar,
  citydb_table_name         varchar,
  citydb_object_id          integer,
  citydb_column_name        varchar,
  citydb_function           varchar,
  citydb_genericattrib_name varchar,
-- *** generic attribute
  strval                    varchar,
  booleanval                numeric(1,0),
  intval                    integer,
  realval                   numeric,
  unit                      varchar,
  dateval                   timestamptz,
  urival                    varchar,
  geomval                   geometry(GeometryZ),
  time_series_id            integer,
-- ***	
--  arrayval              numeric[],
--  blobval               bytea,
--  cityobject_id         integer,
	xml_source              text
);
-- ALTER TABLE citydb.scn2_operation OWNER TO postgres;

CREATE INDEX scn2_oper_objclass_id_fkx         ON citydb.scn2_operation USING btree (objectclass_id);
CREATE INDEX scn2_oper_parent_id_fkx           ON citydb.scn2_operation USING btree (operation_parent_id);
CREATE INDEX scn2_oper_root_id_fkx             ON citydb.scn2_operation USING btree (operation_root_id);
CREATE INDEX scn2_oper_gmlid_inx               ON citydb.scn2_operation USING btree (gmlid, gmlid_codespace);
CREATE INDEX scn2_oper_pos_nbr_inx             ON citydb.scn2_operation USING btree (pos_nbr);
--CREATE INDEX scn2_oper_ctyobj_id_fkx           ON citydb.scn2_operation USING btree (cityobject_id);

COMMENT ON TABLE citydb.scn2_operation IS 'Operation, i.e. an update, insert or delete one, or a combination of them';

COMMENT ON COLUMN citydb.scn2_operation.id                    IS 'ID';
COMMENT ON COLUMN citydb.scn2_operation.operation_parent_id   IS 'ID of the parent operation';
COMMENT ON COLUMN citydb.scn2_operation.operation_root_id     IS 'ID of the root operation';
COMMENT ON COLUMN citydb.scn2_operation.objectclass_id        IS 'Objectclass ID of the operation';
COMMENT ON COLUMN citydb.scn2_operation.gmlid                 IS 'Gml ID';
COMMENT ON COLUMN citydb.scn2_operation.gmlid_codespace       IS 'Gml ID codespace';
COMMENT ON COLUMN citydb.scn2_operation.name                  IS 'Name';
COMMENT ON COLUMN citydb.scn2_operation.name_codespace        IS 'Name codespace';
COMMENT ON COLUMN citydb.scn2_operation.description           IS 'Description';
COMMENT ON COLUMN citydb.scn2_operation.class                 IS 'Class';
COMMENT ON COLUMN citydb.scn2_operation.instant               IS 'Temporal reference: instant date';
COMMENT ON COLUMN citydb.scn2_operation.period_begin          IS 'Temporal reference: period begin date';
COMMENT ON COLUMN citydb.scn2_operation.period_end            IS 'Temporal reference: period end date';
COMMENT ON COLUMN citydb.scn2_operation.pos_nbr               IS 'Order position of the SimpleOperation within the ComplexOperation';
COMMENT ON COLUMN citydb.scn2_operation.parent_feature_uri    IS 'URI of the parent feature';
COMMENT ON COLUMN citydb.scn2_operation.feature_uri           IS 'URI of the feature';
COMMENT ON COLUMN citydb.scn2_operation.attribute_uri         IS 'URI of the target feature attribute';
COMMENT ON COLUMN citydb.scn2_operation.citydb_table_name     IS 'Name of the target table in the 3DCityDB';
COMMENT ON COLUMN citydb.scn2_operation.citydb_object_id      IS 'ID of the target object in the 3DCityDB';
COMMENT ON COLUMN citydb.scn2_operation.citydb_column_name    IS 'Name of the target column in the 3DCityDB';
COMMENT ON COLUMN citydb.scn2_operation.citydb_function       IS 'Function to be performed in the 3DCityDB';
COMMENT ON COLUMN citydb.scn2_operation.citydb_genericattrib_name IS 'Name of the generic attribute in the 3DCityDB'; 
COMMENT ON COLUMN citydb.scn2_operation.booleanval            IS 'Boolean value';
COMMENT ON COLUMN citydb.scn2_operation.strval                IS 'String value';
COMMENT ON COLUMN citydb.scn2_operation.intval                IS 'Integer value';
COMMENT ON COLUMN citydb.scn2_operation.realval               IS 'Real (numeric) value';
COMMENT ON COLUMN citydb.scn2_operation.urival                IS 'Any URI';
COMMENT ON COLUMN citydb.scn2_operation.dateval               IS 'Date value';
COMMENT ON COLUMN citydb.scn2_operation.unit                  IS 'Unit of measure';
COMMENT ON COLUMN citydb.scn2_operation.geomval               IS 'GeometryZ value';
COMMENT ON COLUMN citydb.scn2_operation.time_series_id        IS 'ID of the time series';
--COMMENT ON COLUMN citydb.scn2_operation.arrayval              IS 'Array of (numeric) values';
--COMMENT ON COLUMN citydb.scn2_operation.blobval               IS 'Blob value';
--COMMENT ON COLUMN citydb.scn2_operation.cityobject_id         IS 'Implements +isAppliedTo attribute';
COMMENT ON COLUMN citydb.scn2_operation.xml_source            IS 'XML of the (city)object';

----------------------------------------------------------------
-- Table SCENARIO_TO_OPERATION
----------------------------------------------------------------
DROP TABLE IF EXISTS citydb.scn2_scenario_to_operation CASCADE;
CREATE TABLE         citydb.scn2_scenario_to_operation (
scenario_id  integer NOT NULL,
operation_id integer NOT NULL,
pos_nbr      integer,
CONSTRAINT scn2_scenario_to_operation_pk PRIMARY KEY (scenario_id, operation_id)
);
-- ALTER TABLE citydb.scn2_scenario_to_operation OWNER TO postgres;

CREATE INDEX scn2_scen_to_oper_scen_id_fkx ON citydb.scn2_scenario_to_operation USING btree (scenario_id);
CREATE INDEX scn2_scen_to_oper_oper_id_fkx ON citydb.scn2_scenario_to_operation USING btree (operation_id);
CREATE INDEX scn2_scen_to_oper_pos_fkx     ON citydb.scn2_scenario_to_operation USING btree (pos_nbr);

----------------------------------------------------------------
-- Table SCENARIO_PARAMETER (dataType)
----------------------------------------------------------------
DROP TABLE IF EXISTS citydb.scn2_scenario_parameter CASCADE;
CREATE TABLE         citydb.scn2_scenario_parameter (
	id               serial PRIMARY KEY,
	type             varchar CHECK (type IN ('input', 'output')),
	name             varchar NOT NULL,
	name_codespace   varchar,
	description      text,
	class            varchar,
	constraint_type  varchar,
-- *** simulation properties	
	sim_name         varchar,
  sim_description  varchar,
	sim_reference    varchar,
-- temporal aggregation
  aggregation_type varchar,
  temp_aggregation varchar,
-- *** generic attribute	
  strval           varchar,
  booleanval       numeric(1,0),
  intval           integer,
  realval          numeric,
  unit             varchar,
  dateval          date,
  urival           varchar,
  geomval          geometry(GeometryZ),
  time_series_id   integer,
-- ***             
	cityobject_id    integer,
	scenario_id      integer
);
-- ALTER TABLE citydb.scn2_result OWNER TO postgres;

CREATE INDEX scn2_scnpar_type_fkx    ON citydb.scn2_scenario_parameter USING btree (type);
CREATE INDEX scn2_scnpar_name_inx    ON citydb.scn2_scenario_parameter USING btree (name, name_codespace);
CREATE INDEX scn2_scnpar_ts_id_fkx   ON citydb.scn2_scenario_parameter USING btree (time_series_id);
CREATE INDEX scn2_scnpar_cto_id_fkx  ON citydb.scn2_scenario_parameter USING btree (cityobject_id);
CREATE INDEX scn2_scnpar_scen_id_fkx ON citydb.scn2_scenario_parameter USING btree (scenario_id);

COMMENT ON TABLE citydb.scn2_scenario_parameter IS 'Result parameter (KPI, etc.) of a scenario';

COMMENT ON COLUMN citydb.scn2_scenario_parameter.id               IS 'ID';
COMMENT ON COLUMN citydb.scn2_scenario_parameter.type             IS 'Type of parameter, value in (input, output)';
COMMENT ON COLUMN citydb.scn2_scenario_parameter.name             IS 'Name';
COMMENT ON COLUMN citydb.scn2_scenario_parameter.name_codespace   IS 'Name codespace';
COMMENT ON COLUMN citydb.scn2_scenario_parameter.description      IS 'Description';
COMMENT ON COLUMN citydb.scn2_scenario_parameter.class            IS 'Class';
COMMENT ON COLUMN citydb.scn2_scenario_parameter.constraint_type  IS 'Type of constraint';
COMMENT ON COLUMN citydb.scn2_scenario_parameter.sim_name         IS 'Simulation name';
COMMENT ON COLUMN citydb.scn2_scenario_parameter.sim_description  IS 'Simulation description';
COMMENT ON COLUMN citydb.scn2_scenario_parameter.sim_reference    IS 'Simulation reference';
COMMENT ON COLUMN citydb.scn2_scenario_parameter.aggregation_type IS 'Type of aggreagation';
COMMENT ON COLUMN citydb.scn2_scenario_parameter.temp_aggregation IS 'Temporal aggregation';
COMMENT ON COLUMN citydb.scn2_scenario_parameter.booleanval       IS 'Boolean value';
COMMENT ON COLUMN citydb.scn2_scenario_parameter.strval           IS 'String value';
COMMENT ON COLUMN citydb.scn2_scenario_parameter.intval           IS 'Integer value';
COMMENT ON COLUMN citydb.scn2_scenario_parameter.realval          IS 'Real (numeric) value';
COMMENT ON COLUMN citydb.scn2_scenario_parameter.urival           IS 'Any URI';
COMMENT ON COLUMN citydb.scn2_scenario_parameter.dateval          IS 'Date value';
COMMENT ON COLUMN citydb.scn2_scenario_parameter.unit             IS 'Unit of measure';
COMMENT ON COLUMN citydb.scn2_scenario_parameter.geomval          IS 'GeometryZ value';
COMMENT ON COLUMN citydb.scn2_scenario_parameter.time_series_id   IS 'ID of the time series';
COMMENT ON COLUMN citydb.scn2_scenario_parameter.cityobject_id    IS 'ID of the cityobject';
COMMENT ON COLUMN citydb.scn2_scenario_parameter.scenario_id      IS 'ID of the scenario';

----------------------------------------------------------------
-- Table RESOURCE (FEATURE prototype)
----------------------------------------------------------------
DROP TABLE IF EXISTS citydb.scn2_resource CASCADE;
CREATE TABLE citydb.scn2_resource (
	id                 serial PRIMARY KEY,
	objectclass_id     integer NOT NULL, -- This is a foreign key to citydb.objectclass.id
	gmlid              varchar,
	gmlid_codespace    varchar,
	name               varchar,
	name_codespace     varchar,
	description        text,
	type               varchar,
	quantity           numeric,
	quantity_unit      varchar,
	total_cost         numeric,
	total_cost_unit    varchar,
	unitary_cost       numeric,
	unitary_cost_unit  varchar,
	is_renewable       numeric(1,0),
	scenario_id        integer, -- This is a foreign key to citydb.scn2_scenario.id
	operation_id       integer  -- This is a foreign key to citydb.scn2_operation.id
);

CREATE INDEX scn2_resource_gmlid_inx        ON citydb.scn2_resource USING btree (gmlid, gmlid_codespace);
CREATE INDEX scn2_resource_objclass_id_fkx  ON citydb.scn2_resource USING btree (objectclass_id);
CREATE INDEX scn2_resource_type_fkx         ON citydb.scn2_resource USING btree (type);
CREATE INDEX scn2_resource_scenario_id_fkx  ON citydb.scn2_resource USING btree (scenario_id);
CREATE INDEX scn2_resource_operation_id_fkx ON citydb.scn2_resource USING btree (operation_id);

COMMENT ON TABLE citydb.scn2_resource IS 'Resource(s) required by a scenario or an operation';

COMMENT ON COLUMN citydb.scn2_resource.id                 IS 'ID';
COMMENT ON COLUMN citydb.scn2_resource.objectclass_id     IS 'Objectclass ID of the resource';
COMMENT ON COLUMN citydb.scn2_resource.gmlid              IS 'Gml ID';
COMMENT ON COLUMN citydb.scn2_resource.gmlid_codespace    IS 'Gml ID codespace';
COMMENT ON COLUMN citydb.scn2_resource.name               IS 'Name';
COMMENT ON COLUMN citydb.scn2_resource.name_codespace     IS 'Name codespace';
COMMENT ON COLUMN citydb.scn2_resource.description        IS 'Description';
COMMENT ON COLUMN citydb.scn2_resource.type               IS 'Type of resource';
COMMENT ON COLUMN citydb.scn2_resource.quantity           IS 'Quantity of resource';
COMMENT ON COLUMN citydb.scn2_resource.quantity_unit      IS 'Unit of measure';
COMMENT ON COLUMN citydb.scn2_resource.total_cost         IS 'Total cost of the resource';
COMMENT ON COLUMN citydb.scn2_resource.total_cost_unit    IS 'Currency of the total cost';
COMMENT ON COLUMN citydb.scn2_resource.unitary_cost       IS 'Unitary cost of the resource';
COMMENT ON COLUMN citydb.scn2_resource.unitary_cost_unit  IS 'Currency of the unitary cost';
COMMENT ON COLUMN citydb.scn2_resource.is_renewable       IS 'Is the resource renewable?';
COMMENT ON COLUMN citydb.scn2_resource.scenario_id        IS 'ID of the scenario';
COMMENT ON COLUMN citydb.scn2_resource.operation_id       IS 'ID of the operation';

----------------------------------------------------------------
-- Table LU_INTERPOLATION
----------------------------------------------------------------
DROP TABLE IF EXISTS citydb.scn2_lu_interpolation CASCADE;
CREATE TABLE         citydb.scn2_lu_interpolation (
id             varchar PRIMARY KEY,
name           varchar,
name_codespace varchar,
description    text
);
-- ALTER TABLE citydb.scn2_lu_interpolation OWNER TO postgres;

CREATE INDEX scn2_lu_interp_name_inx ON citydb.scn2_lu_interpolation USING btree (name, name_codespace);

----------------------------------------------------------------
-- Table LU_ACQUISITION_METHOD
----------------------------------------------------------------
DROP TABLE IF EXISTS citydb.scn2_lu_acquisition_method CASCADE;
CREATE TABLE         citydb.scn2_lu_acquisition_method (
id             varchar PRIMARY KEY,
name           varchar,
name_codespace varchar,
description    text
);
-- ALTER TABLE citydb.scn2_lu_acquisition_method OWNER TO postgres;

CREATE INDEX scn2_lu_acq_method_name_inx ON citydb.scn2_lu_acquisition_method USING btree (name, name_codespace);

----------------------------------------------------------------
-- Table LU_CONSTRAINT
----------------------------------------------------------------
DROP TABLE IF EXISTS citydb.scn2_lu_constraint_type CASCADE;
CREATE TABLE         citydb.scn2_lu_constraint_type (
id             varchar PRIMARY KEY,
name           varchar,
name_codespace varchar,
description    text
);
-- ALTER TABLE citydb.scn2_lu_constraint_type OWNER TO postgres;

CREATE INDEX scn2_lu_constr_inx ON citydb.scn2_lu_constraint_type USING btree (name, name_codespace);

----------------------------------------------------------------
-- Table LU_TEMPORAL_AGGREGATION
----------------------------------------------------------------
DROP TABLE IF EXISTS citydb.scn2_lu_temporal_aggregation CASCADE;
CREATE TABLE         citydb.scn2_lu_temporal_aggregation (
id             varchar PRIMARY KEY,
name           varchar,
name_codespace varchar,
description    text
);
-- ALTER TABLE citydb.scn2_lu_temporal_aggregation OWNER TO postgres;

CREATE INDEX scn2_lu_temp_aggr_inx ON citydb.scn2_lu_temporal_aggregation USING btree (name, name_codespace);

----------------------------------------------------------------
-- Table LU_AGGREGATION_TYPE
----------------------------------------------------------------
DROP TABLE IF EXISTS citydb.scn2_lu_aggregation_type CASCADE;
CREATE TABLE         citydb.scn2_lu_aggregation_type (
id             varchar PRIMARY KEY,
name           varchar,
name_codespace varchar,
description    text
);
-- ALTER TABLE citydb.scn2_lu_aggregation_type OWNER TO postgres;

----------------------------------------------------------------
-- Table TIME_SERIES
----------------------------------------------------------------
DROP TABLE IF EXISTS citydb.scn2_time_series CASCADE;
CREATE TABLE         citydb.scn2_time_series (
	id serial             PRIMARY KEY,
	objectclass_id        integer NOT NULL, -- This is a foreign key to objectclass.id
	gmlid                 varchar,
	gmlid_codespace       varchar,
	name                  varchar,
	name_codespace        varchar,
	description           text,
	acquisition_method    varchar NOT NULL,  -- This is a foreign key to lu_acquisition_method.id
	interpolation_type    varchar NOT NULL,  -- This is a foreign key to lu_interpolation.id
	quality_description   text,
	source                varchar,
	time_array            timestamptz[], 
	values_array          numeric[],
	values_unit           varchar NOT NULL,
	array_length          integer,
	temporal_extent_begin timestamptz(0),
	temporal_extent_end   timestamptz(0),
	time_interval         numeric,
	time_interval_unit    varchar
);
-- ALTER TABLE citydb.scn2_time_series OWNER TO postgres;

CREATE INDEX scn2_tseries_gmlid_inx ON citydb.scn2_time_series USING btree (gmlid, gmlid_codespace);
CREATE INDEX scn2_tseries_objclass_id_fkx ON citydb.scn2_time_series USING btree (objectclass_id);
CREATE INDEX scn2_tseries_acq_method_fkx ON citydb.scn2_time_series USING btree (acquisition_method);
CREATE INDEX scn2_tseries_interp_type_fkx ON citydb.scn2_time_series USING btree (interpolation_type);

COMMENT ON TABLE citydb.scn2_time_series IS 'Time series for Scenario ADE';

COMMENT ON COLUMN citydb.scn2_time_series.objectclass_id        IS 'Objectclass ID of the time series';
COMMENT ON COLUMN citydb.scn2_time_series.acquisition_method    IS 'Acquisition method';
COMMENT ON COLUMN citydb.scn2_time_series.interpolation_type    IS 'Interpolation type';
COMMENT ON COLUMN citydb.scn2_time_series.quality_description   IS 'Quality description';
COMMENT ON COLUMN citydb.scn2_time_series.source                IS 'Source';
COMMENT ON COLUMN citydb.scn2_time_series.time_array            IS 'Vector of timestamp values (to be used for irregular TimeSeries)';
COMMENT ON COLUMN citydb.scn2_time_series.values_array          IS 'Vector of values';
COMMENT ON COLUMN citydb.scn2_time_series.values_unit           IS 'Units of measure of values';
COMMENT ON COLUMN citydb.scn2_time_series.array_length          IS 'Number of values in the vector';
COMMENT ON COLUMN citydb.scn2_time_series.temporal_extent_begin IS 'Begin of temporal extent';
COMMENT ON COLUMN citydb.scn2_time_series.temporal_extent_end   IS 'End of temporal extent';
COMMENT ON COLUMN citydb.scn2_time_series.time_interval         IS 'Time interval';
COMMENT ON COLUMN citydb.scn2_time_series.time_interval_unit    IS 'Time interval units of measure';

----------------------------------------------------------------
-- Table TIME_SERIES_FILE
----------------------------------------------------------------
DROP TABLE IF EXISTS citydb.scn2_time_series_file CASCADE;
CREATE TABLE         citydb.scn2_time_series_file (
	id               integer PRIMARY KEY,
	objectclass_id   integer NOT NULL, -- This is a foreign key to objectclass.id
	file_path        varchar,
	file_name        varchar NOT NULL,
	file_extension   varchar NOT NULL,
	nbr_header_lines integer,
	field_sep        varchar,
	record_sep       varchar,
	dec_symbol       varchar,
	time_col_nbr     integer,
	value_col_nbr    integer,
	is_compressed    numeric(1,0)
);
-- ALTER TABLE citydb.scn2_time_series_file OWNER TO postgres;

CREATE INDEX scn2_tseries_file_objclass_id_fkx ON citydb.scn2_time_series_file USING btree (objectclass_id);

COMMENT ON TABLE citydb.scn2_time_series_file IS 'Additional attributes for file-based time series';

COMMENT ON COLUMN citydb.scn2_time_series_file.file_path        IS 'Path to the file containing the time series';
COMMENT ON COLUMN citydb.scn2_time_series_file.file_name        IS 'Name of the file containing the time series';
COMMENT ON COLUMN citydb.scn2_time_series_file.file_extension   IS 'Extension of the file containing the time series';
COMMENT ON COLUMN citydb.scn2_time_series_file.nbr_header_lines IS 'Number of header lines';
COMMENT ON COLUMN citydb.scn2_time_series_file.field_sep        IS 'Field separator';
COMMENT ON COLUMN citydb.scn2_time_series_file.record_sep       IS 'Record separator';
COMMENT ON COLUMN citydb.scn2_time_series_file.dec_symbol       IS 'Decimal separator symbol (e.g. "." or ",")';
COMMENT ON COLUMN citydb.scn2_time_series_file.time_col_nbr     IS 'Column number containing timestamps';
COMMENT ON COLUMN citydb.scn2_time_series_file.value_col_nbr    IS 'Column number containing values';
COMMENT ON COLUMN citydb.scn2_time_series_file.is_compressed    IS '(Optional) Is the file compressed, e.g. zipped?';

----------------------------------------------------------------
-- ADD FOREIGN KEY CONTRAINTS
----------------------------------------------------------------

-- FOREIGN KEY constraint on Table SCENARIO
ALTER TABLE IF EXISTS citydb.scn2_scenario ADD CONSTRAINT scn2_scen_objclass_fk FOREIGN KEY (objectclass_id) REFERENCES citydb.objectclass (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;
ALTER TABLE IF EXISTS citydb.scn2_scenario ADD CONSTRAINT scn2_scen_scn2_scen_fk FOREIGN KEY (scenario_parent_id) REFERENCES citydb.scn2_scenario (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;
ALTER TABLE IF EXISTS citydb.scn2_scenario ADD CONSTRAINT scn2_scen_ctyobj_fk FOREIGN KEY (cityobject_id) REFERENCES citydb.cityobject (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;
ALTER TABLE IF EXISTS citydb.scn2_scenario ADD CONSTRAINT scn2_scen_ctymod_fk FOREIGN KEY (citymodel_id) REFERENCES citydb.citymodel (id) MATCH FULL ON UPDATE CASCADE ON DELETE SET NULL;



-- FOREIGN KEY constraint on Table OPERATION
ALTER TABLE IF EXISTS citydb.scn2_operation ADD CONSTRAINT scn2_oper_objclass_fk FOREIGN KEY (objectclass_id) REFERENCES citydb.objectclass (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;
ALTER TABLE IF EXISTS citydb.scn2_operation ADD CONSTRAINT scn2_oper_scn_oper_fk1 FOREIGN KEY (operation_parent_id) REFERENCES citydb.scn2_operation (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;
ALTER TABLE IF EXISTS citydb.scn2_operation ADD CONSTRAINT scn2_oper_scn_oper_fk2 FOREIGN KEY (operation_root_id) REFERENCES citydb.scn2_operation (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;
--ALTER TABLE IF EXISTS citydb.scn2_operation ADD CONSTRAINT scn2_oper_cto_fk FOREIGN KEY (cityobject_id) REFERENCES citydb.cityobject (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;
ALTER TABLE IF EXISTS citydb.scn2_operation ADD CONSTRAINT scn2_oper_ts_fk FOREIGN KEY (time_series_id) REFERENCES citydb.scn2_time_series (id) MATCH FULL ON UPDATE CASCADE ON DELETE SET NULL;

-- FOREIGN KEY constraint on Table SCENARIO_TO_OPERATION
ALTER TABLE IF EXISTS citydb.scn2_scenario_to_operation ADD CONSTRAINT scn2_scen_to_scn_scen_fk FOREIGN KEY (scenario_id) REFERENCES citydb.scn2_scenario (id) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE IF EXISTS citydb.scn2_scenario_to_operation ADD CONSTRAINT scn2_scen_to_scn_oper_fk FOREIGN KEY (operation_id)  REFERENCES citydb.scn2_operation (id) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;

-- FOREIGN KEY constraint on Table SCN_SCENARIO_PARAMETER
ALTER TABLE IF EXISTS citydb.scn2_scenario_parameter ADD CONSTRAINT scn2_scnpar_scn_scen_fk FOREIGN KEY (scenario_id) REFERENCES citydb.scn2_scenario (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;
ALTER TABLE IF EXISTS citydb.scn2_scenario_parameter ADD CONSTRAINT scn2_scnpar_ctyobj_fk FOREIGN KEY (cityobject_id) REFERENCES citydb.cityobject (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;
ALTER TABLE IF EXISTS citydb.scn2_scenario_parameter ADD CONSTRAINT scn2_scnpar_ts_fk FOREIGN KEY (time_series_id) REFERENCES citydb.scn2_time_series (id) MATCH FULL ON UPDATE CASCADE ON DELETE SET NULL;

ALTER TABLE IF EXISTS citydb.scn2_scenario_parameter ADD CONSTRAINT scn2_scnpar_scn_lu_constr_fk FOREIGN KEY (constraint_type) REFERENCES citydb.scn2_lu_constraint_type (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;
ALTER TABLE IF EXISTS citydb.scn2_scenario_parameter ADD CONSTRAINT scn2_scnpar_scn_lu_temp_agg_fk FOREIGN KEY (temp_aggregation) REFERENCES citydb.scn2_lu_temporal_aggregation (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;
ALTER TABLE IF EXISTS citydb.scn2_scenario_parameter ADD CONSTRAINT scn2_scnpar_scn_lu_agg_type_fk FOREIGN KEY (aggregation_type) REFERENCES citydb.scn2_lu_aggregation_type (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;


-- FOREIGN KEY constraint on Table SCN_RESOURCE
ALTER TABLE IF EXISTS citydb.scn2_resource ADD CONSTRAINT scn2_resource_objclass_fk FOREIGN KEY (objectclass_id) REFERENCES citydb.objectclass (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;
ALTER TABLE IF EXISTS citydb.scn2_resource ADD CONSTRAINT scn2_resource_scn_scen_fk FOREIGN KEY (scenario_id) REFERENCES citydb.scn2_scenario (id) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE IF EXISTS citydb.scn2_resource ADD CONSTRAINT scn2_resource_scn_operation_fk FOREIGN KEY (operation_id) REFERENCES citydb.scn2_operation (id) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;

-- FOREIGN KEY constraint on Table TIME_SERIES
ALTER TABLE IF EXISTS citydb.scn2_time_series ADD CONSTRAINT scn2_tseries_objclass_fk FOREIGN KEY (objectclass_id) REFERENCES citydb.objectclass (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;

ALTER TABLE IF EXISTS citydb.scn2_time_series ADD CONSTRAINT scn2_tseries_scn_lu_acq_method_fk FOREIGN KEY (acquisition_method) REFERENCES citydb.scn2_lu_acquisition_method (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;
ALTER TABLE IF EXISTS citydb.scn2_time_series ADD CONSTRAINT scn2_tseries_scn_lu_interp_fk FOREIGN KEY (interpolation_type) REFERENCES citydb.scn2_lu_interpolation (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;

-- FOREIGN KEY constraint on Table TIME_SERIES_FILE
ALTER TABLE IF EXISTS citydb.scn2_time_series_file ADD CONSTRAINT scn2_tseries_file_objclass_fk FOREIGN KEY (objectclass_id) REFERENCES citydb.objectclass (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;
ALTER TABLE IF EXISTS citydb.scn2_time_series_file ADD CONSTRAINT scn2_tseries_file_scn_tseries_fk FOREIGN KEY (id) REFERENCES citydb.scn2_time_series (id) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;



-- ***********************************************************************
-- ***********************************************************************

DO
$$
BEGIN
RAISE NOTICE '

********************************

Scenario ADE tables installation complete!

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

