#!/bin/sh

# dump-data.sh

if [ ${1} ];
then

    if [ ! -e ../${1}/tmp/${1}-data.sql ];
	then
	echo File does not exist.
        exit;
    fi
    echo 'Start restoring DB.'
    echo 'Droping existing DB...'
    dropdb ${1}
    echo 'Creating new DB...'
    createdb ${1}
    echo 'Changing DB owner...'
    psql -d ${1} -c "ALTER DATABASE ${1} OWNER TO ${1};"
    echo 'Restoring  DB data...'
    pg_restore -d ${1} ../${1}/tmp/dumps/${1}-data.sql
    echo 'Restoring  DB complete.'
    else
	echo Usage ${0} %%project_name%%
	exit;
fi
