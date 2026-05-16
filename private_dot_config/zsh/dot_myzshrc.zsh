# ─── Navigation ────────────────────────────────────────────────────────────────

alias cd..='cd ..'
alias ..='cd ..'
alias ...='cd ../../../'
alias ....='cd ../../../../'
alias .5='cd ../../../../..'

# ─── Git ──────────────────────────────────────────────────────────────────────

alias gtb="git commit --allow-empty -m 'Trigger build'"

# ─── Tmux ─────────────────────────────────────────────────────────────────────

alias ta="tmux a"
alias tk="tmux kill-server"
alias tc="tmux capture-pane -pS - -E - | nvim -"

# ─── Tools ────────────────────────────────────────────────────────────────────

alias lg="lazygit"
alias ld="lazydocker"
alias br="broot"
alias pn="pnpm"
alias nfzf='nvim $(fzf)'
alias vlc='/Applications/VLC.app/Contents/MacOS/VLC'

# ─── Better defaults ─────────────────────────────────────────────────────────

if command -v xh > /dev/null 2>&1; then
    alias http='xh'
fi
alias cat='bat --style=plain'
alias l='eza --color=auto --icons -l'
alias la='l -la'
alias ll='l -lah'
alias bc='bc -l'
alias ping='ping -c 5'
alias fastping='ping -c 100 -s 2'

# ─── Networking ───────────────────────────────────────────────────────────────

if [ "$(command -v ifconfig)" ]; then
    alias ip="ifconfig | ack 'inet ([0-9]+.[0-9]+.[0-9]+.[0-9]+)' --output '\$1'"
elif [ "$(command -v ip)" ]; then
    alias ip="ip address | ack 'inet ([0-9]+.[0-9]+.[0-9]+.[0-9]+)' --output '\$1'"
fi
alias gip="http -4 https://ipecho.io/plain -p b"
alias header='curl -I'
alias headerc='curl -I --compress'

# ─── Info ─────────────────────────────────────────────────────────────────────

alias h='history'
alias j='jobs -l'
alias path='echo -e ${PATH//:/\\n}'
alias now='date +"%T"'
alias nowdate='date +"%d-%m-%Y"'

# ─── Python ───────────────────────────────────────────────────────────────────

alias venv='python -m venv ./venv && echo "layout_python3" > .envrc && direnv allow'
alias pipreq='pip freeze > requirements.txt'

# ─── Chrome ───────────────────────────────────────────────────────────────────

alias chrome="/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome"
alias chrome-canary="/Applications/Google\ Chrome\ Canary.app/Contents/MacOS/Google\ Chrome\ Canary"
alias chrome-ds='open -na Google\ Chrome --args --user-data-dir=/tmp/temporary-chrome-profile-dir --disable-web-security --disable-site-isolation-trials'

# ─── Proxy ────────────────────────────────────────────────────────────────────

function enable-proxy() {
    sudo networksetup -setsecurewebproxy Wi-Fi 127.0.0.1 $1
    sudo networksetup -setwebproxy Wi-Fi 127.0.0.1 $1
}
alias disable-proxy="sudo networksetup -setsecurewebproxystate Wi-Fi off && sudo networksetup -setwebproxystate Wi-Fi off"

# ─── Utility functions ────────────────────────────────────────────────────────

# find-in-file: usage `fif <SEARCH_TERM>`
fif() {
    if [ ! "$#" -gt 0 ]; then
        echo "Need a string to search for!"
        return 1
    fi
    rg --files-with-matches --no-messages "$1" | fzf $FZF_PREVIEW_WINDOW --preview "rg --ignore-case --pretty --context 10 '$1' {}"
}

# query cheat.sh, wttr.in, rate.sx
cheat() { http -b cheat.sh/"$1"; }
wttr()  { http -b wttr.in/"$1"; }
rate()  { http -b rate.sx/"$1"; }

# send email via resend/pop
email() {
    if [[ -z $RESEND_API_KEY ]]; then
        export RESEND_API_KEY=$(pass RESEND_API_KEY)
    fi
    pop "$@"
}
