nnoremap <silent> <space>fr :<C-u>Denite file_mru -split="floating"<CR>
nnoremap <silent> <space>fb :<C-u>Denite buffer -split="floating"<CR>
nnoremap <silent> <space>fy :<C-u>Denite neoyank -split="floating"<CR>
nnoremap <silent> <space>ff :<C-u>Denite file/rec -split="floating"<CR>
nnoremap <silent> <space>fd :<C-u>Denite defx/history -split="floating"<CR>
nnoremap <silent> <space>fu :<C-u>Denite outline<CR>
nnoremap <silent> <space>fo :<C-u>Denite output:
nnoremap <silent> <space>fgl :<C-u>Denite gitlog<CR>
nnoremap <silent> <space>fgs :<C-u>Denite gitstatus<CR>
nnoremap <silent> <space>fgc :<C-u>Denite gitchanged<CR>
nnoremap <silent> <space>fgb :<C-u>Denite gitbranch<CR>

" Define mappings
autocmd FileType denite call s:denite_my_settings()

function! s:denite_my_settings() abort
  nnoremap <silent><buffer><expr> <CR>
  \ denite#do_map('do_action')
  nnoremap <silent><buffer><expr> d
  \ denite#do_map('do_action', 'delete')
  nnoremap <silent><buffer><expr> p
  \ denite#do_map('do_action', 'preview')
  nnoremap <silent><buffer><expr> q
  \ denite#do_map('quit')
  nnoremap <silent><buffer><expr> i
  \ denite#do_map('open_filter_buffer')
  nnoremap <silent><buffer><expr> v
  \ denite#do_map('toggle_select').'j'
endfunction
