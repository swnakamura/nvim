setlocal conceallevel=0

command -range=% GHCopy call GHCopy(<line1>, <line2>)

function GHCopy(line1, line2) abort
  let text = getline(a:line1, a:line2)->join("\n")

  let text = text->substitute('\$\([^$]\{-1,}\)\$','$`\1`$','ge')
  let text = text->substitute(' --- ',':','ge')
  let text = text->substitute('	','    ','ge')
  let text = text->substitute('!\[\[[^]]\+\]\]\n*\ze\s*!\[.\{-\}\](', '' ,'ge') " Remove obsidian internal links: ![[imagefile]], if it's followed by another link: ![imagename](URL).
  let text = text->substitute('[^!]\zs\[\[\([^]]\+\)\]\]\ze', '*\1*' ,'ge') " Remove double square bracket from non-image link: [[file.md]] -> *file.md*

  call setreg('+', text, 'V')
endfunction
