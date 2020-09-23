inoremap <buffer> <silent> <expr> <C-b> pumvisible() ? "<C-e><C-r>=ExecExCommand('normal h')<CR>" : "<C-r>=ExecExCommand('normal h')<CR>"
inoremap <buffer> <silent> <expr> <C-f> pumvisible() ? "<C-e><C-r>=ExecExCommand('normal l')<CR>" : "<C-r>=ExecExCommand('normal l')<CR>"
