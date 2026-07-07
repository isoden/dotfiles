-- ===== HTML/JSX タグの自動クローズ・リネーム (nvim-ts-autotag) =====
-- <div> と打つと </div> を自動挿入。開きタグを変更すると閉じタグも追従。
-- nvim-treesitter のパーサに依存する。
return {
  "windwp/nvim-ts-autotag",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  ft = {
    "html",
    "xml",
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
  },
  opts = {},
}
