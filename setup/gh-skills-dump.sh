#!/bin/zsh

set -euo pipefail

# ${0:A:h:h} は $0 を絶対パス化(:A)し head を2回(:h:h)で祖父ディレクトリ = repo ルート
REPO="${0:A:h:h}"
MANIFEST="$REPO/setup/gh-skills.txt"

if ! command -v gh >/dev/null; then
  echo "gh コマンドが必要です" >&2
  exit 1
fi

if ! command -v jq >/dev/null; then
  echo "jq コマンドが必要です" >&2
  exit 1
fi

# `gh skill list` の version は pin 済みなら commit sha だが、未 pin だと
# main のような branch/tag 名になる。40桁16進数でなければ commit sha ではないので
# GitHub API で現在の sha に解決する。
resolve_sha() {
  local repo="$1" version="$2"
  if [[ "$version" =~ ^[0-9a-f]{40}$ ]]; then
    echo "$version"
  else
    gh api "repos/$repo/commits/$version" --jq .sha
  fi
}

{
  echo "# gh skill (https://cli.github.com/manual/gh_skill) で同期する Claude Code skills のマニフェスト。"
  echo "# 1行 1skill、空白区切りで: owner/repo skill-name commit-sha"
  echo "#"
  echo "# setup/gh-skills-dump.sh で現在の環境 (--scope user --agent claude-code) から生成する。"
  echo

  gh skill list --agent claude-code --scope user --json skillName,sourceURL,version \
    | jq -r '.[] | [(.sourceURL | sub("^https://github.com/"; "") | sub("\\.git$"; "")), .skillName, .version] | @tsv' \
    | while IFS=$'\t' read -r repo skill version; do
        sha="$(resolve_sha "$repo" "$version")"
        echo "$repo $skill $sha"
      done \
    | sort
} > "$MANIFEST"

echo "更新しました: $MANIFEST"
