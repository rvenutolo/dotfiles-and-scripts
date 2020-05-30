#!/usr/bin/env bash

alias sudo='sudo '
alias _='sudo'

## aliases to add flags to same command
if type -P -f safe-rm >/dev/null 2>&1; then
  alias rm='safe-rm -i'
else
  alias rm='rm -i'
fi
alias cp='cp -i'
alias mv='mv -i'
alias mkdir='mkdir -p'
alias ln='ln -v'
alias jobs='jobs -l'
alias br='br -dhp'
alias grep='grep --exclude-dir=.idea --exclude-dir=.git --colour=auto'
alias egrep='grep -E'
alias fgrep='grep -F'
alias du='du -ckh'
alias df='df -kTh'
alias free='free -m'
alias tree='tree -Cugph'
alias nano='nano -c'

## aliases to replace one command with another
alias which='type -a'
if type -P -f nvim >/dev/null 2>&1; then
  alias vim='nvim'
fi

## shorter aliases
alias cls='clear'
alias q='exit'
alias h='history'
alias un='extract'
alias plz='please'

## navigation aliases
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias home='cd $HOME'
alias dl='cd $HOME/Downloads'
alias dt='cd $HOME/Desktop'
alias c='cd $CODE_DIR'

## ls aliases
if type -P -f 'exa' >/dev/null 2>&1; then
  alias exa='exa --classify --group-directories-first --header --time-style=long-iso --color-scale --git'
  alias ls='exa'
  alias ll='exa --long'
  alias la='exa --all'
  alias lla='exa --long --all'
  alias llx='ll --sort=extension'
  alias llax='lla --sort=extension'
  alias lls='ll --sort=size'
  alias llas='lla --sort=size'
  alias llc='ll --sort=mod'
  alias llac='lla --sort=mod'
  alias llr='ll --recurse'
  alias llar='lla --recurse'
  alias tree='ll --tree'
else
  alias ls="ls -hF --color --group-directories-first"
  alias ll='ls -l'
  alias la='ls -A'
  alias lla='ls -Al'
  alias llx='ll -XB' # sort by extension
  alias llax='lla -XB'
  alias lls='ll -lSr' # sort by size, biggest last
  alias llas='lla -lSr'
  alias llc='ll -tcr' # sort by and show change time, most recent last
  alias llac='lla -tcr'
  alias llr='ll -R' # recursive ls
  alias llar='lla -R'
fi

## fasd aliases
alias a='fasd -a'        # any
alias s='fasd -si'       # show / search / select
alias d='fasd -d'        # directory
alias f='fasd -f'        # file
alias sd='fasd -sid'     # interactive directory selection
alias sf='fasd -sif'     # interactive file selection
alias z='fasd_cd -d'     # cd, same functionality as j in autojump
alias zz='fasd_cd -d -i' # cd with interactive selection

## aliases to execute a command with args
alias please='sudo $(fc -ln -1)'
alias bs='br --sizes'
alias chux='chmod u+x'
alias chax='chmod a+x'
alias 600='chmod 600'
alias 644='chmod 644'
alias 655='chmod 655'
alias 700='chmod 700'
alias 744='chmod 744'
alias 755='chmod 755'
alias map='xargs -n1'
# use like so: sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
alias brc='source $HOME/.bashrc'
alias sdf='$CODE_DIR/dotfiles-and-scripts/bin/sync-dotfiles-and-scripts; brc'
alias path='echo -e ${PATH//:/\\n}'
alias du1='du --max-depth=1'
alias localip='ip -o route get to 8.8.8.8 | sed -n "s/.*src \([0-9.]\+\).*/\1/p"'
alias wanip='curl ifconfig.me/ip'

alias sortpom=''\
  'mvn com.github.ekryd.sortpom:sortpom-maven-plugin:sort '\
  '-Dsort.keepBlankLines=true '\
  '-Dsort.predefinedSortOrder="recommended_2008_06" '\
  '-Dsort.encoding="UTF-8" '\
  '-Dsort.lineSeparator="\n" '\
  '-Dsort.nrOfIndentSpace=4'
alias sortpomanddependencies=''\
  'mvn com.github.ekryd.sortpom:sortpom-maven-plugin:sort '\
  '-Dsort.keepBlankLines=true '\
  '-Dsort.predefinedSortOrder="recommended_2008_06" '\
  '-Dsort.encoding="UTF-8" '\
  '-Dsort.lineSeparator="\n" '\
  '-Dsort.nrOfIndentSpace=4 '\
  '-Dsort.sortDependencies=scope,groupId,artifactId'
alias wttr='curl wttr.in/$WTTR_CITY'

if type -P -f 'yay' >/dev/null 2>&1; then
  alias update='yay -Syyu && yay --clean'
elif type -P -f 'apt' >/dev/null 2>&1; then
  alias update='sudo apt update && sudo apt upgrade && sudo apt autoremove'
else
  echo 'Could not find yay or apt' 1>&2
fi

## generic aliases
alias edit='$EDITOR'
alias pager='$PAGER'
alias fm='$FILE_MANAGER'
