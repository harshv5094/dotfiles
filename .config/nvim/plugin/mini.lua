-- List of mini plugins that I want to load with default settings
local mini_plugins = {
	"mini.starter",
	"mini.pairs",
	"mini.indentscope",
	"mini.icons",
	"mini.bracketed",
	"mini.jump2d",
}

-- HACK: A loop for just loading mini plugins with their default settings.
-- It just saves me some repetitive writing.
for _, mini_plugin in ipairs(mini_plugins) do
	if pcall(require, mini_plugin) then
		require(mini_plugin).setup()
	end
end

-- Let plugins that only integrate with nvim-web-devicons use mini.icons instead
if _G.MiniIcons then
	MiniIcons.mock_nvim_web_devicons()
end

if pcall(require, "mini.files") then
	require("mini.files").setup({
		options = {
			use_as_default_explorer = true,
			permanent_delete = false,
			lsp_timeout = 500,
		},
		mappings = {
			close = "q",
			go_in = "L",
			go_in_plus = "l",
			go_out = "H",
			go_out_plus = "h",
			mark_goto = "'",
			mark_set = "m",
			reset = "<BS>",
			reveal_cwd = "@",
			show_help = "g?",
			synchronize = "<CR>",
			trim_left = "<",
			trim_right = ">",
		},
	})

	-- Center the explorer horizontally and pin it to the top
	vim.api.nvim_create_autocmd("User", {
		pattern = "MiniFilesWindowUpdate",
		callback = function()
			local state = MiniFiles.get_explorer_state()
			if state == nil then
				return
			end

			-- Collect open explorer windows and their total outer width (inner + 2 for borders)
			local wins, total = {}, 0
			for _, w in ipairs(state.windows) do
				if vim.api.nvim_win_is_valid(w.win_id) then
					table.insert(wins, w.win_id)
					total = total + vim.api.nvim_win_get_width(w.win_id) + 2
				end
			end
			if #wins == 0 then
				return
			end

			-- Lay them out left to right, starting so the group is centered
			local col = math.floor((vim.o.columns - total) / 2)
			for _, win_id in ipairs(wins) do
				local config = vim.api.nvim_win_get_config(win_id)
				config.relative = "editor"
				config.row = 1 -- just below the top edge (tabline/border space)
				config.col = col
				config.border = "rounded"
				vim.api.nvim_win_set_config(win_id, config)
				col = col + vim.api.nvim_win_get_width(win_id) + 2
			end
		end,
	})

	local minifiles_toggle = function(...)
		if MiniFiles.close() == nil then
			MiniFiles.open(...)
		end
	end

	vim.keymap.set("n", "<leader>e", function()
		minifiles_toggle()
	end, { desc = "Toggle file explorer" })
end

if pcall(require, "mini.diff") then
	require("mini.diff").setup({
		view = {
			style = "sign",
			priority = 5, -- default is 199; breakpoints use 10
		},
	})
end

if pcall(require, "mini.notify") then
	require("mini.notify").setup({
		lsp_progress = {
			enable = false,
		},
	})
	vim.keymap.set("n", "<leader>n", function()
		MiniNotify.show_history()
	end, { desc = "Notification History" })
end
