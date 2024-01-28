# git config
function gitshortlogcmd () {
      git log --date=short --decorate --graph "$@"
}
function gitlogcmd () {
      git log --date=short --decorate --graph --pretty=format:'%C(yellow)%h%Creset%C(green)%d%Creset %ad %s %Cred(%an)%Creset' "$@"
}

alias g="git status --short -b"
alias gb="git branch"
alias ga="git add"
alias gc="git commit -m"
alias gca="git commit --amend"
alias gja="git --no-pager commit --amend --reuse-message=HEAD" # git just amend
alias gss="git show --stat"
alias gsl="git log --pretty=format:'%h %s (%an)' --date=short -n1 | fzf"
alias gl="gitlogcmd"
alias glp="gitlogcmd -p"
alias gls="gitlogcmd --stat"
alias gdf="git-fuzzy-diff"

# switch branch with diff preview
alias gcb="git branch --all | grep -v '^[*+]' | awk '{print $1}' | fzf -0 --preview 'git show --color=always {-1}' | sed 's/remotes\\/origin\\///g' | xargs -r git checkout"
# add file with diff preview
alias addm="git ls-files --deleted --modified --other --exclude-standard | fzf -0 -m --preview 'git diff --color=always {-1}' | xargs -r git add"