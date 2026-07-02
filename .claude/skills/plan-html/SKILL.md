---
name: plan-html
description: Output the plan-mode plan as a standalone HTML file and (when running under cmux) open it in a cmux browser surface for review. Use whenever entering plan mode, updating an in-progress plan, or about to call ExitPlanMode.
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

## ExitPlanMode との関係

ExitPlanMode のテキストには必ず次を含める (`$HOME` は実パスに展開した値で書く):

```
詳細プラン: file://$HOME/.claude/plans/<slug>.html
```

そのうえで 3〜6 行の要約を書く。長い説明は HTML 側に寄せる。

## cmux 連携

環境変数 `CMUX_BUNDLE_ID` が定義されている (= cmux 配下で実行されている) ときのみ以下を行う:

### 初回出力時

```bash
cmux --json browser open "file://$HOME/.claude/plans/<slug>.html"
# 返ってきた surface:N を以降の更新でも使い回す
```

surface 番号は会話のメモとして覚えておく (ファイル名と紐付けて保持)。

### プラン更新時

同じ surface を再 navigate してリロードする (新規タブを開かない):

```bash
cmux browser surface:N open "file://$HOME/.claude/plans/<slug>.html"
```

`open` を同じ URL で再実行すれば該当 surface が再読込される。
新しいタブを増やさないこと。

### `CMUX_BUNDLE_ID` が未定義の環境

HTML 出力だけ行い、ブラウザ操作はスキップする。
ユーザーに「`file://...` を開いてください」と一行案内する。

## やらないこと

- plan モードを抜けた後の進捗報告を HTML に書き戻すこと (HTML は計画のスナップショット)
- 複数の `surface:` を同時に開くこと
- ExitPlanMode 本文に HTML の中身を丸ごとコピペすること (パスだけでよい)
