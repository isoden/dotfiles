# HTML Design System — Shared Reference

Claude Code が生成するスタンドアロン HTML 成果物に共通のデザインシステム。
`plan-html` / `review-html` など派生 skill で参照する。

Source: https://claude.com/blog/using-claude-code-the-unreasonable-effectiveness-of-html
Examples: https://thariqs.github.io/html-effectiveness/

---

## CSS 変数 (必須・色を勝手に変えない)

```css
:root {
  --ivory:    #FAF9F5;   /* ページ背景 */
  --slate:    #141413;   /* 見出し・強調 */
  --clay:     #D97757;   /* アクセント (アクティブ・重要) */
  --oat:      #E3DACC;   /* セカンダリ背景・ウォームハイライト */
  --olive:    #788C5D;   /* 完了・成功 */
  --rust:     #B04A3F;   /* 危険・エラー */
  --gray-100: #F0EEE6;   /* テーブルヘッダ・サブtle背景 */
  --gray-300: #D1CFC5;   /* ボーダー */
  --gray-500: #87867F;   /* 補助テキスト・ラベル */
  --gray-700: #3D3D3A;   /* 本文テキスト */
  --white:    #FFFFFF;   /* カード・パネル背景 */

  --serif: ui-serif, Georgia, 'Times New Roman', serif;
  --sans:  system-ui, -apple-system, 'Segoe UI', Roboto, sans-serif;
  --mono:  ui-monospace, 'SF Mono', Menlo, Monaco, Consolas, monospace;
}
```

**基調はライトモード** — ページ全体の背景は `--ivory`、カードは `--white`。
コードブロックのみ `--slate` 背景を使う。それ以外でダーク背景は使わない。

---

## ページレイアウト

```css
* { margin: 0; padding: 0; box-sizing: border-box; }
body {
  font-family: var(--sans);
  background: var(--ivory);
  color: var(--gray-700);
  line-height: 1.6;
  padding: 56px 24px 120px;
  -webkit-font-smoothing: antialiased;
}
.page { max-width: 860px; margin: 0 auto; }
/* 横並びコンテンツが多い場合: max-width: 1120px */
section { margin-bottom: 52px; }
```

---

## タイポグラフィ

| 要素 | フォント | サイズ | 備考 |
|---|---|---|---|
| h1 | `--serif` | 36–38px | font-weight 500, letter-spacing: -0.01em |
| h2 | `--serif` | 24–26px | font-weight 500 |
| 本文 | `--sans` | 14–15px | color: gray-700 |
| ラベル・タグ | `--mono` | 11–12px | uppercase, letter-spacing: 0.06em, gray-500 |
| コード | `--mono` | 12–13px | |

---

## ボーダー・角丸

```css
/* パネル・カード */
border: 1.5px solid var(--gray-300);
border-radius: 12px;

/* インライン要素 (バッジ・タグ) */
border-radius: 6px;

/* テーブルは border-collapse: separate で角丸を効かせる */
border-collapse: separate; border-spacing: 0;
border-radius: 12px; overflow: hidden;
```

---

## コンポーネントパターン

### セクションヘッダー (番号付き)

```html
<div style="display:flex; align-items:baseline; gap:14px; margin-bottom:8px;">
  <span style="font-family:var(--mono); font-size:12px; background:var(--oat);
    color:var(--slate); padding:3px 9px; border-radius:8px;">01</span>
  <h2 style="font-family:var(--serif); font-weight:500; font-size:26px; color:var(--slate);">
    Section Title
  </h2>
</div>
<p style="font-size:14.5px; color:var(--gray-500); max-width:720px; margin-bottom:28px;">
  説明文
</p>
```

### サマリーストリップ

```html
<div style="display:grid; grid-template-columns:repeat(4,1fr); gap:16px; margin-bottom:48px;">
  <div style="background:var(--white); border:1.5px solid var(--gray-300);
    border-radius:12px; padding:18px 20px;">
    <div style="font-family:var(--mono); font-size:11px; text-transform:uppercase;
      letter-spacing:0.06em; color:var(--gray-500); margin-bottom:6px;">Label</div>
    <div style="font-size:17px; color:var(--clay); font-weight:600;">Value</div>
  </div>
</div>
```

### タイムライン / Steps

```html
<!-- 1エントリ = 3カラム: 日付 | ドット+縦線 | コンテンツ -->
<div style="display:grid; grid-template-columns:120px 28px 1fr; gap:0 18px;">
  <div style="text-align:right; font-family:var(--mono); font-size:12px;
    color:var(--gray-500); padding-top:4px;">Week 1</div>
  <div style="display:flex; flex-direction:column; align-items:center;">
    <!-- 完了: background:var(--olive); border-color:var(--olive) -->
    <!-- 未着手: background:var(--white); border:3px solid var(--clay) -->
    <div style="width:14px; height:14px; border-radius:50%; background:var(--white);
      border:3px solid var(--clay); margin-top:4px; flex-shrink:0;"></div>
    <div style="width:2px; flex:1; background:var(--gray-300); margin:4px 0;"></div>
  </div>
  <div style="padding-bottom:36px;">
    <h3 style="font-family:var(--serif); font-weight:500; font-size:19px;
      color:var(--slate); margin-bottom:4px;">Milestone Title</h3>
    <p style="font-size:14px; color:var(--gray-500);">説明</p>
  </div>
</div>
```

### リスクテーブル

重要度バッジ配色:
- HIGH → `background:#F3D9CC; color:#8A3B1E`
- MED  → `background:var(--oat); color:var(--slate)`
- LOW  → `background:#E4E9DC; color:#4B5C39`

```html
<div style="border:1.5px solid var(--gray-300); border-radius:12px;
  overflow:hidden; background:var(--white);">
  <!-- ヘッダー -->
  <div style="display:grid; grid-template-columns:1.6fr 90px 1.6fr;">
    <div style="padding:14px 18px; background:var(--gray-100); font-size:12px;
      font-weight:600; text-transform:uppercase; letter-spacing:0.04em; color:var(--slate);">Risk</div>
    <div style="padding:14px 18px; background:var(--gray-100);
      border-left:1.5px solid var(--gray-300); font-size:12px; font-weight:600;
      text-transform:uppercase; letter-spacing:0.04em; color:var(--slate);">Sev</div>
    <div style="padding:14px 18px; background:var(--gray-100);
      border-left:1.5px solid var(--gray-300); font-size:12px; font-weight:600;
      text-transform:uppercase; letter-spacing:0.04em; color:var(--slate);">Mitigation</div>
  </div>
  <!-- データ行 -->
  <div style="display:grid; grid-template-columns:1.6fr 90px 1.6fr;
    border-top:1.5px solid var(--gray-300);">
    <div style="padding:14px 18px; font-size:13.5px;">リスクの説明</div>
    <div style="padding:14px 18px; border-left:1.5px solid var(--gray-300);">
      <span style="font-family:var(--mono); font-size:11px; padding:2px 8px;
        border-radius:6px; font-weight:600; background:#F3D9CC; color:#8A3B1E;">HIGH</span>
    </div>
    <div style="padding:14px 18px; border-left:1.5px solid var(--gray-300);
      font-size:13.5px;">緩和策</div>
  </div>
</div>
```

### Open Questions カード

```html
<div style="background:var(--white); border:1.5px solid var(--gray-300);
  border-left:4px solid var(--clay); border-radius:10px; padding:16px 20px; margin-bottom:14px;">
  <div style="font-weight:600; font-size:15px; color:var(--slate); margin-bottom:4px;">
    質問タイトル
  </div>
  <div style="font-size:13.5px; color:var(--gray-500);">詳細・背景・選択肢</div>
  <div style="font-family:var(--mono); font-size:11.5px; color:var(--gray-500); margin-top:8px;">
    Decide with · 関係者, タイミング
  </div>
</div>
```

### コードブロック

```html
<div style="background:var(--slate); border-radius:12px; padding:18px 20px; overflow-x:auto;">
  <div style="font-family:var(--mono); font-size:12px; color:var(--gray-500); margin-bottom:10px;">
    path/to/file.ts
  </div>
  <pre style="font-family:var(--mono); font-size:12.5px; line-height:1.65;
    color:#E8E6DE; white-space:pre; margin:0;">
    <!-- keywords: #D97757 (clay), strings: #788C5D (olive), comments: #87867F -->
  </pre>
</div>
```

### diff 表示

```html
<div style="background:var(--slate); border-radius:12px; padding:18px 20px; overflow-x:auto;">
  <span style="font-family:var(--mono); font-size:12px; color:var(--gray-500);
    display:block; margin-bottom:10px;">path/to/file.ts</span>
  <!-- ctx行: color:#D1CFC5 (gray-300) -->
  <!-- del行: color:#E0897A (赤み) -->
  <!-- add行: color:#A3B88A (緑み) -->
  <div style="font-family:var(--mono); font-size:13px; line-height:1.7;
    color:#D1CFC5; white-space:pre;">- 削除行</div>
  <div style="font-family:var(--mono); font-size:13px; line-height:1.7;
    color:#A3B88A; white-space:pre;">+ 追加行</div>
</div>
```

### 重要度バッジ (汎用)

```html
<!-- pill スタイル (SEV/STATUS 等) -->
<span style="display:inline-flex; align-items:center; gap:6px; font-size:12px;
  font-weight:600; border-radius:999px; padding:5px 12px;
  background:var(--clay); color:var(--white);">HIGH</span>

<!-- タグスタイル (ファイル名・ラベル等) -->
<span style="font-family:var(--mono); font-size:11.5px;
  background:var(--gray-100); border:1px solid var(--gray-300);
  border-radius:6px; padding:3px 8px; color:var(--gray-700);">tag</span>
```

### SVG ダイアグラム

- ボックス: `fill="#FFFFFF" stroke="#D1CFC5"` rx="10"
- アクティブ/重要: `fill="#141413"` テキスト `fill="#FAF9F5"`
- 矢印: `stroke="#87867F"`。強調パス: `stroke="#D97757" stroke-dasharray="5 4"`
- テキスト: `font-family="ui-monospace" font-size="12"` または 10.5
- エッジラベル: `font-size="10.5" fill="#87867F"`

---

## 色の使い方の原則

- clay (#D97757): アクティブ状態・重要な数値・警告・アクセントリンク
- olive (#788C5D): 完了・成功・低リスク
- rust (#B04A3F): エラー・危険
- oat (#E3DACC): セカンダリ背景・中程度の強調
- gray-500 (#87867F): ラベル・補助テキスト・非強調情報
- 意味のない装飾に色を使わない
