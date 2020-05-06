if g:dark_transparent
    let g:lightline = {
                \ 'colorscheme': 'wombat',
                \}
else
    let g:lightline = {
                \ 'colorscheme': 'solarized',
                \}
endif
let g:lightline.subseparator = { 'left': '', 'right': '' }
