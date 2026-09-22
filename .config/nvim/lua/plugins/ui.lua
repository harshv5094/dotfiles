return {

	-- Ui Search
	{
		"folke/flash.nvim",
		enabled = false,
	},

	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts_extend = { "spec" },
		opts = {
			preset = "helix",
			defaults = {},
			spec = {
				{
					mode = { "n", "x" },
					{ "<leader><tab>", group = "tabs" },
					{ "<leader>c", group = "code" },
					{ "<leader>d", group = "debug" },
					{ "<leader>dp", group = "profiler" },
					{ "<leader>f", group = "file/find" },
					{ "<leader>g", group = "git" },
					{ "<localleader>g", group = "git" },
					{ "<localleader>s", group = "find/replace" },
					{ "<localleader>gc", group = "commit" },
					{ "<localleader>gs", group = "status" },
					{ "<localleader>ga", group = "add" },
					{ "<localleader>t", group = "telescope" },
					{ "<leader>gh", group = "hunks" },
					{ "<leader>q", group = "quit/session" },
					{ "<leader>s", group = "search" },
					{ "<leader>u", group = "ui" },
					{ "<leader>x", group = "diagnostics/quickfix" },
					{ "[", group = "prev" },
					{ "]", group = "next" },
					{ "g", group = "goto" },
					{ "gs", group = "surround" },
					{ "z", group = "fold" },
					{
						"<leader>b",
						group = "buffer",
						expand = function()
							return require("which-key.extras").expand.buf()
						end,
					},
					{
						"<leader>w",
						group = "windows",
						proxy = "<c-w>",
						expand = function()
							return require("which-key.extras").expand.win()
						end,
					},
					-- better descriptions
					{ "gx", desc = "Open with system app" },
				},
			},
		},
		keys = {
			{
				"<leader>?",
				function()
					require("which-key").show({ global = false })
				end,
				desc = "Buffer Keymaps (which-key)",
			},
			{
				"<c-w><space>",
				function()
					require("which-key").show({ keys = "<c-w>", loop = true })
				end,
				desc = "Window Hydra Mode (which-key)",
			},
		},
		config = function(_, opts)
			local wk = require("which-key")
			wk.setup(opts)
			if not vim.tbl_isempty(opts.defaults) then
				LazyVim.warn("which-key: opts.defaults is deprecated. Please use opts.spec instead.")
				wk.register(opts.defaults)
			end
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
}
