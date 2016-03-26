#!/usr/bin/env bash

err() {
    echo "$@" >&2
}

function firefox() { command firefox "$@" & }
function google-chrome() { command google-chrome "$@" & }
function chrome() { command google-chrome "$@" & }
function gedit() { command gedit "$@" & }

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
        err "No file specified"
        return 1
    fi
    if [[ -f $1 ]]; then
        case $1 in
            *.tar.bz2) tar xvjf $1   && return 0 ;;
            *.tar.gz)  tar xvzf $1   && return 0 ;;
            *.bz2)     bunzip2 $1    && return 0 ;;
            *.rar)     unrar x $1    && return 0 ;;
            *.gz)      gunzip $1     && return 0 ;;
            *.tar)     tar xvf $1    && return 0 ;;
            *.tbz2)    tar xvjf $1   && return 0 ;;
            *.tgz)     tar xvzf $1   && return 0 ;;
            *.zip)     unzip $1      && return 0 ;;
            *.Z)       uncompress $1 && return 0 ;;
            *.7z)      7z x $1       && return 0 ;;
            *)         err "'$1' cannot be extracted via extract" && return 1;;
        esac
    else
        err "'$1' is not a valid file"
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
    my_ip 2>&-
    echo -e "\nLocal IP Addresses:" ; echo $(localip)
    echo -e "\nExternal IP Address:" ; echo $(ip)
    echo -e "\nOpen connections: "; netstat -pan --inet
    echo
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

# grip - https://github.com/joeyespo/grip
# sudo pip install grip
function pghfm() {
    local inputfile
    if [[ $# -eq 0 ]]; then
        inputfile='README.md'
    elif [[ $# -eq 1 ]]; then
        inputfile=$1
    else
        err "Expected 0 or 1 file path arguments"
        return 1
    fi
    if [[ -f "${inputfile}" ]]; then
        local filetime
        filetime=$(date +%Y%m%d_%H%M%S)
        local filename
        filename="/tmp/$(basename "${inputfile}").${filetime}.html"
        grip "${inputfile}" --export "${filename}"
        x-www-browser "${filename}"
        return 0
    else
        err "'${inputfile}' is not a valid file"
        return 1
    fi
}

function mkcd () {
    mkdir -p -- "$@"
    cd -- "$@"
    return 0
}

function bak () {
    if [[ $# -ne 1 ]]; then
        err "Error: No file specified"
        return 1
    fi
    if [[ -f $1 ]] || [[ -d $1 ]]; then
        local filename
        filename=$1
        local filetime
        filetime=$(date +%Y%m%d_%H%M%S)
        cp -a "${filename}" "${filename}.${filetime}.bak" || exit 1
        return 0
    else
        err "'$1' is not a valid file"
        return 1
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
