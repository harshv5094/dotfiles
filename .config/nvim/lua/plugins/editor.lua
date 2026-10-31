local ok, plugin = pcall(require, "telescope")

if ok then
	local map = vim.keymap.set
	local builtin = require("telescope.builtin")
	local actions = require("telescope.actions")
	local themes = require("telescope.themes")
	local extensions = plugin.extensions
	local fb_actions = extensions.file_browser.actions

	-- Builtin keymaps
	map("n", "<leader>,", builtin.buffers, { desc = "Telescope: Switch Buffers" })
	map("n", "<leader>sa", builtin.help_tags, { desc = "Telescope: Autocmds" })
	map("n", "<leader>sb", builtin.current_buffer_fuzzy_find, { desc = "Telescope: Buffer Lines" })
	map("n", "<leader>sd", builtin.diagnostics, { desc = "Telescope: Diagnostics" })
	map("n", "<leader>sh", builtin.help_tags, { desc = "Telescope: Help Tags" })
	map("n", "<leader>sH", builtin.highlights, { desc = "Telescope: Search Highlights Group" })
	map("n", "<leader>sj", builtin.jumplist, { desc = "Telescope: Jumplist" })
	map("n", "<leader>sk", builtin.keymaps, { desc = "Telescope: Keymaps" })
	map("n", "<leader>sl", builtin.loclist, { desc = "Telescope: loclist" })
	map("n", "<leader>sm", builtin.man_pages, { desc = "Telescope: Man Pages" })
	map("n", "<leader>so", builtin.vim_options, { desc = "Telescope: Options" })
	map("n", "<leader>sO", builtin.oldfiles, { desc = "Telescope: Oldfiles" })
	map("n", "<leader>sq", builtin.quickfix, { desc = "Telescope: Quick Fix list" })
	map("n", "<leader>sr", builtin.resume, { desc = "Telescope: Resume" })
	map("n", "<leader>:", builtin.command_history, { desc = "Telescope: Command History" })
	map("n", "<leader>gst", builtin.git_status, { desc = "Telescope: Git Status" })

	map("n", "<leader><space>", function()
		builtin.find_files({
			hidden = true,
			respect_gitignore = false,
		})
	end, { desc = "Telescope: Find Files" })

	map("n", "<leader>/", function()
		builtin.live_grep({
			hidden = true,
			respect_gitignore = false,
		})
	end, { desc = "Telescope: Live Grep" })

	-- Keymap for searching lazy.nvim plugin directory
	map("n", "<leader>fP", function()
		builtin.find_files({
			prompt_title = "Find Files (vim.pack plugins)",
			cwd = vim.fn.stdpath("data") .. "/site/pack/core/opt/",
		})
	end, { desc = "Telescope: vim.pack plugins" })

	-- Colorscheme keymap
	map("n", "<leader>uC", function()
		builtin.colorscheme({ enable_preview = true })
	end, { desc = "Colorscheme" })

	-- Neovim Config file keymap
	map("n", "<leader>fc", function()
		require("telescope.builtin").find_files({
			prompt_title = "Neovim Config Files",
			cwd = vim.fn.stdpath("config"),
		})
	end, { desc = "Telescope: Config Files" })

	-- Telescope file browser
	map("n", "sf", function()
		extensions.file_browser.file_browser({
			path = "%:p:h",
			cwd = vim.fn.expand("%:p:h"), -- It just opens based on cwd
			respect_gitignore = false,
			hidden = true,
			follow_symlinks = true,
			grouped = true,
			previewer = true,
			initial_mode = "normal",
		})
	end, { desc = "File Browser" })

	plugin.setup({
		defaults = {
			vimgrep_arguments = {
				"rg",
				"--color=never",
				"--no-heading",
				"--with-filename",
				"--line-number",
				"--column",
				"--smart-case",
				"--hidden",
				"--glob=!.git/",
			},
			file_ignore_patterns = {
				"%.git/",
				"node_modules",
				-- "%.git$",
			},
			wrap_results = true,
			layout_stategy = "horizontal",
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
		},
		extensions = {
			fzf = {
				fuzzy = true, -- false will only do exact matching
				override_generic_sorter = true, -- override the generic sorter
				override_file_sorter = true, -- override the file sorter
				case_mode = "smart_case", -- or "ignore_case" or "respect_case"
			},
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
			frecency = {
				show_filter_column = true,
			},
			["ui-select"] = themes.get_dropdown({}),
		},
	})

	plugin.load_extension("fzf")
	plugin.load_extension("file_browser")
	plugin.load_extension("ui-select")
end

ok, _ = pcall(require, "close_buffers")

if ok then
	local keys = {
		{
			"<leader>bh",
			function()
				require("close_buffers").delete({ type = "hidden" })
			end,
			desc = "Close Hidden Buffers",
		},
		{
			"<leader>bd",
			function()
				require("close_buffers").delete({ type = "this" })
			end,
			desc = "Close Current Buffer",
		},
		{
			"<leader>bu",
			function()
				require("close_buffers").delete({ type = "nameless" })
			end,
			desc = "Close Nameless Buffers",
		},
	}

	for _, key in ipairs(keys) do
		vim.keymap.set("n", key[1], key[2], { desc = key.desc })
	end
end

ok, plugin = pcall(require, "grug-far")

if ok then
	vim.keymap.set({ "n", "x" }, "<leader>sr", function()
		local grug = require("grug-far")
		local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
		grug.open({
			transient = true,
			prefills = {
				filesFilter = ext and ext ~= "" and "*." .. ext or nil,
			},
		})
	end, { desc = "Search and Replace (Global)" })
end

local path_check = vim.fn.isdirectory(vim.fn.stdpath("data") .. "/site/pack/core/opt/undotree/")

if path_check then
	vim.keymap.set("n", "<leader>fu", function()
		vim.cmd("UndotreeToggle")
		vim.cmd("UndotreeFocus")
	end, { desc = "Undotree Toggle" })
end

ok, plugin = pcall(require, "persistence")

if ok then
	-- HACK: Automatically delete oil.nvim buffer from the list just when you save any session
	vim.api.nvim_create_autocmd("User", {
		pattern = "PersistenceSavePre",
		callback = function()
			for _, buf in ipairs(vim.api.nvim_list_bufs()) do
				if vim.bo[buf].filetype == "oil" then
					vim.api.nvim_buf_delete(buf, { force = true })
				end
			end
		end,
	})

  -- stylua: ignore
  local keys = {
    { "<leader>qs", function() require("persistence").load() end, desc = "Restore Session" },
    { "<leader>qS", function() require("persistence").select() end,desc = "Select Session" },
    { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore Last Session" },
    { "<leader>qd", function() require("persistence").stop() end, desc = "Don't Save Current Session" },
  }

	for _, key in ipairs(keys) do
		vim.keymap.set("n", key[1], key[2], { desc = key.desc })
	end

	plugin.setup()
end

ok, plugin = pcall(require, "oil")

if ok then
	plugin.setup({
		default_file_explorer = true, -- Set oil.nvim as the default file explorer
		-- Oil will automatically delete hidden buffers after this delay
		cleanup_delay_ms = 3000,
		lsp_file_methods = {
			-- Enable or disable LSP file operations
			enabled = true,
			-- Time to wait for LSP file operations to complete before skipping
			timeout_ms = 1000,
			-- Set to true to autosave buffers that are updated with LSP willRenameFiles
			-- Set to "unmodified" to only save unmodified buffers
			autosave_changes = false,
		},
		-- Send deleted files to the trash instead of permanently deleting them (:help oil-trash)
		delete_to_trash = true,
		view_options = {
			show_hidden = true,
		},
		columns = {
			-- "permissions",
			-- "size",
			-- "mtime",
			"icon",
		},
	})
	vim.keymap.set("n", "<leader>e", "<CMD>Oil<CR>", { noremap = true, silent = true })
end
