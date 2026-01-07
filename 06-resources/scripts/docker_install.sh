#!/bin/bash
set -e

export DEBIAN_FRONTEND=noninteractive

echo "==== Updating system packages ===="
sudo apt-get update -y
sudo apt-get upgrade -y

sudo apt install docker.io -y

sudo systemctl start docker
sudo systemctl enable docker
sudo systemctl status docker


echo "==== Docker installation completed ===="