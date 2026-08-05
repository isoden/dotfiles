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
        -- 2026-08-05: hide_dotfiles=false だけでは .env / node_modules / .expo 等が
        -- 消える問題が残っていた。neo-tree のデフォルトは hide_gitignored=true・
        -- hide_ignored=true（defaults.lua）で、これらは hide_dotfiles とは独立に
        -- 効くため。ツリーは「ディスク上の実体をそのまま見るもの」という位置づけに
        -- するので、gitignore 由来の非表示も止める。
        hide_gitignored = false, -- .gitignore 対象も表示
        hide_ignored = false,    -- .ignore / .neotreeignore 対象も表示
        never_show = {
          ".git",      -- .git ディレクトリは常に非表示（H トグルでも表示しない）
          ".DS_Store", -- macOS のメタデータファイルは常に非表示（H トグルでも表示しない）
        },
      },
      window = {
        mappings = {
          -- デフォルトの H は toggle_hidden = filtered_items.visible の反転で、
          -- 上の hide_* 設定を書き換えるわけではない（2026-07-25 のコメントに
          -- 「hide_dotfiles を反転させる」とあったのは誤り。実装は
          -- sources/filesystem/commands.lua の toggle_hidden を参照）。
          -- 上の設定で既に全て表示されるためトグルの用途が無く、ツリー操作中の
          -- 誤爆で表示が揺れるのを避けるため無効化したままにする。
          -- なお "noop" は neo-tree 側で「キーを登録しない」と解釈される
          -- （ui/renderer.lua の falsy mapping 判定）。再表示手段が要るときは
          -- この行を消せば H が復活する。
          ["H"] = "noop",
        },
      },
    },
  },
}
