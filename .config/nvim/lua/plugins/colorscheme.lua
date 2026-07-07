-- ===== カラースキーム (tokyonight) =====
return {
  "folke/tokyonight.nvim",
  lazy = false,    -- 起動時に必ず読み込む
  priority = 1000, -- テーマは最優先で読み込む
  opts = {
    transparent = true, -- 背景を透過（手書きの透過処理はこれで不要に）
    styles = {
      sidebars = "transparent",
      floats = "transparent",
    },
  },
  config = function(_, opts)
    require("tokyonight").setup(opts)
    vim.cmd.colorscheme("tokyonight")
  end,
}
