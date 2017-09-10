#!/bin/bash

################################################################################
# Description: Tests the connection speed of the internet by downloading a 10 MB
# file from the internet.
# Date: 2015-10
# Author: Kenny Robinson
#
# Version History
# 2016-02-05 - Added header block to script.
################################################################################

## SCRIPT MAIN ##
wget -O /dev/null http://speedtest.wdc01.softlayer.com/downloads/test10.zip

