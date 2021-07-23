setlocal shiftwidth=4
set makeprg=deno
nnoremap <F5> <Cmd>make run --allow-net --allow-read "%"<CR>
iab <buffer> arr =>
