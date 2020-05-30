#!/usr/bin/env bash

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

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

unalias -a

for file in \
  '/etc/bash.bashrc' \
  'etc/bashrc' \
  '/usr/share/bash-completion/bash_completion' \
  '/usr/share/git/completion/git-prompt.sh' \
  "$HOME/.sdkman/bin/sdkman-init.sh" \
  "$HOME/.config/broot/launcher/bash/br" \
  "$HOME/.bash_exports" \
  "$HOME/.bash_functions" \
  "$HOME/.bash_extra" \
  "$HOME/.bash_aliases" \
  "$HOME/.bash_prompt"
do
  [[ -r "${file}" ]] && [[ -f "${file}" ]] && source "${file}"
done
unset file

[[ -r "$HOME/.dir_colors" ]] && [[ -f "$HOME/.dir_colors" ]] && eval "$(dircolors "$HOME/.dir_colors")"

type -p fasd >/dev/null 2>&1 && eval "$(fasd --init auto)"

for dir in \
  "$HOME/.local/bin" \
  "$HOME/.cargo/bin" \
  "$HOME/.bin"
do
  [[ -d "$dir" ]] && [[ $PATH != *"$dir"* ]] && PATH="$dir:$PATH"
done
unset dir
