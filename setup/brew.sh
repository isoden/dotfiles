#!/bin/zsh

set -euo pipefail

# ${0:A:h:h} は $0 を絶対パス化(:A)し head を2回(:h:h)で祖父ディレクトリ = repo ルート
REPO="${0:A:h:h}"
BREWFILE="$REPO/.homebrew/Brewfile"
LOCAL_BREWFILE="$REPO/.homebrew/Brewfile.local"

# brew にパスを通す。
# setup.sh から直接呼ばれた場合や、インストール直後の同一シェルではまだ PATH に
# 載っていないため、実体を直接叩いて shellenv を評価する。
load_brew() {
  if [ -x /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
    return 0
  fi
  return 1
}

load_brew || true

# 未インストールなら公式インストーラを実行する。非対話 (sudo パスワードを
# 入力できない) 環境では失敗しうるので、その旨を案内して中断する。
if ! command -v brew >/dev/null; then
  echo "Homebrew が未インストールのためインストールします: https://brew.sh/"
  NONINTERACTIVE=1 /bin/bash -c \
    "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # インストール直後の同一シェルには PATH が通っていないため再度読み込む。
  if ! load_brew || ! command -v brew >/dev/null; then
    echo "Homebrew のインストールに失敗しました。手動で確認してください: https://brew.sh/" >&2
    exit 1
  fi
fi

# 共有の Brewfile と PC 固有の Brewfile.local (git 管理外、会社/個人PCそれぞれの
# 専用ツール用) をマージしてから扱う。分けずに単一ファイルで運用すると、
# 一方のPCにしか無いツールが「Brewfileに無いから削除対象」と誤検知されてしまう。
MERGED="$(mktemp)"
trap 'rm -f "$MERGED"' EXIT
cat "$BREWFILE" > "$MERGED"
[ -f "$LOCAL_BREWFILE" ] && cat "$LOCAL_BREWFILE" >> "$MERGED"

brew bundle --file "$MERGED"

# zsh 補完系 (zsh-abbr 等) を fpath に追加すると、compinit の compaudit が
# 親ディレクトリ $(brew --prefix)/share の group-writable を insecure と判定し、
# シェル起動のたびに警告を出す。Homebrew 標準の 0775 から group/other の書き込みを
# 落として黙らせる。所有者 (自分) の書き込みは残るので brew の動作には影響しない。
# formula の caveats が案内している対処と同じ。chmod は冪等なので毎回実行してよい。
chmod go-w "$(brew --prefix)/share"

# マージ後のファイルに無いものを列挙する。--force を付けなければ削除はされず、
# 削除対象があるときだけ終了コード 1 を返す仕様なので || true で受ける。
cleanup_output="$(brew bundle cleanup --file "$MERGED" 2>/dev/null || true)"

if [ -z "$cleanup_output" ]; then
  echo "Brewfile と同期しています。"
  exit 0
fi

# -r は非対話でも真になることがあるので、実際に開けるかで判定する
if ! : 2>/dev/null < /dev/tty; then
  echo "対話できないため、Brewfile に無いものの削除確認をスキップします。" >&2
  exit 0
fi

kind=""
kept=0

while IFS= read -r line; do
  case "$line" in
    "Would uninstall formulae:")  kind="formula" ; continue ;;
    "Would uninstall casks:")     kind="cask"    ; continue ;;
    "Would untap:")               kind="tap"     ; continue ;;
    "Run \`brew bundle cleanup"*) kind=""        ; continue ;;
    "")                                            continue ;;
  esac

  [ -n "$kind" ] || continue

  # EOF なら空扱いにして残す (set -e で落とさない)
  answer=""
  read -r "answer?Brewfile にありません。削除しますか? ($kind) $line [y/N]: " < /dev/tty || answer=""

  case "$answer" in
    [yY])
      # 依存されているものは brew 自身が拒否する。その場合は残す。
      case "$kind" in
        formula) brew uninstall --formula "$line" || kept=$((kept + 1)) ;;
        cask)    brew uninstall --cask "$line"    || kept=$((kept + 1)) ;;
        tap)     brew untap "$line"               || kept=$((kept + 1)) ;;
      esac
      ;;
    *)
      kept=$((kept + 1))
      ;;
  esac
done <<< "$cleanup_output"

# 削除しなかったものをどちらのファイルに反映すべきかは自動判定できない
# (共有すべきものか、この PC 固有のものか) ため、ここでは自動で書き込まず案内のみ行う。
if [ "$kept" -gt 0 ]; then
  echo "削除しなかったものがあります。反映する場合は ./setup/brew-dump.sh を実行してください（パッケージごとに追加先を選べます）。"
fi
