filetype plugin indent off
" map space to leader
let mapleader = "\<Space>"
let maplocalleader = "\<C-space>"

"plugin settings
"call system('curl -fLo /home/woody/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim')

let g:python3_host_prog='/home/woody/anaconda3/bin/python3'
set pyxversion=3

call plug#begin('/home/woody/.config/nvim/plugged')

Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'Shougo/defx.nvim'
Plug 'Shougo/deol.nvim'
Plug 'kristijanhusak/defx-git'
Plug 'Shougo/denite.nvim'
Plug 'Shougo/unite-outline'
Plug 'Shougo/neomru.vim'
Plug 'Shougo/neoyank.vim'
Plug 'neoclide/denite-git'
Plug 'Yggdroot/indentLine'
Plug 'SirVer/ultisnips'
Plug 'kana/vim-smartinput'
Plug 'osyo-manga/shabadou.vim'
Plug 'kana/vim-operator-user'
Plug 'rhysd/vim-operator-surround'
Plug 'kana/vim-textobj-user'
Plug 'kana/vim-textobj-syntax'
Plug 'thinca/vim-textobj-between'
Plug 'osyo-manga/vim-textobj-multiblock'
Plug 'kana/vim-textobj-entire'
Plug 'airblade/vim-gitgutter'
Plug 'scrooloose/nerdcommenter'
Plug 'tpope/vim-fugitive'
Plug 'godlygeek/tabular'
Plug 'junegunn/vim-easy-align'
Plug 'soramugi/auto-ctags.vim'
Plug 'majutsushi/tagbar'
Plug 'Shougo/echodoc.vim'
Plug 'https://github.com/qnighy/satysfi.vim'
Plug 'ncm2/float-preview.nvim'
Plug 'https://github.com/flazz/vim-colorschemes'
Plug 'https://github.com/fuenor/jpmoveword.vim'
Plug 'https://github.com/mattn/sonictemplate-vim'
Plug 'https://github.com/tpope/vim-rhubarb'
Plug 'JuliaEditorSupport/julia-vim'
Plug 'https://github.com/dense-analysis/ale'
Plug 'https://github.com/itchyny/lightline.vim'
Plug 'https://github.com/jpalardy/vim-slime'
Plug 'tikhomirov/vim-glsl'
Plug 'Shougo/neco-syntax'
Plug 'Shougo/neosnippet'
Plug 'Shougo/neosnippet-snippets'
" lazy install
Plug 'hynek/vim-python-pep8-indent', {'for' : 'python'}
Plug 'bps/vim-textobj-python', {'for' : 'python'}
Plug 'lervag/vimtex', {'for' : ['tex','cls']}
Plug 'mattn/emmet-vim', {'for' : ['html','htm','md','markdown']}
Plug 'Yggdroot/indentLine', {'for' : ['c','cpp','python','tex','latex']}
Plug 'https://github.com/tell-k/vim-browsereload-mac', {'for' : ['html','htm', 'md']}
Plug 'https://github.com/hail2u/vim-css3-syntax', {'for' : ['html','htm']}
Plug 'https://github.com/pangloss/vim-javascript', {'for' : ['html','htm']}
Plug 'https://github.com/kchmck/vim-coffee-script', {'for' : ['html','htm']}
Plug 'AtsushiM/search-parent.vim', {'for' : ['sass','scss','css']}
Plug 'https://github.com/akiyan/vim-textobj-php', {'for' : ['html','htm']}
Plug 'https://github.com/tpope/vim-surround', {'for' : ['html','htm']}
Plug 'https://github.com/ap/vim-css-color', {'for' : ['html','htm', 'vim']}
Plug 'https://github.com/cakebaker/scss-syntax.vim', {'for' : ['html','htm']}
Plug 'godlygeek/tabular', {'for' : ['md']}
Plug 'wokalski/autocomplete-flow', {'for' : ['html', 'htm', 'js']}
Plug 'pangloss/vim-javascript', {'for' : 'js'}
Plug 'https://github.com/zeekay/vim-beautify', {'for' : ['html', 'htm', 'js']}
Plug 'https://github.com/AtsushiM/sass-compile.vim', {'for' : ['sass','scss']}
Plug 'https://github.com/qnighy/satysfi.vim', {'for' : ['satysfi','saty']}
Plug 'https://github.com/plasticboy/vim-markdown.git', {'for' : ['markdown']}

call plug#end()

" execute plugin specific settings
for f in split(glob('/home/woody/.config/nvim/plugins/*.vim'), '\n')
    exe 'source' f
endfor

" tmux cursor shape setting
if exists('$TMUX')
  let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
  let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
else
  let &t_SI = "\<Esc>]50;CursorShape=1\x7"
  let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif

" if you can't type quickly, change this.
set timeoutlen=400

" update quickly
set updatetime=100

" show cursor line
set cursorline

" shada=viminfo
set shada=!,'100,<0,s10,h,%0

" do not include buffer info in session
set sessionoptions-=buffers

" file encoding
set encoding=utf-8 fileencodings=utf-8,ios-2022-jp,euc-jp,sjis,cp932

" use gui colors
set termguicolors

" assign temporary file
set backupdir=~/.config/nvim/tmp//
set directory=~/.config/nvim/tmp//
set undodir=~/.config/nvim/tmp//
set viewdir=~/.config/nvim/tmp//

" don't use preview window; I prefer popup/floating window
set completeopt-=preview

set nf=alpha,octal,hex,bin

" search settings
set ignorecase smartcase incsearch nohlsearch nowrapscan

" line number settings
set number relativenumber

" listchar settings
set list listchars=tab:»-,trail:~,extends:»,precedes:«,nbsp:%

" show double width characters properly
set ambiwidth=double

" always show finetabline,statusline
set showtabline=2 laststatus=2

" transparent popup window
set winblend=8 pumblend=12

" statusline settting
set statusline=%<%f\ %m\ %r%h%w%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']['.&ft.']\ '}%{FugitiveStatusline()}%=\ col:%3v,\ line:%l/%L%8P\

" tab settings
set tabstop=4 shiftwidth=4
set smarttab smartindent expandtab

"日本語(マルチバイト文字)行の連結時には空白を入力しない
setlocal formatoptions+=mM

" show the result of command with split window
set inccommand=split

" don't fold by default
set foldlevel=99
" reserve two columns for fold
set foldcolumn=2

augroup fileType
  au!
  au BufRead            *.cls    set      ft=tex
  au filetype           python   setlocal foldmethod=syntax
  au filetype           c,cpp    setlocal foldmethod=syntax
  au filetype           go       setlocal tabstop=4 shiftwidth=4 noexpandtab | set formatoptions+=r
  au filetype           tex      setlocal tabstop=4 shiftwidth=4 foldmethod=syntax
  au filetype           html     setlocal nowrap
  au filetype           csv      setlocal nowrap
  au filetype           text     setlocal noet
  au filetype           markdown setlocal noet
  au BufNewFile,BufRead *.grg    setlocal nowrap
  au BufNewFile,BufRead *.jl     setf     julia
  au filetype           help     setlocal listchars=tab:\ \  noet
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

augroup Binary
    au!
    au BufReadPre  *.bin let &bin=1

    au BufReadPost *.bin if &bin | %!xxd
    au BufReadPost *.bin set ft=xxd | endif

    au BufWritePre *.bin if &bin | %!xxd -r
    au BufWritePre *.bin endif

    au BufWritePost *.bin if &bin | %!xxd
    au BufWritePost *.bin set nomod | endif
augroup END


set backspace=eol,indent,start

set wildmenu
set wildmode=list:full
set wildignore=*.o,*.obj,*.pyc,*.so,*.dll

let g:python_highlight_all = 1

set clipboard+=unnamedplus

" Always set ...
" LineNr light-green
autocmd ColorScheme * highlight LineNr guifg=#b5bd68
" background transparent
autocmd ColorScheme * highlight Normal guibg=NONE ctermbg=NONE
" NonText gray
autocmd ColorScheme * highlight NonText guibg=NONE ctermbg=NONE guifg=Gray

" colorscheme jellybeans
colorscheme gruvbox
" colorscheme hybrid
" colorscheme wombat
" colorscheme PaperColor
" colorscheme flatwhite

" use termdebug
packadd termdebug

set mouse=a

"key mapping

tnoremap <silent> <C-c> <C-\><C-n>

"move to the end of a text after copying/pasting it
vnoremap <silent> y y`]
vnoremap <silent> p p`]
nnoremap <silent> p p`]

" Space+something to move to an end
noremap <leader>h ^
noremap <leader>l $
noremap <leader>k gg
noremap <leader>j G

" unmap s,space
nnoremap s <Nop>
nnoremap <Space> <Nop>
" window control
nnoremap ss :split<CR>
nnoremap sv :vsplit<CR>
" st is used by defx
nnoremap sc :tab sp<CR>
nnoremap sC :-tab sp<CR>
nnoremap sj <C-w>j
nnoremap sk <C-w>k
nnoremap sl <C-w>l
nnoremap sh <C-w>h
nnoremap sJ <C-w>J
nnoremap sK <C-w>K
nnoremap sL <C-w>L
nnoremap sH <C-w>H
nnoremap sZ :terminal<CR>
nnoremap sn gt
nnoremap sp gT
nnoremap sr <C-w>r
nnoremap s= <C-w>=
nnoremap sO <C-w>=
nnoremap so <C-w>_<C-w>\|
nnoremap sq :<C-u>tabc<CR>

" move by display line
noremap j  gj
noremap k  gk
noremap gj j
noremap gk k

" always replace considering zenkaku
noremap r  gr
noremap R  gR
noremap gr r
noremap gR R


" do not copy when deleting by x
nnoremap x "_x

" swap t and /
nnoremap t /
nnoremap / t
xnoremap t /
xnoremap / t
nnoremap T ?
nnoremap ? T
xnoremap T ?
xnoremap ? T

" quit this window by q
tnoremap <silent> <leader>q  <C-\><C-n>:q<CR>
nnoremap <silent> <leader>q  :<C-u>q<CR>
nnoremap <silent> <leader>wq :qa<CR>
nnoremap <silent> <leader>Q  :qa<CR>

" delete this buffer by bd
nnoremap <silent> <leader>bd  :<C-u>bd<CR>

" center cursor when jumped
" nnoremap n          nzz
" nnoremap N          Nzz
" This option is deprecated. Instead, cursor should be somewhat inside window
setlocal scrolloff=5

" increase and decrease by plus/minus
nnoremap +  <C-a>
nnoremap -  <C-x>
vmap     g+ g<C-a>
vmap     g- g<C-x>

" switch quote and backquote
nnoremap ' `
nnoremap ` '

" save with <C-g> in insert mode
inoremap <C-g> <ESC>:update<CR>a

"save by <leader>s
nnoremap <silent> <leader>s :<C-u>update<CR>
nnoremap <silent> <leader>ws :<C-u>wall<CR>

"reload init.vim
nnoremap <silent> <leader>r :<C-u>so ~/.config/nvim/init.vim<CR>

"open init.vim in new tab
nnoremap <silent> <leader>fed :tabnew<CR>:<C-u>e ~/.config/nvim/init.vim<CR>

" grep
nnoremap <leader>vv :vimgrep // %:p:h/*<Left><Left><Left><Left><Left><Left><Left><Left><Left>

" recursive search
let s:use_vim_grep = 0
if s:use_vim_grep
    nnoremap <leader>vr :vimgrep // %:p:h/**<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>
else
    set grepprg=rg\ --vimgrep\ --no-heading\ -uuu
    nnoremap <leader>vr :grep -e ""<Left>
endif

" quickfix jump
nnoremap [q :cprevious<CR>   " 前へ
nnoremap ]q :cnext<CR>       " 次へ
nnoremap [Q :<C-u>cfirst<CR> " 最初へ
nnoremap ]Q :<C-u>clast<CR>  " 最後へ

"window-local quickfix jump
nnoremap [w :lprevious<CR>   " 前へ
nnoremap ]w :lnext<CR>       " 次へ
nnoremap [W :<C-u>lfirst<CR> " 最初へ
nnoremap ]W :<C-u>llast<CR>  " 最後へ

" In quickfix window...
augroup QuickfixWindow
    autocmd!
    autocmd filetype qf nnoremap <buffer>p <CR>zz<C-w>j
    autocmd filetype qf unmap j
    autocmd filetype qf unmap k
augroup END

" one push to add/remove tabs
nnoremap > >>
nnoremap < <<

" tagsジャンプの時に複数ある時は一覧表示
nnoremap <C-]> g<C-]>
""
" insert mode keymappings for japanese input convenience
" 単語移動：ctrl-f/bのとき補完ウィンドウを閉じる
inoremap <silent> <expr> <C-b> pumvisible() ? "<C-y><C-r>=ExecExCommand('normal b')<CR>" : "<C-r>=ExecExCommand('normal b')<CR>"
inoremap <silent> <expr> <C-f> pumvisible() ? "<C-y><C-r>=ExecExCommand('normal w')<CR>" : "<C-r>=ExecExCommand('normal w')<CR>"


inoremap <silent> <expr> <C-b> "<C-r>=ExecExCommand('normal b')<CR>"
inoremap <silent> <expr> <C-f> "<C-r>=ExecExCommand('normal w')<CR>"
" 行移動
inoremap <silent> <expr> <C-p> "<C-r>=ExecExCommand('normal k')<CR>"
inoremap <silent> <expr> <C-n> "<C-r>=ExecExCommand('normal j')<CR>"

function! ExecExCommand(cmd)
  silent exec a:cmd
  return ''
endfunction

"コマンドラインでのキーバインドをEmacs風に
" 行頭へ移動
cnoremap <C-A> <Home>
inoremap <C-A> <Home>
" 行末へ移動
cnoremap <C-E> <End>
inoremap <C-E> <End>

iab ar ->
iab pr \|>

set signcolumn=auto

set matchpairs+=「:」,（:）

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
