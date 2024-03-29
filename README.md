# Ubuntu Automation and Scripts

## Repository Archived

This repository has been archived. Updates to the scripts in this repository will be available
in the Technology section of
<a href="https://thealmostengineer.com target="_blank">thealmostengineer.com</a>.  You may use
the search functionality to find the scripts that you are looking for.

## About 

Scripts that can be used to automate repetitive tasks when setting up servers, 
desktops, performing periodic maintenance, or performing automation tasks. 

Some of the scripts here are used in the Kenny The Almost Engineer YouTube Channel. An 
Ubuntu video playlist has been created that demonstrates some of the scripts 
that are part of this repository.  You can watch the playlist by visiting 
[https://www.youtube.com/playlist?list=PLaAJ0fv0d9WPLAng19RpS1Q3jjMoG6eno](https://www.youtube.com/playlist?list=PLaAJ0fv0d9WPLAng19RpS1Q3jjMoG6eno).

Code and scripts used on my Youtube channel at 
<a href="https://www.youtube.com/channel/UC4HCouBLtXD1j1U_17aBqig" target="_blank">https://www.youtube.com/channel/UC4HCouBLtXD1j1U_17aBqig</a>.

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

---- 

## License 

See LICENSE for more details

----

## Author

Kenny Robinson, @almostengr

http://thealmostengineer.com

## Issues

Any issues or bugs that you have with the scripts can be addressed by 
[creating an issue](https://github.com/almostengr/ubuntu-automation/issues)
