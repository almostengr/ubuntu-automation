#!/bin/bash

##############################################
# Name: redirect_home_assistant_using_apache.sh
# Author: Kenny Robinson, @almostengr
# Video Tutorial: https://www.youtube.com/watch?v=Zn9-tm5bHDY&t=1s
# Description: Redirect to Home Assistant using Apache2
###############################################

if [ "$(id -u)" == "0" ]; then
	read -p "Enter your Home Assistant URL: " haURL

	if [ "${haURL}" != "" ]; then
		echo "Updating and installing Apache2"

		apt-get update
		apt-get install apache2 -y
		
		echo "Done updating and installing Apache2"
		echo "Moving old index.html file"	
	
		cd /var/www

		mv index.html index.html.old

		echo "Done moving old index.html file"
		echo "Creating new index.html file"

		touch index.html

		echo "<html>" >> index.html
		echo "<head>" >> index.html
		echo "<title>Redirecting...</title>" >> index.html
		echo "<meta http-equiv=\"refresh\" content=\"0;URL='${haURL}'\" />" >> index.html
		echo "</head>" >> index.html
		echo "<body>" >> index.html
		echo "<p>Redirecting to <a href=\"${haURL}\">${haURL}</a></p>" >> index.html
		echo "</body>" >> index.html
		echo "</html>" >> index.html

		chmod 754 index.html
	
		echo "Done creating new index.html file"
	else
		echo "Home Assistant URL was not entered"
	fi
else
	echo "Not running as root user"
	echo "Rerun this script with the following command"
	echo "sudo bash redirect_home_assistant_using_apache.sh"
fi
