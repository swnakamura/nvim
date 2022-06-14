nnoremap <silent><expr> <F2> <SID>fcitx_toggle()
inoremap <silent><expr> <F2> <SID>fcitx_toggle()

augroup fcitx_autoenable
    autocmd!
    autocmd InsertEnter * if get(b:, 'fcitx_autoenable', '0') | call s:enable() | endif
    autocmd InsertLeave * call s:disable()
    " autocmd FileType markdown,pixiv nnoremap <buffer><silent><expr> <F2> <SID>fcitx_toggle()
augroup END

function! s:fcitx_toggle() abort
  let b:fcitx_autoenable = !get(b:, 'fcitx_autoenable', '0')
  if b:fcitx_autoenable ==# 1
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
