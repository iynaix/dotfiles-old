# set default variables
export PATH="$PATH:$HOME/bin"
export EDITOR="nvim"
export TERMINAL="st"

# start bspwm if not already running
# [ "$(tty)" = "/dev/tty1" ] && ! pgrep -x bspwm >/dev/null && exec startx

# virtualenvwrapper related settings
export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/projects
export VIRTUALENVWRAPPER_SCRIPT=$(which virtualenvwrapper.sh)
source $(which virtualenvwrapper_lazy.sh)
