inoremap <buffer> #s \section{}<Left>
inoremap <buffer> ##s \subsection{}<Left>
inoremap <buffer> ###s \subsubsection{}<Left>

setlocal foldmethod=indent

noremap <buffer> <localleader>s <plug>(vimtex-env-toggle-star)
noremap <buffer> <localleader>t <plug>(vimtex-toc-toggle)
noremap <buffer> <localleader>e <plug>(vimtex-env-change)
noremap <buffer> <localleader>d <plug>(vimtex-delim-toggle-modifier)
noremap <buffer> <F5>           :VimtexCompile<CR>
noremap <buffer> <F6>           :VimtexClean<CR>
noremap <buffer> <F7>           :VimtexCompileOutput<CR>

imap <buffer> ( (
imap <buffer> { {
imap <buffer> [ [
