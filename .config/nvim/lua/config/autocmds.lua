-- ===== ハイライト調整 =====
-- テーマ適用後に行番号の文字色を落として本文と差をつける
local function apply_highlights()
  vim.api.nvim_set_hl(0, "LineNr", { fg = "#6c6c6c", bg = "NONE" })
end
vim.api.nvim_create_autocmd("ColorScheme", { callback = apply_highlights })

-- ===== LSP キーマップ =====
-- 言語サーバーがバッファに接続したタイミングで操作キーを割り当てる
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local buf = args.buf
    local function map(keys, fn, desc)
      vim.keymap.set("n", keys, fn, { buffer = buf, desc = desc })
    end
    map("gd", vim.lsp.buf.definition, "定義へジャンプ")
    map("gr", vim.lsp.buf.references, "参照を一覧")
    map("<leader>rn", vim.lsp.buf.rename, "シンボル名を変更")
    map("<leader>ca", vim.lsp.buf.code_action, "コードアクション")
    -- K=ホバー, [d/]d=前後の診断へ移動 は Neovim 標準で使えます
  end,
})
