#!/bin/bash

#
# Select tmuxp project
# Requires tmuxp to be installed (obviously)
#

set -euo pipefail

SQLITE_DB="$HOME/.config/chromium/Default/History"
SQLITE_DB_READ="/tmp/pwet"
LIMIT=5000

# generate list
if [[ $ROFI_RETV = 0 ]]
then
  sqlite3 -readonly -list "$SQLITE_DB_READ" \
      "SELECT concat(title, char(0), 'info', char(31), id, char(10))
       FROM urls
       GROUP BY title
       ORDER BY last_visit_time DESC
       LIMIT $LIMIT"
fi

# on selection
if [[ $ROFI_RETV = 1 ]] && [ -n "$1" ]
then
    echo "$1 - $ROFI_INFO"
    # sqlite3 "$tmp_history" "SELECT url FROM urls WHERE id='$ROFI_INFO'"
fi



# get_url() {
#   sqlite3 "$tmp_history" "SELECT url FROM urls WHERE id='$1'"
# }

# # If we have an input, extract the url and open it in the default browser
# if [ ! -z ${1+x} ]; then
#     id=$(echo "$1" | awk '{print $1}')
#     url=$(get_url $id)
#     $open "${url}" > /dev/null 2>&1
#     exit 0
# fi


# extract_chrome_history() {
#   local history_file=$1
#   cp -f "$history_file" "$tmp_history"
#   # shellcheck disable=2086
# }

# for chrome_history_file in "${chrome_history_files[@]}"; do
#   extract_chrome_history "$chrome_history_file"
# done
