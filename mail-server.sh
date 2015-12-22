#!/bin/sh

# dev-scp
# mail-server.sh

# Debugging mail server.
# Receive two positioned args: host and port.

HOST=${1:-'127.0.0.1'}
PORT=${1:-'1025'}

# run python SMTP server
python -m smtpd -n -c DebuggingServer $HOST:$PORT
