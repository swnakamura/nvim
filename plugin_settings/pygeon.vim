function!  s:defx_my_settings() abort
    " Define mappings
    nnoremap <silent><buffer><expr> <CR> pygeon#open_mail()
endfunction
autocmd FileType pygeon call s:defx_my_settings()
