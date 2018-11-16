FROM ubuntu:cosmic

# Install Git
RUN apt-get update && apt-get install -y git

# Install container dependencies
RUN apt-get install -y kmod xz-utils

# Install other dependencies #
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y x-window-system mesa-utils mesa-utils-extra libxv1 binutils pulseaudio tzdata xz-utils

# Install build dependencies
COPY install-build-dependencies-debian.sh /root/install-build-dependencies-debian.sh
RUN /root/install-build-dependencies-debian.sh

# Create kodi user
RUN useradd -ms /bin/bash kodi

USER kodi
WORKDIR /home/kodi

# Clone Kodi
RUN git clone https://github.com/xbmc/xbmc.git /home/kodi/kodi-source

# Copy/run configure script
COPY configure-kodi.sh /home/kodi/configure-kodi.sh
RUN ~/configure-kodi.sh

# Build Kodi
COPY build-kodi-x11.sh /home/kodi/build-kodi-x11.sh
RUN ~/build-kodi-x11.sh

# Install Kodi
COPY install-kodi.sh /home/kodi/install-kodi.sh
RUN ~/install-kodi.sh

# Build binary addons
COPY build-binary-addons-all.sh /home/kodi/build-binary-addons-all.sh
RUN ~/build-binary-addons-all.sh

# Build libretro cores
COPY build-binary-addons-libretro-cores.sh /home/kodi/build-binary-addons-libretro-cores.sh
RUN ~/build-binary-addons-libretro-cores.sh

ENTRYPOINT ["/home/kodi/bin-kodi/bin/kodi-standalone"]


# sudo docker build -t kodi .
# sudo x11docker --xorg --vt 1 --gpu --vt 1 --wm none --pulseaudio kodi


