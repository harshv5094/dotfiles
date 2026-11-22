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
init.lua                 -> entry point: enables vim.loader, sources options/autocmds/diagnostics/keymaps/pack, lists plugins for `vim.pack`
lua/
  options.lua            -> vim options + globals (mapleader, netrw, undodir, ...)
  autocmds.lua           -> autocommands (incl. LSP auto-enable)
  diagnostics.lua        -> vim.diagnostic config + virtual text toggle
  keymaps.lua            -> global + LSP keymaps
  pack.lua               -> Custom nvim_user_commands for `vim.pack`
  tools.lua              -> Contains all my utilities and tools (lazygit, terminal, etc.)
  discipline.lua         -> hjkl throttle ("cowboy" mode)
  git.lua                -> git init helper
  icons.lua              -> icon glyph tables (nerd font symbols)
plugin/                  -> Auto imports plugin specs (one file per concern: lsp, ui, format, ...)
lsp/                     -> per-server LSP configs (vim.lsp.Config), auto-loaded
```
