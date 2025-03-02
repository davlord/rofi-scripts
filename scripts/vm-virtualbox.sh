#!/bin/bash

#
# Start/stop virtualbox VMs
# Requires: VBoxManage
#

set -euo pipefail

# generate list
if [[ $ROFI_RETV = 0 ]]
then
    echo -en "\0prompt\x1fVirtualBox VMs\n"

    active_vm_ids=( $(VBoxManage list runningvms | sed -r 's/"([^"]+)"\ \{(.*)\}/\2/') )

    declare -A vms
    while IFS=":" read -r id name ; do
	vms["$id"]="$name"
    done < <(VBoxManage list vms | sed -r 's/"([^"]+)"\ \{(.*)\}/\2:\1/')

    for id in "${!vms[@]}" ; do
	active="false"
	info="startvm $id"
	name_suffix=""
	for i in "${active_vm_ids[@]}"; do
	    if [ "$i" == "$id" ] ; then
	    active="true"
	    info="controlvm $id shutdown"
	    name_suffix=" [running]"
	    fi
	done
	echo -en "${vms[$id]}${name_suffix}\x00info\x1f${info}\x1factive\x1f${active}\n"
    done
fi

# on selection
if [[ $ROFI_RETV = 1 ]] && [ -n "${ROFI_INFO}" ]
then
    coproc ( VBoxManage $ROFI_INFO )
fi
