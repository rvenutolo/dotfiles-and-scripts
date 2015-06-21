#-------------------------------------------------------------
# Some settings
#-------------------------------------------------------------

ulimit -S -c 0          # Don't want any coredumps.
set -o notify
set -o noclobber
set -o ignoreeof
#set -o xtrace          # Useful for debuging.

# Enable options:
shopt -s cdspell
shopt -s cdable_vars
shopt -s checkhash
shopt -s checkwinsize
shopt -s sourcepath
shopt -s no_empty_cmd_completion
shopt -s cmdhist
shopt -s histappend histreedit histverify
shopt -s extglob        # Necessary for programmable completion.
shopt -s dirspell

# Disable options:
shopt -u mailwarn
unset MAILCHECK         # Don't want my shell to warn me of incoming mail.

#export TIMEFORMAT=$'\nreal %3R\tuser %3U\tsys %3S\tpcpu %P\n'
#export HISTTIMEFORMAT="%H:%M > "
#export HISTIGNORE="&:bg:fg:ll:h"
export HOSTFILE=$HOME/.hosts    # Put list of remote hosts in ~/.hosts ...

export EDITOR=nano
export HISTCONTROL=ignoredups
export LANG=en_US.UTF-8;
export LC_ALL=en_US.UTF-8;
export MANPAGER='less -X';
export GREP_OPTIONS='--color=auto';

#-------------------
# Aliases
#-------------------

alias sudo='sudo '
alias _='sudo'

alias please='sudo $(fc -ln -1)'

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias md='mkdir -p'
alias mkdir='mkdir -p'
alias rd='rmdir'

alias cls='clear'
alias q='exit'

alias nano='nano -c'

alias h='history'
alias j='jobs -l'

alias which='type -a'

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias home='cd ~'
alias o='cd /opt'
alias p='cd ~/Projects'
alias dl='cd ~/Downloads'
alias dt='cd ~/Desktop'

alias un='extract'

alias mx='chmod a+x'
alias 644='chmod 644'
alias 744='chmod 744'
alias 755='chmod 755'

alias update='sudo apt-get update && sudo apt-get upgrade'

alias path='echo -e ${PATH//:/\\n}'
alias libpath='echo -e ${LD_LIBRARY_PATH//:/\\n}'

alias du='du -kh'       # Makes a more readable output.
alias df='df -kTh'

alias ip='dig +short myip.opendns.com @resolver1.opendns.com'
alias localip='hostname -I'
alias ips="ifconfig -a | grep -o 'inet6\? \(addr:\)\?\s\?\(\(\([0-9]\+\.\)\{3\}[0-9]\+\)\|[a-fA-F0-9:]\+\)' | awk '{ sub(/inet6? (addr:)? ?/, \"\"); print }'"

alias ll='ls -l --group-directories-first'
alias lla='ls -Al --group-directories-first'
alias ls='ls -hF --color'  # add colors for filetype recognition
alias la='ls -Al'          # show hidden files
alias lx='ls -lXB'         # sort by extension
alias lk='ls -lSr'         # sort by size, biggest last
alias lc='ls -ltcr'        # sort by and show change time, most recent last
alias lu='ls -ltur'        # sort by and show access time, most recent last
alias lt='ls -ltr'         # sort by date, most recent last
alias lm='ls -al |more'    # pipe through 'more'
alias lr='ls -lR'          # recursive ls
alias tree='tree -Csu'     # nice alternative to 'recursive ls'


#-------------------------------------------------------------
# Make the following commands run in background automatically:
#-------------------------------------------------------------

function firefox() { command firefox '$@' & }
function google-chrome() { command google-chrome '$@' & }
function gedit() { command gedit '$@' & }


#-------------------------------------------------------------
# File & string-related functions:
#-------------------------------------------------------------

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
        nf=$(echo $filename | tr A-Z a-z)
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

    mv "$1" $TMPFILE 
    mv "$2" "$1"
    mv $TMPFILE "$2"
}

function extract()      # Handy Extract Program.
{
     if [ -f $1 ] ; then
         case $1 in
             *.tar.bz2)   tar xvjf $1     ;;
             *.tar.gz)    tar xvzf $1     ;;
             *.bz2)       bunzip2 $1      ;;
             *.rar)       unrar x $1      ;;
             *.gz)        gunzip $1       ;;
             *.tar)       tar xvf $1      ;;
             *.tbz2)      tar xvjf $1     ;;
             *.tgz)       tar xvzf $1     ;;
             *.zip)       unzip $1        ;;
             *.Z)         uncompress $1   ;;
             *.7z)        7z x $1         ;;
             *)           echo "'$1' cannot be extracted via >extract<" ;;
         esac
     else
         echo "'$1' is not a valid file"
     fi
}

#-------------------------------------------------------------
# Process/system related functions:
#-------------------------------------------------------------

function my_ps() { ps $@ -u $USER -o pid,%cpu,%mem,bsdtime,command ; }
function pp() { my_ps f | awk '!/awk/ && $0~var' var=${1:-".*"} ; }

function killps()                 # Kill by process name.
{
    local pid pname sig="-TERM"   # Default signal.
    if [ "$#" -lt 1 ] || [ "$#" -gt 2 ]; then
        echo "Usage: killps [-SIGNAL] pattern"
        return;
    fi
    if [ $# = 2 ]; then sig=$1 ; fi
    for pid in $(my_ps| awk '!/awk/ && $0~pat { print $1 }' pat=${!#} ) ; do
        pname=$(my_ps | awk '$1~var { print $5 }' var=$pid )
        if ask "Kill process $pid <$pname> with signal $sig?"
            then kill $sig $pid
        fi
    done
}

function ii()   # Get current host related info.
{
    echo -e "\nYou are logged on $(hostname)"
    echo -e "\nAdditionnal information: " ; uname -a
    echo -e "\nUsers logged on: " ; w -h
    echo -e "\nCurrent date : " ; date
    echo -e "\nMachine stats : " ; uptime
    echo -e "\nMemory stats : " ; free
    my_ip 2>&- ;
    echo -e "\nLocal IP Address :" ; echo ${MY_IP:-"Not connected"}
    echo -e "\nISP Address :" ; echo ${MY_ISP:-"Not connected"}
    echo -e "\nOpen connections : "; netstat -pan --inet;
    echo
}

#-------------------------------------------------------------
# Prompt
#-------------------------------------------------------------

if [[ $COLORTERM = gnome-* && $TERM = xterm ]] && infocmp gnome-256color >/dev/null 2>&1; then
	export TERM='gnome-256color';
elif infocmp xterm-256color >/dev/null 2>&1; then
	export TERM='xterm-256color';
fi;

if tput setaf 1 &> /dev/null; then
	tput sgr0; # reset colors
	bold=$(tput bold);
	reset=$(tput sgr0);
	# Solarized colors, taken from http://git.io/solarized-colors.
	black=$(tput setaf 0);
	blue=$(tput setaf 33);
	cyan=$(tput setaf 37);
	green=$(tput setaf 64);
	orange=$(tput setaf 166);
	purple=$(tput setaf 125);
	red=$(tput setaf 124);
	violet=$(tput setaf 61);
	white=$(tput setaf 15);
	yellow=$(tput setaf 136);
else
	bold='';
	reset="\e[0m";
	black="\e[1;30m";
	blue="\e[1;34m";
	cyan="\e[1;36m";
	green="\e[1;32m";
	orange="\e[1;33m";
	purple="\e[1;35m";
	red="\e[1;31m";
	violet="\e[1;35m";
	white="\e[1;37m";
	yellow="\e[1;33m";
fi;

# Highlight the user name when logged in as root.
if [[ "${USER}" == "root" ]]; then
	userStyle="${red}";
else
	userStyle="${orange}";
fi;

# Highlight the hostname when connected via SSH.
if [[ "${SSH_TTY}" ]]; then
	hostStyle="${bold}${red}";
else
	hostStyle="${yellow}";
fi;

# Set the terminal title to the current working directory.
PS1="\[\033]0;\w\007\]";
PS1+="\[${bold}\]";
PS1+="\[${userStyle}\]\u"; # username
PS1+="\[${white}\]@";
PS1+="\[${hostStyle}\]\h"; # host
PS1+="\[${white}\] ";
PS1+="\[${green}\]\w "; # working directory
PS1+="\[${white}\]\$ \[${reset}\]"; # `$` (and reset color)
export PS1;

PS2="\[${yellow}\]→ \[${reset}\]";
export PS2;

