#!/bin/zsh

set -euo pipefail

if [ "$(uname -s)" != "Darwin" ]; then
  echo "このリポジトリは macOS 専用です (uname -s = $(uname -s))" >&2
  exit 1
fi

# どこから実行してもリンク先が壊れないように、スクリプト自身の位置から解決する。
# ${0:A:h} は $0 を絶対パス化(:A, symlink も解決)し head(:h) で親ディレクトリを取る。
REPO="${0:A:h}"

if ! command -v mise >/dev/null; then
  echo "mise が未インストールのためインストールします: https://mise.run/"
  curl https://mise.run | sh
  export PATH="$HOME/.local/bin:$PATH"
fi

# mise の [dotfiles] は宛先に内容の異なる実ファイルがあっても .bak 退避せず
# --force-dotfiles を要求するだけ。自動で上書きすると分岐した変更を握り潰す
# 恐れがあるため、ここでは付けずエラー停止 → 手動確認に委ねる。
exec mise bootstrap --yes -C "$REPO"
