# ARM32 - ARM64 CROSS COMPILE CONTAINER

An Unbuntu X86-64 base container for ARM64 or ARM32 with FPU (armhf) project compilation targeted at Rapsberry Pi 4.

It cames with 2 flavors:
- ubuntu-arm64toolchain for ARM 64 bits system
- ubuntu-armhf-toolchain for ARM 32 bits system with FPU (armhf)

It uses Debootstrap to create an ARM toolchain in a chrooted environment, and Qemu to install dependencies in this chroot.
Cmake and Ninja are available with a preconfigured .cmake file for the chrooted toolchain.

## System prerequisites
- docker
- binfmt-support
- qemu-user-static

## Building the containers

To build an ARM 64 toolchain from this project root directory
```bash
docker build -f docker/arm64/DockerFile -t ubuntu-arm64-toolchain .
```
Or simply run the build script
```bash
sh build-arm64.sh
```

To build an ARM 32 (armhf) toolchain from this project root directory
```bash
docker build -f docker/armhf/DockerFile -t ubuntu-armhf-toolchain .
```
Or simply run the build script
```bash
sh build-arm32.sh
```

## Using the container

In your ARM project's root directory :

For ARM64 project:
```bash
docker run -it --rm --user $(id -u):$(id -g) --volume `pwd`:/home/default/workdir ubuntu-arm64toolchain:latest
```

For ARM32 project:
```bash
docker run -it --rm --user $(id -u):$(id -g) --volume `pwd`:/home/default/workdir ubuntu-armhftoolchain:latest
```

The container will create a build folder in your project with the resulted binary.

 ## Extending the container

As a base container, you should extend it by creating your own container with your project's dependencies installed.
Those dependencies should be installed in the chrooted ARM environment.

Here's a sample Dockerfile to install wiringpi with boost, libwebsocket, libjsoncpp and libssl on an ARM64 toolchain:
```docker
FROM ubuntu-arm64-toolchain
# There's needed file structure when installing dependecies with apt for boost like passwd
USER root
RUN cp /etc/passwd ${CHROOT_PATH}/etc/passwd
RUN cp /etc/group ${CHROOT_PATH}/etc/group
# Sometimes the chroot environment can't resolve debian's repository hostname
RUN cp /etc/resolv.conf ${CHROOT_PATH}/etc/resolv.conf
#
# WiringPi chroot install
#-------------------------
# chroot sh -c is the only way to execute chrooted cmd, you can't use multiple RUN once chrooted in Docker.
RUN chroot ${CHROOT_PATH} sh -c 'apt-get update && apt-get install libboost-all-dev libjsoncpp-dev libwebsocketpp-dev libssl-dev wget -y \
&& wget https://github.com/WiringPi/WiringPi/releases/download/2.61-1/wiringpi-2.61-1-${RASPI_ARCH}.deb --no-check-certificate \
&& dpkg -i wiringpi-2.61-1-${RASPI_ARCH}.deb \
&& rm wiringpi-2.61-1-${RASPI_ARCH}.deb \
&& apt clean'
#-------------------------
USER default
```