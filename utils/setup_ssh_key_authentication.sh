#!/bin/bash

###############################################################################
# Author: Kenny Robinson, @almostengr
# Video: https://www.youtube.com/watch?v=ZvM-QnQ1zWo
# Description: Generate SSH keys for password-less authentication and more.
###############################################################################

echo "Answer the questions that follow to generate the SSH key" 

ssh-keygen -t rsa

echo "Your key has been generated."
