#!/bin/sh

# dev-scp
# messages.sh

# WARNING: This script MUST run from project root directory.
# Require three positioned args:
#     first: project name (default - get from project 'meta/name.txt' or from basename).
#     second: action (default - makemessages), possible variants: makemessages, compilemessages. Makemessages always run compilemessages.
#     third: environment (default - dev), possible variants: dev, test.
# Also support more options:
#     fourth: apps (default - getting from project 'meta/apps.txt'): list of comma separated project applications names.
#     five: languages (default - getting from project 'meta/languages.txt'): list of comma separated project languages.
# Require project 'meta/name.txt' file.

# getting global variables
PPATH=$PWD
if [ -f $PWD/meta/name.txt ]; then
    NAME=$(echo ${1:-`cat $PWD/meta/name.txt | tr -d "\n"`})
else
    NAME=`basename $PWD`
fi
MANAGE=$PPATH/manage.py
ARCH=`arch`
ACTION=${2:-'makemessages'}
ENVIRONMENT=${3:-'dev'}
APPS=$(echo ${4:-`cat $PPATH/meta/apps.txt`} | tr -d "\n" | tr "," "\n")
LANGUAGES=$(echo ${5:-`cat $PPATH/meta/languages.txt`} | tr -d "\n" | tr "," "\n")

# enable virtualenv in dev end test env's
if [ $ENVIRONMENT == 'dev' ]
then
    source $PPATH/$NAME-venv_$ARCH/bin/activate
fi

if [ $ENVIRONMENT == 'test' ]
then
    source $PPATH/env/bin/activate
fi

# creating and updating .po's files for project and it's app, don't accept in test env.
if [ $ACTION == 'makemessages' ] && [ $ENVIRONMENT == 'dev' ]
then
# apps
for app in $APPS
do
    cd $PPATH/$NAME/apps/$app/
    echo 'processing application' $app
    for lang in $LANGUAGES
    do
        echo 'processing html, py, txt'
        $MANAGE makemessages -l $lang -e html,py,txt -d django --settings=$NAME.settings.$ENVIRONMENT
        echo 'processing js'
        $MANAGE makemessages -l $lang -e js -d djangojs --settings=$NAME.settings.$ENVIRONMENT
    done
done

cd $PPATH/$NAME/
echo 'processing project'
for lang in $LANGUAGES
do
    echo 'processing html, py, txt'
    $MANAGE makemessages -l $lang -e html,py,txt -d django --settings=$NAME.settings.$ENVIRONMENT --ignore=apps/* --ignore=*env*/* --ignore=static/lib/*
    echo 'processing js'
    $MANAGE makemessages -l $lang -e js -d djangojs --settings=$NAME.settings.$ENVIRONMENT --ignore=apps/* --ignore=*env*/* --ignore=static/lib/*
done
fi

if [ $ACTION == 'compilemessages' ]
then
    # complile .po's files
    $MANAGE compilemessages --settings=$NAME.settings.$ENVIRONMENT
fi
