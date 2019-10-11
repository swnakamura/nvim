" 編集したファイルから遡るフォルダの最大数
let g:sass_compile_cdloop = 5
" ファイル保存時に自動コンパイル（1で自動実行）
let g:sass_compile_auto = 1
" 自動コンパイルを実行する拡張子
let g:sass_compile_file                 = ['scss', 'sass']
" cssファイルが入っているディレクトリ名（前のディレクトリほど優先）
let g:sass_compile_cssdir = ['css', 'stylesheet']
let g:sass_compile_beforecmd=''

au BufWritePost *.sass,*.scss SassCompile
autocmd FileType less,sass  setlocal sw = 2 sts=2 ts=2 et
