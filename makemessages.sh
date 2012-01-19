#!/bin/sh

# makemessages.sh

cd ../${1}
source ./${1}-venv/bin/activate # activate project virtualenv

lang_list=$(echo ${2} | tr "," "\n")

for lang in $lang_list
do
<<<<<<< HEAD
    ./manage.py makemessages -l $lang -e html,txt,js --ignore=${1}-venv/* --ignore=data/* -d django
=======
    ./manage.py makemessages -l $lang -e html,txt,js --ignore=${1}-venv/* --ignore=data/ -d django
>>>>>>> a3ebd760e96b0b5c6dd7ac0f6b6e421f95aac1b7
    
done
./manage.py compilemessages

