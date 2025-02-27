#!/bin/bash

#
# Select special chars that will be pasted
# Requires nmcli to be installed
#

set -euo pipefail


# generate list
if [[ $ROFI_RETV = 0 ]]
then
    echo -en "á\0meta\x1fa\n"
    echo -en "í\0meta\x1fi\n"
    echo -en "ó\0meta\x1fo\n"
    echo -en "ő\0meta\x1fo\n"
    echo -en "ú\0meta\x1fu\n"
    echo -en "ű\0meta\x1fu\n"
    echo -en "Á\0meta\x1fA\n"
    echo -en "É\0meta\x1fE\n"
    echo -en "Ë\0meta\x1fE\n"
    echo -en "Í\0meta\x1fI\n"
    echo -en "Ó\0meta\x1fO\n"
    echo -en "Ö\0meta\x1fO\n"
    echo -en "Ú\0meta\x1fU\n"
    echo -en "Ü\0meta\x1fU\n"
fi

# on selection
if [[ $ROFI_RETV = 1 ]] && [ -n "$1" ]
then
  wl-copy "$1"
  coproc ( wtype -M ctrl -M shift v -m ctrl -m shift )
fi
