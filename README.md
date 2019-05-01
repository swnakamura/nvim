Clone this repository in `~./config/` and open Neovim

## How it works
Neovim loads `init.vim` and `dein` starts. `dein` looks for what to install by looking into `toml` directory. When manual settings are required for each plugin, it does by sourcing items in `plugins` directory.

`tablinegen.vim` is sourced by `init.vim` to use my own tabline settings.
