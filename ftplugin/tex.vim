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



noremap <buffer> <localleader>s <plug>(vimtex-env-toggle-star)
noremap <buffer> <localleader>t <plug>(vimtex-toc-toggle)
noremap <buffer> <localleader>e <plug>(vimtex-env-change)
noremap <buffer> <localleader>d <plug>(vimtex-delim-toggle-modifier)
noremap <buffer> <localleader>r :VimtexCompile<CR>
noremap <buffer> <F6>           :VimtexClean<CR>
noremap <buffer> <F7>           :VimtexCompileOutput<CR>
