#!/bin/bash 

### Command to run Home Assistant from Docker
### TODO Convert to Docker Compose

docker run -d \
  --name homeassistant \
  --privileged \
  --restart=unless-stopped \
  -e TZ=America/Chicago \
  -v /home/iamadmin/haconfig:/config \
  --network=host \
  ghcr.io/home-assistant/home-assistant:stable
