#!/bin/bash

################################################################################
# Description: Script to automatically perform
# Author: Kenny Robinson, @almostengr
################################################################################

# MAKE SURE THAT THE ROOT USER IS RUNNING THE SCRIPT.
if [ "$(id -u)" == "0" ]; then
	echo "Cleaning packages"
	/usr/bin/apt-get clean

	echo "Updating repositories"
	/usr/bin/apt-get update

	echo "Installing updates"
	/usr/bin/apt-get upgrade -y
	
	echo "Running upgrade script"
	/usr/bin/do-release-upgrade

	# IF REBOOT FILE HAS BEEN CREATED, THEN DO REBOOT
	if [ -f /var/run/reboot-required ]; then
		echo "Reboot is required"
	fi
else
	# THROW ERROR IF NOT RUNNING AS ROOT
	/bin/echo "ERROR: Must be root to run script."
fi
