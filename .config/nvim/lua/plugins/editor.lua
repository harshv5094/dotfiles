return {
	-- NOTE: A undo history plugin, I love and never gonna delete it
	{
		"mbbill/undotree",
		event = "BufReadPre",
    -- stylua: ignore
		keys = {
			{ "<localleader>u", "<CMD>UndotreeToggle<CR>", desc = "Open undotree", },
		},
	},

	-- NOTE: My custom values for neovim
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
						prompt_title = "Find Files (lazy.nvim plugins)",
						cwd = require("lazy.core.config").options.root,
					})
				end,
				desc = "Telescope -> Find files (lazy.nvim)",
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
					},
				},
				sorting_strategy = "ascending",
				winblend = 0,
				mappings = {
					n = {
						["q"] = actions.close,
					},
				},
			})

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
