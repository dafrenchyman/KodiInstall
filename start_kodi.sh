#!/bin/bash

# Inputs
KODI_CONTAINER_NAME=kodi

# Copy bios' over
cp ./bios/scph*.bin ~/x11docker/$KODI_CONTAINER_NAME/.kodi/userdata/addon_data/game.libretro.pcsx-rearmed/resources/system/

# Mount all the samba shares you want

################################################################################
# To be able to mount cifs shares you must have cifs-utils installed
# sudo apt install -y cifs-utils
################################################################################
mount_cifs () {
  KODI_CONTAINER=$1
  HOST=$2
  SHARE=$3
  CIFS_USER=$4
  CIFS_PASS=$5
  mkdir -p ~/x11docker/$KODI_CONTAINER/shares/$HOST/$SHARE
  sudo mount -t cifs //$HOST/$SHARE/ ~/x11docker/$KODI_CONTAINER/shares/$HOST/$SHARE -o user=$CIFS_USER,pass=$CIFS_PASS,vers=1.0,ro
}

# Open Media Vault Shares
mount_cifs $KODI_CONTAINER_NAME "openmediavault.local" "Anime_Disk18" "xbmc" "xbmc"

export DISPLAY=":0.1"
sleep 1

sudo x11docker --home --hostdisplay --desktop --gpu --alsa --wm none -- --privileged -v /dev/bus/usb:/dev/bus/usb -v /etc/localtime:/etc/localtime:ro -- kodi &
sleep 5
export DISPLAY=":0.0"



