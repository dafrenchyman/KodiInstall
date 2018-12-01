#!/bin/bash

# Creates build directory and configures Kodi build.

cd /root/kodi-source

# cmake ../kodi-source -DCMAKE_INSTALL_PREFIX=/home/kodi/bin-kodi -DENABLE_INTERNAL_FLATBUFFERS=ON -DVERBOSE=ON
#cmake ../kodi-source -DCMAKE_INSTALL_PREFIX=/home/kodi/bin-kodi -DENABLE_INTERNAL_FLATBUFFERS=ON
cmake ../kodi-source  -DENABLE_INTERNAL_FLATBUFFERS=ON
