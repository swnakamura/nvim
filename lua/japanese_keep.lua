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

local M = {}

---@type Commands
M.commands = {
  macos = {
    on = 'macism com.justsystems.inputmethod.atok33.Japanese',
    off = 'macism com.apple.keylayout.ABC',
    check = {
      cmd = 'macism',
      expected = {
        on = 'com.justsystems.inputmethod.atok33.Japanese',
        off = 'com.apple.keylayout.ABC',
      },
    }
  },
  linux = {
    on = 'fcitx5-remote -o',
    off = 'fcitx5-remote -c',
    check = {
      cmd = 'fcitx5-remote',
      expected = {
        on = '2',
        off = '1',
      },
    }
  },
}

if vim.g.is_macos then
  M.osname = 'macos'
else
  M.osname = 'linux'
end

M.save_status = function()
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
  os.execute(M.commands[M.osname][M.status])
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
      M.save_status()
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
