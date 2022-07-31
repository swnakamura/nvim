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
exe 'source' g:nvim_home_directory .. 'rcs/plugin_init.vim'
exe 'source' g:nvim_home_directory .. 'rcs/dein.vim'

" source other settings
exe 'source' g:nvim_home_directory .. 'rcs/set.vim'
exe 'source' g:nvim_home_directory .. 'rcs/mapping.vim'
exe 'source' g:nvim_home_directory .. 'rcs/autocmd.vim'
exe 'source' g:nvim_home_directory .. "rcs/autocmd_fcitx.vim"
exe 'source' g:nvim_home_directory .. 'rcs/mark.vim'

if !exists('g:vscode')
    set background=dark
    colorscheme iceberg
    " Less bright search color
    hi clear Search
    hi Search                gui=bold,underline guisp=#e27878
    " Do not show unnecessary separation colors
    hi LineNr                guibg=#161821
    hi CursorLineNr          guibg=#161821
    hi VertSplit             guifg=#161821 guibg=#161821
    hi SignColumn            guibg=#161821
    hi GitGutterAdd          guibg=#161821
    hi GitGutterChange       guibg=#161821
    hi GitGutterChangeDelete guibg=#161821
    hi GitGutterDelete       guibg=#161821
    " Do not show horizontal line in deleted
    hi DiffDelete guifg=#53343b
endif
" 最後に設定
filetype plugin indent on
syntax enable

set conceallevel=0
