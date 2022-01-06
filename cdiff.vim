function! CharacterCount()
    let s:result = system("git cdiff")
    let s:result = system('echo ''' . s:result . ''' | sed -e "s/{+/\n{+/g" -e "s/+}/+}\n/g" -e "s/\[-/\n\[-/g" -e "s/-\]/-\]\n/g" | rg "[\{\[][^\}\]]*[\}\]]"')
    let s:diff_chars = system('echo '''. s:result . '''| cut -d+ -f2 | cut -d- -f2')
    let s:diff_chars_count = strchars(s:diff_chars)
    return s:diff_chars_count
endfunction
