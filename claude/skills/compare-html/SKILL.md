---
name: compare-html
description: Output side-by-side comparisons of N approaches, libraries, or design options as a standalone HTML file. Use whenever evaluating tradeoffs between multiple options — architecture approaches, library choices, implementation strategies, API designs, or visual directions. Produces richer output than markdown: multi-column code panels with syntax highlighting, Pro/Con tables, attribute chips, and a clear recommendation box.
effort: max
---

# Compare as HTML

N案の並列比較・選択肢評価を Markdown ではなくスタンドアロン HTML として書き出す。

## なぜ HTML か

複数の選択肢を横並びで比較するとき、Markdown のリスト・テーブルでは視覚的な差が見えにくい。
HTML では各案のコードパネル・Pro/Con・属性チップを横に並べて一覧でき、
意思決定に必要な情報を一画面に凝縮できる。

## 出力規約

- 出力先: `~/.claude/comparisons/<slug>.html`
  - slug 命名: `<topic>-compare`（例: `auth-library-compare`, `db-sharding-compare`）
- ファイルは単独で開ける完全な HTML
- インライン CSS のみ。外部 CDN・外部フォント禁止 (オフラインで開けるように)

## デザインシステム

**必ず読むこと**: `~/.claude/skills/html-design-system/references/design-system.md`

CSS 変数・タイポグラフィ・コンポーネントパターンはすべてそのファイルに定義されている。
コードブロック・バッジ・テーブルパターンを参照すること。

## セクション構成

### ヘッダー

比較の問い（「どの認証ライブラリを採用すべきか？」等）を eyebrow + タイトルで明示する。
背景となるプロジェクト制約・評価軸を簡潔に記す。

### 比較グリッド (メイン)

N案を横並びのカラムで表示する。各カラムに含める要素:

1. **案の名前** — A / B / C ラベルまたはライブラリ名
2. **コードサンプル** — ダークコードパネル（シンタックスハイライト付き）で典型的な使い方を示す
3. **Pro/Con テーブル** — 緑ドット（利点）・赤ドット（欠点）で短く列挙
4. **属性チップ行** — バンドルサイズ・テスタビリティ・学習コスト等をモノスペースラベルで並べる

案が2件なら2列、3件なら3列。4件以上は1列に折り返しても読みやすい。

### 推奨ボックス

比較グリッドの後に1つ置く。
左ボーダーを clay 色にしたカードで推奨案と理由を明示する。
前提条件（「チームが TypeScript に慣れている場合は〜」等）があれば条件とともに書く。
推奨が一意に決まらない場合でも、「X の場合は A、Y の場合は B」という形で整理して書く。

## シンタックスハイライト

コードパネルはダークテーマ（`background: #1A1915`）。
語句クラスは以下を使う（外部ライブラリ不要の CSS クラス方式）:

```css
.kw { color: #C89AF7; }  /* キーワード */
.str { color: #A3D977; } /* 文字列 */
.cm  { color: #5F7A5F; } /* コメント */
.fn  { color: #7BC4E2; } /* 関数名 */
.num { color: #F0C984; } /* 数値 */
```

HTML 側は `<span class="kw">const</span>` のように手動でマークアップする。
全文ハイライトは不要。意図を伝える最小限のコードに絞る。

## コンテンツの選び方

### コード設計の比較

実装パターンを並べる場合は、**同じ機能を各案でどう書くか** を揃えて示す。
文字数を同程度に保ち、どちらが長い・短いかが一目でわかるようにする。

### ライブラリ / ツール選定の比較

バンドルサイズ・メンテナンス状況・エコシステムなど客観的な数値を属性チップで示す。
Pro/Con は主観的な評価（「API が直感的」）よりも具体的な根拠（「型推論が完全に効く」）を優先する。

### ビジュアルデザインの比較

各案を並べたアートボードグリッドにする。
コードパネルの代わりにレンダリングされた UI コンポーネントを表示する。

## やらないこと

- 案の数を無理に増やすこと (2〜4案が適切。それ以上は表が崩れ読みにくくなる)
- Pro/Con を網羅的に列挙すること (各3〜5点に絞る)
- 推奨ボックスを省くこと (結論なき比較は意思決定に使えない)
