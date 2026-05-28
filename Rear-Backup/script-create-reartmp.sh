#!/bin/bash

umask 022
##create lv 
lvcreate -v -L 60G -n lvreartmp datavg
##make type lv
mkfs -t ext4 /dev/datavg/lvreartmp 
##map fstap for mount file systems
echo "/dev/datavg/lvreartmp            /reartmp        ext4    defaults        1 2" >> /etc/fstab

##make file 

mkdir -p /reartmp

sleep 3 
systemctl daemon-reload
mount /reartmp/

mkdir -p /reartmp/tmp
mkdir -p /reartmp/output

#if [ $? -eq 0 ]
#then
#	echo -e "[ INFO ] Create File System Success"
#else
#	echo -e " Please check!!!"
#fi
