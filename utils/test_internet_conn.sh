#!/bin/bash

################################################################################
# Description: Tests the connection speed of the internet by downloading a 10 MB
# file from the internet.
# Date: 2015-10
# Author: Kenny Robinson, @almostengr
################################################################################

## SCRIPT MAIN ##
wget -O /dev/null http://speedtest.wdc01.softlayer.com/downloads/test10.zip

