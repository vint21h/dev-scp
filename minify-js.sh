#!/usr/bin/env sh

# dev-scp
# minify-js.sh

# Minify JavaScript files.
# Required args:
#    source: path to the file to minify.


# global variables
SOURCE=${1:-""}
OUTPUT=$(echo ${SOURCE%.*}).min.js


if [ -f ${SOURCE} ]; then
    curl -s  -d compilation_level=SIMPLE_OPTIMIZATIONS -d output_format=text -d output_info=compiled_code --data-urlencode "js_code@${SOURCE}" http://closure-compiler.appspot.com/compile > ${OUTPUT}
else
    exit
fi
