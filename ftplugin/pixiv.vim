" let &colorcolumn=join(range(76,999),",")
" highlight ColorColumn ctermbg=235 guibg=#2c2d27

noremap <buffer> <F5> :NovelPreviewStartServer<CR>

if !exists(':NovelPreviewSend')
    command! NovelPreviewSend echo ''
endif
augroup pixivPreview
    autocmd!
    autocmd BufWrite,CursorMoved,TextChangedI *.pxv,*.as NovelPreviewSend
    autocmd TextChanged,TextChangedI *.pxv,*.as call UpdateEditDistance()
    autocmd BufWritePre *.pxv,*.as NovelFormatterF
augroup END
