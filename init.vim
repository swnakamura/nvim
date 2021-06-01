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

let g:slime_target = "tmux"
let g:slime_dont_ask_default = 1
let g:slime_default_config = {"socket_name": "default", "target_pane": ":.1"}

let g:nvim_home_directory = expand('~/.config/nvim') . '/'

" source plugins
exe 'source' expand(g:nvim_home_directory . 'api_key.vim')
exe 'source' expand(g:nvim_home_directory . 'dein.vim')

" source other settings
exe 'source' expand(g:nvim_home_directory . 'set.vim')
exe 'source' expand(g:nvim_home_directory . 'mapping.vim')
exe 'source' expand(g:nvim_home_directory . 'lsp.vim')
exe 'source' expand(g:nvim_home_directory . 'autocmd.vim')
exe 'source' expand(g:nvim_home_directory . 'mark.vim')


let g:dark_colorscheme=v:false
if !g:dark_colorscheme
    set background=light
endif

nnoremap <silent> <cr> :let searchTerm = '\v<'.expand("<cword>").'>' <bar> let @/ = searchTerm <bar> echo '/'.@/ <bar> call histadd("search", searchTerm) <bar> set hls<cr>
vnoremap <silent> <cr> :let searchTerm = '\v<'.expand("<cword>").'>' <bar> let @/ = searchTerm <bar> echo '/'.@/ <bar> call histadd("search", searchTerm) <bar> set hls<cr>

colorscheme iceberg
" 最後に設定
filetype plugin indent on
syntax enable

set conceallevel=0
