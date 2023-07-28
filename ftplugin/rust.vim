"        compiler settings
nnoremap <buffer> <F3>   <Cmd>cd %:p:h<CR><Cmd>make    check<CR>
nnoremap <buffer> <S-F3> <Cmd>cd %:p:h<CR><Cmd>make    check<CR><Cmd>copen<CR>
nnoremap <buffer> <F15>  <Cmd>cd %:p:h<CR><Cmd>make    check<CR><Cmd>copen<CR>

nnoremap <buffer> <F4>   <Cmd>cd %:p:h<CR><Cmd>make!   build<CR>
nnoremap <buffer> <S-F4> <Cmd>cd %:p:h<CR><Cmd>make    build<CR>
nnoremap <buffer> <F16>  <Cmd>cd %:p:h<CR><Cmd>make    build<CR>

nnoremap <buffer> <F5>   <Cmd>cd %:p:h<CR><Cmd>make!   run<CR>
nnoremap <buffer> <S-F5> <Cmd>cd %:p:h<CR><Cmd>make    run<CR>
nnoremap <buffer> <F17>  <Cmd>cd %:p:h<CR><Cmd>make    run<CR>

nnoremap <buffer> <S-F6> <Cmd>cd %:p:h<CR><Cmd>make!   clean<CR>
nnoremap <buffer> <F18>  <Cmd>cd %:p:h<CR><Cmd>make!   clean<CR>

nnoremap <buffer> <F7>   <Cmd>cd %:p:h<CR><Cmd>make!   doc<CR>
nnoremap <buffer> <S-F7> <Cmd>cd %:p:h<CR><Cmd>make!   doc --open<CR>
nnoremap <buffer> <F19>  <Cmd>cd %:p:h<CR><Cmd>make!   doc --open<CR>

nnoremap <buffer> <F8>   <Cmd>cd %:p:h<CR><Cmd>!rustup doc --std<CR>
nnoremap <buffer> <S-F8> <Cmd>cd %:p:h<CR><Cmd>!rustup doc --std<CR>
nnoremap <buffer> <F20>  <Cmd>cd %:p:h<CR><Cmd>!rustup doc --std<CR>

nnoremap <buffer> <F9>   <Cmd>cd %:p:h<CR><Cmd>make!   test<CR>
nnoremap <buffer> <S-F9> <Cmd>cd %:p:h<CR><Cmd>make    test<CR>
nnoremap <buffer> <F21>  <Cmd>cd %:p:h<CR><Cmd>make    test<CR>

if expand('%:p') =~ 'kyopro'
    nnoremap <buffer> <S-F5> <Cmd>cd %:p:h<CR><Cmd>make build   --bin  %:t<Cmd>r<CR>
    nnoremap <buffer> <F9>   <Cmd>cd %:p:h<CR><Cmd>make atcoder submit %:t<Cmd>r<CR>
endif

iab <buffer> arr =>

set foldmethod=indent
