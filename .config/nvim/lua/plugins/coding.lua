return {

	-- Keeping .env Secret
	{
		"laytan/cloak.nvim",
		event = "BufReadPre",
		config = function()
			require("cloak").setup({
				enabled = true,
				cloak_character = "*",
				-- The applied highlight group (colors) on the cloaking, see `:h highlight`.
				highlight_group = "Comment",
				patterns = {
					{
						-- Match any file starting with ".env".
						-- This can be a table to match multiple file patterns.
						file_pattern = {
							".env*",
							"wrangler.toml",
							".dev.vars",
						},
						-- Match an equals sign and any character after it.
						-- This can also be a table of patterns to cloak,
						-- example: cloak_pattern = { ":.+", "-.+" } for yaml files.
						cloak_pattern = "=.+",
					},
				},
			})
		end,
	},

	-- NOTE: Git wrapper done right by "tpope"
	{
		"tpope/vim-fugitive",
		event = { "BufReadPre", "BufNewFile" },
    -- stylua: ignore
		keys = {
			{ "<localleader>gss", "<CMD>Git status<CR>", desc = "Git status", },
			{ "<localleader>gsq", "<CMD>Git status --short<CR>", desc = "Git status (short)", },
			{ "<localleader>gab", "<CMD>Git add %<CR>", desc = "Git add (Current Buffer)", },
			{ "<localleader>gaa", "<CMD>Git add *<CR>", desc = "Git add (All)", },
			{ "<localleader>gaf", ":Git add ", desc = "Git add (Manual)", },
			{ "<localleader>gce", "<CMD>Git commit --edit<CR>", desc = "Git commit (edit)", },
			{ "<localleader>gca", "<CMD>Git commit --amend<CR>", desc = "Git commit (amend)", },
			{ "<localleader>gp", "<CMD>Git pull --no-edit<CR>", desc = "Git pull (no-edit)", },
			{ "<localleader>gr", "<CMD>Git reset --hard HEAD<CR>", desc = "Git reset (--hard) HEAD", },
			{ "<localleader>gP", "<CMD>Git push --force-with-lease<CR>", desc = "Git push (force-with-lease)", },
			{ "<localleader>gll", "<CMD>Git log<CR>", desc = "Git log", },
		},
	},
}
