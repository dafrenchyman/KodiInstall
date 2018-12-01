#!/bin/bash

# Builds Kodi for X11.

cd /root/kodi-source

CORES=`nproc --all`

cmake --build . -- -j${CORES}
