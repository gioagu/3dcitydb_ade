-- This script is called from CREATE_DB_Metadata_module.bat
\pset footer off
SET client_min_messages TO WARNING;
\set ON_ERROR_STOP ON

\echo
\echo 'Installing the Metadata module functions'
\i postgresql/01_metadata_module_FUNCTIONS.sql

\echo
\echo 'Installing the Metadata module tables'
\i postgresql/02_metadata_module_TABLES.sql

\echo
\echo 'Installing the Metadata module table data'
\i postgresql/03_metadata_module_TABLE_DATA.sql

\echo
\echo '**********************************************************'
\echo
\echo 'Installation of the Metadata module for 3DcityDB complete!'
\echo
\echo '**********************************************************'
\echo
