setlocal foldmethod=indent
nnoremap <buffer> gF            <cmd>update<CR><Cmd>call Preserve(':silent !ruff format --line-length=140' .. expand('%'))<CR>

" augroup format-with-ruff-on-save
"   au BufWritePost *.py call Preserve(':silent !ruff format ' .. expand('%'))
" augroup END
