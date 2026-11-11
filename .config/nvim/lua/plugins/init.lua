---@param plugin_name string
---@return string
-- NOTE: A local function for just using `username/plugin_name` in vim.pack
local function gh(plugin_name)
	return "https://github.com/" .. plugin_name
end

-- HACK: A custom build hook for telescope-fzf-native.nvim
-- I need to run this since it builds itself
vim.api.nvim_create_autocmd("PackChanged", {
	desc = "telescope-fzf-native.nvim build hook",
	callback = function(ev)
		local name, kind = ev.data.spec.name, ev.data.kind
		if name == "telescope-fzf-native.nvim" and (kind == "install" or kind == "update") then
			vim.system({ "make" }, { cwd = ev.data.path })
		end
	end,
})

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
	{ src = gh("nvim-telescope/telescope.nvim") },
	{ src = gh("nvim-telescope/telescope-fzf-native.nvim") },
	{ src = gh("nvim-telescope/telescope-file-browser.nvim") },
	{ src = gh("nvim-telescope/telescope-ui-select.nvim") },
	{ src = gh("stevearc/oil.nvim") },
	{ src = gh("MagicDuck/grug-far.nvim") },
	{ src = gh("kazhala/close-buffers.nvim") },
	{ src = gh("mbbill/undotree") },
	{ src = gh("folke/persistence.nvim") },
	{ src = gh("linux-cultist/venv-selector.nvim") },

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

-- Importing above plugins config
require("plugins.coding")
require("plugins.colorscheme")
require("plugins.editor")
require("plugins.format")
require("plugins.lint")
require("plugins.lsp")
require("plugins.dap") -- Since I'm using mason-registry, I need to run this after mason
require("plugins.mini")
require("plugins.treesitter")
require("plugins.ui")
