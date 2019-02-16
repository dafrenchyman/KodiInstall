#!/bin/bash

################################################################################
# Inputs
################################################################################

# Setup arrays that will store what we need
KODI_DOCKER_NAMES=("kodi_living_room" "kodi_office")
USB_PASSTHROUGH=("/dev/input/js1" "/dev/input/js0")
DISPLAYS=(":0.2" ":0.1")

# Kodi resources
KODI_RESOURCES="kodi_resources"
MARIADB_PASS="kodimaria"


################################################################################
# Functions
################################################################################

# Copy emulator bioses
copy_bioses () {
    KODI_PROCESS_NAME=$1
    for i in "${KODI_PROCESS_NAME[@]}"
    do
        # Copy PSX bxos
        mkdir -p ~/${KODI_RESOURCES}/$i/.kodi/userdata/addon_data/game.libretro.pcsx-rearmed/resources/system/
        cp ./bios/scph*.bin ~/${KODI_RESOURCES}/$i/.kodi/userdata/addon_data/game.libretro.pcsx-rearmed/resources/system/
        cp ./bios/scph*.bin ~/${KODI_RESOURCES}/$i/.kodi/userdata/addon_data/game.libretro.beetle-psx/resources/system

        # Copy Sega CD Bios
        mkdir -p ~/${KODI_RESOURCES}/$i/.kodi/userdata/addon_data/game.libretro.genplus/resources/system/
        cp ./bios/bios_CD_E.bin ~/${KODI_RESOURCES}/$i/.kodi/userdata/addon_data/game.libretro.genplus/resources/system/
        cp ./bios/bios_CD_U.bin ~/${KODI_RESOURCES}/$i/.kodi/userdata/addon_data/game.libretro.genplus/resources/system/
        cp ./bios/bios_CD_J.bin ~/${KODI_RESOURCES}/$i/.kodi/userdata/addon_data/game.libretro.genplus/resources/system/

        # Master System
        cp ./bios/bios_E.bin ~/${KODI_RESOURCES}/$i/.kodi/userdata/addon_data/game.libretro.genplus/resources/system/
        cp ./bios/bios_U.bin ~/${KODI_RESOURCES}/$i/.kodi/userdata/addon_data/game.libretro.genplus/resources/system/
        cp ./bios/bios_J.bin ~/${KODI_RESOURCES}/$i/.kodi/userdata/addon_data/game.libretro.genplus/resources/system/

        # Game Gear
        cp ./bios/bios.gg ~/${KODI_RESOURCES}/$i/.kodi/userdata/addon_data/game.libretro.genplus/resources/system/
    done
}

# Mount all the samba shares you want
# To be able to mount cifs shares you must have cifs-utils installed
# sudo apt install -y cifs-utils
mount_cifs () {
    local HOST=$1
    local SHARE=$2
    local CIFS_USER=$3
    local CIFS_PASS=$4
    shift
    shift
    shift
    shift
    local KODI_PROCESS_NAME=("$@")
    for i in "${KODI_PROCESS_NAME[@]}"
    do
        echo "Docker image: ${i} share: $HOST/$SHARE"
        mkdir -p ~/${KODI_RESOURCES}/$i/shares/$HOST/$SHARE
        sudo mount -t cifs //$HOST/$SHARE/ ~/${KODI_RESOURCES}/$i/shares/$HOST/$SHARE -o user=$CIFS_USER,pass=$CIFS_PASS,vers=1.0,ro
    done
}


# Start mariadb (common db for the kodi instances)
mkdir -p ~/${KODI_RESOURCES}/mariadb
sudo docker run --name kodi-mariadb \
     -v ~/${KODI_RESOURCES}/mariadb:/var/lib/mysql \
     -v /etc/localtime:/etc/localtime:ro \
     -e MYSQL_ROOT_PASSWORD=${MARIADB_PASS} -d mariadb:latest
MARIA_DOCKER=`sudo docker ps | grep kodi-mariadb | cut -f1 -d ' '`
sleep 5

sudo docker exec -it kodi-mariadb mysql -p${MARIADB_PASS} -e "CREATE USER IF NOT EXISTS 'kodi' IDENTIFIED BY 'kodi';"
sudo docker exec -it kodi-mariadb mysql -p${MARIADB_PASS} -e "SET PASSWORD FOR 'kodi'@'%' = PASSWORD('${MARIADB_PASS}');"
sudo docker exec -it kodi-mariadb mysql -p${MARIADB_PASS} -e "GRANT ALL ON *.* TO 'kodi';"
sudo docker exec -it kodi-mariadb mysql -p${MARIADB_PASS} -e "flush privileges;"

MARIA_DB_IP=`sudo docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' kodi-mariadb`

# replace with the correct IP in the settings
sed 's/'"<pass>kodi<\/pass>"'/'"<pass>${MARIADB_PASS}<\/pass>"'/g' < advancedsettings_template.xml > advancedsettings.xml
sed -i 's/'"\*\*\*.\*\*\*.\*\*\*.\*\*\*"'/'"${MARIA_DB_IP}"'/g' advancedsettings.xml

# Copy this file over to each kodi

for i in "${KODI_DOCKER_NAMES[@]}"
do
    mkdir -p ~/${KODI_RESOURCES}/$i/.kodi/userdata
    cp ./advancedsettings.xml ~/${KODI_RESOURCES}/$i/.kodi/userdata/
done

# Copy bios' over
copy_bioses ${KODI_DOCKER_NAMES[@]}

# Open Media Vault Shares
mount_cifs "openmediavault.local" "Anime_Disk18" "xbmc" "xbmc" ${KODI_DOCKER_NAMES[@]}

# Minime Shares
mount_cifs "minime.local" "snapdisk_8tb_03_shows" "xbmc" "xbmc" ${KODI_DOCKER_NAMES[@]}

# Start up the different kodi instances
for (( i = 0 ; i < ${#KODI_DOCKER_NAMES[@]} ; i=$i+1 ));
do
    CURR_DOCKER=${KODI_DOCKER_NAMES[${i}]}
    CURR_USB_PASSTHROUGH=${USB_PASSTHROUGH[${i}]}
    CURR_DISPLAY=${DISPLAYS[${i}]}
    echo
    echo "#####################################################################"
    echo "Setting up $CURR_DOCKER ON ${CURR_DISPLAY}"
    echo "USB device: ${CURR_USB_PASSTHROUGH}"
    echo "#####################################################################"
    echo

    export DISPLAY="${CURR_DISPLAY}"
    sleep 1

    sudo x11docker --homedir ~/${KODI_RESOURCES}/${CURR_DOCKER} \
         --hostdisplay --desktop --gpu --alsa --wm none -- \
         --device=${CURR_USB_PASSTHROUGH} \
         -v /etc/localtime:/etc/localtime:ro \
         --link kodi-mariadb:mysql \
         -- kodi &

    sleep 5

    #export DISPLAY=":0.0"
done


export DISPLAY=":0.0" 


test () {
    sudo docker run -t -i --device=/dev/input/event17 \
    --device=/dev/input/js1 \
    --device=/dev/bus/usb/001/007 \
    -v /dev/input:/dev/input ubuntu bash


    sudo docker run -t -i \
    --device=/dev/input \
    -v /dev/input:/dev/input ubuntu bash

    # Useful to figure out which joystick to send to a kodi
    apt-get update
    apt-get install joystick -y
    jstest /dev/input/js0
}

