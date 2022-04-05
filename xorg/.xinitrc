# sxhkd -c ~/.config/sxhkd/bspwm-sxhkdrc &
sxhkd &
dunst &
udiskie &

export XCURSOR_PATH=""

# set the pointer
xsetroot -cursor_name left_ptr &

# start clipboard manager
clipmenud &

# start torrents
transmission-daemon &

# exec bspwm
exec awesome
