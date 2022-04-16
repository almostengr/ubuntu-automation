#!/bin/bash

$(date)

for file in *
do
	echo "${file}"
	/usr/bin/xz -z "${file}" --threads=0
done

$(date)

