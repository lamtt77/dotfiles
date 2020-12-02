#!/usr/bin/env sh

# LamT: setup my macbook pro laptop, 1) Link config files in home dir and 2) TODO Sudo copy config files to /etc
# add option `-nvv` to test first

stow -nvv --stow macos-home/ -t ~/
