#!/bin/bash

if [ ! -d ~/Hollywood ]; then
  mkdir ~/Hollywood
fi

sshfs rvenutolo@hollywood:/home/ ~/Hollywood
