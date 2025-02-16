#!/bin/bash

#
# Select from clipboard history
# Requires cliphist to be installed
#

set -euo pipefail

# generate list
if [[ $ROFI_RETV = 0 ]]
then
    echo -en "\0prompt\x1fClipboard history\n"
    cliphist list
fi

# on selection
if [[ $ROFI_RETV = 1 ]] && [ -n "$1" ]
then
    cliphist decode <<<"$1" | wl-copy
fi
