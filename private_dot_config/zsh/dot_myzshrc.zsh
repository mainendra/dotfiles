################ Alias ################

# Switch terminal architecture type:
alias x86="$env /usr/bin/arch -x86_64 /bin/zsh ---login"
alias arm="$env /usr/bin/arch -arm64 /bin/zsh ---login"

# mac
alias gtb="git commit --allow-empty -m 'Trigger build'"

# alias ip="ifconfig | ack \"inet ([0-9]+.[0-9]+.[0-9]+.[0-9]+)\" --output \"$1\""
alias ip="ifconfig | ack 'inet ([0-9]+.[0-9]+.[0-9]+.[0-9]+)' --output '\$1'"
alias gip="http https://ipecho.io/plain -p b"

alias ta="tmux a"
alias tk="tmux kill-server"
alias tc="tmux capture-pane -pS - -E - | nvim -"
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
alias l='eza --color=auto --icons -l'
alias la='l -la'
alias ll='l -lah'

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

# pi
if command -v xh > /dev/null 2>&1; then # on pi
    alias http='xh'
fi

################ Utils functions ################

# proxy
enable-proxy() {
    networksetup -setsecurewebproxy Wi-Fi 127.0.0.1 $1
    networksetup -setwebproxy Wi-Fi 127.0.0.1 $1
}
alias disable-proxy="networksetup -setsecurewebproxystate Wi-Fi off && networksetup -setwebproxystate Wi-Fi off"

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

# resend key for pop
email() {
    if [[ -z $RESEND_API_KEY ]]; then
        export RESEND_API_KEY=$(pass RESEND_API_KEY)
    fi
    pop "$@"
}
