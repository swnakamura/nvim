let g:tex_conceal = ''
" set conceallevel=0
let g:vimtex_fold_enabled = 1
let g:vimtex_fold_manual = 1
" set fillchars=fold:\ 
let g:vimtex_mappings_disable = {
    \ 'n': ['tsc', 'tse', 'tsd', 'tsD'],
    \ 'x': ['tsd', 'tsD'],
    \}
map <localleader>ts <plug>(vimtex-env-toggle-star)
map <localleader>t <plug>(vimtex-toc-toggle)
