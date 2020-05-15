filetype plugin indent off
" map space to leader
let mapleader = "\<Space>"
let maplocalleader = "\<C-space>"
let g:vimtex_compiler_progname = 'nvr'
let g:dark_transparent=1

let g:loaded_python_provier=1
let g:python3_host_prog='/usr/bin/python3'
let g:python3_host_skip_check=1
let g:python_host_prog='/usr/bin/python'
let g:python_host_skip_check=1
set pyxversion=3

exe 'source' expand('~/.config/nvim/Plug.vim')

" execute plugin specific settings
for f in split(glob('/home/woody/.config/nvim/plugin_settings/*.vim'), '\n')
    exe 'source' f
endfor

" source settings
exe 'source' expand('~/.config/nvim/set.vim')
exe 'source' expand('~/.config/nvim/mapping.vim')

augroup fileType
  au!
  au BufRead            *.cls     set      ft=tex
  au filetype           python    setlocal foldmethod=indent
  au filetype           c,cpp     setlocal foldmethod=indent
  au filetype           go        setlocal tabstop=4 shiftwidth=4 noexpandtab | set formatoptions+=r
  au filetype           tex       setlocal tabstop=4 shiftwidth=4 foldmethod=syntax spell
  au filetype           tex       imap     <buffer> ( (
  au filetype           tex       imap     <buffer> { {
  au filetype           tex       imap     <buffer> [ [
  au filetype           html      setlocal nowrap
  au filetype           csv       setlocal nowrap
  au filetype           text      setlocal noet spell
  au filetype           mail      setlocal noet spell
  au filetype           gitcommit setlocal spell
  au filetype           markdown  setlocal noet spell
  au BufNewFile,BufRead *.grg     setlocal nowrap
  au BufNewFile,BufRead *.jl      setf     julia
  au filetype           help      setlocal listchars=tab:\ \  noet
augroup END

augroup localleader
    autocmd!
    autocmd FileType tex    map <buffer> <localleader>s <plug>(vimtex-env-toggle-star)
    autocmd FileType tex    map <buffer> <localleader>t <plug>(vimtex-toc-toggle)
    autocmd FileType tex    map <buffer> <localleader>e <plug>(vimtex-env-change)
    autocmd FileType tex    map <buffer> <localleader>d <plug>(vimtex-delim-toggle-modifier)
    autocmd FileType tex    map <buffer> <localleader>r :VimtexCompile<CR>
    autocmd FileType tex    map <buffer> <F6> :VimtexClean<CR>
    autocmd FileType tex    map <buffer> <F7> :VimtexCompileOutput<CR>
    autocmd FileType python map <buffer> <localleader>r :%AsyncRun python<CR>
    autocmd FileType ruby map <buffer> <localleader>r :%AsyncRun ruby<CR>
augroup END

augroup Binary
    au!
    au BufReadPre  *.bin let &bin=1
    au BufReadPre  *.torrent let &bin=1
    au BufReadPre  *.out let &bin=1

    au BufReadPost * if &bin | %!xxd
    au BufReadPost * set ft=xxd | endif

    au BufWritePre * if &bin | %!xxd -r
    au BufWritePre * endif

    au BufWritePost * if &bin | %!xxd
    au BufWritePost * set nomod | endif
augroup END

" inoremap { {}<Left>
" inoremap {<Enter> {}<Left><CR><ESC><S-o>
" inoremap ( ()<ESC>i
" inoremap (<Enter> ()<Left><CR><ESC><S-o>

let g:python_highlight_all = 1

"set clipboard+=unnamedplus

" Always set ...
" LineNr light-green
if g:dark_transparent
    autocmd ColorScheme * highlight LineNr guifg=#b5bd68
    " background transparent
    autocmd ColorScheme * highlight Normal guibg=NONE ctermbg=NONE
    autocmd ColorScheme * highlight EndOfBuffer guibg=NONE ctermbg=NONE
    " NonText gray
    autocmd ColorScheme * highlight NonText guibg=NONE ctermbg=NONE guifg=Gray
    " autocmd ColorScheme * highlight Search  guifg=NONE gui=NONE
    colorscheme iceberg
else
    autocmd ColorScheme * highlight LineNr guifg=#b5bd68
    " background transparent
    autocmd ColorScheme * highlight Normal guibg=NONE ctermbg=NONE
    " NonText gray
    autocmd ColorScheme * highlight NonText guibg=NONE ctermbg=NONE guifg=Gray
    colorscheme flatwhite
endif

augroup limitlento80
    autocmd!
    " autocmd Filetype tex,gitcommit execute "set colorcolumn=" . join(range(81,335), ',')
    " autocmd Filetype tex,gitcommit hi ColorColumn guibg=#262626 ctermbg=235
augroup end

" colorscheme jellybeans
" colorscheme gruvbox
" colorscheme wombat
" colorscheme PaperColor

" use termdebug
packadd termdebug
let g:termdebug_wide=163


"key mapping

" 最後に設定
filetype plugin indent on
syntax enable

" key mapping
nnoremap<silent> gss :SaveSession<CR>
nnoremap<silent> gsl :LoadSession<CR>
nnoremap<silent> gsc :CleanUpSession<CR>
let g:gitsession_tmp_dir = expand("~/.config/nvim/tmp/gitsession")
" let g:gitsession_autoload = 1
set runtimepath+=~/programing/gitsession.nvim
set runtimepath+=~/programing/pygeon.nvim
