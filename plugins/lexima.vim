call lexima#add_rule({'char': '$', 'input_after': '$', 'filetype': ['latex','tex','markdown']})
call lexima#add_rule({'char': '$', 'at': '\%#\$', 'input_after': '$', 'filetype': ['latex','tex','markdown']})
call lexima#add_rule({'char': '<BS>', 'at': '\$\%#\$', 'delete': 1, 'filetype': ['latex','tex']})

call lexima#add_rule({'char': '(', 'at': '\\\%#', 'input_after': '\)', 'filetype': ['latex','tex']})
call lexima#add_rule({'char': '[', 'at': '\\\%#', 'input_after': '\]', 'filetype': ['latex','tex']})
call lexima#add_rule({'char': '[', 'at': '\\\%#', 'input_after': '\]', 'filetype': ['latex','tex']})
call lexima#add_rule({'char': '`', 'filetype':['latex','tex']})

call lexima#add_rule({'char': '<', 'input_after': '>', 'filetype': ['satysfi']})
" call lexima#add_rule({'char': '<', 'at': "'\%#'", 'delete': 1, 'input_after': '>', 'filetype': ['satysfi']})
" call lexima#add_rule({'char': '|', 'at': '(\%#', 'input_after': '|', 'filetype': ['satysfi']})
