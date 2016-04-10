# ========================================
# 環境変数
# ========================================

export PATH=/usr/local/bin:/usr/local/sbin:$PATH
export PATH=$HOME/.nodebrew/current/bin:$PATH
export PATH=$HOME/Library/Haskell/bin:$PATH
export PATH=/usr/local/go/bin:$PATH
export PATH=/opt/go/bin:$PATH
export PATH=/usr/local/heroku/bin:$PATH
export PATH=$HOME/bin:$PATH
export SHELL=/usr/local/bin/bash
export ANDROID_HOME=/usr/local/opt/android-sdk
export GOPATH=$HOME

if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

[ -f $HOME/.travis/travis.sh ] && source $HOME/.travis/travis.sh

# added by travis gem
[ -f /Users/isodayuu/.travis/travis.sh ] && source /Users/isodayuu/.travis/travis.sh

# ======================================
# alias
# ======================================
alias cd='builtin cd "$@" && ls'
alias ls='ls -F'
alias rm='rmtrash'
alias vi='vim'
alias g='git'
alias t='touch'
alias p='python -m CGIHTTPServer'
alias be='bundle exec'

function parse_git_branch {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ [\1]/'
}

function promps {
  local BLUE="\[\e[1;34m\]"
  local GREEN="\[\e[1;32m\]"
  local WHITE="\[\e[00m\]"
  local BASE="\u@\h"

  PS1="${GREEN}${BASE}${WHITE}:${BLUE}\w${GREEN}\$(parse_git_branch)${BLUE}\$${WHITE} "
}

promps

# ディレクトリ名のみの入力でcdできるようにする
shopt -s autocd

# ワイルドカードが使われた時サブディレクトリ、ファイル全てに再帰的にマッチする
shopt -s globstar

# cd の引数にスペルミスがあった時によしなにしてくれる
shopt -s cdspell

source $HOME/bin/git-completion.bash

# tmuxを自動で起動する
[[ -z "$TMUX" && ! -z "$PS1" ]] && tmux

# cd した時に ls も実行する
auto_cdls() {
  if [ "$OLDPWD" != "$PWD" ]; then
    ls
    OLDPWD="$PWD"
  fi
}

PROMPT_COMMAND="$PROMPT_COMMAND"$'\n'auto_cdls
