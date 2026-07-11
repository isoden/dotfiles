-- ===== goto-preview: LSP の定義/型定義をフローティングウィンドウでプレビュー =====
-- タブやバッファを切り替えずに定義元を一時的に覗きたいためのプラグイン。
-- キーマップは default_mappings を使わず、autocmds.lua の LspAttach 側で
-- gd/gy に割り当てて一本化する（LSP 用キーマップの管理場所を分散させない）。
return {
  "rmagatti/goto-preview",
  dependencies = { "rmagatti/logger.nvim" },
  event = "BufEnter",
  opts = {
    default_mappings = false,
    -- プレビューウィンドウ内で gf を押すと、プレビューを閉じて元のウィンドウで
    -- 同じバッファ・カーソル位置を実際に開き直す（close_all_win はフォーカスを
    -- 呼び出し元ウィンドウへ自動的に戻すので、それを利用している）。
    -- goto-preview が vim.fn.bufadd() 等で開くバッファは buflisted=false のため、
    -- そのまま :buffer しても bufferline(mode="buffers") には新規タブとして
    -- 現れず、元のタブの中身だけが差し替わって見える。true にしてから開く。
    post_open_hook = function(buf, win)
      vim.keymap.set("n", "gf", function()
        local cursor = vim.api.nvim_win_get_cursor(win)
        vim.bo[buf].buflisted = true
        require("goto-preview").close_all_win()
        vim.cmd.buffer(buf)
        vim.api.nvim_win_set_cursor(0, cursor)
      end, { buffer = buf, desc = "プレビューを実ウィンドウで開く" })
    end,
  },
}
