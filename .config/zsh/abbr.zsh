# 略語展開 (zsh-abbr)
# abbreviation の実体をこのリポジトリ内ファイルに置き、dotfiles として共有する。
# symlink を保存先にすると abbr add/erase の mv 上書きで実ファイルに化けて連携が
# 切れるため、変数で直接リポジトリ内ファイルを指す。abbr add するとここが直接更新される。
# ZDOTREPO は .zshrc がリポジトリルート（${0:A:h}）として定義する。
export ABBR_USER_ABBREVIATIONS_FILE="$ZDOTREPO/.config/zsh-abbr/user-abbreviations"

# 新規マシンで mise bootstrap 未実行のまま最初のシェルが起動しても落ちないようガードする。
if [[ -f "$ZSH_ABBR_DIR/zsh-abbr.zsh" ]]; then
  source "$ZSH_ABBR_DIR/zsh-abbr.zsh"
fi
