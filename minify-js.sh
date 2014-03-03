#!/bin/sh

# dev-scp
# minify-js.sh

# WARNING: This script MUST run from project root directory.
# Require one arg:
#     source: path to the file to minify.


# getting global variables
SOURCE=${1:-''}
OUTPUT=$(echo ${SOURCE%.*}).min.js

curl -s  -d compilation_level=SIMPLE_OPTIMIZATIONS -d output_format=text -d output_info=compiled_code --data-urlencode "js_code@${SOURCE}" http://closure-compiler.appspot.com/compile > $OUTPUT
