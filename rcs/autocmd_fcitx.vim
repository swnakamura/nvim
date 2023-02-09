nnoremap <silent><expr> <F2> <SID>fcitx_toggle()
inoremap <silent><expr> <F2> <SID>fcitx_toggle()
nnoremap <silent> <Plug>(my-switch)j :call <SID>toggle_fcitx_toggling()<CR>
nnoremap <silent> <Plug>(my-switch)<C-j> :call <SID>toggle_fcitx_toggling()<CR>

let g:is_fcitx_toggling_enabled = v:false
function! s:toggle_fcitx_toggling() abort
  if g:is_fcitx_toggling_enabled
    let g:is_fcitx_toggling_enabled=v:false
    augroup fcitx_autoenable
      autocmd!
    augroup END
    echomsg 'Fcitx toggling disabled'
  else
    let g:is_fcitx_toggling_enabled=v:true
    augroup fcitx_autoenable
      autocmd!
      autocmd InsertEnter * if get(b:, 'fcitx_autoenable', '0') | call s:enable() | endif
      autocmd CmdLineEnter /,\? if get(b:, 'fcitx_autoenable', '0') | call s:enable() | endif
      autocmd InsertLeave * call s:disable()
      autocmd CmdlineLeave /,\? call s:disable()
      " autocmd FileType markdown,pixiv nnoremap <buffer><silent><expr> <F2> <SID>fcitx_toggle()
    augroup END
    echomsg 'Fcitx toggling enabled'
  endif
endfunction

function! s:fcitx_toggle() abort
  let b:fcitx_autoenable = !get(b:, 'fcitx_autoenable', '0')
  if b:fcitx_autoenable ==# 1
    if !g:is_fcitx_toggling_enabled
      call <SID>toggle_fcitx_toggling()
    endif
    echomsg '日本語入力モードON'
    if index(['i'], mode()) != -1
      call s:enable()
    endif
  else
    echo '日本語入力モードOFF'
    if index(['i'], mode()) != -1
      call s:disable()
    endif
  endif
  return ''
endfunction

function! s:enable() abort
  call system('fcitx5-remote -o')
endfunction

function! s:disable() abort
  call system('fcitx5-remote -c')
endfunction
