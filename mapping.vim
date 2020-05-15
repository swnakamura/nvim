nmap <F5> <localleader>r

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
nnoremap sq <Cmd>tabc<CR>

" move by display line
noremap j  gj
noremap k  gk
noremap gj j
noremap gk k

" always replace considering zenkaku
nnoremap r  gr
nnoremap R  gR
nnoremap gr r
nnoremap gR R


" do not copy when deleting by x
nnoremap x "_x

" swap t and /
noremap t /
noremap / t
noremap T ?
noremap ? T

" quit this window by q
nnoremap <silent> <leader>q <Cmd>q<CR>
" nnoremap <silent> <leader>q :<C-u>bd<CR>
nnoremap <silent> <leader>wq :qa<CR>
nnoremap <silent> <leader>Q :qa<CR>

" delete this buffer by bd
nnoremap <silent> <leader>bd <Cmd>bd<CR>

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
nnoremap <silent> <leader>s <Cmd>update<CR>
nnoremap <silent> <leader>ws <Cmd>wall<CR>

"reload init.vim
nnoremap <silent> <leader>r <Cmd>so ~/.config/nvim/init.vim<CR>

"open init.vim in new tab
nnoremap <silent> <leader>fed <Cmd>tabnew<CR><Cmd>e ~/.config/nvim/init.vim<CR>

" grep
nnoremap <leader>vv :vimgrep // %:p:h/*<Left><Left><Left><Left><Left><Left><Left><Left><Left>

" recursive search
let s:use_vim_grep = 0
if s:use_vim_grep
    nnoremap <leader>vr :vimgrep // %:p:h/**<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>
else
    set grepprg=rg\ --vimgrep\ --no-heading\ -uuu
    " nnoremap <leader>vr :grep -e ""<Left>
    nnoremap <leader>vr :Rg ""<Left>
endif

" quickfix jump
nmap [q :cprevious<CR>   " 前へ
nmap ]q :cnext<CR>       " 次へ
nmap [Q <Cmd>cfirst<CR> " 最初へ
nmap ]Q <Cmd>clast<CR>  " 最後へ

"window-local quickfix jump
nmap [w :lprevious<CR>   " 前へ
nmap ]w :lnext<CR>       " 次へ
nmap [W <Cmd>lfirst<CR> " 最初へ
nmap ]W <Cmd>llast<CR>  " 最後へ

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

map y <Plug>(operator-flashy)

