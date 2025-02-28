#!/bin/bash

#
# Select pulseaudio output
# Requires pactl to be installed
#

set -euo pipefail

VBoxManage() {
    case $2 in
        "vms")
	    echo '"win 10" {0000-abcd}'
	    echo '"pwet" {1234-xxxx}'
	    ;;
	"runningvms")
	    echo '"pwet" {1234-xxxx}'
	    ;;
    esac
}

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
	for i in "${active_vm_ids[@]}"; do
	    if [ "$i" == "$id" ] ; then
	    active="true"
	    info="controlvm $id shutdown"
	    fi
	done
	echo -en "${vms[$id]}\x00info\x1f${info}\x1factive\x1f${active}\n"
    done
fi

# on selection
if [[ $ROFI_RETV = 1 ]] && [ -n "${ROFI_INFO}" ]
then
    echo "$ROFI_INFO"
fi
