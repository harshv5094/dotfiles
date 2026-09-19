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
}
