---
name: plan-html
description: Output the plan-mode plan as a standalone HTML file for review. Use whenever entering plan mode, updating an in-progress plan, or about to call ExitPlanMode.
# model は指定しない: 省略時 inherit でセッションモデル (通常最上位) を使う。
# opus 固定は Fable 等の上位モデル使用時にプランだけダウングレードするため却下 (2026-07-15)。
effort: max
---

# Plan as HTML

plan mode で提示するプランは Markdown ではなく HTML ファイルとして書き出す。
ExitPlanMode の本文には要約だけ載せ、詳細は HTML を参照させる。

## なぜ HTML か

表・SVG・リンク・折りたたみ・色分け・チェックリストなどが使え、
Markdown より情報密度と可読性が高い。
参考: https://claude.com/blog/using-claude-code-the-unreasonable-effectiveness-of-html

## 出力規約

- 出力先: `~/.claude/plans/<slug>.html`
  - slug は同ディレクトリの既存ファイル命名規則 (例: `ai-ai-3-dazzling-chipmunk`) に合わせる
  - 既存の `.md` プランと並走するときは同じ slug の `.html` を作る
- ファイルは単独で開ける完全な HTML (`<!doctype html>` から `</html>` まで)
- インライン CSS のみ。外部 CDN・外部フォントへの依存は禁止 (オフラインで開けるように)
- セクション構成: `Goal` / `Context` / `Approach` / `Steps` / `Risks` / `Open Questions`

## デザインシステム

**必ず読むこと**: `~/.claude/skills/html-design-system/references/design-system.md`

CSS 変数・タイポグラフィ・コンポーネントパターン（サマリーストリップ・タイムライン・
リスクテーブル・Open Questions カード・コードブロック・SVG ダイアグラム）はすべて
そのファイルに定義されている。ここに再掲しない。

## 図表の活用

情報が図表で明確になる場合はテキストの代わりに使う。乱用はしない。

- 構造・比較・状態遷移など、文章より図表が明快なときに用いる
- 手段の例: 表・SVG (アーキテクチャ・フロー)・チェックリスト (Steps)・`<details>` (折りたたみ)
- 図表は情報伝達に寄与する場合のみ。飾りとして入れない

## ExitPlanMode との関係

ExitPlanMode のテキストには必ず次を含める (`$HOME` は実パスに展開した値で書く):

```
詳細プラン: file://$HOME/.claude/plans/<slug>.html
```

そのうえで 3〜6 行の要約を書く。長い説明は HTML 側に寄せる。

HTML 出力後は、ユーザーに「`file://...` を開いてください」と一行案内する。

## やらないこと

- plan モードを抜けた後の進捗報告を HTML に書き戻すこと (HTML は計画のスナップショット)
- ExitPlanMode 本文に HTML の中身を丸ごとコピペすること (パスだけでよい)
