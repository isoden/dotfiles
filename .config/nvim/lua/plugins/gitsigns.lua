-- ===== Git 差分表示 (gitsigns) =====
-- 行左端の差分サイン（追加・変更・削除）と、現在行の git blame を提供する。
-- blame は行末の virtual text ではなく lualine のコンポーネントに出したいので、
-- current_line_blame は有効にしつつ virt_text は無効化する。
-- 有効化すると gitsigns が現在行の blame を b:gitsigns_blame_line に書き込むため、
-- これを lualine 側で読み取る（lualine.lua を参照）。
return {
  "lewis6991/gitsigns.nvim",
  event = "VeryLazy",
  opts = {
    current_line_blame = true, -- b:gitsigns_blame_line を有効化（lualine で使用）
    current_line_blame_opts = {
      virt_text = false, -- 行末表示はせず lualine に集約する
      delay = 300,       -- カーソル停止からこの ms 後に blame を算出
    },
    -- b:gitsigns_blame_line のフォーマット。先頭に短縮ハッシュ（7桁）を出す。
    -- 未コミット行では "You, Not Committed Yet" 等になる。
    current_line_blame_formatter = "<abbrev_sha> <author>, <author_time:%Y-%m-%d> · <summary>",
  },
}
