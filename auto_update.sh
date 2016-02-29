#!/bin/bash

################################################
# Script: auto_update.sh
# Description: Script to automatically perform
# functions on ubuntu based servers.
# Author: Bit Second
# Date: 2016-02-28
#
# Version History
# 2016-02-28 - Initial version.
################################################

# MAKE SURE THAT THE ROOT USER IS RUNNING THE SCRIPT.
if [ "$USER" = "root" ]; then
	apt-get autoremove -y

	apt-get update

	apt-get upgrade -y

	apt-get dist-upgrade

	# IF REBOOT FILE HAS BEEN CREATED, THEN DO REBOOT
	if [ -f /var/run/reboot-required ]; then
		reboot
	fi
else
	# THROW ERROR IF NOT RUNNING AS ROOT
	echo "ERROR: Must be root to run script."
fi

