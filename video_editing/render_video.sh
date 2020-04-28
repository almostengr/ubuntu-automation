#!/bin/bash

## HEADER WITH DETAILS ABOUT THE SCRIPT 

/bin/date

MELTBIN=/usr/bin/melt
FFMPEGBIN=/usr/bin/ffmpeg
PROCESSFILENAME=/tmp/render.tmp

function clean_render_directory {
    rm -rf ${WORKINGDIR}
}

# determine the type of video being rendered
if [[ "${1}" == "almostengineer" ]]; then
    echo "Using almostengineer values"
    INCOMINGDIR=/mnt/ramfiles/renderserver/almostengineer/incoming
    YOUTUBEDIR=/mnt/ramfiles/renderserver/almostengineer/uploadready
    ARCHIVEDIR=/mnt/ramfiles/renderserver/almostengineer/archive
    WORKINGDIR=/mnt/ramfiles/renderserver/almostengineer/working
    DOTIMELAPSE=no
elif [[ "${1}" == "dashcam" ]]; then
    echo "Using dashcam values"
    INCOMINGDIR=/mnt/ramfiles/renderserver/dashcam/incoming
    YOUTUBEDIR=/mnt/ramfiles/renderserver/dashcam/uploadready
    ARCHIVEDIR=/mnt/ramfiles/renderserver/dashcam/archive
    WORKINGDIR=/mnt/ramfiles/renderserver/dashcam/working
    DOTIMELAPSE=yes
else
    echo "Invalid value for arg 1 was passed in"
    echo "Usage: render_video.sh <channel>"
    echo "<channel> is either \"almostengineer\" or \"dashcam\""
    exit 2
fi

# create process file

if [ ! -f ${PROCESSFILENAME} ]; then
    touch ${PROCESSFILENAME}
    echo "Started at $(date)" > ${PROCESSFILENAME}
else
    echo "Video rendering is already in progress"
    exit 3
fi

# loop through the files in the incoming directory

cd ${INCOMINGDIR}

for FILENAME in $(ls -l *.gz *.tar)
do 
    echo "Processing ${FILENAME}"

    # handle file if tarred and compressed
    if [[ "${FILENAME}" == *".gz" ]]; then
        echo "Uncompressing ${FILENAME}"
        /bin/gunzip ${FILENAME}

        TARFILENAME=$(echo ${FILENAME} | sed -e 's/.gz//g')
        TARFILENAME="${INCOMINGDIR}/${TARFILENAME}"
    fi

    # create output directory if it does not exist
    if [ ! -f ${WORKINGDIR} ];
        mkdir ${WORKINGDIR}
    fi

    # untar the file to the working directory
    echo "Untarring file ${TARFILENAME}"

    /bin/tar -xf ${TARFILENAME} -C ${WORKINGDIR}

    echo "Done uncompressing file ${TARFILENAME}"

    # 
    cd ${WORKINGDIR}

    KDENLIVEFILE=$(ls -1 *kdenlive)

    FINALVIDEOFILENAME=$(echo ${KDENLIVEFILE} | sed -e 's/.kdenlive//g' )
    FINALVIDEOFILENAME=${FINALVIDEOFILENAME}".mp4"
    FINALVIDEOFILENAME=${YOUTUBEDIR}"/${FINALVIDEOFILENAME}"

    echo "Kdenlive file: "${KDENLIVEFILE}
    echo "Video Output file: "${FINALVIDEOFILENAME}

    # get resolution from kdenlive file

    RESOLUTION=$(grep "kdenlive:docproperties.profile" KDENLIVEFILE)
    RESOLUTION=echo ${RESOLUTION} | sed -e "s|<property name=\"kdenlive:docproperties.profile\">||g"
    RESOLUTION=echo ${RESOLUTION} | sed -e "s|</property>||g"

    echo "Resolution: ${RESOLUTION}"

    echo "Rendering video: ${FINALVIDEOFILENAME}"

    ${MELTBIN} -consumer -avformat:${FINALVIDEOFILENAME} properties=x264-medium f=mp4 vcodec=libx264 acodec=aac \
        g=120 crf=23 ab=160k preset=faster threads=4 real_time=-1 -silent

    echo "Done rendering video: ${FINALVIDEOFILENAME}"

    if [[ "${DOTIMELAPSE}" == "yes" ]]; then
        # timelapse filename
        TLVIDEOFILENAME=$( echo ${FINALVIDEOFILENAME} | sed -e "s|.mp4|timelapse.mp4|g")

        # generate timelapse file
        ${FFMPEGBIN} -i ${FINALVIDEOFILENAME} -vf setpts=0.25*PTS -an ${TLVIDEOFILENAME}
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
rm -f ${PROCESSFILENAME}

/bin/date
