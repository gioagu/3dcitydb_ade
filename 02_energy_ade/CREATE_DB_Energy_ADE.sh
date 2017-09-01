#!/bin/sh
# Shell script to install the Metadata module for the 3DCityDB
# on PostgreSQL/PostGIS

# Provide your database details here
export PGPORT=5432
export PGHOST=localhost
export PGUSER=user
export CITYDB=unade_3dcitydb
export PGBIN=/usr/bin

# cd to path of the shell script
cd "$( cd "$( dirname "$0" )" && pwd )" > /dev/null

# Run INSTALL_Energy_ADE.sql to install the Energy ADE extension into the 3DCityDB instance
"$PGBIN/psql" -h $PGHOST -p $PGPORT -d "$CITYDB" -U $PGUSER -f "INSTALL_Energy_ADE.sql"

echo Press enter to continue
read dummy
