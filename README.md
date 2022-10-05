# ARM32 - ARM 64 CROSS COMPILE CONTAINER

An Unbuntu X86-64 base container for ARM64 or ARM32 with FPU (armhf) project compilation targeted at Rapsberry Pi 4.

It cames with 2 flavors:
- ubuntu-arm64toolchain for ARM 64 bits system
- ubuntu-armhf-toolchain for ARM 32 bits system with FPU (armhf)

It uses Debootstrap to create a ARM toolchain in a chrooted environment, and Qemu to install librairies dependencies in this chroot.
Cmake an Ninja are available with a .cmake file to configure the chrooted toolchain.

## Building the containers

To build an the ARM 64 toolchain from this project root directory
```bash
docker build -f docker/arm64/DockerFile -t ubuntu-arm64-toolchain .
```
Or simply run the build script
```bash
sh build-arm64.sh
```

To build an the ARM 32 (armhf) toolchain from this project root directory
```bash
docker build -f docker/armhf/DockerFile -t ubuntu-armhf-toolchain .
```
Or simply run the build script
```bash
sh build-arm32.sh
```

## Using the container

In your ARM project root directory :
```bash
docker run -it --rm  --volume `pwd`:/workdir ubuntu-arm64toolchain:latest
 ```

 The container will create a build folder with the resulted binary.

 ## Extending the container

As a base container you should extend it by creating your own container to install your project dependencies.
Those dependencies should be installed in both the chrooted ARM environment and the x86-64 container.

Here's an example to install wiringpi :
```docker
FROM ubuntu-arm64-toolchain
# There's needed file structure when installing dependecies with apt for boost like passwd
RUN cp /etc/passwd ${CHROOT_PATH}/etc/passwd
RUN cp /etc/group ${CHROOT_PATH}/etc/group
#
# WiringPi chroot install
#-------------------------
# chroot sh -c is the only way to execute chrooted cmd, you can't use multiple RUN once chrooted in Docker.
RUN chroot ${CHROOT_PATH} sh -c 'apt-get update && apt-get install libboost-all-dev libjsoncpp-dev libwebsocketpp-dev libssl-dev wget -y \
&& wget https://github.com/WiringPi/WiringPi/releases/download/2.61-1/wiringpi-2.61-1-${RASPI_ARCH}.deb --no-check-certificate \
&& dpkg -i wiringpi-2.61-1-${RASPI_ARCH}.deb'
#-------------------------
# Install same libraries for X86-64
RUN apt-get install -y libboost-all-dev libjsoncpp-dev libwebsocketpp-dev libssl-dev
```