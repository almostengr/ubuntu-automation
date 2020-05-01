#!/bin/bash

## DESCRIPTION: This script batch processes project videos that have 
## been created with Kdenlive. This script is done in a data warehousing 
## fashion by staging, processing, and archiving the files.
## AUTHOR: Kenny Robinson @almostengr 
## DATE: 2020-04-28
## USAGE: render_video.sh <config>

/bin/date

MELTBIN=/usr/bin/melt
FFMPEGBIN=/usr/bin/ffmpeg
PROCESSFILENAME=/tmp/render.tmp
HOSTNAME=$(/bin/hostname)

function clean_render_directory {
    cd ${WORKINGDIR}
    rm -rf *
}

function log_message {
    /bin/date ${1}
}

function create_directory {
    if [[ ! -f ${1} ]]; then
        log_message "Creating directory ${1}"
        mkdir ${1}
    fi
}

# determine the type of video being rendered

if [[ "${1}" == "almostengineer" && "${HOSTNAME}" == "media" ]]; then
    log_message "Using almostengineer values"
    INCOMINGDIR=/mnt/ramfiles/youtubechannel/almostengineer/incoming
    YOUTUBEDIR=/mnt/ramfiles/youtubechannel/almostengineer/uploadready
    ARCHIVEDIR=/mnt/ramfiles/youtubechannel/almostengineer/archive
    WORKINGDIR=/mnt/ramfiles/renderyoutubechannelserver/almostengineer/working
    DOTIMELAPSE=no

elif [[ "${1}" == "dashcam" && "${HOSTNAME}" == "media" ]]; then
    log_message "Using dashcam values"
    INCOMINGDIR=/mnt/ramfiles/youtubechannel/dashcam/incoming
    YOUTUBEDIR=/mnt/ramfiles/youtubechannel/dashcam/uploadready
    ARCHIVEDIR=/mnt/ramfiles/youtubechannel/dashcam/archive
    WORKINGDIR=/mnt/ramfiles/youtubechannel/dashcam/working
    DOTIMELAPSE=yes

elif [[ "${HOSTNAME}" == "aeoffice" ]]; then
    log_message "Using development values"
    INCOMINGDIR=/home/almostengineer/Downloads/renderserver/incoming
    YOUTUBEDIR=/home/almostengineer/Downloads /renderserver/youtube
    ARCHIVEDIR=/home/almostengineer/Downloads/renderserver/archive
    WORKINGDIR=/home/almostengineer/Downloads/renderserver/working
    DOTIMELAPSE=no

else
    echo "Invalid value for arg 1 was passed in"
    echo "Usage: render_video.sh <channel>"
    echo "<channel> is either \"almostengineer\" or \"dashcam\""
    exit 2
fi

# create process file

if [ ! -f ${PROCESSFILENAME} ]; then
    touch ${PROCESSFILENAME}
    log_message "Started at $(date)" > ${PROCESSFILENAME}
else
    log_message "Video rendering is already in progress"
    exit 3
fi

# create directories if they do not exist

create_directory ${WORKINGDIR}
create_directory ${YOUTUBEDIR}
create_directory ${ARCHIVEDIR}

# change to the incoming file directory
cd ${INCOMINGDIR}

# loop through the files in the incoming directory
for FILENAME in $(ls -l *.gz *.tar)
do 
    cd ${INCOMINGDIR}

    log_message "Processing ${FILENAME}"

    # handle file if tarred and compressed
    if [[ "${FILENAME}" == *".gz" ]]; then
        log_message "Uncompressing ${FILENAME}"
        /bin/gunzip ${FILENAME}

        TARFILENAME=$(echo ${FILENAME} | sed -e 's/.gz//g')
        TARFILENAME="${INCOMINGDIR}/${TARFILENAME}"
    fi

    # untar the file to the working directory
    log_message "Untarring file ${TARFILENAME}"

    /bin/tar -xf ${TARFILENAME} -C ${WORKINGDIR}

    log_message "Done uncompressing file ${TARFILENAME}"

    # change to the working directory
    cd ${WORKINGDIR}

    KDENLIVEFILE=$(ls -1 *kdenlive)

    FINALVIDEOFILENAME=$(echo ${KDENLIVEFILE} | sed -e 's/.kdenlive//g' )
    FINALVIDEOFILENAME=${FINALVIDEOFILENAME}".mp4"
    FINALVIDEOFILENAME=${YOUTUBEDIR}"/${FINALVIDEOFILENAME}"

    log_message "Kdenlive file: "${KDENLIVEFILE}
    log_message "Video Output file: "${FINALVIDEOFILENAME}

    # get resolution from kdenlive file

    RESOLUTION=$(grep "kdenlive:docproperties.profile" KDENLIVEFILE)
    RESOLUTION=echo ${RESOLUTION} | sed -e "s|<property name=\"kdenlive:docproperties.profile\">||g"
    RESOLUTION=echo ${RESOLUTION} | sed -e "s|</property>||g"

    log_message "Resolution: ${RESOLUTION}"

    log_message "Rendering video: ${FINALVIDEOFILENAME}"

    ${MELTBIN} -consumer -avformat:${FINALVIDEOFILENAME} properties=x264-medium f=mp4 vcodec=libx264 acodec=aac \
        g=120 crf=23 ab=160k preset=faster threads=4 real_time=-1 -silent

    log_message "Done rendering video: ${FINALVIDEOFILENAME}"

    if [[ "${DOTIMELAPSE}" == "yes" ]]; then
        # timelapse filename
        # TLVIDEOFILENAME=$( echo ${FINALVIDEOFILENAME} | sed -e "s|.mp4|timelapse.mp4|g")

        # generate timelapse file
        # ${FFMPEGBIN} -i ${FINALVIDEOFILENAME} -vf setpts=0.25*PTS -an ${TLVIDEOFILENAME}

        # call to the timelapse script
        /bin/bash "$(dirname \"${0}\")/timelapse.sh"
    fi

    # archive the project
    cd ${INCOMINGDIR}

    /bin/gzip ${TARFILENAME}

    ARCHIVEFILENAME="${TARFILENAME}.gz"

    /bin/mv ${ARCHIVEFILENAME} ${ARCHIVEDIR}

    ls -1 ${ARCHIVEDIR}

    clean_render_directory
done

# remove the rendering file once completed
log_message "Processing completed"
rm -f ${PROCESSFILENAME}

/bin/date
