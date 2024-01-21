#!/bin/bash
### config ###
S3_BUCKET_NAME=s3://bradfordly-things
MINECRAFT_BINARY_URL=https://piston-data.mojang.com/v1/objects/8dd1a28015f51b1803213892b50b7b4fc76e594d/server.jar
MINECRAFT_SAVE_FILE=ce_plays_mc.zip
MINECRAFT_DIRECTORY=/opt/minecraft

### install deps ###
depList=(
    openjdk-17-jre-headless
    screen
    unzip
    awscli
)

apt update
apt install ${depList[@]} -y


### minecraft setup ###
ufw allow 25565
mkdir ${MINECRAFT_DIRECTORY}
cd ${MINECRAFT_DIRECTORY}

aws s3 cp ${S3_BUCKET_NAME}/${MINECRAFT_SAVE_FILE} ${MINECRAFT_SAVE_FILE}
unzip ${MINECRAFT_SAVE_FILE}
rm ${MINECRAFT_SAVE_FILE}

wget ${MINECRAFT_BINARY_URL}
java -Xmx1024M -Xms1024M -jar server.jar nogui
sed 's/false/true/g' eula.txt
sed 's/level-name=minecraft/level-name=ce_plays_mc/g' server.properties
sed 's/difficulty=easy/difficulty=normal/g' server.properties
sed 's/view-distance=10/view-distance=30/g' server.properties
