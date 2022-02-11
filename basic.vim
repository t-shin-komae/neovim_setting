" basic.vim
" 基本設定
"
set hidden " 保存されていないファイルがある時でも別のファイルを開くことができる。
" Encoding
set encoding=utf-8      " Vim内部のエンコード設定.
set fileencoding=utf-8  " ファイルの書き込み時.
set fileencodings=utf-8 " ファイルの書き込み時.
set nobomb              " BOM is not prepended. (when binary option is on, BOM is not prepended)

"" Fix backspace indent ------------------------------------------------
set backspace=indent,eol,start

"" Directories for swp files -------------------------------------------
set nobackup
set noswapfile

" File format setting (this only works on creating new buffer) ---------
set fileformats=unix,dos,mac

" Tab settings
set expandtab
set tabstop=4
set shiftwidth=4

" complete option
" TODO もうちょっと調査
set completeopt=menuone

"vim-terminal settings
tnoremap <Esc> <C-\><C-n>

" for mouse
set mouse=a

"for clipboard
set clipboard+=unnamedplus

" for diagnostic symbols
set signcolumn=yes

