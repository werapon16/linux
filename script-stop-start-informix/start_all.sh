#!/bin/bash

INFORMIXDIR=/usr/informix
export INFORMIXDIR
export PATH=$INFORMIXDIR/bin:$PATH

while read INS
do
( 
 export INFORMIXSERVER=$INS
 export ONCONFIG=onconfig.$INS
 
 echo "[$INS] Checking..."

 if onstat - | grep -q "not initialized"; then
	echo "[$INS] Start Online"
	 oninit
	
 else
	echo "[$INS] Already to start"
 fi
) &
done < instances.list
wait
echo "Done."


onstat -g dis |grep -E "Server  |Server Status " |awk  '{print $3 $4}'k
