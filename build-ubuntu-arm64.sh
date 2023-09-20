#!/bin/sh
#docker build -f docker/arm64/DockerFile -t ubuntu-arm64toolchain-wiringpi .
docker build -f docker/arm64_ubuntu_22.04/DockerFile -t ubuntu-22.04-arm64-toolchain .