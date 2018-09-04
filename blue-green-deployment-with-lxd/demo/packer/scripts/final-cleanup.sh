#!/usr/bin/env bash
set -e

logger() {
	DT=$(date '+%Y/%m/%d %H:%M:%S')
	echo "$DT final-cleanup.sh: $1"
}

logger "Executing"

logger "Cleanup"
DEBIAN_FRONTEND=noninteractive apt-get -y dist-upgrade
DEBIAN_FRONTEND=noninteractive apt-get -y autoremove --purge
apt-get -y clean

## zero out logs
cp /dev/null /var/log/alternatives.log
cp /dev/null /var/log/bootstrap.log
cp /dev/null /var/log/dpkg.log
cp /dev/null /var/log/apt/history.log
cp /dev/null /var/log/apt/term.log

## temp files
rm -rf /tmp/* /var/tmp/*

# build artifacts
rm -rf /ops

## apt / dpkg related
rm -rf /var/lib/apt/lists/*
rm -rf /var/lib/dpkg/*-old

## machine speciffic files
rm -f /etc/ssh/ssh_host_*

## we need no docs/man/info
rm -rf /usr/share/man/* /usr/share/info/* /usr/share/doc/*
echo 'All documentation has been removed' > /usr/share/doc/README
echo 'All documentation has been removed' > /usr/share/man/README
echo 'All documentation has been removed' > /usr/share/info/README

logger "Completed"
