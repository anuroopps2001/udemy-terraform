#!/bin/bash
set -e

export DEBIAN_FRONTEND=noninteractive

echo "==== Updating system packages ===="
sudo apt-get update -y
sudo apt-get upgrade -y


echo "===== Remove containerd packages if any ======"
sudo apt remove -y containerd*

sudo apt install docker.io -y

sudo systemctl enable docker --now

sudo usermod -aG docker ubuntu
newgrp docker
sudo systemctl restart docker
sudo systemctl enable docker


echo "==== Docker installation completed ===="