setlocal shiftwidth=4
setlocal makeprg=deno
nnoremap <buffer> <F5> <Cmd>make run --allow-net --allow-read "%"<CR>
iab <buffer> arr =>
