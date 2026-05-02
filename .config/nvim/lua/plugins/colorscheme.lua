return {
	{
		"folke/tokyonight.nvim",
		enabled = false,
	},
	{
		"catppuccin/nvim",
		enabled = false,
	},
	{
		"ellisonleao/gruvbox.nvim",
		lazy = false,
		priority = 1000,
		opts = {
			terminal_colors = true,
			undercurl = true,
			bold = true,
			italic = {
				strings = false,
				emphasis = false,
				comments = true,
				operators = false,
				folds = false,
			},
			transparent_mode = true,
		},
		config = function(_, opts)
			require("gruvbox").setup(opts)
		end,
	},
}
