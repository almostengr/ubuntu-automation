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
HOSTNAME=$(/bin/hostname)

function clean_render_directory {
    log_message "Cleaning Working directory"
    cd ${WORKINGDIR}
    rm -rf *
}

function log_message {
    # echo "$(/bin/date) ${1}"
    echo "${1}"
}

function create_directory {
    if [[ ! -d ${1} ]]; then
        log_message "Creating directory ${1}"
        mkdir ${1}
    fi
}

# determine the type of video being rendered

if [[ "${1}" == "almostengineer" && "${HOSTNAME}" == "media" ]]; then
    log_message "Using almostengineer values"
    INCOMINGDIR=/mnt/ramfiles/almostengineer/incoming
    YOUTUBEDIR=/mnt/ramfiles/almostengineer/uploadready
    ARCHIVEDIR=/mnt/ramfiles/almostengineer/archive
    WORKINGDIR=/mnt/ramfiles/almostengineer/working
    DOTIMELAPSE=no
    TIMELAPSESPEED=0.5

elif [[ "${1}" == "dashcam" && "${HOSTNAME}" == "media" ]]; then
    log_message "Using dashcam values"
    INCOMINGDIR=/mnt/ramfiles/dashcam/incoming
    YOUTUBEDIR=/mnt/ramfiles/dashcam/uploadready
    ARCHIVEDIR=/mnt/ramfiles/dashcam/archive
    WORKINGDIR=/mnt/ramfiles/dashcam/working
    DOTIMELAPSE=yes
    TIMELAPSESPEED=0.25

elif [[ "${1}" == "almostengineer" && "${HOSTNAME}" == "aeoffice" ]]; then
    log_message "Using development values"
    INCOMINGDIR=/home/almostengineer/Downloads/renderserver/incoming
    YOUTUBEDIR=/home/almostengineer/Downloads/renderserver/youtube
    ARCHIVEDIR=/home/almostengineer/Downloads/renderserver/archive
    WORKINGDIR=/home/almostengineer/Downloads/renderserver/working
    DOTIMELAPSE=no
    TIMELAPSESPEED=0.5

else
    echo "Invalid value for arg 1 was passed in"
    echo "Usage: render_video.sh <channel>"
    echo "<channel> is either \"almostengineer\" or \"dashcam\""
    exit 2
fi

log_message "Check if process is already running"

PROCESSES=$(ps -ef | grep "${1}" | grep -v grep | grep render_video)
PROCESSCOUNT=$(echo "${PROCESSES}" | wc -l)

echo "${PROCESSES}"

if [ ${PROCESSCOUNT} -lt 3 ]; then
    log_message "Starting rendering process"
else
    log_message "Video rendering is already in progress"
    log_message "Exiting"
    exit 3
fi

# create directories if they do not exist

create_directory ${WORKINGDIR}
create_directory ${YOUTUBEDIR}
create_directory ${ARCHIVEDIR}

# change to the incoming file directory
cd ${INCOMINGDIR}

log_message 'Renamed incoming files'

rename 's/ /_/g' *

# loop through the files in the incoming directory
for TARFILENAME in $(ls -1 *.gz *.tar)
do

    clean_render_directory

    cd ${INCOMINGDIR}

    log_message "Processing ${TARFILENAME}"

    # handle file if tarred and compressed
    if [[ "${FILENAME}" == *".gz" ]]; then
        log_message "Uncompressing ${TARFILENAME}"
        /bin/gunzip ${TARFILENAME}

        TARFILENAME=$(echo ${TARFILENAME} | sed -e 's/.gz//g')
        TARFILENAME="${INCOMINGDIR}/${TARFILENAME}"
    fi

    # untar the file to the working directory
    log_message "Untarring file ${TARFILENAME}"

    /bin/tar -xf ${TARFILENAME} -C "${WORKINGDIR}"

    log_message "Done uncompressing file ${TARFILENAME}"

    # change to the working directory
    cd ${WORKINGDIR}

    rename 's/ /_/g' *kdenlive

    KDENLIVEPROJECTFILE=$(ls -1 *kdenlive)

    KDENLIVEFILE="${WORKINGDIR}/${KDENLIVEPROJECTFILE}"

    FINALVIDEOFILENAME=$(echo ${KDENLIVEPROJECTFILE} | sed -e 's/.kdenlive//g' )
    FINALVIDEOFILENAME="${FINALVIDEOFILENAME}.mp4"
    FINALVIDEOFILENAME="${YOUTUBEDIR}/${FINALVIDEOFILENAME}"

    log_message "Kdenlive file: ${KDENLIVEFILE}"
    log_message "Video Output file: ${FINALVIDEOFILENAME}"

    # get resolution from kdenlive file

    # RESOLUTION=$(grep "kdenlive:docproperties.profile" KDENLIVEFILE)
    # RESOLUTION=echo ${RESOLUTION} | sed -e "s|<property name=\"kdenlive:docproperties.profile\">||g"
    # RESOLUTION=echo ${RESOLUTION} | sed -e "s|</property>||g"

    # log_message "Resolution: ${RESOLUTION}"

    log_message "Removing line for excess black"

    RANDOMSTRING=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 15)
    TEMPKDENFILE=/tmp/${RANDOMSTRING}.tmp
    /bin/sed 's|<track producer="black_track"/>||g' ${KDENLIVEFILE} > ${TEMPKDENFILE}
    cp ${TEMPKDENFILE} ${KDENLIVEFILE}

    log_message "Removing consumer line"
    /bin/grep -v "<consumer" ${KDENLIVEFILE} > ${TEMPKDENFILE}
    cp ${TEMPKDENFILE} ${KDENLIVEFILE}

    log_message "Rendering video: ${FINALVIDEOFILENAME}"

    # $(${MELTBIN} ${KDENLIVEFILE}) > ${FINALVIDEOFILENAME} 2>&1
    # ${MELTBIN} -consumer -avformat:${FINALVIDEOFILENAME} ${KDENLIVEFILE}

#    ${MELTBIN} ${KDENLIVEFILE} -consumer avformat:${FINALVIDEOFILENAME} properties=x264-medium f=mp4 vcodec=libx264 acodec=aac \
#        g=120 crf=23 ab=160k preset=faster threads=4 real_time=-1

    ${MELTBIN} ${KDENLIVEFILE} -consumer avformat:${FINALVIDEOFILENAME} properties=x264-medium f=mp4 vcodec=libx264 acodec=aac \
        g=15 crf=23 ab=160k preset=faster threads=4 real_time=-1 preset=faster progressive=1

    # ${MELTBIN} ${KDENLIVEFILE} -consumer mlt_service=avformat target=${FINALVIDEOFILENAME} properties=x264-medium \ 
        # f=mp4 vcodec=libx264 acodec=aac g=15 crf=23 ab=160k preset=faster threads=4 real_time=-1 progressive=1
        # movflags=+faststart preset=faster

    log_message "Done rendering video: ${FINALVIDEOFILENAME}"

    if [[ "${DOTIMELAPSE}" == "yes" ]]; then
        # timelapse filename
        # TLVIDEOFILENAME=$( echo ${FINALVIDEOFILENAME} | sed -e "s|.mp4|timelapse.mp4|g")

        # generate timelapse file
        # ${FFMPEGBIN} -i ${FINALVIDEOFILENAME} -vf setpts=0.25*PTS -an ${TLVIDEOFILENAME}

        # call to the timelapse script
        log_message "Creating timelapse"

        /bin/bash "$(dirname \"${0}\")/timelapse.sh"

        log_message "Done creating timelapse"
    fi

    # archive the project

    log_message "Archiving the project"

    cd ${INCOMINGDIR}

    /bin/gzip ${TARFILENAME}

    ARCHIVEFILENAME="${TARFILENAME}"

    log_message "Moving the project to the archive"

    /bin/mv ${ARCHIVEFILENAME} ${ARCHIVEDIR}

    ls -1 ${ARCHIVEDIR}
done

# remove the rendering file once completed
log_message "Processing completed"

clean_render_directory
rm -f ${PROCESSFILENAME}

/bin/date
