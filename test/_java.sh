#!/bin/bash -e

echo "============================ JDK versions ==============================="


shipctl jdk set openjdk8
java -version
printf "\n"

shipctl jdk set openjdk11
java -version
printf "\n"
