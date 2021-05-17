"plugin settings
let s:cache_home = expand('~/.config/nvim')
let s:dein_dir = s:cache_home . '/dein'
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'
if !isdirectory(s:dein_repo_dir)
  call system('git clone https://github.com/Shougo/dein.vim ' . shellescape(s:dein_repo_dir))
endif
let &runtimepath = &runtimepath . ',' . s:dein_repo_dir
let g:python3_host_prog = substitute(system("which python3"), '\n', '', 'g')

let g:dein#types#git#clone_depth = 1
if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)
  " locate toml directory beforehand
  let g:rc_dir    = s:cache_home . '/toml'
  let s:toml      = g:rc_dir . '/dein.toml'
  let s:lazy_toml = g:rc_dir . '/dein_lazy.toml'

  " read toml file and cache them
  call dein#load_toml(s:toml,      {'lazy': 0})
  call dein#load_toml(s:lazy_toml, {'lazy': 1})

  call dein#end()
  call dein#save_state()
endif

if has('vim_starting') && dein#check_install()
  call dein#install()
endif

let g:vimtex_syntax_enabled = 0

" completion
let g:rainbow_active = 1 "set to 0 if you want to enable it later via :RainbowToggle

command DeinUpdate call dein#check_update(v:true)

" use termdebug
packadd termdebug
let g:termdebug_wide=163
