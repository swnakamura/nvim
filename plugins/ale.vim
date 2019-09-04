let g:ale_fixers = {
            \'*': ['trim_whitespace'],
            \'python': ['autopep8'],
            \}

nnoremap <leader>ap :ALEFix<CR>
