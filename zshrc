function safe_source() { [ -f  "$1" ] && source "$1" }

# function safe_export_path() { [[ -d $1 ]] && export PATH=$1:$PATH }
function safe_add_fpath() { [[ -d "$1" ]] && fpath=("$1" $fpath) }  # NOTE: don't quote fpath here
function safe_export_path() {
    if [[ -d "$1" ]]; then
        if [[ ":$PATH:" == *":$1:"* ]]; then
            echo "$1 already exists in PATH"
        else
            export PATH="$1:$PATH"
        fi
    fi
}

# export zsh is important
export ZSH="$HOME/.oh-my-zsh"
export TERM=xterm-256color

ZSH_THEME="candy"

plugins=(
    fzf-tab
    git
    autojump
    zsh-autosuggestions
    zsh-syntax-highlighting
    docker
    docker-compose
    pyenv
)

# alias and self defined function
safe_export_path $HOME/.local/bin >/dev/null
safe_source $ZSH/oh-my-zsh.sh
for file in $HOME/.zsh/*.zsh; do
    source $file
done

safe_add_fpath "$HOME/.zsh/Completion"

safe_source "$HOME"/.fzf.zsh
