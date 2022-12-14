augroup file-type
  au!
  au BufNewFile,BufRead *.cls                            setf tex
  au BufNewFile,BufRead *.jl                             setf julia
  au BufNewFile,BufRead *.elm                            setf elm
  au BufNewFile,BufRead *.ipynb                          setf python
  au BufNewFile,BufRead *.re                             setf review
  au BufNewFile,BufRead *.log                            setf log
  au FileType           python,c,cpp                     setlocal foldmethod=indent
  au FileType           go                               setlocal tabstop=4 shiftwidth=4 noexpandtab formatoptions+=r
  au FileType           vim                              setlocal tabstop=2 shiftwidth=2
  au FileType           tex                              let b:lexima_disabled = 1
  au FileType           html,csv,tsv                     setlocal nowrap
  au FileType           text,mail,markdown,help          setlocal noet spell
  au FileType           gitcommit                        setlocal spell
  " テキストについて-もkeywordとする
  au FileType           text,tex,markdown,gitcommit,help setlocal isk+=-
  au FileType           log                              setlocal nowrap

  " 長い行がありそうな拡張子なら構文解析を途中でやめる
  au FileType           csv,tsv,json                setlocal synmaxcol=256
augroup END

function! Preserve(command)
  let l:curw = winsaveview()
  execute a:command
  call winrestview(l:curw)
endfunction
function! Autopep8()
  call Preserve(':silent %!autopep8 -')
endfunction
augroup formatter
  autocmd!
  autocmd BufWritePre *.py call Autopep8()
augroup END

" 検索中の領域をハイライトする
" ヘルプドキュメント('incsearch')からコピーした
augroup vimrc-incsearch-highlight
  au!
  au CmdlineEnter /,\? :set hlsearch
  au CmdlineLeave /,\? :set nohlsearch
augroup END

" 選択した領域を自動でハイライトする
if !exists("g:vscode")
  augroup instant-visual-highlight
    au!
    autocmd ColorScheme * hi SearchWordMatch gui=reverse
    autocmd CursorMoved,CursorHold * call Visualmatch()
  augroup END
endif

function! Visualmatch()
  if exists("w:visual_match_id")
    call matchdelete(w:visual_match_id)
    unlet w:visual_match_id
  endif
  if index(['v', "\<C-v>"], mode()) != -1 && line('v') == line('.')
    let len_of_char_at_v   = strlen(matchstr(getline('v'), '.', col('v')-1))
    let len_of_char_at_dot = strlen(matchstr(getline('.'), '.', col('.')-1))
    let selected_column_idx = {
          \'first': min([
          \col('v')-1,
          \col('.')-1
          \]),
          \'last' : max([
          \col('v')-2+len_of_char_at_v,
          \col('.')-2+len_of_char_at_dot
          \])
          \}
    if mode() == 'v'
      let w:visual_match_id = matchadd('SearchWordMatch',
            \'\V' .. escape(getline('.')[selected_column_idx['first']:selected_column_idx['last']], '\'))
    else
      let w:visual_match_id = matchadd('SearchWordMatch',
            \'\V\<' .. escape(getline('.')[selected_column_idx['first']:selected_column_idx['last']], '\') .. '\>')
    endif
  endif
endfunction

" 単語を自動でハイライトする
augroup cursor-word-highlight
  au!
  autocmd ColorScheme * hi CursorWord guibg=#282d44
  autocmd CursorHold * call Wordmatch()
  autocmd InsertEnter * call DelWordmatch()
augroup END

function! Wordmatch()
  if &ft=='fern'
    return
  endif
  call DelWordmatch()

  let w:cursorword = expand('<cword>')->escape('\')
  if w:cursorword != ''
    let w:wordmatch_id =  matchadd('CursorWord','\V\<' .. w:cursorword .. '\>')
  endif

  " if exists('w:wordmatch_tid')
  "     call timer_stop(w:wordmatch_tid)
  "     unlet w:wordmatch_tid
  " endif
  " let w:wordmatch_tid = timer_start(200, 'DelWordmatch')
endfunction

function! DelWordmatch(...)
  if exists('w:wordmatch_id')
    call matchdelete(w:wordmatch_id)
    unlet w:wordmatch_id
  endif
endfunction

augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave,WinEnter * if &nu && mode() != "i" | set rnu   | endif
  autocmd BufLeave,FocusLost,InsertEnter,WinLeave   * if &nu                  | set nornu | endif
augroup END

augroup if-binary-then-xxd
  au!
  au BufReadPre *.bin     let b:bin_xxd=1
  au BufReadPre *.img     let b:bin_xxd=1
  au BufReadPre *.sys     let b:bin_xxd=1
  au BufReadPre *.torrent let b:bin_xxd=1
  au BufReadPre *.out     let b:bin_xxd=1
  au BufReadPre *.a       let b:bin_xxd=1

  au BufReadPost * if exists('b:bin_xxd') | %!xxd 
  au BufReadPost * setlocal ft=xxd | endif

  au BufWritePre * if exists('b:bin_xxd') | %!xxd -r 
  au BufWritePre * endif

  au BufWritePost * if exists('b:bin_xxd') | %!xxd 
  au BufWritePost * set nomod | endif
augroup END

augroup csv-tsv
  au!
  au BufReadPost,BufWritePost *.csv %!column -s, -o, -t
  au BufWritePre              *.csv %s/\s\+\ze,/,/ge
  au BufReadPost,BufWritePost *.tsv %!column -s "$(printf '\t')" -o "$(printf '\t')" -t
  au BufWritePre              *.tsv %s/ \+\ze	//ge
augroup END

fu! s:isdir(dir) abort
  return !empty(a:dir) && (isdirectory(a:dir) ||
        \ (!empty($SYSTEMDRIVE) && isdirectory('/'.tolower($SYSTEMDRIVE[0]).a:dir)))
endfu


augroup jupyter-notebook
  au!
  au BufReadPost *.ipynb %!jupytext --from ipynb --to py:percent
  au BufWritePre *.ipynb let g:jupyter_previous_location = getpos('.')
  au BufWritePre *.ipynb %!jupytext --from py:percent --to ipynb
  au BufWritePost *.ipynb %!jupytext --from ipynb --to py:percent 
  au BufWritePost *.ipynb if exists('g:jupyter_previous_location') | call setpos('.', g:jupyter_previous_location) | endif
augroup END

augroup lua-highlight
  autocmd!
  autocmd TextYankPost * silent! lua vim.highlight.on_yank({higroup='Pmenu', timeout=200})
augroup END
