#!/bin/sh
if [ $# -ne 1 ]; then
  cat 1>&2 <<EOF
Usage: $0 groupname
EOF
  exit 1
fi

group="$1"
if ! LANG=C yum grouplist -C "$group" | grep -q '^Installed Groups:'; then
  yum groupinstall -y "$group"
fi
