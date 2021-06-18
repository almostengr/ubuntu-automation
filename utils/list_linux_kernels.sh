#!/bin/bash

################################################################################
# author: Kenny Robinson, @almostengr
# Description: List the linux kernels that are installed on a system. Use in 
# conjunction with removing old and unused kernels. 
# https://thealmostengineer.com/technology/2021.05.10-removing-linux-kernels/
################################################################################

dpkg -l | tail -n +6 | grep -E 'linux-image-[0-9]+' | grep -Fv $(uname -r)
