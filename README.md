# Ubuntu Automation

## About 
Scripts that can be used to automate repetitive tasks when setting up servers, 
desktops, performing periodic maintenance, or performing automation tasks. 

Some of the scripts here are used in the Almost Engineer YouTube channel. An 
Ubuntu video playlist has been created that demonstrates some of the scripts 
that are part of this repository.  You can watch the playlist by visiting 
[https://www.youtube.com/playlist?list=PLaAJ0fv0d9WPLAng19RpS1Q3jjMoG6eno](https://www.youtube.com/playlist?list=PLaAJ0fv0d9WPLAng19RpS1Q3jjMoG6eno).

----

## System Requirements
All scripts have been tested and are confirmed to work on the Ubuntu version
mentioned in the script. Running these scripts on any other OS may result in unexpected
results as the code has not been tested on these systems.

### VirtualBox
Any Unix or Linux based system with Oracle VirutalBox installed. Code has been 
tested and confirmed to be working with Ubuntu 14.04 LTS using Oracle 
VirtualBox 5. Scripts may work on future editions of Ubuntu, but have not been 
tested on these versions.

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

### Running gitdeploy Usage
```bash
/path/to/folder/dodeployment.sh <codedir>
```

Replace *<codedir>* with the directory that the code exists in.

----

## Bug Reports
Please open a new issue on this repo. Include as much detail that you have so 
that the issue can be replicated.

---- 

## License 
See LICENSE for more details

----

## Author
Kenny Robinson, @almostengr
http://thealmostengineer.com
