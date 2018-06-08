#!/bin/bash 

#################################################################################
# Script: update_repo.sh
# Description: Script to automatically update the code from the repository.
# Author: Kenny Robinson, @almostengr
# Date: 2017-09-10
#################################################################################

# pull the latest code from origin
/usr/bin/git fetch --all

# make sure on the master branch
/usr/bin/git checkout master 

# pull the latest version into the current version
/usr/bin/git pull origin master

