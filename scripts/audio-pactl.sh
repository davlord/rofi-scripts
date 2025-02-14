#!/bin/bash

#
# Select pulseaudio output
# Requires pactl to be installed
#

set -euo pipefail

LANG="en_US.utf8" # force english to avoid translated output

# generate list
if [[ $ROFI_RETV = 0 ]]
then
    echo -en "\0prompt\x1fAudio output\n"
    pactl list sinks \
     | grep -E "Name|Description" \
     | awk '{printf "%s ", $0} NR % 2 == 0 {print ""}' \
     | sed -r "s/Name: ([^ ]+)[ \t]+Description: (.*)/\2\x00info\x1f\1/"
fi

# on selection
if [[ $ROFI_RETV = 1 ]] && [ -n "${ROFI_INFO}" ]
then
    pactl set-default-sink $ROFI_INFO
fi
