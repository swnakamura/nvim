let g:LanguageClient_settingsPath = expand('~/.config/nvim/lc_settings.json')
" let g:LanguageClient_loggingLevel = 'INFO'
" let g:LanguageClient_loggingFile = expand('~/.vim/LC.log')
" let g:LanguageClient_selectionUI = "location-list"

" 言語ごとに設定する
let g:LanguageClient_serverCommands = {}
if executable('clangd')
    let g:LanguageClient_serverCommands['c'] = ['clangd']
    let g:LanguageClient_serverCommands['cpp'] = ['clangd']
endif

if executable('pyls')
    let g:LanguageClient_serverCommands['python'] = ['pyls']
endif

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
let g:LanguageClient_useVirtualText = 0

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

augroup lcHighlight
    autocmd!
    autocmd CursorHold,CursorHoldI *.py,*.c,*.cpp call LanguageClient#textDocument_documentHighlight()
augroup END

