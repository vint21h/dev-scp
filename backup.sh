#!/bin/sh

# backup.sh

TIMESTAMP=$(date +%m.%d.%y-%H:%M)

if [ ${1} ];
then
    ./clear.sh ${1}
    ./dump-data.sh ${1}
    ./makemessages.sh board en,ua
    echo Making backup...
    cd ../${1}
    tar czvf ../bak/${1}-src-$TIMESTAMP.tar.gz --exclude .hg --exclude .idea --exclude media --exclude ${1}-venv  .
    cd ./media
    tar czvf ../../bak/${1}-media-$TIMESTAMP.tar.gz .
    echo Done
else
echo Usage ${0} %%project_name%%
    exit;
fi
