#!/bin/bash

n=0
while [ True ];do
    adb reboot
    ((n+=1))
    echo "Reboot: $n"
    sleep 40
done
