#!/bin/bash

################################################################################
# AUTHOR: Kenny Robinson, Bit Second (bitsecondal@gmail.com)
# COPYRIGHT: Bit Second Tech 2016
# WEB: www.bitsecondtech.com
# DATE CREATED: 2016-05-09
# USAGE: ssh_test.sh <user@hostname>
# DESCRIPTION: Check to see if servers are online and listening on SSH. If the
# server is not listening, then system will generate ticket and send email
# notification to those defined in the bashrc configuration.
# VERSION HISTORY
# 2016/02/06 - Initial version.
# 2016/05/09 - Added script to linuxmonitoring repo. Updated usage information
# in the header. 
################################################################################

# Log the date
/bin/date

## SCRIPT MAIN ##

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

		# Send email notification if the server down is internal.
		# mailx -s "Could not connect to ${loginId}" -t "${toEmail}" < /dev/null			
			
		# Create ticket for ticketing system.
		# ${ticketAPI}

	else
		echo "Connection test successful for ${loginId}"
	fi

fi
# end if string not empty

# Log script end time.
/bin/date

