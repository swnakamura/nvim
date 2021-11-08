filetype plugin indent off
" map space as leader
let mapleader = "\<Space>"
let maplocalleader = "\<C-space>"
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

let g:nvim_home_directory = expand('~/.config/nvim') . '/'

" source plugins
exe 'source' g:nvim_home_directory .. 'api_key.vim'
exe 'source' g:nvim_home_directory .. 'dein.vim'

" source other settings
exe 'source' g:nvim_home_directory .. 'set.vim'
exe 'source' g:nvim_home_directory .. 'mapping.vim'
if !exists('g:vscode')
    exe 'source' g:nvim_home_directory .. 'lsp.vim'
endif
exe 'source' g:nvim_home_directory .. 'autocmd.vim'
exe 'source' g:nvim_home_directory .. "autocmd_fcitx.vim"
exe 'source' g:nvim_home_directory .. 'mark.vim'

" nnoremap <silent> <cr> :let searchTerm = '\v<'.expand("<cword>").'>' <bar> let @/ = searchTerm <bar> echo '/'.@/ <bar> call histadd("search", searchTerm) <bar> set hls<cr>
" vnoremap <silent> <cr> :let searchTerm = '\v<'.expand("<cword>").'>' <bar> let @/ = searchTerm <bar> echo '/'.@/ <bar> call histadd("search", searchTerm) <bar> set hls<cr>

" augroup unsetCR
"     autocmd!
"     autocmd Filetype qf nnoremap <buffer> <CR> <CR>
" augroup END

if !exists('g:vscode')
    set background=dark
    colorscheme iceberg
endif
" 最後に設定
filetype plugin indent on
syntax enable

set conceallevel=0
