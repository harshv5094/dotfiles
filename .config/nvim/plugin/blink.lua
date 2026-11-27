if pcall(require, "blink.cmp") then
	---@module 'blink.cmp'
	---@type blink.cmp.Config
	require("blink.cmp").setup({
		keymap = {
			preset = "default",
			["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
			["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
			["<CR>"] = { "accept", "fallback" },
		},
		appearance = {
			nerd_font_variant = "mono",
			kind_icons = require("icons").kinds,
		},
		sources = {
			default = { "lazydev", "lsp", "path", "snippets", "buffer", "emoji" },
			providers = {
				snippets = {
					opts = {
						-- Snippets are vendored in ~/.config/nvim/snippets (see snippets/package.json)
						friendly_snippets = false,
						search_paths = { vim.fn.stdpath("config") .. "/snippets" },
					},
				},
				lazydev = {
					name = "LazyDev",
					module = "lazydev.integrations.blink",
					-- make lazydev completions top priority (see `:h blink.cmp`)
					score_offset = 100,
				},
				emoji = {
					module = "blink-emoji",
					name = "Emoji",
					score_offset = 15, -- Tune by preference
					opts = {
						insert = true, -- Insert emoji (default) or complete its name
						---@type string|table|fun():table
						trigger = function()
							return { ":" }
						end,
					},
					should_show_items = function()
						-- Enable emoji completion only for git commits and markdown.
						-- By default, enabled for all file-types.
						return vim.tbl_contains({ "gitcommit", "markdown", "txt" }, vim.o.filetype)
					end,
				},
			},
		},
		cmdline = {
			enabled = true,
		},
		signature = {
			enabled = true,
			window = {
				show_documentation = true,
			},
		},
		completion = {
			list = {
				selection = {
					preselect = true,
					auto_insert = false,
				},
			},
			ghost_text = {
				enabled = true,
			},
			documentation = {
				auto_show = true,
				auto_show_delay_ms = 800,
			},
			menu = {
				draw = {
					columns = {
						{ "kind_icon" },
						{ "label", "label_description", "source_name", gap = 1 },
					},
					components = {
						source_name = {
							text = function(ctx)
								return "[" .. ctx.source_name .. "]"
							end,
						},
					},
				},
			},
		},
		fuzzy = { implementation = "prefer_rust" },
	})
end
