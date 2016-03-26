#!/usr/bin/env bash

alias sudo='sudo '
alias _='sudo'

alias please='sudo $(fc -ln -1)'
alias plz='please'

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias mkdir='mkdir -p'
alias md='mkdir'
alias rd='rmdir'

alias c='clear'
alias cls='clear'

alias edit="$EDITOR"
alias pager="$PAGER"

alias q='exit'

alias lock='gnome-screensaver-command -l'
alias afk='lock'

alias h='history'
alias jobs='jobs -l'

alias which='type -a'

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

alias un='extract'

# often want to grep in some IntelliJ IDEA project directory and ignore .idea dir
alias grep='grep --exclude-dir=.idea --colour=auto'

alias chux='chmod u+x'
alias chax='chmod a+x'
alias 644='chmod 644'
alias 700='chmod 700'
alias 744='chmod 744'
alias 755='chmod 755'

alias update='\
    sudo apt-get update \
    && sudo apt-get upgrade \
    && sudo apt-get autoremove \
    && sudo apt-get clean \
'

alias bashrc='$EDITOR $HOME/.bashrc'
alias brc='source $HOME/.bashrc'
alias sdf='$PROJECTS_HOME/dotfiles-and-scripts/.bin/sync_dotfiles_and_scripts; brc'

alias path='echo -e ${PATH//:/\\n}'
alias libpath='echo -e ${LD_LIBRARY_PATH//:/\\n}'

alias du='du -ckh'
alias du1='du --max-depth=1'
alias df='df -kTh'

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

alias tree='tree -Cugph'

alias nano='nano -c'

alias pbcopy='xclip -selection clipboard'
alias pbpaste='xclip -selection clipboard -o'

#alias a='atom'
#alias ah='atom .'
#alias apmup='apm update --no-confirm'

alias pmdown='pghfm'

alias gcl='git clone'
alias ga='git add'
alias gall='git add .'
alias gus='git reset HEAD'
alias gm="git merge"
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
alias ggs="gg --stat"
alias gsl="git shortlog -sn"
alias gw="git whatchanged"
alias gt="git tag"
alias gta="git tag -a"
alias gtd="git tag -d"
alias gtl="git tag -l"
# From http://blogs.atlassian.com/2014/10/advanced-git-aliases/
# Show commits since last pull
alias gnew="git log HEAD@{1}..HEAD@{0}"
# Add uncommitted and unstaged changes to the last commit
alias gcaa="git commit -a --amend -C HEAD"
alias gtls='git tag -l | sort -V'
