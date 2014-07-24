#!/bin/bash
XY_CAMERA_ICON="138 757"
XY_CAPTURE="300 747"
CAPTURE_NR=100
#open camera
adb shell "input tap $XY_CAMERA_ICON"
sleep 2
#fast capture
n=0
while true
do
	adb shell "input tap $XY_CAPTURE"
	echo "input tap $XY_CAPTURE"
	((n+=1))
	echo "1 $n"
	if [ $n -gt 100 ]
	then
		echo "2 $n"
		n=0
		sleep 15
	fi

done
