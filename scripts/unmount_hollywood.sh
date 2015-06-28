#!/usr/bin/env bash

fusermount -u ~/Hollywood

if [ -d ~/Hollywood ]; then
  rmdir ~/Hollywood
fi
