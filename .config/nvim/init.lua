-- Neovim 設定エントリポイント
-- 実体は lua/config/ と lua/plugins/ に分割している
require("config.options")  -- 基本オプション（行番号・インデント）
require("config.autocmds") -- autocmd（ハイライト調整・LSP キーマップ）
require("config.lazy")     -- プラグインマネージャ & プラグイン定義（lua/plugins/ を自動読込）
