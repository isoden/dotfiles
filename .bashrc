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

# git-prompt.sh の読み込み
if [ -f /usr/local/etc/bash_completion.d/git-prompt.sh ]; then
  source /usr/local/etc/bash_completion.d/git-prompt.sh
fi

# git-completion.bash の読み込み
if [ -f /usr/local/etc/bash_completion.d/git-completion.bash ]; then
  source /usr/local/etc/bash_completion.d/git-completion.bash
fi

# プロンプトに表示させる Git の情報の設定
# unstaged files があるときに * を表示する
# staged files があるときに + を表示する
GIT_PS1_SHOWDIRTYSTATE=true

# untracked files があるときに % を表示する
GIT_PS1_SHOWUNTRACKEDFILES=true

# stashed files があるときに $ を表示する
GIT_PS1_SHOWSTASHSTATE=true

# カレントブランチが upstream より進んでいる時に > 、遅れている時に < 、
# 遅れておりかつ独自の変更がある場合には <> を表示する
GIT_PS1_SHOWUPSTREAM=auto

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

function promps {
  local BLUE="\[\e[1;34m\]"
  local GREEN="\[\e[1;32m\]"
  local WHITE="\[\e[00m\]"
  local BASE="\u@\h"

  PS1="${GREEN}${BASE}${WHITE}:${BLUE}\w${GREEN}\$(__git_ps1)${BLUE}\$${WHITE} "
}

promps

# ディレクトリ名のみの入力でcdできるようにする
shopt -s autocd

# ワイルドカードが使われた時サブディレクトリ、ファイル全てに再帰的にマッチする
shopt -s globstar

# cd の引数にスペルミスがあった時によしなにしてくれる
shopt -s cdspell

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
