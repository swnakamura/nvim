let g:tex_flavor = 'latex'
let g:tex_conceal = 'abdmg'
" set conceallevel=1
let g:vimtex_fold_enabled = 1
" let g:vimtex_quickfix_enabled=0
let g:vimtex_quickfix_mode = 0
let g:vimtex_fold_manual = 1
" let g:vimtex_view_method='zathura'
" set fillchars=fold:\ 
let g:vimtex_mappings_disable = {
    \ 'n': ['tsc', 'tse', 'tsd', 'tsD', 'tsf'],
    \ 'x': ['tsd', 'tsD', 'tsf'],
    \ 'i': [']]'],
    \}
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
