"plugin settings
let s:nvim_home = expand('~/.config/nvim/')
let s:dein_home = s:nvim_home . 'dein'

if !isdirectory(s:dein_home)
  call system('git clone https://github.com/Shougo/dein.vim ' . shellescape(s:dein_home))
endif
let &runtimepath = &runtimepath . ',' . s:dein_home
let g:python3_host_prog = exepath('python3')

let g:dein#types#git#clone_depth = 1
if dein#load_state(s:dein_home)
  " list toml directory
  let s:toml      = s:nvim_home . 'toml/dein.toml'
  let s:lazy_toml = s:nvim_home . 'toml/dein_lazy.toml'
  let s:novscode_toml = s:nvim_home . 'toml/dein_novscode.toml'

  " obtain cache directory
  let s:cache_home = expand('~/.cache/')
  let s:cache_dein = s:cache_home . 'dein/dein.vim'

  " let's begin...
  call dein#begin(s:cache_dein, [s:toml, s:lazy_toml, s:novscode_toml])

  " read toml file and cache them
  call dein#load_toml(s:toml,      {'lazy': 0})
  call dein#load_toml(s:lazy_toml, {'lazy': 1})
  if !exists('g:vscode')
    call dein#load_toml(s:novscode_toml, {'lazy': 0})
  endif

  " finished!
  call dein#end()
  call dein#save_state()
endif

if has('vim_starting') && dein#check_install()
  call dein#install()
endif

let g:vimtex_syntax_enabled = 0

" completion
let g:rainbow_active = 1 "set to 0 if you want to enable it later via :RainbowToggle

if exists("g:dein#install_github_api_token")
    cabbrev deup call dein#check_update(v:true)
else
    cabbrev deup call dein#update()
endif

autocmd VimEnter * call dein#call_hook('post_source')

" use termdebug
packadd termdebug
let g:termdebug_wide=163
