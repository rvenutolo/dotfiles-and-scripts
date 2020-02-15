#!/usr/bin/env bash

alias sudo='sudo '
alias _='sudo'

## aliases to add flags to same command
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias mkdir='mkdir -p'
alias ln='ln -v'
alias jobs='jobs -l'
alias br='br -dhp'
alias grep='grep --exclude-dir=.idea --exclude-dir=.git --colour=auto'
alias egrep='egrep --exclude-dir=.idea --exclude-dir=.git --colour=auto'
alias fgrep='fgrep --exclude-dir=.idea --exclude-dir=.git --colour=auto'
alias du='du -ckh'
alias df='df -kTh'
alias free='free -m'
alias ls="ls -hF --color"
alias tree='tree -Cugph'
alias nano='nano -c'

## aliases to replace one command with another
alias which='type -a'

## shorter aliases
alias c='clear'
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
alias -- -='cd -'
alias home='cd $HOME'
alias p='cd $HOME/Projects'
alias dl='cd $HOME/Downloads'
alias dt='cd $HOME/Desktop'
alias o='cd /opt'

## ls aliases
alias ll='ls -l --group-directories-first'
alias lla='ls -Al --group-directories-first'
alias llx='ll -XB' # sort by extension
alias llax='lla -XB'
alias llk='ll -lSr' # sort by size, biggest last
alias llak='lla -lSr'
alias llc='ll -tcr' # sort by and show change time, most recent last
alias llac='lla -tcr'
alias llu='ll -tur' # sort by and show access time, most recent last
alias llau='lla -tur'
alias llt='ll -tr' # sort by date, most recent last
alias llat='lla -tr'
alias llr='ll -R' # recursive ls
alias llar='lla -R'

## git aliases
alias g='git'
alias gcl='git clone'
alias ga='git add'
alias gall='git add .'
alias gus='git reset HEAD'
alias gm='git merge'
alias g='git'
alias get='git'
alias gst='git status'
alias gs='git status'
alias gss='git status -s'
alias gl='git pull'
alias gpr='git pull --rebase'
alias gpp='git pull && git push'
alias gup='git fetch && git rebase'
alias gp='git push'
alias gpo='git push origin'
alias gdv='git diff -w "$@" | vim -R -'
alias gc='git commit -v'
alias gca='git commit -v -a'
alias gcm='git commit -v -m'
alias gci='git commit --interactive'
alias gb='git branch'
alias gba='git branch -a'
alias gcount='git shortlog -sn'
alias gcp='git cherry-pick'
alias gco='git checkout'
alias gexport='git archive --format zip --output'
alias gdel='git branch -D'
alias gmu='git fetch origin -v; git fetch upstream -v; git merge upstream/master'
alias gll='git log --graph --pretty=oneline --abbrev-commit'
alias gg="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%Creset' --abbrev-commit --date=relative"
alias ggs='gg --stat'
alias gsl='git shortlog -sn'
alias gw='git whatchanged'
alias gt='git tag'
alias gta='git tag -a'
alias gtd='git tag -d'
alias gtl='git tag -l'
# From http://blogs.atlassian.com/2014/10/advanced-git-aliases/
# Show commits since last pull
alias gnew='git log HEAD@{1}..HEAD@{0}'
# Add uncommitted and unstaged changes to the last commit
alias gcaa='git commit -a --amend -C HEAD'
alias gtls='git tag -l | sort -V'

## aliases to execute a command with args
alias please='sudo $(fc -ln -1)'
alias bs='br --sizes'
alias chux='chmod u+x'
alias chax='chmod a+x'
alias 644='chmod 644'
alias 700='chmod 700'
alias 744='chmod 744'
alias 755='chmod 755'
alias map='xargs -n1'
alias update='sudo apt update && sudo apt upgrade && sudo apt autoremove'
# use like so: sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
alias brc='source $HOME/.bashrc'
alias sdf='$PROJECTS_DIR/dotfiles-and-scripts/bin/sync-dotfiles-and-scripts; brc'
alias path='echo -e ${PATH//:/\\n}'
alias libpath='echo -e ${LD_LIBRARY_PATH//:/\\n}'
alias du1='du --max-depth=1'
alias localip='hostname -I'
alias ips="ifconfig -a | grep -o 'inet6\? \(addr:\)\?\s\?\(\(\([0-9]\+\.\)\{3\}[0-9]\+\)\|[a-fA-F0-9:]\+\)' | awk '{ sub(/inet6? (addr:)? ?/, \"\"); print }'"
alias pbcopy='xclip -selection clipboard'
alias pbpaste='xclip -selection clipboard -o'
alias list-manual-packages="comm -23 <(apt-mark showmanual | sort -u) <(gzip -dc /var/log/installer/initial-status.gz | sed -n 's/^Package: //p' | sort -u)"
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
alias weather='curl wttr.in/$WTTR_CITY'
# the terminal rickroll
alias rr='curl -s -L https://raw.githubusercontent.com/keroserene/rickrollrc/master/roll.sh | bash'

## generic aliases
alias edit="$EDITOR"
alias pager="$PAGER"
alias fm="$FILEMANAGER"
