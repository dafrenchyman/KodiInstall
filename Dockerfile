FROM ubuntu:cosmic

ENV DEBIAN_FRONTEND noninteractive

# Install Git
RUN apt-get update && apt-get install -y git

# Install container dependencies
RUN apt-get install -y kmod xz-utils

# Install other dependencies #
RUN apt-get install -y x-window-system mesa-utils mesa-utils-extra libxv1 binutils libasound2 libpulse0 pulseaudio tzdata smbclient nfs-common

# Install nvidia driver
COPY NVIDIA-Linux-x86_64-415.13.run /root/NVIDIA-Linux-x86_64-415.13.run 
RUN chmod +x /root/NVIDIA-Linux-x86_64-415.13.run 
RUN /root/NVIDIA-Linux-x86_64-415.13.run --accept-license --no-runlevel-check  --no-questions --ui=none --no-kernel-module --no-kernel-module-source --no-backup --tmpdir /tmp2

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

COPY ChronoTrigger.sfc /home/kodi/ChronoTrigger.sfc

# sudo docker build -t kodi .
# sudo x11docker --xorg --vt 8 --gpu --wm none --alsa --user=RETAIN kodi
# sudo x11docker --xorg --vt 8 --hostnet --wm none --pulseaudio -- "--cap-add SYS_ADMIN --cap-add DAC_READ_SEARCH" kodi

# sudo x11docker --xorg --vt 8 --pulseaudio kodi
# sudo x11docker --xorg --vt 8 --pulseaudio --wm none --gpu erichough/kodi

# sudo x11docker --xorg --vt 8 --hostnet  --gpu --wm none --alsa --user=RETAIN kodi



