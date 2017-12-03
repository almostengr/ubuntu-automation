# Ubuntu Automation

## About 
Scripts that can be used to automate repetitive tasks when setting up servers, 
desktops, performing periodic maintenance, or performing automation tasks. 

Some of the scripts here are used in the Almost Engineer YouTube channel. Visit 
https://www.youtube.com/channel/UC4HCouBLtXD1j1U_17aBqig to the the scripts 
being used.

----

## System Requirements
All scripts have been tested and are confirmed to work on the Ubuntu version
mentioned in the script. Running these scripts on any other OS may result in unexpected
results as the code has not been tested on these systems.

### VirtualBox
Any Unix or Linux based system with Oracle VirutalBox installed. Code has been 
tested and confirmed to be working with Ubuntu 14.04 LTS using Oracle 
VirtualBox 5.

----

## Installing
- Pull the latest version of the code from the repository. 

### VirtualBox
On your local machine, copy config.example.sh to config.sh. Confirm that the 
paths in the config.sh file do exist on your local machine. If they do not, 
then update the paths in config.sh or create the necessary folders. The files 
will be automatically created and removed each time the script runs.

---- 

## Running Scripts
To run the script, just call the script via the command line. If a script requires
an argument to be passed, the script will display the values to be passed. Scripts 
can be called at scheduled times using crontab or other scheduling tool. Scripts 
were designed to be ran using the Bash shell.

----

## Contact Information 
Kenny Robinson, @almostengr (Twitter, Instagram)

----

## Bug Reports
Please open a new issue on this repo. Include as much detail that you have so 
that the issue can be replicated.

---- 

## License
This project is licensed under the MIT License. See LICENSE for more details.

