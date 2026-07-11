-- ===== バッファタブ (bufferline) =====
-- キーマップ定義。Cmd+1..9 のタブ番号移動はループで生成する。
local keys = {
  { "<leader>bp", "<cmd>BufferLineTogglePin<cr>",   desc = "タブをピン止め" },
  { "<leader>bo", "<cmd>BufferLineCloseOthers<cr>", desc = "他のタブを全て閉じる" },
  -- ウィンドウレイアウトを保ったままバッファを閉じる（素の :bdelete は最後のバッファだとウィンドウごと消える）
  { "<leader>bd", function() Snacks.bufdelete() end, desc = "タブを閉じる" },
  -- 標準モーション（S-h / S-l）は潰さず、bracket 系でタブを移動する
  { "]b",         "<cmd>BufferLineCycleNext<cr>",   desc = "次のタブへ" },
  { "[b",         "<cmd>BufferLineCyclePrev<cr>",   desc = "前のタブへ" },
}

-- VSCode ライクに Cmd+1..8 で N 番目、Cmd+9 で最後のタブへ移動する。
-- （VSCode の挙動に合わせ 9 は「最後のタブ」= GoToBuffer -1。
--   Ghostty が <D-*> を Neovim へ渡す前提。既存の <D-b> と同じ経路）
for i = 1, 9 do
  local target = i == 9 and -1 or i
  table.insert(keys, {
    "<D-" .. i .. ">",
    "<cmd>BufferLineGoToBuffer " .. target .. "<cr>",
    mode = { "n", "i", "v", "t" },
    desc = i == 9 and "最後のタブへ" or ("タブ " .. i .. " へ"),
  })
end

return {
  "akinsho/bufferline.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons", -- タブのファイルアイコン（要 Nerd Font）
    "folke/snacks.nvim",           -- Snacks.bufdelete() でウィンドウレイアウトを保ったままタブを閉じる
  },
  event = "VeryLazy",                               -- 起動直後の描画は不要なので少し遅延ロード
  keys = keys,
  opts = {
    options = {
      mode = "buffers",         -- 開いているバッファをタブとして並べる
      diagnostics = "nvim_lsp", -- LSP の診断をタブにアイコン表示
      -- タブ右肩に診断件数を出す（例: "2  1 ")
      diagnostics_indicator = function(_, _, diagnostics_dict)
        local s = ""
        for level, count in pairs(diagnostics_dict) do
          local icon = level == "error" and " " or (level == "warning" and " " or " ")
          s = s .. " " .. count .. icon
        end
        return s
      end,
      separator_style = "thin", -- タブ区切りを細い線に
      -- タブの x クリック/マウス右クリックでも同じ close_command を通す
      close_command = function(n) Snacks.bufdelete(n) end,
      right_mouse_command = function(n) Snacks.bufdelete(n) end,
      -- Neo-tree は右配置（neo-tree.lua で position="right"）。
      -- その幅ぶんタブ列をずらしてファイラーと重ならないようにする。
      offsets = {
        {
          filetype = "neo-tree",
          text = "File Explorer",
          highlight = "Directory",
          text_align = "left",
          separator = true,
        },
      },
    },
  },
}
