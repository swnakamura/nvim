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

return M
