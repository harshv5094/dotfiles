# My neovim config

After using lazyvim for years. I decided to build my own neovim config, I added some parts from [lazyvim](https://lazyvim.org), but everything is only those changes I want.

## Requirements

- **Neovim >= 0.12** (uses the native LSP API: `vim.lsp.config` / `vim.lsp.enable`)
- `git` (for plugin bootstrapping)
- A C compiler / `unzip` (for some treesitter parsers and mason tools)

## Install

```bash
git clone <your-repo-url> ~/.config/nvim
nvim
```

On first launch, [vim.pack](https://neovim.io/doc/user/pack/#_plugin-manager) bootstraps itself and ask you to install your plugins. Mason then auto-installs the LSP servers and tools declared in `lsp.lua`.

## Structure

```
init.lua                 -> entry point, loads config.base, also enables vim.loader based on version number
lua/
  config/
    init.lua             -> bootstraps my config files
    options.lua          -> vim options
    keymaps.lua          -> global + LSP keymaps
    autocmds.lua         -> autocommands (incl. LSP auto-enable)
    diagnostics.lua      -> vim.diagnostic config + virtual text toggle
    pack.lua             -> Custom nvim_user_commands for `vim.pack`
  utils/                 -> small helper modules
plugin/                  -> Auto imports plugin specs (one file per concern: lsp, ui, format, ...)
lsp/                     -> per-server LSP configs (vim.lsp.Config), auto-loaded
```
