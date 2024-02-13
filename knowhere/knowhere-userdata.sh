#!/bin/bash

### install dependencies ###
# depList=(
#     curl
#     wget
#     file
#     tar
#     bzip2
#     gzip
#     unzip
#     bsdmainutils
#     python3
#     util-linux
#     ca-certificates
#     binutils
#     bc
#     jq
#     tmux
#     netcat
#     lib32gcc-s1
#     lib32stdc++6
#     libsdl2-2.0-0:i386
#     steamcmd
# )
# dpkg --add-architecture i386
# apt update
# apt install ${depList[@]} -y

### config ###
echo 'setting environment configuration'
S3_BUCKET_NAME=$(aws ssm get-parameter --name "/gamehost/s3bucket" --region us-east-1)
# R53_HOSTEDZONE=""
LGSM_DIR="/opt/linuxgsm"
# MINECRAFT_SAVE_FILE="/saves/minecraft/ce_plays_mc.zip"
# PALWORLD_SAVE_FILE="/saves/palworld/ce_plays_pw.zip"
echo 'environment configuration complete'

### linuxgsm setup ###
echo 'staging linuxgsm scripts'
curl -Lo linuxgsm.sh https://linuxgsm.sh
chmod +x linuxgsm.sh
mkdir ${LGSM_DIR}
mv linuxgsm.sh ${LGSM_DIR}/linuxgsm.sh
cd ${LGSM_DIR}
echo 'linuxgsm scripts staged successfully'

### define game list ###
echo 'setting server list dictionary'
declare -A serverList
serverList[pwserver]=8211 #palworld
serverList[mcserver]=25565 #minecraft
echo 'server list dictionary set successfully'

### install game servers ###
for server in "${!serverList[@]}"
do
    echo "next game server to install: $server"
    pw=$(aws ssm get-parameter --name "/aws/reference/secretsmanager/gamehost/knowhere/linuxgsm/$server" --with-decryption --region us-east-1)
    useradd $server; echo -e $pw['Parameter']['Value'][$server] | passwd $server
    ufw allow $serverList[$server]
    /bin/su -c "$LGSM_DIR/linuxgsm.sh" - $server
    /bin/su -c "$LGSM_DIR/$server auto-install" - $server
    # bash linuxgsm.sh $server
    # bash $server auto-install
done

### palworld setup ###
# TODO: import save file

### minecraft setup ###
# TODO: locate mc install directory from linux gsm
#aws s3 cp ${S3_BUCKET_NAME}/${MINECRAFT_SAVE_FILE} ${MINECRAFT_SAVE_FILE}
#unzip ${MINECRAFT_SAVE_FILE}
#rm ${MINECRAFT_SAVE_FILE}
#sed 's/level-name=minecraft/level-name=ce_plays_mc/g' server.properties
#sed 's/difficulty=easy/difficulty=normal/g' server.properties
#sed 's/view-distance=10/view-distance=30/g' server.properties
