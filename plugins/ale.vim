let g:ale_fixers = {
            \'*': ['trim_whitespace','remove_trailing_lines'],
            \'python': ['autopep8', 'trim_whitespace', 'isort'],
            \'go': ['gofmt'],
            \'javascript': ['prettier'],
            \'vue': ['prettier']
            \}

let g:ale_linters = {
            \'go':['gopls'],
            \'python':['pyls']
            \}

nnoremap <leader>ap :ALEFix<CR>

nnoremap ]a :ALENext<CR>
nnoremap [a :ALEPrevious<CR>
