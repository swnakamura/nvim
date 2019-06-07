"gitgutter
nmap <Leader>hs <Plug>GitGutterStageHunk
nmap <Leader>hu <Plug>GitGutterUndoHunk
nmap <Leader>hp <Plug>GitGutterPreviewHunk
nmap ]c         <Plug>GitGutterNextHunk
nmap [c         <Plug>GitGutterPrevHunk
omap ic         <Plug>GitGutterTextObjectInnerPending
omap ac         <Plug>GitGutterTextObjectOuterPending
xmap ic         <Plug>GitGutterTextObjectInnerVisual
xmap ac         <Plug>GitGutterTextObjectOuterVisual

" vim-fugitive
nnoremap <leader>gs :Gstatus<CR><C-w>T
nnoremap <leader>ga :Gwrite<CR>
nnoremap <leader>gc :Gcommit-v<CR>
nnoremap <leader>gb :Gblame<CR>
nnoremap <leader>gl :Git lga<CR>
nnoremap <leader>gh :tab sp<CR>:0Gllog<CR> " abbrev for git history: create new quickfix tab for history
nnoremap <leader>gp :Gpush<CR>
nnoremap <leader>gf :Gfetch<CR>
nnoremap <leader>gd :Gvdiff<CR>
nnoremap <leader>gr :Grebase -i<CR>
nnoremap <leader>gg :Glgrep 
nnoremap <leader>gm :Gmerge 
