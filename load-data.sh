#!/bin/sh

# dump_sql.sh

echo 'Start restoring DB.'
echo 'Droping existing DB...'
dropdb ${1}
echo 'Creating new DB...'
createdb ${1}
echo 'Changing DB owner...'
psql -d ${1} -c "ALTER DATABASE ${1} OWNER TO ${1};"
echo 'Restoring  DB data...'
pg_restore -d ${1} ../${1}/tmp/${1}-data.sql
echo 'Restoring  DB complete.'
