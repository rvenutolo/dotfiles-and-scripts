#!/usr/bin/env bash

err() {
  echo "$@" >&2
}

function edit() {
  command "${EDITOR}" "$@"
}

function fm() {
  "${FILE_MANAGER}" "$@" >/dev/null 2>&1 &
  disown
}

function manswitch() {
  man "$1" | less -p "^ +$2"
}

# Find a file with a pattern in name:
function ff() {
  find . -type f -iname '*'"$1"'*' -ls
}

# "| order" is very handy for counting duplicated lines in a file or listing
function order() {
  sort | uniq -c | sort -rn
}

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

function un() {
  for archive in "$@"; do
    if [ -f "${archive}" ]; then
      case "${archive}" in
        *.tar.bz2) tar xvjf "${archive}" ;;
        *.tar.gz) tar xvzf "${archive}" ;;
        *.tar.xz) tar xvJf "${archive}" ;;
        *.bz2) bunzip2 "${archive}" ;;
        *.rar) rar x "${archive}" ;;
        *.gz) gunzip "${archive}" ;;
        *.tar) tar xvf "${archive}" ;;
        *.tbz2) tar xvjf "${archive}" ;;
        *.tgz) tar xvzf "${archive}" ;;
        *.zip) unzip "${archive}" ;;
        *.zx) unxz "${archive}" ;;
        *.Z) uncompress "${archive}" ;;
        *.7z) 7z x "${archive}" ;;
        *.exe) cabextract "${archive}" ;;
        *.lzma) unlzma "$1" && return 0 ;;
        *) echo "don't know how to extract '${archive}'..." ;;
      esac
    else
      echo "'${archive}' is not a valid file!"
    fi
  done
}

# Get current host related info.
function ii() {
  echo -e "\nYou are logged on $(hostname)"
  echo -e "\nAdditional information: "
  uname -a
  echo -e "\nUsers logged on: "
  w -h
  echo -e "\nCurrent date: "
  date
  echo -e "\nMachine stats: "
  uptime
  echo -e "\nMemory stats: "
  free
  return 0
}

function dataurl() {
  local mimeType
  mimeType=$(file -b --mime-type "$1")
  if [[ $mimeType == text/* ]]; then
    mimeType="${mimeType};charset=utf-8"
  fi
  echo "data:${mimeType};base64,$(openssl base64 -in "$1" | tr -d '\n')"
}

# Get colors in manual pages
function man() {
  env \
    LESS_TERMCAP_mb="$(printf '\e[1;31m')" \
    LESS_TERMCAP_md="$(printf '\e[1;31m')" \
    LESS_TERMCAP_me="$(printf '\e[0m')" \
    LESS_TERMCAP_se="$(printf '\e[0m')" \
    LESS_TERMCAP_so="$(printf '\e[1;44;33m')" \
    LESS_TERMCAP_ue="$(printf '\e[0m')" \
    LESS_TERMCAP_us="$(printf '\e[1;32m')" \
    man "$@"
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

# Copy file with a progress bar
function cpp() {
  set -e
  strace -q -ewrite cp -- "${1}" "${2}" 2>&1 | awk '{
    count += $NF
    if (count % 10 == 0) {
      percent = count / total_size * 100
      printf "%3d%% [", percent
      for (i=0;i<=percent;i++)
        printf "="
        printf ">"
        for (i=percent;i<100;i++)
          printf " "
          printf "]\r"
    }
  }
  END { print "" }' total_size="$(stat -c '%s' "${1}")" count=0
}

# Change up a variable number of directories
# E.g:
#   cu   -> cd ../
#   cu 2 -> cd ../../
#   cu 3 -> cd ../../../
function cu {
  local count=$1
  if [ -z "${count}" ]; then
    count=1
  fi
  local path=""
  for i in $(seq 1 ${count}); do
    path="${path}../"
  done
  cd $path || exit
}

# Goes up a specified number of directories  (i.e. up 4)
function up() {
  local d=""
  limit=${1:-1}
  for ((i = 1; i <= limit; i++)); do
    d=$d/..
  done
  d=$(echo $d | sed 's/^\///')
  if [ -z "$d" ]; then
    d=..
  fi
  cd $d
}

function hide() {
  for file in "$@"; do
    mv -v "${file}" "$(dirname "${file}")"/."$(basename "${file}")" || exit 1
  done
  return 0
}

function fff() {
  command fff "$@"
  cd "$(cat "${XDG_CACHE_HOME:=${HOME}/.cache}/fff/.fff_d")" || exit
}

function gradle() {
  local dir="$PWD" project_root="$PWD"
  while [[ "$dir" != / ]]; do
    if [[ -f "$dir/settings.gradle" || -f "$dir/settings.gradle.kts" || -f "$dir/gradlew" ]]; then
      project_root="$dir"
      break
    fi
    dir="$(dirname "${dir}")"
  done
  if [[ -f "$project_root/gradlew" ]]; then
    echo "Executing gradlew instead of gradle"
    "$project_root/gradlew" "$@"
  else
    command gradle "$@"
  fi
}

function mvn() {
  local dir="$PWD" project_root="$PWD"
  while [[ "$dir" != / ]]; do
    if [[ -f "$dir/pom.xml" || -f "$dir/mvnw" ]]; then
      project_root="$dir"
      break
    fi
    dir="$(dirname "${dir}")"
  done
  if [[ -f "$project_root/mvnw" ]]; then
    echo "Executing mvnw instead of mvn"
    "$project_root/mvnw" "$@"
  elif command_exists 'mvnd'; then
    command mvnd "$@"
  else
    command mvn "$@"
  fi
}

function uriencode() {
  jq -nr --arg v "$1" '$v|@uri'
}

function kate() {
  command kate "$@" >/dev/null 2>&1 &
  disown
}

function mpv() {
  command mpv "$@" >/dev/null 2>&1 &
  disown
}

function pcat() {
  for var; do
    pygmentize -g "${var}"
  done
  return 0
}

function pless() {
  if [[ "$#" -eq 1 ]]; then
    pygmentize -g "$1" | less -r
  elif [[ "$#" -gt 1 ]]; then
    err "${FUNCNAME[0]} does not support multiple files"
  elif [[ ! -t 0 ]]; then
    pygmentize -g | less -r
  else
    err "${FUNCNAME[0]} - No file or stdin"
  fi
  return 0
}

function cless() {
  case "$1" in
    *.md) glow -s dark "$1" | less -r ;;
    *) highlight -O ansi "$1" --force | less -r ;;
  esac
}

function ccat() {
  case "$1" in
    *.md) glow -s dark "$1" ;;
    *) highlight -O ansi "$1" --force ;;
  esac
}
