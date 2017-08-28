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
-- ***************** 08_Energy_ADE_VIEW_TRIGGERS.sql *********************
--
-- This script adds triggers and trigger functions to schema citydb_view
-- in order to make some views updateable.
--
-- ***********************************************************************
-- ***********************************************************************

----------------------------------------------------------------
-- Function TR_DEL_TIME_SERIES_REGULAR
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_del_time_series_regular() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_del_time_series_regular()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
deleted_id=citydb_pkg.nrg8_delete_time_series(OLD.id, p_schema_name);
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_del_time_series_regular (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_TIME_SERIES_REGULAR
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_ins_time_series_regular() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_ins_time_series_regular()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	inserted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
inserted_id=citydb_view.nrg8_insert_regular_time_series(
id                   :=NEW.id,
gmlid                :=NEW.gmlid,
gmlid_codespace      :=NEW.gmlid_codespace,
name                 :=NEW.name,
name_codespace       :=NEW.name_codespace,
description          :=NEW.description,	
acquisition_method   :=NEW.acquisition_method,
interpolation_type   :=NEW.interpolation_type,
quality_description  :=NEW.quality_description,
source               :=NEW.source,
values_array         :=NEW.values_array,
values_unit          :=NEW.values_unit,
array_length         :=NEW.array_length,
temporal_extent_begin:=NEW.temporal_extent_begin,
temporal_extent_end  :=NEW.temporal_extent_end,
time_interval        :=NEW.time_interval,
time_interval_unit   :=NEW.time_interval_unit,
schema_name          :=p_schema_name
);
--RAISE NOTICE 'Inserted record with id: %', inserted_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_ins_time_series_regular (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_TIME_SERIES_REGULAR
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_upd_time_series_regular() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_upd_time_series_regular()
  RETURNS trigger AS
$BODY$
DECLARE
  p_schema_name varchar DEFAULT 'citydb'::varchar;
  updated_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
EXECUTE format('UPDATE %I.nrg8_time_series AS t SET
gmlid                =%L,
gmlid_codespace      =%L,
name                 =%L,
name_codespace       =%L,
description          =%L,
acquisition_method   =%L,
interpolation_type   =%L,
quality_description  =%L,
source               =%L,
values_array         =%L,
values_unit          =%L,
array_length         =%L,
temporal_extent_begin=%L,
temporal_extent_end  =%L,
time_interval        =%L, 
time_interval_unit   =%L 
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.gmlid,
NEW.gmlid_codespace,
NEW.name,
NEW.name_codespace,
NEW.description,	
NEW.acquisition_method,
NEW.interpolation_type,
NEW.quality_description,
NEW.source,
NEW.values_array,
NEW.values_unit,
NEW.array_length,
NEW.temporal_extent_begin,
NEW.temporal_extent_end, 
NEW.time_interval, 
NEW.time_interval_unit, 
OLD.id
) INTO updated_id;
-- RAISE NOTICE 'Updated record with id: %', updated_id;
RETURN NEW;
EXCEPTION
  WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_upd_time_series_regular (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view TIME_SERIES_REGULAR
----------------------------------------------------------------
DROP TRIGGER IF EXISTS nrg8_tr_del_time_series_regular ON citydb_view.nrg8_time_series_regular;
CREATE TRIGGER nrg8_tr_del_time_series_regular
	INSTEAD OF DELETE ON citydb_view.nrg8_time_series_regular
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_del_time_series_regular ('citydb');

DROP TRIGGER IF EXISTS nrg8_tr_ins_time_series_regular ON citydb_view.nrg8_time_series_regular;
CREATE TRIGGER nrg8_tr_ins_time_series_regular
	INSTEAD OF INSERT ON citydb_view.nrg8_time_series_regular
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_ins_time_series_regular ('citydb');

DROP TRIGGER IF EXISTS nrg8_tr_upd_time_series_regular ON citydb_view.nrg8_time_series_regular;
CREATE TRIGGER nrg8_tr_upd_time_series_regular
	INSTEAD OF UPDATE ON citydb_view.nrg8_time_series_regular
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_upd_time_series_regular ('citydb');
--**************************************************************
--**************************************************************

----------------------------------------------------------------
-- Function TR_DEL_TIME_SERIES_IRREGULAR
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_del_time_series_irregular() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_del_time_series_irregular()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
deleted_id=citydb_pkg.nrg8_delete_time_series(OLD.id, p_schema_name);
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_del_time_series_irregular (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_TIME_SERIES_IRREGULAR
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_ins_time_series_irregular() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_ins_time_series_irregular()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	inserted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
inserted_id=citydb_view.nrg8_insert_irregular_time_series(
id                   :=NEW.id,
gmlid                :=NEW.gmlid,
gmlid_codespace      :=NEW.gmlid_codespace,
name                 :=NEW.name,
name_codespace       :=NEW.name_codespace,
description          :=NEW.description,
acquisition_method   :=NEW.acquisition_method,
interpolation_type   :=NEW.interpolation_type,
quality_description  :=NEW.quality_description,
source               :=NEW.source,
time_array           :=NEW.time_array,
values_array         :=NEW.values_array,
values_unit          :=NEW.values_unit,
array_length         :=NEW.array_length,
schema_name          :=p_schema_name
);
--RAISE NOTICE 'Inserted record with id: %', inserted_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_ins_time_series_irregular (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_TIME_SERIES_IRREGULAR
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_upd_time_series_irregular() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_upd_time_series_irregular()
  RETURNS trigger AS
$BODY$
DECLARE
  p_schema_name varchar DEFAULT 'citydb'::varchar;
  updated_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
EXECUTE format('UPDATE %I.nrg8_time_series AS t SET
gmlid              =%L,
gmlid_codespace    =%L,
name               =%L,
name_codespace     =%L,
description        =%L,
acquisition_method =%L,
interpolation_type =%L,
quality_description=%L,
source             =%L,
time_array         =%L,
values_array       =%L,
values_unit        =%L,
array_length       =%L
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.gmlid,
NEW.gmlid_codespace,
NEW.name,
NEW.name_codespace,
NEW.description,	
NEW.acquisition_method,
NEW.interpolation_type,
NEW.quality_description,
NEW.source,
NEW.time_array,
NEW.values_array,
NEW.values_unit, 
NEW.array_length, 
OLD.id
) INTO updated_id;
-- RAISE NOTICE 'Updated record with id: %',updated_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_upd_time_series_irregular (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view TIME_SERIES_IRREGULAR
----------------------------------------------------------------
DROP TRIGGER IF EXISTS nrg8_tr_del_time_series_irregular ON citydb_view.nrg8_time_series_irregular;
CREATE TRIGGER nrg8_tr_del_time_series_irregular
	INSTEAD OF DELETE ON citydb_view.nrg8_time_series_irregular
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_del_time_series_irregular ('citydb');

DROP TRIGGER IF EXISTS nrg8_tr_ins_time_series_irregular ON citydb_view.nrg8_time_series_irregular;
CREATE TRIGGER nrg8_tr_ins_time_series_irregular
	INSTEAD OF INSERT ON citydb_view.nrg8_time_series_irregular
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_ins_time_series_irregular ('citydb');

DROP TRIGGER IF EXISTS nrg8_tr_upd_time_series_irregular ON citydb_view.nrg8_time_series_irregular;
CREATE TRIGGER nrg8_tr_upd_time_series_irregular
	INSTEAD OF UPDATE ON citydb_view.nrg8_time_series_irregular
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_upd_time_series_irregular ('citydb');
-- ***********************************************************************
-- ***********************************************************************

----------------------------------------------------------------
-- Function TR_DEL_TIME_SERIES_REGULAR_FILE
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_del_time_series_regular_file() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_del_time_series_regular_file()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
deleted_id=citydb_pkg.nrg8_delete_time_series(OLD.id, p_schema_name);
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_del_time_series_regular_file (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_TIME_SERIES_REGULAR_FILE
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_ins_time_series_regular_file() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_ins_time_series_regular_file()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	inserted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
inserted_id=citydb_view.nrg8_insert_regular_time_series_file(
id                   :=NEW.id,
gmlid                :=NEW.gmlid,
gmlid_codespace      :=NEW.gmlid_codespace,
name                 :=NEW.name,
name_codespace       :=NEW.name_codespace,
description          :=NEW.description,	
acquisition_method   :=NEW.acquisition_method,
interpolation_type   :=NEW.interpolation_type,
quality_description  :=NEW.quality_description,
source               :=NEW.source,
values_unit          :=NEW.values_unit,
temporal_extent_begin:=NEW.temporal_extent_begin,
temporal_extent_end  :=NEW.temporal_extent_end,
time_interval        :=NEW.time_interval,
time_interval_unit   :=NEW.time_interval_unit,
file_path            :=NEW.file_path,
file_name            :=NEW.file_name,
file_extension       :=NEW.file_extension,
nbr_header_lines     :=NEW.nbr_header_lines,
field_sep            :=NEW.field_sep,
record_sep           :=NEW.record_sep,
dec_symbol           :=NEW.dec_symbol,
value_col_nbr        :=NEW.value_col_nbr,
is_compressed        :=NEW.is_compressed,
schema_name          :=p_schema_name
);
--RAISE NOTICE 'Inserted record with id: %', inserted_id;
  RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_ins_time_series_regular_file (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_TIME_SERIES_REGULAR_FILE
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_upd_time_series_regular_file() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_upd_time_series_regular_file()
  RETURNS trigger AS
$BODY$
DECLARE
  p_schema_name varchar DEFAULT 'citydb'::varchar;
  updated_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
  p_schema_name=TG_ARGV[0];
END IF;
EXECUTE format('UPDATE %I.nrg8_time_series AS t SET
gmlid                =%L,
gmlid_codespace      =%L,
name                 =%L,
name_codespace       =%L,
description          =%L,
acquisition_method   =%L,
interpolation_type   =%L,
quality_description  =%L,
source               =%L,
values_unit          =%L,
temporal_extent_begin=%L,
temporal_extent_end  =%L,
time_interval        =%L, 
time_interval_unit   =%L 
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.gmlid,
NEW.gmlid_codespace,
NEW.name,
NEW.name_codespace,
NEW.description,	
NEW.acquisition_method,
NEW.interpolation_type,
NEW.quality_description,
NEW.source,
NEW.values_unit,
NEW.temporal_extent_begin,
NEW.temporal_extent_end, 
NEW.time_interval, 
NEW.time_interval_unit, 
OLD.id
) INTO updated_id;
EXECUTE format('UPDATE %I.nrg8_time_series_file AS t SET
file_path       =%L,
file_name       =%L,
file_extension  =%L,
nbr_header_lines=%L,
field_sep       =%L,
record_sep      =%L,
dec_symbol      =%L,
value_col_nbr   =%L,
is_compressed   =%L 
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.file_path,
NEW.file_name,
NEW.file_extension,
NEW.nbr_header_lines,
NEW.field_sep,
NEW.record_sep, 
NEW.dec_symbol, 
NEW.value_col_nbr, 
NEW.is_compressed, 
OLD.id
) INTO updated_id;
-- RAISE NOTICE 'Updated record with id: %',updated_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_upd_time_series_regular_file (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view TIME_SERIES_REGULAR_FILE
----------------------------------------------------------------
DROP TRIGGER IF EXISTS nrg8_tr_del_time_series_regular_file ON citydb_view.nrg8_time_series_regular_file;
CREATE TRIGGER nrg8_tr_del_time_series_regular_file
	INSTEAD OF DELETE ON citydb_view.nrg8_time_series_regular_file
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_del_time_series_regular_file ('citydb');

DROP TRIGGER IF EXISTS nrg8_tr_ins_time_series_regular_file ON citydb_view.nrg8_time_series_regular_file;
CREATE TRIGGER nrg8_tr_ins_time_series_regular_file
	INSTEAD OF INSERT ON citydb_view.nrg8_time_series_regular_file
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_ins_time_series_regular_file ('citydb');

DROP TRIGGER IF EXISTS nrg8_tr_upd_time_series_regular_file ON citydb_view.nrg8_time_series_regular_file;
CREATE TRIGGER nrg8_tr_upd_time_series_regular_file
	INSTEAD OF UPDATE ON citydb_view.nrg8_time_series_regular_file
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_upd_time_series_regular_file ('citydb');
-- ***********************************************************************
-- ***********************************************************************

----------------------------------------------------------------
-- Function TR_DEL_TIME_SERIES_IRREGULAR_FILE
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_del_time_series_irregular_file() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_del_time_series_irregular_file()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
deleted_id=citydb_pkg.nrg8_delete_time_series(OLD.id, p_schema_name);
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_del_time_series_irregular_file (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_TIME_SERIES_IRREGULAR_FILE
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_ins_time_series_irregular_file() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_ins_time_series_irregular_file()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	inserted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
inserted_id=citydb_view.nrg8_insert_irregular_time_series_file(
id                   :=NEW.id,
gmlid                :=NEW.gmlid,
gmlid_codespace      :=NEW.gmlid_codespace,
name                 :=NEW.name,
name_codespace       :=NEW.name_codespace,
description          :=NEW.description,		
acquisition_method   :=NEW.acquisition_method,
interpolation_type   :=NEW.interpolation_type,
quality_description  :=NEW.quality_description,
source               :=NEW.source,
values_unit          :=NEW.values_unit,
file_path            :=NEW.file_path,
file_name            :=NEW.file_name,
file_extension       :=NEW.file_extension,
nbr_header_lines     :=NEW.nbr_header_lines,
field_sep            :=NEW.field_sep,
record_sep           :=NEW.record_sep,
dec_symbol           :=NEW.dec_symbol,
time_col_nbr         :=NEW.time_col_nbr,
value_col_nbr        :=NEW.value_col_nbr,
is_compressed        :=NEW.is_compressed,
schema_name          :=p_schema_name
);
--RAISE NOTICE 'Inserted record with id: %', inserted_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_ins_time_series_irregular_file (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_TIME_SERIES_IRREGULAR_FILE
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_upd_time_series_irregular_file() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_upd_time_series_irregular_file()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
  updated_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
EXECUTE format('UPDATE %I.nrg8_time_series AS t SET
gmlid                =%L,
gmlid_codespace      =%L,
name                 =%L,
name_codespace       =%L,
description          =%L,
acquisition_method   =%L,
interpolation_type   =%L,
quality_description  =%L,
source               =%L,
values_unit          =%L
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.gmlid,
NEW.gmlid_codespace,
NEW.name,
NEW.name_codespace,
NEW.description,			
NEW.acquisition_method,
NEW.interpolation_type,
NEW.quality_description,
NEW.source,
NEW.values_unit,
OLD.id
) INTO updated_id;
EXECUTE format('UPDATE %I.nrg8_time_series_file AS t SET
file_path            =%L,
file_name            =%L,
file_extension       =%L,
nbr_header_lines     =%L,
field_sep            =%L,
record_sep           =%L,
dec_symbol           =%L,
time_col_nbr         =%L,
value_col_nbr        =%L,
is_compressed        =%L
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.file_path,
NEW.file_name,
NEW.file_extension,
NEW.nbr_header_lines,
NEW.field_sep,
NEW.record_sep,
NEW.dec_symbol,
NEW.time_col_nbr,
NEW.value_col_nbr,
NEW.is_compressed,
OLD.id
) INTO updated_id;
-- RAISE NOTICE 'Updated record with id: %',updated_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_upd_time_series_irregular_file (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view TIME_SERIES_IRREGULAR_FILE
----------------------------------------------------------------
DROP TRIGGER IF EXISTS nrg8_tr_del_time_series_irregular_file ON citydb_view.nrg8_time_series_irregular_file;
CREATE TRIGGER nrg8_tr_del_time_series_irregular_file
	INSTEAD OF DELETE ON citydb_view.nrg8_time_series_irregular_file
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_del_time_series_irregular_file ('citydb');

DROP TRIGGER IF EXISTS nrg8_tr_ins_time_series_irregular_file ON citydb_view.nrg8_time_series_irregular_file;
CREATE TRIGGER nrg8_tr_ins_time_series_irregular_file
	INSTEAD OF INSERT ON citydb_view.nrg8_time_series_irregular_file
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_ins_time_series_irregular_file ('citydb');

DROP TRIGGER IF EXISTS nrg8_tr_upd_time_series_irregular_file ON citydb_view.nrg8_time_series_irregular_file;
CREATE TRIGGER nrg8_tr_upd_time_series_irregular_file
	INSTEAD OF UPDATE ON citydb_view.nrg8_time_series_irregular_file
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_upd_time_series_irregular_file ('citydb');
-- ***********************************************************************
-- ***********************************************************************

----------------------------------------------------------------
-- Function TR_DEL_DAILY_SCHEDULE
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_del_daily_schedule() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_del_daily_schedule()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
deleted_id=citydb_pkg.nrg8_delete_daily_schedule(OLD.id, p_schema_name);
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_del_daily_schedule (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_DAILY_SCHEDULE
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_ins_daily_schedule() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_ins_daily_schedule()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	inserted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
inserted_id=citydb_view.nrg8_insert_daily_schedule(
id                   :=NEW.id,
day_type             :=NEW.day_type,
period_of_year_id    :=NEW.period_of_year_id,
time_series_id       :=NEW.time_series_id,
schema_name          :=p_schema_name
);
--RAISE NOTICE 'Inserted record with id: %', inserted_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_ins_daily_schedule (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_DAILY_SCHEDULE
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_upd_daily_schedule() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_upd_daily_schedule()
  RETURNS trigger AS
$BODY$
DECLARE
  p_schema_name varchar DEFAULT 'citydb'::varchar;
  updated_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
EXECUTE format('UPDATE %I.nrg8_daily_schedule AS t SET
day_type         =%L,
period_of_year_id=%L,
time_series_id   =%L 
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.day_type,
NEW.period_of_year_id, 
NEW.time_series_id, 
OLD.id
) INTO updated_id;
-- RAISE NOTICE 'Updated record with id: %',updated_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_upd_daily_schedule (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view DAILY_SCHEDULE
----------------------------------------------------------------
DROP TRIGGER IF EXISTS nrg8_tr_del_daily_schedule ON citydb_view.nrg8_daily_schedule;
CREATE TRIGGER nrg8_tr_del_daily_schedule
	INSTEAD OF DELETE ON citydb_view.nrg8_daily_schedule
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_del_daily_schedule ('citydb');

DROP TRIGGER IF EXISTS nrg8_tr_ins_daily_schedule ON citydb_view.nrg8_daily_schedule;
CREATE TRIGGER nrg8_tr_ins_daily_schedule
	INSTEAD OF INSERT ON citydb_view.nrg8_daily_schedule
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_ins_daily_schedule ('citydb');

DROP TRIGGER IF EXISTS nrg8_tr_upd_daily_schedule ON citydb_view.nrg8_daily_schedule;
CREATE TRIGGER nrg8_tr_upd_daily_schedule
	INSTEAD OF UPDATE ON citydb_view.nrg8_daily_schedule
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_upd_daily_schedule ('citydb');
--**************************************************************
--**************************************************************

----------------------------------------------------------------
-- Function TR_DEL_PERIOD_OF_YEAR
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_del_period_of_year() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_del_period_of_year()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
deleted_id=citydb_pkg.nrg8_delete_period_of_year(OLD.id, p_schema_name);
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_del_period_of_year (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_PERIOD_OF_YEAR
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_ins_period_of_year() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_ins_period_of_year()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	inserted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
inserted_id=citydb_view.nrg8_insert_period_of_year(
id                   :=NEW.id,
begin_time           :=NEW.begin_time,
begin_day            :=NEW.begin_day,
begin_month          :=NEW.begin_month,
end_time             :=NEW.end_time,
end_day              :=NEW.end_day,
end_month            :=NEW.end_month,
sched_id             :=NEW.sched_id,
schema_name          :=p_schema_name
);
--RAISE NOTICE 'Inserted record with id: %', inserted_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_ins_period_of_year (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_PERIOD_OF_YEAR
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_upd_period_of_year() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_upd_period_of_year()
  RETURNS trigger AS
$BODY$
DECLARE
  p_schema_name varchar DEFAULT 'citydb'::varchar;
  updated_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
EXECUTE format('UPDATE %I.nrg8_period_of_year AS t SET
begin_time =%L,
begin_day  =%L,
begin_month=%L,
end_time   =%L,
end_day    =%L,
end_month  =%L,
sched_id   =%L
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.begin_time,
NEW.begin_day,
NEW.begin_month,
NEW.end_time,
NEW.end_day,
NEW.end_month,
NEW.sched_id,
OLD.id
) INTO updated_id;
-- RAISE NOTICE 'Updated record with id: %',updated_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_upd_period_of_year (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view PERIOD_OF_YEAR
----------------------------------------------------------------
DROP TRIGGER IF EXISTS nrg8_tr_del_period_of_year ON citydb_view.nrg8_period_of_year;
CREATE TRIGGER nrg8_tr_del_period_of_year
	INSTEAD OF DELETE ON citydb_view.nrg8_period_of_year
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_del_period_of_year ('citydb');

DROP TRIGGER IF EXISTS nrg8_tr_ins_period_of_year ON citydb_view.nrg8_period_of_year;
CREATE TRIGGER nrg8_tr_ins_period_of_year
	INSTEAD OF INSERT ON citydb_view.nrg8_period_of_year
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_ins_period_of_year ('citydb');

DROP TRIGGER IF EXISTS nrg8_tr_upd_period_of_year ON citydb_view.nrg8_period_of_year;
CREATE TRIGGER nrg8_tr_upd_period_of_year
	INSTEAD OF UPDATE ON citydb_view.nrg8_period_of_year
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_upd_period_of_year ('citydb');
--**************************************************************
--**************************************************************

----------------------------------------------------------------
-- Function TR_DEL_SCHEDULE_CONSTANT_VALUE
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_del_schedule_constant_value() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_del_schedule_constant_value()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
deleted_id=citydb_pkg.nrg8_delete_schedule(OLD.id, p_schema_name);
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_del_schedule_constant_value (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_SCHEDULE_CONSTANT_VALUE
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_ins_schedule_constant_value() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_ins_schedule_constant_value()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	inserted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
inserted_id=citydb_view.nrg8_insert_constant_value_schedule(
id                   :=NEW.id,
gmlid                :=NEW.gmlid,
gmlid_codespace      :=NEW.gmlid_codespace,
name                 :=NEW.name,
name_codespace       :=NEW.name_codespace,
description          :=NEW.description,			
average_value        :=NEW.average_value,
average_value_unit   :=NEW.average_value_unit,
schema_name          :=p_schema_name
);
--RAISE NOTICE 'Inserted record with id: %', inserted_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_ins_schedule_constant_value (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_SCHEDULE_CONSTANT_VALUE
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_upd_schedule_constant_value() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_upd_schedule_constant_value()
  RETURNS trigger AS
$BODY$
DECLARE
  p_schema_name varchar DEFAULT 'citydb'::varchar;
  updated_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
EXECUTE format('UPDATE %I.nrg8_schedule AS t SET
gmlid          =%L,
gmlid_codespace=%L,
name           =%L,
name_codespace =%L,
description    =%L,
value1         =%L,
value1_unit    =%L
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.gmlid,
NEW.gmlid_codespace,
NEW.name,
NEW.name_codespace,
NEW.description,		
NEW.average_value,
NEW.average_value_unit,
OLD.id
) INTO updated_id;
-- RAISE NOTICE 'Updated record with id: %',updated_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_upd_schedule_constant_valuee (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view SCHEDULE_CONSTANT_VALUE
----------------------------------------------------------------
DROP TRIGGER IF EXISTS nrg8_tr_del_schedule_constant_value ON citydb_view.nrg8_schedule_constant_value;
CREATE TRIGGER nrg8_tr_del_schedule_constant_value
	INSTEAD OF DELETE ON citydb_view.nrg8_schedule_constant_value
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_del_schedule_constant_value ('citydb');

DROP TRIGGER IF EXISTS nrg8_tr_ins_schedule_constant_value ON citydb_view.nrg8_schedule_constant_value;
CREATE TRIGGER nrg8_tr_ins_schedule_constant_value
	INSTEAD OF INSERT ON citydb_view.nrg8_schedule_constant_value
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_ins_schedule_constant_value ('citydb');

DROP TRIGGER IF EXISTS nrg8_tr_upd_schedule_constant_value ON citydb_view.nrg8_schedule_constant_value;
CREATE TRIGGER nrg8_tr_upd_schedule_constant_value
	INSTEAD OF UPDATE ON citydb_view.nrg8_schedule_constant_value
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_upd_schedule_constant_value ('citydb');
--**************************************************************
--**************************************************************

----------------------------------------------------------------
-- Function TR_DEL_SCHEDULE_DUAL_VALUE
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_del_schedule_dual_value() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_del_schedule_dual_value()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
deleted_id=citydb_pkg.nrg8_delete_schedule(OLD.id, p_schema_name);
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_del_schedule_dual_value (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_SCHEDULE_DUAL_VALUE
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_ins_schedule_dual_value() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_ins_schedule_dual_value()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	inserted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
inserted_id=citydb_view.nrg8_insert_dual_value_schedule(
id                   :=NEW.id,
gmlid                :=NEW.gmlid,
gmlid_codespace      :=NEW.gmlid_codespace,
name                 :=NEW.name,
name_codespace       :=NEW.name_codespace,
description          :=NEW.description,	
idle_value           :=NEW.idle_value,
idle_value_unit      :=NEW.idle_value_unit,
usage_value          :=NEW.usage_value,
usage_value_unit     :=NEW.usage_value_unit,
hours_per_day        :=NEW.hours_per_day,
days_per_year        :=NEW.days_per_year,
schema_name          :=p_schema_name
);
--RAISE NOTICE 'Inserted record with id: %', inserted_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_ins_schedule_dual_value (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_SCHEDULE_DUAL_VALUE
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_upd_schedule_dual_value() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_upd_schedule_dual_value()
  RETURNS trigger AS
$BODY$
DECLARE
  p_schema_name varchar DEFAULT 'citydb'::varchar;
  updated_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
EXECUTE format('UPDATE %I.nrg8_schedule AS t SET
gmlid          =%L,
gmlid_codespace=%L,
name           =%L,
name_codespace =%L,
description    =%L,
value1         =%L,
value1_unit    =%L,
value2         =%L,
value2_unit    =%L,
hours_per_day  =%L,
days_per_year  =%L
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.gmlid,
NEW.gmlid_codespace,
NEW.name,
NEW.name_codespace,
NEW.description,
NEW.idle_value,
NEW.idle_value_unit,
NEW.usage_value,
NEW.usage_value_unit,
NEW.hours_per_day,
NEW.days_per_year,
OLD.id
) INTO updated_id;
-- RAISE NOTICE 'Updated record with id: %',updated_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_upd_schedule_dual_value (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view SCHEDULE_DUAL_VALUE
----------------------------------------------------------------
DROP TRIGGER IF EXISTS nrg8_tr_del_schedule_dual_value ON citydb_view.nrg8_schedule_dual_value;
CREATE TRIGGER nrg8_tr_del_schedule_dual_value
	INSTEAD OF DELETE ON citydb_view.nrg8_schedule_dual_value
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_del_schedule_dual_value ('citydb');

DROP TRIGGER IF EXISTS nrg8_tr_ins_schedule_dual_value ON citydb_view.nrg8_schedule_dual_value;
CREATE TRIGGER nrg8_tr_ins_schedule_dual_value
	INSTEAD OF INSERT ON citydb_view.nrg8_schedule_dual_value
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_ins_schedule_dual_value ('citydb');

DROP TRIGGER IF EXISTS nrg8_tr_upd_schedule_dual_value ON citydb_view.nrg8_schedule_dual_value;
CREATE TRIGGER nrg8_tr_upd_schedule_dual_value
	INSTEAD OF UPDATE ON citydb_view.nrg8_schedule_dual_value
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_upd_schedule_dual_value ('citydb');
--**************************************************************
--**************************************************************

----------------------------------------------------------------
-- Function TR_DEL_SCHEDULE_DAILY_PATTERN
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_del_schedule_daily_pattern() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_del_schedule_daily_pattern()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
deleted_id=citydb_pkg.nrg8_delete_schedule(OLD.id, p_schema_name);
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_del_schedule_daily_pattern (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_SCHEDULE_DAILY_PATTERN
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_ins_schedule_daily_pattern() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_ins_schedule_daily_pattern()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	inserted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
inserted_id=citydb_view.nrg8_insert_daily_pattern_schedule(
id                   :=NEW.id,
gmlid                :=NEW.gmlid,
gmlid_codespace      :=NEW.gmlid_codespace,
name                 :=NEW.name,
name_codespace       :=NEW.name_codespace,
description          :=NEW.description,	
schema_name          :=p_schema_name
);
-- RAISE NOTICE 'Inserted new % with id: %',class_name, inserted_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_ins_schedule_daily_pattern (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_SCHEDULE_DAILY_PATTERN
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_upd_schedule_daily_pattern() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_upd_schedule_daily_pattern()
  RETURNS trigger AS
$BODY$
DECLARE
  p_schema_name varchar DEFAULT 'citydb'::varchar;
  updated_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
EXECUTE format('UPDATE %I.nrg8_schedule AS t SET
gmlid          =%L,
gmlid_codespace=%L,
name           =%L,
name_codespace =%L,
description    =%L
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.gmlid,
NEW.gmlid_codespace,
NEW.name,
NEW.name_codespace,
NEW.description,	
OLD.id
) INTO updated_id;
-- RAISE NOTICE 'Updated record with id: %',updated_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_upd_schedule_daily_pattern (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view SCHEDULE_DAILY_PATTERN
----------------------------------------------------------------
DROP TRIGGER IF EXISTS nrg8_tr_del_schedule_daily_pattern ON citydb_view.nrg8_schedule_daily_pattern;
CREATE TRIGGER nrg8_tr_del_schedule_daily_pattern
	INSTEAD OF DELETE ON citydb_view.nrg8_schedule_daily_pattern
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_del_schedule_daily_pattern ('citydb');

DROP TRIGGER IF EXISTS nrg8_tr_ins_schedule_daily_pattern ON citydb_view.nrg8_schedule_daily_pattern;
CREATE TRIGGER nrg8_tr_ins_schedule_daily_pattern
	INSTEAD OF INSERT ON citydb_view.nrg8_schedule_daily_pattern
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_ins_schedule_daily_pattern ('citydb');

DROP TRIGGER IF EXISTS nrg8_tr_upd_schedule_daily_pattern ON citydb_view.nrg8_schedule_daily_pattern;
CREATE TRIGGER nrg8_tr_upd_schedule_daily_pattern
	INSTEAD OF UPDATE ON citydb_view.nrg8_schedule_daily_pattern
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_upd_schedule_daily_pattern ('citydb');
--**************************************************************
--**************************************************************

----------------------------------------------------------------
-- Function TR_DEL_SCHEDULE_TIME_SERIES
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_del_schedule_time_series() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_del_schedule_time_series()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
deleted_id=citydb_pkg.nrg8_delete_schedule(OLD.id, p_schema_name);
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_del_schedule_time_series (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_SCHEDULE_TIME_SERIES
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_ins_schedule_time_series() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_ins_schedule_time_series()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	inserted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
inserted_id=citydb_view.nrg8_insert_time_series_schedule(
id                   :=NEW.id,
gmlid                :=NEW.gmlid,
gmlid_codespace      :=NEW.gmlid_codespace,
name                 :=NEW.name,
name_codespace       :=NEW.name_codespace,
description          :=NEW.description,
time_series_id       :=NEW.time_series_id,
schema_name          :=p_schema_name
);
--RAISE NOTICE 'Inserted record with id: %', inserted_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_ins_schedule_time_series (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_SCHEDULE_TIME_SERIES
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_upd_schedule_time_series() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_upd_schedule_time_series()
  RETURNS trigger AS
$BODY$
DECLARE
  p_schema_name varchar DEFAULT 'citydb'::varchar;
  updated_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
EXECUTE format('UPDATE %I.nrg8_schedule AS t SET
gmlid          =%L,
gmlid_codespace=%L,
name           =%L,
name_codespace =%L,
description    =%L,
time_series_id =%L
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.gmlid,
NEW.gmlid_codespace,
NEW.name,
NEW.name_codespace,
NEW.description,	
NEW.time_series_id,
OLD.id
) INTO updated_id;
-- RAISE NOTICE 'Updated record with id: %',updated_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_upd_schedule_time_series (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view SCHEDULE_TIME_SERIES
----------------------------------------------------------------
DROP TRIGGER IF EXISTS nrg8_tr_del_schedule_time_series ON citydb_view.nrg8_schedule_time_series;
CREATE TRIGGER nrg8_tr_del_schedule_time_series
	INSTEAD OF DELETE ON citydb_view.nrg8_schedule_time_series
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_del_schedule_time_series ('citydb');

DROP TRIGGER IF EXISTS nrg8_tr_ins_schedule_time_series ON citydb_view.nrg8_schedule_time_series;
CREATE TRIGGER nrg8_tr_ins_schedule_time_series
	INSTEAD OF INSERT ON citydb_view.nrg8_schedule_time_series
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_ins_schedule_time_series ('citydb');

DROP TRIGGER IF EXISTS nrg8_tr_upd_schedule_time_series ON citydb_view.nrg8_schedule_time_series;
CREATE TRIGGER nrg8_tr_upd_schedule_time_series
	INSTEAD OF UPDATE ON citydb_view.nrg8_schedule_time_series
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_upd_schedule_time_series ('citydb');
--**************************************************************
--**************************************************************

----------------------------------------------------------------
-- Function TR_DEL_CONSTRUCTION_BASE
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_del_construction_base() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_del_construction_base()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
deleted_id=citydb_pkg.nrg8_delete_construction(OLD.id, p_schema_name);
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_del_construction_base (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_CONSTRUCTION_BASE
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_ins_construction_base() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_ins_construction_base()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	inserted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
inserted_id=citydb_view.nrg8_insert_base_construction(
id                      :=NEW.id,
gmlid                   :=NEW.gmlid,
gmlid_codespace         :=NEW.gmlid_codespace,
name                    :=NEW.name,
name_codespace          :=NEW.name_codespace,
description             :=NEW.description,
u_value                 :=NEW.u_value,
u_value_unit            :=NEW.u_value_unit,
glazing_ratio           :=NEW.glazing_ratio,
start_of_life           :=NEW.start_of_life,
life_expect_value       :=NEW.life_expect_value,
life_expect_value_unit  :=NEW.life_expect_value_unit,
main_maint_interval     :=NEW.main_maint_interval,
main_maint_interval_unit:=NEW.main_maint_interval_unit,
schema_name             :=p_schema_name
);
--RAISE NOTICE 'Inserted record with id: %', inserted_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_ins_construction_base (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_CONSTRUCTION_BASE
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_upd_construction_base() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_upd_construction_base()
  RETURNS trigger AS
$BODY$
DECLARE
  p_schema_name varchar DEFAULT 'citydb'::varchar;
  updated_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
EXECUTE format('UPDATE %I.nrg8_construction AS t SET
gmlid                   =%L,
gmlid_codespace         =%L,
name                    =%L,
name_codespace          =%L,
description             =%L,
u_value                 =%L,
u_value_unit            =%L,
glazing_ratio           =%L,
start_of_life           =%L,
life_expect_value       =%L,
life_expect_value_unit  =%L,
main_maint_interval     =%L,
main_maint_interval_unit=%L
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.gmlid,
NEW.gmlid_codespace,
NEW.name,
NEW.name_codespace,
NEW.description,
NEW.u_value,
NEW.u_value_unit,
NEW.glazing_ratio,
NEW.start_of_life,
NEW.life_expect_value,
NEW.life_expect_value_unit,
NEW.main_maint_interval,
NEW.main_maint_interval_unit,
OLD.id
) INTO updated_id;
-- RAISE NOTICE 'Updated record with id: %',updated_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_upd_construction_base (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view CONSTRUCTION_BASE
----------------------------------------------------------------
DROP TRIGGER IF EXISTS nrg8_tr_del_construction_base ON citydb_view.nrg8_construction_base;
CREATE TRIGGER nrg8_tr_del_construction_base
	INSTEAD OF DELETE ON citydb_view.nrg8_construction_base
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_del_construction_base ('citydb');

DROP TRIGGER IF EXISTS nrg8_tr_ins_construction_base ON citydb_view.nrg8_construction_base;
CREATE TRIGGER nrg8_tr_ins_construction_base
	INSTEAD OF INSERT ON citydb_view.nrg8_construction_base
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_ins_construction_base ('citydb');

DROP TRIGGER IF EXISTS nrg8_tr_upd_construction_base ON citydb_view.nrg8_construction_base;
CREATE TRIGGER nrg8_tr_upd_construction_base
	INSTEAD OF UPDATE ON citydb_view.nrg8_construction_base
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_upd_construction_base ('citydb');
--**************************************************************
--**************************************************************

----------------------------------------------------------------
-- Function TR_DEL_CONSTRUCTION_REVERSE
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_del_construction_reverse() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_del_construction_reverse()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
deleted_id=citydb_pkg.nrg8_delete_construction(OLD.id, p_schema_name);
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_del_construction_reverse (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_CONSTRUCTION_REVERSE
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_ins_construction_reverse() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_ins_construction_reverse()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	inserted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
inserted_id=citydb_view.nrg8_insert_reverse_construction(
id                      :=NEW.id,
gmlid                   :=NEW.gmlid,
gmlid_codespace         :=NEW.gmlid_codespace,
name                    :=NEW.name,
name_codespace          :=NEW.name_codespace,
description             :=NEW.description,
base_constr_id          :=NEW.base_constr_id,
schema_name             :=p_schema_name
);
--RAISE NOTICE 'Inserted record with id: %', inserted_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_ins_construction_reverse (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_CONSTRUCTION_REVERSE
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_upd_construction_reverse() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_upd_construction_reverse()
  RETURNS trigger AS
$BODY$
DECLARE
  p_schema_name varchar DEFAULT 'citydb'::varchar;
  updated_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
EXECUTE format('UPDATE %I.nrg8_construction AS t SET
gmlid                   =%L,
gmlid_codespace         =%L,
name                    =%L,
name_codespace          =%L,
description             =%L,
base_constr_id          =%L
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.gmlid,
NEW.gmlid_codespace,
NEW.name,
NEW.name_codespace,
NEW.description,
NEW.base_constr_id,
OLD.id
) INTO updated_id;
-- RAISE NOTICE 'Updated record with id: %',updated_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_upd_construction_reverse (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view CONSTRUCTION_REVERSE
----------------------------------------------------------------
DROP TRIGGER IF EXISTS nrg8_tr_del_construction_reverse ON citydb_view.nrg8_construction_reverse;
CREATE TRIGGER nrg8_tr_del_construction_reverse
	INSTEAD OF DELETE ON citydb_view.nrg8_construction_reverse
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_del_construction_reverse ('citydb');

DROP TRIGGER IF EXISTS nrg8_tr_ins_construction_reverse ON citydb_view.nrg8_construction_reverse;
CREATE TRIGGER nrg8_tr_ins_construction_reverse
	INSTEAD OF INSERT ON citydb_view.nrg8_construction_reverse
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_ins_construction_reverse ('citydb');

DROP TRIGGER IF EXISTS nrg8_tr_upd_construction_reverse ON citydb_view.nrg8_construction_reverse;
CREATE TRIGGER nrg8_tr_upd_construction_reverse
	INSTEAD OF UPDATE ON citydb_view.nrg8_construction_reverse
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_upd_construction_reverse ('citydb');
--**************************************************************
--**************************************************************

----------------------------------------------------------------
-- Function TR_DEL_OPTICAL_PROPERTY_EMISSIVITY
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_del_optical_property_emissivity() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_del_optical_property_emissivity()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
EXECUTE format('DELETE FROM %I.nrg8_optical_property WHERE id=%L RETURNING id', schema_name, OLD.id) INTO deleted_id;
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_del_optical_property_emissivity (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_OPTICAL_PROPERTY_EMISSIVITY
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_ins_optical_property_emissivity() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_ins_optical_property_emissivity()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	inserted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
inserted_id=citydb_view.nrg8_insert_emissivity(
id             :=NEW.id,
fraction       :=NEW.fraction,
surf_side      :=NEW.surf_side,
constr_id      :=NEW.constr_id,
schema_name      :=p_schema_name
);
--RAISE NOTICE 'Inserted record with id: %', inserted_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_ins_optical_property_emissivity (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_OPTICAL_PROPERTY_EMISSIVITY
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_upd_optical_property_emissivity() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_upd_optical_property_emissivity()
  RETURNS trigger AS
$BODY$
DECLARE
  p_schema_name varchar DEFAULT 'citydb'::varchar;
  updated_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
EXECUTE format('UPDATE %I.nrg8_optical_property AS t SET
fraction =%L,
surf_side=%L,
constr_id=%L
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.fraction,
NEW.surf_side,
NEW.constr_id,
OLD.id
) INTO updated_id;
-- RAISE NOTICE 'Updated record with id: %',updated_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_upd_optical_property_emissivity (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view OPTICAL_PROPERTY_EMISSIVITY
----------------------------------------------------------------
DROP TRIGGER IF EXISTS nrg8_tr_del_optical_property_emissivity ON citydb_view.nrg8_optical_property_emissivity;
CREATE TRIGGER nrg8_tr_del_optical_property_emissivity
	INSTEAD OF DELETE ON citydb_view.nrg8_optical_property_emissivity
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_del_optical_property_emissivity ('citydb');

DROP TRIGGER IF EXISTS nrg8_tr_ins_optical_property_emissivity ON citydb_view.nrg8_optical_property_emissivity;
CREATE TRIGGER nrg8_tr_ins_optical_property_emissivity
	INSTEAD OF INSERT ON citydb_view.nrg8_optical_property_emissivity
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_ins_optical_property_emissivity ('citydb');

DROP TRIGGER IF EXISTS nrg8_tr_upd_optical_property_emissivity ON citydb_view.nrg8_optical_property_emissivity;
CREATE TRIGGER nrg8_tr_upd_optical_property_emissivity
	INSTEAD OF UPDATE ON citydb_view.nrg8_optical_property_emissivity
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_upd_optical_property_emissivity ('citydb');
--**************************************************************
--**************************************************************

----------------------------------------------------------------
-- Function TR_DEL_OPTICAL_PROPERTY_REFLECTANCE
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_del_optical_property_reflectance() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_del_optical_property_reflectance()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
EXECUTE format('DELETE FROM %I.nrg8_optical_property WHERE id=%L RETURNING id', schema_name, OLD.id) INTO deleted_id;
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_del_optical_property_reflectance (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_OPTICAL_PROPERTY_REFLECTANCE
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_ins_optical_property_reflectance() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_ins_optical_property_reflectance()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	inserted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
inserted_id=citydb_view.nrg8_insert_reflectance(
id             :=NEW.id,
fraction       :=NEW.fraction,
range          :=NEW.range,
surf_side      :=NEW.surf_side,
constr_id      :=NEW.constr_id,
schema_name    :=p_schema_name
);
--RAISE NOTICE 'Inserted record with id: %', inserted_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_ins_optical_property_reflectance (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_OPTICAL_PROPERTY_REFLECTANCE
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_upd_optical_property_reflectance() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_upd_optical_property_reflectance()
  RETURNS trigger AS
$BODY$
DECLARE
  p_schema_name varchar DEFAULT 'citydb'::varchar;
  updated_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
EXECUTE format('UPDATE %I.nrg8_optical_property AS t SET
fraction =%L,
range    =%L,
surf_side=%L,
constr_id=%L
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.fraction,
NEW.range,
NEW.surf_side,
NEW.constr_id,
OLD.id
) INTO updated_id;
-- RAISE NOTICE 'Updated record with id: %',updated_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_upd_optical_property_reflectance (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view OPTICAL_PROPERTY_REFLECTANCE
----------------------------------------------------------------
DROP TRIGGER IF EXISTS nrg8_tr_del_optical_property_reflectance ON citydb_view.nrg8_optical_property_reflectance;
CREATE TRIGGER nrg8_tr_del_optical_property_reflectance
	INSTEAD OF DELETE ON citydb_view.nrg8_optical_property_reflectance
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_del_optical_property_reflectance ('citydb');

DROP TRIGGER IF EXISTS nrg8_tr_ins_optical_property_reflectance ON citydb_view.nrg8_optical_property_reflectance;
CREATE TRIGGER nrg8_tr_ins_optical_property_reflectance
	INSTEAD OF INSERT ON citydb_view.nrg8_optical_property_reflectance
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_ins_optical_property_reflectance ('citydb');

DROP TRIGGER IF EXISTS nrg8_tr_upd_optical_property_reflectance ON citydb_view.nrg8_optical_property_reflectance;
CREATE TRIGGER nrg8_tr_upd_optical_property_reflectance
	INSTEAD OF UPDATE ON citydb_view.nrg8_optical_property_reflectance
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_upd_optical_property_reflectance ('citydb');
--**************************************************************
--**************************************************************

----------------------------------------------------------------
-- Function TR_DEL_OPTICAL_PROPERTY_TRANSMITTANCE
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_del_optical_property_transmittance() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_del_optical_property_transmittance()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
EXECUTE format('DELETE FROM %I.nrg8_optical_property WHERE id=%L RETURNING id', schema_name, OLD.id) INTO deleted_id;
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_del_optical_property_transmittance (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_OPTICAL_PROPERTY_TRANSMITTANCE
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_ins_optical_property_transmittance() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_ins_optical_property_transmittance()
  RETURNS trigger AS
$BODY$
DECLARE
	class_name varchar DEFAULT 'Transmittance'::varchar;

	p_schema_name varchar DEFAULT 'citydb'::varchar;

	inserted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
inserted_id=citydb_view.nrg8_insert_transmittance(
id             :=NEW.id,
fraction       :=NEW.fraction,
range          :=NEW.range,
constr_id      :=NEW.constr_id,
schema_name      :=p_schema_name
);
--RAISE NOTICE 'Inserted record with id: %', inserted_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_ins_optical_property_transmittance (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_OPTICAL_PROPERTY_TRANSMITTANCE
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_upd_optical_property_transmittance() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_upd_optical_property_transmittance()
  RETURNS trigger AS
$BODY$
DECLARE
  p_schema_name varchar DEFAULT 'citydb'::varchar;
  updated_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
EXECUTE format('UPDATE %I.nrg8_optical_property AS t SET
fraction   =%L,
range      =%L,
constr_id  =%L
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.fraction,
NEW.range,
NEW.constr_id,
OLD.id
) INTO updated_id;
-- RAISE NOTICE 'Updated record with id: %',updated_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_upd_optical_property_transmittance (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view OPTICAL_PROPERTY_TRANSMITTANCE
----------------------------------------------------------------
DROP TRIGGER IF EXISTS nrg8_tr_del_optical_property_transmittance ON citydb_view.nrg8_optical_property_transmittance;
CREATE TRIGGER nrg8_tr_del_optical_property_transmittance
	INSTEAD OF DELETE ON citydb_view.nrg8_optical_property_transmittance
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_del_optical_property_transmittance ('citydb');

DROP TRIGGER IF EXISTS nrg8_tr_ins_optical_property_transmittance ON citydb_view.nrg8_optical_property_transmittance;
CREATE TRIGGER nrg8_tr_ins_optical_property_transmittance
	INSTEAD OF INSERT ON citydb_view.nrg8_optical_property_transmittance
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_ins_optical_property_transmittance ('citydb');

DROP TRIGGER IF EXISTS nrg8_tr_upd_optical_property_transmittance ON citydb_view.nrg8_optical_property_transmittance;
CREATE TRIGGER nrg8_tr_upd_optical_property_transmittance
	INSTEAD OF UPDATE ON citydb_view.nrg8_optical_property_transmittance
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_upd_optical_property_transmittance ('citydb');
--**************************************************************
--**************************************************************

----------------------------------------------------------------
-- Function TR_DEL_LAYER
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_del_layer() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_del_layer()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
deleted_id=citydb_pkg.nrg8_delete_layer(OLD.id, p_schema_name);
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_del_layer (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_LAYER
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_ins_layer() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_ins_layer()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	inserted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
inserted_id=citydb_view.nrg8_insert_layer(
id               :=NEW.id,
gmlid            :=NEW.gmlid,
gmlid_codespace  :=NEW.gmlid_codespace,
name             :=NEW.name,
name_codespace   :=NEW.name_codespace,
description      :=NEW.description,
pos_nbr         :=NEW.pos_nbr,
constr_id        :=NEW.constr_id,
schema_name        :=p_schema_name
);
--RAISE NOTICE 'Inserted record with id: %', inserted_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_ins_layer (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_LAYER
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_upd_layer() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_upd_layer()
  RETURNS trigger AS
$BODY$
DECLARE
  p_schema_name varchar DEFAULT 'citydb'::varchar;
  updated_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
EXECUTE format('UPDATE %I.nrg8_layer AS t SET
gmlid            =%L,
gmlid_codespace  =%L,
name             =%L,
name_codespace   =%L,
description      =%L,
pos_nbr          =%L,
constr_id        =%L
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.gmlid,
NEW.gmlid_codespace,
NEW.name,
NEW.name_codespace,
NEW.description,
NEW.pos_nbr,
NEW.constr_id,
OLD.id
) INTO updated_id;
-- RAISE NOTICE 'Updated record with id: %',updated_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_upd_layer (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view LAYER
----------------------------------------------------------------
DROP TRIGGER IF EXISTS nrg8_tr_del_layer ON citydb_view.nrg8_layer;
CREATE TRIGGER nrg8_tr_del_layer
	INSTEAD OF DELETE ON citydb_view.nrg8_layer
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_del_layer ('citydb');

DROP TRIGGER IF EXISTS nrg8_tr_ins_layer ON citydb_view.nrg8_layer;
CREATE TRIGGER nrg8_tr_ins_layer
	INSTEAD OF INSERT ON citydb_view.nrg8_layer
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_ins_layer ('citydb');

DROP TRIGGER IF EXISTS nrg8_tr_upd_layer ON citydb_view.nrg8_layer;
CREATE TRIGGER nrg8_tr_upd_layer
	INSTEAD OF UPDATE ON citydb_view.nrg8_layer
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_upd_layer ('citydb');
--**************************************************************
--**************************************************************

----------------------------------------------------------------
-- Function TR_DEL_LAYER_COMPONENT
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_del_layer_component() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_del_layer_component()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
deleted_id=citydb_pkg.nrg8_delete_layer_component(OLD.id, p_schema_name);
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_del_layer_component (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_LAYER_COMPONENT
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_ins_layer_component() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_ins_layer_component()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	inserted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
inserted_id=citydb_view.nrg8_insert_layer_component(
id                      :=NEW.id,
gmlid                   :=NEW.gmlid,
gmlid_codespace         :=NEW.gmlid_codespace,
name                    :=NEW.name,
name_codespace          :=NEW.name_codespace,
description             :=NEW.description,
area_fr                 :=NEW.area_fr,
thickness               :=NEW.thickness,
thickness_unit          :=NEW.thickness_unit,
start_of_life           :=NEW.start_of_life,
life_expect_value       :=NEW.life_expect_value,
life_expect_value_unit  :=NEW.life_expect_value_unit,
main_maint_interval     :=NEW.main_maint_interval,
main_maint_interval_unit:=NEW.main_maint_interval_unit,
layer_id                :=NEW.layer_id,
schema_name               :=p_schema_name
);
--RAISE NOTICE 'Inserted record with id: %', inserted_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_ins_layer_component (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_LAYER_COMPONENT
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_upd_layer_component() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_upd_layer_component()
  RETURNS trigger AS
$BODY$
DECLARE
  p_schema_name varchar DEFAULT 'citydb'::varchar;
  updated_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
EXECUTE format('UPDATE %I.nrg8_layer_component AS t SET
gmlid                   =%L,
gmlid_codespace         =%L,
name                    =%L,
name_codespace          =%L,
description             =%L,
area_fr                 =%L,
thickness               =%L,
thickness_unit          =%L,
start_of_life           =%L,
life_expect_value       =%L,
life_expect_value_unit  =%L,
main_maint_interval     =%L,
main_maint_interval_unit=%L,
layer_id                =%L
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.gmlid,
NEW.gmlid_codespace,
NEW.name,
NEW.name_codespace,
NEW.description,
NEW.area_fr,
NEW.thickness,
NEW.thickness_unit,
NEW.start_of_life,
NEW.life_expect_value,
NEW.life_expect_value_unit,
NEW.main_maint_interval,
NEW.main_maint_interval_unit,
NEW.layer_id,
OLD.id
) INTO updated_id;
-- RAISE NOTICE 'Updated record with id: %',updated_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_upd_layer_component (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view LAYER_COMPONENT
----------------------------------------------------------------
DROP TRIGGER IF EXISTS nrg8_tr_del_layer_component ON citydb_view.nrg8_layer_component;
CREATE TRIGGER nrg8_tr_del_layer_component
	INSTEAD OF DELETE ON citydb_view.nrg8_layer_component
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_del_layer_component ('citydb');

DROP TRIGGER IF EXISTS nrg8_tr_ins_layer_component ON citydb_view.nrg8_layer_component;
CREATE TRIGGER nrg8_tr_ins_layer_component
	INSTEAD OF INSERT ON citydb_view.nrg8_layer_component
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_ins_layer_component ('citydb');

DROP TRIGGER IF EXISTS nrg8_tr_upd_layer_component ON citydb_view.nrg8_layer_component;
CREATE TRIGGER nrg8_tr_upd_layer_component
	INSTEAD OF UPDATE ON citydb_view.nrg8_layer_component
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_upd_layer_component ('citydb');
--**************************************************************
--**************************************************************

----------------------------------------------------------------
-- Function TR_DEL_MATERIAL_GAS
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_del_material_gas() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_del_material_gas()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
deleted_id=citydb_pkg.nrg8_delete_material(OLD.id, p_schema_name);
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_del_material_gas (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_MATERIAL_GAS
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_ins_material_gas() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_ins_material_gas()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	inserted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
inserted_id=citydb_view.nrg8_insert_gas(
id                   :=NEW.id,
gmlid                :=NEW.gmlid,
gmlid_codespace      :=NEW.gmlid_codespace,
name                 :=NEW.name,
name_codespace       :=NEW.name_codespace,
description          :=NEW.description,
is_ventilated        :=NEW.is_ventilated,
r_value              :=NEW.r_value,
r_value_unit         :=NEW.r_value_unit,
embodied_carbon      :=NEW.embodied_carbon,
embodied_carbon_unit :=NEW.embodied_carbon_unit,
embodied_nrg         :=NEW.embodied_nrg,
embodied_nrg_unit    :=NEW.embodied_nrg_unit,
layer_component_id   :=NEW.layer_component_id,
schema_name          :=p_schema_name
);
--RAISE NOTICE 'Inserted record with id: %', inserted_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_ins_material_gas (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_MATERIAL_GAS
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_upd_material_gas() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_upd_material_gas()
  RETURNS trigger AS
$BODY$
DECLARE
  p_schema_name varchar DEFAULT 'citydb'::varchar;
  updated_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
EXECUTE format('UPDATE %I.nrg8_material AS t SET
gmlid               =%L,
gmlid_codespace     =%L,
name                =%L,
name_codespace      =%L,
description         =%L,
is_ventilated       =%L,
r_value             =%L,
r_value_unit        =%L,
embodied_carbon     =%L,
embodied_carbon_unit=%L,
embodied_nrg        =%L,
embodied_nrg_unit   =%L,
layer_component_id  =%L
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.gmlid,
NEW.gmlid_codespace,
NEW.name,
NEW.name_codespace,
NEW.description,
NEW.is_ventilated,
NEW.r_value,
NEW.r_value_unit,
NEW.embodied_carbon,
NEW.embodied_carbon_unit,
NEW.embodied_nrg,
NEW.embodied_nrg_unit,
NEW.layer_component_id,
OLD.id
) INTO updated_id;
-- RAISE NOTICE 'Updated record with id: %',updated_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_upd_material_gas (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view MATERIAL_GAS
----------------------------------------------------------------
DROP TRIGGER IF EXISTS nrg8_tr_del_material_gas ON citydb_view.nrg8_material_gas;
CREATE TRIGGER nrg8_tr_del_material_gas
	INSTEAD OF DELETE ON citydb_view.nrg8_material_gas
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_del_material_gas ('citydb');

DROP TRIGGER IF EXISTS nrg8_tr_ins_material_gas ON citydb_view.nrg8_material_gas;
CREATE TRIGGER nrg8_tr_ins_material_gas
	INSTEAD OF INSERT ON citydb_view.nrg8_material_gas
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_ins_material_gas ('citydb');

DROP TRIGGER IF EXISTS nrg8_tr_upd_material_gas ON citydb_view.nrg8_material_gas;
CREATE TRIGGER nrg8_tr_upd_material_gas
	INSTEAD OF UPDATE ON citydb_view.nrg8_material_gas
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_upd_material_gas ('citydb');

--**************************************************************
--**************************************************************

----------------------------------------------------------------
-- Function TR_DEL_MATERIAL_SOLID
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_del_material_solid() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_del_material_solid()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
deleted_id=citydb_pkg.nrg8_delete_material(OLD.id, p_schema_name);
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_del_material_solid (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_MATERIAL_SOLID
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_ins_material_solid() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_ins_material_solid()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	inserted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
inserted_id=citydb_view.nrg8_insert_solid_material(
id                   :=NEW.id,
gmlid                :=NEW.gmlid,
gmlid_codespace      :=NEW.gmlid_codespace,
name                 :=NEW.name,
name_codespace       :=NEW.name_codespace,
description          :=NEW.description,
density              :=NEW.density,
density_unit         :=NEW.density_unit,
specific_heat        :=NEW.specific_heat,
specific_heat_unit   :=NEW.specific_heat_unit,
conductivity         :=NEW.conductivity,
conductivity_unit    :=NEW.conductivity_unit,
permeance            :=NEW.permeance,
permeance_unit       :=NEW.permeance_unit,
porosity             :=NEW.porosity,
embodied_carbon      :=NEW.embodied_carbon,
embodied_carbon_unit :=NEW.embodied_carbon_unit,
embodied_nrg         :=NEW.embodied_nrg,
embodied_nrg_unit    :=NEW.embodied_nrg_unit,
layer_component_id   :=NEW.layer_component_id,
schema_name          :=p_schema_name
);
--RAISE NOTICE 'Inserted record with id: %', inserted_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_ins_material_solid (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_MATERIAL_SOLID
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_upd_material_solid() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_upd_material_solid()
  RETURNS trigger AS
$BODY$
DECLARE
  p_schema_name varchar DEFAULT 'citydb'::varchar;
  updated_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
EXECUTE format('UPDATE %I.nrg8_material AS t SET
gmlid               =%L,
gmlid_codespace     =%L,
name                =%L,
name_codespace      =%L,
description         =%L,
density             =%L,
density_unit        =%L,
specific_heat       =%L,
specific_heat_unit  =%L,
conductivity        =%L,
conductivity_unit   =%L,
permeance           =%L,
permeance_unit      =%L,
porosity            =%L,
embodied_carbon     =%L,
embodied_carbon_unit=%L,
embodied_nrg        =%L,
embodied_nrg_unit   =%L,
layer_component_id  =%L
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.gmlid,
NEW.gmlid_codespace,
NEW.name,
NEW.name_codespace,
NEW.description,
NEW.density,
NEW.density_unit,
NEW.specific_heat,
NEW.specific_heat_unit,
NEW.conductivity,
NEW.conductivity_unit,
NEW.permeance,
NEW.permeance_unit,
NEW.porosity,
NEW.embodied_carbon,
NEW.embodied_carbon_unit,
NEW.embodied_nrg,
NEW.embodied_nrg_unit,
NEW.layer_component_id,
OLD.id
) INTO updated_id;
-- RAISE NOTICE 'Updated record with id: %',updated_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_upd_material_solid (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view MATERIAL_SOLID
----------------------------------------------------------------
DROP TRIGGER IF EXISTS nrg8_tr_del_material_solid ON citydb_view.nrg8_material_solid;
CREATE TRIGGER nrg8_tr_del_material_solid
	INSTEAD OF DELETE ON citydb_view.nrg8_material_solid
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_del_material_solid ('citydb');

DROP TRIGGER IF EXISTS nrg8_tr_ins_material_solid ON citydb_view.nrg8_material_solid;
CREATE TRIGGER nrg8_tr_ins_material_solid
	INSTEAD OF INSERT ON citydb_view.nrg8_material_solid
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_ins_material_solid ('citydb');

DROP TRIGGER IF EXISTS nrg8_tr_upd_material_solid ON citydb_view.nrg8_material_solid;
CREATE TRIGGER nrg8_tr_upd_material_solid
	INSTEAD OF UPDATE ON citydb_view.nrg8_material_solid
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_upd_material_solid ('citydb');

--**************************************************************
--**************************************************************

----------------------------------------------------------------
-- Function TR_DEL_DIMENSIONAL_ATTRIB_FLOOR_AREA
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_del_dimensional_attrib_floor_area() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_del_dimensional_attrib_floor_area()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
EXECUTE format('DELETE FROM %I.nrg8_dimensional_attrib WHERE id=%L RETURNING id', schema_name, OLD.id) INTO deleted_id;
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_del_dimensional_attrib_floor_area (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_DIMENSIONAL_ATTRIB_FLOOR_AREA
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_ins_dimensional_attrib_floor_area() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_ins_dimensional_attrib_floor_area()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	inserted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
inserted_id=citydb_view.nrg8_insert_floor_area(
id                   :=NEW.id,
type                 :=NEW.type,
value                :=NEW.value,
value_unit           :=NEW.value_unit,
cityobject_id        :=NEW.cityobject_id,
schema_name          :=p_schema_name
);
--RAISE NOTICE 'Inserted record with id: %', inserted_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_ins_dimensional_attrib_floor_area (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_DIMENSIONAL_ATTRIB_FLOOR_AREA
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_upd_dimensional_attrib_floor_area() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_upd_dimensional_attrib_floor_area()
  RETURNS trigger AS
$BODY$
DECLARE
  p_schema_name varchar DEFAULT 'citydb'::varchar;
  updated_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
EXECUTE format('UPDATE %I.nrg8_dimensional_attrib AS t SET
type          =%L,
value         =%L,
value_unit    =%L,
cityobject_id =%L
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.type,
NEW.value,
NEW.value_unit,
NEW.cityobject_id,
OLD.id
) INTO updated_id;
-- RAISE NOTICE 'Updated record with id: %',updated_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_upd_dimensional_attrib_floor_area (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view DIMENSIONAL_ATTRIB_FLOOR_AREA
----------------------------------------------------------------
DROP TRIGGER IF EXISTS nrg8_tr_del_dimensional_attrib_floor_area ON citydb_view.nrg8_dimensional_attrib_floor_area;
CREATE TRIGGER nrg8_tr_del_dimensional_attrib_floor_area
	INSTEAD OF DELETE ON citydb_view.nrg8_dimensional_attrib_floor_area
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_del_dimensional_attrib_floor_area ('citydb');

DROP TRIGGER IF EXISTS nrg8_tr_ins_dimensional_attrib_floor_area ON citydb_view.nrg8_dimensional_attrib_floor_area;
CREATE TRIGGER nrg8_tr_ins_dimensional_attrib_floor_area
	INSTEAD OF INSERT ON citydb_view.nrg8_dimensional_attrib_floor_area
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_ins_dimensional_attrib_floor_area ('citydb');

DROP TRIGGER IF EXISTS nrg8_tr_upd_dimensional_attrib_floor_area ON citydb_view.nrg8_dimensional_attrib_floor_area;
CREATE TRIGGER nrg8_tr_upd_dimensional_attrib_floor_area
	INSTEAD OF UPDATE ON citydb_view.nrg8_dimensional_attrib_floor_area
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_upd_dimensional_attrib_floor_area ('citydb');
--**************************************************************
--**************************************************************

----------------------------------------------------------------
-- Function TR_DEL_DIMENSIONAL_ATTRIB_HEIGHT
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_del_dimensional_attrib_height() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_del_dimensional_attrib_height()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
EXECUTE format('DELETE FROM %I.nrg8_dimensional_attrib WHERE id=%L RETURNING id', schema_name, OLD.id) INTO deleted_id;
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_del_dimensional_attrib_height (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_DIMENSIONAL_ATTRIB_HEIGHT
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_ins_dimensional_attrib_height() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_ins_dimensional_attrib_height()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	inserted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
inserted_id=citydb_view.nrg8_insert_height_above_ground(
id                   :=NEW.id,
type                 :=NEW.type,
value                :=NEW.value,
value_unit           :=NEW.value_unit,
cityobject_id        :=NEW.cityobject_id,
schema_name          :=p_schema_name
);
--RAISE NOTICE 'Inserted record with id: %', inserted_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_ins_dimensional_attrib_height (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_DIMENSIONAL_ATTRIB_HEIGHT
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_upd_dimensional_attrib_height() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_upd_dimensional_attrib_height()
  RETURNS trigger AS
$BODY$
DECLARE
  p_schema_name varchar DEFAULT 'citydb'::varchar;
  updated_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
EXECUTE format('UPDATE %I.nrg8_dimensional_attrib AS t SET
type          =%L,
value         =%L,
value_unit    =%L,
cityobject_id =%L
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.type,
NEW.value,
NEW.value_unit,
NEW.cityobject_id,
OLD.id
) INTO updated_id;
-- RAISE NOTICE 'Updated record with id: %',updated_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_upd_dimensional_attrib_height (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view DIMENSIONAL_ATTRIB_HEIGHT
----------------------------------------------------------------
DROP TRIGGER IF EXISTS nrg8_tr_del_dimensional_attrib_height ON citydb_view.nrg8_dimensional_attrib_height;
CREATE TRIGGER nrg8_tr_del_dimensional_attrib_height
	INSTEAD OF DELETE ON citydb_view.nrg8_dimensional_attrib_height
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_del_dimensional_attrib_height ('citydb');

DROP TRIGGER IF EXISTS nrg8_tr_ins_dimensional_attrib_height ON citydb_view.nrg8_dimensional_attrib_height;
CREATE TRIGGER nrg8_tr_ins_dimensional_attrib_height
	INSTEAD OF INSERT ON citydb_view.nrg8_dimensional_attrib_height
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_ins_dimensional_attrib_height ('citydb');

DROP TRIGGER IF EXISTS nrg8_tr_upd_dimensional_attrib_height ON citydb_view.nrg8_dimensional_attrib_height;
CREATE TRIGGER nrg8_tr_upd_dimensional_attrib_height
	INSTEAD OF UPDATE ON citydb_view.nrg8_dimensional_attrib_height
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_upd_dimensional_attrib_height ('citydb');
--**************************************************************
--**************************************************************

----------------------------------------------------------------
-- Function TR_DEL_DIMENSIONAL_ATTRIB_VOLUME
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_del_dimensional_attrib_volume() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_del_dimensional_attrib_volume()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
EXECUTE format('DELETE FROM %I.nrg8_dimensional_attrib WHERE id=%L RETURNING id', schema_name, OLD.id) INTO deleted_id;
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_del_dimensional_attrib_volume (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_DIMENSIONAL_ATTRIB_VOLUME
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_ins_dimensional_attrib_volume() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_ins_dimensional_attrib_volume()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	inserted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
inserted_id=citydb_view.nrg8_insert_volume(
id                   :=NEW.id,
type                 :=NEW.type,
value                :=NEW.value,
value_unit           :=NEW.value_unit,
cityobject_id        :=NEW.cityobject_id,
schema_name          :=p_schema_name
);
--RAISE NOTICE 'Inserted record with id: %', inserted_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_ins_dimensional_attrib_volume (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_DIMENSIONAL_ATTRIB_VOLUME
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_upd_dimensional_attrib_volume() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_upd_dimensional_attrib_volume()
  RETURNS trigger AS
$BODY$
DECLARE
  p_schema_name varchar DEFAULT 'citydb'::varchar;
  updated_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
EXECUTE format('UPDATE %I.nrg8_dimensional_attrib AS t SET
type          =%L,
value         =%L,
value_unit    =%L,
cityobject_id =%L
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.type,
NEW.value,
NEW.value_unit,
NEW.cityobject_id,
OLD.id
) INTO updated_id;
-- RAISE NOTICE 'Updated record with id: %',updated_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_upd_dimensional_attrib_volume (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view DIMENSIONAL_ATTRIB_VOLUME
----------------------------------------------------------------
DROP TRIGGER IF EXISTS nrg8_tr_del_dimensional_attrib_volume ON citydb_view.nrg8_dimensional_attrib_volume;
CREATE TRIGGER nrg8_tr_del_dimensional_attrib_volume
	INSTEAD OF DELETE ON citydb_view.nrg8_dimensional_attrib_volume
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_del_dimensional_attrib_volume ('citydb');

DROP TRIGGER IF EXISTS nrg8_tr_ins_dimensional_attrib_volume ON citydb_view.nrg8_dimensional_attrib_volume;
CREATE TRIGGER nrg8_tr_ins_dimensional_attrib_volume
	INSTEAD OF INSERT ON citydb_view.nrg8_dimensional_attrib_volume
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_ins_dimensional_attrib_volume ('citydb');

DROP TRIGGER IF EXISTS nrg8_tr_upd_dimensional_attrib_volume ON citydb_view.nrg8_dimensional_attrib_volume;
CREATE TRIGGER nrg8_tr_upd_dimensional_attrib_volume
	INSTEAD OF UPDATE ON citydb_view.nrg8_dimensional_attrib_volume
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_upd_dimensional_attrib_volume ('citydb');
--**************************************************************
--**************************************************************

----------------------------------------------------------------
-- Function TR_DEL_ENERGY_DEMAND
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_del_energy_demand() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_del_energy_demand()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
deleted_id=citydb_pkg.nrg8_delete_energy_demand(OLD.id, p_schema_name);
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_del_energy_demand (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_ENERGY_DEMAND
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_ins_energy_demand() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_ins_energy_demand()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	inserted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
inserted_id=citydb_view.nrg8_insert_energy_demand(
id                   :=NEW.id,
gmlid                :=NEW.gmlid,
gmlid_codespace      :=NEW.gmlid_codespace,
name                 :=NEW.name,
name_codespace       :=NEW.name_codespace,
description          :=NEW.description,
end_use              :=NEW.end_use,
max_load             :=NEW.max_load,
max_load_unit        :=NEW.max_load_unit,
time_series_id       :=NEW.time_series_id,
cityobject_id        :=NEW.cityobject_id,
schema_name          :=p_schema_name
);
--RAISE NOTICE 'Inserted record with id: %', inserted_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_ins_energy_demand (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_ENERGY_DEMAND
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_upd_energy_demand() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_upd_energy_demand()
  RETURNS trigger AS
$BODY$
DECLARE
  p_schema_name varchar DEFAULT 'citydb'::varchar;
  updated_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
EXECUTE format('UPDATE %I.nrg8_energy_demand AS t SET
gmlid           =%L,
gmlid_codespace =%L,
name            =%L,
name_codespace  =%L,
description     =%L,
end_use         =%L,
max_load        =%L,
max_load_unit   =%L,
time_series_id  =%L,
cityobject_id   =%L
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.gmlid,
NEW.gmlid_codespace,
NEW.name,
NEW.name_codespace,
NEW.description,
NEW.end_use,
NEW.max_load,
NEW.max_load_unit,
NEW.time_series_id,
NEW.cityobject_id,
OLD.id
) INTO updated_id;
-- RAISE NOTICE 'Updated record with id: %',updated_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_upd_energy_demand (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view ENERGY_DEMAND
----------------------------------------------------------------
DROP TRIGGER IF EXISTS nrg8_tr_del_energy_demand ON citydb_view.nrg8_energy_demand;
CREATE TRIGGER nrg8_tr_del_energy_demand
	INSTEAD OF DELETE ON citydb_view.nrg8_energy_demand
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_del_energy_demand ('citydb');

DROP TRIGGER IF EXISTS nrg8_tr_ins_energy_demand ON citydb_view.nrg8_energy_demand;
CREATE TRIGGER nrg8_tr_ins_energy_demand
	INSTEAD OF INSERT ON citydb_view.nrg8_energy_demand
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_ins_energy_demand ('citydb');

DROP TRIGGER IF EXISTS nrg8_tr_upd_energy_demand ON citydb_view.nrg8_energy_demand;
CREATE TRIGGER nrg8_tr_upd_energy_demand
	INSTEAD OF UPDATE ON citydb_view.nrg8_energy_demand
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_upd_energy_demand ('citydb');
--**************************************************************
--**************************************************************

----------------------------------------------------------------
-- Function TR_DEL_FINAL_ENERGY
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_del_final_energy() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_del_final_energy()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
deleted_id=citydb_pkg.nrg8_delete_final_energy(OLD.id, p_schema_name);
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_del_final_energy (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_FINAL_ENERGY
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_ins_final_energy() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_ins_final_energy()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	inserted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
inserted_id=citydb_view.nrg8_insert_final_energy(
id                          :=NEW.id,
gmlid                       :=NEW.gmlid,
gmlid_codespace             :=NEW.gmlid_codespace,
name                        :=NEW.name,
name_codespace              :=NEW.name_codespace,
description                 :=NEW.description,
nrg_car_type                :=NEW.nrg_car_type,
nrg_car_prim_nrg_factor     :=NEW.nrg_car_prim_nrg_factor,
nrg_car_prim_nrg_factor_unit:=NEW.nrg_car_prim_nrg_factor_unit,
nrg_car_nrg_density         :=NEW.nrg_car_nrg_density,
nrg_car_nrg_density_unit    :=NEW.nrg_car_nrg_density_unit,
nrg_car_co2_emission        :=NEW.nrg_car_co2_emission,
nrg_car_co2_emission_unit   :=NEW.nrg_car_co2_emission_unit,
time_series_id              :=NEW.time_series_id,
schema_name                 :=p_schema_name
);
--RAISE NOTICE 'Inserted record with id: %', inserted_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_ins_final_energy (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_FINAL_ENERGY
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_upd_final_energy() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_upd_final_energy()
  RETURNS trigger AS
$BODY$
DECLARE
  p_schema_name varchar DEFAULT 'citydb'::varchar;
  updated_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
EXECUTE format('UPDATE %I.nrg8_final_energy AS t SET
gmlid                       =%L,
gmlid_codespace             =%L,
name                        =%L,
name_codespace              =%L,
description                 =%L,
nrg_car_type                =%L,
nrg_car_prim_nrg_factor     =%L,
nrg_car_prim_nrg_factor_unit=%L,
nrg_car_nrg_density         =%L,
nrg_car_nrg_density_unit    =%L,
nrg_car_co2_emission        =%L,
nrg_car_co2_emission_unit   =%L,
time_series_id              =%L
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.gmlid,
NEW.gmlid_codespace,
NEW.name,
NEW.name_codespace,
NEW.description,
NEW.nrg_car_type,
NEW.nrg_car_prim_nrg_factor,
NEW.nrg_car_prim_nrg_factor_unit,
NEW.nrg_car_nrg_density,
NEW.nrg_car_nrg_density_unit,
NEW.nrg_car_co2_emission,
NEW.nrg_car_co2_emission_unit,
NEW.time_series_id,
OLD.id
) INTO updated_id;
-- RAISE NOTICE 'Updated record with id: %',updated_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_upd_final_energy (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view FINAL_ENERGY
----------------------------------------------------------------
DROP TRIGGER IF EXISTS nrg8_tr_del_final_energy ON citydb_view.nrg8_final_energy;
CREATE TRIGGER nrg8_tr_del_final_energy
	INSTEAD OF DELETE ON citydb_view.nrg8_final_energy
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_del_final_energy ('citydb');

DROP TRIGGER IF EXISTS nrg8_tr_ins_final_energy ON citydb_view.nrg8_final_energy;
CREATE TRIGGER nrg8_tr_ins_final_energy
	INSTEAD OF INSERT ON citydb_view.nrg8_final_energy
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_ins_final_energy ('citydb');

DROP TRIGGER IF EXISTS nrg8_tr_upd_final_energy ON citydb_view.nrg8_final_energy;
CREATE TRIGGER nrg8_tr_upd_final_energy
	INSTEAD OF UPDATE ON citydb_view.nrg8_final_energy
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_upd_final_energy ('citydb');
-- *************************************************************
-- *************************************************************

----------------------------------------------------------------
-- Function TR_DEL_SYSTEM_OPERATION
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_del_system_operation() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_del_system_operation()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
deleted_id=citydb_pkg.nrg8_delete_system_operation(OLD.id, p_schema_name);
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_del_system_operation (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_SYSTEM_OPERATION
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_ins_system_operation() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_ins_system_operation()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	inserted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;

inserted_id=citydb_view.nrg8_insert_system_operation(
id                   :=NEW.id,
gmlid                :=NEW.gmlid,
gmlid_codespace      :=NEW.gmlid_codespace,
name                 :=NEW.name,
name_codespace       :=NEW.name_codespace,
description          :=NEW.description,
end_use              :=NEW.end_use,
yearly_global_effcy  :=NEW.yearly_global_effcy,
sched_id             :=NEW.sched_id,
nrg_conv_system_id   :=NEW.nrg_conv_system_id,
schema_name          :=p_schema_name
);
--RAISE NOTICE 'Inserted record with id: %', inserted_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_ins_system_operation (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_SYSTEM_OPERATION
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_upd_system_operation() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_upd_system_operation()
  RETURNS trigger AS
$BODY$
DECLARE
  p_schema_name varchar DEFAULT 'citydb'::varchar;
  updated_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
EXECUTE format('UPDATE %I.nrg8_system_operation AS t SET
gmlid                =%L,
gmlid_codespace      =%L,
name                 =%L,
name_codespace       =%L,
description          =%L,
end_use              =%L,
yearly_global_effcy  =%L,
sched_id             =%L,
nrg_conv_system_id   =%L
time_series_id       =%L
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.gmlid,
NEW.gmlid_codespace,
NEW.name,
NEW.name_codespace,
NEW.description,
NEW.end_use,
NEW.yearly_global_effcy,
NEW.sched_id,
NEW.nrg_conv_system_id,
NEW.time_series_id,
OLD.id
) INTO updated_id;
-- RAISE NOTICE 'Updated record with id: %',updated_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_upd_system_operation (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view SYSTEM_OPERATION
----------------------------------------------------------------
DROP TRIGGER IF EXISTS nrg8_tr_del_system_operation ON citydb_view.nrg8_system_operation;
CREATE TRIGGER nrg8_tr_del_system_operation
	INSTEAD OF DELETE ON citydb_view.nrg8_system_operation
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_del_system_operation ('citydb');

DROP TRIGGER IF EXISTS nrg8_tr_ins_system_operation ON citydb_view.nrg8_system_operation;
CREATE TRIGGER nrg8_tr_ins_system_operation
	INSTEAD OF INSERT ON citydb_view.nrg8_system_operation
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_ins_system_operation ('citydb');

DROP TRIGGER IF EXISTS nrg8_tr_upd_system_operation ON citydb_view.nrg8_system_operation;
CREATE TRIGGER nrg8_tr_upd_system_operation
	INSTEAD OF UPDATE ON citydb_view.nrg8_system_operation
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_upd_system_operation ('citydb');
--**************************************************************
--**************************************************************

----------------------------------------------------------------
-- Function TR_DEL_OCCUPANTS
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_del_occupants() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_del_occupants()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
deleted_id=citydb_pkg.nrg8_delete_occupants(OLD.id, p_schema_name);
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_del_occupants (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_OCCUPANTS
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_ins_occupants() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_ins_occupants()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	inserted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
inserted_id=citydb_view.nrg8_insert_occupants(
id                      :=NEW.id,
gmlid                   :=NEW.gmlid,
gmlid_codespace         :=NEW.gmlid_codespace,
name                    :=NEW.name,
name_codespace          :=NEW.name_codespace,
description             :=NEW.description,
type                    :=NEW.type,
nbr_of_occupants        :=NEW.nbr_of_occupants,
heat_diss_tot_value     :=NEW.heat_diss_tot_value,
heat_diss_tot_value_unit:=NEW.heat_diss_tot_value_unit,
heat_diss_conv          :=NEW.heat_diss_conv,
heat_diss_lat           :=NEW.heat_diss_lat,
heat_diss_rad           :=NEW.heat_diss_rad,
sched_id                :=NEW.sched_id,
usage_zone_id           :=NEW.usage_zone_id,
building_unit_id        :=NEW.building_unit_id,
schema_name               :=p_schema_name
);
--RAISE NOTICE 'Inserted record with id: %', inserted_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_ins_occupants (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_OCCUPANTS
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_upd_occupants() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_upd_occupants()
  RETURNS trigger AS
$BODY$
DECLARE
  p_schema_name varchar DEFAULT 'citydb'::varchar;
  updated_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
EXECUTE format('UPDATE %I.nrg8_occupants AS t SET
gmlid                   =%L,
gmlid_codespace         =%L,
name                    =%L,
name_codespace          =%L,
description             =%L,
type                    =%L,
nbr_of_occupants        =%L,
heat_diss_tot_value     =%L,
heat_diss_tot_value_unit=%L,
heat_diss_conv          =%L,
heat_diss_lat           =%L,
heat_diss_rad           =%L,
sched_id                =%L,
usage_zone_id           =%L,
building_unit_id        =%L
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.gmlid,
NEW.gmlid_codespace,
NEW.name,
NEW.name_codespace,
NEW.description,
NEW.type,
NEW.nbr_of_occupants,
NEW.heat_diss_tot_value,
NEW.heat_diss_tot_value_unit,
NEW.heat_diss_conv,
NEW.heat_diss_lat,
NEW.heat_diss_rad,
NEW.sched_id,
NEW.usage_zone_id,
NEW.building_unit_id,
OLD.id
) INTO updated_id;
-- RAISE NOTICE 'Updated record with id: %',updated_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_upd_occupants (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view OCCUPANTS
----------------------------------------------------------------
DROP TRIGGER IF EXISTS nrg8_tr_del_occupants ON citydb_view.nrg8_occupants;
CREATE TRIGGER nrg8_tr_del_occupants
	INSTEAD OF DELETE ON citydb_view.nrg8_occupants
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_del_occupants ('citydb');

DROP TRIGGER IF EXISTS nrg8_tr_ins_occupants ON citydb_view.nrg8_occupants;
CREATE TRIGGER nrg8_tr_ins_occupants
	INSTEAD OF INSERT ON citydb_view.nrg8_occupants
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_ins_occupants ('citydb');

DROP TRIGGER IF EXISTS nrg8_tr_upd_occupants ON citydb_view.nrg8_occupants;
CREATE TRIGGER nrg8_tr_upd_occupants
	INSTEAD OF UPDATE ON citydb_view.nrg8_occupants
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_upd_occupants ('citydb');
--**************************************************************
--**************************************************************

----------------------------------------------------------------
-- Function TR_DEL_HOUSEHOLD
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_del_household() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_del_household()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
deleted_id=citydb_pkg.nrg8_delete_household(OLD.id, p_schema_name);
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_del_household (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_HOUSEHOLD
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_ins_household() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_ins_household()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	inserted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
inserted_id=citydb_view.nrg8_insert_household(
id                   :=NEW.id,
gmlid                :=NEW.gmlid,
gmlid_codespace      :=NEW.gmlid_codespace,
name                 :=NEW.name,
name_codespace       :=NEW.name_codespace,
description          :=NEW.description,
type                 :=NEW.type,
residence_type       :=NEW.residence_type,
occupants_id         :=NEW.occupants_id,
schema_name          :=p_schema_name
);
--RAISE NOTICE 'Inserted record with id: %', inserted_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_ins_household (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_HOUSEHOLD
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_upd_household() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_upd_household()
  RETURNS trigger AS
$BODY$
DECLARE
  p_schema_name varchar DEFAULT 'citydb'::varchar;
  updated_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
EXECUTE format('UPDATE %I.nrg8_household AS t SET
gmlid           =%L,
gmlid_codespace =%L,
name            =%L,
name_codespace  =%L,
description     =%L,
type            =%L,
residence_type  =%L,
occupants_id    =%L
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.gmlid,
NEW.gmlid_codespace,
NEW.name,
NEW.name_codespace,
NEW.description,
NEW.type,
NEW.residence_type,
NEW.occupants_id,
OLD.id
) INTO updated_id;
-- RAISE NOTICE 'Updated record with id: %',updated_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_upd_household (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view HOUSEHOLD
----------------------------------------------------------------
DROP TRIGGER IF EXISTS nrg8_tr_del_household ON citydb_view.nrg8_household;
CREATE TRIGGER nrg8_tr_del_household
	INSTEAD OF DELETE ON citydb_view.nrg8_household
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_del_household ('citydb');

DROP TRIGGER IF EXISTS nrg8_tr_ins_household ON citydb_view.nrg8_household;
CREATE TRIGGER nrg8_tr_ins_household
	INSTEAD OF INSERT ON citydb_view.nrg8_household
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_ins_household ('citydb');

DROP TRIGGER IF EXISTS nrg8_tr_upd_household ON citydb_view.nrg8_household;
CREATE TRIGGER nrg8_tr_upd_household
	INSTEAD OF UPDATE ON citydb_view.nrg8_household
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_upd_household ('citydb');
--**************************************************************
--**************************************************************

----------------------------------------------------------------
-- Function TR_DEL_WEATHER_DATA
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_del_weather_data() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_del_weather_data()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
deleted_id=citydb_pkg.nrg8_delete_weather_data(OLD.id, p_schema_name);
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_del_weather_data (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_WEATHER_DATA
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_ins_weather_data() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_ins_weather_data()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	inserted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
inserted_id=citydb_view.nrg8_insert_weather_data(
id                   :=NEW.id,
gmlid                :=NEW.gmlid,
gmlid_codespace      :=NEW.gmlid_codespace,
name                 :=NEW.name,
name_codespace       :=NEW.name_codespace,
description          :=NEW.description,		
type                 :=NEW.type,
time_series_id       :=NEW.time_series_id,
cityobject_id        :=NEW.cityobject_id,
install_point        :=NEW.install_point,
schema_name          :=p_schema_name
);
--RAISE NOTICE 'Inserted record with id: %', inserted_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_ins_weather_data (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_WEATHER_DATA
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_upd_weather_data() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_upd_weather_data()
  RETURNS trigger AS
$BODY$
DECLARE
  p_schema_name varchar DEFAULT 'citydb'::varchar;
  updated_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
EXECUTE format('UPDATE %I.nrg8_weather_data AS t SET
gmlid           =%L,
gmlid_codespace =%L,
name            =%L,
name_codespace  =%L,
description     =%L,
type            =%L,
time_series_id  =%L,
cityobject_id   =%L,
install_point   =%L
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.gmlid,
NEW.gmlid_codespace,
NEW.name,
NEW.name_codespace,
NEW.description,
NEW.type,
NEW.time_series_id,
NEW.cityobject_id,
NEW.install_point,
OLD.id
) INTO updated_id;
-- RAISE NOTICE 'Updated record with id: %',updated_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_upd_weather_data (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view WEATHER_DATA
----------------------------------------------------------------
DROP TRIGGER IF EXISTS nrg8_tr_del_weather_data ON citydb_view.nrg8_weather_data;
CREATE TRIGGER nrg8_tr_del_weather_data
	INSTEAD OF DELETE ON citydb_view.nrg8_weather_data
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_del_weather_data ('citydb');

DROP TRIGGER IF EXISTS nrg8_tr_ins_weather_data ON citydb_view.nrg8_weather_data;
CREATE TRIGGER nrg8_tr_ins_weather_data
	INSTEAD OF INSERT ON citydb_view.nrg8_weather_data
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_ins_weather_data ('citydb');

DROP TRIGGER IF EXISTS nrg8_tr_upd_weather_data ON citydb_view.nrg8_weather_data;
CREATE TRIGGER nrg8_tr_upd_weather_data
	INSTEAD OF UPDATE ON citydb_view.nrg8_weather_data
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_upd_weather_data ('citydb');
--**************************************************************
--**************************************************************

----------------------------------------------------------------
-- Function TR_DEL_PERF_CERTIFICATION
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_del_perf_certification() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_del_perf_certification()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
deleted_id=citydb_pkg.nrg8_delete_perf_certification(OLD.id, p_schema_name);
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_del_perf_certification (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_PERF_CERTIFICATION
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_ins_perf_certification() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_ins_perf_certification()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	inserted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
inserted_id=citydb_view.nrg8_insert_perf_certification(
id                   :=NEW.id,
name                 :=NEW.name,
rating               :=NEW.rating,
certification_id     :=NEW.certification_id,
building_id          :=NEW.building_id,
building_unit_id	 :=NEW.building_unit_id,
schema_name          :=p_schema_name
);
--RAISE NOTICE 'Inserted record with id: %', inserted_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_ins_perf_certification (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_PERF_CERTIFICATION
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_upd_perf_certification() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_upd_perf_certification()
  RETURNS trigger AS
$BODY$
DECLARE
  p_schema_name varchar DEFAULT 'citydb'::varchar;
  updated_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
EXECUTE format('UPDATE %I.nrg8_perf_certification AS t SET
name            =%L,
rating          =%L,
certification_id=%L,
building_id     =%L,
building_unit_id=%L
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.name,
NEW.rating,
NEW.certification_id,
NEW.building_id,
NEW.building_unit_id,
OLD.id
) INTO updated_id;
-- RAISE NOTICE 'Updated record with id: %',updated_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_upd_perf_certification (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view PERF_CERTIFICATION
----------------------------------------------------------------
DROP TRIGGER IF EXISTS nrg8_tr_del_perf_certification ON citydb_view.nrg8_perf_certification;
CREATE TRIGGER nrg8_tr_del_perf_certification
	INSTEAD OF DELETE ON citydb_view.nrg8_perf_certification
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_del_perf_certification ('citydb');

DROP TRIGGER IF EXISTS nrg8_tr_ins_perf_certification ON citydb_view.nrg8_perf_certification;
CREATE TRIGGER nrg8_tr_ins_perf_certification
	INSTEAD OF INSERT ON citydb_view.nrg8_perf_certification
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_ins_perf_certification ('citydb');

DROP TRIGGER IF EXISTS nrg8_tr_upd_perf_certification ON citydb_view.nrg8_perf_certification;
CREATE TRIGGER nrg8_tr_upd_perf_certification
	INSTEAD OF UPDATE ON citydb_view.nrg8_perf_certification
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_upd_perf_certification ('citydb');
--**************************************************************
--**************************************************************

----------------------------------------------------------------
-- Function TR_DEL_REFURBISHMENT_MEASURE
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_del_refurbishment_measure() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_del_refurbishment_measure()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
deleted_id=citydb_pkg.nrg8_delete_refurbishment_measure(OLD.id, p_schema_name);
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_del_refurbishment_measure (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_REFURBISHMENT_MEASURE
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_ins_refurbishment_measure() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_ins_refurbishment_measure()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	inserted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
inserted_id=citydb_view.nrg8_insert_refurbishment_measure(
id                   :=NEW.id,
description          :=NEW.description,
level                :=NEW.level,
instant_date         :=NEW.instant_date,
begin_date           :=NEW.begin_date,
end_date             :=NEW.end_date,
building_id          :=NEW.building_id,
therm_boundary_id    :=NEW.therm_boundary_id,
schema_name          :=p_schema_name
);
--RAISE NOTICE 'Inserted record with id: %', inserted_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_ins_refurbishment_measure (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_PERF_REFURBISHMENT_MEASURE
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_upd_refurbishment_measure() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_upd_refurbishment_measure()
  RETURNS trigger AS
$BODY$
DECLARE
  p_schema_name varchar DEFAULT 'citydb'::varchar;
  updated_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
EXECUTE format('UPDATE %I.nrg8_refurbishment_measure AS t SET
description      =%L,
level            =%L,
instant_date     =%L,
begin_date       =%L,
end_date         =%L,
building_id      =%L,
therm_boundary_id=%L
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.description,
NEW.level,
NEW.instant_date,
NEW.begin_date,
NEW.end_date,
NEW.building_id,
NEW.therm_boundary_id,
OLD.id
) INTO updated_id;
-- RAISE NOTICE 'Updated record with id: %',updated_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_upd_refurbishment_measure (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view REFURBISHMENT_MEASURE
----------------------------------------------------------------
DROP TRIGGER IF EXISTS nrg8_tr_del_refurbishment_measure ON citydb_view.nrg8_refurbishment_measure;
CREATE TRIGGER nrg8_tr_del_refurbishment_measure
	INSTEAD OF DELETE ON citydb_view.nrg8_refurbishment_measure
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_del_refurbishment_measure ('citydb');

DROP TRIGGER IF EXISTS nrg8_tr_ins_refurbishment_measure ON citydb_view.nrg8_refurbishment_measure;
CREATE TRIGGER nrg8_tr_ins_refurbishment_measure
	INSTEAD OF INSERT ON citydb_view.nrg8_refurbishment_measure
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_ins_refurbishment_measure ('citydb');

DROP TRIGGER IF EXISTS nrg8_tr_upd_refurbishment_measure ON citydb_view.nrg8_refurbishment_measure;
CREATE TRIGGER nrg8_tr_upd_refurbishment_measure
	INSTEAD OF UPDATE ON citydb_view.nrg8_refurbishment_measure
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_upd_refurbishment_measure ('citydb');
--**************************************************************
--**************************************************************

----------------------------------------------------------------
-- Function TR_DEL_WEATHER_STATION
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_del_weather_station() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_del_weather_station()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
deleted_id=citydb_pkg.nrg8_delete_weather_station(OLD.id, p_schema_name);
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_del_weather_station (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_WEATHER_STATION
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_ins_weather_station() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_ins_weather_station()
  RETURNS trigger AS
$BODY$
DECLARE
	class_name varchar DEFAULT 'WeatherStation'::varchar;

	p_schema_name varchar DEFAULT 'citydb'::varchar;
	inserted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
inserted_id=citydb_view.nrg8_insert_weather_station(
id                    :=NEW.id,
gmlid                 :=NEW.gmlid,
gmlid_codespace       :=NEW.gmlid_codespace,
name                  :=NEW.name,
name_codespace        :=NEW.name_codespace,
description           :=NEW.description,
envelope              :=NEW.envelope,
creation_date         :=NEW.creation_date,
termination_date      :=NEW.termination_date,
relative_to_terrain   :=NEW.relative_to_terrain,
relative_to_water     :=NEW.relative_to_water,
last_modification_date:=NEW.last_modification_date,
updating_person       :=NEW.updating_person,
reason_for_update     :=NEW.reason_for_update,
lineage               :=NEW.lineage,
cityobject_id         :=NEW.cityobject_id,
install_point              :=NEW.install_point,
schema_name             :=p_schema_name
);
--RAISE NOTICE 'Inserted record with id: %', inserted_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_ins_weather_station (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_WEATHER_STATION
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_upd_weather_station() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_upd_weather_station()
  RETURNS trigger AS
$BODY$
DECLARE
  p_schema_name varchar DEFAULT 'citydb'::varchar;
  updated_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
EXECUTE format('UPDATE %I.cityobject AS t SET
 gmlid                 =%L,
 gmlid_codespace       =%L,
 name                  =%L,
 name_codespace        =%L,
 description           =%L,
 envelope              =%L,
 creation_date         =%L,
 termination_date      =%L,
 relative_to_terrain   =%L,
 relative_to_water     =%L,
 last_modification_date=%L,
 updating_person       =%L,
 reason_for_update     =%L,
 lineage               =%L
WHERE t.id=%L RETURNING id',
 p_schema_name,
 NEW.gmlid,
 NEW.gmlid_codespace,
 NEW.name,
 NEW.name_codespace,
 NEW.description,
 NEW.envelope,
 NEW.creation_date,
 NEW.termination_date,
 NEW.relative_to_terrain,
 NEW.relative_to_water,
 NEW.last_modification_date,
 NEW.updating_person,
 NEW.reason_for_update,
 NEW.lineage,
 OLD.id
) INTO updated_id;
EXECUTE format('UPDATE %I.nrg8_weather_station AS t SET
install_point=%L
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.install_point,
OLD.id
) INTO updated_id;
-- RAISE NOTICE 'Updated record with id: %',updated_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_upd_weather_station (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view WEATHER_STATION
----------------------------------------------------------------
DROP TRIGGER IF EXISTS nrg8_tr_del_weather_station ON citydb_view.nrg8_weather_station;
CREATE TRIGGER nrg8_tr_del_weather_station
	INSTEAD OF DELETE ON citydb_view.nrg8_weather_station
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_del_weather_station ('citydb');

DROP TRIGGER IF EXISTS nrg8_tr_ins_weather_station ON citydb_view.nrg8_weather_station;
CREATE TRIGGER nrg8_tr_ins_weather_station
	INSTEAD OF INSERT ON citydb_view.nrg8_weather_station
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_ins_weather_station ('citydb');

DROP TRIGGER IF EXISTS nrg8_tr_upd_weather_station ON citydb_view.nrg8_weather_station;
CREATE TRIGGER nrg8_tr_upd_weather_station
	INSTEAD OF UPDATE ON citydb_view.nrg8_weather_station
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_upd_weather_station ('citydb');
--**************************************************************
--**************************************************************

----------------------------------------------------------------
-- Function TR_DEL_NRG_BUILDING
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_del_building() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_del_building()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
deleted_id=citydb_pkg.delete_cityobject(OLD.id, 0, 0, p_schema_name);
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_del_building (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_NRG_BUILDING
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_ins_building() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_ins_building()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	inserted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
inserted_id=citydb_view.nrg8_insert_building(
id                    :=NEW.id,
gmlid                 :=NEW.gmlid,
gmlid_codespace       :=NEW.gmlid_codespace,
name                  :=NEW.name,
name_codespace        :=NEW.name_codespace,
description           :=NEW.description,
envelope              :=NEW.envelope,
creation_date         :=NEW.creation_date,
termination_date      :=NEW.termination_date,
relative_to_terrain   :=NEW.relative_to_terrain,
relative_to_water     :=NEW.relative_to_water,
last_modification_date:=NEW.last_modification_date,
updating_person       :=NEW.updating_person,
reason_for_update     :=NEW.reason_for_update,
lineage               :=NEW.lineage,

building_parent_id         :=NEW.building_parent_id,
building_root_id           :=NEW.building_root_id,
class                      :=NEW.class,
class_codespace            :=NEW.class_codespace,
function                   :=NEW.function,
function_codespace         :=NEW.function_codespace,
usage                      :=NEW.usage,
usage_codespace            :=NEW.usage_codespace,
year_of_construction       :=NEW.year_of_construction,
year_of_demolition         :=NEW.year_of_demolition,
roof_type                  :=NEW.roof_type,
roof_type_codespace        :=NEW.roof_type_codespace,
measured_height            :=NEW.measured_height,
measured_height_unit       :=NEW.measured_height_unit,
storeys_above_ground       :=NEW.storeys_above_ground,
storeys_below_ground       :=NEW.storeys_below_ground,
storey_heights_above_ground:=NEW.storey_heights_above_ground,
storey_heights_ag_unit     :=NEW.storey_heights_ag_unit,
storey_heights_below_ground:=NEW.storey_heights_below_ground,
storey_heights_bg_unit     :=NEW.storey_heights_bg_unit,
lod1_terrain_intersection  :=NEW.lod1_terrain_intersection,
lod2_terrain_intersection  :=NEW.lod2_terrain_intersection,
lod3_terrain_intersection  :=NEW.lod3_terrain_intersection,
lod4_terrain_intersection  :=NEW.lod4_terrain_intersection,
lod2_multi_curve           :=NEW.lod2_multi_curve,
lod3_multi_curve           :=NEW.lod3_multi_curve,
lod4_multi_curve           :=NEW.lod4_multi_curve,
lod0_footprint_id          :=NEW.lod0_footprint_id,
lod0_roofprint_id          :=NEW.lod0_roofprint_id,
lod1_multi_surface_id      :=NEW.lod1_multi_surface_id,
lod2_multi_surface_id      :=NEW.lod2_multi_surface_id,
lod3_multi_surface_id      :=NEW.lod3_multi_surface_id,
lod4_multi_surface_id      :=NEW.lod4_multi_surface_id,
lod1_solid_id              :=NEW.lod1_solid_id,
lod2_solid_id              :=NEW.lod2_solid_id,
lod3_solid_id              :=NEW.lod3_solid_id,
lod4_solid_id              :=NEW.lod4_solid_id,

type                       :=NEW.type,
type_codespace             :=NEW.type_codespace,
constr_weight              :=NEW.constr_weight,
is_landmarked              :=NEW.is_landmarked,
ref_point                  :=NEW.ref_point,
schema_name                  :=p_schema_name
);
--RAISE NOTICE 'Inserted record with id: %', inserted_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_ins_building (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_NRG_BUILDING
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_upd_building() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_upd_building()
  RETURNS trigger AS
$BODY$
DECLARE
  p_schema_name varchar DEFAULT 'citydb'::varchar;
  updated_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
EXECUTE format('UPDATE %I.cityobject AS t SET
 gmlid                 =%L,
 gmlid_codespace       =%L,
 name                  =%L,
 name_codespace        =%L,
 description           =%L,
 envelope              =%L,
 creation_date         =%L,
 termination_date      =%L,
 relative_to_terrain   =%L,
 relative_to_water     =%L,
 last_modification_date=%L,
 updating_person       =%L,
 reason_for_update     =%L,
 lineage               =%L
WHERE t.id=%L RETURNING id',
 p_schema_name,
 NEW.gmlid,
 NEW.gmlid_codespace,
 NEW.name,
 NEW.name_codespace,
 NEW.description,
 NEW.envelope,
 NEW.creation_date,
 NEW.termination_date,
 NEW.relative_to_terrain,
 NEW.relative_to_water,
 NEW.last_modification_date,
 NEW.updating_person,
 NEW.reason_for_update,
 NEW.lineage,
 OLD.id
) INTO updated_id;
EXECUTE format('UPDATE %I.building AS t SET
 building_parent_id         =%L,
 building_root_id           =%L,
 class                      =%L,
 class_codespace            =%L,
 function                   =%L,
 function_codespace         =%L,
 usage                      =%L,
 usage_codespace            =%L,
 year_of_construction       =%L,
 year_of_demolition         =%L,
 roof_type                  =%L,
 roof_type_codespace        =%L,
 measured_height            =%L,
 measured_height_unit       =%L,
 storeys_above_ground       =%L,
 storeys_below_ground       =%L,
 storey_heights_above_ground=%L,
 storey_heights_ag_unit     =%L,
 storey_heights_below_ground=%L,
 storey_heights_bg_unit     =%L,
 lod1_terrain_intersection  =%L,
 lod2_terrain_intersection  =%L,
 lod3_terrain_intersection  =%L,
 lod4_terrain_intersection  =%L,
 lod2_multi_curve           =%L,
 lod3_multi_curve           =%L,
 lod4_multi_curve           =%L,
 lod0_footprint_id          =%L,
 lod0_roofprint_id          =%L,
 lod1_multi_surface_id      =%L,
 lod2_multi_surface_id      =%L,
 lod3_multi_surface_id      =%L,
 lod4_multi_surface_id      =%L,
 lod1_solid_id              =%L,
 lod2_solid_id              =%L,
 lod3_solid_id              =%L,
 lod4_solid_id              =%L
WHERE t.id=%L RETURNING id',
 p_schema_name,
 NEW.building_parent_id,
 NEW.building_root_id,
 NEW.class,
 NEW.class_codespace,
 NEW.function,
 NEW.function_codespace,
 NEW.usage,
 NEW.usage_codespace,
 NEW.year_of_construction,
 NEW.year_of_demolition,
 NEW.roof_type,
 NEW.roof_type_codespace,
 NEW.measured_height,
 NEW.measured_height_unit,
 NEW.storeys_above_ground,
 NEW.storeys_below_ground,
 NEW.storey_heights_above_ground,
 NEW.storey_heights_ag_unit,
 NEW.storey_heights_below_ground,
 NEW.storey_heights_bg_unit,
 NEW.lod1_terrain_intersection,
 NEW.lod2_terrain_intersection,
 NEW.lod3_terrain_intersection,
 NEW.lod4_terrain_intersection,
 NEW.lod2_multi_curve,
 NEW.lod3_multi_curve,
 NEW.lod4_multi_curve,
 NEW.lod0_footprint_id,
 NEW.lod0_roofprint_id,
 NEW.lod1_multi_surface_id,
 NEW.lod2_multi_surface_id,
 NEW.lod3_multi_surface_id,
 NEW.lod4_multi_surface_id,
 NEW.lod1_solid_id,
 NEW.lod2_solid_id,
 NEW.lod3_solid_id,
 NEW.lod4_solid_id,
 OLD.id
) INTO updated_id;
EXECUTE format('UPDATE %I.nrg8_building AS t SET
type          =%L,
type_codespace=%L,
constr_weight =%L,
is_landmarked =%L,
ref_point     =%L
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.type,
NEW.type_codespace,
NEW.constr_weight,
NEW.is_landmarked,
NEW.ref_point,
OLD.id
) INTO updated_id;
-- RAISE NOTICE 'Updated record with id: %',updated_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_upd_building (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view nrg8_BUILDING
----------------------------------------------------------------
DROP TRIGGER IF EXISTS nrg8_tr_del_building ON citydb_view.nrg8_building;
CREATE TRIGGER nrg8_tr_del_building
	INSTEAD OF DELETE ON citydb_view.nrg8_building
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_del_building ('citydb');

DROP TRIGGER IF EXISTS nrg8_tr_ins_building ON citydb_view.nrg8_building;
CREATE TRIGGER nrg8_tr_ins_building
	INSTEAD OF INSERT ON citydb_view.nrg8_building
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_ins_building ('citydb');

DROP TRIGGER IF EXISTS nrg8_tr_upd_building ON citydb_view.nrg8_building;
CREATE TRIGGER nrg8_tr_upd_building
	INSTEAD OF UPDATE ON citydb_view.nrg8_building
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_upd_building ('citydb');
--**************************************************************
--**************************************************************

----------------------------------------------------------------
-- Function TR_DEL_NRG_BUILDING_PART
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_del_building_part() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_del_building_part()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
deleted_id=citydb_pkg.delete_building(OLD.id, p_schema_name);
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_del_building_part (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_NRG_BUILDING_PART
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_ins_building_part() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_ins_building_part()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	inserted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
inserted_id=citydb_view.nrg8_insert_building_part(
id                    :=NEW.id,
gmlid                 :=NEW.gmlid,
gmlid_codespace       :=NEW.gmlid_codespace,
name                  :=NEW.name,
name_codespace        :=NEW.name_codespace,
description           :=NEW.description,
envelope              :=NEW.envelope,
creation_date         :=NEW.creation_date,
termination_date      :=NEW.termination_date,
relative_to_terrain   :=NEW.relative_to_terrain,
relative_to_water     :=NEW.relative_to_water,
last_modification_date:=NEW.last_modification_date,
updating_person       :=NEW.updating_person,
reason_for_update     :=NEW.reason_for_update,
lineage               :=NEW.lineage,

building_parent_id         :=NEW.building_parent_id,
building_root_id           :=NEW.building_root_id,
class                      :=NEW.class,
class_codespace            :=NEW.class_codespace,
function                   :=NEW.function,
function_codespace         :=NEW.function_codespace,
usage                      :=NEW.usage,
usage_codespace            :=NEW.usage_codespace,
year_of_construction       :=NEW.year_of_construction,
year_of_demolition         :=NEW.year_of_demolition,
roof_type                  :=NEW.roof_type,
roof_type_codespace        :=NEW.roof_type_codespace,
measured_height            :=NEW.measured_height,
measured_height_unit       :=NEW.measured_height_unit,
storeys_above_ground       :=NEW.storeys_above_ground,
storeys_below_ground       :=NEW.storeys_below_ground,
storey_heights_above_ground:=NEW.storey_heights_above_ground,
storey_heights_ag_unit     :=NEW.storey_heights_ag_unit,
storey_heights_below_ground:=NEW.storey_heights_below_ground,
storey_heights_bg_unit     :=NEW.storey_heights_bg_unit,
lod1_terrain_intersection  :=NEW.lod1_terrain_intersection,
lod2_terrain_intersection  :=NEW.lod2_terrain_intersection,
lod3_terrain_intersection  :=NEW.lod3_terrain_intersection,
lod4_terrain_intersection  :=NEW.lod4_terrain_intersection,
lod2_multi_curve           :=NEW.lod2_multi_curve,
lod3_multi_curve           :=NEW.lod3_multi_curve,
lod4_multi_curve           :=NEW.lod4_multi_curve,
lod0_footprint_id          :=NEW.lod0_footprint_id,
lod0_roofprint_id          :=NEW.lod0_roofprint_id,
lod1_multi_surface_id      :=NEW.lod1_multi_surface_id,
lod2_multi_surface_id      :=NEW.lod2_multi_surface_id,
lod3_multi_surface_id      :=NEW.lod3_multi_surface_id,
lod4_multi_surface_id      :=NEW.lod4_multi_surface_id,
lod1_solid_id              :=NEW.lod1_solid_id,
lod2_solid_id              :=NEW.lod2_solid_id,
lod3_solid_id              :=NEW.lod3_solid_id,
lod4_solid_id              :=NEW.lod4_solid_id,

type                       :=NEW.type,
type_codespace             :=NEW.type_codespace,
constr_weight              :=NEW.constr_weight,
is_landmarked              :=NEW.is_landmarked,
ref_point                  :=NEW.ref_point,
schema_name                :=p_schema_name
);
--RAISE NOTICE 'Inserted record with id: %', inserted_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_ins_building_part (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_NRG_BUILDING_PART
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_upd_building_part() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_upd_building_part()
  RETURNS trigger AS
$BODY$
DECLARE
  p_schema_name varchar DEFAULT 'citydb'::varchar;
  updated_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
EXECUTE format('UPDATE %I.cityobject AS t SET
 gmlid                 =%L,
 gmlid_codespace       =%L,
 name                  =%L,
 name_codespace        =%L,
 description           =%L,
 envelope              =%L,
 creation_date         =%L,
 termination_date      =%L,
 relative_to_terrain   =%L,
 relative_to_water     =%L,
 last_modification_date=%L,
 updating_person       =%L,
 reason_for_update     =%L,
 lineage               =%L
WHERE t.id=%L RETURNING id',
 p_schema_name,
 NEW.gmlid,
 NEW.gmlid_codespace,
 NEW.name,
 NEW.name_codespace,
 NEW.description,
 NEW.envelope,
 NEW.creation_date,
 NEW.termination_date,
 NEW.relative_to_terrain,
 NEW.relative_to_water,
 NEW.last_modification_date,
 NEW.updating_person,
 NEW.reason_for_update,
 NEW.lineage,
 OLD.id
) INTO updated_id;
EXECUTE format('UPDATE %I.building AS t SET
 building_parent_id         =%L,
 building_root_id           =%L,
 class                      =%L,
 class_codespace            =%L,
 function                   =%L,
 function_codespace         =%L,
 usage                      =%L,
 usage_codespace            =%L,
 year_of_construction       =%L,
 year_of_demolition         =%L,
 roof_type                  =%L,
 roof_type_codespace        =%L,
 measured_height            =%L,
 measured_height_unit       =%L,
 storeys_above_ground       =%L,
 storeys_below_ground       =%L,
 storey_heights_above_ground=%L,
 storey_heights_ag_unit     =%L,
 storey_heights_below_ground=%L,
 storey_heights_bg_unit     =%L,
 lod1_terrain_intersection  =%L,
 lod2_terrain_intersection  =%L,
 lod3_terrain_intersection  =%L,
 lod4_terrain_intersection  =%L,
 lod2_multi_curve           =%L,
 lod3_multi_curve           =%L,
 lod4_multi_curve           =%L,
 lod0_footprint_id          =%L,
 lod0_roofprint_id          =%L,
 lod1_multi_surface_id      =%L,
 lod2_multi_surface_id      =%L,
 lod3_multi_surface_id      =%L,
 lod4_multi_surface_id      =%L,
 lod1_solid_id              =%L,
 lod2_solid_id              =%L,
 lod3_solid_id              =%L,
 lod4_solid_id              =%L
WHERE t.id=%L RETURNING id',
 p_schema_name,
 NEW.building_parent_id,
 NEW.building_root_id,
 NEW.class,
 NEW.class_codespace,
 NEW.function,
 NEW.function_codespace,
 NEW.usage,
 NEW.usage_codespace,
 NEW.year_of_construction,
 NEW.year_of_demolition,
 NEW.roof_type,
 NEW.roof_type_codespace,
 NEW.measured_height,
 NEW.measured_height_unit,
 NEW.storeys_above_ground,
 NEW.storeys_below_ground,
 NEW.storey_heights_above_ground,
 NEW.storey_heights_ag_unit,
 NEW.storey_heights_below_ground,
 NEW.storey_heights_bg_unit,
 NEW.lod1_terrain_intersection,
 NEW.lod2_terrain_intersection,
 NEW.lod3_terrain_intersection,
 NEW.lod4_terrain_intersection,
 NEW.lod2_multi_curve,
 NEW.lod3_multi_curve,
 NEW.lod4_multi_curve,
 NEW.lod0_footprint_id,
 NEW.lod0_roofprint_id,
 NEW.lod1_multi_surface_id,
 NEW.lod2_multi_surface_id,
 NEW.lod3_multi_surface_id,
 NEW.lod4_multi_surface_id,
 NEW.lod1_solid_id,
 NEW.lod2_solid_id,
 NEW.lod3_solid_id,
 NEW.lod4_solid_id,
 OLD.id
) INTO updated_id;
EXECUTE format('UPDATE %I.nrg8_building AS t SET
type          =%L,
type_codespace=%L,
constr_weight =%L,
is_landmarked =%L,
ref_point     =%L
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.type,
NEW.type_codespace,
NEW.constr_weight,
NEW.is_landmarked,
NEW.ref_point,
OLD.id
) INTO updated_id;
-- RAISE NOTICE 'Updated record with id: %',updated_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_upd_building_part (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view nrg8_BUILDING_PART
----------------------------------------------------------------
DROP TRIGGER IF EXISTS nrg8_tr_del_building_part ON citydb_view.nrg8_building_part;
CREATE TRIGGER nrg8_tr_del_building_part
	INSTEAD OF DELETE ON citydb_view.nrg8_building_part
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_del_building_part ('citydb');

DROP TRIGGER IF EXISTS nrg8_tr_ins_building_part ON citydb_view.nrg8_building_part;
CREATE TRIGGER nrg8_tr_ins_building_part
	INSTEAD OF INSERT ON citydb_view.nrg8_building_part
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_ins_building_part ('citydb');

DROP TRIGGER IF EXISTS nrg8_tr_upd_building_part ON citydb_view.nrg8_building_part;
CREATE TRIGGER nrg8_tr_upd_building_part
	INSTEAD OF UPDATE ON citydb_view.nrg8_building_part
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_upd_building_part ('citydb');
--**************************************************************
--**************************************************************

----------------------------------------------------------------
-- Function TR_DEL_BUILDING_UNIT
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_del_building_unit() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_del_building_unit()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
deleted_id=citydb_pkg.nrg8_delete_building_unit(OLD.id, p_schema_name);
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_del_building_unit (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_BUILDING_UNIT
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_ins_building_unit() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_ins_building_unit()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	inserted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
inserted_id=citydb_view.nrg8_insert_building_unit(
id                    :=NEW.id,
gmlid                 :=NEW.gmlid,
gmlid_codespace       :=NEW.gmlid_codespace,
name                  :=NEW.name,
name_codespace        :=NEW.name_codespace,
description           :=NEW.description,
envelope              :=NEW.envelope,
creation_date         :=NEW.creation_date,
termination_date      :=NEW.termination_date,
relative_to_terrain   :=NEW.relative_to_terrain,
relative_to_water     :=NEW.relative_to_water,
last_modification_date:=NEW.last_modification_date,
updating_person       :=NEW.updating_person,
reason_for_update     :=NEW.reason_for_update,
lineage               :=NEW.lineage,
nbr_of_rooms    :=NEW.nbr_of_rooms,
owner_name      :=NEW.owner_name,
ownership_type  :=NEW.ownership_type,
usage_zone_id   :=NEW.usage_zone_id,
schema_name     :=p_schema_name
);
--RAISE NOTICE 'Inserted record with id: %', inserted_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_ins_building_unit (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_BUILDING_UNIT
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_upd_building_unit() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_upd_building_unit()
  RETURNS trigger AS
$BODY$
DECLARE
  p_schema_name varchar DEFAULT 'citydb'::varchar;
  updated_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
EXECUTE format('UPDATE %I.cityobject AS t SET
 gmlid                 =%L,
 gmlid_codespace       =%L,
 name                  =%L,
 name_codespace        =%L,
 description           =%L,
 envelope              =%L,
 creation_date         =%L,
 termination_date      =%L,
 relative_to_terrain   =%L,
 relative_to_water     =%L,
 last_modification_date=%L,
 updating_person       =%L,
 reason_for_update     =%L,
 lineage               =%L
WHERE t.id=%L RETURNING id',
 p_schema_name,
 NEW.gmlid,
 NEW.gmlid_codespace,
 NEW.name,
 NEW.name_codespace,
 NEW.description,
 NEW.envelope,
 NEW.creation_date,
 NEW.termination_date,
 NEW.relative_to_terrain,
 NEW.relative_to_water,
 NEW.last_modification_date,
 NEW.updating_person,
 NEW.reason_for_update,
 NEW.lineage,
 OLD.id
) INTO updated_id;
EXECUTE format('UPDATE %I.nrg8_building_unit AS t SET
nbr_of_rooms  =%L,
owner_name    =%L,
ownership_type=%L,
usage_zone_id =%L
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.nbr_of_rooms,
NEW.owner_name,
NEW.ownership_type,
NEW.usage_zone_id,
OLD.id
) INTO updated_id;
-- RAISE NOTICE 'Updated record with id: %',updated_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_upd_building_unit (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view BUILDING_UNIT
----------------------------------------------------------------
DROP TRIGGER IF EXISTS nrg8_tr_del_building_unit ON citydb_view.nrg8_building_unit;
CREATE TRIGGER nrg8_tr_del_building_unit
	INSTEAD OF DELETE ON citydb_view.nrg8_building_unit
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_del_building_unit ('citydb');

DROP TRIGGER IF EXISTS nrg8_tr_ins_building_unit ON citydb_view.nrg8_building_unit;
CREATE TRIGGER nrg8_tr_ins_building_unit
	INSTEAD OF INSERT ON citydb_view.nrg8_building_unit
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_ins_building_unit ('citydb');

DROP TRIGGER IF EXISTS nrg8_tr_upd_building_unit ON citydb_view.nrg8_building_unit;
CREATE TRIGGER nrg8_tr_upd_building_unit
	INSTEAD OF UPDATE ON citydb_view.nrg8_building_unit
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_upd_building_unit ('citydb');
--**************************************************************
--**************************************************************

----------------------------------------------------------------
-- Function TR_DEL_EMITTER
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_del_emitter() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_del_emitter()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
deleted_id=citydb_pkg.nrg8_delete_emitter(OLD.id, p_schema_name);
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_del_emitter (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_EMITTER
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_ins_emitter() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_ins_emitter()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	inserted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
inserted_id=citydb_view.nrg8_insert_emitter(
id                    :=NEW.id,
gmlid                 :=NEW.gmlid,
gmlid_codespace       :=NEW.gmlid_codespace,
name                  :=NEW.name,
name_codespace        :=NEW.name_codespace,
description           :=NEW.description,
envelope              :=NEW.envelope,
creation_date         :=NEW.creation_date,
termination_date      :=NEW.termination_date,
relative_to_terrain   :=NEW.relative_to_terrain,
relative_to_water     :=NEW.relative_to_water,
last_modification_date:=NEW.last_modification_date,
updating_person       :=NEW.updating_person,
reason_for_update     :=NEW.reason_for_update,
lineage               :=NEW.lineage,

type                     :=NEW.type,
unit_nbr                 :=NEW.unit_nbr,
inst_pwr                 :=NEW.inst_pwr,
inst_pwr_unit            :=NEW.inst_pwr_unit,
therm_exch_tot_value     :=NEW.therm_exch_tot_value,
therm_exch_tot_value_unit:=NEW.therm_exch_tot_value_unit,
therm_exch_conv          :=NEW.therm_exch_conv,
therm_exch_rad           :=NEW.therm_exch_rad,
therm_exch_lat           :=NEW.therm_exch_lat,
distr_system_id          :=NEW.distr_system_id,
cityobject_id            :=NEW.cityobject_id,
schema_name              :=p_schema_name
);
--RAISE NOTICE 'Inserted record with id: %', inserted_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_ins_emitter (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_EMITTER
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_upd_emitter() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_upd_emitter()
  RETURNS trigger AS
$BODY$
DECLARE
  p_schema_name varchar DEFAULT 'citydb'::varchar;
  updated_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
EXECUTE format('UPDATE %I.cityobject AS t SET
 gmlid                 =%L,
 gmlid_codespace       =%L,
 name                  =%L,
 name_codespace        =%L,
 description           =%L,
 envelope              =%L,
 creation_date         =%L,
 termination_date      =%L,
 relative_to_terrain   =%L,
 relative_to_water     =%L,
 last_modification_date=%L,
 updating_person       =%L,
 reason_for_update     =%L,
 lineage               =%L
WHERE t.id=%L RETURNING id',
 p_schema_name,
 NEW.gmlid,
 NEW.gmlid_codespace,
 NEW.name,
 NEW.name_codespace,
 NEW.description,
 NEW.envelope,
 NEW.creation_date,
 NEW.termination_date,
 NEW.relative_to_terrain,
 NEW.relative_to_water,
 NEW.last_modification_date,
 NEW.updating_person,
 NEW.reason_for_update,
 NEW.lineage,
 OLD.id
) INTO updated_id;
EXECUTE format('UPDATE %I.nrg8_emitter AS t SET
type                     =%L,
unit_nbr                 =%L,
inst_pwr                 =%L,
inst_pwr_unit            =%L,
therm_exch_tot_value     =%L,
therm_exch_tot_value_unit=%L,
therm_exch_conv          =%L,
therm_exch_rad           =%L,
therm_exch_lat           =%L,
distr_system_id          =%L,
cityobject_id            =%L
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.type,
NEW.unit_nbr,
NEW.inst_pwr,
NEW.inst_pwr_unit,
NEW.therm_exch_tot_value,
NEW.therm_exch_tot_value_unit,
NEW.therm_exch_conv,
NEW.therm_exch_rad,
NEW.therm_exch_lat,
NEW.distr_system_id,
NEW.cityobject_id,
OLD.id
) INTO updated_id;
-- RAISE NOTICE 'Updated record with id: %',updated_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_upd_emitter (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view EMITTER
----------------------------------------------------------------
DROP TRIGGER IF EXISTS nrg8_tr_del_emitter ON citydb_view.nrg8_emitter;
CREATE TRIGGER nrg8_tr_del_emitter
	INSTEAD OF DELETE ON citydb_view.nrg8_emitter
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_del_emitter ('citydb');

DROP TRIGGER IF EXISTS nrg8_tr_ins_emitter ON citydb_view.nrg8_emitter;
CREATE TRIGGER nrg8_tr_ins_emitter
	INSTEAD OF INSERT ON citydb_view.nrg8_emitter
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_ins_emitter ('citydb');

DROP TRIGGER IF EXISTS nrg8_tr_upd_emitter ON citydb_view.nrg8_emitter;
CREATE TRIGGER nrg8_tr_upd_emitter
	INSTEAD OF UPDATE ON citydb_view.nrg8_emitter
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_upd_emitter ('citydb');
--**************************************************************
--**************************************************************

----------------------------------------------------------------
-- Function TR_DEL_FACILITIES_DHW
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_del_facilities_dhw() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_del_facilities_dhw()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
deleted_id=citydb_pkg.nrg8_delete_facilities(OLD.id, p_schema_name);
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_del_facilities_dhw (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_FACILITIES_DHW
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_ins_facilities_dhw() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_ins_facilities_dhw()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	inserted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
inserted_id=citydb_view.nrg8_insert_dhw_facilities(
id                    :=NEW.id,
gmlid                 :=NEW.gmlid,
gmlid_codespace       :=NEW.gmlid_codespace,
name                  :=NEW.name,
name_codespace        :=NEW.name_codespace,
description           :=NEW.description,
envelope              :=NEW.envelope,
creation_date         :=NEW.creation_date,
termination_date      :=NEW.termination_date,
relative_to_terrain   :=NEW.relative_to_terrain,
relative_to_water     :=NEW.relative_to_water,
last_modification_date:=NEW.last_modification_date,
updating_person       :=NEW.updating_person,
reason_for_update     :=NEW.reason_for_update,
lineage               :=NEW.lineage,

heat_diss_tot_value     :=NEW.heat_diss_tot_value,
heat_diss_tot_value_unit:=NEW.heat_diss_tot_value_unit,
heat_diss_conv          :=NEW.heat_diss_conv,
heat_diss_lat           :=NEW.heat_diss_lat,
heat_diss_rad           :=NEW.heat_diss_rad,
nbr_of_baths            :=NEW.nbr_of_baths,
nbr_of_showers          :=NEW.nbr_of_showers,
nbr_of_washbasins       :=NEW.nbr_of_washbasins,
water_strg_vol          :=NEW.water_strg_vol,
water_strg_vol_unit     :=NEW.water_strg_vol_unit,
oper_sched_id           :=NEW.oper_sched_id,
usage_zone_id           :=NEW.usage_zone_id,
building_unit_id        :=NEW.building_unit_id,
schema_name               :=p_schema_name
);
--RAISE NOTICE 'Inserted record with id: %', inserted_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_ins_facilities_dhw (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_FACILITIES_DHW
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_upd_facilities_dhw() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_upd_facilities_dhw()
  RETURNS trigger AS
$BODY$
DECLARE
  p_schema_name varchar DEFAULT 'citydb'::varchar;
  updated_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
EXECUTE format('UPDATE %I.cityobject AS t SET
 gmlid                 =%L,
 gmlid_codespace       =%L,
 name                  =%L,
 name_codespace        =%L,
 description           =%L,
 envelope              =%L,
 creation_date         =%L,
 termination_date      =%L,
 relative_to_terrain   =%L,
 relative_to_water     =%L,
 last_modification_date=%L,
 updating_person       =%L,
 reason_for_update     =%L,
 lineage               =%L
WHERE t.id=%L RETURNING id',
 p_schema_name,
 NEW.gmlid,
 NEW.gmlid_codespace,
 NEW.name,
 NEW.name_codespace,
 NEW.description,
 NEW.envelope,
 NEW.creation_date,
 NEW.termination_date,
 NEW.relative_to_terrain,
 NEW.relative_to_water,
 NEW.last_modification_date,
 NEW.updating_person,
 NEW.reason_for_update,
 NEW.lineage,
 OLD.id
) INTO updated_id;
EXECUTE format('UPDATE %I.nrg8_facilities AS t SET
heat_diss_tot_value     =%L,
heat_diss_tot_value_unit=%L,
heat_diss_conv          =%L,
heat_diss_lat           =%L,
heat_diss_rad           =%L,
nbr_of_baths            =%L,
nbr_of_showers          =%L,
nbr_of_washbasins       =%L,
water_strg_vol          =%L,
water_strg_vol_unit     =%L,
oper_sched_id           =%L,
usage_zone_id           =%L,
building_unit_id        =%L
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.heat_diss_tot_value,
NEW.heat_diss_tot_value_unit,
NEW.heat_diss_conv,
NEW.heat_diss_lat,
NEW.heat_diss_rad,
NEW.nbr_of_baths,
NEW.nbr_of_showers,
NEW.nbr_of_washbasins,
NEW.water_strg_vol,
NEW.water_strg_vol_unit,
NEW.oper_sched_id,
NEW.usage_zone_id,
NEW.building_unit_id,
OLD.id
) INTO updated_id;
-- RAISE NOTICE 'Updated record with id: %',updated_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_upd_facilities_dhw (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view FACILITIES_DHW
----------------------------------------------------------------
DROP TRIGGER IF EXISTS nrg8_tr_del_facilities_dhw ON citydb_view.nrg8_facilities_dhw;
CREATE TRIGGER nrg8_tr_del_facilities_dhw
	INSTEAD OF DELETE ON citydb_view.nrg8_facilities_dhw
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_del_facilities_dhw ('citydb');

DROP TRIGGER IF EXISTS nrg8_tr_ins_facilities_dhw ON citydb_view.nrg8_facilities_dhw;
CREATE TRIGGER nrg8_tr_ins_facilities_dhw
	INSTEAD OF INSERT ON citydb_view.nrg8_facilities_dhw
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_ins_facilities_dhw ('citydb');

DROP TRIGGER IF EXISTS nrg8_tr_upd_facilities_dhw ON citydb_view.nrg8_facilities_dhw;
CREATE TRIGGER nrg8_tr_upd_facilities_dhw
	INSTEAD OF UPDATE ON citydb_view.nrg8_facilities_dhw
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_upd_facilities_dhw ('citydb');
--**************************************************************
--**************************************************************

----------------------------------------------------------------
-- Function TR_DEL_FACILITIES_DHW
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_del_facilities_electrical_appliances() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_del_facilities_electrical_appliances()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
deleted_id=citydb_pkg.nrg8_delete_facilities(OLD.id, p_schema_name);
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_del_facilities_electrical_appliances (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_FACILITIES_ELECTRICAL_APPLIANCES
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_ins_facilities_electrical_appliances() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_ins_facilities_electrical_appliances()
  RETURNS trigger AS
$BODY$
DECLARE
	class_name varchar DEFAULT 'ElectricalAppliances'::varchar;

	p_schema_name varchar DEFAULT 'citydb'::varchar;
	inserted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
inserted_id=citydb_view.nrg8_insert_electrical_appliances(
id                    :=NEW.id,
gmlid                 :=NEW.gmlid,
gmlid_codespace       :=NEW.gmlid_codespace,
name                  :=NEW.name,
name_codespace        :=NEW.name_codespace,
description           :=NEW.description,
envelope              :=NEW.envelope,
creation_date         :=NEW.creation_date,
termination_date      :=NEW.termination_date,
relative_to_terrain   :=NEW.relative_to_terrain,
relative_to_water     :=NEW.relative_to_water,
last_modification_date:=NEW.last_modification_date,
updating_person       :=NEW.updating_person,
reason_for_update     :=NEW.reason_for_update,
lineage               :=NEW.lineage,

heat_diss_tot_value     :=NEW.heat_diss_tot_value,
heat_diss_tot_value_unit:=NEW.heat_diss_tot_value_unit,
heat_diss_conv          :=NEW.heat_diss_conv,
heat_diss_lat           :=NEW.heat_diss_lat,
heat_diss_rad           :=NEW.heat_diss_rad,
electr_pwr              :=NEW.electr_pwr,
electr_pwr_unit         :=NEW.electr_pwr_unit,

oper_sched_id           :=NEW.oper_sched_id,
usage_zone_id           :=NEW.usage_zone_id,
building_unit_id        :=NEW.building_unit_id,
schema_name               :=p_schema_name
);
--RAISE NOTICE 'Inserted record with id: %', inserted_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_ins_facilities_electrical_appliances (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_FACILITIES_ELECTRICAL_APPLIANCES
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_upd_facilities_electrical_appliances() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_upd_facilities_electrical_appliances()
  RETURNS trigger AS
$BODY$
DECLARE
  p_schema_name varchar DEFAULT 'citydb'::varchar;
  updated_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
EXECUTE format('UPDATE %I.cityobject AS t SET
 gmlid                 =%L,
 gmlid_codespace       =%L,
 name                  =%L,
 name_codespace        =%L,
 description           =%L,
 envelope              =%L,
 creation_date         =%L,
 termination_date      =%L,
 relative_to_terrain   =%L,
 relative_to_water     =%L,
 last_modification_date=%L,
 updating_person       =%L,
 reason_for_update     =%L,
 lineage               =%L
WHERE t.id=%L RETURNING id',
 p_schema_name,
 NEW.gmlid,
 NEW.gmlid_codespace,
 NEW.name,
 NEW.name_codespace,
 NEW.description,
 NEW.envelope,
 NEW.creation_date,
 NEW.termination_date,
 NEW.relative_to_terrain,
 NEW.relative_to_water,
 NEW.last_modification_date,
 NEW.updating_person,
 NEW.reason_for_update,
 NEW.lineage,
 OLD.id
) INTO updated_id;
EXECUTE format('UPDATE %I.nrg8_facilities AS t SET
heat_diss_tot_value     =%L,
heat_diss_tot_value_unit=%L,
heat_diss_conv          =%L,
heat_diss_lat           =%L,
heat_diss_rad           =%L,
electr_pwr              =%L,
electr_pwr_unit         =%L,
oper_sched_id           =%L,
usage_zone_id           =%L,
building_unit_id        =%L
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.heat_diss_tot_value,
NEW.heat_diss_tot_value_unit,
NEW.heat_diss_conv,
NEW.heat_diss_lat,
NEW.heat_diss_rad,
NEW.electr_pwr,
NEW.electr_pwr_unit,
NEW.oper_sched_id,
NEW.usage_zone_id,
NEW.building_unit_id,
OLD.id
) INTO updated_id;
-- RAISE NOTICE 'Updated record with id: %',updated_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_upd_facilities_electrical_appliances (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view FACILITIES_ELECTRICAL_APPLIANCES
----------------------------------------------------------------
DROP TRIGGER IF EXISTS nrg8_tr_del_facilities_electrical_appliances ON citydb_view.nrg8_facilities_electrical_appliances;
CREATE TRIGGER nrg8_tr_del_facilities_electrical_appliances
	INSTEAD OF DELETE ON citydb_view.nrg8_facilities_electrical_appliances
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_del_facilities_electrical_appliances ('citydb');

DROP TRIGGER IF EXISTS nrg8_tr_ins_facilities_electrical_appliances ON citydb_view.nrg8_facilities_electrical_appliances;
CREATE TRIGGER nrg8_tr_ins_facilities_electrical_appliances
	INSTEAD OF INSERT ON citydb_view.nrg8_facilities_electrical_appliances
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_ins_facilities_electrical_appliances ('citydb');

DROP TRIGGER IF EXISTS nrg8_tr_upd_facilities_electrical_appliances ON citydb_view.nrg8_facilities_electrical_appliances;
CREATE TRIGGER nrg8_tr_upd_facilities_electrical_appliances
	INSTEAD OF UPDATE ON citydb_view.nrg8_facilities_electrical_appliances
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_upd_facilities_electrical_appliances ('citydb');
--**************************************************************
--**************************************************************

----------------------------------------------------------------
-- Function TR_DEL_FACILITIES_LIGHTING
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_del_facilities_lighting() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_del_facilities_lighting()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
deleted_id=citydb_pkg.nrg8_delete_facilities(OLD.id, p_schema_name);
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_del_facilities_lighting (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_FACILITIES_LIGHTING
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_ins_facilities_lighting() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_ins_facilities_lighting()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	inserted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
inserted_id=citydb_view.nrg8_insert_lighting(
id                    :=NEW.id,
gmlid                 :=NEW.gmlid,
gmlid_codespace       :=NEW.gmlid_codespace,
name                  :=NEW.name,
name_codespace        :=NEW.name_codespace,
description           :=NEW.description,
envelope              :=NEW.envelope,
creation_date         :=NEW.creation_date,
termination_date      :=NEW.termination_date,
relative_to_terrain   :=NEW.relative_to_terrain,
relative_to_water     :=NEW.relative_to_water,
last_modification_date:=NEW.last_modification_date,
updating_person       :=NEW.updating_person,
reason_for_update     :=NEW.reason_for_update,
lineage               :=NEW.lineage,

heat_diss_tot_value     :=NEW.heat_diss_tot_value,
heat_diss_tot_value_unit:=NEW.heat_diss_tot_value_unit,
heat_diss_conv          :=NEW.heat_diss_conv,
heat_diss_lat           :=NEW.heat_diss_lat,
heat_diss_rad           :=NEW.heat_diss_rad,
electr_pwr              :=NEW.electr_pwr,
electr_pwr_unit         :=NEW.electr_pwr_unit,

oper_sched_id           :=NEW.oper_sched_id,
usage_zone_id           :=NEW.usage_zone_id,
building_unit_id        :=NEW.building_unit_id,
schema_name               :=p_schema_name
);
--RAISE NOTICE 'Inserted record with id: %', inserted_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_ins_facilities_lighting (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_FACILITIES_LIGHTING
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_upd_facilities_lighting() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_upd_facilities_lighting()
  RETURNS trigger AS
$BODY$
DECLARE
  p_schema_name varchar DEFAULT 'citydb'::varchar;
  updated_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
EXECUTE format('UPDATE %I.cityobject AS t SET
 gmlid                 =%L,
 gmlid_codespace       =%L,
 name                  =%L,
 name_codespace        =%L,
 description           =%L,
 envelope              =%L,
 creation_date         =%L,
 termination_date      =%L,
 relative_to_terrain   =%L,
 relative_to_water     =%L,
 last_modification_date=%L,
 updating_person       =%L,
 reason_for_update     =%L,
 lineage               =%L
WHERE t.id=%L RETURNING id',
 p_schema_name,
 NEW.gmlid,
 NEW.gmlid_codespace,
 NEW.name,
 NEW.name_codespace,
 NEW.description,
 NEW.envelope,
 NEW.creation_date,
 NEW.termination_date,
 NEW.relative_to_terrain,
 NEW.relative_to_water,
 NEW.last_modification_date,
 NEW.updating_person,
 NEW.reason_for_update,
 NEW.lineage,
 OLD.id
) INTO updated_id;
EXECUTE format('UPDATE %I.nrg8_facilities AS t SET
heat_diss_tot_value     =%L,
heat_diss_tot_value_unit=%L,
heat_diss_conv          =%L,
heat_diss_lat           =%L,
heat_diss_rad           =%L,
electr_pwr              =%L,
electr_pwr_unit         =%L,
oper_sched_id           =%L,
usage_zone_id           =%L,
building_unit_id        =%L
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.heat_diss_tot_value,
NEW.heat_diss_tot_value_unit,
NEW.heat_diss_conv,
NEW.heat_diss_lat,
NEW.heat_diss_rad,
NEW.electr_pwr,
NEW.electr_pwr_unit,
NEW.oper_sched_id,
NEW.usage_zone_id,
NEW.building_unit_id,
OLD.id
) INTO updated_id;
-- RAISE NOTICE 'Updated record with id: %',updated_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_upd_facilities_lighting (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view FACILITIES_LIGHTING
----------------------------------------------------------------
DROP TRIGGER IF EXISTS nrg8_tr_del_facilities_lighting ON citydb_view.nrg8_facilities_lighting;
CREATE TRIGGER nrg8_tr_del_facilities_lighting
	INSTEAD OF DELETE ON citydb_view.nrg8_facilities_lighting
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_del_facilities_lighting ('citydb');

DROP TRIGGER IF EXISTS nrg8_tr_ins_facilities_lighting ON citydb_view.nrg8_facilities_lighting;
CREATE TRIGGER nrg8_tr_ins_facilities_lighting
	INSTEAD OF INSERT ON citydb_view.nrg8_facilities_lighting
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_ins_facilities_lighting ('citydb');

DROP TRIGGER IF EXISTS nrg8_tr_upd_facilities_lighting ON citydb_view.nrg8_facilities_lighting;
CREATE TRIGGER nrg8_tr_upd_facilities_lighting
	INSTEAD OF UPDATE ON citydb_view.nrg8_facilities_lighting
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_upd_facilities_lighting ('citydb');
--**************************************************************
--**************************************************************

----------------------------------------------------------------
-- Function TR_DEL_DISTRIB_SYSTEM_POWER
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.nrg8_tr_del_distrib_system_power() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_del_distrib_system_power()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
deleted_id=citydb_pkg.nrg8_delete_distrib_system(OLD.id, p_schema_name);
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_del_distrib_system_power (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_DISTRIB_SYSTEM_POWER
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.nrg8_tr_ins_distrib_system_power() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_ins_distrib_system_power()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	inserted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
inserted_id=citydb_view.nrg8_insert_power_distrib_system(
id                    :=NEW.id,
gmlid                 :=NEW.gmlid,
gmlid_codespace       :=NEW.gmlid_codespace,
name                  :=NEW.name,
name_codespace        :=NEW.name_codespace,
description           :=NEW.description,
envelope              :=NEW.envelope,
creation_date         :=NEW.creation_date,
termination_date      :=NEW.termination_date,
relative_to_terrain   :=NEW.relative_to_terrain,
relative_to_water     :=NEW.relative_to_water,
last_modification_date:=NEW.last_modification_date,
updating_person       :=NEW.updating_person,
reason_for_update     :=NEW.reason_for_update,
lineage               :=NEW.lineage,

distrib_perim           :=NEW.distrib_perim,
start_of_life           :=NEW.start_of_life,
life_expect_value       :=NEW.life_expect_value,
life_expect_value_unit  :=NEW.life_expect_value_unit,
main_maint_interval     :=NEW.main_maint_interval,
main_maint_interval_unit:=NEW.main_maint_interval_unit,
nrg_demand_id           :=NEW.nrg_demand_id,
cityobject_id           :=NEW.cityobject_id,

current         :=NEW.current,
current_unit    :=NEW.current_unit,
voltage         :=NEW.voltage,
voltage_unit    :=NEW.voltage_unit,
schema_name       :=p_schema_name
);
--RAISE NOTICE 'Inserted record with id: %', inserted_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_ins_distrib_system_power (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_DISTRIB_SYSTEM_POWER
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.nrg8_tr_upd_distrib_system_power() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_upd_distrib_system_power()
  RETURNS trigger AS
$BODY$
DECLARE
  p_schema_name varchar DEFAULT 'citydb'::varchar;
  updated_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
EXECUTE format('UPDATE %I.cityobject AS t SET
 gmlid                 =%L,
 gmlid_codespace       =%L,
 name                  =%L,
 name_codespace        =%L,
 description           =%L,
 envelope              =%L,
 creation_date         =%L,
 termination_date      =%L,
 relative_to_terrain   =%L,
 relative_to_water     =%L,
 last_modification_date=%L,
 updating_person       =%L,
 reason_for_update     =%L,
 lineage               =%L
WHERE t.id=%L RETURNING id',
 p_schema_name,
 NEW.gmlid,
 NEW.gmlid_codespace,
 NEW.name,
 NEW.name_codespace,
 NEW.description,
 NEW.envelope,
 NEW.creation_date,
 NEW.termination_date,
 NEW.relative_to_terrain,
 NEW.relative_to_water,
 NEW.last_modification_date,
 NEW.updating_person,
 NEW.reason_for_update,
 NEW.lineage,
 OLD.id
) INTO updated_id;
EXECUTE format('UPDATE %I.nrg8_distrib_system AS t SET
distrib_perim           =%L,
start_of_life           =%L,
life_expect_value       =%L,
life_expect_value_unit  =%L,
main_maint_interval     =%L,
main_maint_interval_unit=%L,
nrg_demand_id           =%L,
cityobject_id           =%L
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.distrib_perim,
NEW.start_of_life,
NEW.life_expect_value,
NEW.life_expect_value_unit,
NEW.main_maint_interval,
NEW.main_maint_interval_unit,
NEW.nrg_demand_id,
NEW.cityobject_id,
OLD.id
) INTO updated_id;
EXECUTE format('UPDATE %I.nrg8_power_distrib_system AS t SET
current     =%L,
current_unit=%L,
voltage     =%L,
voltage_unit=%L
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.current,
NEW.current_unit,
NEW.voltage,
NEW.voltage_unit,
OLD.id
) INTO updated_id;
-- RAISE NOTICE 'Updated record with id: %',updated_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_upd_distrib_system_power (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view DISTRIB_SYSTEM_POWER
----------------------------------------------------------------
DROP TRIGGER IF EXISTS nrg8_tr_del_distrib_system_power ON citydb_view.nrg8_distrib_system_power;
CREATE TRIGGER nrg8_tr_del_distrib_system_power
	INSTEAD OF DELETE ON citydb_view.nrg8_distrib_system_power
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_del_distrib_system_power ('citydb');

DROP TRIGGER IF EXISTS nrg8_tr_ins_distrib_system_power ON citydb_view.nrg8_distrib_system_power;
CREATE TRIGGER nrg8_tr_ins_distrib_system_power
	INSTEAD OF INSERT ON citydb_view.nrg8_distrib_system_power
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_ins_distrib_system_power ('citydb');

DROP TRIGGER IF EXISTS nrg8_tr_upd_distrib_system_power ON citydb_view.nrg8_distrib_system_power;
CREATE TRIGGER nrg8_tr_upd_distrib_system_power
	INSTEAD OF UPDATE ON citydb_view.nrg8_distrib_system_power
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_upd_distrib_system_power ('citydb');
--**************************************************************
--**************************************************************
----------------------------------------------------------------
-- Function TR_DEL_DISTRIB_SYSTEM_GENERIC
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.nrg8_tr_del_distrib_system_generic() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_del_distrib_system_generic()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
deleted_id=citydb_pkg.nrg8_delete_distrib_system(OLD.id, p_schema_name);
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_del_distrib_system_generic (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_DISTRIB_SYSTEM_GENERIC
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.nrg8_tr_ins_distrib_system_generic() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_ins_distrib_system_generic()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	inserted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
inserted_id=citydb_view.nrg8_insert_distrib_system(
id                    :=NEW.id,
gmlid                 :=NEW.gmlid,
gmlid_codespace       :=NEW.gmlid_codespace,
name                  :=NEW.name,
name_codespace        :=NEW.name_codespace,
description           :=NEW.description,
envelope              :=NEW.envelope,
creation_date         :=NEW.creation_date,
termination_date      :=NEW.termination_date,
relative_to_terrain   :=NEW.relative_to_terrain,
relative_to_water     :=NEW.relative_to_water,
last_modification_date:=NEW.last_modification_date,
updating_person       :=NEW.updating_person,
reason_for_update     :=NEW.reason_for_update,
lineage               :=NEW.lineage,

distrib_perim           :=NEW.distrib_perim,
start_of_life           :=NEW.start_of_life,
life_expect_value       :=NEW.life_expect_value,
life_expect_value_unit  :=NEW.life_expect_value_unit,
main_maint_interval     :=NEW.main_maint_interval,
main_maint_interval_unit:=NEW.main_maint_interval_unit,
nrg_demand_id           :=NEW.nrg_demand_id,
cityobject_id           :=NEW.cityobject_id
);
--RAISE NOTICE 'Inserted record with id: %', inserted_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_ins_distrib_system_generic (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_DISTRIB_SYSTEM_GENERIC
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.nrg8_tr_upd_distrib_system_generic() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_upd_distrib_system_generic()
  RETURNS trigger AS
$BODY$
DECLARE
  p_schema_name varchar DEFAULT 'citydb'::varchar;
  updated_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
EXECUTE format('UPDATE %I.cityobject AS t SET
 gmlid                 =%L,
 gmlid_codespace       =%L,
 name                  =%L,
 name_codespace        =%L,
 description           =%L,
 envelope              =%L,
 creation_date         =%L,
 termination_date      =%L,
 relative_to_terrain   =%L,
 relative_to_water     =%L,
 last_modification_date=%L,
 updating_person       =%L,
 reason_for_update     =%L,
 lineage               =%L
WHERE t.id=%L RETURNING id',
 p_schema_name,
 NEW.gmlid,
 NEW.gmlid_codespace,
 NEW.name,
 NEW.name_codespace,
 NEW.description,
 NEW.envelope,
 NEW.creation_date,
 NEW.termination_date,
 NEW.relative_to_terrain,
 NEW.relative_to_water,
 NEW.last_modification_date,
 NEW.updating_person,
 NEW.reason_for_update,
 NEW.lineage,
 OLD.id
) INTO updated_id;
EXECUTE format('UPDATE %I.nrg8_distrib_system AS t SET
distrib_perim           =%L,
start_of_life           =%L,
life_expect_value       =%L,
life_expect_value_unit  =%L,
main_maint_interval     =%L,
main_maint_interval_unit=%L,
nrg_demand_id           =%L,
cityobject_id           =%L
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.distrib_perim,
NEW.start_of_life,
NEW.life_expect_value,
NEW.life_expect_value_unit,
NEW.main_maint_interval,
NEW.main_maint_interval_unit,
NEW.nrg_demand_id,
NEW.cityobject_id,
OLD.id
) INTO updated_id;
-- RAISE NOTICE 'Updated record with id: %',updated_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_upd_distrib_system_generic (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view DISTRIB_SYSTEM_GENERIC
----------------------------------------------------------------
DROP TRIGGER IF EXISTS nrg8_tr_del_distrib_system_generic ON citydb_view.nrg8_distrib_system_generic;
CREATE TRIGGER nrg8_tr_del_distrib_system_generic
	INSTEAD OF DELETE ON citydb_view.nrg8_distrib_system_generic
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_del_distrib_system_generic ('citydb');

DROP TRIGGER IF EXISTS nrg8_tr_ins_distrib_system_generic ON citydb_view.nrg8_distrib_system_generic;
CREATE TRIGGER nrg8_tr_ins_distrib_system_generic
	INSTEAD OF INSERT ON citydb_view.nrg8_distrib_system_generic
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_ins_distrib_system_generic ('citydb');

DROP TRIGGER IF EXISTS nrg8_tr_upd_distrib_system_generic ON citydb_view.nrg8_distrib_system_generic;
CREATE TRIGGER nrg8_tr_upd_distrib_system_generic
	INSTEAD OF UPDATE ON citydb_view.nrg8_distrib_system_generic
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_upd_distrib_system_generic ('citydb');
--**************************************************************
--**************************************************************

----------------------------------------------------------------
-- Function TR_DEL_DISTRIB_SYSTEM_THERMAL
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.nrg8_tr_del_distrib_system_thermal() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_del_distrib_system_thermal()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
deleted_id=citydb_pkg.nrg8_delete_distrib_system(OLD.id, p_schema_name);
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_del_distrib_system_thermal (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_DISTRIB_SYSTEM_THERMAL
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.nrg8_tr_ins_distrib_system_thermal() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_ins_distrib_system_thermal()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	inserted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
inserted_id=citydb_view.nrg8_insert_thermal_distrib_system(
id                    :=NEW.id,
gmlid                 :=NEW.gmlid,
gmlid_codespace       :=NEW.gmlid_codespace,
name                  :=NEW.name,
name_codespace        :=NEW.name_codespace,
description           :=NEW.description,
envelope              :=NEW.envelope,
creation_date         :=NEW.creation_date,
termination_date      :=NEW.termination_date,
relative_to_terrain   :=NEW.relative_to_terrain,
relative_to_water     :=NEW.relative_to_water,
last_modification_date:=NEW.last_modification_date,
updating_person       :=NEW.updating_person,
reason_for_update     :=NEW.reason_for_update,
lineage               :=NEW.lineage,

distrib_perim           :=NEW.distrib_perim,
start_of_life           :=NEW.start_of_life,
life_expect_value       :=NEW.life_expect_value,
life_expect_value_unit  :=NEW.life_expect_value_unit,
main_maint_interval     :=NEW.main_maint_interval,
main_maint_interval_unit:=NEW.main_maint_interval_unit,
nrg_demand_id           :=NEW.nrg_demand_id,
cityobject_id           :=NEW.cityobject_id,

has_circulation :=NEW.has_circulation,
medium          :=NEW.medium,
nom_flow        :=NEW.nom_flow,
nom_flow_unit   :=NEW.nom_flow_unit,
supply_temp     :=NEW.supply_temp,
supply_temp_unit:=NEW.supply_temp_unit,
return_temp     :=NEW.return_temp,
return_temp_unit:=NEW.return_temp_unit,
therm_loss      :=NEW.therm_loss,
therm_loss_unit :=NEW.therm_loss_unit,
schema_name       :=p_schema_name
);
--RAISE NOTICE 'Inserted record with id: %', inserted_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_ins_distrib_system_thermal (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_DISTRIB_SYSTEM_THERMAL
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.nrg8_tr_upd_distrib_system_thermal() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_upd_distrib_system_thermal()
  RETURNS trigger AS
$BODY$
DECLARE
  p_schema_name varchar DEFAULT 'citydb'::varchar;
  updated_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
EXECUTE format('UPDATE %I.cityobject AS t SET
 gmlid                 =%L,
 gmlid_codespace       =%L,
 name                  =%L,
 name_codespace        =%L,
 description           =%L,
 envelope              =%L,
 creation_date         =%L,
 termination_date      =%L,
 relative_to_terrain   =%L,
 relative_to_water     =%L,
 last_modification_date=%L,
 updating_person       =%L,
 reason_for_update     =%L,
 lineage               =%L
WHERE t.id=%L RETURNING id',
 p_schema_name,
 NEW.gmlid,
 NEW.gmlid_codespace,
 NEW.name,
 NEW.name_codespace,
 NEW.description,
 NEW.envelope,
 NEW.creation_date,
 NEW.termination_date,
 NEW.relative_to_terrain,
 NEW.relative_to_water,
 NEW.last_modification_date,
 NEW.updating_person,
 NEW.reason_for_update,
 NEW.lineage,
 OLD.id
) INTO updated_id;
EXECUTE format('UPDATE %I.nrg8_distrib_system AS t SET
distrib_perim           =%L,
start_of_life           =%L,
life_expect_value       =%L,
life_expect_value_unit  =%L,
main_maint_interval     =%L,
main_maint_interval_unit=%L,
nrg_demand_id           =%L,
cityobject_id           =%L
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.distrib_perim,
NEW.start_of_life,
NEW.life_expect_value,
NEW.life_expect_value_unit,
NEW.main_maint_interval,
NEW.main_maint_interval_unit,
NEW.nrg_demand_id,
NEW.cityobject_id,
OLD.id
) INTO updated_id;
EXECUTE format('UPDATE %I.nrg8_thermal_distrib_system AS t SET
has_circulation =%L,
medium          =%L,
nom_flow        =%L,
nom_flow_unit   =%L,
supply_temp     =%L,
supply_temp_unit=%L,
return_temp     =%L,
return_temp_unit=%L,
therm_loss      =%L,
therm_loss_unit =%L
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.has_circulation,
NEW.medium,
NEW.nom_flow,
NEW.nom_flow_unit,
NEW.supply_temp,
NEW.supply_temp_unit,
NEW.return_temp,
NEW.return_temp_unit,
NEW.therm_loss,
NEW.therm_loss_unit,
OLD.id
) INTO updated_id;
-- RAISE NOTICE 'Updated record with id: %',updated_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_upd_distrib_system_thermal (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view DISTRIB_SYSTEM_THERMAL
----------------------------------------------------------------
DROP TRIGGER IF EXISTS nrg8_tr_del_distrib_system_thermal ON citydb_view.nrg8_distrib_system_thermal;
CREATE TRIGGER nrg8_tr_del_distrib_system_thermal
	INSTEAD OF DELETE ON citydb_view.nrg8_distrib_system_thermal
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_del_distrib_system_thermal ('citydb');

DROP TRIGGER IF EXISTS nrg8_tr_ins_distrib_system_thermal ON citydb_view.nrg8_distrib_system_thermal;
CREATE TRIGGER nrg8_tr_ins_distrib_system_thermal
	INSTEAD OF INSERT ON citydb_view.nrg8_distrib_system_thermal
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_ins_distrib_system_thermal ('citydb');

DROP TRIGGER IF EXISTS nrg8_tr_upd_distrib_system_thermal ON citydb_view.nrg8_distrib_system_thermal;
CREATE TRIGGER nrg8_tr_upd_distrib_system_thermal
	INSTEAD OF UPDATE ON citydb_view.nrg8_distrib_system_thermal
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_upd_distrib_system_thermal ('citydb');
--**************************************************************
--**************************************************************

----------------------------------------------------------------
-- Function TR_DEL_STORAGE_SYSTEM_POWER
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.nrg8_tr_del_storage_system_power() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_del_storage_system_power()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
deleted_id=citydb_pkg.nrg8_delete_distrib_system(OLD.id, p_schema_name);
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_del_storage_system_power (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_STORAGE_SYSTEM_POWER
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.nrg8_tr_ins_storage_system_power() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_ins_storage_system_power()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	inserted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
inserted_id=citydb_view.nrg8_insert_power_storage_system(
id                    :=NEW.id,
gmlid                 :=NEW.gmlid,
gmlid_codespace       :=NEW.gmlid_codespace,
name                  :=NEW.name,
name_codespace        :=NEW.name_codespace,
description           :=NEW.description,
envelope              :=NEW.envelope,
creation_date         :=NEW.creation_date,
termination_date      :=NEW.termination_date,
relative_to_terrain   :=NEW.relative_to_terrain,
relative_to_water     :=NEW.relative_to_water,
last_modification_date:=NEW.last_modification_date,
updating_person       :=NEW.updating_person,
reason_for_update     :=NEW.reason_for_update,
lineage               :=NEW.lineage,

start_of_life           :=NEW.start_of_life,
life_expect_value       :=NEW.life_expect_value,
life_expect_value_unit  :=NEW.life_expect_value_unit,
main_maint_interval     :=NEW.main_maint_interval,
main_maint_interval_unit:=NEW.main_maint_interval_unit,
nrg_demand_id           :=NEW.nrg_demand_id,
cityobject_id           :=NEW.cityobject_id,

battery_techn    :=NEW.battery_techn,
pwr_capacity     :=NEW.pwr_capacity,
pwr_capacity_unit:=NEW.pwr_capacity_unit,
schema_name        :=p_schema_name
);
--RAISE NOTICE 'Inserted record with id: %', inserted_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_ins_storage_system_power (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_STORAGE_SYSTEM_POWER
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.nrg8_tr_upd_storage_system_power() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_upd_storage_system_power()
  RETURNS trigger AS
$BODY$
DECLARE
  p_schema_name varchar DEFAULT 'citydb'::varchar;
  updated_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
EXECUTE format('UPDATE %I.cityobject AS t SET
 gmlid                 =%L,
 gmlid_codespace       =%L,
 name                  =%L,
 name_codespace        =%L,
 description           =%L,
 envelope              =%L,
 creation_date         =%L,
 termination_date      =%L,
 relative_to_terrain   =%L,
 relative_to_water     =%L,
 last_modification_date=%L,
 updating_person       =%L,
 reason_for_update     =%L,
 lineage               =%L
WHERE t.id=%L RETURNING id',
 p_schema_name,
 NEW.gmlid,
 NEW.gmlid_codespace,
 NEW.name,
 NEW.name_codespace,
 NEW.description,
 NEW.envelope,
 NEW.creation_date,
 NEW.termination_date,
 NEW.relative_to_terrain,
 NEW.relative_to_water,
 NEW.last_modification_date,
 NEW.updating_person,
 NEW.reason_for_update,
 NEW.lineage,
 OLD.id
) INTO updated_id;
EXECUTE format('UPDATE %I.nrg8_storage_system AS t SET
start_of_life           =%L,
life_expect_value       =%L,
life_expect_value_unit  =%L,
main_maint_interval     =%L,
main_maint_interval_unit=%L,
nrg_demand_id           =%L,
cityobject_id           =%L
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.start_of_life,
NEW.life_expect_value,
NEW.life_expect_value_unit,
NEW.main_maint_interval,
NEW.main_maint_interval_unit,
NEW.nrg_demand_id,
NEW.cityobject_id,
OLD.id
) INTO updated_id;
EXECUTE format('UPDATE %I.nrg8_power_storage_system AS t SET
battery_techn    =%L,
pwr_capacity     =%L,
pwr_capacity_unit=%L
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.battery_techn,
NEW.pwr_capacity,
NEW.pwr_capacity_unit,
OLD.id
) INTO updated_id;
-- RAISE NOTICE 'Updated record with id: %',updated_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_upd_storage_system_power (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view STORAGE_SYSTEM_POWER
----------------------------------------------------------------
DROP TRIGGER IF EXISTS nrg8_tr_del_storage_system_power ON citydb_view.nrg8_storage_system_power;
CREATE TRIGGER nrg8_tr_del_storage_system_power
	INSTEAD OF DELETE ON citydb_view.nrg8_storage_system_power
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_del_storage_system_power ('citydb');

DROP TRIGGER IF EXISTS nrg8_tr_ins_storage_system_power ON citydb_view.nrg8_storage_system_power;
CREATE TRIGGER nrg8_tr_ins_storage_system_power
	INSTEAD OF INSERT ON citydb_view.nrg8_storage_system_power
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_ins_storage_system_power ('citydb');

DROP TRIGGER IF EXISTS nrg8_tr_upd_storage_system_power ON citydb_view.nrg8_storage_system_power;
CREATE TRIGGER nrg8_tr_upd_storage_system_power
	INSTEAD OF UPDATE ON citydb_view.nrg8_storage_system_power
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_upd_storage_system_power ('citydb');
--**************************************************************
--**************************************************************

----------------------------------------------------------------
-- Function TR_DEL_STORAGE_SYSTEM_THERMAL
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.nrg8_tr_del_storage_system_thermal() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_del_storage_system_thermal()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
deleted_id=citydb_pkg.nrg8_delete_distrib_system(OLD.id, p_schema_name);
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_del_storage_system_thermal (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_STORAGE_SYSTEM_THERMAL
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.nrg8_tr_ins_storage_system_thermal() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_ins_storage_system_thermal()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	inserted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
inserted_id=citydb_view.nrg8_insert_thermal_storage_system(
id                    :=NEW.id,
gmlid                 :=NEW.gmlid,
gmlid_codespace       :=NEW.gmlid_codespace,
name                  :=NEW.name,
name_codespace        :=NEW.name_codespace,
description           :=NEW.description,
envelope              :=NEW.envelope,
creation_date         :=NEW.creation_date,
termination_date      :=NEW.termination_date,
relative_to_terrain   :=NEW.relative_to_terrain,
relative_to_water     :=NEW.relative_to_water,
last_modification_date:=NEW.last_modification_date,
updating_person       :=NEW.updating_person,
reason_for_update     :=NEW.reason_for_update,
lineage               :=NEW.lineage,

start_of_life           :=NEW.start_of_life,
life_expect_value       :=NEW.life_expect_value,
life_expect_value_unit  :=NEW.life_expect_value_unit,
main_maint_interval     :=NEW.main_maint_interval,
main_maint_interval_unit:=NEW.main_maint_interval_unit,
nrg_demand_id           :=NEW.nrg_demand_id,
cityobject_id           :=NEW.cityobject_id,

medium           :=NEW.medium,
vol              :=NEW.vol,
vol_unit         :=NEW.vol_unit,
prep_temp        :=NEW.prep_temp,
prep_temp_unit   :=NEW.prep_temp_unit,
therm_loss       :=NEW.therm_loss,
therm_loss_unit  :=NEW.therm_loss_unit,
schema_name        :=p_schema_name
);
--RAISE NOTICE 'Inserted record with id: %', inserted_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_ins_storage_system_thermal (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_STORAGE_SYSTEM_THERMAL
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.nrg8_tr_upd_storage_system_thermal() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_upd_storage_system_thermal()
  RETURNS trigger AS
$BODY$
DECLARE
  p_schema_name varchar DEFAULT 'citydb'::varchar;
  updated_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
EXECUTE format('UPDATE %I.cityobject AS t SET
 gmlid                 =%L,
 gmlid_codespace       =%L,
 name                  =%L,
 name_codespace        =%L,
 description           =%L,
 envelope              =%L,
 creation_date         =%L,
 termination_date      =%L,
 relative_to_terrain   =%L,
 relative_to_water     =%L,
 last_modification_date=%L,
 updating_person       =%L,
 reason_for_update     =%L,
 lineage               =%L
WHERE t.id=%L RETURNING id',
 p_schema_name,
 NEW.gmlid,
 NEW.gmlid_codespace,
 NEW.name,
 NEW.name_codespace,
 NEW.description,
 NEW.envelope,
 NEW.creation_date,
 NEW.termination_date,
 NEW.relative_to_terrain,
 NEW.relative_to_water,
 NEW.last_modification_date,
 NEW.updating_person,
 NEW.reason_for_update,
 NEW.lineage,
 OLD.id
) INTO updated_id;
EXECUTE format('UPDATE %I.nrg8_storage_system AS t SET
start_of_life           =%L,
life_expect_value       =%L,
life_expect_value_unit  =%L,
main_maint_interval     =%L,
main_maint_interval_unit=%L,
nrg_demand_id           =%L,
cityobject_id           =%L
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.start_of_life,
NEW.life_expect_value,
NEW.life_expect_value_unit,
NEW.main_maint_interval,
NEW.main_maint_interval_unit,
NEW.nrg_demand_id,
NEW.cityobject_id,
OLD.id
) INTO updated_id;
EXECUTE format('UPDATE %I.nrg8_thermal_storage_system AS t SET
medium         =%L,
vol            =%L,
vol_unit       =%L,
prep_temp      =%L,
prep_temp_unit =%L,
therm_loss     =%L,
therm_loss_unit=%L
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.medium,
NEW.vol,
NEW.vol_unit,
NEW.prep_temp,
NEW.prep_temp_unit,
NEW.therm_loss,
NEW.therm_loss_unit,
OLD.id
) INTO updated_id;
-- RAISE NOTICE 'Updated record with id: %',updated_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_upd_storage_system_thermal (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view STORAGE_SYSTEM_THERMAL
----------------------------------------------------------------
DROP TRIGGER IF EXISTS nrg8_tr_del_storage_system_thermal ON citydb_view.nrg8_storage_system_thermal;
CREATE TRIGGER nrg8_tr_del_storage_system_thermal
	INSTEAD OF DELETE ON citydb_view.nrg8_storage_system_thermal
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_del_storage_system_thermal ('citydb');

DROP TRIGGER IF EXISTS nrg8_tr_ins_storage_system_thermal ON citydb_view.nrg8_storage_system_thermal;
CREATE TRIGGER nrg8_tr_ins_storage_system_thermal
	INSTEAD OF INSERT ON citydb_view.nrg8_storage_system_thermal
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_ins_storage_system_thermal ('citydb');

DROP TRIGGER IF EXISTS nrg8_tr_upd_storage_system_thermal ON citydb_view.nrg8_storage_system_thermal;
CREATE TRIGGER nrg8_tr_upd_storage_system_thermal
	INSTEAD OF UPDATE ON citydb_view.nrg8_storage_system_thermal
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_upd_storage_system_thermal ('citydb');
--**************************************************************
--**************************************************************

----------------------------------------------------------------
-- Function TR_DEL_THERMAL_BOUNDARY
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_del_thermal_boundary() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_del_thermal_boundary()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
deleted_id=citydb_pkg.nrg8_delete_thermal_boundary(OLD.id, p_schema_name);
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_del_thermal_boundary (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_THERMAL_BOUNDARY
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_ins_thermal_boundary() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_ins_thermal_boundary()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	inserted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
inserted_id=citydb_view.nrg8_insert_thermal_boundary(
id                    :=NEW.id,
gmlid                 :=NEW.gmlid,
gmlid_codespace       :=NEW.gmlid_codespace,
name                  :=NEW.name,
name_codespace        :=NEW.name_codespace,
description           :=NEW.description,
envelope              :=NEW.envelope,
creation_date         :=NEW.creation_date,
termination_date      :=NEW.termination_date,
relative_to_terrain   :=NEW.relative_to_terrain,
relative_to_water     :=NEW.relative_to_water,
last_modification_date:=NEW.last_modification_date,
updating_person       :=NEW.updating_person,
reason_for_update     :=NEW.reason_for_update,
lineage               :=NEW.lineage,

type            :=NEW.type,
azimuth         :=NEW.azimuth,
azimuth_unit    :=NEW.azimuth_unit,
inclination     :=NEW.inclination,
inclination_unit:=NEW.inclination_unit,
area            :=NEW.area,
area_unit       :=NEW.area_unit,
therm_zone1_id  :=NEW.therm_zone1_id,
therm_zone2_id  :=NEW.therm_zone2_id,
multi_surf_id   :=NEW.multi_surf_id,
multi_surf_geom :=NEW.multi_surf_geom,
schema_name       :=p_schema_name
);
--RAISE NOTICE 'Inserted record with id: %', inserted_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_ins_thermal_boundary (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_THERMAL_BOUNDARY
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_upd_thermal_boundary() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_upd_thermal_boundary()
  RETURNS trigger AS
$BODY$
DECLARE
  p_schema_name varchar DEFAULT 'citydb'::varchar;
  updated_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
EXECUTE format('UPDATE %I.cityobject AS t SET
 gmlid                 =%L,
 gmlid_codespace       =%L,
 name                  =%L,
 name_codespace        =%L,
 description           =%L,
 envelope              =%L,
 creation_date         =%L,
 termination_date      =%L,
 relative_to_terrain   =%L,
 relative_to_water     =%L,
 last_modification_date=%L,
 updating_person       =%L,
 reason_for_update     =%L,
 lineage               =%L
WHERE t.id=%L RETURNING id',
 p_schema_name,
 NEW.gmlid,
 NEW.gmlid_codespace,
 NEW.name,
 NEW.name_codespace,
 NEW.description,
 NEW.envelope,
 NEW.creation_date,
 NEW.termination_date,
 NEW.relative_to_terrain,
 NEW.relative_to_water,
 NEW.last_modification_date,
 NEW.updating_person,
 NEW.reason_for_update,
 NEW.lineage,
 OLD.id
) INTO updated_id;
EXECUTE format('UPDATE %I.nrg8_thermal_boundary AS t SET
type            =%L,
azimuth         =%L,
azimuth_unit    =%L,
inclination     =%L,
inclination_unit=%L,
area            =%L,
area_unit       =%L,
therm_zone1_id  =%L,
therm_zone2_id  =%L,
multi_surf_id   =%L,
multi_surf_geom =%L
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.type,
NEW.azimuth,
NEW.azimuth_unit,
NEW.inclination,
NEW.inclination_unit,
NEW.area,
NEW.area_unit,
NEW.therm_zone1_id,
NEW.therm_zone2_id,
NEW.multi_surf_id,
NEW.multi_surf_geom,
OLD.id
) INTO updated_id;
-- RAISE NOTICE 'Updated record with id: %',updated_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_upd_thermal_boundary (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view THERMAL_BOUNDARY
----------------------------------------------------------------
DROP TRIGGER IF EXISTS nrg8_tr_del_thermal_boundary ON citydb_view.nrg8_thermal_boundary;
CREATE TRIGGER nrg8_tr_del_thermal_boundary
	INSTEAD OF DELETE ON citydb_view.nrg8_thermal_boundary
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_del_thermal_boundary ('citydb');

DROP TRIGGER IF EXISTS nrg8_tr_ins_thermal_boundary ON citydb_view.nrg8_thermal_boundary;
CREATE TRIGGER nrg8_tr_ins_thermal_boundary
	INSTEAD OF INSERT ON citydb_view.nrg8_thermal_boundary
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_ins_thermal_boundary ('citydb');

DROP TRIGGER IF EXISTS nrg8_tr_upd_thermal_boundary ON citydb_view.nrg8_thermal_boundary;
CREATE TRIGGER nrg8_tr_upd_thermal_boundary
	INSTEAD OF UPDATE ON citydb_view.nrg8_thermal_boundary
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_upd_thermal_boundary ('citydb');
--**************************************************************
--**************************************************************

----------------------------------------------------------------
-- Function TR_DEL_THERMAL_ZONE
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_del_thermal_zone() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_del_thermal_zone()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
deleted_id=citydb_pkg.nrg8_delete_thermal_zone(OLD.id, p_schema_name);
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_del_thermal_zone (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_THERMAL_ZONE
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_ins_thermal_zone() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_ins_thermal_zone()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	inserted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
inserted_id=citydb_view.nrg8_insert_thermal_zone(
id                    :=NEW.id,
gmlid                 :=NEW.gmlid,
gmlid_codespace       :=NEW.gmlid_codespace,
name                  :=NEW.name,
name_codespace        :=NEW.name_codespace,
description           :=NEW.description,
envelope              :=NEW.envelope,
creation_date         :=NEW.creation_date,
termination_date      :=NEW.termination_date,
relative_to_terrain   :=NEW.relative_to_terrain,
relative_to_water     :=NEW.relative_to_water,
last_modification_date:=NEW.last_modification_date,
updating_person       :=NEW.updating_person,
reason_for_update     :=NEW.reason_for_update,
lineage               :=NEW.lineage,

add_therm_bridge_uvalue     :=NEW.add_therm_bridge_uvalue,
add_therm_bridge_uvalue_unit:=NEW.add_therm_bridge_uvalue_unit,
eff_therm_capacity          :=NEW.eff_therm_capacity,
eff_therm_capacity_unit     :=NEW.eff_therm_capacity_unit,
ind_heated_area_ratio       :=NEW.ind_heated_area_ratio,
infiltr_rate                :=NEW.infiltr_rate,
infiltr_rate_unit           :=NEW.infiltr_rate_unit,
is_cooled                   :=NEW.is_cooled,
is_heated                   :=NEW.is_heated,
building_id                 :=NEW.building_id,
solid_id                    :=NEW.solid_id,
multi_surf_geom             :=NEW.multi_surf_geom,
schema_name                   :=p_schema_name
);
--RAISE NOTICE 'Inserted record with id: %', inserted_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_ins_thermal_zone (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_THERMAL_ZONE
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_upd_thermal_zone() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_upd_thermal_zone()
  RETURNS trigger AS
$BODY$
DECLARE
  p_schema_name varchar DEFAULT 'citydb'::varchar;
  updated_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
EXECUTE format('UPDATE %I.cityobject AS t SET
 gmlid                 =%L,
 gmlid_codespace       =%L,
 name                  =%L,
 name_codespace        =%L,
 description           =%L,
 envelope              =%L,
 creation_date         =%L,
 termination_date      =%L,
 relative_to_terrain   =%L,
 relative_to_water     =%L,
 last_modification_date=%L,
 updating_person       =%L,
 reason_for_update     =%L,
 lineage               =%L
WHERE t.id=%L RETURNING id',
 p_schema_name,
 NEW.gmlid,
 NEW.gmlid_codespace,
 NEW.name,
 NEW.name_codespace,
 NEW.description,
 NEW.envelope,
 NEW.creation_date,
 NEW.termination_date,
 NEW.relative_to_terrain,
 NEW.relative_to_water,
 NEW.last_modification_date,
 NEW.updating_person,
 NEW.reason_for_update,
 NEW.lineage,
 OLD.id
) INTO updated_id;
EXECUTE format('UPDATE %I.nrg8_thermal_zone AS t SET
add_therm_bridge_uvalue     =%L,
add_therm_bridge_uvalue_unit=%L,
eff_therm_capacity          =%L,
eff_therm_capacity_unit     =%L,
ind_heated_area_ratio       =%L,
infiltr_rate                =%L,
infiltr_rate_unit           =%L,
is_cooled                   =%L,
is_heated                   =%L,
building_id                 =%L,
solid_id                    =%L,
multi_surf_geom             =%L
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.add_therm_bridge_uvalue,
NEW.add_therm_bridge_uvalue_unit,
NEW.eff_therm_capacity,
NEW.eff_therm_capacity_unit,
NEW.ind_heated_area_ratio,
NEW.infiltr_rate,
NEW.infiltr_rate_unit,
NEW.is_cooled,
NEW.is_heated,
NEW.building_id,
NEW.solid_id,
NEW.multi_surf_geom,
OLD.id
) INTO updated_id;
-- RAISE NOTICE 'Updated record with id: %',updated_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_upd_thermal_zone (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view THERMAL_ZONE
----------------------------------------------------------------
DROP TRIGGER IF EXISTS nrg8_tr_del_thermal_zone ON citydb_view.nrg8_thermal_zone;
CREATE TRIGGER nrg8_tr_del_thermal_zone
	INSTEAD OF DELETE ON citydb_view.nrg8_thermal_zone
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_del_thermal_zone ('citydb');

DROP TRIGGER IF EXISTS nrg8_tr_ins_thermal_zone ON citydb_view.nrg8_thermal_zone;
CREATE TRIGGER nrg8_tr_ins_thermal_zone
	INSTEAD OF INSERT ON citydb_view.nrg8_thermal_zone
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_ins_thermal_zone ('citydb');

DROP TRIGGER IF EXISTS nrg8_tr_upd_thermal_zone ON citydb_view.nrg8_thermal_zone;
CREATE TRIGGER nrg8_tr_upd_thermal_zone
	INSTEAD OF UPDATE ON citydb_view.nrg8_thermal_zone
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_upd_thermal_zone ('citydb');
--**************************************************************
--**************************************************************

----------------------------------------------------------------
-- Function TR_DEL_THERMAL_OPENING (cityobject)
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_del_thermal_opening() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_del_thermal_opening()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
deleted_id=citydb_pkg.nrg8_delete_thermal_opening(OLD.id, p_schema_name);
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_del_thermal_opening (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_THERMAL_OPENING
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_ins_thermal_opening() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_ins_thermal_opening()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	inserted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
inserted_id=citydb_view.nrg8_insert_thermal_opening(
id                    :=NEW.id,
gmlid                 :=NEW.gmlid,
gmlid_codespace       :=NEW.gmlid_codespace,
name                  :=NEW.name,
name_codespace        :=NEW.name_codespace,
description           :=NEW.description,
envelope              :=NEW.envelope,
creation_date         :=NEW.creation_date,
termination_date      :=NEW.termination_date,
relative_to_terrain   :=NEW.relative_to_terrain,
relative_to_water     :=NEW.relative_to_water,
last_modification_date:=NEW.last_modification_date,
updating_person       :=NEW.updating_person,
reason_for_update     :=NEW.reason_for_update,
lineage               :=NEW.lineage,

area                        :=NEW.area,
area_unit                   :=NEW.area_unit,
openable_ratio              :=NEW.openable_ratio,
in_shad_name                :=NEW.in_shad_name,
in_shad_max_cover_ratio     :=NEW.in_shad_max_cover_ratio,
in_shad_transmission        :=NEW.in_shad_transmission,
in_shad_transmission_range  :=NEW.in_shad_transmission_range,
out_shad_name               :=NEW.out_shad_name,
out_shad_max_cover_ratio    :=NEW.out_shad_max_cover_ratio,
out_shad_transmittance      :=NEW.out_shad_transmittance,
out_shad_transmittance_range:=NEW.out_shad_transmittance_range,
therm_boundary_id           :=NEW.therm_boundary_id,
multi_surf_id               :=NEW.multi_surf_id,
multi_surf_geom             :=NEW.multi_surf_geom,
schema_name                   :=p_schema_name
);
--RAISE NOTICE 'Inserted record with id: %', inserted_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_ins_thermal_opening (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_THERMAL_OPENING
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_upd_thermal_opening() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_upd_thermal_opening()
  RETURNS trigger AS
$BODY$
DECLARE
  p_schema_name varchar DEFAULT 'citydb'::varchar;
  updated_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
EXECUTE format('UPDATE %I.cityobject AS t SET
 gmlid                 =%L,
 gmlid_codespace       =%L,
 name                  =%L,
 name_codespace        =%L,
 description           =%L,
 envelope              =%L,
 creation_date         =%L,
 termination_date      =%L,
 relative_to_terrain   =%L,
 relative_to_water     =%L,
 last_modification_date=%L,
 updating_person       =%L,
 reason_for_update     =%L,
 lineage               =%L
WHERE t.id=%L RETURNING id',
 p_schema_name,
 NEW.gmlid,
 NEW.gmlid_codespace,
 NEW.name,
 NEW.name_codespace,
 NEW.description,
 NEW.envelope,
 NEW.creation_date,
 NEW.termination_date,
 NEW.relative_to_terrain,
 NEW.relative_to_water,
 NEW.last_modification_date,
 NEW.updating_person,
 NEW.reason_for_update,
 NEW.lineage,
 OLD.id
) INTO updated_id;
EXECUTE format('UPDATE %I.nrg8_thermal_opening AS t SET
area                        =%L,
area_unit                   =%L,
openable_ratio              =%L,
in_shad_name                =%L,
in_shad_max_cover_ratio     =%L,
in_shad_transmission        =%L,
in_shad_transmission_range  =%L,
out_shad_name               =%L,
out_shad_max_cover_ratio    =%L,
out_shad_transmittance      =%L,
out_shad_transmittance_range=%L,
therm_boundary_id           =%L,
multi_surf_id               =%L,
multi_surf_geom             =%L
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.area,
NEW.area_unit,
NEW.openable_ratio,
NEW.in_shad_name,
NEW.in_shad_max_cover_ratio,
NEW.in_shad_transmission,
NEW.in_shad_transmission_range,
NEW.out_shad_name,
NEW.out_shad_max_cover_ratio,
NEW.out_shad_transmittance,
NEW.out_shad_transmittance_range,
NEW.therm_boundary_id,
NEW.multi_surf_id,
NEW.multi_surf_geom,
OLD.id
) INTO updated_id;
-- RAISE NOTICE 'Updated record with id: %',updated_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_upd_thermal_opening (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view THERMAL_OPENING
----------------------------------------------------------------
DROP TRIGGER IF EXISTS nrg8_tr_del_thermal_opening ON citydb_view.nrg8_thermal_opening;
CREATE TRIGGER nrg8_tr_del_thermal_opening
	INSTEAD OF DELETE ON citydb_view.nrg8_thermal_opening
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_del_thermal_opening ('citydb');

DROP TRIGGER IF EXISTS nrg8_tr_ins_thermal_opening ON citydb_view.nrg8_thermal_opening;
CREATE TRIGGER nrg8_tr_ins_thermal_opening
	INSTEAD OF INSERT ON citydb_view.nrg8_thermal_opening
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_ins_thermal_opening ('citydb');

DROP TRIGGER IF EXISTS nrg8_tr_upd_thermal_opening ON citydb_view.nrg8_thermal_opening;
CREATE TRIGGER nrg8_tr_upd_thermal_opening
	INSTEAD OF UPDATE ON citydb_view.nrg8_thermal_opening
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_upd_thermal_opening ('citydb');
--**************************************************************
--**************************************************************

----------------------------------------------------------------
-- Function TR_DEL_USAGE_ZONE
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_del_usage_zone() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_del_usage_zone()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
deleted_id=citydb_pkg.nrg8_delete_usage_zone(OLD.id, p_schema_name);
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_del_usage_zone (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_USAGE_ZONE
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_ins_usage_zone() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_ins_usage_zone()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	inserted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
inserted_id=citydb_view.nrg8_insert_usage_zone(
id                    :=NEW.id,
gmlid                 :=NEW.gmlid,
gmlid_codespace       :=NEW.gmlid_codespace,
name                  :=NEW.name,
name_codespace        :=NEW.name_codespace,
description           :=NEW.description,
envelope              :=NEW.envelope,
creation_date         :=NEW.creation_date,
termination_date      :=NEW.termination_date,
relative_to_terrain   :=NEW.relative_to_terrain,
relative_to_water     :=NEW.relative_to_water,
last_modification_date:=NEW.last_modification_date,
updating_person       :=NEW.updating_person,
reason_for_update     :=NEW.reason_for_update,
lineage               :=NEW.lineage,

type                    :=NEW.type,
type_codespace          :=NEW.type_codespace,
used_floors             :=NEW.used_floors,
int_gains_tot_value     :=NEW.int_gains_tot_value,
int_gains_tot_value_unit:=NEW.int_gains_tot_value_unit,
int_gains_conv          :=NEW.int_gains_conv,
int_gains_lat           :=NEW.int_gains_lat,
int_gains_rad           :=NEW.int_gains_rad,
heat_sched_id           :=NEW.heat_sched_id,
cool_sched_id           :=NEW.cool_sched_id,
vent_sched_id           :=NEW.vent_sched_id,
therm_zone_id           :=NEW.therm_zone_id,
building_id             :=NEW.building_id,
solid_id                :=NEW.solid_id,
multi_surf_geom         :=NEW.multi_surf_geom,
schema_name               :=p_schema_name
);
--RAISE NOTICE 'Inserted record with id: %', inserted_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_ins_usage_zone (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_USAGE_ZONE
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_upd_usage_zone() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_upd_usage_zone()
  RETURNS trigger AS
$BODY$
DECLARE
  p_schema_name varchar DEFAULT 'citydb'::varchar;
  updated_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
EXECUTE format('UPDATE %I.cityobject AS t SET
 gmlid                 =%L,
 gmlid_codespace       =%L,
 name                  =%L,
 name_codespace        =%L,
 description           =%L,
 envelope              =%L,
 creation_date         =%L,
 termination_date      =%L,
 relative_to_terrain   =%L,
 relative_to_water     =%L,
 last_modification_date=%L,
 updating_person       =%L,
 reason_for_update     =%L,
 lineage               =%L
WHERE t.id=%L RETURNING id',
 p_schema_name,
 NEW.gmlid,
 NEW.gmlid_codespace,
 NEW.name,
 NEW.name_codespace,
 NEW.description,
 NEW.envelope,
 NEW.creation_date,
 NEW.termination_date,
 NEW.relative_to_terrain,
 NEW.relative_to_water,
 NEW.last_modification_date,
 NEW.updating_person,
 NEW.reason_for_update,
 NEW.lineage,
 OLD.id
) INTO updated_id;
EXECUTE format('UPDATE %I.nrg8_usage_zone AS t SET
type                    =%L,
type_codespace          =%L,
used_floors             =%L,
int_gains_tot_value     =%L,
int_gains_tot_value_unit=%L,
int_gains_conv          =%L,
int_gains_lat           =%L,
int_gains_rad           =%L,
heat_sched_id           =%L,
cool_sched_id           =%L,
vent_sched_id           =%L,
therm_zone_id           =%L,
building_id             =%L,
solid_id                =%L,
multi_surf_geom         =%L
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.type,
NEW.type_codespace,
NEW.used_floors,
NEW.int_gains_tot_value,
NEW.int_gains_tot_value_unit,
NEW.int_gains_conv,
NEW.int_gains_lat,
NEW.int_gains_rad,
NEW.heat_sched_id,
NEW.cool_sched_id,
NEW.vent_sched_id,
NEW.therm_zone_id,
NEW.building_id,
NEW.solid_id,
NEW.multi_surf_geom,
OLD.id
) INTO updated_id;
-- RAISE NOTICE 'Updated record with id: %',updated_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_upd_usage_zone (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view USAGE_ZONE
----------------------------------------------------------------
DROP TRIGGER IF EXISTS nrg8_tr_del_usage_zone ON citydb_view.nrg8_usage_zone;
CREATE TRIGGER nrg8_tr_del_usage_zone
	INSTEAD OF DELETE ON citydb_view.nrg8_usage_zone
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_del_usage_zone ('citydb');

DROP TRIGGER IF EXISTS nrg8_tr_ins_usage_zone ON citydb_view.nrg8_usage_zone;
CREATE TRIGGER nrg8_tr_ins_usage_zone
	INSTEAD OF INSERT ON citydb_view.nrg8_usage_zone
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_ins_usage_zone ('citydb');

DROP TRIGGER IF EXISTS nrg8_tr_upd_usage_zone ON citydb_view.nrg8_usage_zone;
CREATE TRIGGER nrg8_tr_upd_usage_zone
	INSTEAD OF UPDATE ON citydb_view.nrg8_usage_zone
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_upd_usage_zone ('citydb');
--**************************************************************
--**************************************************************

----------------------------------------------------------------
-- Function TR_DEL_CONV_SYSTEM_GENERIC
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.nrg8_tr_del_conv_system_generic() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_del_conv_system_generic()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
deleted_id=citydb_pkg.nrg8_delete_conv_system(OLD.id, p_schema_name);
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_del_conv_system_generic (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_CONV_SYSTEM_GENERIC
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.nrg8_tr_ins_conv_system_generic() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_ins_conv_system_generic()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	inserted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
inserted_id=citydb_view.nrg8_insert_conv_system(
id                    :=NEW.id,
gmlid                 :=NEW.gmlid,
gmlid_codespace       :=NEW.gmlid_codespace,
name                  :=NEW.name,
name_codespace        :=NEW.name_codespace,
description           :=NEW.description,
envelope              :=NEW.envelope,
creation_date         :=NEW.creation_date,
termination_date      :=NEW.termination_date,
relative_to_terrain   :=NEW.relative_to_terrain,
relative_to_water     :=NEW.relative_to_water,
last_modification_date:=NEW.last_modification_date,
updating_person       :=NEW.updating_person,
reason_for_update     :=NEW.reason_for_update,
lineage               :=NEW.lineage,

model                   :=NEW.model,
nbr                     :=NEW.nbr,
year_of_manufacture     :=NEW.year_of_manufacture,
inst_nom_pwr            :=NEW.inst_nom_pwr,
inst_nom_pwr_unit       :=NEW.inst_nom_pwr_unit,
nom_effcy               :=NEW.nom_effcy,
effcy_indicator         :=NEW.effcy_indicator,
start_of_life           :=NEW.start_of_life,
life_expect_value       :=NEW.life_expect_value,
life_expect_value_unit  :=NEW.life_expect_value_unit,
main_maint_interval     :=NEW.main_maint_interval,
main_maint_interval_unit:=NEW.main_maint_interval_unit,
inst_in_ctyobj_id       :=NEW.inst_in_ctyobj_id,
cityobject_id           :=NEW.cityobject_id,
schema_name               :=p_schema_name
);
--RAISE NOTICE 'Inserted record with id: %', inserted_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_ins_conv_system_generic (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_CONV_SYSTEM_GENERIC
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.nrg8_tr_upd_conv_system_generic() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_upd_conv_system_generic()
  RETURNS trigger AS
$BODY$
DECLARE
  p_schema_name varchar DEFAULT 'citydb'::varchar;
  updated_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
EXECUTE format('UPDATE %I.cityobject AS t SET
 gmlid                 =%L,
 gmlid_codespace       =%L,
 name                  =%L,
 name_codespace        =%L,
 description           =%L,
 envelope              =%L,
 creation_date         =%L,
 termination_date      =%L,
 relative_to_terrain   =%L,
 relative_to_water     =%L,
 last_modification_date=%L,
 updating_person       =%L,
 reason_for_update     =%L,
 lineage               =%L
WHERE t.id=%L RETURNING id',
 p_schema_name,
 NEW.gmlid,
 NEW.gmlid_codespace,
 NEW.name,
 NEW.name_codespace,
 NEW.description,
 NEW.envelope,
 NEW.creation_date,
 NEW.termination_date,
 NEW.relative_to_terrain,
 NEW.relative_to_water,
 NEW.last_modification_date,
 NEW.updating_person,
 NEW.reason_for_update,
 NEW.lineage,
 OLD.id
) INTO updated_id;
EXECUTE format('UPDATE %I.nrg8_conv_system AS t SET
model                   =%L,
nbr                     =%L,
year_of_manufacture     =%L,
inst_nom_pwr            =%L,
inst_nom_pwr_unit       =%L,
nom_effcy               =%L,
effcy_indicator         =%L,
start_of_life           =%L,
life_expect_value       =%L,
life_expect_value_unit  =%L,
main_maint_interval     =%L,
main_maint_interval_unit=%L,
inst_in_ctyobj_id       =%L,
cityobject_id           =%L
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.model,
NEW.nbr,
NEW.year_of_manufacture,
NEW.inst_nom_pwr,
NEW.inst_nom_pwr_unit,
NEW.nom_effcy,
NEW.effcy_indicator,
NEW.start_of_life,
NEW.life_expect_value,
NEW.life_expect_value_unit,
NEW.main_maint_interval,
NEW.main_maint_interval_unit,
NEW.inst_in_ctyobj_id,
NEW.cityobject_id,
OLD.id
) INTO updated_id;
-- RAISE NOTICE 'Updated record with id: %',updated_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_upd_conv_system_generic (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view CONV_SYSTEM
----------------------------------------------------------------
DROP TRIGGER IF EXISTS nrg8_tr_del_conv_system_generic ON citydb_view.nrg8_conv_system_generic;
CREATE TRIGGER nrg8_tr_del_conv_system_generic
	INSTEAD OF DELETE ON citydb_view.nrg8_conv_system_generic
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_del_conv_system_generic ('citydb');

DROP TRIGGER IF EXISTS nrg8_tr_ins_conv_system_generic ON citydb_view.nrg8_conv_system_generic;
CREATE TRIGGER nrg8_tr_ins_conv_system_generic
	INSTEAD OF INSERT ON citydb_view.nrg8_conv_system_generic
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_ins_conv_system_generic ('citydb');

DROP TRIGGER IF EXISTS nrg8_tr_upd_conv_system_generic ON citydb_view.nrg8_conv_system_generic;
CREATE TRIGGER nrg8_tr_upd_conv_system_generic
	INSTEAD OF UPDATE ON citydb_view.nrg8_conv_system_generic
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_upd_conv_system_generic ('citydb');
--**************************************************************
--**************************************************************

----------------------------------------------------------------
-- Function TR_DEL_CONV_SYSTEM_AIR_COMPRESSOR
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_del_conv_system_air_compressor() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_del_conv_system_air_compressor()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
deleted_id=citydb_pkg.nrg8_delete_conv_system(OLD.id, p_schema_name);
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_del_conv_system_air_compressor (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_CONV_SYSTEM_AIR_COMPRESSOR
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_ins_conv_system_air_compressor() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_ins_conv_system_air_compressor()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	inserted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
inserted_id=citydb_view.nrg8_insert_air_compressor(
id                    :=NEW.id,
gmlid                 :=NEW.gmlid,
gmlid_codespace       :=NEW.gmlid_codespace,
name                  :=NEW.name,
name_codespace        :=NEW.name_codespace,
description           :=NEW.description,
envelope              :=NEW.envelope,
creation_date         :=NEW.creation_date,
termination_date      :=NEW.termination_date,
relative_to_terrain   :=NEW.relative_to_terrain,
relative_to_water     :=NEW.relative_to_water,
last_modification_date:=NEW.last_modification_date,
updating_person       :=NEW.updating_person,
reason_for_update     :=NEW.reason_for_update,
lineage               :=NEW.lineage,

model                   :=NEW.model,
nbr                     :=NEW.nbr,
year_of_manufacture     :=NEW.year_of_manufacture,
inst_nom_pwr            :=NEW.inst_nom_pwr,
inst_nom_pwr_unit       :=NEW.inst_nom_pwr_unit,
nom_effcy               :=NEW.nom_effcy,
effcy_indicator         :=NEW.effcy_indicator,
start_of_life           :=NEW.start_of_life,
life_expect_value       :=NEW.life_expect_value,
life_expect_value_unit  :=NEW.life_expect_value_unit,
main_maint_interval     :=NEW.main_maint_interval,
main_maint_interval_unit:=NEW.main_maint_interval_unit,
inst_in_ctyobj_id       :=NEW.inst_in_ctyobj_id,
cityobject_id           :=NEW.cityobject_id,

compressor_type:=NEW.compressor_type,
pressure       :=NEW.pressure,
pressure_unit  :=NEW.pressure_unit,
schema_name    :=p_schema_name
);
--RAISE NOTICE 'Inserted record with id: %', inserted_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_ins_conv_system_air_compressor (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_CONV_SYSTEM_AIR_COMPRESSOR
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_upd_conv_system_air_compressor() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_upd_conv_system_air_compressor()
  RETURNS trigger AS
$BODY$
DECLARE
  p_schema_name varchar DEFAULT 'citydb'::varchar;
  updated_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
EXECUTE format('UPDATE %I.cityobject AS t SET
 gmlid                 =%L,
 gmlid_codespace       =%L,
 name                  =%L,
 name_codespace        =%L,
 description           =%L,
 envelope              =%L,
 creation_date         =%L,
 termination_date      =%L,
 relative_to_terrain   =%L,
 relative_to_water     =%L,
 last_modification_date=%L,
 updating_person       =%L,
 reason_for_update     =%L,
 lineage               =%L
WHERE t.id=%L RETURNING id',
 p_schema_name,
 NEW.gmlid,
 NEW.gmlid_codespace,
 NEW.name,
 NEW.name_codespace,
 NEW.description,
 NEW.envelope,
 NEW.creation_date,
 NEW.termination_date,
 NEW.relative_to_terrain,
 NEW.relative_to_water,
 NEW.last_modification_date,
 NEW.updating_person,
 NEW.reason_for_update,
 NEW.lineage,
 OLD.id
) INTO updated_id;
EXECUTE format('UPDATE %I.nrg8_conv_system AS t SET
model                   =%L,
nbr                     =%L,
year_of_manufacture     =%L,
inst_nom_pwr            =%L,
inst_nom_pwr_unit       =%L,
nom_effcy               =%L,
effcy_indicator         =%L,
start_of_life           =%L,
life_expect_value       =%L,
life_expect_value_unit  =%L,
main_maint_interval     =%L,
main_maint_interval_unit=%L,
inst_in_ctyobj_id       =%L,
cityobject_id           =%L
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.model,
NEW.nbr,
NEW.year_of_manufacture,
NEW.inst_nom_pwr,
NEW.inst_nom_pwr_unit,
NEW.nom_effcy,
NEW.effcy_indicator,
NEW.start_of_life,
NEW.life_expect_value,
NEW.life_expect_value_unit,
NEW.main_maint_interval,
NEW.main_maint_interval_unit,
NEW.inst_in_ctyobj_id,
NEW.cityobject_id,
OLD.id
) INTO updated_id;
EXECUTE format('UPDATE %I.nrg8_air_compressor AS t SET
compressor_type=%L,
pressure       =%L,
pressure_unit  =%L
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.compressor_type,
NEW.pressure,
NEW.pressure_unit,
OLD.id
) INTO updated_id;
-- RAISE NOTICE 'Updated record with id: %',updated_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_upd_conv_system_air_compressor (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view CONV_SYSTEM_AIR_COMPRESSOR
----------------------------------------------------------------
DROP TRIGGER IF EXISTS nrg8_tr_del_conv_system_air_compressor ON citydb_view.nrg8_conv_system_air_compressor;
CREATE TRIGGER nrg8_tr_del_conv_system_air_compressor
	INSTEAD OF DELETE ON citydb_view.nrg8_conv_system_air_compressor
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_del_conv_system_air_compressor ('citydb');

DROP TRIGGER IF EXISTS nrg8_tr_ins_conv_system_air_compressor ON citydb_view.nrg8_conv_system_air_compressor;
CREATE TRIGGER nrg8_tr_ins_conv_system_air_compressor
	INSTEAD OF INSERT ON citydb_view.nrg8_conv_system_air_compressor
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_ins_conv_system_air_compressor ('citydb');

DROP TRIGGER IF EXISTS nrg8_tr_upd_conv_system_air_compressor ON citydb_view.nrg8_conv_system_air_compressor;
CREATE TRIGGER nrg8_tr_upd_conv_system_air_compressor
	INSTEAD OF UPDATE ON citydb_view.nrg8_conv_system_air_compressor
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_upd_conv_system_air_compressor ('citydb');
--**************************************************************
--**************************************************************

----------------------------------------------------------------
-- Function TR_DEL_CONV_SYSTEM_BOILER
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_del_conv_system_boiler() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_del_conv_system_boiler()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
deleted_id=citydb_pkg.nrg8_delete_conv_system(OLD.id, p_schema_name);
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_del_conv_system_boiler (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_CONV_SYSTEM_BOILER
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_ins_conv_system_boiler() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_ins_conv_system_boiler()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	inserted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
inserted_id=citydb_view.nrg8_insert_boiler(
id                    :=NEW.id,
gmlid                 :=NEW.gmlid,
gmlid_codespace       :=NEW.gmlid_codespace,
name                  :=NEW.name,
name_codespace        :=NEW.name_codespace,
description           :=NEW.description,
envelope              :=NEW.envelope,
creation_date         :=NEW.creation_date,
termination_date      :=NEW.termination_date,
relative_to_terrain   :=NEW.relative_to_terrain,
relative_to_water     :=NEW.relative_to_water,
last_modification_date:=NEW.last_modification_date,
updating_person       :=NEW.updating_person,
reason_for_update     :=NEW.reason_for_update,
lineage               :=NEW.lineage,

model                   :=NEW.model,
nbr                     :=NEW.nbr,
year_of_manufacture     :=NEW.year_of_manufacture,
inst_nom_pwr            :=NEW.inst_nom_pwr,
inst_nom_pwr_unit       :=NEW.inst_nom_pwr_unit,
nom_effcy               :=NEW.nom_effcy,
effcy_indicator         :=NEW.effcy_indicator,
start_of_life           :=NEW.start_of_life,
life_expect_value       :=NEW.life_expect_value,
life_expect_value_unit  :=NEW.life_expect_value_unit,
main_maint_interval     :=NEW.main_maint_interval,
main_maint_interval_unit:=NEW.main_maint_interval_unit,
inst_in_ctyobj_id       :=NEW.inst_in_ctyobj_id,
cityobject_id           :=NEW.cityobject_id,

condensation  :=NEW.condensation,
schema_name     :=p_schema_name
);
--RAISE NOTICE 'Inserted record with id: %', inserted_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_ins_conv_system_boiler (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_CONV_SYSTEM_BOILER
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_upd_conv_system_boiler() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_upd_conv_system_boiler()
  RETURNS trigger AS
$BODY$
DECLARE
  p_schema_name varchar DEFAULT 'citydb'::varchar;
  updated_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
EXECUTE format('UPDATE %I.cityobject AS t SET
 gmlid                 =%L,
 gmlid_codespace       =%L,
 name                  =%L,
 name_codespace        =%L,
 description           =%L,
 envelope              =%L,
 creation_date         =%L,
 termination_date      =%L,
 relative_to_terrain   =%L,
 relative_to_water     =%L,
 last_modification_date=%L,
 updating_person       =%L,
 reason_for_update     =%L,
 lineage               =%L
WHERE t.id=%L RETURNING id',
 p_schema_name,
 NEW.gmlid,
 NEW.gmlid_codespace,
 NEW.name,
 NEW.name_codespace,
 NEW.description,
 NEW.envelope,
 NEW.creation_date,
 NEW.termination_date,
 NEW.relative_to_terrain,
 NEW.relative_to_water,
 NEW.last_modification_date,
 NEW.updating_person,
 NEW.reason_for_update,
 NEW.lineage,
 OLD.id
) INTO updated_id;
EXECUTE format('UPDATE %I.nrg8_conv_system AS t SET
model                   =%L,
nbr                     =%L,
year_of_manufacture     =%L,
inst_nom_pwr            =%L,
inst_nom_pwr_unit       =%L,
nom_effcy               =%L,
effcy_indicator         =%L,
start_of_life           =%L,
life_expect_value       =%L,
life_expect_value_unit  =%L,
main_maint_interval     =%L,
main_maint_interval_unit=%L,
inst_in_ctyobj_id       =%L,
cityobject_id           =%L
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.model,
NEW.nbr,
NEW.year_of_manufacture,
NEW.inst_nom_pwr,
NEW.inst_nom_pwr_unit,
NEW.nom_effcy,
NEW.effcy_indicator,
NEW.start_of_life,
NEW.life_expect_value,
NEW.life_expect_value_unit,
NEW.main_maint_interval,
NEW.main_maint_interval_unit,
NEW.inst_in_ctyobj_id,
NEW.cityobject_id,
OLD.id
) INTO updated_id;
EXECUTE format('UPDATE %I.nrg8_boiler AS t SET
condensation=%L
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.condensation,
OLD.id
) INTO updated_id;
-- RAISE NOTICE 'Updated record with id: %',updated_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_upd_conv_system_boiler (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view CONV_SYSTEM_BOILER
----------------------------------------------------------------
DROP TRIGGER IF EXISTS nrg8_tr_del_conv_system_boiler ON citydb_view.nrg8_conv_system_boiler;
CREATE TRIGGER nrg8_tr_del_conv_system_boiler
	INSTEAD OF DELETE ON citydb_view.nrg8_conv_system_boiler
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_del_conv_system_boiler ('citydb');

DROP TRIGGER IF EXISTS nrg8_tr_ins_conv_system_boiler ON citydb_view.nrg8_conv_system_boiler;
CREATE TRIGGER nrg8_tr_ins_conv_system_boiler
	INSTEAD OF INSERT ON citydb_view.nrg8_conv_system_boiler
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_ins_conv_system_boiler ('citydb');

DROP TRIGGER IF EXISTS nrg8_tr_upd_conv_system_boiler ON citydb_view.nrg8_conv_system_boiler;
CREATE TRIGGER nrg8_tr_upd_conv_system_boiler
	INSTEAD OF UPDATE ON citydb_view.nrg8_conv_system_boiler
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_upd_conv_system_boiler ('citydb');
--**************************************************************
--**************************************************************

----------------------------------------------------------------
-- Function TR_DEL_CONV_SYSTEM_CHILLER
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_del_conv_system_chiller() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_del_conv_system_chiller()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
deleted_id=citydb_pkg.nrg8_delete_conv_system(OLD.id, p_schema_name);
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_del_conv_system_chiller (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_CONV_SYSTEM_CHILLER
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_ins_conv_system_chiller() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_ins_conv_system_chiller()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	inserted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
inserted_id=citydb_view.nrg8_insert_chiller(
id                    :=NEW.id,
gmlid                 :=NEW.gmlid,
gmlid_codespace       :=NEW.gmlid_codespace,
name                  :=NEW.name,
name_codespace        :=NEW.name_codespace,
description           :=NEW.description,
envelope              :=NEW.envelope,
creation_date         :=NEW.creation_date,
termination_date      :=NEW.termination_date,
relative_to_terrain   :=NEW.relative_to_terrain,
relative_to_water     :=NEW.relative_to_water,
last_modification_date:=NEW.last_modification_date,
updating_person       :=NEW.updating_person,
reason_for_update     :=NEW.reason_for_update,
lineage               :=NEW.lineage,

model                   :=NEW.model,
nbr                     :=NEW.nbr,
year_of_manufacture     :=NEW.year_of_manufacture,
inst_nom_pwr            :=NEW.inst_nom_pwr,
inst_nom_pwr_unit       :=NEW.inst_nom_pwr_unit,
nom_effcy               :=NEW.nom_effcy,
effcy_indicator         :=NEW.effcy_indicator,
start_of_life           :=NEW.start_of_life,
life_expect_value       :=NEW.life_expect_value,
life_expect_value_unit  :=NEW.life_expect_value_unit,
main_maint_interval     :=NEW.main_maint_interval,
main_maint_interval_unit:=NEW.main_maint_interval_unit,
inst_in_ctyobj_id       :=NEW.inst_in_ctyobj_id,
cityobject_id           :=NEW.cityobject_id,

condensation_type       :=NEW.condensation_type,
compressor_type         :=NEW.compressor_type,
refrigerant             :=NEW.refrigerant,
schema_name               :=p_schema_name
);
--RAISE NOTICE 'Inserted record with id: %', inserted_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_ins_conv_system_chiller (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_CONV_SYSTEM_CHILLER
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_upd_conv_system_chiller() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_upd_conv_system_chiller()
  RETURNS trigger AS
$BODY$
DECLARE
  p_schema_name varchar DEFAULT 'citydb'::varchar;
  updated_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
EXECUTE format('UPDATE %I.cityobject AS t SET
 gmlid                 =%L,
 gmlid_codespace       =%L,
 name                  =%L,
 name_codespace        =%L,
 description           =%L,
 envelope              =%L,
 creation_date         =%L,
 termination_date      =%L,
 relative_to_terrain   =%L,
 relative_to_water     =%L,
 last_modification_date=%L,
 updating_person       =%L,
 reason_for_update     =%L,
 lineage               =%L
WHERE t.id=%L RETURNING id',
 p_schema_name,
 NEW.gmlid,
 NEW.gmlid_codespace,
 NEW.name,
 NEW.name_codespace,
 NEW.description,
 NEW.envelope,
 NEW.creation_date,
 NEW.termination_date,
 NEW.relative_to_terrain,
 NEW.relative_to_water,
 NEW.last_modification_date,
 NEW.updating_person,
 NEW.reason_for_update,
 NEW.lineage,
 OLD.id
) INTO updated_id;
EXECUTE format('UPDATE %I.nrg8_conv_system AS t SET
model                   =%L,
nbr                     =%L,
year_of_manufacture     =%L,
inst_nom_pwr            =%L,
inst_nom_pwr_unit       =%L,
nom_effcy               =%L,
effcy_indicator         =%L,
start_of_life           =%L,
life_expect_value       =%L,
life_expect_value_unit  =%L,
main_maint_interval     =%L,
main_maint_interval_unit=%L,
inst_in_ctyobj_id       =%L,
cityobject_id           =%L
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.model,
NEW.nbr,
NEW.year_of_manufacture,
NEW.inst_nom_pwr,
NEW.inst_nom_pwr_unit,
NEW.nom_effcy,
NEW.effcy_indicator,
NEW.start_of_life,
NEW.life_expect_value,
NEW.life_expect_value_unit,
NEW.main_maint_interval,
NEW.main_maint_interval_unit,
NEW.inst_in_ctyobj_id,
NEW.cityobject_id,
OLD.id
) INTO updated_id;
EXECUTE format('UPDATE %I.nrg8_chiller AS t SET
condensation_type=%L,
compressor_type  =%L,
refrigerant      =%L
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.condensation_type,
NEW.compressor_type,
NEW.refrigerant,
OLD.id
) INTO updated_id;
-- RAISE NOTICE 'Updated record with id: %',updated_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_upd_conv_system_chiller (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view CONV_SYSTEM_CHILLER
----------------------------------------------------------------
DROP TRIGGER IF EXISTS nrg8_tr_del_conv_system_chiller ON citydb_view.nrg8_conv_system_chiller;
CREATE TRIGGER nrg8_tr_del_conv_system_chiller
	INSTEAD OF DELETE ON citydb_view.nrg8_conv_system_chiller
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_del_conv_system_chiller ('citydb');

DROP TRIGGER IF EXISTS nrg8_tr_ins_conv_system_chiller ON citydb_view.nrg8_conv_system_chiller;
CREATE TRIGGER nrg8_tr_ins_conv_system_chiller
	INSTEAD OF INSERT ON citydb_view.nrg8_conv_system_chiller
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_ins_conv_system_chiller ('citydb');

DROP TRIGGER IF EXISTS nrg8_tr_upd_conv_system_chiller ON citydb_view.nrg8_conv_system_chiller;
CREATE TRIGGER nrg8_tr_upd_conv_system_chiller
	INSTEAD OF UPDATE ON citydb_view.nrg8_conv_system_chiller
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_upd_conv_system_chiller ('citydb');
--**************************************************************
--**************************************************************

----------------------------------------------------------------
-- Function TR_DEL_CONV_SYSTEM_COMBINED_HEAT_POWER
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_del_conv_system_combined_heat_power() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_del_conv_system_combined_heat_power()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
deleted_id=citydb_pkg.nrg8_delete_conv_system(OLD.id, p_schema_name);
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_del_conv_system_combined_heat_power (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_CONV_SYSTEM_COMBINED_HEAT_POWER
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_ins_conv_system_combined_heat_power() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_ins_conv_system_combined_heat_power()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	inserted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
inserted_id=citydb_view.nrg8_insert_combined_heat_power(
id                    :=NEW.id,
gmlid                 :=NEW.gmlid,
gmlid_codespace       :=NEW.gmlid_codespace,
name                  :=NEW.name,
name_codespace        :=NEW.name_codespace,
description           :=NEW.description,
envelope              :=NEW.envelope,
creation_date         :=NEW.creation_date,
termination_date      :=NEW.termination_date,
relative_to_terrain   :=NEW.relative_to_terrain,
relative_to_water     :=NEW.relative_to_water,
last_modification_date:=NEW.last_modification_date,
updating_person       :=NEW.updating_person,
reason_for_update     :=NEW.reason_for_update,
lineage               :=NEW.lineage,

model                   :=NEW.model,
nbr                     :=NEW.nbr,
year_of_manufacture     :=NEW.year_of_manufacture,
inst_nom_pwr            :=NEW.inst_nom_pwr,
inst_nom_pwr_unit       :=NEW.inst_nom_pwr_unit,
nom_effcy               :=NEW.nom_effcy,
effcy_indicator         :=NEW.effcy_indicator,
start_of_life           :=NEW.start_of_life,
life_expect_value       :=NEW.life_expect_value,
life_expect_value_unit  :=NEW.life_expect_value_unit,
main_maint_interval     :=NEW.main_maint_interval,
main_maint_interval_unit:=NEW.main_maint_interval_unit,
inst_in_ctyobj_id       :=NEW.inst_in_ctyobj_id,
cityobject_id           :=NEW.cityobject_id,

techn_type    :=NEW.techn_type,
therm_effcy   :=NEW.therm_effcy,
electr_effcy  :=NEW.electr_effcy,
schema_name     :=p_schema_name
);
--RAISE NOTICE 'Inserted record with id: %', inserted_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_ins_conv_system_combined_heat_power (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_CONV_SYSTEM_COMBINED_HEAT_POWER
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_upd_conv_system_combined_heat_power() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_upd_conv_system_combined_heat_power()
  RETURNS trigger AS
$BODY$
DECLARE
  p_schema_name varchar DEFAULT 'citydb'::varchar;
  updated_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
EXECUTE format('UPDATE %I.cityobject AS t SET
 gmlid                 =%L,
 gmlid_codespace       =%L,
 name                  =%L,
 name_codespace        =%L,
 description           =%L,
 envelope              =%L,
 creation_date         =%L,
 termination_date      =%L,
 relative_to_terrain   =%L,
 relative_to_water     =%L,
 last_modification_date=%L,
 updating_person       =%L,
 reason_for_update     =%L,
 lineage               =%L
WHERE t.id=%L RETURNING id',
 p_schema_name,
 NEW.gmlid,
 NEW.gmlid_codespace,
 NEW.name,
 NEW.name_codespace,
 NEW.description,
 NEW.envelope,
 NEW.creation_date,
 NEW.termination_date,
 NEW.relative_to_terrain,
 NEW.relative_to_water,
 NEW.last_modification_date,
 NEW.updating_person,
 NEW.reason_for_update,
 NEW.lineage,
 OLD.id
) INTO updated_id;
EXECUTE format('UPDATE %I.nrg8_conv_system AS t SET
model                   =%L,
nbr                     =%L,
year_of_manufacture     =%L,
inst_nom_pwr            =%L,
inst_nom_pwr_unit       =%L,
nom_effcy               =%L,
effcy_indicator         =%L,
start_of_life           =%L,
life_expect_value       =%L,
life_expect_value_unit  =%L,
main_maint_interval     =%L,
main_maint_interval_unit=%L,
inst_in_ctyobj_id       =%L,
cityobject_id           =%L
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.model,
NEW.nbr,
NEW.year_of_manufacture,
NEW.inst_nom_pwr,
NEW.inst_nom_pwr_unit,
NEW.nom_effcy,
NEW.effcy_indicator,
NEW.start_of_life,
NEW.life_expect_value,
NEW.life_expect_value_unit,
NEW.main_maint_interval,
NEW.main_maint_interval_unit,
NEW.inst_in_ctyobj_id,
NEW.cityobject_id,
OLD.id
) INTO updated_id;
EXECUTE format('UPDATE %I.nrg8_combined_heat_power AS t SET
techn_type  =%L,
therm_effcy =%L,
electr_effcy=%L
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.techn_type,
NEW.therm_effcy,
NEW.electr_effcy,
OLD.id
) INTO updated_id;
-- RAISE NOTICE 'Updated record with id: %',updated_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_upd_conv_system_combined_heat_power (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view CONV_SYSTEM_COMBINED_HEAT_POWER
----------------------------------------------------------------
DROP TRIGGER IF EXISTS nrg8_tr_del_conv_system_combined_heat_power ON citydb_view.nrg8_conv_system_combined_heat_power;
CREATE TRIGGER nrg8_tr_del_conv_system_combined_heat_power
	INSTEAD OF DELETE ON citydb_view.nrg8_conv_system_combined_heat_power
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_del_conv_system_combined_heat_power ('citydb');

DROP TRIGGER IF EXISTS nrg8_tr_ins_conv_system_combined_heat_power ON citydb_view.nrg8_conv_system_combined_heat_power;
CREATE TRIGGER nrg8_tr_ins_conv_system_combined_heat_power
	INSTEAD OF INSERT ON citydb_view.nrg8_conv_system_combined_heat_power
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_ins_conv_system_combined_heat_power ('citydb');

DROP TRIGGER IF EXISTS nrg8_tr_upd_conv_system_combined_heat_power ON citydb_view.nrg8_conv_system_combined_heat_power;
CREATE TRIGGER nrg8_tr_upd_conv_system_combined_heat_power
	INSTEAD OF UPDATE ON citydb_view.nrg8_conv_system_combined_heat_power
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_upd_conv_system_combined_heat_power ('citydb');
--**************************************************************
--**************************************************************

----------------------------------------------------------------
-- Function TR_DEL_CONV_SYSTEM_ELECTRICAL_RESISTANCE
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_del_conv_system_electrical_resistance() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_del_conv_system_electrical_resistance()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
deleted_id=citydb_pkg.nrg8_delete_conv_system(OLD.id, p_schema_name);
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_del_conv_system_electrical_resistance (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_CONV_SYSTEM_ELECTRICAL_RESISTANCE
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_ins_conv_system_electrical_resistance() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_ins_conv_system_electrical_resistance()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	inserted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
inserted_id=citydb_view.nrg8_insert_conv_system(
id                    :=NEW.id,
gmlid                 :=NEW.gmlid,
gmlid_codespace       :=NEW.gmlid_codespace,
name                  :=NEW.name,
name_codespace        :=NEW.name_codespace,
description           :=NEW.description,
envelope              :=NEW.envelope,
creation_date         :=NEW.creation_date,
termination_date      :=NEW.termination_date,
relative_to_terrain   :=NEW.relative_to_terrain,
relative_to_water     :=NEW.relative_to_water,
last_modification_date:=NEW.last_modification_date,
updating_person       :=NEW.updating_person,
reason_for_update     :=NEW.reason_for_update,
lineage               :=NEW.lineage,

model                   :=NEW.model,
nbr                     :=NEW.nbr,
year_of_manufacture     :=NEW.year_of_manufacture,
inst_nom_pwr            :=NEW.inst_nom_pwr,
inst_nom_pwr_unit       :=NEW.inst_nom_pwr_unit,
nom_effcy               :=NEW.nom_effcy,
effcy_indicator         :=NEW.effcy_indicator,
start_of_life           :=NEW.start_of_life,
life_expect_value       :=NEW.life_expect_value,
life_expect_value_unit  :=NEW.life_expect_value_unit,
main_maint_interval     :=NEW.main_maint_interval,
main_maint_interval_unit:=NEW.main_maint_interval_unit,
inst_in_ctyobj_id       :=NEW.inst_in_ctyobj_id,
cityobject_id           :=NEW.cityobject_id,
schema_name               :=p_schema_name
);
--RAISE NOTICE 'Inserted record with id: %', inserted_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_ins_conv_system_electrical_resistance (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_CONV_SYSTEM_ELECTRICAL_RESISTANCE
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_upd_conv_system_electrical_resistance() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_upd_conv_system_electrical_resistance()
  RETURNS trigger AS
$BODY$
DECLARE
  p_schema_name varchar DEFAULT 'citydb'::varchar;
  updated_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
EXECUTE format('UPDATE %I.cityobject AS t SET
 gmlid                 =%L,
 gmlid_codespace       =%L,
 name                  =%L,
 name_codespace        =%L,
 description           =%L,
 envelope              =%L,
 creation_date         =%L,
 termination_date      =%L,
 relative_to_terrain   =%L,
 relative_to_water     =%L,
 last_modification_date=%L,
 updating_person       =%L,
 reason_for_update     =%L,
 lineage               =%L
WHERE t.id=%L RETURNING id',
 p_schema_name,
 NEW.gmlid,
 NEW.gmlid_codespace,
 NEW.name,
 NEW.name_codespace,
 NEW.description,
 NEW.envelope,
 NEW.creation_date,
 NEW.termination_date,
 NEW.relative_to_terrain,
 NEW.relative_to_water,
 NEW.last_modification_date,
 NEW.updating_person,
 NEW.reason_for_update,
 NEW.lineage,
 OLD.id
) INTO updated_id;
EXECUTE format('UPDATE %I.nrg8_conv_system AS t SET
model                   =%L,
nbr                     =%L,
year_of_manufacture     =%L,
inst_nom_pwr            =%L,
inst_nom_pwr_unit       =%L,
nom_effcy               =%L,
effcy_indicator         =%L,
start_of_life           =%L,
life_expect_value       =%L,
life_expect_value_unit  =%L,
main_maint_interval     =%L,
main_maint_interval_unit=%L,
inst_in_ctyobj_id       =%L,
cityobject_id           =%L
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.model,
NEW.nbr,
NEW.year_of_manufacture,
NEW.inst_nom_pwr,
NEW.inst_nom_pwr_unit,
NEW.nom_effcy,
NEW.effcy_indicator,
NEW.start_of_life,
NEW.life_expect_value,
NEW.life_expect_value_unit,
NEW.main_maint_interval,
NEW.main_maint_interval_unit,
NEW.inst_in_ctyobj_id,
NEW.cityobject_id,
OLD.id
) INTO updated_id;
-- RAISE NOTICE 'Updated record with id: %',updated_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_upd_conv_system_electrical_resistance (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view CONV_SYSTEM_AIR_COMPRESSOR
----------------------------------------------------------------
DROP TRIGGER IF EXISTS nrg8_tr_del_conv_system_electrical_resistance ON citydb_view.nrg8_conv_system_electrical_resistance;
CREATE TRIGGER nrg8_tr_del_conv_system_electrical_resistance
	INSTEAD OF DELETE ON citydb_view.nrg8_conv_system_electrical_resistance
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_del_conv_system_electrical_resistance ('citydb');

DROP TRIGGER IF EXISTS nrg8_tr_ins_conv_system_electrical_resistance ON citydb_view.nrg8_conv_system_electrical_resistance;
CREATE TRIGGER nrg8_tr_ins_conv_system_electrical_resistance
	INSTEAD OF INSERT ON citydb_view.nrg8_conv_system_electrical_resistance
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_ins_conv_system_electrical_resistance ('citydb');

DROP TRIGGER IF EXISTS nrg8_tr_upd_conv_system_electrical_resistance ON citydb_view.nrg8_conv_system_electrical_resistance;
CREATE TRIGGER nrg8_tr_upd_conv_system_electrical_resistance
	INSTEAD OF UPDATE ON citydb_view.nrg8_conv_system_electrical_resistance
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_upd_conv_system_electrical_resistance ('citydb');
--**************************************************************
--**************************************************************

----------------------------------------------------------------
-- Function TR_DEL_CONV_SYSTEM_HEAT_EXCHANGER
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_del_conv_system_heat_exchanger() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_del_conv_system_heat_exchanger()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
deleted_id=citydb_pkg.nrg8_delete_conv_system(OLD.id, p_schema_name);
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_del_conv_system_heat_exchanger (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_CONV_SYSTEM_HEAT_EXCHANGER
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_ins_conv_system_heat_exchanger() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_ins_conv_system_heat_exchanger()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	inserted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
inserted_id=citydb_view.nrg8_insert_heat_exchanger(
id                    :=NEW.id,
gmlid                 :=NEW.gmlid,
gmlid_codespace       :=NEW.gmlid_codespace,
name                  :=NEW.name,
name_codespace        :=NEW.name_codespace,
description           :=NEW.description,
envelope              :=NEW.envelope,
creation_date         :=NEW.creation_date,
termination_date      :=NEW.termination_date,
relative_to_terrain   :=NEW.relative_to_terrain,
relative_to_water     :=NEW.relative_to_water,
last_modification_date:=NEW.last_modification_date,
updating_person       :=NEW.updating_person,
reason_for_update     :=NEW.reason_for_update,
lineage               :=NEW.lineage,

model                   :=NEW.model,
nbr                     :=NEW.nbr,
year_of_manufacture     :=NEW.year_of_manufacture,
inst_nom_pwr            :=NEW.inst_nom_pwr,
inst_nom_pwr_unit       :=NEW.inst_nom_pwr_unit,
nom_effcy               :=NEW.nom_effcy,
effcy_indicator         :=NEW.effcy_indicator,
start_of_life           :=NEW.start_of_life,
life_expect_value       :=NEW.life_expect_value,
life_expect_value_unit  :=NEW.life_expect_value_unit,
main_maint_interval     :=NEW.main_maint_interval,
main_maint_interval_unit:=NEW.main_maint_interval_unit,
inst_in_ctyobj_id       :=NEW.inst_in_ctyobj_id,
cityobject_id           :=NEW.cityobject_id,

network_id              :=NEW.network_id,
network_node_id         :=NEW.network_node_id,
prim_heat_supplier      :=NEW.prim_heat_supplier,
schema_name               :=p_schema_name
);
--RAISE NOTICE 'Inserted record with id: %', inserted_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_ins_conv_system_heat_exchanger (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_CONV_SYSTEM_HEAT_EXCHANGER
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_upd_conv_system_heat_exchanger() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_upd_conv_system_heat_exchanger()
  RETURNS trigger AS
$BODY$
DECLARE
  p_schema_name varchar DEFAULT 'citydb'::varchar;
  updated_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
EXECUTE format('UPDATE %I.cityobject AS t SET
 gmlid                 =%L,
 gmlid_codespace       =%L,
 name                  =%L,
 name_codespace        =%L,
 description           =%L,
 envelope              =%L,
 creation_date         =%L,
 termination_date      =%L,
 relative_to_terrain   =%L,
 relative_to_water     =%L,
 last_modification_date=%L,
 updating_person       =%L,
 reason_for_update     =%L,
 lineage               =%L
WHERE t.id=%L RETURNING id',
 p_schema_name,
 NEW.gmlid,
 NEW.gmlid_codespace,
 NEW.name,
 NEW.name_codespace,
 NEW.description,
 NEW.envelope,
 NEW.creation_date,
 NEW.termination_date,
 NEW.relative_to_terrain,
 NEW.relative_to_water,
 NEW.last_modification_date,
 NEW.updating_person,
 NEW.reason_for_update,
 NEW.lineage,
 OLD.id
) INTO updated_id;
EXECUTE format('UPDATE %I.nrg8_conv_system AS t SET
model                   =%L,
nbr                     =%L,
year_of_manufacture     =%L,
inst_nom_pwr            =%L,
inst_nom_pwr_unit       =%L,
nom_effcy               =%L,
effcy_indicator         =%L,
start_of_life           =%L,
life_expect_value       =%L,
life_expect_value_unit  =%L,
main_maint_interval     =%L,
main_maint_interval_unit=%L,
inst_in_ctyobj_id       =%L,
cityobject_id           =%L
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.model,
NEW.nbr,
NEW.year_of_manufacture,
NEW.inst_nom_pwr,
NEW.inst_nom_pwr_unit,
NEW.nom_effcy,
NEW.effcy_indicator,
NEW.start_of_life,
NEW.life_expect_value,
NEW.life_expect_value_unit,
NEW.main_maint_interval,
NEW.main_maint_interval_unit,
NEW.inst_in_ctyobj_id,
NEW.cityobject_id,
OLD.id
) INTO updated_id;
EXECUTE format('UPDATE %I.nrg8_heat_exchanger AS t SET
network_id        =%L,
network_node_id   =%L,
prim_heat_supplier=%L
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.network_id,
NEW.network_node_id,
NEW.prim_heat_supplier,
OLD.id
) INTO updated_id;
-- RAISE NOTICE 'Updated record with id: %',updated_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_upd_conv_system_heat_exchanger (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view CONV_SYSTEM_HEAT_EXCHANGER
----------------------------------------------------------------
DROP TRIGGER IF EXISTS nrg8_tr_del_conv_system_heat_exchanger ON citydb_view.nrg8_conv_system_heat_exchanger;
CREATE TRIGGER nrg8_tr_del_conv_system_heat_exchanger
	INSTEAD OF DELETE ON citydb_view.nrg8_conv_system_heat_exchanger
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_del_conv_system_heat_exchanger ('citydb');

DROP TRIGGER IF EXISTS nrg8_tr_ins_conv_system_heat_exchanger ON citydb_view.nrg8_conv_system_heat_exchanger;
CREATE TRIGGER nrg8_tr_ins_conv_system_heat_exchanger
	INSTEAD OF INSERT ON citydb_view.nrg8_conv_system_heat_exchanger
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_ins_conv_system_heat_exchanger ('citydb');

DROP TRIGGER IF EXISTS nrg8_tr_upd_conv_system_heat_exchanger ON citydb_view.nrg8_conv_system_heat_exchanger;
CREATE TRIGGER nrg8_tr_upd_conv_system_heat_exchanger
	INSTEAD OF UPDATE ON citydb_view.nrg8_conv_system_heat_exchanger
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_upd_conv_system_heat_exchanger ('citydb');
--**************************************************************
--**************************************************************

----------------------------------------------------------------
-- Function TR_DEL_CONV_SYSTEM_HEAT_PUMP
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_del_conv_system_heat_pump() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_del_conv_system_heat_pump()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
deleted_id=citydb_pkg.nrg8_delete_conv_system(OLD.id, p_schema_name);
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_del_conv_system_heat_pump (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_CONV_SYSTEM_HEAT_PUMP
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_ins_conv_system_heat_pump() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_ins_conv_system_heat_pump()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	inserted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
inserted_id=citydb_view.nrg8_insert_heat_pump(
id                    :=NEW.id,
gmlid                 :=NEW.gmlid,
gmlid_codespace       :=NEW.gmlid_codespace,
name                  :=NEW.name,
name_codespace        :=NEW.name_codespace,
description           :=NEW.description,
envelope              :=NEW.envelope,
creation_date         :=NEW.creation_date,
termination_date      :=NEW.termination_date,
relative_to_terrain   :=NEW.relative_to_terrain,
relative_to_water     :=NEW.relative_to_water,
last_modification_date:=NEW.last_modification_date,
updating_person       :=NEW.updating_person,
reason_for_update     :=NEW.reason_for_update,
lineage               :=NEW.lineage,

model                   :=NEW.model,
nbr                     :=NEW.nbr,
year_of_manufacture     :=NEW.year_of_manufacture,
inst_nom_pwr            :=NEW.inst_nom_pwr,
inst_nom_pwr_unit       :=NEW.inst_nom_pwr_unit,
nom_effcy               :=NEW.nom_effcy,
effcy_indicator         :=NEW.effcy_indicator,
start_of_life           :=NEW.start_of_life,
life_expect_value       :=NEW.life_expect_value,
life_expect_value_unit  :=NEW.life_expect_value_unit,
main_maint_interval     :=NEW.main_maint_interval,
main_maint_interval_unit:=NEW.main_maint_interval_unit,
inst_in_ctyobj_id       :=NEW.inst_in_ctyobj_id,
cityobject_id           :=NEW.cityobject_id,

heat_source             :=NEW.heat_source,
cop_source_temp         :=NEW.cop_source_temp,
cop_source_temp_unit    :=NEW.cop_source_temp_unit,
cop_oper_temp           :=NEW.cop_oper_temp,
cop_oper_temp_unit      :=NEW.cop_oper_temp_unit,
schema_name               :=p_schema_name
);
--RAISE NOTICE 'Inserted record with id: %', inserted_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_ins_conv_system_heat_pump (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_CONV_SYSTEM_HEAT_PUMP
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_upd_conv_system_heat_pump() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_upd_conv_system_heat_pump()
  RETURNS trigger AS
$BODY$
DECLARE
  p_schema_name varchar DEFAULT 'citydb'::varchar;
  updated_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
EXECUTE format('UPDATE %I.cityobject AS t SET
 gmlid                 =%L,
 gmlid_codespace       =%L,
 name                  =%L,
 name_codespace        =%L,
 description           =%L,
 envelope              =%L,
 creation_date         =%L,
 termination_date      =%L,
 relative_to_terrain   =%L,
 relative_to_water     =%L,
 last_modification_date=%L,
 updating_person       =%L,
 reason_for_update     =%L,
 lineage               =%L
WHERE t.id=%L RETURNING id',
 p_schema_name,
 NEW.gmlid,
 NEW.gmlid_codespace,
 NEW.name,
 NEW.name_codespace,
 NEW.description,
 NEW.envelope,
 NEW.creation_date,
 NEW.termination_date,
 NEW.relative_to_terrain,
 NEW.relative_to_water,
 NEW.last_modification_date,
 NEW.updating_person,
 NEW.reason_for_update,
 NEW.lineage,
 OLD.id
) INTO updated_id;
EXECUTE format('UPDATE %I.nrg8_conv_system AS t SET
model                   =%L,
nbr                     =%L,
year_of_manufacture     =%L,
inst_nom_pwr            =%L,
inst_nom_pwr_unit       =%L,
nom_effcy               =%L,
effcy_indicator         =%L,
start_of_life           =%L,
life_expect_value       =%L,
life_expect_value_unit  =%L,
main_maint_interval     =%L,
main_maint_interval_unit=%L,
inst_in_ctyobj_id       =%L,
cityobject_id           =%L
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.model,
NEW.nbr,
NEW.year_of_manufacture,
NEW.inst_nom_pwr,
NEW.inst_nom_pwr_unit,
NEW.nom_effcy,
NEW.effcy_indicator,
NEW.start_of_life,
NEW.life_expect_value,
NEW.life_expect_value_unit,
NEW.main_maint_interval,
NEW.main_maint_interval_unit,
NEW.inst_in_ctyobj_id,
NEW.cityobject_id,
OLD.id
) INTO updated_id;
EXECUTE format('UPDATE %I.nrg8_heat_pump AS t SET
heat_source         =%L,
cop_source_temp     =%L,
cop_source_temp_unit=%L,
cop_oper_temp       =%L,
cop_oper_temp_unit  =%L
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.heat_source,
NEW.cop_source_temp,
NEW.cop_source_temp_unit,
NEW.cop_oper_temp,
NEW.cop_oper_temp_unit,
OLD.id
) INTO updated_id;
-- RAISE NOTICE 'Updated record with id: %',updated_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_upd_conv_system_heat_pump (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view CONV_SYSTEM_HEAT_PUMP
----------------------------------------------------------------
DROP TRIGGER IF EXISTS nrg8_tr_del_conv_system_heat_pump ON citydb_view.nrg8_conv_system_heat_pump;
CREATE TRIGGER nrg8_tr_del_conv_system_heat_pump
	INSTEAD OF DELETE ON citydb_view.nrg8_conv_system_heat_pump
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_del_conv_system_heat_pump ('citydb');

DROP TRIGGER IF EXISTS nrg8_tr_ins_conv_system_heat_pump ON citydb_view.nrg8_conv_system_heat_pump;
CREATE TRIGGER nrg8_tr_ins_conv_system_heat_pump
	INSTEAD OF INSERT ON citydb_view.nrg8_conv_system_heat_pump
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_ins_conv_system_heat_pump ('citydb');

DROP TRIGGER IF EXISTS nrg8_tr_upd_conv_system_heat_pump ON citydb_view.nrg8_conv_system_heat_pump;
CREATE TRIGGER nrg8_tr_upd_conv_system_heat_pump
	INSTEAD OF UPDATE ON citydb_view.nrg8_conv_system_heat_pump
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_upd_conv_system_heat_pump ('citydb');
--**************************************************************
--**************************************************************

----------------------------------------------------------------
-- Function TR_DEL_CONV_SYSTEM_MECH_VENTILATION
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_del_conv_system_mech_ventilation() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_del_conv_system_mech_ventilation()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
deleted_id=citydb_pkg.nrg8_delete_conv_system(OLD.id, p_schema_name);
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_del_conv_system_mech_ventilation (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_CONV_SYSTEM_MECH_VENTILATION
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_ins_conv_system_mech_ventilation() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_ins_conv_system_mech_ventilation()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	inserted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
inserted_id=citydb_view.nrg8_insert_mech_ventilation(
id                    :=NEW.id,
gmlid                 :=NEW.gmlid,
gmlid_codespace       :=NEW.gmlid_codespace,
name                  :=NEW.name,
name_codespace        :=NEW.name_codespace,
description           :=NEW.description,
envelope              :=NEW.envelope,
creation_date         :=NEW.creation_date,
termination_date      :=NEW.termination_date,
relative_to_terrain   :=NEW.relative_to_terrain,
relative_to_water     :=NEW.relative_to_water,
last_modification_date:=NEW.last_modification_date,
updating_person       :=NEW.updating_person,
reason_for_update     :=NEW.reason_for_update,
lineage               :=NEW.lineage,

model                   :=NEW.model,
nbr                     :=NEW.nbr,
year_of_manufacture     :=NEW.year_of_manufacture,
inst_nom_pwr            :=NEW.inst_nom_pwr,
inst_nom_pwr_unit       :=NEW.inst_nom_pwr_unit,
nom_effcy               :=NEW.nom_effcy,
effcy_indicator         :=NEW.effcy_indicator,
start_of_life           :=NEW.start_of_life,
life_expect_value       :=NEW.life_expect_value,
life_expect_value_unit  :=NEW.life_expect_value_unit,
main_maint_interval     :=NEW.main_maint_interval,
main_maint_interval_unit:=NEW.main_maint_interval_unit,
inst_in_ctyobj_id       :=NEW.inst_in_ctyobj_id,
cityobject_id           :=NEW.cityobject_id,

heat_recovery           :=NEW.heat_recovery,
recuperation            :=NEW.recuperation,
schema_name               :=p_schema_name
);
--RAISE NOTICE 'Inserted record with id: %', inserted_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_ins_conv_system_mech_ventilation (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_CONV_SYSTEM_MECH_VENTILATION
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_upd_conv_system_mech_ventilation() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_upd_conv_system_mech_ventilation()
  RETURNS trigger AS
$BODY$
DECLARE
  p_schema_name varchar DEFAULT 'citydb'::varchar;
  updated_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
EXECUTE format('UPDATE %I.cityobject AS t SET
 gmlid                 =%L,
 gmlid_codespace       =%L,
 name                  =%L,
 name_codespace        =%L,
 description           =%L,
 envelope              =%L,
 creation_date         =%L,
 termination_date      =%L,
 relative_to_terrain   =%L,
 relative_to_water     =%L,
 last_modification_date=%L,
 updating_person       =%L,
 reason_for_update     =%L,
 lineage               =%L
WHERE t.id=%L RETURNING id',
 p_schema_name,
 NEW.gmlid,
 NEW.gmlid_codespace,
 NEW.name,
 NEW.name_codespace,
 NEW.description,
 NEW.envelope,
 NEW.creation_date,
 NEW.termination_date,
 NEW.relative_to_terrain,
 NEW.relative_to_water,
 NEW.last_modification_date,
 NEW.updating_person,
 NEW.reason_for_update,
 NEW.lineage,
 OLD.id
) INTO updated_id;
EXECUTE format('UPDATE %I.nrg8_conv_system AS t SET
model                   =%L,
nbr                     =%L,
year_of_manufacture     =%L,
inst_nom_pwr            =%L,
inst_nom_pwr_unit       =%L,
nom_effcy               =%L,
effcy_indicator         =%L,
start_of_life           =%L,
life_expect_value       =%L,
life_expect_value_unit  =%L,
main_maint_interval     =%L,
main_maint_interval_unit=%L,
inst_in_ctyobj_id       =%L,
cityobject_id           =%L
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.model,
NEW.nbr,
NEW.year_of_manufacture,
NEW.inst_nom_pwr,
NEW.inst_nom_pwr_unit,
NEW.nom_effcy,
NEW.effcy_indicator,
NEW.start_of_life,
NEW.life_expect_value,
NEW.life_expect_value_unit,
NEW.main_maint_interval,
NEW.main_maint_interval_unit,
NEW.inst_in_ctyobj_id,
NEW.cityobject_id,
OLD.id
) INTO updated_id;
EXECUTE format('UPDATE %I.nrg8_mech_ventilation AS t SET
heat_recovery=%L,
recuperation =%L
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.heat_recovery,
NEW.recuperation,
OLD.id
) INTO updated_id;
-- RAISE NOTICE 'Updated record with id: %',updated_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_upd_conv_system_mech_ventilation (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view CONV_SYSTEM_MECH_VENTILATION
----------------------------------------------------------------
DROP TRIGGER IF EXISTS nrg8_tr_del_conv_system_mech_ventilation ON citydb_view.nrg8_conv_system_mech_ventilation;
CREATE TRIGGER nrg8_tr_del_conv_system_mech_ventilation
	INSTEAD OF DELETE ON citydb_view.nrg8_conv_system_mech_ventilation
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_del_conv_system_mech_ventilation ('citydb');

DROP TRIGGER IF EXISTS nrg8_tr_ins_conv_system_mech_ventilation ON citydb_view.nrg8_conv_system_mech_ventilation;
CREATE TRIGGER nrg8_tr_ins_conv_system_mech_ventilation
	INSTEAD OF INSERT ON citydb_view.nrg8_conv_system_mech_ventilation
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_ins_conv_system_mech_ventilation ('citydb');

DROP TRIGGER IF EXISTS nrg8_tr_upd_conv_system_mech_ventilation ON citydb_view.nrg8_conv_system_mech_ventilation;
CREATE TRIGGER nrg8_tr_upd_conv_system_mech_ventilation
	INSTEAD OF UPDATE ON citydb_view.nrg8_conv_system_mech_ventilation
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_upd_conv_system_mech_ventilation ('citydb');
--**************************************************************
--**************************************************************

----------------------------------------------------------------
-- Function TR_DEL_CONV_SYSTEM_SOLAR_PV_THERMAL
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_del_conv_system_solar_pv_thermal() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_del_conv_system_solar_pv_thermal()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
deleted_id=citydb_pkg.nrg8_delete_conv_system(OLD.id, p_schema_name);
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_del_conv_system_solar_pv_thermal (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_CONV_SYSTEM_SOLAR_PV_THERMAL
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_ins_conv_system_solar_pv_thermal() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_ins_conv_system_solar_pv_thermal()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	inserted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
inserted_id=citydb_view.nrg8_insert_photovoltaic_thermal_system(
id                    :=NEW.id,
gmlid                 :=NEW.gmlid,
gmlid_codespace       :=NEW.gmlid_codespace,
name                  :=NEW.name,
name_codespace        :=NEW.name_codespace,
description           :=NEW.description,
envelope              :=NEW.envelope,
creation_date         :=NEW.creation_date,
termination_date      :=NEW.termination_date,
relative_to_terrain   :=NEW.relative_to_terrain,
relative_to_water     :=NEW.relative_to_water,
last_modification_date:=NEW.last_modification_date,
updating_person       :=NEW.updating_person,
reason_for_update     :=NEW.reason_for_update,
lineage               :=NEW.lineage,

model                   :=NEW.model,
nbr                     :=NEW.nbr,
year_of_manufacture     :=NEW.year_of_manufacture,
inst_nom_pwr            :=NEW.inst_nom_pwr,
inst_nom_pwr_unit       :=NEW.inst_nom_pwr_unit,
nom_effcy               :=NEW.nom_effcy,
effcy_indicator         :=NEW.effcy_indicator,
start_of_life           :=NEW.start_of_life,
life_expect_value       :=NEW.life_expect_value,
life_expect_value_unit  :=NEW.life_expect_value_unit,
main_maint_interval     :=NEW.main_maint_interval,
main_maint_interval_unit:=NEW.main_maint_interval_unit,
inst_in_ctyobj_id       :=NEW.inst_in_ctyobj_id,
cityobject_id           :=NEW.cityobject_id,

collector_type          :=NEW.collector_type,
cell_type               :=NEW.cell_type,
module_area             :=NEW.module_area,
module_area_unit        :=NEW.module_area_unit,
aperture_area           :=NEW.aperture_area,
aperture_area_unit      :=NEW.aperture_area_unit,
eta0                    :=NEW.eta0,
a1                      :=NEW.a1,
a2                      :=NEW.a2,
them_surf_id            :=NEW.them_surf_id,
building_inst_id        :=NEW.building_inst_id,
multi_surf_id           :=NEW.multi_surf_id,
multi_surf_geom         :=NEW.multi_surf_geom,
schema_name             :=p_schema_name
);
--RAISE NOTICE 'Inserted record with id: %', inserted_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_ins_conv_system_solar_pv_thermal (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_CONV_SYSTEM_PV_THERMAL
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_upd_conv_system_solar_pv_thermal() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_upd_conv_system_solar_pv_thermal()
  RETURNS trigger AS
$BODY$
DECLARE
  p_schema_name varchar DEFAULT 'citydb'::varchar;
  updated_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
EXECUTE format('UPDATE %I.cityobject AS t SET
 gmlid                 =%L,
 gmlid_codespace       =%L,
 name                  =%L,
 name_codespace        =%L,
 description           =%L,
 envelope              =%L,
 creation_date         =%L,
 termination_date      =%L,
 relative_to_terrain   =%L,
 relative_to_water     =%L,
 last_modification_date=%L,
 updating_person       =%L,
 reason_for_update     =%L,
 lineage               =%L
WHERE t.id=%L RETURNING id',
 p_schema_name,
 NEW.gmlid,
 NEW.gmlid_codespace,
 NEW.name,
 NEW.name_codespace,
 NEW.description,
 NEW.envelope,
 NEW.creation_date,
 NEW.termination_date,
 NEW.relative_to_terrain,
 NEW.relative_to_water,
 NEW.last_modification_date,
 NEW.updating_person,
 NEW.reason_for_update,
 NEW.lineage,
 OLD.id
) INTO updated_id;
EXECUTE format('UPDATE %I.nrg8_conv_system AS t SET
model                   =%L,
nbr                     =%L,
year_of_manufacture     =%L,
inst_nom_pwr            =%L,
inst_nom_pwr_unit       =%L,
nom_effcy               =%L,
effcy_indicator         =%L,
start_of_life           =%L,
life_expect_value       =%L,
life_expect_value_unit  =%L,
main_maint_interval     =%L,
main_maint_interval_unit=%L,
inst_in_ctyobj_id       =%L,
cityobject_id           =%L
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.model,
NEW.nbr,
NEW.year_of_manufacture,
NEW.inst_nom_pwr,
NEW.inst_nom_pwr_unit,
NEW.nom_effcy,
NEW.effcy_indicator,
NEW.start_of_life,
NEW.life_expect_value,
NEW.life_expect_value_unit,
NEW.main_maint_interval,
NEW.main_maint_interval_unit,
NEW.inst_in_ctyobj_id,
NEW.cityobject_id,
OLD.id
) INTO updated_id;
EXECUTE format('UPDATE %I.nrg8_solar_system AS t SET
collector_type    =%L,
cell_type         =%L,
module_area       =%L,
module_area_unit  =%L,
aperture_area     =%L,
aperture_area_unit=%L,
eta0              =%L,
a1                =%L,
a2                =%L,
them_surf_id      =%L,
building_inst_id  =%L,
multi_surf_id     =%L,
multi_surf_geom   =%L
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.collector_type,
NEW.cell_type,
NEW.module_area,
NEW.module_area_unit,
NEW.aperture_area,
NEW.aperture_area_unit,
NEW.eta0,
NEW.a1,
NEW.a2,
NEW.them_surf_id,
NEW.building_inst_id,
NEW.multi_surf_id,
NEW.multi_surf_geom,
OLD.id
) INTO updated_id;
-- RAISE NOTICE 'Updated record with id: %',updated_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_upd_conv_system_solar_pv_thermal (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view CONV_SYSTEM_PV_THERMAL
----------------------------------------------------------------
DROP TRIGGER IF EXISTS nrg8_tr_del_conv_system_solar_pv_thermal ON citydb_view.nrg8_conv_system_solar_pv_thermal;
CREATE TRIGGER nrg8_tr_del_conv_system_solar_pv_thermal
	INSTEAD OF DELETE ON citydb_view.nrg8_conv_system_solar_pv_thermal
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_del_conv_system_solar_pv_thermal ('citydb');

DROP TRIGGER IF EXISTS nrg8_tr_ins_conv_system_solar_pv_thermal ON citydb_view.nrg8_conv_system_solar_pv_thermal;
CREATE TRIGGER nrg8_tr_ins_conv_system_solar_pv_thermal
	INSTEAD OF INSERT ON citydb_view.nrg8_conv_system_solar_pv_thermal
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_ins_conv_system_solar_pv_thermal ('citydb');

DROP TRIGGER IF EXISTS nrg8_tr_upd_conv_system_solar_pv_thermal ON citydb_view.nrg8_conv_system_solar_pv_thermal;
CREATE TRIGGER nrg8_tr_upd_conv_system_solar_pv_thermal
	INSTEAD OF UPDATE ON citydb_view.nrg8_conv_system_solar_pv_thermal
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_upd_conv_system_solar_pv_thermal ('citydb');
--**************************************************************
--**************************************************************

----------------------------------------------------------------
-- Function TR_DEL_CONV_SYSTEM_SOLAR_PV
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_del_conv_system_solar_pv() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_del_conv_system_solar_pv()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
deleted_id=citydb_pkg.nrg8_delete_conv_system(OLD.id, p_schema_name);
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_del_conv_system_solar_pv (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_CONV_SYSTEM_SOLAR_PV
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_ins_conv_system_solar_pv() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_ins_conv_system_solar_pv()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	inserted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
inserted_id=citydb_view.nrg8_insert_photovoltaic_system(
id                    :=NEW.id,
gmlid                 :=NEW.gmlid,
gmlid_codespace       :=NEW.gmlid_codespace,
name                  :=NEW.name,
name_codespace        :=NEW.name_codespace,
description           :=NEW.description,
envelope              :=NEW.envelope,
creation_date         :=NEW.creation_date,
termination_date      :=NEW.termination_date,
relative_to_terrain   :=NEW.relative_to_terrain,
relative_to_water     :=NEW.relative_to_water,
last_modification_date:=NEW.last_modification_date,
updating_person       :=NEW.updating_person,
reason_for_update     :=NEW.reason_for_update,
lineage               :=NEW.lineage,

model                   :=NEW.model,
nbr                     :=NEW.nbr,
year_of_manufacture     :=NEW.year_of_manufacture,
inst_nom_pwr            :=NEW.inst_nom_pwr,
inst_nom_pwr_unit       :=NEW.inst_nom_pwr_unit,
nom_effcy               :=NEW.nom_effcy,
effcy_indicator         :=NEW.effcy_indicator,
start_of_life           :=NEW.start_of_life,
life_expect_value       :=NEW.life_expect_value,
life_expect_value_unit  :=NEW.life_expect_value_unit,
main_maint_interval     :=NEW.main_maint_interval,
main_maint_interval_unit:=NEW.main_maint_interval_unit,
inst_in_ctyobj_id       :=NEW.inst_in_ctyobj_id,
cityobject_id           :=NEW.cityobject_id,

cell_type               :=NEW.cell_type,
module_area             :=NEW.module_area,
module_area_unit        :=NEW.module_area_unit,

them_surf_id            :=NEW.them_surf_id,
building_inst_id        :=NEW.building_inst_id,
multi_surf_id           :=NEW.multi_surf_id,
multi_surf_geom         :=NEW.multi_surf_geom,
schema_name               :=p_schema_name
);
--RAISE NOTICE 'Inserted record with id: %', inserted_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_ins_conv_system_solar_pv (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_CONV_SYSTEM_SOLAR_PV
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_upd_conv_system_solar_pv() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_upd_conv_system_solar_pv()
  RETURNS trigger AS
$BODY$
DECLARE
  p_schema_name varchar DEFAULT 'citydb'::varchar;
  updated_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
EXECUTE format('UPDATE %I.cityobject AS t SET
 gmlid                 =%L,
 gmlid_codespace       =%L,
 name                  =%L,
 name_codespace        =%L,
 description           =%L,
 envelope              =%L,
 creation_date         =%L,
 termination_date      =%L,
 relative_to_terrain   =%L,
 relative_to_water     =%L,
 last_modification_date=%L,
 updating_person       =%L,
 reason_for_update     =%L,
 lineage               =%L
WHERE t.id=%L RETURNING id',
 p_schema_name,
 NEW.gmlid,
 NEW.gmlid_codespace,
 NEW.name,
 NEW.name_codespace,
 NEW.description,
 NEW.envelope,
 NEW.creation_date,
 NEW.termination_date,
 NEW.relative_to_terrain,
 NEW.relative_to_water,
 NEW.last_modification_date,
 NEW.updating_person,
 NEW.reason_for_update,
 NEW.lineage,
 OLD.id
) INTO updated_id;
EXECUTE format('UPDATE %I.nrg8_conv_system AS t SET
model                   =%L,
nbr                     =%L,
year_of_manufacture     =%L,
inst_nom_pwr            =%L,
inst_nom_pwr_unit       =%L,
nom_effcy               =%L,
effcy_indicator         =%L,
start_of_life           =%L,
life_expect_value       =%L,
life_expect_value_unit  =%L,
main_maint_interval     =%L,
main_maint_interval_unit=%L,
inst_in_ctyobj_id       =%L,
cityobject_id           =%L
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.model,
NEW.nbr,
NEW.year_of_manufacture,
NEW.inst_nom_pwr,
NEW.inst_nom_pwr_unit,
NEW.nom_effcy,
NEW.effcy_indicator,
NEW.start_of_life,
NEW.life_expect_value,
NEW.life_expect_value_unit,
NEW.main_maint_interval,
NEW.main_maint_interval_unit,
NEW.inst_in_ctyobj_id,
NEW.cityobject_id,
OLD.id
) INTO updated_id;
EXECUTE format('UPDATE %I.nrg8_solar_system AS t SET
cell_type         =%L,
module_area       =%L,
module_area_unit  =%L,
them_surf_id      =%L,
building_inst_id  =%L,
multi_surf_id     =%L,
multi_surf_geom   =%L
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.cell_type,
NEW.module_area,
NEW.module_area_unit,
NEW.them_surf_id,
NEW.building_inst_id,
NEW.multi_surf_id,
NEW.multi_surf_geom,
OLD.id
) INTO updated_id;
-- RAISE NOTICE 'Updated record with id: %',updated_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_upd_conv_system_solar_pv (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view CONV_SYSTEM_SOLAR_PV
----------------------------------------------------------------
DROP TRIGGER IF EXISTS nrg8_tr_del_conv_system_solar_pv ON citydb_view.nrg8_conv_system_solar_pv;
CREATE TRIGGER nrg8_tr_del_conv_system_solar_pv
	INSTEAD OF DELETE ON citydb_view.nrg8_conv_system_solar_pv
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_del_conv_system_solar_pv ('citydb');

DROP TRIGGER IF EXISTS nrg8_tr_ins_conv_system_solar_pv ON citydb_view.nrg8_conv_system_solar_pv;
CREATE TRIGGER nrg8_tr_ins_conv_system_solar_pv
	INSTEAD OF INSERT ON citydb_view.nrg8_conv_system_solar_pv
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_ins_conv_system_solar_pv ('citydb');

DROP TRIGGER IF EXISTS nrg8_tr_upd_conv_system_solar_pv ON citydb_view.nrg8_conv_system_solar_pv;
CREATE TRIGGER nrg8_tr_upd_conv_system_solar_pv
	INSTEAD OF UPDATE ON citydb_view.nrg8_conv_system_solar_pv
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_upd_conv_system_solar_pv ('citydb');
--**************************************************************
--**************************************************************

----------------------------------------------------------------
-- Function TR_DEL_CONV_SYSTEM_SOLAR_THERMAL
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_del_conv_system_solar_thermal() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_del_conv_system_solar_thermal()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
deleted_id=citydb_pkg.nrg8_delete_conv_system(OLD.id, p_schema_name);
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_del_conv_system_solar_thermal (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_CONV_SYSTEM_SOLAR_THERMAL
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_ins_conv_system_solar_thermal() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_ins_conv_system_solar_thermal()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	inserted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
inserted_id=citydb_view.nrg8_insert_solar_thermal_system(
id                    :=NEW.id,
gmlid                 :=NEW.gmlid,
gmlid_codespace       :=NEW.gmlid_codespace,
name                  :=NEW.name,
name_codespace        :=NEW.name_codespace,
description           :=NEW.description,
envelope              :=NEW.envelope,
creation_date         :=NEW.creation_date,
termination_date      :=NEW.termination_date,
relative_to_terrain   :=NEW.relative_to_terrain,
relative_to_water     :=NEW.relative_to_water,
last_modification_date:=NEW.last_modification_date,
updating_person       :=NEW.updating_person,
reason_for_update     :=NEW.reason_for_update,
lineage               :=NEW.lineage,

model                   :=NEW.model,
nbr                     :=NEW.nbr,
year_of_manufacture     :=NEW.year_of_manufacture,
inst_nom_pwr            :=NEW.inst_nom_pwr,
inst_nom_pwr_unit       :=NEW.inst_nom_pwr_unit,
nom_effcy               :=NEW.nom_effcy,
effcy_indicator         :=NEW.effcy_indicator,
start_of_life           :=NEW.start_of_life,
life_expect_value       :=NEW.life_expect_value,
life_expect_value_unit  :=NEW.life_expect_value_unit,
main_maint_interval     :=NEW.main_maint_interval,
main_maint_interval_unit:=NEW.main_maint_interval_unit,
inst_in_ctyobj_id       :=NEW.inst_in_ctyobj_id,
cityobject_id           :=NEW.cityobject_id,
collector_type          :=NEW.collector_type,
aperture_area           :=NEW.aperture_area,
aperture_area_unit      :=NEW.aperture_area_unit,
eta0                    :=NEW.eta0,
a1                      :=NEW.a1,
a2                      :=NEW.a2,
them_surf_id            :=NEW.them_surf_id,
building_inst_id        :=NEW.building_inst_id,
multi_surf_id           :=NEW.multi_surf_id,
multi_surf_geom         :=NEW.multi_surf_geom,
schema_name               :=p_schema_name
);
--RAISE NOTICE 'Inserted record with id: %', inserted_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_ins_conv_system_solar_thermal (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_CONV_SYSTEM_SOLAR_THERMAL
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_upd_conv_system_solar_thermal() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_upd_conv_system_solar_thermal()
  RETURNS trigger AS
$BODY$
DECLARE
  p_schema_name varchar DEFAULT 'citydb'::varchar;
  updated_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
EXECUTE format('UPDATE %I.cityobject AS t SET
 gmlid                 =%L,
 gmlid_codespace       =%L,
 name                  =%L,
 name_codespace        =%L,
 description           =%L,
 envelope              =%L,
 creation_date         =%L,
 termination_date      =%L,
 relative_to_terrain   =%L,
 relative_to_water     =%L,
 last_modification_date=%L,
 updating_person       =%L,
 reason_for_update     =%L,
 lineage               =%L
WHERE t.id=%L RETURNING id',
 p_schema_name,
 NEW.gmlid,
 NEW.gmlid_codespace,
 NEW.name,
 NEW.name_codespace,
 NEW.description,
 NEW.envelope,
 NEW.creation_date,
 NEW.termination_date,
 NEW.relative_to_terrain,
 NEW.relative_to_water,
 NEW.last_modification_date,
 NEW.updating_person,
 NEW.reason_for_update,
 NEW.lineage,
 OLD.id
) INTO updated_id;
EXECUTE format('UPDATE %I.nrg8_conv_system AS t SET
model                   =%L,
nbr                     =%L,
year_of_manufacture     =%L,
inst_nom_pwr            =%L,
inst_nom_pwr_unit       =%L,
nom_effcy               =%L,
effcy_indicator         =%L,
start_of_life           =%L,
life_expect_value       =%L,
life_expect_value_unit  =%L,
main_maint_interval     =%L,
main_maint_interval_unit=%L,
inst_in_ctyobj_id       =%L,
cityobject_id           =%L
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.model,
NEW.nbr,
NEW.year_of_manufacture,
NEW.inst_nom_pwr,
NEW.inst_nom_pwr_unit,
NEW.nom_effcy,
NEW.effcy_indicator,
NEW.start_of_life,
NEW.life_expect_value,
NEW.life_expect_value_unit,
NEW.main_maint_interval,
NEW.main_maint_interval_unit,
NEW.inst_in_ctyobj_id,
NEW.cityobject_id,
OLD.id
) INTO updated_id;
EXECUTE format('UPDATE %I.nrg8_solar_system AS t SET
collector_type    =%L,
aperture_area     =%L,
aperture_area_unit=%L,
eta0              =%L,
a1                =%L,
a2                =%L,
them_surf_id      =%L,
building_inst_id  =%L,
multi_surf_id     =%L,
multi_surf_geom   =%L
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.collector_type,
NEW.aperture_area,
NEW.aperture_area_unit,
NEW.eta0,
NEW.a1,
NEW.a2,
NEW.them_surf_id,
NEW.building_inst_id,
NEW.multi_surf_id,
NEW.multi_surf_geom,
OLD.id
) INTO updated_id;
-- RAISE NOTICE 'Updated record with id: %',updated_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_upd_conv_system_solar_thermal (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view CONV_SYSTEM_SOLAR_THERMAL
----------------------------------------------------------------
DROP TRIGGER IF EXISTS nrg8_tr_del_conv_system_solar_thermal ON citydb_view.nrg8_conv_system_solar_thermal;
CREATE TRIGGER nrg8_tr_del_conv_system_solar_thermal
	INSTEAD OF DELETE ON citydb_view.nrg8_conv_system_solar_thermal
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_del_conv_system_solar_thermal ('citydb');

DROP TRIGGER IF EXISTS nrg8_tr_ins_conv_system_solar_thermal ON citydb_view.nrg8_conv_system_solar_thermal;
CREATE TRIGGER nrg8_tr_ins_conv_system_solar_thermal
	INSTEAD OF INSERT ON citydb_view.nrg8_conv_system_solar_thermal
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_ins_conv_system_solar_thermal ('citydb');

DROP TRIGGER IF EXISTS nrg8_tr_upd_conv_system_solar_thermal ON citydb_view.nrg8_conv_system_solar_thermal;
CREATE TRIGGER nrg8_tr_upd_conv_system_solar_thermal
	INSTEAD OF UPDATE ON citydb_view.nrg8_conv_system_solar_thermal
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_upd_conv_system_solar_thermal ('citydb');
--**************************************************************
--**************************************************************

----------------------------------------------------------------
-- Function TR_DEL_TIME_SERIES
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_del_time_series() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_del_time_series()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
deleted_id=citydb_pkg.nrg8_delete_time_series(OLD.id, p_schema_name);
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_del_time_series (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_TIME_SERIES
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_ins_time_series() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_ins_time_series()
  RETURNS trigger AS
$BODY$
DECLARE
	inserted_id integer;
	p_schema_name varchar DEFAULT 'citydb'::varchar;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
inserted_id=citydb_view.nrg8_insert_time_series(
classname            :=NEW.classname            ,
id                   :=NEW.id                   ,
gmlid                :=NEW.gmlid                ,
gmlid_codespace      :=NEW.gmlid_codespace      ,
name                 :=NEW.name                 ,
name_codespace       :=NEW.name_codespace       ,
description          :=NEW.description          ,
acquisition_method   :=NEW.acquisition_method   ,
interpolation_type   :=NEW.interpolation_type   ,
quality_description  :=NEW.quality_description  ,
source               :=NEW.source               ,
time_array           :=NEW.time_array           ,
values_array         :=NEW.values_array         ,
values_unit          :=NEW.values_unit          ,
array_length         :=NEW.array_length         ,
temporal_extent_begin:=NEW.temporal_extent_begin,
temporal_extent_end  :=NEW.temporal_extent_end  ,
time_interval        :=NEW.time_interval        ,
time_interval_unit   :=NEW.time_interval_unit   ,
--
file_path            :=NEW.file_path            ,
file_name            :=NEW.file_name            ,
file_extension       :=NEW.file_extension       ,
nbr_header_lines     :=NEW.nbr_header_lines     ,
field_sep            :=NEW.field_sep            ,
record_sep           :=NEW.record_sep           ,
dec_symbol           :=NEW.dec_symbol           ,
time_col_nbr         :=NEW.time_col_nbr         ,
value_col_nbr        :=NEW.value_col_nbr        ,
is_compressed        :=NEW.is_compressed        ,
--
schema_name          :=p_schema_name
);
--RAISE NOTICE 'Inserted record with id: %', inserted_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_ins_time_series (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_TIME_SERIES
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_upd_time_series() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_upd_time_series()
  RETURNS trigger AS
$BODY$
DECLARE
  updated_id integer;
  p_schema_name varchar DEFAULT 'citydb'::varchar;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
EXECUTE format('UPDATE %I.nrg8_time_series AS t SET
gmlid                =%L,
gmlid_codespace      =%L,
name                 =%L,
name_codespace       =%L,
description          =%L,
acquisition_method   =%L,
interpolation_type   =%L,
quality_description  =%L,
source               =%L,
time_array           =%L,
values_array         =%L,
values_unit          =%L,
array_length         =%L,
temporal_extent_begin=%L,
temporal_extent_end  =%L,
time_interval        =%L, 
time_interval_unit   =%L 
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.gmlid,
NEW.gmlid_codespace,
NEW.name,
NEW.name_codespace,
NEW.description,	
NEW.acquisition_method,
NEW.interpolation_type,
NEW.quality_description,
NEW.source,
NEW.time_array,
NEW.values_array,
NEW.values_unit,
NEW.array_length,
NEW.temporal_extent_begin,
NEW.temporal_extent_end, 
NEW.time_interval, 
NEW.time_interval_unit, 
OLD.id
) INTO updated_id;

IF OLD.classname IN ('RegularTimeSeriesFile', 'IrregularTimeSeriesFile') THEN
	EXECUTE format('UPDATE %I.nrg8_time_series_file AS t SET
	file_path            =%L,
	file_name            =%L,
	file_extension       =%L,
	nbr_header_lines     =%L,
	field_sep            =%L,
	record_sep           =%L,
	dec_symbol           =%L,
	time_col_nbr         =%L,
	value_col_nbr        =%L,
	is_compressed        =%L
	WHERE t.id=%L RETURNING id',
	p_schema_name,
	NEW.file_path,
	NEW.file_name,
	NEW.file_extension,
	NEW.nbr_header_lines,
	NEW.field_sep,
	NEW.record_sep,
	NEW.dec_symbol,
	NEW.time_col_nbr,
	NEW.value_col_nbr,
	NEW.is_compressed,
	OLD.id
	) INTO updated_id;
END IF;
-- RAISE NOTICE 'Updated record with id: %',updated_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_upd_time_series (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view TIME_SERIES
----------------------------------------------------------------
DROP TRIGGER IF EXISTS nrg8_tr_del_time_series ON citydb_view.nrg8_time_series;
CREATE TRIGGER nrg8_tr_del_time_series
	INSTEAD OF DELETE ON citydb_view.nrg8_time_series
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_del_time_series ('citydb');

DROP TRIGGER IF EXISTS nrg8_tr_ins_time_series ON citydb_view.nrg8_time_series;
CREATE TRIGGER nrg8_tr_ins_time_series
	INSTEAD OF INSERT ON citydb_view.nrg8_time_series
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_ins_time_series ('citydb');

DROP TRIGGER IF EXISTS nrg8_tr_upd_time_series ON citydb_view.nrg8_time_series;
CREATE TRIGGER nrg8_tr_upd_time_series
	INSTEAD OF UPDATE ON citydb_view.nrg8_time_series
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_upd_time_series ('citydb');
--**************************************************************
--**************************************************************

----------------------------------------------------------------
-- Function TR_DEL_WEATHER_DATA_TS
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_del_weather_data_ts() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_del_weather_data_ts()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
deleted_id=citydb_pkg.nrg8_delete_weather_data(OLD.id, p_schema_name);
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_del_weather_data_ts (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_WEATHER_DATA_TS
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.nrg8_tr_ins_weather_data_ts() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_ins_weather_data_ts()
  RETURNS trigger AS
$BODY$
DECLARE
	ts_id integer;
	inserted_id integer;
	p_schema_name varchar DEFAULT 'citydb'::varchar;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
ts_id=citydb_view.nrg8_insert_time_series(
classname            :=NEW.ts_classname            ,
id                   :=NEW.ts_id                   ,
gmlid                :=NEW.ts_gmlid                ,
gmlid_codespace      :=NEW.ts_gmlid_codespace      ,
name                 :=NEW.ts_name                 ,
name_codespace       :=NEW.ts_name_codespace       ,
description          :=NEW.ts_description          ,
acquisition_method   :=NEW.ts_acquisition_method   ,
interpolation_type   :=NEW.ts_interpolation_type   ,
quality_description  :=NEW.ts_quality_description  ,
source               :=NEW.ts_source               ,
time_array           :=NEW.ts_time_array           ,
values_array         :=NEW.ts_values_array         ,
values_unit          :=NEW.ts_values_unit          ,
array_length         :=NEW.ts_array_length         ,
temporal_extent_begin:=NEW.ts_temporal_extent_begin,
temporal_extent_end  :=NEW.ts_temporal_extent_end  ,
time_interval        :=NEW.ts_time_interval        ,
time_interval_unit   :=NEW.ts_time_interval_unit   ,
--
file_path            :=NEW.ts_file_path            ,
file_name            :=NEW.ts_file_name            ,
file_extension       :=NEW.ts_file_extension       ,
nbr_header_lines     :=NEW.ts_nbr_header_lines     ,
field_sep            :=NEW.ts_field_sep            ,
record_sep           :=NEW.ts_record_sep           ,
dec_symbol           :=NEW.ts_dec_symbol           ,
time_col_nbr         :=NEW.ts_time_col_nbr         ,
value_col_nbr        :=NEW.ts_value_col_nbr        ,
is_compressed        :=NEW.ts_is_compressed        ,
--
schema_name          :=p_schema_name
);
inserted_id=citydb_view.nrg8_insert_weather_data(
id                   :=NEW.id,
gmlid                :=NEW.gmlid,
gmlid_codespace      :=NEW.gmlid_codespace,
name                 :=NEW.name,
name_codespace       :=NEW.name_codespace,
description          :=NEW.description,		
type                 :=NEW.type,
time_series_id       :=ts_id,
cityobject_id        :=NEW.cityobject_id,
install_point        :=NEW.install_point,
--
schema_name          :=p_schema_name
);
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_ins_weather_data_ts (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_WEATHER_DATA_TS
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_upd_weather_data_ts() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_upd_weather_data_ts()
  RETURNS trigger AS
$BODY$
DECLARE
  updated_id integer;
  p_schema_name varchar DEFAULT 'citydb'::varchar;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
EXECUTE format('UPDATE %I.nrg8_time_series AS t SET
gmlid                =%L,
gmlid_codespace      =%L,
name                 =%L,
name_codespace       =%L,
description          =%L,
acquisition_method   =%L,
interpolation_type   =%L,
quality_description  =%L,
source               =%L,
time_array           =%L,
values_array         =%L,
values_unit          =%L,
array_length         =%L,
temporal_extent_begin=%L,
temporal_extent_end  =%L,
time_interval        =%L, 
time_interval_unit   =%L 
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.ts_gmlid,
NEW.ts_gmlid_codespace,
NEW.ts_name,
NEW.ts_name_codespace,
NEW.ts_description,	
NEW.ts_acquisition_method,
NEW.ts_interpolation_type,
NEW.ts_quality_description,
NEW.ts_source,
NEW.ts_time_array,
NEW.ts_values_array,
NEW.ts_values_unit,
NEW.ts_array_length,
NEW.ts_temporal_extent_begin,
NEW.ts_temporal_extent_end, 
NEW.ts_time_interval, 
NEW.ts_time_interval_unit, 
OLD.ts_id
) INTO updated_id;

IF OLD.ts_classname IN ('RegularTimeSeriesFile', 'IrregularTimeSeriesFile') THEN
	EXECUTE format('UPDATE %I.nrg8_time_series_file AS t SET
	file_path            =%L,
	file_name            =%L,
	file_extension       =%L,
	nbr_header_lines     =%L,
	field_sep            =%L,
	record_sep           =%L,
	dec_symbol           =%L,
	time_col_nbr         =%L,
	value_col_nbr        =%L,
	is_compressed        =%L
	WHERE t.id=%L RETURNING id',
	p_schema_name,
	NEW.ts_file_path,
	NEW.ts_file_name,
	NEW.ts_file_extension,
	NEW.ts_nbr_header_lines,
	NEW.ts_field_sep,
	NEW.ts_record_sep,
	NEW.ts_dec_symbol,
	NEW.ts_time_col_nbr,
	NEW.ts_value_col_nbr,
	NEW.ts_is_compressed,
	OLD.ts_id
	) INTO updated_id;
END IF;

EXECUTE format('UPDATE %I.nrg8_weather_data AS t SET
gmlid           =%L,
gmlid_codespace =%L,
name            =%L,
name_codespace  =%L,
description     =%L,
type            =%L,
cityobject_id   =%L,
install_point   =%L
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.gmlid,
NEW.gmlid_codespace,
NEW.name,
NEW.name_codespace,
NEW.description,
NEW.type,
NEW.cityobject_id,
NEW.install_point,
OLD.id
) INTO updated_id;
-- RAISE NOTICE 'Updated record with id: %',updated_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_upd_weather_data_ts (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view WEATHER_DATA_TS
----------------------------------------------------------------
DROP TRIGGER IF EXISTS nrg8_tr_del_weather_data_ts ON citydb_view.nrg8_weather_data_ts;
CREATE TRIGGER nrg8_tr_del_weather_data_ts
	INSTEAD OF DELETE ON citydb_view.nrg8_weather_data_ts
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_del_weather_data_ts ('citydb');

DROP TRIGGER IF EXISTS nrg8_tr_ins_weather_data_ts ON citydb_view.nrg8_weather_data_ts;
CREATE TRIGGER nrg8_tr_ins_weather_data_ts
	INSTEAD OF INSERT ON citydb_view.nrg8_weather_data_ts
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_ins_weather_data_ts ('citydb');

DROP TRIGGER IF EXISTS nrg8_tr_upd_weather_data_ts ON citydb_view.nrg8_weather_data_ts;
CREATE TRIGGER nrg8_tr_upd_weather_data_ts
	INSTEAD OF UPDATE ON citydb_view.nrg8_weather_data_ts
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_upd_weather_data_ts ('citydb');
--**************************************************************
--**************************************************************

----------------------------------------------------------------
-- Function TR_DEL_SCHEDULE_TIME_SERIES_TS
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_del_schedule_time_series_ts() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_del_schedule_time_series_ts()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
deleted_id=citydb_pkg.nrg8_delete_schedule(OLD.id, p_schema_name);
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_del_schedule_time_series_ts (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_SCHEDULE_TIME_SERIES_TS
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_ins_schedule_time_series_ts() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_ins_schedule_time_series_ts()
  RETURNS trigger AS
$BODY$
DECLARE
	ts_id integer;
	inserted_id integer;
	p_schema_name varchar DEFAULT 'citydb'::varchar;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
ts_id=citydb_view.nrg8_insert_time_series(
classname            :=NEW.ts_classname            ,
id                   :=NEW.ts_id                   ,
gmlid                :=NEW.ts_gmlid                ,
gmlid_codespace      :=NEW.ts_gmlid_codespace      ,
name                 :=NEW.ts_name                 ,
name_codespace       :=NEW.ts_name_codespace       ,
description          :=NEW.ts_description          ,
acquisition_method   :=NEW.ts_acquisition_method   ,
interpolation_type   :=NEW.ts_interpolation_type   ,
quality_description  :=NEW.ts_quality_description  ,
source               :=NEW.ts_source               ,
time_array           :=NEW.ts_time_array           ,
values_array         :=NEW.ts_values_array         ,
values_unit          :=NEW.ts_values_unit          ,
array_length         :=NEW.ts_array_length         ,
temporal_extent_begin:=NEW.ts_temporal_extent_begin,
temporal_extent_end  :=NEW.ts_temporal_extent_end  ,
time_interval        :=NEW.ts_time_interval        ,
time_interval_unit   :=NEW.ts_time_interval_unit   ,
--
file_path            :=NEW.ts_file_path            ,
file_name            :=NEW.ts_file_name            ,
file_extension       :=NEW.ts_file_extension       ,
nbr_header_lines     :=NEW.ts_nbr_header_lines     ,
field_sep            :=NEW.ts_field_sep            ,
record_sep           :=NEW.ts_record_sep           ,
dec_symbol           :=NEW.ts_dec_symbol           ,
time_col_nbr         :=NEW.ts_time_col_nbr         ,
value_col_nbr        :=NEW.ts_value_col_nbr        ,
is_compressed        :=NEW.ts_is_compressed        ,
--
schema_name          :=p_schema_name
);
inserted_id=citydb_view.nrg8_insert_time_series_schedule(
id                   :=NEW.id,
gmlid                :=NEW.gmlid,
gmlid_codespace      :=NEW.gmlid_codespace,
name                 :=NEW.name,
name_codespace       :=NEW.name_codespace,
description          :=NEW.description,
time_series_id       :=ts_id,
--
schema_name          :=p_schema_name
);
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_ins_schedule_time_series_ts (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_SCHEDULE_TIME_SERIES_TS
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_upd_schedule_time_series_ts() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_upd_schedule_time_series_ts()
  RETURNS trigger AS
$BODY$
DECLARE
  updated_id integer;
  p_schema_name varchar DEFAULT 'citydb'::varchar;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
EXECUTE format('UPDATE %I.nrg8_time_series AS t SET
gmlid                =%L,
gmlid_codespace      =%L,
name                 =%L,
name_codespace       =%L,
description          =%L,
acquisition_method   =%L,
interpolation_type   =%L,
quality_description  =%L,
source               =%L,
time_array           =%L,
values_array         =%L,
values_unit          =%L,
array_length         =%L,
temporal_extent_begin=%L,
temporal_extent_end  =%L,
time_interval        =%L, 
time_interval_unit   =%L 
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.ts_gmlid,
NEW.ts_gmlid_codespace,
NEW.ts_name,
NEW.ts_name_codespace,
NEW.ts_description,	
NEW.ts_acquisition_method,
NEW.ts_interpolation_type,
NEW.ts_quality_description,
NEW.ts_source,
NEW.ts_time_array,
NEW.ts_values_array,
NEW.ts_values_unit,
NEW.ts_array_length,
NEW.ts_temporal_extent_begin,
NEW.ts_temporal_extent_end, 
NEW.ts_time_interval, 
NEW.ts_time_interval_unit, 
OLD.ts_id
) INTO updated_id;

IF OLD.ts_classname IN ('RegularTimeSeriesFile', 'IrregularTimeSeriesFile') THEN
	EXECUTE format('UPDATE %I.nrg8_time_series_file AS t SET
	file_path            =%L,
	file_name            =%L,
	file_extension       =%L,
	nbr_header_lines     =%L,
	field_sep            =%L,
	record_sep           =%L,
	dec_symbol           =%L,
	time_col_nbr         =%L,
	value_col_nbr        =%L,
	is_compressed        =%L
	WHERE t.id=%L RETURNING id',
	p_schema_name,
	NEW.ts_file_path,
	NEW.ts_file_name,
	NEW.ts_file_extension,
	NEW.ts_nbr_header_lines,
	NEW.ts_field_sep,
	NEW.ts_record_sep,
	NEW.ts_dec_symbol,
	NEW.ts_time_col_nbr,
	NEW.ts_value_col_nbr,
	NEW.ts_is_compressed,
	OLD.ts_id
	) INTO updated_id;
END IF;

EXECUTE format('UPDATE %I.nrg8_schedule AS t SET
gmlid          =%L,
gmlid_codespace=%L,
name           =%L,
name_codespace =%L,
description    =%L,
time_series_id =%L
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.gmlid,
NEW.gmlid_codespace,
NEW.name,
NEW.name_codespace,
NEW.description,
OLD.ts_id,	
OLD.id
) INTO updated_id;
-- RAISE NOTICE 'Updated record with id: %',updated_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_upd_schedule_time_series_ts (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view SCHEDULE_TIME_SERIES_TS
----------------------------------------------------------------
DROP TRIGGER IF EXISTS nrg8_tr_del_schedule_time_series_ts ON citydb_view.nrg8_schedule_time_series_ts;
CREATE TRIGGER nrg8_tr_del_schedule_time_series_ts
	INSTEAD OF DELETE ON citydb_view.nrg8_schedule_time_series_ts
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_del_schedule_time_series_ts ('citydb');

DROP TRIGGER IF EXISTS nrg8_tr_ins_schedule_time_series_ts ON citydb_view.nrg8_schedule_time_series_ts;
CREATE TRIGGER nrg8_tr_ins_schedule_time_series_ts
	INSTEAD OF INSERT ON citydb_view.nrg8_schedule_time_series_ts
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_ins_schedule_time_series_ts ('citydb');

DROP TRIGGER IF EXISTS nrg8_tr_upd_schedule_time_series_ts ON citydb_view.nrg8_schedule_time_series_ts;
CREATE TRIGGER nrg8_tr_upd_schedule_time_series_ts
	INSTEAD OF UPDATE ON citydb_view.nrg8_schedule_time_series_ts
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_upd_schedule_time_series_ts ('citydb');
--**************************************************************
--**************************************************************

----------------------------------------------------------------
-- Function TR_DEL_FINAL_ENERGY_TS
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_del_final_energy_ts() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_del_final_energy_ts()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
deleted_id=citydb_pkg.nrg8_delete_final_energy(OLD.id, p_schema_name);
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_del_final_energy_ts (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_FINAL_ENERGY_TS
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_ins_final_energy_ts() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_ins_final_energy_ts()
  RETURNS trigger AS
$BODY$
DECLARE
	ts_id integer;
	inserted_id integer;
	p_schema_name varchar DEFAULT 'citydb'::varchar;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
ts_id=citydb_view.nrg8_insert_time_series(
classname            :=NEW.ts_classname            ,
id                   :=NEW.ts_id                   ,
gmlid                :=NEW.ts_gmlid                ,
gmlid_codespace      :=NEW.ts_gmlid_codespace      ,
name                 :=NEW.ts_name                 ,
name_codespace       :=NEW.ts_name_codespace       ,
description          :=NEW.ts_description          ,
acquisition_method   :=NEW.ts_acquisition_method   ,
interpolation_type   :=NEW.ts_interpolation_type   ,
quality_description  :=NEW.ts_quality_description  ,
source               :=NEW.ts_source               ,
time_array           :=NEW.ts_time_array           ,
values_array         :=NEW.ts_values_array         ,
values_unit          :=NEW.ts_values_unit          ,
array_length         :=NEW.ts_array_length         ,
temporal_extent_begin:=NEW.ts_temporal_extent_begin,
temporal_extent_end  :=NEW.ts_temporal_extent_end  ,
time_interval        :=NEW.ts_time_interval        ,
time_interval_unit   :=NEW.ts_time_interval_unit   ,
--
file_path            :=NEW.ts_file_path            ,
file_name            :=NEW.ts_file_name            ,
file_extension       :=NEW.ts_file_extension       ,
nbr_header_lines     :=NEW.ts_nbr_header_lines     ,
field_sep            :=NEW.ts_field_sep            ,
record_sep           :=NEW.ts_record_sep           ,
dec_symbol           :=NEW.ts_dec_symbol           ,
time_col_nbr         :=NEW.ts_time_col_nbr         ,
value_col_nbr        :=NEW.ts_value_col_nbr        ,
is_compressed        :=NEW.ts_is_compressed        ,
--
schema_name          :=p_schema_name
);
inserted_id=citydb_view.nrg8_insert_final_energy(
id                          :=NEW.id,
gmlid                       :=NEW.gmlid,
gmlid_codespace             :=NEW.gmlid_codespace,
name                        :=NEW.name,
name_codespace              :=NEW.name_codespace,
description                 :=NEW.description,
nrg_car_type                :=NEW.nrg_car_type,
nrg_car_prim_nrg_factor     :=NEW.nrg_car_prim_nrg_factor,
nrg_car_prim_nrg_factor_unit:=NEW.nrg_car_prim_nrg_factor_unit,
nrg_car_nrg_density         :=NEW.nrg_car_nrg_density,
nrg_car_nrg_density_unit    :=NEW.nrg_car_nrg_density_unit,
nrg_car_co2_emission        :=NEW.nrg_car_co2_emission,
nrg_car_co2_emission_unit   :=NEW.nrg_car_co2_emission_unit,
time_series_id              :=ts_id,
--
schema_name                 :=p_schema_name
);
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_ins_final_energy_ts (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_FINAL_ENERGY_TS
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_upd_final_energy_ts() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_upd_final_energy_ts()
  RETURNS trigger AS
$BODY$
DECLARE
  updated_id integer;
  p_schema_name varchar DEFAULT 'citydb'::varchar;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
EXECUTE format('UPDATE %I.nrg8_time_series AS t SET
gmlid                =%L,
gmlid_codespace      =%L,
name                 =%L,
name_codespace       =%L,
description          =%L,
acquisition_method   =%L,
interpolation_type   =%L,
quality_description  =%L,
source               =%L,
time_array           =%L,
values_array         =%L,
values_unit          =%L,
array_length         =%L,
temporal_extent_begin=%L,
temporal_extent_end  =%L,
time_interval        =%L, 
time_interval_unit   =%L 
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.ts_gmlid,
NEW.ts_gmlid_codespace,
NEW.ts_name,
NEW.ts_name_codespace,
NEW.ts_description,	
NEW.ts_acquisition_method,
NEW.ts_interpolation_type,
NEW.ts_quality_description,
NEW.ts_source,
NEW.ts_time_array,
NEW.ts_values_array,
NEW.ts_values_unit,
NEW.ts_array_length,
NEW.ts_temporal_extent_begin,
NEW.ts_temporal_extent_end, 
NEW.ts_time_interval, 
NEW.ts_time_interval_unit, 
OLD.ts_id
) INTO updated_id;

IF OLD.ts_classname IN ('RegularTimeSeriesFile', 'IrregularTimeSeriesFile') THEN
	EXECUTE format('UPDATE %I.nrg8_time_series_file AS t SET
	file_path            =%L,
	file_name            =%L,
	file_extension       =%L,
	nbr_header_lines     =%L,
	field_sep            =%L,
	record_sep           =%L,
	dec_symbol           =%L,
	time_col_nbr         =%L,
	value_col_nbr        =%L,
	is_compressed        =%L
	WHERE t.id=%L RETURNING id',
	p_schema_name,
	NEW.ts_file_path,
	NEW.ts_file_name,
	NEW.ts_file_extension,
	NEW.ts_nbr_header_lines,
	NEW.ts_field_sep,
	NEW.ts_record_sep,
	NEW.ts_dec_symbol,
	NEW.ts_time_col_nbr,
	NEW.ts_value_col_nbr,
	NEW.ts_is_compressed,
	OLD.ts_id
	) INTO updated_id;
END IF;

EXECUTE format('UPDATE %I.nrg8_final_energy AS t SET
gmlid                       =%L,
gmlid_codespace             =%L,
name                        =%L,
name_codespace              =%L,
description                 =%L,
nrg_car_type                =%L,
nrg_car_prim_nrg_factor     =%L,
nrg_car_prim_nrg_factor_unit=%L,
nrg_car_nrg_density         =%L,
nrg_car_nrg_density_unit    =%L,
nrg_car_co2_emission        =%L,
nrg_car_co2_emission_unit   =%L,
time_series_id              =%L
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.gmlid,
NEW.gmlid_codespace,
NEW.name,
NEW.name_codespace,
NEW.description,
NEW.nrg_car_type,
NEW.nrg_car_prim_nrg_factor,
NEW.nrg_car_prim_nrg_factor_unit,
NEW.nrg_car_nrg_density,
NEW.nrg_car_nrg_density_unit,
NEW.nrg_car_co2_emission,
NEW.nrg_car_co2_emission_unit,
OLD.ts_id,
OLD.id
) INTO updated_id;
-- RAISE NOTICE 'Updated record with id: %',updated_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_upd_final_energy_ts (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view FINAL_ENERGY_TS
----------------------------------------------------------------
DROP TRIGGER IF EXISTS nrg8_tr_del_final_energy_ts ON citydb_view.nrg8_final_energy_ts;
CREATE TRIGGER nrg8_tr_del_final_energy_ts
	INSTEAD OF DELETE ON citydb_view.nrg8_final_energy_ts
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_del_final_energy_ts ('citydb');

DROP TRIGGER IF EXISTS nrg8_tr_ins_final_energy_ts ON citydb_view.nrg8_final_energy_ts;
CREATE TRIGGER nrg8_tr_ins_final_energy_ts
	INSTEAD OF INSERT ON citydb_view.nrg8_final_energy_ts
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_ins_final_energy_ts ('citydb');

DROP TRIGGER IF EXISTS nrg8_tr_upd_final_energy_ts ON citydb_view.nrg8_final_energy_ts;
CREATE TRIGGER nrg8_tr_upd_final_energy_ts
	INSTEAD OF UPDATE ON citydb_view.nrg8_final_energy_ts
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_upd_final_energy_ts ('citydb');
--**************************************************************
--**************************************************************

----------------------------------------------------------------
-- Function TR_DEL_ENERGY_DEMAND_TS
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_del_energy_demand_ts() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_del_energy_demand_ts()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
deleted_id=citydb_pkg.nrg8_delete_energy_demand(OLD.id, p_schema_name);
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_del_energy_demand_ts (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_ENERGY_DEMAND_TS
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_ins_energy_demand_ts() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_ins_energy_demand_ts()
  RETURNS trigger AS
$BODY$
DECLARE
	ts_id integer;
	inserted_id integer;
	p_schema_name varchar DEFAULT 'citydb'::varchar;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
ts_id=citydb_view.nrg8_insert_time_series(
classname            :=NEW.ts_classname            ,
id                   :=NEW.ts_id                   ,
gmlid                :=NEW.ts_gmlid                ,
gmlid_codespace      :=NEW.ts_gmlid_codespace      ,
name                 :=NEW.ts_name                 ,
name_codespace       :=NEW.ts_name_codespace       ,
description          :=NEW.ts_description          ,
acquisition_method   :=NEW.ts_acquisition_method   ,
interpolation_type   :=NEW.ts_interpolation_type   ,
quality_description  :=NEW.ts_quality_description  ,
source               :=NEW.ts_source               ,
time_array           :=NEW.ts_time_array           ,
values_array         :=NEW.ts_values_array         ,
values_unit          :=NEW.ts_values_unit          ,
array_length         :=NEW.ts_array_length         ,
temporal_extent_begin:=NEW.ts_temporal_extent_begin,
temporal_extent_end  :=NEW.ts_temporal_extent_end  ,
time_interval        :=NEW.ts_time_interval        ,
time_interval_unit   :=NEW.ts_time_interval_unit   ,
--
file_path            :=NEW.ts_file_path            ,
file_name            :=NEW.ts_file_name            ,
file_extension       :=NEW.ts_file_extension       ,
nbr_header_lines     :=NEW.ts_nbr_header_lines     ,
field_sep            :=NEW.ts_field_sep            ,
record_sep           :=NEW.ts_record_sep           ,
dec_symbol           :=NEW.ts_dec_symbol           ,
time_col_nbr         :=NEW.ts_time_col_nbr         ,
value_col_nbr        :=NEW.ts_value_col_nbr        ,
is_compressed        :=NEW.ts_is_compressed        ,
--
schema_name          :=p_schema_name
);
inserted_id=citydb_view.nrg8_insert_energy_demand(
id                   :=NEW.id,
gmlid                :=NEW.gmlid,
gmlid_codespace      :=NEW.gmlid_codespace,
name                 :=NEW.name,
name_codespace       :=NEW.name_codespace,
description          :=NEW.description,
end_use              :=NEW.end_use,
max_load             :=NEW.max_load,
max_load_unit        :=NEW.max_load_unit,
time_series_id       :=ts_id,
cityobject_id        :=NEW.cityobject_id,
--
schema_name          :=p_schema_name
);
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_ins_energy_demand_ts (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_ENERGY_DEMAND_TS
----------------------------------------------------------------
DROP FUNCTION IF EXISTS citydb_view.nrg8_tr_upd_energy_demand_ts() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_upd_energy_demand_ts()
  RETURNS trigger AS
$BODY$
DECLARE
  updated_id integer;
  p_schema_name varchar DEFAULT 'citydb'::varchar;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
EXECUTE format('UPDATE %I.nrg8_time_series AS t SET
gmlid                =%L,
gmlid_codespace      =%L,
name                 =%L,
name_codespace       =%L,
description          =%L,
acquisition_method   =%L,
interpolation_type   =%L,
quality_description  =%L,
source               =%L,
time_array           =%L,
values_array         =%L,
values_unit          =%L,
array_length         =%L,
temporal_extent_begin=%L,
temporal_extent_end  =%L,
time_interval        =%L, 
time_interval_unit   =%L 
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.ts_gmlid,
NEW.ts_gmlid_codespace,
NEW.ts_name,
NEW.ts_name_codespace,
NEW.ts_description,	
NEW.ts_acquisition_method,
NEW.ts_interpolation_type,
NEW.ts_quality_description,
NEW.ts_source,
NEW.ts_time_array,
NEW.ts_values_array,
NEW.ts_values_unit,
NEW.ts_array_length,
NEW.ts_temporal_extent_begin,
NEW.ts_temporal_extent_end, 
NEW.ts_time_interval, 
NEW.ts_time_interval_unit, 
OLD.ts_id
) INTO updated_id;

IF OLD.ts_classname IN ('RegularTimeSeriesFile', 'IrregularTimeSeriesFile') THEN
	EXECUTE format('UPDATE %I.nrg8_time_series_file AS t SET
	file_path            =%L,
	file_name            =%L,
	file_extension       =%L,
	nbr_header_lines     =%L,
	field_sep            =%L,
	record_sep           =%L,
	dec_symbol           =%L,
	time_col_nbr         =%L,
	value_col_nbr        =%L,
	is_compressed        =%L
	WHERE t.id=%L RETURNING id',
	p_schema_name,
	NEW.ts_file_path,
	NEW.ts_file_name,
	NEW.ts_file_extension,
	NEW.ts_nbr_header_lines,
	NEW.ts_field_sep,
	NEW.ts_record_sep,
	NEW.ts_dec_symbol,
	NEW.ts_time_col_nbr,
	NEW.ts_value_col_nbr,
	NEW.ts_is_compressed,
	OLD.ts_id
	) INTO updated_id;
END IF;

EXECUTE format('UPDATE %I.nrg8_energy_demand AS t SET
gmlid           =%L,
gmlid_codespace =%L,
name            =%L,
name_codespace  =%L,
description     =%L,
end_use         =%L,
max_load        =%L,
max_load_unit   =%L,
time_series_id  =%L,
cityobject_id   =%L
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.gmlid,
NEW.gmlid_codespace,
NEW.name,
NEW.name_codespace,
NEW.description,
NEW.end_use,
NEW.max_load,
NEW.max_load_unit,
OLD.ts_id,
NEW.cityobject_id,
OLD.id
) INTO updated_id;
-- RAISE NOTICE 'Updated record with id: %',updated_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_upd_energy_demand_ts (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view ENERGY_DEMAND_TS
----------------------------------------------------------------
DROP TRIGGER IF EXISTS nrg8_tr_del_energy_demand_ts ON citydb_view.nrg8_energy_demand_ts;
CREATE TRIGGER nrg8_tr_del_energy_demand_ts
	INSTEAD OF DELETE ON citydb_view.nrg8_energy_demand_ts
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_del_energy_demand_ts ('citydb');

DROP TRIGGER IF EXISTS nrg8_tr_ins_energy_demand_ts ON citydb_view.nrg8_energy_demand_ts;
CREATE TRIGGER nrg8_tr_ins_energy_demand_ts
	INSTEAD OF INSERT ON citydb_view.nrg8_energy_demand_ts
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_ins_energy_demand_ts ('citydb');

DROP TRIGGER IF EXISTS nrg8_tr_upd_energy_demand_ts ON citydb_view.nrg8_energy_demand_ts;
CREATE TRIGGER nrg8_tr_upd_energy_demand_ts
	INSTEAD OF UPDATE ON citydb_view.nrg8_energy_demand_ts
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_upd_energy_demand_ts ('citydb');
--**************************************************************
--**************************************************************















----------------------------------------------------------------
-- Function TR_DEL_DAILY_SCHEDULE_TS
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.nrg8_tr_del_daily_schedule_ts() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_del_daily_schedule_ts()
  RETURNS trigger AS
$BODY$
DECLARE
	p_schema_name varchar DEFAULT 'citydb'::varchar;
	deleted_id integer;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
deleted_id=citydb_pkg.nrg8_delete_daily_schedule(OLD.id, p_schema_name);
-- RAISE NOTICE 'Deleted record with id: %', deleted_id;
RETURN OLD;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_del_daily_schedule_ts (id: %): %', deleted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_INS_DAILY_SCHEDULE_TS
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.nrg8_tr_ins_daily_schedule_ts() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_ins_daily_schedule_ts()
  RETURNS trigger AS
$BODY$
DECLARE
	ts_id integer;
	inserted_id integer;
	p_schema_name varchar DEFAULT 'citydb'::varchar;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
ts_id=citydb_view.nrg8_insert_time_series(
classname            :=NEW.ts_classname            ,
id                   :=NEW.ts_id                   ,
gmlid                :=NEW.ts_gmlid                ,
gmlid_codespace      :=NEW.ts_gmlid_codespace      ,
name                 :=NEW.ts_name                 ,
name_codespace       :=NEW.ts_name_codespace       ,
description          :=NEW.ts_description          ,
acquisition_method   :=NEW.ts_acquisition_method   ,
interpolation_type   :=NEW.ts_interpolation_type   ,
quality_description  :=NEW.ts_quality_description  ,
source               :=NEW.ts_source               ,
time_array           :=NEW.ts_time_array           ,
values_array         :=NEW.ts_values_array         ,
values_unit          :=NEW.ts_values_unit          ,
array_length         :=NEW.ts_array_length         ,
temporal_extent_begin:=NEW.ts_temporal_extent_begin,
temporal_extent_end  :=NEW.ts_temporal_extent_end  ,
time_interval        :=NEW.ts_time_interval        ,
time_interval_unit   :=NEW.ts_time_interval_unit   ,
--
file_path            :=NEW.ts_file_path            ,
file_name            :=NEW.ts_file_name            ,
file_extension       :=NEW.ts_file_extension       ,
nbr_header_lines     :=NEW.ts_nbr_header_lines     ,
field_sep            :=NEW.ts_field_sep            ,
record_sep           :=NEW.ts_record_sep           ,
dec_symbol           :=NEW.ts_dec_symbol           ,
time_col_nbr         :=NEW.ts_time_col_nbr         ,
value_col_nbr        :=NEW.ts_value_col_nbr        ,
is_compressed        :=NEW.ts_is_compressed        ,
--
schema_name          :=p_schema_name
);
inserted_id=citydb_view.nrg8_insert_daily_schedule(
id                :=NEW.id,
day_type          :=NEW.day_type,
period_of_year_id :=NEW.period_of_year_id,
time_series_id    :=ts_id,
--
schema_name       :=p_schema_name
);
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_ins_daily_schedule_ts (id: %): %', inserted_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Function TR_UPD_DAILY_SCHEDULE_TS
----------------------------------------------------------------
DROP FUNCTION IF EXISTS    citydb_view.nrg8_tr_upd_daily_schedule_ts() CASCADE;
CREATE OR REPLACE FUNCTION citydb_view.nrg8_tr_upd_daily_schedule_ts()
  RETURNS trigger AS
$BODY$
DECLARE
  updated_id integer;
  p_schema_name varchar DEFAULT 'citydb'::varchar;
BEGIN
IF TG_ARGV[0] IS NOT NULL THEN
	p_schema_name=TG_ARGV[0];
END IF;
EXECUTE format('UPDATE %I.nrg8_time_series AS t SET
gmlid                =%L,
gmlid_codespace      =%L,
name                 =%L,
name_codespace       =%L,
description          =%L,
acquisition_method   =%L,
interpolation_type   =%L,
quality_description  =%L,
source               =%L,
time_array           =%L,
values_array         =%L,
values_unit          =%L,
array_length         =%L,
temporal_extent_begin=%L,
temporal_extent_end  =%L,
time_interval        =%L, 
time_interval_unit   =%L 
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.ts_gmlid,
NEW.ts_gmlid_codespace,
NEW.ts_name,
NEW.ts_name_codespace,
NEW.ts_description,	
NEW.ts_acquisition_method,
NEW.ts_interpolation_type,
NEW.ts_quality_description,
NEW.ts_source,
NEW.ts_time_array,
NEW.ts_values_array,
NEW.ts_values_unit,
NEW.ts_array_length,
NEW.ts_temporal_extent_begin,
NEW.ts_temporal_extent_end, 
NEW.ts_time_interval, 
NEW.ts_time_interval_unit, 
OLD.ts_id
) INTO updated_id;

IF OLD.ts_classname IN ('RegularTimeSeriesFile', 'IrregularTimeSeriesFile') THEN
	EXECUTE format('UPDATE %I.nrg8_time_series_file AS t SET
	file_path            =%L,
	file_name            =%L,
	file_extension       =%L,
	nbr_header_lines     =%L,
	field_sep            =%L,
	record_sep           =%L,
	dec_symbol           =%L,
	time_col_nbr         =%L,
	value_col_nbr        =%L,
	is_compressed        =%L
	WHERE t.id=%L RETURNING id',
	p_schema_name,
	NEW.ts_file_path,
	NEW.ts_file_name,
	NEW.ts_file_extension,
	NEW.ts_nbr_header_lines,
	NEW.ts_field_sep,
	NEW.ts_record_sep,
	NEW.ts_dec_symbol,
	NEW.ts_time_col_nbr,
	NEW.ts_value_col_nbr,
	NEW.ts_is_compressed,
	OLD.ts_id
	) INTO updated_id;
END IF;

EXECUTE format('UPDATE %I.nrg8_daily_schedule AS t SET
id                =%L,
day_type          =%L,
period_of_year_id =%L,
time_series_id    =%L
WHERE t.id=%L RETURNING id',
p_schema_name,
NEW.id,
NEW.day_type,
NEW.period_of_year_id,
OLD.ts_id,
OLD.id
) INTO updated_id;
-- RAISE NOTICE 'Updated record with id: %',updated_id;
RETURN NEW;
EXCEPTION
	WHEN OTHERS THEN RAISE NOTICE 'citydb_view.nrg8_tr_upd_daily_schedule_ts (id: %): %', updated_id, SQLERRM;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------
-- Triggers for view DAILY_SCHEDULE_TS
----------------------------------------------------------------
DROP TRIGGER IF EXISTS nrg8_tr_del_daily_schedule_ts ON citydb_view.nrg8_daily_schedule_ts;
CREATE TRIGGER nrg8_tr_del_daily_schedule_ts
	INSTEAD OF DELETE ON citydb_view.nrg8_daily_schedule_ts
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_del_daily_schedule_ts ('citydb');

DROP TRIGGER IF EXISTS nrg8_tr_ins_daily_schedule_ts ON citydb_view.nrg8_daily_schedule_ts;
CREATE TRIGGER nrg8_tr_ins_daily_schedule_ts
	INSTEAD OF INSERT ON citydb_view.nrg8_daily_schedule_ts
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_ins_daily_schedule_ts ('citydb');

DROP TRIGGER IF EXISTS nrg8_tr_upd_daily_schedule_ts ON citydb_view.nrg8_daily_schedule_ts;
CREATE TRIGGER nrg8_tr_upd_daily_schedule_ts
	INSTEAD OF UPDATE ON citydb_view.nrg8_daily_schedule_ts
	FOR EACH ROW
	EXECUTE PROCEDURE citydb_view.nrg8_tr_upd_daily_schedule_ts ('citydb');
--**************************************************************
--**************************************************************












































DO
$$
BEGIN
RAISE NOTICE '

********************************

Trigger functions for views installation complete!

********************************

';
END
$$;
SELECT 'Trigger functions for views installation complete!'::varchar AS installation_result;

-- ***********************************************************************
-- ***********************************************************************
--
-- END OF FILE
--
-- ***********************************************************************
-- ***********************************************************************

