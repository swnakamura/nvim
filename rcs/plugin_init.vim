function! Asterisk_add() abort
    map *   <Plug>(asterisk-*)
    map #   <Plug>(asterisk-#)
    map g*  <Plug>(asterisk-g*)
    map g#  <Plug>(asterisk-g#)
    map z*  <Plug>(asterisk-z*)
    map gz* <Plug>(asterisk-gz*)
    map z#  <Plug>(asterisk-z#)
    map gz# <Plug>(asterisk-gz#)
    let g:asterisk#keeppos = 1
endfunction

function! Ddc_add() abort
    call ddc#custom#patch_global('sources', ['file', 'nvim-lsp', 'around', 'ultisnips', 'buffer'])
    call ddc#custom#patch_global('cmdlineSources', ['cmdline', 'cmdline-history', 'file', 'around'])
    if filereadable('/usr/share/dict/words')
        set dictionary+=/usr/share/dict/words
    endif
    call ddc#custom#set_context(["python", "c", "cpp", "[a-z, A-Z]+"], { ->
      \ ddc#syntax#in('Comment') || ddc#syntax#in('String') || ddc#syntax#in('rustCommentLineDoc') ? {
      \   'sources': ['file', 'dictionary', 'around', 'buffer'],
      \ } : {} })
    call ddc#custom#patch_filetype(["text", "markdown", "gitcommit", 'tex'], 'sources', ['file', 'nvim-lsp', 'ultisnips', 'around', 'buffer', 'dictionary'])
    call ddc#custom#patch_global('sourceOptions', {
        \ 'file': { 'mark': 'F', 'forceCompletionPattern': '\S/\S*'},
        \ 'nvim-lsp': { 'mark':'lsp', 'forceCompletionPattern': '\.\w*|:\w*|->\w*'},
        \ 'around': { 'mark': 'A' },
        \ 'buffer': { 'mark': 'B' },
        \ 'ultisnips': { 'mark': 'US' },
        \ '_': { 'matchers': ['matcher_fuzzy'],
        \        'sorters':  ['sorter_rank'],
        \        'ignoreCase': v:true},
        \ 'cmdline': {
        \       'mark': 'cmdline',
        \       'forceCompletionPattern': '\S/\S*',
        \       'dup': 'force',
        \   }
        \})
    call ddc#custom#patch_global('sourceParams', {
        \ 'nvim-lsp': { 'kindLabels': { 'Class': 'c' } },
        \ 'buffer': {'requireSameFiletype': v:false},
        \   })
    call ddc#enable()

    " Use pum.vim
	call ddc#custom#patch_global('autoCompleteEvents', [
		\ 'InsertEnter', 'TextChangedI', 'TextChangedP',
		\ 'CmdlineEnter', 'CmdlineChanged',
		\ ])
    call ddc#custom#patch_global('completionMenu', 'pum.vim')

    " pum mappings
    inoremap <silent><expr> <C-n>   pum#visible() ? '<Cmd>call pum#map#insert_relative(+1)<CR>' : "<C-r>=ExecExCommand('normal gj')<CR>"
    inoremap <silent><expr> <C-p>   pum#visible() ? '<Cmd>call pum#map#insert_relative(-1)<CR>' : "<C-r>=ExecExCommand('normal gk')<CR>"

    " command line settings
	nnoremap : <Cmd>call CommandlinePre()<CR>:
	function! CommandlinePre() abort
	  " Note: It disables default command line completion!
	  cnoremap <expr> <Tab>
	  \ pum#visible() ? '<Cmd>call pum#map#insert_relative(+1)<CR>' :
	  \ ddc#manual_complete()
	  cnoremap <expr> <S-Tab>
	  \ pum#visible() ? '<Cmd>call pum#map#insert_relative(-1)<CR>' :
	  \ ddc#manual_complete()
	  cnoremap <C-y>   <Cmd>call pum#map#confirm()<CR>
	  cnoremap <C-e>   <Cmd>call pum#map#cancel()<CR>

	  " Overwrite sources
	  if !exists('b:prev_buffer_config')
		let b:prev_buffer_config = ddc#custom#get_buffer()
	  endif
	  call ddc#custom#patch_buffer('sources',
			  \ ['cmdline', 'cmdline-history', 'around'])

	  autocmd User DDCCmdlineLeave ++once call CommandlinePost()
	  autocmd InsertEnter <buffer> ++once call CommandlinePost()
	  " Enable command line completion
	  call ddc#enable_cmdline_completion()
	endfunction

	function! CommandlinePost() abort
	  cunmap <Tab>
	  cunmap <S-Tab>
	  cunmap <C-y>
	  cunmap <C-e>

	  " Restore sources
	  if exists('b:prev_buffer_config')
		call ddc#custom#set_buffer(b:prev_buffer_config)
		unlet b:prev_buffer_config
	  else
		call ddc#custom#set_buffer({})
	  endif
	endfunction
endfunction

function! Textobjentire_add() abort
    let g:textobj_entire_no_default_key_mappings = 1
    omap av <Plug>(textobj-entire-a)
    omap iv <Plug>(textobj-entire-i)
    xmap av <Plug>(textobj-entire-a)
    xmap iv <Plug>(textobj-entire-i)
endfunction

function! Textobjpython_postsource() abort
    call textobj#user#map('python', {
          \   'class': {
          \     'select-a': '<buffer>ax',
          \     'select-i': '<buffer>ix',
          \     'move-n': '<buffer>]x',
          \     'move-p': '<buffer>[x',
          \   },
          \   'function': {
          \     'select-a': '<buffer>af',
          \     'select-i': '<buffer>if',
          \     'move-n': '<buffer>]f',
          \     'move-p': '<buffer>[f',
          \   }
          \ })
endfunction

function! Textobjuser_add() abort
    " operator mappings
    map        <silent>sa             <Plug>(operator-surround-append)
    map        <silent>sd             <Plug>(operator-surround-delete)
    map        <silent>sr             <Plug>(operator-surround-replace)
    omap       ab                     <Plug>(textobj-multiblock-a)
    omap       ib                     <Plug>(textobj-multiblock-i)
    vmap       ab                     <Plug>(textobj-multiblock-a)
    vmap       ib                     <Plug>(textobj-multiblock-i)

    " if you use vim-textobj-multiblock
    nmap <silent>sdd <Plug>(operator-surround-delete)<Plug>(textobj-multiblock-a)
    nmap <silent>srr <Plug>(operator-surround-replace)<Plug>(textobj-multiblock-a)

    " if you use vim-textobj-between
    nmap <silent>sdb <Plug>(operator-surround-delete)<Plug>(textobj-between-a)
    nmap <silent>srb <Plug>(operator-surround-replace)<Plug>(textobj-between-a)
endfunction

function! Vimtex_add() abort
    let g:tex_flavor = 'latex'
    let g:tex_conceal = 'abdmg'
    let g:vimtex_fold_enabled = 1
    let g:vimtex_view_general_viewer='evince'
    " let g:vimtex_quickfix_enabled=0
    let g:vimtex_quickfix_mode = 0
    let g:vimtex_fold_manual = 1
    " let g:vimtex_view_method='zathura'
    " set fillchars=fold:\ 
    " let g:vimtex_mappings_disable = {
    "     \ 'n': ['tsc', 'tse', 'tsd', 'tsD', 'tsf'],
    "     \ 'x': ['tsd', 'tsD', 'tsf'],
    "     \ 'i': [']]'],
    "     \}
    let g:vimtex_compiler_latexmk = {
            \ 'build_dir' : 'livepreview',
          \}
endfunction

function! Fzf_add() abort
    nnoremap <silent> <space>fr  <Cmd>History<CR>
    nnoremap <silent> <space>ff  <Cmd>Files<CR>
    nnoremap <silent> <space>fb  <Cmd>Buffers<CR>
    nnoremap <silent> <space>fc  <Cmd>History:<CR>
    " nnoremap <silent> <space>fgc  <Cmd>Commits<CR>
    nnoremap <silent> <space>fm  <Cmd>Maps<CR>
    nnoremap <silent> <space>fh  <Cmd>Helptags<CR>
    nnoremap <silent> <space>ft  <Cmd>Tags<CR>
    nnoremap <silent> <space>fg  <Cmd>Rg<CR>
endfunction

function! Gitgutter_add() abort
    let g:gitgutter_preview_win_floating = 1
    nmap <Leader>hs <Plug>(GitGutterStageHunk)
    nmap <Leader>hu <Plug>(GitGutterUndoHunk)
    nmap <Leader>hp <Plug>(GitGutterPreviewHunk)
    nmap ]h         <Plug>(GitGutterNextHunk)
    nmap [h         <Plug>(GitGutterPrevHunk)
    omap ih         <Plug>(GitGutterTextObjectInnerPending)
    omap ah         <Plug>(GitGutterTextObjectOuterPending)
    xmap ih         <Plug>(GitGutterTextObjectInnerVisual)
    xmap ah         <Plug>(GitGutterTextObjectOuterVisual)
    nmap ]c         <Plug>(GitGutterNextHunk)
    nmap [c         <Plug>(GitGutterPrevHunk)
    omap ic         <Plug>(GitGutterTextObjectInnerPending)
    omap ac         <Plug>(GitGutterTextObjectOuterPending)
    xmap ic         <Plug>(GitGutterTextObjectInnerVisual)
    xmap ac         <Plug>(GitGutterTextObjectOuterVisual)

    nmap <Up> <Plug>(GitGutterStageHunk)
    nmap <PageUp> <Plug>(GitGutterPrevHunk)<Plug>(GitGutterPreviewHunk)
    nmap <PageDown> <Plug>(GitGutterNextHunk)<Plug>(GitGutterPreviewHunk)
endfunction

function! Fugitive_add() abort
    nnoremap <leader>gs :Git <CR><C-w>T
    nnoremap <leader>ga :Gwrite<CR>
    nnoremap <leader>gc :Git commit -v<CR>
    nnoremap <leader>gb :Git blame<CR>
    nnoremap <leader>gh :tab sp<CR>:0Gclog<CR>
    nnoremap <leader>gp <Cmd>Dispatch! git push<CR>
    nnoremap <leader>gf <Cmd>Dispatch! git fetch<CR>
    nnoremap <leader>gd :vert :Gdiffsplit<CR>
    nnoremap <leader>gr :Git rebase -i<CR>
    nnoremap <leader>gg :Glgrep ""<Left>
    nnoremap <leader>gm :Git merge 

    nnoremap <S-Up> :Gwrite<CR>
    nnoremap <C-Up> :Git commit -v<CR>
    nnoremap <expr> <Right> '<Cmd>' . (&diff ? 'only' : 'vert Gdiffsplit!') . '<CR>'
    nnoremap <expr> <Left> '<Cmd>' . (&ft==#'fugitiveblame' ? 'quit' : 'Git blame') . '<CR>'
    nnoremap <Down> <Cmd>Dispatch! git fetch<CR>
    nnoremap <C-Down> <Cmd>Dispatch! git pull<CR>
endfunction

function! Lightline_add() abort
    let g:lightline = {
                \  'colorscheme': 'iceberg',
                \  'active': {
                    \     'right' : [ [ 'lineinfo' ],
                    \            [ 'percent', 'editdistance', 'fileencoding' ],
                    \            [ 'fileformat', 'fileencoding', 'filetype' ] ]
                    \ },
                    \ 'component_function': {
                        \    'editdistance': 'NCCCachedEditDistance',
                        \}
                    \}

    "let g:lightline.separator = { 'left': "\ue0b8", 'right': "\ue0be" }
    "let g:lightline.subseparator = { 'left':  "\ue0b9", 'right': "\ue0b9"  }
    "let g:lightline.tabline_separator = { 'left': "\ue0bc", 'right': "\ue0ba" }
    "let g:lightline.tabline_subseparator = { 'left': "\ue0bb", 'right': "\ue0bb" }
endfunction

function! Treesitter_postsource() abort
    lua <<EOF
require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
    disable = {
      'lua',
      'toml',
      'tex',
      'latex',
      'vim',
    }
  },
  indent = {
    enable = false
  },
  ensure_installed = {'c', 'cpp', 'python', 'rust', 'org'}
}
EOF
endfunction

function! Nvim_cmp_postsource() abort
set completeopt=menu,menuone,noselect

lua <<EOF
  -- Set up nvim-cmp.
  local cmp = require'cmp'

  cmp.setup({
    snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
        -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
        -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
        vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
      end,
    },
    window = {
      -- completion = cmp.config.window.bordered(),
      -- documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      -- { name = 'vsnip' }, -- For vsnip users.
      -- { name = 'luasnip' }, -- For luasnip users.
      -- { name = 'ultisnips' }, -- For ultisnips users.
      -- { name = 'snippy' }, -- For snippy users.
    }, {
      { name = 'buffer' },
    })
  })

  -- Set configuration for specific filetype.
  cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
      { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
    }, {
      { name = 'buffer' },
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

  -- Set up lspconfig.
  local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
  -- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
  require('lspconfig')['pyright'].setup {
  }
EOF
endfunction
