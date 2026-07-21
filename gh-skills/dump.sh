#!/bin/zsh

set -euo pipefail

# ${0:A:h:h} は $0 を絶対パス化(:A)し head を2回(:h:h)で祖父ディレクトリ = repo ルート
REPO="${0:A:h:h}"
MANIFEST="$REPO/gh-skills/manifest.txt"

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
  echo "# gh-skills/dump.sh で現在の環境 (--scope user --agent claude-code) から生成する。"
  echo

  # 区切り文字は @tsv (タブ) ではなく "|" を使う。zsh の read はタブ等の空白系 IFS
  # 文字を特別扱いし、連続する区切り文字をまとめて先頭の空フィールドを潰してしまう
  # ため、sourceURL が空のエントリでフィールドがずれるバグを踏んだ (2026-07-22)。
  gh skill list --agent claude-code --scope user --json skillName,sourceURL,version \
    | jq -r '.[] | [(.sourceURL | sub("^https://github.com/"; "") | sub("\\.git$"; "")), .skillName, .version] | join("|")' \
    | while IFS='|' read -r repo skill version; do
        # sourceURL が空 = gh skill install 以外の経路 (Claude Code 組み込み skill 等)
        # で入ったもの。gh skill install で再現できないためマニフェストの対象外。
        if [ -z "$repo" ]; then
          echo "sourceURL 不明のためスキップ: $skill" >&2
          continue
        fi
        sha="$(resolve_sha "$repo" "$version")"
        echo "$repo $skill $sha"
      done \
    | sort
} > "$MANIFEST"

echo "更新しました: $MANIFEST"
