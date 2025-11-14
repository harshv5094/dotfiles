return {
	-- LSP Manager (Mason)
	{
		"mason-org/mason.nvim",
		opts = {
			ensure_installed = {
				"tree-sitter-cli",
				"stylua",
				"shellcheck",
				"shfmt",
				"flake8",
			},
		},
	},

	-- blink.cmp - Code completion made easy
	{
		"saghen/blink.cmp",
		dependencies = {
			"moyiz/blink-emoji.nvim",
			"saghen/blink.compat",
		},
		opts = {
			fuzzy = {
				implementation = "lua",
			},
			completion = {
				menu = {
					-- winblend = vim.o.pumblend,
					-- border = "rounded",
				},
			},
			signature = {
				window = {
					-- winblend = vim.o.pumblend,
					-- border = "rounded",
				},
			},
			sources = {
				default = {
					"emoji",
				},
				providers = {
					emoji = {
						module = "blink-emoji",
						name = "Emoji",
						score_offset = 15, -- Tune by preference
						opts = { insert = true }, -- Insert emoji (default) or complete its name
					},
				},
			},
		},
	},

	-- Configuring LSP
	{
		"neovim/nvim-lspconfig",
		---@class PluginLspOpts
		opts = {
			---@type lspconfig.options
			servers = {
				-- pyright will be automatically installed with mason and loaded with lspconfig
				cssls = {},
				html = {},
			},
		},
	},
}
