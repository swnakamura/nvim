" compiler settings
nnoremap <buffer> <S-F3> :cd %:p:h<CR>:make    check<CR>:copen<CR>
nnoremap <buffer> <F3>   :cd %:p:h<CR>:make    check<CR>
nnoremap <buffer> <F4>   :cd %:p:h<CR>:make!   build<CR>
nnoremap <buffer> <S-F4> :cd %:p:h<CR>:make    build<CR>
nnoremap <buffer> <F5>   :cd %:p:h<CR>:make!   run<CR>
nnoremap <buffer> <S-F5> :cd %:p:h<CR>:make    run<CR>

nnoremap <buffer> <S-F6> :cd %:p:h<CR>:make!   clean<CR>

nnoremap <buffer> <F7>   :cd %:p:h<CR>:make!   doc<CR>
nnoremap <buffer> <S-F7> :cd %:p:h<CR>:make!   doc --open<CR>

nnoremap <buffer> <F8>   :cd %:p:h<CR>:!rustup doc --std<CR>
nnoremap <buffer> <S-F8> :cd %:p:h<CR>:!rustup doc --std<CR>

nnoremap <buffer> <F9>   :cd %:p:h<CR>:make!   test<CR>
nnoremap <buffer> <S-F9> :cd %:p:h<CR>:make    test<CR>

if expand('%:p') =~ 'kyopro'
    nnoremap <buffer> <S-F5> :cd %:p:h<CR>:make build   --bin  %:t:r<CR>
    nnoremap <buffer> <F9>   :cd %:p:h<CR>:make atcoder submit %:t:r<CR>
endif

iab <buffer> arr =>
