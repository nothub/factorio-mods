#!/usr/bin/env sh

set -eu
cd "$(dirname "$(realpath "$0")")/.."

if test "$#" -ne 1; then
    echo >&2 "Usage: run <name>"
    exit 1
fi

killall -q factorio || true

rm -rf "${HOME}/.factorio/mods/${1}"
cp -r "${1}" "${HOME}/.factorio/mods/"

mod_list="${HOME}/.factorio/mods/mod-list.json"
if test -r "${mod_list}"; then
    cat "${mod_list}" \
        | jq "del(.mods[] | select(.name == \"${1}\" )) | .mods += [{ \"name\": \"${1}\", \"enabled\": true }]" \
        | tee "${mod_list}" > /dev/null
fi

steam steam://rungameid/427520
