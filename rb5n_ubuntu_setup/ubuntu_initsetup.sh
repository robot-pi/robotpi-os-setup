#!/bin/bash

# root password
echo "root:123456" | chpasswd

# robotpi newuser
useradd -m -d /home/robotpi -s /bin/bash robotpi
echo "robotpi:123456" | chpasswd
usermod -aG sudo robotpi

# update package
UBUNTU_ROBOTPI_PACKAGES=" \
    sudo \
    pciutils \
    iproute2 \
    dialog \
    tmux \
    htop \
    network-manager \
    gdm3 \
    gnome-session \
    gnome-terminal \
    gnome-control-center \
    nautilus \
    gnome-tweaks \
    ubuntu-wallpapers \
"

apt update
apt --fix-broken install -y
apt-get install ${UBUNTU_ROBOTPI_PACKAGES} -y

# display manager setup
WESTON_BOOTUP_PROP='persist.display.launch.weston.at.bootup'
sed -i "s/${WESTON_BOOTUP_PROP}=true/${WESTON_BOOTUP_PROP}=false/g" /build.prop
systemctl disable init_display
dpkg-reconfigure gdm3

# network setup
cp ./wlan_daemon_script /etc/initscripts/wlan
systemctl enable network-manager

