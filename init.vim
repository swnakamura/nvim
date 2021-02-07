filetype plugin indent off
" map space to leader
let mapleader = "\<Space>"
let maplocalleader = "\<C-space>"
let g:vimtex_compiler_progname = 'nvr'
let g:dark_colorscheme=0

let g:loaded_python_provier=1
let g:python3_host_prog='/usr/bin/python3'
let g:python3_host_skip_check=1
let g:python_host_prog='/usr/bin/python'
let g:python_host_skip_check=1
set pyxversion=3

let g:nvim_home_directory = '/home/woody/.config/nvim'

" source plugins
exe 'source' expand(g:nvim_home_directory . '/dein.vim')

" source other settings
exe 'source' expand(g:nvim_home_directory . '/set.vim')
exe 'source' expand(g:nvim_home_directory . '/mapping.vim')
exe 'source' expand(g:nvim_home_directory . '/lsp.vim')
exe 'source' expand(g:nvim_home_directory . '/autocmd.vim')

let g:python_highlight_all = 1

" Always set ...
if g:dark_colorscheme
    colorscheme iceberg
else
    set background=light
    colorscheme iceberg
endif

" 最後に設定
filetype plugin indent on
syntax enable

set conceallevel=0
