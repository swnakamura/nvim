function! woodyZootopia#init#nerdcommenter#add() abort
    let g:NERDSpaceDelims=1
    let g:NERDDefaultAlign='left'
    let g:NERDCustomDelimiters = {'vim': {'left': '"','right':''}}
    noremap <C-_> <Plug>NERDCommenterToggle
endfunction
