#!/bin/sh

# dev-scp
# mail-server.sh

python -m smtpd -n -c DebuggingServer localhost:${1}
