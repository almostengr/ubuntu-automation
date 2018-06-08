#!/bin/bash

###############################################################################
# Video Title: Install Kdenlive on Ubuntu 16.04 Desktop | Almost Engineered Tech, Ep 7
# Author: Kenny Robinson, @almostengr
# Video: https://youtu.be/fU8m3tcLaoQ
# OS: Ubuntu 16.04
###############################################################################

if [ "$(id -u)" == "0" ]; then
	sudo add-apt-repository ppa:kdenlive/kdenlive-stable
	sudo apt-get update
	sudo apt-get install kdenlive
else
	echo "ERROR: Must be root to run script. Re-run script using"
	echo "sudo bash <scriptname>"
fi

