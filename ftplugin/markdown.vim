setlocal conceallevel=1

command -range=% GHCopy call GHCopy(<line1>, <line2>)

function GHCopy(line1, line2) abort
  let text_lst = getline(a:line1, a:line2)

  let text_lst = text_lst->filter('v:val !~ ''\[\[[^\]]*\.\(png\|jpg\|jpeg\)\]\]'' ') " Remove lines with internal links to image files: [[*.png]] or [[*.jpg]]

  let text = text_lst->join("\n")

  let text = text->substitute('%%.\{-1,}%%', '' ,'ge') " Remove contents of obsidian comments

  let text = text->substitute('\$\([^$]\{-1,}\)\$','$`\1`$','ge') " Surround inline math with backticks: $inline math$ -> $`inline math`$
  let text = text->substitute(' --- ',':','ge') " Replace ' --- ' with ':'

  let text = text->substitute('#\([^# ]\+\)', '', 'ge') " remove tags e.g. #tags
  let text = text->substitute('[📅➕⏳✅] \d\d\d\d-\d\d-\d\d', '', 'ge') " remove emoji dates from obsidian-tasks
  let text = text->substitute('	','    ','ge') " Replace tabs with 4 spaces
  let text = text->substitute('[^!]\[\[\zs[^]]\+|\([^]]\+\)\ze\]\]', '\1' ,'ge') " Remove original link from aliased file name: [[original name|aliased name]] -> [[aliased name]]
  " If double bracket link is followed by an http link, change the double bracket link to a markdown link
  let text = text->substitute('[^!]\zs\[\[\([^]]\+\)\]\]\s\?(\(http[^)]\+\))', '[\1](\2)' ,'ge') " Change double bracket link to markdown link: [[file.md]] <link> -> [file.md](<link>)
  let text = text->substitute('[^!]\zs\[\[\([^]]\+\)\]\]\ze', '<strong>\1</strong>' ,'ge') " Remove double square bracket from non-image link and surround it with double star instead: [[file.md]] -> <strong>file.md</strong>

  " Note that ^ cannot be used in the following regexes because the text is already merged into one line
  let text = text->substitute('\n\s*\\<\([^>]\+\)>','\n<\1>','ge') " Remove preceding backslashes for html tags in the beginning of the line
  let text = text->substitute('\v\n\\(!\[[^]]+\]\([^)]+\))','\n\1','ge') " Remove preceding backslashes for image formats `![alias](path)` in the beginning of the line
  " Make a newline after bullet lists.
  " Note that we cannot use \s as the regular expression. We also have to use
  " \n as the replacement string to make a newline.
  let text = text->substitute('- [^\n]*\n\zs\ze[^\(\( 	\)*-\)\n]', '\n', 'ge')
  " Here, '[^\(\( 	\)*-\)\n]' means:
  " From this line new text starts, and it's not
  " 1. there's already newline
  " 2. There's another bullet list in this line
  call setreg('+', text, 'V')
endfunction


" Copy markdown text and convert it to plain text
function PlainTextCopy(line1, line2) abort
  let text_lst = getline(a:line1, a:line2)

  let text_lst = text_lst->filter('v:val !~ ''\[\[[^\]]*\.\(png\|jpg\|jpeg\)\]\]'' ') " Remove lines with internal links to image files: [[*.png]] or [[*.jpg]]

  let text = text_lst->join("\n")

  let text = text->substitute('%%.\{-1,}%%', '' ,'ge') " Remove contents of obsidian comments

  let text = text->substitute('\$\([^$]\{-1,}\)\$','\1','ge') " Surround inline math with backticks: $inline math$ -> inline math
  let text = text->substitute(' --- ',':','ge') " Replace ' --- ' with ':'

  let text = text->substitute('#\([^# ]\+\)', '', 'ge') " remove tags e.g. #tags
  let text = text->substitute('[📅➕⏳✅] \d\d\d\d-\d\d-\d\d', '', 'ge') " remove emoji dates from obsidian-tasks
  let text = text->substitute('	','    ','ge') " Replace tabs with 4 spaces
  let text = text->substitute('[^!]\[\[\zs[^]]\+|\([^]]\+\)\ze\]\]', '\1' ,'ge') " Remove original link from aliased file name: [[original name|aliased name]] -> [[aliased name]]
  " If double bracket link is followed by an http link, change the double bracket link to a markdown link
  let text = text->substitute('[^!]\zs\[\[\([^]]\+\)\]\]\s\?(\(http[^)]\+\))', '[\1](\2)' ,'ge') " Change double bracket link to markdown link: [[file.md]] <link> -> [file.md](<link>)
  let text = text->substitute('[^!]\zs\[\[\([^]]\+\)\]\]\ze', '\1' ,'ge') " Remove double square bracket from non-image link : [[file.md]] -> file.md

  " Remove any text decorations
  let text = text->substitute('\*\([^*]\+\)\*','\1','ge') " Remove bold text: *bold text* -> bold text
  let text = text->substitute('\*\*\([^*]\+\)\*\*','\1','ge') " Remove bold text: **bold text** -> bold text

  " Note that ^ cannot be used in the following regexes because the text is already merged into one line
  let text = text->substitute('\n\s*\\<\([^>]\+\)>','\n<\1>','ge') " Remove preceding backslashes for html tags in the beginning of the line
  let text = text->substitute('\v\n\\(!\[[^]]+\]\([^)]+\))','\n\1','ge') " Remove preceding backslashes for image formats `![alias](path)` in the beginning of the line

  " Change a markdown bullet to more fancy ones
  let text = text->substitute('\n\s*\zs- \[ \]\ze\s\+', '☐', 'ge')
  let text = text->substitute('\n\s*\zs- \[x\]\ze\s\+', '☑', 'ge')
  let text = text->substitute('\n\s*\zs-\ze\s\+', '• ', 'ge')

  call setreg('+', text, 'V')
endfunction

