#!/usr/bin/env sh

# LamT: setup my archlinux X11/dwm/i3 workstation, 1) Link config files in home dir and 2) TODO sudo copy config files to /etc
# add option `-nvv` to test first
#
# Maintenance, search for bogus links: chkstow -t ~

stow -vv --stow arch-home/ -t ~/
stow -vv --stow common-home/ -t ~/
