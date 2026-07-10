# ~/.zshrc — エントリポイント
#
# 実体はこのリポジトリ内 .config/zsh/*.zsh に機能別で分割してある。
# ~/.zshrc は init.sh がリポジトリへ張る symlink なので、それを :A で解決した
# ディレクトリ = リポジトリルート。これを起点に各設定を読み込むので
# ~/.config/zsh への symlink は不要。
# 起動 rc ファイル内の $0 はシェルの起動パスになり得て当てにならないため、
# 固定の $HOME/.zshrc を解決する。
typeset -g ZDOTREPO="${${:-$HOME/.zshrc}:A:h}"

# 読み込み順序に依存関係がある（path → tools → completion → abbr）ため、明示的に列挙する。
for _rc in \
  path \
  tools \
  options \
  completion \
  prompt \
  functions \
  abbr
do
  source "$ZDOTREPO/.config/zsh/$_rc.zsh"
done
unset _rc

# PC 固有設定（git 管理外）。存在すれば最後に読み込み、共通設定の上書きを許す。
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
