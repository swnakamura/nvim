-- Define "Japanese input mode", in which the IME is enabled or disabled when entering or leaving insert mode.
local M = require('japanese.common')

-- Functions to enable/disable IME

M.enable = function()
  os.execute(M.commands[M.osname].on)
end

M.disable = function()
  os.execute(M.commands[M.osname].off)
end

M.toggle_IME = function()
  vim.b.IME_autoenable = not vim.b.IME_autoenable
  if vim.b.IME_autoenable then
    print('日本語入力モードON')
    if vim.fn.mode() == 'i' then
      M.enable()
    end
    -- also set keymap for FuzzyMotion, which is useful for Japanese text
    -- temporarily disabled because it resutls in an unknown error
    -- vim.api.nvim_buf_set_keymap(0, 'n', 'S',     '<cmd>FuzzyMotion<CR>', { noremap = true, silent = true })
    -- vim.api.nvim_buf_set_keymap(0, 'n', 't',     '<cmd>FuzzyMotion<CR>', { noremap = true, silent = true })
    -- vim.api.nvim_buf_set_keymap(0, 'n', '<C-s>', '<cmd>FuzzyMotion<CR>', { noremap = true, silent = true })
  else
    print('日本語入力モードOFF')
    pcall(vim.api.nvim_buf_del_keymap, 0, 'n', 'S')
    pcall(vim.api.nvim_buf_del_keymap, 0, 'n', 't')
    pcall(vim.api.nvim_buf_del_keymap, 0, 'n', '<C-s>')
    if vim.fn.mode() == 'i' then
      M.disable()
    end
  end
end

-- Autocommands that are controlled by the above functions (only if IME is enabled)
if not M.ime_enabled then
  return M
end

vim.api.nvim_create_augroup("IME_autotoggle", { clear = true })
vim.api.nvim_create_autocmd("InsertEnter", {
  group = "IME_autotoggle",
  pattern = "*",
  callback = function()
    if vim.b.IME_autoenable then
      M.enable()
    end
  end,
})
vim.api.nvim_create_autocmd("InsertLeave", {
  group = "IME_autotoggle",
  pattern = "*",
  callback = function()
    M.disable()
  end,
})
vim.api.nvim_create_autocmd("CmdLineEnter", {
  group = "IME_autotoggle",
  pattern = [[/,\?]],
  callback = function()
    if vim.b.IME_autoenable then
      vim.keymap.set('c', '<CR>', '<Plug>(kensaku-search-replace)<CR>')
    else
      -- set and delete to return to the default behavior
      vim.keymap.set('c', '<CR>', '<CR>')
      vim.keymap.del('c', '<CR>')
    end
  end,
})

vim.api.nvim_create_augroup("auto_ja", { clear = true })
vim.api.nvim_create_autocmd("BufRead", {
  group = "auto_ja",
  pattern = { "*/my-text/**.txt", "*/my-text/**.md", "*/obsidian/**.md" },
  callback = function()
    M.toggle_IME()
  end,
})

return M
