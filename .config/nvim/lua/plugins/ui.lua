return {

	-- Ui Search
	{
		"folke/flash.nvim",
		enabled = false,
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
		event = "VeryLazy",
		config = function()
			local incline = require("incline")
			incline.setup({
				debounce_threshold = {
					falling = 50,
					rising = 10,
				},
				hide = {
					cursorline = "smart",
					focused_win = false,
					only_win = false,
				},
				window = { padding = 0, margin = { vertical = 0, horizontal = 0 } },
				render = function(props)
					local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
					local modified = vim.bo[props.buf].modified

					-- No Name for unsaved file
					if filename == "" then
						filename = "[No Name]"
					end

					-- Adding plus sign for unsaved file
					if modified then
						filename = "[+] " .. filename
					end

					-- Determine styling: Bold only if focused
					-- Keeps italic if modified, regardless of focus
					local style = ""
					if props.focused then
						style = modified and "bold,italic" or "bold"
					else
						style = modified and "italic" or "none"
					end

					local design = {
						{ " " },
						{ filename, gui = style },
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
			opts.options.component_separators = { left = "|", right = "|" }
			opts.options.section_separators = { left = "", right = "" }
			opts.sections.lualine_a = { { "mode", icon = "" } }
			opts.sections.lualine_y = { { "progress" } }
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
