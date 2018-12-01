FROM ubuntu:cosmic

ENV DEBIAN_FRONTEND noninteractive

# Install Git
RUN apt-get update && apt-get install -y git

# Install container dependencies
RUN apt-get install -y kmod xz-utils

# Install other dependencies #
RUN apt-get install -y x-window-system mesa-utils mesa-utils-extra libxv1 binutils libasound2 libpulse0 pulseaudio tzdata smbclient nfs-common cifs-utils

# Install build dependencies
COPY ./kodi/install-build-dependencies-debian.sh /root/install-build-dependencies-debian.sh
RUN /root/install-build-dependencies-debian.sh

# Install nvidia drivers
COPY nvidia.run /root/nvidia.run
RUN chmod +x /root/nvidia.run
RUN /root/nvidia.run --accept-license --no-runlevel-check  --no-questions --ui=none --no-kernel-module --no-kernel-module-source --no-backup --tmpdir /tmp2

# Clone Kodi
RUN git clone https://github.com/xbmc/xbmc.git /root/kodi-source

# Copy/run configure script
COPY ./kodi/configure-kodi.sh /root/kodi-source/configure-kodi.sh
RUN /root/kodi-source/configure-kodi.sh

# Build Kodi
COPY ./kodi/build-kodi-x11.sh /root/kodi-source/build-kodi-x11.sh
RUN /root/kodi-source/build-kodi-x11.sh

# Install Kodi
COPY ./kodi/install-kodi.sh /root/kodi-source/install-kodi.sh
RUN /root/kodi-source/install-kodi.sh

# Build binary addons
COPY ./kodi/build-binary-addons-all.sh /root/kodi-source/build-binary-addons-all.sh
RUN /root/kodi-source/build-binary-addons-all.sh

# Build libretro cores
COPY ./kodi/build-binary-addons-libretro-cores.sh /root/kodi-source/build-binary-addons-libretro-cores.sh
RUN /root/kodi-source/build-binary-addons-libretro-cores.sh

ENTRYPOINT ["/usr/local/bin/kodi-standalone"]



