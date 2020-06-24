#!/usr/bin/env bash

alias sudo='sudo '
alias _='sudo'
alias please='sudo $(fc -ln -1)'
alias plz='please'

alias rm='rm -iv'
alias cp='cp -iv'
alias mv='mv -iv'
alias mkdir='mkdir -pv'
alias ln='ln -v'
alias jobs='jobs -l'
alias grep='grep --exclude-dir=.idea --exclude-dir=.git --colour=auto'
alias egrep='grep -E'
alias fgrep='grep -F'
alias du='du -ckh'
alias du1='du --max-depth=1'
alias df='df -kTh'
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
alias map='xargs -n1'
alias which='type -a'
alias path='echo -e ${PATH//:/\\n}'
alias cls='clear'
alias q='exit'
alias h='history'

alias file_extensions='find . -type f | sed -n "s/..*\.//p" | sort | uniq -c'

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias home='cd ${HOME}'
alias dl='cd ${HOME}/Downloads'
alias dt='cd ${HOME}/Desktop'
alias c='cd ${CODE_DIR}'

alias brc='source ${HOME}/.bashrc'
alias sdf='${CODE_DIR}/dotfiles-and-scripts/bin/sync-dotfiles-and-scripts; brc'

alias e='edit'
alias pager='${PAGER}'

if command_exists 'exa'; then
  alias exa='exa --classify --group-directories-first --icons --header --time-style=long-iso --color-scale --git'
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

if command_exists 'broot'; then
  alias br='br -dhp'
  alias bs='br --sizes'
fi

if command_exists 'curl'; then
  alias wanip='curl ifconfig.me/ip'
  alias wttr='curl wttr.in/${WTTR_CITY}'
fi

if command_exists 'fasd'; then
  alias a='fasd -a'        # any
  alias s='fasd -si'       # show / search / select
  alias d='fasd -d'        # directory
  alias f='fasd -f'        # file
  alias sd='fasd -sid'     # interactive directory selection
  alias sf='fasd -sif'     # interactive file selection
  alias z='fasd_cd -d'     # cd, same functionality as j in autojump
  alias zz='fasd_cd -d -i' # cd with interactive selection
fi

if command_exists 'git'; then
  alias g='git'
  alias ga='git add'
  alias gc='git commit'
  alias gs='git status'
  alias gb='git checkout'
  alias gm='git merge'
fi

if command_exists 'gradle'; then
  alias gradle='gradle-or-gradlew'
fi

if command_exists 'ip'; then
  alias localip='ip -o route get to 8.8.8.8 | sed -n "s/.*src \([0-9.]\+\).*/\1/p"'
fi

if command_exists 'journalctl'; then
  alias coredumps='journalctl | command grep -F "dumped core"'
fi

if command_exists 'kate'; then
  alias k='kate'
fi

if command_exists 'micro'; then
  alias m='micro'
fi

if command_exists 'msgcat'; then
  alias colortest='msgcat --color=test'
fi

if command_exists 'mvn'; then
  alias mvn='mvn-or-mvnw'
  alias sortpom='\
    mvn com.github.ekryd.sortpom:sortpom-maven-plugin:sort \
    -Dsort.keepBlankLines=true \
    -Dsort.predefinedSortOrder="recommended_2008_06" \
    -Dsort.encoding="UTF-8" \
    -Dsort.lineSeparator="\n" \
    -Dsort.nrOfIndentSpace=4'
  alias sortpomanddependencies='\
    mvn com.github.ekryd.sortpom:sortpom-maven-plugin:sort \
    -Dsort.keepBlankLines=true \
    -Dsort.predefinedSortOrder="recommended_2008_06" \
    -Dsort.encoding="UTF-8" \
    -Dsort.lineSeparator="\n" \
    -Dsort.nrOfIndentSpace=4 \
    -Dsort.sortDependencies=scope,groupId,artifactId'
fi

if command_exists 'nano'; then
  alias nano='nano -c'
  alias n='nano'
fi

if command_exists 'notify-send'; then
  # use like so: sleep 10; alert
  alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
fi

if command_exists 'nvim'; then
  alias vim='nvim'
  alias v='nvim'
elif command_exists 'vim'; then
  alias v='vim'
else
  alias v='vi'
fi

if command_exists 'safe-rm'; then
  alias rm='safe-rm -iv'
fi

if command_exists 'tldr'; then
  alias t='tldr'
fi

if command_exists 'tree'; then
  alias tree='tree -Cugph'
fi

if command_exists 'xsel'; then
  alias clip='xsel -ib'
  alias paste='xsel -ob'
fi

if command_exists 'yay'; then
  alias update='yay -Syyu && yay --clean'
  alias p='pacman'
  alias y='yay'
elif command_exists 'apt'; then
  alias update='sudo apt update && sudo apt upgrade && sudo apt autoremove'
fi
