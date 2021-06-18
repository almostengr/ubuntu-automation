#!/bin/bash

###############################################################################
# Author: Kenny Robinson, @almostengr
# Description: Remove duplicate files from a particular directory. Need to be
# in the diretory that you wish to clean BEFORE running this script.
###############################################################################

echo "Checking disk space"

# check disk space before cleanup
du -sh "$(pwd)"

echo "Done checking disk space"
echo "Removing duplicates"

# perform cleanup
fdupes -r -d -N "$(pwd)"

echo "Done removing duplicates"
echo "Removing empty directories"

# remove empty directories
EMPTYDIR=1

while [ ${EMPTYDIR} -gt 0 ]; do
	# remove the empty directories
	find . -type d -empty -exec rm -rf {} \;
	
	# check if new empty directories exist
	EMPTYDIR=$(find . -type d -empty | wc -l)
	echo "${EMPTYDIR} empty directories found"
done

echo "Done removing empty directories"
echo "Checking disk space"

# check disk space after cleanup
du -sh "$(pwd)"

echo "Done checking disk space"
