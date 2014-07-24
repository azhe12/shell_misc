#!/bin/bash
#Usage: fpsMe.sh [option] logfile
#option:
#logfile is from "adb logcat -v threadtime"
#set -x
usage()
{
	cat << EOF
	Usage: $0 [option] logfile"
	option:
	logfile is from "adb logcat -v threadtime"
EOF
}
test $# -lt 1 && usage && set +x && exit

shift $((OPTIND-1))

#fps record
LOG_FILE=$1
FPS_FILE=$LOG_FILE.fps
RESULT_FILE=$LOG_FILE.result
grep 'FPS=' $LOG_FILE |awk '{print $7}'|sed 's/FPS=//'>$FPS_FILE

awk '
BEGIN{
	min_fps = 1000
	max_fps = 0
	for (i = 1; getline fps; i++) {
		list_fps[i] = fps
		if (min_fps > fps)
			min_fps = fps
		if (max_fps < fps)
			max_fps = fps
		sum += fps
	}
	total = i - 1
	average = sum/total

	for (i = 1; i <= total; i++) {
		tmp += (list_fps[i] - average)^2
	}
	standard_div = sqrt(tmp/(total - 1))
	printf("average FPS = %f min FPS = %f max FPS = %f standard deviation = %f\n", average, min_fps , max_fps, standard_div)
}' $FPS_FILE |tee $RESULT_FILE


set +x
