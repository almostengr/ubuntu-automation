#!/bin/bash

###############################################
## DESCRIPTION: Script used to create videos for YouTube and other social media outlets
## AUTHOR: Kenny Robinson, @almostengr
##
## REFERENCES:
## https://superuser.com/questions/939357/how-to-position-drawtext-text
###############################################

## POSITIONS CONSTANTS
PADDING="20"
UPPERLEFT="x=${PADDING}:y=${PADDING}"
UPPERCENTER="x=(w-text_w)/2:y=${PADDING}"
UPPERRIGHT="x=w-tw-${PADDING}:y=${PADDING}"
CENTERED="x=(w-text_w)/2:y=(h-text_h)/2"
LOWERLEFT="x=${PADDING}:y=h-th-${PADDING}-30"
LOWERCENTER="x=(w-text_w)/2:y=h-th-${PADDING}-30"
LOWERRIGHT="x=w-tw-${PADDING}:y=h-th-${PADDING}-30"
FONTSIZE="h/35"

## DIRECTORIES CONSTANTS
VIDEOSFOLDER="/mnt/d74511ce-4722-471d-8d27-05013fd521b3/videos"
INCOMINGDIR="${VIDEOSFOLDER}/incoming"
WORKINGDIR="${VIDEOSFOLDER}/working"
ARCHIVEDIR="${VIDEOSFOLDER}/archive"
UPLOADDIR="${VIDEOSFOLDER}/upload"

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

    RANDOMSUBINTERVAL=$(( ${RANDOM} % 999 + 1 )) ## random number between 1 and 999
    SUBSCRIBE=", drawtext=text='SUBSCRIBE!':fontcolor=white:fontsize=h/16:box=1:boxborderw=10:boxcolor=red:${LOWERRIGHT}:enable='lt(mod(t,${RANDOMSUBINTERVAL}),5)':${LOWERCENTER}"

    RANDOMCHANNELINTERVAL=$(( ${RANDOM} % 20 + 5 )) ## random number between 5 and 20

    ## channel title
    CHANNELNAME="drawtext=textfile:'Kenny Ram Dash Cam':fontcolor=${COLOR}:fontsize=${FONTSIZE}:${UPPERRIGHT}:box=1:boxborderw=7:boxcolor=black"
    CHANNELNAME1="${CHANNELNAME}:enable='between(t,0,${RANDOMCHANNELINTERVAL})'"
    CHANNELNAME2=", ${CHANNELNAME}@${DIMMEDBG}:enable='gt(t,${RANDOMCHANNELINTERVAL})'"

    ## video title
    TITLETEXT=$(echo "${VIDEOTITLE}" | fold -sw 60)
    TITLE=", drawtext=textfile:'${VIDEOTITLE}':fontcolor=${COLOR}:box=1:boxborderw=7:boxcolor=black"
    TITLE3="${TITLE}:fontsize=${FONTSIZE}:${UPPERLEFT}:enable='between(t,0,${RANDOMCHANNELINTERVAL})'"
    TITLE2="${TITLE}@${DIMMEDBG}:fontsize=${FONTSIZE}:${UPPERLEFT}:enable='gt(t,${RANDOMCHANNELINTERVAL})'"

    LOGLEVEL="error"

    /usr/bin/ffmpeg -hide_banner -loglevel ${LOGLEVEL} -y -f concat -i input.txt -an -vf "${CHANNELNAME1}${CHANNELNAME2}${TITLE2}${TITLE3}${DESTINATIONDETAILS}${MAJORROADDETAILS}${SUBTITLESFILE}${SUBSCRIBE}" "${OUTPUTNAME}.mp4"

    # merge audio and video

    echo "INFO: $(date) Creating thumbnail"
    /usr/bin/ffmpeg -hide_banner -loglevel ${LOGLEVEL} -i "${OUTPUTNAME}.mp4" -ss 00:00:02.000 -frames:v 1 thumbnail.jpg

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

function checkForExistingProcess() 
{
    PSOUTPUT=$(ps -ef | grep -e "process_youtube_videos" | wc -l)
    
    if [ ${PSOUTPUT} -gt 0 ]; then
        echo "Process is already running. Exiting"
        exit 5
    fi
}

function create_directory {
    if [[ ! -d ${1} ]]; then
        echo "INFO: Creating directory ${1}"
        mkdir ${1}
    fi
}

function clean_working_directory {
    echo "INFO: Cleaning working directory"
    cd ${WORKINGDIR}
    rm -rf *
}

## main

checkForExistingProcess

cd "${VIDEOSFOLDER}"

checkDiskSpace

cd ${INCOMINGDIR}

create_directory ${WORKINGDIR}
create_directory ${UPLOADDIR}
create_directory ${ARCHIVEDIR}

# for VIDDIRECTORY in */
for TARFILENAME in $(ls -1 *tar *gz)
do
    # cd "${VIDEOSFOLDER}/incoming"

    checkDiskSpace
    
    cd "${INCOMINGDIR}"

    echo "INFO: $(date) Performing cleanup"
    #/bin/rm input.txt details.txt
    clean_working_directory #/bin/rm "${WORKINGDIR}/*"

    if [[ "${TARFILENAME}" == *".gz" ]]; then
        echo "INFO: Uncompressing ${TARFILENAME}"
        /bin/gunzip ${TARFILENAME}
        TARFILENAME=$(echo ${TARFILENAME} | sed -e 's/.gz//g')
        TARFILENAME="${INCOMINGDIR}/${TARFILENAME}"
    fi

    echo "INFO: Untarring file ${TARFILENAME}"
    /bin/tar -xf ${TARFILENAME} -C "${WORKINGDIR}"
    echo "INFO: Done uncompressing file ${TARFILENAME}"


    #BASENAME=$(/usr/bin/basename "$(pwd)")
    #OUTPUTNAME="${BASENAME}"
    #VIDEOTITLE=$(cut -d ";" -f 1 <<< "${BASENAME}")
    VIDEOTITLE=$(cut -d ";" -f 1 <<< "${TARFILENAME}")

    #echo "INFO: $(date) Removing previous video files"
    #/bin/rm "${BASENAME}*"

    cd ${WORKINGDIR}

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

    # render video without filters for archiving

    if [ -f "dashcam.txt" ]; then
        echo "INFO: Dash Cam channel video"

        COLOR="white"
        BGCOLOR="black"

        CONTAINSNIGHT=$(echo ${VIDEOTITLE} | grep -i night | wc -l)

        if [ ${CONTAINSNIGHT} -eq 1 ]; then
            COLOR="orange"
            BGCOLOR="black"
        fi

        BRANDINGTEXT="Kenny Ram Dash Cam"

        RANDOMSUBINTERVAL=$(( ${RANDOM} % 999 + 1 )) ## random number between 1 and 999
        SUBSCRIBE=", drawtext=text='SUBSCRIBE!':fontcolor=white:fontsize=h/16:box=1:boxborderw=10:boxcolor=red:${LOWERRIGHT}:enable='lt(mod(t,${RANDOMSUBINTERVAL}),5)':${LOWERCENTER}"

        RANDOMCHANNELINTERVAL=$(( ${RANDOM} % 20 + 5 )) ## random number between 5 and 20

        ## channel title
        CHANNELNAME="drawtext=textfile:'${BRANDINGTEXT}':fontcolor=${COLOR}:fontsize=${FONTSIZE}:${UPPERRIGHT}:box=1:boxborderw=7:boxcolor=black"
        
        VIDEOFILTER+="${CHANNELNAME}:enable='between(t,0,${RANDOMCHANNELINTERVAL})'"
        VIDEOFILTER+=", ${CHANNELNAME}@${DIMMEDBG}:enable='gt(t,${RANDOMCHANNELINTERVAL})'"

        ## video title
        TITLETEXT=$(echo "${VIDEOTITLE}" | fold -sw 60)
        TITLE=", drawtext=textfile:'${VIDEOTITLE}':fontcolor=${COLOR}:box=1:boxborderw=7:boxcolor=black"

        VIDEOFILTER+="${TITLE}:fontsize=${FONTSIZE}:${UPPERLEFT}:enable='between(t,0,${RANDOMCHANNELINTERVAL})'"
        VIDEOFILTER+="${TITLE}@${DIMMEDBG}:fontsize=${FONTSIZE}:${UPPERLEFT}:enable='gt(t,${RANDOMCHANNELINTERVAL})'"

        GENERALDETAILS="fontcolor=white:fontsize=${FONTSIZE}:box=1:boxborderw=7:boxcolor=green:${LOWERCENTER}"

        if [ -f "destination.txt" ]; then
            echo "INFO: $(date) Found drive details file"
            VIDEOFILTER+=", drawtext=textfile=destination.txt:${GENERALDETAILS}:enable='between(t,5,12)'"
        fi

        if [ -f "majorroads.txt" ]; then
            echo "INFO: $(date) Found major road details file"
            VIDEOFILTER+=", drawtext=textfile=majorroads.txt:${GENERALDETAILS}:enable='between(t,12,20)'"
        fi

        if [ -f "subtitles.ass" ]; then
            echo "INFO: $(date) Found subtitles file"
            VIDEOFILTER+=", subtitles=subtitles.ass"
        fi

    elif [ -f "services.txt" ]
        echo "INFO: RHT Services channel video"

        COLOR="white"
        BGCOLOR="black"
    else
        echo "INFO: Unknown channel video"

        COLOR="white"
        BGCOLOR="black"
    fi


    echo "INFO: $(date) Rendering video"




    LOGLEVEL="error"

    #/usr/bin/ffmpeg -hide_banner -loglevel ${LOGLEVEL} -y -f concat -i input.txt -an -vf "${CHANNELNAME1}${CHANNELNAME2}${TITLE2}${TITLE3}${DESTINATIONDETAILS}${MAJORROADDETAILS}${SUBTITLESFILE}${SUBSCRIBE}" "${OUTPUTNAME}.mp4"
    /usr/bin/ffmpeg -hide_banner -loglevel ${LOGLEVEL} -y -f concat -i input.txt -an -vf "${VIDEOFILTER}" "${OUTPUTNAME}.mp4"

    # merge audio and video

    echo "INFO: $(date) Creating thumbnail"
    /usr/bin/ffmpeg -hide_banner -loglevel ${LOGLEVEL} -i "${OUTPUTNAME}.mp4" -ss 00:00:02.000 -frames:v 1 thumbnail.jpg

    echo "INFO: $(date) Removing temporary files"
    /bin/rm input.txt details.txt

    echo "INFO: $(date) Packaging video into archive"
    /bin/tar -czvf "${BASENAME}.tar.gz" "${OUTPUTNAME}.mp4" *.txt thumbnail.jpg

    echo "INFO: $(date) Moving video and thumbnail to upload directory"
    /bin/mv "${OUTPUTNAME}.mp4" "${DASHCAMFOLDER}/upload"
    /bin/mv "thumbnail.jpg" "${DASHCAMFOLDER}/upload/${OUTPUTNAME}.jpg"

    echo "INFO: $(date) Moving archive to archive directory"
    /bin/mv "${BASENAME}.tar.gz" "${DASHCAMFOLDER}/archive"
done
