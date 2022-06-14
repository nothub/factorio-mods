#!/usr/bin/env bash

set -eo pipefail

log() {
  echo >&2 "$*"
}

debug() {
  if [[ $debug -ge 1 ]]; then log "$@"; fi
}

panic() {
  log "$@"
  exit 1
}

print_usage() {
  set +x
  script_name="$(basename "${BASH_SOURCE[0]}")"
  log "Usage: ${script_name} [-v|-vv] [-h] [--] <command> <mod path> [<arg>...]
  ${script_name} package <mod path>
  ${script_name} install <mod path> [<client mods path>]
  ${script_name} publish <mod path> [<api key>]

  Options:
    -v        Increase output verbosity
    -h, -?    Print this help and exit
  "
}

check_dependency() {
  if ! command -v "$1" >/dev/null 2>&1; then
    panic "Missing dependency: ${1}"
  fi
}

command_package() {
  debug "Packaging distribution archive."

  check_dependency zip

  mkdir -p "${out_dir}"
  rm -f "${out_dir}/${mod_archive}"

  if [[ $debug -lt 1 ]]; then quiet="--quiet"; fi

  if ! zip ${quiet} --recurse-paths "${out_dir}/${mod_archive}" "${mod_name}"; then
    panic "Failed to create distribution archive!"
  fi
  debug "Distribution archive ready:" "${out_dir}/${mod_archive}"
}

command_install() {
  if [[ ! -f "${out_dir}/${mod_archive}" ]]; then command_package; fi

  client_mods_dir="$HOME/.factorio/mods/"
  if [[ $# -ge 1 ]]; then client_mods_dir="$1"; fi

  debug "Installing mod to: ${client_mods_dir}"

  if ! cp "${out_dir}/${mod_archive}" "${client_mods_dir}"; then
    panic "failed to install mod!"
  fi
}

command_publish() {
  check_dependency curl

  if [[ ! -f "${out_dir}/${mod_archive}" ]]; then command_package; fi

  debug "Publishing distribution archive."

  # read key from args
  if [[ $# -ge 1 ]]; then
    api_key="$1"
  else
    config_file=$(realpath "auth.cfg")
    # read key from auth.cfg
    if [[ -f ${config_file} ]]; then
      # shellcheck disable=SC1091
      source auth.cfg
    # create example auth.cfg
    elif [[ ! -f ${config_file} ]]; then
      cat <<EOF >"${config_file}"
# Create your API key (not Token) at: https://factorio.com/profile
api_key=""
EOF
      log "Created empty auth.cfg, create your API key (not Token) at: https://factorio.com/profile"
      exit 0
    fi
  fi

  if [[ -z ${api_key} ]]; then
    panic "Missing API key! Supply key as argument or in: ${config_file}"
  fi

  debug "Initializing upload"
  init_response=$(curl --request POST --location --silent \
    --header "Authorization: Bearer ${api_key}" \
    --form "mod=${mod_name}" \
    https://mods.factorio.com/api/v2/mods/releases/init_upload)

  error=$(echo "${init_response}" | jq --raw-output '.error')
  if [[ "$error" != "null" ]]; then panic "${error}: $(echo "${init_response}" | jq --raw-output '.message')"; fi

  debug "Finishing upload"
  finish_response=$(curl --request POST --location --silent \
    --header "Authorization: Bearer ${api_key}" \
    --form file=@"${out_dir}/${mod_archive}" \
    "$(echo "${init_response}" | jq --raw-output '.upload_url')")

  error=$(echo "${finish_response}" | jq --raw-output '.error')
  if [[ "${error}" != "null" ]]; then panic "${error}: $(echo "${finish_response}" | jq --raw-output '.message')"; fi
  success=$(echo "${finish_response}" | jq --raw-output '.success')
  if [[ "${success}" != "true" ]]; then panic "Upload success=\"${success}\" without error message!"; fi

  log "Mod published: https://mods.factorio.com/mod/${mod_name}"
}

# ENTRY POINT

# read options
debug=0
while getopts vh? opt; do
  case $opt in
  v)
    debug=$((debug + 1))
    if [[ $debug -eq 2 ]]; then set -x; fi
    ;;
  h | \?)
    print_usage
    exit
    ;;
  esac
done
shift $((OPTIND - 1))

# cd to script directory / repository root
cd "$(dirname "$(readlink -f -- "$0")")"
out_dir=$(realpath "out")

# require at least 2 arguments
if [[ $# -lt 2 ]]; then
  print_usage
  exit
fi

# read required arguments
command=$1
mod_path=$(realpath "$2")
shift 2

if [[ ! -f ${mod_path}/info.json ]]; then panic "Missing mod info.json: ${mod_path}/info.json"; fi

# read mod infos
check_dependency jq
mod_name=$(jq --raw-output '.name' <"${mod_path}/info.json")
mod_version=$(jq --raw-output '.version' <"${mod_path}/info.json")
mod_archive=${mod_name}_${mod_version}.zip

log "${mod_name}" "v${mod_version}"
debug "$(jq <"${mod_path}/info.json")"

if ! echo "${mod_version}" | grep --extended-regexp --quiet '^[0-9]+\.[0-9]+\.[0-9]+$'; then
  panic "Invalid version pattern: ${mod_version}"
fi

case $command in
package)
  command_package
  exit
  ;;
install)
  command_install "$@"
  exit
  ;;
publish)
  command_publish "$@"
  exit
  ;;
*)
  print_usage
  exit
  ;;
esac
