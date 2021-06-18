#!/bin/bash

##############################################
# Author: Kenny Robinson, @almostengr
# DATE: 2020-04-28
# DESCRIPTION: This script batch processes project videos that have
# been created with Kdenlive. This script is done in a data warehousing
# fashion by staging, processing, and archiving the files.
# USAGE: render_video.sh <config>
###############################################

date

echo ""
echo "Disk usage"
df -h /mnt/ramfiles

echo ""
echo "Pending video files"
ls -ltr /mnt/ramfiles/almostengineer/incoming /mnt/ramfiles/dashcam/incoming

echo ""
echo "Currenting rendering"
ls -ltr /mnt/ramfiles/almostengineer/working /mnt/ramfiles/dashcam/working
