#! /bin/bash
sudo apt update && sudo apt upgrade -y
sudo apt install docker.io -y
sudo service docker start
sudo usermod -a -G docker ubuntu
git clone https://github.com/neylsoncrepalde/mlflow-aws.git
