#!/bin/bash

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

