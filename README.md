# Git Deploy
Automatically checkout the master branch of the repository.

## Purpose 
To automatically pull the lastest commit of the master branch from origin. Can be used 
as a cron job to schedule continuous deployments or integrations.

## Setup 
1) Copy the latest master branch to the server. 
2) Create a cron job that calls the script.

## Usage 
```bash 
/path/to/folder/dodeployment.sh codedir
``` 

Replace *codedir* with the directory that the code exists in.

## License 
See LICENSE for more details

## Features / Bugs
Features and bugs will be tracked using the issue queue on the repository. 
Visit https://github.com/bitsecondal/gitdeploy for more information.

