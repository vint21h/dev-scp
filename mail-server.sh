#!/bin/sh

# mail-server.sh

python -m smtpd -n -c DebuggingServer localhost:${1}

