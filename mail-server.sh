#!/bin/sh

# dev-scp
# mail-server.sh

# Debugging mail server.
# Require one positioned arg: port.
# Always run on loopback address.

# global variables
PORT=${1:-'1025'}

# run python SMTP server
python -m smtpd -n -c DebuggingServer 127.0.0.1:$PORT
