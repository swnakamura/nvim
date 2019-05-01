" map space to leader
let mapleader = "\<Space>"

"plugin settings
let s:cache_home = expand('~/.config/nvim')
let s:dein_dir = s:cache_home . '/dein'
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'
if !isdirectory(s:dein_repo_dir)
  call system('git clone https://github.com/Shougo/dein.vim ' . shellescape(s:dein_repo_dir))
endif
let &runtimepath = s:dein_repo_dir .",". &runtimepath
let g:python3_host_prog = substitute(system("which python3"), '\n', '', 'g')

let g:dein#types#git#clone_depth = 1
if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)
  " locate toml directory beforehand
  let g:rc_dir    = s:cache_home . '/toml'
  let s:toml      = g:rc_dir . '/dein.toml'
  let s:lazy_toml = g:rc_dir . '/dein_lazy.toml'

  " read toml file and cache them
  call dein#load_toml(s:toml,      {'lazy': 0})
  call dein#load_toml(s:lazy_toml, {'lazy': 1})

  call dein#end()
  call dein#save_state()
endif

if has('vim_starting') && dein#check_install()
  call dein#install()
endif

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
set encoding=utf-8
set fileencodings=utf-8,ios-2022-jp,euc-jp,sjis,cp932

" use gui colors
set termguicolors

" assign temporary file
set backupdir=~/.config/nvim/tmp//
set directory=~/.config/nvim/tmp//
set undodir=~/.config/nvim/tmp//
set viewdir=~/.config/nvim/tmp//

" to use floating window
set completeopt=menu


set smarttab
set nf=alpha,octal,hex,bin

set ignorecase
set smartcase
set incsearch
set nohlsearch
set wrapscan

set number
set list
set listchars=tab:»-,trail:~,extends:»,precedes:«,nbsp:%

" for double width characters
set ambiwidth=double

" always show finetabline,statusline
set showtabline=2
set laststatus=2

set statusline=%<%f\ %m\ %r%h%w%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}%=\ col:%3v,\ line:%l/%L%8P\ 
source <sfile>:p:h/tablinegen.vim

set tabstop=4
set softtabstop=4
set shiftwidth=4
set smartindent
set expandtab

"日本語(マルチバイト文字)行の連結時には空白を入力しない
setlocal formatoptions+=mM

set inccommand=split

augroup fileType
  autocmd!
  autocmd filetype           python   setlocal foldmethod=syntax
  autocmd filetype           c,cpp    setlocal foldmethod=syntax
  autocmd filetype           go       setlocal tabstop=4       noexpandtab | set formatoptions+=r
  autocmd filetype           tex      setlocal tabstop=4       softtabstop=0 shiftwidth=0 foldmethod=syntax
  autocmd filetype           html     setlocal nowrap
  autocmd filetype           csv      setlocal nowrap
  autocmd filetype           text     setlocal noet
  autocmd filetype           help     setlocal listchars=tab:\ \             noet
  autocmd filetype           markdown setlocal noet
  autocmd BufNewFile,BufRead *.grg    setlocal nowrap
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

autocmd ColorScheme * highlight LineNr guifg=#b5bd68
" colorscheme jellybeans
colorscheme gruvbox
" colorscheme hybrid
" colorscheme wombat
" colorscheme PaperColor
" colorscheme flatwhite

set mouse=a

"key mapping

tnoremap <silent>   <C-c>       <C-\><C-n>

"move to the end of a text after copying/pasting it
vnoremap <silent>   y           y`]
vnoremap <silent>   p           p`]
nnoremap <silent>   p           p`]

" Space+something to move to an end
noremap  <leader>h  ^
noremap  <leader>l  $
noremap  <leader>k  gg
noremap  <leader>j  G

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
nnoremap sn gt
nnoremap sp gT
nnoremap sr <C-w>r
nnoremap s= <C-w>=
nnoremap sO <C-w>=
nnoremap so <C-w>_<C-w>\|

" move by display line
noremap  j          gj
noremap  k          gk
noremap  gj         j
noremap  gk         k

" do not copy when delete by x
nnoremap x          "_x

" swap t and /
nnoremap t          /
nnoremap /          t
xnoremap t          /
xnoremap /          t
nnoremap T          ?
nnoremap ?          T
xnoremap T          ?
xnoremap ?          T

" quit by q
tnoremap <silent>  <leader>q <C-\><C-n>:q<CR>
nnoremap <silent>  <leader>q  :<C-u>q<CR>
nnoremap <silent>  <leader>wq  :<C-u>bufdo bd<CR>:q<CR>
nnoremap <silent>  <leader>Q  :<C-u>bufdo bd<CR>:q<CR>

" center cursor when jumped
" nnoremap n          nzz
" nnoremap N          Nzz
" instead, cursor should be somewhat inside window
setlocal scrolloff=10

" increase and decrease by plus/minus
nnoremap +          <C-a>
nnoremap -          <C-x>
vmap     g+          g<C-a>
vmap     g-          g<C-x>

"save by <leader>s
nnoremap <silent>  <leader>s  :<C-u>update<CR>
nnoremap <silent>  <leader>ws  :<C-u>wall<CR>

"reload init.vim again
nnoremap <silent>  <leader>r  :<C-u>so          ~/.config/nvim/init.vim<CR>

"delete every window in this tab
nnoremap <silent>  <leader>bd  :<C-u>tabc<CR>

"open init.vim in new tab
nmap     <silent>  <leader>fed <leader>wt:<C-u>e ~/.config/nvim/init.vim<CR>

" grep
nnoremap <leader>vv :lvimgrep //j %:p:h/*<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>

" recursive search
let s:use_vim_grep = 0
if s:use_vim_grep
    nnoremap <leader>vr :lvimgrep //j %:p:h/**<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>
else
    set grepprg=rg\ --vimgrep\ --no-heading
    nnoremap <leader>vr :lgrep 
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
    autocmd filetype qf nnoremap <buffer>p <CR>zz<C-w><C-p>
augroup END

" one push to cause change
nnoremap > >>
nnoremap < <<

" tagsジャンプの時に複数ある時は一覧表示
nnoremap <C-]> g<C-]> 

" insert mode keymappings for japanese input
" 一文字移動
inoremap <silent> <C-h> <Left>
inoremap <silent> <C-l> <Right>
"単語移動
inoremap <silent> <C-b> <S-Left>
inoremap <silent> <C-f> <S-Right>
" 行移動
inoremap <silent> <expr> <C-p>  pumvisible() ? "\<C-p>" : "<C-r>=MyExecExCommand('normal k')<CR>"
inoremap <silent> <expr> <C-n>  pumvisible() ? "\<C-n>" : "<C-r>=MyExecExCommand('normal j')<CR>"

"コマンドラインでのキーバインドをEmacsふうに
" 行頭へ移動
:cnoremap <C-A>         <Home>
" 行末へ移動
:cnoremap <C-E>         <End>

function! MyExecExCommand(cmd, ...)
  let saved_ve = &virtualedit
  let index = 1
  while index <= a:0
    if a:{index} == 'onemore'
      silent setlocal virtualedit+=onemore
    endif
    let index = index + 1
  endwhile

  silent exec a:cmd
  if a:0 > 0
    silent exec 'setlocal virtualedit='.saved_ve
  endif
  return ''
endfunction

set matchpairs+=「:」,（:）

" 最後に設定
filetype plugin indent on
syntax enable
