(xterm-mouse-mode 1)
(ws-butler-mode -1)

(counsel-load-theme-action "gruvbox")

(require 'clipetty)
(global-clipetty-mode 1)
(global-set-key (kbd "M-w") #'clipetty-kill-ring-save)
(setq clipetty-tmux-ssh-tty "tmux show-environment SSH_TTY")