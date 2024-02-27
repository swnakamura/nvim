setlocal foldmethod=indent
nnoremap <buffer> gF            <Cmd>call Preserve(':silent !ruff format ' .. expand('%'))<CR>
