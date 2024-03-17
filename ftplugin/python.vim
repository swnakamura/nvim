setlocal foldmethod=indent
" nnoremap <buffer> gF            <Cmd>call Preserve(':silent !ruff format ' .. expand('%'))<CR>

augroup format-with-ruff-on-save
  au BufWritePost *.py call Preserve(':silent !ruff format ' .. expand('%'))
augroup END
