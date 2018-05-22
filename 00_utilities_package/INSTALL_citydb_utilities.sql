-- This script is called from CREATE_DB_citydb_util.bat
\pset footer off
SET client_min_messages TO WARNING;
\set ON_ERROR_STOP ON

\echo
\echo 'Installing the citydb util functions'
\i postgresql/02_citydb_util_DML_FUNCTIONS.sql

\echo
\echo 'Installing the citydb util views'
\i postgresql/03_citydb_util_TABLES.sql

\echo
\echo 'Installing the citydb util views'
\i postgresql/05_citydb_util_TABLE_DATA.sql

\echo
\echo 'Installing the citydb util views'
\i postgresql/06_citydb_util_VIEWS.sql

\echo
\echo 'Installing the citydb util view functions'
\i postgresql/07_citydb_util_VIEW_FUNCTIONS.sql

\echo
\echo 'Installing the citydb util view functions'
\i postgresql/08_citydb_util_VIEW_TRIGGERS.sql

\echo
\echo '**********************************************************'
\echo
\echo 'Installation of the 3DcityDB Utilities Package complete!'
\echo
\echo '**********************************************************'
\echo
