#!/usr/bin/env bash

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

if [[ -r '/etc/bash.bashrc' ]]; then
    source '/etc/bash.bashrc'
elif [[ -r '/etc/bashrc' ]]; then
    source '/etc/bashrc'
fi

if [[ -r '/usr/share/bash-completion/bash_completion' ]]; then
    source '/usr/share/bash-completion/bash_completion'
fi

if [[ -f '/usr/share/git/completion/git-prompt.sh' ]]; then
  source '/usr/share/git/completion/git-prompt.sh'
fi

for file in $HOME/.bash_{exports,functions,extra,aliases,prompt,path}; do
    [[ -r "${file}" ]] && [[ -f "${file}" ]] && source "${file}";
done
unset file

umask 0022
ulimit -S -c 0 # no core dumps
set -o notify
set -o noclobber
set -o ignoreeof

shopt -s \
    cdable_vars \
    cdspell \
    checkhash \
    checkwinsize \
    cmdhist \
    direxpand \
    dirspell \
    dotglob \
    extglob \
    extquote \
    histappend \
    no_empty_cmd_completion \
    nocaseglob \
    progcomp \
    progcomp_alias \
    sourcepath

if [[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]]; then
    source "$HOME/.sdkman/bin/sdkman-init.sh"
fi

if [[ -r "$HOME/.dir_colors" ]]; then
    eval $(dircolors "$HOME/.dir_colors")
fi

if command -v fasd >/dev/null 2>&1; then
    eval "$(fasd --init auto)"
fi

for dir in "$HOME/.local/bin" "$HOME/.cargo/bin" "$HOME/.bin"
do
    if [[ -d "$dir" ]] && [[ $PATH != *"$dir"* ]]; then
        PATH=""$dir":$PATH"
    fi
done
unset dir

