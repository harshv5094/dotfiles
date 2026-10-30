local ok, plugin = pcall(require, "lazydev")

if ok then
	plugin.setup({
		library = {
			{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
		},
	})
end

ok, plugin = pcall(require, "blink.cmp")

if ok then
	---@module 'blink.cmp'
	---@type blink.cmp.Config
	plugin.setup({
		keymap = {
			preset = "default",
			["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
			["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
			["<CR>"] = { "accept", "fallback" },
		},
		appearance = {
			nerd_font_variant = "mono",
			kind_icons = my_utils.icons.kinds,
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
						return vim.tbl_contains({ "gitcommit", "markdown" }, vim.o.filetype)
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

ok, plugin = pcall(require, "mason")

if ok then
	---@type MasonSettings
	plugin.setup({
		ui = {
			icons = {
				package_installed = "✓",
				package_pending = "➜",
				package_uninstalled = "✗",
			},
		},
	})

	vim.keymap.set("n", "<leader>cm", "<CMD>Mason<CR>", { desc = "Mason" })

	-- A custom hook to add Mason
	vim.api.nvim_create_autocmd("PackChanged", {
		desc = "Mason Command",
		callback = function(ev)
			local name, kind = ev.data.spec.name, ev.data.kind
			if name == "mason.nvim" and (kind == "install" or kind == "update") then
				vim.cmd("Mason")
			end
		end,
	})
end

ok, plugin = pcall(require, "mason-tool-installer")

if ok then
	---@type MasonToolInstallerSettings
	plugin.setup({
		ensure_installed = {
			-- Installed first: required by nvim-treesitter to
			-- compile/install parsers (see plugins/treesitter.lua).
			{ "tree-sitter-cli", auto_update = true },

			-- LSP servers
			"lua-language-server",
			"bash-language-server",
			"yaml-language-server",
			"json-lsp",
			"taplo",

			-- Formatters / linters
			"stylua",
			"shellcheck",
			"shfmt",
			"luacheck",
		},
	})
end
