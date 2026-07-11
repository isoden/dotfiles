:page_facing_up: dotfiles
===

Apple Silicon の macOS 専用。

## Setup

```console
./setup.sh
```

`~` 配下に既存の実ファイル・実ディレクトリがある場合は `.bak` に退避してからリンクします。
[Homebrew](https://brew.sh/) が未インストールの場合は公式インストーラで自動インストールします。
何度実行しても安全です。会社PC⇔個人PC間の設定同期にもそのまま使えます。

## Brewfile の更新

現在インストールされているものと `.homebrew/Brewfile` + `.homebrew/Brewfile.local`（会社PC/個人PCなど、そのマシンにしか無いツール用。git 管理外）との差分を検出し、
新規分だけをパッケージごとにどちらへ追加するか聞きます。

```console
./setup/brew-dump.sh
```
