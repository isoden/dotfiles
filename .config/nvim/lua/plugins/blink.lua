-- ===== 補完ポップアップ (blink.cmp) =====
return {
  "saghen/blink.cmp",
  dependencies = { "rafamadriz/friendly-snippets" }, -- 定番スニペット集
  version = "1.*",                                   -- 事前ビルド済みバイナリを利用（Rust 不要）
  opts = {
    -- 補完中: <CR>確定 / <C-e>閉じる / <C-n><C-p>で選択 / <C-space>手動表示
    -- preselect（先頭候補の自動選択）はデフォルトの true のままなので、
    -- メニュー表示中の <CR> は改行にならず必ず先頭候補が確定される。
    -- 改行したい場合は <C-e> でメニューを閉じてから Enter を押す。
    keymap = { preset = "enter" },
    sources = { default = { "lsp", "path", "snippets", "buffer" } },
    completion = {
      documentation = { auto_show = true }, -- 候補のドキュメントを自動表示
    },
  },
  -- LSP に「blink による補完能力」を伝える（全サーバー共通）
  config = function(_, opts)
    require("blink.cmp").setup(opts)
    vim.lsp.config("*", { capabilities = require("blink.cmp").get_lsp_capabilities() })
  end,
}
