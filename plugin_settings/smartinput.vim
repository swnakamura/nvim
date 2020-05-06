" call smartinput#define_rule({
" \   'at': '\s\+\%#',
" \   'char': '<CR>',
" \   'input': "<C-o>:call setline('.', substitute(getline('.'), '\\s\\+$', '', ''))<CR><CR>",
" \   })

