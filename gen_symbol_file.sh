#!/bin/bash
#Copyright (c) 2007 Li XianJing <xianjimli@hotmail.com>
set -x
if [ "$1" = "" ]
then
    echo "usage: " $0 " [maps file]"
    exit 1
fi

grep r-xp $1 |grep /.so >all_so.tmp.log

awk 'BEGIN{i=0} {print i " " strtonum("0x"substr($1, 0, 8)) " " $6; i++}' all_so.tmp.log >baseaddr_so.tmp.log
awk '{system("objdump -h " $3 "| grep text");}' baseaddr_so.tmp.log | \
awk 'BEGIN{i=0}{print i " " strtonum("0x" $4); i++}' >offset.tmp.log

join offset.tmp.log baseaddr_so.tmp.log >offset_baseaddr_so.tmp.log

awk '{printf("add-symbol-file %s 0x%x y ", $4, $2 + $3)}' offset_baseaddr_so.tmp.log

rm -f *.tmp.log
set +x
