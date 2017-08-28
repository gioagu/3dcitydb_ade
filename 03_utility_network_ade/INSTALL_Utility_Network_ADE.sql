-- This script is called from CREATE_DB_UtilityNetwork_ADE.bat
\pset footer off
SET client_min_messages TO WARNING;
\set ON_ERROR_STOP ON

\echo
\echo 'Installing the UtilityNetwork ADE functions'
\i postgresql/01_UtilityNetwork_ADE_FUNCTIONS.sql

\echo
\echo 'Installing the UtilityNetwork ADE tables'
\i postgresql/02_UtilityNetwork_ADE_DML_FUNCTIONS.sql

\echo
\echo 'Installing the UtilityNetwork ADE table data'
\i postgresql/03_UtilityNetwork_ADE_TABLES.sql

\echo
\echo 'Installing the UtilityNetwork ADE triggers'
\i postgresql/04_UtilityNetwork_ADE_TRIGGERS.sql

\echo
\echo 'Installing the UtilityNetwork ADE table data'
\i postgresql/05_UtilityNetwork_ADE_TABLE_DATA.sql

\echo
\echo 'Installing the UtilityNetwork ADE table data'
\i postgresql/06_UtilityNetwork_ADE_VIEWS.sql

\echo
\echo 'Installing the UtilityNetwork ADE table data'
\i postgresql/07_UtilityNetwork_ADE_VIEW_FUNCTIONS.sql

\echo
\echo 'Installing the UtilityNetwork ADE table data'
\i postgresql/08_UtilityNetwork_ADE_VIEW_TRIGGERS.sql


\echo
\echo '***********************************************************'
\echo
\echo 'Installation of UtilityNetwork ADE extension for 3DCityDB complete!'
\echo
\echo '***********************************************************'
\echo