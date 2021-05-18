" https://github.com/neovim/nvim-lspconfig を参考にした

" dictionaryを宣言
let g:LSP_commands = {}

" それぞれの言語を追加
" 例えば、C/C++:
if executable('clangd')
    let g:LSP_commands['c'] = 'clangd'
    let g:LSP_commands['cpp'] = 'clangd'
endif

" Rust
if executable('rust-analyzer')
    let g:LSP_commands['rust'] = 'rust_analyzer'
endif

" Python
if executable('pyls')
    let g:LSP_commands['python'] = 'pyls'
endif
if executable('pyright')
    let g:LSP_commands['python'] = 'pyright'
endif

" Vim Script
if executable('vim-language-server')
    let g:LSP_commands['vim'] = 'vimls'
endif

" 追加したそれぞれの言語についてLSP設定を起動
for [key, val] in items(g:LSP_commands)
    exe 'lua require''lspconfig''.' . val . '.setup{}'
endfor

" https://github.com/neovim/nvim-lspconfig そのまま
function! LC_maps()
    if has_key(g:LSP_commands, &filetype)
        nnoremap <buffer> <silent> gd    <cmd>lua vim.lsp.buf.declaration()<CR>
        nnoremap <buffer> <silent> <c-]> <cmd>lua vim.lsp.buf.definition()<CR>
        nnoremap <buffer> <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>
        nnoremap <buffer> <silent> gD    <cmd>lua vim.lsp.buf.implementation()<CR>
        nnoremap <buffer> <silent> <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
        inoremap <buffer> <silent> <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
        nnoremap <buffer> <silent> 1gD   <cmd>lua vim.lsp.buf.type_definition()<CR>
        nnoremap <buffer> <silent> gr    <cmd>lua vim.lsp.buf.rename()<CR>
        nnoremap <buffer> <silent> gR    <cmd>lua vim.lsp.buf.references()<CR>
        nnoremap <buffer> <silent> g0    <cmd>lua vim.lsp.buf.document_symbol()<CR>
        nnoremap <buffer> <silent> gW    <cmd>lua vim.lsp.buf.workspace_symbol()<CR>
        nnoremap <buffer>  gF    <cmd>lua vim.lsp.buf.formatting_sync(nil, 10000)<CR>
    endif
endfunction

autocmd BufEnter * call LC_maps()

" 特定のファイルの時、保存時に整形する
augroup lspAutoFormat
    autocmd!
    autocmd BufWritePre *.rs,*.c,*.cpp, lua vim.lsp.buf.formatting_sync(nil, 1000)
augroup END
