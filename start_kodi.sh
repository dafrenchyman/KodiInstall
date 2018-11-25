#!/bin/bash

# Inputs
KODI_CONTAINER_NAME=kodi

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

mount_cifs $KODI_CONTAINER_NAME "openmediavault.local" "consoles_disk23" "xbmc" "xbmc"

#DISPLAY=":0.1" sudo x11docker --home --hostdisplay --gpu --alsa -- "--privileged" kodi &
export DISPLAY=":0.1"
sleep 3



#sudo x11docker --home --hostdisplay --gpu --alsa -- "--privileged -v /dev/bus/usb:/dev/bus/usb" kodi &
#sudo x11docker --home --hostdisplay --gpu --alsa -- --privileged -v /dev/bus/usb:/dev/bus/usb -- kodi &
sudo x11docker --home --hostdisplay --gpu --alsa --wm none -- --privileged -v /dev/bus/usb:/dev/bus/usb -- kodi &
sleep 5
export DISPLAY=":0.0"
mate-panel --reset



