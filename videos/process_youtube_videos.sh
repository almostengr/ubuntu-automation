#!/bin/bash

###############################################
## DESCRIPTION: Script used to create videos for YouTube and other social media outlets
## AUTHOR: Kenny Robinson, @almostengr
##
## REFERENCES:
## https://superuser.com/questions/939357/how-to-position-drawtext-text
###############################################

## POSITION CONSTANTS
PADDING="20"
UPPERLEFT="x=${PADDING}:y=${PADDING}"
UPPERCENTER="x=(w-text_w)/2:y=${PADDING}"
UPPERRIGHT="x=w-tw-${PADDING}:y=${PADDING}"
CENTERED="x=(w-text_w)/2:y=(h-text_h)/2"
LOWERLEFT="x=${PADDING}:y=h-th-${PADDING}-30"
LOWERCENTER="x=(w-text_w)/2:y=h-th-${PADDING}-30"
LOWERRIGHT="x=w-tw-${PADDING}:y=h-th-${PADDING}-30"
FONTSIZE="h/35"

## DIRECTORY CONSTANTS
# VIDEOS_FOLDER="/mnt/d74511ce-4722-471d-8d27-05013fd521b3/testingscript"
VIDEOS_FOLDER="/home/almostengineer/Videos/testingscript"
INCOMING_DIR="${VIDEOS_FOLDER}/incoming"
WORKING_DIR="${VIDEOS_FOLDER}/working"
ARCHIVE_DIR="${VIDEOS_FOLDER}/archive"
UPLOAD_DIR="${VIDEOS_FOLDER}/upload"
PROCESSED_DIR="${VIDEOS_FOLDER}/processed"

function checkDiskSpace() {
    DISK_SPACE_USED=$(df -h --output=pcent . | tail -1 | sed 's/[^0-9]*//g')

    echo "INFO: $(date) Disk space is ${DISK_SPACE_USED}%"
    
    if [ ${DISK_SPACE_USED} -gt 95 ]; then
        exit 3
    fi
}

function checkForExistingProcess() 
{
    PS_OUTPUT=$(ps -ef | grep -e "process_youtube_videos" | wc -l)

    if [ ${PS_OUTPUT} -gt 3 ]; then
        echo "Process is already running. Exiting"
        exit 5
    fi
}

## main

checkForExistingProcess

cd "${VIDEOS_FOLDER}"

checkDiskSpace

mkdir -p ${UPLOAD_DIR}
mkdir -p ${ARCHIVE_DIR}
mkdir -p ${PROCESSED_DIR}

cd "${INCOMING_DIR}"

for TAR_FILENAME in *.tar*
do
    if [[ "${TAR_FILENAME}" == "*.tar*" ]]; then
        echo "INFO: $(date) Skipping ${TAR_FILENAME}"
        continue
    fi
    
    checkDiskSpace
    
    cd "${INCOMING_DIR}"

    echo "INFO: $(date) Performing cleanup"
    /bin/rm -fr "${WORKING_DIR}"
    mkdir -p ${WORKING_DIR}

    if [[ "${TAR_FILENAME}" == *".gz" ]]; then
        echo "INFO: $(date) Uncompressing ${TAR_FILENAME}"
        /bin/gunzip "${TAR_FILENAME}"
        TAR_FILENAME=$(echo "${TAR_FILENAME}" | sed -e 's/.gz//g')
    fi

    echo "INFO: $(date) Untarring file ${TAR_FILENAME}"
    /bin/tar -xf "${TAR_FILENAME}" -C "${WORKING_DIR}"

    VIDEO_TITLE=$(cut -d ";" -f 1 <<< "${TAR_FILENAME}")
    VIDEO_TITLE=$(echo ${VIDEO_TITLE} | sed -e 's/.tar//g')

    cd ${WORKING_DIR}

    echo "INFO: $(date) Making the list of video files"

    if [ -f "dashcam.txt" ]; then
        ls -1tr *mp4 *MP4 *MOV *mov > input.txt
    else
        ls -1 *mp4 *MP4 *MOV *mov > input.txt
    fi

    sed -i -e 's/^/file "/' input.txt # add prefix to each line
    sed -i -e 's/$/"/' input.txt # add suffix to each line
    sed -i -e "s/\"/'/g" input.txt

    echo ${VIDEO_TITLE} | fold -sw 60 > title.txt
    /bin/sed -e '/^$/d' title.txt > title2.txt
    mv title2.txt title.txt

    echo "INFO: $(date) Video Title: ${VIDEO_TITLE}"

    # render video without filters for archiving

    if [ -f "dashcam.txt" ]; then
        echo "INFO: $(date) Dash Cam channel video"

        COLOR="white"

        CONTAINS_NIGHT=$(echo ${VIDEO_TITLE} | grep -i night | wc -l)

        if [ ${CONTAINS_NIGHT} -eq 1 ]; then
            COLOR="orange"
        fi

        RANDOM_CHANNEL_INTERVAL=$(( ${RANDOM} % 20 + 5 )) ## random number between 5 and 20

        ## channel title
        CHANNEL_NAME="drawtext=textfile:'Kenny Ram Dash Cam':fontcolor=${COLOR}:fontsize=${FONTSIZE}:${UPPERRIGHT}:box=1:boxborderw=7:boxcolor=black"
        
        VIDEO_FILTER+="${CHANNEL_NAME}:enable='between(t,0,${RANDOM_CHANNEL_INTERVAL})'"
        VIDEO_FILTER+=", ${CHANNEL_NAME}@${DIMMEDBG}:enable='gt(t,${RANDOM_CHANNEL_INTERVAL})'"

        ## video title
        TITLETEXT=$(echo "${VIDEO_TITLE}" | fold -sw 60)
        TITLE=", drawtext=textfile:'${VIDEO_TITLE}':fontcolor=${COLOR}:box=1:boxborderw=7:boxcolor=black"

        VIDEO_FILTER+="${TITLE}:fontsize=${FONTSIZE}:${UPPERLEFT}:enable='between(t,0,${RANDOM_CHANNEL_INTERVAL})'"
        VIDEO_FILTER+="${TITLE}@0.3:fontsize=${FONTSIZE}:${UPPERLEFT}:enable='gt(t,${RANDOM_CHANNEL_INTERVAL})'"

        GENERALDETAILS="fontcolor=white:fontsize=${FONTSIZE}:box=1:boxborderw=7:boxcolor=green:${LOWERCENTER}"

        if [ -f "destination.txt" ]; then
            echo "INFO: $(date) Found drive details file"
            VIDEO_FILTER+=", drawtext=textfile=destination.txt:${GENERALDETAILS}:enable='between(t,5,12)'"
        fi

        if [ -f "majorroads.txt" ]; then
            echo "INFO: $(date) Found major road details file"
            VIDEO_FILTER+=", drawtext=textfile=majorroads.txt:${GENERALDETAILS}:enable='between(t,12,20)'"
        fi

        ARCHIVE_FILE_NAME="${VIDEO_TITLE}.dash.mp4"

    elif [ -f "services.txt" ]; then
        echo "INFO: $(date) RHTS channel video"

        CURRENTDAY=$(date +%A)

        # video title
        if [ "${CURRENTDAY}" == "Monday" ]; then
            BRANDING_TEXT="facebook.com/rhtservicesllc"
        elif [ "${CURRENTDAY}" == "Wednesday" ]; then
            BRANDING_TEXT="IG: @rhtservicesllc"
        elif [ "${CURRENTDAY}" == "Friday" ]; then
            BRANDING_TEXT="rhtservices.net"
        else
            BRANDING_TEXT="Robinson Handy and Technology Services"
        fi

        VIDEO_FILTER="drawtext=textfile:'${BRANDING_TEXT}':fontcolor=white:fontsize=${FONTSIZE}:${UPPERRIGHT}:box=1:boxborderw=7:boxcolor=black"
        ARCHIVE_FILE_NAME="${VIDEO_TITLE}.svcs.mp4"

    else
        echo "INFO: $(date) Unknown channel video"

        VIDEO_FILTER=""
        ARCHIVE_FILE_NAME="${VIDEO_TITLE}.unknown.mp4"
    fi
    
    FINAL_OUTPUT_NAME="${VIDEO_TITLE}.mp4"

    if [ -f "subtitles.ass" ]; then
        echo "INFO: $(date) Found subtitles file"
        VIDEO_FILTER+=", subtitles=subtitles.ass"
    fi

    echo "INFO: $(date) Rendering video for archive"

    /usr/bin/ffmpeg -hide_banner -safe 0 -loglevel error -y -f concat -i input.txt "${ARCHIVE_FILE_NAME}"

    echo "INFO: $(date) Rendering video with filter overlays"

    if [[ "${VIDEO_FILTER}" == "" ]]; then
        /bin/cp -p "${ARCHIVE_FILE_NAME}" "${FINAL_OUTPUT_NAME}"
    else
        /usr/bin/ffmpeg -hide_banner -safe 0 -loglevel error -y -f concat -i input.txt -an -vf "${VIDEO_FILTER}" "${FINAL_OUTPUT_NAME}"
    fi

    echo "INFO: $(date) Creating thumbnail"
    /usr/bin/ffmpeg -hide_banner -loglevel error -i "${FINAL_OUTPUT_NAME}" -ss 00:00:02.000 -frames:v 1 thumbnail.jpg

    echo "INFO: $(date) Compressing tar file for archiving"
    TAR_ARCHIVE_FILE_NAME="$(echo ${ARCHIVE_FILE_NAME} | sed 's/\.mp4//g').$(date +%Y%m%d).tar.gz"
    /bin/rm input.txt
    /bin/tar -czvf "${TAR_ARCHIVE_FILE_NAME}" "${ARCHIVE_FILE_NAME}" *.txt thumbnail.jpg

    echo "INFO: $(date) Moving video and thumbnail to upload directory"
    /bin/mv "${FINAL_OUTPUT_NAME}" "${UPLOAD_DIR}"
    /bin/mv "thumbnail.jpg" "${UPLOAD_DIR}/${FINAL_OUTPUT_NAME}.jpg"

    echo "INFO: $(date) Moving archive to archive directory"
    /bin/mv "${TAR_ARCHIVE_FILE_NAME}" "${ARCHIVE_DIR}"

    echo "INFO: $(date) Compressing and moving input tar file"
    cd "${INCOMING_DIR}"
    /bin/gzip "${TAR_FILENAME}"
    /bin/mv "${TAR_FILENAME}".gz "${PROCESSED_DIR}"

    /bin/rm -fr "${WORKING_DIR}"
done
