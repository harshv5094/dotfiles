-- Bootstrap my config
_G.my_utils = require("utils")
require("config.options")
require("config.autocmds")
require("config.diagnostics")
require("config.keymaps")
require("config.pack")

---@param plugin_name string
---@return string
-- NOTE: A local function for just using `username/plugin_name` in vim.pack
local function gh(plugin_name)
	return "https://github.com/" .. plugin_name
end

-- Adding the plugins here so they can be installed/loaded
vim.pack.add({
	-- Coding
	{ src = gh("folke/trouble.nvim") },
	{ src = gh("b0o/SchemaStore.nvim") },
	{ src = gh("laytan/cloak.nvim") },

	-- Colorscheme
	{ src = gh("ellisonleao/gruvbox.nvim") },

	-- Editor
	{ src = gh("nvim-lua/plenary.nvim") },
	{ src = gh("nvim-tree/nvim-web-devicons") },
	{ src = gh("MagicDuck/grug-far.nvim") },
	{ src = gh("kazhala/close-buffers.nvim") },
	{ src = gh("mbbill/undotree") },
	{ src = gh("folke/persistence.nvim") },

	-- Format
	{ src = gh("stevearc/conform.nvim") },

	-- Linter
	{ src = gh("mfussenegger/nvim-lint") },

	-- LSP
	{ src = gh("saghen/blink.cmp"), version = vim.version.range("1.*") },
	{ src = gh("rafamadriz/friendly-snippets") },
	{ src = gh("moyiz/blink-emoji.nvim") },
	{ src = gh("folke/lazydev.nvim") },
	{ src = gh("mason-org/mason.nvim") },
	{ src = gh("WhoIsSethDaniel/mason-tool-installer.nvim") },

	-- Mini
	{ src = gh("nvim-mini/mini.nvim") },

	-- DAP
	{ src = gh("mfussenegger/nvim-dap") },
	{ src = gh("igorlfs/nvim-dap-view") },

	-- Treesitter
	{ src = gh("nvim-treesitter/nvim-treesitter") },
	{ src = gh("nvim-treesitter/nvim-treesitter-context") },
	{ src = gh("mks-h/treesitter-autoinstall.nvim") },

	-- UI
	{ src = gh("j-hui/fidget.nvim") },
	{ src = gh("folke/which-key.nvim") },
	{ src = gh("folke/todo-comments.nvim") },
	{ src = gh("MeanderingProgrammer/render-markdown.nvim") },
	{ src = gh("akinsho/bufferline.nvim") },
	{ src = gh("b0o/incline.nvim") },
})
