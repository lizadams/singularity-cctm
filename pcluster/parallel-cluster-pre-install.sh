#!/bin/bash
set -x
yum update -y

# install docker
sudo yum install -y yum-utils
sudo yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install docker-ce docker-ce-cli containerd.io

# add docker group and put centos user in it

sudo groupadd docker
sudo usermod -aG docker centos

# enable and start docker service

sudo systemctl enable docker
sudo systemctl start docker
