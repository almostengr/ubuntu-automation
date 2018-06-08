#!/bin/bash

################################################################################
# AUTHOR: Kenny Robinson, @almostengr
# DATE CREATED: 2016-05-09
# USAGE: ssh_test.sh <user@hostname>
# DESCRIPTION: Check to see if servers are online and listening on SSH. If the
# server is not listening, then system will generate ticket and send email
# notification to those defined in the bashrc configuration.
################################################################################

toEmail=""
ticketAPI=""

if [ -z "$1" ]; then
	# Display the help information if the host name is not provided.
	echo "ERROR: Login name not provided."
	echo ""
	echo "Usage: ssh_test.sh <user@hostname>"
else
	# ssh to the server

	loginId=${1}

	echo "Attempting to connect to ${loginId}"

	/usr/bin/ssh -q ${loginId} exit
	if [ $? -ne 0 ]
	then
		echo "Unable to connect via SSH as ${1}. Sending notifications."
	else
		echo "Connection test successful for ${loginId}"
	fi
fi

