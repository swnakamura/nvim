setlocal conceallevel=0

command -range=% GHCopy call GHCopy(<line1>, <line2>)

function GHCopy(line1, line2) abort
  let text = getline(a:line1, a:line2)

  let text = text->filter('v:val !~ ''\[\[[^.]*\.\(png\|jpg\)\]\]'' ') " Remove lines with internal links to image files: [[*.png]] or [[*.jpg]]

  let text = text->join("\n")

  let text = text->substitute('\$\([^$]\{-1,}\)\$','$`\1`$','ge')
  let text = text->substitute(' --- ',':','ge')
  let text = text->substitute('	','    ','ge')
  let text = text->substitute('[^!]\[\[\zs[^]]\+|\([^]]\+\)\ze\]\]', '\1' ,'ge') " Remove original link from aliased file name: [[original name|aliased name]] -> [[aliased name]]
  let text = text->substitute('[^!]\zs\[\[\([^]]\+\)\]\]\ze', '**\1**' ,'ge') " Remove double square bracket from non-image link and surround it with double star instead: [[file.md]] -> **file.md**
  call setreg('+', text, 'V')
endfunction
