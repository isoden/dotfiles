-- ===== ファジーファインダー / 全文検索 (fzf-lua) =====
-- fzf + ripgrep を使った高速検索。VSCode の Cmd+Shift+F（全文検索）に相当。
-- 前提: `fzf` と `rg`(ripgrep) がインストール済みであること。
return {
  "ibhagwan/fzf-lua",
  dependencies = {
    "nvim-tree/nvim-web-devicons", -- アイコン表示（要 Nerd Font）
  },
  -- キー入力 or :FzfLua コマンドで初めて読み込む（起動を軽く保つ）
  cmd = "FzfLua",
  keys = {
    -- VSCode ライクに Cmd+Shift+F でプロジェクト全体を全文検索（grep）
    { "<D-S-f>", "<cmd>FzfLua live_grep<cr>", mode = { "n", "i" }, desc = "ファイル内容を全文検索 (live_grep)" },
    -- VSCode ライクに Cmd+P でファイル名検索
    { "<D-p>", "<cmd>FzfLua files<cr>", mode = { "n", "i" }, desc = "ファイルを検索 (files)" },
    -- カーソル下の単語をそのまま全文検索
    { "<D-S-f>", "<cmd>FzfLua grep_visual<cr>", mode = "x", desc = "選択範囲を全文検索" },
  },
  opts = {
    winopts = {
      preview = {
        layout = "vertical", -- プレビューを下に縦並び表示
      },
    },
  },
}
