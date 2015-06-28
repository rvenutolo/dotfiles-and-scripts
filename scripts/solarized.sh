#!/usr/bin/env bash

set -e

# store all solarized files in one place
mkdir ~/.solarized
cd ~/.solarized

# dircolors
git clone https://github.com/seebi/dircolors-solarized.git
eval `dircolors ~/.solarized/dircolors-solarized/dircolors.256dark`
ln -s ~/.solarized/dircolors-solarized/dircolors.256dark ~/.dir_colors

# gnome terminal
git clone https://github.com/sigurdga/gnome-terminal-colors-solarized.git
./gnome-terminal-colors-solarized/install.sh

# guake
git clone https://github.com/coolwanglu/guake-colors-solarized
./guake-colors-solarized/set_dark.sh

# tmux
git clone https://github.com/seebi/tmux-colors-solarized.git
echo "
set -g default-terminal \"screen-256color-bce\"
source ~/.solarized/tmux-colors-solarized/tmuxcolors-256.conf" >> ~/.tmux.conf

# vim
echo "
set term=screen-256color-bce
let g:solarized_termcolors=256
set t_Co=256
set background=dark
colorscheme default " >> ~/.vimrc.after

# nano
# http://antesarkkinen.com/blog/add-colors-to-os-x-terminal-including-ls-and-nano/
#curl -OL http://85.159.208.243/share/givemecolors.tar.gz
#sudo mkdir -p /usr/share/nano
#sudo tar -zxvf givemecolors.tar.gz
#sudo cp givemecolors/*.nanorc /usr/share/nano/
#sudo cp givemecolors/nanorc /etc/nanorc

# gedit
mkdir -p ~/.gnome2/gedit/styles/
git clone https://github.com/mukashi/solarized.git mukashi_solarized
cp mukashi_solarized/gedit-colors-solarized/*.xml ~/.gnome2/gedit/styles
# modifying ~/.gconf/apps/gedit-2/preferences/editor/colors/%gconf.xml doesn't seem to work to set color scheme :(
# xmlstarlet edit -L -u "/gconf/entry[@name='scheme']/stringvalue" -v 'solarized_dark' ~/.gconf/apps/gedit-2/preferences/editor/colors/%gconf.xml

# intellij
# need to update path to config dir if not at ~/.IntelliJIdea14
git clone https://github.com/jkaving/intellij-colors-solarized.git
unzip intellij-colors-solarized/settings.jar 'colors/*' -d ~/.IntelliJIdea14/config/

echo ""
echo "########################################"
echo "Set gedit color scheme: Edit | Preferences | Font & Color"
echo "Set IntelliJIDEA colors: Settings | Editor | Colors & Fonts"
echo "########################################"
