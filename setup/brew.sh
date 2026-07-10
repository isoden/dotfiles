#!/bin/bash

set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BREWFILE="$REPO/.homebrew/Brewfile"

# init.sh から直接呼ばれた場合は brew にパスが通っていないことがある
if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

if ! command -v brew >/dev/null; then
  echo "Homebrew が必要です: https://brew.sh/" >&2
  exit 1
fi

brew bundle --file "$BREWFILE"

# Brewfile に無いものを列挙する。--force を付けなければ削除はされず、
# 削除対象があるときだけ終了コード 1 を返す仕様なので || true で受ける。
cleanup_output="$(brew bundle cleanup --file "$BREWFILE" 2>/dev/null || true)"

if [ -z "$cleanup_output" ]; then
  echo "Brewfile と同期しています。"
  exit 0
fi

# -r は非対話でも真になることがあるので、実際に開けるかで判定する
if ! : 2>/dev/null < /dev/tty; then
  echo "対話できないため、Brewfile に無いものの削除確認をスキップします。" >&2
  exit 0
fi

kind=""
kept=0

while IFS= read -r line; do
  case "$line" in
    "Would uninstall formulae:")  kind="formula" ; continue ;;
    "Would uninstall casks:")     kind="cask"    ; continue ;;
    "Would untap:")               kind="tap"     ; continue ;;
    "Run \`brew bundle cleanup"*) kind=""        ; continue ;;
    "")                                            continue ;;
  esac

  [ -n "$kind" ] || continue

  # EOF なら空扱いにして残す (set -e で落とさない)
  answer=""
  read -r -p "Brewfile にありません。削除しますか? ($kind) $line [y/N]: " answer < /dev/tty || answer=""

  case "$answer" in
    [yY])
      # 依存されているものは brew 自身が拒否する。その場合は残す。
      case "$kind" in
        formula) brew uninstall --formula "$line" || kept=$((kept + 1)) ;;
        cask)    brew uninstall --cask "$line"    || kept=$((kept + 1)) ;;
        tap)     brew untap "$line"               || kept=$((kept + 1)) ;;
      esac
      ;;
    *)
      kept=$((kept + 1))
      ;;
  esac
done <<< "$cleanup_output"

# 削除しなかったものは Brewfile 側に取り込んで同期させる
if [ "$kept" -gt 0 ]; then
  echo "削除しなかったものを Brewfile に反映します。"
  "$REPO/setup/brew-dump.sh"
fi
