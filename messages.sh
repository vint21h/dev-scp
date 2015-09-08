#!/bin/sh

# dev-scp
# messages.sh

# WARNING: This script MUST run from project root directory.
# Require two positioned args:
#     first: project name (default - get from project 'meta/name' or from basename).
#     second: action (default - makemessages), possible variants: makemessages, compilemessages. Makemessages always run compilemessages.
# Also support more options:
#     third: apps (default - getting from project 'meta/apps'): list of comma separated project applications names.
#     fourth: languages (default - getting from project 'meta/languages'): list of comma separated project languages.
#     five: python path to project settings file.
# Require project 'meta/name' file.

# getting global variables
PPATH=$PWD  # project path
if [ -f $PWD/META/name.txt ]; then
    NAME=$(echo ${1:-`cat $PWD/META/name.txt | tr -d "\n"`})
else
    NAME=`basename $PWD`
fi
MANAGE=$PPATH/manage.py
ARCH=`arch`
ACTION=${2:-'makemessages'}
APPS=$(echo ${3:-`cat $PPATH/META/apps.txt`} | tr -d "\n" | tr "," "\n")
LANGUAGES=$(echo ${4:-`cat $PPATH/META/languages.txt`} | tr -d "\n" | tr "," "\n")
SETTINGS=${5:-$NAME.settings.dev}

# enable virtualenv
source $PPATH/.env/$ARCH/bin/activate

# creating and updating .po's files for project and it's apps.
if [ $ACTION == 'makemessages' ]
then
# apps
for app in $APPS
do
    cd $PPATH/$NAME/apps/$app/
    echo 'Processing application:' $app
    for lang in $LANGUAGES
    do
        echo 'Processing: *.html, *.py, *.txt'
        $MANAGE makemessages -l $lang -e html,py,txt -d django --settings=$SETTINGS
        echo 'Processing: *.js'
        $MANAGE makemessages -l $lang -e js -d djangojs --settings=$SETTINGS
    done
done

cd $PPATH/$NAME/
echo 'Processing project': $NAME
for lang in $LANGUAGES
do
    echo 'Processing: *.html, *.py, *.txt'
    $MANAGE makemessages -l $lang -e html,py,txt -d django --settings=$SETTINGS --ignore=apps/* --ignore=*env*/* --ignore=static/lib/*
    echo 'Processing: *.js'
    $MANAGE makemessages -l $lang -e js -d djangojs --settings=$SETTINGS --ignore=apps/* --ignore=*env*/* --ignore=static/lib/*
done
fi

if [ $ACTION == 'compilemessages' ]
then
    # complile .po's files
    $MANAGE compilemessages --settings=$SETTINGS
fi
