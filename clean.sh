#!/usr/bin/env bash

apt update
apt autoremove -y
apt clean all
find /var/lib/apt/lists -type f -delete
find /var/cache -type f -delete
find /var/log -type f -delete
find /tmp -type f -delete

exit 0
