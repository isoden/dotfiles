-- ===== LSP (補完・エラー表示) =====
return {
  -- mason: 言語サーバーを nvim 内から自動インストールするツール
  { "mason-org/mason.nvim", opts = {} },
  -- mason-lspconfig: mason と lspconfig を橋渡し。ensure_installed のサーバーを
  -- 自動でインストール＆有効化してくれる
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
      "mason-org/mason.nvim",
      "neovim/nvim-lspconfig", -- 各言語サーバーのデフォルト設定集
    },
    opts = {
      -- TypeScript / JavaScript 用サーバー（初回起動時に自動インストール）
      ensure_installed = { "ts_ls" },
    },
  },
}
