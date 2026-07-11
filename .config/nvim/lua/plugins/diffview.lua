-- ===== Git 差分ビューア (diffview) =====
-- 左サイドバーに変更ファイル一覧、メインペインに選択ファイルの diff を表示する。
-- ファイルパネル操作: <cr>/o/l で diff を開く、gf で実ファイルへジャンプ（編集用）。
return {
  "sindrets/diffview.nvim",
  cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
  keys = {
    -- 開閉トグル。:DiffviewOpen は呼ぶたびに新しい tabpage を積み重ねるだけで閉じてくれない。
    -- また diffview 内で :q や q（パネルフォーカス時の close）を叩いてもパネルの
    -- ウィンドウが閉じるだけで diff ペインは残る（Panel:close() の仕様。neo-tree を閉じても
    -- Neovim 自体は終わらないのと同じ設計）。確実に全部閉じるには DiffviewClose を使う必要が
    -- あるため、開いているかどうかで呼び分ける。
    {
      "<leader>gs",
      function()
        if require("diffview.lib").get_current_view() then
          vim.cmd("DiffviewClose")
        else
          vim.cmd("DiffviewOpen")
        end
      end,
      desc = "git 変更ファイル一覧 + diff (toggle)",
    },
  },
  config = function()
    require("diffview").setup()

    -- diffview はファイルパネルで diff を覗いただけのファイルも、LSP 等を正常動作させるため
    -- 実バッファとして buflisted=true にする（vcs/file.lua の _create_local_buffer 参照）。
    -- ファイルを切り替えると同じウィンドウのバッファが差し替わるだけなので、直前まで見ていた
    -- ファイルは「どのウィンドウにも表示されていない listed バッファ」として残り、bufferline
    -- (mode="buffers") のタブにどんどん積み上がってしまう（本家 issue でも未解決:
    -- https://github.com/sindrets/diffview.nvim/pull/477）。
    -- `DiffviewDiffBufRead` は diff ウィンドウに新しいファイルが読み込まれる度に発火し、
    -- その時点で args.buf は今読み込まれたバッファを指すため、これを使って
    -- 「直前まで表示していたファイル」を編集中・他ウィンドウ表示中でなければ都度 unlist する。
    -- gf 等で diffview 外に明示的に開いたファイルはその時点で他ウィンドウ表示があるため残る。
    local prev_bufnr = nil

    local function unlist_if_orphaned(bufnr)
      if not bufnr or not vim.api.nvim_buf_is_valid(bufnr) then return end
      if vim.bo[bufnr].modified then return end
      if #vim.fn.win_findbuf(bufnr) > 0 then return end
      vim.bo[bufnr].buflisted = false
    end

    vim.api.nvim_create_autocmd("User", {
      pattern = "DiffviewDiffBufRead",
      callback = function(args)
        unlist_if_orphaned(prev_bufnr)
        prev_bufnr = args.buf
      end,
    })

    vim.api.nvim_create_autocmd("User", {
      pattern = "DiffviewViewClosed",
      callback = function()
        unlist_if_orphaned(prev_bufnr)
        prev_bufnr = nil
      end,
    })
  end,
}
