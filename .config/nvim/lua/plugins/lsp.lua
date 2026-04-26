return {
	-- LSP Manager (Mason)
	{
		"mason-org/mason.nvim",
		opts = function(_, opts)
			vim.list_extend(opts.ensure_installed, {
				"css-lsp",
				"tree-sitter-cli",
				"stylua",
				"shellcheck",
				"shfmt",
				"flake8",
			})
		end,
	},

	-- NOTE: blink.cmp - Code completion made easy
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
			cmdline = {
				enabled = false,
			},
			sources = {
				default = { "lazydev", "lsp", "path", "snippets", "buffer", "emoji" },
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
}
