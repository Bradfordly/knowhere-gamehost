#!/bin/bash -xe

# TODO: review LinuxGSM docs for backup command args
/bin/su -c "/home/$server/$server backup" - $server

# TODO: get file and mv to s3
aws s3 mv /home/$server/lgsm/backup/ #local backup file name
