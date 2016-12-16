#!/usr/bin/env sh

# dev-scp
# messages.sh

# Create and update gettext .po files, compile .mo files for django projects.
# WARNING: This script MUST run only from project root directory.
# Require two positioned args:
#    first: action (default - makemessages), possible variants: makemessages, compilemessages.
#    second: project name (default - get from project "META/name.txt" or from basename).
# Also support more options:
#    third: apps (default - getting from project "META/apps.txt"): list of comma separated project applications names.
#    fourth: libs (default - getting from project "META/libs.txt"): list of comma separated project libraries names.
#    five: languages (default - getting from project "META/languages.txt"): list of comma separated project languages.
#    six: python path to project settings module (default - $NAME.settings.dev).

# global variables
ACTION=${1:-"makemessages"}
if [ -f $PWD/META/name.txt ]; then
    NAME=$(echo ${2:-`cat $PWD/META/name.txt | tr -d "\n"`})
else
    NAME=`basename $PWD`
fi
if [ -f $PWD/META/apps.txt ]; then
    APPS=$(echo ${3:-`cat $PWD/META/apps.txt`} | tr -d "\n" | tr "," "\n")
else
    APPS=()
fi
if [ -f $PWD/META/libs.txt ]; then
    LIBS=$(echo ${4:-`cat $PWD/META/libs.txt`} | tr -d "\n" | tr "," "\n")
else
    LIBS=()
fi
if [ -f $PWD/META/languages.txt ]; then
    LANGUAGES=$(echo ${5:-`cat $PWD/META/languages.txt`} | tr -d "\n" | tr "," "\n")
else
    LANGUAGES=()
fi
SETTINGS=${6:-$NAME.settings.dev}
MANAGE=$PWD/manage.py
PDP=$PWD  # project directory path


# creating and updating .po's files for project and it's apps.
if [ $ACTION = "makemessages" ]
then
# apps
for app in $APPS
do
    cd $PDP/$NAME/apps/$app/
    echo "Processing application:" $app
    for lang in $LANGUAGES
    do
        echo "Processing: *.html, *.py, *.txt"
        $MANAGE makemessages -l $lang -e html,py,txt,email -d django --settings=$SETTINGS
        echo "Processing: *.js"
        $MANAGE makemessages -l $lang -e js -d djangojs --settings=$SETTINGS
    done
done

# libs
for lib in $LIBS
do
    cd $PDP/$NAME/lib/$lib/
    echo "Processing library:" $lib
    for lang in $LANGUAGES
    do
        echo "Processing: *.html, *.py, *.txt"
        $MANAGE makemessages -l $lang -e html,py,txt,email -d django --settings=$SETTINGS
        echo "Processing: *.js"
        $MANAGE makemessages -l $lang -e js -d djangojs --settings=$SETTINGS
    done
done

# project
cd $PDP/$NAME/
echo "Processing project": $NAME
for lang in $LANGUAGES
do
    echo "Processing: *.html, *.py, *.txt"
    $MANAGE makemessages -l $lang -e html,py,txt,email -d django --settings=$SETTINGS --ignore=apps/* --ignore=lib/* --ignore=*env*/* --ignore=static/lib/*
    echo "Processing: *.js"
    $MANAGE makemessages -l $lang -e js -d djangojs --settings=$SETTINGS --ignore=apps/* --ignore=lib/* --ignore=*env*/* --ignore=static/lib/*
done
fi

if [ $ACTION = "compilemessages" ]
then
    # complile .po's files
    $MANAGE compilemessages --settings=$SETTINGS
fi
