#!/usr/bin/env bash

err() {
    echo "$@" >&2
}

function manswitch () { 
  man $1 | less -p "^ +$2"
}

# Find a file with a pattern in name:
function ff() {
    find . -type f -iname '*'$@'*' -ls
}

# Move filenames to lowercase
function lowercase() {
    for file ; do
        local filename
        filename=${file##*/}
        case "${filename}" in
            */*) dirname=="${file%/*}" ;;
            *) dirname=".";;
        esac
        local nf
        nf=$(echo "${filename}" | tr A-Z a-z)
        local newname
        newname="${dirname}/${nf}"
        if [[ "${nf}" != "${filename}" ]]; then
            mv "${file}" "${newname}" || exit 1
            echo "$FUNCNAME: ${file} --> ${newname}"
            return 0
        else
            echo "$FUNCNAME: ${file} not changed"
            return 0
        fi
    done
}

# Swap 2 filenames around, if they exist
function swap() {
    local temp_file
    temp_file="tmp.$$"
    [[ $# -ne 2 ]] && err "swap: 2 arguments needed" && return 1
    [[ ! -e $1 ]] && err "swap: $1 does not exist" && return 1
    [[ ! -e $2 ]] && err "swap: $2 does not exist" && return 1
    mv "$1" "${temp_file}" || exit 1
    mv "$2" "$1" || exit 1
    mv "${temp_file}" "$2" || exit 1
    echo "swapped '$1' and '$2'"
    return 0
}

function extract () {
    if [[ $# -ne 1 ]]; then
        err "Usage: extract <path/file_name>.<7z|bz2|exe|gz|lzma|rar|tar|tar.bz2|tar.gz|tar.xz|tbz2|tgz|Z|zip|zx>"
        return 1
    fi
    if [[ -f $1 ]]; then
        case $1 in
            *.tar.bz2|*.tbz2) tar xvjf $1   && return 0 ;;
            *.tar.gz|*.tgz)  tar xvzf $1   && return 0 ;;
            *.tar.xz)  tar xvJf $1   && return 0 ;;
            *.7z)      7z x $1       && return 0 ;;
            *.bz2)     bunzip2 $1    && return 0 ;;
            *.exe)     cabextract $1 && return 0 ;;
            *.gz)      gunzip $1     && return 0 ;;
            *.lzma)    unlzma $1     && return 0 ;;
            *.rar)     unrar x $1    && return 0 ;;
            *.tar)     tar xvf $1    && return 0 ;;
            *.Z)       uncompress $1 && return 0 ;;
            *.zip)     unzip $1      && return 0 ;;
            *.zx)      unxz $1       && return 0 ;;
            *)         err "extract: '$1' - unknown archive method" && return 1 ;;
        esac
    else
        err "'$1' does not exist"
        return 1
    fi
}

# Get current host related info.
function ii() {
    echo -e "\nYou are logged on $(hostname)"
    echo -e "\nAdditional information: " ; uname -a
    echo -e "\nUsers logged on: " ; w -h
    echo -e "\nCurrent date: " ; date
    echo -e "\nMachine stats: " ; uptime
    echo -e "\nMemory stats: " ; free
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
    tmp=$(echo -e "GET / HTTP/1.0\nEOT" \
        | openssl s_client -connect "${domain}:443" -servername "${domain}" 2>&1)

    if [[ "${tmp}" = *"-----BEGIN CERTIFICATE-----"* ]]; then
        local certText
        certText=$(echo "${tmp}" \
            | openssl x509 -text -certopt "no_aux, no_header, no_issuer, no_pubkey, \
            no_serial, no_sigdump, no_signame, no_validity, no_version")
        echo "Common Name:"
        echo ""
        echo "${certText}" | grep "Subject:" | sed -e "s/^.*CN=//" | sed -e "s/\/emailAddress=.*//";
        echo ""
        echo "Subject Alternative Name(s):"
        echo ""
        echo "${certText}" | grep -A 1 "Subject Alternative Name:" \
            | sed -e "2s/DNS://g" -e "s/ //g" | tr "," "\n" | tail -n +2
        return 0
    else
        err "Certificate not found"
        return 1
    fi
}

function mkcd () {
    mkdir -p -- "$@" && cd -- "$@"
}

function bak () {
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
      mv -v "${file}" $(dirname "${file}")/.$(basename "${file}") || exit 1
    done
    return 0
}

# pygmentize - http://pygments.org/
# sudo pip install Pygments
function pcat() {
    for var;
    do
        pygmentize -g "${var}"
    done
    return 0
}

# pygmentize - http://pygments.org/
# sudo pip install Pygments
function pless() {
    if [[ $# -eq 1 ]]; then
        pygmentize -g $1 | less -r
    elif [[ $# -eq 2 ]] && [[ $1 == -* ]]; then
        pygmentize $2 | less "$1r"
    else
        err "Error: bad arguments"
        err "Usage: '$FUNCNAME [-options] /path/to/file'"
        return 1
    fi
    return 0
}

function symlinks() {
    if [[ $# -eq 2 ]]; then
        local src_dir
        local target_dir
        src_dir=$1
        target_dir=$2
        ! [[ -d "${src_dir}" ]] && err "${src_dir} is not a directory" && return 1
        ! [[ -d "${target_dir}" ]] && err "${target_dir} is not a directory" && return 1
        src_dir=$(readlink -m "${src_dir}")
        target_dir=$(readlink -m "${target_dir}")
        echo "Creating symlinks of all files in ${src_dir} in ${target_dir}"
        for src_file in "${src_dir}"/* ; do
            local target_file
            target_file="$target_dir/$(basename "${src_file}")"
            if [[ -e "${target_file}" ]]; then
                if [[ -h "${target_file}" ]]; then
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
        err "Usage: '$FUNCNAME /path/to/src_dir /path/to/target_dir"
        return 1
    fi
}

function mvn() {
    local maven_wrapper='./mvnw'
    if [[ -x ${maven_wrapper} ]]; then
        ${maven_wrapper} "$@"
    else
        command mvn "$@"
    fi
}

function gradle() {
    local gradle_wrapper='./gradlew'
    if [[ -x ${gradle_wrapper} ]]; then
        ${gradle_wrapper} "$@"
    else
        command gradle "$@"
    fi
}

function fff() {
    command fff "$@"
    cd "$(cat "${XDG_CACHE_HOME:=${HOME}/.cache}/fff/.fff_d")"
}

function check-setup() {

  for cmd in \
        '7z' \
        'aws' \
        'broot' \
        'bunzip2' \
        'cabextract' \
        'cargo' \
        'docker' \
        'dos2unix' \
        'exa' \
        'fasd' \
        'fd' \
        'fff' \
        'git' \
        'gradle' \
        'groovy' \
        'gunzip' \
        'http' \
        'iconv' \
        'java' \
        'javac' \
        'kotlin' \
        'lf' \
        'locate' \
        'mn' \
        'mvn' \
        'nano' \
        'neofetch' \
        'nvim' \
        'openconnect' \
        'pygmentize' \
        'ranger' \
        'rg' \
        'safe-rm' \
        'sbt' \
        'scala' \
        'spark-submit' \
        'spring' \
        'tar' \
        'tldr' \
        'tree' \
        'uncompress' \
        'unlzma' \
        'unrar' \
        'unxz' \
        'unzip' \
        'visualvm' \
        'xsel' \
        'zip'
  do
      type -P -f $cmd >/dev/null 2>&1 || echo "Command not available: $cmd"
    done

    for func in \
        '__git_ps1' \
        'br' \
        'sdk'
    do
        declare -f -F $func >/dev/null 2>&1 || echo "Function not available: $func"
    done

    for file in \
        "$HOME/.bash_extra" \
        "$HOME/.gitconfig.private" \
        "$HOME/.ssh/config.private" 
    do
        [[ -f $file ]] || echo "Missing file: $file"
    done

    for var in \
        'EDITOR' \
        'FILE_MANAGER' \
        'PACKAGE_MANAGER' \
        'PAGER'
    do
        [[ -z ${!var} ]] && echo "Environment variable not set: $var"
    done
    
    for font in \
      'Fira Code' \
      'Hack' \
      'Hasklig' \
      'Inconsolata' \
      'Input Mono' \
      'Iosevka' \
      'JetBrains Mono' \
      'Menlo' \
      'Monoid' \
      'Roboto Mono' \
      'Source Code Pro'
    do
      fc-list : family | grep -wq "$font" || echo "Font not available: $font"
    done
    
    for service in \
      'docker' \
      'ssh-agent'
    do
      pgrep "$service" >/dev/null 2>&1 || echo "Service not running: $service"
    done
    
    groups $USER | grep -wq 'docker' || echo 'User is not in docker group'
    
    # There may be a better way to detect if bash-completion is present
    type -t '_init_completion' >/dev/null 2>&1 || echo 'bash-completion not present'

    return 0
}
