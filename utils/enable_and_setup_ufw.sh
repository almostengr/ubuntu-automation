#!/bin/bash

###############################################################################
# Video Title: Enable and setup UFW on Ubuntu 16.04
# Author: Kenny Robinson, @almostengr
# Video: https://youtu.be/sgMuFbtOPWU
###############################################################################

if [ "$(id -u)" == "0" ]; then
	ufw status
	ufw enable
	ufw status
	ufw allow 22
	ufw status
	ufw allow 80
	ufw allow 443
	ufw status
	ufw status numbered
	ufw delete 6
	ufw status
else
	echo "ERROR: Must be root to run script. Re-run script using"
	echo "sudo bash <scriptname>"
fi
