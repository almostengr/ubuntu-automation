#!/bin/bash

################################################################################
# AUTHOR: Kenny Robinson, @almostengr
# DATE CREATED: 2016-02-21
# USAGE: vms_online.sh 
# DESCRIPTION: Check to see if all Virtual Machines are online. If not, then 
# an alert and email notification should be issued. 
################################################################################

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

