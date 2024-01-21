#!/bin/bash
### config ###
MINECRAFT_BINARY_URL=https://piston-data.mojang.com/v1/objects/8dd1a28015f51b1803213892b50b7b4fc76e594d/server.jar

### install deps ###
depList=(
    openjdk-17-jre-headless
    screen
)

apt update
apt install ${depList[@]} -y


### minecraft setup ###
ufw allow 25565
mkdir ~/servers/minecraft && cd ~/servers/minecraft
wget ${MINECRAFT_BINARY_URL}

### leaving start command commented out
# java -Xmx1024M -Xms1024M -jar server.jar nogui
