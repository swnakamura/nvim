let g:fcitx_autoenable=1
" set iminsert=2
" set imsearch=2
" set imcmdline
" set imactivatefunc=ImActivate

nnoremap <silent><expr> <F2> <SID>fcitx_toggle()

augroup fcitx_autoenable
    autocmd!
    autocmd InsertEnter *.md,*.pxv,*.ltx if g:fcitx_autoenable | call s:enable() | endif
    autocmd InsertLeave *.md,*.pxv,*.ltx call s:disable()
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
    call system('fcitx-remote -o')
endfunction

function! s:disable() abort
    call system('fcitx-remote -c')
endfunction
