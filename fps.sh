#!/bin/bash
cmd=$1
nid=$2

case $cmd in
	"start") 
		echo "Start dumping fps in system log...";		
		native_id=`adb shell service call SurfaceFlinger 2000 i32 2 i32 1 s16 for_test s16 for_test s16 for_test s16 for_test | grep -o -E \([a-fA-F0-9]+\ \)`;					
		str=`echo "ibase=16; ${native_id^^}"|bc`
		
		echo "SESSION_ID = $str"
		echo "Stop fps log by \"source fps.sh stop $str\""

		;;
	"stop")
		echo "Stop dumping fps in system log..."
	    adb shell service call SurfaceFlinger 2001 i32 $2 
		;;
	"setup")
		echo "Setup device for precondition to dump fps in system log..."
		adb shell "echo 'profiler.logfps=2' >> /data/local.prop"
		adb shell chmod 644 /data/local.prop
		adb reboot
		;;
	*)
		echo "FPS log enable/disable script"
		echo "Usage: $0 [setup|start|stop]"
        echo "   Setup device to allow enabling fps mechanism"
		echo "     \$ $0 setup"
		echo "   Start dumping fps information in system log. A session id will be output for closing the dump session."
		echo "     \$ $0 start"
		echo "   Stop dumping fps informaiton in system log."
		echo "     \$ $0 stop {SESSION_ID}"
		;;
esac

echo $nid;
