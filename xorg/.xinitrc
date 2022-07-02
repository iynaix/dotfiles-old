dunst &
udiskie &

export XCURSOR_PATH=""

# set the pointer
xsetroot -cursor_name left_ptr &

# start clipboard manager
clipmenud &

# start torrents
transmission-daemon &

# setup displays and wallpaper
source ~/bin/wallpaper

wm_=bspwm
if [ $wm_ == awesome ]; then
    sxhkd -c ~/.config/sxhkd/common.conf &
    exec awesome >> /tmp/awesome_stdout 2>> /tmp/awesome_stderr
else
    sxhkd -c ~/.config/sxhkd/common.conf ~/.config/sxhkd/bspwm.conf &
    exec bspwm
fi
