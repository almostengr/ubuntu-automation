#!/bin/bash

################################################################################
# AUTHOR: Kenny Robinson, @almostengr
# DATE CREATED: 2016-05-29
# USAGE: clean_log_dir.sh
# DESCRIPTION: Cleans the log directory on the machine. Log and compressed log 
# files that are older than 30 days are automatically discarded. To prevent 
# permissions error when running the script via cron or other automation, the 
# run as ID should be a member of the syslog group. 
################################################################################

# FILES OLDER THAN THIS NUMBER OF DAYS WILL BE REMOVED 
DELAY=30

if [ "$(id -u)" == "0" ]; then
	cd /var/log 

	# display the disk usage before cleanup
	# /bin/df -h .
	/usr/bin/du -sh /var/log

	# list all the files before removing
	/usr/bin/find /var/log/* -type f -mtime +${DELAY} -exec ls -la {} \;

	# remove the files
	/usr/bin/find /var/log/* -type f -mtime +${DELAY} -exec rm {} \;

	# display the disk usage after cleanup
	# /bin/df -h .
	/usr/bin/du -sh /var/log
else
	echo "ERROR: Must be root to run script."
fi

