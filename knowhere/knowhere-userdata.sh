#!/bin/bash -xe

curl -Lo linuxgsm.sh https://linuxgsm.sh
chmod +x linuxgsm.sh

declare -A serverList
serverList['pwserver']=8211 #palworld
serverList['mcserver']=25565 #minecraft

for server in "${!serverList[@]}"
do
    password=$server@123
    port=$serverList[$server]
    adduser $server --disabled-password
    echo "$server:$password" | chpasswd
    echo "$server  ALL=(ALL:ALL) ALL" >> /etc/sudoers
    chown -R "$server:$server" /home/$server
    cp linuxgsm.sh /home/$server/linuxgsm.sh
    ufw allow $port
    /bin/su -c "/home/$server/linuxgsm.sh $server" - $server
    /bin/su -c "/home/$server/$server auto-install" - $server
done
