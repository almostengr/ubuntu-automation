#!/bin/bash

# create a video slide show from a folder of images
# information sourced from https://trac.ffmpeg.org/wiki/Slideshow

/bin/date

## remove existing files
rm output.mp4 list.txt

## loop through the files and subfiles in the directory
for filename in $(find . -name '*.jpg')
do
echo "file '${filename}'" >> list.txt
echo duration 2 >> list.txt
done

## run create the video file
# ffmpeg -f concat -safe 0 -i list.txt -vsync vfr -pix_fmt yuv420p output.mp4
ffmpeg -f concat -safe 0 -i list.txt -vsync vfr -pix_fmt rgb24 output.mp4

## if scale errors, add -vf scale=-2:720

/bin/date
