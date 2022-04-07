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

mkdir -p ${UPLOAD_DIR}
mkdir -p ${ARCHIVE_DIR}
mkdir -p ${PROCESSED_DIR}

echo "INFO: $(date) Removing old files in processing directory"

DELAY=60
/usr/bin/find "${PROCESSED_DIR}/*" -type f -mtime +${DELAY} -exec ls -la {} \; # list files to be removed
/usr/bin/find "${PROCESSED_DIR}/*" -type f -mtime +${DELAY} -exec rm {} \; 	# remove the files

checkDiskSpace

cd "${INCOMING_DIR}"

for TAR_FILENAME in *.tar*
do
    if [[ "${TAR_FILENAME}" == "*.tar*" ]]; then
        echo "INFO: $(date) Skipping ${TAR_FILENAME}" #prevent errors when no archives are present
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

    VIDEO_TITLE=$(awk -F "." '{print $1}' <<< "${TAR_FILENAME}")
    VIDEO_TITLE=$(cut -d ";" -f 1 <<< "${VIDEO_TITLE}")
    VIDEO_TITLE=$(echo ${VIDEO_TITLE} | sed -e 's/.tar//g')

    cd ${WORKING_DIR}

    echo "INFO: $(date) Making the list of video files"

    if [ -f "dashcam.txt" ]; then
        ls -1tr *mp4 *MP4 *MOV > input.txt
    else
        ls -1 *mp4 *MP4 *mkv > input.txt
    fi

    INPUT_FILE_LINES=$(grep -e "\." input.txt | wc -l)
    
    if [ ${INPUT_FILE_LINES} -gt 1 ]; then
        /bin/sed -i -e 's/^/file "/' input.txt # add prefix to each line
        /bin/sed -i -e 's/$/"/' input.txt # add suffix to each line
        /bin/sed -i -e "s/\"/'/g" input.txt # replace double quotes with single quotes
    fi

    echo ${VIDEO_TITLE} | fold -sw 60 > title.txt
    /bin/sed -e '/^$/d' title.txt > title2.txt
    /bin/mv title2.txt title.txt

    echo "INFO: $(date) Video Title: ${VIDEO_TITLE}"

    # render video without filters for archiving

    if [ -f "dashcam.txt" ]; then
        echo "INFO: $(date) Dash Cam channel video"

        CONTAINS_NIGHT=$(echo "${VIDEO_TITLE}" | grep -i night | wc -l)

        COLOR="white"
        if [ ${CONTAINS_NIGHT} -gt 0 ]; then
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
    

    if [ ${INPUT_FILE_LINES} -eq 1 ]; then
        INPUT_FILE_NAME=$(cat input.txt)
        
        /bin/mv "${INPUT_FILE_NAME}" "${ARCHIVE_FILE_NAME}"
    else
        /usr/bin/ffmpeg -hide_banner -safe 0 -loglevel error -y -f concat -i input.txt "${ARCHIVE_FILE_NAME}"
    fi

    echo "INFO: $(date) Rendering video with filter overlays"

    if [[ "${VIDEO_FILTER}" == "" ]]; then
        /bin/cp -p "${ARCHIVE_FILE_NAME}" "${FINAL_OUTPUT_NAME}"
    else
        /usr/bin/ffmpeg -hide_banner -safe 0 -loglevel error -y -f concat -i input.txt -an -vf "${VIDEO_FILTER}" "${FINAL_OUTPUT_NAME}"
    fi

    echo "INFO: $(date) Creating thumbnail"
    THUMBNAIL_FILE_NAME="${VIDEO_TITLE}.jpg"
    /usr/bin/ffmpeg -hide_banner -loglevel error -y -i "${FINAL_OUTPUT_NAME}" -ss 00:00:02.000 -frames:v 1 "${THUMBNAIL_FILE_NAME}"

    echo "INFO: $(date) Compressing tar file for archiving"
    TAR_ARCHIVE_FILE_NAME="$(echo ${ARCHIVE_FILE_NAME} | sed 's/\.mp4//g').tar.gz"
    /bin/rm input.txt
    /bin/tar -czvf "${TAR_ARCHIVE_FILE_NAME}" "${ARCHIVE_FILE_NAME}" "${THUMBNAIL_FILE_NAME}" *.txt 

    echo "INFO: $(date) Moving video and thumbnail to upload directory"
    /bin/mv "${FINAL_OUTPUT_NAME}" "${THUMBNAIL_FILE_NAME}" "${UPLOAD_DIR}"

    echo "INFO: $(date) Moving tar archive to archive directory"
    /bin/mv "${TAR_ARCHIVE_FILE_NAME}" "${ARCHIVE_DIR}"

    echo "INFO: $(date) Compressing and moving input tar file"
    cd "${INCOMING_DIR}"
    /bin/gzip "${TAR_FILENAME}"
    /bin/mv "${TAR_FILENAME}".gz "${PROCESSED_DIR}"

    /bin/rm -fr "${WORKING_DIR}"
done


