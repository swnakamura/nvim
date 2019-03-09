" 編集したファイルから遡るフォルダの最大数
let g:sass_compile_cdloop = 5
" ファイル保存時に自動コンパイル（1で自動実行）
let g:sass_compile_auto = 1
" 自動コンパイルを実行する拡張子
let g:sass_compile_file = ['scss', 'sass', 'wowow']
" cssファイルが入っているディレクトリ名（前のディレクトリほど優先）
let g:sass_compile_cssdir = ['css', 'stylesheet']
let g:sass_compile_beforecmd=''
let g:sass_compile_aftercmd=''

au BufWritePost *.sass,*.scss SassCompile
