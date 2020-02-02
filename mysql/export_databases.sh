#!/bin/bash

####################################################################
# Name: export_databases.sh
# Author: Kenny Robinson, @almostengr
# Usage: export_databases.sh
# Description: Export all the databases to a file.
####################################################################

USERNAME="${1}"
PASSWORD="${2}"

if [ "${hostname}" == "" ]; then
	hostname="localhost"
fi

if [ "${port}" == "" ]; then
	port="3306"
fi

if [ "${USERNAME}" == "" ]; then
	echo "Username not provided"
	exit 1
fi

if [ "${PASSWORD"} == "" ]; then
	echo "Password not provided"
	echo 1
fi

/usr/bin/mysqldump --all-databases -u "${USERNAME}" -p"${PASSWORD}" -h "${HOSTNAME}" > ./databaseexport.sql

