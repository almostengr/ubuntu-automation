#!/bin/bash

## Description: remove nuget packages from system 
## suggested to run this once per month to clean disk clean

date
df -h . 
/usr/bin/dotnet nuget locals -c all
df -h . 
date
