#!/bin/bash

#
# Launch some search queries on a web browser
# Inspired from web-search script from Miroslav Vidovic
#

set -euo pipefail

declare -A URLS

URLS=(
  ["archlinux wiki"]="https://wiki.archlinux.org/index.php?search="
  ["archlinux aur"]="https://aur.archlinux.org/packages/?O=0&K="
  ["giphy"]="https://giphy.com/search/"
  ["gifer"]="https://gifer.com/en/gifs/"
  ["google"]="https://www.google.com/search?q="
  ["translate en -> fr"]="https://www.wordreference.com/enfr/"
  ["translate fr -> en"]="https://www.wordreference.com/fren/"
  ["docker hub"]="https://hub.docker.com/search?type=image&q="
  ["npm"]="https://www.npmjs.com/search?q="
  ["kaamelott"]="https://kaamelott-gifboard.fr/search/quote?search="
)


# generate list
if [[ $ROFI_RETV = 0 ]]
then
    echo -en "\0prompt\x1fWeb search\n"
    for name in "${!URLS[@]}"
    do
      echo -en "${name}\0info\x1f${name}\n"
    done
fi

# on site selection
if [[ $ROFI_RETV = 1 ]] && [ -n "${ROFI_INFO}" ]
then
    echo -en "\0data\x1f${ROFI_INFO}\n"
    echo -en "\0prompt\x1fWeb search on ${ROFI_INFO}\n"
    echo " "
fi

# on search 
if [[ $ROFI_RETV = 2 ]] && [ -n "${ROFI_DATA}" ]
then
    url=${URLS[${ROFI_DATA}]}$1
    coproc ( xdg-open "$url" )
fi
