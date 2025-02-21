#!/bin/bash

#
# Select and open from browser history
# For chrome based browsers (chromium, brave, ...)
#

set -euo pipefail

#SQLITE_DB="$HOME/.config/chromium/Default/History"
SQLITE_DB="$HOME/.config/BraveSoftware/Brave-Browser/Default/History"
SQLITE_DB_READ="/tmp/pwet"
LIMIT=5000
SEPARATOR="	"

# generate list
if [[ $ROFI_RETV = 0 ]]
then
  cp -f $SQLITE_DB $SQLITE_DB_READ
  sqlite3 -separator "$SEPARATOR" -readonly -list "$SQLITE_DB_READ" \
      "SELECT id, title
       FROM urls
       GROUP BY title
       ORDER BY last_visit_time DESC
       LIMIT $LIMIT" \
  | awk -F "$SEPARATOR" '{printf "%s\x00info\x1f%s\n", $2, $1}'
fi

# on selection
if [[ $ROFI_RETV = 1 ]] && [ -n "$1" ]
then
    url=$(sqlite3 -readonly "$SQLITE_DB_READ" "SELECT url FROM urls WHERE id='$ROFI_INFO'")
    coproc ( xdg-open "$url" )
fi
