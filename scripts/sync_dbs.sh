#!/usr/bin/env bash

rsync --progress -av rvenutolo@hollywood:/digitalenvoy/netacuity/to_release/\*.db $HOME/nadbs/
