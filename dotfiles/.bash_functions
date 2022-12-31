#!/usr/bin/env bash

# Move filenames to lowercase
function lowercase() {
  for file; do
    local filename
    filename="${file##*/}"
    case "${filename}" in
      */*) dirname="${file%/*}" ;;
      *) dirname="." ;;
    esac
    local nf
    nf="$(echo "${filename}" | tr '[:upper:]' '[:lower:]')"
    local newname
    newname="${dirname}/${nf}"
    if [[ "${nf}" != "${filename}" ]]; then
      mv "${file}" "${newname}" || exit 1
      echo "${FUNCNAME[0]}: ${file} --> ${newname}"
      return 0
    else
      echo "${FUNCNAME[0]}: ${file} not changed"
      return 0
    fi
  done
}

# Swap 2 filenames around, if they exist
function swap() {
  local temp_file
  temp_file="tmp.$$"
  [[ "$#" -ne 2 ]] && err "swap: 2 arguments needed" && return 1
  [[ ! -e "$1" ]] && err "swap: $1 does not exist" && return 1
  [[ ! -e "$2" ]] && err "swap: $2 does not exist" && return 1
  mv "$1" "${temp_file}" || exit 1
  mv "$2" "$1" || exit 1
  mv "${temp_file}" "$2" || exit 1
  echo "swapped '$1' and '$2'"
  return 0
}

function mkcd() {
  mkdir -p -- "$@" && cd -- "$@" || exit
}

function bak() {
  if [[ "$#" -ne 1 ]]; then
    err "Error: No file specified"
    return "1"
  fi
  if [[ -f "$1" ]] || [[ -d "$1" ]]; then
    local filename
    filename="${1%/}"
    local filetime
    filetime="$(date +%Y%m%d_%H%M%S)"
    cp -a "${filename}" "${filename}.${filetime}.bak" || exit "1"
    return "0"
  else
    err "'$1' is not a valid file"
    return "1"
  fi
}

function fff() {
  command fff "$@"
  cd "$(cat "${XDG_CACHE_HOME:=${HOME}/.cache}/fff/.fff_d")" || exit
}
