require'nvim-tree'.setup {
    view = {
        mappings = {
            list = {
                { key = { "<CR>", "o", "<2-LeftMouse>", "p" }, action = "edit" },
                { key = { "h" }, action = "dir_up" },
                { key = { "l" }, action = "cd" },
                { key = { "." }, action = "toggle_dotfiles" },
                { key = { "s" }, action = "" },
            }
        }
    }
}
