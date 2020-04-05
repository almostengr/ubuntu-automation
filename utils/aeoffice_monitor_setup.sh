#!/bin/bash

# steps were taken from https://askubuntu.com/questions/493165/ubuntu-14-04-unknown-display-nvidia-graphics
# and placed into a script

PATH=/usr/bin/:${PATH}
OLD_IFS=$IFS

# get the mode details from the system
# cvt 1920 1080

# configure the new mode based on the resolution size
xrandr --newmode "1920x1080_60.00"  173.00  1920 2048 2248 2576  1080 1083 1088 1120 -hsync +vsync
xrandr --addmode VGA-1 1920x1080_60.00
xrandr --output VGA-1 --mode 1920x1080_60.00
