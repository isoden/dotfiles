# -------------------------------------
# 環境変数
# -------------------------------------

# SSHで接続した先で日本語が使えるようにする
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# エディタ
export EDITOR=/usr/bin/vim
#eval "$(direnv hook zsh)"

# ページャ
export PAGER=/usr/local/bin/vimpager
export MANPAGER=/usr/local/bin/vimpager


# -------------------------------------
# zshのオプション
# -------------------------------------

## 補完機能の強化
autoload -U compinit
compinit

## 入力しているコマンド名が間違っている場合にもしかして：を出す。
setopt correct

# ビープを鳴らさない
setopt nobeep

## 色を使う
setopt prompt_subst

## ^Dでログアウトしない。
setopt ignoreeof

## バックグラウンドジョブが終了したらすぐに知らせる。
setopt no_tify

## 直前と同じコマンドをヒストリに追加しない
# cd setopt hist_ignore_dups

# 補完
## タブによるファイルの順番切り替えをしない
unsetopt auto_menu

# cd -[tab]で過去のディレクトリにひとっ飛びできるようにする
setopt auto_pushd

# ディレクトリ名を入力するだけでcdできるようにする
setopt auto_cd

# zsh起動時にtmuxも起動
[[ -z "$TMUX" && ! -z "$PS1" ]] && tmux

# -------------------------------------
# パス
# -------------------------------------

# 重複する要素を自動的に削除
typeset -U path cdpath fpath manpath

path=(
    $HOME/bin(N-/)
    /usr/local/bin(N-/)
    /usr/local/sbin(N-/)
    $path
)

# -------------------------------------
# プロンプト
# -------------------------------------

autoload -U promptinit; promptinit
autoload -Uz colors; colors
autoload -Uz vcs_info
autoload -Uz is-at-least

# begin VCS
zstyle ":vcs_info:*" enable git svn hg bzr
zstyle ":vcs_info:*" formats "(%s)-[%b]"
zstyle ":vcs_info:*" actionformats "(%s)-[%b|%a]"
zstyle ":vcs_info:(svn|bzr):*" branchformat "%b:r%r"
zstyle ":vcs_info:bzr:*" use-simple true

zstyle ":vcs_info:*" max-exports 6

if is-at-least 4.3.10; then
    zstyle ":vcs_info:git:*" check-for-changes true # commitしていないのをチェック
    zstyle ":vcs_info:git:*" stagedstr "<S>"
    zstyle ":vcs_info:git:*" unstagedstr "<U>"
    zstyle ":vcs_info:git:*" formats "(%b) %c%u"
    zstyle ":vcs_info:git:*" actionformats "(%s)-[%b|%a] %c%u"
fi

function vcs_prompt_info() {
    LANG=en_US.UTF-8 vcs_info
    [[ -n "$vcs_info_msg_0_" ]] && echo -n " %{$fg[yellow]%}$vcs_info_msg_0_%f"
}
# end VCS

NG=" |||O⌓O; "
OK=" ✘╹◡╹✘ "


PROMPT=""
PROMPT+="%(?.%F{green}$OK%f.%F{red}$NG%f) "
PROMPT+="%F{blue}%~%f"
PROMPT+="\$(vcs_prompt_info)"
PROMPT+="
"
PROMPT+="%% "

RPROMPT="[%*]"

# -------------------------------------
# エイリアス
# -------------------------------------

# -n 行数表示, -I バイナリファイル無視, svn関係のファイルを無視
alias grep="grep --color -n -I --exclude='*.svn-*' --exclude='entries' --exclude='*/cache/*'"

# tree
alias tree="tree -NC" # N: 文字化け対策, C:色をつける

alias ll='ls -l'
alias rm='rmtrash'
alias showdotfiles='defaults write com.apple.finder AppleShowAllFiles TRUE && killall Finder && open -a XtraFinder.app'
alias hidedotfiles='defaults write com.apple.finder AppleShowAllFiles FALSE && killall Finder && open -a XtraFinder.app'
alias be='bundle exec'
alias p='python -m SimpleHTTPServer'
alias s='php -S'
alias t='touch'
alias g='git'
alias vi='vim'
# -------------------------------------
# キーバインド
# -------------------------------------

bindkey -e

function cdup() {
   echo
   cd ..
   zle reset-prompt
}
zle -N cdup
bindkey '^K' cdup

bindkey "^R" history-incremental-search-backward

# -------------------------------------
# その他
# -------------------------------------

# cdしたあとで、自動的に ls する
function chpwd() { ls -1 }

# iTerm2のタブ名を変更する
function title {
    echo -ne "\033]0;"$*"\007"
}

# ディレクトリ移動と作成を同時に実行
function mkcd() {
    mkdir $1 && cd $1
}

# isoden/site-boilerplate から雛形を作成
function scaffold() {
    git clone git@github.com:isoden/site-boilerplate.git $1
    cd $1
    rm -rf .git
}

# isoden/javascript-boilerplate からJSプラグインのひな形を作成
function js() {
    git clone git@github.com:isoden/javascript-boilerplate.git $1
    cd $1
    rm -rf .git
}

# .gitignoreを作成 https://www.gitignore.io/docs
function gi() { curl -L -s https://www.gitignore.io/api/$@ ;}

# 各pathを通す
export PATH=/usr/local/bin:/usr/local/sbin:$PATH
export PATH=$HOME/.nodebrew/current/bin:$PATH
export PATH=${PATH}:/usr/pgsql-9.2/bin
export PATH=$HOME/.node_modules:$PATH
export SHELL=/usr/local/bin/zsh

if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi
export GOPATH=$HOME/.go

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
