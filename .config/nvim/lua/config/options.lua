-- ===== リーダーキー =====
-- キーマップ定義より前に設定する必要があるため先頭に置く
-- （init.lua で config.options を config.lazy より先に require している）。
vim.g.mapleader = " "      -- <leader> を Space に
vim.g.maplocalleader = " " -- <localleader> も Space に

-- ===== 行番号 =====
vim.opt.number = true
vim.opt.relativenumber = true

-- カレント行だけ番号色を変える（CursorLineNr）ために cursorline を有効化。
-- cursorlineopt=number で行背景は光らせず、番号カラムのみ対象にする。
vim.opt.cursorline = true
vim.opt.cursorlineopt = "number"

-- 行番号カラムを自前で組む（ソースコード側に余白）
vim.opt.statuscolumn = "%s%=%{v:relnum ? v:relnum : v:lnum}%#Normal#  "

-- ===== インデント設定 =====
vim.opt.expandtab = true   -- Tab をスペースに展開
vim.opt.shiftwidth = 2     -- 自動インデント / >> << の幅（← 4 にしたい場合はここを変更）
vim.opt.tabstop = 2        -- Tab 文字の見た目の幅
vim.opt.softtabstop = 2    -- Tab / Backspace キーで増減するスペース数
vim.opt.breakindent = true -- 折り返した行も見た目のインデントを維持
-- NOTE: autoindent は Neovim 標準で ON。言語ごとの細かいインデントは
--       filetype indent（標準で有効）が担当するため smartindent は基本不要。

-- ===== マウススクロール無効化 =====
-- クリックや選択は残しつつ、ホイールスクロールだけを潰す。
-- （マウス自体を完全に無効化したい場合は vim.opt.mouse = "" にする）
for _, key in ipairs({
  "<ScrollWheelUp>", "<ScrollWheelDown>", "<ScrollWheelLeft>", "<ScrollWheelRight>",
  "<S-ScrollWheelUp>", "<S-ScrollWheelDown>", "<S-ScrollWheelLeft>", "<S-ScrollWheelRight>",
  "<C-ScrollWheelUp>", "<C-ScrollWheelDown>", "<C-ScrollWheelLeft>", "<C-ScrollWheelRight>",
}) do
  vim.keymap.set({ "n", "i", "v", "c" }, key, "<Nop>")
end
