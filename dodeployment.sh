#!/bin/bash

DEBUG=0

function log_message () {
# log message to the log file

	echo $*
	echo "$(date) | $*" >> ${LOGFILE}
}

function debug_message() {
# display message

	if [ ${DEBUG} -eq 1 ]; then
		log_message "DEBUG: $*"
	fi
}

function main() {
# main function and logic

	CODEDIR="${1}"

	log_message "Changing directory"

	cd ${CODEDIR}
	
	if [ "$(pwd)" == "${CODEDIR}" ]; then
	# check if the current directory is the code directory

		log_message "Done changing directory" 

		log_message "Checking out master"

		OUTPUTCHECKOUT=$(git checkout master)

		log_message "Done checking out master"

		log_message "Verifiying on master branch"

		ISMASTER=$(echo ${OUTPUTCHECKOUT} | grep "On branch master" | wc -1)

		if [ ${ROWCOUNT} -eq 1 ]; then
		# check that the row exists in the output
	
			log_message "Done verifying on master branch"

			log_message "Pulling master branch"

			git pull origin master

			log_message "Done pulling master branch"
		else
			log_message "Could not checkout master branch"
			log_message "${OUTPUTCHECKOUT}"
		fi
	else
		log_message "Could not change into directory."
	fi
}

main $*

