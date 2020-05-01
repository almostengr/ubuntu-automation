#!/bin/bash

/bin/date

FILENAME="${1}"

# input video file must be provided
if [[ "${FILENAME}" != "" ]]; then
	echo "Input video file: ${FILENAME}"

	# for filename in $(ls -1 *mp4 *MP4 *mov *MOV | grep -v -i timelapse )
	# do

	echo "Starting on ${FILENAME}"

	MODFILENAME=$(echo ${FILENAME} | sed 's/.mp4//g')
	OUTPUTFILE="${MODFILENAME}.timelapse.mp4"

	if [[ "${FILENAME}" == *"mov" ]]; then
		# OUTPUTFILE="$(echo ${FILENAME} | sed 's/.mov//g').timelapse.mov"
		MODFILENAME=$(echo ${FILENAME} | sed 's/.mov//g')
		OUTPUTFILE="${MODFILENAME}.timelapse.mov"
		
	elif [[ "${FILENAME}" == *"mkv" ]]; then
		MODFILENAME=$(echo ${FILENAME} | sed 's/.mkv//g')
		OUTPUTFILE="${MODFILENAME}.timelapse.mkv"
	fi

	# /usr/bin/ffmpeg -i ${filename} -vf "setpts=0.75*PTS" -an ${filename}.Timelapse.mp4
	/usr/bin/ffmpeg -i ${FILENAME} -vf "setpts=0.75*PTS" -an ${OUTPUTFILE}

	echo "Done with ${FILENAME}"
	# done

else 
	echo "The video file to timelapse was not provided."
fi

/bin/date
