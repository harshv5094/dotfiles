return {
	-- NOTE: Utility plugin to autoinstall treesitter parsers
	{
		"mks-h/treesitter-autoinstall.nvim",
		opts = {
			-- A list of *treesitter languages* to ignore.
			ignore = {},
			-- Auto-enable highlighting for installed languages.
			highlight = true,
			-- A list of *treesitter languages* to also enable regex highlighting for
			regex = {},
		},
		config = function(_, opts)
			require("treesitter-autoinstall").setup(opts)
		end,
	},

	-- NOTE: Removing some default treesitter installation from the list
	{
		"nvim-treesitter/nvim-treesitter",
		opts = function(_, opts)
			local drop = {
				"javascript",
				"tsx",
				"typescript",
			}
			opts.ensure_installed = vim.tbl_filter(function(lang)
				return not vim.tbl_contains(drop, lang)
			end, opts.ensure_installed)
		end,
	},
}
