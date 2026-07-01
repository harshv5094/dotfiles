return {

	-- Better increase/descrease
	{
		"monaqa/dial.nvim",
		event = "BufReadPre",
    -- stylua: ignore
    keys = {
      { "<C-a>", function() return require("dial.map").inc_normal() end, expr = true, desc = "Increment" },
      { "<C-x>", function() return require("dial.map").dec_normal() end, expr = true, desc = "Decrement" },
    },
		config = function()
			local augend = require("dial.augend")
			require("dial.config").augends:register_group({
				default = {
					augend.integer.alias.decimal,
					augend.integer.alias.hex,
					augend.date.alias["%Y/%m/%d"],
					augend.constant.alias.bool,
					augend.semver.alias.semver,
					augend.constant.new({ elements = { "let", "const" } }),
				},
			})
		end,
	},

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
		event = "BufReadPre",
		keys = {
			{
				"<localleader>gs",
				"<CMD>Git status --short<CR>",
				desc = "Git status (short)",
			},
			{
				"<localleader>ga",
				":Git add ",
				desc = "Git add",
			},
			{
				"<localleader>gce",
				"<CMD>Git commit --edit<CR>",
				desc = "Git commit (edit)",
			},
			{
				"<localleader>gca",
				"<CMD>Git commit --amend<CR>",
				desc = "Git commit (amend)",
			},
			{
				"<localleader>gp",
				"<CMD>Git pull --no-edit<CR>",
				desc = "Git pull (no-edit)",
			},
			{
				"<localleader>gP",
				"<CMD>Git push --force-with-lease<CR>",
				desc = "Git push (force-with-lease)",
			},
		},
	},
}
