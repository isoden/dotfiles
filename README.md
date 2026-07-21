:page_facing_up: dotfiles
===

Apple Silicon の macOS 専用。

## Setup

```console
./setup.sh
```

[mise](https://mise.jdx.dev/) が未インストールの場合は公式インストーラで自動導入し、`mise bootstrap` に委譲します。1コマンドで以下を行います：

- dotfiles の symlink 化（`mise.toml` の `[dotfiles]`）
- Homebrew パッケージのインストール（`mise.toml` + `mise.local.toml` の `[bootstrap.packages]`。mise 独自実装のため、実物の Homebrew CLI は必須ではありません）
- GitHub 配布の Claude Code skills の同期（`setup/gh-skills.sh`）

`~` 配下に内容の異なる既存ファイルがある場合は `.bak` への自動退避はせずエラー停止します。`mise bootstrap dotfiles status` で差分を確認してから、必要なら `mise bootstrap --force-dotfiles` で上書きしてください。

以下のユースケースを想定：
- PCの初期セットアップ
- 複数PC間の設定・パッケージ共有

## How to use

### 状態を確認する

```console
mise bootstrap status                    # dotfiles・packages の集約ステータス
mise bootstrap dotfiles status           # symlink の適用状況（差分/衝突を個別表示）
mise bootstrap packages status           # Homebrew formula/cask のインストール状況
mise bootstrap --dry-run                 # 副作用なしで全計画を確認
```

### brew パッケージを追加する

```console
mise bootstrap packages use brew:jq                          # 全PC共通 (mise.toml に追加)
mise bootstrap packages use -p mise.local.toml brew:ollama   # このPCだけ (mise.local.toml に追加。git 管理外)
```

`-p` を省略すると実行ディレクトリの `mise.toml`（全PC共通）に書き込まれます。PC固有パッケージを追加するときは必ず `-p mise.local.toml` を明示してください。

cask を追加するときは `brew-cask:`、カスタム tap の formula は `<tap>/<name>` を指定します（例: `brew-cask:firefox`、`brew:yusukebe/tap/ax`）。

### GitHub 配布の Claude Code skills を同期する

```console
./setup/gh-skills.sh        # setup/gh-skills.txt の内容で `gh skill install` を同期
./setup/gh-skills-dump.sh   # 現在の環境 (user scope) を setup/gh-skills.txt に書き出す
```
