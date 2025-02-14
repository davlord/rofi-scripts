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
    pactl list sinks \
     | grep -E "Sink|Description" \
     | awk '{printf "%s ", $0} NR % 2 == 0 {print ""}' \
     | sed -r "s/Sink #([0-9])+[ \t]+Description: (.*)/\2\x00info\x1f\1/"
fi

# on selection
if [[ $ROFI_RETV = 1 ]] && [ -n "${ROFI_INFO}" ]
then
    pactl set-default-sink $ROFI_INFO
fi
