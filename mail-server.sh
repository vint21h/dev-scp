#!/usr/bin/env sh

# dev-scp
# mail-server.sh

# Debugging mail server.
# Args:
#    host: listen host. Defaults to: 127.0.0.1.
#    port: listen port. Defaults to: 1025.


# global variables
HOST=${1:-"127.0.0.1"}
PORT=${1:-"1025"}

# run python SMTP server
python -m smtpd -n -c DebuggingServer ${HOST}:${PORT}
