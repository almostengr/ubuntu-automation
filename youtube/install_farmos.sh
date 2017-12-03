#!/bin/bash

###############################################################################
# Video Title: Install FarmOS using Drush | Almost Engineered Tech, Ep 8 
# Author: Kenny Robinson, @almostengr
# Video: https://youtu.be/Cxawn2l5Cdk
# OS: Ubuntu 14.04 LTS
###############################################################################

if [ "$(id -u)" == "0" ]; then
	# download additional software
	sudo apt-get update
	sudo apt-get install drush -y

	cd /var/www
	
	# use drush to download the files
	drush dl farm

	chown -R www-data:www-data farm*
else
	echo "ERROR: Must be root to run script. Re-run script using"
	echo "sudo bash <scriptname>"
fi

