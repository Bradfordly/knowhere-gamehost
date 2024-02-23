#!/bin/bash -xe

### install dependencies ###
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
dpkg --add-architecture i386
apt update
apt install ${depList[@]} -y

### linuxgsm setup ###
curl -Lo linuxgsm.sh https://linuxgsm.sh
chmod +x linuxgsm.sh
mv linuxgsm.sh ${LGSM_DIR}
cd ${LGSM_DIR}

### define game list ###
declare -A serverList
serverList[pwserver]=8211 #palworld
serverList[mcserver]=25565 #minecraft

### install game servers ###
for server in "${!serverList[@]}"
do
    
    adduser --system $server --disabled-password
    #password= ;)
    #echo "$server:$password" | chpasswd
    echo "$server  ALL=(ALL:ALL) ALL" >> /etc/sudoers
    chown -R "$server:$server" /home/$server
    cp linuxgsm.sh /home/$server/linuxgsm.sh 
    /bin/su -c "/home/$server/linuxgsm.sh $server" - $server
    bash /home/$server/$server install 
    /bin/su -c "/home/$server/$server auto-install" - $server
done

### dynamic dns
wget https://raw.githubusercontent.com/Bradfordly/bradfordly-gamehost/$branch/knowhere/scripts/ddns.sh
mv ddns.sh /opt/knowhere/scripts/ddns.sh
chmod +x /opt/knowhere/scripts/ddns.sh
bash /opt/knowhere/scripts/ddns.sh
cp /opt/knowhere/scripts/ddns.sh /etc/init.d/ddns.sh
