let g:fcitx_autoenable=1
" set iminsert=2
" set imsearch=2
" set imcmdline
" set imactivatefunc=ImActivate

nnoremap <silent><expr> <F2> <SID>fcitx_toggle()

augroup fcitx_autoenable
    autocmd!
    autocmd InsertEnter * if g:fcitx_autoenable | call s:enable() | endif
    autocmd InsertLeave * call s:disable()
    " autocmd FileType markdown,pixiv nnoremap <buffer><silent><expr> <F2> <SID>fcitx_toggle()
augroup END

function! s:fcitx_toggle() abort
  let g:fcitx_autoenable = g:fcitx_autoenable == 1 ? 0 : 1
  if g:fcitx_autoenable ==# 1
    echomsg '日本語入力モードON'
  else
    echomsg '日本語入力モードOFF'
  endif
endfunction

function! s:enable() abort
    if index(['markdown', 'pixiv', 'html'], &filetype) != -1 "if filetype is one of these...
        call system('fcitx-remote -o')
    endif
endfunction

function! s:disable() abort
    call system('fcitx-remote -c')
endfunction
