#!/bin/sh

# dump-data.sh

if [ -n ${1} ];
then
    echo 'Start dumping DB.'
    echo 'Dumping DB structure in SQL...'
    pg_dump -s ${1} -f ../${1}/tmp/${1}-structure.sql -F t
    echo 'Dumping DB data in SQL...'
    pg_dump ${1} -f ../${1}/tmp/${1}-data.sql -F t
    echo 'Dumping DB data in JSON...'
    source ../${1}/${1}-venv/bin/activate # activate project virtualenv
    python ../${1}/manage.py dumpdata > ../${1}/tmp/${1}-data.json
    echo 'Dumping DB complete.'
else
    echo Usage ${0} %%project_name%%
    exit;
fi