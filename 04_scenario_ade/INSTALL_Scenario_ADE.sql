-- This script is called from CREATE_DB_Scenario_ADE.bat
\pset footer off
SET client_min_messages TO WARNING;
\set ON_ERROR_STOP ON

\echo
\echo 'Installing the Scenario ADE functions'
\i postgresql/01_Scenario_ADE_FUNCTIONS.sql

\echo
\echo 'Installing the Scenario ADE tables'
\i postgresql/02_Scenario_ADE_DML_FUNCTIONS.sql

\echo
\echo 'Installing the Scenario ADE table data'
\i postgresql/03_Scenario_ADE_TABLES.sql

\echo
\echo 'Installing the Scenario ADE triggers'
\i postgresql/04_Scenario_ADE_TRIGGERS.sql

\echo
\echo 'Installing the Scenario ADE table data'
\i postgresql/05_Scenario_ADE_TABLE_DATA.sql

\echo
\echo 'Installing the Scenario ADE table data'
\i postgresql/06_Scenario_ADE_VIEWS.sql

\echo
\echo 'Installing the Scenario ADE table data'
\i postgresql/07_Scenario_ADE_VIEW_FUNCTIONS.sql

\echo
\echo 'Installing the Scenario ADE table data'
\i postgresql/08_Scenario_ADE_VIEW_TRIGGERS.sql


\echo
\echo '***********************************************************'
\echo
\echo 'Installation of Scenario ADE extension for 3DCityDB complete!'
\echo
\echo '***********************************************************'
\echo