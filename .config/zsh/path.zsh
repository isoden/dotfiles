# path/fpath の重複エントリを自動排除する（brew shellenv とシステム設定で
# 同じディレクトリが複数回入るため）。以降の PATH/fpath 追加すべてに効く。
typeset -U path fpath

# 全マシン共通の PATH。PC 固有のパスは ~/.zshrc.local に置く。
export PATH="$HOME/.local/bin:$PATH"

# Homebrew: PATH/MANPATH/INFOPATH を設定する。
# 2026-07-24: brew 本体（/opt/homebrew/bin/brew・Library/Homebrew）はアンインストール済み。
# パッケージ管理は mise bootstrap packages（`[bootstrap.packages]` の brew: backend。
# 実物の Homebrew CLI に依存せず、/opt/homebrew の prefix 構造だけを使う mise 独自実装）
# に移行済みのため、`brew shellenv` を呼ばず同等の PATH 前置を静的に行う。
export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"
export MANPATH="/opt/homebrew/share/man:${MANPATH:-}"
export INFOPATH="/opt/homebrew/share/info:${INFOPATH:-}"
