#!/bin/bash

# First check if we need to install an nvidia driver
if [ -e "/proc/driver/nvidia" ]; then
    NVIDIA_VER=$(head -n1 </proc/driver/nvidia/version | awk '{ print $8 }')
    wget -O nvidia.run https://download.nvidia.com/XFree86/Linux-x86_64/${NVIDIA_VER}/NVIDIA-Linux-x86_64-${NVIDIA_VER}.run
else
    echo "#!/bin/bash" > nvidia.run
fi
chmod +x nvidia.run

# Install x11docker (https://github.com/mviereck/x11docker)
wget https://raw.githubusercontent.com/mviereck/x11docker/master/x11docker -O /tmp/x11docker
sudo bash /tmp/x11docker --update
rm /tmp/x11docker

# Build the docker container
sudo docker build --no-cache -t kodi_test .
