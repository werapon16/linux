#!/bin/bash

umask 022

onstat -g dis |grep "Server        :" |awk '{print $3}' > /tmp/instance.list
