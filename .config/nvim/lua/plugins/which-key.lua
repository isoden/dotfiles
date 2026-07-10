-- ===== キーマップヘルプ (which-key) =====
-- リーダーキー等を押した後に、続けて押せるキーの候補を desc 付きでポップアップ表示する。
return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy", -- 起動直後は不要なので遅延ロード
    opts = {
      preset = "modern", -- ポップアップの見た目をモダンプリセットに
    },
    keys = {
      -- <leader>? で現在のバッファに効くキーマップ一覧を表示
      { "<leader>?", function() require("which-key").show({ global = false }) end, desc = "Buffer keymaps" },
    },
  },
}
