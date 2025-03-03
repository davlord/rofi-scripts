#!/bin/bash

#
# Activate/deactivate VPN connections from networkmanager
# Requires nmcli to be installed
#

set -euo pipefail


# generate list
if [[ $ROFI_RETV = 0 ]]
then
    nmcli --terse con | awk -F  ':' '{if ($3 == "vpn") {
    	  vpn_name = $4 == "" ? $1 : $1 " [connected]";
	  vpn_id=$2;
          vpn_active = $4 == "" ? "false" : "true";
	  vpn_toggle = $4 == "" ? "up" : "down";
          printf "%s\x00info\x1f%s %s\x1factive\x1f%s\n", vpn_name, vpn_toggle, vpn_id, vpn_active
    } }'
fi

# on selection
if [[ $ROFI_RETV = 1 ]] && [ -n "$ROFI_INFO" ]
then
   coproc( nmcli connection $ROFI_INFO )
fi
