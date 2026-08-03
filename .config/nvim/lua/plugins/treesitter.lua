-- ===== 構文解析 & シンタックスハイライト (nvim-treesitter / main ブランチ) =====
-- nvim-ts-autotag が依存。HTML/JSX などのパーサを提供する。
--
-- 2026-08-04 master → main へ移行。master は 2026-03 で凍結されており Neovim 0.12 と非互換。
-- 具体的には nvim 0.12 の vim.treesitter.query.add_predicate が `all` オプションを廃止し、
-- 述語ハンドラに渡る match[capture_id] が TSNode 単体から TSNode[] に変わったが、master 側の
-- query_predicates.lua は単体 TSNode を前提に node:type() を呼ぶため例外が出る。この述語
-- (#not-kind-eq?) は queries/ecma/indents.scm で使われ typescript が継承するので、TS/TSX で
-- インデントクエリの走査ごと落ち、indentexpr が常に 0 を返してインデントが効かなくなっていた。
--
-- main は完全な書き直しで master と API 互換性が無い（nvim-treesitter.configs は存在しない）。
-- highlight / indent は「モジュール」ではなく素の Neovim 機能として自前で有効化する。
return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  -- main は lazy-loading を明示的に非サポート（README の Installation 節）。
  -- event 指定で遅延させると壊れるため lazy = false で常時ロードする。
  lazy = false,
  -- プラグイン更新時にパーサも追従させないと壊れる旨が README に明記されている。
  build = ":TSUpdate",
  config = function()
    -- install_dir はデフォルト（stdpath("data")/site）のままで良いが、
    -- setup を呼ばないと runtimepath への prepend が走らないため明示的に呼ぶ。
    require("nvim-treesitter").setup({})

    -- master の ensure_installed 相当。非同期実行で、導入済みなら no-op。
    -- main には master の auto_install（開いたファイルタイプのパーサを自動導入する機能）が
    -- 無いため、必要なパーサはすべてここに明示列挙する必要がある。
    -- 一覧は移行時点で master が自動導入していた 22 個から、Neovim 同梱分
    -- （c / lua / markdown / markdown_inline / query / vim / vimdoc）を除いたもの。
    -- 新しい言語を扱うようになったらここに追記する。
    require("nvim-treesitter").install({
      -- autotag が効く Web 系
      "html",
      "xml",
      "css",
      "javascript",
      "typescript",
      "tsx",
      "vue",
      "astro",
      -- 設定ファイル・データ形式
      -- jsonc は main のサポート対象から外れており、宣言すると起動時に
      -- "skipping unsupported language: jsonc" の警告が出る。jsonc ファイルタイプは
      -- vim.treesitter.language.get_lang("jsonc") == "json" で json パーサにマップされる。
      "json",
      "yaml",
      "toml",
      "git_config",
      "gitignore",
      -- その他
      "bash",
      "ruby",
      "glsl",
    })

    -- master の highlight / indent モジュール相当。main には無いので FileType で自前設定する。
    -- パーサ未導入のファイルタイプでは vim.treesitter.start() が例外を投げるため pcall で守る
    -- （master の auto_install に相当する自動導入は main には無い）。
    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("user_treesitter", { clear = true }),
      callback = function(args)
        if not pcall(vim.treesitter.start, args.buf) then
          return
        end
        -- indentexpr の文字列はクォートの種類まで README 指定どおりにする必要がある
        -- （外側が " で require の引数が ' ）。
        vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
    })
  end,
}
