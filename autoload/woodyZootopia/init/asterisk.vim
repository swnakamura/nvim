function! woodyZootopia#init#asterisk#add() abort
    map *   <Plug>(asterisk-*)
    map #   <Plug>(asterisk-#)
    map g*  <Plug>(asterisk-g*)
    map g#  <Plug>(asterisk-g#)
    map z*  <Plug>(asterisk-z*)
    map gz* <Plug>(asterisk-gz*)
    map z#  <Plug>(asterisk-z#)
    map gz# <Plug>(asterisk-gz#)
    let g:asterisk#keeppos = 1
endfunction
