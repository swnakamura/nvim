setlocal foldmethod=indent
nnoremap <buffer> gF            <Cmd>call Preserve(':silent %!black -q - --target-version py310 2>/dev/null')<CR>
