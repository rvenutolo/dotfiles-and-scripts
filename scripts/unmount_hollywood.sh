#!/usr/bin/env bash

fusermount -u $HOME/Hollywood

if [ -d $HOME/Hollywood ]; then
    rmdir $HOME/Hollywood
fi
