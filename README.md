# Build docker container of Kodi with retroplayer Dolphin (Gamecube, Wii) and PCSX2 (Playstation 2)

The whole point of this repo is to try and package a complete media entertainment system in a docker container. Sort of like an Libreelec, but without dedicating a whole computer to it. The idea is you can hook up a TV to your main box and set it up on it's own `SCREEN` session (or multiple `SCREEN`s. I have this feeding my living room and office right now). The other thought is that since you're passing your beefy main box to it, why not use some powerful emulators on the box as well. 

## Pre-reqs

The `start_kodi.sh` script assumes you've setup a 2nd Xserver screen that will be dedicated to Kodi. If this is not something you want to do, I would comment out the `export DISPLAY...` parts of that script. If you would like to dedicate a screen to Kodi (this makes it easy to still be able to use the computer while someone else is using Kodi via a controller on a TV), then I would suggest using nvidia's `NVIDIA X Server Settings` to set up an `X Screen 1` where you will run Kodi. Do note that some window managers don't play nice with this. I'm using Gnome 3 and it seems to be working fine.

## Install

Run the `build_container.sh` script first, and be prepared to wait a while. This script will also install x11docker (https://github.com/mviereck/x11docker) onto your system as well.

Once building is done, you simply run `start_kodi.sh`. The script can easily be modified to mount more CIFS volumns and you can also switch from `--alsa` to `--pulseaudio` in the part that runs `sudo x11docker`. You may need to play around with some of these settings to get what you want working correctly.

When Kodi is up and running, you'll have to specify the monitor and audio out you want each Kodi to use, so your regular `SCREEN` (your desktop) won't be affected. You may also want to play with setting `--wm=gnome` to `--wm=none` in the `start_kodi.sh` script once you have everything setup the way you like it. That way, your regular desktop can be used without affecting the Kodi sessions.

## TODOs

- You still need to manually setup *romcollectionbrowser* (https://github.com/maloep/romcollectionbrowser) as I haven't automated that process yet.
- PS2 & Gamecube audio require you pass your regular computer's audio over. I haven't figured out a way around this yet. :-(
- In Dolphin, you can setup your *guide* controller button to exit back to Kodi easy enough, but I haven't figured out away to do this in PCSX2 yet.
- More emulators
- ...

Enjoy, Fork, PR,... whatever :-D
