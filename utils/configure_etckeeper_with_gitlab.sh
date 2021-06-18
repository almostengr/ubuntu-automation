#!/bin/bash

################################################################################
# Author: Kenny Robinson, @almostengr
# Video Tutorial: https://youtu.be/dPm8cazYy00
# Description: This script will set up etckeeper on your computer with Gitlab.
################################################################################

if [ "$(id -u)" == "0" ]; then
	read -p "Enter GitLab URL: " gitlabURL

	if [ "${gitlabURL}" != "" ]; then
		echo "Running updates and installing etckeeper"

		apt-get update
		apt-get install etckeeper git -y

		echo "Done running updates and installing etckeeper"
		echo "Generating SSH key"

		ssh-keygen

		echo "Done generating SSH key"

		read "Place the public key file onto GitLab."
		read "Press ENTER when this has been completed."

		echo "Adding origin location"

		cd /etc
		git remote -v
		git remote add origin ${gitlabURL}
		git remote -v

		echo "Done adding origin location"
		echo "Pushing to GitLab"

		git push origin master

		echo "Done pushing to GitLab"
	else
		echo "Gitlab URL was not entered"
	fi
else
	echo "Not running as root user"
	echo "Rerun this script with the following command"
	echo "sudo bash configure_etckeeper_with_gitlab.sh"
fi
