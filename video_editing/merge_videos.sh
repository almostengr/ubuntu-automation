#!/bin/bash

# Commands referenced from https://scribbleghost.net/2018/10/26/merge-video-files-together-with-ffmpeg/

/bin/date

/bin/echo "Current directory $(pwd)"

/bin/echo "Removing previous list file"
/bin/rm list.txt

echo "Adding files to list"
/usr/bin/touch list.txt

echo "Adding video intro"
# /bin/echo "file '/home/almostengineer/Videos/ytvideostructure/06clips/dash_cam_opening.mp4'" >> list.txt

for filename in $(ls -1tr | grep -v txt)
do
    /bin/echo "file '${filename}'" >> list.txt
done

echo "Rendering video"

/usr/bin/ffmpeg -f concat -i list.txt -c copy output.mov

echo "Done rendering video"

echo "Performing cleanup"

# /bin/rm list.txt

/bin/date
