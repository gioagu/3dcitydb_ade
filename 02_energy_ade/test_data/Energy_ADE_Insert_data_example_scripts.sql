-- 3D City Database extension for the Energy ADE v. 0.8
--
--                     September 2017
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
-- ****************************************************************
-- ****************************************************************
--
-- SQL examples on how to insert ADE data into the 3DCityDB 
--
-- ****************************************************************
--
-- This file contains three examples of how to 
-- insert ADE data into the 3DCityDB. For each insert
-- operation, different possibilities, in decreasing level
-- of complexity, are shown.
--
-- EXAMPLE 1 inserts a RegularTimeSeries object.
--
-- EXAMPLE 2 inserts a RegularTimeSeriesFile object
--
-- EXAMPLE 3 shows how to insert an EnergyDemand object.
-- In this example it is also shown how to use the
-- "_ts" prefixed updatable views.
--
-- For each case, an example is given also how to delete the data.
--
-- For more details, please refer to the documentation of the 
-- 3DCityDB extension for the Energy ADE which can be downloaded
-- from
-- https://github.com/gioagu/3dcitydb_ade/tree/master/02_energy_ade/manual.
--
-- ****************************************************************

-- *******
-- ******* EXAMPLE 1: Insert a RegularTimeSeries object. All attributes are stored into one single table in the citydb schema (nrg8_time_series)
-- *******

-- INSERT MODE 1a: Standard SQL INSERT statement (NOT RECOMMENDED)
-- Notes: you provide the objectclass_id (MANDATORY) and the ID. You must be sure that the ID value is not already assigned.

SELECT citydb_pkg.nrg8_delete_time_series(10001);

INSERT INTO citydb.nrg8_time_series
(id, objectclass_id, name, acquisition_method, interpolation_type, values_array, values_unit, temporal_extent_begin, temporal_extent_end, time_interval, time_interval_unit)
VALUES
(10001, 202, 'Test_time_series_insert_1a', 'Estimation', 'AverageInSucceedingInterval', '{1,2,3,4,5,6,7,8,9,10,11,12}', 'kWh/m^2/month', '2015-01-01 00:00', '2015-12-31 23:59', 1, 'month');

-- INSERT MODE 1b: Standard SQL INSERT statement (NOT RECOMMENDED)
-- Notes: you provide only the objectclass_id (MANDATORY). The sequence takes care of assigning a unique ID.

SELECT citydb_pkg.nrg8_delete_time_series(id) FROM citydb.nrg8_time_series WHERE name='Test_time_series_insert_1b';

INSERT INTO citydb.nrg8_time_series
(objectclass_id, name, acquisition_method, interpolation_type, values_array, values_unit, temporal_extent_begin, temporal_extent_end, time_interval, time_interval_unit)
VALUES
(202, 'Test_time_series_insert_1b', 'Estimation', 'AverageInSucceedingInterval', '{1,2,3,4,5,6,7,8,9,10,11,12}', 'kWh/m^2/month', '2015-01-01 00:00', '2015-12-31 23:59', 1, 'month');

-- INSERT MODE 2a: Use the insert stored procedure in the citydb_pkg schema
-- Notes: you provide the objectclass_id (MANDATORY) and the ID. You must be sure that the ID value is not already assigned.
-- Additionally, the gmlid is added automatically, if not explicitly set.

SELECT citydb_pkg.nrg8_delete_time_series(10002);

SELECT citydb_pkg.nrg8_insert_time_series(
  id := 10002,
  objectclass_id := 202,
  name := 'Test_time_series_insert_2a',
  acquisition_method := 'Estimation',
  interpolation_type := 'AverageInSucceedingInterval',
  values_array := '{1,2,3,4,5,6,7,8,9,10,11,12}',
  values_unit := 'kWh/m^2/month',
  temporal_extent_begin := '2015-01-01 00:00',
  temporal_extent_end := '2015-12-31 23:59',
  time_interval := 1,
  time_interval_unit := 'month');

-- INSERT MODE 2b: Use the insert stored procedure in the citydb_pkg schema
-- Notes: you provide only the objectclass_id (MANDATORY). The sequence takes care of assigning a unique ID.
-- Additionally, the gmlid is added automatically, if not explicitly set.

SELECT citydb_pkg.nrg8_delete_time_series(id) FROM citydb_view.nrg8_time_series WHERE name='Test_time_series_insert_2b';

SELECT citydb_pkg.nrg8_insert_time_series(
  objectclass_id := 202,
  name := 'Test_time_series_insert_2b',
  acquisition_method := 'Estimation',
  interpolation_type := 'AverageInSucceedingInterval',
  values_array := '{1,2,3,4,5,6,7,8,9,10,11,12}',
  values_unit := 'kWh/m^2/month',
  temporal_extent_begin := '2015-01-01 00:00',
  temporal_extent_end := '2015-12-31 23:59',
  time_interval := 1,
  time_interval_unit := 'month');

-- INSERT MODE 3a - Use the updatabble VIEW in citydb_view schema
-- Notes: You provide the ID. You must be sure that the ID value is not already assigned.
-- You DO NOT need to set the cityobjectclass_id (202) anymore.
-- Additionally, the gmlid is added automatically, if not explicitly set.

DELETE FROM citydb_view.nrg8_time_series_regular WHERE id=10003;

INSERT INTO citydb_view.nrg8_time_series_regular
(id, name, acquisition_method, interpolation_type, values_array, values_unit, temporal_extent_begin, temporal_extent_end, time_interval, time_interval_unit)
VALUES
(10003, 'Test_time_series_insert_3a', 'Estimation', 'AverageInSucceedingInterval', '{1,2,3,4,5,6,7,8,9,10,11,12}', 'kWh/m^2/month', '2015-01-01 00:00', '2015-12-31 23:59', 1, 'month');

-- INSERT MODE 3b - using the updatabble VIEW in citydb_view schema
-- Notes: you provide neither the objectclass_id nor the ID. The sequence takes care of assigning the unique ID.
-- Additionally, the gmlid is added automatically, if not explicitly set.

DELETE FROM citydb_view.nrg8_time_series_regular WHERE name='Test_time_series_insert_3b';

INSERT INTO citydb_view.nrg8_time_series_regular
(name, acquisition_method, interpolation_type, values_array, values_unit, temporal_extent_begin, temporal_extent_end, time_interval, time_interval_unit)
VALUES
('Test_time_series_insert_3b', 'Estimation', 'AverageInSucceedingInterval', '{1,2,3,4,5,6,7,8,9,10,11,12}', 'kWh/m^2/month', '2015-01-01 00:00', '2015-12-31 23:59', 1, 'month');

-- INSERT MODE 4a - using the "smart" function in citydv_view schema
-- Notes: You provide the ID. You must be sure that the ID value is not already assigned.
-- You DO NOT need to set the cityobjectclass_id (202) anymore.
-- Additionally, the gmlid is added automatically, if not explicitly set.

SELECT citydb_view.nrg8_delete_regular_time_series(10004);

SELECT citydb_view.nrg8_insert_regular_time_series(
  id := 10004,
  name := 'Test_time_series_insert_4a',
  acquisition_method := 'Estimation',
  interpolation_type := 'AverageInSucceedingInterval',
  values_array := '{1,2,3,4,5,6,7,8,9,10,11,12}',
  values_unit := 'kWh/m^2/month',
  temporal_extent_begin := '2015-01-01 00:00',
  temporal_extent_end := '2015-12-31 23:59',
  time_interval := 1,
  time_interval_unit := 'month');

-- INSERT MODE 4b - using the "smart" function in citydv_view schema
-- Notes: you provide neither the objectclass_id nor the ID. The trigger functions take care of them.
-- Additionally, the gmlid is added automatically, if not explicitly set.

SELECT citydb_view.nrg8_delete_regular_time_series(id) FROM citydb_view.nrg8_time_series WHERE name='Test_time_series_insert_4b';

SELECT citydb_view.nrg8_insert_regular_time_series(
  name := 'Test_time_series_insert_4b',
  acquisition_method := 'Estimation',
  interpolation_type := 'AverageInSucceedingInterval',
  values_array := '{1,2,3,4,5,6,7,8,9,10,11,12}',
  values_unit := 'kWh/m^2/month',
  temporal_extent_begin := '2015-01-01 00:00',
  temporal_extent_end := '2015-12-31 23:59',
  time_interval := 1,
  time_interval_unit := 'month');
  
-- *******
-- ******* EXAMPLE 2: Insert a RegularTimeSeriesFile object.
-- ******* All attributes are stored into two tables in the citydb schema (nrg8_time_series and nrg8_time_series_file)
-- *******

-- INSERT MODE 1a: Standard SQL INSERT statement (NOT RECOMMENDED)
-- Notes: you provide the objectclass_id (MANDATORY) and the ID. You must be sure that the ID value is not already assigned.

SELECT citydb_pkg.nrg8_delete_time_series(10011);

WITH s AS (
  INSERT INTO citydb.nrg8_time_series
  (id, objectclass_id, name, acquisition_method, interpolation_type, values_unit, temporal_extent_begin, temporal_extent_end, time_interval, time_interval_unit)
  VALUES
  (10011, 204, 'Test_time_series_file_insert_1', 'Estimation', 'AverageInSucceedingInterval', 'kWh/m^2/month', '2015-01-01 00:00', '2015-12-31 23:59', 1, 'month')
  RETURNING id, objectclass_id
)
INSERT INTO citydb.nrg8_time_series_file 
(id, objectclass_id, file_path, file_name, file_extension, nbr_header_lines, field_sep, record_sep, dec_symbol, value_col_nbr, is_compressed)
SELECT s.id, s.objectclass_id, 'file_path_XXXXX', 'file_name_XXXXX', 'file_ext_XXXXX', 1, ',', '/n', '.', 1, 0 FROM s;

-- INSERT MODE 1b: Standard SQL INSERT statement (NOT RECOMMENDED)
-- Notes: you provide only the objectclass_id (MANDATORY). The sequence takes care of assigning a unique ID.

SELECT citydb_pkg.nrg8_delete_time_series(id) FROM citydb.nrg8_time_series WHERE name='Test_time_series_file_insert_1b';

WITH s AS (
  INSERT INTO citydb.nrg8_time_series
  (objectclass_id, name, acquisition_method, interpolation_type, values_unit, temporal_extent_begin, temporal_extent_end, time_interval, time_interval_unit)
  VALUES
  (204, 'Test_time_series_file_insert_1', 'Estimation', 'AverageInSucceedingInterval', 'kWh/m^2/month', '2015-01-01 00:00', '2015-12-31 23:59', 1, 'month')
  RETURNING id, objectclass_id
)
INSERT INTO citydb.nrg8_time_series_file 
(id, objectclass_id, file_path, file_name, file_extension, nbr_header_lines, field_sep, record_sep, dec_symbol, value_col_nbr, is_compressed)
SELECT s.id, s.objectclass_id, 'file_path_XXXXX', 'file_name_XXXXX', 'file_ext_XXXXX', 1, ',', '/n', '.', 1, 0 FROM s;

-- INSERT MODE 2a: Use the insert stored procedure in the citydb_pkg schema
-- Notes: you provide the objectclass_id (MANDATORY) and the ID. You must be sure that the ID value is not already assigned.
-- Additionally, the gmlid is added automatically, if not explicitly set.

SELECT citydb_pkg.nrg8_delete_time_series(10012);

WITH s AS (
SELECT citydb_pkg.nrg8_insert_time_series(
  id := 10012,
  objectclass_id := 204,
  name := 'Test_time_series_file_insert_2a',
  acquisition_method := 'Estimation',
  interpolation_type := 'AverageInSucceedingInterval',
  values_unit := 'kWh/m^2/month',
  temporal_extent_begin := '2015-01-01 00:00',
  temporal_extent_end := '2015-12-31 23:59',
  time_interval := 1,
  time_interval_unit := 'month') AS ts_id
)
SELECT citydb_pkg.nrg8_insert_time_series_file(
  id := s.ts_id, 
  objectclass_id := 204, 
  file_path := 'file_path_XXXXX', 
  file_name := 'file_name_XXXXX', 
  file_extension := 'file_ext_XXXXX', 
  nbr_header_lines := 1, 
  field_sep := ',', 
  record_sep := '/n', 
  dec_symbol := '.', 
  value_col_nbr := 1, 
  is_compressed := 0)
FROM s;

-- INSERT MODE 2b: Use the insert stored procedure in the citydb_pkg schema
-- Notes: you provide only the objectclass_id (MANDATORY). The sequence takes care of assigning a unique ID.
-- Additionally, the gmlid is added automatically, if not explicitly set.

SELECT citydb_pkg.nrg8_delete_time_series(id) FROM citydb.nrg8_time_series WHERE name='Test_time_series_file_insert_2b';

WITH s AS (
  SELECT citydb_pkg.nrg8_insert_time_series(
    objectclass_id := 204,
    name := 'Test_time_series_file_insert_2b',
    acquisition_method := 'Estimation',
    interpolation_type := 'AverageInSucceedingInterval',
    values_unit := 'kWh/m^2/month',
    temporal_extent_begin := '2015-01-01 00:00',
    temporal_extent_end := '2015-12-31 23:59',
    time_interval := 1,
    time_interval_unit := 'month') AS ts_id
)
SELECT citydb_pkg.nrg8_insert_time_series_file(
  id := s.ts_id, 
  objectclass_id := 204, 
  file_path := 'file_path_XXXXX', 
  file_name := 'file_name_XXXXX', 
  file_extension := 'file_ext_XXXXX', 
  nbr_header_lines := 1, 
  field_sep := ',', 
  record_sep := '/n', 
  dec_symbol := '.', 
  value_col_nbr := 1, 
  is_compressed := 0)
FROM s;

-- INSERT MODE 3a - Use the updatabble VIEW in citydb_view schema
-- Notes: You provide the ID. You must be sure that the ID value is not already assigned.
-- You DO NOT need to set the cityobjectclass_id (204) anymore.
-- Additionally, the gmlid is added automatically, if not explicitly set.

DELETE FROM citydb_view.nrg8_time_series_regular_file WHERE id=10013;

INSERT INTO citydb_view.nrg8_time_series_regular_file
(id, name, acquisition_method, interpolation_type, values_unit, temporal_extent_begin, temporal_extent_end, time_interval, time_interval_unit,
file_path, file_name, file_extension, nbr_header_lines, field_sep, record_sep, dec_symbol, value_col_nbr, is_compressed)
VALUES
(10013, 'Test_time_series_file_insert_3a', 'Estimation', 'AverageInSucceedingInterval', 'kWh/m^2/month', '2015-01-01 00:00', '2015-12-31 23:59', 1, 'month',
'file_path_XXXXX', 'file_name_XXXXX', 'file_ext_XXXXX', 1, ',', '/n', '.', 1, 0);

-- INSERT MODE 3b - using the updatabble VIEW in citydb_view schema
-- Notes: you provide neither the objectclass_id nor the ID. The sequence takes care of assigning the unique ID.
-- Additionally, the gmlid is added automatically, if not explicitly set.

DELETE FROM citydb_view.nrg8_time_series_regular_file WHERE name='Test_time_series_insert_file_3b';

INSERT INTO citydb_view.nrg8_time_series_regular_file
(name, acquisition_method, interpolation_type, values_unit, temporal_extent_begin, temporal_extent_end, time_interval, time_interval_unit,
file_path, file_name, file_extension, nbr_header_lines, field_sep, record_sep, dec_symbol, value_col_nbr, is_compressed)
VALUES
('Test_time_series_insert_file_3b', 'Estimation', 'AverageInSucceedingInterval', 'kWh/m^2/month', '2015-01-01 00:00', '2015-12-31 23:59', 1, 'month',
'file_path_XXXXX', 'file_name_XXXXX', 'file_ext_XXXXX', 1, ',', '/n', '.', 1, 0);

-- INSERT MODE 4a - using the "smart" function in citydv_view schema
-- Notes: You provide the ID. You must be sure that the ID value is not already assigned.
-- You DO NOT need to set the cityobjectclass_id (204) anymore.
-- Additionally, the gmlid is added automatically, if not explicitly set.

SELECT citydb_view.nrg8_delete_regular_time_series_file(10014);

SELECT citydb_view.nrg8_insert_regular_time_series_file(
  id := 10014,
  name := 'Test_time_series_file_insert_4a',
  acquisition_method := 'Estimation',
  interpolation_type := 'AverageInSucceedingInterval',
  values_unit := 'kWh/m^2/month',
  temporal_extent_begin := '2015-01-01 00:00',
  temporal_extent_end := '2015-12-31 23:59',
  time_interval := 1,
  time_interval_unit := 'month',
  file_path := 'file_path_XXXXX', 
  file_name := 'file_name_XXXXX', 
  file_extension := 'file_ext_XXXXX', 
  nbr_header_lines := 1, 
  field_sep := ',', 
  record_sep := '/n', 
  dec_symbol := '.', 
  value_col_nbr := 1, 
  is_compressed := 0);

-- INSERT MODE 4b - using the "smart" function in citydv_view schema
-- Notes: you provide neither the objectclass_id nor the ID. The trigger functions take care of them.
-- Additionally, the gmlid is added automatically, if not explicitly set.

SELECT citydb_view.nrg8_delete_regular_time_series_file(id) FROM citydb_view.nrg8_time_series WHERE name='Test_time_series_file_insert_4b';

SELECT citydb_view.nrg8_insert_regular_time_series_file(
name := 'Test_time_series_file_insert_4b',
acquisition_method := 'Estimation',
interpolation_type := 'AverageInSucceedingInterval',
values_unit := 'kWh/m^2/month',
temporal_extent_begin := '2015-01-01 00:00',
temporal_extent_end := '2015-12-31 23:59',
time_interval := 1,
time_interval_unit := 'month',
file_path := 'file_path_XXXXX', 
file_name := 'file_name_XXXXX', 
file_extension := 'file_ext_XXXXX', 
nbr_header_lines := 1, 
field_sep := ',', 
record_sep := '/n', 
dec_symbol := '.', 
value_col_nbr := 1, 
is_compressed := 0);

-- *******
-- ******* EXAMPLE 3: Insert an EnergyDemand object (with an associated RegularTimeSeriesFile object)
-- ******* All attributes are stored into three tables in the citydb schema (nrg8_energy_demand, nrg8_time_series and nrg8_time_series_file)
-- ******* Please note: for the sake of simplicity, not all possible combinations are shown.
-- ******* Keep in mind that from MODE 3 onwards, the user can alternatively avoid to the set the IDs.
-- ******* In addition, in this example, the EnergyDemand object is not linked to any CityObject (i.e. the cityobject_id field is set to NULL)
-- *******

-- INSERT MODE 1: Standard SQL INSERT statement (NOT RECOMMENDED)
-- Notes: you provide the objectclass_id (MANDATORY) and the ID. You must be sure that the ID value is not already assigned.

SELECT citydb_pkg.nrg8_delete_energy_demand(1001);

WITH s1 AS (
  INSERT INTO citydb.nrg8_time_series
  (id, objectclass_id, name, acquisition_method, interpolation_type, values_unit, temporal_extent_begin, temporal_extent_end, time_interval, time_interval_unit)
  VALUES
  (10111, 204, 'Test_time_series_file_insert_11', 'Estimation', 'AverageInSucceedingInterval', 'kWh/m^2/month', '2015-01-01 00:00', '2015-12-31 23:59', 1, 'month')
  RETURNING id, objectclass_id
),
s2 AS (
  INSERT INTO citydb.nrg8_time_series_file 
  (id, objectclass_id, file_path, file_name, file_extension, nbr_header_lines, field_sep, record_sep, dec_symbol, value_col_nbr, is_compressed)
    SELECT s1.id, s1.objectclass_id, 'file_path_XXXXX', 'file_name_XXXXX', 'file_ext_XXXXX', 1, ',', '/n', '.', 1, 0
	FROM s1
)
INSERT INTO citydb.nrg8_energy_demand 
(id, objectclass_id, name, end_use, time_series_id, cityobject_id)
  SELECT 1001, 232, 'Energy_Demand_Test_1', 'SpaceHeating', s1.id, NULL 
  FROM s1;

-- INSERT MODE 2: Use the insert stored procedure in the citydb_pkg schema
-- Notes: you provide the objectclass_id (MANDATORY) and the ID. You must be sure that the ID value is not already assigned.
-- Additionally, the gmlid values are added automatically, if not explicitly set.

SELECT citydb_pkg.nrg8_delete_energy_demand(1002);

WITH s1 AS (
  SELECT citydb_pkg.nrg8_insert_time_series(
    id := 10112,
    objectclass_id := 204,
    name := 'Test_time_series_file_insert_12',
    acquisition_method := 'Estimation',
    interpolation_type := 'AverageInSucceedingInterval',
    values_unit := 'kWh/m^2/month',
    temporal_extent_begin := '2015-01-01 00:00',
    temporal_extent_end := '2015-12-31 23:59',
    time_interval := 1,
    time_interval_unit := 'month') AS ts_id
),
s2 AS (
  SELECT citydb_pkg.nrg8_insert_time_series_file(
    id := s1.ts_id, 
    objectclass_id := 204, 
    file_path := 'file_path_XXXXX', 
    file_name := 'file_name_XXXXX', 
    file_extension := 'file_ext_XXXXX', 
    nbr_header_lines := 1, 
    field_sep := ',', 
    record_sep := '/n', 
    dec_symbol := '.', 
    value_col_nbr := 1, 
    is_compressed := 0)
  FROM s1
)
SELECT citydb_pkg.nrg8_insert_energy_demand(
  id := 1002,
  objectclass_id := 232,
  name := 'Energy_Demand_Test_2',
  end_use := 'SpaceHeating',
  time_series_id := s1.ts_id
)
FROM s1;

-- INSERT MODE 3 - Use the updatabble VIEWS in citydb_view schema
-- Notes: You provide the ID. You must be sure that the ID values are not already assigned.
-- You DO NOT need to set the cityobjectclass_id (204 and 232) anymore.
-- Additionally, the gmlid values are added automatically, if not explicitly set.

DELETE FROM citydb_view.nrg8_energy_demand WHERE id=1003;

WITH s AS (
  INSERT INTO citydb_view.nrg8_time_series_regular_file
  (id, name, acquisition_method, interpolation_type, values_unit, temporal_extent_begin, temporal_extent_end, time_interval, time_interval_unit,
  file_path, file_name, file_extension, nbr_header_lines, field_sep, record_sep, dec_symbol, value_col_nbr, is_compressed)
  VALUES
  (10113, 'Test_time_series_file_insert_3', 'Estimation', 'AverageInSucceedingInterval', 'kWh/m^2/month', '2015-01-01 00:00', '2015-12-31 23:59', 1, 'month',
  'file_path_XXXXX', 'file_name_XXXXX', 'file_ext_XXXXX', 1, ',', '/n', '.', 1, 0)
  RETURNING id
)
INSERT INTO citydb_view.nrg8_energy_demand
(id, name, end_use, time_series_id, cityobject_id)
SELECT 1003, 'Energy_Demand_Test_3', 'SpaceHeating', s.id, NULL
FROM s;

-- INSERT MODE 4 - using the "smart" function in citydv_view schema
-- Notes: You provide the ID. You must be sure that the ID values are not already assigned.
-- You DO NOT need to set the cityobjectclass_id (204 and 232) anymore.
-- Additionally, the gmlid values are added automatically, if not explicitly set.

SELECT citydb_view.nrg8_delete_energy_demand(1004);

WITH s AS (
  SELECT citydb_view.nrg8_insert_regular_time_series_file(
  id := 10114,
  name := 'Test_time_series_file_insert_4',
  acquisition_method := 'Estimation',
  interpolation_type := 'AverageInSucceedingInterval',
  values_unit := 'kWh/m^2/month',
  temporal_extent_begin := '2015-01-01 00:00',
  temporal_extent_end := '2015-12-31 23:59',
  time_interval := 1,
  time_interval_unit := 'month',
  file_path := 'file_path_XXXXX', 
  file_name := 'file_name_XXXXX', 
  file_extension := 'file_ext_XXXXX', 
  nbr_header_lines := 1, 
  field_sep := ',', 
  record_sep := '/n', 
  dec_symbol := '.', 
  value_col_nbr := 1, 
  is_compressed := 0) AS ts_id
)
SELECT citydb_view.nrg8_insert_energy_demand(
  id := 1004,
  name := 'Energy_Demand_Test_4',
  end_use := 'SpaceHeating',
  time_series_id := s.ts_id
)
FROM s;

-- INSERT MODE 5a - using the "_ts" suffixed updatable VIEW in citydv_view schema
-- Notes: You MUST provide the classname of the time series object. In this case: RegularTimeSeriesFile
-- You provide the ID. You must be sure that the ID values are not already assigned.
-- You DO NOT need to set the cityobjectclass_id (204 and 232) anymore.
-- Additionally, the gmlid values are added automatically, if not explicitly set.

DELETE FROM citydb_view.nrg8_energy_demand_ts WHERE id=1005;

INSERT INTO citydb_view.nrg8_energy_demand_ts
(id, name, end_use, cityobject_id,
ts_classname, -- ATTENTION, this field is MANDATORY
ts_id, ts_name, ts_acquisition_method, ts_interpolation_type, ts_values_unit, ts_temporal_extent_begin, ts_temporal_extent_end, ts_time_interval, ts_time_interval_unit, ts_file_path, ts_file_name, ts_file_extension, ts_nbr_header_lines, ts_field_sep, ts_record_sep, ts_dec_symbol, ts_value_col_nbr, ts_is_compressed)
VALUES  
(1005, 'Energy_Demand_Test_5a', 'SpaceHeating', NULL,
'RegularTimeSeries', -- ATTENTION, this field is MANDATORY
10115, 'Test_time_series_file_insert_5a', 'Estimation', 'AverageInSucceedingInterval', 'kWh/m^2/month', '2015-01-01 00:00', '2015-12-31 23:59', 1, 'month', 'file_path_XXXXX', 'file_name_XXXXX', 'file_ext_XXXXX', 1, ',', '/n', '.', 1, 0);

-- INSERT MODE 5b - using the "_ts" suffixed updatable VIEW in citydv_view schema
-- Notes: You MUST provide the classname of the time series object. In this case: RegularTimeSeriesFile
-- You do provide neither the ID values, nor the cityobjectclass_id values (204 and 232) anymore.
-- You must be sure that the ID values are not already assigned.
-- Additionally, the gmlid values are added automatically, if not explicitly set.

DELETE FROM citydb_view.nrg8_energy_demand_ts WHERE name='Energy_Demand_Test_5b';

INSERT INTO citydb_view.nrg8_energy_demand_ts
(name, end_use, cityobject_id,
ts_classname, -- ATTENTION, this field is MANDATORY
ts_name, ts_acquisition_method, ts_interpolation_type, ts_values_unit, ts_temporal_extent_begin, ts_temporal_extent_end, ts_time_interval, ts_time_interval_unit, ts_file_path, ts_file_name, ts_file_extension, ts_nbr_header_lines, ts_field_sep, ts_record_sep, ts_dec_symbol, ts_value_col_nbr, ts_is_compressed)
VALUES  
('Energy_Demand_Test_5b', 'SpaceHeating', NULL,
'RegularTimeSeries', -- ATTENTION, this field is MANDATORY
'Test_time_series_file_insert_5b', 'Estimation', 'AverageInSucceedingInterval', 'kWh/m^2/month', '2015-01-01 00:00', '2015-12-31 23:59', 1, 'month', 'file_path_XXXXX', 'file_name_XXXXX', 'file_ext_XXXXX', 1, ',', '/n', '.', 1, 0);


-- ***********************************************************************
-- ***********************************************************************
--
-- END OF FILE
--
-- ***********************************************************************
-- ***********************************************************************