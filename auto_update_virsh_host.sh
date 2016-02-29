#!/bin/bash

################################################
# Script: auto_update_virsh_host.sh
# Description: Script to automatically perform
# functions on ubuntu based machines that have 
# virsh install for virtual hosts.
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

		listFile=/tmp/virsh.txt

		virsh list --all | grep "running" > $listFile

		# SHUTDOWN EACH OF THE RUNNING MACHINES
		while line
		do
			hostname=$(awk '{print $2}' $line | xargs)
			virsh shutdown $hostname
		done < $listFile

		# ALLOW TIME FOR ALL THE VMS TO SHUTDOWN
		sleep 180

		# REBOOT THIS MACHINE 
		reboot
	fi
else
	# THROW ERROR IF NOT RUNNING AS ROOT
	echo "ERROR: Must be root to run script."
fi

