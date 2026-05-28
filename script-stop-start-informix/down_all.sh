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

 if onstat - | grep -q "On-Line"; then
	echo "[$INS] Shutdown"
	 onmode -ky
 else
	echo "[$INS] Already down"
 fi
) &
done < instances.list
wait
echo "Done."
