#!/bin/sh
cmake -DCMAKE_TOOLCHAIN_FILE=/cmake/aarch64-rpi4-linux-gnu.cmake -S .$WORKDIR_FOLDER -B .$BUILD_FOLDER
cmake --build .$BUILD_FOLDER