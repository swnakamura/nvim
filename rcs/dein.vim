"plugin settings
"
let g:dein#install_progress_type = 'floating'
let g:dein#install_check_diff = v:true
let g:dein#enable_notification = v:true
let g:dein#install_check_remote_threshold = 24 * 60 * 60
let g:dein#types#git#clone_depth = 1

let s:dein_home = g:nvim_conf_dir . 'dein'

if !isdirectory(s:dein_home)
  call system('git clone https://github.com/Shougo/dein.vim ' . shellescape(s:dein_home))
endif
let &runtimepath = &runtimepath . ',' . s:dein_home

let s:cache_dein = g:nvim_conf_dir . '/.cache/dein/dein.vim'

" list toml directory
let s:toml      = g:nvim_conf_dir . 'toml/dein.toml'
let s:lazy_toml = g:nvim_conf_dir . 'toml/dein_lazy.toml'
let s:denops_toml = g:nvim_conf_dir . 'toml/denops.toml'
let s:fern_toml = g:nvim_conf_dir . 'toml/fern.toml'
let s:cmp_toml = g:nvim_conf_dir . 'toml/cmp.toml'

if dein#min#load_state(s:cache_dein)
  echomsg "Rebuilding cache"
  call dein#begin(s:cache_dein, [s:toml, s:lazy_toml, s:denops_toml, s:fern_toml, s:cmp_toml])

  " read toml file and cache them
  call dein#load_toml(s:toml, #{lazy: 0})
  call dein#load_toml(s:lazy_toml, #{lazy: 1})
  call dein#load_toml(s:denops_toml, #{lazy: 1})
  call dein#load_toml(s:fern_toml, #{lazy: 1})
  call dein#load_toml(s:cmp_toml, #{lazy: 1})

  " finished!
  call dein#end()
  call dein#save_state()
endif

if has('vim_starting') && dein#check_install()
  call dein#install()
endif

if exists("g:dein#install_github_api_token")
  cabbrev deup call dein#check_update(v:true)
else
  cabbrev deup call dein#update()
endif

autocmd VimEnter * call dein#call_hook('post_source')

" use termdebug
packadd termdebug
let g:termdebug_wide=163
