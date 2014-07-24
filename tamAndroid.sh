#!/bin/bash
#set -x
ANDROID_SOURCE_DIR="system/core system/media device/common device/htc device/google frameworks/av frameworks/base frameworks/htc frameworks/native hardware/ vendor/htc vendor/sprd"

SRC_LIST=cscope.files
find $ANDROID_SOURCE_DIR -type f -name "*.h" \
		-o -name "*.c" \
		-o -name "*.cc" \
		-o -name "*.cpp" \
		-o -name "*.java" \
		>$SRC_LIST
echo "GEN cscope" && cscope -bq -i $SRC_LIST 2>/dev/null
echo "GEN ctags" && ctags $(sed '/^-/d' $SRC_LIST) 2>/dev/null
#set +x
