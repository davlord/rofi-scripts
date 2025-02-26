#!/bin/bash

#
# Select and open from browser bookmarks
# For chrome based browsers (chromium, brave, ...)
# Requires: xdg-open, jq
#

set -euo pipefail

declare -A BOOKMARK_FILES 
BOOKMARK_FILES=(
  ["chromium"]="$HOME/.config/chromium/Default/Bookmarks"
  ["brave-browser"]="$HOME/.config/BraveSoftware/Brave-Browser/Default/Bookmarks"
)
BROWSER=$(xdg-settings get default-web-browser | cut -f1 -d ".")

# generate list
if [[ $ROFI_RETV = 0 ]]
then
  echo -en "\0prompt\x1fBookmarks from ${BROWSER}\n"
  cat ${BOOKMARK_FILES[${BROWSER}]} | \
    jq --raw-output 'def build_path($parent):
	if .type == "folder" then
	    .children[] | build_path($parent + "/" + .name)
	elif .type == "url" then
	    $parent + "/" + .name + "\u0000info\u001f" + .url
	end;
	.roots | keys[] as $i | .[$i] | build_path("")' 
fi

# on selection
if [[ $ROFI_RETV = 1 ]] && [ -n "$ROFI_INFO" ]
then
    xdg-open "$ROFI_INFO" > /dev/null 2>&1 & # brave cannot be launched in coproc
fi
