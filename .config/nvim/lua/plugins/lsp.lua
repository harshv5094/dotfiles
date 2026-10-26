return {
	{
		"saghen/blink.cmp",
		dependencies = {
			"onsails/lspkind.nvim",
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
					{ "kind" },
					{ "source_name" },
				},
				components = {
					source_name = {
						text = function(ctx)
							return "[" .. ctx.source_name .. "]"
						end,
					},
					kind_icon = {
						text = function(ctx)
							local icon = ctx.kind_icon
							if ctx.source_name == "Path" then
								local dev_icon = require("nvim-web-devicons").get_icon(ctx.label)
								if dev_icon then
									icon = dev_icon
								end
							else
								icon = require("lspkind").symbol_map[ctx.kind] or icon
							end
							return icon .. ctx.icon_gap
						end,
						highlight = function(ctx)
							local hl = ctx.kind_hl
							if ctx.source_name == "Path" then
								local _, dev_hl = require("nvim-web-devicons").get_icon(ctx.label)
								if dev_hl then
									hl = dev_hl
								end
							end
							return hl
						end,
					},
				},
			}
		end,
	},
}
