" nmap <F5> <localleader>r

tnoremap <silent> <C-[> <C-\><C-n>
tnoremap <silent> <C-l> <C-\><C-n>
"move to the end of a text after copying/pasting it
vnoremap <silent> y y`]
vnoremap <silent> p p`]
nnoremap <silent> p p`]

" Space+something to move to an end
" noremap <leader>h ^
" noremap <leader>l $
" noremap <leader>k gg
" noremap <leader>j G
noremap H ^
noremap L $

" unmap s,space
nnoremap [Win] <Nop>
vnoremap [Win] <Nop>
nmap s [Win]
vmap s [Win]
nnoremap <Space> <Nop>
nnoremap <C-space> <Nop>
" window control
nnoremap [Win]s <Cmd>split<CR>
nnoremap [Win]v <Cmd>vsplit<CR>
" st is used by defx
nnoremap [Win]c <Cmd>tab sp<CR>
nnoremap [Win]C <Cmd>-tab sp<CR>
nnoremap [Win]j <C-w>j
nnoremap [Win]k <C-w>k
nnoremap [Win]l <C-w>l
nnoremap [Win]h <C-w>h
nnoremap [Win]J <C-w>J
nnoremap [Win]K <C-w>K
nnoremap [Win]L <C-w>L
nnoremap [Win]H <C-w>H
nnoremap [Win]z <Cmd>terminal<CR>
nnoremap [Win]n gt
nnoremap [Win]p gT
nnoremap [Win]r <C-w>r
nnoremap [Win]= <C-w>=
nnoremap [Win]O <C-w>=
nnoremap [Win]o <C-w>_<C-w>\|
nnoremap [Win]q <Cmd>tabc<CR>
nnoremap [Win]1 <Cmd>1tabnext<CR>
nnoremap [Win]2 <Cmd>2tabnext<CR>
nnoremap [Win]3 <Cmd>3tabnext<CR>
nnoremap [Win]4 <Cmd>4tabnext<CR>
nnoremap [Win]5 <Cmd>5tabnext<CR>
nnoremap [Win]6 <Cmd>6tabnext<CR>
nnoremap [Win]7 <Cmd>7tabnext<CR>
nnoremap [Win]8 <Cmd>8tabnext<CR>
nnoremap [Win]9 <Cmd>9tabnext<CR>

nnoremap Q <Cmd>copen<CR>

nnoremap <leader><leader> <C-^>

" move by display line
nnoremap <expr> j v:count == 0 ? 'gj' : 'j'
xnoremap <expr> j (v:count == 0 && mode() ==# 'v') ? 'gj' : 'j'
nnoremap <expr> k v:count == 0 ? 'gk' : 'k'
xnoremap <expr> k (v:count == 0 && mode() ==# 'v') ? 'gk' : 'k'
nnoremap gj j
nnoremap gk k
xnoremap gj j
xnoremap gk k

" always replace considering zenkaku
nnoremap r  gr
nnoremap R  gR
nnoremap gr r
nnoremap gR R


" do not copy when deleting by x
nnoremap x "_x

" swap t and /
" noremap t /
" noremap / t
" noremap T ?
" noremap ? T

" quit this window by q
nnoremap <silent> <leader>q <Cmd>q<CR>
nnoremap <silent> <leader>wq <Cmd>qa<CR>
nnoremap <silent> <leader>Q <Cmd>qa<CR>

" delete this buffer by bd
nnoremap <silent> <leader>bd <Cmd>bd<CR>


" increase and decrease by plus/minus
nnoremap +  <C-a>
nnoremap -  <C-x>
vmap     g+ g<C-a>
vmap     g- g<C-x>

" switch quote and backquote
nnoremap ' `
nnoremap ` '

if !exists('g:vscode')
    " save with <C-l> in insert mode
    inoremap <C-l> <Cmd>update<CR>
    "save by <leader>s
    nnoremap <silent> <leader>s <Cmd>update<CR>
    nnoremap <silent> <leader>ws <Cmd>wall<CR>
else
    nnoremap <leader>s <Cmd>call VSCodeNotify('workbench.action.files.save')<CR>
    inoremap <C-l> <Cmd>call VSCodeNotify('workbench.action.files.save')<CR>
endif

"reload init.vim
" nnoremap <silent> <leader>r <Cmd>so ~/.config/nvim/init.vim<CR>

"open init.vim in new tab
" nnoremap <silent> <leader>fed <Cmd>tabnew ~/.config/nvim/init.vim<CR>

" grep
nnoremap <leader>vv :vimgrep // %:p:h/*<Left><Left><Left><Left><Left><Left><Left><Left><Left>

" recursive search
let s:use_vim_grep = 0
if s:use_vim_grep
    nnoremap <leader>vr <Cmd>vimgrep // %:p:h/**<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>
else
    " nnoremap <silent> <space>vr  <Cmd>Rg<CR>
    set grepprg=rg\ --vimgrep\ --no-heading\ -uuu
    nnoremap <leader>vr <Cmd>grep -e ""<Left>
endif

" quickfix jump
nmap [q <Cmd>cprevious<CR>   " 前へ
nmap ]q <Cmd>cnext<CR>       " 次へ
nmap [Q <Cmd>cfirst<CR> " 最初へ
nmap ]Q <Cmd>clast<CR>  " 最後へ

"window-local quickfix jump
nmap [w <Cmd>lprevious<CR>   " 前へ
nmap ]w <Cmd>lnext<CR>       " 次へ
nmap [W <Cmd>lfirst<CR> " 最初へ
nmap ]W <Cmd>llast<CR>  " 最後へ

" In quickfix window
augroup QuickfixWindow
    autocmd!
    " `p` to preview
    autocmd FileType qf nnoremap <buffer> p <CR>zz<C-w>p
    " always move linewise
    autocmd filetype qf nnoremap <buffer> j j
    autocmd filetype qf nnoremap <buffer> k k
    " capital J/K to move+preview
    autocmd FileType qf nmap <buffer> J jp
    autocmd FileType qf nmap <buffer> K kp
    " Press Q again to close quickfix window
    autocmd FileType qf nnoremap <buffer> Q <Cmd>q<CR>
augroup END

" search with C-p/C-n
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>

" one push to add/remove tabs
nnoremap > >>
nnoremap < <<

" tagsジャンプの時に複数ある時は一覧表示
nnoremap <C-]> g<C-]>

" 補完せず補完ウィンドウを閉じてから移動
" inoremap <silent> <expr> <C-b> pumvisible() ? "<C-e><C-r>=ExecExCommand('normal b')<CR>" : "<C-r>=ExecExCommand('normal b')<CR>"
" inoremap <silent> <expr> <C-f> pumvisible() ? "<C-e><C-r>=ExecExCommand('normal w')<CR>" : "<C-r>=ExecExCommand('normal w')<CR>"
" inoremap <silent> <expr> <A-b> pumvisible() ? "<C-e><C-r>=ExecExCommand('normal h')<CR>" : "<C-r>=ExecExCommand('normal h')<CR>"
" inoremap <silent> <expr> <A-f> pumvisible() ? "<C-e><C-r>=ExecExCommand('normal l')<CR>" : "<C-r>=ExecExCommand('normal l')<CR>"

inoremap <silent> <expr> <C-b> "<C-r>=ExecExCommand('normal b')<CR>"
inoremap <silent> <expr> <C-f> "<C-r>=ExecExCommand('normal w')<CR>"
" 行移動
inoremap <silent> <expr> <C-p> "<C-r>=ExecExCommand('normal gk')<CR>"
inoremap <silent> <expr> <C-n> "<C-r>=ExecExCommand('normal gj')<CR>"

function! ExecExCommand(cmd)
  silent exec a:cmd
  return ''
endfunction

" very magic検索
" nnoremap / /\v
" nnoremap ? ?\v


" quickfix jump
nnoremap <silent> [f <Cmd>cp<CR>
nnoremap <silent> ]f <Cmd>cn<CR>
nnoremap <silent> [F <Cmd>cfirst<CR>
nnoremap <silent> ]F <Cmd>clast<CR>
nnoremap [t <Cmd>lp<CR>
nnoremap ]t <Cmd>lne<CR>
nnoremap [T <Cmd>lfirst<CR>
nnoremap ]T <Cmd>llast<CR>

" 行頭へ移動
cnoremap <C-A> <Home>
inoremap <C-A> <Home>
" 行末へ移動
cnoremap <C-E> <End>
inoremap <C-E> <End>

nnoremap<silent> gss <Cmd>SaveSession<CR>
nnoremap<silent> gsr <Cmd>StartRepeatedSave<CR>
nnoremap<silent> gsl <Cmd>LoadSession<CR>
nnoremap<silent> gsc <Cmd>CleanUpSession<CR>

cabbrev gs GhostStart
