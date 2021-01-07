let s:plug_script = expand(g:home_directory . "/.config/nvim/autoload/plug.vim")
let s:plug_repo_dir = expand(g:home_directory . "/.config/nvim/plugged")

if !filereadable(s:plug_script)
    call system('curl -fLo ' . g:home_directory . '/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim')
    source s:plug_script
endif


call plug#begin(g:home_directory . '/.config/nvim/plugged')

let g:vim_markdown_no_default_key_mappings = 1

" completion
Plug 'neovim/nvim-lspconfig'
Plug 'Sirver/ultisnips'
Plug 'honza/vim-snippets'
Plug 'woodyZootopia/flatwhite-vim'
Plug 'Shougo/deoplete.nvim'
Plug 'Shougo/deoplete-lsp'

" colorschemes
Plug 'woodyZootopia/iceberg.vim', {'branch': 'support_LSP'}
Plug 'cocopon/pgmnt.vim'
Plug 'altercation/vim-colors-solarized'

Plug 'cohama/lexima.vim'

Plug 'Shougo/defx.nvim'
Plug 'kristijanhusak/defx-icons'

Plug 'Shougo/deol.nvim'
Plug 'kristijanhusak/defx-git'
" Plug 'lambdalisue/gina.vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
" Plug 'Shougo/denite.nvim'
" Plug 'Shougo/unite-outline'
Plug 'Shougo/neomru.vim'
Plug 'Shougo/neoyank.vim'
Plug 'haya14busa/vim-asterisk'
Plug 'neoclide/denite-git'
Plug 'Yggdroot/indentLine'
Plug 'kana/vim-smartinput'
Plug 'osyo-manga/shabadou.vim'
Plug 'kana/vim-operator-user'
Plug 'rhysd/vim-operator-surround'
Plug 'kana/vim-textobj-user'
Plug 'kana/vim-textobj-syntax'
Plug 'thinca/vim-textobj-between'
Plug 'osyo-manga/vim-textobj-multiblock'
Plug 'kana/vim-textobj-entire'
Plug 'airblade/vim-gitgutter'
Plug 'scrooloose/nerdcommenter'
Plug 'tpope/vim-fugitive'
Plug 'godlygeek/tabular'
Plug 'junegunn/vim-easy-align'
Plug 'soramugi/auto-ctags.vim'
Plug 'majutsushi/tagbar'
Plug 'Shougo/echodoc.vim'
Plug 'qnighy/satysfi.vim'
" Plug 'ncm2/float-preview.nvim'
Plug 'micke/vim-hybrid'
Plug 'mbbill/undotree'
Plug 'fuenor/jpmoveword.vim'
Plug 'tpope/vim-rhubarb'
Plug 'JuliaEditorSupport/julia-vim'
Plug 'itchyny/lightline.vim'
Plug 'jpalardy/vim-slime'
Plug 'tikhomirov/vim-glsl'
Plug 'Shougo/neco-syntax'
Plug 'skywind3000/asyncrun.vim'
Plug 'woodyZootopia/NeoDebug'
Plug 'yuratomo/gmail.vim'

" lazy install
Plug 'jceb/vim-orgmode', {'for': ['org']}
Plug 'mattn/emmet-vim', {'for': ['html','vue']}
Plug 'hynek/vim-python-pep8-indent', {'for' : 'python'}
Plug 'bps/vim-textobj-python', {'for' : 'python'}
Plug 'lervag/vimtex', {'for' : ['tex']}
Plug 'hail2u/vim-css3-syntax', {'for' : ['html','htm']}
Plug 'pangloss/vim-javascript', {'for' : ['html','htm']}
Plug 'kchmck/vim-coffee-script', {'for' : ['html','htm']}
Plug 'AtsushiM/search-parent.vim', {'for' : ['sass','scss','css']}
Plug 'akiyan/vim-textobj-php', {'for' : ['html','htm']}
Plug 'tpope/vim-surround', {'for' : ['html','htm']}
Plug 'ap/vim-css-color', {'for' : ['html','htm', 'vim']}
Plug 'cakebaker/scss-syntax.vim', {'for' : ['html','htm']}
Plug 'godlygeek/tabular', {'for' : ['md']}
Plug 'wokalski/autocomplete-flow', {'for' : ['html', 'htm', 'js']}
Plug 'pangloss/vim-javascript', {'for' : 'js'}
Plug 'zeekay/vim-beautify', {'for' : ['html', 'htm', 'js']}
Plug 'AtsushiM/sass-compile.vim', {'for' : ['sass','scss']}
Plug 'qnighy/satysfi.vim', {'for' : ['satysfi','saty']}
Plug 'plasticboy/vim-markdown', {'for' : ['markdown']}
Plug 'rust-lang/rust.vim', {'for': ['rust']}
Plug 'rust-lang/rust.vim', {'for': ['rust']}
Plug 'luochen1990/rainbow', {'for': ['lisp']}
let g:rainbow_active = 1 "set to 0 if you want to enable it later via :RainbowToggle

call plug#end()

if !isdirectory(s:plug_repo_dir)
    exe 'PlugInstall'
endif

" use termdebug
packadd termdebug
let g:termdebug_wide=163

" use my own plugin
let g:gitsession_autosave = 1
set runtimepath+=~/programming/gitsession.nvim
let g:gitsession_tmp_dir = expand("~/.config/nvim/tmp/gitsession")
