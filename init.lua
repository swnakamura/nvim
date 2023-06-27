vim.loader.enable()

-- Do not load some of the default plugins
vim.g.loaded_netrwPlugin = true

-- Set <space> as the leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Install package manager
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

vim.g.is_macos = vim.fn.has('mac')

-- [[ Plugin settings ]]

-- NOTE: Here is where you install your plugins.
--  You can configure plugins using the `config` key.
--
--  You can also configure plugins after the setup call,
--    as they will be available in your neovim runtime.
require('lazy').setup({
  -- NOTE: First, some plugins that don't require any configuration

  -- Git related plugins
  {
    'tpope/vim-fugitive',
    init = function()
      vim.keymap.set("n", "<leader>gs", ":Git <CR><C-w>T")
      vim.keymap.set("n", "<leader>ga", ":Gwrite<CR>")
      vim.keymap.set("n", "<leader>gc", ":Git commit -v<CR>")
      vim.keymap.set("n", "<leader>gb", ":Git blame<CR>")
      vim.keymap.set("n", "<leader>gh", ":tab sp<CR>:0Gclog<CR>")
      vim.keymap.set("n", "<leader>gp", "<Cmd>Dispatch! git push<CR>")
      vim.keymap.set("n", "<leader>gf", "<Cmd>Dispatch! git fetch<CR>")
      vim.keymap.set("n", "<leader>gd", ":vert :Gdiffsplit<CR>")
      vim.keymap.set("n", "<leader>gr", ":Git rebase -i<CR>")
      vim.keymap.set("n", "<leader>gg", ":Glgrep \"\"<Left>")
      vim.keymap.set("n", "<leader>gm", ":Git merge ")

      vim.keymap.set("n", "<S-Up>", ":Gwrite<CR>")
      vim.keymap.set("n", "<C-Up>", ":Git commit -v<CR>")
      vim.keymap.set("n", "<Right>",
        function() return '<Cmd>' .. (vim.o.diff and 'only' or 'vert Gdiffsplit!') .. '<CR>' end,
        { expr = true }
      )
      vim.keymap.set("n", "<Left>",
        function() return '<Cmd>' .. (vim.o.ft == 'fugitiveblame' and 'quit' or 'Git blame') .. '<CR>' end,
        { expr = true }
      )
      vim.keymap.set("n", "<Down>", "<Cmd>Dispatch! git fetch<CR>")
      vim.keymap.set("n", "<C-Down>", "<Cmd>Dispatch! git pull<CR>")
    end,
    cmd = { 'Git', 'Gwrite', 'Gclog', 'Gdiffsplit', 'Glgrep' },
    dependencies = { 'tpope/vim-dispatch', cmd = 'Dispatch' }
  },
  { 'tpope/vim-rhubarb',  cmd = 'GBrowse' },
  {
    'cohama/agit.vim',
    cmd = 'Agit',
    init = function()
      vim.keymap.set('n', '<leader>gl', '<Cmd>Agit<CR>')
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
      vim.keymap.set('n', '<Plug>(my-win)z', '<Cmd>FloatermToggle<CR>')
      vim.keymap.set('t', '<C-[>', '<C-\\><C-n>:FloatermHide<CR>')
      vim.keymap.set('t', '<C-l>', '<C-\\><C-n>')
    end
  },

  -- Detect tabstop and shiftwidth automatically
  -- { 'tpope/vim-sleuth',  event = { 'BufRead', 'BufNewFile' } },

  -- NOTE: This is where your plugins related to LSP can be installed.
  --  The configuration is done below. Search for lspconfig to find it below.
  {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    event = { 'BufRead', 'BufNewFile' },
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      { 'williamboman/mason.nvim', config = true },
      {
        'williamboman/mason-lspconfig.nvim',
        dependencies =
        {
          -- Additional lua configuration, makes nvim stuff amazing!
          -- needs to be loaded before lspconfig
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
          local servers = {
            -- clangd = {},
            -- gopls = {},
            -- pyright = {},
            -- rust_analyzer = {},
            -- tsserver = {},

            lua_ls = {
              Lua = {
                completion = {
                  callSnippet = "Replace"
                }
              },
            },
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

            nmap('<leader>i', function(_)
              vim.lsp.buf.inlay_hint(0, true)
              vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI", "InsertEnter" }, {
                once = true,
                callback = function()
                  vim.lsp.buf.inlay_hint(0, false)
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
                settings = servers[server_name],
              }
            end
          }

          mason_lspconfig.setup({
            handlers = handlers,
            ensure_installed = vim.tbl_keys(servers),
          })
        end
      },

      -- Useful status updates for LSP
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      { 'j-hui/fidget.nvim',       tag = 'legacy', opts = {} },

    },
  },

  -- operator augmentation
  {
    'rhysd/vim-operator-surround',
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
      end,
    },
    keys = { { 'sa', mode = '' }, { 'sd', mode = '' }, { 'sr', mode = '' } }
  },
  {
    'kana/vim-textobj-entire',
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
    keys = { { 'av', mode = { 'o', 'x' } }, { 'iv', mode = { 'o', 'x' } } }
  },
  {
    'kana/vim-textobj-syntax',
    dependencies = { 'kana/vim-textobj-user' },
    event = { 'BufRead', 'BufNewFile' }
  },
  {
    'thinca/vim-textobj-between',
    init = function()
      vim.keymap.set('n', 'sdb', '<Plug>(operator-surround-delete)<Plug>(textobj-between-a)',
        { remap = true, silent = true })
      vim.keymap.set('n', 'srb', '<Plug>(operator-surround-replace)<Plug>(textobj-between-a)',
        { remap = true, silent = true })
    end,
    dependencies = { 'kana/vim-textobj-user' },
    keys = { 'srb', 'sdb' }
  },
  {
    'osyo-manga/vim-textobj-multiblock',
    init = function()
      vim.keymap.set('n', 'sdd', '<Plug>(operator-surround-delete)<Plug>(textobj-multiblock-a)',
        { remap = true, silent = true })
      vim.keymap.set('n', 'srr', '<Plug>(operator-surround-replace)<Plug>(textobj-multiblock-a)',
        { remap = true, silent = true })
    end,
    dependencies = { 'kana/vim-textobj-user' },
    keys = { 'sdd', 'srr' }
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
      luasnip.config.setup({ enable_autosnippets = true })

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
    'woodyZootopia/luasnip-latex-snippets.nvim',
    dependencies = { 'L3MON4D3/LuaSnip' },
    ft = { 'markdown', 'tex', 'text' },
    event = 'InsertEnter',
    config = function()
      require 'luasnip-latex-snippets'.setup({ use_treesitter = true })
    end
  },

  {
    'L3MON4D3/LuaSnip',
    config = function()
      vim.keymap.set("i", "<C-k>", function()
        if require('luasnip').expand_or_jumpable() then
          return '<Plug>luasnip-expand-or-jump'
        else
          return '<C-k>'
        end
      end, { silent = true, expr = true })

      local ls = require("luasnip")

      ls.add_snippets("python", {
        ls.parser.parse_snippet("pf", "print(f\"{$1}\")$0"),
        ls.parser.parse_snippet("pdb", "__import__(\"pdb\").set_trace()"),
        ls.parser.parse_snippet("todo", "# TODO: "),
        ls.parser.parse_snippet("pltimport", "import matplotlib.pyplot as plt"),
        ls.parser.parse_snippet("ifmain", "if __name__ == \"__main__\":"),
        ls.parser.parse_snippet({ trig = "plot_instantly", name = "plot_instantly" },
          [[
from matplotlib.pyplot import plot,hist,imshow,scatter,show,savefig,legend,clf,figure,close
import matplotlib.pyplot as plt
imshow($1)
show()
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
        ls.parser.parse_snippet({ trig = ",,", snippetType = "autosnippet" }, "$$1$"),
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
% some packages
% \usepackage{graphicx}
% \usepackage{amsmath}
% \usepackage{amssymb}
% \usepackage{todonotes}
% \usepackage{siunitx}
% \usepackage{bm}
% \usepackage{booktabs}
% \usepackage{capt-of}
%
% \usepackage{/home/snakamura/ghq/github.com/woodyZootopia/latex-macros/macros-maths}
% \usepackage[
%     backend=biber,
%     style=numeric,
%     sortlocale=en_US,
%     url=true,
%     doi=true,
%     eprint=false
% ]{biblatex}
% \addbibresource{citations.bib}
% \usepackage{luatexja-ruby}

\title{${1:レポート}}
\author{${2}}
%
\begin{document}
\maketitle

\setcounter{tocdepth}{5}
% \tableofcontents

${0:Hello, world!}

% \printbibliography
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
        ls.parser.parse_snippet("preview",
          [[
\documentclass{jlreq}
\usepackage[active,tightpage]{preview}
% some packages
% \usepackage{graphicx}
% \usepackage{amsmath}
% \usepackage{amssymb}
% \usepackage{todonotes}
% \usepackage{siunitx}
% \usepackage{bm}
% \usepackage{booktabs}
% \usepackage{capt-of}

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

  -- Fern (filer)
  {
    'lambdalisue/fern.vim',
    init = function()
      vim.g['fern#renderer'] = "nerdfont"
      vim.keymap.set('n', "<leader>d", '<Cmd>Fern %:h<CR>')
      vim.keymap.set('n', "<leader>n", '<Cmd>Fern . -reveal=% -drawer<CR>')
      vim.keymap.set('n', "st", ':<C-u>tab sp<CR><Cmd>Fern %:h<CR>')
    end,
    config = function()
      local init_fern = function()
        vim.cmd('silent! nunmap <buffer> s')
        vim.cmd('silent! nunmap <buffer> N')
        vim.keymap.set('n', 'o', '<Plug>(fern-action-open-or-expand)', { buffer = true })
        vim.keymap.set('n', 'l', '<Plug>(fern-action-open-or-expand)', { buffer = true })
        vim.keymap.set('n', 'p', '<Plug>(fern-action-open-or-expand)<C-w><C-w>', { buffer = true })
        vim.keymap.set('n', '<', '<Plug>(fern-action-open:vsplit)', { buffer = true })
        vim.keymap.set('n', '<', '<Plug>(fern-action-open:split)', { buffer = true })
        vim.keymap.set('n', '<', '<Plug>(fern-action-open:tabedit)', { buffer = true })
        vim.keymap.set('n', 'h', '<Plug>(fern-action-collapse)', { buffer = true })
        vim.keymap.set('n', '<', '<Plug>(fern-action-tcd)<Plug>(fern-action-open-or-enter)', { buffer = true })
        vim.keymap.set('n', '-', '<Plug>(fern-action-leave)<Plug>(fern-wait)<Plug>(fern-action-tcd:root)',
          { buffer = true })
        vim.keymap.set('n', 'L', '<Plug>(fern-action-new-file)', { buffer = true })
        vim.keymap.set('n', 'd', '<Plug>(fern-action-trash)<CR>', { buffer = true })
        vim.keymap.set('n', 'D', '<Plug>(fern-action-trash=)y<CR>', { buffer = true })
        vim.keymap.set('n', '~', '<Cmd>Fern ~<CR>', { buffer = true })
      end
      vim.api.nvim_create_augroup('fern-custom', {})
      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'fern',
        callback = function()
          init_fern()
          vim.fn['glyph_palette#apply']()
        end,
        group = 'fern-custom'
      })
    end,
    dependencies = { {
      'lambdalisue/fern-renderer-nerdfont.vim',
      dependencies = { 'lambdalisue/nerdfont.vim',
        'nvim-tree/nvim-web-devicons' }
    },
      'lambdalisue/glyph-palette.vim',
      'lambdalisue/fern-git-status.vim',
      'lambdalisue/fern-hijack.vim' },
    cmd = 'Fern'
  },

  -- mini.nvim for indentscope
  {
    'echasnovski/mini.nvim',
    init = function()
      require('mini.indentscope').setup {
        draw = {
          delay = 20,
          animation = require('mini.indentscope').gen_animation.none()
        },
        symbol = '│',
      }
    end
  },

  -- markdown
  'preservim/vim-markdown',

  -- buffer preview for markdown
  {
    'iamcco/markdown-preview.nvim',
    event = { 'BufRead', 'BufNewFile' },
    build = function() vim.fn["mkdp#util#install"]() end,
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
    keys = { 'ga', mode = 'x' }
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
    end,
    cmd = 'TagbarToggle'
  },

  -- Useful plugin to show you pending keybinds.
  { 'folke/which-key.nvim',                                opts = {}, event = 'BufEnter' },
  {
    -- Adds git releated signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
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
        map('v', '<leader>hs', function() gs.stage_hunk { vim.fn.line("."), vim.fn.line("v") } end)
        map('v', '<leader>hu', function() gs.reset_hunk { vim.fn.line("."), vim.fn.line("v") } end)
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
    event = { 'BufRead', 'BufNewFile' }
  },

  {
    -- colorscheme
    'woodyZootopia/iceberg.vim',
    priority = 1000,
    config = function()
      vim.cmd.colorscheme 'iceberg'
    end,
  },

  -- capture vim script output
  'https://github.com/tyru/capture.vim',

  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function ()
      require('lualine').setup({})
    end
  },

  {
    -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help indent_blankline.txt`
    opts = {
      char = '┊',
      show_trailing_blankline_indent = false,
    },
    event = { 'BufRead', 'BufNewFile' }
  },

  -- "gc" to comment visual regions/lines
  {
    'preservim/nerdcommenter',
    event = 'VimEnter',
    init = function()
      vim.g.NERDSpaceDelims = 1
      vim.g.NERDDefaultAlign = 'left'
      vim.g.NERDCustomDelimiters = { vim = { left = '"', right = '' } }
      vim.keymap.set("n", "<C-_>", "<Plug>NERDCommenterToggle")
      vim.keymap.set("n", "<C-/>", "<Plug>NERDCommenterToggle")
    end
  },


  -- Fuzzy Finder (files, lsp, etc)
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = { 'nvim-lua/plenary.nvim', {
      'nvim-telescope/telescope-fzf-native.nvim',
      -- NOTE: If you are having trouble with this installation,
      --       refer to the README for telescope-fzf-native for more instructions.
      build = 'make',
      cond = function()
        return vim.fn.executable 'make' == 1
      end,
    } },
    config = function()
      require('telescope').setup {
        defaults = {
          mappings = {
            i = {
              ['<C-u>'] = false,
              ['<C-d>'] = false,
            },
          },
        },
      }

      -- Enable telescope fzf native, if installed
      pcall(require('telescope').load_extension, 'fzf')
    end,
    init = function()
      vim.keymap.set('n', '<leader>gf', '<Cmd>Telescope git_files<CR>', { desc = 'Search [G]it [F]iles' })
      vim.keymap.set('n', '<leader>ff', '<Cmd>Telescope find_files<CR>', { desc = '[F]ind [F]iles' })
      vim.keymap.set('n', '<leader>fr', '<Cmd>Telescope oldfiles<CR>')
      vim.keymap.set('n', '<leader>fh', '<Cmd>Telescope help_tags<CR>', { desc = '[F]ind [H]elp' })
      vim.keymap.set('n', '<leader>fw', '<Cmd>Telescope grep_string<CR>', { desc = '[F]ind current [W]ord' })
      vim.keymap.set('n', '<leader>fg', '<Cmd>Telescope live_grep<CR>', { desc = '[F]ind by [G]rep' })
      vim.keymap.set('n', '<leader>fd', '<Cmd>Telescope diagnostics<CR>', { desc = '[F]ind [D]iagnostics' })
    end,
    cmd = 'Telescope',
  },



  {
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter.configs').setup {
        -- Add languages to be installed here that you want installed for treesitter
        ensure_installed = { 'c', 'cpp', 'go', 'lua', 'python', 'rust', 'tsx', 'typescript', 'vimdoc', 'vim' },

        -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
        auto_install = false,

        highlight = { enable = true },
        indent = { enable = true },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = '<c-space>',
            node_incremental = '<c-space>',
            scope_incremental = '<c-s>',
            node_decremental = '<M-space>',
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
    dependencies = 'nvim-treesitter/nvim-treesitter',
    config = function()
      require "treesitter-context".setup()
      vim.keymap.set("n", "[c", function()
        require("treesitter-context").go_to_context()
      end, { silent = true })
    end,
  },

  {
    'woodyZootopia/gitsession.vim',
    init = function()
      vim.g.gitsession_autosave = 1
      vim.g.gitsession_tmp_dir = vim.fn.stdpath('config') .. '/tmp/gitsession'
    end
  },

  {
    'inkarkat/vim-SpellCheck',
    cmd = 'SpellCheck',
    dependencies = 'vim-ingo-library'
  },

  {
    'lervag/vimtex',
    ft = 'tex',
    init = function()
      vim.g.tex_flavor = 'latex'
      vim.g.tex_conceal = 'abdmg'
      vim.g.vimtex_fold_enabled = 1
      vim.g.vimtex_view_method = 'zathura'
      vim.g.vimtex_quickfix_enabled = 0
      vim.g.vimtex_quickfix_mode = 0
      vim.g.vimtex_fold_manual = 1
      -- Do below if using treesitter
      -- vim.g.vimtex_syntax_enabled = 0
      -- vim.g.vimtex_syntax_conceal_disable = 1
    end
  },

  -- Japanese

  {
    'woodyZootopia/jpmoveword.vim',
    init = function()
      vim.g.jpmoveword_separator = '，．、。・「」『』（）【】'
      vim.g.matchpairs_textobject = 1
      vim.g.jpmoveword_stop_eol = 2
    end
  },

  { dir = '~/ghq/github.com/woodyZootopia/novel_formatter' },

  {
    dir = '~/ghq/github.com/woodyZootopia/novel-preview.vim',
    ft = 'text',
    dependencies = 'vim-denops/denops.vim',
    init = function()
      vim.g['denops#deno'] = '/Users/snakamura/.deno/bin/deno'
    end,
    config = function()
      vim.keymap.set('n', '<F5>', '<Cmd>NovelPreviewStartServer<CR><Cmd>NovelPreviewAutoSend<CR>')
    end
  },

  -- NOTE: Next Step on Your Neovim Journey: Add/Configure additional "plugins" for kickstart
  --       These are some example plugins that I've included in the kickstart repository.
  --       Uncomment any of the lines below to enable them.
  -- require 'kickstart.plugins.autoformat',
  -- require 'kickstart.plugins.debug',

  -- NOTE: The import below automatically adds your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
  --    You can use this folder to prevent any conflicts with this init.lua if you're interested in keeping
  --    up-to-date with whatever is in the kickstart repo.
  --
  --    For additional information see: https://github.com/folke/lazy.nvim#-structuring-your-plugins
  { import = 'custom.plugins' },
}, {})

-- [[ Setting options ]]
-- See `:help vim.o`
-- NOTE: You can change these options as you wish!

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
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

vim.o.cursorline = true

vim.o.shada = "!,'50,<1000,s100,h,%0"

vim.opt.sessionoptions:remove({ 'blank', 'buffers' })

vim.o.fileencodings = 'utf-8,ios-2022-jp,euc-jp,sjis,cp932'

vim.o.previewheight = 999

vim.o.list = true
vim.o.listchars = 'tab:»-,trail:~,extends:»,precedes:«,nbsp:%'

vim.o.scrolloff = 5

vim.o.showtabline = 2

vim.o.winblend = 25
vim.o.pumblend = 20

vim.o.smartindent = true
vim.o.expandtab = true

vim.opt.formatoptions:append({ 'm', 'M' })

vim.o.inccommand = 'split'

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

vim.opt.matchpairs:append({ '「:」', '（:）', '『:』', '【:】', '〈:〉', '《:》', '〔:〕', '｛:｝', '<:>' })

vim.o.spelllang = 'en,cjk'

vim.go.signcolumn = 'yes:1'

-- [[ Basic Keymaps ]]

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
vim.keymap.set({ 'n', 'v' }, '<C-Space>', '<Nop>', { silent = true })

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
vim.keymap.set('n', '<C-w>c', '<Cmd>tab sp<CR>')
vim.keymap.set('n', '<C-w><C-c>', '<Cmd>tab sp<CR>')
vim.keymap.set('n', '<Plug>(my-win)C', '<Cmd>-tab sp<CR>')
vim.keymap.set('n', '<Plug>(my-win)j', '<C-w>j')
vim.keymap.set('n', '<Plug>(my-win)k', '<C-w>k')
vim.keymap.set('n', '<Plug>(my-win)l', '<C-w>l')
vim.keymap.set('n', '<Plug>(my-win)h', '<C-w>h')
vim.keymap.set('n', '<Plug>(my-win)J', '<C-w>J')
vim.keymap.set('n', '<Plug>(my-win)K', '<C-w>K')
vim.keymap.set('n', '<Plug>(my-win)L', '<C-w>L')
vim.keymap.set('n', '<Plug>(my-win)H', '<C-w>H')
vim.keymap.set('n', '<Plug>(my-win)n', 'gt')
vim.keymap.set('n', '<Plug>(my-win)p', 'gT')
vim.keymap.set('n', '<Plug>(my-win)r', '<C-w>r')
vim.keymap.set('n', '<Plug>(my-win)=', '<C-w>=')
vim.keymap.set('n', '<Plug>(my-win)O', '<C-w>=')
vim.keymap.set('n', '<Plug>(my-win)o', '<C-w>_<C-w>|')
vim.keymap.set('n', '<Plug>(my-win)q', '<Cmd>tabc<CR>')
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
vim.keymap.set('n', '<leader>q', '<Cmd>quit<CR>')
vim.keymap.set('n', '<leader>wq', '<Cmd>quitall<CR>')

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

vim.keymap.set('i', '<C-b>', "<Cmd>exec 'normal! b'<CR>")
vim.keymap.set('i', '<C-f>', "<Cmd>exec 'normal! w'<CR>")
vim.keymap.set('i', '<C-p>', "<Cmd>exec 'normal! gk'<CR>")
vim.keymap.set('i', '<C-n>', "<Cmd>exec 'normal! gj'<CR>")

vim.keymap.set('n', 'gss', '<Cmd>SaveSession<CR>')
vim.keymap.set('n', 'gsr', '<Cmd>StartRepeatedSave<CR>')
vim.keymap.set('n', 'gsl', '<Cmd>LoadSession<CR>')
vim.keymap.set('n', 'gsc', '<Cmd>CleanUpSession<CR>')

-- 行頭/行末へ移動
vim.keymap.set({ 'i', 'c' }, '<C-A>', '<Home>')
vim.keymap.set({ 'i', 'c' }, '<C-E>', '<End>')

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
    vim.opt_local.wrap = false
  end,
  group = 'quick-fix-window'
})

vim.cmd([[

" vimgrep
nnoremap <leader>vv :<C-u>vimgrep // %:p:h/*<Left><Left><Left><Left><Left><Left><Left><Left><Left>


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

  "  プログラムっぽいファイルならbreakindent
  au FileType c,cpp,rust,go,python,lua,bash,vim,tex,markdown setlocal breakindent
augroup END

function! Preserve(command)
  let l:curw = winsaveview()
  execute a:command
  call winrestview(l:curw)
endfunction
augroup formatter
  autocmd!
  " autocmd BufWritePre *.py call Preserve(':silent %!black -q - --target-version py310 2>/dev/null')
augroup END

" 検索中の領域をハイライトする
" ヘルプドキュメント('incsearch')からコピーした
augroup vimrc-incsearch-highlight
  au!
  au CmdlineEnter /,\? set hlsearch
  au CmdlineLeave /,\? set nohlsearch
augroup END

" 選択した領域を自動でハイライトする
if !exists("g:vscode")
  augroup instant-visual-highlight
    au!
    autocmd ColorScheme * hi SearchWordMatch gui=reverse
    autocmd CursorMoved,CursorHold * call Visualmatch()
  augroup END
endif

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
    let text = getline('.')->strcharpart(colrange[0]-1, colrange[1]-colrange[0]+1)
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
    let w:visual_match_id = matchadd('SearchWordMatch', '\V' .. text)
  else
    let w:visual_match_id = matchadd('SearchWordMatch', '\V\<' .. text .. '\>')
  endif
endfunction

" 単語を自動でハイライトする
augroup cursor-word-highlight
  au!
  autocmd ColorScheme * hi CursorWord guibg=#282d44
  autocmd CursorHold * call Wordmatch()
  autocmd InsertEnter * call DelWordmatch()
augroup END

function! Wordmatch()
  if &ft=='fern'
    return
  endif
  call DelWordmatch()

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
  au BufWritePre *.ipynb let g:jupyter_previous_location = getpos('.')
  au BufWritePre *.ipynb %!jupytext --from py:percent --to ipynb
  au BufWritePost *.ipynb %!jupytext --from ipynb --to py:percent
  au BufWritePost *.ipynb if exists('g:jupyter_previous_location') | call setpos('.', g:jupyter_previous_location) | endif
augroup END

augroup lua-highlight
  autocmd!
  autocmd TextYankPost * silent! lua vim.highlight.on_yank({higroup='Pmenu', timeout=200})
augroup END
]])

-- [[  autocmd-fcitx ]]
vim.cmd([[
nnoremap <silent><expr> <F2> Fcitx_toggle()
inoremap <silent><expr> <F2> Fcitx_toggle()
nnoremap <silent> <Plug>(my-switch)j :call Toggle_fcitx_toggling()<CR>
nnoremap <silent> <Plug>(my-switch)<C-j> :call Toggle_fcitx_toggling()<CR>

let g:is_fcitx_toggling_enabled = v:false
function! Toggle_fcitx_toggling() abort
  if g:is_fcitx_toggling_enabled
    let g:is_fcitx_toggling_enabled=v:false
    augroup fcitx_autoenable
      autocmd!
    augroup END
    echomsg 'Fcitx toggling disabled'
  else
    let g:is_fcitx_toggling_enabled=v:true
    augroup fcitx_autoenable
      autocmd!
      autocmd InsertEnter * if get(b:, 'fcitx_autoenable', '0') | call Enable() | endif
      autocmd CmdLineEnter /,\? if get(b:, 'fcitx_autoenable', '0') | call Enable() | endif
      autocmd InsertLeave * call Disable()
      autocmd CmdlineLeave /,\? call Disable()
      " autocmd FileType markdown,pixiv nnoremap <buffer><silent><expr> <F2> <SID>fcitx_toggle()
    augroup END
    echomsg 'Fcitx toggling enabled'
  endif
endfunction

function! Fcitx_toggle() abort
  let b:fcitx_autoenable = !get(b:, 'fcitx_autoenable', '0')
  if b:fcitx_autoenable ==# 1
    if !g:is_fcitx_toggling_enabled
      call Toggle_fcitx_toggling()
    endif
    echomsg '日本語入力モードON'
    if index(['i'], mode()) != -1
      call Enable()
    endif
  else
    echo '日本語入力モードOFF'
    if index(['i'], mode()) != -1
      call Disable()
    endif
  endif
  return ''
endfunction

function! Enable() abort
  if g:is_macos
    call system('/Users/snakamura/im-select com.justsystems.inputmethod.atok32.Japanese')
  else
    call system('fcitx5-remote -o')
  endif
endfunction

function! Disable() abort
  if g:is_macos
    call system('/Users/snakamura/im-select com.apple.keylayout.ABC')
  else
    call system('fcitx5-remote -c')
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
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
-- vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et