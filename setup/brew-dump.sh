#!/bin/zsh

set -euo pipefail

# ${0:A:h:h} は $0 を絶対パス化(:A)し head を2回(:h:h)で祖父ディレクトリ = repo ルート
REPO="${0:A:h:h}"
BREWFILE="$REPO/.homebrew/Brewfile"
LOCAL_BREWFILE="$REPO/.homebrew/Brewfile.local"

if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

if ! command -v brew >/dev/null; then
  echo "Homebrew が必要です: https://brew.sh/" >&2
  exit 1
fi

CURRENT="$(mktemp)"
trap 'rm -f "$CURRENT"' EXIT

brew bundle dump --force --no-npm --no-vscode --file "$CURRENT"

# tap/brew/cask 等の実体行だけを比較対象にする（説明コメント行・空行は無視する）。
entries() {
  local file="$1"
  [ -f "$file" ] || return 0
  grep -E '^(tap|brew|cask|vscode|mas|whalebrew) ' "$file" || true
}

# 現在インストール済みの中から、共有 Brewfile にも Brewfile.local にも
# まだ無い行 (新規分) だけを抽出する。
new_entries="$(comm -23 \
  <(entries "$CURRENT" | sort) \
  <( { entries "$BREWFILE"; entries "$LOCAL_BREWFILE"; } | sort) \
)"

if [ -z "$new_entries" ]; then
  echo "差分はありません。"
  exit 0
fi

if ! : 2>/dev/null < /dev/tty; then
  echo "対話できないため、差分の振り分けをスキップします。以下が未反映です:" >&2
  echo "$new_entries" >&2
  exit 0
fi

added_common=0
added_local=0
skipped=0

while IFS= read -r line; do
  [ -n "$line" ] || continue

  answer=""
  read -r "answer?$line
  どちらに追加しますか? [c]ommon (全PC共通) / [l]ocal (このPC固有) / それ以外でスキップ: " < /dev/tty || answer=""

  case "$answer" in
    [cC])
      echo "$line" >> "$BREWFILE"
      added_common=$((added_common + 1))
      ;;
    [lL])
      echo "$line" >> "$LOCAL_BREWFILE"
      added_local=$((added_local + 1))
      ;;
    *)
      skipped=$((skipped + 1))
      ;;
  esac
done <<< "$new_entries"

echo "共有 Brewfile に追加: $added_common 件"
echo "Brewfile.local に追加: $added_local 件"
echo "スキップ: $skipped 件"
