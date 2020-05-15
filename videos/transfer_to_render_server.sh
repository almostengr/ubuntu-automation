#!/bin/bash 

/bin/date

/bin/echo "Transferring files"

/usr/bin/scp -p /home/almostengineer/Videos/dashcamvideos/*tar.gz iamadmin@media://mnt/ramfiles/renderserver/dashpending/

/usr/bin/scp -p /home/almostengineer/Videos/aevideos/*tar.gz iamadmin@media://mnt/ramfiles/renderserver/aepending/

/bin/date 

/bin/echo "Moving files to archive"

mv /home/almostengineer/Videos/dashcamvideos/*tar.gz /mnt/d74511ce-4722-471d-8d27-05013fd521b3/Kenny\ Ram\ Dash\ Cam/archive

mv /home/almostengineer/Videos/aevideos/*tar.gz /mnt/d74511ce-4722-471d-8d27-05013fd521b3/Almost\ Engineer/archive

/bin/echo "Process complete"

/bin/date
