#!/usr/bin/env bash

err() {
  echo "$@" >&2
}

function edit() {
  command "${EDITOR}" "$@"
}

function fm() {
  "${FILE_MANAGER}" "$@" >/dev/null 2>&1 & disown
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
    cd $path
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

# Show all the names (CNs and SANs) listed in the SSL certificate
# for a given domain
function getcertnames() {
  if [[ -z "$1" ]]; then
    err "No domain specified"
    return 1
  fi

  local domain
  domain="$1"
  echo "Testing ${domain}…"
  echo ""

  local tmp
  tmp="$(echo -e "GET / HTTP/1.0\nEOT" |
    openssl s_client -connect "${domain}:443" -servername "${domain}" 2>&1)"

  if [[ "${tmp}" = *"-----BEGIN CERTIFICATE-----"* ]]; then
    local certText
    certText="$(echo "${tmp}" |
      openssl x509 -text -certopt "no_aux, no_header, no_issuer, no_pubkey, \
            no_serial, no_sigdump, no_signame, no_validity, no_version")"
    echo "Common Name:"
    echo ""
    echo "${certText}" | grep "Subject:" | sed -e "s/^.*CN=//" | sed -e "s/\/emailAddress=.*//"
    echo ""
    echo "Subject Alternative Name(s):"
    echo ""
    echo "${certText}" | grep -A '1' "Subject Alternative Name:" |
      sed -e "2s/DNS://g" -e "s/ //g" | tr "," "\n" | tail -n +2
    return 0
  else
    err "Certificate not found"
    return 1
  fi
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

function symlinks() {
  if [[ "$#" -eq 2 ]]; then
    local src_dir
    local target_dir
    src_dir="$1"
    target_dir="$2"
    ! [[ -d "${src_dir}" ]] && err "${src_dir} is not a directory" && return 1
    ! [[ -d "${target_dir}" ]] && err "${target_dir} is not a directory" && return 1
    src_dir="$(readlink -m "${src_dir}")"
    target_dir="$(readlink -m "${target_dir}")"
    echo "Creating symlinks of all files in ${src_dir} in ${target_dir}"
    for src_file in "${src_dir}"/*; do
      local target_file
      target_file="$target_dir/$(basename "${src_file}")"
      if [[ -e "${target_file}" ]]; then
        if [[ -L "${target_file}" ]]; then
          echo "${target_file} symlink exists; did not overwrite"
        else
          echo "${target_file} file exists; did not overwrite"
        fi
      else
        ln -s "${src_file}" "${target_file}" || exit 1
        echo "Created ${target_file} symlink"
      fi
    done
    return 0
  else
    err "Error: bad arguments"
    err "Usage: '${FUNCNAME[0]} /path/to/src_dir /path/to/target_dir"
    return 1
  fi
}

function fff() {
  command fff "$@"
  cd "$(cat "${XDG_CACHE_HOME:=${HOME}/.cache}/fff/.fff_d")" || exit
}

function gradle-or-gradlew() {
  local dir="$PWD" project_root="$PWD"
  while [[ "$dir" != / ]]; do
    if [[ -f "$dir/settings.gradle" || -f "$dir/settings.gradle.kts" || -f "$dir/gradlew" ]]; then
      project_root="$dir"
      break
    fi
    dir="${dir:h}"
  done
  if [[ -f "$project_root/gradlew" ]]; then
    echo "Executing gradlew instead of gradle"
    "$project_root/gradlew" "$@"
  else
    command gradle "$@"
  fi
}

function uriencode() {
  jq -nr --arg v "$1" '$v|@uri'
}

function kate() {
  command kate "$@" >/dev/null 2>&1 & disown
}

function mpv() {
  command mpv "$@" >/dev/null 2>&1 & disown
}

function mvn-or-mvnw() {
  local dir="$PWD" project_root="$PWD"
  while [[ "$dir" != / ]]; do
    if [[ -f "$dir/pom.xml" || -f "$dir/mvnw" ]]; then
      project_root="$dir"
      break
    fi
    dir="${dir:h}"
  done
  if [[ -f "$project_root/mvnw" ]]; then
    echo "Executing mvnw instead of mvn"
    "$project_root/mvnw" "$@"
  else
    command mvn "$@"
  fi
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

function check_setup() {

  for cmd in \
    '7z' \
    'authy' \
    'aws' \
    'bashtop' \
    'bat' \
    'bmon' \
    'broot' \
    'bunzip2' \
    'cabextract' \
    'cargo' \
    'checkbashisms' \
    'colordiff' \
    'ctop' \
    'dash' \
    'ddd' \
    'dig' \
    'diff-so-fancy' \
    'docker' \
    'dos2unix' \
    'exa' \
    'fasd' \
    'fd' \
    'fff' \
    'fzf' \
    'git' \
    'glances' \
    'gparted' \
    'gradle' \
    'groovy' \
    'gtop' \
    'gunzip' \
    'http' \
    'iconv' \
    'incrontab' \
    'java' \
    'javac' \
    'jq' \
    'kotlin' \
    'lazydocker' \
    'lf' \
    'locate' \
    'micro' \
    'mn' \
    'mvn' \
    'nano' \
    'ncdu' \
    'neofetch' \
    'nnn' \
    'nvim' \
    'oneshot' \
    'pandoc' \
    'postman' \
    'pygmentize' \
    'ranger' \
    'rg' \
    'safe-rm' \
    'sbt' \
    'scala' \
    'sd' \
    'shellcheck' \
    'shfmt' \
    'spark-submit' \
    'spring' \
    'tar' \
    'tldr' \
    'trash-empty' \
    'tree' \
    'uncompress' \
    'unlzma' \
    'unrar' \
    'unxz' \
    'unzip' \
    'visualvm' \
    'xsel' \
    'zip'; do
    command_exists "${cmd}" >/dev/null 2>&1 || echo "Command not available: ${cmd}"
  done

  for func in \
    '__git_ps1' \
    'br' \
    'sdk'; do
    declare -f -F "${func}" >/dev/null 2>&1 || echo "Function not available: ${func}"
  done

  for file in \
    "${HOME}/.bash_extra" \
    "${HOME}/.gitconfig.private" \
    "${HOME}/.ssh/config.private"; do
    [[ -f "${file}" ]] || echo "Missing file: ${file}"
  done

  for var in \
    'BROWSER' \
    'DE' \
    'EDITOR' \
    'FILE_MANAGER' \
    'JAVA_HOME' \
    'HOME_OR_NOT' \
    'PAGER' \
    'VISUAL'; do
    [[ -z "${!var}" ]] && echo "Environment variable not set: ${var}"
  done

  for font in \
    'Code New Roman' \
    'Fantasque Sans Mono' \
    'Fira Code' \
    'Hack' \
    'Hasklig' \
    'Inconsolata' \
    'Input' \
    'Iosevka' \
    'JetBrains Mono' \
    'Menlo' \
    'Monoid' \
    'Mononoki' \
    'Roboto Mono' \
    'Source Code Pro' \
    'Terminess' \
    'Ubuntu Mono'; do
    fc-list : family | grep -wiq "${font}" ||
      fc-list : family | grep -wiq "${font}TTF" ||
      fc-list : family | grep -wiq "$(echo -e "${font}" | tr -d '[:space:]')" ||
      fc-list : family | grep -wiq "$(echo -e "${font}TTF" | tr -d '[:space:]')" ||
      echo "Font not available: ${font}"
  done

  for service in \
    'dockerd' \
    'cupsd' \
    'ssh-agent' \
    'sshd'; do
    pgrep -x "${service}" >/dev/null 2>&1 || echo "Service not running: ${service}"
  done

  for group in \
    'docker' \
    'sys'; do
    groups "${USER}" | grep -wq "${group}" || echo "User is not in group: ${group}"
  done

  for kvals in \
    'vm.dirty_background_ratio 5' \
    'vm.dirty_ratio 5' \
    'vm.swappiness 10'; do
    IFS=' ' read -r k v <<< "${kvals}"
    [[ $(sysctl -n "${k}") -le "${v}" ]] || echo "Kernel variable ${k} is >${v}: $(sysctl -n "${k}")"
  done

  # There may be a better way to detect if bash-completion is present
  type -t '_init_completion' >/dev/null 2>&1 || echo 'bash-completion not present'

  if [[ "${HOME_OR_NOT}" == 'home' ]]; then

    for cmd in \
      'backintime' \
      'openconnect' \
      'timeshift' \
      'virt-manager' \
      'virsh'; do
      command_exists "${cmd}" >/dev/null 2>&1 || echo "Command not available: ${cmd}"
    done

    for service in \
      'CrashPlanServic' \
      'incrond' \
      'libvirtd' \
      'nfsd' \
      'virtlogd'; do
      pgrep -x "${service}" >/dev/null 2>&1 || echo "Service not running: ${service}"
    done

    for group in \
      'kvm' \
      'input' \
      'libvirt' \
      'wheel'; do
      groups "${USER}" | grep -wq "${group}" || echo "User is not in group: ${group}"
    done

  fi

  return 0
}
