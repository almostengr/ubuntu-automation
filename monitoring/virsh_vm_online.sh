#!/bin/bash

################################################################################
# AUTHOR: Kenny Robinson, Bit Second (bitsecondal@gmail.com)
# COPYRIGHT: Bit Second Tech 2016
# WEB: www.bitsecondtech.com
# DATE CREATED: 2016-02-21
# USAGE: vms_online.sh 
# DESCRIPTION: Check to see if all Virtual Machines are online. If not, then 
# an alert and email notification should be issued. 
# VERSION HISTORY
# 2016-02-21 - Initial version.
# 2015-05-09 - Added code to monitoring repository. Added additional comments 
# to the script-wide variables.
################################################################################

/bin/date 

# Script Variables
toEmail=""
ticketAPI=""

# SCRIPT MAIN

# Get all of the Virtual Machines on the host. 
virsh list --all | grep "shut off"
returnCd=$?

# If any of the machines show as offline, then throw error 
if [ ${returnCd} -eq 0 ]; then
	# Some or none of the VMs are running. Display message stating so. 
	echo "One or more VMs are offline."
else
	# All VMs are running. Display message stating so. 
	echo "All VMS are online."
fi

/bin/date

