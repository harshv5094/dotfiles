return {

	-- Ui Search
	{
		"folke/flash.nvim",
		enabled = false,
	},

	-- Noice UI
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		opts = function(_, opts)
			table.insert(opts.routes, {
				filter = {
					event = "notify",
					find = "No information available",
				},
				opts = { skip = true },
			})
			local focused = true
			vim.api.nvim_create_autocmd("FocusGained", {
				callback = function()
					focused = true
				end,
			})
			vim.api.nvim_create_autocmd("FocusLost", {
				callback = function()
					focused = false
				end,
			})
			table.insert(opts.routes, 1, {
				filter = {
					cond = function()
						return not focused
					end,
				},
				view = "notify_send",
				opts = { stop = false },
			})

			opts.commands = {
				all = {
					-- options for the message history that you get with `:Noice`
					view = "split",
					opts = { enter = true, format = "details" },
					filter = {},
				},
			}

			vim.api.nvim_create_autocmd("FileType", {
				pattern = "markdown",
				callback = function(event)
					vim.schedule(function()
						require("noice.text.markdown").keys(event.buf)
					end)
				end,
			})

			opts.presets.lsp_doc_border = true
		end,
	},

	-- Highlight Color
	{
		"brenoprata10/nvim-highlight-colors",
		event = "BufReadPre",
		opts = function()
			local colors = require("nvim-highlight-colors")
			local opts = colors.setup({
				render = "virtual",
				virtual_symbol = "■",
				virtual_symbol_prefix = "",
				virtual_symbol_suffix = " ",
				virtual_symbol_position = "inline",
				enable_tailwind = true,
				enable_hex = true,
				enable_rgb = true,
				enable_var_usage = true,
				enable_named_colors = true,
			})
			return opts
		end,
	},

	-- Tab Line
	{
		"akinsho/bufferline.nvim",
		event = "VeryLazy",
		keys = {
			{ "<Tab>", "<Cmd>BufferLineCycleNext<CR>", desc = "Next tab" },
			{ "<S-Tab>", "<Cmd>BufferLineCyclePrev<CR>", desc = "Prev tab" },
		},
		opts = {
			options = {
				mode = "tabs",
			},
		},
	},

	-- File Title
	{
		"b0o/incline.nvim",
		event = "BufReadPre",
		priority = 1200,
		config = function()
			-- local colors = require("tokyonight.colors").setup()
			local colors = require("gruvbox").palette
			local incline = require("incline")
			local devicons = require("nvim-web-devicons")
			local helpers = require("incline.helpers")
			incline.setup({
				highlight = {
					groups = {
						InclineNormal = { guibg = colors.light0, guifg = colors.dark0 },
						InclineNormalNC = { guibg = colors.dark0, guifg = colors.light0 },
					},
				},
				window = { padding = 0, margin = { vertical = 0, horizontal = 0 } },
				hide = {
					cursorline = true,
				},
				render = function(props)
					local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
					local icon, color = devicons.get_icon_color(filename)
					local modified = vim.bo[props.buf].modified

					-- No Name for unsaved file
					if filename == "" then
						filename = "[No Name]"
					end

					-- Adding plus sign for unsaved file
					if modified then
						filename = "[+] " .. filename
					end

					local design = {
						icon and { " ", icon, " ", guifg = color, guibg = helpers.contrast_color(color) or " " },
						{ " " },
						{ filename, gui = modified and "bold,italic" or "bold" },
						{ " " },
					}

					return design
				end,
			})
		end,
	},

	-- Statusline
	{
		"nvim-lualine/lualine.nvim",
		opts = function(_, opts)
			opts.sections.lualine_a = { { "mode", icon = "" } }
			opts.sections.lualine_z = {
				function()
					return " " .. os.date("%I:%M %p")
				end,
			}
		end,
	},

	-- Turning of markdown rendering
	{
		"MeanderingProgrammer/render-markdown.nvim",
		enabled = false,
	},
}
