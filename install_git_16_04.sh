#!/bin/bash

###############################################################################
# Video Title: Install Git on Ubuntu 16.04 | Almost Engineered Tech, Ep 4
# Author: Kenny Robinson, @almostengr
# Video: https://youtu.be/rMPXp9FEcl8
# OS: Ubuntu 16.04
###############################################################################

if [ "$(id -u)" == "0" ]; then
	sudo apt-get update
	sudo apt-get install git
else
	echo "ERROR: Must be root to run script. Re-run script using"
	echo "sudo bash <scriptname>"
fi

