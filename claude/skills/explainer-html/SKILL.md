---
name: explainer-html
description: Output technical explainers — code walkthroughs, feature deep-dives, and concept explanations — as a standalone HTML file. Use whenever explaining how existing code works, documenting an internal system, writing a feature spec explainer, or teaching a concept interactively. Produces richer output than markdown: clickable flow diagrams, collapsible step-by-step walkthroughs, tabbed config examples, interactive demos, and sticky gotcha sidebars.
effort: max
---

# Explainer as HTML

コード解説・機能ドキュメント・技術概念の説明を Markdown ではなくスタンドアロン HTML として書き出す。

## なぜ HTML か

コードの流れ・依存関係・概念は空間的な情報であり、Markdown に平坦化すると読み飛ばされやすい。
HTML では SVG フロー図・折りたたみステップ・タブ切替・インタラクティブデモ・スティッキーサイドバーが使えるため、
読者が自分のペースで深く掘り下げながら全体像を保持できる。

## 出力規約

- 出力先: `~/.claude/explainers/<slug>.html`
  - slug 命名: `<topic>-explainer`（例: `auth-flow-explainer`, `rate-limit-explainer`）
- ファイルは単独で開ける完全な HTML
- インライン CSS のみ。外部 CDN・外部フォント禁止 (オフラインで開けるように)

## デザインシステム

**必ず読むこと**: `~/.claude/skills/html-design-system/references/design-system.md`

CSS 変数・タイポグラフィ・コンポーネントパターンはすべてそのファイルに定義されている。
特に SVG ダイアグラム・コードブロック・折りたたみパターンを参照すること。

## コンテンツ種別と構成

説明する内容に応じて適切な構成を選ぶ。固定ではない。

### コード解説 (既存コードの仕組みを説明)

`TL;DR` / `Architecture` (SVG フロー図) / `Walkthrough` (番号付き折りたたみステップ) /
`Key files` / `Gotchas`

例: 認証フロー・ミドルウェアの動作・キャッシュ戦略

### 機能 deep-dive (実装詳細 + 設定方法)

`TL;DR` / `How it works` (ステップ解説) / `Configuration` (タブ切替 YAML/TypeScript/etc) /
`Gotchas` / `FAQ`

例: レート制限・フィーチャーフラグ・バックグラウンドジョブ

### 概念解説 (アルゴリズム・設計パターン等)

`Overview` / `Interactive demo` (SVG + スライダー等) / `Comparison` (before/after や mod-N との対比) /
`When to use` / `Glossary`

例: コンシステントハッシング・CAP定理・CQRS

## 主要コンポーネントパターン

### TL;DR バナー (必須)

スレート背景の濃いボックスで最初に結論を提示する。
読者が詳細を読むかどうか判断できるように、3行以内で本質を伝える。

### SVG アーキテクチャ / フロー図

コードの流れや依存関係は必ず図で示す。
ホットパス（重要な実行経路）は clay 色で強調し、通常フローはグレーで描く。
design-system.md の SVG ダイアグラムパターンを参照。

### 番号付き折りたたみステップ

各ステップを `<details>` でラップし、ステップ番号・タイトル・関連ファイル名を `<summary>` に入れる。
展開するとコードスニペット（ダークコードブロック）と説明が見える。
一度に1つだけ開く JS 制御を付けると流れが追いやすい。

### タブ切替 (設定例)

YAML / TypeScript / HTTP レスポンス等の複数表現を切り替えるタブ UI。
コンテンツが長くなりがちな設定例をコンパクトに収める。

### スティッキーサイドバー

Key files / Gotchas / Glossary など参照性の高いコンテンツをサイドバーに固定する。
ビューポート幅 1100px 以上では右カラムとして追従させる。

### インタラクティブデモ (概念解説時)

概念をリアルタイムで体験できる SVG デモ（スライダー・ボタン連動）は
「読んで理解」ではなく「操作して理解」を促す。
飾りとして入れるのではなく、概念の核を体験できる場合のみ実装する。

## やらないこと

- コードを実際に変更すること (HTML は説明ドキュメントであり実装ではない)
- すべてのコンポーネントを詰め込むこと (内容に合ったものだけ選ぶ)
