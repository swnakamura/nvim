" if you can't type quickly, change this.
set timeoutlen=400

set clipboard=unnamedplus

" update quickly
set updatetime=100

" show cursor line
set cursorline

" shada=viminfo
set shada=!,'3000,<0,s10,h,%0

" do not include buffer info in session
set sessionoptions-=blank
set sessionoptions-=buffers

" file encoding
set fileencodings=utf-8,ios-2022-jp,euc-jp,sjis,cp932

" use gui colors
set termguicolors

" assign temporary file
set backupdir =~/.config/nvim/tmp//
set directory =~/.config/nvim/tmp//
set undodir   =~/.config/nvim/tmp//
set viewdir   =~/.config/nvim/tmp//

" don't use preview window; I prefer popup/floating window
set completeopt-=preview

set nrformats=alpha,octal,hex,bin

" search settings
set ignorecase smartcase nohlsearch nowrapscan

" line number settings
set relativenumber
set number

" listchar settings
set list listchars=tab:»-,trail:~,extends:»,precedes:«,nbsp:%

set scrolloff=5

" show double width characters properly
set ambiwidth=single

" always show finetabline,statusline
set showtabline=2

set laststatus=0
set rulerformat=%50(%1*%=%f\ %([%H%M%R]%)\ %12.(%l,%c%V%)\ %P%)
set statusline=%=%f\ %([%H%M%R]%)\ %12.(%l,%c%V%)\ %P

" transparent popup window
set winblend=25 pumblend=20

" statusline settting
" set statusline=%<%f\ %m\ %r%h%w%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']['.&ft.']\ '}%{FugitiveStatusline()}%=\ col:%3v,\ line:%l/%L%8P\

" tab settings
set tabstop=4 shiftwidth=4
set smartindent expandtab

"日本語(マルチバイト文字)行の連結時には空白を入力しない
setglobal formatoptions+=mM

" show the result of command with split window
set inccommand=split

" don't fold by default
set foldlevel=99
" reserve two columns for fold
" set foldcolumn=2

set backspace=eol,indent,start

set diffopt+=vertical,algorithm:patience,indent-heuristic

set wildmenu
set wildmode=list:full
set wildignore+=*.o
set wildignore+=*.obj
set wildignore+=*.pyc
set wildignore+=*.so
set wildignore+=*.dll

set splitbelow
set splitright

" モード変更時に表示しない
set noshowmode

set title

set mouse=a

set matchpairs+=「:」,（:）,『:』,【:】,〈:〉,《:》,〔:〕,｛:｝

set spelllang=en,cjk

setglobal signcolumn=yes

" tmux cursor shape setting
if exists('$TMUX')
  let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
  let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
else
  let &t_SI = "\<Esc>]50;CursorShape=1\x7"
  let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif
