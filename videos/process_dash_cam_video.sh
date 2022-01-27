#!/bin/bash

###############################################
## DESCRIPTION: Script used to create videos for the Kenny Ram Dash Cam YouTube channel
## AUTHOR: Kenny Robinson, @almostengr
##
## REFERENCES:
## https://superuser.com/questions/939357/how-to-position-drawtext-text
###############################################

DASHCAMFOLDER="/mnt/d74511ce-4722-471d-8d27-05013fd521b3/Kenny Ram Dash Cam"

function checkDiskSpace() {
    DISKSPACEUSED=$(df -h --output=pcent . | tail -1 | sed 's/[^0-9]*//g')

    echo "INFO: $(date) Disk space is ${DISKSPACEUSED}%"
    
    if [ ${DISKSPACEUSED} -gt 95 ]; then
        exit 3
    fi
}

function renderVideo() {
    echo "INFO: $(date) Performing cleanup"
    /bin/rm input.txt details.txt

    ## todo check why intro video causes problems with rendering

    # echo "INFO: $(date) Copying video intro"
    # /bin/cp -p "/mnt/d74511ce-4722-471d-8d27-05013fd521b3/ytvideostructure/dash_cam_opening_shortened.mp4" AAAAintro.mp4

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

    CONTAINSNIGHT=$(echo ${VIDEOTITLE} | grep -i night | wc -l)

    if [ ${CONTAINSNIGHT} -eq 1 ]; then
        COLOR="orange"
        BGCOLOR="black"
    fi

    FONTSIZE="h/35"
    DIMMEDBG="0.3"

    ## POSITIONS
    PADDING="20"
    UPPERLEFT="x=${PADDING}:y=${PADDING}"
    UPPERCENTER="x=(w-text_w)/2:y=${PADDING}"
    UPPERRIGHT="x=w-tw-${PADDING}:y=${PADDING}"
    CENTERED="x=(w-text_w)/2:y=(h-text_h)/2"
    LOWERLEFT="x=${PADDING}:y=h-th-${PADDING}-30"
    LOWERCENTER="x=(w-text_w)/2:y=h-th-${PADDING}-30"
    LOWERRIGHT="x=w-tw-${PADDING}:y=h-th-${PADDING}-30"

    GENERALDETAILS="fontcolor=white:fontsize=${FONTSIZE}:box=1:boxborderw=7:boxcolor=green:${LOWERCENTER}"

    DESTINATIONDETAILS=""
    if [ -f "destination.txt" ]; then
        echo "INFO: $(date) Found drive details file"
        DESTINATIONDETAILS=", drawtext=textfile=destination.txt:${GENERALDETAILS}:enable='between(t,5,12)'"
    fi

    MAJORROADDETAILS=""
    if [ -f "majorroads.txt" ]; then
        echo "INFO: $(date) Found major road details file"
        MAJORROADDETAILS=", drawtext=textfile=majorroads.txt:${GENERALDETAILS}:enable='between(t,12,20)'"
    fi

    SUBTITLESFILE=""
    if [ -f "subtitles.ass" ]; then
        echo "INFO: $(date) Found subtitles file"
        SUBTITLESFILE=", subtitles=subtitles.ass"
    fi

    SUBSCRIBE=", drawtext=text='SUBSCRIBE!':fontcolor=white:fontsize=h/16:box=1:boxborderw=7:boxcolor=red:${LOWERRIGHT}:enable='lt(mod(t,600),5)':${LOWERCENTER}"

    ## create thumbnail from title
    # echo "INFO: $(date) Creating thumbnail"
    # /usr/bin/convert thumbnail.jpg -background ${BGCOLOR} -size 1920x1080 -fill "${COLOR}" -pointsize 72 -gravity center label:"$(echo ${BASENAME} | fold -sw 20)" thumbnail.png
    # /usr/bin/convert -background ${BGCOLOR} -size 1920x1080 -fill "${COLOR}" -pointsize 72 -gravity center label:"$(echo ${BASENAME} | fold -sw 20)" thumbnail.jpg

    ## channel title
    CHANNELNAME="drawtext=textfile:'Kenny Ram Dash Cam':fontcolor=${COLOR}:fontsize=${FONTSIZE}:${UPPERRIGHT}:box=1:boxborderw=7:boxcolor=black"
    CHANNELNAME1="${CHANNELNAME}:enable='between(t,0,20)'"
    CHANNELNAME2=", ${CHANNELNAME}@${DIMMEDBG}:enable='gt(t,20)'"

    ## video title
    TITLETEXT=$(echo "${VIDEOTITLE}" | fold -sw 60)
    TITLE=", drawtext=textfile:'${VIDEOTITLE}':fontcolor=${COLOR}:box=1:boxborderw=7:boxcolor=black"
    TITLE3="${TITLE}:fontsize=${FONTSIZE}:${UPPERLEFT}:enable='between(t,0,20)'"
    TITLE2="${TITLE}@${DIMMEDBG}:fontsize=${FONTSIZE}:${UPPERLEFT}:enable='gt(t,20)'"

    /usr/bin/ffmpeg -y -f concat -i input.txt -an -vf "${CHANNELNAME1}${CHANNELNAME2}${TITLE2}${TITLE3}${DESTINATIONDETAILS}${MAJORROADDETAILS}${SUBTITLESFILE}" "${OUTPUTNAME}.mp4"

    echo "INFO: $(date) Creating thumbnail"
    /usr/bin/ffmpeg -i "${OUTPUTNAME}.mp4" -ss 00:00:02.000 -frames:v 1 thumbnail.jpg

    echo "INFO: $(date) Removing temporary files"
    /bin/rm input.txt details.txt

    echo "INFO: $(date) Packaging video into archive"
    /bin/tar -czvf "${BASENAME}.tar.gz" "${OUTPUTNAME}.mp4" *.txt thumbnail.jpg

    echo "INFO: $(date) Moving video and thumbnail to upload directory"
    /bin/mv "${OUTPUTNAME}.mp4" "${DASHCAMFOLDER}/upload"
    /bin/mv "thumbnail.jpg" "${DASHCAMFOLDER}/upload/${OUTPUTNAME}.jpg"

    echo "INFO: $(date) Moving archive to archive directory"
    /bin/mv "${BASENAME}.tar.gz" "${DASHCAMFOLDER}/archive"
}


## main

cd "${DASHCAMFOLDER}"

for VIDDIRECTORY in */
do
    cd "${DASHCAMFOLDER}"

    checkDiskSpace

    if [[ "${VIDDIRECTORY}" == "upload/" || "${VIDDIRECTORY}" == "archive/" ]]; then
        continue
    fi

    cd "${VIDDIRECTORY}"
    echo "INFO: $(date) Rendering video files in $(pwd)"

    renderVideo
done
