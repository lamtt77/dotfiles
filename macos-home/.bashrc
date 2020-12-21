# LamT: read when interactive
export FZF_BASE=/usr/local/opt/fzf
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

[[ -e ~/.aliases ]] && source ~/.aliases
[[ -e ~/.myprofile ]] && source ~/.myprofile

#export TERM=xterm-256color
export SHELL=/bin/bash

# minio autocomplete
complete -C /usr/local/bin/mc mc
