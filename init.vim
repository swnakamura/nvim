filetype plugin indent off
" map space to leader
let mapleader = "\<Space>"
let maplocalleader = "\<C-space>"
let g:vimtex_compiler_progname = 'nvr'
let g:dark_colorscheme=1

let g:loaded_python_provier=1
let g:python3_host_prog='/usr/bin/python3'
let g:python3_host_skip_check=1
let g:python_host_prog='/usr/bin/python'
let g:python_host_skip_check=1
set pyxversion=3

" source plugins
exe 'source' expand('~/.config/nvim/Plug.vim')

" execute plugin specific settings
for f in split(glob('/home/woody/.config/nvim/plugin_settings/*.vim'), '\n')
    exe 'source' f
endfor

" source other settings
exe 'source' expand('~/.config/nvim/set.vim')
exe 'source' expand('~/.config/nvim/mapping.vim')
exe 'source' expand('~/.config/nvim/lsp.vim')
exe 'source' expand('~/.config/nvim/autocmd.vim')

let g:python_highlight_all = 1

" Always set ...
if g:dark_colorscheme
    colorscheme iceberg
else
    " LineNr light-green
    autocmd ColorScheme * highlight LineNr guifg=#b5bd68
    " background transparent
    autocmd ColorScheme * highlight Normal guibg=NONE ctermbg=NONE
    " NonText gray
    autocmd ColorScheme * highlight NonText guibg=NONE ctermbg=NONE guifg=Gray
    colorscheme flatwhite
endif

" 最後に設定
filetype plugin indent on
syntax enable

set conceallevel=0
