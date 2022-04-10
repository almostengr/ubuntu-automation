#!/bin/bash

# constants

PARENT_DIR="/mnt/d74511ce-4722-471d-8d27-05013fd521b3/Kenny Ram Dash Cam"
OUTGOING_DIR="${PARENT_DIR}/outgoing"

cd "${PARENT_DIR}"

# move folder contents in to tar files

for ${directory} in *20*/
do
    cd "${directory}"

    /usr/bin/touch "dashcam.txt"

    /bin/tar -cf "${directory}.tar" *

    /usr/bin/xz -z -e -T 2 -v "${directory}.tar"

    cd "${PARENT_DIR}"
done

# move compressed files to directory for transfer

cd "${PARENT_DIR}"

/bin/mv *tar.xz "${OUTGOING_DIR}"