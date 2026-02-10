local M = {}

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

M.commands = {
  macos = {
    on = 'macism dev.ensan.inputmethod.azooKeyMac.Japanese',
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

-- Check if the check command is available
local function is_check_command_available()
  local check_cmd = M.commands[M.osname].check.cmd
  local handle = io.popen('which ' .. check_cmd .. ' 2>/dev/null')
  if handle then
    local result = handle:read('*a')
    handle:close()
    return result ~= ''
  end
  return false
end

M.ime_enabled = is_check_command_available()

return M
