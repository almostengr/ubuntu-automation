#!/bin/bash

################################################################################
# Script: install_lamp.sh
# Description: Script to install LAMP server
# Author: Kenny Robinson, Almost Engineer, @almostengr
################################################################################

# MAKE SURE THAT THE ROOT USER IS RUNNING THE SCRIPT.
if [ "$(id -u)" == "0" ]; then
	/bin/echo "$(date) Updating repositories"
	/usr/bin/apt-get update

	/bin/echo "$(date) Installing packages"
	/usr/bin/apt-get install -y apache2 mysql-server php5-mysql libapache2-mod-php5 php5-mcrypt
	
	# restart apache after install 
	/bin/echo "$(date) Restarting apache"
	/usr/sbin/service apache2 restart

	# IF REBOOT FILE HAS BEEN CREATED, THEN DO REBOOT
	if [ -f /var/run/reboot-required ]; then
		/bin/echo "$(date) Reboot is required. Rebooting"
		/bin/sleep 5
		/sbin/reboot
	fi
else
	# THROW ERROR IF NOT RUNNING AS ROOT
	/bin/echo "$(date) ERROR: Must be root to run script."
fi

