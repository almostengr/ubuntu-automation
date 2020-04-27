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

## Running Scripts

To run the script, just call the script via the command line. If a script requires
an argument to be passed, the script will display the values to be passed. Scripts 
can be called at scheduled times using crontab or other scheduling tool. Scripts 
were designed to be ran using the Bash shell.

### Hard Coded Paths

Some of the scripts have some of the paths to programs and files hardcoded into
the script. It is recommended that you change the paths to what matches your 
particular instance. 

### Running gitdeploy Usage

```bash
/path/to/folder/dodeployment.sh <codedir>
```

Replace *<codedir>* with the directory that the code exists in.

### Confirmed OS Version

Some scripts have the version that it is confirmed to working with contained in the
script header block. If you have issues with any of the scripts, confirm that the 
script has been designed for your particular system. If it has not, then you may 
need to make manual adjustments to the script.

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
