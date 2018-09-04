#!/usr/bin/env bash
#
# trim canonical stuff
#

set -e

logger() {
	DT=$(date '+%Y/%m/%d %H:%M:%S')
	echo "$DT clean-canonical-fat.sh: $1"
}

logger "Executing"

# so basically remove some stuff we do not want
logger 'Clean virtualization stuff'
DEBIAN_FRONTEND=noninteractive apt-get autoremove --purge -y lxc-common lxd lxd-client
rm -rf /var/lib/lxd

logger 'Remove snap and company'
DEBIAN_FRONTEND=noninteractive apt-get autoremove --purge -y snapd

logger 'Remove filesystem and hw tools'
DEBIAN_FRONTEND=noninteractive apt-get autoremove --purge -y \
	squashfs-tools xfsprogs btrfs-tools bcache-tools cpio dosfstools \
	dmeventd dmsetup lvm2 fuse libfuse2 gdisk hdparm makedev ntfs-3g \
	open-iscsi parted pciutils xfsprogs
rm -rf /etc/console-setup

logger 'Remove some libs'
DEBIAN_FRONTEND=noninteractive apt-get autoremove --purge -y \
		'liblvm2app*' 'libdevmapper-event*'

logger 'Remove unneeded utils'
DEBIAN_FRONTEND=noninteractive apt-get autoremove --purge -y \
	at apport apport-symptoms byobu screen tmux \
	command-not-found command-not-found-data dnsmasq-base dmidecode \
	ed eject ethtool friendly-recovery ifenslave info install-info manpages \
	mdadm mlocate popularity-contest pastebinit plymouth plymouth-theme-ubuntu-text \
	sosreport usbutils vlan xdg-user-dirs zerofree accountsservice acpid cryptsetup-bin \
	libeatmydata1 fonts-ubuntu-font-family-console ftp geoip-database kmod krb5-locales \
	libaccountsservice0 libatm1  libdrm-common libdrm2 libdumbnet1 libfribidi0 \
	libnetfilter-conntrack3 libnih1 libparted2 libx11-data libxau6 libxdmcp6 libusb-1.0-0 \
	lshw python3-problem-report ssh-import-id sgml-base xkb-data zip

logger 'Completed'
