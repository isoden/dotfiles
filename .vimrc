"------------------------------
" Vim settings
"------------------------------

"NeoBundleの設定
if has('vim_starting')
  set runtimepath+=~/.vim/bundle/neobundle.vim
endif

call neobundle#begin(expand('~/.vim/bundle'))

"NeoBundleでインストールするプラグイン一覧
NeoBundleFetch 'Shougo/neobundle.vim'
NeoBundleFetch 'Shougo/vimproc'
NeoBundleFetch 'Yggdroot/indentLine'
NeoBundleFetch 'cakebaker/scss-syntax.vim'
NeoBundleFetch 'digitaload/vim-jade'
NeoBundleFetch 'terryma/vim-multiple-cursors'
NeoBundleFetch 'othree/html5.vim'
NeoBundleFetch 'wavded/vim-stylus'
NeoBundleFetch 'Townk/vim-autoclose'
NeoBundleFetch 'tomasr/molokai'
NeoBundleFetch 'Xuyuanp/git-nerdtree'
NeoBundleFetch 'mattn/emmet-vim'

call neobundle#end()

filetype plugin indent on

"colorschemeをmolokaiに設定
colorscheme molokai
syntax on

" バックスペースでなんでも消せるように
set backspace=indent,eol,start
set cindent       " ?

set tabstop=4     " :
set shiftwidth=4
set softtabstop=4
set expandtab

set relativenumber

set visualbell

set guifont=Consolas:h14

let g:indentLine_color_term=222
let g:indentLine_color_gui="#405060"
let g:indentLine_char="¦"

"------------------------------
" backup settings
"------------------------------
" バックアップファイルを指定したフォルダに作成する
set backupdir=$HOME/.vim/.backup

" スワップファイルを指定したフォルダに作成する
let &directory=&backupdir

" バックアップフォルダがなければ作成する
if isdirectory(&directory) == 0
    echo "make backup directory"
    echo &directory
    call mkdir(&directory)
endif

if has('persistent_undo')
    set undodir=$directory
    set undofile
endif

autocmd FileType html inoremap <silent> <buffer> </ </<C-x><C-o>
set statusline=%l
set laststatus=2

" マウス操作を有効化
set mouse=a
set ttymouse=xterm2

" emmet
" let g:user_emmet_expandabbr_key='<Ctrl-e>'


" 基本設定
source $HOME/.vim/settings/basic.vim

" 表示、見た目
source $HOME/.vim/settings/appearance.vim

