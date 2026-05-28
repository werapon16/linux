#!/bin/bash

umask 022

umount /reartmp

lvremote /dev/rtvg/lvreartmp

cp -p /etc/fstab /etc/fstab.bk

sed -i '/reartmp/d' /etc/fstab


