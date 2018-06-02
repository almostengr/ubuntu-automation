#!/bin/bash

###############################################################################
# Script: remove_duplicates.sh
# Author: Kenny Robinson, @almostengr
# Description: Remove duplicate files from a particular directory. Need to be 
# in the diretory that you wish to clean BEFORE running this script.
###############################################################################

date

# check disk space before cleanup
du -sh "$(pwd)"

# perform cleanup
fdupes -r -d -N "$(pwd)"

# remove empty directories
EMPTYDIR=1

while [ ${EMPTYDIR} -gt 0 ]; do
	# remove the empty directories
	find . -type d -empty -exec rm -rf {} \;
	
	# check if new empty directories exist
	EMPTYDIR=$(find . -type d -empty | wc -l)
done

# check disk space after cleanup
du -sh "$(pwd)"

date
