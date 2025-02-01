setlocal foldmethod=indent
" run ruff format and check
nnoremap <buffer> gF            <cmd>update<CR><cmd>call Preserve(':silent %!ruff format --line-length=140 -')<CR><cmd>call Preserve(':silent %!ruff check --fix-only -q --extend-select I -')<CR>

" augroup format-with-ruff-on-save
"   au BufWritePost *.py call Preserve(':silent !ruff format ' .. expand('%'))
" augroup END
