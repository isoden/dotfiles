# ディレクトリ移動時に ls を実行
function chpwd() {
  ls -lh
}

# ターミナルタイトルを更新
precmd() {
  print -Pn '\e]0;%n@%m: %~\a'
}

function up() {
  (cd "$ZDOTREPO" && mise bootstrap packages upgrade)
}

function beep() {
  afplay /System/Library/Sounds/Ping.aiff
}

# 親ディレクトリが存在しない深い階層でも touch できるようにする
function touchp() {
  mkdir -p "${1:h}" && touch "$1"
}
