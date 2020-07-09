" " compiler settings
nnoremap <buffer> <localleader>r :cd %:p:h<CR>:make! run<CR>
nnoremap <buffer> <F6>           :cd %:p:h<CR>:make! build<CR>
nnoremap <buffer> <F7>           :cd %:p:h<CR>:make! doc<CR>
nnoremap <buffer> <F8>           :cd %:p:h<CR>:make! doc --open<CR>
if expand('%:p') =~ 'kyopro'
    nnoremap <buffer> <F6>           :cd %:p:h<CR>:make! build --bin %:t:r<CR>
    nnoremap <buffer> <F9>           :cd %:p:h<CR>:make! atcoder submit %:t:r<CR>
endif

iab ar =>
