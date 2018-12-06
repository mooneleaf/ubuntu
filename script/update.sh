#!/bin/bash -eux

# Disable the release upgrader
echo "==> Disabling the release upgrader"
sed -i.bak 's/^Prompt=.*$/Prompt=never/' /etc/update-manager/release-upgrades

echo "==> Checking version of Ubuntu"
. /etc/lsb-release

if [[ $DISTRIB_RELEASE == 16.04 || $DISTRIB_RELEASE == 16.10 ]]; then
    echo "==> Disabling periodic apt upgrades"
    echo 'APT::Periodic::Enable "0";' >> /etc/apt/apt.conf.d/10periodic
fi



if [[ $UPDATE  =~ true || $UPDATE =~ 1 || $UPDATE =~ yes ]]; then
	echo "==> Updating list of repositories"
	# apt-get update does not actually perform updates, it just downloads and indexes the list of packages
	apt-get update --yes

    echo "==> Performing dist-upgrade (all packages and kernel)"
	apt-get dist-upgrade --yes --allow-change-held-packages

	apt-get install --fix-broken --yes

	printf "==> %s" "Rebooting"
	nohup shutdown --reboot now </dev/null >/dev/null 2>&1 &
fi
