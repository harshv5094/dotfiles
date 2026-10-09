return {
	-- NOTE: Utility plugin to autoinstall treesitter parsers
	{
		"mks-h/treesitter-autoinstall.nvim",
		event = { "VeryLazy" },
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

	{
		"nvim-treesitter/nvim-treesitter",
		init = function()
			if vim.fn.has("win32") then
				-- HACK: Using gcc as default compiler instead of `cl.exe`
				vim.env.CC = "gcc"
			end
		end,
		opts = function(_, opts)
			-- HACK: Removing some default treesitter installation from the list
			local drop = {
				"javascript",
				"tsx",
				"typescript",
				"python",
				"xml",
			}
			opts.ensure_installed = vim.tbl_filter(function(lang)
				return not vim.tbl_contains(drop, lang)
			end, opts.ensure_installed)
		end,
	},
}
