#!/usr/bin/env sh

# dev-scp
# clear.sh

# Recursive delete useless files.
# Require one arg:
#    extensions: list of of comma separated files extensions to delete (default - pyc,pyo,bak,orig,~*,tmp).

# global variables
EXTENSIONS=$(echo ${1:-'pyc,pyo,bak,orig,~*'} | tr "," "\n")


for extension in $EXTENSIONS
do
    echo 'Removing *.'$extension' ...'
    find -iname '*.'$extension -print0 | xargs -0 rm -rf
done
