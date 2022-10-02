#!/bin/bash

$(date)

cd /home/iamadmin/Videos/compressed

for file in *
do
	echo "${file}"
	/usr/bin/xz -z "${file}" --threads=0
done

$(date)

