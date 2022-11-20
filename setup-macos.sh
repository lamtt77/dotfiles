#!/usr/bin/env sh

# LamT: setup my macbook pro laptop, 1) Link config files in home dir and 2) sudo/copy config files to /etc
# add option `-nvv` to test first

stow -vv --stow macos-home/ -t ~/
stow -vv --stow common-home/ -t ~/

# some files needed to manually copy/sync, for instance, Safari won't read symlink config file
MANUAL_DIR="macos-sync"

printf "\nSyncing %s... " "$MANUAL_DIR"

copy() {
  orig_file="$MANUAL_DIR/$1"
  dest_file="$2"

  #cp -vR "$orig_file" "$dest_file/$1"
  rsync -ravh "$orig_file" "$dest_file/$1"
}

copy "Library/" "$HOME"
