#!/bin/bash

# constants

PARENT_DIR="/mnt/d74511ce-4722-471d-8d27-05013fd521b3/Kenny Ram Dash Cam"
OUTGOING_DIR="${PARENT_DIR}/outgoing"

cd "${PARENT_DIR}"

# move folder contents into tar files

for ${directory} in *20*/
do
    /bin/echo "INFO: $(date) Processing ${directory}"
    cd "${directory}"

    /usr/bin/touch "dashcam.txt"

    /bin/tar -cf "${directory}.tar" *

    /usr/bin/xz -z -e -T 2 -v "${directory}.tar.xz"

    /bin/mv *tar* "${OUTGOING_DIR}"

    cd "${PARENT_DIR}"

    TAR_PRESENT=$(/bin/ls -1 "${OUTGOING_DIR}/${directory}*" | wc -l)

    if [ ${TAR_PRESENT} -eq 1 ]; then
        /bin/echo "INFO: $(date) ${directory} tar file is present. Removing origial files"
        # /bin/rm -rf "${directory}"
    else
        /bin/echo "ERROR: $(date) ${directory} tar file is not present"
    fi
done
