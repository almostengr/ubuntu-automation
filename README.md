# Git Deploy
Automatically checkout the master branch of the repository.

## Purpose 
To automatically pull the lastest commit of the master branch. Can be used as a cron job to schedule deployments.

## Setup 
1) Copy the latest master branch to the server. 
2) Create a cron job that calls the script.

## Usage 
```bash 
dodeployment.sh *codedir*
``` 

Replace *codedir* with the directory that the code exists in.

