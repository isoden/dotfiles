-- ===== ハイライト調整 =====
-- テーマ適用後に行番号の文字色を落として本文と差をつける
local function apply_highlights()
  -- グレースケールで統一。現在行を明るく、他行は暗めにして差をつける。
  -- カスタム statuscolumn では相対番号の行は LineNrAbove/LineNrBelow で
  -- 描画されるため、この2つも揃える必要がある。
  local dim = "#808080"  -- 他の行（relativenumber）: 暗め
  vim.api.nvim_set_hl(0, "LineNr", { fg = dim, bg = "NONE" })
  vim.api.nvim_set_hl(0, "LineNrAbove", { fg = dim, bg = "NONE" })
  vim.api.nvim_set_hl(0, "LineNrBelow", { fg = dim, bg = "NONE" })
  -- 現在行（CursorLineNr）: 明るいグレー。黄色をやめてグレースケールに。
  vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#e0e0e0", bg = "NONE", bold = true })
end
vim.api.nvim_create_autocmd("ColorScheme", { callback = apply_highlights })

-- ===== LSP 診断表示 =====
-- virtual_text は Neovim のデフォルトが false のため、型エラー等をサイン
-- カラムの記号だけでなく行末メッセージでもその場で読めるよう明示的に有効化する。
vim.diagnostic.config({ virtual_text = true })

-- ===== LSP キーマップ =====
-- 言語サーバーがバッファに接続したタイミングで操作キーを割り当てる
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local buf = args.buf
    local function map(keys, fn, desc)
      vim.keymap.set("n", keys, fn, { buffer = buf, desc = desc })
    end
    -- gd/gy はバッファ・タブを切り替えず、フローティングウィンドウで定義元を
    -- プレビューする（goto-preview.lua）。閉じるのは <Esc>。
    map("gd", function() require("goto-preview").goto_preview_definition() end, "定義をプレビュー")
    map("gy", function() require("goto-preview").goto_preview_type_definition() end, "型定義をプレビュー")
    map("<Esc>", function() require("goto-preview").close_all_win() end, "プレビューを閉じる")
    map("gr", vim.lsp.buf.references, "参照を一覧")
    map("<leader>rn", vim.lsp.buf.rename, "シンボル名を変更")
    map("<leader>ca", vim.lsp.buf.code_action, "コードアクション")
    -- K=ホバー, [d/]d=前後の診断へ移動 は Neovim 標準で使えます
  end,
})
