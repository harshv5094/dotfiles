-- Just declaring local variables openly
local ok, plugin

-- A plugin to close buffers based on scenario
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

-- A global search and replace plugin
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

-- A tree view of undo file
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
				if vim.bo[buf].filetype == "oil://*" then
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

-- The file manager which uses neovim buffer, just like a file
ok, plugin = pcall(require, "oil")

if ok then
	plugin.setup({
		default_file_explorer = true,
		cleanup_delay_ms = 3000,
		lsp_file_methods = {
			enabled = true,
			timeout_ms = 1000,
			autosave_changes = false,
		},
		watch_for_changes = true,
		delete_to_trash = true,
		view_options = {
			show_hidden = true,
		},
		columns = {
			"permissions",
			"size",
			"mtime",
			"icon",
		},
	})
	vim.keymap.set("n", "<leader>e", "<CMD>Oil<CR>", { noremap = true, silent = true })
end
