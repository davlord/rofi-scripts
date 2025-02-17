#!/bin/bash

#
# Select password from pass
# Requires pass to be installed (obvisously)
# Inspired from passmenu
#

set -euo pipefail

# generate list
if [[ $ROFI_RETV = 0 ]]
then
    shopt -s nullglob globstar
    prefix=${PASSWORD_STORE_DIR-~/.password-store}
    password_files=( "$prefix"/**/*.gpg )
    password_files=( "${password_files[@]#"$prefix"/}" )
    password_files=( "${password_files[@]%.gpg}" )
    printf '%s\n' "${password_files[@]}"
fi

# on selection
if [[ $ROFI_RETV = 1 ]] && [ -n "$1" ]
then
    coproc( pass show "$1" | wl-copy > /dev/null 2>&1 )
fi
