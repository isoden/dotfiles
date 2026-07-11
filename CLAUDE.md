# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

Apple Silicon の macOS 専用の dotfiles。シェルは zsh。すべてのスクリプトは `#!/bin/zsh` + `set -euo pipefail`。

## Commands

```console
./setup.sh              # 設定を ~ 配下へ symlink し、brew.sh → gh-skills.sh を実行
./setup/brew.sh        # Brewfile と同期。未インストールなら Homebrew も自動導入
./setup/brew-dump.sh   # 現在の環境と Brewfile+Brewfile.local との差分をパッケージごとに振り分けて追記する
./setup/gh-skills.sh        # setup/gh-skills.txt の内容で `gh skill install` を同期
./setup/gh-skills-dump.sh   # 現在の環境 (user scope) を setup/gh-skills.txt に書き出す
zsh -n <script>        # スクリプトの構文チェック（テストは無い）
```

## Architecture

**リンク方式のセットアップ。** `setup.sh` の `link()` ヘルパーがリポジトリ内の実ファイルを `~` 配下へ symlink する。宛先に実ファイル/実ディレクトリがあれば `.bak` へ退避してから張る（`.bak` が既にあれば中断）。BSD の `ln` は宛先が実ディレクトリだと `-n` を付けても中に潜り込むため、この退避が必須。`ln` 自体が失敗した場合はエラーを stderr に出力するが、他のエントリのリンクは続行する。冪等なスクリプトなので、会社PC⇔個人PC間の同期用途で何度実行しても安全。

**設定の実体はリポジトリ内に集約。** `~/.zshrc` だけを symlink し、そこから `${:-$HOME/.zshrc}:A:h` でリポジトリルート（`ZDOTREPO`）を解決して `.config/zsh/*.zsh` を読み込む。よって `~/.config/zsh` への個別リンクは不要。zsh 設定は `path → tools → options → completion → prompt → functions → abbr` の順に依存関係があるため `.zshrc` で明示列挙している。PC 固有設定は git 管理外の `~/.zshrc.local` に置き、共通設定を上書きできる。

**Claude Code 設定は `claude/`（ドット無し）に置く。** リポジトリ直下に `.claude/` を置くと「このリポジトリのプロジェクト設定」として自動検出されてしまうため。`setup.sh` の `link_claude_entries` が `claude/<skills|agents|hooks|scripts>/` 配下を **エントリ単位で** `~/.claude/<name>/` へ張る。ディレクトリごと差し替えると同居する plugin 管理のスキル等を壊すため、個別リンクにしている。`claude/CLAUDE.md` はグローバル設定として `~/.claude/CLAUDE.md` に張られる。

**Homebrew 同期。** `.homebrew/Brewfile`（全PC共通、git 管理）と `.homebrew/Brewfile.local`（そのPC固有、git 管理外）の2ファイル構成。会社PC/個人PCそれぞれにしか無いツール（VPNクライアント等）を共有 Brewfile に混ぜると、他方のPCで「Brewfileに無いから削除対象」と誤検知されたり、逆に固有ツールが他方に同期されてしまうため分離している。`brew.sh` は両ファイルを一時ファイルにマージしてから `brew bundle`／`brew bundle cleanup` に渡す。マージ後のファイルに無いものは対話的に削除確認し、削除しなかったものの反映方法（共有かPC固有か）は案内するのみで自動では書き込まない（自動判定できないため）。非対話（`/dev/tty` が開けない）環境では削除確認をスキップする。prefix は `/opt/homebrew` 固定（Apple Silicon 専用）。`brew-dump.sh` は `brew bundle dump` で得た現在の全パッケージ一覧と、Brewfile+Brewfile.local に既にある行との差分（tap/brew/cask 等の実体行のみを `comm` で比較、説明コメント行は無視）を取り、新規分だけをパッケージごとに `c`(共有)/`l`(PC固有)/スキップで振り分けて対象ファイルに追記する。全量書き出し（`--force` 上書き）はしないので、手動で書いたコメントや順序は保持される。

**GitHub 配布の Claude Code skills は `gh skill` で同期。** 自作 skill（`claude/skills/`）とは別に、GitHub リポジトリで配布されている skills は `setup/gh-skills.txt`（`owner/repo skill-name commit-sha` を1行1skillで列挙）が唯一のソース。`gh-skills.sh` が各行を `gh skill install <repo> <skill>@<sha> --agent claude-code --scope user --force` でインストールする。commit sha を明示指定することで、複数 PC 間で同一バージョンが入る状態を保証する（Brewfile がバージョンを固定しないのとは対照的）。`gh` 自体は Brewfile 経由で導入されるため、`setup.sh` は `brew.sh` の後に `gh-skills.sh` を呼ぶ。新しい skill を試すときは pin 無しで `gh skill install` した後 `gh-skills-dump.sh` を実行する。`gh skill list --json` の `version` は pin 済みなら commit sha だがそれ以外は branch/tag 名になるため、dump 側は 40 桁16進数か判定し、そうでなければ `gh api repos/<owner>/<repo>/commits/<ref>` で commit sha に解決してから書き出す。`gh skill uninstall` 相当のコマンドは無いため、`gh-skills.txt` から行を消しても実体は残る（手動で削除ディレクトリを消す必要がある）。

## Conventions

- スクリプト内でパスを自己解決するときは `${0:A:h}`（絶対パス化して親ディレクトリ）を使う。`setup/` 配下は `:h:h` でリポジトリルート。
- 非自明な挙動（BSD `ln` の罠、`(N)` glob 修飾子、compaudit 対策の `chmod go-w` 等）は日本語コメントで理由を残す慣習がある。
