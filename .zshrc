# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/home/iynaix/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="spaceship"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# stop auto correcting . directories
CORRECT_IGNORE_FILE='.*'

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(vi-mode git history-substring-search dotenv colorize virtualenvwrapper archlinux cp ripgrep command-not-found colored-man-pages yarn npm)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# setup broot
# source /home/iynaix/.config/broot/launcher/bash/br

##################################################
# SETUP FZF
##################################################

if [ -f /etc/profile.d/fzf.zsh ]; then
    source /etc/profile.d/fzf.zsh
    export FZF_DEFAULT_COMMAND='rg --files'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_DEFAULT_OPTS='--height 40% --reverse --border --select-1 --exit-0'
fi

# load shortcut aliases
[ -f "$HOME/.shortcutrc" ] && source "$HOME/.shortcutrc"

##################################################
# ALIASES
##################################################
alias :e="nvim"
alias :q="exit"
alias :sp="bspc node -p south; $TERMINAL & disown"
alias :vs="bspc node -p east; $TERMINAL & disown"
alias c="clear"
alias cal="cal -3"
alias calc='ipy -i -c "from math import *"'
alias clearq="rm -rf /tmp/q"
alias du="dust"
alias f="fab"
alias gotop="gotop -p"
alias nvim=nvim
alias nvimdiff=nvim -d
alias ipy="ipython3"
alias ifconfig-ext='curl ifconfig.me/all'
alias ipynb="ipy notebook"
alias isodate='date -u +"%Y-%m-%dT%H:%M:%SZ"'
alias ll="ls -al"
alias lns="ln -s"
alias ls="exa --group-directories-first --color-scale --icons"
alias mergeclean="find . -type f -name '*.orig' -exec rm -f {} \;"
alias open='xdg-open'
alias pj="openproj"
alias py='python'
alias r="ranger"
alias showq="touch /tmp/q && tail -f /tmp/q"
alias stopemacs="pkill -SIGUSR2 emacs"
alias subs="subliminal download -l 'en' -l 'eng' -s"
alias todo="rg TODO"
alias tree="exa --group-directories-first --color-scale --icons --tree"
alias v=nvim
alias vi=nvim
alias vim=nvim
alias wget='wget --content-disposition'
alias whereami='echo "$( hostname --fqdn ) ($(hostname -i)):$( pwd )"'
alias xclip="xclip -selection c"
alias y="yay"
alias yn="yarn"
alias yt="youtube-dl"
alias yta="yt --audio-format mp3 --extract-audio"
alias yts="yt --write-auto-sub --sub-lang='en,eng' --convert-subs srt --embed-subs"
alias coinfc="openproj coinfc"
alias coinfc-backend="openproj coinfc-backend"
alias coinfcweb="tmuxp load ~/.tmuxp/coinfcweb.yml"
alias coinfcnative="tmuxp load ~/.tmuxp/coinfcnative.yml"

#shut zsh up
alias eslint="nocorrect eslint"
alias gulp="nocorrect gulp"
alias netlify="nocorrect netlify"
alias yarn="nocorrect yarn"

#git stuff
alias gaa="git add --all"
alias gbr="git bisect reset"
alias gcaam="gaa && gcam"
alias gcam="git commit --amend"
alias gdc="git diff --cached"
alias gdi="git diff"
alias gl="git pull"
alias glc='gl origin "$( git rev-parse --abbrev-ref HEAD )"'
alias gpc='gp origin "$( git rev-parse --abbrev-ref HEAD )"'
alias groot='cd $(git rev-parse --show-toplevel)'
alias grh='git reset --hard'
alias gri='git rebase --interactive'
alias gst="git status -s -b && echo && git log | head -n 1"
alias gsub="git submodule update --init --recursive"
# access github page for the repo we are currently in
alias github="open \`git remote -v | grep github.com | grep fetch | head -1 | awk '{print $2}' | sed 's/git:/http:/git'\`"

alias gf="git flow"
alias gff="gf feature"
alias gffco="gff checkout"
alias gfh="gf hotfix"
alias gfr="gf release"
alias gfs="gf support"

# use vim keys in tab completion menu
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'left' vi-backward-char
bindkey -M menuselect 'down' vi-down-line-or-history
bindkey -M menuselect 'up' vi-up-line-or-history
bindkey -M menuselect 'right' vi-forward-char

# don't nag about .env files
ZSH_DOTENV_PROMPT=false

##################################################
# PROMPT SETTINGS
##################################################

# Change cursor with support for inside/outside tmux
function _set_cursor() {
    if [[ $TMUX = '' ]]; then
      echo -ne $1
    else
      echo -ne "\ePtmux;\e\e$1\e\\"
    fi
}

function _set_block_cursor() { _set_cursor '\e[2 q' }
function _set_beam_cursor() { _set_cursor '\e[6 q' }

function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] || [[ $1 = 'block' ]]; then
      _set_block_cursor
  else
      _set_beam_cursor
  fi
}
zle -N zle-keymap-select

# ensure beam cursor when starting new terminal
precmd_functions+=(_set_beam_cursor)

SPACESHIP_PROMPT_SEPARATE_LINE=false
SPACESHIP_CHAR_SYMBOL=❯
SPACESHIP_CHAR_SUFFIX=" "
SPACESHIP_PACKAGE_SHOW=false
SPACESHIP_NODE_SHOW=false
SPACESHIP_RUBY_SHOW=false
SPACESHIP_ELM_SHOW=false
SPACESHIP_ELIXIR_SHOW=false
SPACESHIP_XCODE_SHOW_LOCAL=false
SPACESHIP_SWIFT_SHOW_LOCAL=false
SPACESHIP_GOLANG_SHOW=false
SPACESHIP_PHP_SHOW=false
SPACESHIP_RUST_SHOW=false
SPACESHIP_JULIA_SHOW=false
SPACESHIP_DOCKER_SHOW=false
SPACESHIP_DOCKER_CONTEXT_SHOW=false
SPACESHIP_AWS_SHOW=false
SPACESHIP_CONDA_SHOW=false
SPACESHIP_DOTNET_SHOW=false
SPACESHIP_EMBER_SHOW=false
SPACESHIP_KUBECONTEXT_SHOW=false
SPACESHIP_TERRAFORM_SHOW=false
SPACESHIP_TERRAFORM_SHOW=false
SPACESHIP_VI_MODE_SHOW=false

##################################################
# FUNCTION ALIASES
##################################################

#Suppress output of loud commands you don't want to hear from
#http://www.commandlinefu.com/commands/view/9390/suppress-output-of-loud-commands-you-dont-want-to-hear-from
q() { "$@" > /dev/null 2>&1; }

# system update with autoremove
upd8() {
    yay -Syyu && sudo pacman -Rs $(pacman -Qdtq)
}

# checkout and pull and merge gitflow branch
gffp() {
    gffco $1 && gp
}

# delete a remote branch
grd() {
    gb -D $1
    gp origin --delete $1
}

# delete a remote feature branch
gffrd() {
    gb -D feature/$1
    gp origin --delete feature/$1
}

# find and use manage.py
dj() {
    # coinfc directory no longer matches coinfc-backend
    if [[ -a "coinfc/manage.py" ]] then
       python "coinfc/manage.py" $*
    elif [[ -a "${PWD##*/}/manage.py" ]] then
        python "${PWD##*/}/manage.py" $*
    elif [[ -a "manage.py" ]] then
        python manage.py $*
    else
        return 1 # not found, error out
    fi
}

_dj() {
    declare target_list
    target_list=(`dj -h | sed -nr 's/^\s+(\w+)$/\1/p' | sort -u`)
    _describe -t commands "management commands" target_list
}
compdef _dj dj

# opens the image after it has been generated as well
djgraph() {
    dj graph_models -a -o $* && open $*[-1]
}

# shell or shell_plus
djsp() {
    dj shell_plus --quiet-load $*
    if [[ $? -ne 0 ]]; then
        dj shell $*
    fi
}

# shell_plus in ipython notebook
djspnb() {
    dj shell_plus --notebook
}

# runs the django devserver so that it is accessible on LAN
djls() {
    echo "Django web server can be accessed via http://`ifconfig | perl -nle'/dr:(\S+)/ && print $1' | head -1`:8001/"

    dj runserver_plus 0.0.0.0:8001 $*
    if [[ $? -ne 0 ]]; then
        dj runserver 0.0.0.0:8001 $*
    fi
}

# less verbose xev output with only the relevant parts
keys() {
    xev | awk -F'[ )]+' '/^KeyPress/ { a[NR+2] } NR in a { printf "%-3s %s\n", $5, $8 }'
}

# server command, runs a local server
# tries running a django runserver_plus, falling back to runserver, then falling back to SimpleHttpServer
server() {
    # is this django?
    dj runserver_plus $*
    if [[ $? -ne 0 ]]; then
        dj runserver $*
        if [[ $? -ne 0 ]]; then
            python3 -m http.server ${1:-8000}
        fi
    fi
}

# searches git history, can never remember this stupid thing
gsearch() {
    # 2nd argument is target path and subsequent arguments are passed thru
    glg -S$1 -- ${2:-.} $*[2,-1]
}

# cd to project dir and open the virtualenv if it exists
openproj () {
    cd ~/projects/
    if [[ $# -eq 1 ]]; then
        cd $1
    fi
}
_openproj() {
    _files -/ -W '/home/iynaix/projects/'
}
compdef _openproj openproj

# cd to repo dir
openrepo () {
    cd ~/repos/
    if [[ $# -eq 1 ]]; then
        cd $1
    fi
}
_openrepo() {
    _files -/ -W '/home/iynaix/repos/'
}
compdef _openrepo openrepo

rezshrc() {
    . ~/.zshrc # reload .zshrc
    # refresh the virtualenv if we are in one
    if [ -d 'env' ]; then
        q source env/bin/activate
    fi
}

# autocompletion for fabric, stolen from:
# https://github.com/kennethreitz/fabric-zsh-completion/blob/master/fab-completion.zsh
_fab_list() {
    declare target_list
    target_list=($(fab --list-format=short --list | sort -u))
    _describe -t commands "fabric commands" target_list
}
compdef _fab_list fab

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
