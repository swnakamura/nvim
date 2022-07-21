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
    set dictionary+=/usr/share/dict/words
    call ddc#custom#set_context(["python", "c", "cpp", "[a-z, A-Z]+"], { ->
      \ ddc#syntax#in('Comment') || ddc#syntax#in('String') || ddc#syntax#in('rustCommentLineDoc') ? {
      \   'sources': ['file', 'dictionary', 'around', 'buffer'],
      \ } : {} })
    call ddc#custom#patch_filetype(["text", "markdown", "gitcommit", 'tex'], 'sources', ['file', 'around', 'buffer', 'dictionary'])
    call ddc#custom#patch_global('sourceOptions', {
        \ 'file': { 'mark': 'F', 'forceCompletionPattern': '\S/\S*'},
        \ 'nvim-lsp': { 'mark':'lsp', 'forceCompletionPattern': '\.\w*|:\w*|->\w*'},
        \ 'around': { 'mark': 'A' },
        \ 'buffer': { 'mark': 'B' },
        \ 'ultisnips': { 'mark': 'US' },
        \ '_': { 'matchers': ['matcher_fuzzy'],
        \        'sorters':  ['sorter_rank'],
        \        'ignoreCase': v:true},
        \   })
    call ddc#custom#patch_global('sourceParams', {
        \ 'nvim-lsp': { 'kindLabels': { 'Class': 'c' } },
        \ 'buffer': {'requireSameFiletype': v:false},
        \   })
    call ddc#enable()
endfunction

function! Nerdcommenter_add() abort
    nnoremap <C-->             <Plug>kommentary_line_default
    vnoremap <C-->             <Plug>kommentary_visual_default<ESC>
    nnoremap <leader>c<leader> <Plug>kommentary_line_default
    vnoremap <leader>c<leader> <Plug>kommentary_visual_default<ESC>
    nnoremap <leader>cc        <Plug>kommentary_line_increase
    vnoremap <leader>cc        <Plug>kommentary_visual_increase<ESC>
    nnoremap <leader>cy        yy<Plug>kommentary_line_increase
    vnoremap <leader>cy        ygv<Plug>kommentary_visual_increase<ESC>
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
    " set conceallevel=1
    let g:vimtex_fold_enabled = 1
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
            \ 'callback' : 1,
            \ 'continuous' : 1,
            \ 'executable' : 'latexmk',
            \ 'hooks' : [],
            \ 'options' : [
            \   '-verbose',
            \   '-file-line-error',
            \   '-synctex=1',
            \   '-interaction=nonstopmode',
            \   '-shell-escape',
            \ ],
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
    }
  },
  indent = {
    enable = false
  },
  ensure_installed = {'c', 'cpp', 'python', 'rust', 'latex', 'vim'}
}
EOF
endfunction
