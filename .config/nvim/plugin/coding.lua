if pcall(require, "trouble") then
	-- stylua: ignore
	local keys = {
		{ "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
		{ "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics (Trouble)" },
		{ "<leader>xL", "<cmd>Trouble loclist toggle<cr>", desc = "Location List (Trouble)", },
		{ "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix List (Trouble)", },
		{ "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>", desc = "Symbols (Trouble)" },
		{ "<leader>cl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", desc = "LSP Definitions / references / ... (Trouble)", },
	}
	for _, key in ipairs(keys) do
		vim.keymap.set("n", key[1], key[2], { desc = key.desc })
	end

	require("trouble").setup()
end

if pcall(require, "cloak") then
	require("cloak").setup({
		enabled = true,
		cloak_character = "*",
		highlight_group = "Comment",
		patterns = {
			{
				-- Match any file starting with ".env".
				file_pattern = {
					".env*",
					"wrangler.toml",
					".dev.vars",
				},
				-- Match an equals sign and any character after it.
				cloak_pattern = "=.+",
			},
		},
	})
end

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
			ghost_text = {
				enabled = true,
			},
			documentation = {
				auto_show = true,
				auto_show_delay_ms = 500,
			},
			menu = {
				draw = {
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
				},
			},
		},
		fuzzy = { implementation = "prefer_rust" },
	})
end

-- A git wrapper by tpope
if require("tools").vim_plugin_path_checker("vim-fugitive") then
	-- stylua: ignore
	local keys = {
		{ "<leader>gss", "<CMD>G status<CR>", desc = "status" },
		{ "<leader>gsq", "<CMD>G status --short<CR>", desc = "status (short)" },
		{ "<leader>gab", "<CMD>G add %<CR>", desc = "add (Current Buffer)" },
		{ "<leader>gaa", "<CMD>G add *<CR>", desc = "add (All)" },
		{ "<leader>gbb", "<CMD>G blame<CR>", desc = "blame" },
		{ "<leader>gaf", ":G add ", desc = "add (Manual)" },
		{ "<leader>gce", "<CMD>G commit --edit<CR>", desc = "commit (edit)" },
		{ "<leader>gca", "<CMD>G commit --amend<CR>", desc = "commit (amend)" },
		{ "<leader>gp", "<CMD>G pull --no-edit<CR>", desc = "pull (no-edit)" },
		{ "<leader>gr", "<CMD>G reset --hard HEAD<CR>", desc = "reset (--hard) HEAD" },
		{ "<leader>gP", "<CMD>G push --force-with-lease<CR>", desc = "push (force-with-lease)" },
		{ "<leader>gll", "<CMD>G log<CR>", desc = "log" },
	}

	for _, key in ipairs(keys) do
		vim.keymap.set("n", key[1], key[2], { desc = key.desc })
	end
end
