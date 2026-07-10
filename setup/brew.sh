#!/bin/bash

set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# init.sh から直接呼ばれた場合は brew にパスが通っていないことがある
if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

if ! command -v brew >/dev/null; then
  echo "Homebrew が必要です: https://brew.sh/" >&2
  exit 1
fi

brew bundle --file "$REPO/.homebrew/Brewfile"
