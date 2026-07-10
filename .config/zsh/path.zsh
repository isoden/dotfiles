# path/fpath の重複エントリを自動排除する（brew shellenv とシステム設定で
# 同じディレクトリが複数回入るため）。以降の PATH/fpath 追加すべてに効く。
typeset -U path fpath

# 全マシン共通の PATH。PC 固有のパスは ~/.zshrc.local に置く。
export PATH="$HOME/.local/bin:$PATH"

# Homebrew: PATH/MANPATH/INFOPATH と HOMEBREW_* 環境変数を設定する。
# shellenv は /opt/homebrew/bin を PATH 先頭へ前置するので、Homebrew 版コマンドが
# system 版より優先される（例: git は /usr/bin/git ではなく Homebrew 版が使われる）。
eval "$(/opt/homebrew/bin/brew shellenv)"
