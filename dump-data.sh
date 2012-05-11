#!/bin/sh

# dev-scp
# dump-data.sh

if [ ${1} ];
then
    echo 'Dumping DB structure in SQL...'
    pg_dump -s ${1} -f ../${1}/tmp/dumps/${1}-structure.sql -F t
    echo 'Dumping DB data in SQL...'
    pg_dump ${1} -f ../${1}/tmp/dumps/${1}-data.sql -F t
    echo 'Dumping DB data in JSON...'
    source ../${1}/${1}-venv/bin/activate # activate project virtualenv
    python ../${1}/manage.py dumpdata > ../${1}/tmp/dumps//${1}-data.json
else
    echo Usage ${0} %%project_name%%
    exit;
fi
