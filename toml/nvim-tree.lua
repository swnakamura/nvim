require'nvim-tree'.setup {
    respect_buf_cwd = true,
    view = {
        mappings = {
            list = {
                { key = { "<CR>", "o", "<2-LeftMouse>" }, action = "edit" },
                { key = "h", action = "dir_up" },
                { key = "l", action = "cd" },
                { key = ".", action = "toggle_dotfiles" },
                { key = "s", action = "" },
                { key = "x", action = "system_open" },
                { key = "C", action = "cut" },
                { key = "P", action = "paste" },
                { key = "p", action = "preview" },
                { key = "q", action = "" }
            }
        },
        adaptive_size = true,
    },
    git = {
        ignore = false
    },
    renderer = {
        icons = {
            git_placement = "after"
        }
    }
}
