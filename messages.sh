#!/bin/sh

# dev-scp
# messages.sh

# WARNING: This and all deploy helpers scripts MUST run from project root directory.
# Require two positioned args:
#     first: action (default - makemessages), possible variants: makemessages, compilemessages. Makemessages always run compilemessages.
#     second: environment (default - dev), possible variants: dev, test, production.
# Also support more options:
#     third: apps (default - getting from project 'meta/apps.txt'): list of comma separated project applications names.
#     fourth: languages (default - getting from project 'meta/languages.txt'): list of comma separated project languages.
# Strong require project 'meta/project-name.txt' file.

PROJECT_PATH=$PWD
PROJECT_NAME=`cat $PWD/meta/project-name.txt | tr -d "\n"`
SCRIPT=$(readlink -f $0)
SCRIPTS_PATH=`dirname $SCRIPT`
MANAGE_PY=$PROJECT_PATH/manage.py

ARCH=`arch`
MAKE=${1:-'makemessages'}
ENVIRONMENT=${2:-'dev'}
APPS=$(echo ${3:-`cat $PROJECT_PATH/meta/apps.txt`} | tr -d "\n" | tr "," "\n")
LANGUAGES=$(echo ${4:-`cat $PROJECT_PATH/meta/languages.txt`} | tr -d "\n" | tr "," "\n")

source $PROJECT_PATH/$PROJECT_NAME-venv_$ARCH/bin/activate

# creating and updating .po's files for project and it's app
if [ $ENVIRONMENT == 'dev' ] || [ $MAKE == 'makemessages' ]
then
# apps
for app in $APPS
do
    cd $PROJECT_PATH/$PROJECT_NAME/apps/$app/
    echo 'processing application' $app
    for lang in $LANGUAGES
    do
        echo 'processing html, py, txt'
        $MANAGE_PY makemessages -l $lang -e html,py,txt -d django --settings=$PROJECT_NAME.settings.$ENVIRONMENT
        echo 'processing js'
        $MANAGE_PY makemessages -l $lang -e js -d djangojs --settings=$PROJECT_NAME.settings.$ENVIRONMENT
    done
done

cd $PROJECT_PATH/$PROJECT_NAME/
echo 'processing project'
for lang in $LANGUAGES
do
    echo 'processing html, py, txt'
    $MANAGE_PY makemessages -l $lang -e html,py,txt -d django --settings=$PROJECT_NAME.settings.$ENVIRONMENT --ignore=apps/* --ignore=*env*/* --ignore=static/lib/*
    echo 'processing js'
    $MANAGE_PY makemessages -l $lang -e js -d djangojs --settings=$PROJECT_NAME.settings.$ENVIRONMENT --ignore=apps/* --ignore=*env*/* --ignore=static/lib/*
done
fi

# complile .po's files
$MANAGE_PY compilemessages --settings=$PROJECT_NAME.settings.$ENVIRONMENT
