
local M = {}

-- Functions to enable/disable IME

M.enable = function()
  if vim.g.is_macos then
    os.execute('macism com.justsystems.inputmethod.atok33.Japanese')
  else
    os.execute('fcitx5-remote -o')
  end
end

M.disable = function()
  if vim.g.is_macos then
    os.execute('macism com.apple.keylayout.ABC')
  else
    os.execute('fcitx5-remote -c')
  end
end

M.toggle_IME = function()
  vim.b.IME_autoenable = not vim.b.IME_autoenable
  if vim.b.IME_autoenable then
    print('日本語入力モードON')
    if vim.fn.mode() == 'i' then
      M.enable()
    end
    -- also set keymap for FuzzyMotion, which is useful for Japanese text
    vim.api.nvim_buf_set_keymap(0, 'n', 'S',     '<cmd>FuzzyMotion<CR>', { noremap = true, silent = true })
    vim.api.nvim_buf_set_keymap(0, 'n', '<C-s>', '<cmd>FuzzyMotion<CR>', { noremap = true, silent = true })
  else
    print('日本語入力モードOFF')
    vim.api.nvim_buf_del_keymap(0, 'n', 'S')
    if vim.fn.mode() == 'i' then
      M.disable()
    end
  end
end

-- Autocommands that are controlled by the above functions
vim.api.nvim_create_augroup("IME_autotoggle", { clear = true })
vim.api.nvim_create_autocmd("InsertEnter", {
  group = "IME_autotoggle",
  pattern = "*",
  callback = function()
    if vim.b.IME_autoenable then
      require('japanese_input').enable()
    end
  end,
})
vim.api.nvim_create_autocmd("InsertLeave", {
  group = "IME_autotoggle",
  pattern = "*",
  callback = function()
    require('japanese_input').disable()
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
    require('japanese_input').toggle_IME()
  end,
})

return M
