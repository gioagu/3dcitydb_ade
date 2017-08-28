-- 3D City Database extension for the Energy ADE v. 0.8
--
--                     August 2017
--
-- 3D City Database: http://www.3dcitydb.org/ 
-- Energy ADE: https://github.com/cstb/citygml-energy
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
-- ********************* 03_Energy_ADE_TABLES.sql ************************
--
-- This script creates all Energy ADE tables in the citydb schema. 
-- All new tables are prefixed with "nrg8_".
-- At the end, the function citydb_pkg.set_ade_column_srid() is executed
-- to set the SRID of the newly added geometry columns.
--
-- ***********************************************************************
-- ***********************************************************************

----------------------------------------------------------------
-- Table LU_INTERPOLATION
----------------------------------------------------------------
DROP TABLE IF EXISTS citydb.nrg8_lu_interpolation CASCADE;
CREATE TABLE citydb.nrg8_lu_interpolation (
id varchar PRIMARY KEY,
name varchar,
name_codespace varchar,
description text
);
-- ALTER TABLE citydb.nrg8_lu_interpolation OWNER TO postgres;

CREATE INDEX nrg8_lu_interp_name_inx ON citydb.nrg8_lu_interpolation USING btree (name, name_codespace);

----------------------------------------------------------------
-- Table LU_ACQUISITION_METHOD
----------------------------------------------------------------
DROP TABLE IF EXISTS citydb.nrg8_lu_acquisition_method CASCADE;
CREATE TABLE citydb.nrg8_lu_acquisition_method (
id varchar PRIMARY KEY,
name varchar,
name_codespace varchar,
description text
);
-- ALTER TABLE citydb.nrg8_lu_acquisition_method OWNER TO postgres;

CREATE INDEX nrg8_lu_acq_method_name_inx ON citydb.nrg8_lu_acquisition_method USING btree (name, name_codespace);

----------------------------------------------------------------
-- Table LU_DAY
----------------------------------------------------------------
DROP TABLE IF EXISTS citydb.nrg8_lu_day CASCADE;
CREATE TABLE citydb.nrg8_lu_day (
id varchar PRIMARY KEY,
name varchar,
name_codespace varchar,
description text
);
-- ALTER TABLE citydb.nrg8_lu_xxxx OWNER TO postgres;

CREATE INDEX nrg8_lu_day_name_inx ON citydb.nrg8_lu_day USING btree (name, name_codespace);

----------------------------------------------------------------
-- Table LU_SURFACE_SIDE
----------------------------------------------------------------
DROP TABLE IF EXISTS citydb.nrg8_lu_surface_side CASCADE;
CREATE TABLE citydb.nrg8_lu_surface_side (
id varchar PRIMARY KEY,
name varchar,
name_codespace varchar,
description text
);
-- ALTER TABLE citydb.nrg8_lu_surface_side OWNER TO postgres;

CREATE INDEX nrg8_lu_surf_side_name_inx ON citydb.nrg8_lu_surface_side USING btree (name, name_codespace);

----------------------------------------------------------------
-- Table LU_WAWELENGTH_RANGE
----------------------------------------------------------------
DROP TABLE IF EXISTS citydb.nrg8_lu_wavelength_range CASCADE;
CREATE TABLE citydb.nrg8_lu_wavelength_range (
id varchar PRIMARY KEY,
name varchar,
name_codespace varchar,
description text
);
-- ALTER TABLE citydb.nrg8_lu_wavelength_range OWNER TO postgres;

CREATE INDEX nrg8_lu_wavelength_range_name_inx ON citydb.nrg8_lu_wavelength_range USING btree (name, name_codespace);

----------------------------------------------------------------
-- Table LU_DIMENSIONAL_ATTRIB
----------------------------------------------------------------
DROP TABLE IF EXISTS citydb.nrg8_lu_dimensional_attrib CASCADE;
CREATE TABLE citydb.nrg8_lu_dimensional_attrib (
id varchar PRIMARY KEY,
objectclass_id integer NOT NULL,
name varchar,
name_codespace varchar,
description text
);
-- ALTER TABLE citydb.nrg8_lu_dimensional_attrib OWNER TO postgres;

CREATE INDEX nrg8_lu_dim_attrib_objclass_id_fkx ON citydb.nrg8_lu_dimensional_attrib USING btree (objectclass_id);
CREATE INDEX nrg8_lu_dim_attrib_name_inx ON citydb.nrg8_lu_dimensional_attrib USING btree (name, name_codespace);

----------------------------------------------------------------
-- Table LU_REFURBISHMENT_CLASS
----------------------------------------------------------------
DROP TABLE IF EXISTS citydb.nrg8_lu_refurbishment_class CASCADE;
CREATE TABLE citydb.nrg8_lu_refurbishment_class (
id varchar PRIMARY KEY,
name varchar,
name_codespace varchar,
description text
);
-- ALTER TABLE citydb.nrg8_lu_refurbishment_class OWNER TO postgres;

CREATE INDEX nrg8_lu_ref_class_name_inx ON citydb.nrg8_lu_refurbishment_class USING btree (name, name_codespace);

----------------------------------------------------------------
-- Table LU_CONSTRUCTION_WEIGHT
----------------------------------------------------------------
DROP TABLE IF EXISTS citydb.nrg8_lu_construction_weight CASCADE;
CREATE TABLE citydb.nrg8_lu_construction_weight (
id varchar PRIMARY KEY,
name varchar,
name_codespace varchar,
description text
);
-- ALTER TABLE citydb.nrg8_lu_construction_weight OWNER TO postgres;

CREATE INDEX nrg8_lu_constr_weight_name_inx ON citydb.nrg8_lu_construction_weight USING btree (name, name_codespace);


----------------------------------------------------------------
-- Table LU_WEATHER_DATA
----------------------------------------------------------------
DROP TABLE IF EXISTS citydb.nrg8_lu_weather_data CASCADE;
CREATE TABLE citydb.nrg8_lu_weather_data (
id varchar PRIMARY KEY,
name varchar,
name_codespace varchar,
description text
);
-- ALTER TABLE citydb.nrg8_lu_weather_data OWNER TO postgres;

CREATE INDEX nrg8_lu_weather_data_name_inx ON citydb.nrg8_lu_weather_data USING btree (name, name_codespace);


----------------------------------------------------------------
-- Table LU_THERMAL_BOUNDARY
----------------------------------------------------------------
DROP TABLE IF EXISTS citydb.nrg8_lu_thermal_boundary CASCADE;
CREATE TABLE citydb.nrg8_lu_thermal_boundary (
id varchar PRIMARY KEY,
name varchar,
name_codespace varchar,
description text
);
-- ALTER TABLE citydb.nrg8_lu_thermal_boundary OWNER TO postgres;

CREATE INDEX nrg8_lu_ther_bdry_name_inx ON citydb.nrg8_lu_thermal_boundary USING btree (name, name_codespace);

----------------------------------------------------------------
-- Table LU_HOUSEHOLD
----------------------------------------------------------------
DROP TABLE IF EXISTS citydb.nrg8_lu_household CASCADE;
CREATE TABLE citydb.nrg8_lu_household (
id varchar PRIMARY KEY,
name varchar,
name_codespace varchar,
description text
);
-- ALTER TABLE citydb.nrg8_lu_household OWNER TO postgres;

CREATE INDEX nrg8_lu_household_name_inx ON citydb.nrg8_lu_household USING btree (name, name_codespace);

----------------------------------------------------------------
-- Table LU_OCCUPANTS
----------------------------------------------------------------
DROP TABLE IF EXISTS citydb.nrg8_lu_occupants CASCADE;
CREATE TABLE citydb.nrg8_lu_occupants (
id varchar PRIMARY KEY,
name varchar,
name_codespace varchar,
description text
);
-- ALTER TABLE citydb.nrg8_lu_occupants OWNER TO postgres;

CREATE INDEX nrg8_lu_occupants_name_inx ON citydb.nrg8_lu_occupants USING btree (name, name_codespace);

----------------------------------------------------------------
-- Table LU_OWNERSHIP
----------------------------------------------------------------
DROP TABLE IF EXISTS citydb.nrg8_lu_ownership CASCADE;
CREATE TABLE citydb.nrg8_lu_ownership (
id varchar PRIMARY KEY,
name varchar,
name_codespace varchar,
description text
);
-- ALTER TABLE citydb.nrg8_lu_xxxx OWNER TO postgres;

CREATE INDEX nrg8_lu_ownership_name_inx ON citydb.nrg8_lu_ownership USING btree (name, name_codespace);

----------------------------------------------------------------
-- Table LU_RESIDENCE
----------------------------------------------------------------
DROP TABLE IF EXISTS citydb.nrg8_lu_residence CASCADE;
CREATE TABLE citydb.nrg8_lu_residence (
id varchar PRIMARY KEY,
name varchar,
name_codespace varchar,
description text
);
-- ALTER TABLE citydb.nrg8_lu_residence OWNER TO postgres;

CREATE INDEX nrg8_lu_residence_name_inx ON citydb.nrg8_lu_residence USING btree (name, name_codespace);

----------------------------------------------------------------
-- Table LU_END_USE
----------------------------------------------------------------
DROP TABLE IF EXISTS citydb.nrg8_lu_end_use CASCADE;
CREATE TABLE citydb.nrg8_lu_end_use (
id varchar PRIMARY KEY,
name varchar,
name_codespace varchar,
description text
);
-- ALTER TABLE citydb.nrg8_lu_end_use OWNER TO postgres;

CREATE INDEX nrg8_lu_end_use_name_inx ON citydb.nrg8_lu_end_use USING btree (name, name_codespace);

----------------------------------------------------------------
-- Table LU_DISTRIBUTION
----------------------------------------------------------------
DROP TABLE IF EXISTS citydb.nrg8_lu_distribution CASCADE;
CREATE TABLE citydb.nrg8_lu_distribution (
id varchar PRIMARY KEY,
name varchar,
name_codespace varchar,
description text
);
-- ALTER TABLE citydb.nrg8_lu_distribution OWNER TO postgres;

CREATE INDEX nrg8_lu_distribution_name_inx ON citydb.nrg8_lu_distribution USING btree (name, name_codespace);

----------------------------------------------------------------
-- Table LU_MEDIUM
----------------------------------------------------------------
DROP TABLE IF EXISTS citydb.nrg8_lu_medium CASCADE;
CREATE TABLE citydb.nrg8_lu_medium (
id varchar PRIMARY KEY,
name varchar,
name_codespace varchar,
description text
);
-- ALTER TABLE citydb.nrg8_lu_medium OWNER TO postgres;

CREATE INDEX nrg8_lu_medium_name_inx ON citydb.nrg8_lu_medium USING btree (name, name_codespace);

----------------------------------------------------------------
-- Table LU_HEAT_SOURCE
----------------------------------------------------------------
DROP TABLE IF EXISTS citydb.nrg8_lu_heat_source CASCADE;
CREATE TABLE citydb.nrg8_lu_heat_source (
id varchar PRIMARY KEY,
name varchar,
name_codespace varchar,
description text
);
-- ALTER TABLE citydb.nrg8_lu_heat_source OWNER TO postgres;

CREATE INDEX nrg8_lu_heat_source_name_inx ON citydb.nrg8_lu_heat_source USING btree (name, name_codespace);

----------------------------------------------------------------
-- Table LU_CELL
----------------------------------------------------------------
DROP TABLE IF EXISTS citydb.nrg8_lu_cell CASCADE;
CREATE TABLE citydb.nrg8_lu_cell (
id varchar PRIMARY KEY,
name varchar,
name_codespace varchar,
description text
);
-- ALTER TABLE citydb.nrg8_lu_cell OWNER TO postgres;

CREATE INDEX nrg8_lu_cell_name_inx ON citydb.nrg8_lu_cell USING btree (name, name_codespace);

----------------------------------------------------------------
-- Table LU_COLLECTOR
----------------------------------------------------------------
DROP TABLE IF EXISTS citydb.nrg8_lu_collector CASCADE;
CREATE TABLE citydb.nrg8_lu_collector (
id varchar PRIMARY KEY,
name varchar,
name_codespace varchar,
description text
);
-- ALTER TABLE citydb.nrg8_lu_collector OWNER TO postgres;

CREATE INDEX nrg8_lu_collector_name_inx ON citydb.nrg8_lu_collector USING btree (name, name_codespace);

----------------------------------------------------------------
-- Table LU_EMITTER
----------------------------------------------------------------
DROP TABLE IF EXISTS citydb.nrg8_lu_emitter CASCADE;
CREATE TABLE citydb.nrg8_lu_emitter (
id varchar PRIMARY KEY,
name varchar,
name_codespace varchar,
description text
);
-- ALTER TABLE citydb.nrg8_lu_emitter OWNER TO postgres;

CREATE INDEX nrg8_lu_emitter_name_inx ON citydb.nrg8_lu_emitter USING btree (name, name_codespace);

----------------------------------------------------------------
-- Table LU_COMPRESSOR
----------------------------------------------------------------
DROP TABLE IF EXISTS citydb.nrg8_lu_compressor CASCADE;
CREATE TABLE citydb.nrg8_lu_compressor (
id varchar PRIMARY KEY,
name varchar,
name_codespace varchar,
description text
);
-- ALTER TABLE citydb.nrg8_lu_compressor OWNER TO postgres;

CREATE INDEX nrg8_lu_compressor_name_inx ON citydb.nrg8_lu_compressor USING btree (name, name_codespace);

----------------------------------------------------------------
-- Table LU_CONDENSATION
----------------------------------------------------------------
DROP TABLE IF EXISTS citydb.nrg8_lu_condensation CASCADE;
CREATE TABLE citydb.nrg8_lu_condensation (
id varchar PRIMARY KEY,
name varchar,
name_codespace varchar,
description text
);
-- ALTER TABLE citydb.nrg8_lu_condensation OWNER TO postgres;

CREATE INDEX nrg8_lu_condensation_name_inx ON citydb.nrg8_lu_condensation USING btree (name, name_codespace);

----------------------------------------------------------------
-- Table LU_ENERGY_SOURCE
----------------------------------------------------------------
DROP TABLE IF EXISTS citydb.nrg8_lu_energy_source CASCADE;
CREATE TABLE citydb.nrg8_lu_energy_source (
id varchar PRIMARY KEY,
name varchar,
name_codespace varchar,
description text
);
-- ALTER TABLE citydb.nrg8_lu_energy_source OWNER TO postgres;

CREATE INDEX nrg8_lu_nrg_source_name_inx ON citydb.nrg8_lu_energy_source USING btree (name, name_codespace);

----------------------------------------------------------------
-- Table TIME_SERIES
----------------------------------------------------------------
DROP TABLE IF EXISTS citydb.nrg8_time_series CASCADE;
CREATE TABLE citydb.nrg8_time_series (
	id serial PRIMARY KEY,
	objectclass_id integer NOT NULL, -- This is a foreign key to objectclass.id
	gmlid varchar,
	gmlid_codespace varchar,
	name varchar,
	name_codespace varchar,
	description text,
	acquisition_method varchar NOT NULL,  -- This is a foreign key to lu_acquisition_method.id
	interpolation_type varchar NOT NULL,  -- This is a foreign key to lu_interpolation.id
	quality_description text,
	source varchar,
	time_array timestamp(0) with time zone[], 
	values_array numeric[],
	values_unit varchar NOT NULL,
	array_length integer,
	temporal_extent_begin timestamp(0) with time zone,
	temporal_extent_end timestamp(0) with time zone,
	time_interval numeric,
	time_interval_unit varchar
);
-- ALTER TABLE citydb.nrg8_time_series OWNER TO postgres;

CREATE INDEX nrg8_tseries_gmlid_inx ON citydb.nrg8_time_series USING btree (gmlid, gmlid_codespace);
CREATE INDEX nrg8_tseries_objclass_id_fkx ON citydb.nrg8_time_series USING btree (objectclass_id);
CREATE INDEX nrg8_tseries_acq_method_fkx ON citydb.nrg8_time_series USING btree (acquisition_method);
CREATE INDEX nrg8_tseries_interp_type_fkx ON citydb.nrg8_time_series USING btree (interpolation_type);

COMMENT ON COLUMN citydb.nrg8_time_series.objectclass_id IS 'Objectclass ID of the time series';
COMMENT ON COLUMN citydb.nrg8_time_series.acquisition_method IS 'Acquisition method';
COMMENT ON COLUMN citydb.nrg8_time_series.interpolation_type IS 'Interpolation type';
COMMENT ON COLUMN citydb.nrg8_time_series.quality_description IS 'Quality description';
COMMENT ON COLUMN citydb.nrg8_time_series.source IS 'Source';
COMMENT ON COLUMN citydb.nrg8_time_series.time_array IS 'Vector of timestamp values (to be used for irregular TimeSeries)';
COMMENT ON COLUMN citydb.nrg8_time_series.values_array IS 'Vector of values';
COMMENT ON COLUMN citydb.nrg8_time_series.values_unit IS 'Units of measure of values';
COMMENT ON COLUMN citydb.nrg8_time_series.array_length IS 'Number of values in the vector';
COMMENT ON COLUMN citydb.nrg8_time_series.temporal_extent_begin IS 'Begin of temporal extent';
COMMENT ON COLUMN citydb.nrg8_time_series.temporal_extent_end IS 'End of temporal extent';
COMMENT ON COLUMN citydb.nrg8_time_series.time_interval IS 'Time interval';
COMMENT ON COLUMN citydb.nrg8_time_series.time_interval_unit IS 'Time interval units of measure';

----------------------------------------------------------------
-- Table TIME_SERIES_FILE
----------------------------------------------------------------
DROP TABLE IF EXISTS citydb.nrg8_time_series_file CASCADE;
CREATE TABLE citydb.nrg8_time_series_file (
	id integer PRIMARY KEY,
	objectclass_id integer NOT NULL, -- This is a foreign key to objectclass.id
	file_path varchar,
	file_name varchar NOT NULL,
	file_extension varchar NOT NULL,
	nbr_header_lines integer,
	field_sep varchar,
	record_sep varchar,
	dec_symbol varchar,
	time_col_nbr integer,
	value_col_nbr integer,
	is_compressed numeric(1,0)
);
-- ALTER TABLE citydb.nrg8_time_series_file OWNER TO postgres;

CREATE INDEX nrg8_tseries_file_objclass_id_fkx ON citydb.nrg8_time_series_file USING btree (objectclass_id);

COMMENT ON COLUMN citydb.nrg8_time_series_file.file_path IS 'Path to the file containing the time series';
COMMENT ON COLUMN citydb.nrg8_time_series_file.file_name IS 'Name of the file containing the time series';
COMMENT ON COLUMN citydb.nrg8_time_series_file.file_extension IS 'Extension of the file containing the time series';
COMMENT ON COLUMN citydb.nrg8_time_series_file.nbr_header_lines IS 'Number of header lines';
COMMENT ON COLUMN citydb.nrg8_time_series_file.field_sep IS 'Field separator';
COMMENT ON COLUMN citydb.nrg8_time_series_file.record_sep IS 'Record separator';
COMMENT ON COLUMN citydb.nrg8_time_series_file.dec_symbol IS 'Decimal separator symbol (e.g. "." or ",")';
COMMENT ON COLUMN citydb.nrg8_time_series_file.time_col_nbr IS 'Column number containing timestamps';
COMMENT ON COLUMN citydb.nrg8_time_series_file.value_col_nbr IS 'Column number containing values';
COMMENT ON COLUMN citydb.nrg8_time_series_file.is_compressed IS '(Optional) Is the file compressed, e.g. zipped?';

----------------------------------------------------------------
-- Table SCHEDULE
----------------------------------------------------------------
DROP TABLE IF EXISTS citydb.nrg8_schedule CASCADE;
CREATE TABLE citydb.nrg8_schedule (
	id serial PRIMARY KEY,
	objectclass_id integer NOT NULL, 	-- This is a foreign key to objectclass.id
	gmlid varchar,
	gmlid_codespace varchar,
	name varchar,
	name_codespace varchar,
  description text,	
	value1 numeric,
	value1_unit varchar,
	value2 numeric,
	value2_unit varchar,
	hours_per_day numeric CHECK (hours_per_day BETWEEN 0 AND 24),
	days_per_year numeric CHECK (days_per_year BETWEEN 0 AND 366),
	time_series_id integer 							-- This is a foreign key to time_series.id
);
-- ALTER TABLE citydb.nrg8_schedule OWNER TO postgres;

CREATE INDEX nrg8_sched_gmlid_inx ON citydb.nrg8_schedule USING btree (gmlid, gmlid_codespace);
CREATE INDEX nrg8_sched_objclass_id_fkx ON citydb.nrg8_schedule USING btree (objectclass_id);
CREATE INDEX nrg8_sched_tseries_id_fkx ON citydb.nrg8_schedule USING btree (time_series_id);

COMMENT ON COLUMN citydb.nrg8_schedule.objectclass_id IS 'Objectclass ID of the schedule';
COMMENT ON COLUMN citydb.nrg8_schedule.value1 IS 'Average value (SingleValueSchedule) or Idle value (DualValueSchedule)';
COMMENT ON COLUMN citydb.nrg8_schedule.value1_unit IS 'Value unit of measure';
COMMENT ON COLUMN citydb.nrg8_schedule.value2 IS 'Usage value (DualValueSchedule)';
COMMENT ON COLUMN citydb.nrg8_schedule.value2_unit IS 'Value unit of measure';
COMMENT ON COLUMN citydb.nrg8_schedule.hours_per_day IS 'Usage hours per day, value in [0,24]';
COMMENT ON COLUMN citydb.nrg8_schedule.days_per_year IS 'Usage days per year, value in [0,366]';

----------------------------------------------------------------
-- Table PERIOD_OF_YEAR
----------------------------------------------------------------
DROP TABLE IF EXISTS citydb.nrg8_period_of_year CASCADE;
CREATE TABLE citydb.nrg8_period_of_year (
	id serial PRIMARY KEY,
--	objectclass_id integer NOT NULL,	-- This is a foreign key to objectclass.id
--	gmlid varchar,
--	gmlid_codespace varchar,
--	name varchar,
--	name_codespace varchar,
	begin_time time(0) DEFAULT '00:00:00'::time(0) CHECK (begin_time BETWEEN '00:00:00'::time(0) AND '23:59:59'::time(0)),
	begin_day integer NOT NULL CHECK (begin_day BETWEEN 1 AND 31),
	begin_month integer NOT NULL CHECK (begin_month BETWEEN 1 AND 12),
	end_time time(0) DEFAULT '23:59:59'::time(0) CHECK (end_time BETWEEN '00:00:00'::time(0) AND '23:59:59'::time(0)),
	end_day integer NOT NULL CHECK (end_day BETWEEN 1 AND 31),
	end_month integer NOT NULL CHECK (end_month BETWEEN 1 AND 12),
	sched_id integer	-- This is a foreign key to schedule.id
);
-- ALTER TABLE citydb.nrg8_period_of_year OWNER TO postgres;

--CREATE INDEX nrg8_period_of_year_objclass_id_fkx ON citydb.nrg8_period_of_year USING btree (objectclass_id);
--CREATE INDEX nrg8_period_of_year_gmlid_inx ON citydb.nrg8_period_of_year USING btree (gmlid, gmlid_codespace);
CREATE INDEX nrg8_period_of_year_sched_id_fkx ON citydb.nrg8_period_of_year USING btree (sched_id);

--COMMENT ON COLUMN citydb.nrg8_period_of_year.objectclass_id IS 'Objectclass ID of the period of year';
COMMENT ON COLUMN citydb.nrg8_period_of_year.begin_time IS 'Start time of period of year (default: 00:00:00)';
COMMENT ON COLUMN citydb.nrg8_period_of_year.begin_day IS 'First day of period of year, in [1..31]';
COMMENT ON COLUMN citydb.nrg8_period_of_year.begin_month IS 'First month of period of year, in [1..12]';
COMMENT ON COLUMN citydb.nrg8_period_of_year.end_time IS 'Finish time of period of year (default: 23:59:59)';
COMMENT ON COLUMN citydb.nrg8_period_of_year.end_day IS 'Last day of period of year, in [1..31]';
COMMENT ON COLUMN citydb.nrg8_period_of_year.end_month IS 'Last month of period of year, in [1..12]';

----------------------------------------------------------------
-- Table DAILY_SCHEDULE
----------------------------------------------------------------
DROP TABLE IF EXISTS citydb.nrg8_daily_schedule CASCADE;
CREATE TABLE citydb.nrg8_daily_schedule (
	id serial PRIMARY KEY,
	day_type varchar,                   -- This is a foreign key to lu_day.id
	period_of_year_id integer,	        -- This is a foreign key to period_of_year.id
	time_series_id integer	-- This is a foreign key to time_series.id
);
-- ALTER TABLE citydb.nrg8_daily_schedule OWNER TO postgres;

CREATE INDEX nrg8_daily_sched_day_type_fkx ON citydb.nrg8_daily_schedule USING btree (day_type);
CREATE INDEX nrg8_daily_sched_period_of_year_id_fkx ON citydb.nrg8_daily_schedule USING btree (period_of_year_id);
CREATE INDEX nrg8_daily_sched_tseries_id_fkx ON citydb.nrg8_daily_schedule USING btree (time_series_id);

COMMENT ON COLUMN citydb.nrg8_daily_schedule.day_type IS 'Type of day';

--------------------
-- Table CONSTRUCTION
--------------------
DROP TABLE IF EXISTS citydb.nrg8_construction CASCADE;
CREATE TABLE citydb.nrg8_construction (
	id serial PRIMARY KEY,
	objectclass_id integer NOT NULL, -- This is a foreign key to objectclass.id
	gmlid varchar,
	gmlid_codespace varchar,
	name varchar,
	name_codespace varchar,
	description text,
	u_value numeric,
	u_value_unit varchar,
	glazing_ratio numeric CHECK (glazing_ratio BETWEEN 0 AND 1),
	start_of_life date,
	life_expect_value numeric,
	life_expect_value_unit varchar,
	main_maint_interval numeric,
	main_maint_interval_unit varchar,
	base_constr_id integer -- references nrg8_construction.id ON UPDATE CASCADE ON DELETE CASCADE, 
);
-- ALTER TABLE citydb.nrg8_construction OWNER TO postgres;

CREATE INDEX nrg8_constr_objclass_id_fkx ON citydb.nrg8_construction USING btree (objectclass_id);
CREATE INDEX nrg8_constr_gmlid_inx ON citydb.nrg8_construction USING btree (gmlid, gmlid_codespace);
CREATE INDEX nrg8_constr_base_constr_id_fkx ON citydb.nrg8_construction USING btree (base_constr_id);

COMMENT ON COLUMN citydb.nrg8_construction.objectclass_id IS 'Objectclass ID of the construction';
COMMENT ON COLUMN citydb.nrg8_construction.u_value IS 'U-value (Thermal transmittance)';
COMMENT ON COLUMN citydb.nrg8_construction.u_value_unit IS 'U-value units of measure';
COMMENT ON COLUMN citydb.nrg8_construction.glazing_ratio IS 'Glazing ratio of windows, value in [0,1]';
COMMENT ON COLUMN citydb.nrg8_construction.start_of_life IS 'Service life: Date of start of service';
COMMENT ON COLUMN citydb.nrg8_construction.life_expect_value IS 'Service life: Life expectancy';
COMMENT ON COLUMN citydb.nrg8_construction.life_expect_value_unit IS 'Life expectancy units of measure';
COMMENT ON COLUMN citydb.nrg8_construction.main_maint_interval IS 'Service life: Main maintenance time interval';
COMMENT ON COLUMN citydb.nrg8_construction.main_maint_interval_unit IS 'Time interval units of measure';

--------------------
-- Table CITYOBJECT_TO_CONSTRUCTION
--------------------
DROP TABLE IF EXISTS citydb.nrg8_cityobject_to_constr CASCADE;
CREATE TABLE citydb.nrg8_cityobject_to_constr (
	cityobject_id integer NOT NULL,
	constr_id integer NOT NULL,
	CONSTRAINT nrg8_ctyobj_to_constr_pk PRIMARY KEY (cityobject_id, constr_id)
);

CREATE INDEX nrg8_cto_to_constr_cto_id_fkx ON citydb.nrg8_cityobject_to_constr USING btree (cityobject_id);
CREATE INDEX nrg8_cto_to_constr_constr_id_fkx ON citydb.nrg8_cityobject_to_constr USING btree (constr_id);

------------------
--- Table OPTICAL_PROPERTY
------------------
DROP TABLE IF EXISTS citydb.nrg8_optical_property CASCADE;
CREATE TABLE IF NOT EXISTS citydb.nrg8_optical_property (
	id serial PRIMARY KEY,
	objectclass_id integer NOT NULL, -- This is a foreign key to objectclass.id
	fraction numeric NOT NULL CHECK (fraction BETWEEN 0 AND 1),
	range varchar,      -- This is a foreign key to lu_wavelength_range.id
	surf_side varchar,  -- This is a foreign key to lu_surface_side.id
	constr_id integer	-- This is a Foreign Key to construction.id
);
-- ALTER TABLE citydb.nrg8_optical_property OWNER TO postgres;

CREATE INDEX nrg8_opt_prop_objclass_id_fkx ON citydb.nrg8_optical_property USING btree (objectclass_id);
CREATE INDEX nrg8_opt_prop_range_fkx ON citydb.nrg8_optical_property USING btree (range);
CREATE INDEX nrg8_opt_prop_surf_side_fkx ON citydb.nrg8_optical_property USING btree (surf_side);
CREATE INDEX nrg8_opt_prop_constr_id_fkx ON citydb.nrg8_optical_property USING btree (constr_id);

COMMENT ON COLUMN citydb.nrg8_optical_property.objectclass_id IS 'Objectclass ID of the optical property';
COMMENT ON COLUMN citydb.nrg8_optical_property.fraction IS 'Value in [0,1]';
COMMENT ON COLUMN citydb.nrg8_optical_property.range IS 'Wavelangth range (Solar, Infrared, Visible, Total)';
COMMENT ON COLUMN citydb.nrg8_optical_property.surf_side IS 'Surface side (Inside, Outside)';

------------------
--- Table LAYER
------------------
DROP TABLE IF EXISTS citydb.nrg8_layer CASCADE;
CREATE TABLE IF NOT EXISTS citydb.nrg8_layer (
	id serial PRIMARY KEY,
	objectclass_id integer NOT NULL,	-- This is a foreign key to objectclass.id
	gmlid varchar,
	gmlid_codespace varchar,
	name varchar,
	name_codespace varchar,
	description text,
	pos_nbr integer NOT NULL CHECK (pos_nbr > 0),
	constr_id integer	-- This is a foreign key to construction.id
);
-- ALTER TABLE citydb.nrg8_layer OWNER TO postgres;

CREATE INDEX nrg8_layer_objclass_id_fkx ON citydb.nrg8_layer USING btree (objectclass_id);
CREATE INDEX nrg8_layer_gmlid_inx ON citydb.nrg8_layer USING btree (gmlid, gmlid_codespace);
CREATE INDEX nrg8_layer_pos_nbr_inx ON citydb.nrg8_layer USING btree (pos_nbr);
CREATE INDEX nrg8_layer_constr_id_fkx ON citydb.nrg8_layer USING btree (constr_id);

COMMENT ON COLUMN citydb.nrg8_layer.objectclass_id IS 'Objectclass ID of the layer';
COMMENT ON COLUMN citydb.nrg8_layer.pos_nbr IS 'Order position of the layer in the construction set';

------------------
--- Table LAYER_COMPONENT
------------------
DROP TABLE IF EXISTS citydb.nrg8_layer_component CASCADE;
CREATE TABLE IF NOT EXISTS citydb.nrg8_layer_component (
	id serial PRIMARY KEY,
	objectclass_id integer NOT NULL,	-- This is a foreign key to objectclass.id
	gmlid varchar,
	gmlid_codespace varchar,
	name varchar,
	name_codespace varchar,
	description text,
	area_fr numeric DEFAULT 1.0 CHECK (area_fr BETWEEN 0 AND 1),
	thickness numeric,
	thickness_unit varchar,
	start_of_life date,
	life_expect_value numeric,
	life_expect_value_unit varchar,
	main_maint_interval numeric,
	main_maint_interval_unit varchar,
	layer_id integer	-- This is a foreign key to layer.id
);
-- ALTER TABLE citydb.nrg8_layer_component OWNER TO postgres;

CREATE INDEX nrg8_layer_comp_objclass_id_fkx ON citydb.nrg8_layer_component USING btree (objectclass_id);
CREATE INDEX nrg8_layer_comp_gmlid_inx ON citydb.nrg8_layer_component USING btree (gmlid, gmlid_codespace);
CREATE INDEX nrg8_layer_comp_layer_id_fkx ON citydb.nrg8_layer_component USING btree (layer_id);

COMMENT ON COLUMN citydb.nrg8_layer_component.objectclass_id IS 'Objectclass ID of the layer component';
COMMENT ON COLUMN citydb.nrg8_layer_component.area_fr IS 'Area fraction, value in [0,1]';
COMMENT ON COLUMN citydb.nrg8_layer_component.thickness IS 'Thickness';
COMMENT ON COLUMN citydb.nrg8_layer_component.thickness_unit IS 'Thickness units of measure';
COMMENT ON COLUMN citydb.nrg8_layer_component.start_of_life IS 'Service life: Date of start of service';
COMMENT ON COLUMN citydb.nrg8_layer_component.life_expect_value IS 'Service life: Life expectancy';
COMMENT ON COLUMN citydb.nrg8_layer_component.life_expect_value_unit IS 'Life expectancy units of measure';
COMMENT ON COLUMN citydb.nrg8_layer_component.main_maint_interval IS 'Service life: Main maintenance time interval';
COMMENT ON COLUMN citydb.nrg8_layer_component.main_maint_interval_unit IS 'Time interval units of measure';

------------------
--- Table MATERIAL
------------------
DROP TABLE IF EXISTS citydb.nrg8_material CASCADE;
CREATE TABLE IF NOT EXISTS citydb.nrg8_material (
id serial PRIMARY KEY,
objectclass_id integer NOT NULL,	-- This is a foreign key to objectclass.id
gmlid varchar,
gmlid_codespace varchar,
name varchar,
name_codespace varchar,
description text,
is_ventilated numeric(1,0) DEFAULT 0,
r_value numeric,
r_value_unit varchar,
density numeric,
density_unit varchar,
specific_heat numeric,
specific_heat_unit varchar,
conductivity numeric,
conductivity_unit varchar,
permeance numeric,
permeance_unit varchar,
porosity numeric CHECK (porosity BETWEEN 0 AND 1),
embodied_carbon numeric,
embodied_carbon_unit varchar,
embodied_nrg numeric,
embodied_nrg_unit varchar,
layer_component_id integer	-- This is a foreign key to layer_component.id
);
-- ALTER TABLE citydb.nrg8_material OWNER TO postgres;

CREATE INDEX nrg8_material_objclass_id_fkx ON citydb.nrg8_material USING btree (objectclass_id);
CREATE INDEX nrg8_material_gmlid_inx ON citydb.nrg8_material USING btree (gmlid, gmlid_codespace);
CREATE INDEX nrg8_material_layer_component_id_fkx ON citydb.nrg8_material USING btree (layer_component_id);

COMMENT ON COLUMN citydb.nrg8_material.objectclass_id IS 'Objectclass ID of the material';
COMMENT ON COLUMN citydb.nrg8_material.r_value IS 'R value (gas constant)';
COMMENT ON COLUMN citydb.nrg8_material.r_value_unit IS 'R value units of measure';
COMMENT ON COLUMN citydb.nrg8_material.density IS 'Density';
COMMENT ON COLUMN citydb.nrg8_material.density_unit IS 'Density units of measure';
COMMENT ON COLUMN citydb.nrg8_material.specific_heat IS 'Specific heat';
COMMENT ON COLUMN citydb.nrg8_material.specific_heat_unit IS 'Specific heat units of measure';
COMMENT ON COLUMN citydb.nrg8_material.conductivity IS 'Conductivity';
COMMENT ON COLUMN citydb.nrg8_material.conductivity_unit IS 'Conductivity units of measure';
COMMENT ON COLUMN citydb.nrg8_material.permeance IS 'Permeance';
COMMENT ON COLUMN citydb.nrg8_material.permeance_unit IS 'Permeance units of measure';
COMMENT ON COLUMN citydb.nrg8_material.porosity IS 'Ratio of porosity, value in [0,1]';
COMMENT ON COLUMN citydb.nrg8_material.embodied_carbon IS 'Embodied carbon';
COMMENT ON COLUMN citydb.nrg8_material.embodied_carbon_unit IS 'Embodied carbon units of measure';
COMMENT ON COLUMN citydb.nrg8_material.embodied_nrg IS 'Embodied energy';
COMMENT ON COLUMN citydb.nrg8_material.embodied_nrg_unit IS 'Embodied energy units of measure';

--------------------
-- Table DIMENSINAL ATTRIB (length, area, volume)
--------------------
DROP TABLE IF EXISTS citydb.nrg8_dimensional_attrib CASCADE;
CREATE TABLE citydb.nrg8_dimensional_attrib (
	id serial PRIMARY KEY,
	objectclass_id integer NOT NULL,	-- This is a foreign key to objectclass.id	
	type varchar,	                    -- This is a foreign key to lu_dimensional_attrib.id
	value numeric,
	value_unit varchar,
	cityobject_id integer	-- This is a foreign key to cityobject.id
);
-- ALTER TABLE citydb.nrg8_dimensional_attrib OWNER TO postgres;

CREATE INDEX nrg8_dim_attrib_objclass_id_fkx ON citydb.nrg8_dimensional_attrib USING btree (objectclass_id);
CREATE INDEX nrg8_dim_attrib_type_fkx ON citydb.nrg8_dimensional_attrib USING btree (type);
CREATE INDEX nrg8_dim_attrib_ctyobj_id_fkx ON citydb.nrg8_dimensional_attrib USING btree (cityobject_id);

COMMENT ON COLUMN citydb.nrg8_dimensional_attrib.objectclass_id IS 'Objectclass ID of the dimensional attribute';
COMMENT ON COLUMN citydb.nrg8_dimensional_attrib.type           IS 'Type of the dimensional value';
COMMENT ON COLUMN citydb.nrg8_dimensional_attrib.value          IS 'Numerical value of the dimensional attribute';
COMMENT ON COLUMN citydb.nrg8_dimensional_attrib.value_unit     IS 'Unit of measure of the value';
COMMENT ON COLUMN citydb.nrg8_dimensional_attrib.cityobject_id  IS 'ID of the cityobject';

--------------------
-- Table ENERGY_PERF_CERTIFICATION
--------------------
DROP TABLE IF EXISTS citydb.nrg8_perf_certification CASCADE;
CREATE TABLE citydb.nrg8_perf_certification (
	id                serial PRIMARY KEY,
	name              varchar,
	rating            varchar,
	certification_id  varchar,
	building_id       integer,	-- This is a foreign key to nrg8_building.id
	building_unit_id  integer	-- This is a foreign key to nrg8_building_unit.id
);
-- ALTER TABLE citydb.nrg8_perf_certification OWNER TO postgres;

CREATE INDEX nrg8_perf_cert_bdg_id_fkx ON citydb.nrg8_perf_certification USING btree (building_id);
CREATE INDEX nrg8_perf_cert_bdg_unit_fkx ON citydb.nrg8_perf_certification USING btree (building_unit_id);

COMMENT ON COLUMN citydb.nrg8_perf_certification.name             IS 'Name of the performance certificate';
COMMENT ON COLUMN citydb.nrg8_perf_certification.rating           IS 'Rating of the performance certificate';
COMMENT ON COLUMN citydb.nrg8_perf_certification.certification_id IS 'ID/Reference number/code of the performance certificate';

--------------------
-- Table REFURBISHMENT_MEASURE
--------------------
DROP TABLE IF EXISTS citydb.nrg8_refurbishment_measure CASCADE;
CREATE TABLE citydb.nrg8_refurbishment_measure (
	id serial PRIMARY KEY,
	description text,
	level varchar,    			-- This is a foreign key to lu_refurbishment_class.id
	instant_date date,
	begin_date date,
	end_date date,
	building_id integer,		-- This is a foreign key to nrg8_building.id
	therm_boundary_id integer 	-- This is a foreign key to thermal_boundary.id
);
-- ALTER TABLE citydb.nrg8_refurbishment_measure OWNER TO postgres;

CREATE INDEX nrg8_ref_meas_level_fkx ON citydb.nrg8_refurbishment_measure USING btree (level);
CREATE INDEX nrg8_ref_meas_bdg_id_fkx ON citydb.nrg8_refurbishment_measure USING btree (building_id);
CREATE INDEX nrg8_ref_meas_therm_bdry_id_fkx ON citydb.nrg8_refurbishment_measure USING btree (therm_boundary_id);

COMMENT ON COLUMN citydb.nrg8_refurbishment_measure.instant_date IS 'Date of the refurbishment measure';
COMMENT ON COLUMN citydb.nrg8_refurbishment_measure.begin_date   IS 'Initial date of the refurbishment measure';
COMMENT ON COLUMN citydb.nrg8_refurbishment_measure.end_date     IS 'Final date of the refurbishment measure';

--------------------
-- Table WEATHER_STATION
--------------------
DROP TABLE IF EXISTS citydb.nrg8_weather_station CASCADE;
CREATE TABLE citydb.nrg8_weather_station (
	id integer PRIMARY KEY,
	objectclass_id integer NOT NULL, -- This is a foreign key to objectclass.id
	cityobject_id integer, -- This is a foreign key to cityobject.id +installed_on
	install_point geometry(POINTZ)
);
-- ALTER TABLE citydb.nrg8_weather_station OWNER TO postgres;

CREATE INDEX nrg8_weather_station_objclass_id_fkx ON citydb.nrg8_weather_station USING btree (objectclass_id);
CREATE INDEX nrg8_weather_station_ctyobj_id_fkx ON citydb.nrg8_weather_station USING btree (cityobject_id);

COMMENT ON COLUMN citydb.nrg8_weather_station.objectclass_id IS 'Objectclass ID of the weather station';

--------------------
-- Table WEATHER_DATA
--------------------
DROP TABLE IF EXISTS citydb.nrg8_weather_data CASCADE;
CREATE TABLE citydb.nrg8_weather_data (
	id serial PRIMARY KEY,
	gmlid varchar,
	gmlid_codespace varchar,
	name varchar,
	name_codespace varchar,
	description text,	
	type varchar,						-- This is a foreign key to lu_weather_data.id
	time_series_id integer, 			-- This is a foreign key to time_series.id
	cityobject_id integer, 				-- This is a foreign key to cityobject.id
	install_point geometry(POINTZ)   
);
-- ALTER TABLE citydb.nrg8_weather_data OWNER TO postgres;

CREATE INDEX nrg8_weather_data_gmlid_inx ON citydb.nrg8_weather_data USING btree (gmlid, gmlid_codespace);
CREATE INDEX nrg8_weather_data_type_fkx ON citydb.nrg8_weather_data USING btree (type);
CREATE INDEX nrg8_weather_data_ts_id_fkx ON citydb.nrg8_weather_data USING btree (time_series_id);
CREATE INDEX nrg8_weather_data_ctyobj_id_fkx ON citydb.nrg8_weather_data USING btree (cityobject_id);

COMMENT ON COLUMN citydb.nrg8_weather_data.type IS 'Type of weather data';
COMMENT ON COLUMN citydb.nrg8_weather_data.cityobject_id IS 'implements +installedOn';

--------------------
-- Table nrg8_BUILDING
--------------------
DROP TABLE IF EXISTS citydb.nrg8_building CASCADE;
CREATE TABLE citydb.nrg8_building (
	id integer PRIMARY KEY,
	objectclass_id integer NOT NULL, 	-- This is a foreign key to objectclass.id
	type varchar,
	type_codespace varchar,
	constr_weight varchar,				-- This is a foreign key to lu_construction_weight.id
	is_landmarked numeric(1,0),
	ref_point geometry(POINTZ)
); 
-- ALTER TABLE citydb.nrg8_building OWNER TO postgres;

CREATE INDEX nrg8_bdg_id_fkx ON citydb.nrg8_building USING btree (id);
CREATE INDEX nrg8_bdg_objclass_id_fkx ON citydb.nrg8_building USING btree (objectclass_id);
CREATE INDEX nrg8_bdg_type_fkx ON citydb.nrg8_building USING btree (type);
CREATE INDEX nrg8_bdg_constr_weight_fkx ON citydb.nrg8_building USING btree (constr_weight);

COMMENT ON COLUMN citydb.nrg8_building.objectclass_id IS 'Objectclass ID of the building';
COMMENT ON COLUMN citydb.nrg8_building.type IS 'Building type';
COMMENT ON COLUMN citydb.nrg8_building.type_codespace IS 'Building type codespace';
COMMENT ON COLUMN citydb.nrg8_building.constr_weight IS 'Construction weight';
COMMENT ON COLUMN citydb.nrg8_building.is_landmarked IS 'Is the building protected as landmark?';
COMMENT ON COLUMN citydb.nrg8_building.ref_point IS 'Reference point';

--------------------
-- Table THERMAL_ZONE_TO_ROOM
--------------------
DROP TABLE IF EXISTS citydb.nrg8_thermal_zone_to_room CASCADE;
CREATE TABLE citydb.nrg8_thermal_zone_to_room (
	therm_zone_id integer NOT NULL, 	-- This is a foreign key to themal_zone.id
	room_id integer NOT NULL, 			-- This is a foreign key to room.id
	CONSTRAINT nrg8_thermal_zone_to_room_pk PRIMARY KEY (therm_zone_id, room_id)
);
-- ALTER TABLE citydb.nrg8_thermal_zone_to_room OWNER TO postgres;

CREATE INDEX nrg8_therm_zone_to_room_therm_zone_id_fkx ON citydb.nrg8_thermal_zone_to_room USING btree (therm_zone_id);
CREATE INDEX nrg8_therm_zone_to_room_room_id_fkx ON citydb.nrg8_thermal_zone_to_room USING btree (room_id);

--------------------
-- Table THERMAL_BOUNDARY_TO_THEMATIC_SURFACE
--------------------
DROP TABLE IF EXISTS citydb.nrg8_therm_bdry_to_them_surf CASCADE;
CREATE TABLE citydb.nrg8_therm_bdry_to_them_surf (
	therm_boundary_id integer NOT NULL, 			-- This is a foreign key to themal_boundary.id
	them_surf_id integer NOT NULL, 				-- This is a foreign key to them_surface.id
	CONSTRAINT nrg8_therm_bdry_to_them_surf_pk PRIMARY KEY (therm_boundary_id, them_surf_id)
);
-- ALTER TABLE citydb.nrg8_therm_bdry_to_them_surf OWNER TO postgres;

CREATE INDEX nrg8_therm_bdry_to_them_surf_therm_bdry_id_fkx ON citydb.nrg8_therm_bdry_to_them_surf USING btree (therm_boundary_id);
CREATE INDEX nrg8_therm_bdry_to_them_surf_them_surf_id_fkx ON citydb.nrg8_therm_bdry_to_them_surf USING btree (them_surf_id);

--------------------
-- Table THERMAL_OPENING_TO_OPENING
--------------------
DROP TABLE IF EXISTS citydb.nrg8_therm_open_to_open CASCADE;
CREATE TABLE citydb.nrg8_therm_open_to_open (
	therm_opening_id integer NOT NULL, 					-- This is a foreign key to themal_opening.id
	opening_id integer NOT NULL, 						-- This is a foreign key to opening.id
	CONSTRAINT nrg8_therm_open_to_open_pk PRIMARY KEY (therm_opening_id, opening_id)
);
-- ALTER TABLE citydb.nrg8_therm_open_to_open OWNER TO postgres;

CREATE INDEX nrg8_therm_open_to_open_therm_open_id_fkx ON citydb.nrg8_therm_open_to_open USING btree (therm_opening_id);
CREATE INDEX nrg8_therm_open_to_open_open_id_fkx ON citydb.nrg8_therm_open_to_open USING btree (opening_id);

--------------------
-- Table THERMAL_ZONE
--------------------
DROP TABLE IF EXISTS citydb.nrg8_thermal_zone CASCADE;
CREATE TABLE citydb.nrg8_thermal_zone (
	id integer PRIMARY KEY, 					-- This is a foreign key to cityobject.id
	objectclass_id integer NOT NULL, 			-- This is a foreign key to objectclass.id
	add_therm_bridge_uvalue numeric,
	add_therm_bridge_uvalue_unit varchar,
	eff_therm_capacity numeric,
	eff_therm_capacity_unit varchar,
	ind_heated_area_ratio numeric CHECK (ind_heated_area_ratio BETWEEN 0 AND 1),
	infiltr_rate numeric,
	infiltr_rate_unit varchar,
	is_cooled numeric(1,0),
	is_heated numeric(1,0),
	building_id integer, 						-- This is a foreign key to building.id
	solid_id integer, 							-- This is a foreign key to surface_geometry.id
	multi_surf_geom geometry(MULTIPOLYGONZ)
);
-- ALTER TABLE citydb.nrg8_thermal_zone OWNER TO postgres;

CREATE INDEX nrg8_therm_zone_objclass_id_fkx ON citydb.nrg8_thermal_zone USING btree (objectclass_id);
CREATE INDEX nrg8_therm_zone_building_id_fkx ON citydb.nrg8_thermal_zone USING btree (building_id);
CREATE INDEX nrg8_therm_zone_solid_id_fkx ON citydb.nrg8_thermal_zone USING btree (solid_id);

COMMENT ON COLUMN citydb.nrg8_thermal_zone.objectclass_id IS 'Objectclass ID of the thermal zone';
COMMENT ON COLUMN citydb.nrg8_thermal_zone.add_therm_bridge_uvalue IS 'U-value for the additional thermal bridge';
COMMENT ON COLUMN citydb.nrg8_thermal_zone.add_therm_bridge_uvalue_unit IS 'U-value units of measure';
COMMENT ON COLUMN citydb.nrg8_thermal_zone.eff_therm_capacity IS 'Effective thermal capacity';
COMMENT ON COLUMN citydb.nrg8_thermal_zone.eff_therm_capacity_unit IS 'Effective thermal capacity units of measure';
COMMENT ON COLUMN citydb.nrg8_thermal_zone.ind_heated_area_ratio IS 'Ratio of the indirectly heated area, value in [0,1]';
COMMENT ON COLUMN citydb.nrg8_thermal_zone.infiltr_rate IS 'Infiltration rate';
COMMENT ON COLUMN citydb.nrg8_thermal_zone.infiltr_rate_unit IS 'Infiltration rate units of measure';

--------------------
-- Table THERMAL_BOUNDARY
--------------------
DROP TABLE IF EXISTS citydb.nrg8_thermal_boundary CASCADE;
CREATE TABLE citydb.nrg8_thermal_boundary (
	id integer PRIMARY KEY, 			-- This is a foreign key to building.id
	objectclass_id integer NOT NULL, 	-- This is a foreign key to objectclass.id
	type varchar NOT NULL,				-- This is a foreign key to lu_thermal_boundary.id
	azimuth numeric,
	azimuth_unit varchar,
	inclination numeric,
	inclination_unit varchar,
	area numeric,
	area_unit varchar,
	therm_zone1_id integer, 			-- This is a foreign key to thermal_zone.id
	therm_zone2_id integer, 			-- This is a foreign key to thermal_zone.id
	multi_surf_id integer,  			-- This is a foreign key to surface_geometry.id
	multi_surf_geom geometry(MULTIPOLYGONZ)
);
-- ALTER TABLE citydb.nrg8_thermal_boundary OWNER TO postgres;

CREATE INDEX nrg8_therm_bdry_objclass_id_fkx ON citydb.nrg8_thermal_boundary USING btree (objectclass_id);
CREATE INDEX nrg8_therm_bdry_type_fkx ON citydb.nrg8_thermal_boundary USING btree (type);
CREATE INDEX nrg8_therm_bdry_therm_zone1_id_fkx ON citydb.nrg8_thermal_boundary USING btree (therm_zone1_id);
CREATE INDEX nrg8_therm_bdry_therm_zone2_id_fkx ON citydb.nrg8_thermal_boundary USING btree (therm_zone2_id);
CREATE INDEX nrg8_therm_bdry_multi_surf_id_fkx ON citydb.nrg8_thermal_boundary USING btree (multi_surf_id);
--CREATE INDEX nrg8_therm_bdry_multi_surface_geom_spx ON citydb.nrg8_thermal_boundary USING gist (multi_surf_geom gist_geometry_ops_nd);

COMMENT ON COLUMN citydb.nrg8_thermal_boundary.objectclass_id IS 'Objectclass ID of the thermal boundary';
COMMENT ON COLUMN citydb.nrg8_thermal_boundary.type IS 'Type of thermal boundary';
COMMENT ON COLUMN citydb.nrg8_thermal_boundary.azimuth IS 'Azimuth of the normal vector to the thermal boundary';
COMMENT ON COLUMN citydb.nrg8_thermal_boundary.azimuth_unit IS 'Azimuth units of measure';
COMMENT ON COLUMN citydb.nrg8_thermal_boundary.inclination IS 'Inclination of the thermal boundary';
COMMENT ON COLUMN citydb.nrg8_thermal_boundary.inclination_unit IS 'Inclination units of measure';
COMMENT ON COLUMN citydb.nrg8_thermal_boundary.area IS 'Area of the thermal boundary, including the thermal opening(s)';
COMMENT ON COLUMN citydb.nrg8_thermal_boundary.area_unit IS 'Area units of measure';

--------------------
-- Table THERMAL_OPENING
--------------------
DROP TABLE IF EXISTS citydb.nrg8_thermal_opening CASCADE;
CREATE TABLE citydb.nrg8_thermal_opening (
	id integer PRIMARY KEY, 						-- This is a foreign key to building.id
	objectclass_id integer NOT NULL, 				-- This is a foreign key to objectclass.id
	area numeric,
	area_unit varchar,
	openable_ratio numeric CHECK (openable_ratio BETWEEN 0 AND 1),
	in_shad_name varchar,
	in_shad_max_cover_ratio numeric CHECK (in_shad_max_cover_ratio BETWEEN 0 AND 1),
	in_shad_transmission numeric CHECK (in_shad_transmission BETWEEN 0 AND 1),
	in_shad_transmission_range varchar,
	out_shad_name varchar,
	out_shad_max_cover_ratio numeric CHECK (out_shad_max_cover_ratio BETWEEN 0 AND 1),
	out_shad_transmittance numeric CHECK (out_shad_transmittance BETWEEN 0 AND 1),
	out_shad_transmittance_range varchar,
	therm_boundary_id integer, 						-- This is a foreign key to thermal_boundary.id
	multi_surf_id integer, 							-- This is a foreign key to surface_geometry.id
	multi_surf_geom geometry(MULTIPOLYGONZ)
);
-- ALTER TABLE citydb.nrg8_thermal_opening OWNER TO postgres;

CREATE INDEX nrg8_therm_open_objclass_id_fkx ON citydb.nrg8_thermal_opening USING btree (objectclass_id);
CREATE INDEX nrg8_therm_open_therm_bdry_id_fkx ON citydb.nrg8_thermal_opening USING btree (therm_boundary_id);
CREATE INDEX nrg8_therm_open_multi_surf_id_fkx ON citydb.nrg8_thermal_opening USING btree (multi_surf_id);
-- CREATE INDEX nrg8_therm_open_multi_surf_geom_spx ON citydb.nrg8_thermal_opening USING gist (multi_surf_geom gist_geometry_ops_nd);

COMMENT ON COLUMN citydb.nrg8_thermal_opening.objectclass_id IS 'Objectclass ID of the the thermal opening';
COMMENT ON COLUMN citydb.nrg8_thermal_opening.area IS 'Area of the thermal opening';
COMMENT ON COLUMN citydb.nrg8_thermal_opening.area_unit IS 'Area units of measure';
COMMENT ON COLUMN citydb.nrg8_thermal_opening.openable_ratio IS 'Openable ratio, value in [0,1]';
COMMENT ON COLUMN citydb.nrg8_thermal_opening.in_shad_name IS 'Indoor shading: Device Name';
COMMENT ON COLUMN citydb.nrg8_thermal_opening.in_shad_max_cover_ratio IS 'Indoor shading: Maximum cover ratio, value in [0,1]';
COMMENT ON COLUMN citydb.nrg8_thermal_opening.in_shad_transmission IS 'Indoor shading: Transmission fraction, value in [0,1]';
COMMENT ON COLUMN citydb.nrg8_thermal_opening.in_shad_transmission_range IS 'Indoor shading: Transmission range';
COMMENT ON COLUMN citydb.nrg8_thermal_opening.out_shad_name IS 'Outdoor shading: Device Name';
COMMENT ON COLUMN citydb.nrg8_thermal_opening.out_shad_max_cover_ratio IS 'Outdoor shading: Maximum cover ratio, value in [0,1]';
COMMENT ON COLUMN citydb.nrg8_thermal_opening.out_shad_transmittance IS 'Outdoor shading: Transmission fraction, value in [0,1]';
COMMENT ON COLUMN citydb.nrg8_thermal_opening.out_shad_transmittance_range IS 'Outdoor shading: Transmission range';

--------------------
-- Table USAGE_ZONE
--------------------
DROP TABLE IF EXISTS citydb.nrg8_usage_zone CASCADE;
CREATE TABLE citydb.nrg8_usage_zone (
	id integer PRIMARY KEY, 					-- This is a foreign key to cityobject.id
	objectclass_id integer NOT NULL, 			-- This is a foreign key to objectclass.id
	type varchar,
	type_codespace varchar,
	used_floors integer,
	int_gains_tot_value numeric,
	int_gains_tot_value_unit varchar,
	int_gains_conv numeric CHECK (int_gains_conv BETWEEN 0 AND 1),
	int_gains_lat numeric CHECK (int_gains_lat BETWEEN 0 AND 1),
	int_gains_rad numeric CHECK (int_gains_rad BETWEEN 0 AND 1),
	heat_sched_id integer, 						-- This is a foreign key to schedule.id
	cool_sched_id integer, 						-- This is a foreign key to schedule.id
	vent_sched_id integer, 						-- This is a foreign key to schedule.id
	therm_zone_id integer, 						-- This is a foreign key to thermal_zone.id
	building_id integer, 						-- This is a foreign key to building.id
	solid_id integer, 							-- This is a foreign key to surface_geometry.id
	multi_surf_geom geometry(MULTIPOLYGONZ)
);
-- ALTER TABLE citydb.nrg8_usage_zone OWNER TO postgres;

CREATE INDEX nrg8_usage_zone_objclass_id_fkx ON citydb.nrg8_usage_zone USING btree (objectclass_id);
CREATE INDEX nrg8_usage_zone_type_inx ON citydb.nrg8_usage_zone USING btree (type, type_codespace);
CREATE INDEX nrg8_usage_zone_heat_sched_id_fkx ON citydb.nrg8_usage_zone USING btree (heat_sched_id);
CREATE INDEX nrg8_usage_zone_cool_sched_id_fkx ON citydb.nrg8_usage_zone USING btree (cool_sched_id);
CREATE INDEX nrg8_usage_zone_vent_sched_id_fkx ON citydb.nrg8_usage_zone USING btree (vent_sched_id);
CREATE INDEX nrg8_usage_zone_therm_zone_id_fkx ON citydb.nrg8_usage_zone USING btree (therm_zone_id);
CREATE INDEX nrg8_usage_zone_solid_id_fkx ON citydb.nrg8_usage_zone USING btree (solid_id);
-- CREATE INDEX nrg8_usage_zone_multi_surf_geom_spx ON citydb.nrg8_usage_zone USING gist (multi_surf_geom gist_geometry_ops_nd);

COMMENT ON COLUMN citydb.nrg8_usage_zone.objectclass_id IS 'Objectclass ID of the usage zone';
COMMENT ON COLUMN citydb.nrg8_usage_zone.type IS 'Type of usage zone';
COMMENT ON COLUMN citydb.nrg8_usage_zone.type_codespace IS 'Type of usage zone (codespace)';
COMMENT ON COLUMN citydb.nrg8_usage_zone.used_floors IS 'Number of used floors';
COMMENT ON COLUMN citydb.nrg8_usage_zone.int_gains_tot_value IS 'Total value of average internal gains through heat exchange';
COMMENT ON COLUMN citydb.nrg8_usage_zone.int_gains_tot_value_unit IS 'Internal gains units of measure';
COMMENT ON COLUMN citydb.nrg8_usage_zone.int_gains_conv IS 'Convective fraction of internal gains through heat exchange, value in [0,1]';
COMMENT ON COLUMN citydb.nrg8_usage_zone.int_gains_lat IS 'Latent fraction of internal gains through heat exchange, value in [0,1]';
COMMENT ON COLUMN citydb.nrg8_usage_zone.int_gains_rad IS 'Radiant fraction of internal gains through heat exchange, value in [0,1]';

--------------------
-- Table BUILDING_UNIT
--------------------
DROP TABLE IF EXISTS citydb.nrg8_building_unit CASCADE;
CREATE TABLE citydb.nrg8_building_unit (
	id integer PRIMARY KEY,			 	-- This is a foreign key to cityobject.id
	objectclass_id integer NOT NULL, 	-- This is a foreign key to objectclass.id
	nbr_of_rooms integer,
	owner_name varchar,					
	ownership_type varchar,				-- This is a foreign key to lu_ownership.id
	usage_zone_id integer 				-- This is a foreign key to usage_zone.id
);
-- ALTER TABLE citydb.nrg8_building_unit OWNER TO postgres;

CREATE INDEX nrg8_bdg_unit_objclass_id_fkx ON citydb.nrg8_building_unit USING btree (objectclass_id);
CREATE INDEX nrg8_bdg_unit_ownership_type_fkx ON citydb.nrg8_building_unit USING btree (ownership_type);
CREATE INDEX nrg8_bdg_unit_usage_zone_id_fkx ON citydb.nrg8_building_unit USING btree (usage_zone_id);

COMMENT ON COLUMN citydb.nrg8_building_unit.objectclass_id IS 'Objectclass ID of the building unit';
COMMENT ON COLUMN citydb.nrg8_building_unit.nbr_of_rooms IS 'Number of rooms';
COMMENT ON COLUMN citydb.nrg8_building_unit.owner_name IS 'Name of the owner';
COMMENT ON COLUMN citydb.nrg8_building_unit.ownership_type IS 'Type of the ownership';

--------------------
-- Table BUILDING_UNIT_TO_ADDRESS
--------------------
DROP TABLE IF EXISTS citydb.nrg8_bdg_unit_to_address CASCADE;
CREATE TABLE citydb.nrg8_bdg_unit_to_address (
	building_unit_id integer NOT NULL, 							-- This is a foreign key to nrg8_building_unit.id
	address_id integer NOT NULL, 								-- This is a foreign key to address.id
	CONSTRAINT nrg8_bdg_unit_to_address_pk PRIMARY KEY (building_unit_id, address_id)
);
-- ALTER TABLE citydb.nrg8_bdg_unit_to_address OWNER TO postgres;

CREATE INDEX nrg8_bdg_unit_to_address_bdg_unit_id_fkx ON citydb.nrg8_bdg_unit_to_address USING btree (building_unit_id);
CREATE INDEX nrg8_bdg_unit_to_address_address_id_fkx ON citydb.nrg8_bdg_unit_to_address USING btree (address_id);

--------------------
-- Table OCCUPANTS
--------------------
DROP TABLE IF EXISTS citydb.nrg8_occupants CASCADE;
CREATE TABLE citydb.nrg8_occupants (
	id serial PRIMARY KEY,
	objectclass_id integer NOT NULL, 	-- This is a foreign key to objectclass.id
	gmlid varchar,
	gmlid_codespace varchar,
	name varchar,
	name_codespace varchar,
	description text,
	type varchar,						-- This is a foreign key to lu_occupants.id
	nbr_of_occupants integer,
	heat_diss_tot_value numeric,
	heat_diss_tot_value_unit varchar,
	heat_diss_conv numeric CHECK (heat_diss_conv BETWEEN 0 AND 1),
	heat_diss_lat numeric CHECK (heat_diss_lat BETWEEN 0 AND 1),
	heat_diss_rad numeric CHECK (heat_diss_rad BETWEEN 0 AND 1),
	usage_zone_id integer,		-- This is a foreign key to nrg8_usage_zone.id
	sched_id integer,		-- This is a foreign key to nrg8_schedule.id
	building_unit_id integer	-- This is a foreign key to nrg8_building_unit.id
);
-- ALTER TABLE citydb.nrg8_occupants OWNER TO postgres;

CREATE INDEX nrg8_occup_objclass_id_fkx ON citydb.nrg8_occupants USING btree (objectclass_id);
CREATE INDEX nrg8_occup_gmlid_inx ON citydb.nrg8_occupants USING btree (gmlid,gmlid_codespace);
CREATE INDEX nrg8_occup_type_fkx ON citydb.nrg8_occupants USING btree (type);
CREATE INDEX nrg8_occup_usage_zone_id_inx ON citydb.nrg8_occupants USING btree (usage_zone_id);
CREATE INDEX nrg8_occup_bdg_unit_id_inx ON citydb.nrg8_occupants USING btree (building_unit_id);

COMMENT ON COLUMN citydb.nrg8_occupants.objectclass_id IS 'Objectclass ID of the occupants';
COMMENT ON COLUMN citydb.nrg8_occupants.type IS 'Type of occupants';
COMMENT ON COLUMN citydb.nrg8_occupants.nbr_of_occupants IS 'Number of occupants';
COMMENT ON COLUMN citydb.nrg8_occupants.heat_diss_tot_value IS 'Total value of heat dissipation through heat exchange';
COMMENT ON COLUMN citydb.nrg8_occupants.heat_diss_tot_value_unit IS 'Heat dissipation units of measure';
COMMENT ON COLUMN citydb.nrg8_occupants.heat_diss_conv IS 'Convective fraction of heat dissipation through heat exchange, value in [0,1]';
COMMENT ON COLUMN citydb.nrg8_occupants.heat_diss_lat IS 'Latent fraction of heat dissipation through heat exchange, value in [0,1]';
COMMENT ON COLUMN citydb.nrg8_occupants.heat_diss_rad IS 'Radiant fraction of heat dissipation through heat exchange, value in [0,1]';

--------------------
-- Table HOUSEHOLD
--------------------
DROP TABLE IF EXISTS citydb.nrg8_household CASCADE;
CREATE TABLE citydb.nrg8_household (
	id serial PRIMARY KEY,
	objectclass_id integer NOT NULL, 	-- This is a foreign key to objectclass.id
	gmlid varchar,
	gmlid_codespace varchar,
	name varchar,
	name_codespace varchar,
	description text,
	type varchar,						-- This is a foreign key to lu_household.id
	residence_type varchar,				-- This is a foreign key to lu_residence.id
	occupants_id integer 				-- This is a foreign key to occupants.id
);
-- ALTER TABLE citydb.nrg8_household OWNER TO postgres;

CREATE INDEX nrg8_household_objclass_id_fkx ON citydb.nrg8_household USING btree (objectclass_id);
CREATE INDEX nrg8_household_gmlid_inx ON citydb.nrg8_household USING btree (gmlid, gmlid_codespace);
CREATE INDEX nrg8_household_type_fkx ON citydb.nrg8_household USING btree (type);
CREATE INDEX nrg8_household_residence_type_fkx ON citydb.nrg8_household USING btree (residence_type);
CREATE INDEX nrg8_household_occup_id_fkx ON citydb.nrg8_household USING btree (occupants_id);

COMMENT ON COLUMN citydb.nrg8_household.objectclass_id IS 'Objectclass ID of the household';
COMMENT ON COLUMN citydb.nrg8_household.type IS 'Type of household';
COMMENT ON COLUMN citydb.nrg8_household.residence_type IS 'Type of residence';

--------------------
-- Table FACILITIES
--------------------
DROP TABLE IF EXISTS citydb.nrg8_facilities CASCADE;
CREATE TABLE citydb.nrg8_facilities (
	id integer PRIMARY KEY, 			-- This is a foreign key to cityobject.id
	objectclass_id integer NOT NULL, 	-- This is a foreign key to objectclass.id
	heat_diss_tot_value numeric,
	heat_diss_tot_value_unit varchar,
	heat_diss_conv numeric CHECK (heat_diss_conv BETWEEN 0 AND 1),
	heat_diss_lat numeric CHECK (heat_diss_lat BETWEEN 0 AND 1),
	heat_diss_rad numeric CHECK (heat_diss_rad BETWEEN 0 AND 1),
	electr_pwr numeric,
	electr_pwr_unit varchar,
	nbr_of_baths integer,
	nbr_of_showers integer,
	nbr_of_washbasins integer,
	water_strg_vol numeric,
	water_strg_vol_unit varchar,
	oper_sched_id integer, 				-- This is a foreign key to nrg8_schedule.id
	usage_zone_id integer,				-- This is a foreign key to nrg8_usage_zone.id
	building_unit_id integer			-- This is a foreign key to nrg8_building_unit.id
);
-- ALTER TABLE citydb.nrg8_facilities OWNER TO postgres;

CREATE INDEX nrg8_facilities_objclass_id_fkx ON citydb.nrg8_facilities USING btree (objectclass_id);
CREATE INDEX nrg8_facilities_oper_sched_id_fkx ON citydb.nrg8_facilities USING btree (oper_sched_id);
CREATE INDEX nrg8_facilities_usage_zone_id_fkx ON citydb.nrg8_facilities USING btree (usage_zone_id);
CREATE INDEX nrg8_facilities_bdg_unit_id_fkx ON citydb.nrg8_facilities USING btree (building_unit_id);

COMMENT ON COLUMN citydb.nrg8_facilities.objectclass_id IS 'Objectclass ID of the facilities';
COMMENT ON COLUMN citydb.nrg8_facilities.heat_diss_tot_value IS 'Total value of heat dissipation through heat exchange';
COMMENT ON COLUMN citydb.nrg8_facilities.heat_diss_tot_value_unit IS 'Heat dissipation units of measure';
COMMENT ON COLUMN citydb.nrg8_facilities.heat_diss_conv IS 'Convective fraction of heat dissipation through heat exchange, value in [0,1]';
COMMENT ON COLUMN citydb.nrg8_facilities.heat_diss_lat IS 'Latent fraction of heat dissipation through heat exchange, value in [0,1]';
COMMENT ON COLUMN citydb.nrg8_facilities.heat_diss_rad IS 'Radiant fraction of heat dissipation through heat exchange, value in [0,1]';
COMMENT ON COLUMN citydb.nrg8_facilities.electr_pwr IS 'Electrival power';
COMMENT ON COLUMN citydb.nrg8_facilities.electr_pwr_unit IS 'Electrival power units of measure';
COMMENT ON COLUMN citydb.nrg8_facilities.nbr_of_baths IS 'Number of baths';
COMMENT ON COLUMN citydb.nrg8_facilities.nbr_of_showers IS 'Number of showers';
COMMENT ON COLUMN citydb.nrg8_facilities.nbr_of_washbasins IS 'Number of washbasins';
COMMENT ON COLUMN citydb.nrg8_facilities.water_strg_vol IS 'Water storage volume';
COMMENT ON COLUMN citydb.nrg8_facilities.water_strg_vol_unit IS 'Volume units of measure';

----------------------------------------------------------------
-- Table ENERGY_DEMAND
----------------------------------------------------------------
DROP TABLE IF EXISTS citydb.nrg8_energy_demand CASCADE;
CREATE TABLE IF NOT EXISTS citydb.nrg8_energy_demand (
	id serial PRIMARY KEY,
  	objectclass_id integer NOT NULL, 	-- This is a foreign key to objectclass.id
	gmlid varchar,
	gmlid_codespace varchar,
	name varchar,
	name_codespace varchar,
	description text,
	end_use varchar,					-- This is a foreign key to lu_end_use.id
	max_load numeric,
	max_load_unit varchar,
	time_series_id integer, 			-- This is a foreign key to time_series.id 
	cityobject_id integer 				-- This is a foreign key to cityobject.id
);
-- ALTER TABLE citydb.nrg8_energy_demand OWNER TO postgres;

CREATE INDEX nrg8_energy_demand_objclass_id_fkx ON citydb.nrg8_energy_demand USING btree (objectclass_id);
CREATE INDEX nrg8_energy_demand_gmlid_inx ON citydb.nrg8_energy_demand USING btree (gmlid, gmlid_codespace);
CREATE INDEX nrg8_energy_demand_end_use_fkx ON citydb.nrg8_energy_demand USING btree (end_use);
CREATE INDEX nrg8_energy_demand_tseries_id_fkx ON citydb.nrg8_energy_demand USING btree (time_series_id);
CREATE INDEX nrg8_energy_demand_ctyobj_id_fkx ON citydb.nrg8_energy_demand USING btree (cityobject_id);

COMMENT ON COLUMN citydb.nrg8_energy_demand.objectclass_id IS 'Objectclass ID of the energy demand';
COMMENT ON COLUMN citydb.nrg8_energy_demand.end_use IS 'End use';
COMMENT ON COLUMN citydb.nrg8_energy_demand.max_load IS 'Maximum load';
COMMENT ON COLUMN citydb.nrg8_energy_demand.max_load_unit IS 'Maximum load unit of measure';

----------------------------------------------------------------
-- Table FINAL_ENERGY
----------------------------------------------------------------
DROP TABLE IF EXISTS citydb.nrg8_final_energy CASCADE;
CREATE TABLE IF NOT EXISTS citydb.nrg8_final_energy (
	id serial PRIMARY KEY,
  	objectclass_id integer NOT NULL, 	-- This is a foreign key to objectclass.id
	gmlid varchar,
	gmlid_codespace varchar,
	name varchar,
	name_codespace varchar,
	description text,
	nrg_car_type varchar,				-- This is a foreign key to lu_energy_source.id
	nrg_car_prim_nrg_factor numeric,
	nrg_car_prim_nrg_factor_unit varchar,
	nrg_car_nrg_density numeric,
	nrg_car_nrg_density_unit varchar,
	nrg_car_co2_emission numeric,
	nrg_car_co2_emission_unit varchar,
	time_series_id integer 				-- This is a foreign key to time_series.id 
);
-- ALTER TABLE citydb.nrg8_final_energy OWNER TO postgres;

CREATE INDEX nrg8_final_energy_objclass_id_fkx ON citydb.nrg8_final_energy USING btree (objectclass_id);
CREATE INDEX nrg8_final_energy_gmlid_inx ON citydb.nrg8_final_energy USING btree (gmlid, gmlid_codespace);
CREATE INDEX nrg8_final_nrg_car_type_fkx ON citydb.nrg8_final_energy USING btree (nrg_car_type);
CREATE INDEX nrg8_final_nrg_tseries_id_fkx ON citydb.nrg8_final_energy USING btree (time_series_id);

COMMENT ON COLUMN citydb.nrg8_final_energy.objectclass_id IS 'Objectclass ID of the final energy';
COMMENT ON COLUMN citydb.nrg8_final_energy.nrg_car_type IS 'Energy carrier: Type';
COMMENT ON COLUMN citydb.nrg8_final_energy.nrg_car_prim_nrg_factor IS 'Energy carrier: Primary energy factor';
COMMENT ON COLUMN citydb.nrg8_final_energy.nrg_car_prim_nrg_factor_unit IS 'Primary energy factor units of measure';
COMMENT ON COLUMN citydb.nrg8_final_energy.nrg_car_nrg_density IS 'Energy carrier: Energy density';
COMMENT ON COLUMN citydb.nrg8_final_energy.nrg_car_nrg_density_unit IS 'Energy density units of measure';
COMMENT ON COLUMN citydb.nrg8_final_energy.nrg_car_co2_emission IS 'Energy carrier: CO2 emission';
COMMENT ON COLUMN citydb.nrg8_final_energy.nrg_car_co2_emission_unit IS 'CO2 emission units of measure';

----------------------------------------------------------------
-- Table ENERGY_CONV_SYSTEM_TO_FINAL_ENERGY
----------------------------------------------------------------
DROP TABLE IF EXISTS citydb.nrg8_conv_sys_to_final_nrg CASCADE;
CREATE TABLE IF NOT EXISTS citydb.nrg8_conv_sys_to_final_nrg (
	conv_system_id integer NOT NULL,    			-- This is a foreign key to nrg8_conv_system.id
	final_nrg_id integer NOT NULL, 				-- This is a foreign key to nrg8_final_energy.id
	role varchar NOT NULL CHECK (role IN ('production','consumption')),	-- TODO make it better
	CONSTRAINT nrg8_conv_sys_to_final_nrg_pk PRIMARY KEY (conv_system_id, final_nrg_id, role)
);
-- ALTER TABLE citydb.nrg8_conv_sys_to_final_nrg OWNER TO postgres;

CREATE INDEX nrg8_conv_sys_to_final_nrg_conv_sys_id_fkx ON citydb.nrg8_conv_sys_to_final_nrg USING btree (conv_system_id);
CREATE INDEX nrg8_conv_sys_to_final_nrg_final_nrg_id_fkx ON citydb.nrg8_conv_sys_to_final_nrg USING btree (final_nrg_id);
CREATE INDEX nrg8_conv_sys_to_final_nrg_role_inx ON citydb.nrg8_conv_sys_to_final_nrg USING btree (role);

----------------------------------------------------------------
-- Table ENERGY_CONVERSION_SYSTEM_TO_ENERGY_DEMAND
----------------------------------------------------------------
DROP TABLE IF EXISTS citydb.nrg8_conv_sys_to_nrg_demand CASCADE;
CREATE TABLE IF NOT EXISTS citydb.nrg8_conv_sys_to_nrg_demand (
	conv_system_id integer NOT NULL,		-- This is a foreign key to conv_system.id
	nrg_demand_id integer NOT NULL,			-- This is a foreign key to energy_demand.id
	CONSTRAINT nrg8_conv_sys_to_nrg_demand_pk PRIMARY KEY (conv_system_id, nrg_demand_id)
);
-- ALTER TABLE citydb.nrg8_conv_sys_to_nrg_demand OWNER TO postgres;

CREATE INDEX nrg8_conv_sys_to_nrg_demand_conv_sys_id_fkx ON citydb.nrg8_conv_sys_to_nrg_demand USING btree (conv_system_id);
CREATE INDEX nrg8_conv_sys_to_nrg_demand_nrg_demand_id_fkx ON citydb.nrg8_conv_sys_to_nrg_demand USING btree (nrg_demand_id);

----------------------------------------------------------------
-- Table EMITTER
----------------------------------------------------------------
DROP TABLE IF EXISTS citydb.nrg8_emitter CASCADE;
CREATE TABLE IF NOT EXISTS citydb.nrg8_emitter (
	id integer PRIMARY KEY, 						-- This is a foreign key to cityobject.id
	objectclass_id integer NOT NULL,				-- This is a foreign key to objectclass.id
	type varchar,									-- This is a foreign key to lu_emitter.id
	unit_nbr integer,
	inst_pwr numeric,
	inst_pwr_unit varchar,
	therm_exch_tot_value numeric,
	therm_exch_tot_value_unit varchar,
	therm_exch_conv numeric CHECK (therm_exch_conv BETWEEN 0 AND 1),
	therm_exch_rad numeric CHECK (therm_exch_rad BETWEEN 0 AND 1),
	therm_exch_lat numeric CHECK (therm_exch_lat BETWEEN 0 AND 1),
	distr_system_id integer,						-- This is a foreign key to distrib_system.id
	cityobject_id integer								-- This is a foreign key to cityobject.id
);
-- ALTER TABLE citydb.nrg8_emitter OWNER TO postgres;

CREATE INDEX nrg8_emitter_objclass_id_fkx ON citydb.nrg8_emitter USING btree (objectclass_id);
CREATE INDEX nrg8_emitter_type_fkx ON citydb.nrg8_emitter USING btree (type);
CREATE INDEX nrg8_emitter_distr_sys_id_fkx ON citydb.nrg8_emitter USING btree (distr_system_id);
CREATE INDEX nrg8_emitter_ctyobj_id_fkx ON citydb.nrg8_emitter USING btree (cityobject_id);

COMMENT ON COLUMN citydb.nrg8_emitter.objectclass_id IS 'Objectclass ID of the emitter';
COMMENT ON COLUMN citydb.nrg8_emitter.type IS 'Type of emitter';
COMMENT ON COLUMN citydb.nrg8_emitter.unit_nbr IS 'Unit number';
COMMENT ON COLUMN citydb.nrg8_emitter.inst_pwr IS 'Installed power';
COMMENT ON COLUMN citydb.nrg8_emitter.inst_pwr_unit IS 'Installed power units of measure';
COMMENT ON COLUMN citydb.nrg8_emitter.therm_exch_tot_value IS 'Total value of thermal exchange through heat exchange';
COMMENT ON COLUMN citydb.nrg8_emitter.therm_exch_tot_value_unit IS 'Heat exchange units of measure';
COMMENT ON COLUMN citydb.nrg8_emitter.therm_exch_conv IS 'Convective fraction of thermal exchange through heat exchange, value in [0,1]';
COMMENT ON COLUMN citydb.nrg8_emitter.therm_exch_lat IS 'Latent fraction of thermal exchange through heat exchange, value in [0,1]';
COMMENT ON COLUMN citydb.nrg8_emitter.therm_exch_rad IS 'Radiant fraction of thermal exchange through heat exchange, value in [0,1]';

----------------------------------------------------------------
-- Table ENERGY_DISTRIB_SYSTEM
----------------------------------------------------------------
DROP TABLE IF EXISTS citydb.nrg8_distrib_system CASCADE;
CREATE TABLE IF NOT EXISTS citydb.nrg8_distrib_system (
	id integer PRIMARY KEY, 			-- This is a foreign key to cityobject.id
	objectclass_id integer NOT NULL,	-- This is a foreign key to objectclass.id
	distrib_perim varchar,				-- This is a foreign key to lu_distribution.id
	start_of_life date,
	life_expect_value numeric,
	life_expect_value_unit varchar,
	main_maint_interval numeric,
	main_maint_interval_unit varchar,
	nrg_demand_id integer,				-- This is a foreign key to nrg8_energy_demand.id
	cityobject_id integer				-- This is a foreign key to cityobject.id
);
-- ALTER TABLE citydb.nrg8_distrib_system OWNER TO postgres;

CREATE INDEX nrg8_distr_sys_objclass_id_fkx ON citydb.nrg8_distrib_system USING btree (objectclass_id);
CREATE INDEX nrg8_distr_sys_distrib_perim_fkx ON citydb.nrg8_distrib_system USING btree (distrib_perim);
CREATE INDEX nrg8_distr_sys_nrg_demand_id_fkx ON citydb.nrg8_distrib_system USING btree (nrg_demand_id);
CREATE INDEX nrg8_distr_sys_ctyobj_fkx ON citydb.nrg8_distrib_system USING btree (cityobject_id);

COMMENT ON COLUMN citydb.nrg8_distrib_system.objectclass_id IS 'Objectclass ID of the energy distribution system';
COMMENT ON COLUMN citydb.nrg8_distrib_system.distrib_perim IS 'Distribution perimeter';
COMMENT ON COLUMN citydb.nrg8_distrib_system.start_of_life IS 'Service life: Date of start of service';
COMMENT ON COLUMN citydb.nrg8_distrib_system.life_expect_value IS 'Service life: Life expectancy';
COMMENT ON COLUMN citydb.nrg8_distrib_system.life_expect_value_unit IS 'Life expectancy units of measure';
COMMENT ON COLUMN citydb.nrg8_distrib_system.main_maint_interval IS 'Service life: Main maintenance time interval';
COMMENT ON COLUMN citydb.nrg8_distrib_system.main_maint_interval_unit IS 'Time interval units of measure';
COMMENT ON COLUMN citydb.nrg8_distrib_system.cityobject_id IS 'Implements +energyConversionSystem attribute in class CityObject';

----------------------------------------------------------------
-- Table ENERGY_THERMAL_DISTRIBUTION_SYSTEM
----------------------------------------------------------------
DROP TABLE IF EXISTS citydb.nrg8_thermal_distrib_system CASCADE;
CREATE TABLE IF NOT EXISTS citydb.nrg8_thermal_distrib_system (
	id integer PRIMARY KEY,				-- This is a foreign key to distrib_system.id
	objectclass_id integer NOT NULL, 	-- This is a foreign key to objectclass.id
	has_circulation numeric(1,0),
	medium varchar,						-- This is a foreign key to lu_medium.id
	nom_flow numeric,
	nom_flow_unit varchar,
	supply_temp numeric, 
	supply_temp_unit varchar,
	return_temp numeric,
	return_temp_unit varchar,
	therm_loss numeric, 
	therm_loss_unit varchar
);
-- ALTER TABLE citydb.nrg8_thermal_distrib_system OWNER TO postgres;

CREATE INDEX nrg8_thermal_distrib_system_objclass_id_fkx ON citydb.nrg8_thermal_distrib_system USING btree (objectclass_id);
CREATE INDEX nrg8_thermal_distrib_system_medium_fkx ON citydb.nrg8_thermal_distrib_system USING btree (medium);

COMMENT ON COLUMN citydb.nrg8_thermal_distrib_system.objectclass_id IS 'Objectclass ID of the thermal distribution system';
COMMENT ON COLUMN citydb.nrg8_thermal_distrib_system.has_circulation IS 'Has circulation?';
COMMENT ON COLUMN citydb.nrg8_thermal_distrib_system.medium IS 'Type of medium';
COMMENT ON COLUMN citydb.nrg8_thermal_distrib_system.nom_flow IS 'Nominal flow';
COMMENT ON COLUMN citydb.nrg8_thermal_distrib_system.nom_flow_unit IS 'Nominal flow units of measure';
COMMENT ON COLUMN citydb.nrg8_thermal_distrib_system.supply_temp IS 'Supply temperature';
COMMENT ON COLUMN citydb.nrg8_thermal_distrib_system.supply_temp_unit IS 'Supply temperature units of measure';
COMMENT ON COLUMN citydb.nrg8_thermal_distrib_system.return_temp IS 'Return temperature';
COMMENT ON COLUMN citydb.nrg8_thermal_distrib_system.return_temp_unit IS 'Return temperature units of measure';
COMMENT ON COLUMN citydb.nrg8_thermal_distrib_system.therm_loss IS 'Thermal losses factor';
COMMENT ON COLUMN citydb.nrg8_thermal_distrib_system.therm_loss_unit IS 'Thermal losses factor units of measure';

----------------------------------------------------------------
-- Table ENERGY_POWER_DISTRIBUTION_SYSTEM
----------------------------------------------------------------
DROP TABLE IF EXISTS citydb.nrg8_power_distrib_system CASCADE;
CREATE TABLE IF NOT EXISTS citydb.nrg8_power_distrib_system (
	id integer PRIMARY KEY,				-- This is a foreign key to distrib_system.id
	objectclass_id integer NOT NULL, 	-- This is a foreign key to objectclass.id
	current numeric,
	current_unit varchar,
	voltage numeric,
	voltage_unit varchar
);
-- ALTER TABLE citydb.nrg8_power_distrib_system OWNER TO postgres;

CREATE INDEX nrg8_power_distrib_system_objclass_id_fkx ON citydb.nrg8_power_distrib_system USING btree (objectclass_id);

COMMENT ON COLUMN citydb.nrg8_power_distrib_system.objectclass_id IS 'Objectclass ID of the power distribution system';
COMMENT ON COLUMN citydb.nrg8_power_distrib_system.current IS 'Current';
COMMENT ON COLUMN citydb.nrg8_power_distrib_system.current_unit IS 'Current units of measure';
COMMENT ON COLUMN citydb.nrg8_power_distrib_system.voltage IS 'Voltage';
COMMENT ON COLUMN citydb.nrg8_power_distrib_system.voltage_unit IS 'Voltage units of measure';

----------------------------------------------------------------
-- Table ENERGY_STORAGE_SYSTEM
----------------------------------------------------------------
DROP TABLE IF EXISTS citydb.nrg8_storage_system CASCADE;
CREATE TABLE IF NOT EXISTS citydb.nrg8_storage_system (
	id integer PRIMARY KEY, 			-- This is a foreign key to cityobject.id
	objectclass_id integer NOT NULL,	-- This is a foreign key to objectclass.id
	start_of_life date,
	life_expect_value numeric,
	life_expect_value_unit varchar,
	main_maint_interval numeric,
	main_maint_interval_unit varchar,
	nrg_demand_id integer,				-- This is a foreign key to nrg_demand.id
	cityobject_id integer				-- This is a foreign key to cityobject.id	
);
-- ALTER TABLE citydb.nrg8_storage_system OWNER TO postgres;

CREATE INDEX nrg8_stor_sys_objclass_id_fkx ON citydb.nrg8_storage_system USING btree (objectclass_id);
CREATE INDEX nrg8_stor_sys_nrg_demand_id_fkx ON citydb.nrg8_storage_system USING btree (nrg_demand_id);
CREATE INDEX nrg8_stor_sys_ctyobj_id_fkx ON citydb.nrg8_storage_system USING btree (cityobject_id);

COMMENT ON COLUMN citydb.nrg8_storage_system.objectclass_id IS 'Objectclass ID of the energy storage system';
COMMENT ON COLUMN citydb.nrg8_storage_system.start_of_life IS 'Service life: Date of start of service';
COMMENT ON COLUMN citydb.nrg8_storage_system.life_expect_value IS 'Service life: Life expectancy';
COMMENT ON COLUMN citydb.nrg8_storage_system.life_expect_value_unit IS 'Life expectancy units of measure';
COMMENT ON COLUMN citydb.nrg8_storage_system.main_maint_interval IS 'Service life: Main maintenance time interval';
COMMENT ON COLUMN citydb.nrg8_storage_system.main_maint_interval_unit IS 'Time interval units of measure';
COMMENT ON COLUMN citydb.nrg8_storage_system.cityobject_id IS 'Implements +energyConversionSystem attribute in class CityObject';

----------------------------------------------------------------
-- Table ENERGY_THERMAL_STORAGE_SYSTEM
----------------------------------------------------------------
DROP TABLE IF EXISTS citydb.nrg8_thermal_storage_system CASCADE;
CREATE TABLE IF NOT EXISTS citydb.nrg8_thermal_storage_system (
	id integer PRIMARY KEY, 			-- This is a foreign key to nrg8_storage_system.id
	objectclass_id integer NOT NULL, 	-- This is a foreign key to objectclass.id
	medium varchar,						-- This is a foreign key to lu_medium.id
	vol numeric,
	vol_unit varchar,
	prep_temp numeric,
	prep_temp_unit varchar,
	therm_loss numeric, 
	therm_loss_unit varchar
);
-- ALTER TABLE citydb.nrg8_thermal_storage_system OWNER TO postgres;

CREATE INDEX nrg8_thermal_stor_sys_objclass_id_fkx ON citydb.nrg8_thermal_storage_system USING btree (objectclass_id);
CREATE INDEX nrg8_thermal_stor_sys_medium_fkx ON citydb.nrg8_thermal_storage_system USING btree (medium);

COMMENT ON COLUMN citydb.nrg8_thermal_storage_system.objectclass_id IS 'Objectclass ID of the thermal storage system';
COMMENT ON COLUMN citydb.nrg8_thermal_storage_system.medium IS 'Type of medium';
COMMENT ON COLUMN citydb.nrg8_thermal_storage_system.vol IS 'Volume';
COMMENT ON COLUMN citydb.nrg8_thermal_storage_system.vol_unit IS 'Volume units of measure';
COMMENT ON COLUMN citydb.nrg8_thermal_storage_system.prep_temp IS 'Preparation temperature';
COMMENT ON COLUMN citydb.nrg8_thermal_storage_system.prep_temp IS 'Preparation temperature units of measure';
COMMENT ON COLUMN citydb.nrg8_thermal_storage_system.therm_loss IS 'Thermal losses factor';
COMMENT ON COLUMN citydb.nrg8_thermal_storage_system.therm_loss IS 'Thermal losses factor units of measure';

----------------------------------------------------------------
-- Table ENERGY_POWER_STORAGE_SYSTEM
----------------------------------------------------------------
DROP TABLE IF EXISTS citydb.nrg8_power_storage_system CASCADE;
CREATE TABLE IF NOT EXISTS citydb.nrg8_power_storage_system (
	id integer PRIMARY KEY, 			-- This is a foreign key to nrg8_storage_system.id
	objectclass_id integer NOT NULL, 	-- This is a foreign key to objectclass.id
	battery_techn varchar,
	pwr_capacity numeric,
	pwr_capacity_unit varchar
);
-- ALTER TABLE citydb.nrg8_power_storage_system OWNER TO postgres;

CREATE INDEX nrg8_power_stor_sys_objclass_id_fkx ON citydb.nrg8_power_storage_system USING btree (objectclass_id);

COMMENT ON COLUMN citydb.nrg8_power_storage_system.objectclass_id IS 'Objectclass ID of the power storage system';
COMMENT ON COLUMN citydb.nrg8_power_storage_system.battery_techn IS 'Battery technology';
COMMENT ON COLUMN citydb.nrg8_power_storage_system.pwr_capacity IS 'Power capacity';
COMMENT ON COLUMN citydb.nrg8_power_storage_system.pwr_capacity_unit IS 'Power capacity units of measure';

----------------------------------------------------------------
-- Table SYSTEM_OPERATION
----------------------------------------------------------------
DROP TABLE IF EXISTS citydb.nrg8_system_operation CASCADE;
CREATE TABLE IF NOT EXISTS citydb.nrg8_system_operation (
	id serial PRIMARY KEY,
  objectclass_id integer NOT NULL, 	-- This is a foreign key to objectclass.id
	gmlid varchar,
	gmlid_codespace varchar,
	name varchar,
	name_codespace varchar,
	description text,
	end_use varchar NOT NULL,			-- This is a foreign key to lu_end_use.id
	yearly_global_effcy numeric CHECK (yearly_global_effcy BETWEEN 0 AND 1),
	sched_id integer, 					-- This is a foreign key to nrg8_schedule.id
	nrg_conv_system_id integer 			-- This is a foreign key to nrg8_conv_system.id
);
-- ALTER TABLE citydb.nrg8_system_operation OWNER TO postgres;

CREATE INDEX nrg8_sys_oper_objclass_id_fkx ON citydb.nrg8_system_operation USING btree (objectclass_id);
CREATE INDEX nrg8_sys_oper_end_use_fkx ON citydb.nrg8_system_operation USING btree (end_use);
CREATE INDEX nrg8_sys_oper_sched_id_fkx ON citydb.nrg8_system_operation USING btree (sched_id);
CREATE INDEX nrg8_sys_oper_nrg_conv_sys_id_fkx ON citydb.nrg8_system_operation USING btree (nrg_conv_system_id);

COMMENT ON COLUMN citydb.nrg8_system_operation.objectclass_id IS 'Objectclass ID of the system_operation';
COMMENT ON COLUMN citydb.nrg8_system_operation.end_use IS 'Type of end use';
COMMENT ON COLUMN citydb.nrg8_system_operation.yearly_global_effcy IS 'Yearly global efficiency factor, value in [0,1]';

----------------------------------------------------------------
-- Table ENERGY_CONV_SYSTEM
----------------------------------------------------------------
DROP TABLE IF EXISTS citydb.nrg8_conv_system CASCADE;
CREATE TABLE IF NOT EXISTS citydb.nrg8_conv_system (
	id integer PRIMARY KEY, 			-- This is a foreign key to cityobject.id
	objectclass_id integer NOT NULL, 	-- This is a foreign key to objectclass.id
	model varchar,
	nbr integer,
	year_of_manufacture integer,
	inst_nom_pwr numeric,
	inst_nom_pwr_unit varchar,
	nom_effcy numeric,
	effcy_indicator varchar,
	start_of_life date,
	life_expect_value numeric,
	life_expect_value_unit varchar,
	main_maint_interval numeric,
	main_maint_interval_unit varchar,
	inst_in_ctyobj_id integer,			-- This is a foreign key to cityobject.id  -- +installed_in
	cityobject_id integer 				-- This is a foreign key to cityobject.id, correspond to +energyConversionSystem of CityObject.
);
-- ALTER TABLE citydb.nrg8_conv_system OWNER TO postgres;

CREATE INDEX nrg8_conv_sys_objclass_id_fkx ON citydb.nrg8_conv_system USING btree (objectclass_id);
CREATE INDEX nrg8_conv_sys_inst_in_ctyobj_id_fkx ON citydb.nrg8_conv_system USING btree (inst_in_ctyobj_id);
CREATE INDEX nrg8_conv_sys_ctyobj_id_fkx ON citydb.nrg8_conv_system USING btree (cityobject_id);

COMMENT ON COLUMN citydb.nrg8_conv_system.objectclass_id IS 'Objectclass ID of the energy conversion system';
COMMENT ON COLUMN citydb.nrg8_conv_system.model IS 'Model';
COMMENT ON COLUMN citydb.nrg8_conv_system.nbr IS 'Model number';
COMMENT ON COLUMN citydb.nrg8_conv_system.year_of_manufacture IS 'Year of manufacture';
COMMENT ON COLUMN citydb.nrg8_conv_system.inst_nom_pwr IS 'Installed nominal power';
COMMENT ON COLUMN citydb.nrg8_conv_system.inst_nom_pwr_unit IS 'Installed nominal power units of measure';
COMMENT ON COLUMN citydb.nrg8_conv_system.nom_effcy IS 'Nominal efficiency';
COMMENT ON COLUMN citydb.nrg8_conv_system.effcy_indicator IS 'Efficiency indicator';
COMMENT ON COLUMN citydb.nrg8_conv_system.start_of_life IS 'Service life: Date of start of service';
COMMENT ON COLUMN citydb.nrg8_conv_system.life_expect_value IS 'Service life: Life expectancy';
COMMENT ON COLUMN citydb.nrg8_conv_system.life_expect_value_unit IS 'Life expectancy units of measure';
COMMENT ON COLUMN citydb.nrg8_conv_system.main_maint_interval IS 'Service life: Main maintenance time interval';
COMMENT ON COLUMN citydb.nrg8_conv_system.main_maint_interval_unit IS 'Time interval units of measure';
COMMENT ON COLUMN citydb.nrg8_conv_system.inst_in_ctyobj_id IS 'Implements +installed_in attribute in class EnergyConversionSystem';
COMMENT ON COLUMN citydb.nrg8_conv_system.cityobject_id IS 'Implements +energyConversionSystem attribute in class CityObject';

----------------------------------------------------------------
-- Table ENERGY_SOLAR_SYSTEM
----------------------------------------------------------------
DROP TABLE IF EXISTS citydb.nrg8_solar_system CASCADE;
CREATE TABLE IF NOT EXISTS citydb.nrg8_solar_system (
	id integer PRIMARY KEY, 			-- This is a foreign key to nrg8_conv_system.id
	objectclass_id integer NOT NULL, 	-- This is a foreign key to objectclass.id
	collector_type varchar,				-- This is a foreign key to lu_collector.id
	cell_type varchar,					-- This is a foreign key to lu_cell.id
	module_area numeric,
	module_area_unit varchar,
	aperture_area numeric,
	aperture_area_unit varchar,
	eta0 numeric CHECK (eta0 BETWEEN 0 AND 1),
	a1 numeric,
	a2 numeric,
	them_surf_id integer,				-- This is a foreign key to thematic_surface.id
	building_inst_id integer,			-- This is a foreign key to building_installation.id
	multi_surf_id integer, 				-- This is a foreign key to surface_geometry.id
	multi_surf_geom geometry(MULTIPOLYGONZ)
);
-- ALTER TABLE citydb.nrg8_solar_system OWNER TO postgres;

CREATE INDEX nrg8_solar_sys_objclass_id_fkx ON citydb.nrg8_solar_system USING btree (objectclass_id);
CREATE INDEX nrg8_solar_sys_collector_type_fkx ON citydb.nrg8_solar_system USING btree (collector_type);
CREATE INDEX nrg8_solar_sys_cell_type_fkx ON citydb.nrg8_solar_system USING btree (cell_type);
CREATE INDEX nrg8_solar_sys_multi_surf_id_fkx ON citydb.nrg8_solar_system USING btree (multi_surf_id);
CREATE INDEX nrg8_solar_sys_them_surf_id_fkx ON citydb.nrg8_solar_system USING btree (them_surf_id);
CREATE INDEX nrg8_solar_sys_bdg_inst_id_fkx ON citydb.nrg8_solar_system USING btree (building_inst_id);

COMMENT ON COLUMN citydb.nrg8_solar_system.objectclass_id IS 'Objectclass ID of the solar system';
COMMENT ON COLUMN citydb.nrg8_solar_system.collector_type IS 'Collector type';
COMMENT ON COLUMN citydb.nrg8_solar_system.cell_type IS 'Cell type';
COMMENT ON COLUMN citydb.nrg8_solar_system.module_area IS 'Module area';
COMMENT ON COLUMN citydb.nrg8_solar_system.module_area_unit IS 'Module area units of measure';
COMMENT ON COLUMN citydb.nrg8_solar_system.aperture_area IS 'Aperture area';
COMMENT ON COLUMN citydb.nrg8_solar_system.aperture_area_unit IS 'Aperture area units of measure';
COMMENT ON COLUMN citydb.nrg8_solar_system.eta0 IS 'Zero heat loss efficiency, values in [0,1]';
COMMENT ON COLUMN citydb.nrg8_solar_system.a1 IS 'Linear heat loss coefficient';
COMMENT ON COLUMN citydb.nrg8_solar_system.a2 IS 'Quadratic heat loss coefficient';
COMMENT ON COLUMN citydb.nrg8_solar_system.them_surf_id IS 'Implements attribute +installedOnBoundarySurface of class _SolarEnergySystem';
COMMENT ON COLUMN citydb.nrg8_solar_system.building_inst_id IS 'Implements attribute +installedOnBuildingIntallation of class _SolarEnergySystem';

----------------------------------------------------------------
-- Table BOILER
----------------------------------------------------------------
DROP TABLE IF EXISTS citydb.nrg8_boiler CASCADE;
CREATE TABLE IF NOT EXISTS citydb.nrg8_boiler (
	id integer PRIMARY KEY, 		-- This is a foreign key to nrg8_conv_system.id
	objectclass_id integer NOT NULL, -- This is a foreign key to objectclass.id
	condensation numeric(1,0)
);
-- ALTER TABLE citydb.nrg8_boiler OWNER TO postgres;

CREATE INDEX nrg8_boiler_objclass_id_fkx ON citydb.nrg8_boiler USING btree (objectclass_id);

COMMENT ON COLUMN citydb.nrg8_boiler.objectclass_id IS 'Objectclass ID of the boiler';
COMMENT ON COLUMN citydb.nrg8_boiler.condensation IS 'Condensation?';

----------------------------------------------------------------
-- Table HEAT_PUMP
----------------------------------------------------------------
DROP TABLE IF EXISTS citydb.nrg8_heat_pump CASCADE;
CREATE TABLE IF NOT EXISTS citydb.nrg8_heat_pump (
	id integer PRIMARY KEY, 	-- This is a foreign key to conv_system.id
	objectclass_id integer, 	-- This is a foreign key to objectclass.id
	heat_source varchar,		-- This is a foreign key to lu_heat_source.id
	cop_source_temp numeric,
	cop_source_temp_unit varchar,
	cop_oper_temp numeric,
	cop_oper_temp_unit varchar
);
-- ALTER TABLE citydb.nrg8_heat_pump OWNER TO postgres;

CREATE INDEX nrg8_heat_pump_objclass_id_fkx ON citydb.nrg8_heat_pump USING btree (objectclass_id);
CREATE INDEX nrg8_heat_pump_heat_source_fkx ON citydb.nrg8_heat_pump USING btree (heat_source);

COMMENT ON COLUMN citydb.nrg8_heat_pump.objectclass_id IS 'Objectclass ID of the heat_pump';
COMMENT ON COLUMN citydb.nrg8_heat_pump.heat_source IS 'Type of heat source';
COMMENT ON COLUMN citydb.nrg8_heat_pump.cop_source_temp IS 'COP source temperature';
COMMENT ON COLUMN citydb.nrg8_heat_pump.cop_source_temp_unit IS 'Temperature units of measure';
COMMENT ON COLUMN citydb.nrg8_heat_pump.cop_oper_temp IS 'COP operation temperature';
COMMENT ON COLUMN citydb.nrg8_heat_pump.cop_oper_temp_unit IS 'Temperature units of measure';

----------------------------------------------------------------
-- Table COMBINED_HEAT_POWER
----------------------------------------------------------------
DROP TABLE IF EXISTS citydb.nrg8_combined_heat_power CASCADE;
CREATE TABLE IF NOT EXISTS citydb.nrg8_combined_heat_power (
	id integer PRIMARY KEY, 			-- This is a foreign key to conv_system.id
	objectclass_id integer NOT NULL, 	-- This is a foreign key to objectclass.id
	techn_type varchar,
	therm_effcy numeric CHECK (therm_effcy BETWEEN 0 AND 1),
	electr_effcy numeric CHECK (electr_effcy BETWEEN 0 AND 1)
);
-- ALTER TABLE citydb.nrg8_combined_heat_power OWNER TO postgres;

CREATE INDEX nrg8_combined_heat_power_objclass_id_fkx ON citydb.nrg8_combined_heat_power USING btree (objectclass_id);

COMMENT ON COLUMN citydb.nrg8_combined_heat_power.objectclass_id IS 'Objectclass ID of the combined heat prower';
COMMENT ON COLUMN citydb.nrg8_combined_heat_power.techn_type IS 'Type of technology';
COMMENT ON COLUMN citydb.nrg8_combined_heat_power.therm_effcy IS 'Thermal efficiency factor, value in [0,1]';
COMMENT ON COLUMN citydb.nrg8_combined_heat_power.electr_effcy IS 'Electrical efficiency factor, value in [0,1]';

----------------------------------------------------------------
-- Table HEAT_EXCHANGER
----------------------------------------------------------------
DROP TABLE IF EXISTS citydb.nrg8_heat_exchanger CASCADE;
CREATE TABLE IF NOT EXISTS citydb.nrg8_heat_exchanger (
	id integer PRIMARY KEY, 			-- This is a foreign key to conv_system.id
	objectclass_id integer NOT NULL, 	-- This is a foreign key to objectclass.id
	network_id integer,    				-- Link to a UtilityNetwork CityObject
	network_node_id integer, 			-- Link to a UtilityNetwork CityObject
	prim_heat_supplier varchar
);
-- ALTER TABLE citydb.nrg8_heat_exchanger OWNER TO postgres;

CREATE INDEX nrg8_heat_exchanger_objclass_id_fkx ON citydb.nrg8_heat_exchanger USING btree (objectclass_id);
CREATE INDEX nrg8_heat_exchanger_network_id_fkx ON citydb.nrg8_heat_exchanger USING btree (network_id);
CREATE INDEX nrg8_heat_exchanger_network_node_id_fkx ON citydb.nrg8_heat_exchanger USING btree (network_node_id);

COMMENT ON COLUMN citydb.nrg8_heat_exchanger.objectclass_id IS 'Objectclass ID of the heat exchanger';
COMMENT ON COLUMN citydb.nrg8_heat_exchanger.network_id IS 'Network ID';
COMMENT ON COLUMN citydb.nrg8_heat_exchanger.network_node_id IS 'Network node ID';
COMMENT ON COLUMN citydb.nrg8_heat_exchanger.prim_heat_supplier IS 'Primary heat supplier';

----------------------------------------------------------------
-- Table MECHANICAL_VENTILATION
----------------------------------------------------------------
DROP TABLE IF EXISTS citydb.nrg8_mech_ventilation CASCADE;
CREATE TABLE IF NOT EXISTS citydb.nrg8_mech_ventilation (
	id integer PRIMARY KEY, 			-- This is a foreign key to conv_system.id
	objectclass_id integer NOT NULL,	-- This is a foreign key to objectclass.id
	heat_recovery numeric(1,0),
	recuperation numeric CHECK (recuperation BETWEEN 0 AND 1)
);
-- ALTER TABLE citydb.nrg8_mechanical_ventilation OWNER TO postgres;

CREATE INDEX nrg8_mech_ventilation_objclass_id_fkx ON citydb.nrg8_mech_ventilation USING btree (objectclass_id);

COMMENT ON COLUMN citydb.nrg8_mech_ventilation.objectclass_id IS 'Objectclass ID of the ventilation';
COMMENT ON COLUMN citydb.nrg8_mech_ventilation.heat_recovery IS 'Has heat recovery?';
COMMENT ON COLUMN citydb.nrg8_mech_ventilation.recuperation IS 'Recuperation factor, value in [0,1]';

----------------------------------------------------------------
-- Table CHILLER
----------------------------------------------------------------
DROP TABLE IF EXISTS citydb.nrg8_chiller CASCADE;
CREATE TABLE IF NOT EXISTS citydb.nrg8_chiller (
	id integer PRIMARY KEY, 			-- This is a foreign key to conv_system.id
	objectclass_id integer NOT NULL, 	-- This is a foreign key to objectclass.id
	condensation_type varchar, 			-- This is a foreign key to lu_condensation.id
	compressor_type varchar,			-- This is a foreign key to lu_compressor.id
	refrigerant varchar
);
-- ALTER TABLE citydb.nrg8_chiller OWNER TO postgres;

CREATE INDEX nrg8_chiller_objclass_id_fkx ON citydb.nrg8_chiller USING btree (objectclass_id);
CREATE INDEX nrg8_chiller_cond_type_fkx ON citydb.nrg8_chiller USING btree (condensation_type);
CREATE INDEX nrg8_chiller_compr_type_id_fkx ON citydb.nrg8_chiller USING btree (compressor_type);

COMMENT ON COLUMN citydb.nrg8_chiller.objectclass_id IS 'Objectclass ID of the chiller';
COMMENT ON COLUMN citydb.nrg8_chiller.condensation_type IS 'Type of condensation';
COMMENT ON COLUMN citydb.nrg8_chiller.compressor_type IS 'Type of compressor';
COMMENT ON COLUMN citydb.nrg8_chiller.refrigerant IS 'Refrigerant';

----------------------------------------------------------------
-- Table AIR_COMPRESSOR
----------------------------------------------------------------
DROP TABLE IF EXISTS citydb.nrg8_air_compressor CASCADE;
CREATE TABLE IF NOT EXISTS citydb.nrg8_air_compressor (
	id integer PRIMARY KEY, 			-- This is a foreign key to conv_system.id
	objectclass_id integer NOT NULL, 	-- This is a foreign key to objectclass.id
	compressor_type varchar NOT NULL,	-- This is a foreign key to lu_compressor.id
	pressure numeric,
	pressure_unit varchar
);
-- ALTER TABLE citydb.nrg8_air_compressor OWNER TO postgres;

CREATE INDEX nrg8_air_compr_objclass_id_fkx ON citydb.nrg8_air_compressor USING btree (objectclass_id);
CREATE INDEX nrg8_air_compr_compr_type_fkx ON citydb.nrg8_air_compressor USING btree (compressor_type);

COMMENT ON COLUMN citydb.nrg8_air_compressor.objectclass_id IS 'Objectclass ID of the air compressor';
COMMENT ON COLUMN citydb.nrg8_air_compressor.compressor_type IS 'Type of compressor';
COMMENT ON COLUMN citydb.nrg8_air_compressor.pressure IS 'Pressure';
COMMENT ON COLUMN citydb.nrg8_air_compressor.pressure_unit IS 'Pressure units of measure';


-- ADD FOREIGN KEY CONTRAINTS

-- FOREIGN KEY constraint on Table TIME_SERIES
ALTER TABLE IF EXISTS citydb.nrg8_time_series ADD CONSTRAINT nrg8_tseries_objclass_fk FOREIGN KEY (objectclass_id) REFERENCES citydb.objectclass (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;

ALTER TABLE IF EXISTS citydb.nrg8_time_series ADD CONSTRAINT nrg8_tseries_nrg_lu_acq_method_fk FOREIGN KEY (acquisition_method) REFERENCES citydb.nrg8_lu_acquisition_method (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;
ALTER TABLE IF EXISTS citydb.nrg8_time_series ADD CONSTRAINT nrg8_tseries_nrg_lu_interp_fk FOREIGN KEY (interpolation_type) REFERENCES citydb.nrg8_lu_interpolation (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;

-- FOREIGN KEY constraint on Table TIME_SERIES_FILE
ALTER TABLE IF EXISTS citydb.nrg8_time_series_file ADD CONSTRAINT nrg8_tseries_file_objclass_fk FOREIGN KEY (objectclass_id) REFERENCES citydb.objectclass (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;
ALTER TABLE IF EXISTS citydb.nrg8_time_series_file ADD CONSTRAINT nrg8_tseries_file_nrg_tseries_fk FOREIGN KEY (id) REFERENCES citydb.nrg8_time_series (id) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;

-- FOREIGN KEY constraint on Table SCHEDULE
ALTER TABLE IF EXISTS citydb.nrg8_schedule ADD CONSTRAINT nrg8_sched_objclass_fk FOREIGN KEY (objectclass_id) REFERENCES citydb.objectclass (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;
ALTER TABLE IF EXISTS citydb.nrg8_schedule ADD CONSTRAINT nrg8_sched_nrg_tseries_fk FOREIGN KEY (time_series_id) REFERENCES citydb.nrg8_time_series (id) MATCH FULL ON UPDATE CASCADE ON DELETE SET NULL;

-- FOREIGN KEY constraint on Table PERIOD_OF_YEAR
--ALTER TABLE IF EXISTS citydb.nrg8_period_of_year ADD CONSTRAINT nrg8_period_of_year_objclass_fk FOREIGN KEY (objectclass_id) REFERENCES citydb.objectclass (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;
ALTER TABLE IF EXISTS citydb.nrg8_period_of_year ADD CONSTRAINT nrg8_period_of_year_nrg_sched_fk FOREIGN KEY (sched_id) REFERENCES citydb.nrg8_schedule (id) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;

-- FOREIGN KEY constraint on Table DAILY_SCHEDULE
--ALTER TABLE IF EXISTS citydb.nrg8_daily_schedule ADD CONSTRAINT nrg8_daily_sched_objclass_fk FOREIGN KEY (objectclass_id) REFERENCES citydb.objectclass (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;
ALTER TABLE IF EXISTS citydb.nrg8_daily_schedule ADD CONSTRAINT nrg8_daily_sched_nrg_period_of_year_fk FOREIGN KEY (period_of_year_id) REFERENCES citydb.nrg8_period_of_year (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;
ALTER TABLE IF EXISTS citydb.nrg8_daily_schedule ADD CONSTRAINT nrg8_daily_sched_nrg_tseries_fk FOREIGN KEY (time_series_id) REFERENCES citydb.nrg8_time_series (id) MATCH FULL ON UPDATE CASCADE ON DELETE SET NULL;

ALTER TABLE IF EXISTS citydb.nrg8_daily_schedule ADD CONSTRAINT nrg8_daily_sched_nrg_lu_day_fk FOREIGN KEY (day_type) REFERENCES citydb.nrg8_lu_day (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;

-- FOREIGN KEY constraint on Table CITYOBJECT_TO_CONSTRUCTION
ALTER TABLE IF EXISTS citydb.nrg8_cityobject_to_constr ADD CONSTRAINT nrg8_ctyobj_nrg_constr_fk1 FOREIGN KEY (cityobject_id) REFERENCES citydb.cityobject (id) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE IF EXISTS citydb.nrg8_cityobject_to_constr ADD CONSTRAINT nrg8_ctyobj_nrg_constr_fk2 FOREIGN KEY (constr_id) REFERENCES citydb.nrg8_construction (id) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;

-- FOREIGN KEY constraint on Table CONSTRUCTION
ALTER TABLE IF EXISTS citydb.nrg8_construction ADD CONSTRAINT nrg8_constr_objclass_fk FOREIGN KEY (objectclass_id) REFERENCES citydb.objectclass (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;
ALTER TABLE IF EXISTS citydb.nrg8_construction ADD CONSTRAINT nrg8_constr_nrg_constr_fk FOREIGN KEY (base_constr_id) REFERENCES citydb.nrg8_construction (id) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;

-- FOREIGN KEY constraint on Table OPTICAL_PROPERTY
ALTER TABLE IF EXISTS citydb.nrg8_optical_property ADD CONSTRAINT nrg8_opt_prop_objclass_fk FOREIGN KEY (objectclass_id) REFERENCES citydb.objectclass (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;

ALTER TABLE IF EXISTS citydb.nrg8_optical_property ADD CONSTRAINT nrg8_opt_prop_nrg_constr_fk FOREIGN KEY (constr_id) REFERENCES citydb.nrg8_construction (id) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE IF EXISTS citydb.nrg8_optical_property ADD CONSTRAINT nrg8_opt_prop_nrg_lu_range_fk FOREIGN KEY (range) REFERENCES citydb.nrg8_lu_wavelength_range (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;
ALTER TABLE IF EXISTS citydb.nrg8_optical_property ADD CONSTRAINT nrg8_opt_prop_nrg_lu_surf_side_fk FOREIGN KEY (surf_side) REFERENCES citydb.nrg8_lu_surface_side (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;

-- FOREIGN KEY constraint on Table LAYER
ALTER TABLE IF EXISTS citydb.nrg8_layer ADD CONSTRAINT nrg8_layer_objclass_fk FOREIGN KEY (objectclass_id) REFERENCES citydb.objectclass (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;
ALTER TABLE IF EXISTS citydb.nrg8_layer ADD CONSTRAINT nrg8_layer_nrg_constr_fk FOREIGN KEY (constr_id) REFERENCES citydb.nrg8_construction (id) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;

-- FOREIGN KEY constraint on Table LAYER_COMPONENT
ALTER TABLE IF EXISTS citydb.nrg8_layer_component ADD CONSTRAINT nrg8_layer_comp_objclass_fk FOREIGN KEY (objectclass_id) REFERENCES citydb.objectclass (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;
ALTER TABLE IF EXISTS citydb.nrg8_layer_component ADD CONSTRAINT nrg8_layer_comp_nrg_layer_fk FOREIGN KEY (layer_id) REFERENCES citydb.nrg8_layer (id) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;

-- FOREIGN KEY constraint on Table MATERIAL
ALTER TABLE IF EXISTS citydb.nrg8_material ADD CONSTRAINT nrg8_material_objclass_fk FOREIGN KEY (objectclass_id) REFERENCES citydb.objectclass (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;
ALTER TABLE IF EXISTS citydb.nrg8_material ADD CONSTRAINT nrg8_material_nrg_layer_comp_fk FOREIGN KEY (layer_component_id) REFERENCES citydb.nrg8_layer_component (id) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;

-- FOREIGN KEY constraint on Table DIMENSINAL ATTRIB
ALTER TABLE IF EXISTS citydb.nrg8_dimensional_attrib ADD CONSTRAINT nrg8_dim_attrib_objclass_fk FOREIGN KEY (objectclass_id) REFERENCES citydb.objectclass (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;
ALTER TABLE IF EXISTS citydb.nrg8_dimensional_attrib ADD CONSTRAINT nrg8_dim_attrib_ctyobj_fk FOREIGN KEY (cityobject_id) REFERENCES citydb.cityobject (id) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE IF EXISTS citydb.nrg8_dimensional_attrib ADD CONSTRAINT nrg8_dim_attrib_nrg_lu_dim_attrib_fk FOREIGN KEY (type) REFERENCES citydb.nrg8_lu_dimensional_attrib (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;

-- FOREIGN KEY constraint on Table ENERGY_PERFORMANCE_CERTIFICATION
ALTER TABLE IF EXISTS citydb.nrg8_perf_certification ADD CONSTRAINT nrg8_perf_cert_nrg_bdg_fk FOREIGN KEY (building_id) REFERENCES citydb.nrg8_building (id) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE IF EXISTS citydb.nrg8_perf_certification ADD CONSTRAINT nrg8_perf_cert_nrg_bdg_unit_fk FOREIGN KEY (building_unit_id) REFERENCES citydb.nrg8_building_unit (id) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;

-- FOREIGN KEY constraint on Table REFURBISHMENT_MEASURE
ALTER TABLE IF EXISTS citydb.nrg8_refurbishment_measure ADD CONSTRAINT nrg8_refurb_meas_nrg_bdg_fk FOREIGN KEY (building_id) REFERENCES citydb.nrg8_building (id) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE IF EXISTS citydb.nrg8_refurbishment_measure ADD CONSTRAINT nrg8_refurb_meas_nrg_therm_bdry_fk FOREIGN KEY (therm_boundary_id) REFERENCES citydb.nrg8_thermal_boundary (id) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE IF EXISTS citydb.nrg8_refurbishment_measure ADD CONSTRAINT nrg8_refurb_meas_nrg_lu_ref_class_fk FOREIGN KEY (level) REFERENCES citydb.nrg8_lu_refurbishment_class (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;

-- FOREIGN KEY constraint on Table WEATHER_STATION
ALTER TABLE IF EXISTS citydb.nrg8_weather_station ADD CONSTRAINT nrg8_weather_station_objclass_fk FOREIGN KEY (objectclass_id) REFERENCES citydb.objectclass (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;
ALTER TABLE IF EXISTS citydb.nrg8_weather_station ADD CONSTRAINT nrg8_weather_station_ctyobj_fk1 FOREIGN KEY (id) REFERENCES citydb.cityobject (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;
ALTER TABLE IF EXISTS citydb.nrg8_weather_station ADD CONSTRAINT nrg8_weather_station_ctyobj_fk2 FOREIGN KEY (cityobject_id) REFERENCES citydb.cityobject (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;

-- FOREIGN KEY constraint on Table WEATHER_DATA
--ALTER TABLE IF EXISTS citydb.nrg8_weather_data ADD CONSTRAINT nrg8_weather_data_objclass_fk FOREIGN KEY (objectclass_id) REFERENCES citydb.objectclass (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;
ALTER TABLE IF EXISTS citydb.nrg8_weather_data ADD CONSTRAINT nrg8_weather_data_ctyobj_fk FOREIGN KEY (cityobject_id) REFERENCES citydb.cityobject (id) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE IF EXISTS citydb.nrg8_weather_data ADD CONSTRAINT nrg8_weather_data_nrg_tseries_fk FOREIGN KEY (time_series_id) REFERENCES citydb.nrg8_time_series (id) MATCH FULL ON UPDATE CASCADE ON DELETE SET NULL;

ALTER TABLE IF EXISTS citydb.nrg8_weather_data ADD CONSTRAINT nrg8_weather_data_nrg_lu_weather_data_fk FOREIGN KEY (type) REFERENCES citydb.nrg8_lu_weather_data (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;

-- FOREIGN KEY constraint on Table nrg8_BUILDING
ALTER TABLE IF EXISTS citydb.nrg8_building ADD CONSTRAINT nrg8_bdg_objclass_fk FOREIGN KEY (objectclass_id) REFERENCES citydb.objectclass (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;
ALTER TABLE IF EXISTS citydb.nrg8_building ADD CONSTRAINT nrg8_bdg_bdg_fk FOREIGN KEY (id) REFERENCES citydb.building (id) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE IF EXISTS citydb.nrg8_building ADD CONSTRAINT nrg8_bdg_nrg_lu_constr_weight_fk FOREIGN KEY (constr_weight) REFERENCES citydb.nrg8_lu_construction_weight (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;

-- FOREIGN KEY constraint on Table THERMAL_ZONE
ALTER TABLE IF EXISTS citydb.nrg8_thermal_zone ADD CONSTRAINT nrg8_therm_zone_objclass_fk FOREIGN KEY (objectclass_id) REFERENCES citydb.objectclass (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;
ALTER TABLE IF EXISTS citydb.nrg8_thermal_zone ADD CONSTRAINT nrg8_therm_zone_ctyobj_fk FOREIGN KEY (id) REFERENCES citydb.cityobject (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;
ALTER TABLE IF EXISTS citydb.nrg8_thermal_zone ADD CONSTRAINT nrg8_therm_zone_nrg_bdg_fk FOREIGN KEY (building_id) REFERENCES citydb.nrg8_building (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;
ALTER TABLE IF EXISTS citydb.nrg8_thermal_zone ADD CONSTRAINT nrg8_therm_zone_surf_geom_fk FOREIGN KEY (solid_id) REFERENCES citydb.surface_geometry (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;

-- FOREIGN KEY constraint on Table THERMAL_ZONE_TO_ROOM
ALTER TABLE IF EXISTS citydb.nrg8_thermal_zone_to_room ADD CONSTRAINT nrg8_therm_zone_room_fk1 FOREIGN KEY (therm_zone_id) REFERENCES citydb.nrg8_thermal_zone (id) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE IF EXISTS citydb.nrg8_thermal_zone_to_room ADD CONSTRAINT nrg8_therm_zone_room_fk2 FOREIGN KEY (room_id) REFERENCES citydb.room (id) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;

-- FOREIGN KEY constraint on Table THERMAL_BOUNDARY
ALTER TABLE IF EXISTS citydb.nrg8_thermal_boundary ADD CONSTRAINT nrg8_therm_bdry_objclass_fk FOREIGN KEY (objectclass_id) REFERENCES citydb.objectclass (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;
ALTER TABLE IF EXISTS citydb.nrg8_thermal_boundary ADD CONSTRAINT nrg8_therm_bdry_ctyobj_fk FOREIGN KEY (id) REFERENCES citydb.cityobject (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;
ALTER TABLE IF EXISTS citydb.nrg8_thermal_boundary ADD CONSTRAINT nrg8_therm_bdry_nrg_therm_zone_fk1 FOREIGN KEY (therm_zone1_id) REFERENCES citydb.nrg8_thermal_zone (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;
ALTER TABLE IF EXISTS citydb.nrg8_thermal_boundary ADD CONSTRAINT nrg8_therm_bdry_nrg_therm_zone_fk2 FOREIGN KEY (therm_zone2_id) REFERENCES citydb.nrg8_thermal_zone (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;
ALTER TABLE IF EXISTS citydb.nrg8_thermal_boundary ADD CONSTRAINT nrg8_therm_bdry_surf_geom_fk FOREIGN KEY (multi_surf_id) REFERENCES citydb.surface_geometry (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;

ALTER TABLE IF EXISTS citydb.nrg8_thermal_boundary ADD CONSTRAINT nrg8_therm_bdry_nrg_lu_therm_bdry_fk FOREIGN KEY (type) REFERENCES citydb.nrg8_lu_thermal_boundary (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;

-- FOREIGN KEY constraint on Table THERMAL_BOUNDARY_TO_THEMATIC_SURFACE
ALTER TABLE IF EXISTS citydb.nrg8_therm_bdry_to_them_surf ADD CONSTRAINT nrg8_therm_bdry_to_them_surf_fk1 FOREIGN KEY (therm_boundary_id) REFERENCES citydb.nrg8_thermal_boundary (id) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE IF EXISTS citydb.nrg8_therm_bdry_to_them_surf ADD CONSTRAINT nrg8_therm_bdry_to_them_surf_fk2 FOREIGN KEY (them_surf_id) REFERENCES citydb.thematic_surface (id) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;

-- FOREIGN KEY constraint on Table THERMAL_OPENING
ALTER TABLE IF EXISTS citydb.nrg8_thermal_opening ADD CONSTRAINT nrg8_therm_open_objclass_fk FOREIGN KEY (objectclass_id) REFERENCES citydb.objectclass (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;
ALTER TABLE IF EXISTS citydb.nrg8_thermal_opening ADD CONSTRAINT nrg8_therm_open_ctyobj_fk FOREIGN KEY (id) REFERENCES citydb.cityobject (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;
ALTER TABLE IF EXISTS citydb.nrg8_thermal_opening ADD CONSTRAINT nrg8_therm_open_nrg_therm_bdry_fk FOREIGN KEY (therm_boundary_id) REFERENCES citydb.nrg8_thermal_boundary (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;
ALTER TABLE IF EXISTS citydb.nrg8_thermal_opening ADD CONSTRAINT nrg8_therm_open_surf_geom_fk FOREIGN KEY (multi_surf_id) REFERENCES citydb.surface_geometry (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;

-- FOREIGN KEY constraint on Table THERMAL_OPENING_TO_OPENING
ALTER TABLE IF EXISTS citydb.nrg8_therm_open_to_open ADD CONSTRAINT nrg8_therm_open_to_open_fk1 FOREIGN KEY (therm_opening_id) REFERENCES citydb.nrg8_thermal_opening (id) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE IF EXISTS citydb.nrg8_therm_open_to_open ADD CONSTRAINT nrg8_therm_open_to_open_fk2 FOREIGN KEY (opening_id) REFERENCES citydb.opening (id) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;

-- FOREIGN KEY constraint on Table USAGE_ZONE
ALTER TABLE IF EXISTS citydb.nrg8_usage_zone ADD CONSTRAINT nrg8_usage_zone_objclass_fk FOREIGN KEY (objectclass_id) REFERENCES citydb.objectclass (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;
ALTER TABLE IF EXISTS citydb.nrg8_usage_zone ADD CONSTRAINT nrg8_usage_zone_ctyobj_fk FOREIGN KEY (id) REFERENCES citydb.cityobject (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;
ALTER TABLE IF EXISTS citydb.nrg8_usage_zone ADD CONSTRAINT nrg8_usage_zone_nrg_therm_zone_fk FOREIGN KEY (therm_zone_id) REFERENCES citydb.nrg8_thermal_zone (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;
ALTER TABLE IF EXISTS citydb.nrg8_usage_zone ADD CONSTRAINT nrg8_usage_zone_nrg_bdg_fk FOREIGN KEY (building_id) REFERENCES citydb.nrg8_building (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;
ALTER TABLE IF EXISTS citydb.nrg8_usage_zone ADD CONSTRAINT nrg8_usage_zone_surf_geom_fk FOREIGN KEY (solid_id) REFERENCES citydb.surface_geometry (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;
ALTER TABLE IF EXISTS citydb.nrg8_usage_zone ADD CONSTRAINT nrg8_usage_zone_nrg_sched_fk1 FOREIGN KEY (heat_sched_id) REFERENCES citydb.nrg8_schedule (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;
ALTER TABLE IF EXISTS citydb.nrg8_usage_zone ADD CONSTRAINT nrg8_usage_zone_nrg_sched_fk2 FOREIGN KEY (cool_sched_id) REFERENCES citydb.nrg8_schedule (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;
ALTER TABLE IF EXISTS citydb.nrg8_usage_zone ADD CONSTRAINT nrg8_usage_zone_nrg_sched_fk3 FOREIGN KEY (vent_sched_id) REFERENCES citydb.nrg8_schedule (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;

-- FOREIGN KEY constraint on Table BUILDING_UNIT
ALTER TABLE IF EXISTS citydb.nrg8_building_unit ADD CONSTRAINT nrg8_bdg_unit_objclass_fk FOREIGN KEY (objectclass_id) REFERENCES citydb.objectclass (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;
ALTER TABLE IF EXISTS citydb.nrg8_building_unit ADD CONSTRAINT nrg8_bdg_unit_ctyobj_fk FOREIGN KEY (id) REFERENCES citydb.cityobject (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;
ALTER TABLE IF EXISTS citydb.nrg8_building_unit ADD CONSTRAINT nrg8_bdg_unit_nrg_usage_zone_fk FOREIGN KEY (usage_zone_id) REFERENCES citydb.nrg8_usage_zone (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;

ALTER TABLE IF EXISTS citydb.nrg8_building_unit ADD CONSTRAINT nrg8_bdg_unit_nrg_lu_ownership_fk FOREIGN KEY (ownership_type) REFERENCES citydb.nrg8_lu_ownership (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;

-- FOREIGN KEY constraint on Table BUILDING_UNIT_TO_ADDRESS
ALTER TABLE IF EXISTS citydb.nrg8_bdg_unit_to_address ADD CONSTRAINT nrg8_bdg_unit_to_address_fk1 FOREIGN KEY (building_unit_id) REFERENCES citydb.nrg8_building_unit (id) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE IF EXISTS citydb.nrg8_bdg_unit_to_address ADD CONSTRAINT nrg8_bdg_unit_to_address_fk2 FOREIGN KEY (address_id) REFERENCES citydb.address (id) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;

-- FOREIGN KEY constraint on Table OCCUPANTS
ALTER TABLE IF EXISTS citydb.nrg8_occupants ADD CONSTRAINT nrg8_occup_objclass_fk FOREIGN KEY (objectclass_id) REFERENCES citydb.objectclass (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;
ALTER TABLE IF EXISTS citydb.nrg8_occupants ADD CONSTRAINT nrg8_occup_nrg_bdg_unit_fk FOREIGN KEY (building_unit_id) REFERENCES citydb.nrg8_building_unit (id) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE IF EXISTS citydb.nrg8_occupants ADD CONSTRAINT nrg8_occup_nrg_usage_zone_fk FOREIGN KEY (usage_zone_id) REFERENCES citydb.nrg8_usage_zone (id) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE IF EXISTS citydb.nrg8_occupants ADD CONSTRAINT nrg8_occup_nrg_sched_fk FOREIGN KEY (sched_id) REFERENCES citydb.nrg8_schedule (id) MATCH FULL ON UPDATE CASCADE ON DELETE SET NULL;

ALTER TABLE IF EXISTS citydb.nrg8_occupants ADD CONSTRAINT nrg8_occup_nrg_lu_occup_fk FOREIGN KEY (type) REFERENCES citydb.nrg8_lu_occupants (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;

-- FOREIGN KEY constraint on Table HOUSEHOLD
ALTER TABLE IF EXISTS citydb.nrg8_household ADD CONSTRAINT nrg8_household_objclass_fk FOREIGN KEY (objectclass_id) REFERENCES citydb.objectclass (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;
ALTER TABLE IF EXISTS citydb.nrg8_household ADD CONSTRAINT nrg8_household_nrg_occup_fk FOREIGN KEY (occupants_id) REFERENCES citydb.nrg8_occupants (id) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE IF EXISTS citydb.nrg8_household ADD CONSTRAINT nrg8_household_nrg_lu_household_fk FOREIGN KEY (type) REFERENCES citydb.nrg8_lu_household (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;
ALTER TABLE IF EXISTS citydb.nrg8_household ADD CONSTRAINT nrg8_household_nrg_lu_residence_fk FOREIGN KEY (residence_type) REFERENCES citydb.nrg8_lu_residence (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;

-- FOREIGN KEY constraint on Table FACILITIES
ALTER TABLE IF EXISTS citydb.nrg8_facilities ADD CONSTRAINT nrg8_fac_objclass_fk FOREIGN KEY (objectclass_id) REFERENCES citydb.objectclass (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;
ALTER TABLE IF EXISTS citydb.nrg8_facilities ADD CONSTRAINT nrg8_fac_ctyobj_fk FOREIGN KEY (id) REFERENCES citydb.cityobject (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;
ALTER TABLE IF EXISTS citydb.nrg8_facilities ADD CONSTRAINT nrg8_fac_nrg_bdg_unit_fk FOREIGN KEY (building_unit_id) REFERENCES citydb.nrg8_building_unit (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;
ALTER TABLE IF EXISTS citydb.nrg8_facilities ADD CONSTRAINT nrg8_fac_nrg_usage_zone_fk FOREIGN KEY (usage_zone_id) REFERENCES citydb.nrg8_usage_zone (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;
ALTER TABLE IF EXISTS citydb.nrg8_facilities ADD CONSTRAINT nrg8_fac_nrg_sched_fk FOREIGN KEY (oper_sched_id) REFERENCES citydb.nrg8_schedule (id) MATCH FULL ON UPDATE CASCADE ON DELETE SET NULL;

-- FOREIGN KEY constraint on Table ENERGY_DEMAND
ALTER TABLE IF EXISTS citydb.nrg8_energy_demand ADD CONSTRAINT nrg8_demand_objclass_fk FOREIGN KEY (objectclass_id) REFERENCES citydb.objectclass (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;
ALTER TABLE IF EXISTS citydb.nrg8_energy_demand ADD CONSTRAINT nrg8_demand_ctyobj_fk FOREIGN KEY (cityobject_id) REFERENCES citydb.cityobject (id) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE IF EXISTS citydb.nrg8_energy_demand ADD CONSTRAINT nrg8_demand_nrg_tseries_fk FOREIGN KEY (time_series_id) REFERENCES citydb.nrg8_time_series (id) MATCH FULL ON UPDATE CASCADE ON DELETE SET NULL;

ALTER TABLE IF EXISTS citydb.nrg8_energy_demand ADD CONSTRAINT nrg8_demand_nrg_lu_end_use_fk FOREIGN KEY (end_use) REFERENCES citydb.nrg8_lu_end_use (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;

-- FOREIGN KEY constraint on Table FINAL_ENERGY
ALTER TABLE IF EXISTS citydb.nrg8_final_energy ADD CONSTRAINT nrg8_final_nrg_objclass_fk FOREIGN KEY (objectclass_id) REFERENCES citydb.objectclass (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;
ALTER TABLE IF EXISTS citydb.nrg8_final_energy ADD CONSTRAINT nrg8_final_nrg_tseries_fk FOREIGN KEY (time_series_id) REFERENCES citydb.nrg8_time_series (id) MATCH FULL ON UPDATE CASCADE ON DELETE SET NULL;

ALTER TABLE IF EXISTS citydb.nrg8_final_energy ADD CONSTRAINT nrg8_final_nrg_lu_nrg_source_fk FOREIGN KEY (nrg_car_type) REFERENCES citydb.nrg8_lu_energy_source (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;

-- FOREIGN KEY constraint on Table ENERGY_CONV_SYSTEM_TO_FINAL_ENERGY
ALTER TABLE IF EXISTS citydb.nrg8_conv_sys_to_final_nrg ADD CONSTRAINT nrg8_conv_sys_to_final_nrg_nrg_conv_sys_fk FOREIGN KEY (conv_system_id) REFERENCES citydb.nrg8_conv_system (id) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE IF EXISTS citydb.nrg8_conv_sys_to_final_nrg ADD CONSTRAINT nrg8_conv_sys_to_final_nrg_nrg_final_nrg_fk FOREIGN KEY (final_nrg_id) REFERENCES citydb.nrg8_final_energy (id) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;

-- FOREIGN KEY constraint on Table ENERGY_CONV_SYSTEM_TO_ENERGY_DEMAND
ALTER TABLE IF EXISTS citydb.nrg8_conv_sys_to_nrg_demand ADD CONSTRAINT nrg8_conv_sys_to_nrg_demand_nrg_conv_sys_fk FOREIGN KEY (conv_system_id) REFERENCES citydb.nrg8_conv_system (id) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE IF EXISTS citydb.nrg8_conv_sys_to_nrg_demand ADD CONSTRAINT nrg8_conv_sys_to_nrg_demand_nrg_demand_fk FOREIGN KEY (nrg_demand_id) REFERENCES citydb.nrg8_energy_demand (id) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;

-- FOREIGN KEY constraint on Table EMITTER
ALTER TABLE IF EXISTS citydb.nrg8_emitter ADD CONSTRAINT nrg8_emitter_objclass_fk FOREIGN KEY (objectclass_id) REFERENCES citydb.objectclass (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;
ALTER TABLE IF EXISTS citydb.nrg8_emitter ADD CONSTRAINT nrg8_emitter_ctyobj_fk1 FOREIGN KEY (id) REFERENCES citydb.cityobject (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;
ALTER TABLE IF EXISTS citydb.nrg8_emitter ADD CONSTRAINT nrg8_emitter_ctyobj_fk2 FOREIGN KEY (cityobject_id) REFERENCES citydb.cityobject (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;
ALTER TABLE IF EXISTS citydb.nrg8_emitter ADD CONSTRAINT nrg8_emitter_nrg_distr_sys_fk FOREIGN KEY (distr_system_id) REFERENCES citydb.nrg8_distrib_system (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;




ALTER TABLE IF EXISTS citydb.nrg8_emitter ADD CONSTRAINT nrg8_emitter_nrg_lu_emitter_fk FOREIGN KEY (type) REFERENCES citydb.nrg8_lu_emitter (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;

-- FOREIGN KEY constraint on Table ENERGY_DISTRIB_SYSTEM
ALTER TABLE IF EXISTS citydb.nrg8_distrib_system ADD CONSTRAINT nrg8_distr_sys_objcl_fk FOREIGN KEY (objectclass_id) REFERENCES citydb.objectclass (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;
ALTER TABLE IF EXISTS citydb.nrg8_distrib_system ADD CONSTRAINT nrg8_distr_sys_ctyobj_fk1 FOREIGN KEY (id) REFERENCES citydb.cityobject (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;
ALTER TABLE IF EXISTS citydb.nrg8_distrib_system ADD CONSTRAINT nrg8_distr_sys_ctyobj_fk2 FOREIGN KEY (cityobject_id) REFERENCES citydb.cityobject (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;
ALTER TABLE IF EXISTS citydb.nrg8_distrib_system ADD CONSTRAINT nrg8_distr_sys_nrg_demand_fk FOREIGN KEY (nrg_demand_id) REFERENCES citydb.nrg8_energy_demand (id) MATCH FULL ON UPDATE CASCADE ON DELETE SET NULL;

ALTER TABLE IF EXISTS citydb.nrg8_distrib_system ADD CONSTRAINT nrg8_distr_sys_nrg_lu_distrib_fk FOREIGN KEY (distrib_perim) REFERENCES citydb.nrg8_lu_distribution (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;

-- FOREIGN KEY constraint on Table ENERGY_THERMAL_DISTRIB_SYSTEM
ALTER TABLE IF EXISTS citydb.nrg8_thermal_distrib_system ADD CONSTRAINT nrg8_therm_distr_sys_objcl_fk FOREIGN KEY (objectclass_id) REFERENCES citydb.objectclass (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;
ALTER TABLE IF EXISTS citydb.nrg8_thermal_distrib_system ADD CONSTRAINT nrg8_therm_distr_sys_nrg_distr_sys_fk FOREIGN KEY (id) REFERENCES citydb.nrg8_distrib_system (id) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE IF EXISTS citydb.nrg8_thermal_distrib_system ADD CONSTRAINT nrg8_therm_distr_sys_nrg_lu_medium_fk FOREIGN KEY (medium) REFERENCES citydb.nrg8_lu_medium (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;

-- FOREIGN KEY constraint on Table ENERGY_POWER_DISTRIB_SYSTEM
ALTER TABLE IF EXISTS citydb.nrg8_power_distrib_system ADD CONSTRAINT nrg8_pwr_distr_sys_objcl_fk FOREIGN KEY (objectclass_id) REFERENCES citydb.objectclass (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;
ALTER TABLE IF EXISTS citydb.nrg8_power_distrib_system ADD CONSTRAINT nrg8_pwr_distr_sys_nrg_distr_sys_fk FOREIGN KEY (id) REFERENCES citydb.nrg8_distrib_system (id) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;

-- FOREIGN KEY constraint on Table ENERGY_STORAGE_SYSTEM
ALTER TABLE IF EXISTS citydb.nrg8_storage_system ADD CONSTRAINT nrg8_stor_sys_objcl_fk FOREIGN KEY (objectclass_id) REFERENCES citydb.objectclass (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;
ALTER TABLE IF EXISTS citydb.nrg8_storage_system ADD CONSTRAINT nrg8_stor_sys_ctyobj_fk1 FOREIGN KEY (id) REFERENCES citydb.cityobject (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;
ALTER TABLE IF EXISTS citydb.nrg8_storage_system ADD CONSTRAINT nrg8_stor_sys_ctyobj_fk2 FOREIGN KEY (cityobject_id) REFERENCES citydb.cityobject (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;
ALTER TABLE IF EXISTS citydb.nrg8_storage_system ADD CONSTRAINT nrg8_stor_sys_nrg_demand_fk FOREIGN KEY (nrg_demand_id) REFERENCES citydb.nrg8_energy_demand (id) MATCH FULL ON UPDATE CASCADE ON DELETE SET NULL;


-- FOREIGN KEY constraint on Table ENERGY_POWER_STORAGE_SYSTEM
ALTER TABLE IF EXISTS citydb.nrg8_power_storage_system ADD CONSTRAINT nrg8_pwr_stor_sys_objcl_fk FOREIGN KEY (objectclass_id) REFERENCES citydb.objectclass (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;
ALTER TABLE IF EXISTS citydb.nrg8_power_storage_system ADD CONSTRAINT nrg8_pwr_stor_sys_nrg_stor_sys_fk FOREIGN KEY (id) REFERENCES citydb.nrg8_storage_system (id) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;

-- FOREIGN KEY constraint on Table ENERGY_THERMAL_STORAGE_SYSTEM
ALTER TABLE IF EXISTS citydb.nrg8_thermal_storage_system ADD CONSTRAINT nrg8_therm_stor_sys_objcl_fk FOREIGN KEY (objectclass_id) REFERENCES citydb.objectclass (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;
ALTER TABLE IF EXISTS citydb.nrg8_thermal_storage_system ADD CONSTRAINT nrg8_therm_stor_sys_nrg_stor_sys_fk FOREIGN KEY (id) REFERENCES citydb.nrg8_storage_system (id) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE IF EXISTS citydb.nrg8_thermal_storage_system ADD CONSTRAINT nrg8_therm_stor_sys_nrg_lu_medium_fk FOREIGN KEY (medium) REFERENCES citydb.nrg8_lu_medium (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;

-- FOREIGN KEY constraint on Table SYSTEM_OPERATION
ALTER TABLE IF EXISTS citydb.nrg8_system_operation ADD CONSTRAINT nrg8_sys_oper_objcl_fk FOREIGN KEY (objectclass_id) REFERENCES citydb.objectclass (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;
ALTER TABLE IF EXISTS citydb.nrg8_system_operation ADD CONSTRAINT nrg8_sys_oper_nrg_sched_fk FOREIGN KEY (sched_id) REFERENCES citydb.nrg8_schedule (id) MATCH FULL ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE IF EXISTS citydb.nrg8_system_operation ADD CONSTRAINT nrg8_sys_oper_nrg_conv_sys_fk FOREIGN KEY (nrg_conv_system_id) REFERENCES citydb.nrg8_conv_system (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;

ALTER TABLE IF EXISTS citydb.nrg8_system_operation ADD CONSTRAINT nrg8_sys_oper_nrg_lu_end_use_fk FOREIGN KEY (end_use) REFERENCES citydb.nrg8_lu_end_use (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;

-- FOREIGN KEY constraint on Table ENERGY_CONV_SYSTEM
ALTER TABLE IF EXISTS citydb.nrg8_conv_system ADD CONSTRAINT nrg8_conv_sys_ctyobj_fk1 FOREIGN KEY (id) REFERENCES citydb.cityobject (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;
ALTER TABLE IF EXISTS citydb.nrg8_conv_system ADD CONSTRAINT nrg8_conv_sys_ctyobj_fk2 FOREIGN KEY (cityobject_id) REFERENCES citydb.cityobject (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;
ALTER TABLE IF EXISTS citydb.nrg8_conv_system ADD CONSTRAINT nrg8_conv_sys_ctyobj_fk3 FOREIGN KEY (inst_in_ctyobj_id) REFERENCES citydb.cityobject (id) MATCH FULL ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE IF EXISTS citydb.nrg8_conv_system ADD CONSTRAINT nrg8_conv_sys_objclass_fk FOREIGN KEY (objectclass_id) REFERENCES citydb.objectclass (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;

-- FOREIGN KEY constraint on Table ENERGY_SOLAR_SYSTEM
ALTER TABLE IF EXISTS citydb.nrg8_solar_system ADD CONSTRAINT nrg8_solar_sys_nrg_conv_sys_fk FOREIGN KEY (id) REFERENCES citydb.nrg8_conv_system (id) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE IF EXISTS citydb.nrg8_solar_system ADD CONSTRAINT nrg8_solar_sys_objclass_fk FOREIGN KEY (objectclass_id) REFERENCES citydb.objectclass (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;
ALTER TABLE IF EXISTS citydb.nrg8_solar_system ADD CONSTRAINT nrg8_solar_sys_surf_geom_fk FOREIGN KEY (multi_surf_id) REFERENCES citydb.surface_geometry (id) MATCH FULL ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE IF EXISTS citydb.nrg8_solar_system ADD CONSTRAINT nrg8_solar_sys_them_surf_fk FOREIGN KEY (them_surf_id) REFERENCES citydb.thematic_surface (id) MATCH FULL ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE IF EXISTS citydb.nrg8_solar_system ADD CONSTRAINT nrg8_solar_sys_bdg_inst_fk FOREIGN KEY (building_inst_id) REFERENCES citydb.building_installation (id) MATCH FULL ON UPDATE CASCADE ON DELETE SET NULL;

ALTER TABLE IF EXISTS citydb.nrg8_solar_system ADD CONSTRAINT nrg8_solar_sys_nrg_lu_collector_fk FOREIGN KEY (collector_type) REFERENCES citydb.nrg8_lu_collector (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;
ALTER TABLE IF EXISTS citydb.nrg8_solar_system ADD CONSTRAINT nrg8_solar_sys_nrg_lu_cell_fk FOREIGN KEY (cell_type) REFERENCES citydb.nrg8_lu_cell (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;

-- FOREIGN KEY constraint on Table BOILER
ALTER TABLE IF EXISTS citydb.nrg8_boiler ADD CONSTRAINT nrg8_boiler_objclass_fk FOREIGN KEY (objectclass_id) REFERENCES citydb.objectclass (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;
ALTER TABLE IF EXISTS citydb.nrg8_boiler ADD CONSTRAINT nrg8_boiler_nrg_conv_sys_fk FOREIGN KEY (id) REFERENCES citydb.nrg8_conv_system (id) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;

-- FOREIGN KEY constraint on Table HEAT_PUMP
ALTER TABLE IF EXISTS citydb.nrg8_heat_pump ADD CONSTRAINT nrg8_heat_pump_objclass_fk FOREIGN KEY (objectclass_id) REFERENCES citydb.objectclass (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;
ALTER TABLE IF EXISTS citydb.nrg8_heat_pump ADD CONSTRAINT nrg8_heat_pump_nrg_conv_sys_fk FOREIGN KEY (id) REFERENCES citydb.nrg8_conv_system (id) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE IF EXISTS citydb.nrg8_heat_pump ADD CONSTRAINT nrg8_heat_pump_nrg_lu_heat_source_fk FOREIGN KEY (heat_source) REFERENCES citydb.nrg8_lu_heat_source (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;

-- FOREIGN KEY constraint on Table COMBINED_HEAT_POWER
ALTER TABLE IF EXISTS citydb.nrg8_combined_heat_power ADD CONSTRAINT nrg8_comb_heat_pwr_objclass_fk FOREIGN KEY (objectclass_id) REFERENCES citydb.objectclass (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;
ALTER TABLE IF EXISTS citydb.nrg8_combined_heat_power ADD CONSTRAINT nrg8_comb_heat_pwr_nrg_conv_sys_fk FOREIGN KEY (id) REFERENCES citydb.nrg8_conv_system (id) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;

-- FOREIGN KEY constraint on Table HEAT_EXCHANGER
ALTER TABLE IF EXISTS citydb.nrg8_heat_exchanger ADD CONSTRAINT nrg8_heat_exch_objclass_fk FOREIGN KEY (objectclass_id) REFERENCES citydb.objectclass (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;
ALTER TABLE IF EXISTS citydb.nrg8_heat_exchanger ADD CONSTRAINT nrg8_heat_exch_nrg_conv_sys_fk FOREIGN KEY (id) REFERENCES citydb.nrg8_conv_system (id) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;

-- FOREIGN KEY constraint on Table MECH_VENTILATION
ALTER TABLE IF EXISTS citydb.nrg8_mech_ventilation ADD CONSTRAINT nrg8_mech_vent_objclass_fk FOREIGN KEY (objectclass_id) REFERENCES citydb.objectclass (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;
ALTER TABLE IF EXISTS citydb.nrg8_mech_ventilation ADD CONSTRAINT nrg8_mech_vent_nrg_conv_sys_fk FOREIGN KEY (id) REFERENCES citydb.nrg8_conv_system (id) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;

-- FOREIGN KEY constraint on Table CHILLER
ALTER TABLE IF EXISTS citydb.nrg8_chiller ADD CONSTRAINT nrg8_chiller_objclass_fk FOREIGN KEY (objectclass_id) REFERENCES citydb.objectclass (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;
ALTER TABLE IF EXISTS citydb.nrg8_chiller ADD CONSTRAINT nrg8_chiller_nrg_conv_sys_fk FOREIGN KEY (id) REFERENCES citydb.nrg8_conv_system (id) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE IF EXISTS citydb.nrg8_chiller ADD CONSTRAINT nrg8_chiller_nrg_lu_conden_fk FOREIGN KEY (condensation_type) REFERENCES citydb.nrg8_lu_condensation (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;
ALTER TABLE IF EXISTS citydb.nrg8_chiller ADD CONSTRAINT nrg8_chiller_nrg_lu_compr_fk FOREIGN KEY (compressor_type) REFERENCES citydb.nrg8_lu_compressor (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;

-- FOREIGN KEY constraint on Table AIR_COMPRESSOR
ALTER TABLE IF EXISTS citydb.nrg8_air_compressor ADD CONSTRAINT nrg8_air_compr_objclass_fk FOREIGN KEY (objectclass_id) REFERENCES citydb.objectclass (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;
ALTER TABLE IF EXISTS citydb.nrg8_air_compressor ADD CONSTRAINT nrg8_air_compr_nrg_conv_sys_fk FOREIGN KEY (id) REFERENCES citydb.nrg8_conv_system (id) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE IF EXISTS citydb.nrg8_air_compressor ADD CONSTRAINT nrg8_air_compr_nrg_lu_compr_fk FOREIGN KEY (compressor_type) REFERENCES citydb.nrg8_lu_compressor (id) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION;

-- EXECUTE THE STORED PROCEDURE TO SET THE SRID OF THE NEW GEOMETRY COLUMNS TO THE CURRENT ONE ON THE DATABASE
SELECT citydb_pkg.nrg8_set_ade_columns_srid('citydb');

-- ***********************************************************************
-- ***********************************************************************

DO
$$
BEGIN
RAISE NOTICE '

********************************

Energy ADE tables installation complete!

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

