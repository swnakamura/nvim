local M = {}

M.save_status = function()
  if vim.g.is_macos then
    local handle = io.popen('macism')
    M.status = handle:read("*l")
    handle:close()
  else
    M.status = os.execute('fcitx5-remote -s') -- fixme
  end
  return 0
end

M.restore_status = function()
  if vim.g.is_macos then
    os.execute('macism' .. M.status)
  else
    os.execute('fcitx5-remote -r') -- fixme
  end
end

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

vim.api.nvim_create_autocmd("InsertLeave", {
  pattern = "*",
  callback = function()
    M.save_status()
  end,
})

vim.api.nvim_create_autocmd("InsertEnter", {
  pattern = "*",
  callback = function()
    if vim.b.IME_autoenable then
      M.restore_status()
    end
  end,
})
