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
			transparent_mode = true,
		},
		config = function(_, opts)
			require("gruvbox").setup(opts)
		end,
	},
}
