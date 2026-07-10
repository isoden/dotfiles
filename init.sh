#!/bin/zsh

set -euo pipefail

if [ "$(uname -s)" != "Darwin" ]; then
  echo "このリポジトリは macOS 専用です (uname -s = $(uname -s))" >&2
  exit 1
fi

# どこから実行してもリンク先が壊れないように、スクリプト自身の位置から解決する。
# ${0:A:h} は $0 を絶対パス化(:A, symlink も解決)し head(:h) で親ディレクトリを取る。
REPO="${0:A:h}"

# BSD の ln は宛先が実ディレクトリのとき -n を付けても黙って成功し、
# その中にリンクを作ってしまう。事前に退避して確実に置き換える。
link() {
  local src="$1" dst="$2"

  if [ ! -e "$src" ]; then
    echo "リンク元が存在しません: $src" >&2
    exit 1
  fi

  if [ -e "$dst" ] && [ ! -L "$dst" ]; then
    if [ -e "$dst.bak" ]; then
      echo "退避先が既に存在します。手動で確認してください: $dst.bak" >&2
      exit 1
    fi
    echo "backup: $dst -> $dst.bak"
    mv "$dst" "$dst.bak"
  fi

  mkdir -p "$(dirname "$dst")"
  ln -fsn "$src" "$dst"
}

link "$REPO/.zshrc"        "$HOME/.zshrc"

link "$REPO/.config/git/config"         "$HOME/.config/git/config"
link "$REPO/.config/git/ignore"         "$HOME/.config/git/ignore"
link "$REPO/.config/nvim"               "$HOME/.config/nvim"
link "$REPO/.config/ghostty/config"     "$HOME/.config/ghostty/config"
link "$REPO/.config/mise/config.toml"   "$HOME/.config/mise/config.toml"
link "$REPO/.config/herdr/config.toml"  "$HOME/.config/herdr/config.toml"

# Claude Code のグローバル設定。
# ドット無しの claude/ に置くのは、リポジトリ直下の .claude/ が
# 「このリポジトリのプロジェクト設定」として自動検出されるのを避けるため。
link "$REPO/claude/CLAUDE.md"  "$HOME/.claude/CLAUDE.md"

# claude/<name>/ 配下の各エントリを ~/.claude/<name>/ へ個別にリンクする。
# ディレクトリごと差し替えると、そこに同居するプラグイン管理のスキル等を
# 壊してしまうため。glob の (N) 修飾子で、ディレクトリが無い/空でも
# 「no matches found」で中断せず何もせずスキップする。${entry:t} は basename。
link_claude_entries() {
  local name="$1" entry
  for entry in "$REPO/claude/$name"/*(N); do
    link "$entry" "$HOME/.claude/$name/${entry:t}"
  done
}

link_claude_entries skills
link_claude_entries agents
link_claude_entries hooks
link_claude_entries scripts

"$REPO/setup/brew.sh"
