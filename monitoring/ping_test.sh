#!/bin/bash

################################################################################
# AUTHOR: Kenny Robinson, @almostengr
# DATE CREATED: 2016-05-09
# USAGE: ping_test.sh <hostname>
# DESCRIPTION: To ping another host to confirm whether it is responding. To
# receive email notifications for when the ping test has failed, the "toEmail"
# variable needs to be popluated. If using a ticketing system, the "ticketAPI"
# variable should be popluated with the command or script that should be ran
# to automatically generate a ticket.
################################################################################

toEmail=""
ticketAPI=""

# If arg one is not passed, then throw error. Otherwise perform ping.
if [ "${1}" != "" ]
then 
	echo "Pinging host ${1}..."
	ping -c 2 ${1} | grep "0% packet loss"

	# If ping fails, then send email and create ticket via JSON API.
	if [ $? -eq 0 ]
	then 
		# Ping test has succeeded.
		echo "Ping test successful for ${1}."
	else
		# Ping test failed.
		echo "Ping test failed for ${1}."
	fi
else
	# If no value for param 1 has been passed, then display help info.
	echo "ERROR!"
	echo ""
	echo "Usage:"
	echo "ping <hostname>"
fi

