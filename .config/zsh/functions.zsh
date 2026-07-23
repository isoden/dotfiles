# ディレクトリ移動時に ls を実行
function chpwd() {
  ls -lh
}

# ターミナルタイトルを更新
precmd() {
  print -Pn '\e]0;%n@%m: %~\a'
}

function up() {
  mise bootstrap packages upgrade
}

function beep() {
  afplay /System/Library/Sounds/Ping.aiff
}
