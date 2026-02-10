local o = vim.opt
local go = vim.opt_global

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
o.number = true
o.relativenumber = true

-- Enable mouse mode
o.mouse = 'a'

-- window minimum size is 0
go.winminheight = 0
go.winminwidth = 0

-- Sync clipboard between OS and Neovim.
vim.o.clipboard = "unnamedplus"

if Env.is_wsl then
  vim.g.clipboard = {
    name = 'WslClipboard',
    copy = {
      ['+'] = { 'sh', '-c', 'iconv -t sjis | clip.exe' },
      ['*'] = { 'sh', '-c', 'iconv -t sjis | clip.exe' },
    },
    paste = {
      ['+'] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
      ['*'] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
    },
    cache_enabled = 0,
  }
elseif not Env.is_vscode and not vim.g.neovide then
  -- "dummy" paste function that just pastes from the unnamed register.
  -- https://zenn.dev/goropikari/articles/506e08e7ad52af
  local function paste()
    return {
      vim.fn.split(vim.fn.getreg(""), "\n"),
      vim.fn.getregtype(""),
    }
  end

  vim.g.clipboard = {
    name = "OSC 52",
    copy = {
      ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
      ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
    },
    paste = {
      ["+"] = paste,
      ["*"] = paste,
    },
  }
end
-- Enable break indent
o.breakindent = true

-- Save undo history
o.undofile = true

-- Case insensitive searching UNLESS /C or capital in search
o.ignorecase = true
o.smartcase = true

-- Keep signcolumn on by default
go.signcolumn = 'yes:1'
go.foldcolumn = '0'

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

-- o.scrolloff = 15

go.laststatus = 3

o.showtabline = 2

o.winblend = 0
o.pumblend = 20

o.smartindent = true
o.expandtab = true

o.formatoptions:append({ 'm', 'M' })

o.inccommand = 'split'

o.colorcolumn = "+1"

o.diffopt:append('vertical,algorithm:patience,indent-heuristic,hiddenoff')

o.wildmode = 'list:full'

o.wildignore:append({ '*.o', '*.obj', '*.pyc', '*.so', '*.dll' })

o.splitbelow = true
o.splitright = true

o.title = true
o.titlestring = '%f%M%R%H'

o.matchpairs:append({ '「:」', '（:）', '『:』', '【:】', '〈:〉', '《:》', '〔:〕', '｛:｝', '<:>' })

o.spelllang = 'en,cjk'
o.spellfile = vim.fn.stdpath('config') .. '/spell/en.utf-8.add'
