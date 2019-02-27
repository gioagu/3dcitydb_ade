@ECHO OFF
set PGPORT=write here the port of the postgres server (e.g. 5432)
set PGHOST=write here the name/address of the host (e.g. localhost)
set PGUSER=write here the postgres user (e.g. postgres)
set CITYDB=write here the name of the database (e.g. my_database)
set PGBIN=write here the path to psql.exe (e.g. C:\Program Files\PostgreSQL\9.6\bin)

REM cd to path of the shell script
cd /d %~dp0
REM cd back to root folder
cd ..

"%PGBIN%\psql" -h %PGHOST% -p %PGPORT% -d "%CITYDB%" -U %PGUSER% -c "ALTER DATABASE %CITYDB% SET search_path TO citydb, citydb_pkg, public"

cd .\00_utilities_package
"%PGBIN%\psql" -h %PGHOST% -p %PGPORT% -d "%CITYDB%" -U %PGUSER% -f "INSTALL_citydb_utilities.sql"
cd ..
REM pause

cd .\01_metadata_module
"%PGBIN%\psql" -h %PGHOST% -p %PGPORT% -d "%CITYDB%" -U %PGUSER% -f "INSTALL_Metadata_module.sql"
cd ..
REM pause

cd .\02_energy_ade
"%PGBIN%\psql" -h %PGHOST% -p %PGPORT% -d "%CITYDB%" -U %PGUSER% -f "INSTALL_Energy_ADE.sql"
cd ..
REM pause

cd .\03_utility_network_ade
"%PGBIN%\psql" -h %PGHOST% -p %PGPORT% -d "%CITYDB%" -U %PGUSER% -f "INSTALL_Utility_Network_ADE.sql"
cd ..
REM pause

cd .\04_scenario_ade
"%PGBIN%\psql" -h %PGHOST% -p %PGPORT% -d "%CITYDB%" -U %PGUSER% -f "INSTALL_Scenario_ADE.sql"
cd ..
REM pause

cd .\05_simulation_package
"%PGBIN%\psql" -h %PGHOST% -p %PGPORT% -d "%CITYDB%" -U %PGUSER% -f "INSTALL_Simulation_PKG.sql"
cd ..
REM pause

@ECHO ON
pause
