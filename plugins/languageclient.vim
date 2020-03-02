let g:LanguageClient_settingsPath = expand('~/.config/nvim/lc_settings.json')
let g:LanguageClient_loggingLevel = 'INFO'
let g:LanguageClient_loggingFile = expand('~/.vim/LC.log')
let g:LanguageClient_selectionUI = "location-list"
let g:LanguageClient_diagnosticsList = "Location"
let g:LanguageClient_hasSnippetSupport=1

" 言語ごとに設定する
let g:LanguageClient_serverCommands = {}
if executable('clangd')
    let g:LanguageClient_serverCommands['c'] = ['clangd']
    let g:LanguageClient_serverCommands['cpp'] = ['clangd']
endif

" if executable('pyls')
"     let g:LanguageClient_serverCommands['python'] = ['pyls']
" endif

if executable('css-languageserver')
    let g:LanguageClient_serverCommands['css'] = ['css-languageserver', '--stdio']
    let g:LanguageClient_serverCommands['scss'] = ['css-languageserver', '--stdio']
    let g:LanguageClient_serverCommands['sass'] = ['css-languageserver', '--stdio']
endif

if executable(expand('~/go/bin/go-langserver'))
    let g:LanguageClient_serverCommands['go'] = [expand('~/go/bin/go-langserver'), '-gocodecompletion']
endif

let g:default_julia_version='1.0'
let g:LanguageClient_serverCommands['julia'] =  ['julia', '--startup-file=no', '--history-file=no', '-e', ' using LanguageServer; using Pkg; import StaticLint; import SymbolServer; env_path = dirname(Pkg.Types.Context().env.project_file); debug = false; server = LanguageServer.LanguageServerInstance(stdin, stdout, debug, env_path, "", Dict()); server.runlinter = true; run(server);']


" if executable(expand('~/go/bin/gopls'))
"     let g:LanguageClient_serverCommands['go'] = [expand('~/go/bin/gopls')]
" endif

" other settings
let g:LanguageClient_useVirtualText = "CodeLens"

let g:LanguageClient_documentHighlightDisplay =
            \ {
            \     1: {
            \         "name": "Text",
            \         "texthl": "SpellRare",
            \     },
            \     2: {
            \         "name": "Read",
            \         "texthl": "MatchParen",
            \     },
            \     3: {
            \         "name": "Write",
            \         "texthl": "MatchParen",
            \     },
            \ }

" augroup LanguageClient_config
"     autocmd!
"     autocmd User LanguageClientStarted setlocal signcolumn=yes
"     autocmd User LanguageClientStopped setlocal signcolumn=auto
" augroup END

function! LC_maps()
    if has_key(g:LanguageClient_serverCommands, &filetype)
        nnoremap <buffer> <silent> K          :call LanguageClient#textDocument_hover()<CR>
        nnoremap <buffer> <silent> <Leader>lh :call LanguageClient_textDocument_hover()<CR>
        nnoremap <buffer> <silent> <Leader>ld :call LanguageClient_textDocument_definition()<CR>
        nnoremap <buffer> <silent> <Leader>lr :call LanguageClient_textDocument_rename()<CR>
        nnoremap <buffer> <silent> <Leader>lf :call LanguageClient_textDocument_formatting()<CR>
        nnoremap <buffer> <silent> gf         :call LanguageClient_textDocument_formatting()<CR>
    endif
endfunction

autocmd FileType * call LC_maps()

augroup languageClientHighlight
    autocmd!
    autocmd CursorHold,CursorHoldI *.c,*.cpp call LanguageClient#textDocument_documentHighlight()
augroup END

function! ExpandLspSnippet()
    call UltiSnips#ExpandSnippetOrJump()
    if !pumvisible() || empty(v:completed_item)
        return ''
    endif

    " only expand Lsp if UltiSnips#ExpandSnippetOrJump not effect.
    let l:value = v:completed_item['word']
    let l:kind = v:completed_item['kind']
    let l:abbr = v:completed_item['abbr']

    " remove inserted chars before expand snippet
    let l:end = col('.')
    let l:line = 0
    let l:start = 0
    for l:match in [l:abbr . '(', l:abbr, l:value]
        let [l:line, l:start] = searchpos(l:match, 'b', line('.'))
        if l:line != 0 || l:start != 0
            break
        endif
    endfor
    if l:line == 0 && l:start == 0
        return ''
    endif

    let l:matched = l:end - l:start
    if l:matched <= 0
        return ''
    endif

    exec 'normal! ' . l:matched . 'x'

    if col('.') == col('$') - 1
        " move to $ if at the end of line.
        call cursor(l:line, col('$'))
    endif

    " expand snippet now.
    call UltiSnips#Anon(l:value)
    return ''
endfunction

imap <C-k> <C-R>=ExpandLspSnippet()<CR>
