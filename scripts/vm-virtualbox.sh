#!/bin/bash

#
# Select pulseaudio output
# Requires pactl to be installed
#

set -euo pipefail

LANG="en_US.utf8" # force english to avoid translated output

# generate list
if [[ $ROFI_RETV = 0 ]]
then
    echo -en "\0prompt\x1fVirtualBox VMs\n"
    active_vm_ids=( $(VBoxManage list runningvms | sed -r 's/"([^"]+)"\ \{(.*)\}/\2/') )

    declare -A pwet
    while IFS=":" read -r priority host ; do
	pwet["$priority"]="$host"
    done < <(VBoxManage list vms | sed -r 's/"([^"]+)"\ \{(.*)\}/\2:\1/')

    for priority in "${!pwet[@]}" ; do
	echo "$priority -> ${pwet[$priority]}"
    done

    # printf '%s\n' "${active_vm_ids[@]}"
 #    VBoxManage list vms \
	# | sed -r 's/"([^"]+)"\ \{(.*)\}/\2:\1/' \
	# | awk -F ':' -v active_vm_ids="${active_vm_ids[*]}" 'BEGIN {split(active_vm_ids,arr," "); vm_active = ($1 in arr) ? "true" : "false"; printf "%s-%s\x00info\x1f%s\x1factive\x1f%s\n", $2, vm_active, $1, "false" }'
fi

# on selection
if [[ $ROFI_RETV = 1 ]] && [ -n "${ROFI_INFO}" ]
then
    echo "$ROFI_INFO"
fi
