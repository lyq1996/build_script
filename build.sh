#!/bin/bash
#  ./build.sh 1 to clean build before make
if [ -n "$1" ]; then
    clean_flag=$1
else
    clean_flag="0"
fi

# export OrangeFox flags
export OF_ALLOW_DISABLE_NAVBAR="0"
export OF_DISABLE_MIUI_SPECIFIC_FEATURES="1"    # Remove MIUI staff
export TW_DEVICE_VERSION="R10.1"
export BUILD_TYPE="Beta"

# build
cd /home/ubuntu/rec

# prepare modifed AromaFM.zip modify
# backup origin AromaFM.zip
if [ ! -f "vendor/recovery/FoxFiles/AromaFM/AromaFM-b.zip" ]; then  # last time build failed.
    echo "backup and replace AromaFM.zip to support Chinese"
    cp vendor/recovery/FoxFiles/AromaFM/AromaFM.zip vendor/recovery/FoxFiles/AromaFM/AromaFM-b.zip
    cp /home/ubuntu/AromaFM.zip vendor/recovery/FoxFiles/AromaFM/AromaFM.zip
fi

source build/envsetup.sh
lunch omni_dumpling-eng
if [ "$clean_flag" = "1" ]; then
    echo "clean build dir..."
    make clean
fi
make recoveryimage

# restore origin AromaFM.zip
echo "restore origin AromaFM.zip"
mv vendor/recovery/FoxFiles/AromaFM/AromaFM-b.zip vendor/recovery/FoxFiles/AromaFM/AromaFM.zip

if [ -f "nohup.out" ]; then  # copy log
    cp nohup.out $(date "+%Y-%m-%d-%H-%M-%S").log
    rm nohup.out
fi
