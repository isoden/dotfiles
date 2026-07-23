#!/bin/zsh

set -euo pipefail

# ${0:A:h:h} は $0 を絶対パス化(:A)し head を2回(:h:h)で祖父ディレクトリ = repo ルート
REPO="${0:A:h:h}"
MANIFEST="$REPO/gh-skills/manifest.txt"

if ! command -v gh >/dev/null; then
  echo "gh コマンドが必要です (Brewfile 経由でインストールされます)" >&2
  exit 1
fi

if ! command -v jq >/dev/null; then
  echo "jq コマンドが必要です" >&2
  exit 1
fi

# ローカルにインストール済みの skill バージョンを "owner/repo|skill-name" -> version の
# 連想配列に読み込む。区切り文字に "|" を使う理由は dump.sh と同じ (zsh の read が
# タブ区切りの空フィールドを潰すため)。manifest.txt の sha と一致すれば再インストールを
# スキップし、無駄なダウンロードを避ける。
typeset -A installed
while IFS='|' read -r repo skill version; do
  [ -z "$repo" ] && continue
  installed["$repo|$skill"]="$version"
done < <(gh skill list --agent claude-code --scope user --json skillName,sourceURL,version \
  | jq -r '.[] | [(.sourceURL | sub("^https://github.com/"; "") | sub("\\.git$"; "")), .skillName, .version] | join("|")')

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

  # 添字を "$repo|$skill" とクォートしないと zsh が "|" をパイプとして解釈し
  # 常に未検出扱いになる (実機で確認、2026-07-23)。
  if [ "${installed["$repo|$skill"]:-}" = "$sha" ]; then
    echo "skip (up to date): $repo $skill@$sha"
    continue
  fi

  echo "install: $repo $skill@$sha"
  gh skill install "$repo" "$skill" --pin "$sha" --agent claude-code --scope user --force
done < "$MANIFEST"
