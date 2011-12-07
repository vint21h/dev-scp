#!/bin/sh

# clear.sh

cd ../${1}

echo 'Removing *.pyc ...'
find -iname '*.pyc' -print0 | xargs -0 rm -rf
echo 'Removing *.orig ...'
find -iname '*.orig' -print0 | xargs -0 rm -rf

