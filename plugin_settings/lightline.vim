if g:dark_colorscheme
    let g:lightline = {
                \ 'colorscheme': 'wombat',
                \}
else
    let g:lightline = {
                \ 'colorscheme': 'solarized',
                \}
endif
let g:lightline.subseparator = { 'left': '', 'right': '' }
