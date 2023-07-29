setlocal foldmethod=indent
noremap <buffer> <F5>           :cd %:h<CR>:AsyncRun python %<CR>
noremap <buffer> <F6>           :AsyncStop<CR>

nnoremap <buffer><expr> gF Preserve(':silent %!black -q - --target-version py310 2>/dev/null')
