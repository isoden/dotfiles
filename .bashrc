# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# 使ってない説
# if [[ -r "$(brew --prefix)/etc/profile.d/bash_completion.sh" ]]; then
  # . "$(brew --prefix)/etc/profile.d/bash_completion.sh"
# fi

if [[ -r "$(brew --prefix)/etc/bash_completion.d/git-completion.bash" ]]; then
  . "$(brew --prefix)/etc/bash_completion.d/git-completion.bash"
  # `alias g="git"` でも補完されるようにする
  __git_complete g __git_main
fi

# If not running interactively, don't do anything
case $- in
  *i*) ;;
    *) return;;
esac

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

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
if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
  alias ls='ls --color=auto'
  #alias dir='dir --color=auto'
  #alias vdir='vdir --color=auto'

  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# https://zenn.dev/kaityo256/articles/open_command_on_wsl
open() {
  if [ $# != 1 ]; then
    explorer.exe .
  else
    if [ -e $1 ]; then
      cmd.exe /c start $(wslpath -w $1) 2> /dev/null
    else
      echo "open: $1 : No such file or directory"
    fi
  fi
}

# https://qiita.com/uplus_e10/items/c58ab78e062218dc4eda
_cd_hook() {
  [[ ${AUTOLS_DIR:-$PWD} != $PWD ]] && ls
  AUTOLS_DIR="${PWD}"
}

HISTCONTROL=ignoreboth
HISTSIZE=1000
HISTFILESIZE=2000

shopt -s autocd
shopt -s cdspell
shopt -s globstar
shopt -s histappend
shopt -s checkwinsize

export BROWSER="wslview"
export PROMPT_COMMAND="_cd_hook"

# https://github.com/direnv/direnv/blob/master/docs/hook.md#bash
eval "$(direnv hook bash)"
eval "$(anyenv init -)"
