#!/bin/bash

# SCript to automatically commit the updates to the files and the push them to remote repository.

/bin/date

if [ "${1}" == "" ]
then
    exit 1;
fi

cd ${1}

OUTPUT=$(/usr/bin/git status)

ROWCOUNT=$(echo ${OUTPUT} | /bin/grep -i "nothing to commit, working tree clean" | wc -l)

if [ ${ROWCOUNT} -eq 0 ]
then

/usr/bin/git add .

/usr/bin/git commit -m 'Commiting new files'

/usr/bin/git fetch -p

/usr/bin/git push

fi

/bin/date
