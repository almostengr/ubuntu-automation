#!/bin/bash

####################################################################
# Name: export_databases.sh
# Author: Kenny Robinson, @almostengr
# Usage: export_databases.sh
# Description: Export all the databases to a file.
####################################################################


SQLFILENAME=
hostname=""
port="3306"

if [ "${hostname}" == "" ]; then
	hostname="localhost"
fi

if [ "${port}" == "" ]; then
	port="3306"
fi

/usr/bin/mysqldump --all-databases -u "${username}" -p"${password}" -h "${hostname}"


