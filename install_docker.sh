#!/usr/bin/env bash
# Install docker
echo "Upgrading system..."
sudo apt update && sudo apt upgrade -y

echo "Installing Docker"
sudo apt install docker.io -y

echo "Configuring docker"
sudo service docker start
sudo usermod -a -G docker ubuntu

echo "All set up. Now, you have to exit and log in again for the changes to happen! Good Luck!"

echo "See also the Environment Variables you will have to set up"
echo ""
cat build_and_run.sh

echo ""
