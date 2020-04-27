#!/bin/bash

echo "Current directory $(pwd)"

for filename in $(ls -1 *mp4 *MP4 *mov *MOV | grep -v -i timelapse )
do
	/bin/date

	echo "Starting on ${filename}"

	OUTPUTFILE="${filename}.timelapse.mp4"

	if [[ "${filename}" == *"mov" ]]; then
		OUTPUTFILE="${filename}.timelapse.mov"
	fi

	# /usr/bin/ffmpeg -i ${filename} -vf "setpts=0.75*PTS" -an ${filename}.Timelapse.mp4
	/usr/bin/ffmpeg -i ${filename} -vf "setpts=0.75*PTS" -an ${OUTPUTFILE}

	echo "Done with ${filename}"
done
