#!/bin/bash -e
export JAVA_VERSION=11
echo "================ Installing openjdk"$JAVA_VERSION"-installer ============================="
sudo add-apt-repository ppa:openjdk-r/ppa
sudo apt-get update
sudo apt install -y openjdk-"$JAVA_VERSION"-jdk 
