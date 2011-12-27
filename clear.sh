#!/bin/sh

# clear.sh

if [ ${1} ];
then
    cd ../${1}

    echo 'Removing *.pyc ...'
    find -iname '*.pyc' -print0 | xargs -0 rm -rf
    echo 'Removing *.orig ...'
    find -iname '*.orig' -print0 | xargs -0 rm -rf
else
    echo Usage ${0} %%project_name%%
    exit;
fi
