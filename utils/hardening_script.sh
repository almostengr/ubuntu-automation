#!/bin/bash

###############################################################################
# Script: hardening_script.sh
# Author: Kenny Robinson, Bit Second Tech
# Description: To automatically install additional software on Ubuntu machines 
# so that manually running each of the commands does not have to be performed.
###############################################################################

if [ "$(id -u)" == "0" ]; then
	set -x

	openssl version -v

	openssl version -b

	apt-get update

	apt-get upgrade openssl libssl-dev

	apt-cache policy openssl libssl-dev

	openssl version -b

	# ufw enable

	apt-get install fail2ban -y
		
	apt-get install git -y
	
	apt-get install etckeeper -y

	apt-get upgrade -y

	apt-get dist-upgrade -y

	apt-get autoremove -y

	set +x

	echo "Setup done. Rebooting..."

	sleep 5

	/sbin/reboot

else
	echo "ERROR: Must be root to run script. Re-run script using"
	echo "sudo bash hardening_script.sh"
fi
