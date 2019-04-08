"gitgutter
nmap ]h         <Plug>GitGutterNextHunk
nmap [h         <Plug>GitGutterPrevHunk
nmap <Leader>ha <Plug>GitGutterStageHunk
nmap <Leader>hr <Plug>GitGutterUndoHunk
nmap <Leader>hv <Plug>GitGutterPreviewHunk
omap ih         <Plug>GitGutterTextObjectInnerPending
omap ah         <Plug>GitGutterTextObjectOuterPending
xmap ih         <Plug>GitGutterTextObjectInnerVisual
xmap ah         <Plug>GitGutterTextObjectOuterVisual

" vim-fugitive
nnoremap <leader>gs :tab sp<CR>:Gstatus<CR>:unmap<buffer> s<CR><C-w>_<C-w>\|
nnoremap <leader>ga :Gwrite<CR>
nnoremap <leader>gc :Gcommit<CR>
nnoremap <leader>gb :Gblame<CR>
nnoremap <leader>gl :Git lga<CR>
" abbrev for git history: create new quickfix tab for history
nnoremap <leader>gh :tab sp<CR>:0Glog<CR>
nnoremap <leader>gp :Gpush<CR>
nnoremap <leader>gf :Gfetch<CR>
nnoremap <leader>gd :Gvdiff<CR>
nnoremap <leader>gr :Grebase -i
