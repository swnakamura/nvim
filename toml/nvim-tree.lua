-- If you want icons for diagnostic errors, you'll need to define them somewhere:
vim.fn.sign_define("DiagnosticSignError",
{text = " ", texthl = "DiagnosticSignError"})
vim.fn.sign_define("DiagnosticSignWarn",
{text = " ", texthl = "DiagnosticSignWarn"})
vim.fn.sign_define("DiagnosticSignInfo",
{text = " ", texthl = "DiagnosticSignInfo"})
vim.fn.sign_define("DiagnosticSignHint",
{text = " ", texthl = "DiagnosticSignHint"})
-- NOTE: this is changed from v1.x, which used the old style of highlight groups
-- in the form "LspDiagnosticsSignWarning"

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
        },
        indent_markers = {
            enable = true,
        },
    }
}
