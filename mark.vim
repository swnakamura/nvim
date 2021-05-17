" A miniature plugin to ease the use of mark feature.
" Copied from http://saihoooooooo.hatenablog.com/entry/2013/04/30/001908 and
" slightly modified

" マーク設定 : {{{

let g:markrement_char = get(g:, 'markrement_char', [
\     'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm',
\     'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z'
\ ])
function! s:AutoMarkrement()
    if !exists('b:markrement_pos')
        let b:markrement_pos = 0
    else
        let b:markrement_pos = (b:markrement_pos + 1) % len(g:markrement_char)
    endif
    execute 'mark' g:markrement_char[b:markrement_pos]
    echo 'marked' g:markrement_char[b:markrement_pos]
endfunction

" マークする
nnoremap <silent>m :<C-u>call <SID>AutoMarkrement()<CR>

" 次/前のマーク
nnoremap ]k ]`
nnoremap [k [`

" 一覧表示
" nnoremap ml :<C-u>marks<CR>

augroup markMove
    autocmd!
    " 前回終了位置に移動
    autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line('$') | exe 'normal g`"' | endif
    " バッファ読み込み時にマークを初期化
    autocmd BufReadPost * delmarks!
augroup END

" }}}
