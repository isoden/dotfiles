---
name: plan-html
description: Output the plan-mode plan as a standalone HTML file for review. Use whenever entering plan mode, updating an in-progress plan, or about to call ExitPlanMode.
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
- インライン CSS のみ。外部 CDN や外部フォントへの依存は禁止 (オフラインで開けるように)
- セクション構成: `Goal` / `Context` / `Approach` / `Steps` / `Risks` / `Open Questions`

## 図表の活用

情報が図表で明確になる場合はテキストの代わりに使う。乱用はしない。

- 構造・比較・状態遷移など、文章より図表が明快なときに用いる
- 手段の例: 表 (比較・パラメータ)、SVG (アーキテクチャ・フロー・依存関係)、
  チェックリスト (Steps)、`<details>` (折りたたみで補足を隠す)
- 図表は情報伝達に寄与する場合のみ。飾りとして入れない

## 見た目

ダークモードを基調とし、装飾は必要最低限にする。

- 配色はダーク基調 (暗い背景 + 十分なコントラストの本文色)
- 色は意味づけにのみ使う (例: Risk = 警告色、完了 = 緑)。無意味な色分けはしない
- 情報伝達に寄与しない装飾を避ける: グラデーション、影、角丸の多用、
  アイコンやアニメーションの過剰使用
- 余白・行間・見出し階層で構造を示す。飾りで埋めない

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
