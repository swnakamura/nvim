  let g:deoplete#enable_at_startup = 1

  inoremap <expr><tab> pumvisible() ? "\<C-n>" : "\<tab>"

  " Expand the completed snippet trigger by <CR>.
  " trial 1
  imap <expr> <CR>
  \ (pumvisible() && neosnippet#expandable()) ?
  \ "\<Plug>(neosnippet_expand)" : "<C-r>=<SID>my_cr_function()<CR>"
  "
  " trial 2
  " imap <expr> <CR> "<C-r>=<SID>my_cr_function()<CR>"
  "
  " my function
  function! s:my_cr_function() abort
    return deoplete#close_popup() . lexima#expand('<CR>','i')
  endfunction

let g:deoplete#auto_complete_delay = 0
let g:deoplete#enable_camel_case = 0
let g:deoplete#enable_ignore_case = 0
let g:deoplete#enable_refresh_always = 0
let g:deoplete#enable_smart_case = 1
let g:deoplete#file#enable_buffer_path = 1
let g:deoplete#auto_complete_start_length = 1
let g:deoplete#max_list = 100

" limit only to deoplete-zsh when in deol buffer
call deoplete#custom#option('sources', {  'zsh': ['zsh'], })
