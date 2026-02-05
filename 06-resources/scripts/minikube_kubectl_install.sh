#! /bin/bash

echo "========= Installing minikube =========="
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube

echo "======= Installing kubectl ========="
curl -LO "https://dl.k8s.io/release/$(curl -Ls https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install kubectl /usr/local/bin/kubectl

# Before starting minikube, make sure docker installed and running as service
echo "======= Start minikube cluster with docker driver ========="
minikube start --driver=docker