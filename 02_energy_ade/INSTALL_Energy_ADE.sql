-- This script is called from CREATE_DB_Energy_ADE.bat
\pset footer off
SET client_min_messages TO WARNING;
\set ON_ERROR_STOP ON

\echo
\echo 'Installing the Energy ADE functions'
\i postgresql/01_Energy_ADE_FUNCTIONS.sql

\echo
\echo 'Installing the Energy ADE DML functions'
\i postgresql/02_Energy_ADE_DML_FUNCTIONS.sql

\echo
\echo 'Installing the Energy ADE tables'
\i postgresql/03_Energy_ADE_TABLES.sql

\echo
\echo 'Installing the Energy ADE triggers'
\i postgresql/04_Energy_ADE_TRIGGERS.sql

\echo
\echo 'Installing the Energy ADE table data'
\i postgresql/05_Energy_ADE_TABLE_DATA.sql

\echo
\echo 'Installing the Energy ADE views'
\i postgresql/06_Energy_ADE_VIEWS.sql

\echo
\echo 'Installing the Energy ADE view functions'
\i postgresql/07_Energy_ADE_VIEW_FUNCTIONS.sql

\echo
\echo 'Installing the Energy ADE view triggers'
\i postgresql/08_Energy_ADE_VIEW_TRIGGERS.sql


\echo
\echo '***********************************************************'
\echo
\echo 'Installation of Energy ADE extension for 3DCityDB complete!'
\echo
\echo '***********************************************************'
\echo