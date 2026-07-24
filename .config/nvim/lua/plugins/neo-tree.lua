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
  -- init は遅延ロードの有無に関わらず起動時に必ず実行される（lazy.nvim の仕様）。
  -- ここで VimEnter フックだけ先に登録しておき、実際のプラグイン本体は
  -- 発火時に :Neotree コマンド経由で遅延ロードさせる。
  init = function()
    vim.api.nvim_create_autocmd("VimEnter", {
      once = true,
      -- VimEnter 直後は他プラグイン（dashboard 等）のバッファ/ウィンドウ確定より
      -- 早く走ることがあり、その状態で開くとエラーになることがあるため
      -- schedule で1 tick 遅らせる（コミュニティで広く使われる回避策）。
      callback = vim.schedule_wrap(function()
        vim.cmd("Neotree show")
      end),
    })
  end,
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
      filtered_items = {
        hide_dotfiles = false, -- ドット始まりの不可視ファイルも常に表示
        never_show = {
          ".git",      -- .git ディレクトリは常に非表示（H トグルでも表示しない）
          ".DS_Store", -- macOS のメタデータファイルは常に非表示（H トグルでも表示しない）
        },
      },
      window = {
        mappings = {
          -- デフォルトの H (toggle_hidden) はランタイムで hide_dotfiles を反転させ、
          -- 上の hide_dotfiles=false を無効化してしまう。誤操作で不可視ファイルが
          -- 消えるのを防ぐため、このトグル自体を無効化する（2026-07-25）。
          ["H"] = "noop",
        },
      },
    },
  },
}
