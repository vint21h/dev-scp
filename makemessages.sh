#!/bin/sh

# makemessages.sh

cd ../${1}
source ./${1}-venv/bin/activate # activate project virtualenv

lang_list=$(echo ${2} | tr "," "\n")

for lang in $lang_list
do
    ./manage.py makemessages -l $lang -e html,txt --ignore=${1}-venv/*
done
./manage.py compilemessage

