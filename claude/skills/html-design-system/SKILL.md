---
name: html-design-system
description: Shared HTML design system for standalone HTML artifacts. Referenced internally by plan-html, review-html, and other HTML-output skills. Not directly user-invocable — loaded via path reference from sibling skills.
---

# HTML Design System

`plan-html` / `review-html` など HTML 成果物を生成する skill が共通で参照するデザインシステム。

詳細は `references/design-system.md` を参照。

## このファイルの役割

- CSS 変数パレット・タイポグラフィ・コンポーネントパターンを一元管理する
- 派生 skill の SKILL.md から `~/.claude/skills/html-design-system/references/design-system.md` を参照させる
- 新しい HTML 成果物 skill を追加するときは、同じ reference を参照することで一貫したスタイルを保つ

## 派生 skill 一覧

- `plan-html` — 実装計画・設計ドキュメント
- `review-html` — コードレビュー・PR ライトアップ
- `explainer-html` — コード解説・機能 deep-dive・概念説明
- `compare-html` — N案並列比較・ライブラリ選定・設計選択
