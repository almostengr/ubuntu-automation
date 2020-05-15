#!/bin/bash

date

echo ""
echo "Disk usage"
df -h /mnt/ramfiles

echo ""
echo "Pending video files"
ls -ltr /mnt/ramfiles/renderserver/*pending

echo ""
echo "Currenting rendering"
ls -ltr /mnt/ramfiles/renderserver/*render
