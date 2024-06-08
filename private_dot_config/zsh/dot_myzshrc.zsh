# thinker fix
# export PATH="/usr/local/opt/tcl-tk/bin:$PATH"
# export LDFLAGS="-L/usr/local/opt/tcl-tk/lib"
# export CPPFLAGS="-I/usr/local/opt/tcl-tk/include"
# export PKG_CONFIG_PATH="/usr/local/opt/tcl-tk/lib/pkgconfig"

# In ZSH $PATH is tied to $path array

# Add tizen sdk to path
path+=($HOME/tizen-studio/tools/)
path+=($HOME/tizen-studio/tools/ide/bin)

# Android studio
if [ -d "$HOME/Library/Android/sdk/platform-tools" ]; then
    path+=($HOME/Library/Android/sdk/platform-tools)
elif [ -d "$HOME/platform-tools" ]; then
    path+=($HOME/platform-tools)
fi

# layzygit config dir
export CONFIG_DIR="$HOME/.config/lazygit"

# rg config
export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"

# FZF config
# export FZF_DEFAULT_COMMAND="fd --hidden --follow --exclude '.git' --exclude 'node_modules'"
# export FZF_DEFAULT_OPTS="--height 50% --layout=reverse --border --preview 'head -100 {}' --bind 'ctrl-e:execute(echo {+} | xargs -o nvim)' --bind 'ctrl-y:execute-silent(echo {+} | pbcopy)'"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# Set up fzf key bindings and fuzzy completion
eval "$(fzf --zsh)"

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

# mac
enable-proxy() {
    networksetup -setsecurewebproxy Wi-Fi 127.0.0.1 $1
    networksetup -setwebproxy Wi-Fi 127.0.0.1 $1
}
alias disable-proxy="networksetup -setsecurewebproxystate Wi-Fi off && networksetup -setwebproxystate Wi-Fi off"

alias gtb="git commit --allow-empty -m 'Trigger build'"

# alias ip="ifconfig | ack \"inet ([0-9]+.[0-9]+.[0-9]+.[0-9]+)\" --output \"$1\""
alias ip="ifconfig | ack 'inet ([0-9]+.[0-9]+.[0-9]+.[0-9]+)' --output '\$1'"
alias gip="http https://ipecho.io/plain -p b"

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
alias fastping='ping -c 100 -s 2'

# get web server headers #
alias header='curl -I'

# find out if remote server supports gzip / mod_deflate or not #
alias headerc='curl -I --compress'

# default utils
if command -v batcat > /dev/null 2>&1; then # on pi
    alias bat='batcat'
fi
alias cat='bat --style=plain'
alias l='eza'
alias la='eza -la --icons'
alias ll='eza -lah --icons'
alias ls='eza --color=auto --icons'

# Chrome
alias chrome="/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome"
alias chrome-canary="/Applications/Google\ Chrome\ Canary.app/Contents/MacOS/Google\ Chrome\ Canary"
# bookmark manager
alias cb='chrome $(buku -p -f 10 | fzf)'
# chrome with security disabled
alias chrome-ds='open -na Google\ Chrome --args --user-data-dir=/tmp/temporary-chrome-profile-dir --disable-web-security --disable-site-isolation-trials'

alias venv='python -m venv ./venv && echo "layout_python3" > .envrc && direnv allow'
alias pipreq='pip freeze > requirements.txt'

# VLC video player (mac)
alias vlc='/Applications/VLC.app/Contents/MacOS/VLC'

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

# brew auto update
export HOMEBREW_AUTO_UPDATE_SECS="86400"

# openjdk
export PATH="/usr/local/opt/openjdk/bin:$PATH"
export CPPFLAGS="-I/usr/local/opt/openjdk/include"

[ -f $HOME/.config/broot/launcher/bash/br ] && source $HOME/.config/broot/launcher/bash/br

# asdf version manager
[ -f ~/.asdf/asdf.sh ] && . "$HOME/.asdf/asdf.sh"
[ -f $(brew --prefix asdf)/libexec/asdf.sh ] && . "$(brew --prefix asdf)/libexec/asdf.sh"

# pi
if command -v xh > /dev/null 2>&1; then # on pi
    alias http='xh'
fi

# bob (nvim version manager)
export PATH="$HOME/.local/share/bob/nvim-bin:$PATH"
# bob completions
fpath+=~/.zfunc

# resend key for pop
email() {
    if [[ -z $RESEND_API_KEY ]]; then
        export RESEND_API_KEY=$(pass RESEND_API_KEY)
    fi
    pop "$@"
}

# force path to have unique values
typeset -aU path
