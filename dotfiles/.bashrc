#!/usr/bin/env bash

# If not running interactively, don't do anything
[[ "$-" != *i* ]] && return

umask 0022
ulimit -S -c 0 # no core dumps
set -o notify
set -o noclobber
set -o ignoreeof

# shopt -p | sort -k3
shopt -u assoc_expand_once
shopt -u autocd
shopt -u cdable_vars
shopt -s cdspell
shopt -s checkhash
shopt -s checkjobs
shopt -s checkwinsize
shopt -s cmdhist
shopt -u compat31
shopt -u compat32
shopt -u compat40
shopt -u compat41
shopt -u compat42
shopt -u compat43
shopt -u compat44
shopt -s complete_fullquote
shopt -s direxpand
shopt -s dirspell
shopt -s dotglob
shopt -u execfail
shopt -s expand_aliases
shopt -u extdebug
shopt -s extglob
shopt -s extquote
shopt -u failglob
shopt -s force_fignore
shopt -s globasciiranges
shopt -u globstar
shopt -u gnu_errfmt
shopt -s histappend
shopt -u histreedit
shopt -u histverify
shopt -u hostcomplete
shopt -u huponexit
shopt -u inherit_errexit
shopt -s interactive_comments
shopt -u lastpipe
shopt -u lithist
shopt -u localvar_inherit
shopt -u localvar_unset
shopt -u login_shell
shopt -u mailwarn
shopt -s nocaseglob
shopt -u nocasematch
shopt -s no_empty_cmd_completion
shopt -u nullglob
shopt -s progcomp
shopt -s progcomp_alias
shopt -s promptvars
shopt -u restricted_shell
shopt -u shift_verbose
shopt -s sourcepath
shopt -u xpg_echo

unalias -a

function command_exists() {
  type -P -f "$1" >/dev/null 2>&1
}

for file in \
  '/etc/bash.bashrc' \
  '/etc/bashrc' \
  '/usr/share/bash-completion/bash_completion' \
  '/etc/bash_completion' \
  '/usr/local/etc/bash_completion' \
  '/etc/bash_completion.d/'* \
  '/usr/share/git/completion/git-prompt.sh' \
  '/etc/profile.d/autojump.sh' \
  '/usr/share/autojump/autojump.sh' \
  '/usr/share/autojump/autojump.bash' \
  "${HOME}/.sdkman/bin/sdkman-init.sh" \
  "${HOME}/.cargo/env" \
  "${HOME}/.config/broot/launcher/bash/br" \
  "${HOME}/.bash_exports" \
  "${HOME}/.bash_functions" \
  "${HOME}/.bash_aliases" \
  "${HOME}/.bash_extra"; do
  [[ -r "${file}" ]] && [[ -f "${file}" ]] && source "${file}"
done
unset file

for dir in \
  "$(ruby -e 'puts Gem.user_dir')/bin" \
  "${HOME}/.local/bin" \
  "${HOME}/.cargo/bin" \
  "${HOME}/.local/share/coursier/bin" \
  "${HOME}/.bin"; do
  [[ -d "${dir}" ]] && [[ "${PATH}" != *"${dir}"* ]] && PATH="${dir}:${PATH}"
done
unset dir

[[ -r "${HOME}/.dir_colors" ]] && [[ -f "${HOME}/.dir_colors" ]] && eval "$(dircolors "${HOME}/.dir_colors")"
command_exists 'fasd' && eval "$(fasd --init auto)"
command_exists 'starship' && eval "$(starship init bash)"

unset -f command_exists
