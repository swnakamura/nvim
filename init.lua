vim.loader.enable()

local vfn = vim.fn
local vapi = vim.api

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

-- Do not load some of the default plugins
vim.g.loaded_netrwPlugin = true

vim.g.mapleader = " "

-- Install lazy.nvim (package manager)
local lazypath = vfn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
  vfn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable',
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- [[ Environment Detection ]]
-- Encapsulate environment checks for clarity and maintainability
local function detect_env()
  local env = {}
  env.is_wsl = vfn.has('wsl') == 1
  env.is_macos = vfn.has('mac') == 1
  env.is_linux = vfn.has('unix') == 1 and not env.is_macos
  env.is_vscode = vfn.exists('g:vscode') == 1
  env.is_ssh = vfn.getenv('SSH_CONNECTION') ~= vim.NIL
  env.is_wide_for_neotree = vim.o.columns > 200 and vfn.argc() > 0
  return env
end

Env = detect_env()
vim.g.is_wsl = Env.is_wsl
vim.g.is_macos = Env.is_macos
vim.g.is_vscode = Env.is_vscode
vim.g.is_linux = Env.is_linux
vim.g.is_ssh = Env.is_ssh
vim.g.is_wide_for_neotree = Env.is_wide_for_neotree

_G.LazyVim = require("lazyvim.util")

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
end


-- print warning if inotifywait not found on linux system
if Env.is_linux and vim.fn.executable('inotifywait') ~= 1 then
  vim.notify("inotifywait not found. Some features may not work properly.", vim.log.levels.WARN)
end

-- [[ Neovide settings ]]
vim.g.neovide_cursor_animation_length = 0.10 -- default 0.13
vim.g.neovide_cursor_trail_size = 0.2 -- default 0.8
if Env.is_macos then
  vim.o.guifont = "JetBrains Mono:h12"
else
  vim.o.guifont = "JetBrains Mono Light:h12"
end

-- [[ Plugin settings ]]

local treesitter_filetypes = { 'bibtex', 'bash', 'c', 'cpp', 'css', 'go', 'html', 'lua', 'markdown', 'markdown_inline', 'python', 'rust', 'latex', 'tsx', 'typescript', 'vimdoc', 'vim', 'yaml' }


local event = require("lazy.core.handler.event")

event.mappings.LazyFile = { id = "LazyFile", event = { "BufReadPost", "BufNewFile", "BufWritePre", "BufAdd" } }
event.mappings["User LazyFile"] = event.mappings.LazyFile

require('lazy').setup({

  -- noice
  {
    "folke/noice.nvim",
    event = "LazyFile",
    opts = {
      -- add any options here
      notify = {
        enabled = false
      },
      views = {
        cmdline_popup = {
          filter_options = {},
          win_options = {
            winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
          },
        },
      },
      lsp = {
        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
        signature = {
          enabled = false,
        }
      },
      -- you can enable a preset for easier configuration
      presets = {
        -- bottom_search = true,         -- use a classic bottom cmdline for search
        -- command_palette = true,       -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = false,           -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = true,       -- add a border to hover docs and signature help
      },
    },
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      "MunifTanjim/nui.nvim",
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      -- "rcarriga/nvim-notify",
    },
  },

  -- snacks.nvim (many QoL plugins)
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    keys = {
      -- Find
      { "<leader>fr", function() Snacks.picker.smart({ layout='telescope' }) end, desc = "Smart Find Files" },
      { "<leader>fR", function() Snacks.picker.recent({ layout='telescope' }) end, desc = "Recent Files" },
      { "<leader>fp", function() Snacks.picker.projects({ layout='telescope' }) end, desc = "Projects" },
      { "<leader>ff", function() Snacks.picker.files({ layout='telescope' }) end, desc = "Smart Find Files" },
      { "<leader>fb", function() Snacks.picker.buffers({ layout='telescope' }) end, desc = "Buffers" },
      { "<leader>fg", function() Snacks.picker.git_files({ layout='telescope' }) end, desc = "Find Git Files" },
      { "<leader>fc", function() Snacks.picker.command_history({ layout='telescope' }) end, desc = "Command History" },
      { "<leader>fn", function() Snacks.picker.notifications({ layout='telescope' }) end, desc = "Notification History" },

      -- Grep
      { "<leader>sb", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
      { "<leader>sB", function() Snacks.picker.grep_buffers({ layout='telescope' }) end, desc = "Grep Open Buffers" },
      { "<leader>sw", function() Snacks.picker.grep_word({ layout='telescope' }) end, desc = "Visual selection or word", mode = { "n", "x" } },
      { "<leader>sg", function() Snacks.picker.grep({ layout='telescope',
        args = {
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--smart-case",
          "--max-columns=500",
          "--max-columns-preview",
          "-g",
          "!.git",
          "-u", -- added
        }
      }) end, desc = "Grep" },
      { "<leader>sG",
        function()
          local cwd = vfn.expand "%:p:h"
          -- for Oil buffers such as "oil://~", remove "oil://"
          if cwd:match("oil://") then
            cwd = cwd:gsub("oil://", "")
          end
          Snacks.picker.grep({
            layout='telescope',
            dirs = { cwd },
            args = {
              "--color=never",
              "--no-heading",
              "--with-filename",
              "--line-number",
              "--column",
              "--smart-case",
              "--max-columns=500",
              "--max-columns-preview",
              "-g",
              "!.git",
              "-u", -- added
            }
          })
        end,
        desc = "Grep"
      },

      -- other search functionalities
      { '<leader>s"', function() Snacks.picker.registers({ layout='telescope' }) end, desc = "Registers" },
      { '<leader>s/', function() Snacks.picker.search_history({ layout='telescope' }) end, desc = "Search History" },
      { "<leader>sa", function() Snacks.picker.autocmds({ layout='telescope' }) end, desc = "Autocmds" },
      { "<leader>sc", function() Snacks.picker.command_history({ layout='telescope' }) end, desc = "Command History" },
      { "<leader>sC", function() Snacks.picker.commands({ layout='telescope' }) end, desc = "Commands" },
      { "<leader>sd", function() Snacks.picker.diagnostics({ layout='telescope' }) end, desc = "Diagnostics" },
      { "<leader>sD", function() Snacks.picker.diagnostics_buffer({ layout='telescope' }) end, desc = "Buffer Diagnostics" },
      { "<leader>sh", function() Snacks.picker.help({ layout='telescope' }) end, desc = "Help Pages" },
      { "<leader>sH", function() Snacks.picker.highlights({ layout='telescope' }) end, desc = "Highlights" },
      { "<leader>si", function() Snacks.picker.icons({ layout='telescope' }) end, desc = "Icons" },
      { "<leader>sj", function() Snacks.picker.jumps({ layout='telescope' }) end, desc = "Jumps" },
      { "<leader>sk", function() Snacks.picker.keymaps({ layout='telescope' }) end, desc = "Keymaps" },
      { "<leader>sl", function() Snacks.picker.loclist({ layout='telescope' }) end, desc = "Location List" },
      { "<leader>sm", function() Snacks.picker.marks({ layout='telescope' }) end, desc = "Marks" },
      { "<leader>sM", function() Snacks.picker.man({ layout='telescope' }) end, desc = "Man Pages" },
      { "<leader>sq", function() Snacks.picker.qflist({ layout='telescope' }) end, desc = "Quickfix List" },
      { "<leader>sR", function() Snacks.picker.resume({ layout='telescope' }) end, desc = "Resume" },
      { "<leader>su", function() Snacks.picker.undo({ layout='telescope' }) end, desc = "Undo History" },
    },
    config = function()
      local opts = {
        bigfile = { enabled = true },
        dim = { enabled = true },
        dashboard = {
          enabled = true,
          preset = {
            keys = {
              { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
              { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
              { icon = "󰦨 ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
              { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
              { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
              { icon = " ", key = "s", desc = "Restore Session", section = "session" },
              { icon = "󰒲 ", key = "L", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
              { icon = "󰪶 ", key = "y", desc = "yazi", action = ":Yazi cwd", enabled = package.loaded.lazy ~= nil },
              { icon = " ", key = "q", desc = "Quit", action = ":qa" },
              { icon = " ", key = "R", desc = "Remote Neovim", action = ":RemoteStart" },
              { icon = " ", key = "p", desc = "search for a project", action = ":lua Snacks.picker.projects()" },
              { icon = " ", key = "G", desc = "Git status", action = ":lua require('neogit').open()" },
            }
          },
          sections = {
            { section = "header" },
            { icon = " ",          title = "Recent Files",    section = "recent_files",                      indent = 2,  padding = 1 },
            { icon = " ",          title = "Projects",        section = "projects",                          indent = 2,  padding = 1 },
            { icon = " ",          title = "Keymaps",         section = "keys",                              indent = 2,  padding = 1 },
            { section = "startup" },
          },
        },
        -- input = { enabled = true },
        indent = {
          enabled = true,
          chunk = { enabled = true },
        },
        quickfile = { enabled = true },
        picker = { enabled = true, },
        scope = { enabled = true },
        scroll = {
          enabled = not vim.g.neovide and not vim.g.is_vscode,
          filter = function(buf)
            return vim.bo[buf].buftype ~= "terminal" and vim.bo[buf].filetype ~= "copilot-chat"
          end
        },
        words = { enabled = true },
      }
      require('snacks').setup(opts)

      -- somehow we need to defer the highlight setting not to be overridden by the default
      vim.defer_fn(
        function()
          vim.cmd[[hi! SnacksIndentChunk guifg=#7469c4]]
          vim.cmd[[hi! SnacksIndentScope guifg=#7469c4]]
        -- No need for default listchars
        end, 200
      )
      vim.defer_fn(
        function()
        -- No need for default listchars
        -- This needs to be deferred as it should override the default
        vim.cmd([[set listchars-=leadmultispace:---\|]])
        end, 100
      )
    end
  },

  -- prettier diagnostics
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "LazyFile",
    priority = 1000, -- needs to be loaded in first
    config = function()
        require('tiny-inline-diagnostic').setup({
        options = {
          multilines = {
            enabled = true,
            always_show = false,
          },
          show_all_diags_on_cursorline = true,
        }
      })
        vim.diagnostic.config({ virtual_text = false }) -- Only if needed in your configuration, if you already have native LSP diagnostics
    end
  },
  -- lazydev
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },

  -- smart increment/decrement
  {
    keys = {
      { "<C-a>", mode = { "n", "v" }, desc = "Increment" },
      { "<C-x>", mode = { "n", "v" }, desc = "Decrement" },
    },
    'monaqa/dial.nvim',
    config = function()
      local augend = require("dial.augend")
      require("dial.config").augends:register_group {
        default = {
          augend.integer.alias.decimal_int,
          augend.integer.alias.hex,
          augend.integer.alias.octal,
          augend.date.alias["%Y/%m/%d"],
          augend.date.alias["%Y-%m-%d"],
          augend.date.alias["%m/%d"],
          augend.date.alias["%H:%M"],
          augend.date.alias["%H:%M:%S"],
          augend.constant.alias.ja_weekday_full,
          augend.constant.alias.ja_weekday,
        },
      }

      map("n", "<C-a>", function()
        require("dial.map").manipulate("increment", "normal")
      end)
      map("n", "<C-x>", function()
        require("dial.map").manipulate("decrement", "normal")
      end)
      map("n", "g<C-a>", function()
        require("dial.map").manipulate("increment", "gnormal")
      end)
      map("n", "g<C-x>", function()
        require("dial.map").manipulate("decrement", "gnormal")
      end)
      map("v", "<C-a>", function()
        require("dial.map").manipulate("increment", "visual")
      end)
      map("v", "<C-x>", function()
        require("dial.map").manipulate("decrement", "visual")
      end)
      map("v", "g<C-a>", function()
        require("dial.map").manipulate("increment", "gvisual")
      end)
      map("v", "g<C-x>", function()
        require("dial.map").manipulate("decrement", "gvisual")
      end)
    end
  },

  -- remote-nvim
  {
    cmd = { "RemoteStart" },
    "hmk114/remote-nvim.nvim",
    version = "*", -- Pin to GitHub releases
    dependencies = {
      "nvim-lua/plenary.nvim", -- For standard functions
      "MunifTanjim/nui.nvim", -- To build the plugin UI
      "nvim-telescope/telescope.nvim", -- For picking b/w different remote methods
    },
    opts = {
      remote = {
        copy_dirs = {
          config = {
            compression = {
              enabled = true,
              additional_opts = { "--exclude-vcs" },
            },
          },
        },
      },
    }
  },

  -- Git related plugins
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",         -- required
      "sindrets/diffview.nvim",        -- optional - Diff integration

      -- Only one of these is needed.
      "nvim-telescope/telescope.nvim", -- optional
    },
    keys = {
      {'<leader>gs'},
      {'gs'},
      {'<leader>ga'},
      {'<leader>gc'},
      {'<leader>gl'}
    },
    config = function()
      map("n", "<leader>gs", function() require('neogit').open() end, { desc = "Git status (neogit)"})
      map("n", "gs",         function() require('neogit').open() end, { desc = "Git status (neogit)"})
      map("n", "<leader>ga", '<cmd>silent !git add %<CR>', {silent = true, desc = "Git add current file"})
      map("n", "<leader>gc", require('neogit').action('commit', 'commit', {'--verbose'}), {silent = true, desc = "Git commit"}) -- TODO: wrapping this command with function enables lazy loading of neogit, but it results in an error
      map("n", "<leader>gl", require('neogit').action('log', 'log_all_branches', {'--graph', '--topo-order', '--decorate'}), {silent = true, desc = "Git log"})
      require('neogit').setup {
        status = {
          recent_commit_count = 30
        }
      }
      -- Close neogit status tab with <BS>
      vapi.nvim_create_autocmd('FileType', {
        pattern = 'NeogitStatus',
        callback = function()
          map('n', '<BS>', '<Cmd>q<CR>', { buffer = 0, desc = "Close neogit status" })
        end
      })
    end
  },
  {
    "FabijanZulj/blame.nvim",
    opts = {
      virtual_style = 'float',
      date_format = "%Y.%m.%d",
    },
    keys = {
      { "<Left>", "<Cmd>BlameToggle<CR>"}
    }
  },
  {
    'tpope/vim-fugitive',
    cmd = { 'Git', 'Gwrite', 'Gclog', 'Gdiffsplit', 'Glgrep', 'GBrowse', 'Dispatch' },
    keys = {
      { "<leader>gh", "<cmd>tab sp<CR>:0Gclog<CR>", desc = "Git history" },
      { "<leader>gp", "<cmd>Dispatch! git push<CR>", desc = "Git async push" },
      { "<leader>gf", "<cmd>Dispatch! git fetch<CR>", desc = "Git async fetch" },
      { "<leader>gg", [[:<C-u>Glgrep ""<Left>]], desc = "Git grep" },
      { "<leader>gd", function()
          if not vim.o.diff then
            return [[<Cmd>tab sp<CR>]] ..
                   [[<Cmd>vert Gdiffsplit!<CR>]] ..
                   [[<C-w><C-w>]] ..
                   [[<Cmd>setlocal nonumber norelativenumber foldcolumn=0 signcolumn=no wrap<CR>]] ..
                   [[<C-w><C-w>]] ..
                   [[<Cmd>setlocal nonumber norelativenumber foldcolumn=0 signcolumn=no wrap<CR>]]
          else
            return [[<Cmd>tabclose<CR>]]
          end
        end,
        expr = true, silent = true, desc = "Git diff"
      }
    },
    dependencies = { 'tpope/vim-dispatch', 'tpope/vim-rhubarb', 'tyru/open-browser.vim' },
    init = function()
      -- Generate commit message with copilot and commit with `q`. Abort with `Q`
      vim.keymap.set("n", "<leader>gm",
        function()
          vim.cmd("Git commit -v")
          -- wait for 0.2 seconds to wait for the commit window to open
          vim.defer_fn(function()
            -- If not in the commit message window, something went wrong. Abort
            if vim.bo.filetype ~= 'gitcommit' then
              return
            end
            vim.g.copilotchat_layout = 'float'
            vim.cmd("CopilotChatReset")
            vim.cmd("CopilotChatGenAndCopyCommitMsg")
            vim.g.copilotchat_layout = nil
            -- Set the copilot chat window width to 80
            vim.cmd("vertical resize 80")
            -- make mapping to use the commit message with `q`
            vim.keymap.set("n", "q",
              function()
                -- Restore the original mapping for closing the copilotchat window
                vim.keymap.set("n", "q", require('CopilotChat').close, { buffer = 0, silent = true })
                vim.keymap.del("n", "Q", { buffer = 0, silent = true })
                vim.cmd('quit') -- quit the copilotchat window
                -- if I'm currently in the commit message window, paste the commit message and close it
                if vim.bo.filetype == 'gitcommit' then
                  vim.cmd("normal! gg") -- go to the top of the commit message window
                  vim.cmd('normal ""P')
                  vim.cmd('write') -- write the commit message
                  vim.cmd('quit') -- quit the commit message window
                end
              end
              , { buffer = 0, silent = true }
            )
            -- Abort the commit message with `Q`
            vim.keymap.set("n", "Q",
              function()
                -- Restore the original mapping for closing the copilotchat window
                vim.keymap.set("n", "q", require('CopilotChat').close, { buffer = 0, silent = true })
                vim.keymap.del("n", "Q", { buffer = 0, silent = true })
                vim.cmd('quit') -- quit the copilotchat window
                -- if I'm currently in the commit message window, close it
                if vim.bo.filetype == 'gitcommit' then
                  vim.cmd('quit') -- quit the commit message window
                end
              end
              , { buffer = 0, silent = true }
            )
          end, 200)
        end, { silent = true, desc = "Git commit with copilot commit message" })

      -- With the help of rhubarb and open-browser.vim, you can open the current line in the browser with `:GBrowse`
      vim.cmd([[command! -nargs=1 Browse OpenBrowser <args>]])
    end,
  },
  {
    -- Adds git releated signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    event = 'LazyFile',
    opts = {
      signs_staged_enable = true,
      signcolumn = true,
      numhl      = true,
      signs = {
        add          = { text = '▏' },
        change       = { text = '▏' },
      },
      signs_staged = {
        add          = { text = '▏' },
        change       = { text = '▏' },
      },
      on_attach  = function(bufnr)
        local gs = package.loaded.gitsigns

        -- Use the global map helper, always set buffer
        local function bufmap(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          map(mode, l, r, opts)
        end

        -- Navigation
        local hunk_nav_opts = {wrap = false}
        for _, downkey in ipairs({'<PageDown>', ']h', '<Down>'}) do
          bufmap('n', downkey, function()
            if vim.wo.diff then return ']c' end
            vim.schedule(function() gs.nav_hunk('next', hunk_nav_opts) end)
            vim.defer_fn(function() gs.preview_hunk_inline() end, 500)
            return '<Ignore>'
          end, { expr = true })
        end

        for _, upkey in ipairs({'<PageUp>', '[h', '<Up>'}) do
          bufmap('n', upkey, function()
            if vim.wo.diff then return '[c' end
            vim.schedule(function() gs.nav_hunk('prev', hunk_nav_opts) end)
            vim.defer_fn(function() gs.preview_hunk_inline() end, 500)
            return '<Ignore>'
          end, { expr = true })
        end

        -- Actions
        bufmap('n', '<leader>hs', gs.stage_hunk, { desc = "Git stage hunk" })
        bufmap('n', '<C-Up>', function()
          gs.stage_hunk(nil, {})
        end, { desc = "Git stage hunk" })
        bufmap('n', '<Right>', function()
          gs.stage_hunk(nil, {})
        end, { desc = "Git stage hunk" })
        bufmap('n', '<leader>hu', gs.reset_hunk, { desc = "Git reset hunk" })
        bufmap('v', '<leader>hs', function() gs.stage_hunk { vfn.line("."), vfn.line("v") } end, { desc = "Git stage hunk" })
        bufmap('v', '<leader>hu', function() gs.reset_hunk { vfn.line("."), vfn.line("v") } end, { desc = "Git reset hunk" })
        bufmap('n', '<leader>hS', gs.stage_buffer, { desc = "Git stage buffer" })
        bufmap('n', '<leader>hr', gs.undo_stage_hunk, { desc = "Git undo stage hunk" })
        bufmap('n', '<leader>hR', gs.reset_buffer, { desc = "Git reset buffer" })
        bufmap('n', '<leader>hp', gs.preview_hunk, { desc = "Git preview hunk"})
        bufmap('n', '<leader>hb', function() gs.blame_line { full = true } end, { desc = "Git blame hunk" })
        bufmap('n', '<leader>hd', gs.diffthis, { desc = 'Git diff this' })
        bufmap('n', '<leader>hD', function() gs.diffthis('~') end, { desc = 'Git diff this' })

        -- Text object
        bufmap({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
      end
    },
  },

  -- floating terminal
  {
    cond = false,
    'voldikss/vim-floaterm',
    cmd = 'FloatermToggle',
    init = function()
      vim.g.floaterm_width = 0.9
      vim.g.floaterm_height = 0.9
      map({'n', 'i', 'v'}, '<C-z>', '<Cmd>FloatermToggle<CR>', { silent = true })
      map('t', [[<C-;>]], [[<C-\><C-n>:FloatermHide<CR>]], { silent = true })
      vapi.nvim_create_autocmd('FileType', {
        pattern = 'floaterm',
        callback = function()
          map('n', [[<C-;>]], [[<C-\><C-n>:FloatermHide<CR>]], { silent = true, buffer = 0 })
          map('t', [[<C-/>]], [[<C-\><C-n>:FloatermHide<CR>]], { silent = true, buffer = 0 })
          map('t', '<C-l>', [[<C-\><C-n>]], { silent = true, buffer = 0 })
        end
      })
    end
  },

  {
    "nvzone/floaterm",
    keys = {
     {'<C-z>', mode = {'n', 'i', 'v'},  '<Cmd>FloatermToggle<CR>'}
    },
    cmd = "FloatermToggle",
    dependencies = "nvzone/volt",
    opts = {
      border = false,
      size = { h = 80, w = 90 },
      mappings = {
        term = function(buf)
          map({'n', 't'}, '<C-;>', [[<C-\><C-n>:FloatermToggle<CR>]], { silent = true, buffer = buf })
          map({'n', 't'}, '<C-l>', [[<C-\><C-n>]], { silent = true, buffer = buf })
        end
      }
    },
  },

  -- better diff
  {
    event = 'LazyFile',
    'https://github.com/rickhowe/diffchar.vim',
  },

  -- clever s
  {
    -- This one has japanese search functionality
    'yuki-yano/fuzzy-motion.vim',
    cmd = { 'FuzzyMotion' },
    config = function()
      vim.g.fuzzy_motion_matchers = { 'kensaku', 'fzf' }
    end
  },

  -- leap.nvim
  {
    'https://github.com/ggandor/leap.nvim',
    keys = {
      { '<C-s>', '<Plug>(leap)',             mode = { 'n', 'x', 'o' }, desc = "Leap" },
      { 't',     '<Plug>(leap)',             mode = { 'n', 'x', 'o' }, desc = "Leap" },
      { 'S',     '<Plug>(leap-from-window)', mode = { 'n', 'x', 'o' }, desc = "Leap from window" },
    },
  },

  -- performance (faster macro execution)
  {
    "https://github.com/pteroctopus/faster.nvim",
    event='LazyFile'
  },

  -- copilot
  {
    cond = not Env.is_vscode,
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        suggestion = {
          auto_trigger = true,
          keymap = {
            accept = "<Tab>"
          }
        },
        filetypes = {
          -- yaml = false,
          text = false,
          markdown = false,
          help = false,
          gitrebase = false,
          hgcommit = false,
          svn = false,
          cvs = false,
          ["."] = false,
          ["*"] = false, -- disable by default

          c = true,
          cpp = true,
          python = true,
          rust = true,
          go = true,
          javascript = true,
          typescript = true,
          lua = true,
          html = true,
          css = true,
          gitcommit = true,
          bash = true,
          sh = true,
          zsh = true,
          vim = true,
        },
      })
    end,
  },

  -- copilot chat
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      { "zbirenbaum/copilot.lua" },
      { "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log and async functions
      -- { "nvim-telescope/telescope-ui-select.nvim" } -- for telescope picker?
    },
    build = "make tiktoken", -- Only on MacOS or Linux
    cmd = { "CopilotChat", "CopilotChatReset" },
    keys = {{ '<C-k>', mode = 'v' }, { '<leader>-', mode={'n','v'} }, { '<leader>9', mode={'n','v'} }},
    config = function()
      map("n", "<C-k>", "<Cmd>CopilotChat <CR>i#buffer<CR><CR>/COPILOT_GENERATE<CR><CR>", { silent = true })
      map("v", "<C-k>", "<Cmd>CopilotChat <CR>i/COPILOT_GENERATE<CR><CR>", { silent = true })
      map({"n", "v"}, "<leader>-",
        function()
          require("CopilotChat").select_prompt()
        end,
        {desc = "CopilotChat - Prompt actions"}
      )
      map({"n", "v"}, "<leader>9", require("CopilotChat").open, { desc = "CopilotChat - Open" })
      vapi.nvim_create_autocmd('BufWinEnter', {
        pattern = 'copilot-chat',
        callback = function()
          vim.wo.winfixwidth = true
        end
      })
      local user = vim.env.USER or "User"
      require("CopilotChat").setup(
        {
          question_header = "  " .. user .. " ",
          answer_header = "  Copilot ",
          -- Since I use rendermarkdown, default fancy features are disabled
          highlight_headers = false,
          separator = '---',
          error_header = '> [!ERROR] Error',
          -- See Configuration section for options
          model = 'gpt-4.1',
          window = {
            layout = function()
              local layout = vim.g.copilotchat_layout or 'vertical'
              return layout
            end,
            relative = 'cursor',
            width = 65,
            row = 1
          },

          prompts = {
            ArgTypeAnnot = {
              prompt = '/COPILOT_GENERATE\n\nGive type annotation for the selected function arguments. Generate only the function declaration. Specify the range of the code to replace above the code snippet (even if it\' a single line, specify start and end of the range to replace).',
            },
            DocString = {
              prompt = '/COPILOT_GENERATE\n\nWrite docstring for the selected function or class in Google style. Specify the range of code to replace the snippet in the aforementioned syntax and wrap the docstring in code block with python language. If the selected text already contains docstring, specify the range of the code to replace and generate a new one. You can generate function declaration if you need to, but should not make any modification to that.',
            },

            BetterNamings = {
              prompt = '/COPILOT_GENERATE\n\nPlease provide better names for the following variables and functions. Specify the range of the code to replace and wrap the whole message in code block with language markdown.',
            },
            GenAndCopyCommitMsg = {
              prompt = '> #git:staged\n\nSummarize and explain the change in the code. Then write commit message for the change with commitizen convention. Make sure the title has maximum 50 characters and message is wrapped at 72 characters. Wrap the whole message in code block with language gitcommit. Do not put spaces in front of the commit comment lines.',
              selection = nil,
              callback = function(response, _)
                local commit_message = response:match("```gitcommit\n(.-)```")
                if commit_message then
                  vfn.setreg('"', commit_message , 'c')
                end
                return ''
              end,
            },
          }
        }
      )
    end,
    -- See Commands section for default commands if you want to lazy load on them
  },
  {
    "yetone/avante.nvim",
    version = false, -- Never set this value to "*"! Never!
    keys = {
      '<leader>aa',
      '<leader>ae',
      '<leader>ad',
      '<leader>af',
      '<leader>ah',
      '<leader>an',
      '<leader>ar',
      '<leader>aR',
      '<leader>as',
      '<leader>aS',
      '<leader>at',
      '<leader>a?',
    },
    opts = {
      -- add any opts here
      -- for example
      provider = "copilot",
      copilot = {
        model = "gpt-4.1",
      }
    },
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    build = "make",
    -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      --- The below dependencies are optional,
      "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
      "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
      "zbirenbaum/copilot.lua", -- for providers='copilot'
    },
    init = function()
      vapi.nvim_create_autocmd('FileType', {
        pattern = 'Avante',
        callback = function()
          vim.wo.conceallevel = 2
        end
      })
    end
  },

  -- register preview
  {
    cond = not Env.is_vscode,
    'tversteeg/registers.nvim',
    config = true,
    keys = {
      { [["]],   mode = { "n", "v" } },
      { "<C-R>", mode = "i" }
    },
    cmd = "Registers",
  },

  -- undotree
  {
    cond = not Env.is_vscode,
    'mbbill/undotree',
    init = function()
      map('n', 'U', ':UndotreeToggle<CR>')
    end,
    cmd = 'UndotreeToggle'
  },

  -- nvim-lspconfig
  {
    cond = not Env.is_vscode,
    'neovim/nvim-lspconfig',
    event = { "LazyFile" },
    cmd = { "LspInfo", "LspInstall", "LspUninstall", "Mason" },
    dependencies = {
      {'Saghen/blink.cmp'},
      { 'williamboman/mason.nvim', config = true },
      {
        'williamboman/mason-lspconfig.nvim',
        config = function()
          local words = {}
          for word in io.open(vfn.stdpath("config") .. "/spell/en.utf-8.add", 'r'):lines() do
            table.insert(words, word)
          end
          local server2setting = {
            bashls = {},
            denols = {},
            clangd = {},
            -- pyright = {},
            basedpyright = {
              -- copied from https://kushaldas.in/posts/basedpyright-and-neovim.html
              basedpyright = {
                typeCheckingMode = 'basic', -- for backward compatibility
                analysis = {
                  diagnosticMode = 'openFilesOnly',
                  typeCheckingMode = 'basic',
                  useLibraryCodeForTypes = true,
                  diagnosticSeverityOverrides = {
                    autoSearchPaths = true,
                    enableTypeIgnoreComments = false,
                    reportGeneralTypeIssues = 'none',
                    reportArgumentType = 'none',
                    reportUnknownMemberType = 'none',
                    reportAssignmentType = 'none',
                  },
                },
              },
            },
            ruff = {},
            -- pylyzer = {},
            rust_analyzer = {},

            lua_ls = {
              Lua = {
                completion = {
                  callSnippet = "Replace"
                }
              },
            },
            texlab = {},
          }

          for server_name, settings in pairs(server2setting) do
            vim.lsp.config(server_name, {
              capabilities = require('blink.cmp').get_lsp_capabilities(settings.capabilities),
              settings = settings,
            })
          end

          vim.lsp.config('ltex', {
            filetypes =  {"bibtex", "org", "tex", "restructuredtext", "latex", "html", "markdown"} ,
              ltex = {
                dictionary = {
                  ["en-US"] = words,
                },
              },
          })

          -- efm language server for textlint
          vim.lsp.config('efm', {
            init_options = { documentFormatting = true },
            single_file_support = true,
            filetypes = { 'text' },
            settings = {
              rootMarkers = { ".git" },
              root_markers = { ".git" },
              languages = {
                text = {
                  {
                    lintOnSave = true,
                    lintAfterOpen = true,

                    lintIgnoreExitCode = true,

                    lintFormats = { '%E1;%E%l:%c:', '%C2;%m', '%C3;%m%Z' },
                    lintCommand = [[npx textlint --parallel -f json "${INPUT}" | jq -r '.[] | .messages[] | "1;\(.line):\(.column):\n2;\(.message | split("\n")[0])\n3;[\(.ruleId)]"' 2> ~/out2.txt | tee ~/out.txt ]],

                    -- もともとはこうだったが、ファイルにスペースが含まれている場合などでどうしてもうまくいかないので、ファイル名をlintFormatから省いた上のコマンドを使う。どうせシングルファイルの処理なので、ファイル名は必要ない
                    -- cf. https://ryota2357.com/blog/2023/textlint-with-efm-nvimlsp/
                    -- lintFormats = { '%E1;%E%f:%l:%c:', '%C2;%m', '%C3;%m%Z' },
                    -- lintCommand = [[npx textlint -f json --stdin --stdin-filename ${INPUT} | jq -r '.[] | .filePath as $origPath | ($origPath | gsub(" " ; "\\ ")) as $filePath | .messages[] | "1;\($filePath):\(.line):\(.column):\n2;\(.message | split("\n")[0])\n3;[\(.ruleId)]"' 2> ~/out2.txt | tee ~/out.txt ]],

                  },
                }
              }
            }
          })
          -- Toggle efm language server
          local function toggle_efm()
            local efm_client = vim.lsp.get_clients({ name = 'efm' })[1]
            if efm_client then
              vim.lsp.enable('efm', false)
              vim.notify('efm language server disabled')
            else
              vim.lsp.enable('efm')
              vim.notify('efm language server enabled')
            end
          end
          map('n', [[\e]], toggle_efm, { desc = 'Toggle efm language server' })

          vapi.nvim_create_autocmd('LspAttach', {
            group = vapi.nvim_create_augroup('my.lsp', {}),
            callback = function(args)
              local bufnr = args.buf
              local nmap = function(keys, func, desc)
                if desc then
                  desc = 'LSP: ' .. desc
                end

                map('n', keys, func, { buffer = bufnr, desc = desc })
              end

              nmap('<leader>ln', vim.lsp.buf.rename, 'Rename')
              nmap('<leader>la', vim.lsp.buf.code_action, 'Code Action')

              nmap('<leader>ld', "<cmd>Lspsaga peek_definition<CR>", 'Goto Definition')
              nmap('<leader>lr', require('telescope.builtin').lsp_references, 'Goto References')
              nmap('<leader>li', vim.lsp.buf.implementation, 'Goto Implementation')
              -- nmap('<leader>D', vim.lsp.buf.type_definition, 'Type Definition')
              -- nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, 'Document Symbols')
              -- nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Workspace Symbols')

              -- See `:help K` for why this keymap
              nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
              nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

              -- Lesser used LSP functionality
              nmap('gD', vim.lsp.buf.declaration, 'Goto Declaration')
              nmap('<leader>lwa', vim.lsp.buf.add_workspace_folder, 'Workspace Add Folder')
              nmap('<leader>lwr', vim.lsp.buf.remove_workspace_folder, 'Workspace Remove Folder')
              nmap('<leader>lwl', function()
                print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
              end, 'Workspace List Folders')

              -- Diagnostic keymaps
              -- nmap('[d', function() vim.diagnostic.jump({ count = -1 }) end, 'Go to previous diagnostic message')
              -- nmap(']d', function() vim.diagnostic.jump({ count = 1 }) end, 'Go to next diagnostic message')
              -- nmap('[d', function() vim.diagnostic.goto_prev() end, 'Go to previous diagnostic message')
              -- nmap(']d', function() vim.diagnostic.goto_next() end, 'Go to next diagnostic message')
              nmap('[d', function() require("lspsaga.diagnostic"):goto_prev() end, 'Go to previous diagnostic message')
              nmap(']d', function() require("lspsaga.diagnostic"):goto_next() end, 'Go to next diagnostic message')
              nmap('<leader>le', vim.diagnostic.open_float, 'Open floating diagnostic message')
              nmap('<leader>ll', vim.diagnostic.setloclist, 'Open diagnostics list')

              -- nmap('<leader>a', '<cmd>Lspsaga outline<cr>', 'Open outline')

              -- Create a command `:Format` local to the LSP buffer
              vapi.nvim_buf_create_user_command(bufnr, 'Format', function(_)
                vim.lsp.buf.format()
              end, { desc = 'Format current buffer with LSP' })
              -- map('n', 'gF', vim.lsp.buf.format)

              nmap('<leader>i', function(_)
                vim.lsp.inlay_hint.enable()
                vim.diagnostic.config({virtual_lines = true})
                vapi.nvim_create_autocmd({ "CursorMoved", "CursorMovedI", "InsertEnter" }, {
                  once = true,
                  callback = function()
                    vim.lsp.inlay_hint.enable(false)
                    vim.diagnostic.config({virtual_lines = false})
                  end
                })
              end, 'Toggle inlay hint')
            end
          })

          require('mason').setup()
          require('mason-lspconfig').setup({
            automatic_enable = true,
            ensure_installed = vim.tbl_keys(server2setting),
          })
        end
      },
      { 'j-hui/fidget.nvim',       tag = 'legacy', opts = {} },
    },
  },

  -- lsp saga (useful lsp features)
  {
    cond = not Env.is_vscode,
    'nvimdev/lspsaga.nvim',
    event = 'LspAttach',
    config = function()
      require('lspsaga').setup({
        lightbulb = {
          enable = false
        }
      })
    end,
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-tree/nvim-web-devicons'
    }
  },


  -- DAP
  {
    cond = not Env.is_vscode,
    'https://github.com/mfussenegger/nvim-dap',
    -- ft = { 'python', 'c', 'cpp', 'rust' },
    keys = {
      -- https://zenn.dev/kawat/articles/51f9cc1f0f0aa9 を参考
      {'<leader>Du', '<cmd>lua require("dapui").toggle()<CR>', mode = 'n', desc = "Toggle DAP UI" },
      { '<F6>', '<cmd>DapContinue<CR>', mode = 'n', desc = "DAP Continue" },
      { '<F10>', '<cmd>DapStepOver<CR>', mode = 'n', desc = "DAP Step Over" },
      { '<F11>', '<cmd>DapStepInto<CR>', mode = 'n', desc = "DAP Step Into" },
      { '<F12>', '<cmd>DapStepOut<CR>', mode = 'n', desc = "DAP Step Out" },
      { '<leader>b', '<cmd>DapToggleBreakpoint<CR>', mode = 'n', desc = "DAP Toggle Breakpoint" },
      { '<leader>B', '<cmd>lua require("dap").set_breakpoint(nil, nil, vim.fn.input("Breakpoint condition: "))<CR>', mode = 'n', desc = "DAP Set Breakpoint with condition" },
      { '<leader>Dp', '<cmd>lua require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: "))<CR>', mode = 'n', desc = "DAP Set Log Point" },
      { '<leader>De', '<cmd>lua require("dapui").eval()<CR>', mode = 'n', desc = "DAP Evaluate Expression" },
      { '<leader>Dr', '<cmd>lua require("dap").repl.open()<CR>', mode = 'n', desc = "DAP Open REPL" },
      { '<leader>Dl', '<cmd>lua require("dap").run_last()<CR>', mode = 'n', desc = "DAP Run Last Session" }
    },
    dependencies = {
      {
        'https://github.com/rcarriga/nvim-dap-ui',
        dependencies = 'https://github.com/nvim-neotest/nvim-nio',
        opts = {}
      },
      'nvim-dap-python',
    },
  },
  {
    ft = { 'python' },
    cond = not Env.is_vscode,
    'https://github.com/mfussenegger/nvim-dap-python',
    config = function()
      local venv = os.getenv('VIRTUAL_ENV')
      local command = string.format('%s/bin/python', venv)

      require('dap-python').setup(command)
    end
  },

  -- operator augmentation
  {
    event = 'LazyFile',
    'echasnovski/mini.surround',
    version = false,
    config = function()
      require('mini.surround').setup({
        mappings = {
          -- Disable sh and sn mappings
          highlight = '',
          update_n_lines = '',
        },
        custom_surroundings = {
          -- Japanese brackets. Code from https://riq0h.jp/2023/02/18/142447
          ['j'] = {
            input = function()
              local ok, val = pcall(vfn.getchar)
              if not ok then return end
              local char = vfn.nr2char(assert(tonumber(val)))

              local dict = {
                ['('] = { '（().-()）' },
                ['{'] = { '｛().-()｝' },
                ['['] = { '「().-()」' },
                [']'] = { '『().-()』' },
                ['<'] = { '＜().-()＞' },
                ['"'] = { '”().-()”' },
              }

              -- If char is 'b', return all the surroundings to cover all patterns
              if char == 'b' then
                local ret = {}
                for _, v in pairs(dict) do table.insert(ret, v) end
                return { ret }
              end

              -- else, return the corresponding surroundings
              if dict[char] then return dict[char] end

              error('%s is unsupported surroundings in Japanese')
            end,
            output = function()
              local ok, val = pcall(vfn.getchar)
              if not ok then return end
              local char = vfn.nr2char(assert(tonumber(val)))

              local dict = {
                ['('] = { left = '（', right = '）' },
                ['{'] = { left = '｛', right = '｝' },
                ['['] = { left = '「', right = '」' },
                [']'] = { left = '『', right = '』' },
                ['<'] = { left = '＜', right = '＞' },
                ['"'] = { left = '”', right = '”' },
              }

              if not dict[char] then error('%s is unsupported surroundings in Japanese') end

              return dict[char]
            end
          }
        },
      })
    end
  },

  -- completion
  {
    'https://github.com/Saghen/blink.cmp',

    event = { 'InsertEnter' , 'CmdlineEnter' },

    dependencies = {
      { "epwalsh/obsidian.nvim" },
      { 'L3MON4D3/LuaSnip' }
    },

    -- use a release tag to download pre-built binaries
    version = '*',
    -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
    -- build = 'cargo build --release',
    -- If you use nix, you can build from source using latest nightly rust with:
    -- build = 'nix run .#build-plugin',

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      -- 'default' for mappings similar to built-in completion
      -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
      -- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
      -- See the full "keymap" documentation for information on defining your own keymap.
      keymap = {
        preset = 'default',
        ['<Tab>'] = {},
      },

      enabled = function()
        -- Enable when all of the following are true:
        -- 1. Not in text file insert mode
        -- 2. Not in prompt
        local is_text = vim.bo.filetype == 'text'
        local is_insert = vapi.nvim_get_mode().mode == 'i'
        return not (is_text and is_insert)
      end,

      completion = {
        menu = {
          max_height = 30,
          winblend = 30,
          -- auto_show = function(ctx)
          --     return ctx.mode ~= 'default'
          -- end,
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 100,
          window = {
            winblend = 30,
            border = 'rounded'
          }
        },
        list = {
          selection = {
            preselect = false,
          }
        }
      },
      cmdline = {
        completion = {
          menu = {
            auto_show = function(ctx)
              return vfn.getcmdtype() == ':'
            end,
          },
          list = {
            selection = {
              preselect = false,
            }
          }
        },
      },

      appearance = {
        -- Sets the fallback highlight groups to nvim-cmp's highlight groups
        -- Useful for when your theme doesn't support blink.cmp
        -- Will be removed in a future release
        use_nvim_cmp_as_default = true,
        -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = 'mono'
      },

      snippets = { preset = 'luasnip' },

      -- Default list of enabled providers defined so that you can extend it
      -- elsewhere in your config, without redefining it, due to `opts_extend`
      sources = {
        default = function()
          if vim.bo.filetype == 'markdown' then
            return { 'obsidian', 'obsidian_new', 'obsidian_tags', 'lazydev', 'lsp', 'path', 'snippets', 'buffer' }
          else
            return { 'lazydev', 'lsp', 'path', 'snippets', 'buffer' }
          end
        end,
        providers = {
          lsp = {
            async = true, -- Whether we should show the completions before this provider returns, without waiting for it
            timeout_ms = 2000, -- How long to wait for the provider to return before showing completions and treating it as asynchronous
          },
          obsidian = {
            name = "obsidian",
            module = "blink.compat.source",
          },
          obsidian_new = {
            name = "obsidian_new",
            module = "blink.compat.source",
          },
          obsidian_tags = {
            name = "obsidian_tags",
            module = "blink.compat.source",
          },
          lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
            -- make lazydev completions top priority (see `:h blink.cmp`)
            score_offset = 100,
          },
        },
      },
    },
    opts_extend = { "sources.default" }
  },
  {
    'saghen/blink.compat',
    -- use the latest release, via version = '*', if you also use the latest release for blink.cmp
    version = '*',
    -- lazy.nvim will automatically load the plugin when it's required by blink.cmp
    lazy = true,
    -- make sure to set opts so that lazy.nvim calls blink.compat's setup
    opts = {},
  },

  -- lsp signature help
  {
    cond = not Env.is_vscode and not Env.is_macos,
    "ray-x/lsp_signature.nvim",
    event = "LazyFile",
    opts = {},
    config = function(_, opts)
      vapi.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local bufnr = args.buf
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if not client then
            return
          end
          if vim.tbl_contains({ 'null-ls' }, client.name) then -- blacklist lsp
            return
          end
          require("lsp_signature").on_attach({
            -- ... setup options here ...
          }, bufnr)
        end,
      })
    end
  },


  -- snippets
  {
    'L3MON4D3/LuaSnip',
    event = 'InsertEnter',
    build = "make install_jsregexp",
    version = "2.*",
    config = function()
      require('luasnip').config.setup({
        enable_autosnippets = true,
        delete_check_events = 'InsertLeave',
      })
      map("i", "<C-k>", function()
        if require('luasnip').expand_or_jumpable() then
          return '<Plug>luasnip-expand-or-jump'
        else
          return '<C-k>'
        end
      end, { silent = true, expr = true })

      local ls = require("luasnip")

      ls.add_snippets("sh", {
        ls.parser.parse_snippet('cdhere', [[cd "$(dirname "\$0")"]])
      })

      ls.add_snippets("bash", {
        ls.parser.parse_snippet('cdhere', 'cd "$(dirname "$0")"')
      })

      ls.add_snippets("zsh", {
        ls.parser.parse_snippet('cdhere', 'cd "$(dirname "$0")"')
      })

      ls.add_snippets("python", {
        ls.parser.parse_snippet("pf", [[print(f"{$1}")$0]]),
        ls.parser.parse_snippet("bp", [[breakpoint()]]),
        ls.parser.parse_snippet("pretty_traceback", [[import colored_traceback.always  # noqa: F401]]),
        ls.parser.parse_snippet("todo", "# TODO: "),
        ls.parser.parse_snippet("import_plt", "import matplotlib.pyplot as plt"),
        ls.parser.parse_snippet("ifmain", [[if __name__ == "__main__":]]),
        ls.parser.parse_snippet({ trig = "plot_instantly", name = "plot_instantly" },
          [[
            import matplotlib.pyplot as plt
            fig = plt.figure()
            ax = fig.add_subplot(111)
            ax.$1
            plt.show()
            $0
          ]]
        ),
        ls.parser.parse_snippet({ trig = "set_axes_equal", name = "set x y z axes equal for same aspect ratio." },
          [[
            def set_axes_equal(ax):
                """
                Make axes of 3D plot have equal scale so that spheres appear as spheres,
                cubes as cubes, etc.

                Input
                  ax: a matplotlib axis, e.g., as output from plt.gca().
                """

                x_limits = ax.get_xlim3d()
                y_limits = ax.get_ylim3d()
                z_limits = ax.get_zlim3d()

                x_range = abs(x_limits[1] - x_limits[0])
                x_middle = np.mean(x_limits)
                y_range = abs(y_limits[1] - y_limits[0])
                y_middle = np.mean(y_limits)
                z_range = abs(z_limits[1] - z_limits[0])
                z_middle = np.mean(z_limits)

                # The plot bounding box is a sphere in the sense of the infinity
                # norm, hence I call half the max range the plot radius.
                plot_radius = 0.5*max([x_range, y_range, z_range])

                ax.set_xlim3d([x_middle - plot_radius, x_middle + plot_radius])
                ax.set_ylim3d([y_middle - plot_radius, y_middle + plot_radius])
                ax.set_zlim3d([z_middle - plot_radius, z_middle + plot_radius])

          ]]
        ),
        ls.parser.parse_snippet({ trig = "argument_parser", name = "argument_parser" },
          [[
            import argparse
            p = argparse.ArgumentParser()
            p.add_argument('${1:foo}')
            args = p.parse_args()
          ]]
        ),
        ls.parser.parse_snippet({ trig = "tyro_argument_parser", name = "tyro_argument_parser" },
          [[
            import dataclasses

            import tyro


            @dataclasses.dataclass
            class Args:
                """$1.
                $2"""

                field1: tyro.conf.Positional[str]
                """A string field."""

                field2: int = 3
                """A numeric field, with a default value."""

                $3

            if __name__ == "__main__":
                args = tyro.cli(Args)
                print(args)
                $0
          ]]
        ),
        ls.parser.parse_snippet({ trig = "read_movie_using_cv2", name = "read movie using cv2" },
          [[
            cap = cv2.VideoCapture(movie_path)
            FPS = round(cap.get(cv2.CAP_PROP_FPS), 2)
            NUM_FRAMES = int(round(cap.get(cv2.CAP_PROP_FRAME_COUNT), 2))
            WIDTH, HEIGHT = int(cap.get(cv2.CAP_PROP_FRAME_WIDTH)), int(cap.get(cv2.CAP_PROP_FRAME_HEIGHT))
            while True:
                ret, frame = cap.read()
                if ret is False:
                    break
            cap.release()
          ]]
        ),
        ls.parser.parse_snippet({ trig = "write_movie_using_cv2", name = "write movie using cv2" },
          [[
            out = cv2.VideoWriter(
                f"out.mp4",
                cv2.VideoWriter_fourcc("m", "p", "4", "v"),
                FPS,
                (WIDTH, HEIGHT),
                )
            out.write((image * 255).astype(np.uint8))
            out.release()
          ]]
        ),
        ls.parser.parse_snippet({ trig = "read_write_movie_using_cv2", name = "read and write movie using cv2" },
          [[
            cap = cv2.VideoCapture(movie_path)
            FPS = round(cap.get(cv2.CAP_PROP_FPS), 2)
            NUM_FRAMES = int(round(cap.get(cv2.CAP_PROP_FRAME_COUNT), 2))
            WIDTH, HEIGHT = int(cap.get(cv2.CAP_PROP_FRAME_WIDTH)), int(cap.get(cv2.CAP_PROP_FRAME_HEIGHT))
            out = cv2.VideoWriter(
                f"out.mp4",
                cv2.VideoWriter_fourcc("m", "p", "4", "v"),
                FPS,
                (WIDTH, HEIGHT),
                )
            while True:
                ret, frame = cap.read()
                if ret is False:
                    break
                out.write(frame)
            cap.release()
            out.release()
          ]]
        ),
        ls.parser.parse_snippet({ trig = "loguru_debugonly", name = "loguru_debugonly" },
          [[
            if not args.debug:
                logger.remove()
                logger.add(sys.stderr, level="ERROR")
          ]]
        ),
        ls.parser.parse_snippet({ trig = "sort_gpu_by_usage", name = "sort available gpu by usage using pynvml and cuda functionality" },
          [[
            import pynvml

            pynvml.nvmlInit()
            device_count = pynvml.nvmlDeviceGetCount()

            available_gpus = []

            for i in range(device_count):
                handle = pynvml.nvmlDeviceGetHandleByIndex(i)
                meminfo = pynvml.nvmlDeviceGetMemoryInfo(handle)
                free_mem = meminfo.free / (1024**2)  # MB
                total_mem = meminfo.total / (1024**2)
                usage = (meminfo.used / meminfo.total)
                available_gpus.append((i, usage, free_mem))

            # usageが少ない順にソート
            available_gpus.sort(key=lambda x: x[1])

            best_gpu = available_gpus[0][0]
            print(f"Best GPU ID: {best_gpu}")
            os.environ["CUDA_VISIBLE_DEVICES"] = str(best_gpu)
          ]]
        ),
        ls.parser.parse_snippet({ trig = "image_sequence", name = "A class that simulates video capture from a directory of images" },
          [[
            class ImageSequence:
                def __init__(self, dirname):
                    self.dirname = dirname
                    self.files = sorted(Path(dirname).glob("*.(JPG|jpg|png|jpeg)"))
                    self.idx = 0

                def read(self):
                    if self.idx >= len(self.files):
                        return False, None
                    img = cv2.imread(str(self.files[self.idx]), cv2.IMREAD_COLOR)
                    self.idx += 1
                    return True, img

                def release(self):
                    pass
          ]]
        ),
        ls.parser.parse_snippet({ trig = "import_jaxtyping", name = "Use beartype and jaxtyping for runtime type checking" },
          [[
            from beartype import beartype as typechecker
            from jaxtyping import Bool, Float, jaxtyped
          ]]
        ),
        ls.parser.parse_snippet({ trig = "import_beartype", name = "Use beartype and jaxtyping for runtime type checking" },
          [[
            from beartype import beartype as typechecker
            from jaxtyping import Bool, Float, jaxtyped
          ]]
        ),
        ls.parser.parse_snippet({ trig = "jaxtyped_decoration", name = "Use beartype and jaxtyping for runtime type checking" },
          [[
            @jaxtyped(typechecker=typechecker)
          ]]
        ),
      })

      ls.add_snippets("html", {
        ls.parser.parse_snippet("rb", "<ruby>$1<rp> (</rp><rt>$2</rt><rp>) </rp></ruby>$0")
      })

      ls.add_snippets("text", {
        ls.parser.parse_snippet("rb", "[[rb:$1>$2]]$0"),
        ls.parser.parse_snippet("np", "[newpage]"),
        ls.parser.parse_snippet("sp", "◇　◇　◇"),
      })

      ls.add_snippets("markdown", {
        ls.parser.parse_snippet("rb", "<ruby>$1<rp> (</rp><rt>$2</rt><rp>) </rp></ruby>$0"),
        ls.parser.parse_snippet("str", "<strong>$1</strong>$0"),
        ls.parser.parse_snippet({ trig = ",,", snippetType = "autosnippet" }, "$$1$$0"),
        ls.parser.parse_snippet("details",
          [[
            <details>
            <summary>
            $1
            </summary>
            $2
            </details>
            $0
          ]]
        ),
      })
      ls.add_snippets("tex", {
        ls.parser.parse_snippet("bf", "\\textbf{$1}"),
        ls.parser.parse_snippet("it", "\\textit{$1}"),
        ls.parser.parse_snippet("sc", "\\textsc{$1}"),
        ls.parser.parse_snippet("sf", "\\textsf{$1}"),
        ls.parser.parse_snippet("tt", "\\texttt{$1}"),
        ls.parser.parse_snippet("em", "\\emph{$1}"),
        ls.parser.parse_snippet({ trig = ",,", snippetType = "autosnippet" }, "$$1$"),
        ls.parser.parse_snippet("jbase",
          [[
            \documentclass[12pt,a4paper,titlepage]{jlreq}

            %%%% jlreq configurations
            % \jlreqsetup{caption_font=\normalfont}

            \usepackage{luatexja}

            %%%% some other packages
            \usepackage{graphicx}
            \usepackage{amsmath}
            \usepackage{amssymb}
            \usepackage{todonotes}
            \usepackage{siunitx}
            \usepackage{bm}
            \usepackage{tabularrary}
            \UseTblrLibrary{booktabs}
            \usepackage{capt-of}

            %%%% if you use citations...
            % \usepackage[
            %     backend=biber,
            %     style=numeric,
            %     sortlocale=en_US,
            %     url=false,
            %     maxbibnames=99,
            %     doi=false,
            %     eprint=false
            % ]{biblatex}
            % \setlength{\biblabelsep}{0.5em} % ラベルと文献名の間隔を調整
            % \addbibresource{citations.bib}

            %%%% luatexja choices with fonts
            %% default
            % \usepackage[haranoaji, jfm_yoko=jlreq,jfm_tate=jlreqv]{luatexja-preset}
            %% default with deluxe option (enables multi weight)
            \usepackage[haranoaji, deluxe, jfm_yoko=jlreq,jfm_tate=jlreqv]{luatexja-preset}
            %% source han
            % \usepackage[sourcehan, deluxe, jfm_yoko=jlreq,jfm_tate=jlreqv]{luatexja-preset}
            %% hiragino-pro
            % \usepackage[hiragino-pro, deluxe, jfm_yoko=jlreq,jfm_tate=jlreqv]{luatexja-preset}

            %%%% if you use ruby
            % \usepackage{luatexja-ruby}

            \title{report}
            \author{shu}
            %
            \begin{document}
            \maketitle

            \setcounter{tocdepth}{5}
            % \tableofcontents

            日本語を勉強する
            \textbf{日本語を勉強する}

            % \printbibliography[title=参考文献]
            \end{document}
          ]]
        ),
        ls.parser.parse_snippet("fig",
          [[
            \begin{figure}[b]
                \centering
                \includegraphics[width=\linewidth]{${1:path}}
                \caption{${2:caption}}
              \label{fig:${5:${1/[\W]+/_/g}}}
            \end{figure}$0
          ]]
        ),
        ls.parser.parse_snippet("tblr",
          [[
            \begin{table}[t]
                \centering
                \SetTblrInner{rowsep=2pt,colsep=6pt,stretch=1,abovesep=2pt}
                \begin{tblr}{@{}llll@{}}
                    \toprule
                    \midrule
                    \bottomrule
                \end{tblr}
                \caption{${1:caption}}
                \label{tab:$2}
            \end{table}$0
          ]]),
        ls.parser.parse_snippet("preview",
          [[
            \documentclass{article}
            \usepackage[active,tightpage]{preview}
            % some packages
            \usepackage{graphicx}
            \usepackage{amsmath}
            \usepackage{amssymb}
            \usepackage{todonotes}
            \usepackage{siunitx}
            \usepackage{bm}
            \usepackage{booktabs}
            \usepackage{capt-of}
            \usepackage{geometry}
            \geometry{paperwidth=2cm} % とりあえず小さくしておけば問題ない

            \begin{document}
            \begin{preview}
                \begin{align*}
                  ${0}
                \end{align*}
            \end{preview}
            \end{document}
          ]]
        )
      })
    end
  },

  -- Adds latex snippets
  {
    'iurimateus/luasnip-latex-snippets.nvim',
    ft = { 'tex', 'markdown' },
    -- vimtex isn't required if using treesitter
    dependencies = "L3MON4D3/LuaSnip",
    config = function()
      require 'luasnip-latex-snippets'.setup({ use_treesitter = true })
      -- or setup({ use_treesitter = true })
    end,
  },

  -- show luasnip snippets in telescope
  {
    'benfowler/telescope-luasnip.nvim',
    keys = {
      { "<leader>ss", "<cmd>Telescope luasnip<CR>", desc = "Telescope: Show Luasnip snippets" },
    },
  },

  -- Neotree (filer)
  {
    cond = not Env.is_vscode,
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    cmd = 'Neotree',
    init = function()
      vim.g.neo_tree_remove_legacy_commands = 1

      vim.keymap.set('n', "<leader>d", '<Cmd>Neotree focus<CR>')
    end,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
      {
        's1n7ax/nvim-window-picker',
        name = 'window-picker',
        version = '2.*',
        opts = {hint = 'floating-big-letter'},
      },
    },
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require("neo-tree").setup({
        default_component_configs = {
          file_size = { enabled = false },
          type = { enabled = false },
          last_modified = { enabled = false, format = 'relative' },
          git_status = {
            symbols = {
              added     = "",
              deleted   = "",
              modified  = "",
              renamed   = "",
              untracked = "?",
              unstaged = "U",
              staged = "S",
            }
          }
        },
        filesystem = {
          follow_current_file = {
            enabled = true,
          },
          window = {
            width = '60',
            max_width = '30%',
            mappings = {
              ["o"] = "open",
              ["x"] = "system_open",
              ["<C-s>"] = "open_split",
              ["<C-v>"] = "open_vsplit",
              ["s"] = "none",
              ["/"] = "none",
              ["?"] = "none",
              ["g?"] = "show_help",
              ["F"] = "fuzzy_finder",
              ["P"] = "toggle_preview",
              ["-"] = "navigate_up",
              ["<F5>"] = "refresh",
              ["z"] = "none",
              ["<C-c>"] = "none"
            },
          },
          commands = {
            system_open = function(state)
              local node = state.tree:get_node()
              local path = node:get_id()
              path = vfn.shellescape(path, true)
              if Env.is_macos then
                vapi.nvim_command("silent !open -g " .. path)
              else
                vapi.nvim_command("silent !xdg-open " .. path)
              end
            end,
          },
        },
        event_handlers = {
          {
            event = "neo_tree_buffer_enter",
            handler = function(arg)
              vim.opt.relativenumber = true
            end,
          }
        }
      })
    end
  },

  -- oil
  {
    keys = { "<leader>e", "<leader>E" },
    'https://github.com/stevearc/oil.nvim',
    config = function()
      require('oil').setup({
        keymaps = {
          ["~"] = "<cmd>edit $HOME<CR>",
          ["<C-\\>"] = {"actions.cd", mode="n"},
          ["H"] = "actions.toggle_hidden",
          ['cy'] = {
            desc = 'Copy filepath to system clipboard',
            callback = function ()
              require('oil.actions').copy_entry_path.callback()
              vfn.setreg("+", vfn.getreg(vim.v.register))
            end,
          },
          ["gd"] = {
            desc = "Toggle file detail view",
            callback = function()
              Oil_detail = not Oil_detail
              if Oil_detail then
                require("oil").set_columns({ "icon", "permissions", "size", "mtime" })
              else
                require("oil").set_columns({ "icon" })
              end
            end,
          },
        }
      })
      vim.keymap.set("n", "<leader>e", "<CMD>Oil<CR>", { desc = "Open parent directory" })
      vim.keymap.set("n", "<leader>E",
        function()
          local cwd = vfn.getcwd()
          vim.cmd("Oil " .. cwd)
        end,
        { desc = "Open cwd" }
      )
    end
  },

  -- yazi
  {
    cond = not Env.is_vscode,
    "mikavilpas/yazi.nvim",
    keys = {
      {
        "<C-y>",
        "<cmd>Yazi<CR>",
        desc = "Open the file manager",
      },
      -- {
      --   "<C-y>",
      --   function()
      --     -- NOTE: requires a version of yazi that includes
      --     -- https://github.com/sxyazi/yazi/pull/1305 from 2024-07-18
      --     require('yazi').toggle()
      --   end,
      --   desc = "Resume the last yazi session",
      -- },
    },
    ---@type YaziConfig
    opts = {
      -- if you want to open yazi instead of netrw, see below for more info
      open_for_directories = false,

      -- enable these if you are using the latest version of yazi
      -- use_ya_for_events_reading = true,
      -- use_yazi_client_id_flag = true,

      keymaps = {
        show_help = '<f1>',
      },
    },
  },


  -- emmet
  {
    cond=false, -- not to occupy <C-y> mapping
    'mattn/emmet-vim',
    ft = { 'html', 'xml', 'vue', 'htmldjango', 'markdown' }
  },

  -- barbar
  {
    cond = not Env.is_vscode,
    'romgrk/barbar.nvim',
    event = 'LazyFile',
    dependencies = {
      'lewis6991/gitsigns.nvim',     -- OPTIONAL: for git status
      'nvim-tree/nvim-web-devicons', -- OPTIONAL: for file icons
    },
    init = function()
      vim.g.barbar_auto_setup = false
      local opts = { noremap = true, silent = true }
      -- Use the global map helper
      map('n', '<C-p>', '<Cmd>BufferPrevious<CR>', opts)
      map('n', '<C-n>', '<Cmd>BufferNext<CR>', opts)
      map('n', '<C-,>', '<Cmd>BufferMovePrevious<CR>', opts)
      map('n', '<C-.>', '<Cmd>BufferMoveNext<CR>', opts)
      map('n', '<leader>wd', '<Cmd>quit<CR>', opts)
      map({ 'n', 'v' }, '<backspace>', '<Cmd>BufferClose<CR>', opts)
      map({ 'n', 'v' }, '<C-backspace>', '<Cmd>BufferClose<CR><Cmd>close<CR>', opts)
      map({ 'n', 'v' }, '<leader>bd', '<Cmd>BufferClose<CR>', opts)
      map({ 'n', 'v' }, '<leader>bo', '<Cmd>BufferCloseAllButVisible<CR>', opts)
      -- map('n', '<C-w>', '<Cmd>BufferClose<CR>', opts)
      map('n', '<C-1>', '<Cmd>BufferGoto 1<CR>', opts)
      map('n', '<C-2>', '<Cmd>BufferGoto 2<CR>', opts)
      map('n', '<C-3>', '<Cmd>BufferGoto 3<CR>', opts)
      map('n', '<C-4>', '<Cmd>BufferGoto 4<CR>', opts)
      map('n', '<C-5>', '<Cmd>BufferGoto 5<CR>', opts)
      map('n', '<C-6>', '<Cmd>BufferGoto 6<CR>', opts)
      map('n', '<C-7>', '<Cmd>BufferGoto 7<CR>', opts)
      map('n', '<C-8>', '<Cmd>BufferGoto 8<CR>', opts)
      map('n', '<C-9>', '<Cmd>BufferGoto 9<CR>', opts)
      map('n', '<C-0>', '<Cmd>BufferLast<CR>', opts)
    end,
    config = function()
      vim.g.barbar_auto_setup = false -- disable auto-setup

      require 'barbar'.setup {
        icons = {
          -- Configure the base icons on the bufferline.
          -- Valid options to display the buffer index and -number are `true`, 'superscript' and 'subscript'
          buffer_index = false,
          buffer_number = false,
          button = '',
          -- Enables / disables diagnostic symbols
          -- diagnostics = {
          --   [vim.diagnostic.severity.ERROR] = { enabled = true, icon = 'ﬀ' },
          --   [vim.diagnostic.severity.WARN] = { enabled = false },
          --   [vim.diagnostic.severity.INFO] = { enabled = false },
          --   [vim.diagnostic.severity.HINT] = { enabled = true },
          -- },
          -- gitsigns = {
          --   added = { enabled = true, icon = '+' },
          --   changed = { enabled = true, icon = '~' },
          --   deleted = { enabled = true, icon = '-' },
          -- },
          separator = { left = '', right = '' },
          separator_at_end = false,

          maximum_padding = 0,
          minimum_padding = 0,

          -- Configure the icons on the bufferline when modified or pinned.
          -- Supports all the base icon options.
          modified = { button = '●' },
          pinned = { button = '', filename = true },

          -- Configure the icons on the bufferline based on the visibility of a buffer.
          -- Supports all the base icon options, plus `modified` and `pinned`.
          alternate = { separator = { left = '　', right = '　' } },
          current = { separator = { left = '【', right = '】' } },
          inactive = { separator = { left = '　', right = '　' } },
          visible = { separator = { left = '　', right = '　' } },
        },
      }
    end,
  },

  -- markdown
  {
    'https://github.com/preservim/vim-markdown',
    ft = 'markdown',
  },
  {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
    ft = { 'markdown', 'copilot-chat' },
    config = function()
      require('render-markdown').setup({
        file_types = { 'markdown', 'copilot-chat' }, -- Registers copilot-chat filetype for markdown rendering
        render_modes = true,
        heading = {
          width = "block",
          left_pad = 0,
          right_pad = 0,
          icons = {},
        },
        code = {
          width = "block",
          right_pad = 5,
        },
        checkbox = {
          checked = { scope_highlight = "@markup.strikethrough" },
          custom = {
            cancelled = {
              raw = "[-]",
              rendered = "󱘹",
              scope_highlight = "@markup.strikethrough",
            },
          },
        },
      })
    end
  },

  -- vim table mode for markdown
  {
    cond = false,
    'dhruvasagar/vim-table-mode',
    ft = 'markdown',
    init = function()
      vim.g.table_mode_disable_mappings = 1
    end,
    config = function()
      vapi.nvim_create_autocmd({ "FileType" }, {
        pattern = "markdown",
        callback = function()
          vim.keymap.set('n', '<C-t>', '<cmd>TableModeToggle<cr>', { buffer = 0 })
        end
      }
      )
    end
  },

  -- easy align
  {
    keys = {
      { 'ga', '<Plug>(EasyAlign)', mode = { 'x' }, desc = 'Easy Align' },
    },
    'junegunn/vim-easy-align',
  },

  -- Fix Neovim's broken visual star search
  {
    'thinca/vim-visualstar',
    event = 'LazyFile',
    init = function()
      vim.g.visualstar_no_default_key_mappings = false
    end,
    config = function()
      vim.keymap.set('x', '*', '<Plug>(visualstar-g*)')
      vim.keymap.set('x', '#', '<Plug>(visualstar-g#)')
    end,
  },

  -- close parenthesis automatically
  {
    event = 'InsertEnter',
    'echasnovski/mini.pairs',
    version = false,
    config=true,
  },

  -- rust
  { 'rust-lang/rust.vim',                        ft = 'rust' },

  -- tagbar
  {
    cond = false,
    'majutsushi/tagbar',
    init = function()
      vim.keymap.set('n', '<leader>t', '<cmd>TagbarToggle<CR>')
    end,
    config = function()
      vim.cmd([[
        let g:tagbar_sort = 0
        let g:tagbar_autoclose = 0

        let g:tagbar_map_togglesort = "S"

        let g:tagbar_type_help = {
        \ 'ctagstype' : 'vimhelp',
        \ 'kinds'     : [
        \ 's:Sections',
        \ 'b:Subsections',
        \ ],
        \ 'kind2scope':{'s': 'section', 'b': 'subsection'},
        \ 'scope2kind':{'section': 's'},
        \ 'sro': ',',
        \ 'sort'    : 0,
        \ 'deffile' : $HOME . '.ctags.d/vim.ctags'
        \ }
        ]])
    end,
    cmd = 'TagbarToggle'
  },

  -- aerial (outline based on treesitter)
  {
    keys = {
      { '<leader>t', '<cmd>AerialToggle<CR>',  mode = {'n'} },
    },
    cmd = 'AerialToggle',
    'stevearc/aerial.nvim',
    config = function()
      require("aerial").setup({
        -- optionally use on_attach to set keymaps when aerial has attached to a buffer
        on_attach = function(bufnr)
          -- Jump forwards/backwards with '{' and '}'
          -- vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr })
          -- vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr })
        end,
        close_on_select = true,
        autojump = true,
      })
    end
  },

  -- Useful plugin to show you pending keybinds.
  {
    'folke/which-key.nvim',
    opts = {
      preset = "helix",
      sort = { 'alphanum' }
    },
    event = 'BufEnter'
  },

  -- colorscheme
  {
    cond = not Env.is_vscode,
    'oahlen/iceberg.nvim',
    -- event = 'VimEnter',
    config = function()
      if vim.o.bg == 'light' then
        vim.cmd.colorscheme 'iceberg-light'
      else
        vim.cmd.colorscheme 'iceberg'
      end
      vim.cmd([[
        " Less bright search color
        hi clear Search
        hi Search                guibg=NvimDarkYellow
        hi clear CurSearch
        hi CurSearch             guibg=NvimDarkYellow

        " Do not show unnecessary separation colors (make the background the same as WinSeparator)
        hi LineNr                guibg=#101218
        hi CursorLineNr          guibg=#101218
        hi FoldColumn            guibg=#101218
        hi SignColumn            guibg=#101218
        hi DiagnosticSignError   guibg=#101218
        hi DiagnosticSignWarn    guibg=#101218
        hi DiagnosticSignInfo    guibg=#101218
        hi DiagnosticSignHint    guibg=#101218
        hi GitGutterAdd          guibg=#101218
        hi GitGutterChange       guibg=#101218
        hi GitGutterChangeDelete guibg=#101218
        hi GitGutterDelete       guibg=#101218

        " Nontext is way too dark
        hi NonText              guifg=#353b5e

        " Dim Neotree git signs
        hi! link NeoTreeGitUntracked Title
        hi! link NeoTreeGitUnstaged  Title

        " make Fold color pale purple
        hi Folded                guibg=#2d273f
        " Disable hl for winbar which is used by dropbar
        hi WinBar guibg=NONE

        hi link LspInlayHint ModeMsg

        " Dimmer floating windows
        hi! Pmenu guifg=#c7c9d1 guibg=#242633
        hi! PmenuSbar guifg=NONE guibg=#242633
        hi! PmenuSel guifg=#e0e2eb guibg=#33374d
        hi! DiagnosticFloatingHint guifg=#c7c9d1 guibg=#242633

        " Highlighting every text expression is annoying
        hi LspReferenceText guibg=None

        " Dimmer TabLine
        hi TabLine    guifg=#828597 guibg=#24283d
        hi TabLineSel guifg=#e9e9ed guibg=#373c59
        ]])

      -- Black background in tabline for inactive buffers
      for _, group in ipairs({'', 'ADDED', 'Btn', 'CHANGED', 'DELETED', 'ERROR', 'HINT', 'Icon', 'Index', 'INFO', 'Mod', 'ModBtn', 'Number', 'Pin', 'PinBtn', 'Sign', 'SignRight', 'Target', 'WARN'}) do
        vapi.nvim_set_hl(0, 'BufferInactive' .. group, { bg = '#000000' })
      end

      -- Use Pmenu color for floating windows
      -- but not for TreesitterContext
      local hl = vapi.nvim_get_hl(0, { name = 'NormalFloat' })
      vapi.nvim_set_hl(0, 'TreesitterContext', hl)
      vapi.nvim_set_hl(0, 'NormalFloat', { link = 'Normal' })
      vapi.nvim_set_hl(0, 'FloatBorder', { fg = '#6c7189', bg = '#161822' })

      -- Bold highlight group for filename
      hl = vapi.nvim_get_hl(0, { name = 'Normal' })
      vapi.nvim_set_hl(0, 'Bold', { bold = true, fg = hl.fg, bg = hl.bg })

    end
  },

  -- Show modes with the current line color instead of the statusline
  {
    cond=false,
    'mvllow/modes.nvim',
    config = function()
      require('modes').setup({
        colors = {
          copy = "#f5c359",
          delete = "#c75c6a",
          insert = "#78ccc5",
          visual = "#c0f36e",
        },
        -- set_number = false,
        line_opacity = 0.3,
      })
      vim.o.showmode = false
    end

  },
  -- capture vim script output
  {
    'https://github.com/tyru/capture.vim',
    cmd = 'Capture',
  },

  -- lualine (statusline implemented with lua)
  {
    cond = not Env.is_vscode,
    'nvim-lualine/lualine.nvim',
    event = 'LazyFile',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('lualine').setup {
        options = {
          icons_enabled = true,
          theme = 'auto',
          -- component_separators = { left = '', right = '' },
          -- section_separators = { left = '', right = '' },
          component_separators = { left = '', right = '' },
          section_separators = { left = '', right = '' },
          disabled_filetypes = {
            statusline = {'snacks_dashboard'},
            winbar = {},
          },
          ignore_focus = {},
          always_divide_middle = true,
          globalstatus = true,
          refresh = {
            statusline = 1,
            tabline = 1,
            winbar = 1,
          }
        },
        sections = {
          lualine_a = {
            'mode',
            {
              require("noice").api.status.mode['get'],
              cond = function()
                return require("noice").api.status.mode['has']() and vfn.reg_recording() ~= ""
              end,
              color = { fg = "#ff9e64" },
            },
          },
          lualine_b = {
            'branch',
            { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
            { require'lazyvim.util.lualine'.pretty_path() },
            'progress', 'location',
          },
          lualine_c = {
            {
              'diff',
              symbols = {
                added = require('lazyvim.config.init').icons.git.added,
                modified = require('lazyvim.config.init').icons.git.modified,
                removed = require('lazyvim.config.init').icons.git.removed,
              },
              source = function()
                local gitsigns = vim.b.gitsigns_status_dict
                if gitsigns then
                  return {
                    added = gitsigns.added,
                    modified = gitsigns.changed,
                    removed = gitsigns.removed,
                  }
                end
              end,
            },
            'diagnostics',
            {
              require("noice").api.status.message['get'],
              cond = require("noice").api.status.message['has'],
              color = function() return { fg = Snacks.util.color("Statement") } end,
            },
            {
              require("lazy.status").updates,
              cond = require("lazy.status").has_updates,
              color = function() return { fg = Snacks.util.color("Special") } end,
            },
            'encoding', 'fileformat',
            -- search count
            {
              function()
                local ok, count = pcall(vfn.searchcount, {recompute = 0})
                if not ok then
                  return ''
                end
                return string.format('%d/%d', count.current, count.total)
              end
            },
          },
          lualine_x = {},
          lualine_y = {},
          lualine_z = {}
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = { 'encoding', 'fileformat', 'progress', 'location', 'filename' },
          lualine_c = {},
          lualine_x = {},
          lualine_y = {},
          lualine_z = {}
        },
        tabline = {},
        winbar = {},
        inactive_winbar = {},
        extensions = {}
      }
    end
  },

  -- dev icons
  {
    lazy = true,
    'nvim-tree/nvim-web-devicons',
    opts = {

      override = {
        sh = {
          icon = "",
          color = "#89e051",
          cterm_color = 113,
          name = "sh"
        },
      }
    }
  },

  -- Telescope Fuzzy Finder (files, lsp, etc)
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = { 'nvim-lua/plenary.nvim', {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make',
      cond = function()
        return vfn.executable 'make' == 1
      end,
    } },
    config = function()
      local actions = require('telescope.actions')
      require('telescope').setup {
        defaults = {
          mappings = {
            i = {
              ['<C-u>'] = false,
              ['<C-d>'] = false,
              ['<ScrollWheelUp>'] = actions.move_selection_previous,
              ['<ScrollWheelDown>'] = actions.move_selection_next,
            },
          },
          vimgrep_arguments = {
            "rg",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
            "-u" -- added
          }
        },
      }

      -- To avoid entering insert mode after search
      vapi.nvim_create_autocmd("WinLeave", {
        callback = function()
          if vim.bo.ft == "TelescopePrompt" and vfn.mode() == "i" then
            vapi.nvim_feedkeys(vapi.nvim_replace_termcodes("<Esc>", true, false, true), "i", false)
          end
        end,
      })

      -- Enable telescope fzf native, if installed
      require('telescope').load_extension('fzf')
    end,
    cmd = 'Telescope',
  },

  -- obsidian integration
  {
    cond = not Env.is_vscode and not Env.is_ssh, -- run only in local neovim
    'epwalsh/obsidian.nvim',
    ft = 'markdown',
    dependencies = {
      -- Required.
      "nvim-lua/plenary.nvim",

      -- Optional, for search and quick-switch functionality.
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      map('n', '<leader>fo', function() vim.cmd([[ObsidianQuickSwitch]]) end, {desc='Obsidian Quick Switch'})
      require('obsidian').setup(
        {
          disable_frontmatter = true,
          workspaces = {
            {
              name = "work",
              path = "~/research_vault",
            }
          },
        }
      )
    end
  },


  -- treesitter
  {
    cond = not Env.is_vscode,
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    ft = treesitter_filetypes,
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter.configs').setup {
        -- Add languages to be installed here that you want installed for treesitter
        ensure_installed = treesitter_filetypes,

        -- List of parsers to ignore installing (for "all")
        ignore_install = { "json" },

        -- Install parsers synchronously (only applied to `ensure_installed`)
        sync_install = false,

        -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
        auto_install = true,

        modules = {},

        -- modules and its options
        highlight = { enable = true, disable = { "json" } },
        indent = { enable = true },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "M",
            node_incremental = "M",
            scope_incremental = "S",
            node_decremental = "m",
          },
        },
        textobjects = {
          select = {
            enable = true,
            lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
            keymaps = {
              -- You can use the capture groups defined in textobjects.scm
              ['aa'] = '@parameter.outer',
              ['ia'] = '@parameter.inner',
              ['af'] = '@function.outer',
              ['if'] = '@function.inner',
              ['ac'] = '@class.outer',
              ['ic'] = '@class.inner',
            },
          },
          move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
              [']m'] = '@function.outer',
              [']]'] = '@class.outer',
            },
            goto_next_end = {
              [']M'] = '@function.outer',
              [']['] = '@class.outer',
            },
            goto_previous_start = {
              ['[m'] = '@function.outer',
              ['[['] = '@class.outer',
            },
            goto_previous_end = {
              ['[M'] = '@function.outer',
              ['[]'] = '@class.outer',
            },
          },
          -- swap = {
          --   enable = true,
          --   swap_next = {
          --     ['<leader>a'] = '@parameter.inner',
          --   },
          --   swap_previous = {
          --     ['<leader>A'] = '@parameter.inner',
          --   },
          -- },
        },
      }
    end
  },
  {
    cond = not Env.is_vscode,
    'nvim-treesitter/nvim-treesitter-context',
    ft = treesitter_filetypes,
    dependencies = 'nvim-treesitter/nvim-treesitter',
    config = function()
      require "treesitter-context".setup {
        max_lines = 10, -- maximum number of lines to show in the context
        multiline_threshold = 1, -- Maximum number of lines to show for a single context
        trim_scope = 'inner',
      }
      map({ "n", "v" }, "[c", function()
        require("treesitter-context").go_to_context()
      end, { silent = true })
      map("n", "<C-w><C-o>", "<C-w>o<cmd>TSContext enable<CR>", { silent = true })
    end,
  },

  -- automatic session save and restore
  {
    "folke/persistence.nvim",
    event = "BufReadPre", -- this will only start session saving when an actual file was opened
    opts = {}
  },

  -- spell check and load wrong spells to quickfix list
  {
    'inkarkat/vim-SpellCheck',
    cmd = 'SpellCheck',
    dependencies = 'inkarkat/vim-ingo-library'
  },

  -- vimtex
  {
    'lervag/vimtex',
    -- lazy loading not allowed
    ft = 'tex',
    cmd = 'VimtexInverseSearch',
    init = function()
      vim.g.tex_flavor = 'latex'
      vim.g.tex_conceal = 'abdmg'
      vim.g.vimtex_fold_enabled = 1
      if Env.is_macos then
        vim.g.vimtex_view_method = 'skim' -- skim
        -- vim.g.vimtex_view_general_viewer = 'zathura' -- zathura
      else
        vim.g.vimtex_view_method = 'zathura'
      end
      vim.g.vimtex_quickfix_enabled = 1
      vim.g.vimtex_quickfix_mode = 2
      vim.g.vimtex_quickfix_ignore_filters = {
        'Japanese fonts will be scaled by 1',
        [[\addjfontfeature(s) ignored]],
        [["HOT-ReishoRkk" does not contain]],
        [["851Gkktt" does not contain]]
      }
      -- vim.g.vimtex_fold_manual = 1
      -- Do below if using treesitter
      vim.g.vimtex_syntax_enabled = 0
      vim.g.vimtex_syntax_conceal_disable = 1
    end
  },

  -- Japanese
  {
    'swnakamura/jpmoveword.vim',
    init = function()
      vim.g.jpmoveword_separator = '，．、。・「」『』（）【】'
      vim.g.jpmoveword_enable_WBE = 2
      vim.g.matchpairs_textobject = 1
      vim.g.jpmoveword_stop_eol = 2
    end
  },
  {
    cond=false,
    "https://github.com/atusy/budouxify.nvim",
    dependencies = {"https://github.com/atusy/budoux.lua"},
    config = function()
      map("n", "W", function()
        local pos = require("budouxify.motion").find_forward({
          head = true,
        })
        if pos then
          vapi.nvim_win_set_cursor(0, { pos.row, pos.col })
        end
      end)
      map("n", "E", function()
        local pos = require("budouxify.motion").find_forward({
          head = false,
        })
        if pos then
          vapi.nvim_win_set_cursor(0, { pos.row, pos.col })
        end
      end)
    end
  },
  {
    cond = vfn.isdirectory(vfn.expand('~/ghq/github.com/swnakamura/novel_formatter')) == 1,
    event = 'LazyFile',
    dir = '~/ghq/github.com/swnakamura/novel_formatter'
  },
  {
    cond = vfn.isdirectory(vfn.expand('~/ghq/github.com/swnakamura/novel-preview.vim')) == 1,
    dir = '~/ghq/github.com/swnakamura/novel-preview.vim',
    ft = 'text',
    dependencies = 'vim-denops/denops.vim',
    init = function()
      -- if env.is_macos then
      --   vim.g['denops#deno'] = '/Users/snakamura/.deno/bin/deno'
      -- end
    end,
    config = function()
      map('n', '<F5>', '<Cmd>NovelPreviewStartServer<CR><Cmd>NovelPreviewAutoSend<CR>')
    end
  },
  -- japanese kensaku
  {
    event = 'LazyFile',
    'lambdalisue/kensaku.vim',
    dependencies = { 'vim-denops/denops.vim', 'lambdalisue/kensaku-search.vim' },
  },

  -- Zen mode
  {
    cond = not Env.is_vscode,
    "folke/zen-mode.nvim",
    keys = {
      { "<leader>z", "<cmd>ZenMode<cr>", desc = "Zen mode" },
    },
    opts = {
      on_open = function()
        vim.o.laststatus = 0

        map('n', '<C-l>', '<cmd>redraw<CR>', { desc = 'Redraw' })

        if vim.tbl_contains({ 'text', 'markdown' }, vim.o.filetype) then
          vim.o.number = false
          vim.o.relativenumber = false
          Zen_PrevStatusColumn = vim.wo.statuscolumn
          vim.wo.statuscolumn = ''
          Zen_PrevFoldColumn = vim.wo.foldcolumn
          vim.o.foldcolumn = '0'
        end
      end,
      on_close = function()
        vim.o.laststatus = 3

        map('n', '<C-l>', '<C-w>l')

        if vim.tbl_contains({ 'text', 'markdown' }, vim.o.filetype) then
          vim.o.number = true
          vim.o.relativenumber = true
          vim.wo.statuscolumn = Zen_PrevStatusColumn
          vim.o.foldcolumn = Zen_PrevFoldColumn
        end
      end,
      plugins = {
        options = {
          ruler = false,
          showcmd = false,
          laststatus = 0,
        }
      }
    },
  },

  -- ghosttext
  {
    cond = false,
    'https://github.com/subnut/nvim-ghost.nvim',
    init = function()
      vapi.nvim_create_augroup('nvim-ghost-user-autocmd', {})
      vapi.nvim_create_autocmd('User', {
        pattern = { 'www.reddit.com', 'www.stackoverflow.com', 'github.com' },
        command = 'set filetype=markdown',
        group = 'nvim-ghost-user-autocmd'
      })
      vapi.nvim_create_autocmd('User', {
        pattern = { 'www.overleaf.com' },
        command = 'set filetype=tex',
        group = 'nvim-ghost-user-autocmd'
      })
      if Env.is_macos then
        vim.g.nvim_ghost_use_script = 1
        vim.g.nvim_ghost_python_executable = '/usr/bin/python3'
      end
    end,
    build = function() vfn['nvim_ghost#installer#install']() end
  },

  -- color picker
  {
    'uga-rosa/ccc.nvim',
    cmd = {'CccPick', 'CccConvert', 'CccHighlighterEnable', 'CccHighlighterToggle', 'CccHighlighterDisable' },
    config = true
  },

  -- expl3
  { 'wtsnjp/vim-expl3',  ft = 'expl3' },

  -- better quickfix window
  { 'kevinhwang91/nvim-bqf', ft = 'qf' },

  -- beautify fold
  {
    'kevinhwang91/nvim-ufo',
    dependencies = { 'kevinhwang91/promise-async' },
    event = 'LazyFile',
    init = function()
      vim.o.foldenable = true
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.opt.foldcolumn = "1"
      vim.o.statuscolumn = '%#FoldColumn#%{foldlevel(v:lnum) > foldlevel(v:lnum - 1) ? (foldclosed(v:lnum) == -1 ? "▼" : "▶") : " " }%*%=%-l %s'

      UFOVirtTextHandler = function(virtText, lnum, endLnum, width, truncate)
        local newVirtText = {}
        local suffix = (' 󰁂 %d '):format(endLnum - lnum)
        local sufWidth = vfn.strdisplaywidth(suffix)
        local targetWidth = width - sufWidth
        local curWidth = 0
        for _, chunk in ipairs(virtText) do
          local chunkText = chunk[1]
          local chunkWidth = vfn.strdisplaywidth(chunkText)
          if targetWidth > curWidth + chunkWidth then
            table.insert(newVirtText, chunk)
          else
            chunkText = truncate(chunkText, targetWidth - curWidth)
            local hlGroup = chunk[2]
            table.insert(newVirtText, {chunkText, hlGroup})
            chunkWidth = vfn.strdisplaywidth(chunkText)
            -- str width returned from truncate() may less than 2nd argument, need padding
            if curWidth + chunkWidth < targetWidth then
              suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
            end
            break
          end
          curWidth = curWidth + chunkWidth
        end
        table.insert(newVirtText, {suffix, 'MoreMsg'})
        return newVirtText
      end
    end,
    config = function()
      require('ufo').setup({
        provider_selector = function(bufnr, filetype, buftype)
          if filetype == 'NeogitStatus' then
            return ''
          else
            return {'treesitter', 'indent'}
          end
        end,
        fold_virt_text_handler = UFOVirtTextHandler,
      })
    end
  },

  -- marks
  {
    event = 'LazyFile',
    'chentoast/marks.nvim',
    config = function()
      require('marks').setup({})
      vapi.nvim_set_hl(0, 'MarkSignHL', { link = "CursorLineNr" })
      vapi.nvim_set_hl(0, 'MarkSignNumHL', { link = "LineNr" })
    end
  },

}, require('lazy.core.config').defaults)

-- [[ Setting options ]]
require('options')

-- tab width settings
-- [[ Basic Keymaps ]]
require('keymaps')

-- [[minor functionalities]]
-- abbreviation for substitution
vim.cmd([[cnoreabbrev <expr> ss getcmdtype() .. getcmdline() ==# ':ss' ? [getchar(), ''][1] .. "%s///g<Left><Left>" : 'ss']])

-- visual modeで複数行を選択して'/'を押すと，その範囲内での検索を行う
vim.cmd([[
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
au FileType yaml                                  setlocal tabstop=4 shiftwidth=4
au FileType lua                                   setlocal tabstop=2 shiftwidth=2
au FileType html,csv,tsv                          setlocal nowrap
au FileType text,mail,markdown,help               setlocal noet      spell
au FileType markdown,org                          setlocal breakindentopt=list:-1
au FileType gitcommit                             setlocal spell

"  テキストについて-もkeywordとする
au FileType text,tex,markdown,gitcommit,help,yaml setlocal isk+=-

"  texについて@もkeywordとする
au FileType tex                                   setlocal isk+=@-@
au FileType log                                   setlocal nowrap

"  長い行がありそうな拡張子なら構文解析を途中でやめる
au FileType csv,tsv,json                          setlocal synmaxcol=256

"  インデントの有りそうなファイルならbreakindent
au FileType c,cpp,rust,go,python,lua,bash,vim,tex,markdown setlocal breakindent
augroup END

" / as file completion when in <c-x><c-f> completion
" https://zenn.dev/kawarimidoll/articles/54e38aa7f55aff
inoremap <expr> /
\ complete_info(['mode']).mode == 'files' && complete_info(['selected']).selected >= 0
\   ? '<c-x><c-f>'
\   : '/'
]])

vim.cmd([[
" 検索中の領域をハイライトする
augroup vimrc-incsearch-highlight
au!
" 検索に入ったときにhlsearchをオン
au CmdlineEnter /,\? set hlsearch
nnoremap n n<Cmd>set hlsearch<CR><Cmd>autocmd CursorMoved,BufLeave,WinLeave * ++once set nohlsearch<CR>
nnoremap N N<Cmd>set hlsearch<CR><Cmd>autocmd CursorMoved,BufLeave,WinLeave * ++once set nohlsearch<CR>
" CmdlineLeave時に即座に消す代わりに、少し待って、更にカーソルが動いたときに消す
" カーソルが動いたときにすぐ消すようにすると、検索された単語に移動した瞬間に消えてしまうので意味がない。その防止
au CmdlineLeave /,\? set hlsearch
au CmdlineLeave /,\? autocmd CursorHold * ++once autocmd CursorMoved,BufLeave,WinLeave * ++once set nohlsearch
augroup END
]])

-- 選択した領域を自動でハイライトする
vim.cmd([[hi link VisualMatch Search]])
VisualMatch = function()
  if vim.w.visual_match_id then
    vfn.matchdelete(vim.w.visual_match_id)
    vim.w.visual_match_id = nil
  end

  if vfn.mode() ~= 'v' then
    return nil
  end

  local line = vfn.line
  local charcol = vfn.charcol

  if charcol'.' < charcol'v' then
    vim.g.colrange = { charcol('.'), charcol('v') }
  elseif charcol'.' > charcol'v' then
    vim.g.colrange = { charcol('v'), charcol('.') }
  elseif line'.' ~= line'v' then
    -- same column, different line
    vim.g.colrange = { charcol('v'), charcol('.') }
  else
    return nil
  end

  if line'.' == line'v' then
    vim.cmd([[
      let g:text = getline('.')->strcharpart(g:colrange[0]-1, g:colrange[1]-g:colrange[0]+1)->escape('\')
      ]])
  else
    if line'.' > line'v' then
      vim.g.linerange = { 'v', '.' }
    else
      vim.g.linerange = { '.', 'v' }
    end
    vim.cmd([[
      let g:lines=getline(g:linerange[0], g:linerange[1])
      let g:lines[0] = g:lines[0]->strcharpart(charcol(g:linerange[0])-1)
      let g:lines[-1] = g:lines[-1]->strcharpart(0,charcol(g:linerange[1]))
      let g:text = g:lines->map({key, line -> line->escape('\')})->join('\n')
      ]])
  end

  -- if length of the text is too long, do not highlight
  if #vim.g.text > 5000 then
    return nil
  end

  vim.w.visual_match_id = vfn.matchadd('VisualMatch', [[\V]] .. vim.g.text, 11)
  return nil
end
-- WinLeave is needed to clear match when leaving the window. VisualMatch deletes the match for the current window only, so if you switch to another window, the match should be cleared before you leave.
vapi.nvim_create_autocmd({'CursorMoved', 'WinLeave'}, {
  pattern = '*',
  callback = VisualMatch
})

vim.cmd([[hi CursorWord guibg=#2a2e41]])
WordMatch = function()
  if vim.tbl_contains({ 'fern', 'neo-tree', 'floaterm', 'oil', 'org', 'NeogitStatus', 'aerial' }, vim.bo.filetype) then
    return
  end
  DelWordMatch()
  if vim.o.hlsearch then
    return
  end

  local cursorword = vfn.expand('<cword>')
  if cursorword == '' then
    return
  end
  vim.w.wordmatch_id = vfn.matchadd('CursorWord', [[\V\<]] .. cursorword .. [[\>]])
end

DelWordMatch = function()
  if vim.w.wordmatch_id then
    vfn.matchdelete(vim.w.wordmatch_id)
    vim.w.wordmatch_id = nil
  end
end

vapi.nvim_create_autocmd('CursorHold', {
  pattern = '*',
  callback = WordMatch
})

vim.cmd([[
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
]])

function RestoreWinAfter(command)
  local curw = vfn.winsaveview()
  vapi.nvim_exec2(command, {output = true})
  vfn.winrestview(curw)
end

function Is_joblog()
  -- if the first line starts with "Seq	Host ..." then it's a joblog file
  if vfn.getline(1):sub(1, 29) == 'Seq\tHost\tStarttime\tJobRuntime' then
    return true
  end
  return false
end

vapi.nvim_create_autocmd(
  {'BufReadPost', 'BufWritePost'},
  {
    pattern = '*.csv',
    callback = function()
      if vfn.has('uniz') then
        RestoreWinAfter('silent %!column -s, -o, -t -L')
      else
        RestoreWinAfter([[silent %!column -s -t]])
      end
    end
  }
)
vapi.nvim_create_autocmd(
  {'BufReadPost', 'BufWritePost'},
  {
    pattern = '*.tsv',
    callback = function()
      if Is_joblog() then
        return
      end
      RestoreWinAfter([[silent %!column -s "$(printf '\t')" -o "$(printf '\t')" -t -L]])
    end
  }
)
vapi.nvim_create_autocmd(
  {'BufWritePre'},
  {
    pattern = '*.csv',
    callback = function()
      RestoreWinAfter([[silent %s/ \+\ze,/,/ge]])
      RestoreWinAfter([[silent %s/\s\+$//ge]])
    end
  }
)
vapi.nvim_create_autocmd(
  {'BufWritePre'},
  {
    pattern = '*.tsv',
    callback = function()
      if Is_joblog() then
        return
      end
      RestoreWinAfter([[silent %s/ \+\ze	//ge]])
      RestoreWinAfter([[silent %s/\s\+$//ge]])
    end
  }
)

vim.cmd([[
augroup jupyter-notebook
au!
au BufReadPost *.ipynb %!jupytext --from ipynb --to py:percent
au BufReadPost *.ipynb set filetype=python
au BufWritePre *.ipynb let g:jupyter_previous_location = getpos('.')
au BufWritePre *.ipynb silent %!jupytext --from py:percent --to ipynb
au BufWritePost *.ipynb silent %!jupytext --from ipynb --to py:percent
au BufWritePost *.ipynb if exists('g:jupyter_previous_location') | call setpos('.', g:jupyter_previous_location) | endif
augroup END

augroup yank-highlight
autocmd!
autocmd TextYankPost * silent! lua vim.highlight.on_yank {higroup='DiffText', timeout=300}
augroup END
]])

-- [[ ftplugins ]]
-- python
vapi.nvim_create_autocmd(
  'FileType',
  {
    pattern='python',
    callback=function()
      function FormatPython()
        pcall(vim.cmd, 'update')
        RestoreWinAfter(':silent %!ruff format --line-length=140 -')
        RestoreWinAfter(':silent %!ruff check --fix-only -q --extend-select I -')
        vim.cmd('update')
      end
      map('n', 'gF', FormatPython, { buffer = true })
    end
  })


-- [[ autocmd-IME ]]
-- require('japanese.keep').setup()
map({'n', 'i'}, '<F2>', require('japanese.mode').toggle_IME, { noremap = true, silent = true, expr = true })
-- also make a command to enable japanese mode
vapi.nvim_create_user_command('JapaneseModeToggle', function()
  require('japanese.mode').toggle_IME()
end, { desc = 'Toggle Japanese IME mode' })


-- [[ autosave ]]
local autosave_disabled_ft = { "acwrite", "oil", "yazi", "neo-tree", "yaml", "toml", "json", "csv", "tsv", "gitcommit"}
vapi.nvim_create_autocmd("BufRead", {
  pattern = "*",
  group = vapi.nvim_create_augroup("autosave", {}),
  callback = function(ctx)
    vapi.nvim_buf_set_var(ctx.buf, "autosave_enabled", true)
  end,
})
local autosave = function(ctx)
  if
    not vim.bo.modified
    or vfn.findfile(ctx.file, ".") == "" -- a new file
    or ctx.file:match("wezterm.lua")
    or not vapi.nvim_buf_get_var(ctx.buf, "autosave_enabled")
  then
    return
  elseif vim.tbl_contains(autosave_disabled_ft, vim.bo[ctx.buf].ft) then
    vim.notify("Leaving buffer with unsaved chages", { title = "Autosave" }, vim.log.levels.WARN)
    return
  end
  vim.cmd("silent lockmarks update")
end
vapi.nvim_create_autocmd({"BufLeave", "FocusLost"}, {
  pattern = "*",
  callback = autosave,
})

-- vim: ts=2 sts=2 sw=2 et
