" inoremap <buffer> ,, $$<`1`><Left><Left><Left><Left><Left><Left>
" imap     <buffer> .. <Plug>(vimtex-cmd-create)
inoremap <buffer> #s \section{}<Left>
inoremap <buffer> ##s \subsection{}<Left>
inoremap <buffer> ###s \subsubsection{}<Left>
" inoremap <buffer> __ _{\rm }<`1`><Left><Left><Left><Left><Left><Left>

function! Synctex()
    execute "!zathura --synctex-forward " . line('.') . ":" . col('.') . ":" . bufname('%') . " " . g:syncpdf
endfunction
map <buffer> <C-enter> :call Synctex()<CR>
