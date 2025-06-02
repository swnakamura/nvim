---@class CommandCheck
---@field cmd string
---@field expected { on: string, off: string }

---@class PlatformCommands
---@field on string
---@field off string
---@field check CommandCheck

---@class Commands
---@field macos PlatformCommands
---@field linux PlatformCommands

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
  os.execute(M.commands[M.osname][M.status])
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
