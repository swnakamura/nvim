call lexima#add_rule({'char': '$', 'input_after': '$', 'filetype': ['latex','tex']})
call lexima#add_rule({'char': '$', 'at': '\%#\$', 'input_after': '$', 'filetype': ['latex','tex']})
call lexima#add_rule({'char': '<BS>', 'at': '\$\%#\$', 'delete': 1, 'filetype': ['latex','tex']})

call lexima#add_rule({'char': '(', 'at': '\\\%#', 'input_after': '\)', 'filetype': ['latex','tex']})
call lexima#add_rule({'char': '[', 'at': '\\\%#', 'input_after': '\]', 'filetype': ['latex','tex']})
