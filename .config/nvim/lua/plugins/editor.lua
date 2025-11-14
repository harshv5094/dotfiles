-- Default variables values for common options
-- local default_height = 20

return {
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
				";c",
				function()
					local builtin = require("telescope.builtin")
					builtin.lsp_incoming_calls()
				end,
				desc = "Telescope -> LSP incoming calls",
			},
			{
				";;",
				function()
					require("telescope.builtin").resume()
				end,
				desc = "Telescope -> Resume",
			},
			{
				";f",
				function()
					local builtin = require("telescope.builtin")
					builtin.find_files({
						no_ignore = false,
						follow = true,
						hidden = true,
					})
				end,
				desc = "Telescope -> Find Files",
			},
			{
				";b",
				function()
					local builtin = require("telescope.builtin")
					builtin.buffers()
				end,
				desc = "Telescope -> Buffers",
			},
			{
				";h",
				function()
					local builtin = require("telescope.builtin")
					builtin.help_tags()
				end,
				desc = "Telescope -> Help Tags",
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
						respect_gitignore = false,
						hidden = true,
						follow_symlinks = true,
						grouped = true,
						previewer = true,
						initial_mode = "normal",
						layout_config = {
							-- height = default_height,
						},
					})
				end,
				desc = "Telescope -> Browse File",
			},
			{
				";nn",
				function()
					require("utils.notes").create_note()
				end,
				desc = "Notes -> New Markdown Note",
			},
			{
				";nt",
				function()
					require("utils.notes").search_by_tag()
				end,
				desc = "Notes -> Search Notes by Tag",
			},
			{
				";nf",
				function()
					require("utils.notes").find_notes()
				end,
				desc = "Notes -> Find Notes",
			},
			{
				";ns",
				function()
					require("utils.notes").sync_to_remote()
				end,
				desc = "Notes -> Sync to My Remote Repos",
			},
		},
		config = function(_, opts)
			local telescope = require("telescope")
			local actions = require("telescope.actions")
			local fb_actions = require("telescope").extensions.file_browser.actions

			opts.defaults = vim.tbl_deep_extend("force", opts.defaults or {}, {
				wrap_results = true,
				layout_strategy = "horizontal",
				layout_config = {
					prompt_position = "top",
					-- height = default_height,
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
		event = "VeryLazy",
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
