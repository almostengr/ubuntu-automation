#!/bin/bash

###############################################
## DESCRIPTION: Script used to create videos for the Kenny Ram Dash Cam YouTube channel
## AUTHOR: Kenny Robinson, @almostengr
## 
## REFERENCES: 
## https://superuser.com/questions/939357/how-to-position-drawtext-text
###############################################

DASHCAMFOLDER="/mnt/d74511ce-4722-471d-8d27-05013fd521b3/Kenny Ram Dash Cam"

## change to dash cam folder

## beginning of loop

## cd to dash cam folder

## cd into child folder

echo "INFO: $(date) Performing cleanup"
/bin/rm input.txt details.txt

## todo check why intro video causes problems with rendering

# echo "INFO: $(date) Copying video intro"
# /bin/cp -p "/mnt/d74511ce-4722-471d-8d27-05013fd521b3/ytvideostructure/dash_cam_opening_shortened.mp4" AAAAintro.mp4

echo "INFO: $(date) Making the list of video files"
for file in $(ls -1tr *mp4 *MP4 *MOV *mov) ;
# for file in $(ls -1 *mp4 *MP4 *MOV *mov) ;
do
echo "file ${file}" >> input.txt
echo "$(pwd)/${file}" >> details.txt
done

BASENAME=$(/usr/bin/basename "$(pwd)")
OUTPUTNAME="${BASENAME}$(/bin/date +%Y%m%d%H%M)"
VIDEOTITLE=$(cut -d ";" -f 1 <<< "${BASENAME}")

echo "INFO: Video Title: ${VIDEOTITLE}"

echo "INFO: $(date) Rendering video"

COLOR="white"

CONTAINSNIGHT=$(echo ${VIDEOTITLE} | grep -i night | wc -l)

if [ ${CONTAINSNIGHT} -eq 1 ]; then
    COLOR="orange"
fi

# /usr/bin/ffmpeg -f concat -i input.txt -an -vf "drawtext=textfile:Kenny Ram Dash Cam:fontcolor=${COLOR}:fontsize=30:x=920:y=20:box=1:boxborderw=7:boxcolor=black@0.7" "${OUTPUTNAME}.mp4"
/usr/bin/ffmpeg -y -f concat -i input.txt -an -vf "drawtext=textfile:Kenny Ram Dash Cam:fontcolor=${COLOR}:fontsize=25:x=w-tw-50:y=50:box=1:boxborderw=7:boxcolor=black@0.3, drawtext=textfile:'${VIDEOTITLE}':fontcolor=${COLOR}:fontsize=25:x=50:y=50:box=1:boxborderw=7:boxcolor=black@0.3" "${OUTPUTNAME}.mp4"

echo "INFO: $(date) Packaging video into archive"
tar -czvf "${BASENAME}.tar.gz" "${OUTPUTNAME}.mp4" details.txt

echo "INFO: $(date) Moving video to upload directory"
/bin/mv "${OUTPUTNAME}.mp4" "${DASHCAMFOLDER}/upload"

echo "INFO: $(date) Moving archive to archive directory"
/bin/mv "${BASENAME}.tar.gz" "${DASHCAMFOLDER}/archive"

## end of loop
