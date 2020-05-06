function! MyTabLine() abort
  let s = ' '
  for i in range(tabpagenr('$'))

    " タブページ番号の設定 (マウスクリック用)
    let s .= '%' . (i + 1) . 'T'

    " 強調表示グループの選択
    if i + 1 == tabpagenr()
      let s .= '%#TabLineSel#'
    else
      let s .= '%#TabLine#'
    endif

    " number of window
    if tabpagewinnr(i + 1, '$') > 1
        let s .= "%#Title#"
        let s .= tabpagewinnr(i + 1, '$')
    endif

    " whether one of them is updated
    for bufnr in tabpagebuflist(i + 1)
        if getbufvar(bufnr,"&modified")
            let s .= "%#Title#"
            let s .= '+'
            break
        endif
    endfor

    let s .= "%#TablineFill#"

    " 強調表示グループの選択
    if i + 1 == tabpagenr()
      let s .= '%#TabLineSel#'
    else
      let s .= '%#TabLine#'
    endif

    " ラベルは MyTabLabel() で作成する
    let s .= MyTabLabel(i + 1)

    " blank
    let s .= " "

  endfor

  " 最後のタブページの後は TabLineFill で埋め、タブページ番号をリセッ
  " トする
  let s .= '%#TabLineFill#%T'

  " カレントタブページを閉じるボタンのラベルを右添えで作成
  let s .= '%=%#TabLine#'

  return s
endfunction

function! MyTabLabel(n) abort
  let buflist = tabpagebuflist(a:n)
  let winnr = tabpagewinnr(a:n)
  let fname = pathshorten(fnamemodify(bufname(buflist[winnr - 1]),":~"))
  return fname
endfunction



set tabline=%!MyTabLine()
" set tabline=
