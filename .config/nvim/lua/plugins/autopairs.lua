-- ===== カッコの自動補完 (nvim-autopairs) =====
-- ( [ { " ' などを入力すると対の閉じカッコを自動挿入
return {
  "windwp/nvim-autopairs",
  event = "InsertEnter", -- 挿入モードに入った時に読み込む
  opts = {},
}
