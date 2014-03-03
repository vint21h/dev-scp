#!/bin/sh

# dev-scp
# makemessages.sh

if [ ${1} ];
then
    cd ../${1}
    source ./${1}-venv/bin/activate # activate project virtualenv

    lang_list=$(echo ${2} | tr "," "\n")

    for lang in $lang_list
    do
        ./manage.py makemessages -l $lang -e html,txt,js --ignore=${1}-venv/* --ignore=data/* -d django
    done
    ./manage.py compilemessages
else
    echo Usage ${0} %%project_name%%
    exit;
fi
