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
  if [[ "$#" -ne 1 ]]; then
    err "Usage: ${FUNCNAME[0]} <path/file_name>.<7z|bz2|exe|gz|lzma|rar|tar|tar.bz2|tar.gz|tar.xz|tbz2|tgz|Z|zip|zx>"
    return 1
  fi
  if [[ -f "$1" ]]; then
    case "$1" in
      *.tar.bz2 | *.tbz2) tar xvjf "$1" && return 0 ;;
      *.tar.gz | *.tgz) tar xvzf "$1" && return 0 ;;
      *.tar.xz) tar xvJf "$1" && return 0 ;;
      *.7z) 7z x "$1" && return 0 ;;
      *.bz2) bunzip2 "$1" && return 0 ;;
      *.exe) cabextract "$1" && return 0 ;;
      *.gz) gunzip "$1" && return 0 ;;
      *.lzma) unlzma "$1" && return 0 ;;
      *.rar) unrar x "$1" && return 0 ;;
      *.tar) tar xvf "$1" && return 0 ;;
      *.Z) uncompress "$1" && return 0 ;;
      *.zip) unzip "$1" && return 0 ;;
      *.zx) unxz "$1" && return 0 ;;
      *) err "${FUNCNAME[0]} $1 - unknown archive method" && return 1 ;;
    esac
  else
    err "'$1' does not exist"
    return 1
  fi
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
  command kate "$@" > /dev/null 2>&1 &
  disown
}

function mpv() {
  command mpv "$@" > /dev/null 2>&1 &
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

function check-setup() {

  local expected_cmds=(
    '7z' 'alacritty' 'authy' 'aws' 'bat' 'bmon' 'broot' 'btop' 'bunzip2' 'cabextract' 'cargo' 'checkbashisms' 'clamscan'
    'cmake' 'colordiff' 'cpufetch' 'crontab' 'ctop' 'curl' 'dash' 'dig' 'diff-so-fancy' 'distrobox' 'docker' 'dos2unix'
    'exa' 'fasd' 'fd' 'fff' 'fzf' 'gdu' 'git' 'gitui' 'glances' 'go' 'gparted' 'gradle' 'groovy' 'gunzip' 'http' 'iconv'
    'inotifywait' 'java' 'javac' 'jq' 'kotlin' 'lazydocker' 'lazygit' 'lf' 'locate' 'maldet' 'micro' 'mn' 'mvn' 'mvnd'
    'nano' 'ncdu' 'neofetch' 'nnn' 'nvim' 'onefetch' 'oneshot' 'pandoc' 'parallel' 'pcmanfm' 'pip' 'postman' 'procs'
    'pygmentize' 'pv' 'ranger' 'rg' 'ruby' 'rustup' 'sbt' 'scala' 'screen' 'sd' 'shellcheck' 'shfmt' 'sntp'
    'spark-submit' 'spring' 'stacer' 'tabs2spaces' 'tar' 'tldr' 'tokei' 'trash' 'tree' 'uncompress' 'unlzma' 'unrar'
    'unxz' 'unzip' 'visualvm' 'wget' 'xsel' 'zip'
  )
  if [[ "${HOME_OR_NOT}" == 'home' ]]; then
    expected_cmds+=(
      'backintime' 'clapper' 'dnuos' 'eyeD3' 'flac' 'flac2all' 'flac2mp3.pl' 'lame' 'magick' 'mediainfo' 'mogrify'
      'mp3splt' 'openconnect' 'pacseek' 'paru' 'puddletag' 'soundkonverter' 'sox' 'speedtest' 'tageditor' 'timeshift'
      'virt-manager' 'virsh' 'yay'
    )
  fi
  for cmd in "${expected_cmds[@]}"; do
    command_exists "${cmd}" >/dev/null 2>&1 || echo "Command not available: ${cmd}"
  done

  local expected_funcs=('__git_ps1' 'br' 'sdk')
  for func in "${expected_funcs[@]}"; do
    declare -f -F "${func}" >/dev/null 2>&1 || echo "Function not available: ${func}"
  done

  local expected_files=("${HOME}/.bash_extra" "${HOME}/.gitconfig.private" "${HOME}/.ssh/config.private")
  for file in "${expected_files[@]}"; do
    [[ -f "${file}" ]] || echo "Missing file: ${file}"
  done

  local expected_vars=('BROWSER' 'DE' 'EDITOR' 'FILE_MANAGER' 'JAVA_HOME' 'HOME_OR_NOT' 'PAGER' 'VISUAL')
  for var in "${expected_vars[@]}"; do
    [[ -z "${!var}" ]] && echo "Environment variable not set: ${var}"
  done

  local expected_fonts=(
    'Code New Roman' 'Fantasque Sans Mono' 'Fira Code' 'FreeMono' 'Hack' 'Hasklig' 'Inconsolata' 'Input' 'Iosevka'
    'JetBrains Mono' 'JoyPixels' 'Menlo' 'Monoid' 'Mononoki' 'Noto Color Emoji' 'Roboto Mono' 'Source Code Pro'
    'Terminess' 'Ubuntu Mono'
  )
  for font in "${expected_fonts[@]}"; do
    fc-list : family | grep -wiq "${font}" ||
      fc-list : family | grep -wiq "${font}TTF" ||
      fc-list : family | grep -wiq "$(echo -e "${font}" | tr -d '[:space:]')" ||
      fc-list : family | grep -wiq "$(echo -e "${font}TTF" | tr -d '[:space:]')" ||
      echo "Font not available: ${font}"
  done

  local expected_services=('docker' 'cups' 'ssh-agent' 'sshd')
  if [[ "${HOME_OR_NOT}" == 'home' ]]; then
    expected_services+=('crashplan-pro' 'nfs-server' 'virtlogd')
  fi
  for service in "${expected_services[@]}"; do
    systemctl is-active --quiet "${service}" ||
      systemctl is-active --user --quiet "${service}" ||
      echo "Service not running: ${service}"
  done

  if [[ "${HOME_OR_NOT}" == 'home' ]]; then
    # libvirtd goes inactive, but is still enabled
    systemctl is-enabled --quiet 'libvirtd' || systemctl is-enabled --user --quiet 'libvirtd' || echo "Service not enabled: libvirtd"
  fi

  local expected_groups=('docker' 'sys')
  if [[ "${HOME_OR_NOT}" == 'home' ]]; then
    expected_groups+=('kvm' 'input' 'libvirt' 'wheel')
  fi
  for group in "${expected_groups[@]}"; do
    groups "${USER}" | grep -wq "${group}" || echo "User is not in group: ${group}"
  done

  local expected_kvals=(
    'vm.dirty_background_ratio 5'
    'vm.dirty_ratio 5'
    'vm.swappiness 10'
  )
  for kvals in "${expected_kvals[@]}"; do
    IFS=' ' read -r k v <<<"${kvals}"
    [[ $(sysctl -n "${k}") -le "${v}" ]] || echo "Kernel variable ${k} is >${v}: $(sysctl -n "${k}")"
  done

  # There may be a better way to detect if bash-completion is present
  type -t '_init_completion' >/dev/null 2>&1 || echo 'bash-completion not present'

  [[ "$(rustup toolchain list)" != stable* ]] && echo "rust toolchain is not 'stable'"

  [[ $(timedatectl show) != *'NTP=yes'* ]] && echo "timedatectl set-ntp is not set"

  return 0
}
