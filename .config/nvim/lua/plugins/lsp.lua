return {
	{
		"saghen/blink.cmp",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
			"moyiz/blink-emoji.nvim",
		},
		opts = function(_, opts)
			-- Add emoji to the default sources, without duplicating it
			if not vim.tbl_contains(opts.sources.default, "emoji") then
				table.insert(opts.sources.default, "emoji")
			end

			-- Register the provider by assignment
			opts.sources.providers.emoji = {
				module = "blink-emoji",
				name = "Emoji",
				score_offset = 15,
				opts = {
					insert = true,
					trigger = function()
						return { ":" }
					end,
				},
				should_show_items = function()
					return vim.tbl_contains({ "gitcommit", "markdown" }, vim.o.filetype)
				end,
			}

			opts.completion.menu.draw = {
				columns = {
					{ "kind_icon" },
					{ "label", "label_description", gap = 1 },
					{ "kind", "source_name", gap = 1 },
				},
				components = {
					source_name = {
						text = function(ctx)
							return "[" .. ctx.source_name .. "]"
						end,
					},
				},
			}
		end,
	},
}
