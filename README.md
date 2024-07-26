This branch is for RB5N system image generation using build environment from thundercomm sdk manager. Please follow the instruction to setup docker environment first (https://tencpddgy2a.larksuite.com/docx/TanidCHfXoPOYnxU3m3uWj5msQc#Giu9dqPP0oPHrQxFqfwuimeesCM).

```
# rebuild rootfs
sudo ./build-system.sh
# enter fastboot mode
sudo fastboot flash system rootfs/qti-ubuntu-robotics-image-qrb5165-rb5-sysfs.ext4
```

After initial bootup, 
```
# push scripts to the device
adb root
adb push ./rb5n_ubuntu_setup /data

# enter adb shell (root permission)
cd /data/rb5n_ubuntu_setup
./ubuntu_initsetup.sh
```
