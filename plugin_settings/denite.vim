" nnoremap <silent> <space>fr  <Cmd>Denite -split=floating -start-filter file_mru<CR>
" nnoremap <silent> <space>fb  <Cmd>Denite -split=floating -start-filter buffer<CR>
" nnoremap <silent> <space>fy  <Cmd>Denite -split=floating -start-filter neoyank<CR>
" nnoremap <silent> <space>ff  <Cmd>Denite -split=floating -start-filter file/rec<CR>
" nnoremap <silent> <space>fd  <Cmd>Denite -split=floating -start-filter defx/history<CR>
" nnoremap <silent> <space>fu  <Cmd>Denite -split=floating -start-filter outline<CR>
" nnoremap <silent> <space>fc  <Cmd>Denite -split=floating -start-filter command_history<CR>
" nnoremap <silent> <space>fo  <Cmd>Denite -split=floating -start-filter output:
" nnoremap <silent> <space>fgl <Cmd>Denite -split=floating -start-filter gitlog<CR>
" nnoremap <silent> <space>fgs <Cmd>Denite -split=floating -start-filter gitstatus<CR>
" nnoremap <silent> <space>fgc <Cmd>Denite -split=floating -start-filter gitchanged<CR>
" nnoremap <silent> <space>fgb <Cmd>Denite -split=floating -start-filter gitbranch<CR>

" Define mappings
autocmd FileType denite call s:denite_my_settings()

function! s:denite_my_settings() abort
  nnoremap <silent><buffer><expr> <CR>
  \ denite#do_map('do_action')
  nnoremap <silent><buffer><expr> <C-j>
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
