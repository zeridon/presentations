#!/usr/bin/env bash
#
# trim canonical stuff
#

set -e

logger() {
	DT=$(date '+%Y/%m/%d %H:%M:%S')
	echo "$DT prepare.sh: $1"
}

logger "Executing"

# let's wait a bit for dns/net to settle (seems too fast)
logger "Waiting for network"
_breaker=0
until $(curl --output /dev/null --silent --head --fail https://google.com); do
	printf '.'
	sleep 1
	_breaker=$((_breaker+1))
	if [[ ${_breaker} -gt 100 ]] ; then
		logger "No network available. Bailing out"
		exit -9
	fi
done

# prety
echo ''

# do some speedups
if [[ ! -e /etc/dpkg/dpkg.cfg.d/container-apt-speedup ]]; then
	echo 'force-unsafe-io' > /etc/dpkg/dpkg.cfg.d/container-apt-speedup
fi

if [[ ! -e /etc/apt/apt.conf.d/container-norecommend ]]; then
	echo 'APT::Install-Recommends "0";' > /etc/apt/apt.conf.d/container-norecommend
	echo 'APT::Install-Suggests "0";' >> /etc/apt/apt.conf.d/container-norecommend
fi

## Enable Ubuntu Universe, Multiverse, and deb-src for main.
sed -i 's/^#\s*\(deb.*main restricted\)$/\1/g' /etc/apt/sources.list
sed -i 's/^#\s*\(deb.*universe\)$/\1/g' /etc/apt/sources.list
sed -i 's/^#\s*\(deb.*multiverse\)$/\1/g' /etc/apt/sources.list
DEBIAN_FRONTEND=noninteractive apt-get update

## Prevent initramfs updates from trying to run grub and lilo.
## https://journal.paul.querna.org/articles/2013/10/15/docker-ubuntu-on-rackspace/
## http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=594189
export INITRD=no
mkdir -p /etc/container_environment
echo -n no > /etc/container_environment/INITRD

## install localepurge for minimal size
## preset configs
echo 'localepurge	localepurge/nopurge	multiselect	en_US, en_US.ISO-8859-15, en_US.UTF-8' | debconf-set-selections
echo 'localepurge	localepurge/dontbothernew	boolean	false' | debconf-set-selections
echo 'localepurge	localepurge/mandelete	boolean	true' | debconf-set-selections
echo 'localepurge	localepurge/use-dpkg-feature	boolean	false' | debconf-set-selections
echo 'localepurge	localepurge/showfreedspace	boolean	false' | debconf-set-selections
echo 'localepurge	localepurge/verbose	boolean	false' | debconf-set-selections

DEBIAN_FRONTEND=noninteractive apt-get install -y localepurge

## nuke locales
localepurge -v

## set back to dpkg (no need to install)
echo 'localepurge    localepurge/use-dpkg-feature  boolean true' | debconf-set-selections

## Install HTTPS support for APT.
DEBIAN_FRONTEND=noninteractive apt-get install -y apt-transport-https ca-certificates

## Install add-apt-repository
DEBIAN_FRONTEND=noninteractive apt-get install -y software-properties-common

## Upgrade all packages.
DEBIAN_FRONTEND=noninteractive apt-get dist-upgrade -y --no-install-recommends

## nuke unneeded packages
DEBIAN_FRONTEND=noninteractive apt-get autoremove --purge -y

## Fix locale.
DEBIAN_FRONTEND=noninteractive apt-get install -y language-pack-en
locale-gen en_US.UTF-8
update-locale LANG=en_US.UTF-8 LC_CTYPE=en_US.UTF-8
echo -n 'en_US.UTF-8 UTF-8' > /var/lib/locales/supported.d/local
echo -n 'en_US.UTF-8 UTF-8' > /var/lib/locales/supported.d/en
