#!/bin/zsh

set -euo pipefail

# ${0:A:h:h} は $0 を絶対パス化(:A)し head を2回(:h:h)で祖父ディレクトリ = repo ルート
REPO="${0:A:h:h}"
MANIFEST="$REPO/gh-skills/manifest.txt"

if ! command -v gh >/dev/null; then
  echo "gh コマンドが必要です (Brewfile 経由でインストールされます)" >&2
  exit 1
fi

# マニフェストの各行を owner/repo skill-name commit-sha としてインストールする。
# --pin で明示指定することで、複数 PC 間で常に同じバージョンの skill が入る状態を保つ。
# `skill@sha` 構文だけでは pinned=false のままで、誰かが `gh skill update --all` を
# 実行すると黙って上書きされてしまう不具合を実機で確認したため --pin を使う
# (2026-07-22)。
while IFS= read -r line || [ -n "$line" ]; do
  case "$line" in
    ''|'#'*) continue ;;
  esac

  read -r repo skill sha <<< "$line"

  if [ -z "$repo" ] || [ -z "$skill" ] || [ -z "$sha" ]; then
    echo "不正な行をスキップします: $line" >&2
    continue
  fi

  echo "install: $repo $skill@$sha"
  gh skill install "$repo" "$skill" --pin "$sha" --agent claude-code --scope user --force
done < "$MANIFEST"
