#!/usr/bin/env bash

rsync --progress -av hollywood:/digitalenvoy/netacuity/to_release/\*.db $HOME/nadbs/
