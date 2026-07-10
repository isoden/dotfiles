# ディレクトリ移動時に ls を実行
function chpwd() {
  ls -lh
}

# ターミナルタイトルを更新
precmd() {
  print -Pn '\e]0;%n@%m: %~\a'
}

function up() {
  brew update && brew upgrade && brew cleanup && brew doctor
}

function beep() {
  afplay /System/Library/Sounds/Ping.aiff
}
