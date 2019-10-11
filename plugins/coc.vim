nmap <leader>af <Plug>(coc-format)
nmap <leader>ar <Plug>(coc-rename)
nmap <leader>ad <Plug>(coc-definition)

let g:coc_snippet_next = "<C-k>"
let g:coc_snippet_prev = "<C-j>"

inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
imap <expr><tab> pumvisible() ? "\<C-n>" : "\<tab>"
