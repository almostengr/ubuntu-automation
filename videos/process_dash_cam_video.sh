#!/bin/bash

###############################################
## DESCRIPTION: Script used to create short videos aka YouTube Shorts for the Kenny Ram Dash Cam YouTube channel
## AUTHOR: Kenny Robinson, @almostengr
###############################################

DASHCAMFOLDER="/mnt/d74511ce-4722-471d-8d27-05013fd521b3/Kenny Ram Dash Cam"

echo "INFO: $(date) Performing cleanup"
/bin/rm input.txt details.txt

## todo check if doing short video

echo "INFO: $(date) Making the list of video files"
for file in $(ls -1 *mp4 *MP4 *MOV *mov) ; 
do 
echo "file ${file}" >> input.txt
echo "$(pwd)" >> details.txt
done

BASENAME=$(/usr/bin/basename "$(pwd)")
OUTPUTNAME="${BASENAME}$(/bin/date +%Y%m%d%H%M)"

echo "INFO: $(date) Rendering video"

## todo Check if doing 720 or 1080 video

## no audio; 920 for 720p, 1420 for 1080p
/usr/bin/ffmpeg -f concat -i input.txt -an -vf "drawtext=textfile:Kenny Ram Dash Cam:fontcolor=white:fontsize=30:x=920:y=20:box=1:boxborderw=7:boxcolor=black@0.7" "${OUTPUTNAME}.mp4"

echo "INFO: $(date) Packaging video into archive"
tar -czvf "${OUTPUTNAME}.tar.gz" "${OUTPUTNAME}.mp4" details.txt

echo "INFO: $(date) Moving video to upload directory"
/bin/mv "${OUTPUTNAME}.mp4" "${DASHCAMFOLDER}/upload"

echo "INFO: $(date) Moving archive to archive directory"
/bin/mv "${OUTPUTNAME}.tar.gz" "${DASHCAMFOLDER}/archive"
