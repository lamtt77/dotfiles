#!/usr/bin/env sh

# LamT: setup my archlinux X11/dwm/i3 workstation, 1) Link config files in home dir and 2) TODO Sudo copy config files to /etc
# add option `-nvv` to test first

stow -vv --stow arch-home/ -t ~/
