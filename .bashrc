# ~/.bashrc: executed by bash(1) for non-login shells.

if command -v brew >/dev/null; then
  if [[ -r "$(brew --prefix)/etc/bash_completion.d/git-completion.bash" ]]; then
    . "$(brew --prefix)/etc/bash_completion.d/git-completion.bash"
    # `alias g="git"` でも補完されるようにする
    __git_complete g __git_main
  fi
fi

# If not running interactively, don't do anything
case $- in
  *i*) ;;
    *) return;;
esac

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
  xterm-color|*-256color) color_prompt=yes;;
esac

_branchName() {
  branch=$(git symbolic-ref --short HEAD 2> /dev/null)

  [[ $branch != "" ]] && echo "($branch)"
}

PS1='\[\033[01;34m\]\w\[\033[00m\] \[\033[01;33m\]$(_branchName "%s")\[\033[00m\]\n ❯ '

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
  PS1="\[\e]0;\u@\h: \w\a\]$PS1"
  ;;
*)
  ;;
esac

# enable color support of ls and also add handy aliases
export CLICOLOR=1
alias grep='grep --color=auto'

# brew を最新にする
pkgupgrade() {
  brew update && brew upgrade && brew cleanup && brew doctor
}

# https://qiita.com/uplus_e10/items/c58ab78e062218dc4eda
_cd_hook() {
  [[ ${AUTOLS_DIR:-$PWD} != $PWD ]] && ls
  AUTOLS_DIR="${PWD}"
}

HISTCONTROL=ignoreboth
HISTSIZE=1000
HISTFILESIZE=2000

shopt -s cdspell
shopt -s histappend
shopt -s checkwinsize

# autocd と globstar は bash 4.0 以降。macOS 標準の /bin/bash は 3.2 なので
# Homebrew の bash で起動したときだけ有効にする。
if [ "${BASH_VERSINFO[0]}" -ge 4 ]; then
  shopt -s autocd
  shopt -s globstar
fi

export PROMPT_COMMAND="_cd_hook"

# https://github.com/direnv/direnv/blob/master/docs/hook.md#bash
eval "$(direnv hook bash)"
eval "$(mise activate bash)"
