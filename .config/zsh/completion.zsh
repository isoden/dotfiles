# zsh-abbr は Homebrew 非依存 (manual-tools/sync.sh) で $ZSH_ABBR_DIR に clone する。
# abbr.zsh でも参照するためここで定義する。
typeset -g ZSH_ABBR_DIR="$HOME/.local/share/zsh-abbr"

# zsh-abbr の補完も同じ fpath にまとめ、compinit は一度だけ呼ぶ。
# 二重に compinit すると片方が insecure directories 警告を出すことがある。
fpath=(
  /opt/homebrew/share/zsh/site-functions
  $ZSH_ABBR_DIR/completions
  $fpath
)

autoload -Uz compinit
compinit

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
