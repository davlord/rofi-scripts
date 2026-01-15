#!/bin/bash

#
# Select tmuxp project
# Requires tmuxp to be installed (obviously)
#

set -euo pipefail


# generate list
if [[ $ROFI_RETV = 0 ]]
then
    tmuxp ls --json | jq -r '.workspaces[].session_name'
fi

# on selection
if [[ $ROFI_RETV = 1 ]] && [ -n "$1" ]
then
   coproc ( alacritty --class tmux-project -T tmux:$1 -e tmuxp load $1 )
fi
