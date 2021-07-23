let g:eskk_autoenable=1
" set iminsert=2
" set imsearch=2
" set imcmdline
" set imactivatefunc=ImActivate

nnoremap <silent><expr> <F2> <SID>markdown_eskk_toggle()

augroup eskk_autoenable
    autocmd!
    autocmd InsertEnter *.md,*.pxv,*.ltx if g:eskk_autoenable | call s:enable() | endif
    autocmd InsertLeave *.md,*.pxv,*.ltx call s:disable()
    " autocmd FileType markdown,pixiv nnoremap <buffer><silent><expr> <F2> <SID>markdown_eskk_toggle()
augroup END

function! s:markdown_eskk_toggle() abort
  let g:eskk_autoenable = g:eskk_autoenable == 1 ? 0 : 1
  if g:eskk_autoenable ==# 1
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
