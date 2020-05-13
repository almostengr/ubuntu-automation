#!/bin/bash

##############################################
# Name: uninstall_plex.sh
# Author: Kenny Robinson, @almostengr
# Video Tutorial: https://youtu.be/FEatUj8B0XA
# Description: Uninstall Plex Media Server from your 
# computer or server.
###############################################

if [ "$(id -u)" == "0" ]; then
	echo "Removing Plex Media Server"

	apt-get autoremove --purge plexmediaserver -y
	
	echo "Done removing Plex Media Server"
	echo "Confirming that Plex is no longer running"

	ps -ef | grep -i plex
	
	echo "Done confirming that Plex is no longer running"
else
	echo "Not running as root user"
	echo "Rerun this script with the following command"
	echo "sudo bash <scriptname>
fi

