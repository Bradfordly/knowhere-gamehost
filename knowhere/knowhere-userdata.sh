#!/bin/bash

### config ###
S3_BUCKET_NAME="s3://bradfordly-things"
LGSM_DIR="/opt/linuxgsm/linuxgsm.sh"
MINECRAFT_SAVE_FILE="/games/saves/minecraft/ce_plays_mc.zip"
PALWORLD_SAVE_FILE="/games/saves/palworld/ce_plays_pw.zip"

### install dependencies ###
dpkg --add-architecture i386
depList=(
    curl
    wget
    file
    tar
    bzip2
    gzip
    unzip
    bsdmainutils
    python3
    util-linux
    ca-certificates
    binutils
    bc
    jq
    tmux
    netcat
    lib32gcc-s1
    lib32stdc++6
    libsdl2-2.0-0:i386
    steamcmd
)
apt update && apt install ${depList[@]} -y

### linuxgsm setup
curl -Lo linuxgsm.sh https://linuxgsm.sh
chmod +x linuxgsm.sh
mv linuxgsm.sh ${LGSM_DIR}
cd ${LGSM_DIR}

### get secrets
secret=$(aws ssm get-parameter --name "MyStringParameter")

### palworld setup
ufw allow 8211
adduser pwserver
echo "pwserver:${pwserver}" | chpasswd
bash linuxgsm.sh pwserver

### minecraft setup
ufw allow 25565
adduser mcserver
echo "mcserver:${mcserver}" | chpasswd
bash linuxgsm.sh mcserver
# TODO: locate mc install directory from linux gsm
#aws s3 cp ${S3_BUCKET_NAME}${MINECRAFT_SAVE_FILE} ${MINECRAFT_SAVE_FILE}
#unzip ${MINECRAFT_SAVE_FILE}
#rm ${MINECRAFT_SAVE_FILE}
#sed 's/false/true/g' eula.txt
#sed 's/level-name=minecraft/level-name=ce_plays_mc/g' server.properties
#sed 's/difficulty=easy/difficulty=normal/g' server.properties
#sed 's/view-distance=10/view-distance=30/g' server.properties

### dynamic dns (update cname record w/ new ec2 public dns)
# TODO: setup cloudflare api access
