" unset `` enclosure
call lexima#add_rule({'char': '`',    'filetype':    ['latex','tex']})

" unset " closure
call lexima#add_rule({'char': '"',    'filetype':    ['vim']})

call lexima#add_rule({'char': '<',    'input_after': '>',       'filetype':    ['satysfi']})
call lexima#add_rule({'char': '<BS>', 'at':          '<\%#>',   'delete':      1,    'filetype':    ['satysfi']})
call lexima#add_rule({'char': '<',    'at':          '''\%#''', 'delete': 1, 'input': '<', 'filetype': ['satysfi']})
" WIP
" call lexima#add_rule({'char': "|", 'at': '(\%#)', 'input_after': '|', 'filetype': ['satysfi']})
