vim.loader.enable()

local fn = vim.fn

-- Do not load some of the default plugins
vim.g.loaded_netrwPlugin = true

vim.cmd([[
let g:mapleader = "\<Space>"
let g:maplocalleader = "\<C-space>"
]])

-- Install lazy.nvim (package manager)
local lazypath = fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
  fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable',
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

if fn.has('wsl') == 1 then
  vim.g.is_wsl = true
else
  vim.g.is_wsl = false
end

if vim.g.is_wsl then
  vim.cmd([[
let g:clipboard = {
        \   'name': 'WslClipboard',
        \   'copy': {
        \      '+': ['sh', '-c', 'iconv -t sjis | clip.exe'],
        \      '*': ['sh', '-c', 'iconv -t sjis | clip.exe'],
        \    },
        \   'paste': {
        \      '+': 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
        \      '*': 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
        \   },
        \   'cache_enabled': 0,
        \ }
  ]])
end


if fn.has('mac') == 1 then
  vim.g.is_macos = true
else
  vim.g.is_macos = false
end

if vim.g.is_macos == false then
  local FSWATCH_EVENTS = {
    Created = 1,
    Updated = 2,
    Removed = 3,
    -- Renamed
    OwnerModified = 2,
    AttributeModified = 2,
    MovedFrom = 1,
    MovedTo = 3
    -- IsFile
    -- IsDir
    -- IsSymLink
    -- Link
    -- Overflow
  }

  --- @param data string
  --- @param opts table
  --- @param callback fun(path: string, event: integer)
  local function fswatch_output_handler(data, opts, callback)
    local d = vim.split(data, '%s+')
    local cpath = d[1]

    for i = 2, #d do
      if d[i] == 'IsDir' or d[i] == 'IsSymLink' or d[i] == 'PlatformSpecific' then
        return
      end
    end

    if opts.include_pattern and opts.include_pattern:match(cpath) == nil then
      return
    end

    if opts.exclude_pattern and opts.exclude_pattern:match(cpath) ~= nil then
      return
    end

    for i = 2, #d do
      local e = FSWATCH_EVENTS[d[i]]
      if e then
        callback(cpath, e)
      end
    end
  end

  local function fswatch(path, opts, callback)
    local obj = vim.system({
      'fswatch',
      '--recursive',
      '--event-flags',
      '--exclude', '/.git/',
      path
    }, {
      stdout = function(_, data)
        if data == nil then
          return
        end
        for line in vim.gsplit(data, '\n', { plain = true, trimempty = true }) do
          fswatch_output_handler(line, opts, callback)
        end
      end
    })

    return function()
      obj:kill(2)
    end
  end

  if vim.fn.executable('fswatch') == 1 then
    require('vim.lsp._watchfiles')._watchfunc = fswatch
  end
end



-- [[ Plugin settings ]]

require('lazy').setup({

  {
    cond = false,
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      -- add any options here
      lsp = {
        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      -- you can enable a preset for easier configuration
      presets = {
        -- bottom_search = true,         -- use a classic bottom cmdline for search
        -- command_palette = true,       -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = false,           -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = false,       -- add a border to hover docs and signature help
      },
    },
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      "MunifTanjim/nui.nvim",
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      "rcarriga/nvim-notify",
    },
  },

  {
    cond = false,
    'goolord/alpha-nvim',
    event = "VimEnter",
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require 'alpha'.setup(require 'alpha.themes.startify'.config)
    end
  },

  {
    'https://github.com/Bekaboo/dropbar.nvim',
    config = function()
      vim.keymap.set('n', "<leader>n", require('dropbar.api').pick)
      vim.cmd([[
      augroup dropbar-keymap
        autocmd FileType dropbar_menu nnoremap q <Cmd>q<CR>
      augroup END
      ]])
    end
  },

  -- Git related plugins
  {
    'tpope/vim-fugitive',
    cmd = { 'Git', 'Gwrite', 'Gclog', 'Gdiffsplit', 'Glgrep' },
    dependencies = { 'tpope/vim-dispatch' },
    init = function()
      vim.keymap.set("n", "<leader>gs", "<cmd>Git <CR><Cmd>only<CR>", { silent = true })
      vim.keymap.set("n", "<leader>ga", "<cmd>Gwrite<CR>", { silent = true })
      vim.keymap.set("n", "<leader>gc", "<cmd>Git commit -v<CR>", { silent = true })
      vim.keymap.set("n", "<leader>gb", "<cmd>Git blame<CR>", { silent = true })
      vim.keymap.set("n", "<leader>gh", "<cmd>tab sp<CR>:0Gclog<CR>", { silent = true })
      vim.keymap.set("n", "<leader>gp", "<cmd>Dispatch! git push<CR>", { silent = true })
      vim.keymap.set("n", "<leader>gf", "<cmd>Dispatch! git fetch<CR>", { silent = true })
      vim.keymap.set("n", "<leader>gd", "<cmd>vert :Gdiffsplit!<CR>", { silent = true })
      vim.keymap.set("n", "<leader>gr", "<cmd>Git rebase -i<CR>", { silent = true })
      vim.keymap.set("n", "<leader>gg", "<cmd>Glgrep \"\"<Left>")
      vim.keymap.set("n", "<leader>gm", "<cmd>Git merge ")

      vim.keymap.set("n", "<S-Up>", ":Gwrite<CR>", { silent = true })
      vim.keymap.set("n", "<C-Up>", ":Git commit -v<CR>", { silent = true })
      vim.keymap.set("n", "<Right>",
        function()
          if not vim.o.diff then
            return
                [[<Cmd>tab sp<CR>]] ..
                [[<Cmd>vert Gdiffsplit!<CR>]] ..
                [[<C-w><C-w>]] ..
                [[<Cmd>setlocal nonumber norelativenumber foldcolumn=0 signcolumn=no wrap<CR>]] ..
                [[<C-w><C-w>]] ..
                [[zR]] ..
                [[<Cmd>setlocal nonumber norelativenumber foldcolumn=0 signcolumn=no wrap<CR>]]
          end
        end,
        { expr = true, silent = true }
      )
      vim.keymap.set("n", "<Left>",
        function() return '<Cmd>' .. (vim.o.ft == 'fugitiveblame' and 'quit' or 'Git blame') .. '<CR>' end,
        { expr = true, silent = true }
      )
      vim.keymap.set("n", "<Down>", "<Cmd>Dispatch! git fetch<CR>", { silent = true })
      vim.keymap.set("n", "<C-Down>", "<Cmd>Dispatch! git pull<CR>", { silent = true })
    end,
    config = function()
      vim.cmd([[
      augroup fugitive-keymap
        autocmd FileType fugitive nnoremap <buffer><nowait><expr> m '<Cmd>exe <SNR>' . g:fugitive_sid . '_NextFile(v:count1)<CR>'
      augroup END
      ]])
      vim.schedule(function()
        vim.cmd([[
          let g:fugitive_sid = getscriptinfo(#{name:'autoload/fugitive.vim'})[0]['sid']
        ]])
      end)
    end,
  },
  { 'tpope/vim-rhubarb',      cmd = 'GBrowse', dependencies = 'tpope/vim-fugitive' },
  {
    'cohama/agit.vim',
    cmd = 'Agit',
    init = function()
      vim.keymap.set('n', '<leader>gl', '<Cmd>Agit<CR>', { silent = true })
    end,
    config = function()
      vim.cmd([[
hi link agitStatAdded diffAdded
hi link agitStatRemoved diffRemoved
hi link agitDiffAdd diffAdded
hi link agitDiffRemove diffRemoved
      ]])
    end
  },

  -- floating terminal
  {
    'voldikss/vim-floaterm',
    cmd = 'FloatermToggle',
    init = function()
      vim.g.floaterm_width = 0.9
      vim.g.floaterm_height = 0.9
      vim.keymap.set('n', '<Plug>(my-win)z', '<Cmd>FloatermToggle<CR>', { silent = true })
      vim.keymap.set('t', '<C-[>', '<C-\\><C-n>:FloatermHide<CR>', { silent = true })
      vim.keymap.set('t', '<C-l>', '<C-\\><C-n>', { silent = true })
    end
  },

  -- clever f/F/t/T
  {
    'rhysd/clever-f.vim',
    event = 'VeryLazy',
    init = function()
      vim.keymap.set({ 'n', 'v' }, ';', ':')
      vim.g.clever_f_smart_case = 1
      vim.g.clever_f_use_migemo = 1
      vim.g.clever_f_across_no_line = 1
      vim.g.clever_f_chars_match_any_signs = ';'
    end
  },


  -- register preview
  {
    'tversteeg/registers.nvim',
    config = true,
    keys = {
      { "\"",    mode = { "n", "v" } },
      { "<C-R>", mode = "i" }
    },
    cmd = "Registers",
  },

  {
    'mbbill/undotree',
    init = function()
      vim.keymap.set('n', 'U', ':UndotreeToggle<CR>')
    end,
    cmd = 'UndotreeToggle'
  },

  {
    'neovim/nvim-lspconfig',
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "LspInfo", "LspInstall", "LspUninstall", "Mason" },
    dependencies = {
      { 'williamboman/mason.nvim', config = true },
      {
        'williamboman/mason-lspconfig.nvim',
        dependencies =
        {
          'folke/neodev.nvim',
          config = function()
            require("neodev").setup({
              override = function(root_dir, library)
                library.enabled = true
                library.plugins = true
              end,
            })
          end
        },
        config = function()
          local mason_lspconfig = require 'mason-lspconfig'
          local words = {}
          for word in io.open(fn.stdpath("config") .. "/spell/en.utf-8.add", 'r'):lines() do
            table.insert(words, word)
          end
          local server2setting = {
            denols = {},
            clangd = {},
            pyright = {
              pyright = { autoImportCompletions = true, },
              python = {
                analysis = {
                  autoSearchPaths = true,
                  diagnosticMode = 'openFilesOnly',
                  useLibraryCodeForTypes = true,
                  typeCheckingMode = 'off'
                }
              }
            },
            rust_analyzer = {},

            lua_ls = {
              Lua = {
                completion = {
                  callSnippet = "Replace"
                }
              },
            },
            texlab = {},
            -- ltex = {
            --   ltex = {
            --     dictionary = {
            --       ["en-US"] = words,
            --     },
            --   },
            -- }
          }
          local on_attach = function(_, bufnr)
            local nmap = function(keys, func, desc)
              if desc then
                desc = 'LSP: ' .. desc
              end

              vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
            end

            nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
            nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

            nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
            nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
            nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
            nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
            -- nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
            -- nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

            -- See `:help K` for why this keymap
            nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
            nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

            -- Lesser used LSP functionality
            nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
            nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
            nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
            nmap('<leader>wl', function()
              print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
            end, '[W]orkspace [L]ist Folders')

            -- Create a command `:Format` local to the LSP buffer
            vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
              vim.lsp.buf.format()
            end, { desc = 'Format current buffer with LSP' })
            vim.keymap.set('n', 'gF', vim.lsp.buf.format)

            nmap('<leader>i', function(_)
              vim.lsp.inlay_hint(0, true)
              vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI", "InsertEnter" }, {
                once = true,
                callback = function()
                  vim.lsp.inlay_hint(0, false)
                end
              })
            end, 'Toggle inlay hint')
          end

          local capabilities = require('cmp_nvim_lsp').default_capabilities()

          local handlers = {
            function(server_name)
              require('lspconfig')[server_name].setup {
                capabilities = capabilities,
                on_attach = on_attach,
                settings = server2setting[server_name],
              }
            end
          }

          mason_lspconfig.setup({
            handlers = handlers,
            ensure_installed = vim.tbl_keys(server2setting),
          })
        end
      },
      { 'j-hui/fidget.nvim',       tag = 'legacy', opts = {} },
    },
  },

  {
    'mfussenegger/nvim-lint',
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require('lint').linters_by_ft = {
        -- markdown = { 'proselint' },
        -- tex = { 'proselint' },
        -- python = { 'cspell' }
      }
      vim.api.nvim_create_autocmd({ "BufWritePost" }, {
        callback = function()
          require("lint").try_lint()
        end,
      })
    end
  },

  -- operator augmentation
  {
    'rhysd/vim-operator-surround',
    event = 'VeryLazy',
    dependencies = {
      'kana/vim-operator-user',
      config = function()
        vim.keymap.set('', 'sa', '<Plug>(operator-surround-append)', { remap = true, silent = true })
        vim.keymap.set('', 'sd', '<Plug>(operator-surround-delete)', { remap = true, silent = true })
        vim.keymap.set('', 'sr', '<Plug>(operator-surround-replace)', { remap = true, silent = true })
        vim.keymap.set('o', 'ab', '<Plug>(textobj-multiblock-a)', { remap = true })
        vim.keymap.set('o', 'ib', '<Plug>(textobj-multiblock-i)', { remap = true })
        vim.keymap.set('v', 'ab', '<Plug>(textobj-multiblock-a)', { remap = true })
        vim.keymap.set('v', 'ib', '<Plug>(textobj-multiblock-i)', { remap = true })
        vim.cmd([[
              let g:operator#surround#blocks = {
              \   'markdown' : [
              \       { 'block' : ["```\n", "\n```"], 'motionwise' : ['line'], 'keys' : ['`'] },
              \       { 'block' : ['**', '**'], 'motionwise' : ['char', 'line', 'block'], 'keys' : ["d*"] },
              \   ],
              \   '-' : [
              \       { 'block' : ['「', '」'], 'motionwise' : ['char', 'line', 'block'], 'keys' : ['j[', 'j]'] },
              \       { 'block' : ['『', '』'], 'motionwise' : ['char', 'line', 'block'], 'keys' : ['j{', 'j}'] },
              \       { 'block' : ['〝', '〟'], 'motionwise' : ['char', 'line', 'block'], 'keys' : ['j"'] },
              \       { 'block' : ['【', '】'], 'motionwise' : ['char', 'line', 'block'], 'keys' : ["j'"] },
              \   ],
              \ }

        ]])
      end,
    },
  },
  {
    'kana/vim-textobj-entire',
    event = 'VeryLazy',
    dependencies = { 'kana/vim-textobj-user' },
    init = function()
      vim.g.textobj_entire_no_default_key_mappings = true
    end,
    config = function()
      vim.keymap.set('o', 'av', '<Plug>(textobj-entire-a)', { remap = true })
      vim.keymap.set('o', 'iv', '<Plug>(textobj-entire-i)', { remap = true })
      vim.keymap.set('x', 'av', '<Plug>(textobj-entire-a)', { remap = true })
      vim.keymap.set('x', 'iv', '<Plug>(textobj-entire-i)', { remap = true })
    end,
    -- keys = { { 'av', mode = { 'o', 'x' } }, { 'iv', mode = { 'o', 'x' } } }
  },
  {
    'kana/vim-textobj-syntax',
    dependencies = { 'kana/vim-textobj-user' },
    event = 'VeryLazy',
  },
  {
    'thinca/vim-textobj-between',
    event = 'VeryLazy',
    init = function()
      vim.keymap.set('n', 'sdb', '<Plug>(operator-surround-delete)<Plug>(textobj-between-a)',
        { remap = true, silent = true })
      vim.keymap.set('n', 'srb', '<Plug>(operator-surround-replace)<Plug>(textobj-between-a)',
        { remap = true, silent = true })
    end,
    dependencies = { 'kana/vim-textobj-user' },
    -- keys = { 'srb', 'sdb' }
  },
  {
    'osyo-manga/vim-textobj-multiblock',
    event = 'VeryLazy',
    init = function()
      vim.keymap.set('n', 'sdd', '<Plug>(operator-surround-delete)<Plug>(textobj-multiblock-a)',
        { remap = true, silent = true })
      vim.keymap.set('n', 'srr', '<Plug>(operator-surround-replace)<Plug>(textobj-multiblock-a)',
        { remap = true, silent = true })
    end,
    dependencies = { 'kana/vim-textobj-user' },
    -- keys = { 'sdd', 'srr' }
  },

  {
    -- Autocompletion
    'hrsh7th/nvim-cmp',
    event = { 'InsertEnter', 'CmdlineEnter' },
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',

      -- Adds LSP completion capabilities
      'hrsh7th/cmp-nvim-lsp',

      -- Adds a number of user-friendly snippets
      'rafamadriz/friendly-snippets',

      -- Adds several other sources
      'octaltree/cmp-look',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      'onsails/lspkind.nvim',
      'hrsh7th/cmp-nvim-lsp-signature-help',
    },
    config = function()
      local cmp = require 'cmp'
      local luasnip = require 'luasnip'
      require('luasnip.loaders.from_vscode').lazy_load()

      cmp.setup {
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert {
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-e>'] = function(_)
            if cmp.visible() then
              cmp.mapping.abort()
            end
            vim.cmd('call feedkeys("\\<End>")')
          end,
          ['<C-n>'] = cmp.mapping.select_next_item(),
          ['<C-p>'] = cmp.mapping.select_prev_item(),
          ['<C-u>'] = cmp.mapping.scroll_docs(-4),
          ['<C-d>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete {},
          ['<CR>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = false,
          }, -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        },
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'buffer' },
          { name = 'path' },
          { name = 'nvim_lsp_signature_help' }
        }, {
          { name = 'look' }
        }),
      }

      -- For gitcommit, only complete from local buffer and dictionary
      cmp.setup.filetype('gitcommit', {
        sources = cmp.config.sources({
          { name = 'buffer' },
          {
            name = 'look',
            keyword_length = 5,
          },
        })
      })
      cmp.setup.filetype('yaml', {
        sources = cmp.config.sources({})
      })

      cmp.setup.filetype('tex', {
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'buffer' },
          { name = 'path' }
        }, {
          {
            name = 'look',
            keyword_length = 5,
          },
        })
      })

      -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline({ '/', '?' }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = 'buffer' }
        }
      })

      -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = 'path' }
        }, {
          { name = 'cmdline' }
        })
      })
    end,
  },


  -- Adds latex snippets
  {
    dir = '~/ghq/github.com/iurimateus/luasnip-latex-snippets.nvim',
    ft = { 'tex', 'markdown' },
    -- vimtex isn't required if using treesitter
    dependencies = "L3MON4D3/LuaSnip",
    config = function()
      require 'luasnip-latex-snippets'.setup({ use_treesitter = true })
      -- or setup({ use_treesitter = true })
    end,
  },

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
      vim.keymap.set("i", "<C-k>", function()
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
        ls.parser.parse_snippet("todo", "# TODO: "),
        ls.parser.parse_snippet("pltimport", "import matplotlib.pyplot as plt"),
        ls.parser.parse_snippet("ifmain", [[if __name__ == "__main__":]]),
        ls.parser.parse_snippet({ trig = "plot_instantly", name = "plot_instantly" },
          [[
import matplotlib.pyplot as plt
fig, ax = plt.subplots(layout='tight')
ax.$1
plt.show()
$0
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
        ls.parser.parse_snippet("acd", [[
<details>
<summary>
$1
</summary>

$2

</details>
$0
]]),
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

\begin{document}
\begin{preview}
    ${0}
\end{preview}
\end{document}
    ]]
        )
      })
    end
  },

  -- Neotree (filer)
  {
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
        event = 'VeryLazy',
        version = '2.*',
        config = function()
          require 'window-picker'.setup({
            hint = 'floating-big-letter'
          })
        end,
      },
    },
    config = function()
      require("neo-tree").setup({
        filesystem = {
          follow_current_file = {
            enabled = true,
          },
          window = {
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
              path = fn.shellescape(path, 1)
              if vim.g.is_macos then
                vim.api.nvim_command("silent !open -g " .. path)
              else
                vim.api.nvim_command("silent !xdg-open " .. path)
              end
            end,
          },
        },
      })
    end
  },

  -- oil
  {
    'https://github.com/stevearc/oil.nvim',
    config = function()
      require('oil').setup({
        keymaps = {
          ["H"] = "actions.toggle_hidden",
        }
      })
      vim.keymap.set("n", "<leader>v", "<CMD>Oil<CR>", { desc = "Open parent directory" })
    end
  },

  {
    'mattn/emmet-vim',
    ft = { 'html', 'xml', 'vue', 'htmldjango', 'markdown' }
  },

  {
    'romgrk/barbar.nvim',
    event = 'VeryLazy',
    dependencies = {
      'lewis6991/gitsigns.nvim',     -- OPTIONAL: for git status
      'nvim-tree/nvim-web-devicons', -- OPTIONAL: for file icons
    },
    init = function()
      vim.g.barbar_auto_setup = false
      local opts = { noremap = true, silent = true }
      local map = vim.keymap.set
      map('n', '<C-p>', '<Cmd>BufferPrevious<CR>', opts)
      map('n', '<C-n>', '<Cmd>BufferNext<CR>', opts)
      map('n', '<C-,>', '<Cmd>BufferMovePrevious<CR>', opts)
      map('n', '<C-.>', '<Cmd>BufferMoveNext<CR>', opts)
      map('n', '<leader>q', '<Cmd>BufferClose<CR>', opts)
      -- map('n', '<backspace>', '<Cmd>BufferClose<CR>', opts)
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
    config = true,
  },

  -- mini.nvim for indentscope, alignment
  {
    cond = false,
    'echasnovski/mini.nvim',
    event = 'VeryLazy',
    config = function()
      require('mini.indentscope').setup {
        draw = {
          delay = 20,
          animation = require('mini.indentscope').gen_animation.none()
        },
        symbol = '┊',
      }
    end
  },

  {
    -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    config = function()
      local highlight = {
        "IBL1",
        "IBL2",
      }
      -- iceberg
      vim.cmd([[
      hi IBL1 guifg=#242940 guibg=#1e2132
      hi IBL2 guifg=#242940 guibg=#161821
      ]])
      -- nightfox
      -- vim.cmd([[
      -- hi IBL1 guibg=#192330
      -- hi IBL2 guibg=#212e3f
      -- ]])

      require("ibl").setup {
        -- indent = { highlight = highlight, char = "▏" },
        indent = { highlight = highlight, char = "" },
        whitespace = {
          highlight = highlight,
          remove_blankline_trail = false,
        },
        scope = { enabled = false },
      }
    end
  },

  {
    cond = false,
    'monaqa/dial.nvim',
    config = function()
      vim.keymap.set("n", "<C-a>", require("dial.map").inc_normal(), { noremap = true })
      vim.keymap.set("n", "<C-x>", require("dial.map").dec_normal(), { noremap = true })
      vim.keymap.set("n", "g<C-a>", require("dial.map").inc_gnormal(), { noremap = true })
      vim.keymap.set("n", "g<C-x>", require("dial.map").dec_gnormal(), { noremap = true })
      vim.keymap.set("v", "<C-a>", require("dial.map").inc_visual(), { noremap = true })
      vim.keymap.set("v", "<C-x>", require("dial.map").dec_visual(), { noremap = true })
      vim.keymap.set("v", "g<C-a>", require("dial.map").inc_gvisual(), { noremap = true })
      vim.keymap.set("v", "g<C-x>", require("dial.map").dec_gvisual(), { noremap = true })
    end
  },

  -- markdown
  { 'preservim/vim-markdown', ft = 'markdown' },

  -- buffer preview for markdown
  {
    cond = false,
    'iamcco/markdown-preview.nvim',
    event = 'VeryLazy',
    build = function() fn["mkdp#util#install"]() end,
    config = function()
      vim.api.nvim_create_augroup('markdown_bufpreview', {})
      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'markdown',
        callback = function()
          vim.keymap.set({ 'n', 'i' }, '<F5>', '<Cmd>MarkdownPreview<CR>', { buffer = true })
        end,
        group = 'markdown_bufpreview',
      })
    end
  },

  {
    cond = false,
    'kat0h/bufpreview.vim',
    build = 'deno task prepare',
    dependencies = 'vim-denops/denops.vim',
    config = function()
      vim.cmd([[
    augroup markdown_bufpreview
    autocmd!
    autocmd FileType markdown nnoremap <buffer> <F5> <Cmd>PreviewMarkdown<CR>
    autocmd FileType markdown inoremap <buffer> <F5> <Cmd>PreviewMarkdown<CR>
    augroup END
    ]])
    end
  },

  {
    'junegunn/vim-easy-align',
    init = function()
      vim.keymap.set('x', 'ga', '<Plug>(EasyAlign)')
    end,
  },

  -- Fix Neovim's broken visual star search
  {
    'thinca/vim-visualstar',
    event = 'VeryLazy',
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
    'kana/vim-smartinput',
    event = 'InsertEnter',
    config = function()
      vim.cmd([[
      call smartinput#map_to_trigger('i', '<Bar>', '<Bar>', '<Bar>')
  " argument of lambda function
  call smartinput#define_rule({
  \   'at': '(\s*\%#',
  \   'char': '<Bar>',
  \   'input': '<Bar><Bar><Left>',
  \   'filetype': ['rust'],
  \ })
  call smartinput#define_rule({
  \   'at': '\%#\_s*|',
  \   'char': '<Bar>',
  \   'input': '<C-r>=smartinput#_leave_block(''|'')<Enter><Right>',
  \   'filetype': ['rust'],
  \ })
  " lifetime specifier
  call smartinput#define_rule({
  \   'at': '<\%#',
  \   'char': "'",
  \   'input': "'",
  \   'filetype': ['rust'],
  \ })
  call smartinput#define_rule({
  \   'at': '''\%#',
  \   'char': "'",
  \   'input': "'",
  \   'filetype': ['tex'],
  \ })
      ]])
    end
  },

  -- rust
  { 'rust-lang/rust.vim', ft = 'rust' },

  -- tagbar
  {
    'majutsushi/tagbar',
    init = function()
      vim.keymap.set('n', '<leader>t', '<cmd>TagbarToggle<CR>')
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

  -- Useful plugin to show you pending keybinds.
  -- { 'folke/which-key.nvim',                                opts = {}, event = 'BufEnter' },
  {
    -- Adds git releated signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    event = 'VeryLazy',
    opts = {
      signcolumn = false,
      numhl      = true,
      on_attach  = function(bufnr)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map('n', '<PageDown>', function()
          if vim.wo.diff then return ']c' end
          vim.schedule(function() gs.next_hunk({ preview = true }) end)
          return '<Ignore>'
        end, { expr = true })
        map('n', ']h', function()
          if vim.wo.diff then return ']c' end
          vim.schedule(function() gs.next_hunk({ preview = true }) end)
          return '<Ignore>'
        end, { expr = true })

        map('n', '<PageUp>', function()
          if vim.wo.diff then return '[c' end
          vim.schedule(function() gs.prev_hunk({ preview = true }) end)
          return '<Ignore>'
        end, { expr = true })
        map('n', '[h', function()
          if vim.wo.diff then return '[c' end
          vim.schedule(function() gs.prev_hunk({ preview = true }) end)
          return '<Ignore>'
        end, { expr = true })

        -- Actions
        map('n', '<leader>hs', gs.stage_hunk)
        map('n', '<Up>', gs.stage_hunk)
        map('n', '<leader>hu', gs.reset_hunk)
        map('v', '<leader>hs', function() gs.stage_hunk { fn.line("."), fn.line("v") } end)
        map('v', '<leader>hu', function() gs.reset_hunk { fn.line("."), fn.line("v") } end)
        map('n', '<leader>hS', gs.stage_buffer)
        map('n', '<leader>hr', gs.undo_stage_hunk)
        map('n', '<leader>hR', gs.reset_buffer)
        map('n', '<leader>hp', gs.preview_hunk)
        map('n', '<leader>hb', function() gs.blame_line { full = true } end)
        -- map('n', '<leader>tb', gs.toggle_current_line_blame)
        map('n', '<leader>hd', gs.diffthis)
        map('n', '<leader>hD', function() gs.diffthis('~') end)
        -- map('n', '<leader>td', gs.toggle_deleted)

        -- Text object
        map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
      end
    },
  },

  -- colorscheme
  {
    'oahlen/iceberg.nvim',
    priority = 1000,
    config = function()
      vim.cmd.colorscheme 'iceberg'
      vim.cmd([[
" Less bright search color
hi clear Search
hi Search                guibg=NONE gui=bold,underline guisp=#e27878
" Less bright cursor line number
hi clear CursorLineNr
hi link CursorLineNr ModeMsg
" Do not show unnecessary separation colors
hi LineNr                guibg=NONE
hi SignColumn            guibg=NONE
hi GitGutterAdd          guibg=NONE
hi GitGutterChange       guibg=NONE
hi GitGutterChangeDelete guibg=NONE
hi GitGutterDelete       guibg=NONE
" Disable hl for winbar which is used by dropbar
hi WinBar guibg=NONE
      ]])
    end
  },

  -- capture vim script output
  'https://github.com/tyru/capture.vim',

  {
    'nvim-lualine/lualine.nvim',
    -- event = 'VeryLazy',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      local custom_color = require('lualine.themes.iceberg_dark')
      custom_color.normal.c.fg = '#6b7089'
      require('lualine').setup {
        options = {
          icons_enabled = true,
          theme = custom_color,
          -- component_separators = { left = '', right = '' },
          -- section_separators = { left = '', right = '' },
          component_separators = { left = '', right = '' },
          section_separators = { left = '', right = '' },
          disabled_filetypes = {
            statusline = {},
            winbar = {},
          },
          ignore_focus = {},
          always_divide_middle = true,
          globalstatus = false,
          refresh = {
            statusline = 1000,
            tabline = 1000,
            winbar = 1000,
          }
        },
        sections = {
          lualine_a = { 'mode' },
          lualine_b = { 'encoding', 'fileformat', 'filetype', 'progress', 'location', 'filename' },
          lualine_c = { 'branch', 'diff', 'diagnostics' },
          lualine_x = {},
          lualine_y = {},
          lualine_z = {}
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = { 'encoding', 'fileformat', 'filetype', 'progress', 'location', 'filename' },
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

  {
    'preservim/nerdcommenter',
    event = 'VeryLazy',
    init = function()
      vim.g.NERDSpaceDelims = 1
      vim.g.NERDDefaultAlign = 'left'
      vim.g.NERDCustomDelimiters = { vim = { left = '"', right = '' } }
      vim.keymap.set({ "n", "x" }, "<C-_>", "<Plug>NERDCommenterToggle")
      vim.keymap.set({ "n", "x" }, "<C-/>", "<Plug>NERDCommenterToggle")
      vim.keymap.set({ "n", "x" }, "<C-;>", "<Plug>NERDCommenterToggle")
    end
  },


  -- Fuzzy Finder (files, lsp, etc)
  --
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = { 'nvim-lua/plenary.nvim', {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make',
      cond = function()
        return fn.executable 'make' == 1
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
        },
      }

      -- To avoid entering insert mode after search
      vim.api.nvim_create_autocmd("WinLeave", {
        callback = function()
          if vim.bo.ft == "TelescopePrompt" and vim.fn.mode() == "i" then
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "i", false)
          end
        end,
      })

      -- Enable telescope fzf native, if installed
      require('telescope').load_extension('fzf')
    end,
    init = function()
      vim.keymap.set('n', '<leader>gf', '<Cmd>Telescope git_files<CR>', { desc = 'Search [G]it [F]iles' })
      vim.keymap.set('n', '<leader>ff', '<Cmd>Telescope find_files<CR>', { desc = '[F]ind [F]iles' })
      vim.keymap.set('n', '<leader>fr', '<Cmd>Telescope oldfiles<CR>')
      vim.keymap.set('n', '<leader>fb', '<Cmd>Telescope buffers<CR>')
      vim.keymap.set('n', '<leader>fh', '<Cmd>Telescope help_tags<CR>', { desc = '[F]ind [H]elp' })
      vim.keymap.set('n', '<leader>fw', '<Cmd>Telescope grep_string<CR>', { desc = '[F]ind current [W]ord' })
      vim.keymap.set('n', '<leader>fg', '<Cmd>Telescope live_grep<CR>', { desc = '[F]ind by [G]rep' })
      vim.keymap.set('n', '<leader>fd', '<Cmd>Telescope diagnostics<CR>', { desc = '[F]ind [D]iagnostics' })
    end,
    cmd = 'Telescope',
  },

  -- show image with kitty graphics protocol
  {
    cond = false,
    'edluffy/hologram.nvim',
    ft = 'markdown',
    -- opts = { auto_display = true }
  },

  -- obsidian integration
  {
    'epwalsh/obsidian.nvim',
    ft = 'markdown',
    dependencies = {
      -- Required.
      "nvim-lua/plenary.nvim",

      -- Optional, for completion.
      "hrsh7th/nvim-cmp",

      -- Optional, for search and quick-switch functionality.
      "nvim-telescope/telescope.nvim",
    },
    opts = {
      workspaces = {
        {
          name = "work",
          path = "~/research_vault",
        }
      },
    },
  },


  {
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    event = 'VeryLazy',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter.configs').setup {
        -- Add languages to be installed here that you want installed for treesitter
        ensure_installed = { 'bibtex', 'bash', 'c', 'cpp', 'css', 'go', 'html', 'lua', 'markdown', 'org', 'python', 'rust',
          'latex', 'tsx',
          'typescript', 'vimdoc', 'vim', 'yaml' },

        -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
        auto_install = true,

        highlight = { enable = true },
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
          swap = {
            enable = true,
            swap_next = {
              ['<leader>a'] = '@parameter.inner',
            },
            swap_previous = {
              ['<leader>A'] = '@parameter.inner',
            },
          },
        },
      }
    end
  },
  {
    'nvim-treesitter/nvim-treesitter-context',
    event = 'VeryLazy',
    dependencies = 'nvim-treesitter/nvim-treesitter',
    config = function()
      require "treesitter-context".setup { max_lines = 7 }
      vim.keymap.set({ "n", "v" }, "[c", function()
        require("treesitter-context").go_to_context()
      end, { silent = true })
    end,
  },

  {
    'rmagatti/auto-session',
    config = function()
      require("auto-session").setup {
        log_level = "error",
        auto_session_suppress_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
      }
    end
  },

  {
    cond = false,
    'swnakamura/gitsession.vim'
  },

  {
    cond = false,
    'ojroques/nvim-osc52',
    config = function()
      local function copy(lines, _)
        require('osc52').copy(table.concat(lines, '\n'))
      end

      local function paste()
        return { vim.fn.split(vim.fn.getreg(''), '\n'), vim.fn.getregtype('') }
      end

      vim.g.clipboard = {
        name = 'osc52',
        copy = { ['+'] = copy, ['*'] = copy },
        paste = { ['+'] = paste, ['*'] = paste },
      }
    end
  },

  {
    'inkarkat/vim-SpellCheck',
    cmd = 'SpellCheck',
    dependencies = 'inkarkat/vim-ingo-library'
  },

  {
    'lervag/vimtex',
    init = function()
      vim.g.tex_flavor = 'latex'
      vim.g.tex_conceal = 'abdmg'
      vim.g.vimtex_fold_enabled = 1
      if vim.g.is_macos then
        -- vim.g.vimtex_view_method = 'skim' -- skim
        vim.g.vimtex_view_general_viewer = 'zathura' -- zathura
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
      vim.g.matchpairs_textobject = 1
      vim.g.jpmoveword_stop_eol = 2
    end
  },

  {
    cond = vim.g.is_macos,
    dir = '~/ghq/github.com/swnakamura/novel_formatter'
  },

  {
    cond = vim.g.is_macos,
    dir = '~/ghq/github.com/swnakamura/novel-preview.vim',
    -- ft = 'text',
    dependencies = 'vim-denops/denops.vim',
    init = function()
      -- if vim.g.is_macos then
      --   vim.g['denops#deno'] = '/Users/snakamura/.deno/bin/deno'
      -- end
    end,
    config = function()
      vim.keymap.set('n', '<F5>', '<Cmd>NovelPreviewStartServer<CR><Cmd>NovelPreviewAutoSend<CR>')
    end
  },

  {
    'lambdalisue/kensaku.vim',
    dependencies = { 'vim-denops/denops.vim', 'lambdalisue/kensaku-search.vim' },
  },

  -- Zen mode
  {
    "folke/zen-mode.nvim",
    event = 'VeryLazy',
    config = function()
      vim.keymap.set('n', 'Z', function()
        require("zen-mode").toggle({
          plugins = {
            options = {
              ruler = false,
              showcmd = false,
              laststatus = 0,
            }
          }
        })
      end)
    end,
  },

  -- ghosttext
  {
    cond = false,
    'https://github.com/subnut/nvim-ghost.nvim',
    init = function()
      vim.api.nvim_create_augroup('nvim-ghost-user-autocmd', {})
      vim.api.nvim_create_autocmd('User', {
        pattern = { 'www.reddit.com', 'www.stackoverflow.com', 'github.com' },
        command = 'set filetype=markdown',
        group = 'nvim-ghost-user-autocmd'
      })
      vim.api.nvim_create_autocmd('User', {
        pattern = { 'www.overleaf.com' },
        command = 'set filetype=tex',
        group = 'nvim-ghost-user-autocmd'
      })
      if vim.g.is_macos then
        vim.g.nvim_ghost_use_script = 1
        vim.g.nvim_ghost_python_executable = '/usr/bin/python3'
      end
    end,
    build = function() fn['nvim_ghost#installer#install']() end
  },

  -- color picker
  { 'uga-rosa/ccc.nvim',  event = 'VeryLazy' },

  -- expl3
  { 'wtsnjp/vim-expl3',   filetype = 'expl3' },

  -- pgmnt
  { 'cocopon/pgmnt.vim' },

  -- window separation color
  {
    cond = false,
    "nvim-zh/colorful-winsep.nvim",
    config = true,
    event = { "WinNew" },
  },

  { 'kevinhwang91/nvim-bqf', ft = 'qf' },

  -- org mode
  {
    'nvim-orgmode/orgmode',
    dependencies = {
      { 'nvim-treesitter/nvim-treesitter' },
    },
    ft = 'org',
    event = 'VeryLazy',
    config = function()
      -- Load treesitter grammar for org
      require('orgmode').setup_ts_grammar()

      -- Setup orgmode
      require('orgmode').setup({
        org_agenda_files = '~/org/**/*',
        org_default_notes_file = '~/org/refile.org',
        org_todo_keywords ={'WAITING', 'TODO', '|', 'DONE'},
        org_capture_templates = {
          t = { description = 'Task (issue)', template = '* TODO %? \n  %u', headline='Issue' },
          c = { description = 'Chore', template = '* TODO %? \n  %u', headline='Chore' },
          p = {
            description = 'Paper',
            template = '* TODO [[%x][%?]]\n  %u\n',
            target = '~/org/papers.org'
          },
          m = { description = 'Maybe (personal)', template = '* TODO [[%x][%?]]\n  %u', target = '~/org/personal.org' },
        },
        org_id_method = 'uuid',
        org_agenda_span = 'day',
      })
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "org",
        callback = function()
          vim.keymap.set('i', "<C-CR>", function() require('orgmode').action('org_mappings.meta_return') end)
        end
      })
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "orgagenda",
        callback = function()
          vim.keymap.set('n', "q", '<cmd>q<cr>')
        end
      })
      vim.keymap.set('n', '<leader>oo', '<cmd>e ~/org/refile.org<cr>zR')
    end,
  },
  {
    'akinsho/org-bullets.nvim',
    config = true,
  },
}, {})

-- [[ Setting options ]]

-- tab width settings
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.smartindent = true
vim.o.expandtab = true

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
if vim.fn.executable('rg') then
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
vim.o.listchars = 'tab:» ,trail:~,extends:»,precedes:«,nbsp:%'

vim.o.scrolloff = 5

vim.o.laststatus = 3

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
vim.keymap.set({ 'n', 'v' }, '<BS>', '<Cmd>BufferClose<CR>', { silent = true })
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

-- window control by s
vim.keymap.set('n', '<Plug>(my-win)', '<Nop>')
vim.keymap.set('n', 's', '<Plug>(my-win)', { remap = true })
vim.keymap.set('x', 's', '<Nop>')
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
vim.keymap.set('n', 'sq', '<Cmd>quit<CR>')
vim.keymap.set('n', 'se', '<cmd>silent! %bdel|edit #|normal `"<C-n><leader>q<cr>')
vim.keymap.set('n', 'sQ', '<Cmd>tabc<CR>')
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
vim.keymap.set('n', 'm', 'ma')
vim.keymap.set('n', "'", '`a')

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
augroup file-type
  au!
  au FileType go                                    setlocal tabstop=4 shiftwidth=4 noexpandtab formatoptions+=r
  au FileType html,csv,tsv                          setlocal nowrap
  au FileType text,mail,markdown,help               setlocal noet      spell
  au FileType gitcommit                             setlocal spell
  "  テキストについて-もkeywordとする
  au FileType text,tex,markdown,gitcommit,help      setlocal isk+=-
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
augroup instant-visual-highlight
  au!
  autocmd CursorMoved,CursorHold * call Visualmatch()
augroup END

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
  if index(['fern','neo-tree','floaterm'], &ft) != -1
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
  au BufReadPre *.torrent let b:bin_xxd=1
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

-- [[ autocmd-IME ]]
vim.cmd([[
nnoremap <silent><expr> <F2> IME_toggle()
inoremap <silent><expr> <F2> IME_toggle()

augroup IME_autotoggle
  autocmd!
  autocmd InsertEnter * if get(b:, 'IME_autoenable', v:false) | call Enable() | endif
  autocmd InsertLeave * call Disable()
  autocmd CmdLineEnter /,\? if get(b:, 'IME_autoenable', v:false) | cnoremap <CR> <Plug>(kensaku-search-replace)<CR>| endif
  autocmd CmdLineEnter /,\? if !get(b:, 'IME_autoenable', v:false) | silent! cunmap <CR> | endif
augroup END

function! IME_toggle() abort
  let b:IME_autoenable = !get(b:, 'IME_autoenable', v:false)
  if b:IME_autoenable ==# v:true
    echo '日本語入力モードON'
    if mode() == 'i'
      call Enable()
    endif
  else
    echo '日本語入力モードOFF'
    if mode() == 'i'
      call Disable()
    endif
  endif
  return ''
endfunction

function! Enable() abort
  if g:is_macos
    call system('im-select com.justsystems.inputmethod.atok33.Japanese')
  else
    call system('fcitx5-remote -o')
  endif
endfunction

function! Disable() abort
  if g:is_macos
    call system('im-select com.apple.keylayout.ABC')
  else
    call system('fcitx5-remote -c')
  endif
endfunction

augroup auto_ja
  autocmd BufRead */my-text/**.txt call IME_toggle()
  autocmd BufRead */obsidian/**.md call IME_toggle()
augroup END
]])

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

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
-- vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>l', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- vim: ts=2 sts=2 sw=2 et
