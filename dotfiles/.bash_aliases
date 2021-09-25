#!/usr/bin/env bash

alias sudo='sudo '
alias _='sudo'
alias please='sudo $(fc -ln -1)'
alias plz='please'

if command_exists 'exa'; then
  alias exa='exa --classify --group-directories-first --icons --header --time-style=long-iso --color-scale --git'
  alias ls='exa'
  alias l='exa'
  alias ll='exa --long'
  alias la='exa --all'
  alias lla='exa --long --all'
  alias llx='exa --long --sort=extension'
  alias llax='exa --long --all --sort=extension'
  alias lls='exa --long --sort=size'
  alias llas='exa --long --all --sort=size'
  alias llc='exa --long --sort=mod'
  alias llac='exa --long --all --sort=mod'
  alias llr='exa --long --recurse'
  alias llar='exa --long --all --recurse'
  alias tree='exa --long --tree'
else
  alias ls="ls -hF --color --group-directories-first"
  alias l='ls'
  alias ll='ls -l'
  alias la='ls -A'
  alias lla='ls -Al'
  alias llx='ls -l -XB' # sort by extension
  alias llax='ls -Al -XB'
  alias lls='ls -l -lSr' # sort by size, biggest last
  alias llas='ls -Al -lSr'
  alias llc='ls -l -tcr' # sort by and show change time, most recent last
  alias llac='ls -Al -tcr'
  alias llr='ls -l -R' # recursive ls
  alias llar='ls -Al -R'
fi

alias mkdir='mkdir -pv'
alias cp='cp -iv'
alias mv='mv -iv'
alias rm='rm -Iv --preserve-root'
if command_exists 'safe-rm'; then
  alias rm='safe-rm -iv'
fi
alias chown='chown --preserve-root'
alias chmod='chmod --preserve-root'
alias chgrp='chgrp --preserve-root'


alias e='edit'
alias k='kate'
alias m='micro'
alias nano='nano -c'
alias n='nano'
alias x='xdg-open'
if command_exists 'nvim'; then
  alias vim='nvim'
  alias v='nvim'
elif command_exists 'vim'; then
  alias v='vim'
else
  alias v='vi'
fi

alias grep='grep --exclude-dir=.idea --exclude-dir=.git --colour=auto'
alias egrep='grep -E'
alias fgrep='grep -F'

alias du='du -ckh'
alias du1='du --max-depth=1'
alias df='df -kTh -x squashfs'
alias free='free -m'

alias chux='chmod u+x'
alias chax='chmod a+x'
alias 600='chmod 600'
alias 640='chmod 640'
alias 644='chmod 644'
alias 655='chmod 655'
alias 700='chmod 700'
alias 744='chmod 744'
alias 755='chmod 755'
alias 775='chomd 775'

alias ..='cd ..'
alias ...='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../..'
alias .5='cd ../../../..'
alias .6='cd ../../../../..'
alias home='cd ${HOME}'
alias dl='cd ${HOME}/Downloads'
alias dt='cd ${HOME}/Desktop'
alias c='cd ${CODE_DIR}'

alias tarc="tar -cvzf"
alias tarx="tar -xf"

alias br='br -dhp'
alias bs='br --sizes'

alias a='fasd -a'        # any
alias s='fasd -si'       # show / search / select
alias d='fasd -d'        # directory
alias f='fasd -f'        # file
alias sd='fasd -sid'     # interactive directory selection
alias sf='fasd -sif'     # interactive file selection
alias z='fasd_cd -d'     # cd, same functionality as j in autojump
alias zz='fasd_cd -d -i' # cd with interactive selection

alias g='git'
alias ga='git add'
alias gc='git commit'
alias gs='git status'
alias gb='git checkout'
alias gm='git merge'

alias docker-clean-images='docker rmi $(docker images -a --filter=dangling=true -q)'
alias docker-clean-ps='docker rm $(docker ps --filter=status=exited --filter=status=created -q)'

alias gradle='gradle-or-gradlew'
alias mvn='mvn-or-mvnw'
alias mvnsources='mvn dependency:sources && mvn dependency:resolve -Dclassifier=javadoc'
alias sortpom="mvn com.github.ekryd.sortpom:sortpom-maven-plugin:sort"\
" -Dsort.keepBlankLines=true"\
" -Dsort.predefinedSortOrder='recommended_2008_06'"\
" -Dsort.encoding='UTF-8'"\
" -Dsort.lineSeparator='\n'"\
" -Dsort.nrOfIndentSpace=4"
alias sortpomanddependencies="mvn com.github.ekryd.sortpom:sortpom-maven-plugin:sort"\
" -Dsort.keepBlankLines=true"\
" -Dsort.predefinedSortOrder='recommended_2008_06'"\
" -Dsort.encoding='UTF-8'"\
" -Dsort.lineSeparator='\n'"\
" -Dsort.nrOfIndentSpace=4"\
" -Dsort.sortDependencies=scope,groupId,artifactId"

alias update='paru -Syu && paru -c'
alias p='paru'
alias update-mirrors='sudo pacman-mirrors --country United_States,Canada && sudo pacman-mirrors --fasttrack && sudo pacman -Syyu'

alias copy='xsel -ib'
alias paste='xsel -ob'
alias cwd='pwd | tr -d "\r\n" | copy'
alias shrug='echo -n "¯\_(ツ)_/¯" | copy'

alias psa='ps aux'
alias psaf='ps auxf'

## get top process eating memory
alias psmem='ps auxf | sort -nr -k 4'
alias psmem10='ps auxf | sort -nr -k 4 | head -10'

## get top process eating cpu ##
alias pscpu='ps auxf | sort -nr -k 3'
alias pscpu10='ps auxf | sort -nr -k 3 | head -10'

alias jctl="journalctl -p3 -xb"
alias jctl-last="journalctl -p3 -xb1"

alias ln='ln -v'
alias jobs='jobs -l'
alias map='xargs -n1'
alias which='type -a'
alias path='echo -e ${PATH//:/\\n}'
alias cls='clear'
alias q='exit'
alias h='history'
alias file-extensions='find . -type f | sed -n "s/..*\.//p" | sort | uniq -c | sort -nr'
alias file-counts='du -a | cut -d/ -f2 | sort | uniq -c | sort -nr'
alias pager='${PAGER}'
alias t='tldr'
alias tree='tree -Cugph'
# use like so: sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
alias brc='source ${HOME}/.bashrc'
alias sdf='${CODE_DIR}/dotfiles-and-scripts/bin/sync-dotfiles-and-scripts; brc'
alias coredumps='journalctl | command grep -F "dumped core"'
alias colortest='msgcat --color=test'
alias localip='ip -o route get to 8.8.8.8 | sed -n "s/.*src \([0-9.]\+\).*/\1/p"'
alias wanip='curl ifconfig.me/ip'
alias wttr='curl wttr.in/${WTTR_CITY}'
alias flac2v0='flac2mp3.pl --quiet --lameargs="-V0 --noreplaygain --nohist --quiet" --processes="$(nproc)" . .'
