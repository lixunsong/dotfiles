#!/bin/sh

export DOTFILES=$HOME/dotfiles
export EMACSD=$HOME/.emacs.d

# Get OS information
OS=`uname -s`
OSREV=`uname -r`
OSARCH=`uname -m`

# Define colors
if command -v tput >/dev/null 2>&1; then
    ncolors=$(tput colors)
fi
if [ -t 1 ] && [ -n "$ncolors" ] && [ "$ncolors" -ge 8 ]; then
    RED="$(tput setaf 1)"
    GREEN="$(tput setaf 2)"
    YELLOW="$(tput setaf 3)"
    BLUE="$(tput setaf 4)"
    BOLD="$(tput bold)"
    NORMAL="$(tput sgr0)"
else
    RED=""
    GREEN=""
    YELLOW=""
    BLUE=""
    BOLD=""
    NORMAL=""
fi

# Functions
is_mac()
{
    [ "$OS" = "Darwin" ]
}

is_cygwin()
{
    [ "$OSTYPE" = "cygwin" ]
}

is_linux()
{
    [ "$OS" = "Linux" ]
}

is_debian() {
    command -v apt-get >/dev/null 2>&1
}

is_arch() {
    command -v pacman >/dev/null 2>&1
}

install_package() {
    if ! command -v ${1} >/dev/null 2>&1; then
        if is_mac; then
            brew -q install ${1}
        elif is_debian; then
            sudo apt-get install -y ${1}
        elif is_arch; then
            pacman -Ssu --noconfirm ${1}
        elif is_cygwin; then
            apt-cyg install -y ${1}
        fi
    else
        if is_mac; then
            brew upgrade -q ${1}
        elif is_debian; then
            sudo apt-get upgrade -y ${1}
        elif is_arch; then
            pacman -Ssu --noconfirm ${1}
        elif is_cygwin; then
            apt-cyg upgrade -y ${1}
        fi
    fi
}

clean_dotfiles() {
    confs="
    .zshrc
    .zshrc.local
    .zsh
    .oh-my-zsh
    "
    for c in ${confs}; do
        [ -f $HOME/${c} ] && mv $HOME/${c} $HOME/${c}.bak
    done

    rm -rf $HOME/.zsh
    rm -rf $HOME/.oh-my-zsh
    rm -f .zshrc
}

prepare_zsh()
{
    # Check zsh
    if ! command -v zsh >/dev/null 2>&1; then
        printf "${GREEN}▓▒░ Installing zsh...${NORMAL}\n"
        install_package zsh
    fi

    printf "${GREEN}▓▒░ Installing oh-my-zsh...${NORMAL}\n"
    install_ohmyzsh

    cp  $DOTFILES/zshrc $HOME/.zshrc
    cp -r $DOTFILES/zsh $HOME/.zsh

    . $HOME/.zshrc
}

prepare_tmux(){
    if ! command -v tmux >/dev/null 2>&1; then
        printf "${GREEN}▓▒░ Installing tmux...${NORMAL}\n"
        install_package tmux
    fi
    cp $DOTFILES/tmux.conf $HOME/.tmux.conf
}

install_ohmyzsh()
{
    sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    # plugins
    printf "${GREEN}▓▒░ Installing zsh plugins...${NORMAL}\n"
    install_zsh_autojump
    install_zsh_autosuggest
    install_zsh_syntax_highlight
    install_zsh_fzf_tab
}

install_zsh_autojump()
{
    local autojump_path="$ZSH_CUSTOM/plugins/autojump"
    if [ -d "$autojump_path" ]; then
        echo "autojump already installed"
    else
        git clone https://github.com/wting/autojump.git $autojump_path
        cd $autojump_path
        ./install.py
    fi
}

install_zsh_autosuggest()
{
    local auto_suggest_path="$ZSH_CUSTOM/plugins/zsh-autosuggestions"
    if [ -d "$auto_suggest_path" ]; then
        echo "zsh-autosuggestions already installed"
    else
        git clone https://github.com/zsh-users/zsh-autosuggestions.git $auto_suggest_path
    fi
}

install_zsh_syntax_highlight()
{
    local syntax_highlight_path="$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
    if [ -d "$syntax_highlight_path" ]; then
        echo "zsh-syntax-highlighting already installed"
    else
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $syntax_highlight_path
    fi
}

install_zsh_fzf_tab()
{
    local fzf_tab_path="${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fzf-tab"
    if [ -d "$fzf_tab_path" ]; then
        echo "fzf-tab already installed"
    else
        git clone https://github.com/Aloxaf/fzf-tab  $fzf_tab_path
    fi
}

install_fzf()
{
    if [ -d "$HOME/.fzf" ]; then
        echo "fzf already installed"
    else
        git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
        $HOME/.fzf/install
    fi
}

install_all(){
    prepare_tmux
    prepare_zsh
}

update_conf(){
    cp $DOTFILES/tmux.conf $HOME/tmux.conf
    if [ -d $HOME/.zsh ]; then
        echo "remove ~/.zsh dir"
        rm -rf $HOME/.zsh
    fi
    cp zshrc $HOME/.zshrc
    cp -r zsh $HOME/.zsh
    if ! [ -f "$HOME/.zsh.local" ]; then
        echo "update zsh.local, for local usage"
        cp zsh.local $HOME/.zsh.local
    fi
    echo "update configure of zsh & tmux done"
}
