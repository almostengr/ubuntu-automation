#!/bin/bash

####################################################################################
# DESCRIPTION: Check to see if any virtual machines are not running. If they are
# not running then the scripts are started. 
# AUTHOR: Kenny Robinson, @almostengr
####################################################################################

function log_message {
## LOG MESSAGES FROM THE SCRIPT
	echo $(date)" | "$*
}

function get_running_vms {
## GET THE LIST OF RUNNING VMS

	log_message "Getting the list of VMs that are running"
	${VBOXBIN} list runningvms | awk '{print $1}' > ${VMSRUNNING}
	log_message "Done getting the list of VMs that are running"
}

function get_all_vms {
## GET THE LIST OF ALL THE VMS

	log_message "Getting the list of VMs that are created"
	${VBOXBIN} list vms | awk '{print $1}' > ${VMSALL}
	log_message "Done getting the list of VMs that are created"
}

function start_vms_notrunning {
## COMPARES WHAT IS RUNNING TO WHAT IS NOT RUNNING AND STARTS THOSE THAT ARE NOT RUNNING
	LINECOUNT=0
	
	log_message "Comparing the running VMs to all VMs"
	diff ${VMSRUNNING} ${VMSALL} > ${VMSDIFF}
	log_message "Done comparing the running VMs to all VMs"

	while read line
	do
		if [ ${LINECOUNT} -gt 0 ]; then
			MACHINENAME=$(echo ${line} | awk '{print $2}' | sed 's/"//g')
			log_message "Virtual machine ${MACHINENAME} is not running"
			${VBOXBIN} startvm ${MACHINENAME} --type headless
			log_message "Virtual machine ${MACHINENAME} has been requested to start"
			log_message "Waiting..."
			sleep 5

			# CHECK TO SEE IF THE MACHINE DID START
			ps -ef | grep virtualbox | grep ${MACHINENAME}

			if [ $? -eq 0 ]; then
				log_message "Virtual machine ${MACHINENAME} is running"
			else
				log_message "Virtual machine ${MACHINENAME} failed to start"
			fi
		fi

		# INCREMENT COUNTER
		LINECOUNT=$((${LINECOUNT} + 1))
	done < ${VMSDIFF}
}

function cleanup {
## CLEANUP AFTER RUNNING THE SCRIPT

	log_message "Performing cleanup."
	rm ${VMSRUNNING} ${VMSALL} ${VMSDIFF}
	log_message "Done performing cleanup."
}

function main {
	get_running_vms
	get_all_vms
	start_vms_notrunning
}

# Default Variables
VBOXBIN=/usr/bin/VBoxManage
VMSRUNNING=/var/tmp/vmsrunning.txt
VMSALL=/var/tmp/vmsall.txt
VMSDIFF=/var/tmp/vmsdiff.txt

# LOAD CONFIGURATION FILE
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cd ${DIR}
. config.sh

main $*

