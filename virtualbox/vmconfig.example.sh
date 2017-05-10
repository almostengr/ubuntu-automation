#!/bin/bash

## Configuration File
##
## Variables are explained and defined below:
##
## VBOXBIN should point to the bin path of VBoxManage on your system.
##
## VMSRUNNING should point to a file location that has write permissions.
## /var/tmp or /tmp are suitable locations.
##
## VMSALL should point to a file that has write permissions. /var/tmp or
## /tmp are suitable locations.
##
## VMSDIFF should point to a file location that has write permissions.

VBOXBIN=/usr/bin/VBoxManage
VMSRUNNING=/var/tmp/vmsrunning.txt
VMSALL=/var/tmp/vmsall.txt
VMSDIFF=/var/tmp/vmsdiff.txt


################################################################################
################################################################################
##### DO NOT EDIT BELOW THIS LINE - DO NOT EDIT BELOW THIS LINE ################
################################################################################

export VBOXBIN
export VMSRUNNING
export VMSALL
export VMSDIFF
