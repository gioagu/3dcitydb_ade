-- This script is called from CREATE_DB_Simulation_PKG.bat (or .sh)
\pset footer off
SET client_min_messages TO WARNING;
\set ON_ERROR_STOP ON

\echo
\echo 'Installing the Simulation PKG functions'
\i postgresql/01_Simulation_PKG_FUNCTIONS.sql

\echo
\echo 'Installing the Simulation PKG functions'
\i postgresql/02_Simulation_PKG_DML_FUNCTIONS.sql

\echo
\echo 'Installing the Simulation PKG tables'
\i postgresql/03_Simulation_PKG_TABLES.sql

\echo
\echo 'Installing the Simulation PKG tables'
\i postgresql/06_Simulation_PKG_VIEWS.sql

\echo
\echo '***********************************************************'
\echo
\echo 'Installation of Simulation PKG extension for 3DCityDB complete!'
\echo
\echo '***********************************************************'
\echo