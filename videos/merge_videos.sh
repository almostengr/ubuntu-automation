#!/bin/bash

# Commands referenced from https://scribbleghost.net/2018/10/26/merge-video-files-together-with-ffmpeg/

/bin/date

/bin/echo "Current directory $(pwd)"

# /bin/echo "Removing previous list file"
# /bin/rm list.txt

echo "Adding files to list"
# /usr/bin/touch list.txt

echo "Adding video intro"
# /bin/echo "file '/home/almostengineer/Videos/ytvideostructure/06clips/dash_cam_opening.mp4'" >> list.txt

OUTPUTFILE="output.mp4"

# for filename in $(ls -1tr *mp4 *MP4 *mov *MOV | grep -v output)
for filename in $(ls -1 *mp4 *MP4 *mov *MOV | grep -v output)
do
    /bin/echo "file '${filename}'" >> list.txt

    if [[ "${filename}" == *"mp4" ]]; then
	OUTPUTFILE=output.mp4
    elif [[ "${filename}" == *"mov" ]]; then
        OUTPUTFILE=output.mov
    else
        OUTPUTFILE=output.mov
    fi
done

echo "Rendering video"

# /usr/bin/ffmpeg -f concat -i list.txt -c copy output.mov
/usr/bin/ffmpeg -f concat -i list.txt -c copy ${OUTPUTFILE}

echo "Done rendering video"

echo "Performing cleanup"

# /bin/rm list.txt

/bin/date
