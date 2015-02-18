" -------------------------------------------------- "
" 基本的な設定
" -------------------------------------------------- "

" ファイルタイプの検出、ファイルタイププラグイン
" インデントファイルを使う
filetype plugin indent on

" バックスペースでなんでも消せるようにする
set backspace=indent,eol,start

" バックアップファイルを作らない (file~ みたいなの)
set nobackup

" コマンド、検索パターンの履歴
set history=1000

" undo用ファイルを無効化
set noundofile

" カーソルを行頭、行末で止まらないようにする
set whichwrap=b,s,h,l,<,>,~,[,]

" 不可視文字を表示させる
set list

" 不可視文字の代替表示文字
set listchars=eol:↵,tab:>-,extends:<,trail:#


" 他で書き換えられたら自動で読み直す
set autoread

" タイトルを非表示にする
set notitle

" スワップファイルを作らない
set noswapfile

" 編集中でも他のファイルを開けるようにする
set hidden

" テキスト整形オプション
" c: 幅に合わせてコメントを自動折り返し
" r: 挿入モードで<Enter>入力後のコメント自動挿入
" l: 長い行の自動折り返しをしない
" M: 行の連結時に、マルチバイト文字の前後に空白を挿入しない
" m: マルチバイト文字の間でも改行する
" o: ノーマルモードから挿入モードのコメント自動挿入
set formatoptions=crMmoql

" ビープを鳴らさない
set visualbell t_vb=

" 一行に長い文章を書いても自動折り返しをしない
set textwidth=0

" スクロール時の余白確保
set scrolloff=5

" OSのクリップボードを使用する
" set clipboard=unnamed

" 常に今のディレクトリを起点にする
set autochdir

" 長い行かつ最後の行の場合、可能な限り中身を表示する
set display+=lastline

" 括弧入力時に対応する括弧を表示
set showmatch

" 対応する括弧を表示(10ms)
set matchtime=10

" 自動でインデント
set autoindent

" 新しい行を開始したときに、新しい行のインデントを現在行と同じ量にする。
set smartindent

" タブ入力を半角スペースにする
set expandtab

" タブが対応する空白の数
set tabstop=2

" インデント量
set shiftwidth=2

" キーボード入力のタブ量、0で無効（tabstop などに従う、基本使わない）
set softtabstop=0

" 最後まで検索したら先頭へ戻る
set wrapscan

" 大文字小文字無視
set ignorecase

" 検索文字列に大文字が含まれている場合は区別して検索する
set smartcase

" インクリメンタルサーチ
set incsearch

" 検索文字をハイライト
set hlsearch
