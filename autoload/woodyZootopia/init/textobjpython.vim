function! woodyZootopia#init#textobjpython#add() abort
    call textobj#user#map('python', {
          \   'class': {
          \     'select-a': '<buffer>ax',
          \     'select-i': '<buffer>ix',
          \     'move-n': '<buffer>]x',
          \     'move-p': '<buffer>[x',
          \   },
          \   'function': {
          \     'select-a': '<buffer>af',
          \     'select-i': '<buffer>if',
          \     'move-n': '<buffer>]f',
          \     'move-p': '<buffer>[f',
          \   }
          \ })
endfunction
