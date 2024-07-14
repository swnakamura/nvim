vim.loader.enable()

local fn = vim.fn

vim.cmd([[
let g:mapleader = "\<Space>"
let g:maplocalleader = "\<C-space>"
]])

-- [[ Setting options ]]

-- tab width settings
vim.o.tabstop = 8
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.smartindent = true
vim.o.expandtab = true

-- conceal level
vim.go.conceallevel = 2

-- Set highlight on search
vim.o.hlsearch = false

-- no wrapscan
vim.o.wrapscan = false

-- Make relative line numbers default
vim.wo.number = true
vim.go.relativenumber = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.o.clipboard = 'unnamedplus'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeout = true
vim.o.timeoutlen = 1000

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

-- Use ripgrep if available
if fn.executable('rg') then
  vim.o.grepprg = 'rg --vimgrep'
  vim.o.grepformat = '%f:%l:%c:%m'
  -- Rgコマンド：引数がないなら選択領域を検索、選択されてもいないならカーソルの単語を検索
  vim.cmd([[
  command -range -nargs=* -complete=file Rg <line1>,<line2>call g:Rg(<q-args>, <range>)
  fun! g:Rg(input, range) range
  if a:range == 2 && a:firstline == a:lastline
  " Assumes that the command is run with visual selection
  " let colrange = charcol('.') < charcol('v') ? [charcol('.'), charcol('v')] : [charcol('v'), charcol('.')]
  let colrange = [charcol("'<"), charcol("'>")]
  let text = getline('.')->strcharpart(colrange[0]-1, colrange[1]-colrange[0]+1)->escape('\')
  elseif empty(a:input)
  let text = expand("<cword>")
  echoerr text
  else
  let text = a:input
  endif
  if text == ''
  echoerr 'search text is empty'
  return
  endif
  exec 'grep' "'" . text . "'"
  endfun
  ]])
end

-- Open quickfix window after some commands
vim.cmd("au QuickfixCmdPost make,grep,grepadd,vimgrep copen")

vim.o.cursorline = true

vim.o.shada = "!,'50,<1000,s100,h"

vim.opt.sessionoptions:remove({ 'blank', 'buffers' })

vim.o.fileencodings = 'utf-8,ios-2022-jp,euc-jp,sjis,cp932'

vim.o.previewheight = 999

vim.o.list = true
vim.o.listchars = 'leadmultispace:|   ,tab:» ,trail:~,extends:»,precedes:«,nbsp:%'

vim.o.scrolloff = 5

vim.go.laststatus = 3

vim.o.showtabline = 2

vim.o.winblend = 0
vim.o.pumblend = 20

vim.o.smartindent = true
vim.o.expandtab = true

vim.opt.formatoptions:append({ 'm', 'M' })

vim.o.inccommand = 'split'

vim.o.colorcolumn = "+1"

vim.o.foldlevel = 99
vim.cmd([[
set foldtext=MyFoldText()
function! MyFoldText()
let line = getline(v:foldstart)
let sub = substitute(line, '/\*\|\*/\|{{{\d\=', '', 'g')
let nline = v:foldend - v:foldstart
return sub . ' <' . nline  . ' lines>' . v:folddashes
endfunction
]])

vim.opt.diffopt:append('vertical,algorithm:patience,indent-heuristic')

vim.o.wildmode = 'list:full'

vim.opt.wildignore:append({ '*.o', '*.obj', '*.pyc', '*.so', '*.dll' })

vim.o.splitbelow = true
vim.o.splitright = true

vim.o.title = true
vim.o.titlestring = '%f%M%R%H'

vim.opt.matchpairs:append({ '「:」', '（:）', '『:』', '【:】', '〈:〉', '《:》', '〔:〕', '｛:｝', '<:>' })

vim.o.spelllang = 'en,cjk'

vim.go.signcolumn = 'yes:1'

-- [[ Basic Keymaps ]]

vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
vim.keymap.set({ 'n', 'v' }, '<Space>o', '<Nop>', { silent = true })
vim.keymap.set({ 'n', 'v' }, '<Space><BS>', '<C-^>', { silent = true })
vim.keymap.set({ 'n', 'v' }, '<C-Space>', '<Nop>', { silent = true })
vim.keymap.set({ 'n', 'v', 'o' }, '<cr>', '<Plug>(clever-f-repeat-forward)', { silent = true })

vim.keymap.set({ 'n', 'v', 'o' }, '<Tab>', '%', { silent = true, remap = true })
vim.keymap.set({ 'n', 'v' }, '<C-i>', '<C-i>', { silent = true })

-- Remap for dealing with word wrap
-- H/L for ^/$
vim.keymap.set({ 'n', 'x' }, 'H', '^')
vim.keymap.set({ 'n', 'x' }, 'L', '$')

-- gj/gk submode
vim.keymap.set('n', 'gj', 'gj<Plug>(g-mode)', { remap = true })
vim.keymap.set('n', 'gk', 'gk<Plug>(g-mode)', { remap = true })
vim.keymap.set('n', '<Plug>(g-mode)j', 'gj<Plug>(g-mode)')
vim.keymap.set('n', '<Plug>(g-mode)k', 'gk<Plug>(g-mode)')
vim.keymap.set('n', '<Plug>(g-mode)', '<Nop>', { remap = true })

-- terminal
-- open terminal in new split with height 15
vim.keymap.set('n', '<C-z>', '<Cmd>15split term://zsh<CR><cmd>set nobuflisted<CR>', { silent = true })
-- In terminal, use <C-[> to go back to the buffer above
vim.keymap.set('t', '<C-[>', [[<C-\><C-n><C-w><C-k>]], { silent = true })
vim.keymap.set('t', '<C-l>', [[<C-\><C-n>]], { silent = true })
-- enter insert mode when entering terminal buffer
vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
    -- if entered to termianl buffer, enter insert mode
    if vim.bo.buftype == 'terminal' then
      vim.cmd('startinsert')
    end
  end
})

vim.cmd([[
" カーソルがインデント内部ならtrue
function! s:in_indent() abort
return col('.') <= indent('.')
endfunction

" カーソルがインデントとずれた位置ならtrue
function! s:not_fit_indent() abort
return !!((col('.') - 1) % shiftwidth())
endfunction

function! s:quantized_h(cnt = 1) abort
if a:cnt > 1 || !&expandtab
execute printf('normal! %sh', a:cnt)
return
endif
normal! h
while s:in_indent() && s:not_fit_indent()
normal! h
endwhile
endfunction

function! s:quantized_l(cnt = 1) abort
if a:cnt > 1 || !&expandtab
execute printf('normal! %sl', a:cnt)
return
endif
normal! l
while s:in_indent() && s:not_fit_indent()
normal! l
endwhile
endfunction

noremap h <cmd>call <sid>quantized_h(v:count1)<cr>
noremap l <cmd>call <sid>quantized_l(v:count1)<cr>
]])

-- do not copy when deleting by x
vim.keymap.set({ 'n', 'x' }, 'x', '"_x')

-- commenting using <C-;> and <C-/>
vim.keymap.set({ "n", "x" }, "<C-/>", "gcc", { remap = true })
vim.keymap.set({ "n", "x" }, "<C-;>", "gcc", { remap = true })
vim.keymap.set({ "v" }, "<C-/>", "gc", { remap = true })
vim.keymap.set({ "v" }, "<C-;>", "gc", { remap = true })

-- window control by s
-- disabled
-- vim.keymap.set('n', '<Plug>(my-win)', '<Nop>')
-- vim.keymap.set('n', 's', '<Plug>(my-win)', { remap = true })
-- vim.keymap.set('x', 's', '<Nop>')
-- window control
vim.keymap.set('n', '<Plug>(my-win)s', '<Cmd>split<CR>')
vim.keymap.set('n', '<Plug>(my-win)v', '<Cmd>vsplit<CR>')
-- st is used by nvim-tree
vim.keymap.set('n', '<Plug>(my-win)c', '<Cmd>tab sp<CR>')
-- vim.keymap.set('n', '<C-w>c', '<Cmd>tab sp<CR>')
-- vim.keymap.set('n', '<C-w><C-c>', '<Cmd>tab sp<CR>')
vim.keymap.set('n', '<Plug>(my-win)C', '<Cmd>-tab sp<CR>')
vim.keymap.set('n', '<Plug>(my-win)j', '<C-w>j')
vim.keymap.set('n', '<Plug>(my-win)k', '<C-w>k')
vim.keymap.set('n', '<Plug>(my-win)l', '<C-w>l')
vim.keymap.set('n', '<Plug>(my-win)h', '<C-w>h')
vim.keymap.set('n', '<Plug>(my-win)J', '<C-w>J')
vim.keymap.set('n', '<Plug>(my-win)K', '<C-w>K')
vim.keymap.set('n', '<Plug>(my-win)n', 'gt')
vim.keymap.set('n', '<Plug>(my-win)p', 'gT')
vim.keymap.set('n', '<Plug>(my-win)L', '<C-w>L')
vim.keymap.set('n', '<Plug>(my-win)H', '<C-w>H')
vim.keymap.set('n', '<Plug>(my-win)r', '<C-w>r')
vim.keymap.set('n', '<Plug>(my-win)=', '<C-w>=')
vim.keymap.set('n', '<Plug>(my-win)O', '<C-w>=')
vim.keymap.set('n', '<Plug>(my-win)o', '<C-w>o')
vim.keymap.set('n', '<Plug>(my-win)1', '<Cmd>1tabnext<CR>')
vim.keymap.set('n', '<Plug>(my-win)2', '<Cmd>2tabnext<CR>')
vim.keymap.set('n', '<Plug>(my-win)3', '<Cmd>3tabnext<CR>')
vim.keymap.set('n', '<Plug>(my-win)4', '<Cmd>4tabnext<CR>')
vim.keymap.set('n', '<Plug>(my-win)5', '<Cmd>5tabnext<CR>')
vim.keymap.set('n', '<Plug>(my-win)6', '<Cmd>6tabnext<CR>')
vim.keymap.set('n', '<Plug>(my-win)7', '<Cmd>7tabnext<CR>')
vim.keymap.set('n', '<Plug>(my-win)8', '<Cmd>8tabnext<CR>')
vim.keymap.set('n', '<Plug>(my-win)9', '<Cmd>9tabnext<CR>')

-- disable Fn in insert mode
for i = 1, 12 do
  vim.keymap.set('i', '<F' .. tostring(i) .. '>', '<Nop>')
end

-- save&exit
vim.keymap.set('i', '<c-l>', '<cmd>update<cr>')
vim.keymap.set('n', '<leader>s', '<cmd>update<cr>')
-- vim.keymap.set('n', 'sq', '<Cmd>quit<CR>')
-- vim.keymap.set('n', 'se', '<cmd>silent! %bdel|edit #|normal `"<C-n><leader>q<cr>')
-- vim.keymap.set('n', 'sQ', '<Cmd>tabc<CR>')
vim.keymap.set('n', '<leader>wq', '<Cmd>quitall<CR>')

-- On certain files, quit by <leader>q
vim.api.nvim_create_augroup('bdel-quit', {})
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'gitcommit', 'lazy', 'help', 'man', 'noice', 'lspinfo', 'qf' },
  callback = function()
    vim.keymap.set('n', '<leader>q', '<Cmd>q<CR>', { buffer = true })
  end,
  group = 'bdel-quit'
})

-- On git commit message file, set colorcolumn at 51
vim.api.nvim_create_augroup('gitcommit-colorcolumn', {})
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'gitcommit',
  command = 'setlocal colorcolumn=51,+1',
  group = 'gitcommit-colorcolumn'
})

-- always replace considering doublewidth
vim.keymap.set('n', 'r', 'gr')
vim.keymap.set('n', 'R', 'gR')
vim.keymap.set('n', 'gr', 'r')
vim.keymap.set('n', 'gR', 'R')

-- do not copy when deleting by x
vim.keymap.set({ 'n', 'x' }, 'gR', 'R')

-- increase and decrease by plus/minus
vim.keymap.set({ 'n', 'x' }, '+', '<c-a>')
vim.keymap.set({ 'n', 'x' }, '-', '<c-x>')
vim.keymap.set('x', 'g+', 'g<c-a>')
vim.keymap.set('x', 'g-', 'g<c-x>')

-- I can remember only one mark anyway
-- vim.keymap.set('n', 'm', 'ma')
-- vim.keymap.set('n', "'", '`a')

-- select pasted text
vim.keymap.set('n', 'gp', '`[v`]')
vim.keymap.set('n', 'gP', '`[V`]')

-- reload init.vim
vim.keymap.set('n', '<leader>re', '<Cmd>e $MYVIMRC<CR>')

-- quickfix jump
vim.keymap.set('n', '[q', '<Cmd>cprevious<CR>')
vim.keymap.set('n', ']q', '<Cmd>cnext<CR>')
vim.keymap.set('n', '[Q', '<Cmd>cfirst<CR>')
vim.keymap.set('n', ']Q', '<Cmd>clast<CR>')

-- window-local quickfix jump
vim.keymap.set('n', '[w', '<Cmd>lprevious<CR>')
vim.keymap.set('n', ']w', '<Cmd>lnext<CR>')
vim.keymap.set('n', '[W', '<Cmd>lfirst<CR>')
vim.keymap.set('n', ']W', '<Cmd>llast<CR>')

-- argument jump
vim.keymap.set('n', '[a', '<Cmd>previous<CR>')
vim.keymap.set('n', ']a', '<Cmd>next<CR>')
vim.keymap.set('n', '[A', '<Cmd>first<CR>')
vim.keymap.set('n', ']A', '<Cmd>last<CR>')

-- search with C-p/C-n
vim.keymap.set('c', '<C-p>', '<Up>')
vim.keymap.set('c', '<C-n>', '<Down>')

-- one push to add/remove tabs
vim.keymap.set('n', '>', '>>')
vim.keymap.set('n', '<', '<<')

-- tagsジャンプの時に複数ある時は一覧表示
vim.keymap.set('n', '<C-]>', 'g<C-]>')

vim.keymap.set('i', '<C-b>', "<Cmd>normal! b<CR>")
vim.keymap.set('i', '<C-f>', "<Cmd>normal! w<CR>")
vim.keymap.set('i', '<C-p>', "<Cmd>normal! gk<CR>")
vim.keymap.set('i', '<C-n>', "<Cmd>normal! gj<CR>")

-- 行頭/行末へ移動
vim.keymap.set({ 'i', 'c' }, '<C-A>', '<Home>')
vim.keymap.set({ 'i', 'c' }, '<C-E>', '<End>')

-- v_CTRL-k/j to move the selected range
vim.keymap.set("x", "<Plug>(my-move-range)", "<Nop>", { silent = true })
vim.keymap.set("x", "<C-j>", ":m '>+1<CR>gv=gv<Plug>(my-move-range)", { silent = true, remap = true })
vim.keymap.set("x", "<C-k>", ":m '<-2<CR>gv=gv<Plug>(my-move-range)", { silent = true, remap = true })
vim.keymap.set("x", "<Plug>(my-move-range)<C-k>", "<Cmd>undojoin | '<,'>m '<-2<CR>gv=gv<Plug>(move-range)",
  { silent = true })
vim.keymap.set("x", "<Plug>(my-move-range)<C-j>", "<Cmd>undojoin | '<,'>m '>+1<CR>gv=gv<Plug>(move-range)",
  { silent = true })

-- Open quickfix window
-- nnoremap Q <Cmd>copen<CR>
-- autocmd for quickfix window
vim.api.nvim_create_augroup('quick-fix-window', {})
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'qf',
  callback = function()
    vim.keymap.set('n', 'p', '<CR>zz<C-w>p', { buffer = true })
    vim.keymap.set('n', 'j', 'j', { buffer = true })
    vim.keymap.set('n', 'k', 'k', { buffer = true })
    vim.keymap.set('n', 'J', 'jp', { buffer = true, remap = true })
    vim.keymap.set('n', 'K', 'kp', { buffer = true, remap = true })
    vim.keymap.set('n', '<C-j>', 'jp', { buffer = true, remap = true })
    vim.keymap.set('n', '<C-k>', 'kp', { buffer = true, remap = true })
    vim.keymap.set('n', 'q', '<Cmd>quit<CR>', { buffer = true })
    vim.keymap.set('n', '<cr>', '<cr>', { buffer = true })
    vim.opt_local.wrap = false
  end,
  group = 'quick-fix-window'
})

vim.api.nvim_create_augroup('markdown-mapping', {})
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'markdown',
  callback = function()
    vim.keymap.set('v', '<C-b>', '<Plug>(operator-surround-append)d*', { buffer = true, silent = true })
    vim.keymap.set('v', '<C-i>', '<Plug>(operator-surround-append)*', { buffer = true, silent = true })
    vim.keymap.set('v', '<Tab>', '%', { buffer = true, silent = true, remap = true })
  end,
  group = 'markdown-mapping'
})

-- [[ frequenly used files ]]
vim.keymap.set('n', '<leader>oo', '<cmd>e ~/org/inbox.org<cr>zR')
vim.keymap.set('n', '<leader>on', '<cmd>e ~/research_vault/notes/note.md<cr>G')
vim.keymap.set('n', '<leader>oi', '<cmd>e ~/research_vault/weekly-issues/issue.md<cr>')



-- [[minor functionalities]]
vim.cmd([[
" abbreviation for vimgrep
" nnoremap <leader>vv :<C-u>vimgrep // %:p:h/*<Left><Left><Left><Left><Left><Left><Left><Left><Left>

" abbreviation for substitution
cnoreabbrev <expr> ss getcmdtype() .. getcmdline() ==# ':ss' ? [getchar(), ''][1] .. "%s///g<Left><Left>" : 'ss'

" visual modeで複数行を選択して'/'を押すと，その範囲内での検索を行う
xnoremap <expr> / (line('.') == line('v')) ?
\ '/' :
\ ((line('.') < line('v')) ? '' : 'o') . "<ESC>" . '/\%>' . (min([line('v'), line('.')])-1) . 'l\%<' . (max([line('v'), line('.')])+1) . 'l'

]])


-- [[autocmd]]
vim.cmd([[
" ファイルタイプごとの設定。複数のファイルタイプで共通することの多い設定をここに書き出しているが、ファイルライプごとの特異性が高いものはftplugin/filetype.vimに書いていく
augroup file-type
au!
au FileType go                                    setlocal tabstop=4 shiftwidth=4 noexpandtab formatoptions+=r
au FileType html,csv,tsv                          setlocal nowrap
au FileType text,mail,markdown,help               setlocal noet      spell
au FileType markdown,org                          setlocal breakindentopt=list:-1
au FileType gitcommit                             setlocal spell
"  テキストについて-もkeywordとする
au FileType text,tex,markdown,gitcommit,help      setlocal isk+=-
"  texについて@もkeywordとする
au FileType tex                                   setlocal isk+=@-@
au FileType log                                   setlocal nowrap

"  長い行がありそうな拡張子なら構文解析を途中でやめる
au FileType csv,tsv,json                          setlocal synmaxcol=256

"  インデントの有りそうなファイルならbreakindent
au FileType c,cpp,rust,go,python,lua,bash,vim,tex,markdown setlocal breakindent
augroup END

" used in 'ftplugin/python.vim' etc
function! Preserve(command)
let l:curw = winsaveview()
execute a:command
call winrestview(l:curw)
return ''
endfunction

" 検索中の領域をハイライトする
augroup vimrc-incsearch-highlight
au!
" 検索に入ったときにhlsearchをオン
au CmdlineEnter /,\? set hlsearch
nnoremap n n<Cmd>set hlsearch<CR><Cmd>autocmd CursorMoved * ++once set nohlsearch<CR>
nnoremap N N<Cmd>set hlsearch<CR><Cmd>autocmd CursorMoved * ++once set nohlsearch<CR>
" CmdlineLeave時に即座に消す代わりに、少し待って、更にカーソルが動いたときに消す
" カーソルが動いたときにすぐ消すようにすると、検索された単語に移動した瞬間に消えてしまうので意味がない。その防止
au CmdlineLeave /,\? autocmd CursorHold * ++once autocmd CursorMoved * ++once set nohlsearch
" au CmdlineLeave /,\? set nohlsearch
augroup END

" 選択した領域を自動でハイライトする
" treesitterを使っているときは使えない？ のでdisable
" augroup instant-visual-highlight
" au!
" autocmd CursorMoved,CursorHold * call Visualmatch()
" augroup END

function! Visualmatch()
  if exists("w:visual_match_id")
    call matchdelete(w:visual_match_id)
    unlet w:visual_match_id
  endif

  if index(['v', "\<C-v>"], mode()) == -1
    return
  endif


  if line('.') == line('v')
  let colrange = charcol('.') < charcol('v') ? [charcol('.'), charcol('v')] : [charcol('v'), charcol('.')]
  let text = getline('.')->strcharpart(colrange[0]-1, colrange[1]-colrange[0]+1)->escape('\')
  elseif mode() == 'v' " multiline matchingはvisual modeのみ
  if line('.') > line('v')
  let linerange = ['v','.']
  else
  let linerange = ['.','v']
  endif
  let lines=getline(linerange[0], linerange[1])
  let lines[0] = lines[0]->strcharpart(charcol(linerange[0])-1)
  let lines[-1] = lines[-1]->strcharpart(0,charcol(linerange[1]))
  let text = lines->map({key, line -> line->escape('\')})->join('\n')
  else
  let text = ''
  endif

  " virtualeditの都合でempty textが選択されることがある．
  " この場合全部がハイライトされてしまうので除く
  if text == ''
  return
  endif

  if mode() == 'v'
  let w:visual_match_id = matchadd('VisualMatch', '\V' .. text)
  else
  let w:visual_match_id = matchadd('VisualMatch', '\V\<' .. text .. '\>')
  endif
endfunction

" 単語を自動でハイライトする
augroup cursor-word-highlight
au!
autocmd CursorHold * call Wordmatch()
autocmd InsertEnter * call DelWordmatch()
augroup END

function! Wordmatch()
if index(['fern','neo-tree','floaterm','oil','org'], &ft) != -1
return
endif
call DelWordmatch()
if &hlsearch
" avoid interfering with hlsearch
return
endif

let w:cursorword = expand('<cword>')->escape('\')
if w:cursorword != ''
let w:wordmatch_id =  matchadd('CursorWord','\V\<' .. w:cursorword .. '\>')
endif

" if exists('w:wordmatch_tid')
"     call timer_stop(w:wordmatch_tid)
"     unlet w:wordmatch_tid
" endif
" let w:wordmatch_tid = timer_start(200, 'DelWordmatch')
endfunction

function! DelWordmatch(...)
if exists('w:wordmatch_id')
call matchdelete(w:wordmatch_id)
unlet w:wordmatch_id
endif
endfunction

augroup numbertoggle
autocmd!
autocmd BufEnter,FocusGained,InsertLeave,WinEnter * if &nu && mode() != "i" | set rnu   | endif
autocmd BufLeave,FocusLost,InsertEnter,WinLeave   * if &nu                  | set nornu | endif
augroup END

augroup if-binary-then-xxd
au!
au BufReadPre *.bin     let b:bin_xxd=1
au BufReadPre *.img     let b:bin_xxd=1
au BufReadPre *.sys     let b:bin_xxd=1
au BufReadPre *.out     let b:bin_xxd=1
au BufReadPre *.a       let b:bin_xxd=1

au BufReadPost * if exists('b:bin_xxd') | %!xxd
au BufReadPost * setlocal ft=xxd | endif

au BufWritePre * if exists('b:bin_xxd') | %!xxd -r
au BufWritePre * endif

au BufWritePost * if exists('b:bin_xxd') | %!xxd
au BufWritePost * set nomod | endif
augroup END

" augroup csv-tsv
"   au!
"   au BufReadPost,BufWritePost *.csv call Preserve('silent %!column -s, -o, -t -L')
"  au BufReadPost,BufWritePost *.csv call Preserve('silent %!column -s, -t') " macOS
"   au BufWritePre              *.csv call Preserve('silent %s/\s\+\ze,/,/ge')
"   au BufReadPost,BufWritePost *.tsv call Preserve('silent %!column -s "$(printf ''\t'')" -o "$(printf ''\t'')" -t -L')
"   au BufWritePre              *.tsv call Preserve('silent %s/ \+\ze	//ge')
"   au BufWritePre              *.tsv call Preserve('silent %s/\s\+$//ge')
" augroup END

fu! s:isdir(dir) abort
return !empty(a:dir) && (isdirectory(a:dir) ||
\ (!empty($SYSTEMDRIVE) && isdirectory('/'.tolower($SYSTEMDRIVE[0]).a:dir)))
endfu


augroup jupyter-notebook
au!
au BufReadPost *.ipynb %!jupytext --from ipynb --to py:percent
au BufReadPost *.ipynb set filetype=python
au BufWritePre *.ipynb let g:jupyter_previous_location = getpos('.')
au BufWritePre *.ipynb silent %!jupytext --from py:percent --to ipynb
au BufWritePost *.ipynb silent %!jupytext --from ipynb --to py:percent
au BufWritePost *.ipynb if exists('g:jupyter_previous_location') | call setpos('.', g:jupyter_previous_location) | endif
augroup END

augroup lua-highlight
autocmd!
autocmd TextYankPost * silent! lua vim.highlight.on_yank({higroup='Pmenu', timeout=200})
augroup END
]])

vim.cmd([[
function Float(key)
while v:true
" 現在位置に文字がある間……
exec 'normal! ' a:key
if line(".") <= 1 || line(".") >= line("$") || (strlen(getline(".")) < col(".") || getline(".")[col(".") - 1] =~ '\s')
break
endif
endwhile
while v:true
" 現在位置が空白文字である間……
exec 'normal! ' a:key
if line(".") <= 1 || line(".") >= line("$") || !(strlen(getline(".")) < col(".") || getline(".")[col(".") - 1] =~ '\s')
break
endif
endwhile
endfunction
]])

vim.keymap.set({ 'n', 'v' }, '<leader>k', [[<Cmd>call Float('k')<CR>]])
vim.keymap.set({ 'n', 'v' }, '<leader>j', [[<Cmd>call Float('j')<CR>]])

-- [[ switch settings with local leader ]]
vim.cmd([[
  nnoremap <Plug>(my-switch) <Nop>
  nmap <localleader> <Plug>(my-switch)
  nnoremap <silent> <Plug>(my-switch)s     <Cmd>setl spell! spell?<CR>
  nnoremap <silent> <Plug>(my-switch)<C-s> <Cmd>setl spell! spell?<CR>
  nnoremap <silent> <Plug>(my-switch)l     <Cmd>setl list! list?<CR>
  nnoremap <silent> <Plug>(my-switch)<C-l> <Cmd>setl list! list?<CR>
  nnoremap <silent> <Plug>(my-switch)t     <Cmd>setl expandtab! expandtab?<CR>
  nnoremap <silent> <Plug>(my-switch)<C-t> <Cmd>setl expandtab! expandtab?<CR>
  nnoremap <silent> <Plug>(my-switch)w     <Cmd>setl wrap! wrap?<CR>
  nnoremap <silent> <Plug>(my-switch)<C-w> <Cmd>setl wrap! wrap?<CR>
  nnoremap <silent> <Plug>(my-switch)b     <Cmd>setl scrollbind! scrollbind?<CR>
  nnoremap <silent> <Plug>(my-switch)<C-b> <Cmd>setl scrollbind! scrollbind?<CR>
  nnoremap <silent> <Plug>(my-switch)d     <Cmd>if !&diff \| diffthis \| else \| diffoff \| endif \| set diff?<CR>
  nnoremap <silent> <Plug>(my-switch)<C-d> <Cmd>if !&diff \| diffthis \| else \| diffoff \| endif \| set diff?<CR>
  nnoremap <silent> <Plug>(my-switch)c     <Cmd>if &conceallevel > 0 \| set conceallevel=0 \| else \| set conceallevel=2 \| endif \| set conceallevel?<CR>
  nnoremap <silent> <Plug>(my-switch)<C-c> <Cmd>if &conceallevel > 0 \| set conceallevel=0 \| else \| set conceallevel=2 \| endif \| set conceallevel?<CR>
  nnoremap <silent> <Plug>(my-switch)y     <Cmd>call Toggle_syntax()<CR>
  nnoremap <silent> <Plug>(my-switch)<C-y> <Cmd>call Toggle_syntax()<CR>
  nnoremap <silent> <Plug>(my-switch)n     <Cmd>call Toggle_noice()<CR>
  nnoremap <silent> <Plug>(my-switch)<C-n> <Cmd>call Toggle_noice()<CR>
  function! Toggle_syntax() abort
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
  let g:is_noice_enabled = v:true
  function Toggle_noice() abort
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
]])


-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- vim: ts=2 sts=2 sw=2 et
