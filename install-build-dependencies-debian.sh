#!/bin/bash

# Install Kodi build dependencies for Debian unstable (October 2018).

# Install build tools
apt-get install -y \
    build-essential debhelper \
    autoconf automake autopoint gettext autotools-dev cmake curl \
    default-jre doxygen gawk gdc gperf libtool \
    lsb-release swig unzip yasm zip ccache

# Python stuff
apt-get install -y python-dev python-pil

# Install build libraries (alphabetical order0
apt-get install -y \
    libasound2-dev \
    libass-dev \
    libavahi-client-dev \
    libavahi-common-dev \
    libbluetooth-dev \
    libbluray-dev \
    libbz2-dev \
    libcdio-dev \
    libcec-dev \
    libcrossguid-dev \
    libcurl4-openssl-dev \
    libcwiid-dev \
    libdbus-1-dev \
    libegl1-mesa-dev \
    libenca-dev \
    libflac-dev \
    libfontconfig-dev \
    libfreetype6-dev \
    libfribidi-dev \
    libfstrcmp-dev \
    libfmt-dev \
    libgcrypt-dev \
    libgif-dev \
    libgles2-mesa-dev \
    libgl1-mesa-dev \
    libglu1-mesa-dev \
    libgnutls28-dev \
    libgpg-error-dev \
    libiso9660-dev \
    libjpeg-dev \
    liblcms2-dev \
    liblirc-dev \
    libltdl-dev \
    liblzo2-dev \
    libmicrohttpd-dev \
    libmysqlclient-dev \
    libnfs-dev \
    libogg-dev \
    libpcre3-dev \
    libplist-dev \
    libpng-dev \
    libpulse-dev \
    libp8-platform-dev \
    libsmbclient-dev \
    libsqlite3-dev \
    libssl-dev \
    libtag1-dev \
    libtiff5-dev \
    libtinyxml-dev \
    libudev-dev \
    libva-dev \
    libvdpau-dev \
    libvorbis-dev \
    libxmu-dev \
    libxrandr-dev \
    libxslt1-dev \
    libxt-dev \
    rapidjson-dev \
    uuid-dev \
    zlib1g-dev
