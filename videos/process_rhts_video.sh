#!/bin/bash

###############################################
## DESCRIPTION: Script used to create videos for the Robinson Handy and Technology Services YouTube channel
## AUTHOR: Kenny Robinson, @almostengr
##
## REFERENCES:
## https://superuser.com/questions/939357/how-to-position-drawtext-text
###############################################

VIDEOSFOLDER="/mnt/d74511ce-4722-471d-8d27-05013fd521b3/RHT Services"

function checkDiskSpace() {
    DISKSPACEUSED=$(df -h --output=pcent . | tail -1 | sed 's/[^0-9]*//g')

    echo "INFO: $(date) Disk space is ${DISKSPACEUSED}%"
    
    if [ ${DISKSPACEUSED} -gt 95 ]; then
        exit 3
    fi
}

function renderAndArchiveVideo() {
    echo "INFO: $(date) Performing cleanup"
    /bin/rm input.txt details.txt

    BASENAME=$(/usr/bin/basename "$(pwd)")
    OUTPUTNAME="${BASENAME}"
    VIDEOTITLE=$(cut -d ";" -f 1 <<< "${BASENAME}")

    echo "INFO: $(date) Removing previous video files"
    /bin/rm "${BASENAME}*"

    echo "INFO: $(date) Making the list of video files"
    for file in $(ls -1tr *mp4 *MP4 *MOV *mov) ;
    do
        echo "file ${file}" >> input.txt
        echo "$(pwd)/${file}" >> details.txt
    done

    echo ${VIDEOTITLE} | fold -sw 60 > title.txt
    /bin/sed -e '/^$/d' title.txt > title2.txt
    mv title2.txt title.txt

    echo "INFO: Video Title: ${VIDEOTITLE}"

    echo "INFO: $(date) Rendering video"

    COLOR="white"
    BGCOLOR="blue"

    FONTSIZE="h/35"
    DIMMEDBG="0.3"

    ## POSITIONS
    PADDING="30"
    UPPERLEFT="x=${PADDING}:y=${PADDING}"
    UPPERCENTER="x=(w-text_w)/2:y=${PADDING}"
    UPPERRIGHT="x=w-tw-${PADDING}:y=${PADDING}"
    CENTERED="x=(w-text_w)/2:y=(h-text_h)/2"
    LOWERLEFT="x=${PADDING}:y=h-th-${PADDING}-30"
    LOWERCENTER="x=(w-text_w)/2:y=h-th-${PADDING}-30"
    LOWERRIGHT="x=w-tw-${PADDING}:y=h-th-${PADDING}-30"

    GENERALDETAILS="fontcolor=white:fontsize=${FONTSIZE}:box=1:boxborderw=7:boxcolor=green:${LOWERCENTER}"

    SUBTITLESFILE=""
    if [ -f "subtitles.ass" ]; then
        echo "INFO: $(date) Found subtitles file"
        SUBTITLESFILE=", subtitles=subtitles.ass"
    fi

    BRANDINGTEXT=""
    DAYOFWEEK=$(date +%A)
    if [ "${DAYOFWEEK}" == "Monday" ]; then
        BRANDINGTEXT="facebook.com/rhtservicesllc"
    elif [ "${DAYOFWEEK}" == "Wednesday" ]; then
        BRANDINGTEXT="IG: @rhtservicesllc"
    elif [ "${DAYOFWEEK}" == "Friday" ]; then
        BRANDINGTEXT="rhtservices.net"
    else 
        BRANDINGTEXT="Robinson Handy and Technology Services"
    fi

    RANDOMSUBINTERVAL=$(( ${RANDOM} % 999 + 1 )) ## random number between 1 and 999
    SUBSCRIBE=", drawtext=text='SUBSCRIBE!':fontcolor=white:fontsize=h/16:box=1:boxborderw=10:boxcolor=red:${LOWERRIGHT}:enable='lt(mod(t,${RANDOMSUBINTERVAL}),5)':${LOWERCENTER}"

    RANDOMCHANNELINTERVAL=$(( ${RANDOM} % 20 + 5 )) ## random number between 5 and 20

    ## channel title
    CHANNELNAME="drawtext=textfile:'${BRANDINGTEXT}':fontcolor=${COLOR}:fontsize=${FONTSIZE}:${UPPERRIGHT}:box=1:boxborderw=10:boxcolor=black@{DIMMEDBG}"

    LOGLEVEL="error"

    /usr/bin/ffmpeg -hide_banner -loglevel ${LOGLEVEL} -y -f concat -i input.txt -an -vf "${CHANNELNAME}${SUBTITLESFILE}" "${OUTPUTNAME}.mp4"

    echo "INFO: $(date) Creating thumbnail"
    /usr/bin/ffmpeg -hide_banner -loglevel ${LOGLEVEL} -i "${OUTPUTNAME}.mp4" -ss 00:00:02.000 -frames:v 1 thumbnail.jpg

    echo "INFO: $(date) Removing temporary files"
    /bin/rm input.txt details.txt

    echo "INFO: $(date) Packaging video into archive"
    /bin/tar -czvf "${BASENAME}.tar.gz" "${OUTPUTNAME}.mp4" *.txt thumbnail.jpg

    echo "INFO: $(date) Moving video and thumbnail to upload directory"
    /bin/mv "${OUTPUTNAME}.mp4" "${VIDEOSFOLDER}/upload"
    /bin/mv "thumbnail.jpg" "${VIDEOSFOLDER}/upload/${OUTPUTNAME}.jpg"

    echo "INFO: $(date) Moving archive to archive directory"
    /bin/mv "${BASENAME}.tar.gz" "${VIDEOSFOLDER}/archive"
}


## main

cd "${VIDEOSFOLDER}"

for DIRNAME in */
do
    cd "${VIDEOSFOLDER}"

    checkDiskSpace

    if [[ "${DIRNAME}" == "upload/" || "${DIRNAME}" == "archive/" || "${DIRNAME}" == *"ignore"* ]]; then
        continue
    fi

    cd "${DIRNAME}"
    echo "INFO: $(date) Rendering video files in $(pwd)"

    renderAndArchiveVideo
done
