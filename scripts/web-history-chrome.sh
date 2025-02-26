#!/bin/bash

#
# Select and open from browser history
# For chrome based browsers (chromium, brave, ...)
# Requires xdg-open
#

set -euo pipefail

declare -A DATABASES 
DATABASES=(
  ["chromium"]="$HOME/.config/chromium/Default/History"
  ["brave"]="$HOME/.config/BraveSoftware/Brave-Browser/Default/History"
)
BROWSER=$(xdg-settings get default-web-browser | cut -f1 -d ".")

TMP=${TMPDIR-/tmp}
SQLITE_DB="${TMP}/rofi-script-web-history-${BROWSER}"
LIMIT=5000
SEPARATOR="	"

# generate list
if [[ $ROFI_RETV = 0 ]]
then
  echo -en "\0prompt\x1fHistory from ${BROWSER}\n"
  cp -f ${DATABASES[$BROWSER]} $SQLITE_DB
  sqlite3 -separator "$SEPARATOR" -readonly -list "$SQLITE_DB" \
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
    url=$(sqlite3 -readonly "$SQLITE_DB" "SELECT url FROM urls WHERE id='$ROFI_INFO'")
    xdg-open "$url" > /dev/null 2>&1 & # brave cannot be launched in coproc
fi
