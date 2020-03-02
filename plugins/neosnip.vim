let g:neosnippet#snippets_directory=expand('~/.config/nvim/Neosnips')
imap <C-k> <Plug>(neosnippet_expand_or_jump)
smap <C-k> <Plug>(neosnippet_expand_or_jump)
xmap <C-k> <Plug>(neosnippet_expand_target)
if has('conceal')
  set conceallevel=0 concealcursor=niv
endif
