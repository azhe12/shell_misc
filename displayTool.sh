#!/bin/bash

#resolution
z4td_width=480
z4td_height=800
cp5dtu_width=540
cp5dtu_height=960
cp5dwg_width=540
cp5dwg_height=960
cp5dug_width=540
cp5dug_height=960

TOP_DIR=$(pwd)
DUMP_WIFIDISPLAY_DIR=$TOP_DIR/dump_wifidisplay
DUMP_CARMODE_DIR=$TOP_DIR/dump_carmode
DUMP_LAYER_DIR=$TOP_DIR/dump_layer
DUMP_FB_DIR=$TOP_DIR/dump_fb

usage()
{
    echo "Usage: displayTool option [action] [-option action]"
    echo "Example: ./displayTool --project cp5dtu --wifidisplay dump_enable"
    echo "option:"
    echo "    -p|--project <name>       :project name"
    echo "    -w|--wifidisplay [action]"
    echo "        action: [dump_enable|dump_disable|pull|clean]"
    echo "    -c|--carmode [action]"
    echo "        action: [enable|disable|dump_enable|dump_disable|pull|clean]"
    echo "    -l|--layer [action]"
    echo "        action: [dump_enable|dump_disable|pull|clean]"
    echo "    -h|--hwcomposer [action]"
    echo "        action: [log_enable|log_disable]"
    echo "    -f|--fb [action]"
    echo "        action: [dump_enable|dump_disable|pull|clean]"
    echo "    --help"
    echo "Note:"
    echo "    pull            :pull dump data from device"
    echo "    clean           :clean dump data in device"
        
}
parse_project()
{
    echo
}

do_wifidisplay()
{
    case $1 in
        dump_enable) #begin dump
            adb shell "setprop debug.wifidisplay 1"
            break
            ;;
        dump_disable) #stop dump
            adb shell "setprop debug.wifidisplay 0"
            break
            ;;
        pull) #pull from device to ./dump_wifidisplay
            mkdir $DUMP_WIFIDISPLAY_DIR
            cd $DUMP_WIFIDISPLAY_DIR
            adb pull /data/htclog
            break
            ;;
        clean) #rm dump img in device
            adb shell "cd /data/htclog;rm *.raw"
            break
            ;;
         *)
            usage
            echo "not support argument:$1"
            exit -1
            break
            ;;
   esac
}

do_carmode()
{
    if [ -z ${project}_width ] || [ -z ${project}_width ];then
        echo "unknow project!"
        return
    fi
    case $1 in
        enable)
            adb shell "
            service call SurfaceFlinger 3003 i32 $(eval echo \$${project}_width);
            service call SurfaceFlinger 3004 i32 $(eval echo \$${project}_height);
            service call SurfaceFlinger 3002 i32 0;
            service call SurfaceFlinger 3001 i32 3"
            break
            ;;
        disable)
            adb shell "service call SurfaceFlinger 3001 i32 2"
            break
            ;;
        dump_enable)
            adb shell "service call SurfaceFlinger 3001 i32 4"
            break
            ;;
        dump_disable)
            adb shell "service call SurfaceFlinger 3001 i32 5"
            break
            ;;
        pull)
            mkdir $DUMP_CARMODE_DIR
            cd $DUMP_CARMODE_DIR
            adb pull /data/htclog
            break
            ;;
        clean)
            adb shell "cd /data/htclog;rm *.raw"
            break
            ;;
        *)
            usage
            echo "not support argument:$1"
            exit -1
            break
            ;;
    esac
}

do_layer()
{
    dump_dir="/data/dump/"
    case $1 in
        dump_enable)
            adb shell "
            mkdir $dump_dir;
            setprop dump.hwcomposer.path $dump_dir;
            setprop dump.hwcomposer.flag 1"
            break
            ;;
        dump_disable)
            adb shell "setprop dump.hwcomposer.flag 0"
            break
            ;;
        pull)
            mkdir $DUMP_LAYER_DIR
            cd $DUMP_LAYER_DIR
            adb pull $dump_dir
            break
            ;;
        clean)
            adb shell "cd $dump_dir;rm *.bmp"
            break
            ;;
        *)
            usage
            echo "not support argument:$1"
            exit -1
            break
            ;;
    esac
}
do_hwcomposer()
{
    case $1 in
        log_enable)
            adb shell "setprop debug.hwcomposer.info 1"
            ;;
        log_disable)
            adb shell "setprop debug.hwcomposer.info 0"
            ;;
        *)
            usage
            echo "not support argument:$1"
            exit -1
            ;;
esac
}

do_fb()
{
    dump_dir="/data/dump/"
    case $1 in
        dump_enable)
            adb shell "
            mkdir $dump_dir;
            setprop dump.hwcomposer.path $dump_dir;
            setprop dump.hwcomposer.flag 8"
            break
            ;;
        dump_disable)
            adb shell "setprop dump.hwcomposer.flag 0"
            break
            ;;
        pull)
            mkdir $DUMP_FB_DIR
            cd $DUMP_FB_DIR
            adb pull $dump_dir
            break
            ;;
        clean)
            adb shell "cd $dump_dir;rm *.bmp"
            break
            ;;
        *)
            usage
            echo "not support argument:$1"
            exit -1
            break
            ;;
    esac

}
#set -x
if [ $# -lt 1 ];then
    usage
    exit -1
fi
while [ $# -gt 0 ]
do
    case $1 in
        -p|--project)
            project=$2
            width=$2_width
            height=$2_height
            shift
            ;;
        -w|--wifidisplay)
            action=$2
            do_wifidisplay $action
            shift
            ;;
        -c|--carmode)
            action=$2
            do_carmode $action
            shift
            ;;
        -l|--layer)
            action=$2
            do_layer $action
            shift
            ;;
        -h|--hwcomposer)
            action=$2
            do_hwcomposer $action
            shift
            ;;
        -f|--fb)
            action=$2
            do_fb $action
            shift
            ;;
        --help)
            usage
            exit -1
            ;;
        -*)
            echo "unknow option:$1"
            usage
            exit -1
            ;;
        *)
            echo "unknow arg: $1"
            usage
            exit -1
            ;;
    esac
    shift
done
set +x
