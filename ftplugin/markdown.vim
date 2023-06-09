setlocal conceallevel=2

command! -range GHCopy call GitHubCopy()

function! GitHubCopy() abort
  normal! m x
  '<,'>s/\$\([^$]\{-}\)\$/$`\1`$/ge
  " '<,'>s/\$\$\(.[^$]\{-1,}\)\$\$/\r```math\r\1\r```/ge
  '<,'>s/bm/mathbf/ge
  '<,'>yank +
  undo
endfunction
