setlocal conceallevel=2

command -range GHCopy  call GHCopy()

function GHCopy() abort
  let text = getline("'<", "'>")->join("\n")

  let text = text->substitute('\$\([^$]\{-1,}\)\$','$`\1`$','ge')
  let text = text->substitute('!\[\[[^]]\+\]\]\n*\ze\s*!\[.\{-\}\](', '' ,'ge') " Remove obsidian internal links: [[somefile]], if it's followed by another link: ![linkname](URL).
  let text = text->substitute('!\[\[\([^]]\+\)\]\]\n*', '\1' ,'ge') " Otherwise, only remove double square bracket.

  call setreg('+', text, 'V')
endfunction
