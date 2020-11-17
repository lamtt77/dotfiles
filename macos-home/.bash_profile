[[ -e ~/.aliases ]] && source ~/.aliases
[[ -e ~/.myprofile ]] && source ~/.myprofile

[ -f /usr/local/etc/profile.d/autojump.sh ] && . /usr/local/etc/profile.d/autojump.sh

#export TERM=xterm-256color
export SHELL=/bin/bash

# minio autocomplete
complete -C /usr/local/bin/mc mc
