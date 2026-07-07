-- ===== 行番号 =====
vim.opt.number = true
vim.opt.relativenumber = true

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
