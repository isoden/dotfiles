# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

Apple Silicon の macOS 専用の dotfiles。シェルは zsh。すべてのスクリプトは `#!/bin/zsh` + `set -euo pipefail`。

## Commands

```console
./setup.sh                          # mise 未導入なら curl で導入し、mise bootstrap --yes に委譲する
mise bootstrap status                # dotfiles・packages の集約ステータス
mise bootstrap dotfiles status       # symlink の適用状況（差分/衝突を個別表示）
mise bootstrap packages status       # Homebrew formula/cask のインストール状況
mise bootstrap --dry-run             # 副作用なしで全計画（symlink一覧・インストール予定）を確認
mise bootstrap packages prune --dry-run  # 宣言外パッケージの削除候補を確認（★下記の制約に注意）
mise bootstrap packages use brew:<name>                        # brew パッケージを追加（全PC共通、mise.toml へ）
mise bootstrap packages use -p mise.local.toml brew:<name>      # brew パッケージを追加（このPCのみ、mise.local.toml へ）
./setup/gh-skills.sh        # setup/gh-skills.txt の内容で `gh skill install` を同期
./setup/gh-skills-dump.sh   # 現在の環境 (user scope) を setup/gh-skills.txt に書き出す
zsh -n <script>        # スクリプトの構文チェック（テストは無い）
```

## Architecture

**mise bootstrap によるセットアップ。** `setup.sh` は mise 未導入なら公式 curl インストーラー（`https://mise.run`）で導入し、`exec mise bootstrap --yes -C "$REPO"` に委譲する薄いラッパー。実体の宣言はリポジトリルートの `mise.toml`（後述）が持つ。旧 `link()`/`link_claude_entries()`（自作 bash による symlink 管理）は撤去済み。**mise の `[dotfiles]` は宛先に内容の異なる実ファイルがあっても `.bak` 退避せず `--force-dotfiles` を要求するだけ**（旧 `link()` の `.bak` 退避に相当する機能は無い）ため、`setup.sh` はデフォルトで `--force-dotfiles` を付けない。衝突時はエラー停止するので、`mise bootstrap dotfiles status` で差分を目視確認してから `mise bootstrap --force-dotfiles` を手動実行する。冪等なコマンドなので、会社PC⇔個人PC間の同期用途で何度実行しても安全。

**設定の実体はリポジトリ内に集約。** `~/.zshrc` だけを symlink し、そこから `${:-$HOME/.zshrc}:A:h` でリポジトリルート（`ZDOTREPO`）を解決して `.config/zsh/*.zsh` を読み込む。よって `~/.config/zsh` への個別リンクは不要。zsh 設定は `path → tools → options → completion → prompt → functions → abbr` の順に依存関係があるため `.zshrc` で明示列挙している。PC 固有設定は git 管理外の `~/.zshrc.local` に置き、共通設定を上書きできる。

**Claude Code 設定は `claude/`（ドット無し）に置く。** リポジトリ直下に `.claude/` を置くと「このリポジトリのプロジェクト設定」として自動検出されてしまうため。`mise.toml` の `[dotfiles]` が `claude/<skills|agents|hooks|scripts>/` 配下を `~/.claude/<name>/` へ張る。ディレクトリごと差し替えると同居する plugin 管理のスキル等を壊すため、個別リンクにしている。`claude/CLAUDE.md` はグローバル設定として `~/.claude/CLAUDE.md` に張られる。

`claude/agents` のようなフラットなファイル群には `mode = "symlink-each"` を使う（宛先ディレクトリ内の各ファイルを個別に symlink 化する。旧 `link_claude_entries` のエントリ単位リンクと同じ効果）。**`claude/skills` には `symlink-each` を使わず、各 skill サブディレクトリを個別の `mode = "symlink"` エントリとして列挙している。** 理由: `claude/skills` は「skill ディレクトリの中に SKILL.md 等がある」2階層構造で、`symlink-each` はここに対して再帰的にファイル単位で `ln -sf` をかけようとする。既にディレクトリ全体が symlink 化済みのエントリ（例: `plan-html`）に対してこれを行うと、symlink を辿った先の実ファイルへ自己参照 symlink を作ってしまい中身を破壊する（2026-07-21 の mise bootstrap 全面移行の実機検証で `plan-html/SKILL.md` が実際に破壊され、`git checkout` で復元した）。挙動が不安定で公式ドキュメントにもネスト構造での仕様記載が無いため、安全側に倒して個別列挙にしている。新しい skill を `claude/skills/` に追加したら `mise.toml` にも1行追記すること。ただし `css-core-architecture` は `.gitignore` 対象（git 管理外、ライセンス未確認のため）なので **意図的に `mise.toml` へ含めていない** — 含めると、このディレクトリを持たない別マシンで clone した際に `source missing` で bootstrap 全体が止まる。使うマシンでは手動で `ln -s` するか、`mise.toml` にコメントアウトしてある行を一時的に有効化する。

**Homebrew パッケージ管理は mise bootstrap に統合。** `mise.toml`（リポジトリルート、コミット対象）の `[bootstrap.packages]`・`[bootstrap.brew.taps]` が全PC共通パッケージを宣言し、`mise.local.toml`（リポジトリルート、git 管理外）が PC 固有パッケージを宣言する。両ファイルはキー単位でマージされるので、旧 `Brewfile` + `Brewfile.local` と同じ「会社PC/個人PC固有ツールを分離しつつ共通部分を共有する」運用ができる。`mise` の `brew:`/`brew-cask:` パッケージマネージャーは **実物の Homebrew CLI に委譲するのではなく mise 独自実装**（Homebrew 不要で動く）である点に注意。この独自実装には既知の制約がある: `mise bootstrap packages prune` はカスタム tap（`yusukebe/tap` 等）の formula に対して `api/formula/<name>.json` 形式のメタデータを要求し、tap がそれを公開していないと `404` で失敗する（このリポジトリでは `yusukebe/tap/ax` が該当し、`prune` は現状使えない）。`import`（`brew leaves` 相当を `[bootstrap.packages]` へ書き出す）は動作するが、cask は対象外で手動転記が必要。宣言外パッケージを確認したいときは `brew bundle cleanup --dry-run` のような Homebrew 自身のコマンドを併用する。

**パッケージ追加は `mise bootstrap packages use` を直接叩く。** `mise bootstrap packages use brew:<name>` はデフォルトで実行ディレクトリの `mise.toml`（全PC共通）に書き込む。PC固有パッケージにしたいときは `-p mise.local.toml` を明示すること（書き忘れると共通ファイルに混入する）。ラッパースクリプトは用意していない — 「mise をやめる可能性に備える」という理由だけで薄いラッパーを足すのは仮説的な将来要件のための設計であり、コマンド1つをドキュメントに書けば足りると判断した（2026-07-22、一度 `setup/pkg-add.sh` として実装したが過剰と判断し撤去）。

**`.config/mise/config.toml` と `mise.toml` の役割分担。** `.config/mise/config.toml` は `~/.config/mise/config.toml` に symlink される、グローバルな `[tools]`（bun/node 等の言語ランタイムのフォールバック）専用の設定。一方 `mise.toml` はリポジトリルートに置くだけで**どこにも symlink しない** — bootstrap タスクが参照する `{{config_root}}` は、グローバル設定として読み込まれた場合 `$HOME` に解決されてしまい、`gh-skills.sh` の相対パス実行（`dir = "{{config_root}}"`）が壊れるため。

**GitHub 配布の Claude Code skills は `gh skill` で同期（vendoring はしない）。** 自作 skill（`claude/skills/`）とは別に、GitHub リポジトリで配布されている skills は `setup/gh-skills.txt`（`owner/repo skill-name commit-sha` を1行1skillで列挙）が唯一のソース。実体をリポジトリにコピーする vendoring 方式は採用していない — 配布元のライセンス確認の手間（`css-core-architecture` を `.gitignore` に置いた理由と同じ問題）と upstream 更新追従の手動化を避けるため、reference + sha pin 方式（Claude Code 本体の plugin marketplace や Vercel skills.sh も同じ思想）を踏襲している。`mise.toml` の `[tasks.bootstrap]` が `gh-skills.sh` を呼び、各行を `gh skill install <repo> <skill>@<sha> --agent claude-code --scope user --force` でインストールする。commit sha を明示指定することで、複数 PC 間で同一バージョンが入る状態を保証する（`[bootstrap.packages]` がバージョンを固定しないのとは対照的）。新しい skill を試すときは pin 無しで `gh skill install` した後 `gh-skills-dump.sh` を実行する。

`gh skill list --json` の `sourceURL` は、Claude Code 公式 plugin marketplace（`~/.claude/settings.json` の `enabledPlugins`。figma 公式 plugin 等）や Cloudflare 系の組み込み skill では空文字列になる。これらは `gh skill install` で再現できないインストール経路なので、`gh-skills-dump.sh` は `sourceURL` が空のエントリを警告付きでスキップし、マニフェストの対象外にする。`version` は pin 済みなら commit sha だがそれ以外は branch/tag 名になるため、dump 側は 40 桁16進数か判定し、そうでなければ `gh api repos/<owner>/<repo>/commits/<ref>` で commit sha に解決してから書き出す。`gh skill uninstall` 相当のコマンドは無いため、`gh-skills.txt` から行を消しても実体は残る（手動で削除ディレクトリを消す必要がある）。

**zsh の `read` はタブ区切り TSV を先頭空フィールドで壊す。** `gh-skills-dump.sh` は元々 `jq -r '... | @tsv'` の出力を `IFS=$'\t' read -r a b c` で読んでいたが、zsh の `read` はタブ等の空白系 IFS 文字を特別扱いし、連続する区切り文字をまとめて先頭の空フィールドを潰す（`printf '\tfoo\t' | IFS=$'\t' read -r a b c` は `a=foo` になり `a` に入るべき空文字列が消える）。`,` や `|` のような非空白文字を区切りにすれば問題なく空フィールドを保持できるため、`join("|")` + `IFS='|' read` に変更している（2026-07-22、`sourceURL` が空の skill で実際にこのバグを踏んで発覚）。

## Conventions

- スクリプト内でパスを自己解決するときは `${0:A:h}`（絶対パス化して親ディレクトリ）を使う。`setup/` 配下は `:h:h` でリポジトリルート。
- 非自明な挙動（`symlink-each` のネスト構造での破壊的挙動、`{{config_root}}` がグローバル設定では `$HOME` に解決される罠、compaudit 対策の `chmod go-w` 等）は日本語コメントで理由を残す慣習がある。
