"plugin settings
let s:cache_home = expand('~/.config/nvim')
let s:dein_dir = s:cache_home . '/dein'
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'
if !isdirectory(s:dein_repo_dir)
  call system('git clone https://github.com/Shougo/dein.vim ' . shellescape(s:dein_repo_dir))
endif
let &runtimepath = s:dein_repo_dir .",". &runtimepath
let g:python3_host_prog = expand('~/.virtualenvs/nvim/bin/python3')

if &compatible
  set nocompatible
endif
set runtimepath+=~/.config/nvim/colors
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
set listchars=tab:>-,trail:~

set showtabline=2
set ambiwidth=double
set laststatus=2
set tabstop=2
set shiftwidth=2
set smartindent
set expandtab

augroup fileTypeIndent
    autocmd!
    autocmd BufNewFile,BufRead *.py  setlocal tabstop=4 softtabstop=4 shiftwidth=4
    autocmd BufNewFile,BufRead *.c   setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.cpp setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.tex setlocal tabstop=1 softtabstop=0 shiftwidth=0
augroup END

set clipboard=unnamed

set backspace=eol,indent,start

set wildmenu
set wildmode=list:full
set wildignore=*.o,*.obj,*.pyc,*.so,*.dll
let g:python_highlight_all = 1

"let g:hybrid_custom_term_colors = 1
"let g:hybrid_reduced_contrast = 1 " Remove this line if using the default palette.
syntax enable
autocmd ColorScheme * highlight LineNr guifg=#b5bd68
colorscheme hybrid
set background=dark

"key mapping
inoremap <silent> <C-j> <ESC>
noremap <Space>h  ^
noremap <Space>l  $
noremap <Space>k gg
noremap <Space>j G
noremap t /
noremap / t
nnoremap ss :split<CR>
nnoremap s <Nop>
nnoremap sv :vsplit<CR>
nnoremap sj <C-w>j
nnoremap sk <C-w>k
nnoremap sl <C-w>l
nnoremap sh <C-w>h
nnoremap sJ <C-w>J
nnoremap sK <C-w>K
nnoremap sL <C-w>L
nnoremap sH <C-w>H
nnoremap st :tabnew<CR>
nnoremap sn gt
nnoremap sp gT
nnoremap sz :terminal<CR>
tnoremap <C-j> <C-\><C-n>
tnoremap <C-q> <C-\><C-n>:q<CR>
nnoremap sr <C-w>r
nnoremap s= <C-w>=
nnoremap sw <C-w>w
nnoremap so <C-w>_<C-w>|
nnoremap sO <C-w>=
nnoremap x "_x
nnoremap D "_D
nnoremap <Space>t gt
noremap j gj
noremap k gk
nnoremap gg ggzz
noremap gj j
noremap gk k
vnoremap v $h
nnoremap <Tab> %
vnoremap <Tab> %
nnoremap + <C-a>
nnoremap - <C-x>
nnoremap <silent> <Space>w :<C-u>update<CR>
nnoremap <silent> <Space>q :<C-u>q<CR>
"Denite vim
nnoremap <silent> <Space>uc   :<C-u>Denite file_mru<CR>
nnoremap <silent> <Space>ub   :<C-u>Denite buffer<CR>
nnoremap <silent> <Space>uy   :<C-u>Denite neoyank<CR>
nnoremap <silent> <Space>ur :<C-u>Denite file_rec<CR>

"other plugins
noremap <Space>n :NERDTree .<CR>
noremap <Space>e :cd %:h<CR>:e .<CR>
nnoremap <Space>ap :Autopep8<CR>
nnoremap rp :QuickRun<Space>python<Space>-outputter/buffer/split<Space>":botright"<Space>-outputter/buffer/close_on_empty<Space>1<Space>-hook/time/enable<Space>1<CR>
nnoremap rc :QuickRun<Space>cpp/g++<Space>-outputter/buffer/split<Space>":botright"<Space>-outputter/buffer/close_on_empty<Space>1<Space>-hook/time/enable<Space>1<Space>-cmdopt<Space>'-std=c++11'<CR>
nmap <Space>m <Plug>(quickhl-manual-this)
xmap <Space>m <Plug>(quickhl-manual-this)
nmap <Space>M <Plug>(quickhl-manual-reset)
xmap <Space>M <Plug>(quickhl-manual-reset)

" カーソル下のURLや単語をブラウザで開く
nmap <Space>b <Plug>(openbrowser-smart-search)
vmap <Space>b <Plug>(openbrowser-smart-search)

" operator mappings
map <silent>sa <Plug>(operator-surround-append)
map <silent>sd <Plug>(operator-surround-delete)
map <silent>sr <Plug>(operator-surround-replace)
omap ab <Plug>(textobj-multiblock-a)
omap ib <Plug>(textobj-multiblock-i)
vmap ab <Plug>(textobj-multiblock-a)
vmap ib <Plug>(textobj-multiblock-i)

"commenting out
map co \c<Space>

" delete or replace most inner surround

" if you use vim-textobj-multiblock
nmap <silent>sdd <Plug>(operator-surround-delete)<Plug>(textobj-multiblock-a)
nmap <silent>srr <Plug>(operator-surround-replace)<Plug>(textobj-multiblock-a)

" if you use vim-textobj-between
nmap <silent>sdb <Plug>(operator-surround-delete)<Plug>(textobj-between-a)
nmap <silent>srb <Plug>(operator-surround-replace)<Plug>(textobj-between-a)


filetype plugin indent on
