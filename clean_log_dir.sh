#/bin/bash

################################################################################
# AUTHOR: Kenny Robinson, Bit Second (bitsecondal@gmail.com)
# COPYRIGHT: Bit Second Tech 2016
# WEB: www.bitsecondtech.com
# DATE CREATED: 2016-05-29
# USAGE: clean_log_dir.sh
# DESCRIPTION: Cleans the log directory on the machine. Log and compressed log 
# files that are older than 30 days are automatically discarded. To prevent 
# permissions error when running the script via cron or other automation, the 
# run as ID should be a member of the syslog group. 
################################################################################

function main {
# FILES OLDER THAN THIS NUMBER OF DAYS WILL BE REMOVED 
DELAY=30


date 

df -h . 

/usr/bin/find /var/log/* -mtime +${DELAY} -exec rm {} \; 

df -h . 

date

} # END FUNCTION 

main



################################################################################
# VERSION HISTORY
# 2016/05-29 - Initial Version.
################################################################################

