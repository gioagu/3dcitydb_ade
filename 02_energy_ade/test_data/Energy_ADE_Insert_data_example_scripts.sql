-- ****************************************************
--
-- Examples on how to insert ADE data into the 3DCityDB 
--
-- ****************************************************

-- *******
-- ******* EXAMPLE 1: Insert a Regular Time Series. All attributes are stored into one single table in the citydb schema (nrg8_time_series)
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
time_interval_unit := 'month'
);

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
time_interval_unit := 'month'
);

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
time_interval_unit := 'month'
);

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
time_interval_unit := 'month'
);
-- *******
-- ******* EXAMPLE 2: Insert a Regular Time Series File. All attributes are stored into two linked tables in the citydb schema (nrg8_time_series and nrg8_time_series_file)
-- *******

-- INSERT MODE 1a: Standard SQL INSERT statement (NOT RECOMMENDED)
-- Notes: you provide the objectclass_id (MANDATORY) and the ID. You must be sure that the ID value is not already assigned.
SELECT citydb_pkg.nrg8_delete_time_series(10011);

WITH s AS (
INSERT INTO citydb.nrg8_time_series
(id, objectclass_id, name, acquisition_method, interpolation_type, values_unit, temporal_extent_begin, temporal_extent_end, time_interval, time_interval_unit)
VALUES
(10011, 204, 'Test_time_series_file_insert_1', 'Estimation', 'AverageInSucceedingInterval', 'kWh/m^2/month', '2015-01-01 00:00', '2015-12-31 23:59', 1, 'month')
RETURNING id, objectclass_id)
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
RETURNING id, objectclass_id)
INSERT INTO citydb.nrg8_time_series_file 
(id, objectclass_id, file_path, file_name, file_extension, nbr_header_lines, field_sep, record_sep, dec_symbol, value_col_nbr, is_compressed)
SELECT s.id, s.objectclass_id, 'file_path_XXXXX', 'file_name_XXXXX', 'file_ext_XXXXX', 1, ',', '/n', '.', 1, 0 FROM s;

-- INSERT MODE 2a: Use the insert stored procedure in the citydb_pkg schema
-- Notes: you provide the objectclass_id (MANDATORY) and the ID. You must be sure that the ID value is not already assigned.
-- Additionally, the gmlid is added automatically, if not explicitly set.

SELECT citydb_pkg.nrg8_delete_time_series(10012);

WITH s AS (SELECT citydb_pkg.nrg8_insert_time_series(
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

WITH s AS (SELECT citydb_pkg.nrg8_insert_time_series(
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
is_compressed := 0
);

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
is_compressed := 0
);