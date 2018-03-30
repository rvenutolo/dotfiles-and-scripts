#!/usr/bin/env bash

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

if [[ -r /etc/bashrc ]]; then
    source /etc/bashrc
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

for file in $HOME/.bash_{aliases,exports,functions,prompt,extra,path}; do
    [[ -r "${file}" ]] && [[ -f "${file}" ]] && source "${file}";
done;
unset file;

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
shopt -s nocaseglob
shopt -s dirspell

# Disable options:
shopt -u mailwarn
unset MAILCHECK         # Don't want my shell to warn me of incoming mail.

# disable core dumps
ulimit -S -c 0

# default umask
umask 0022

# https://github.com/joelthelion/autojump
if [[ -r /usr/share/autojump/autojump.sh ]]; then
    source /usr/share/autojump/autojump.sh
fi

# https://github.com/clvv/fasd
if [[ "$(type -P fasd)" ]]; then
    eval "$(fasd --init auto)"
fi

# put ~/.local/bin at front of PATH
if [[ -d "$HOME/.local/bin" ]] && [[ $PATH != "$HOME/.local/bin"* ]]; then
    PATH="$HOME/.local/bin:$PATH"
fi

# put ~/.bin at front of PATH
if [[ -d "$HOME/.bin" ]] && [[ $PATH != "$HOME/.bin"* ]]; then
    PATH="$HOME/.bin:$PATH"
fi

# set dircolors
if [[ -e "$HOME/.dir_colors/dircolors" ]]; then
    eval `dircolors "$HOME/.dir_colors/dircolors"`
fi
