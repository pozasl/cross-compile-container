#!/bin/sh
# Run the container to build arm64
docker run -it --rm  --volume `pwd`:/workdir ubuntu-arm64toolchain-wiringpi:latest