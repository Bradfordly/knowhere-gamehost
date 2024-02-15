#!/bin/bash -xe

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
)
dpkg --add-architecture i386
apt update
apt install ${depList[@]} -y

curl -Lo linuxgsm.sh https://linuxgsm.sh
chmod +x linuxgsm.sh

declare -A serverList
serverList['pwserver']=8211 #palworld
serverList['mcserver']=25565 #minecraft

for server in "${!serverList[@]}"
do
    password=$server@123
    port=$serverList[$server]
    ufw allow $port
    adduser $server --disabled-password
    echo "$server:$password" | chpasswd
    echo "$server  ALL=(ALL:ALL) ALL" >> /etc/sudoers
    chown -R "$server:$server" /home/$server
    cp linuxgsm.sh /home/$server/linuxgsm.sh
    /bin/su -c "/home/$server/linuxgsm.sh $server" - $server
    bash /home/$server/$server install
    /bin/su -c "/home/$server/$server auto-install" - $server
done
