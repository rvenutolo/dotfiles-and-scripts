function firefox() { command firefox "$@" & }
function google-chrome() { command google-chrome "$@" & }
function chrome() { command google-chrome "$@" & }
function gedit() { command gedit "$@" & }

# Find a file with a pattern in name:
function ff() { find . -type f -iname '*'$*'*' -ls ; }

function lowercase()  # move filenames to lowercase
{
    for file ; do
        filename=${file##*/}
        case "$filename" in
        */*) dirname==${file%/*} ;;
        *) dirname=.;;
        esac
        nf=$(echo "$filename" | tr A-Z a-z)
        newname="${dirname}/${nf}"
        if [ "$nf" != "$filename" ]; then
            mv "$file" "$newname"
            echo "lowercase: $file --> $newname"
        else
            echo "lowercase: $file not changed."
        fi
    done
}

function swap()  # Swap 2 filenames around, if they exist
{                #(from Uzi's bashrc).
    local TMPFILE=tmp.$$ 

    [ $# -ne 2 ] && echo "swap: 2 arguments needed" && return 1
    [ ! -e $1 ] && echo "swap: $1 does not exist" && return 1
    [ ! -e $2 ] && echo "swap: $2 does not exist" && return 1

    mv "$1" "$TMPFILE"
    mv "$2" "$1"
    mv "$TMPFILE" "$2"
}

extract () {
    if [ $# -ne 1 ]; then
        echo "Error: No file specified."
        return 1
    fi
    if [ -f $1 ]; then
        case $1 in
            *.tar.bz2) tar xvjf $1   ;;
            *.tar.gz)  tar xvzf $1   ;;
            *.bz2)     bunzip2 $1    ;;
            *.rar)     unrar x $1    ;;
            *.gz)      gunzip $1     ;;
            *.tar)     tar xvf $1    ;;
            *.tbz2)    tar xvjf $1   ;;
            *.tgz)     tar xvzf $1   ;;
            *.zip)     unzip $1      ;;
            *.Z)       uncompress $1 ;;
            *.7z)      7z x $1       ;;
            *)         echo "'$1' cannot be extracted via extract" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# Get current host related info.
function ii()
{
    echo -e "\nYou are logged on $(hostname)"
    echo -e "\nAdditional information: " ; uname -a
    echo -e "\nUsers logged on: " ; w -h
    echo -e "\nCurrent date: " ; date
    echo -e "\nMachine stats: " ; uptime
    echo -e "\nMemory stats: " ; free
    my_ip 2>&- ;
    echo -e "\nLocal IP Addresses:" ; echo `localip`
    echo -e "\nExternal IP Address:" ; echo `ip`
    echo -e "\nOpen connections: "; netstat -pan --inet;
    echo
}

function calc()
{
    local result="";
    result="$(printf "scale=10;$*\n" | bc --mathlib | tr -d '\\\n')";
    #                       └─ default (when `--mathlib` is used) is 20
    #
    if [[ "$result" == *.* ]]; then
        # improve the output for decimal numbers
        printf "$result" |
        sed -e 's/^\./0./'        `# add "0" for cases like ".5"` \
            -e 's/^-\./-0./'      `# add "0" for cases like "-.5"`\
            -e 's/0*$//;s/\.$//';  # remove trailing zeros
    else
        printf "$result";
    fi;
    printf "\n";
}

# Show all the names (CNs and SANs) listed in the SSL certificate
# for a given domain
function getcertnames()
{
    if [ -z "${1}" ]; then
        echo "ERROR: No domain specified.";
        return 1;
    fi;

    local domain="${1}";
    echo "Testing ${domain}…";
    echo ""; # newline

    local tmp=$(echo -e "GET / HTTP/1.0\nEOT" \
        | openssl s_client -connect "${domain}:443" -servername "${domain}" 2>&1);

    if [[ "${tmp}" = *"-----BEGIN CERTIFICATE-----"* ]]; then
        local certText=$(echo "${tmp}" \
            | openssl x509 -text -certopt "no_aux, no_header, no_issuer, no_pubkey, \
            no_serial, no_sigdump, no_signame, no_validity, no_version");
        echo "Common Name:";
        echo ""; # newline
        echo "${certText}" | grep "Subject:" | sed -e "s/^.*CN=//" | sed -e "s/\/emailAddress=.*//";
        echo ""; # newline
        echo "Subject Alternative Name(s):";
        echo ""; # newline
        echo "${certText}" | grep -A 1 "Subject Alternative Name:" \
            | sed -e "2s/DNS://g" -e "s/ //g" | tr "," "\n" | tail -n +2;
        return 0;
    else
        echo "ERROR: Certificate not found.";
        return 1;
    fi;
}

function down4me ()
{
    curl -s "http://www.downforeveryoneorjustme.com/$1" | sed '/just you/!d;s/<[^>]*>//g'
}

function pghfm()
{
    # grip - https://github.com/joeyespo/grip
    # sudo pip install grip
    local inputfile
    if [ $# -eq 0 ]; then
        inputfile='README.md'
    elif [ $# -eq 1 ]; then
        inputfile=$1
    else
        echo "ERROR: Expected 0 or 1 file path arguments"
        return 1
    fi
    if [ -f "$inputfile" ]; then
        local filetime=$(date +%Y%m%d_%H%M%S)
        local filename="/tmp/`basename \"$inputfile\"`.$filetime.html"
        grip "$inputfile" --export "$filename"
        x-www-browser "$filename"
    else
        echo "'$inputfile' is not a valid file"
    fi
}

function mkcd ()
{
    mkdir -p -- "$*"
    cd -- "$*"
}

function bak ()
{
    if [ $# -ne 1 ]; then
        echo "Error: No file specified."
        return 1
    fi
    if [ -f $1 ] || [ -d $1 ]; then
        local filename=$1
        local filetime=$(date +%Y%m%d_%H%M%S)
        cp -a "${filename}" "${filename}.${filetime}.bak"
    else
        echo "'$1' is not a valid file"
    fi
}

function pcat() {
    # pygmentize - http://pygments.org/
    # sudo pip install Pygments
    for var;
    do
        pygmentize -g "$var"
    done
}

function pless() {
    # pygmentize - http://pygments.org/
    # sudo pip install Pygments
    if [ $# -eq 1 ]; then
        pygmentize -g $1 | less -r
    elif [ $# -eq 2 ] && [[ $1 == -* ]]; then
        pygmentize $2 | less "$1r"
    else
        echo "Error: bad arguments"
        echo "Usage: 'pless [-options] /path/to/file'"
    fi
}
