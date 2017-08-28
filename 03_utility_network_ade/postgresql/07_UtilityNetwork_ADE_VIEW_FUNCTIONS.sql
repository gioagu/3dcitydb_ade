-- 3D City Database extension for the UtilityNetworks ADE v. 0.9
--
--                     BETA 1, August 2017
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
-- ************** 07_UtilityNetworks_ADE_VIEW_FUNCTIONS.sql **************
--
-- This script adds stored procedured to schema citydb_view. They are all
-- prefixed with "utn9_".
--
-- ***********************************************************************
-- ***********************************************************************

----------------------------------------------------------------
-- DROP existing prefixed insert functions
----------------------------------------------------------------
DO $$
DECLARE
db_schema varchar DEFAULT 'citydb_view'::varchar;
db_prefix varchar DEFAULT 'utn9'::varchar;
func_prefix varchar DEFAULT 'insert'::varchar;
db_prefix_length integer;
test integer DEFAULT NULL;
rec RECORD;
BEGIN
db_prefix_length=char_length(db_prefix) + 1 + char_length(func_prefix::varchar);
-- Check whether there are any prefixed functions to drop at all!
EXECUTE format('SELECT 1 FROM information_schema.routines WHERE routine_type=''FUNCTION'' AND routine_schema=%L AND substring(routine_name, 1, %L::integer)=%L||''_''||%L LIMIT 1', db_schema, db_prefix_length, db_prefix, func_prefix) INTO test;
IF test IS NOT NULL AND test=1 THEN
	RAISE INFO 'Removing all % functions with db_prefix "%" in schema %',  func_prefix, db_prefix, db_schema;
	FOR rec IN EXECUTE format('SELECT proname || ''('' || oidvectortypes(proargtypes) || '')'' AS function_name
	FROM pg_proc INNER JOIN pg_namespace ns ON (pg_proc.pronamespace = ns.oid)
	WHERE ns.nspname = %L AND substring(proname, 1, %L::integer)=%L||''_''||%L ORDER BY proname', db_schema, db_prefix_length, db_prefix, func_prefix) LOOP
		--RAISE NOTICE 'Dropping FUNCTION citydb_view.%',rec.function_name;
		EXECUTE 'DROP FUNCTION IF EXISTS ' || db_schema ||'.' || rec.function_name || ' CASCADE';
	END LOOP;
ELSE
	-- RAISE INFO '-- No functions to delete';
END IF;
END $$;

----------------------------------------------------------------
-- DROP existing prefixed delete functions
----------------------------------------------------------------
DO $$
DECLARE
db_schema varchar DEFAULT 'citydb_view'::varchar;
db_prefix varchar DEFAULT 'utn9'::varchar;
func_prefix varchar DEFAULT 'delete'::varchar;
db_prefix_length integer;
test integer DEFAULT NULL;
rec RECORD;
BEGIN
db_prefix_length=char_length(db_prefix) + 1 + char_length(func_prefix::varchar);
-- Check whether there are any prefixed functions to drop at all!
EXECUTE format('SELECT 1 FROM information_schema.routines WHERE routine_type=''FUNCTION'' AND routine_schema=%L AND substring(routine_name, 1, %L::integer)=%L||''_''||%L LIMIT 1', db_schema, db_prefix_length, db_prefix, func_prefix) INTO test;
IF test IS NOT NULL AND test=1 THEN
	RAISE INFO 'Removing all % functions with db_prefix "%" in schema %',  func_prefix, db_prefix, db_schema;
	FOR rec IN EXECUTE format('SELECT proname || ''('' || oidvectortypes(proargtypes) || '')'' AS function_name
	FROM pg_proc INNER JOIN pg_namespace ns ON (pg_proc.pronamespace = ns.oid)
	WHERE ns.nspname = %L AND substring(proname, 1, %L::integer)=%L||''_''||%L ORDER BY proname', db_schema, db_prefix_length, db_prefix, func_prefix) LOOP
		--RAISE NOTICE 'Dropping FUNCTION citydb_view.%',rec.function_name;
		EXECUTE 'DROP FUNCTION IF EXISTS ' || db_schema ||'.' || rec.function_name || ' CASCADE';
	END LOOP;
ELSE
	-- RAISE INFO '-- No functions to delete';
END IF;
END $$;


-- ***********************************************************************
-- ***********************************************************************

DO
$$
BEGIN
RAISE NOTICE '

********************************

UtilityNetworks ADE view functions installation complete!

********************************

';
END
$$;
SELECT 'UtilityNetworks ADE view functions installed correctly!'::varchar AS installation_result;


-- ***********************************************************************
-- ***********************************************************************
--
-- END OF FILE
--
-- ***********************************************************************
-- ***********************************************************************