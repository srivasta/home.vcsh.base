#!/bin/bash

set -e
dir=$(mktemp -d -p /tmp CPU_HOG.XXXXXXXXXXXXXXXX)

for index in $(seq -w 1 24); do
    top -b -d 10 -n 360 -i >$dir/log.$(date +%F-%H)
done
