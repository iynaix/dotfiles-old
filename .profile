# set default variables
export PATH="$PATH:$HOME/bin:$HOME/.npm-global/bin:$HOME/.local/bin"
export EDITOR="nvim"
export TERMINAL="xst"

# start bspwm if not already running
[ "$(tty)" = "/dev/tty1" ] && ! pgrep -x bspwm >/dev/null && exec startx

# virtualenvwrapper related settings
export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/projects
export VIRTUALENVWRAPPER_SCRIPT=$(which virtualenvwrapper.sh)
source $(which virtualenvwrapper_lazy.sh)

source /home/iynaix/.config/broot/launcher/bash/br
