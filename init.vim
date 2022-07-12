filetype plugin indent off

let g:do_filetype_lua = 1
let g:did_load_filetypes = 0

" map space as leader
let g:mapleader = "\<Space>"
let g:maplocalleader = "\<C-space>"
let g:vimtex_compiler_progname = 'nvr'

let g:loaded_python_provier=1
let g:python3_host_prog='/usr/bin/python3'
let g:python3_host_skip_check=1
let g:python_host_prog='/usr/bin/python'
let g:python_host_skip_check=1
set pyxversion=3

let g:slime_target = "tmux"
let g:slime_dont_ask_default = 1
let g:slime_default_config = {"socket_name": "default", "target_pane": ":.1"}

let g:nvim_home_directory = stdpath('config') . '/'

exe 'source' g:nvim_home_directory .. 'rcs/api_key.vim'

" source plugins
exe 'source' g:nvim_home_directory .. 'rcs/dein.vim'

" source other settings
exe 'source' g:nvim_home_directory .. 'rcs/set.vim'
exe 'source' g:nvim_home_directory .. 'rcs/mapping.vim'
if !exists('g:vscode')
    exe 'source' g:nvim_home_directory .. 'rcs/lsp.vim'
endif
exe 'source' g:nvim_home_directory .. 'rcs/autocmd.vim'
exe 'source' g:nvim_home_directory .. "rcs/autocmd_fcitx.vim"
exe 'source' g:nvim_home_directory .. 'rcs/mark.vim'

if !exists('g:vscode')
    set background=dark
    colorscheme iceberg
endif
" 最後に設定
filetype plugin indent on
syntax enable

set conceallevel=0
