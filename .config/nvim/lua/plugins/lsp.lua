return {
	-- NOTE: blink.cmp - Code completion made easy
	{
		"saghen/blink.cmp",
		dependencies = {
			"moyiz/blink-emoji.nvim",
		},
		opts = {
			fuzzy = {
				implementation = "prefer_rust",
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
