-- ===== インデントガイド / 括弧の虹色ハイライト =====
-- indent-blankline: 縦線でインデント階層を可視化し、カーソル位置のスコープを強調。
-- rainbow-delimiters: 対応する括弧を階層ごとに色分けする。
-- どちらもキーマップ無し・ファイル読み込み時に自動適用。
return {
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",                              -- setup 対象は "ibl" モジュール
    event = { "BufReadPre", "BufNewFile" },    -- 実ファイルを開いた時だけロード
    opts = {
      indent = { char = "│" },
      scope = {
        enabled = true,
        show_start = true,  -- スコープ開始行に下線を引く
        show_end = false,
      },
      -- ファイラーやダッシュボード等ではガイド線が邪魔なので除外。
      -- snacks_dashboard はこの環境のダッシュボード (dashboard.lua) の filetype。
      exclude = {
        filetypes = { "help", "neo-tree", "lazy", "mason", "snacks_dashboard" },
      },
    },
  },
  {
    "HiPhish/rainbow-delimiters.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("rainbow-delimiters.setup").setup({
        -- この順で括弧の入れ子を色分けする（色は rainbow-delimiters が定義）
        highlight = {
          "RainbowDelimiterRed",
          "RainbowDelimiterYellow",
          "RainbowDelimiterBlue",
          "RainbowDelimiterOrange",
          "RainbowDelimiterGreen",
          "RainbowDelimiterViolet",
          "RainbowDelimiterCyan",
        },
      })
    end,
  },
}
