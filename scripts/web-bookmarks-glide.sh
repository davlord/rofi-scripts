#!/bin/bash

#
# Select and open from browser history
# For chrome based browsers (chromium, brave, ...)
# Requires xdg-open
#

set -euo pipefail

# declare -A DATABASES 
# DATABASES=(
#   ["userapp-Glide-5LAGJ3"]="$HOME/.config/chromium/Default/History"
#   ["brave-browser"]="$HOME/.config/BraveSoftware/Brave-Browser/Default/History"
# )
# BROWSER=$(xdg-settings get default-web-browser | cut -f1 -d ".")

readonly BROWSER_DIR="${HOME}/.config/glide/glide/w2z9me1p.default-glide"


TMP=${TMPDIR-/tmp}
SQLITE_DB="${TMP}/rofi-script-web-history-glide"
LIMIT=5000
SEPARATOR="	"

# generate list
if [[ $ROFI_RETV = 0 ]]
then
  echo -en "\0prompt\x1fBookmarks from glide\n"
  cp -f "${BROWSER_DIR}/places.sqlite" "$SQLITE_DB"
  sqlite3 -separator "$SEPARATOR" -readonly -list "$SQLITE_DB" \
      "SELECT fk, title
       FROM moz_bookmarks
       WHERE parent > 2
       ORDER BY title ASC
       LIMIT $LIMIT" \
  | awk -F "$SEPARATOR" '{printf "%s\x00info\x1f%s\n", $2, $1}'
fi

# on selection
if [[ $ROFI_RETV = 1 ]] && [ -n "$1" ]
then
    url=$(sqlite3 -readonly "$SQLITE_DB" "SELECT url FROM moz_places WHERE id='$ROFI_INFO'")
    xdg-open "$url" > /dev/null 2>&1 & # brave cannot be launched in coproc
fi
