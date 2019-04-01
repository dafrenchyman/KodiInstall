#!/bin/bash

# Cleans Kodi binary addons.

cd /root/kodi-source
make -j8 -C tools/depends/target/binary-addons PREFIX=/usr/local clean #PREFIX=/root/kodi/bin-kodi clean
