#!/bin/zsh

set -euo pipefail

# ${0:A:h:h} は $0 を絶対パス化(:A)し head を2回(:h:h)で祖父ディレクトリ = repo ルート
REPO="${0:A:h:h}"

if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

if ! command -v brew >/dev/null; then
  echo "Homebrew が必要です: https://brew.sh/" >&2
  exit 1
fi

brew bundle dump --force --no-npm --no-vscode --file "$REPO/.homebrew/Brewfile"

echo "更新しました: $REPO/.homebrew/Brewfile"
