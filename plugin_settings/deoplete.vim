let g:deoplete#enable_at_startup = 1

" imap <expr><tab> pumvisible() ? "\<C-n>" : "\<tab>"

" Expand the completed snippet trigger by <CR>.
" trial 1
" imap <expr> <CR>
" \ (pumvisible() && neosnippet#expandable()) ?
" \ "\<Plug>(neosnippet_expand)" : "<C-r>=<SID>my_cr_function()<CR>"
"
" trial 2
inoremap <silent> <expr> <CR> "<C-r>=deoplete#close_popup()<CR><CR>"

call deoplete#custom#option({
            \'camel_case': v:true,
            \'auto_complete_delay': 0,
            \'smart_case': v:true,
            \'refresh_always': v:false,
            \'buffer_path': v:true,
            \'min_pattern_length': 1,
            \'max_list': 100,
            \})

" limit only to deoplete-zsh when in deol buffer
call deoplete#custom#option('sources', {  'zsh': ['zsh'], })

