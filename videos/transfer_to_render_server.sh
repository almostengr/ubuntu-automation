#!/bin/bash 

###############################################
# Author: Kenny Robinson, @almostengr
# DESCRIPTION: This script transfers files to the main computer 
# to the rendering server for processing
###############################################

/bin/date

/bin/echo "Transferring files"

mkdir -p /mnt/d74511ce-4722-471d-8d27-05013fd521b3/outgoing/archive

/usr/bin/scp -p /mnt/d74511ce-4722-471d-8d27-05013fd521b3/outgoing/*.tar* iamadmin@media://mnt/ramfiles/youtube/incoming

/bin/date 

/bin/echo "Moving files to archive"

mv /mnt/d74511ce-4722-471d-8d27-05013fd521b3/outgoing/*.tar* /mnt/d74511ce-4722-471d-8d27-05013fd521b3/outgoing/archive

/bin/echo "Process complete"

/bin/date
