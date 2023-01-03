#!/usr/bin/env bash

function mkcd() {
  mkdir -p -- "$@" && cd -- "$@" || exit
}

function fff() {
  command fff "$@"
  cd "$(cat "${XDG_CACHE_HOME:=${HOME}/.cache}/fff/.fff_d")" || exit
}
