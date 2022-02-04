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
  let b:fcitx_autoenable = !get(b:, 'fcitx_autoenable', '0')
  if b:fcitx_autoenable ==# 1
    echo '日本語入力モードON'
  else
    echo '日本語入力モードOFF'
  endif
  return ''
endfunction

function! s:enable() abort
    if index(['markdown', 'pixiv', 'html', 'tex'], &filetype) != -1 "if filetype is one of these...
        call system('fcitx5-remote -o')
    endif
endfunction

function! s:disable() abort
    call system('fcitx5-remote -c')
endfunction
