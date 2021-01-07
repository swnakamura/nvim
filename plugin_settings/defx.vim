call defx#custom#column('indent',{'indent': "-"})
" call defx#custom#column('mark', {
"             \ 'readonly_icon': '✗',
"             \ 'selected_icon': '✓',
"             \ })
" call defx#custom#column('icon', {
"             \ 'directory_icon': '',
"             \ 'opened_icon': '',
"             \ 'root_icon': '',
"             \ })
nnoremap <silent> st        :Defx -new -auto-cd -columns=time:size:indent:icons:filename -show-ignored-files `expand('%:p:h')` -search=`expand('%:p')` -split=tab        <CR>
nnoremap <silent> <leader>d :Defx -new -auto-cd -columns=time:size:indent:icons:filename -show-ignored-files `expand('%:p:h')` -search=`expand('%:p')` -split=no         <CR>
nnoremap <silent> <leader>n :Defx -new -auto-cd -columns=time:size:indent:icons:filename -show-ignored-files `expand('%:p:h')` -search=`expand('%:p')` -split=vertical -winwidth=40 <CR>
nnoremap <silent> <leader>z :Defx -new -auto-cd -columns=size:indent:filename:time      -show-ignored-files `expand('%:p:h')` -search=`expand('%:p')` -split=floating <CR>
" seldom used
" nnoremap <silent> <leader>dv :Defx -new -auto-cd -columns=size:mark:filename:time -show-ignored-files `expand('%:p:h')` -search=`expand('%:p')` -split=vertical -winwidth=50<CR>:IndentLinesDisable<CR>

autocmd FileType defx call s:defx_my_settings()
function!  s:defx_my_settings() abort
    " Define mappings
    nnoremap <silent><buffer><expr> <CR>          defx#do_action('open')
    nnoremap <silent><buffer><expr> o             defx#is_directory()?defx#do_action('open_or_close_tree'):defx#do_action('drop')
    nnoremap <silent><buffer><expr> O             defx#is_directory()?defx#do_action('open_tree_recursive'):defx#do_action('drop','tabnew')
    nnoremap <silent><buffer><expr> <2-LeftMouse> defx#do_action('open')
    nnoremap <silent><buffer><expr> l             defx#do_action('open_directory')
    nnoremap <silent><buffer><expr> K             defx#do_action('new_directory')
    nnoremap <silent><buffer><expr> L             defx#do_action('new_file')
    nnoremap <silent><buffer><expr> h             defx#do_action('cd',['..'])
    nnoremap <silent><buffer><expr> d             defx#do_action('remove',['..'])
    nnoremap <silent><buffer><expr> r             defx#do_action('rename',['..'])
    nnoremap <silent><buffer><expr> ~             defx#do_action('cd')
    nnoremap <silent><buffer><expr> v             defx#do_action('toggle_select').'j'
    nnoremap <silent><buffer><expr> R             defx#do_action('redraw')
    nnoremap <silent><buffer><expr> yy            defx#do_action('yank_path')
    nnoremap <silent><buffer><expr> !             defx#do_action('execute_command')
    nnoremap <silent><buffer><expr> i             defx#do_action('execute_command')
    nnoremap <silent><buffer><expr> x             defx#do_action('execute_system')
    nnoremap <silent><buffer><expr> .             defx#do_action('toggle_ignored_files')
    nnoremap <silent><buffer><expr> c             defx#do_action('copy')
    nnoremap <silent><buffer><expr> P             defx#do_action('paste')
    nnoremap <silent><buffer><expr> Se            defx#do_action('toggle_sort', 'extension')
    nnoremap <silent><buffer><expr> Sn            defx#do_action('toggle_sort', 'filename')
    nnoremap <silent><buffer><expr> Ss            defx#do_action('toggle_sort', 'size')
    nnoremap <silent><buffer><expr> St            defx#do_action('toggle_sort', 'time')
    nnoremap <buffer>               <leader>gd    :call                         <SID>git_diff_of_directory()<CR>
endfunction

function! s:drop_and_back()
    call defx#do_action('open')
    " exe "normal \<C-w>h"
endfunction

function! s:git_diff_of_directory()
    exe "tabnew"
    exe "read !git diff"
    exe "setf diff"
    exe "setlocal buftype=nofile"
    exe "setlocal bufhidden=hide"
    exe "setlocal noswapfile"
endfunction
