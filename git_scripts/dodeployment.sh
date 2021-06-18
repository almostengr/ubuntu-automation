#!/bin/bash

################################################################################
# Description: Used to deploy master branch of code to server. Can be used with
# cron job to automatic recurring deployments.
# Author: Kenny Robinson
# Date: 2017-09-13
# Usage: dodeployment.sh <directory>
################################################################################

DEBUG=0
# LOGFILE=${HOME}/gitdeploy.$(date +%Y%m%d.%H%M%S).log

function log_message () {
# log message to the log file

	echo $*
}

function debug_message () {
# displays additional messages when needed

	if [ ${DEBUG} -eq 1 ]; then
		log_message "DEBUG $*"
	fi
}

function main() {
# main function and logic

	CODEDIR="${1}"
	BRANCH="${2}"

	if [ -z "${BRANCH}" ]; then
		BRANCH="main"
	fi

	log_message "Changing directory"

	cd ${CODEDIR}
	
	if [ "$(pwd)" == "${CODEDIR}" ]; then
	# check if the current directory is the code directory

		log_message "Done changing directory"
		log_message "Fetching latest commits from repo" 

		git fetch --all 

		log_message "Done fetching latest commits from repo"
		log_message "Checking out ${BRANCH} branch"

		git checkout ${BRANCH}

		log_message "Done checking out ${BRANCH} branch"
		log_message "Verifiying on ${BRANCH} branch"

		OUTPUTSTATUS=$(git status)

		debug_message "OUTPUTSTATUS=${OUTPUTSTATUS}"
	
		# get the output and parse the line
		ROWCOUNT=$(echo ${OUTPUTSTATUS} | grep "On branch ${BRANCH}" | wc -l)

		debug_message "Row Count: ${ROWCOUNT}"

		log_message "Done verifying on ${BRANCH} branch"
	
		if [ ${ROWCOUNT} -eq 1 ]; then
		# check that the row exists in the output
			log_message "Pulling ${BRANCH} branch"

			git pull origin ${BRANCH}  --commit

			log_message "Done pulling ${BRANCH} branch"
		else
			log_message "Could not checkout ${BRANCH} branch"
			log_message "${OUTPUTSTATUS}"
		fi
	else
		log_message "Could not change into directory."
	fi
}

log_message $(date)

main $*

log_message $(date)
