#!/bin/bash

set -euo pipefail

if [ "$(uname -s)" != "Darwin" ]; then
  echo "このリポジトリは macOS 専用です (uname -s = $(uname -s))" >&2
  exit 1
fi

# どこから実行してもリンク先が壊れないように、スクリプト自身の位置から解決する
REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

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
link "$REPO/.config/mise/config.toml"   "$HOME/.config/mise/config.toml"
link "$REPO/.config/herdr/config.toml"  "$HOME/.config/herdr/config.toml"

"$REPO/setup/brew.sh"
