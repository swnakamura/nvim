filetype plugin indent off


" map space as leader
let g:mapleader = "\<Space>"
let g:maplocalleader = "\<C-space>"

let g:loaded_python_provier=1
let g:python3_host_prog='/usr/bin/python3'
let g:python3_host_skip_check=1
let g:python_host_prog='/usr/bin/python'
let g:python_host_skip_check=1
set pyxversion=3

let g:slime_target = "tmux"
let g:slime_dont_ask_default = 1
let g:slime_default_config = {"socket_name": "default", "target_pane": ":.1"}

let g:nvim_conf_dir = stdpath('config') . '/'

if filereadable(g:nvim_conf_dir .. 'rcs/api_key.vim')
  exe 'source' g:nvim_conf_dir .. 'rcs/api_key.vim'
endif

" source plugins
exe 'source' g:nvim_conf_dir .. 'rcs/plugin_init.vim'
exe 'source' g:nvim_conf_dir .. 'rcs/dein.vim'

" source other settings
exe 'source' g:nvim_conf_dir .. 'rcs/set.vim'
exe 'source' g:nvim_conf_dir .. 'rcs/mapping.vim'
exe 'source' g:nvim_conf_dir .. 'rcs/autocmd.vim'
exe 'source' g:nvim_conf_dir .. "rcs/autocmd_fcitx.vim"

if !exists('g:vscode')
  set background=dark
  colorscheme iceberg
  " Less bright search color
  hi clear Search
  hi Search                gui=bold,underline guisp=#e27878
  " Statusline color
  hi StatusLine            gui=NONE guibg=#0f1117 guifg=#9a9ca5
  hi StatusLineNC          gui=NONE guibg=#0f1117 guifg=#9a9ca5
  " Do not show unnecessary separation colors
  hi LineNr                guibg=#161821
  hi CursorLineNr          guibg=#161821
  hi SignColumn            guibg=#161821
  hi GitGutterAdd          guibg=#161821
  hi GitGutterChange       guibg=#161821
  hi GitGutterChangeDelete guibg=#161821
  hi GitGutterDelete       guibg=#161821
  highlight IndentBlanklineIndent guifg=#3c3c43 gui=nocombine
  " Do not show horizontal line in deleted
  hi DiffDelete guifg=#53343b
  " nvim-tree setting
  hi! link NvimTreeIndentMarker LineNr
endif
" 最後に設定
filetype plugin indent on
syntax enable
