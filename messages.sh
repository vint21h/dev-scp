#!/usr/bin/env sh

# dev-scp
# messages.sh

# Create and update gettext .po files, compile .mo files for django projects.
# WARNING: This script MUST run only from project root directory.
# Required args:
#    action: what to do. Defaults to: makemessages. Possible variants: makemessages, compilemessages.
#    name: project name. Defaults to: get from project "META/name.txt" or from basename.
# Args:
#    apps: list of comma separated project applications names. Defaults to: getting from project "META/messages/apps.txt".
#    libs: list of comma separated project libraries names. Defaults to: getting from project "META/messages/libs.txt".
#    languages: list of comma separated project languages. Defaults to: getting from project "META/messages/languages.txt".
#    settings: python path to project settings module. Defaults to: $NAME.settings.dev.
#    backend-extensions: list of comma separated files extensions which contains strings marked to translate on backend side. Defaults to: html,py,txt,email,json.
#    frontend-extensions: list of comma separated files extensions which contains strings marked to translate on frontend side. Defaults to: js.
#    backend-domain: backend gettext application domain name. Defaults to: django.
#    frontend-domain: frontend gettext application domain name. Defaults to: djangojs.


# global variables
ACTION=${1:-"makemessages"}
if [ -f ${PWD}/META/name.txt ]; then
    NAME=$(echo ${2:-`cat ${PWD}/META/name.txt | tr -d "\n"`})
else
    NAME=`basename $PWD`
fi
if [ -f ${PWD}/META/messages/apps.txt ]; then
    APPS=$(echo ${3:-`cat ${PWD}/META/messages/apps.txt`} | tr -d "\n" | tr "," "\n")
else
    APPS=()
fi
if [ -f ${PWD}/META/messages/libs.txt ]; then
    LIBS=$(echo ${4:-`cat ${PWD}/META/messages/libs.txt`} | tr -d "\n" | tr "," "\n")
else
    LIBS=()
fi
if [ -f ${PWD}/META/messages/languages.txt ]; then
    LANGUAGES=$(echo ${5:-`cat ${PWD}/META/messages/languages.txt`} | tr -d "\n" | tr "," "\n")
else
    LANGUAGES=()
fi
SETTINGS=${6:-${NAME}.settings.dev}
if [ -f ${PWD}/META/messages/backend-extensions.txt ]; then
    BACKEND_EXTENSIONS=$(echo ${7:-`cat ${PWD}/META/messages/backend-extensions.txt`})
else
    BACKEND_EXTENSIONS=html,py,txt,email,json
fi
if [ -f ${PWD}/META/messages/frontend-extensions.txt ]; then
    FRONTEND_EXTENSIONS=$(echo ${8:-`cat ${PWD}/META/messages/frontend-extensions.txt`})
else
    FRONTEND_EXTENSIONS=js
fi
BACKEND_DOMAIN=$(echo ${9:-django})
FRONTEND_DOMAIN=$(echo ${10:-djangojs})
MANAGE=${PWD}/manage.py
PDP=${PWD}  # project directory path


# creating and updating .po's files for project and it's apps.
if [ ${ACTION} = "makemessages" ]
then
# apps
for app in ${APPS}
do
    cd ${PDP}/${NAME}/apps/${app}/
    echo "Processing application:" ${app}
    for lang in ${LANGUAGES}
    do
        echo "Processing backend files..."
        ${MANAGE} makemessages -l ${lang} -e ${BACKEND_EXTENSIONS} -d ${BACKEND_DOMAIN} --settings=${SETTINGS}
        echo "Processing frontend files..."
        ${MANAGE} makemessages -l ${lang} -e ${FRONTEND_EXTENSIONS} -d ${FRONTEND_DOMAIN} --settings=${SETTINGS}
    done
done

# libs
for lib in ${LIBS}
do
    cd ${PDP}/${NAME}/lib/${lib}/
    echo "Processing library:" ${lib}
    for lang in ${LANGUAGES}
    do
        echo "Processing backend files..."
        ${MANAGE} makemessages -l ${lang} -e ${BACKEND_EXTENSIONS} -d ${BACKEND_DOMAIN} --settings=${SETTINGS}
        echo "Processing frontend files..."
        ${MANAGE} makemessages -l ${lang} -e ${FRONTEND_EXTENSIONS} -d ${FRONTEND_DOMAIN} --settings=${SETTINGS}
    done
done

# project
cd ${PDP}/${NAME}/
echo "Processing project": ${NAME}
for lang in ${LANGUAGES}
do
    echo "Processing backend files..."
    ${MANAGE} makemessages -l ${lang} -e ${BACKEND_EXTENSIONS} -d ${BACKEND_DOMAIN} --settings=${SETTINGS} --ignore=apps/* --ignore=lib/* --ignore=*env*/* --ignore=static/lib/*
    echo "Processing frontend files..."
    ${MANAGE} makemessages -l ${lang} -e ${FRONTEND_EXTENSIONS} -d ${FRONTEND_DOMAIN} --settings=${SETTINGS} --ignore=apps/* --ignore=lib/* --ignore=*env*/* --ignore=static/lib/*
done
fi

if [ ${ACTION} = "compilemessages" ]
then
    # compile .po's files
    ${MANAGE} compilemessages --settings=${SETTINGS}
fi
