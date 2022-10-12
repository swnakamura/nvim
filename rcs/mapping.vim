" nmap <F5> <localleader>r

" move to the end of a text after copying
xnoremap <silent> y y`]

" Space+something to move to an end
" noremap <leader>h ^
" noremap <leader>l $
" noremap <leader>k gg
" noremap <leader>j G
nnoremap H ^
nnoremap L $
xnoremap H ^
xnoremap L $

nnoremap <Space> <Nop>
nnoremap <C-space> <Nop>

" unmap s,space
nnoremap <Plug>(my-win) <Nop>
nmap s <Plug>(my-win)
xnoremap s <Nop>
" window control
nnoremap <Plug>(my-win)s <Cmd>split<CR>
nnoremap <Plug>(my-win)v <Cmd>vsplit<CR>
" st is used by nvim-tree
nnoremap <Plug>(my-win)c <Cmd>tab sp<CR>
nnoremap <Plug>(my-win)C <Cmd>-tab sp<CR>
nnoremap <Plug>(my-win)j <C-w>j
nnoremap <Plug>(my-win)k <C-w>k
nnoremap <Plug>(my-win)l <C-w>l
nnoremap <Plug>(my-win)h <C-w>h
nnoremap <Plug>(my-win)J <C-w>J
nnoremap <Plug>(my-win)K <C-w>K
nnoremap <Plug>(my-win)L <C-w>L
nnoremap <Plug>(my-win)H <C-w>H
" nnoremap <Plug>(my-win)z <Cmd>cd %:h<CR><Cmd>terminal<CR>
nnoremap <Plug>(my-win)n gt
nnoremap <Plug>(my-win)p gT
nnoremap <Plug>(my-win)r <C-w>r
nnoremap <Plug>(my-win)= <C-w>=
nnoremap <Plug>(my-win)O <C-w>=
nnoremap <Plug>(my-win)o <C-w>_<C-w>\|
nnoremap <Plug>(my-win)q <Cmd>tabc<CR>
nnoremap <Plug>(my-win)1 <Cmd>1tabnext<CR>
nnoremap <Plug>(my-win)2 <Cmd>2tabnext<CR>
nnoremap <Plug>(my-win)3 <Cmd>3tabnext<CR>
nnoremap <Plug>(my-win)4 <Cmd>4tabnext<CR>
nnoremap <Plug>(my-win)5 <Cmd>5tabnext<CR>
nnoremap <Plug>(my-win)6 <Cmd>6tabnext<CR>
nnoremap <Plug>(my-win)7 <Cmd>7tabnext<CR>
nnoremap <Plug>(my-win)8 <Cmd>8tabnext<CR>
nnoremap <Plug>(my-win)9 <Cmd>9tabnext<CR>

nnoremap <S-Left>  <C-w><<C-w><
nnoremap <S-Right> <C-w>><C-w>>
nnoremap <S-Up>    <C-w>+<C-w>+
nnoremap <S-Down>  <C-w>-<C-w>-

" w!! to save with sudo
cabbr w!! w !sudo tee > /dev/null %

nnoremap <leader><leader> <C-^>

nnoremap <Plug>(my-switch) <Nop>
nmap <localleader> <Plug>(my-switch)
nnoremap <silent> <Plug>(my-switch)s :<C-u>setl spell! spell?<CR>
nnoremap <silent> <Plug>(my-switch)l :<C-u>setl list! list?<CR>
" nnoremap <silent> <Plug>(my-switch)t :<C-u>setl expandtab! expandtab?<CR>
nnoremap <silent> <Plug>(my-switch)w :<C-u>setl wrap! wrap?<CR>
nnoremap <silent> <Plug>(my-switch)p :<C-u>setl paste! paste?<CR>
nnoremap <silent> <Plug>(my-switch)b :<C-u>setl scrollbind! scrollbind?<CR>
nnoremap <silent> <Plug>(my-switch)y :call <SID>toggle_syntax()<CR>
function! s:toggle_syntax() abort
  if exists('g:syntax_on')
    syntax off
    redraw
    echo 'syntax off'
  else
    syntax on
    redraw
    echo 'syntax on'
  endif
endfunction
nnoremap <silent> <Plug>(my-switch)m :call <SID>toggle_move_g()<CR>
function s:toggle_move_g() abort
    if exists('b:gj_gk_enabled')
        unlet b:gj_gk_enabled
        echo 'gj/gk disabled'
        nunmap k
        nunmap j
        xunmap k
        xunmap j
        nunmap gk
        nunmap gj
        xunmap gk
        xunmap gj
    else
        let b:gj_gk_enabled=1
        echo 'gj/gk enabled'
        " move by display line
        nnoremap <expr> j v:count == 0 ? 'gj' : 'j'
        xnoremap <expr> j (v:count == 0 && mode() ==# 'v') ? 'gj' : 'j'
        nnoremap <expr> k v:count == 0 ? 'gk' : 'k'
        xnoremap <expr> k (v:count == 0 && mode() ==# 'v') ? 'gk' : 'k'
        nnoremap gj j
        nnoremap gk k
        xnoremap gj j
        xnoremap gk k
    endif
endfunction
let g:is_noice_enabled = v:true
nnoremap <silent> <Plug>(my-switch)n :call <SID>toggle_noice()<CR>
function s:toggle_noice() abort
    if g:is_noice_enabled
        let g:is_noice_enabled=v:false
        Noice disable
        set cmdheight=1
        echomsg 'noice disabled'
    else
        let g:is_noice_enabled=v:true
        Noice enable
        echomsg 'noice enabled'
    endif
endfunction

" ctrlで画面上・下に移動
nnoremap <C-j> L
nnoremap <C-k> H

" always replace considering doublewidth
nnoremap r  gr
nnoremap R  gR
nnoremap gr r
nnoremap gR R


" do not copy when deleting by x
nnoremap x "_x

" quit this window by q
nnoremap <silent> <leader>q :call <SID>sayonara()<CR>
function s:sayonara() abort
    let bufnr = bufnr()
    quit
    if bufnr->win_findbuf()->len() == 0
        silent! exe 'bdel' bufnr
    endif
endfunction
nnoremap <silent> <leader>wq <Cmd>qa<CR>


" increase and decrease by plus/minus
nnoremap +  <C-a>
nnoremap -  <C-x>
xnoremap g+ g<C-a>
xnoremap g- g<C-x>

" switch quote and backquote
nnoremap ' `
nnoremap ` '

" select pasted text
nnoremap gp `[v`]
nnoremap gP `[V`]

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
nnoremap <silent> <leader>rr <Cmd>so $MYVIMRC<CR>
nnoremap <silent> <leader>re <Cmd>e $MYVIMRC<CR>

"open init.vim in new tab
" nnoremap <silent> <leader>fed <Cmd>tabnew ~/.config/nvim/init.vim<CR>

" grep
nnoremap <leader>vv :<C-u>vimgrep // %:p:h/*<Left><Left><Left><Left><Left><Left><Left><Left><Left>

" recursive search
let s:use_vim_grep = 0
if s:use_vim_grep
    nnoremap <leader>vr :<C-u>vimgrep // %:p:h/**<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>
else
    " nnoremap <silent> <space>vr  <Cmd>Rg<CR>
    set grepprg=rg\ --vimgrep\ --no-heading\ -uuu
    nnoremap <leader>vr :<C-u>grep -e ""<Left>
endif

" quickfix jump
nmap [q <Cmd>cprevious<CR>
nmap ]q <Cmd>cnext<CR>
nmap [Q <Cmd>cfirst<CR>
nmap ]Q <Cmd>clast<CR>

" window-local quickfix jump
nmap [w <Cmd>lprevious<CR>
nmap ]w <Cmd>lnext<CR>
nmap [W <Cmd>lfirst<CR>
nmap ]W <Cmd>llast<CR>

" Open quickfix window
" nnoremap Q <Cmd>copen<CR>

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

" visual modeで複数行を選択して'/'を押すと，その範囲内での検索を行う
xnoremap <expr> / (line('.') == line('v')) ?
            \ '/' :
            \ ((line('.') < line('v')) ? '' : 'o') . "<ESC>" . '/\%>' . (min([line('v'), line('.')])-1) . 'l\%<' . (max([line('v'), line('.')])+1) . 'l'

inoremap <silent> <expr> <C-b> "<C-r>=ExecExCommand('normal b')<CR>"
inoremap <silent> <expr> <C-f> "<C-r>=ExecExCommand('normal w')<CR>"
inoremap <silent> <expr> <C-p> "<C-r>=ExecExCommand('normal gk')<CR>"
inoremap <silent> <expr> <C-n> "<C-r>=ExecExCommand('normal gj')<CR>"

" 移動はこの関数を使わないとうまく行かない
" --nopluginだとうまくいく．Ultisnipあたりが悪さをしているのだろうか？
function! ExecExCommand(cmd)
  silent exec a:cmd
  return ''
endfunction

" quickfix jump
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
