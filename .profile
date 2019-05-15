# set default variables
export PATH="$PATH:$HOME/bin"
export EDITOR="nvim"
export TERMINAL="xst"

# start i3 if not already running
# [ "$(tty)" = "/dev/tty1" ] && ! pgrep -x i3 >/dev/null && exec startx

# virtualenvwrapper related settings
export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/projects
export VIRTUALENVWRAPPER_SCRIPT=$(which virtualenvwrapper.sh)
source $(which virtualenvwrapper_lazy.sh)
