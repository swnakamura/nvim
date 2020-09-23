"gitgutter
let g:gitgutter_preview_win_floating = 0
nmap <Leader>hs <Plug>(GitGutterStageHunk)
nmap <Leader>ha <Plug>(GitGutterStageHunk)
nmap <Leader>hu <Plug>(GitGutterUndoHunk)
nmap <Leader>hp <Plug>(GitGutterPreviewHunk)
nmap <Leader>hv <Plug>(GitGutterPreviewHunk)
nmap ]c         <Plug>(GitGutterNextHunk)
nmap [c         <Plug>(GitGutterPrevHunk)
omap ic         <Plug>(GitGutterTextObjectInnerPending)
omap ac         <Plug>(GitGutterTextObjectOuterPending)
xmap ic         <Plug>(GitGutterTextObjectInnerVisual)
xmap ac         <Plug>(GitGutterTextObjectOuterVisual)
nmap ]h         <Plug>(GitGutterNextHunk)
nmap [h         <Plug>(GitGutterPrevHunk)
omap ih         <Plug>(GitGutterTextObjectInnerPending)
omap ah         <Plug>(GitGutterTextObjectOuterPending)
xmap ih         <Plug>(GitGutterTextObjectInnerVisual)
xmap ah         <Plug>(GitGutterTextObjectOuterVisual)

" vim-fugitive
nnoremap <leader>gs :Gstatus<CR><C-w>T
nnoremap <leader>ga :Gwrite<CR>
nnoremap <leader>gc :Gcommit-v<CR>
nnoremap <leader>gb :Gblame<CR>
nnoremap <leader>gl :tab sp<CR>:Glog<CR><C-w>j
nnoremap <leader>gh :tab sp<CR>:0Glog<CR>
" abbrev for git history: create new quickfix tab for history
nnoremap <leader>gp :Gpush<CR>
nnoremap <leader>gf :Gfetch<CR>
nnoremap <leader>gd :Gvdiff!<CR>
nnoremap <leader>gr :Grebase -i<CR>
nnoremap <leader>gg :Glgrep ""<Left>
nnoremap <leader>gm :Gmerge 
