#
# ~/.bash_profile
#

# LamT: use .xprofile for LightDM
#if [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
#  #exec startx ~/.xinitrc dwm
#  exec startx ~/.xinitrc i3
#fi

[[ -f ~/.bashrc ]] && . ~/.bashrc

