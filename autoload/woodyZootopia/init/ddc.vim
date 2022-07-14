function! woodyZootopia#init#ddc#add() abort
    call ddc#custom#patch_global('sources', ['file', 'nvim-lsp', 'around', 'ultisnips', 'buffer'])
    set dictionary+=/usr/share/dict/words
    call ddc#custom#set_context(["python", "c", "cpp", "[a-z, A-Z]+"], { ->
      \ ddc#syntax#in('Comment') || ddc#syntax#in('String') || ddc#syntax#in('rustCommentLineDoc') ? {
      \   'sources': ['file', 'dictionary', 'around', 'buffer'],
      \ } : {} })
    call ddc#custom#patch_filetype(["text", "markdown", "gitcommit", 'tex'], 'sources', ['file', 'around', 'buffer', 'spell_user', 'dictionary'])
    call ddc#custom#patch_global('sourceOptions', {
        \ 'file': { 'mark': 'F', 'forceCompletionPattern': '\S/\S*'},
        \ 'nvim-lsp': { 'mark':'lsp', 'forceCompletionPattern': '\.\w*|:\w*|->\w*'},
        \ 'around': { 'mark': 'A' },
        \ 'buffer': { 'mark': 'B' },
        \ 'ultisnips': { 'mark': 'US' },
        \ '_': { 'matchers': ['matcher_fuzzy'],
        \        'sorters':  ['sorter_rank'],
        \        'ignoreCase': v:true},
        \   })
    call ddc#custom#patch_global('sourceParams', {
        \ 'nvim-lsp': { 'kindLabels': { 'Class': 'c' } },
        \ 'buffer': {'requireSameFiletype': v:false},
        \   })
    call ddc#enable()
endfunction
