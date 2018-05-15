#!/bin/sh
# Shell script to install the Simulation PKG for the 3DCityDB
# on PostgreSQL/PostGIS

# Provide your database details here
export PGPORT=write here the port of the postgres server (e.g. 5432)
export PGHOST=write here the name/address of the host (e.g. localhost)
export PGUSER=write here the postgres user (e.g. postgres)
export CITYDB=write here the name of the database (e.g. vienna)
export PGBIN=write here the path to psql

# cd to path of the shell script
cd "$( cd "$( dirname "$0" )" && pwd )" > /dev/null

# Run INSTALL_Simulation_PKG.sql to install the Simulation PKG into the 3DCityDB instance
"$PGBIN/psql" -h $PGHOST -p $PGPORT -d "$CITYDB" -U $PGUSER -f "INSTALL_Simulation_PKG.sql"

echo Press enter to continue
read dummy
