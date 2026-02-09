#!/bin/bash

#
# Activate/deactivate WIFI from networkmanager
# Requires nmcli to be installed
#

set -euo pipefail


# generate list
if [[ $ROFI_RETV = 0 ]]
then
    nmcli radio wifi | awk '{
          wifi_status = $1;
          wifi_active = $1 == "disabled" ? "false" : "true";
	  wifi_toggle = $1 == "disabled" ? "on" : "off";
          printf "Wifi: %s\x00info\x1f%s\x1factive\x1f%s\n", wifi_status, wifi_toggle, wifi_active
    }'
fi

# on selection
if [[ $ROFI_RETV = 1 ]] && [ -n "$ROFI_INFO" ]
then
   coproc( nmcli radio wifi $ROFI_INFO )
fi
