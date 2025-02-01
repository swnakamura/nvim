" Japanese common syntaxes

syn case ignore

syn region Bracket1 start="「" end="」"
syn region Bracket2 start="『" end="』"
syn region Bracket3 start="（" end="）"
syn match BracketContent "[^「（『」）』]" containedin=Bracket1,Bracket2,Bracket3 contained

syn match Ruby "\v\[\[rb:[^>]+>[^\]]+\]\]"
syn match RubyParent "\v:\zs[^>]+" containedin=Ruby contained nextgroup=RubyChild
syn match RubyChild ">\v\zs[^\]]+" containedin=Ruby contained

syn match Punctuation "\v[、。！？]" contained

hi link Bracket1 Title
hi link Bracket2 Title
hi link Bracket3 Title
hi link BracketContent String
hi link Ruby Title
hi link RubyParent String
hi link RubyChild String
hi link Punctuation Special

" 校正エラー色

syn match DoublePunctuation "\v[、。]{2,}"
hi link DoublePunctuation DiffDelete

" 半角の記号を変換
syn match HankakuKagi '\v[｣｢]'
hi link HankakuKagi DiffDelete

" カンマピリオドをテンマルに変更
syn match CommaPeriod "\v[，．]"
hi link CommaPeriod DiffDelete

" 感嘆符の後に全角スペースを追加
syn match KantanhuSpace '[！？♡][^」」）』！？♡　、。…]'
hi link KantanhuSpace DiffDelete

" 濁点を半角に変更
syn match DakutenZenkaku '゛'
hi link DakutenZenkaku DiffDelete

" ダブル感嘆符を一つにまとめる
syn match DoubleExclamation '\v[！？]{2}'
hi link DoubleExclamation DiffDelete
