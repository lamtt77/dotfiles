#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# merge in defaults and keymaps

if [ -f $sysresources ]; then
    xrdb -merge $sysresources
fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"
fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

# start some nice programs

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

# ===
xrandr --output Virtual1 --mode 1280x800    # LamT: my Macbook Pro resolution
xrdb ~/.Xresources-xrdp		# LamT: for xrdp black box issue

# LamT: for dwm grey window issue when opening Idea, seems not happen if within LightDM
export _JAVA_AWT_WM_NONREPARENTING=1
export AWT_TOOLKIT=MToolkit
wmname LG3D

# LamT: for Vietnamese Input: IBus Bamboo Engine
export GTK_IM_MODULE=ibus
export XMODIFIERS=@im=ibus
export QT_IM_MODULE=ibus
export QT4_IM_MODULE=ibus
export CLUTTER_IM_MODULE=ibus
# ibus-daemon -rdx      # LamT: do not like to load permanently for now

# Default DM is set here
session=${1:-dwm}

case $session in
    i3|i3wm           ) exec i3;;
    # call `startdwm` instead of `exec dwm` to loop reload config (killall xinit/lightdm) without restart all apps
    #dwm               ) startdwm;;
    dwm               ) (conky | dwm-setstatus) & startdwm;;
    kde               ) exec startplasma-x11;;
    xfce|xfce4        ) exec startxfce4;;
    # No known session, try to run it as command
    *                 ) exec $1;;
esac

# ===
# exec dwm                # LamT
# exec i3
# exec enlightenment_start
# exec mate-session
# exec xmonad
# exec startlxqt
# exec startlxde
# exec awesome
# exec bspwm
# exec gnome-session
# exec gnome-session --session=gnome-classic
# exec startplasma-x11
# exec startplasma-wayland
# exec startxfce4
# exec startfluxbox
# exec openbox-session
# exec cinnamon-session
# exec pekwm
# exec catwm
# exec startede
# exec icewm-session
# exec jwm
# exec monsterwm
# exec notion
# exec startdde         # deepin-session
