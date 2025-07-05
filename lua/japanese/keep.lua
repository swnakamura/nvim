-- Keep the IME status when leaving insert mode and restore it when entering insert mode
local M = require('japanese.common')

M.stash_status = function()
  local check_cfg = M.commands[M.osname].check
  local handle = io.popen(check_cfg.cmd)
  local retval = nil
  if handle then
    retval = handle:read("*l")
    handle:close()
  end
  if retval == nil then
    print("Failed to get IME status.")
    return -1
  end
  if retval == check_cfg.expected.on then
    M.status = 'on'
  elseif retval == check_cfg.expected.off then
    M.status = 'off'
  else
    M.status = 'unknown'
    print("Unknown IME status: " .. retval)
  end
  os.execute(M.commands[M.osname].off)
  return 0
end

M.restore_status = function()
  local cmd = M.commands[M.osname][M.status]
  if type(cmd) ~= 'string' then
    print("Invalid command for IME status: " .. M.status)
    return -1
  end
  os.execute(cmd)
end


M.setup = function()
  M.status = 'off'
  vim.api.nvim_create_autocmd("InsertLeave", {
    pattern = "*",
    callback = function()
      M.stash_status()
    end,
  })

  vim.api.nvim_create_autocmd("InsertEnter", {
    pattern = "*",
    callback = function()
      M.restore_status()
    end,
  })
end

return M
