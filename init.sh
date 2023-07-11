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

sudo apt update && sudo apt upgrade

sudo apt install git docker docker-compose ca-certificates syslog-ng syslog-ng-core \
	syslog-ng-scl fail2ban

cp .bashrc /root
cp .vimrc /boot
cp fail2ban.local /etc/fail2ban/
cp jail.local /etc/fail2ban/
