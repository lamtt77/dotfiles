#!/usr/bin/env sh

# LamT: setup my macbook pro laptop, 1) Link config files in home dir and 2) TODO sudo copy config files to /etc
# add option `-nvv` to test first

stow -vv --stow macos-home/ -t ~/
stow -vv --stow common-home/ -t ~/
