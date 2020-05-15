" " ctags+tagbar settings.
" " Universal Ctags required.
let g:rust_use_custom_ctags_defs = 1  " if using rust.vim
let g:tagbar_type_rust = {
  \ 'ctagsbin' : '/usr/local/bin/ctags',
  \ 'ctagstype' : 'rust',
  \ 'kinds' : [
      \ 'n:modules',
      \ 's:structures:1',
      \ 'i:interfaces',
      \ 'c:implementations',
      \ 'f:functions:1',
      \ 'g:enumerations:1',
      \ 't:type aliases:1:0',
      \ 'v:constants:1:0',
      \ 'M:macros:1',
      \ 'm:fields:1:0',
      \ 'e:enum variants:1:0',
      \ 'P:methods:1',
  \ ],
  \ 'sro': '::',
  \ 'kind2scope' : {
      \ 'n': 'module',
      \ 's': 'struct',
      \ 'i': 'interface',
      \ 'c': 'implementation',
      \ 'f': 'function',
      \ 'g': 'enum',
      \ 't': 'typedef',
      \ 'v': 'variable',
      \ 'M': 'macro',
      \ 'm': 'field',
      \ 'e': 'enumerator',
      \ 'P': 'method',
  \ },
\ }

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
