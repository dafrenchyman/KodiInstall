# Build docker container of kodi with retroplayer

Forked off of: https://github.com/Wintermute0110/KodiInstall

## Pre-reqs

The `start_kodi.sh` script assumes you've setup a 2nd Xserver screen that will be dedicated to Kodi. If this is not something you want to do, I would comment out the `export DISPLAY...` parts of that script. If you would like to dedicate a screen to Kodi (this makes it easy to still be able to use the computer while someone else is using Kodi via a controller on a TV), then I would suggest using nvidia's `NVIDIA X Server Settings` to set up an `X Screen 1` where you will run Kodi. Do note that some window managers don't play nice with this. I'm using Gnome 3 and it seems to be working fine.

## Install

Run the `build_container.sh` script first, and be prepared to wait a while. This script will also install x11docker (https://github.com/mviereck/x11docker) onto your system as well.

Once building is done, you simply run `start_kodi.sh`. The script can easily be modified to mount more CIFS volumns and you can also switch from `--alsa` to `--pulseaudio` in the part that runs `sudo x11docker`. You may need to play around with some of these settings to get what you want working correctly.

Good luck!
