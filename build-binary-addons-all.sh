#!/bin/bash

# Builds Kodi binary addons.
# Uses Kodi standard repository for binary addons.
# Note that Libretro cores are not compiled by this script.

# Configure Kodi standard repository for binary addons.
repofname="/root/kodi-source/cmake/addons/bootstrap/repositories/binary-addons.txt"
bin_addons_repo="binary-addons https://github.com/xbmc/repo-binary-addons.git master"
rm -f $repofname
echo $bin_addons_repo >> $repofname

CORES=`nproc --all`

# Build the addons
cd /root/kodi-source
rm -f /root/kodi-source/tools/depends/target/binary-addons/.installed-native
make -j${CORES} -C tools/depends/target/binary-addons PREFIX=/usr/local #PREFIX=/root/bin-kodi
