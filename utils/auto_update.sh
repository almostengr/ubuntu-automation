#!/bin/bash

################################################################################
# Script: auto_update.sh
# Description: Script to automatically perform function on ubuntu servers.
# Author: Kenny Robinson, @almostengr
# Date: 2016-02-28
################################################################################

# MAKE SURE THAT THE ROOT USER IS RUNNING THE SCRIPT.
if [ "$(id -u)" == "0" ]; then
	echo "$(date) Removing old software"
	/usr/bin/apt-get autoremove --purge -y

	echo "$(date) Cleaning packages"
	/usr/bin/apt-get clean

	echo "$(date) Updating repositories"
	/usr/bin/apt-get update

	echo "$(date) Installing updates"
	/usr/bin/apt-get upgrade -y

	# IF REBOOT FILE HAS BEEN CREATED, THEN DO REBOOT
	if [ -f /var/run/reboot-required ]; then
		echo "$(date) Reboot is required. Rebooting"
		sleep 5
		/sbin/reboot
	fi
else
	# THROW ERROR IF NOT RUNNING AS ROOT
	/bin/echo "$(date) ERROR: Must be root to run script."
fi

