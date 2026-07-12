-- ===== format-ts-errors: TypeScript の型エラーを整形表示 =====
-- ts_ls (tsserver) が返す診断メッセージは複雑なジェネリクスがあると1行の長大な
-- オブジェクト型になり読みにくい。textDocument/publishDiagnostics をラップし、
-- エラーコードごとに改行・インデントを入れて整形し直す（README の実装例に準拠）。
-- blink.lua の vim.lsp.config("*", ...) と同じく、ts_ls の LSP クライアントが
-- 実際に起動する前に登録されている必要があるため、ここも lazy trigger を付けず
-- 起動時に読み込む。
return {
  "davidosomething/format-ts-errors.nvim",
  config = function()
    require("format-ts-errors").setup({
      add_markdown = true,
      -- デフォルト値(1)のままだと単一行の型（例: `number`）にも無駄な
      -- インデントが入り `  number` のように余分な空白が付く。
      start_indent_level = 0,
    })

    vim.lsp.config("ts_ls", {
      handlers = {
        ["textDocument/publishDiagnostics"] = function(_, result, ctx, config)
          if result.diagnostics == nil then return end

          local idx = 1
          while idx <= #result.diagnostics do
            local entry = result.diagnostics[idx]
            local formatter = require("format-ts-errors")[entry.code]
            entry.message = formatter and formatter(entry.message) or entry.message

            -- 80001: 「CommonJS モジュールを ES モジュールに変換できます」という
            -- 提案であり型エラーではないため、雑音として間引く。
            if entry.code == 80001 then
              table.remove(result.diagnostics, idx)
            else
              idx = idx + 1
            end
          end

          vim.lsp.diagnostic.on_publish_diagnostics(_, result, ctx, config)
        end,
      },
    })
  end,
}
