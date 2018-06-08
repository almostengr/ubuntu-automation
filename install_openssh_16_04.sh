#!/bin/bash

###############################################################################
# Video Title: Install OpenSSH Server on Ubuntu 16.04 | Almost Engineered Tech, Ep 9
# Author: Kenny Robinson, @almostengr
# Video: https://youtu.be/rMPXp9FEcl8
# OS: Ubuntu 16.04
###############################################################################

if [ "$(id -u)" == "0" ]; then
	sudo apt-get update
	sudo apt-get install openssh-server 
	ps -ef | grep ssh
else
	echo "ERROR: Must be root to run script. Re-run script using"
	echo "sudo bash <scriptname>"
fi

