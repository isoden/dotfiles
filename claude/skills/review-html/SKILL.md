---
name: review-html
description: Output code reviews, PR writeups, and annotated diffs as a standalone HTML file. Use whenever writing a code review, creating a PR description, analyzing a diff, or generating a module map. Produces richer output than markdown — inline annotations, severity badges, jump links, before/after comparisons, and module graphs.
effort: max
---

# Review as HTML

コードレビュー・PR ライトアップ・アーキテクチャ解説などを
Markdown ではなくスタンドアロン HTML として書き出す。

## なぜ HTML か

diff・コールグラフは空間情報であり Markdown で平坦化すると見通しが悪い。
HTML では注釈付き diff・モジュール図・重要度バッジ・ジャンプリンクが使えるため、
レビュアーがコードの形状を一瞥で把握できる。

## 出力規約

- 出力先: `~/.claude/reviews/<slug>.html`
  - slug 命名: `<repo>-<branch>-<連番>` または `<repo>-<feature>-review` 等
- ファイルは単独で開ける完全な HTML
- インライン CSS のみ。外部 CDN・外部フォント禁止 (オフラインで開けるように)

## デザインシステム

**必ず読むこと**: `~/.claude/skills/html-design-system/references/design-system.md`

CSS 変数・タイポグラフィ・コンポーネントパターンはすべてそのファイルに定義されている。
特にコードレビューで使う diff 表示・重要度バッジ・コードブロックの使い方を参照すること。

## ユースケース別セクション構成

コンテキストに応じて適切な構成を選ぶ。固定ではない。

### PR ライトアップ (著者視点)

`Motivation` / `Changes` (ファイルごとの変更ツアー + Why) /
`Before / After` (動作比較) / `Where to focus` (レビュアーへの誘導) /
`Risks` / `Testing`

### アノテーション付き diff (レビュアー視点)

`Summary` / `Annotated diff` (diff + マージンノート・重要度バッジ) /
`Findings` (問題点一覧) / `Suggestions`

### モジュールマップ / コード理解

`Overview` / `Module graph` (SVG ボックス＆アロー) /
`Hot path` (重要パスのハイライト) / `Entry points` / `Key types`

## 重要度バッジ

finding・コメントへの重要度付けは design-system.md の重要度バッジ配色を使う:
- HIGH (バグ・セキュリティ): `background:#F3D9CC; color:#8A3B1E`
- MED (設計上の懸念・保守性): `background:var(--oat); color:var(--slate)`
- LOW (スタイル・nit): `background:#E4E9DC; color:#4B5C39`

## diff 表示

design-system.md の「diff 表示」パターンを使う:
- ctx 行: `color:#D1CFC5` (gray-300)
- del 行: `color:#E0897A`
- add 行: `color:#A3B88A`

## 図表の活用

- モジュール依存: SVG ボックス＆アロー (design-system.md の SVG ダイアグラム参照)
- 変更前後の比較: 2カラムグリッドで並置
- finding 一覧: 重要度でソートした表またはカードリスト
- 飾りとして図表を使わない

## やらないこと

- コードを実際に変更すること (HTML は成果物・レポートであり実装ではない)
- review ファイルへの進捗更新 (HTML はスナップショット)
