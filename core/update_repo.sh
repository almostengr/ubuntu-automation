#!/bin/bash 

#################################################################################
# Script: update_repo.sh
# Description: Script to automatically update the code from the repository.
# Author: Kenny Robinson, Bit Second (www.bitsecondtech.com)
# Date: 2017-09-10
#################################################################################

/bin/date

/usr/bin/git checkout master 

/usr/bin/git pull origin master

/bin/date

