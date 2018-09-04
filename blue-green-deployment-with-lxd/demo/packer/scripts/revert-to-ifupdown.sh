#!/usr/bin/env bash
#
# trim canonical stuff
#

set -e

logger() {
	DT=$(date '+%Y/%m/%d %H:%M:%S')
	echo "$DT revert-to-ifupdown.sh: $1"
}

logger "Executing"

logger 'Install ifupdown and nuke netplan'
DEBIAN_FRONTEND=noninteractive apt-get install -y \
	ifupdown resolvconf

DEBIAN_FRONTEND=noninteractive apt-get autoremove --purge -y \
	netplan.io nplan

cp /ops/config/etc-network-interfaces /etc/network/interfaces

rm -rf /usr/share/netplan /etc/netplan

logger 'Completed'
