-- ===== ファイルツリー (neo-tree) =====
return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",       -- 汎用ユーティリティ
    "nvim-tree/nvim-web-devicons", -- アイコン表示（要 Nerd Font）
    "MunifTanjim/nui.nvim",        -- UI コンポーネント
  },
  -- キー入力 or :Neotree コマンドで初めて読み込む（起動を軽く保つ）
  cmd = "Neotree",
  keys = {
    -- VSCode ライクに Cmd+B でツリーをトグル
    { "<D-b>", "<cmd>Neotree toggle<cr>", mode = { "n", "i", "v", "t" }, desc = "Neo-tree をトグル" },
    -- VSCode ライクに Cmd+Shift+E でツリーにフォーカス（閉じていれば開く）
    { "<D-S-e>", "<cmd>Neotree focus<cr>", mode = { "n", "i", "v", "t" }, desc = "Neo-tree にフォーカス" },
  },
  opts = {
    window = {
      position = "right", -- ツリーを右側に配置
      width = 32,
    },
    filesystem = {
      follow_current_file = { enabled = true }, -- 開いているファイルをツリー上で追従
      use_libuv_file_watcher = true,            -- OS のファイル監視で自動更新
    },
  },
}
