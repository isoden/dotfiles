# ディレクトリ移動時に ls を実行
function chpwd() {
  ls -lh
}

# ターミナルタイトルを更新
precmd() {
  print -Pn '\e]0;%n@%m: %~\a'
}

function up() {
  # mise 本体を先に更新してから packages upgrade を回す。
  # bootstrap の brew backend は mise 独自実装なので、本体が古いと
  # パッケージ側の更新挙動も古いままになるため順序が重要。
  # -y は確認プロンプトを抑止する（up は非対話で一気に流す用途）。
  mise self-update -y && (cd "$ZDOTREPO" && mise bootstrap packages upgrade)
}

function beep() {
  afplay /System/Library/Sounds/Ping.aiff
}

# 親ディレクトリが存在しない深い階層でも touch できるようにする
function touchp() {
  mkdir -p "${1:h}" && touch "$1"
}
