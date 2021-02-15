augroup fileType
  au!
  au BufRead            *.cls     set      ft=tex
  au filetype           python    setlocal foldmethod=indent
  au filetype           c,cpp     setlocal foldmethod=indent
  au filetype           go        setlocal tabstop=4 shiftwidth=4 noexpandtab | set formatoptions+=r
  au filetype           tex       setlocal tabstop=4 shiftwidth=4 foldmethod=syntax spell
  au filetype           tex       imap     <buffer> ( (
  au filetype           tex       imap     <buffer> { {
  au filetype           tex       imap     <buffer> [ [
  au filetype           html      setlocal nowrap
  au filetype           csv       setlocal nowrap
  au filetype           tsv       setlocal nowrap
  au filetype           text      setlocal noet spell
  au filetype           mail      setlocal noet spell
  au filetype           gitcommit setlocal spell
  au filetype           markdown  setlocal noet spell
  au BufNewFile,BufRead *.grg     setlocal nowrap
  au BufNewFile,BufRead *.jl      setf     julia
  au BufNewFile,BufRead *.pxv     setf     pixiv
  au filetype           help      setlocal spell noet
augroup END

augroup localleader
    autocmd!
    autocmd FileType tex    map <buffer> <localleader>s <plug>(vimtex-env-toggle-star)
    autocmd FileType tex    map <buffer> <localleader>t <plug>(vimtex-toc-toggle)
    autocmd FileType tex    map <buffer> <localleader>e <plug>(vimtex-env-change)
    autocmd FileType tex    map <buffer> <localleader>d <plug>(vimtex-delim-toggle-modifier)
    autocmd FileType python map <buffer> <localleader>r :%AsyncRun python<CR>
    autocmd FileType ruby map <buffer> <localleader>r :%AsyncRun ruby<CR>
augroup END

augroup Binary
    au!
    au BufReadPre  *.bin setlocal bin
    au BufReadPre  *.img setlocal bin
    au BufReadPre  *.sys setlocal bin
    au BufReadPre  *.torrent setlocal bin
    au BufReadPre  *.out setlocal bin
    au BufReadPre  *.a setlocal bin

    au BufReadPost * if &bin | %!xxd
    au BufReadPost * setlocal ft=xxd | endif

    au BufWritePre * if &bin | %!xxd -r
    au BufWritePre * endif

    au BufWritePost * if &bin | %!xxd
    au BufWritePost * set nomod | endif
augroup END

augroup CSV_TSV
    au!
    au BufReadPost,BufWritePost *.csv %!column -s, -o, -t
    au BufWritePre              *.csv %s/\s\+,/,/ge
    au BufReadPost,BufWritePost *.tsv %!column -s "$(printf '\t')" -o "$(printf '\t')" -t
    au BufWritePre              *.tsv %s/ \+	/	/ge
augroup END

augroup LuaHighlight
  autocmd!
  autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank()
augroup END

augroup limitlento80
    autocmd!
    " autocmd Filetype tex,gitcommit execute "set colorcolumn=" . join(range(81,335), ',')
    " autocmd Filetype tex,gitcommit hi ColorColumn cterm=NONE ctermbg=251 ctermfg=237 guibg=#cad0de guifg=#576a9e
augroup end
