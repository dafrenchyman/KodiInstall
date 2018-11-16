#!/bin/bash

# Builds Kodi for X11.

mkdir -p /home/kodi/kodi-build
cd /home/kodi/kodi-build

CORES=`nproc --all`

cmake --build . -- -j${CORES}
