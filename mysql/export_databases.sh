#!/bin/bash

####################################################################
# Name: export_databases.sh
# Author: Kenny Robinson, @almostengr
# Usage: export_databases.sh
# Description: Export all the databases to a file.
####################################################################

source ./config.sh

if [ "${hostname}" == "" ]; then
	hostname="localhost"
fi

if [ "${port}" == "" ]; then
	port="3306"
fi

/usr/bin/mysqldump --all-databases -u "${USERNAME}" -p"${PASSWORD}" -h "${HOSTNAME}" > ${SQLFILE}

