#!/usr/bin/bash
while true; do
  WALLDIR=~/ghq/github.com/zhichaoh/catppuccin-wallpapers

  img=$(fd . -e jpg -e png -e webp "$WALLDIR" | shuf -n1)

  feh --bg-fill "$img"
  wallust run "$img"

  i3-msg reload
  sleep 15m
done
