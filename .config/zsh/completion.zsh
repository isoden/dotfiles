# zsh-abbr の補完も同じ fpath にまとめ、compinit は一度だけ呼ぶ。
# 二重に compinit すると片方が insecure directories 警告を出すことがある。
fpath=(
  /opt/homebrew/share/zsh/site-functions
  /opt/homebrew/share/zsh-abbr
  $fpath
)

autoload -Uz compinit
compinit

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
