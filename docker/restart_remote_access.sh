#!/bin/bash

ACCESS_PORT=${1:-9080}

# this line below is a generic approach
# PASSWD_HASH=$(caddy hash-password --plaintext $NEW_PASSWD)

# this method below only works on a system with blowfish set as password hashing method
# requires to change before running this script: /etc/pam.d/common-password: lines

# here are the per-package modules (the "Primary" block)
# password       [success=1 default=ignore]      pam_unix.so obscure sha512
# to
# password       [success=1 default=ignore]      pam_unix.so obscure blowfish

PASSWD_HASH=$(sudo cat /etc/shadow | grep $USER | cut -d ":" -f 2)

# restart processes
echo $NEW_PASSWD | sudo -S pkill -2 -f supervisord
echo "Please refresh all windows and log in with your new credentials."
HTTP_BASIC_AUTH_PASSWD_HASH=$PASSWD_HASH ACCESS_PORT=$ACCESS_PORT supervisord -c /etc/supervisord.conf > /dev/null 2>&1 &