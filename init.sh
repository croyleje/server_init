#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "ERROR: script must be run as root"
  exit 1
fi

getent passwd | \
grep -vE '(nologin|false)$' | \
awk -F: -v min=`awk '/^UID_MIN/ {print $2}' /etc/login.defs` \
-v max=`awk '/^UID_MAX/ {print $2}' /etc/login.defs` \
'{if(($3 >= min)&&($3 <= max)) print $1}' | \
sort -u

cp .bashrc /root
cp .vimrc /boot
