#!/bin/bash

# Prevent running outside of the container
[[ "$DBHOST" = "" ]] && { echo "Not running inside the container!! ABORTING!"; exit 1; }

DB_CONNECTION="-u$DBUSER -p$DBPASS -h$DBHOST $DBNAME"

# Find the most recent dump file (-t flag for ls)
DUMPFILE=$(ls -t /var/www/html/dbs/*.sql.gz | head -n 1)

# Test the dump before importing. Exit if it fails.
gunzip -t $DUMPFILE || { echo "$DUMPFILE is corrupt! ABORTING!!"; exit 1; }

echo "Dropping all tables from $DBNAME@$DBHOST"
mysqldump $DB_CONNECTION --no-data --add-drop-table | grep ^DROP | pv - | mysql $DB_CONNECTION

# Perform the actual import, use pv to get a nice progressbar
echo "Importing $DUMPFILE into db: $DBNAME"
pv $DUMPFILE | zcat - | mysql $DB_CONNECTION
