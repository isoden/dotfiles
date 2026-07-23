#!/bin/zsh

set -euo pipefail

# mise の brew: backend はカスタム tap (olets/tap, yusukebe/tap) の formula 取得に
# api/formula/*.json を要求するが両 tap とも非公開のため 404 になり、github: backend も
# zsh-abbr が依存する submodule が release tarball に含まれず動かない（詳細は CLAUDE.md）。
# そのため ax・zsh-abbr はこのスクリプトで個別に、Homebrew 非依存でインストールする。

AX_TAG="v0.1.21"
ZSH_ABBR_PIN="v6.5.2"
ZSH_ABBR_DIR="$HOME/.local/share/zsh-abbr"

install_ax() {
  local pin_version="${AX_TAG#v}"

  if command -v ax >/dev/null && [ "$(ax --version)" = "$pin_version" ]; then
    echo "skip (up to date): ax $AX_TAG"
    return
  fi

  echo "install: ax $AX_TAG"
  AX_VERSION="$AX_TAG" AX_INSTALL_DIR="$HOME/.local/bin" sh -c "$(curl -fsSL https://ax.yusuke.run/install)"
}

install_zsh_abbr() {
  if [ -d "$ZSH_ABBR_DIR" ] \
    && [ "$(git -C "$ZSH_ABBR_DIR" describe --tags --exact-match 2>/dev/null)" = "$ZSH_ABBR_PIN" ] \
    && [ -s "$ZSH_ABBR_DIR/zsh-job-queue/zsh-job-queue.zsh" ]; then
    echo "skip (up to date): zsh-abbr $ZSH_ABBR_PIN"
    return
  fi

  echo "install: zsh-abbr $ZSH_ABBR_PIN"
  rm -rf "$ZSH_ABBR_DIR"
  git clone https://github.com/olets/zsh-abbr "$ZSH_ABBR_DIR" \
    --recurse-submodules --single-branch --branch "$ZSH_ABBR_PIN" --depth 1
}

install_ax
install_zsh_abbr
