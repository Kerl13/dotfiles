#!/bin/sh

set -euC

TIMEOUT=5

get_pass_id () {
  keyctl request user keepasspass 2>/dev/null || \
  {
    stty -echo
    read -r PASSWORD
    stty echo
    printf '\n'
    ID="$(keyctl add user keepasspass "$PASSWORD" @u)"
    keyctl timeout "$ID" "$TIMEOUT"
    echo "$ID"
  }
}

usage () {
  cat << EOF
usage: $0 DATABASE TITLE

Retrieve a password from a Keepass database file.

DATABASE path to the database
TITLE    title of a password entry
EOF
  exit 1
}

if [ $# != 2 ]; then usage; fi
KPPASS="$(keyctl print "$(get_pass_id)")"
printf '%s' "$KPPASS" | python ~/.local/bin/kpfind.py "$1" "$2"
