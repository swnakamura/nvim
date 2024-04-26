setlocal conceallevel=2

command -range=% GHCopy call GHCopy(<line1>, <line2>)

function GHCopy(line1, line2) abort
  let text = getline(a:line1, a:line2)

  let text = text->filter('v:val !~ ''\[\[[^\]]*\.\(png\|jpg\)\]\]'' ') " Remove lines with internal links to image files: [[*.png]] or [[*.jpg]]

  let text = text->join("\n")

  let text = text->substitute('%%.\{-1,}%%', '' ,'ge') " Remove contents of obsidian comments

  let text = text->substitute('\$\([^$]\{-1,}\)\$','$`\1`$','ge') " Surround inline math with backticks: $inline math$ -> `$inline math$`
  let text = text->substitute(' --- ',':','ge') " Replace ' --- ' with ':'

  let text = text->substitute('#\([^# ]\+\)', '', 'ge') " remove tags e.g. #tags
  let text = text->substitute('[📅➕⏳✅] \d\d\d\d-\d\d-\d\d', '', 'ge') " remove emoji dates from obsidian-tasks
  let text = text->substitute('	','    ','ge') " Replace tabs with 4 spaces
  let text = text->substitute('[^!]\[\[\zs[^]]\+|\([^]]\+\)\ze\]\]', '\1' ,'ge') " Remove original link from aliased file name: [[original name|aliased name]] -> [[aliased name]]
  let text = text->substitute('[^!]\zs\[\[\([^]]\+\)\]\]\ze', '<strong>\1</strong>' ,'ge') " Remove double square bracket from non-image link and surround it with double star instead: [[file.md]] -> <strong>file.md</strong>
  let text = text->substitute('\n\s*\\<\([^>]\+\)>','\r<\1>','ge') " Remove preceding backslashes for html tags in the beginning of the line
  let text = text->substitute('\v\n\\(!\[[^]]+\]\([^)]+\))','\r\1','ge') " Remove preceding backslashes for image formats `![alias](path)` in the beginning of the line
  call setreg('+', text, 'V')
endfunction
