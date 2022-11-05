require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = {'diff', 'org'},
    disable = {'json', 'diff', 'org'},
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "vac",
      node_incremental = "M",
      scope_incremental = "S",
      node_decremental = "m",
    },
  },
  indent = {
    enable = false
  },
  auto_install = true,
}
