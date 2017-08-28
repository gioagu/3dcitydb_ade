REM Shell script to install the Metadata module for the 3DCityDB
REM on PostgreSQL/PostGIS

REM Provide your database details here
set PGPORT=write here the port of the postgres server (e.g. 5432)
set PGHOST=write here the name/address of the host (e.g. localhost)
set PGUSER=write here the postgres user (e.g. postgres)
set CITYDB=write here the name of the database (e.g. vienna)
set PGBIN=write here the path to psql.exe (e.g C:\Program Files\PostgreSQL\9.6\bin)

REM cd to path of the shell script
cd /d %~dp0

REM Run INSTALL_Metadata_module.sql to add the Metadata module to the 3DCityDB instance
"%PGBIN%\psql" -h %PGHOST% -p %PGPORT% -d "%CITYDB%" -U %PGUSER% -f "INSTALL_Metadata_module.sql"
pause