#!/bin/sh
#docker build -f docker/arm64/DockerFile -t ubuntu-arm64toolchain-wiringpi .
docker build -f docker/arm64/DockerFile-Ubuntu-22.04 -t ubuntu-22.04-arm64-toolchain .