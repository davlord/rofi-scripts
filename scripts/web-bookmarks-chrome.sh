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
  ["brave"]=""
)
BROWSER="chromium"

# generate list
if [[ $ROFI_RETV = 0 ]]
then
  echo -en "\0prompt\x1fBookmarks from ${BROWSER}\n"
  cat ${BOOKMARK_FILES[${BROWSER}]} | \
    jq --ascii-output 'def build_path($path):
	if .children then
	    .children[] | build_path($path + "/" + .name)
	elif has("url") then
	    $path + "/" + .name + "\u0000info\u001f" + .url
	else
	    empty
	end;
	.roots.bookmark_bar | .. | objects | select(has("children") or has("url")) | build_path("")' 
fi

# on selection
if [[ $ROFI_RETV = 1 ]] && [ -n "$ROFI_INFO" ]
then
    echo "$ROFI_INFO"
    # xdg-open "$url" > /dev/null 2>&1 & # brave cannot be launched in coproc
fi
