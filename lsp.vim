" dictionaryを宣言
let g:LSP_commands = {}

" それぞれの言語を追加
" 例えば、C/C++:
if executable(expand('clangd'))
    let g:LSP_commands['c'] = 'clangd'
    let g:LSP_commands['cpp'] = 'clangd'
endif

" Rust
if executable(expand('rust-analyzer'))
    let g:LSP_commands['rust'] = 'rust_analyzer'
endif

" Python
if executable(expand('pyls'))
    let g:LSP_commands['python'] = 'pyls'
endif

" 追加したそれぞれの言語についてLSPコマンドを起動
for [key,val] in items(g:LSP_commands)
    exe 'lua require''nvim_lsp''.' . val . '.setup{}'
endfor


"lsp.txtそのまま
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
    endif
endfunction

autocmd BufRead * call LC_maps()

" 特定のファイルの時、保存時に整形する
augroup lspAutoFormat
    autocmd!
    autocmd BufWritePre *.rs,*.c,*.cpp,*.py lua vim.lsp.buf.formatting_sync(nil, 1000)
augroup END
