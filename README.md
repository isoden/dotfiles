:page_facing_up: dotfiles
===

Apple Silicon の macOS 専用。

## Setup

```console
./init.sh
```

`~` 配下に既存の実ファイル・実ディレクトリがある場合は `.bak` に退避してからリンクします。
[Homebrew](https://brew.sh/) が未インストールの場合は公式インストーラで自動インストールします。

## Brewfile の更新

現在インストールされているものを `.homebrew/Brewfile` に書き出します。

```console
./setup/brew-dump.sh
```
