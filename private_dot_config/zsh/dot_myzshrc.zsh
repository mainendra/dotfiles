# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:/usr/local/sbin:$PATH

# thinker fix
# export PATH="/usr/local/opt/tcl-tk/bin:$PATH"
# export LDFLAGS="-L/usr/local/opt/tcl-tk/lib"
# export CPPFLAGS="-I/usr/local/opt/tcl-tk/include"
# export PKG_CONFIG_PATH="/usr/local/opt/tcl-tk/lib/pkgconfig"

# In ZSH $PATH is tied to $path array

# pyenv - python version manager
export PYENV_ROOT="$HOME/.pyenv"
path+=($PYENV_ROOT/bin)

# Add tizen sdk to path
path+=($HOME/tizen-studio/tools/)
path+=($HOME/tizen-studio/tools/ide/bin)

# Android studio
path+=($HOME/Library/Android/sdk/platform-tools)

# local bin to path
path+=($HOME/.local/bin)

# lsp servers
# path+=($HOME/.local/share/nvim/lsp_servers)

# force path to have unique values
typeset -U path

# layzygit config dir
export CONFIG_DIR="$HOME/.config/lazygit"

# FZF config
# export FZF_DEFAULT_COMMAND="fd --hidden --follow --exclude '.git' --exclude 'node_modules'"
# export FZF_DEFAULT_OPTS="--height 50% --layout=reverse --border --preview 'head -100 {}' --bind 'ctrl-e:execute(echo {+} | xargs -o nvim)' --bind 'ctrl-y:execute-silent(echo {+} | pbcopy)'"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi
export EDITOR='nvim'

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.

enable-proxy() {
    networksetup -setsecurewebproxy Wi-Fi 127.0.0.1 $1
    networksetup -setwebproxy Wi-Fi 127.0.0.1 $1
}
alias disable-proxy="networksetup -setsecurewebproxystate Wi-Fi off && networksetup -setwebproxystate Wi-Fi off"

alias gtb="git commit --allow-empty -m 'Trigger build'"

# alias ip="ifconfig | ack \"inet ([0-9]+.[0-9]+.[0-9]+.[0-9]+)\" --output \"$1\""
alias ip="ifconfig | ack 'inet ([0-9]+.[0-9]+.[0-9]+.[0-9]+)' --output '\$1'"
alias gip="http ipecho.net/plain -p b"

alias ta="tmux a"
alias tk="tmux kill-server"
alias lg="lazygit"
alias ld="lazydocker"
alias gu="gitui"
alias br="broot"

## get rid of command not found ##
alias cd..='cd ..'

## a quick way to get out of current directory ##
alias ..='cd ..'
alias ...='cd ../../../'
alias ....='cd ../../../../'
alias .....='cd ../../../../'
alias .4='cd ../../../../'
alias .5='cd ../../../../..'

# calculator with bash support
alias bc='bc -l'

# handy short cuts #
alias h='history'
alias j='jobs -l'

# date time
alias path='echo -e ${PATH//:/\\n}'
alias now='date +"%T"'
alias nowtime=now
alias nowdate='date +"%d-%m-%Y"'

# Stop after sending count ECHO_REQUEST packets #
alias ping='ping -c 5'
# Do not wait interval 1 second, go fast #
alias fastping='ping -c 100 -s.2'

# get web server headers #
alias header='curl -I'

# find out if remote server supports gzip / mod_deflate or not #
alias headerc='curl -I --compress'

# default utils
alias cat='bat --style=plain'
alias l='exa'
alias la='exa -la'
alias ll='exa -lah'
alias ls='exa --color=auto'

# Chrome
alias chrome="/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome"
alias chrome-canary="/Applications/Google\ Chrome\ Canary.app/Contents/MacOS/Google\ Chrome\ Canary"

# Python3
# alias python=/usr/local/bin/python3
# alias pip=/usr/local/bin/pip3

alias venv='python -m venv ./venv && echo "layout_python3" > .envrc && direnv allow'
alias pipreq='pip freeze > requirements.txt'

# pyenv install
alias pyinstall="PYTHON_CONFIGURE_OPTS=\"--with-tcltk-includes='-I/usr/local/opt/tcl-tk/include' --with-tcltk-libs='-L/usr/local/opt/tcl-tk/lib -ltcl8.6 -ltk8.6'\" pyenv install \$1"

# bookmark manager
alias cb='chrome $(buku -p -f 10 | fzf)'

# chrome with security disabled
alias chrome-ds='open -na Google\ Chrome --args --user-data-dir=/tmp/temporary-chrome-profile-dir --disable-web-security --disable-site-isolation-trials'

# VLC video player
alias vlc='/Applications/VLC.app/Contents/MacOS/VLC'

# node link
alias npmlink='nvm exec default npm link'
alias npmunlink='nvm exec default npm unlink'

# pnpm
alias pn=pnpm

# forgit
alias gf='git forgit'

# fzf nvim
alias nfzf='nvim $(fzf)'

# Utils functions

# find-in-file - usage: fif <SEARCH_TERM>
fif() {
  if [ ! "$#" -gt 0 ]; then
    echo "Need a string to search for!";
    return 1;
  fi
  rg --files-with-matches --no-messages "$1" | fzf $FZF_PREVIEW_WINDOW --preview "rg --ignore-case --pretty --context 10 '$1' {}"
}

# Utils
cheat() {
    http -b cheat.sh/"$1"
}
wttr() {
    http -b wttr.in/"$1"
}
rate() {
    http -b rate.sx/"$1"
}

# Install or open the webpage for the selected application
# using brew cask search as input source
# and display a info quickview window for the currently marked application
install() {
    local token
    token=$(brew search --casks | fzf-tmux --query="$1" +m --preview 'brew cask info {}')

    if [ "x$token" != "x" ]
    then
        echo "(I)nstall or open the (h)omepage of $token"
        read input
        if [ $input = "i" ] || [ $input = "I" ]; then
            brew cask install $token
        fi
        if [ $input = "h" ] || [ $input = "H" ]; then
            brew cask home $token
        fi
    fi
}
# Uninstall or open the webpage for the selected application
# using brew list as input source (all brew cask installed applications)
# and display a info quickview window for the currently marked application
uninstall() {
    local token
    token=$(brew cask list | fzf-tmux --query="$1" +m --preview 'brew cask info {}')

    if [ "x$token" != "x" ]
    then
        echo "(U)ninstall or open the (h)omepage of $token"
        read input
        if [ $input = "u" ] || [ $input = "U" ]; then
            brew cask uninstall $token
        fi
        if [ $input = "h" ] || [ $token = "h" ]; then
            brew cask home $token
        fi
    fi
}

# Restart LogiMgrDaemon
restartLogi() (
    PID=$(ps -eaf | grep LogiMgrDaemon | grep -v grep | awk '{print $2}')
    if [[ "" != "$PID" ]]; then
        echo "Killing LogiMgrDaemon with PID $PID"
        kill -9 "$PID"
    fi
)

# Init python version manager (pyenv)
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

export PATH="$HOME/.deno/bin:$PATH"

# brew auto update
export HOMEBREW_AUTO_UPDATE_SECS="86400"

# openjdk
export PATH="/usr/local/opt/openjdk/bin:$PATH"
export CPPFLAGS="-I/usr/local/opt/openjdk/include"

typeset -aU path

# golang
export GOPATH=$HOME/golang
export GOROOT=/usr/local/opt/go/libexec
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:$GOROOT/bin

source $HOME/.config/broot/launcher/bash/br

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# Bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# place this after nvm initialization!
autoload -U add-zsh-hook
load-nvmrc() {
  local node_version="$(nvm version)"
  local nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$node_version" ]; then
      nvm use
    fi
  elif [ "$node_version" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}
add-zsh-hook chpwd load-nvmrc
load-nvmrc


# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
export PATH="$PNPM_HOME:$PATH"
# pnpm end
