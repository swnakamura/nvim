local o = vim.opt
local go = vim.opt_global
local bo = vim.opt_buffer

o.tabstop = 8
o.softtabstop = 4
o.shiftwidth = 4
o.smartindent = true
o.expandtab = true

-- conceal level
go.conceallevel = 1

-- Set highlight on search
o.hlsearch = false

o.wrapscan = false

-- Make relative line numbers default
vim.wo.number = true
go.relativenumber = true

-- Enable mouse mode
o.mouse = 'a'

-- window minimum size is 0
go.winminheight = 0
go.winminwidth = 0

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
o.clipboard = 'unnamedplus'

-- Enable break indent
o.breakindent = true

-- Save undo history
o.undofile = true

-- Case insensitive searching UNLESS /C or capital in search
o.ignorecase = true
o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Decrease update time
o.updatetime = 250
o.timeout = true
o.timeoutlen = 1000

-- Set completeopt to have a better completion experience
o.completeopt = 'menuone,noselect'

-- NOTE: You should make sure your terminal supports this
o.termguicolors = true

-- Open quickfix window after some commands
vim.cmd("au QuickfixCmdPost make,grep,grepadd,vimgrep copen")

o.cursorline = true

o.shada = "!,'50,<1000,s100,h"

o.sessionoptions:remove({ 'blank', 'buffers' })

o.fileencodings = 'utf-8,ios-2022-jp,euc-jp,sjis,cp932'

o.previewheight = 999

o.list = true
o.listchars = 'leadmultispace:---|,tab:» ,trail:~,extends:»,precedes:«,nbsp:%'

o.scrolloff = 15

go.laststatus = 3

o.showtabline = 2

o.winblend = 0
o.pumblend = 20

o.smartindent = true
o.expandtab = true

o.formatoptions:append({ 'm', 'M' })

o.inccommand = 'split'

o.colorcolumn = "+1"

o.diffopt:append('vertical,algorithm:patience,indent-heuristic')

o.wildmode = 'list:full'

o.wildignore:append({ '*.o', '*.obj', '*.pyc', '*.so', '*.dll' })

o.splitbelow = true
o.splitright = true

o.title = true
o.titlestring = '%f%M%R%H'

o.matchpairs:append({ '「:」', '（:）', '『:』', '【:】', '〈:〉', '《:》', '〔:〕', '｛:｝', '<:>' })

o.spelllang = 'en,cjk'

go.signcolumn = 'yes:1'

