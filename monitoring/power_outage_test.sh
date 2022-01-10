#!/bin/bash

## shutdown if router cannot be reached

TEST_PASS="N"
COUNT=0

while [[ ${TEST_PASS} == "N" ]] || [[ ${COUNT} -ge 2 ]]
do
	wget -q http://router

	RETURN_CODE=$?

	echo "Checking return code ${RETURN_CODE}"

	if [ ${RETURN_CODE} -ne 0 ]; then
		COUNT=$((${COUNT}+1))

		sleep 60
	else
		exit 0
	fi

	if [ ${COUNT} -ge 2 ]; then
		echo "do shutdown"
		shutdown -h now
		exit 1
	fi
done
