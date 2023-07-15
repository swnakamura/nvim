setlocal conceallevel=2

command -range GHCopy  call GHCopy()

function GHCopy() abort
  let text = getline("'<", "'>")->join("\n")

  let text = text->substitute('\$\([^$]\{-1,}\)\$','$`\1`$','ge')
  let text = text->substitute(' --- ',':','ge')
  let text = text->substitute('!\[\[[^]]\+\]\]\n*\ze\s*!\[.\{-\}\](', '' ,'ge') " Remove obsidian internal links: ![[imagefile]], if it's followed by another link: ![imagename](URL).
  let text = text->substitute('[^!]\zs\[\[\([^]]\+\)\]\]\ze', '*\1*' ,'ge') " Remove double square bracket from non-image link: [[file.md]] -> *file.md*

  call setreg('+', text, 'V')
endfunction
