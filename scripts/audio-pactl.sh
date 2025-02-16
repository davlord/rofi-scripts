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
    default_sink=$(pactl get-default-sink)
    readonly default_sink
    pactl list sinks \
     | grep -E "Name|Description" \
     | awk '{printf "%s ", $0} NR % 2 == 0 {print ""}' \
     | sed -r "s/Name: ([^ ]+)[ \t]+Description: (.*)/\1 \2/" \
     | awk -v default_sink="$default_sink" '{sink_name=$1; sink_active = sink_name == default_sink ? "true" : "false"; $1=""; sink_description=$0; printf "%s\x00info\x1f%s\x1factive\x1f%s\n", sink_description, sink_name, sink_active}'
fi

# on selection
if [[ $ROFI_RETV = 1 ]] && [ -n "${ROFI_INFO}" ]
then
    pactl set-default-sink "$ROFI_INFO"
fi
