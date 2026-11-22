if pcall(require, "close_buffers") then
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

if pcall(require, "grug-far") then
	vim.keymap.set({ "n", "x" }, "<leader>sr", function()
		local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
		require("grug-far").open({
			transient = true,
			prefills = {
				filesFilter = ext and ext ~= "" and "*." .. ext or nil,
			},
		})
	end, { desc = "Search and Replace (Global)" })
end

-- A tree view of undo file
if require("tools").vim_plugin_path_checker("undotree") then
	vim.keymap.set("n", "<leader>fu", function()
		vim.cmd("UndotreeToggle")
		vim.cmd("UndotreeFocus")
	end, { desc = "Undotree Toggle" })
end

if pcall(require, "persistence") then
	-- stylua: ignore
	local keys = {
		{ "<leader>qs", function() require("persistence").load() end, desc = "Restore Session" },
		{ "<leader>qS", function() require("persistence").select() end, desc = "Select Session" },
		{ "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore Last Session" },
		{ "<leader>qd", function() require("persistence").stop() end, desc = "Don't Save Current Session" },
	}

	for _, key in ipairs(keys) do
		vim.keymap.set("n", key[1], key[2], { desc = key.desc })
	end

	require("persistence").setup()
end
