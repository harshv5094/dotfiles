return {
	-- Treesitter
	{
		"nvim-treesitter/nvim-treesitter",
		opts = function(_, opts)
			-- add tsx and treesitter
			vim.list_extend(opts.ensure_installed, {
				"html",
				"css",
				"json",
				"query",
				"regex",
				"vim",
				"ssh_config",
				"gitcommit",
				"ini",
				"zsh",
			})
		end,
	},
}
