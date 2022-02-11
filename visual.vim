" visual.vim
" シンタックスハイライト
syntax on
" 行番号表示
set number
try
    colorscheme iceberg
    catch
    try
        colorscheme darkblue
        catch
    endtry
endtry

" カーソルのある行のハイライト
set cursorline
" スクロール時のオフセット
set scrolloff=3
