#!/bin/bash

#
# Select and open from browser bookmarks
# For chrome based browsers (chromium, brave, ...)
# Requires: xdg-open, jq
#

set -euo pipefail

QUICKMARK_FILE="$HOME/.config/qutebrowser/quickmarks"
BOOKMARK_FILE="$HOME/.config/qutebrowser/bookmarks/urls"

# generate list
if [[ $ROFI_RETV = 0 ]]
then
  echo -en "\0prompt\x1fBookmarks from qutebrowser\n"
  awk '{ printf "%s\x00info\x1f%s\n", $1, $2 }' $QUICKMARK_FILE
  awk '{ printf "%s\x00info\x1f%s\n", $2, $1 }' $BOOKMARK_FILE 
fi

# on selection
if [[ $ROFI_RETV = 1 ]] && [ -n "$ROFI_INFO" ]
then
    xdg-open "$ROFI_INFO" > /dev/null 2>&1 &
fi
