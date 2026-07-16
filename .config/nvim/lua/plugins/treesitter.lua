-- ===== 構文解析 & シンタックスハイライト (nvim-treesitter) =====
-- nvim-ts-autotag が依存。HTML/JSX などのパーサを提供する。
return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  build = ":TSUpdate",
  event = { "BufReadPost", "BufNewFile" },
  opts = {
    -- autotag が効く Web 系パーサを自動インストール
    ensure_installed = {
      "html",
      "xml",
      "css",
      "javascript",
      "typescript",
      "tsx",
    },
    auto_install = true,
    highlight = { enable = true },
    indent = { enable = true },
  },
  config = function(_, opts)
    require("nvim-treesitter.configs").setup(opts)
  end,
}
