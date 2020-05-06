filetype plugin indent off
" map space to leader
let mapleader = "\<Space>"
let maplocalleader = "\<C-space>"
let g:vimtex_compiler_progname = 'nvr'
let g:dark_transparent=1

let s:plug_script = expand("~/.config/nvim/autoload/plug.vim")
let s:plug_repo_dir = expand("~/.config/nvim/plugged")

if !filereadable(s:plug_script)
    call system('curl -fLo /home/woody/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim')
    source s:plug_script
endif

let g:loaded_python_provier=1
let g:python3_host_prog='/usr/bin/python3'
let g:python3_host_skip_check=1
let g:python_host_prog='/usr/bin/python'
let g:python_host_skip_check=1
set pyxversion=3

call plug#begin('/home/woody/.config/nvim/plugged')

Plug 'Shougo/neosnippet'
Plug 'Shougo/neosnippet-snippets'
Plug 'jceb/vim-orgmode'
Plug 'honza/vim-snippets'
"Plug 'woodyZootopia/flatwhite-vim'
" Plug 'neoclide/coc.nvim', {'branch': 'release'}
" Plug 'rafi/awesome-vim-colorschemes'
Plug 'sheerun/vim-wombat-scheme'
Plug 'cohama/lexima.vim'
Plug 'Shougo/deoplete.nvim'
Plug 'Shougo/defx.nvim'
Plug 'Shougo/deol.nvim'
Plug 'autozimu/LanguageClient-neovim', {
            \'branch': 'next',
            \'do':     'bash install.sh',
            \}
Plug 'kristijanhusak/defx-git'
Plug 'Shougo/denite.nvim'
Plug 'Shougo/unite-outline'
Plug 'Shougo/neomru.vim'
Plug 'Shougo/neoyank.vim'
Plug 'neoclide/denite-git'
Plug 'Yggdroot/indentLine'
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
Plug 'qnighy/satysfi.vim'
Plug 'ncm2/float-preview.nvim'
Plug 'micke/vim-hybrid'
Plug 'mbbill/undotree'
Plug 'fuenor/jpmoveword.vim'
" Plug 'mattn/sonictemplate-vim'
Plug 'tpope/vim-rhubarb'
Plug 'JuliaEditorSupport/julia-vim'
" Plug 'dense-analysis/ale'
Plug 'itchyny/lightline.vim'
Plug 'jpalardy/vim-slime'
Plug 'tikhomirov/vim-glsl'
Plug 'Shougo/neco-syntax'
Plug 'skywind3000/asyncrun.vim'
" lazy install
Plug 'mattn/emmet-vim', {'for': ['html','vue']}
Plug 'hynek/vim-python-pep8-indent', {'for' : 'python'}
Plug 'bps/vim-textobj-python', {'for' : 'python'}
Plug 'lervag/vimtex', {'for' : ['tex']}
Plug 'hail2u/vim-css3-syntax', {'for' : ['html','htm']}
Plug 'pangloss/vim-javascript', {'for' : ['html','htm']}
Plug 'kchmck/vim-coffee-script', {'for' : ['html','htm']}
Plug 'AtsushiM/search-parent.vim', {'for' : ['sass','scss','css']}
Plug 'akiyan/vim-textobj-php', {'for' : ['html','htm']}
Plug 'tpope/vim-surround', {'for' : ['html','htm']}
Plug 'ap/vim-css-color', {'for' : ['html','htm', 'vim']}
Plug 'cakebaker/scss-syntax.vim', {'for' : ['html','htm']}
Plug 'godlygeek/tabular', {'for' : ['md']}
Plug 'wokalski/autocomplete-flow', {'for' : ['html', 'htm', 'js']}
Plug 'pangloss/vim-javascript', {'for' : 'js'}
Plug 'zeekay/vim-beautify', {'for' : ['html', 'htm', 'js']}
Plug 'AtsushiM/sass-compile.vim', {'for' : ['sass','scss']}
Plug 'qnighy/satysfi.vim', {'for' : ['satysfi','saty']}
Plug 'plasticboy/vim-markdown', {'for' : ['markdown']}
Plug 'rust-lang/rust.vim', {'for': ['rust']}

call plug#end()

if !isdirectory(s:plug_repo_dir)
    exe 'PlugInstall'
endif

" execute plugin specific settings
for f in split(glob('/home/woody/.config/nvim/plugin_settings/*.vim'), '\n')
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
  au filetype           markdown  setlocal noet
  au BufNewFile,BufRead *.grg     setlocal nowrap
  au BufNewFile,BufRead *.jl      setf     julia
  au filetype           help      setlocal listchars=tab:\ \  noet
augroup END

nmap <F5> <localleader>r

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

set backspace=eol,indent,start

set wildmenu
set wildmode=list:full
set wildignore=*.o,*.obj,*.pyc,*.so,*.dll

let g:python_highlight_all = 1

"set clipboard+=unnamedplus

" Always set ...
" LineNr light-green
if g:dark_transparent
    autocmd ColorScheme * highlight LineNr guifg=#b5bd68
    " background transparent
    autocmd ColorScheme * highlight Normal guibg=NONE ctermbg=NONE
    " NonText gray
    autocmd ColorScheme * highlight NonText guibg=NONE ctermbg=NONE guifg=Gray
    colorscheme wombat
else
    autocmd ColorScheme * highlight LineNr guifg=#b5bd68
    " background transparent
    autocmd ColorScheme * highlight Normal guibg=NONE ctermbg=NONE
    " NonText gray
    autocmd ColorScheme * highlight NonText guibg=NONE ctermbg=NONE guifg=Gray
    colorscheme flatwhite
endif

" colorscheme jellybeans
" colorscheme gruvbox
" colorscheme wombat
" colorscheme PaperColor

" use termdebug
packadd termdebug

set mouse=a

"key mapping

tnoremap <silent> <C-[> <C-\><C-n>
tnoremap <silent> <C-l> <C-\><C-n>
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
vnoremap s <Nop>
nnoremap <Space> <Nop>
nnoremap <C-space> <Nop>
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
nnoremap sz :terminal<CR>
nnoremap sz :terminal<CR>
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
noremap t /
noremap / t
noremap T ?
noremap ? T

" quit this window by q
nnoremap <silent> <leader>q :<C-u>q<CR>
" nnoremap <silent> <leader>q :<C-u>bd<CR>
nnoremap <silent> <leader>wq :qa<CR>
nnoremap <silent> <leader>Q :qa<CR>

" delete this buffer by bd
nnoremap <silent> <leader>bd :<C-u>bd<CR>

" center cursor when jumped
setlocal scrolloff=5

" increase and decrease by plus/minus
nnoremap +  <C-a>
nnoremap -  <C-x>
vmap     g+ g<C-a>
vmap     g- g<C-x>

" switch quote and backquote
nnoremap ' `
nnoremap ` '

" save with <C-l> in insert mode
inoremap <C-l> <ESC>:update<CR>a

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

" 補完せず補完ウィンドウを閉じてから移動
inoremap <silent> <expr> <C-b> pumvisible() ? "<C-e><C-r>=ExecExCommand('normal b')<CR>" : "<C-r>=ExecExCommand('normal b')<CR>"
inoremap <silent> <expr> <C-f> pumvisible() ? "<C-e><C-r>=ExecExCommand('normal w')<CR>" : "<C-r>=ExecExCommand('normal w')<CR>"
inoremap <silent> <expr> <A-b> pumvisible() ? "<C-e><C-r>=ExecExCommand('normal h')<CR>" : "<C-r>=ExecExCommand('normal h')<CR>"
inoremap <silent> <expr> <A-f> pumvisible() ? "<C-e><C-r>=ExecExCommand('normal l')<CR>" : "<C-r>=ExecExCommand('normal l')<CR>"

" inoremap <silent> <expr> <C-b> "<C-r>=ExecExCommand('normal b')<CR>"
" inoremap <silent> <expr> <C-f> "<C-r>=ExecExCommand('normal w')<CR>"
" 行移動
inoremap <silent> <expr> <C-p> "<C-r>=ExecExCommand('normal k')<CR>"
inoremap <silent> <expr> <C-n> "<C-r>=ExecExCommand('normal j')<CR>"

function! ExecExCommand(cmd)
  silent exec a:cmd
  return ''
endfunction

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

set spelllang=en,cjk

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
