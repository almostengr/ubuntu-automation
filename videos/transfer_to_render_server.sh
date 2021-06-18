#!/bin/bash 

###############################################
# Author: Kenny Robinson, @almostengr
# DESCRIPTION: This script transfers files to the main computer 
# to the rendering server for processing
###############################################

/bin/date

/bin/echo "Transferring files"

/usr/bin/scp -p /home/almostengineer/Videos/dashcamvideos/*tar.gz iamadmin@media://mnt/ramfiles/dashcam/incoming

/usr/bin/scp -p /home/almostengineer/Videos/aevideos/*tar.gz iamadmin@media://mnt/ramfiles/almostengineer/incoming

/bin/date 

/bin/echo "Moving files to archive"

mv /home/almostengineer/Videos/dashcamvideos/*tar.gz /mnt/d74511ce-4722-471d-8d27-05013fd521b3/Kenny\ Ram\ Dash\ Cam/archive

mv /home/almostengineer/Videos/aevideos/*tar.gz /mnt/d74511ce-4722-471d-8d27-05013fd521b3/Almost\ Engineer/archive

/bin/echo "Process complete"

/bin/date
