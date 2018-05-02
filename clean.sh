#!/usr/bin/env sh

# dev-scp
# clean.sh

# Recursive delete useless files by extensions and directories by masks.
# WARNING: This script MUST run only from project root directory.
# Args:
#    extensions: list of of comma separated files extensions to delete. Defaults to: pyc,pyo,bak,orig,~*,tmp.
#    dirs: list of of comma separated directories masks to delete. Defaults to: __pycache__.


# global variables
EXTENSIONS=$(echo ${1:-"pyc,pyo,bak,orig,~*"} | tr "," "\n")
DIRS=$(echo ${2:-"__pycache__"} | tr "," "\n")


for extension in ${EXTENSIONS}
do
    echo "Removing *."${extension}" ..."
    find -iname "*."${extension} -print0 | xargs -0 rm -rf
done

for dir in ${DIRS}
do
    echo "Removing "${dir}" ..."
    find -type d -name ${dir} -print0 | xargs -0 rm -rf
done
