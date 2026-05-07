return {
	{
		"mbbill/undotree",
		event = "BufReadPre",
		keys = {
			{
				"<localleader>u",
				"<CMD>UndotreeToggle<CR>",
				{ desc = "Undotree Toggle" },
			},
		},
	},
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
			},
			"nvim-telescope/telescope-file-browser.nvim",
		},
		keys = {
			{
				"<leader>fP",
				function()
					require("telescope.builtin").find_files({
						cwd = require("lazy.core.config").options.root,
					})
				end,
				desc = "Telescope -> Find files from Lazy config root",
			},
			{
				"<localleader>tc",
				function()
					local builtin = require("telescope.builtin")
					builtin.lsp_incoming_calls()
				end,
				desc = "Telescope -> LSP incoming calls",
			},
			{
				"<localleader>tr",
				function()
					require("telescope.builtin").resume()
				end,
				desc = "Telescope -> Resume",
			},
			{
				"sf",
				function()
					local telescope = require("telescope")
					local function telescope_buffer_dir()
						return vim.fn.expand("%:p:h")
					end

					telescope.extensions.file_browser.file_browser({
						path = "%:p:h",
						cwd = telescope_buffer_dir(),
						respect_gitignore = true,
						hidden = true,
						follow_symlinks = true,
						grouped = true,
						previewer = true,
						initial_mode = "normal",
						-- layout_config = {
						-- 	height = 0.60,
						-- },
					})
				end,
				desc = "Telescope -> Browse File",
			},
		},
		config = function(_, opts)
			local telescope = require("telescope")
			local actions = require("telescope.actions")
			local fb_actions = require("telescope").extensions.file_browser.actions

			opts.defaults = vim.tbl_deep_extend("force", opts.defaults or {}, {
				file_ignore_patterns = {
					"%.git/",
					"node_modules",
					-- "%.git$",
				},
				wrap_results = true,
				layout_strategy = "horizontal",
				layout_config = {
					horizontal = {
						prompt_position = "top",
						previewer_width = 0.55,
					},
					width = 0.87,
					height = 0.80,
				},
				sorting_strategy = "ascending",
				winblend = 0,
				mappings = {
					n = {
						["q"] = actions.close,
					},
				},
			})

			-- TODO: Find a permanent way to set default theme for picker

			-- local custom_style = {
			-- 	theme = "ivy",
			-- 	layout_config = { height = 0.60 },
			-- }
			--
			-- opts.pickers = {
			-- 	diagnostics = vim.tbl_extend("force", custom_style, {
			-- 		layout_config = { preview_cutoff = 9999 },
			-- 	}),
			-- 	buffers = custom_style,
			-- 	find_files = custom_style,
			-- 	live_grep = custom_style,
			-- 	keymaps = custom_style,
			-- 	help_tags = custom_style,
			-- 	command_history = custom_style,
			-- 	colorscheme = custom_style,
			-- 	git_status = custom_style,
			-- 	man_pages = custom_style,
			-- }
			--
			opts.extensions = {
				file_browser = {
					-- theme = "ivy",
					-- disables netrw and use telescope-file-browser in its place
					hijack_netrw = false,
					mappings = {
						-- your custom insert mode mappings
						["n"] = {
							-- your custom normal mode mappings
							["N"] = fb_actions.create,
							["h"] = fb_actions.goto_parent_dir,
							["q"] = actions.close,
							["H"] = fb_actions.toggle_hidden,
							["/"] = function()
								vim.cmd("startinsert")
							end,
							["<C-u>"] = function(prompt_bufnr)
								for i = 1, 10 do
									actions.move_selection_previous(prompt_bufnr)
								end
							end,
							["<C-d>"] = function(prompt_bufnr)
								for i = 1, 10 do
									actions.move_selection_next(prompt_bufnr)
								end
							end,
							["<PageUp>"] = actions.preview_scrolling_up,
							["<PageDown>"] = actions.preview_scrolling_down,
						},
					},
				},
			}
			telescope.setup(opts)
			require("telescope").load_extension("fzf")
			require("telescope").load_extension("file_browser")
		end,
	},

	-- Multiple close buffer plugin
	{
		"kazhala/close-buffers.nvim",
		event = "BufReadPre",
		keys = {
			{
				"<leader>bh",
				function()
					require("close_buffers").delete({ type = "hidden" })
				end,
				desc = "Close Hidden Buffers",
			},
			{
				"<leader>bu",
				function()
					require("close_buffers").delete({ type = "nameless" })
				end,
				desc = "Close Nameless Buffers",
			},
		},
	},
}
