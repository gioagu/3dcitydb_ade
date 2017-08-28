REM Shell script to install the 3DCityDB Utilities Package
REM on PostgreSQL/PostGIS

REM Provide your database details here
set PGPORT=write here the port of the postgres server (e.g. 5432)
set PGHOST=write here the name/address of the host (e.g. localhost)
set PGUSER=write here the postgres user (e.g. postgres)
set CITYDB=write here the name of the database (e.g. vienna)
set PGBIN=write here the path to psql.exe (e.g C:\Program Files\PostgreSQL\9.6\bin)

REM cd to path of the shell script
cd /d %~dp0

REM Run INSTALL_citydb_util.sql to add the 3DCityDB utilities to the 3DCityDB instance
"%PGBIN%\psql" -h %PGHOST% -p %PGPORT% -d "%CITYDB%" -U %PGUSER% -c "ALTER DATABASE %CITYDB% SET search_path TO citydb, citydb_pkg, public"
"%PGBIN%\psql" -h %PGHOST% -p %PGPORT% -d "%CITYDB%" -U %PGUSER% -f "INSTALL_citydb_utilities.sql"
pause