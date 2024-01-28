# dotfiles

## Usage

For first time running:
```shell
source ~/dotfiles/install.sh
install_all
```

Update config. You can edit configs (e.g zshrc, tmux.conf) in the dotfiles directory, and then run the command:

```shell
update_conf
```

## Features

- Automatically install and configure everything.
- zsh enhanced with oh-my-zsh, supporting fzf-tab, autosuggestions etc.
- More friendly tmux appearance and keys.
- Featured git aliases, for using git in cmd easily.

## Acknowledgement

This project is built upon following repos and articles:
 
- [FateScript's dotfiles](https://github.com/FateScript/dotfiles)
- [seagle0128's dotfiles](https://github.com/seagle0128/dotfiles/tree/master)
- [Managing your dotfiles](https://effective-shell.com/part-5-building-your-toolkit/managing-your-dotfiles/)