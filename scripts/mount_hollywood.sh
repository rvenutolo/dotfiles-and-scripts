#!/usr/bin/env bash

if [ ! -d $HOME/Hollywood ]; then
    mkdir $HOME/Hollywood
fi

sshfs hollywood:/home/ $HOME/Hollywood
