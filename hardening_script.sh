#!/bin/bash

set -x

openssl version -v

openssl version -b

apt-get update

apt-get upgrade openssl libssl-dev

apt-cache policy openssl libssl-dev

openssl version -b

ufw allow from 192.168.1.0/24 to any port 22

ufw allow from 192.168.1.0/24 to any port 10000

ufw enable

echo 'ALERT - ACCESS GRANTED on:' `date` `who` | mail -s "ALERT - ACCESS GRANTED from `who | awk '{print $6}'`" tharam04@yahoo.com >> /root/.bash_profile

apt-get install fail2ban -y

apt-get upgrade -y

apt-get dist-upgrade -y

apt-get autoremove -y

set +x
