" let g:LanguageClient_settingsPath = expand('~/.config/nvim/lc_settings.json')
" let g:LanguageClient_loggingLevel = 'INFO'
" let g:LanguageClient_loggingFile = expand('~/.vim/LC.log')
" let g:LanguageClient_selectionUI = "location-list"
" let g:LanguageClient_diagnosticsList = "Location"
" let g:LanguageClient_hasSnippetSupport=1
" let g:LanguageClient_autoStart=1

" " 言語ごとに設定する
" let g:LanguageClient_serverCommands = {}
" if executable('clangd')
"     let g:LanguageClient_serverCommands['c'] = ['clangd']
"     let g:LanguageClient_serverCommands['cpp'] = ['clangd']
" endif

" if executable('pyls')
"     let g:LanguageClient_serverCommands['python'] = ['pyls']
" endif

" if executable('css-languageserver')
"     let g:LanguageClient_serverCommands['css'] = ['css-languageserver', '--stdio']
"     let g:LanguageClient_serverCommands['scss'] = ['css-languageserver', '--stdio']
"     let g:LanguageClient_serverCommands['sass'] = ['css-languageserver', '--stdio']
" endif

" let s:go_langserver_path=expand('~/go/bin/go-langserver')
" " let s:go_langserver_path=expand('~/go/bin/gopls')
" if executable(s:go_langserver_path)
"     let g:LanguageClient_serverCommands['go'] = [s:go_langserver_path, '-gocodecompletion']
" endif

" " if executable('rustup')
" "     let g:LanguageClient_serverCommands['rust'] = ['rustup', 'run', 'stable', 'rls']
" " endif

" if executable('rust-analyzer')
"     let g:LanguageClient_serverCommands['rust'] = ['rust-analyzer']
" endif

" let s:latex_langserver_path=expand('texlab')
" if executable(s:latex_langserver_path)
"     let g:LanguageClient_serverCommands['tex'] = [s:latex_langserver_path]
" endif

" if executable(expand('texlab'))
"     let g:LanguageClient_serverCommands['tex'] = ['texlab']
" endif

" if executable(expand('~/node_modules/.bin/vim-language-server'))
"     let g:LanguageClient_serverCommands['vim'] = ['~/node_modules/.bin/vim-language-server']
" endif

" let g:default_julia_version='1.0'
" let g:LanguageClient_serverCommands['julia'] =  ['julia', '--startup-file=no', '--history-file=no', '-e', ' using LanguageServer; using Pkg; import StaticLint; import SymbolServer; env_path = dirname(Pkg.Types.Context().env.project_file); debug = false; server = LanguageServer.LanguageServerInstance(stdin, stdout, debug, env_path, "", Dict()); server.runlinter = true; run(server);']

" " other settings
" let g:LanguageClient_useVirtualText = "CodeLens"

" let g:LanguageClient_documentHighlightDisplay =
"             \ {
"             \     1: {
"             \         "name": "Text",
"             \         "texthl": "SpellRare",
"             \     },
"             \     2: {
"             \         "name": "Read",
"             \         "texthl": "MatchParen",
"             \     },
"             \     3: {
"             \         "name": "Write",
"             \         "texthl": "MatchParen",
"             \     },
"             \ }

" let g:LanguageClient_diagnosticsDisplay =
"             \
"             \    {
"             \        1: {
"             \            "name": "Error",
"             \            "texthl": "ALEError",
"             \            "signText": "!!",
"             \            "signTexthl": "ALEErrorSign",
"             \            "virtualTexthl": "Error",
"             \        },
"             \        2: {
"             \            "name": "Warning",
"             \            "texthl": "ALEWarning",
"             \            "signText": "!",
"             \            "signTexthl": "ALEWarningSign",
"             \            "virtualTexthl": "Todo",
"             \        },
"             \        3: {
"             \            "name": "Information",
"             \            "texthl": "ALEInfo",
"             \            "signText": "i",
"             \            "signTexthl": "ALEInfoSign",
"             \            "virtualTexthl": "Todo",
"             \        },
"             \        4: {
"             \            "name": "Hint",
"             \            "texthl": "ALEInfo",
"             \            "signText": "?",
"             \            "signTexthl": "ALEInfoSign",
"             \            "virtualTexthl": "Todo",
"             \        },
"             \    }

" " augroup LanguageClient_config
" "     autocmd!
" "     autocmd User LanguageClientStarted setlocal signcolumn=yes
" "     autocmd User LanguageClientStopped setlocal signcolumn=auto
" " augroup END

" function! LC_maps()
"     if has_key(g:LanguageClient_serverCommands, &filetype)
"         nnoremap <buffer> <silent> K          :call LanguageClient#textDocument_hover()<CR>
"         nnoremap <buffer> <silent> <Leader>ah :call LanguageClient_textDocument_hover()<CR>
"         nnoremap <buffer> <silent> <Leader>ad :call LanguageClient_textDocument_definition()<CR>
"         nnoremap <buffer> <silent> <Leader>ar :call LanguageClient_textDocument_rename()<CR>
"         nnoremap <buffer> <silent> <Leader>aR :LanguageClientStop<CR>:call wait(500,0)<CR>:LanguageClientStart<CR>
"         nnoremap <buffer> <silent> <Leader>af :call LanguageClient_textDocument_formatting()<CR>
"         " nnoremap <buffer> <silent> gf         :call LanguageClient_textDocument_formatting()<CR>
"     endif
" endfunction

" autocmd FileType * call LC_maps()

" augroup languageClientHighlight
"     autocmd!
"     autocmd CursorHold,CursorHoldI *.c,*.cpp,*.rs call LanguageClient#textDocument_documentHighlight()
" augroup END

" augroup languageClientAutoFormat
"     autocmd!
"     autocmd BufWritePre *.rs :call LanguageClient#textDocument_formatting_sync()
" augroup END
