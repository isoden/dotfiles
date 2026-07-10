-- ===== ステータスライン (lualine) =====
-- 画面下部のバーにモード・Git・診断・ファイル情報などをまとめて表示する。
-- 上部のタブ列は bufferline が担うため、ここでは扱わない。
return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" }, -- セクションのアイコン（要 Nerd Font）
  event = "VeryLazy",                               -- 起動直後の描画は不要なので少し遅延ロード
  opts = {
    options = {
      theme = "auto",           -- colorscheme (tokyonight) に自動追従
      globalstatus = true,      -- 複数ウィンドウでもステータスラインは 1 本に共有
      section_separators = { left = "", right = "" },
      component_separators = { left = "", right = "" },
    },
    sections = {
      lualine_a = { "mode" },                                  -- Normal / Insert 等のモード
      lualine_b = { "branch", "diff", "diagnostics" },         -- Git ブランチ・差分・LSP 診断
      lualine_c = { { "filename", path = 1 } },                -- ファイル名（相対パス付き）
      lualine_x = { "encoding", "fileformat", "filetype" },    -- エンコーディング・改行コード・種別
      lualine_y = { "progress" },                              -- バッファ内の進捗
      lualine_z = { "location" },                              -- カーソル位置（行:列）
    },
  },
}
