-- List of mini plugins that I want to load with default settings
local mini_plugins = {
	"mini.starter",
	"mini.pairs",
	"mini.indentscope",
	"mini.icons",
	"mini.bracketed",
}

-- HACK: A loop for just loading mini plugins with their default settings.
-- It just saves me some repetitive writing.
for _, mini_plugin in ipairs(mini_plugins) do
	if pcall(require, mini_plugin) then
		require(mini_plugin).setup()
	end
end

if pcall(require, "mini.files") then
	require("mini.files").setup({
		options = {
			use_as_default_explorer = true,
		},
		-- windows = {
		-- 	preview = true,
		-- 	width_preview = 40,
		-- },
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

if pcall(require, "mini.git") then
	-- stylua: ignore
	local keys = {
		{ "<leader>gss", "<CMD>Git status<CR>", desc = "Git status" },
		{ "<leader>gsq", "<CMD>Git status --short<CR>", desc = "Git status (short)" },
		{ "<leader>gab", "<CMD>Git add %<CR>", desc = "Git add (Current Buffer)" },
		{ "<leader>gaa", "<CMD>Git add *<CR>", desc = "Git add (All)" },
		{ "<leader>gaf", ":Git add ", desc = "Git add (Manual)" },
		{ "<leader>gce", "<CMD>Git commit --edit<CR>", desc = "Git commit (edit)" },
		{ "<leader>gca", "<CMD>Git commit --amend<CR>", desc = "Git commit (amend)" },
		{ "<leader>gp", "<CMD>Git pull --no-edit<CR>", desc = "Git pull (no-edit)" },
		{ "<leader>gr", "<CMD>Git reset --hard HEAD<CR>", desc = "Git reset (--hard) HEAD" },
		{ "<leader>gP", "<CMD>Git push --force-with-lease<CR>", desc = "Git push (force-with-lease)" },
		{ "<leader>gll", "<CMD>Git log<CR>", desc = "Git log" },
	}

	for _, key in ipairs(keys) do
		vim.keymap.set("n", key[1], key[2], { desc = key.desc })
	end
	require("mini.git").setup()
end
