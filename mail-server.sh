#!/bin/sh

# dev-scp
# mail-server.sh

# Debugging mail server.
# Always run on 127.0.0.1 IP address.
# Require one arg:
#    port: listen port (default - 1025).

# global variables
PORT=${1:-'1025'}

# run python SMTP server
python -m smtpd -n -c DebuggingServer 127.0.0.1:$PORT
