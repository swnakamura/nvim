-- [[ Keymap Helper ]]
-- Usage: map({mode}, lhs, rhs, opts)
-- Sets keymaps with default options (silent=true, noremap=true)
---@overload fun(mode: string|table, lhs: string, rhs: string|function, opts: table): nil
---@overload fun(mode: string|table, lhs: string, rhs: string|function): nil
local function map(mode, lhs, rhs, opts)
  opts = opts or {}
  if opts.silent == nil then opts.silent = true end
  vim.keymap.set(mode, lhs, rhs, opts)
end

local vapi = vim.api
local vfn = vim.fn

map({ 'n', 'v' }, '<Space>o', '<Nop>')
map('n', '<C-h>', '<C-w>h')
map('n', '<C-l>', '<C-w>l')

-- copy and paste
if vim.g.neovide then
  for _, m in ipairs({ 'A', 'D' }) do
    map('v', '<' .. m .. '-c>', '"+y')    -- Copy
    map('n', '<' .. m .. '-v>', '"+P')    -- Paste normal mode
    map('v', '<' .. m .. '-v>', '"+P')    -- Paste visual mode
    map('c', '<' .. m .. '-v>', '<C-R>+') -- Paste command mode
    map('i', '<' .. m .. '-v>', '<C-R>+') -- Paste insert mode
  end
end

-- move cursor to the center of the window lr
map('n', 'z.', 'zezL')

-- Tabs is used as %, while <C-i> remains as go to next location
map({ 'n', 'v', 'o' }, '<Tab>', '%', { remap = true })
map({ 'n', 'v' }, '<C-i>', '<C-i>')

-- Pseudo operator for selecting the whole text
map('v', 'iv', 'gg0oG$')
map('o', 'iv', ':<C-u>normal! gg0vG$<CR>')
map('v', 'av', 'gg0oG$')
map('o', 'av', ':<C-u>normal! gg0vG$<CR>')

-- Swap p and P in visual mode pasting (p should not overwrite the register)
map('v', 'p', 'P')
map('v', 'P', 'p')

-- gj/gk submode
map('n', 'gj', 'gj<Plug>(g-mode)', { remap = true })
map('n', 'gk', 'gk<Plug>(g-mode)', { remap = true })
map('n', '<Plug>(g-mode)j', 'gj<Plug>(g-mode)')
map('n', '<Plug>(g-mode)k', 'gk<Plug>(g-mode)')
map('n', '<Plug>(g-mode)', '<Nop>', { remap = true })

-- keymap for alternate file
map({ 'n', 'v' }, '<leader><leader>', '<C-^>')

-- keymap for ex command
-- map({ 'n', 'v' }, ';', ':')
map({ 'n', 'v' }, '<leader>;', ':')

-- [[ Quantized h/l ]]

-- カーソルがインデント内部ならtrue
local function in_indent()
  return vfn.col('.') <= vfn.indent('.')
end

-- カーソルがインデントとずれた位置ならtrue
local function not_fit_indent()
  return ((vfn.col('.') - 1) % vfn.shiftwidth()) ~= 0
end

function Quantized_h(cnt)
  cnt = cnt or 1
  if cnt > 1 or not vim.o.expandtab then
    vim.cmd(string.format('normal! %sh', cnt))
    return
  end
  vim.cmd('normal! h')
  while in_indent() and not_fit_indent() do
    vim.cmd('normal! h')
  end
end

function Quantized_l(cnt)
  cnt = cnt or 1
  if cnt > 1 or not vim.o.expandtab then
    vim.cmd(string.format('normal! %sl', cnt))
    return
  end
  vim.cmd('normal! l')
  while in_indent() and not_fit_indent() do
    vim.cmd('normal! l')
  end
end

map('n', 'h', '<cmd>lua Quantized_h(vim.v.count1)<CR>', { silent = true })
map('n', 'l', '<cmd>lua Quantized_l(vim.v.count1)<CR>', { silent = true })

-- [[ H/L in indent]]
map({ 'n', 'x' }, 'H', function()
  if vfn.col('.') - 1 <= vfn.indent('.') then
    vim.cmd('normal! zc')
  else
    vim.cmd('normal! ^')
  end
end
)
map({ 'n', 'x' }, 'L', function()
  if vfn.foldclosed('.') ~= -1 then
    vim.cmd('normal! zo')
  else
    vim.cmd('normal! $')
  end
end)


-- do not copy when deleting by x
map({ 'n', 'x' }, 'x', '"_x')

-- commenting using <C-;>
do
  local operator_rhs = function()
    return require('vim._comment').operator()
  end
  vim.keymap.set({ 'n', 'x' }, '<C-;>', operator_rhs, { expr = true, desc = 'Toggle comment' })

  local line_rhs = function()
    return require('vim._comment').operator() .. '_'
  end
  vim.keymap.set('n', '<C-;>', line_rhs, { expr = true, desc = 'Toggle comment line' })
end

-- comment after copying
map({ "n" }, "<leader>cy", "yygcc", { remap = true })
map({ "v" }, "<leader>cy", "ygvgc", { remap = true })

-- window control by s
map('n', '<Plug>(my-win)', '<Nop>')
map('n', 's', '<Plug>(my-win)', { remap = true })
-- window control
map('n', '<Plug>(my-win)s', '<Cmd>split<CR>')
map('n', '<Plug>(my-win)v', '<Cmd>vsplit<CR>')
-- st is used by nvim-tree
map('n', '<Plug>(my-win)c', '<Cmd>tab sp<CR>')
map('n', '<Plug>(my-win)C', '<Cmd>tabc<CR>')
map('n', '<Plug>(my-win)j', '<C-w>j')
map('n', '<Plug>(my-win)k', '<C-w>k')
map('n', '<Plug>(my-win)l', '<C-w>l')
map('n', '<Plug>(my-win)h', '<C-w>h')
map('n', '<Plug>(my-win)J', '<C-w>J')
map('n', '<Plug>(my-win)K', '<C-w>K')
map('n', '<Plug>(my-win)n', 'gt')
map('n', '<Plug>(my-win)p', 'gT')
map('n', '<Plug>(my-win)L', '<C-w>L')
map('n', '<Plug>(my-win)H', '<C-w>H')
map('n', '<Plug>(my-win)r', '<C-w>r')
map('n', '<Plug>(my-win)=', '<C-w>=')
map('n', '<Plug>(my-win)O', '<Cmd>tabonly<CR>')
map('n', '<Plug>(my-win)o', '<C-w>|<C-w>_')
map('n', '<Plug>(my-win)1', '<Cmd>1tabnext<CR>')
map('n', '<Plug>(my-win)2', '<Cmd>2tabnext<CR>')
map('n', '<Plug>(my-win)3', '<Cmd>3tabnext<CR>')
map('n', '<Plug>(my-win)4', '<Cmd>4tabnext<CR>')
map('n', '<Plug>(my-win)5', '<Cmd>5tabnext<CR>')
map('n', '<Plug>(my-win)6', '<Cmd>6tabnext<CR>')
map('n', '<Plug>(my-win)7', '<Cmd>7tabnext<CR>')
map('n', '<Plug>(my-win)8', '<Cmd>8tabnext<CR>')
map('n', '<Plug>(my-win)9', '<Cmd>9tabnext<CR>')

-- disable Fn in insert mode
for i = 1, 12 do
  map('i', '<F' .. tostring(i) .. '>', '<Nop>')
end

-- save&exit
map('i', '<c-l>', '<cmd>update<cr>')
map('n', '<leader>fs', '<cmd>update<cr>')
map('n', '<leader>fS', '<cmd>wall<cr>')
-- map('n', 'sq', '<Cmd>quit<CR>')
-- map('n', 'se', '<cmd>silent! %bdel|edit #|normal `"<C-n><leader>q<cr>')
-- map('n', 'sQ', '<Cmd>tabc<CR>')
map('n', '<leader>qq', '<Cmd>quitall<CR>')
map('n', '<leader>qs', '<Cmd>update<cr><cmd>quit<CR>')
map('n', '<leader>qQ', '<Cmd>quitall!<CR>')

-- On certain files, quit by <leader>q
vapi.nvim_create_augroup('bdel-quit', {})
vapi.nvim_create_autocmd('FileType', {
  pattern = { 'gitcommit', 'lazy', 'help', 'man', 'noice', 'lspinfo', 'qf' },
  callback = function()
    map('n', '<leader>q', '<Cmd>q<CR>', { buffer = true })
  end,
  group = 'bdel-quit'
})

-- On git commit message file, set colorcolumn at 51
vapi.nvim_create_augroup('gitcommit-colorcolumn', {})
vapi.nvim_create_autocmd('FileType', {
  pattern = 'gitcommit',
  command = 'setlocal colorcolumn=51,+1',
  group = 'gitcommit-colorcolumn'
})

-- always replace considering doublewidth
map('n', 'r', 'gr')
map('n', 'R', 'gR')
map('n', 'gr', 'r')
map('n', 'gR', 'R')

-- do not copy when deleting by x
map({ 'n', 'x' }, 'gR', 'R')

-- increase and decrease by plus/minus
map({ 'n', 'x' }, '+', '<c-a>')
map({ 'n', 'x' }, '-', '<c-x>')
map('x', 'g+', 'g<c-a>')
map('x', 'g-', 'g<c-x>')

-- I can remember only one mark anyway
-- map('n', 'm', 'ma')
-- map('n', "'", '`a')

-- select pasted text
map('n', 'gp', '`[v`]')
map('n', 'gP', '`[V`]')

-- quickfix jump
map('n', '[q', '<Cmd>cprevious<CR>')
map('n', ']q', '<Cmd>cnext<CR>')
map('n', '[Q', '<Cmd>cfirst<CR>')
map('n', ']Q', '<Cmd>clast<CR>')

-- window-local quickfix jump
map('n', '[w', '<Cmd>lprevious<CR>')
map('n', ']w', '<Cmd>lnext<CR>')
map('n', '[W', '<Cmd>lfirst<CR>')
map('n', ']W', '<Cmd>llast<CR>')

-- argument jump
map('n', '[a', '<Cmd>previous<CR>')
map('n', ']a', '<Cmd>next<CR>')
map('n', '[A', '<Cmd>first<CR>')
map('n', ']A', '<Cmd>last<CR>')

-- search with C-p/C-n
map('c', '<C-p>', '<Up>')
map('c', '<C-n>', '<Down>')

-- one push to add/remove tabs
map('n', '>', '>>')
map('n', '<', '<<')

-- tagsジャンプの時に複数ある時は一覧表示
-- map('n', '<C-]>', 'g<C-]>')

map('i', '<C-b>', "<Cmd>normal! b<CR>")
map('i', '<C-f>', "<Cmd>normal! w<CR>")
map('i', '<C-p>', "<Cmd>normal! gk<CR>")
map('i', '<C-n>', "<Cmd>normal! gj<CR>")

-- 行頭/行末へ移動
map({ 'i', 'c' }, '<C-A>', '<Home>')
map({ 'i', 'c' }, '<C-E>', '<End>')

-- Open quickfix window
-- nnoremap Q <Cmd>copen<CR>
-- autocmd for quickfix window
vapi.nvim_create_augroup('quick-fix-window', {})
vapi.nvim_create_autocmd('FileType', {
  pattern = 'qf',
  callback = function()
    map('n', 'p', '<CR>zz<C-w>p', { buffer = true })
    map('n', 'j', 'j', { buffer = true })
    map('n', 'k', 'k', { buffer = true })
    map('n', 'J', 'jp', { buffer = true, remap = true })
    map('n', 'K', 'kp', { buffer = true, remap = true })
    map('n', '<C-j>', 'jp', { buffer = true, remap = true })
    map('n', '<C-k>', 'kp', { buffer = true, remap = true })
    map('n', 'q', '<Cmd>quit<CR>', { buffer = true })
    map('n', '<cr>', '<cr>', { buffer = true })
    vim.opt_local.wrap = false
  end,
  group = 'quick-fix-window'
})

vapi.nvim_create_augroup('markdown-mapping', {})
vapi.nvim_create_autocmd('FileType', {
  pattern = 'markdown',
  callback = function()
    map('v', '<C-b>', '<Plug>(operator-surround-append)d*', { buffer = true, silent = true })
    map('v', '<C-i>', '<Plug>(operator-surround-append)*', { buffer = true, silent = true })
    map('v', '<Tab>', '%', { buffer = true, silent = true, remap = true })
  end,
  group = 'markdown-mapping'
})

-- [[ frequenly used files ]]
map('n', '<leader>oo', '<cmd>e ~/org/inbox.org<cr>zR')
map('n', '<leader>on', '<cmd>e ~/research_vault/notes/note.md<cr>G')
map('n', '<leader>oi', '<cmd>e ~/research_vault/weekly-issues/issue.md<cr>')
-- <leader>fed to open init.lua
map('n', '<leader>fed', '<Cmd>edit $MYVIMRC<CR>')

-- [[ Float keymap (jump until non-whitespace is found) ]]
MoveUntilNonWS = function(up)
  local curpos = vfn.getcurpos()
  -- 現在位置に文字がある間……
  while true do
    curpos[2] = curpos[2] + up
    vfn.cursor(curpos[2], curpos[3])
    if vfn.line('.') <= 1 or vfn.line('.') >= vfn.line('$') or (vfn.strlen(vfn.getline('.')) < vfn.col('.') or vfn.getline("."):sub(vfn.col('.'), vfn.col('.')) == ' ') then
      break
    end
  end
  -- 現在位置が空白文字である間……
  while true do
    curpos[2] = curpos[2] + up
    vfn.cursor(curpos[2], curpos[3])
    if vfn.line('.') <= 1 or vfn.line('.') >= vfn.line('$') or not (vfn.strlen(vfn.getline('.')) < vfn.col('.') or vfn.getline("."):sub(vfn.col('.'), vfn.col('.')) == ' ') then
      break
    end
  end
end

map({ 'n', 'v' }, '<leader>k', [[<Cmd>lua MoveUntilNonWS(-1)<CR>]])
map({ 'n', 'v' }, '<leader>j', [[<Cmd>lua MoveUntilNonWS(1)<CR>]])

-- [[ toggle/switch settings with local leader ]]
local toggle_prefix = [[\]]
map('n', toggle_prefix .. 's', '<Cmd>setl spell! spell?<CR>', { silent = true, desc = 'toggle spell' })
map('n', toggle_prefix .. 'a', function()
  if vim.b.autosave_enabled then
    vim.b.autosave_enabled = false
    print('Autosave disabled')
  else
    vim.b.autosave_enabled = true
    print('Autosave enabled')
  end
end, { silent = true, desc = 'toggle autosave' })
map('n', toggle_prefix .. 'l', '<Cmd>setl list! list?<CR>', { silent = true, desc = 'toggle list' })
map('n', toggle_prefix .. 't', '<Cmd>setl expandtab! expandtab?<CR>', { silent = true, desc = 'toggle expandtab' })
map('n', toggle_prefix .. 'w', '<Cmd>setl wrap! wrap?<CR>', { silent = true, desc = 'toggle wrap' })
map('n', toggle_prefix .. 'b', '<Cmd>setl cursorbind! cursorbind?<CR>', { silent = true, desc = 'toggle cursorbind' })
map('n', toggle_prefix .. 'd', function()
  if vim.o.diff then
    vim.cmd('diffoff')
    print('Diff off')
  else
    vim.cmd('diffthis')
    print('Diff on')
  end
end, { silent = true, desc = 'toggle diff' })
map('n', toggle_prefix .. 'D', function()
  if vim.o.diff then
    vim.cmd('diffoff!')
    print('Diff off for all buffers')
  else
    vim.cmd('windo diffthis')
    print('Diff on for all buffers')
  end
end, { silent = true, desc = 'toggle diff' })
map('n', toggle_prefix .. 'c', function()
  if vim.o.conceallevel > 0 then
    vim.o.conceallevel = 0
    print('Conceal off')
  else
    vim.o.conceallevel = 2
    print('Conceal on')
  end
end, { silent = true, desc = 'toggle conceallevel' })
map('n', toggle_prefix .. 'y', function()
  if vim.o.clipboard == 'unnamedplus' then
    vim.o.clipboard = ''
    print('clipboard=')
  else
    vim.o.clipboard = 'unnamedplus'
    print('clipboard=unnamedplus')
  end
end, { silent = true, desc = 'toggle clipboard' })

Env.is_noice_enabled = true
Toggle_noice = function()
  if Env.is_noice_enabled then
    Env.is_noice_enabled = false
    vim.cmd('Noice disable')
    vim.opt.cmdheight = 1
    print('Noice disabled')
  else
    Env.is_noice_enabled = true
    vim.cmd('Noice enable')
    print('Noice enabled')
  end
end
map('n', toggle_prefix .. 'n', Toggle_noice, { silent = true, desc = 'toggle noice' })
