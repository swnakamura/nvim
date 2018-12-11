"plugin settings
let s:cache_home = expand('~/.config/nvim')
let s:dein_dir = s:cache_home . '/dein'
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'
if !isdirectory(s:dein_repo_dir)
  call system('git clone https://github.com/Shougo/dein.vim ' . shellescape(s:dein_repo_dir))
endif
let &runtimepath = s:dein_repo_dir .",". &runtimepath
if exists("$VIRTUAL_ENV")
  if !empty(glob("$VIRTUAL_ENV/bin/python3"))
    let g:python3_host_prog = substitute(system("which python3"), '\n', '', 'g')
  else
    let g:python_host_prog = substitute(system("which python"), '\n', '', 'g')
  endif
endif

if &compatible
  set nocompatible
endif
if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)

 " プラグインリストを収めた TOML ファイル
  " 予め TOML ファイル（後述）を用意しておく
  let g:rc_dir    = s:cache_home . '/toml'
  let s:toml      = g:rc_dir . '/dein.toml'
  let s:lazy_toml = g:rc_dir . '/dein_lazy.toml'

  " TOML を読み込み、キャッシュしておく
  call dein#load_toml(s:toml,      {'lazy': 0})
  call dein#load_toml(s:lazy_toml, {'lazy': 1})

  " 設定終了
  call dein#end()
  call dein#save_state()
endif

if dein#check_install(['vimproc.vim'])
  call dein#install(['vimproc.vim'])
endif

if has('vim_starting') && dein#check_install()
  call dein#install()
endif

if exists('$TMUX')
  let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
  let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
else
  let &t_SI = "\<Esc>]50;CursorShape=1\x7"
  let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif

set timeoutlen=400

"general settings
if &compatible
  set nocompatible
endif
syntax enable
set t_Co=256

set encoding=utf-8
set fileencodings=utf-8,ios-2022-jp,euc-jp,sjis,cp932
set termguicolors

set smarttab
set virtualedit=block
set nf=alpha

set ignorecase
set smartcase
set incsearch
set nohlsearch
set wrapscan


set number
set list
set listchars=tab:>-,trail:~,extends:»,precedes:«

set showtabline=2
set ambiwidth=double
set laststatus=2
set tabstop=2
set shiftwidth=2
set smartindent
set expandtab

set inccommand=split

augroup fileType
    autocmd!
    autocmd BufNewFile,BufRead *.py  setlocal tabstop=4 softtabstop=4 shiftwidth=4 foldmethod=indent
    autocmd BufNewFile,BufRead *.c   setlocal tabstop=2 softtabstop=2 shiftwidth=2 foldmethod=syntax
    autocmd BufNewFile,BufRead *.cpp setlocal tabstop=2 softtabstop=2 shiftwidth=2 foldmethod=syntax
    autocmd BufNewFile,BufRead *.tex setlocal tabstop=4 softtabstop=0 shiftwidth=0 foldmethod=syntax
    autocmd BufNewFile,BufRead *.html setlocal nowrap
    autocmd BufNewFile,BufRead *.grg setlocal nowrap tabstop=4 softtabstop=4 shiftwidth=4
    autocmd BufNewFile,BufRead *.csv setlocal nowrap
augroup END

augroup Beautifytype
"for javascript
autocmd FileType javascript noremap <buffer> <leader>aj :call JsBeautify()<cr>
" for json
autocmd FileType json noremap <buffer> <leader>aj :call JsonBeautify()<cr>
" for jsx
autocmd FileType jsx noremap <buffer> <leader>aj :call JsxBeautify()<cr>
" for html
autocmd FileType html noremap <buffer> <leader>aj :call HtmlBeautify()<cr>
" for css or scss
autocmd FileType css noremap <buffer> <leader>aj :call CSSBeautify()<cr>
augroup END

set clipboard=unnamed
set backspace=eol,indent,start

set wildmenu
set wildmode=list:full
set wildignore=*.o,*.obj,*.pyc,*.so,*.dll
let g:python_highlight_all = 1

syntax enable
"autocmd ColorScheme * highlight LineNr guifg=#b5bd68
"colorscheme Dark
"colorscheme Dim2
"colorscheme jelybeans
"colorscheme gruvbox
colorscheme PaperColor

set mouse=a

"key mapping

noremap  あ         a
noremap  い         i
noremap  う         u
noremap  え         e
noremap  お         o
noremap  ア         a
noremap  イ         i
noremap  ウ         u
noremap  エ         e
noremap  オ         o

inoremap <silent>   fd          <ESC>
let      mapleader  =           "\<Space>"

"ペーストした後にその文章の後に移動
vnoremap <silent>   y           y`]
vnoremap <silent>   p           p`]
nnoremap <silent>   p           p`]

noremap  <leader>h  ^
noremap  <leader>l  $
noremap  <leader>k  gg
noremap  <leader>j  G
nnoremap <leader>ws :split<CR>
nnoremap <leader>wv :vsplit<CR>
nnoremap <leader>wj <C-w>j
nnoremap <leader>wk <C-w>k
nnoremap <leader>wl <C-w>l
nnoremap <leader>wh <C-w>h
nnoremap <leader>wJ <C-w>J
nnoremap <leader>wK <C-w>K
nnoremap <leader>wL <C-w>L
nnoremap <leader>wH <C-w>H
nnoremap <leader>wt :tabnew<CR>
nnoremap <leader>wn gt
nnoremap <leader>wp gT
nnoremap sz         :terminal<CR>
tnoremap fd         <C-\><C-n>
tnoremap <leader>wd <C-\><C-n>:q<CR>
tnoremap <leader>bd <C-\><C-n>:q<CR>
nnoremap <leader>wr <C-w>r
nnoremap <leader>w= <C-w>=
nnoremap <leader>ww <C-w>w
nnoremap <leader>wo <C-w>_<C-w>|
nnoremap <leader>wO <C-w>=
nnoremap x          "_x
noremap  j          gj
noremap  k          gk
noremap  gj         j
noremap  gk         k
nnoremap t          /
nnoremap /          t
nnoremap gg         ggzz
nnoremap <Tab>      %
vnoremap <Tab>      %
nnoremap +          <C-a>
nnoremap -          <C-x>
nnoremap <silent>   <leader>fs  :<C-u>update<CR>
nnoremap <silent>   <leader>wd  :<C-u>q<CR>
"reload init.vim again
nnoremap <silent>   <leader>qr  :<C-u>so          ~/.config/nvim/init.vim<CR>
"delete every window in this tab
nnoremap <silent>   <leader>bd  :<C-u>tabc<CR>
"quit vim
nnoremap <silent>   <leader>qq  :<C-u>bufdo       bd<CR>:q<CR>
"open init.vim in new tab
nmap     <silent>   <leader>fed <leader>wt:<C-u>e ~/.config/nvim/init.vim<CR>
nnoremap <leader>v  :vim *<Left><Left>
nnoremap cn         :cn<CR>
nnoremap cp         :cp<CR>
nnoremap cN         :cN<CR>
"Denite vim
nnoremap <silent> <leader>fr :<C-u>Denite file_mru<CR>
nnoremap <silent> <leader>fb :<C-u>Denite buffer<CR>
nnoremap <silent> <leader>fy :<C-u>Denite neoyank<CR>
nnoremap <silent> <leader>ff :<C-u>Denite file_rec<CR>

"Defx
nnoremap   <silent> <leader>D   :Defx -columns=mark:filename:size:time:type:git -fnamewidth=30 -split=tab `expand('%:p:h')` -search=`expand('%:p')` <CR>
nnoremap   <silent> <leader>d   :Defx -columns=mark:filename:size:time:type:git -fnamewidth=30            `expand('%:p:h')` -search=`expand('%:p')`<CR>
autocmd    FileType defx call s:defx_my_settings()
function!  s:defx_my_settings() abort
  " Define mappings
  nnoremap <silent><buffer><expr> o        defx#do_action('drop')
  nnoremap <silent><buffer><expr> <CR>     defx#do_action('drop')
  nnoremap <silent><buffer><expr> l        defx#do_action('drop')
  nnoremap <silent><buffer><expr> K        defx#do_action('new_directory')
  nnoremap <silent><buffer><expr> L        defx#do_action('new_file')
  nnoremap <silent><buffer><expr> h        defx#do_action('cd',['..'])
  nnoremap <silent><buffer><expr> dd       defx#do_action('remove_trash',['..'])
  nnoremap <silent><buffer><expr> r        defx#do_action('rename',['..'])
  nnoremap <silent><buffer><expr> ~        defx#do_action('cd')
  nnoremap <silent><buffer><expr> <leader> defx#do_action('toggle_select').'j'
  nnoremap <silent><buffer><expr> s        defx#do_action('toggle_ignored_files')
  nnoremap <silent><buffer><expr> R        defx#do_action('redraw')
  nnoremap <silent><buffer><expr> yy       defx#do_action('yank_path')
  nnoremap <silent><buffer><expr> !        defx#do_action('execute_command')
  nnoremap <silent><buffer><expr> x        defx#do_action('execute_system')
endfunction
"open defx if open without any file
"TODO

"other plugins
noremap  <leader>e  :cd %:h<CR>:e .<CR>
nmap     <leader>m  <Plug>(quickhl-manual-this)
xmap     <leader>m  <Plug>(quickhl-manual-this)
nmap     <leader>M  <Plug>(quickhl-manual-reset)
xmap     <leader>M  <Plug>(quickhl-manual-reset)
nnoremap <leader>gs :Gstatus<CR>
nnoremap <leader>ga :Gwrite<CR>
nnoremap <leader>gc :Gcommit<CR>
nnoremap <leader>gb :Gblame<CR>
nnoremap <leader>gl :Git lga<CR>
nnoremap <leader>gp :Gpush<CR>
nnoremap <leader>gf :Gfetch<CR>
nnoremap <leader>gd :Gdiff<CR>

" カーソル下のURLや単語をブラウザで開く
"nmap <leader>b <Plug>(openbrowser-smart-search)
"vmap <leader>b <Plug>(openbrowser-smart-search)

" operator mappings
map        <silent>sa             <Plug>(operator-surround-append)
map        <silent>sd             <Plug>(operator-surround-delete)
map        <silent>sr             <Plug>(operator-surround-replace)
omap       ab                     <Plug>(textobj-multiblock-a)
omap       ib                     <Plug>(textobj-multiblock-i)
vmap       ab                     <Plug>(textobj-multiblock-a)
vmap       ib                     <Plug>(textobj-multiblock-i)

" delete or replace most inner surround

" if you use vim-textobj-multiblock
nmap       <silent>sdd            <Plug>(operator-surround-delete)<Plug>(textobj-multiblock-a)
nmap       <silent>srr            <Plug>(operator-surround-replace)<Plug>(textobj-multiblock-a)

" if you use vim-textobj-between
nmap       <silent>sdb            <Plug>(operator-surround-delete)<Plug>(textobj-between-a)
nmap       <silent>srb            <Plug>(operator-surround-replace)<Plug>(textobj-between-a)

filetype   plugin                 indent      on
