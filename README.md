Robot-Pi Manifest Repository
=================

These are the setup scripts for the Robot-Pi OE buildsystem. If you want to (re)build packages or images, this is the thing to use.
The Robot-Pi OE buildsystem is using various components from the Yocto Project, most importantly the Openembedded buildsystem, the bitbake task executor and various application and BSP layers.

To configure the scripts and download the build metadata, do:
```
mkdir ~/bin
PATH=~/bin:$PATH

curl http://commondatastorage.googleapis.com/git-repo-downloads/repo > ~/bin/repo
chmod a+x ~/bin/repo
```
Run repo init to bring down the latest version of Repo with all its most recent bug fixes. You must specify a URL for the manifest, which specifies where the various repositories included in the Android source will be placed within your working directory. To check out the current branch, specify it with -b:
```
repo init -u git@github.com:whni/robotpi-os-setup.git -b linaro/kirkstone
```
When prompted, configure Repo with your real name and email address.

A successful initialization will end with a message stating that Repo is initialized in your working directory. Your client directory should now contain a .repo directory where files such as the manifest will be kept.

To pull down the metadata sources to your working directory from the repositories as specified in the default manifest, run
```
# sync to latest projects (local commits are abandoned)
repo sync
# rebase to latest project (local commits are reversed)
repo rebase
```
When downloading from behind a proxy (which is common in some corporate environments), it might be necessary to explicitly specify the proxy that is then used by repo:
```
export HTTP_PROXY=http://<proxy_user_id>:<proxy_password>@<proxy_server>:<proxy_port>
export HTTPS_PROXY=http://<proxy_user_id>:<proxy_password>@<proxy_server>:<proxy_port>
```
More rarely, Linux clients experience connectivity issues, getting stuck in the middle of downloads (typically during "Receiving objects"). It has been reported that tweaking the settings of the TCP/IP stack and using non-parallel commands can improve the situation. You need root access to modify the TCP setting:
```
sudo sysctl -w net.ipv4.tcp_window_scaling=0
repo sync -j1
```
In any sub-project/repository, you can push your commit(s) by:
```
git push <remote_url> HEAD:<remote_branch>

# manifest project
git push git@github.com:whni/robotpi-os-setup.git HEAD:linaro/kirkstone
# robotpi layer project
git push git@github.com:whni/meta-robotpi.git HEAD:main
```

Setup Build Environment
-----------------

MACHINE values can be:
* qrb5165-rb5
* dragonboard-410c
* dragonboard-820c
* ...

DISTRO values can be:
* robotpi
* robotpi-wayland (no supported image yet)
* rpb
* rpb-wayland

```
source setup-environment

# MACHINE=<machine> DISTRO=<distro> bitbake <image>
MACHINE=qrb5165-rb5 DISTRO=robotpi bitbake robotpi-desktop-image-debug

# once we have these env variables set, directly run bitbake in build-${DISTRO} directory:
# echo $MACHINE
# echo $DISTRO
# echo $SDKMACHINE
# bitbake <image>
bitbake robotpi-desktop-image-debug
```

NOTE: to prevent build process from being killed by the system, we need to stop out-of-memory manager on Ubuntu dev machine:
```
systemctl disable --now systemd-oomd
systemctl mask systemd-oomd

systemctl is-enabled systemd-oomd
```


Flash Image onto RB5 Board
-----------------------------
After the build process is done, the generated images can be found at `build-${DISTRO}/tmp-${DISTRO}-glibc/deploy/images/${MACHINE}/`, e.g., 
`build-robotpi/tmp-robotpi-glibc/deploy/images/qrb5165-rb5/`.

#### Kernel
- `boot-qrb5165-rb5.img` (soft link)
- `boot-qrb5165-rb5--6.0-r0-qrb5165-rb5-${TIMESTAMP}.img`

#### Device tree table
- `qrb5165-rb5.dtb` (soft link)
- `qrb5165-rb5--6.0-r0-qrb5165-rb5-${TIMESTAMP}.dtb`

#### Rootfs compressed image (release/debug/develop)
- `robotpi-desktop-image-debug-qrb5165-rb5.ext4.gz (soft link)`
- `robotpi-desktop-image-develop-qrb5165-rb5-${TIMESTAMP}.rootfs.ext4.gz`

Switch RB5 board into fastboot mode (presseing vol- while reconnecting power cable):
```
# list fastboot devices
fastboot devices

# flash kernel/boot partition
fastboot flash boot boot-qrb5165-rb5--6.0-r0-qrb5165-rb5-${TIMESTAMP}.img

# flash rootfs partition
# use real file since gunzip cannot read soft link
# or use graphic tool to uncompress soft link file
gunzip robotpi-desktop-image-develop-qrb5165-rb5-${TIMESTAMP}.rootfs.ext4.gz
fastboot flash rootfs robotpi-desktop-image-debug-qrb5165-rb5.ext4

# reboot
fastboot reboot
```

System Post-Configuration
-----------------------------
#### Remote Login
1. ADB: connecting host to the board USB-C port, use `adb shell` to log into the board (as root)
2. SSH: after the board connects to Internet, use `ssh username@ip_address`. The `username` can be `robotpi` or `root`.
   This option only works for debug/develop images.

#### Internet Connection
The system is using network manager to control network interfaces. To connect to Wi-Fi AP:
```
nmcli device
nmcli device wifi connect <SSID> password <PASSWORD>
```

Creating a local topic branch
-----------------------------

If you need to create local branches for all repos which then can be done e.g.
```
~/bin/repo start myangstrom --all
```
Where 'myangstrom' is the name of branch you choose

Updating the sandbox
--------------------

If you need to bring changes from upstream then use following commands
```
repo sync
```
Rebase your local committed changes
```
repo rebase
```
If you find any bugs please report them here

https://github.com/96boards/oe-rpb-manifest/issues

If you have questions or feedback, please subscribe to

https://lists.linaro.org/mailman/listinfo/openembedded

Maintainers
-------------------------

* Koen Kooi <mailto:koen.kooi@linaro.org>
* Nicolas Dechesne <nicolas.dechesne@linaro.org>
* Fathi Boudra <mailto:fathi.boudra@linaro.org>
