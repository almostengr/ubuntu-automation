#!/bin/bash

################################################################################
# Script: install_lamp.sh
# Description: Script to install LAMP server
# Author: Kenny Robinson, Almost Engineer, @almostengr
################################################################################

# MAKE SURE THAT THE ROOT USER IS RUNNING THE SCRIPT.
if [ "$(id -u)" == "0" ]; then
	echo "Updating repositories"

	/usr/bin/apt-get update

	echo "Installing packages"

	/usr/bin/apt-get install -y apache2 php5 mysql-client mysql-server php5-mysql libapache2-mod-php5 php5-mcrypt

	# restart apache after install 
	/usr/sbin/service apache2 restart

	# IF REBOOT FILE HAS BEEN CREATED, THEN DO REBOOT
	if [ -f /var/run/reboot-required ]; then
		echo "Reboot is required. Rebooting"

		/sbin/reboot
	fi

	/bin/date
else
	# THROW ERROR IF NOT RUNNING AS ROOT
	/bin/echo "ERROR: Must be root to run script."
fi

