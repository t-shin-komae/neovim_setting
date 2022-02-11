" plug.vim
let g:netrw_liststyle=1
let g:netrw_sizestyle="H"
let g:netrw_timefmt="%Y/%m/%d(%a) %H:%M:%S"
let g:netrw_preview=1

call plug#begin()
Plug 'cocopon/iceberg.vim'
Plug 'vim-airline/vim-airline'
Plug 'tpope/vim-commentary'
Plug 'jiangmiao/auto-pairs'

" セッション管理
Plug 'xolox/vim-session'
Plug 'xolox/vim-misc'

" 補完エンジン
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }

" Language Server Protocol クライアント
Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }
" スニペットエンジン
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/vim-vsnip-integ'
Plug 'Shougo/deol.nvim'
" C++用
" Plug 'm-pilia/vim-ccls'
Plug 'vim-scripts/DoxygenToolkit.vim'
call plug#end()

" タブラインにもairlineを適用
let g:airline#extensions#tabline#enabled = 1

" （タブが一個の場合）バッファのリストをタブラインに表示する機能をオフ
let g:airline#extensions#tabline#show_buffers = 0

" 0でそのタブで開いてるウィンドウ数、1で左のタブから連番
let g:airline#extensions#tabline#tab_nr_type = 1

" タブに表示する名前（fnamemodifyの第二引数）
let g:airline#extensions#tabline#fnamemod = ':t'

let g:LanguageClient_serverCommands = {
      \ 'c': ['ccls'],
      \ 'cpp': ['ccls'],
      \ 'cuda': ['ccls'],
      \ }
let g:LanguageClient_settingsPath = expand('<sfile>:p:h') . '/lsp_settings.json'
let g:ccls_close_on_jump = v:true
let g:ccls_levels=1


let s:session_path = expand('.vim/sessions')
if !isdirectory(s:session_path)
    call mkdir(s:session_path, "p")
endif

let g:session_directory = s:session_path
let g:session_autosave = 'yes'
let g:session_autoload = 'yes'
let g:session_autosave_periodic = 1
" let g:LanguageClient_setOmnifunc=v:true
let g:deoplete#enable_at_startup = 1

let g:LanguageClient_loggingFile = '/tmp/LanguageServer.log'

filetype indent on
autocmd FileType c,cpp,cuda setlocal sw=2 sts=2 ts=4 et

let g:deol#prompt_pattern = '% \|%$'
