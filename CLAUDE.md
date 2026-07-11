# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

Apple Silicon の macOS 専用の dotfiles。シェルは zsh。すべてのスクリプトは `#!/bin/zsh` + `set -euo pipefail`。

## Commands

```console
./init.sh              # 設定を ~ 配下へ symlink し、brew.sh → gh-skills.sh を実行
./setup/brew.sh        # Brewfile と同期。未インストールなら Homebrew も自動導入
./setup/brew-dump.sh   # 現在の環境を .homebrew/Brewfile に書き出す
./setup/gh-skills.sh        # setup/gh-skills.txt の内容で `gh skill install` を同期
./setup/gh-skills-dump.sh   # 現在の環境 (user scope) を setup/gh-skills.txt に書き出す
zsh -n <script>        # スクリプトの構文チェック（テストは無い）
```

## Architecture

**リンク方式のセットアップ。** `init.sh` の `link()` ヘルパーがリポジトリ内の実ファイルを `~` 配下へ symlink する。宛先に実ファイル/実ディレクトリがあれば `.bak` へ退避してから張る（`.bak` が既にあれば中断）。BSD の `ln` は宛先が実ディレクトリだと `-n` を付けても中に潜り込むため、この退避が必須。

**設定の実体はリポジトリ内に集約。** `~/.zshrc` だけを symlink し、そこから `${:-$HOME/.zshrc}:A:h` でリポジトリルート（`ZDOTREPO`）を解決して `.config/zsh/*.zsh` を読み込む。よって `~/.config/zsh` への個別リンクは不要。zsh 設定は `path → tools → options → completion → prompt → functions → abbr` の順に依存関係があるため `.zshrc` で明示列挙している。PC 固有設定は git 管理外の `~/.zshrc.local` に置き、共通設定を上書きできる。

**Claude Code 設定は `claude/`（ドット無し）に置く。** リポジトリ直下に `.claude/` を置くと「このリポジトリのプロジェクト設定」として自動検出されてしまうため。`init.sh` の `link_claude_entries` が `claude/<skills|agents|hooks|scripts>/` 配下を **エントリ単位で** `~/.claude/<name>/` へ張る。ディレクトリごと差し替えると同居する plugin 管理のスキル等を壊すため、個別リンクにしている。`claude/CLAUDE.md` はグローバル設定として `~/.claude/CLAUDE.md` に張られる。

**Homebrew 同期。** `.homebrew/Brewfile` が唯一のソース。`brew.sh` は `brew bundle` で導入後、Brewfile に無いものを対話的に確認して削除し、残したものは `brew-dump.sh` で Brewfile に取り込む。非対話（`/dev/tty` が開けない）環境では削除確認をスキップする。prefix は `/opt/homebrew` 固定（Apple Silicon 専用）。

**GitHub 配布の Claude Code skills は `gh skill` で同期。** 自作 skill（`claude/skills/`）とは別に、GitHub リポジトリで配布されている skills は `setup/gh-skills.txt`（`owner/repo skill-name commit-sha` を1行1skillで列挙）が唯一のソース。`gh-skills.sh` が各行を `gh skill install <repo> <skill>@<sha> --agent claude-code --scope user --force` でインストールする。commit sha を明示指定することで、複数 PC 間で同一バージョンが入る状態を保証する（Brewfile がバージョンを固定しないのとは対照的）。`gh` 自体は Brewfile 経由で導入されるため、`init.sh` は `brew.sh` の後に `gh-skills.sh` を呼ぶ。新しい skill を試すときは pin 無しで `gh skill install` した後 `gh-skills-dump.sh` を実行する。`gh skill list --json` の `version` は pin 済みなら commit sha だがそれ以外は branch/tag 名になるため、dump 側は 40 桁16進数か判定し、そうでなければ `gh api repos/<owner>/<repo>/commits/<ref>` で commit sha に解決してから書き出す。`gh skill uninstall` 相当のコマンドは無いため、`gh-skills.txt` から行を消しても実体は残る（手動で削除ディレクトリを消す必要がある）。

## Conventions

- スクリプト内でパスを自己解決するときは `${0:A:h}`（絶対パス化して親ディレクトリ）を使う。`setup/` 配下は `:h:h` でリポジトリルート。
- 非自明な挙動（BSD `ln` の罠、`(N)` glob 修飾子、compaudit 対策の `chmod go-w` 等）は日本語コメントで理由を残す慣習がある。
