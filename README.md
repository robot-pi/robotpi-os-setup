# Building Robot Pi OS

## Build Envrionment
1. Build machine: Ubuntu 20.04
2. Repo configuration tool: kas (https://kas.readthedocs.io/en/latest/)

## Ubuntu prerequisites:
```
sudo apt-get install gawk wget git diffstat unzip gcc-multilib \
        build-essential chrpath socat cpio python3-pip python3-pexpect \
        xz-utils debianutils iputils-ping \
        python3-git python3-jinja2 libegl1-mesa libsdl1.2-dev xterm \
        g++-multilib locales lsb-release python3-distutils time \
        liblz4-tool zstd file
sudo locale-gen en_US.utf8
```

## Installing kas

To create a Python virtual environment to install kas run these commands:
```
python3 -m venv venv
source venv/bin/activate
pip3 install kas
```

## Clone the robotpi-os-setup project
Create top-level project directory such `robotpi`. 
```
cd robotpi
git clone git@github.com:whni/robotpi-os-setup.git
```

## Running kas
There are multiple kas configration files under robotpi-os-setup directory:
1. `robotpi-os-setup/robotpi-os-qemux86-64.yml`
2. `robotpi-os-setup/robotpi-raspberrypi4-64.yml`
```
kas checkout robotpi-os-setup/robotpi-os-xxxx.yml
```
This will generate project configuration files such as local.conf and bblayers.conf
under build/conf and download all required layers under layers directory. Then use
bitbake to generate the target image.
```
source layers/openembedded-core/oe-init-build-env
bitbake ros-image-core
```
The above kas and bitbake steps can be also achieved by one-line command (NOT recommended):
```
kas build robotpi-os-setup/robotpi-os-xxxx.yml
```

<span style="color:red">NOTE: Please note that whenever you run kas checkout or build command,
all layer repos under layers directory will be refreshed based on kas yml configurations.
Please remember to save your changes before running any kas command!</span>.

## Writing the image
The raspberry pi image can be found as:
```
build/BUILD-${DISTRO}-xxxx/deploy/images/raspberrypi4-64/ros-image-core-humble-raspberrypi4-64.rootfs.wic.bz2
```

If using [Balena Etcher](https://etcher.balena.io/), you may provide it with
this file directly.