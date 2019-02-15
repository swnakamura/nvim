"gitgutter
nmap     ]h         <Plug>GitGutterNextHunk
nmap     [h         <Plug>GitGutterPrevHunk
nmap     <Leader>ha <Plug>GitGutterStageHunk
nmap     <Leader>hr <Plug>GitGutterUndoHunk
nmap     <Leader>hv <Plug>GitGutterPreviewHunk
omap     ih         <Plug>GitGutterTextObjectInnerPending
omap     ah         <Plug>GitGutterTextObjectOuterPending
xmap     ih         <Plug>GitGutterTextObjectInnerVisual
xmap     ah         <Plug>GitGutterTextObjectOuterVisual

nnoremap <leader>gs :Gstatus<CR>
nnoremap <leader>ga :Gwrite<CR>
nnoremap <leader>gc :Gcommit<CR>
nnoremap <leader>gb :Gblame<CR>
nnoremap <leader>gl :Git lga<CR>
nnoremap <leader>gp :Gpush<CR>
nnoremap <leader>gf :Gfetch<CR>
nnoremap <leader>gd :Gdiff<CR>
