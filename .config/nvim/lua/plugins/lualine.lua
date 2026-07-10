-- ===== ステータスライン (lualine) =====
-- 画面下部のバーにモード・Git・診断・ファイル情報などをまとめて表示する。
-- 上部のタブ列は bufferline が担うため、ここでは扱わない。

-- blame コンポーネントをクリックしたとき、その行の commit を GitHub で開く。
-- gitsigns が current_line_blame 有効時に b:gitsigns_blame_line_dict へ格納する
-- コミット情報（abbrev_sha=7桁）を使う。GitHub は短縮ハッシュでも該当コミットへ解決する。
local function open_blame_commit_on_github()
  local dict = vim.b.gitsigns_blame_line_dict
  local sha = dict and dict.abbrev_sha
  -- 未コミット行は sha が nil か全ゼロなので開かない
  if not sha or sha:match("^0+$") then
    vim.notify("未コミットの行です", vim.log.levels.INFO)
    return
  end
  -- 開いているファイルのディレクトリでリモートを引く（CWD 依存を避ける）
  local dir = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":h")
  local remote = vim.fn.systemlist({ "git", "-C", dir, "remote", "get-url", "origin" })[1]
  if not remote or not remote:match("github%.com") then
    vim.notify("GitHub の origin リモートが見つかりません", vim.log.levels.WARN)
    return
  end
  -- git@github.com:owner/repo.git / https://github.com/owner/repo(.git) → owner/repo
  local slug = remote
    :gsub("^git@github%.com:", "")
    :gsub("^https://github%.com/", "")
    :gsub("%.git$", "")
  vim.ui.open(("https://github.com/%s/commit/%s"):format(slug, sha))
end

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
      lualine_c = {
        { "filename", path = 1 },                             -- ファイル名（相対パス付き）
        {
          -- 現在行の git blame。gitsigns が current_line_blame 有効時に
          -- b:gitsigns_blame_line へ書き込む値をそのまま表示する（gitsigns.lua を参照）。
          function()
            return vim.b.gitsigns_blame_line or ""
          end,
          cond = function()
            local b = vim.b.gitsigns_blame_line
            return b ~= nil and b ~= ""
          end,
          icon = "",             -- git commit アイコン（要 Nerd Font）
          color = "Comment",      -- テーマの Comment 色に追従させ控えめに見せる
          on_click = function()   -- クリックで該当 commit を GitHub で開く
            open_blame_commit_on_github()
          end,
        },
      },
      lualine_x = { "encoding", "fileformat", "filetype" },    -- エンコーディング・改行コード・種別
      lualine_y = { "progress" },                              -- バッファ内の進捗
      lualine_z = { "location" },                              -- カーソル位置（行:列）
    },
  },
}
