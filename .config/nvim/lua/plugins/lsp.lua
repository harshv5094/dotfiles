return {
	-- NOTE: blink.cmp - Code completion made easy
	{
		"saghen/blink.cmp",
		opts = function(_, opts)
			opts.cmdline.enabled = false
		end,
	},
}
