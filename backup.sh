#!/bin/sh

# backup.sh

TIMESTAMP=$(date +%m.%d.%y-%H:%M)

if [ ${1} ];
then
#     ./clear.sh ${1}
#     ./dump-data.sh ${1}
#     ./makemessages.sh board en,ua
    echo Making backup...
    tar czvf ../bak/$TIMESTAMP.tar.gz ../${1}/  --exclude ../${1}/.hg/ --exclude ../${1}/media/ --exclude ../${1}-venv/
else
echo Usage ${0} %%project_name%%
    exit;
fi
