"------------------------------
" Vim settings
"------------------------------
"Viとの互換off
set nocompatible

"NeoBundleの設定
filetype off
if has('vim_starting')
    set runtimepath+=~/.vim/bundle/neobundle.vim
            call neobundle#rc(expand('~/.vim/bundle/'))
endif

"NeoBundleでインストールするプラグイン
NeoBundle 'Shougo/neobundle.vim'
NeoBundle 'Shougo/vimproc'
NeoBundle 'Yggdroot/indentLine'
NeoBundle 'cakebaker/scss-syntax.vim'
NeoBundle 'digitaload/vim-jade'
NeoBundle 'terryma/vim-multiple-cursors'
NeoBundle 'othree/html5.vim'
NeoBundle 'wavded/vim-stylus'
NeoBundle 'Townk/vim-autoclose'

filetype plugin indent on
filetype indent on

"colorscheme を jellybeansに設定
colorscheme jellybeans
syntax on

set autoindent
set smartindent
set cindent

set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab

set relativenumber

set visualbell

set guifont=Ricty-Regular:h14

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
