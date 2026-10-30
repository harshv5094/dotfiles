-- Bootstrap my config
_G.my_utils = require("utils")
require("config.options")
require("config.autocmds")
require("config.diagnostics")
require("config.keymaps")
require("config.pack")

-- Bootstrapping all my plugins in one plugins folder like lazyvim/lazy.nvim
require("plugins")
